# -*- coding: utf-8 -*-
"""
Build script for AWS Certified Solutions Architect - Professional (SAP-C02) RDB & JSON Export.
Generates:
  - data/sap_c02_exam.db
  - data/schema_and_data.sql
  - data/sap_c02_rdb_export.json
"""

import json
import os
import sqlite3
import sys
from collections import Counter

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
if PROJECT_DIR not in sys.path:
    sys.path.insert(0, PROJECT_DIR)

from sap_c02_questions_part1 import QUESTIONS_PART_1
from sap_c02_questions_part2 import QUESTIONS_PART_2

DATA_DIR = os.path.join(PROJECT_DIR, "data")
os.makedirs(DATA_DIR, exist_ok=True)

DB_PATH = os.path.join(DATA_DIR, "sap_c02_exam.db")
SQL_DUMP_PATH = os.path.join(DATA_DIR, "schema_and_data.sql")
JSON_EXPORT_PATH = os.path.join(DATA_DIR, "sap_c02_rdb_export.json")

OFFICIAL_PDF_URL = (
    "https://d1.awsstatic.com/training-and-certification/docs-sa-pro/"
    "AWS-Certified-Solutions-Architect-Professional_Sample-Questions.pdf"
)
OFFICIAL_EXAM_URL = (
    "https://aws.amazon.com/certification/certified-solutions-architect-professional/"
)

# 1. Rounds / Study Sets
EXAM_ROUNDS = [
    (
        1,
        "OFFICIAL_PDF",
        "공식 샘플 PDF (AWS Official 10문항)",
        "AWS Official Sample Questions PDF",
        "AWS 공식 SAP-C02 Sample Questions PDF 전 문항 (Organizations, StackSets, CORS, Lambda 502, SSM, IAM Cross-Account, Kinesis, SQS, App Runner Multi-Region, Aurora Serverless)",
    ),
    (
        2,
        "SET_1_D1",
        "Set 1 · 조직 복잡성 & 하이브리드 네트워킹 (Domain 1)",
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Organizations, Control Tower, SCP/Tag Policy/Backup Policy, AWS RAM, Transit Gateway Appliance Mode & Peering, Direct Connect BGP/BFD, Route 53 Resolver, PrivateLink",
    ),
    (
        3,
        "SET_2_D2",
        "Set 2 · 신규 솔루션 & 고가용성/DR 설계 (Domain 2)",
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "DR RPO/RTO(Warm Standby vs Pilot Light), Global Accelerator, Aurora Global DB, DynamoDB Global Tables LWW, Step Functions Saga/Distributed Map, CloudFront OAC, Nitro Enclaves, EKS",
    ),
    (
        4,
        "SET_3_D3",
        "Set 3 · 기존 솔루션 성능·비용·운영 개선 (Domain 3)",
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "S3 Storage Lens, S3 Express One Zone/Glacier Instant, EBS gp3/io2 Nitro 대역폭, EFS Elastic, FSx Lustre/ONTAP, DataSync/Transfer Family, FinOps/CUR, Athena Parquet, Lambda SnapStart",
    ),
    (
        5,
        "SET_4_D4",
        "Set 4 · 워크로드 마이그레이션 & 현대화 (Domain 4)",
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "AWS MGN(Rehost), VMware Cloud on AWS(Relocate), DMS+SCT 이기종 vs 네이티브 동종, 7Rs, Strangler Fig, App2Container+Fargate, Snowball+DataSync, Mainframe Blu Age, VPC Lattice",
    ),
    (
        6,
        "SET_5_MOCK",
        "Set 5 · 실전 종합 아키텍처 모의고사 (전 도메인 통합)",
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "4대 도메인 복합 엔터프라이즈 시나리오: IPv6/NAT64, Firewall Manager, DX MACsec, Shield Advanced, Outposts vs Local Zones, KMS Multi-Region, MSK Replicator, Air-Gapped Backup, Zero-Downtime DNS Cutover",
    ),
]

# 2. Official SAP-C02 4 Domains (with exact Exam Guide weight percentages)
CATEGORIES_DOMAIN = [
    (
        1,
        "D1_ORG_COMPLEXITY",
        "Domain 1: Design Solutions for Organizational Complexity (26%)",
        26,
        "AWS Organizations, Control Tower, SCP, IAM Identity Center ABAC, RAM, Transit Gateway, Direct Connect BGP/BFD, Route 53 Resolver, PrivateLink, Cross-Account KMS/CloudTrail",
    ),
    (
        2,
        "D2_NEW_SOLUTIONS",
        "Domain 2: Design for New Solutions (29%)",
        29,
        "DR 전략(RPO/RTO Pilot Light/Warm Standby/Active-Active), Global Accelerator, Aurora/DynamoDB Global, Step Functions/EventBridge, CloudFront OAC, RDS Proxy, Nitro Enclaves, EKS/Shield/Backup",
    ),
    (
        3,
        "D3_CONTINUOUS_IMP",
        "Domain 3: Continuous Improvement for Existing Solutions (25%)",
        25,
        "S3 Storage Lens/Express One Zone, EBS gp3/io2, EFS Elastic, FSx Lustre/ONTAP, DataSync/Transfer Family, FinOps(CUR/Compute Optimizer/Savings Plans), Athena Parquet, Lambda SnapStart, Redis CME",
    ),
    (
        4,
        "D4_MIGRATION_MOD",
        "Domain 4: Accelerate Workload Migration and Modernization (20%)",
        20,
        "AWS MGN, VMware Cloud(Relocate), DMS+SCT vs Native DB Migration, 7Rs, Strangler Fig, App2Container+Fargate, Snowball+DataSync, Migration Evaluator/ADS, Mainframe Modernization, VPC Lattice",
    ),
]

# 3. Question Types (Single vs Multi-Select)
CATEGORIES_QTYPE = [
    (
        1,
        "SINGLE",
        "단일 선택 (Single Choice)",
        "1개 정답",
        "4지선다(A~D) 중 요구사항과 제약조건을 모두 만족하는 최선의 단일 아키텍처 선택",
    ),
    (
        2,
        "MULTI",
        "다중 선택 (Select TWO/THREE)",
        "2~3개 정답",
        "5~6지선다(A~E/F) 중 상호 보완적 아키텍처 조치 2가지 또는 3가지를 정확히 조합 선택",
    ),
]


def validate_questions(all_questions):
    """Ensure zero empty required fields, valid option/answer consistency, and expected counts."""
    assert len(all_questions) >= 80, f"Expected >= 80 questions, got {len(all_questions)}"

    seen_round_qno = set()
    valid_sources = {
        "AWS Official Sample Questions PDF",
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
    }

    for idx, q in enumerate(all_questions, start=1):
        (
            round_id,
            q_no,
            domain_id,
            qtype_id,
            select_count,
            source,
            difficulty,
            title,
            question_text,
            arch_ctx,
            options,
            correct_options,
            answer_text,
            core_keywords,
            explanation,
            exam_tip,
        ) = q

        assert (round_id, q_no) not in seen_round_qno, f"Duplicate (round_id={round_id}, q_no={q_no})"
        seen_round_qno.add((round_id, q_no))

        assert source in valid_sources, f"Invalid source on item {idx}: {source}"
        assert domain_id in {1, 2, 3, 4}, f"Invalid domain_id on item {idx}: {domain_id}"
        assert qtype_id in {1, 2}, f"Invalid qtype_id on item {idx}: {qtype_id}"
        assert select_count in {1, 2, 3}, f"Invalid select_count on item {idx}: {select_count}"
        assert (qtype_id == 1 and select_count == 1) or (qtype_id == 2 and select_count in {2, 3}), (
            f"qtype_id/select_count mismatch on item {idx}"
        )

        for field_name, val in [
            ("title", title),
            ("question_text", question_text),
            ("answer_text", answer_text),
            ("core_keywords", core_keywords),
            ("explanation", explanation),
            ("exam_tip", exam_tip),
            ("source", source),
            ("difficulty", difficulty),
        ]:
            assert isinstance(val, str) and val.strip() != "", (
                f"Empty {field_name} on round={round_id}, q_no={q_no}"
            )

        assert isinstance(options, list) and len(options) >= 4, f"Too few options on item {idx}"
        opt_labels = [o["label"] for o in options]
        assert len(opt_labels) == len(set(opt_labels)), f"Duplicate option labels on item {idx}"
        for opt in options:
            assert opt["text"].strip() != "", f"Empty option text on item {idx}"

        assert len(correct_options) == select_count, (
            f"select_count={select_count} vs len(correct_options)={len(correct_options)} on item {idx}"
        )
        for c in correct_options:
            assert c in opt_labels, f"Correct label {c} missing from options on item {idx}"


def build_database():
    all_questions = QUESTIONS_PART_1 + QUESTIONS_PART_2
    validate_questions(all_questions)

    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")
    cur = conn.cursor()

    cur.executescript(
        """
        CREATE TABLE exam_rounds (
            round_id INTEGER PRIMARY KEY,
            round_code TEXT NOT NULL UNIQUE,
            round_title TEXT NOT NULL,
            source_type TEXT NOT NULL,
            focus_topics TEXT NOT NULL
        );

        CREATE TABLE categories_domain (
            domain_id INTEGER PRIMARY KEY,
            domain_code TEXT NOT NULL UNIQUE,
            domain_name TEXT NOT NULL,
            weight_pct INTEGER NOT NULL,
            description TEXT NOT NULL
        );

        CREATE TABLE categories_qtype (
            qtype_id INTEGER PRIMARY KEY,
            qtype_code TEXT NOT NULL UNIQUE,
            qtype_name TEXT NOT NULL,
            select_count_label TEXT NOT NULL,
            description TEXT NOT NULL
        );

        CREATE TABLE questions (
            question_id INTEGER PRIMARY KEY AUTOINCREMENT,
            round_id INTEGER NOT NULL REFERENCES exam_rounds(round_id),
            question_no INTEGER NOT NULL,
            domain_id INTEGER NOT NULL REFERENCES categories_domain(domain_id),
            qtype_id INTEGER NOT NULL REFERENCES categories_qtype(qtype_id),
            select_count INTEGER NOT NULL,
            source TEXT NOT NULL,
            difficulty TEXT NOT NULL,
            title TEXT NOT NULL,
            question_text TEXT NOT NULL,
            architecture_context TEXT NOT NULL,
            options_json TEXT NOT NULL,
            correct_options_json TEXT NOT NULL,
            answer_text TEXT NOT NULL,
            core_keywords TEXT NOT NULL,
            explanation TEXT NOT NULL,
            exam_tip TEXT NOT NULL,
            UNIQUE(round_id, question_no)
        );

        CREATE TABLE domain_analytics (
            domain_id INTEGER PRIMARY KEY REFERENCES categories_domain(domain_id),
            domain_code TEXT NOT NULL,
            domain_name TEXT NOT NULL,
            official_weight_pct INTEGER NOT NULL,
            total_questions INTEGER NOT NULL,
            rdb_share_pct REAL NOT NULL,
            official_count INTEGER NOT NULL,
            scenario_count INTEGER NOT NULL,
            single_count INTEGER NOT NULL,
            multi_count INTEGER NOT NULL
        );

        CREATE INDEX idx_questions_round ON questions(round_id);
        CREATE INDEX idx_questions_domain ON questions(domain_id);
        CREATE INDEX idx_questions_source ON questions(source);

        CREATE VIEW v_question_detail AS
        SELECT
            q.question_id,
            q.round_id,
            r.round_code,
            r.round_title,
            q.question_no,
            q.domain_id,
            d.domain_code,
            d.domain_name,
            d.weight_pct,
            q.qtype_id,
            t.qtype_code,
            t.qtype_name,
            q.select_count,
            q.source,
            q.difficulty,
            q.title,
            q.question_text,
            q.architecture_context,
            q.options_json,
            q.correct_options_json,
            q.answer_text,
            q.core_keywords,
            q.explanation,
            q.exam_tip
        FROM questions q
        JOIN exam_rounds r ON q.round_id = r.round_id
        JOIN categories_domain d ON q.domain_id = d.domain_id
        JOIN categories_qtype t ON q.qtype_id = t.qtype_id;
        """
    )

    cur.executemany("INSERT INTO exam_rounds VALUES (?, ?, ?, ?, ?)", EXAM_ROUNDS)
    cur.executemany("INSERT INTO categories_domain VALUES (?, ?, ?, ?, ?)", CATEGORIES_DOMAIN)
    cur.executemany("INSERT INTO categories_qtype VALUES (?, ?, ?, ?, ?)", CATEGORIES_QTYPE)

    q_rows = []
    for q in all_questions:
        (
            round_id,
            q_no,
            domain_id,
            qtype_id,
            select_count,
            source,
            difficulty,
            title,
            question_text,
            arch_ctx,
            options,
            correct_options,
            answer_text,
            core_keywords,
            explanation,
            exam_tip,
        ) = q
        q_rows.append(
            (
                round_id,
                q_no,
                domain_id,
                qtype_id,
                select_count,
                source,
                difficulty,
                title,
                question_text,
                arch_ctx,
                json.dumps(options, ensure_ascii=False),
                json.dumps(correct_options, ensure_ascii=False),
                answer_text,
                core_keywords,
                explanation,
                exam_tip,
            )
        )

    cur.executemany(
        """
        INSERT INTO questions (
            round_id, question_no, domain_id, qtype_id, select_count,
            source, difficulty, title, question_text, architecture_context,
            options_json, correct_options_json, answer_text,
            core_keywords, explanation, exam_tip
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        q_rows,
    )

    total_q = len(all_questions)
    analytics_rows = []
    for dom_id, dom_code, dom_name, weight_pct, _ in CATEGORIES_DOMAIN:
        dom_qs = [q for q in all_questions if q[2] == dom_id]
        cnt = len(dom_qs)
        share = round((cnt / total_q) * 100, 1) if total_q else 0.0
        off_cnt = sum(1 for q in dom_qs if q[5] == "AWS Official Sample Questions PDF")
        scen_cnt = cnt - off_cnt
        single_cnt = sum(1 for q in dom_qs if q[3] == 1)
        multi_cnt = sum(1 for q in dom_qs if q[3] == 2)
        analytics_rows.append(
            (
                dom_id,
                dom_code,
                dom_name,
                weight_pct,
                cnt,
                share,
                off_cnt,
                scen_cnt,
                single_cnt,
                multi_cnt,
            )
        )

    cur.executemany(
        "INSERT INTO domain_analytics VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        analytics_rows,
    )
    conn.commit()

    # Integrity check
    integrity = cur.execute("PRAGMA integrity_check").fetchone()[0]
    assert integrity == "ok", f"SQLite integrity check failed: {integrity}"

    # Export SQL dump
    with open(SQL_DUMP_PATH, "w", encoding="utf-8") as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")

    source_counts = Counter(q[5] for q in all_questions)
    official_count = source_counts["AWS Official Sample Questions PDF"]
    scenario_count = source_counts["SAP-C02 공식 Exam Guide 아키텍처 시나리오"]

    export_data = {
        "meta": {
            "cert_id": "aws-sap-c02",
            "exam_code": "SAP-C02",
            "level": "Professional",
            "cert_group": "AWS 클라우드 자격",
            "exam_stage": "필기",
            "title": "AWS Certified Solutions Architect - Professional (SAP-C02) 아키텍처 RDB",
            "official_exam_url": OFFICIAL_EXAM_URL,
            "sample_pdf_url": OFFICIAL_PDF_URL,
            "exam_duration_min": 180,
            "exam_questions_count": 75,
            "passing_score": 750,
            "rounds_count": len(EXAM_ROUNDS),
            "questions_count": total_q,
            "official_sample_count": official_count,
            "scenario_count": scenario_count,
            "updated_at": "2026-11-26",
        },
        "rounds": [
            {
                "round_id": r[0],
                "round_code": r[1],
                "round_title": r[2],
                "source_type": r[3],
                "focus_topics": r[4],
                "question_count": sum(1 for q in all_questions if q[0] == r[0]),
            }
            for r in EXAM_ROUNDS
        ],
        "domains": [
            {
                "domain_id": d[0],
                "domain_code": d[1],
                "domain_name": d[2],
                "weight_pct": d[3],
                "description": d[4],
            }
            for d in CATEGORIES_DOMAIN
        ],
        "qtypes": [
            {
                "qtype_id": t[0],
                "qtype_code": t[1],
                "qtype_name": t[2],
                "select_count_label": t[3],
                "description": t[4],
            }
            for t in CATEGORIES_QTYPE
        ],
        "analytics": [
            {
                "domain_id": a[0],
                "domain_code": a[1],
                "domain_name": a[2],
                "official_weight_pct": a[3],
                "total_questions": a[4],
                "rdb_share_pct": a[5],
                "official_count": a[6],
                "scenario_count": a[7],
                "single_count": a[8],
                "multi_count": a[9],
            }
            for a in analytics_rows
        ],
        "questions": [],
    }

    for row in cur.execute(
        """
        SELECT question_id, round_id, round_code, round_title, question_no,
               domain_id, domain_code, domain_name, weight_pct,
               qtype_id, qtype_code, qtype_name, select_count,
               source, difficulty, title, question_text, architecture_context,
               options_json, correct_options_json, answer_text,
               core_keywords, explanation, exam_tip
        FROM v_question_detail
        ORDER BY round_id ASC, question_no ASC
        """
    ):
        export_data["questions"].append(
            {
                "question_id": row[0],
                "round_id": row[1],
                "round_code": row[2],
                "round_title": row[3],
                "question_no": row[4],
                "domain_id": row[5],
                "domain_code": row[6],
                "domain_name": row[7],
                "weight_pct": row[8],
                "qtype_id": row[9],
                "qtype_code": row[10],
                "qtype_name": row[11],
                "select_count": row[12],
                "source": row[13],
                "difficulty": row[14],
                "title": row[15],
                "question_text": row[16],
                "architecture_context": row[17],
                "options": json.loads(row[18]),
                "correct_options": json.loads(row[19]),
                "answer_text": row[20],
                "core_keywords": row[21],
                "explanation": row[22],
                "exam_tip": row[23],
            }
        )

    with open(JSON_EXPORT_PATH, "w", encoding="utf-8") as f:
        json.dump(export_data, f, ensure_ascii=False, indent=2)

    conn.close()

    print(f"[OK] Built SAP-C02 RDB successfully (PRAGMA integrity_check: {integrity})")
    print(f"     Total Questions: {total_q} (Official PDF: {official_count}, Exam Guide Scenarios: {scenario_count})")
    for a in analytics_rows:
        print(
            f"     - Domain {a[0]} ({a[3]}% blueprint): {a[4]} questions ({a[5]}%) "
            f"[Official={a[6]}, Scenario={a[7]}, Single={a[8]}, Multi={a[9]}]"
        )
    print(f"     DB:   {DB_PATH}")
    print(f"     SQL:  {SQL_DUMP_PATH}")
    print(f"     JSON: {JSON_EXPORT_PATH}")


if __name__ == "__main__":
    build_database()
