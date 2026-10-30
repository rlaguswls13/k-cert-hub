# eip-rdb-system 위키 인덱스

설명만으로 충분하면 대상 파일을 열지 않는다. 세부 스키마나 API 계약, 데이터 정제 규칙이 필요할 때만 아래 정본 문서를 읽는다.

## 로컬 정본

| 관심사 | 정본 | 요약 |
| --- | --- | --- |
| RDB 스키마 & 뷰 | [03-schemas/db-schemas.md](03-schemas/db-schemas.md) | `exam_rounds`, `categories_major`, `categories_minor`, `questions`, `category_analytics`, `predicted_questions` 테이블 및 3개 학습 모드 View |
| REST API & CLI 계약 | [03-schemas/api-contracts.md](03-schemas/api-contracts.md) | Node.js 무의존성 HTTP 서버(`server.js`) API 엔드포인트 및 Python CLI(`query_rdb.py`) 사용법 |
| 도메인 분류 체계 | [05-direction/domain-mindmap.md](05-direction/domain-mindmap.md) | 카테고리2(이론/코드) 및 카테고리1(18개 세부 유형) 분류 규칙, 출제임박도($\text{Imminence Index}$) 공식 |
| 로드맵 & 목표 | [05-direction/roadmap-goals.md](05-direction/roadmap-goals.md) | 데이터 파싱 품질 100% 보장, 3대 학습 모드 UI/UX, 배포 파이프라인 목표 |
| 기출 분석 & 예상 20선 | [06-reports/qna-analysis-and-predictions.md](06-reports/qna-analysis-and-predictions.md) | 2020년 1회~2026년 2회(18회차, 360문항) 통계 분석 및 예상문제 20선 전문 |

## 운영·세션 자료

- 세션 핸드오프(SSOT): [Session_Handoff.md](Session_Handoff.md)
- 세션 로그 인덱스: [Session_Index.md](Session_Index.md), [sessions/](sessions/)
- 검토 흐름: [06-reports/review-inbox/README.md](06-reports/review-inbox/README.md), [06-reports/digests/README.md](06-reports/digests/README.md)
