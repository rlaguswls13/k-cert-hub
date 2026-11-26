import os
import sqlite3
import argparse

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'isec_exam.db')


def get_conn():
    return sqlite3.connect(DB_PATH)


def show_analytics():
    conn = get_conn()
    cur = conn.cursor()
    print("=" * 112)
    print(f"{'도메인(5대 과목)':<24} | {'문항수':>4} | {'비중':>5} | {'단답':>4} | {'서술':>4} | {'실무':>4} | {'등장회차':>5} | {'평균주기':>5} | {'임박도':>4} | {'주력 유형'}")
    print("-" * 112)
    for r in cur.execute("""
        SELECT domain_name, total_questions, share_pct, short_count, essay_count, practical_count,
               round_appearances, avg_interval, imminence_index, primary_qtype
        FROM domain_analytics
        ORDER BY total_questions DESC
    """):
        print(f"{r[0]:<24} | {r[1]:>3}개 | {r[2]:>4.1f}% | {r[3]:>3}개 | {r[4]:>3}개 | {r[5]:>3}개 | {r[6]:>4}회 | {r[7]:>4.2f}회 | {r[8]:>4.2f} | {r[9]}")
    print("=" * 112)
    conn.close()


def query_questions(round_id=None, qtype_id=None, domain=None, mode='exam', limit=10):
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
    if qtype_id:
        where.append("qtype_id = ?")
        params.append(int(qtype_id))
    if domain:
        where.append("domain_name LIKE ?")
        params.append(f"%{domain}%")
    where_sql = ("WHERE " + " AND ".join(where)) if where else ""
    sql = f"SELECT * FROM {view_name} {where_sql} ORDER BY round_id DESC, question_no ASC LIMIT ?"
    params.append(limit)
    rows = cur.execute(sql, params).fetchall()
    cols = [d[0] for d in cur.description]
    print(f"\n[조회 모드: {mode.upper()} ({view_name}) | 조회 건수: {len(rows)}건]")
    for row in rows:
        rec = dict(zip(cols, row))
        print("-" * 95)
        print(f"[{rec['round_title']} #{rec['question_no']} | {rec['qtype_name']}] ({rec['domain_name']})")
        print(f"Q. {rec['title']}")
        print(f"   {rec['question_text']}")
        if rec.get('code_or_log'):
            print(f"\n[제시 로그/설정]\n{rec['code_or_log']}")
        if 'answer_text' in rec:
            print(f"\n[모범 정답]\n{rec['answer_text']}")
            print(f"[핵심 키워드] {rec['core_keywords']}")
        if 'explanation' in rec:
            print(f"[상세 해설]   {rec['explanation']}")
            print(f"[출제 계보]   {rec['escalation_note']}")
        if rec.get('source'):
            print(f"[출처 구분]   {rec['source']}")
    conn.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="정보보안기사 실기 기출 RDB 조회 CLI")
    parser.add_argument('--analytics', action='store_true', help='5대 도메인별 출제빈도·주기·임박도 분석 출력')
    parser.add_argument('--mode', choices=['exam', 'compare', 'explain'], default='exam', help='학습 모드 선택')
    parser.add_argument('--round', type=int, help='회차 필터 (10~26)')
    parser.add_argument('--qtype', type=int, help='유형 필터 (1:단답, 2:서술, 3:실무)')
    parser.add_argument('--domain', type=str, help='도메인 검색어 (예: 시스템, 네트워크, 앱, 법규)')
    parser.add_argument('--limit', type=int, default=10, help='최대 출력 건수')
    args = parser.parse_args()
    if args.analytics:
        show_analytics()
    else:
        query_questions(args.round, args.qtype, args.domain, args.mode, args.limit)
