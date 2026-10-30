# DB Schemas — 정보처리기사 실기 기출 RDB (`data/eip_exam.db`)

본 문서는 `rebuild_clean_rdb.py`가 생성하는 정규화 SQLite 데이터베이스(`data/eip_exam.db`) 및 SQL 덤프(`data/schema_and_data.sql`)의 스키마 명세다.

## 1. 엔티티 관계도 (ERD)

```mermaid
erDiagram
    EXAM_ROUNDS ||--o{ QUESTIONS : "1:N (회차별 출제)"
    CATEGORIES_MAJOR ||--o{ CATEGORIES_MINOR : "1:N (카테고리2 -> 카테고리1)"
    CATEGORIES_MAJOR ||--o{ QUESTIONS : "1:N (이론/코드 분류)"
    CATEGORIES_MINOR ||--o{ QUESTIONS : "1:N (18개 세부유형 분류)"
    CATEGORIES_MINOR ||--|| CATEGORY_ANALYTICS : "1:1 (출제빈도/간격/임박도 분석)"

    EXAM_ROUNDS {
        int round_id PK "회차 고유순번 (1~18)"
        string round_title "회차명 (예: 2026년 2회)"
        int exam_year "출제연도 (2020~2026)"
        int exam_session "회차 (1~4)"
        string source_url "원문 출처 URL"
        int question_count "출제 문항 수 (20)"
    }

    CATEGORIES_MAJOR {
        int major_id PK "1=이론, 2=코드"
        string major_code "THEORY / CODE"
        string major_name "이론 문제 / 코드 문제"
        string description "분류 기준 설명"
    }

    CATEGORIES_MINOR {
        int minor_id PK "세부유형 ID (1~18)"
        int major_id FK "상위 대분류 ID"
        string minor_code "유형 영문코드"
        string minor_name "세부 유형명 (카테고리1)"
        string description "세부 출제 범위"
    }

    QUESTIONS {
        int question_id PK "전체 고유 문항 ID (1~360)"
        int round_id FK "출제 회차 ID"
        int question_no "회차 내 문제 번호 (1~20)"
        int major_id FK "카테고리2 ID (이론/코드)"
        int minor_id FK "카테고리1 ID (세부유형)"
        string question_format "출제방식 (단답형/코드출력/SQL작성 등)"
        string question_header "문제 발문 (첫 줄 요약)"
        string question_body "문제 본문/보조 설명"
        string choices_text "보기 박스 항목"
        string tables_json "표 데이터 JSON (headers/rows)"
        string images_json "로컬 이미지 경로 JSON (/images/questions/...)"
        string code_snippet "정제된 코드 또는 SQL 스니펫"
        string code_lang "코드 언어 (c/java/python/sql/text)"
        string answer_text "공식 정답"
        string explanation_text "상세 해설 및 풀이 근거"
        string raw_keywords "핵심 검색 키워드"
    }

    CATEGORY_ANALYTICS {
        int minor_id PK, FK "세부유형 ID"
        int major_id FK "대분류 ID"
        string minor_name "세부유형명"
        string major_name "대분류명"
        int total_questions "총 출제 문항수"
        float share_pct "전체 대비 출제 비중(%)"
        int round_appearances "등장 회차 수 (최대 18)"
        float avg_per_round "회차당 평균 출제 수"
        float avg_interval "평균 출제 간격 (회차 기준)"
        int min_interval "최소 출제 간격"
        int max_interval "최대 출제 간격"
        int last_seen_round_id "마지막 출제 회차 ID"
        string last_seen_round_title "마지막 출제 회차명"
        int rounds_since_last "마지막 출제 이후 경과 회차 수"
        float imminence_index "출제 임박도 지수 (경과회차 / 평균간격)"
        string primary_format "주요 출제 방식"
        string format_distribution "출제 방식 분포 문자열"
    }

    PREDICTED_QUESTIONS {
        int pred_id PK "예상문제 번호 (1~20)"
        string major_name "대분류명 (이론 문제 / 코드 문제)"
        string minor_name "세부유형명"
        string question_format "출제방식"
        string imminence_badge "우선순위 배지"
        string basis "출제 근거 (빈도·주기·간격 데이터)"
        string question_header "예상문제 발문"
        string question_body "예상문제 본문"
        string code_snippet "예상문제 코드/SQL"
        string code_lang "코드 언어"
        string answer_text "정답"
        string explanation_text "핵심 해설"
    }
```

## 2. 3대 학습 모드 전용 SQL View

1. **`v_mode_exam` (실전 풀이 모드)**: `answer_text`와 `explanation_text` 컬럼을 물리적으로 제외한 프로젝션 뷰.
2. **`v_mode_compare` (정답 확인 모드)**: 문제 정보 + `answer_text`까지만 포함하는 프로젝션 뷰.
3. **`v_mode_explanation` (완전 해설 모드)**: 문제 정보 + `answer_text` + `explanation_text` 전체 컬럼을 조인한 뷰.
