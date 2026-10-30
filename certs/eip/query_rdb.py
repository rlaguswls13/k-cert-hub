import os
import sqlite3
import argparse

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'eip_exam.db')

def get_conn():
    return sqlite3.connect(DB_PATH)

def show_analytics():
    conn = get_conn()
    cur = conn.cursor()
    print("=" * 105)
    print(f"{'구분(Cat2)':<8} | {'세부유형(Cat1)':<20} | {'문항수':>5} | {'비중':>5} | {'등장회차':>6} | {'평균주기':>6} | {'미출제':>5} | {'임박도':>5} | {'주요 출제방식'}")
    print("-" * 105)
    for r in cur.execute("""
        SELECT major_name, minor_name, total_questions, share_pct, round_appearances,
               avg_interval, rounds_since_last, imminence_index, primary_format
        FROM category_analytics
        ORDER BY total_questions DESC
    """):
        print(f"{r[0]:<10} | {r[1]:<20} | {r[2]:>4}개 | {r[3]:>4.1f}% | {r[4]:>5}회 | {r[5]:>5.2f}회 | {r[6]:>4}회 | {r[7]:>5.2f} | {r[8]}")
    print("=" * 105)
    conn.close()

def query_questions(round_title=None, cat1=None, cat2=None, mode='exam', limit=20):
    conn = get_conn()
    cur = conn.cursor()
    
    view_map = {
        'exam': 'v_mode_exam',
        'compare': 'v_mode_compare',
        'explain': 'v_mode_explanation'
    }
    view_name = view_map.get(mode, 'v_mode_exam')
    
    where_clauses = []
    params = []
    if round_title:
        where_clauses.append("round_title LIKE ?")
        params.append(f"%{round_title}%")
    if cat1:
        where_clauses.append("category1_type LIKE ?")
        params.append(f"%{cat1}%")
    if cat2:
        where_clauses.append("category2_domain LIKE ?")
        params.append(f"%{cat2}%")
        
    where_sql = ("WHERE " + " AND ".join(where_clauses)) if where_clauses else ""
    sql = f"SELECT * FROM {view_name} {where_sql} ORDER BY question_id ASC LIMIT ?"
    params.append(limit)
    
    rows = cur.execute(sql, params).fetchall()
    mode_label = {'exam': '시험모드 (문제만)', 'compare': '비교모드 (문제+답)', 'explain': '해설모드 (문제+답+해설)'}[mode]
    
    print(f"\n[조회 모드: {mode_label}] (총 {len(rows)}건 출력)")
    print("=" * 80)
    for r in rows:
        q_id, r_title, q_num, c2, c1, q_fmt, header, body, code, lang = r[:10]
        print(f"#[ID:{q_id:03d}] [{r_title} {q_num}번] [{c2} > {c1}] ({q_fmt})")
        print(f"Q. {header}")
        if body:
            print(f"{body}")
        if code:
            print("-" * 40 + f" [{lang.upper() or 'CODE'}]")
            print(code)
            print("-" * 40)
        if mode in ('compare', 'explain'):
            print(f"\n👉 [정답]: {r[10]}")
        if mode == 'explain':
            print(f"💡 [해설]:\n{r[11]}")
        print("=" * 80)
    conn.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='정보처리기사 실기 RDB 조회 및 학습 모드 CLI')
    parser.add_argument('--analytics', action='store_true', help='유형별 출제빈도/출제간격/출제방식 분석표 출력')
    parser.add_argument('--round', type=str, help='회차별 필터 (예: "2024년 1회")')
    parser.add_argument('--cat1', type=str, help='카테고리1(세부유형) 필터 (예: "디자인 패턴", "Java")')
    parser.add_argument('--cat2', type=str, help='카테고리2(이론/코드) 필터 (예: "이론", "코드")')
    parser.add_argument('--mode', type=str, choices=['exam', 'compare', 'explain'], default='compare',
                        help='출력 모드: exam(시험모드:문제만), compare(비교모드:문제+답), explain(해설모드:문제+답+해설)')
    parser.add_argument('--limit', type=int, default=20, help='최대 출력 문항 수')
    args = parser.parse_args()
    
    if args.analytics:
        show_analytics()
    else:
        query_questions(args.round, args.cat1, args.cat2, args.mode, args.limit)
