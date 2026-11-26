import os
import json
import sqlite3
from collections import Counter

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(PROJECT_DIR, "data")
os.makedirs(DATA_DIR, exist_ok=True)

SEED_PATH = os.path.join(DATA_DIR, "saa_c03_seed.json")
DB_PATH = os.path.join(DATA_DIR, "saa_c03_exam.db")
SQL_DUMP_PATH = os.path.join(DATA_DIR, "schema_and_data.sql")
JSON_EXPORT_PATH = os.path.join(DATA_DIR, "saa_c03_rdb_export.json")

CERT_META = {
    "cert_id": "aws-saa-c03",
    "exam_code": "SAA-C03",
    "title": "AWS Certified Solutions Architect - Associate (SAA-C03) RDB",
    "level": "Associate",
    "cert_group": "AWS 클라우드 자격",
    "exam_stage": "필기",
    "passing_score": "720",
    "score_scale": "100-1000",
    "exam_question_count": "65",
    "exam_duration_minutes": "130",
    "updated_at": "2026-11-26",
}

EXAM_ROUNDS = [
    (
        1,
        "OFFICIAL_SAMPLE",
        "공식 샘플 10선 (AWS Official PDF)",
        "AWS Official Sample Questions PDF",
        10,
        "AWS 공식 SAA-C03 Sample Exam Questions PDF 원문 10문항 (단일·복수 선택 포함 + 한국어 아키텍처 핵심 해설)",
    ),
    (
        2,
        "CLOUDCERTPREP",
        "핵심 기초 20선 (CloudCertPrep MIT)",
        "CloudCertPrep (MIT)",
        20,
        "CloudCertPrep MIT 오픈소스 4대 도메인 기초 시나리오 20문항 (영문 원문 + 한국어 아키텍처 핵심 해설)",
    ),
    (
        3,
        "MOCK_SET_1",
        "실전 모의고사 1회 (공식 비율 60문항)",
        "Power-xc/aws-saa-cert-quiz (MIT)",
        60,
        "공식 시험 도메인 가중치(30/26/24/20%)를 그대로 반영한 한국어 실전 시나리오 60문항 (단일·복수 선택 혼합)",
    ),
    (
        4,
        "MOCK_SET_2",
        "실전 모의고사 2회 (심화 시나리오 60문항)",
        "Power-xc/aws-saa-cert-quiz (MIT)",
        60,
        "보안·고복원력·고성능·FinOps 심화 아키텍처 트레이드오프 60문항 (도메인 비율 30/26/24/20% 유지)",
    ),
]

CATEGORIES_DOMAIN = [
    (
        1,
        "D1_SECURE",
        "Domain 1: 안전한 아키텍처 설계",
        "Design Secure Architectures",
        30.0,
        "1.1–1.3",
        "IAM/Identity Center 접근 제어, 멀티 계정 SCP/Organizations, KMS/Secrets Manager 암호화, VPC/WAF/Shield/PrivateLink 보안 설계",
    ),
    (
        2,
        "D2_RESILIENT",
        "Domain 2: 복원력이 뛰어난 아키텍처 설계",
        "Design Resilient Architectures",
        26.0,
        "2.1–2.2",
        "느슨한 결합(SQS/SNS/EventBridge/Step Functions), 다중 AZ/다중 리전 고가용성, DR 전략(Pilot Light/Warm Standby), Aurora/DynamoDB 복구",
    ),
    (
        3,
        "D3_PERFORMANT",
        "Domain 3: 고성능 아키텍처 설계",
        "Design High-Performing Architectures",
        24.0,
        "3.1–3.5",
        "S3 Express One Zone/EFS/EBS io2 스토리지, Lambda/Fargate/Batch 탄력 컴퓨팅, ElastiCache/Aurora Reader, CloudFront/Global Accelerator/TGW",
    ),
    (
        4,
        "D4_COST",
        "Domain 4: 비용 최적화 아키텍처 설계",
        "Design Cost-Optimized Architectures",
        20.0,
        "4.1–4.4",
        "Compute Savings Plans/Spot/RI, Graviton(arm64), S3/EBS 수명 주기·스냅샷 아카이브, VPC Gateway Endpoint·IPv4·데이터 전송 비용 절감",
    ),
]

CATEGORIES_QTYPE = [
    (1, "SINGLE", "단일 선택 (Single Choice)", "4개 선택지 중 최적의 아키텍처 1개 선택"),
    (2, "MULTI", "복수 선택 (Multiple Response)", "5개 선택지 중 요구사항을 충족하는 복수 정답(2개) 선택"),
]


def build_database():
    if not os.path.exists(SEED_PATH):
        raise FileNotFoundError(f"Seed bank not found: {SEED_PATH}")

    with open(SEED_PATH, "r", encoding="utf-8") as f:
        seed_questions = json.load(f)

    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")
    cur = conn.cursor()

    cur.executescript("""
    CREATE TABLE cert_metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
    );

    CREATE TABLE exam_rounds (
        round_id INTEGER PRIMARY KEY,
        round_code TEXT NOT NULL UNIQUE,
        round_title TEXT NOT NULL,
        source_name TEXT NOT NULL,
        question_target INTEGER NOT NULL,
        description TEXT NOT NULL
    );

    CREATE TABLE categories_domain (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL UNIQUE,
        domain_name TEXT NOT NULL,
        domain_name_en TEXT NOT NULL,
        official_weight_pct REAL NOT NULL,
        task_range TEXT NOT NULL,
        description TEXT NOT NULL
    );

    CREATE TABLE categories_qtype (
        qtype_id INTEGER PRIMARY KEY,
        qtype_code TEXT NOT NULL UNIQUE,
        qtype_name TEXT NOT NULL,
        description TEXT NOT NULL
    );

    CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY,
        round_id INTEGER NOT NULL,
        question_no INTEGER NOT NULL,
        domain_id INTEGER NOT NULL,
        qtype_id INTEGER NOT NULL,
        qtype TEXT NOT NULL CHECK(qtype IN ('SINGLE', 'MULTI')),
        source TEXT NOT NULL,
        source_ref_id TEXT NOT NULL UNIQUE,
        language TEXT NOT NULL,
        title TEXT NOT NULL,
        question_text TEXT NOT NULL,
        choices_json TEXT NOT NULL,
        answer_index INTEGER,
        answer_indices_json TEXT NOT NULL,
        answer_keys TEXT NOT NULL,
        answer_text TEXT NOT NULL,
        keywords_json TEXT NOT NULL,
        keywords_text TEXT NOT NULL,
        explanation TEXT NOT NULL,
        FOREIGN KEY (round_id) REFERENCES exam_rounds(round_id),
        FOREIGN KEY (domain_id) REFERENCES categories_domain(domain_id),
        FOREIGN KEY (qtype_id) REFERENCES categories_qtype(qtype_id)
    );

    CREATE TABLE question_choices (
        choice_id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        choice_index INTEGER NOT NULL,
        choice_key TEXT NOT NULL,
        choice_text TEXT NOT NULL,
        is_correct INTEGER NOT NULL CHECK(is_correct IN (0, 1)),
        FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
    );

    CREATE TABLE question_keywords (
        kw_id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        keyword TEXT NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
    );

    CREATE TABLE domain_analytics (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL,
        domain_name TEXT NOT NULL,
        domain_name_en TEXT NOT NULL,
        official_weight_pct REAL NOT NULL,
        total_questions INTEGER NOT NULL,
        bank_share_pct REAL NOT NULL,
        single_count INTEGER NOT NULL,
        multi_count INTEGER NOT NULL,
        official_pdf_count INTEGER NOT NULL,
        mit_count INTEGER NOT NULL,
        top_keywords TEXT NOT NULL,
        FOREIGN KEY (domain_id) REFERENCES categories_domain(domain_id)
    );

    CREATE INDEX idx_questions_round ON questions(round_id, question_no);
    CREATE INDEX idx_questions_domain ON questions(domain_id);
    CREATE INDEX idx_questions_qtype ON questions(qtype_id);
    CREATE INDEX idx_questions_source ON questions(source);
    CREATE INDEX idx_choices_qid ON question_choices(question_id, choice_index);
    CREATE INDEX idx_keywords_kw ON question_keywords(keyword);

    CREATE VIEW v_questions_full AS
    SELECT
        q.question_id,
        q.round_id,
        r.round_code,
        r.round_title,
        q.question_no,
        q.domain_id,
        d.domain_code,
        d.domain_name,
        d.domain_name_en,
        d.official_weight_pct,
        q.qtype_id,
        q.qtype,
        t.qtype_name,
        q.source,
        q.source_ref_id,
        q.language,
        q.title,
        q.question_text,
        q.choices_json,
        q.answer_index,
        q.answer_indices_json,
        q.answer_keys,
        q.answer_text,
        q.keywords_json,
        q.keywords_text,
        q.explanation
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_domain d ON q.domain_id = d.domain_id
    JOIN categories_qtype t ON q.qtype_id = t.qtype_id;

    CREATE VIEW v_domain_summary AS
    SELECT
        d.domain_id,
        d.domain_name,
        d.official_weight_pct,
        a.total_questions,
        a.bank_share_pct,
        a.single_count,
        a.multi_count,
        a.official_pdf_count,
        a.mit_count,
        a.top_keywords
    FROM domain_analytics a
    JOIN categories_domain d ON a.domain_id = d.domain_id
    ORDER BY d.domain_id;

    CREATE VIEW v_source_summary AS
    SELECT
        source,
        COUNT(*) AS question_count,
        SUM(CASE WHEN qtype = 'SINGLE' THEN 1 ELSE 0 END) AS single_count,
        SUM(CASE WHEN qtype = 'MULTI' THEN 1 ELSE 0 END) AS multi_count
    FROM questions
    GROUP BY source
    ORDER BY question_count DESC;
    """)

    cur.executemany("INSERT INTO cert_metadata VALUES (?, ?)", list(CERT_META.items()))
    cur.executemany("INSERT INTO exam_rounds VALUES (?, ?, ?, ?, ?, ?)", EXAM_ROUNDS)
    cur.executemany("INSERT INTO categories_domain VALUES (?, ?, ?, ?, ?, ?, ?)", CATEGORIES_DOMAIN)
    cur.executemany("INSERT INTO categories_qtype VALUES (?, ?, ?, ?)", CATEGORIES_QTYPE)

    q_rows = []
    choice_rows = []
    kw_rows = []

    for q in seed_questions:
        qid = int(q["question_id"])
        qtype = q["qtype"]
        qtype_id = 1 if qtype == "SINGLE" else 2
        choices = q["choices"]
        ans_indices = q["answer_indices"]
        ans_set = set(ans_indices)
        keywords = q["keywords"]

        # Quality assertions before inserting
        assert q["title"].strip(), f"Empty title on qid={qid}"
        assert q["question_text"].strip(), f"Empty question_text on qid={qid}"
        assert q["answer_text"].strip(), f"Empty answer_text on qid={qid}"
        assert q["explanation"].strip(), f"Empty explanation on qid={qid}"
        assert len(keywords) >= 3, f"Too few keywords on qid={qid}"
        assert len(choices) >= 4, f"Too few choices on qid={qid}"

        q_rows.append((
            qid,
            int(q["round_id"]),
            int(q["question_no"]),
            int(q["domain_id"]),
            qtype_id,
            qtype,
            q["source"],
            q["source_ref_id"],
            q["language"],
            q["title"].strip(),
            q["question_text"].strip(),
            json.dumps(choices, ensure_ascii=False),
            q["answer_index"],
            json.dumps(ans_indices),
            q["answer_keys"],
            q["answer_text"].strip(),
            json.dumps(keywords, ensure_ascii=False),
            ", ".join(keywords),
            q["explanation"].strip(),
        ))

        for cidx, c in enumerate(choices):
            choice_rows.append((qid, cidx, c["key"], c["text"], 1 if cidx in ans_set else 0))

        for kw in keywords:
            kw_rows.append((qid, kw))

    cur.executemany(
        "INSERT INTO questions VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        q_rows,
    )
    cur.executemany(
        "INSERT INTO question_choices (question_id, choice_index, choice_key, choice_text, is_correct) VALUES (?, ?, ?, ?, ?)",
        choice_rows,
    )
    cur.executemany(
        "INSERT INTO question_keywords (question_id, keyword) VALUES (?, ?)",
        kw_rows,
    )

    total_q = len(seed_questions)
    analytics_rows = []
    for dom_id, dom_code, dom_name, dom_name_en, weight_pct, _, _ in CATEGORIES_DOMAIN:
        dom_qs = [q for q in seed_questions if int(q["domain_id"]) == dom_id]
        cnt = len(dom_qs)
        share = round((cnt / total_q) * 100, 1) if total_q else 0.0
        single_c = sum(1 for q in dom_qs if q["qtype"] == "SINGLE")
        multi_c = sum(1 for q in dom_qs if q["qtype"] == "MULTI")
        pdf_c = sum(1 for q in dom_qs if q["source"] == "AWS Official Sample Questions PDF")
        mit_c = cnt - pdf_c
        kw_counter = Counter(kw for q in dom_qs for kw in q["keywords"])
        top_kws = ", ".join(k for k, _ in kw_counter.most_common(6))
        analytics_rows.append((
            dom_id, dom_code, dom_name, dom_name_en, weight_pct,
            cnt, share, single_c, multi_c, pdf_c, mit_c, top_kws,
        ))

    cur.executemany(
        "INSERT INTO domain_analytics VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        analytics_rows,
    )
    conn.commit()

    # Integrity check
    ic_row = cur.execute("PRAGMA integrity_check;").fetchone()
    assert ic_row and ic_row[0] == "ok", f"SQLite integrity_check failed: {ic_row}"

    # Export SQL dump
    with open(SQL_DUMP_PATH, "w", encoding="utf-8") as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")

    # Export JSON
    source_counts = dict(Counter(q["source"] for q in seed_questions))
    single_total = sum(1 for q in seed_questions if q["qtype"] == "SINGLE")
    multi_total = sum(1 for q in seed_questions if q["qtype"] == "MULTI")

    export_data = {
        "meta": {
            "cert_id": CERT_META["cert_id"],
            "exam_code": CERT_META["exam_code"],
            "title": CERT_META["title"],
            "level": CERT_META["level"],
            "cert_group": CERT_META["cert_group"],
            "exam_stage": CERT_META["exam_stage"],
            "official_exam_format": {
                "question_count": 65,
                "scored_count": 50,
                "unscored_count": 15,
                "duration_minutes": 130,
                "passing_score": 720,
                "score_scale": "100-1000",
            },
            "rounds_count": len(EXAM_ROUNDS),
            "questions_count": total_q,
            "single_count": single_total,
            "multi_count": multi_total,
            "sources_breakdown": source_counts,
            "updated_at": CERT_META["updated_at"],
        },
        "rounds": [
            {
                "round_id": r[0],
                "round_code": r[1],
                "round_title": r[2],
                "source_name": r[3],
                "question_target": r[4],
                "description": r[5],
            }
            for r in EXAM_ROUNDS
        ],
        "domains": [
            {
                "domain_id": d[0],
                "domain_code": d[1],
                "domain_name": d[2],
                "domain_name_en": d[3],
                "official_weight_pct": d[4],
                "task_range": d[5],
                "description": d[6],
            }
            for d in CATEGORIES_DOMAIN
        ],
        "qtypes": [
            {
                "qtype_id": t[0],
                "qtype_code": t[1],
                "qtype_name": t[2],
                "description": t[3],
            }
            for t in CATEGORIES_QTYPE
        ],
        "analytics": [
            {
                "domain_id": a[0],
                "domain_code": a[1],
                "domain_name": a[2],
                "domain_name_en": a[3],
                "official_weight_pct": a[4],
                "total_questions": a[5],
                "bank_share_pct": a[6],
                "single_count": a[7],
                "multi_count": a[8],
                "official_pdf_count": a[9],
                "mit_count": a[10],
                "top_keywords": a[11],
            }
            for a in analytics_rows
        ],
        "questions": [],
    }

    for row in cur.execute("""
        SELECT
            question_id, round_id, round_code, round_title, question_no,
            domain_id, domain_code, domain_name, domain_name_en, official_weight_pct,
            qtype_id, qtype, qtype_name, source, source_ref_id, language,
            title, question_text, choices_json, answer_index, answer_indices_json,
            answer_keys, answer_text, keywords_json, explanation
        FROM v_questions_full
        ORDER BY round_id ASC, question_no ASC
    """):
        export_data["questions"].append({
            "question_id": row[0],
            "round_id": row[1],
            "round_code": row[2],
            "round_title": row[3],
            "question_no": row[4],
            "domain_id": row[5],
            "domain_code": row[6],
            "domain_name": row[7],
            "domain_name_en": row[8],
            "official_weight_pct": row[9],
            "qtype_id": row[10],
            "qtype": row[11],
            "qtype_name": row[12],
            "source": row[13],
            "source_ref_id": row[14],
            "language": row[15],
            "title": row[16],
            "question_text": row[17],
            "choices": json.loads(row[18]),
            "answer_index": row[19],
            "answer_indices": json.loads(row[20]),
            "answer_keys": row[21],
            "answer_text": row[22],
            "keywords": json.loads(row[23]),
            "explanation": row[24],
        })

    with open(JSON_EXPORT_PATH, "w", encoding="utf-8") as f:
        json.dump(export_data, f, ensure_ascii=False, indent=2)

    conn.close()
    print(f"[OK] Built AWS SAA-C03 RDB: {len(EXAM_ROUNDS)} rounds, {total_q} questions (SINGLE={single_total}, MULTI={multi_total})")
    print(f"     integrity_check: {ic_row[0]}")
    print(f"     sources: {source_counts}")
    print(f"     DB:   {DB_PATH}")
    print(f"     SQL:  {SQL_DUMP_PATH}")
    print(f"     JSON: {JSON_EXPORT_PATH}")


if __name__ == "__main__":
    build_database()
