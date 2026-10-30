# API Contracts & CLI Interface — eip-rdb-system

본 문서는 `server.js` (Node.js HTTP 서버)와 `query_rdb.py` (Python CLI 도구)의 인터페이스를 정의한다.

## 1. Node.js REST API (`server.js`)

기본 포트: `3000` (`process.env.PORT` 우선)

| 메서드 | 엔드포인트 | 쿼리 파라미터 | 응답 요약 |
| --- | --- | --- | --- |
| `GET` | `/api/init` | 없음 | 전체 초기 데이터셋 (`categories_major`, `categories_minor`, `exam_rounds`, `category_analytics`, `questions` 360건, `predicted_questions` 20건) |
| `GET` | `/api/rounds` | 없음 | 18개 기출 회차 메타데이터 배열 |
| `GET` | `/api/analytics` | 없음 | 18개 세부 유형별 빈도·주기·임박도 분석 배열 |
| `GET` | `/api/questions` | `round`, `cat2`, `cat1`, `format`, `q`, `mode`(`exam`\|`compare`\|`explain`) | 조건 필터링 및 학습 모드별 필드 마스킹이 적용된 기출문제 목록 (`{ count, mode, items }`) |
| `GET` | `/api/predictions` | `mode`(`exam`\|`compare`\|`explain`) | 적중 예상문제 20선 (`mode`에 따라 정답·해설 마스킹 적용) |

## 2. Python RDB 재빌드 및 CLI 조회 도구

- **데이터 정제 및 RDB 재빌드**:
  ```bash
  python rebuild_clean_rdb.py
  ```
  - 입력: `data/articles_raw.json`
  - 출력: `data/eip_exam.db`, `data/schema_and_data.sql`, `data/eip_rdb_export.json`, `public/images/questions/*.png`
- **CLI 조회 (`query_rdb.py`)**:
  ```bash
  python query_rdb.py --analytics
  python query_rdb.py --mode exam --round "2026년 2회"
  python query_rdb.py --mode compare --cat2 "코드 문제" --cat1 "[코드] Java"
  python query_rdb.py --mode explain --cat1 "[이론] 네트워크/프로토콜" --limit 10
  ```
