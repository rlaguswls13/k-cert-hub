# DB Schemas — 정보관리기술사 기출 RDB (`data/itpe_exam.db`)

본 문서는 `rebuild_itpe_rdb.py`가 생성하는 정규화 SQLite 데이터베이스(`data/itpe_exam.db`) 및 SQL 덤프(`data/schema_and_data.sql`)의 스키마 명세다.

## 1. 핵심 테이블 구성

1. **`exam_rounds`**: 제120회 ~ 제140회(21개 회차) 시행일자, 출처 URL, 회차별 핵심 출제 트렌드 요약(`trend_summary`).
2. **`categories_period` (카테고리2)**: 1교시 단답·용어형(10점, 권장 10분) ~ 2·3·4교시 서술형(25점, 권장 25분).
3. **`categories_domain` (카테고리1)**: 8대 핵심 기술 도메인(`AI_DATA`, `SW_ARCH`, `SEC`, `DB`, `NW_CLOUD`, `CA_OS`, `ITBIZ_PM`, `LAW_GOV`).
4. **`questions`**: 기출 문항 발문(`question_header`), 하위 질문 배열(`sub_prompts_json`), 모범 4단 목차(`standard_outline_json`), 필수 채점 키워드(`core_keywords`), 핵심 비교표(`comparison_table_json`), 완결 서브노트 해설(`model_answer_text`), 출제 계보(`escalation_note`).
5. **`domain_analytics`**: 8대 도메인별 문항 수, 비중, 1교시 vs 2~4교시 분포, 평균 출제 주기, 임박도 지수, 최근 급상승 키워드.
6. **`predicted_topics`**: 제141회 대비 적중 예상 20선 토픽 및 4단 서브노트 데이터.

## 2. 3대 서브노트 학습 모드 전용 SQL View

- **`v_mode_exam` (실전 구상 모드)**: 문제 발문과 하위 질문(`sub_prompts_json`), 배점·권장시간만 반환하고 모범 목차·비교표·해설을 제외한 뷰.
- **`v_mode_compare` (목차·키워드 비교 모드)**: 문제 정보 + `standard_outline_json`(모범 4단 목차) + `core_keywords`(필수 채점 키워드)까지만 반환하는 뷰.
- **`v_mode_explanation` (서브노트 해설 모드)**: 비교표(`comparison_table_json`), 서브노트 본문(`model_answer_text`), 출제 계보(`escalation_note`)까지 전체 반환하는 뷰.
