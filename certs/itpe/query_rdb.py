import os
import json
import sqlite3
import argparse

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'itpe_exam.db')

def get_conn():
    return sqlite3.connect(DB_PATH)

def show_analytics():
    conn = get_conn()
    cur = conn.cursor()
    print("=" * 115)
    print(f"{'도메인(카테고리1)':<32} | {'문항수':>4} | {'비중':>5} | {'1교시':>4} | {'2~4교시':>5} | {'등장회차':>5} | {'평균주기':>5} | {'임박도':>4} | {'주요 출제방식'}")
    print("-" * 115)
    for r in cur.execute("""
        SELECT domain_name, total_questions, share_pct, p1_count, p234_count,
               round_appearances, avg_interval, imminence_index, primary_format
        FROM domain_analytics
        ORDER BY total_questions DESC
    """):
        print(f"{r[0]:<32} | {r[1]:>3}개 | {r[2]:>4.1f}% | {r[3]:>3}개 | {r[4]:>4}개 | {r[5]:>4}회 | {r[6]:>4.2f}회 | {r[7]:>4.2f} | {r[8]}")
    print("=" * 115)
    conn.close()

def query_questions(round_id=None, period_id=None, domain=None, mode='exam', limit=10):
    conn = get_conn()
    cur = conn.cursor()
    view_map = {
        'exam': 'v_mode_exam',
        'compare': 'v_mode_compare',
        'explain': 'v_mode_explanation'
    }
    view_name = view_map.get(mode, 'v_mode_exam')
    where, params = [], []
    if round_id:
        where.append("round_id = ?")
        params.append(int(round_id))
    if period_id:
        where.append("period_id = ?")
        params.append(int(period_id))
    if domain:
        where.append("domain_name LIKE ?")
        params.append(f"%{domain}%")
    where_sql = ("WHERE " + " AND ".join(where)) if where else ""
    sql = f"SELECT * FROM {view_name} {where_sql} ORDER BY round_id DESC, period_id ASC, question_no ASC LIMIT ?"
    params.append(limit)
    rows = cur.execute(sql, params).fetchall()
    cols = [d[0] for d in cur.description]
    print(f"\n[조회 모드: {mode.upper()} ({view_name}) | 조회 건수: {len(rows)}건]")
    for row in rows:
        rec = dict(zip(cols, row))
        print("-" * 95)
        print(f"[{rec['round_title']} | {rec['period_name']} #{rec['question_no']}] ({rec['domain_name']} / {rec['question_format']})")
        print(f"Q. {rec['question_header']}")
        for sp in json.loads(rec['sub_prompts_json']):
            print(f"   - {sp}")
        if 'standard_outline_json' in rec:
            print(f"\n[모범 4단 목차] {' -> '.join(json.loads(rec['standard_outline_json']))}")
            print(f"[필수 키워드]   {rec['core_keywords']}")
        if 'model_answer_text' in rec:
            print(f"[서브노트 해설] {rec['model_answer_text']}")
            print(f"[출제 계보]     {rec['escalation_note']}")
    conn.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="정보관리기술사 기출 RDB 조회 CLI")
    parser.add_argument('--analytics', action='store_true', help='8대 도메인별 출제빈도·주기·임박도 분석 출력')
    parser.add_argument('--mode', choices=['exam', 'compare', 'explain'], default='exam', help='학습 모드 선택')
    parser.add_argument('--round', type=int, help='회차 필터 (예: 140)')
    parser.add_argument('--period', type=int, help='교시 필터 (1~4)')
    parser.add_argument('--domain', type=str, help='도메인 검색어 (예: AI, 보안, DB)')
    parser.add_argument('--limit', type=int, default=10, help='최대 출력 건수')
    args = parser.parse_args()
    if args.analytics:
        show_analytics()
    else:
        query_questions(args.round, args.period, args.domain, args.mode, args.limit)
