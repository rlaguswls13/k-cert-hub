# itpe-rdb-system 위키 인덱스

설명만으로 충분하면 대상 파일을 열지 않는다. 세부 스키마나 API 계약, 서브노트 구조 규칙이 필요할 때만 아래 정본 문서를 읽는다.

## 로컬 정본

| 관심사 | 정본 | 요약 |
| --- | --- | --- |
| RDB 스키마 & 뷰 | [03-schemas/db-schemas.md](03-schemas/db-schemas.md) | `exam_rounds`, `categories_period`, `categories_domain`, `questions`, `domain_analytics`, `predicted_topics` 및 3개 학습 모드 View |
| REST API & CLI 계약 | [03-schemas/api-contracts.md](03-schemas/api-contracts.md) | Node.js HTTP 서버(`server.js`, порт 3001) API 엔드포인트 및 Python CLI(`query_rdb.py`) 사용법 |
| 도메인 분류 체계 | [05-direction/domain-mindmap.md](05-direction/domain-mindmap.md) | 교시별(1~4교시) 및 8대 기술 도메인 분류, 1교시→서술형 승격 패턴 |
| 로드맵 & 목표 | [05-direction/roadmap-goals.md](05-direction/roadmap-goals.md) | 4단 서브노트 표준화, 3대 학습 모드 UI/UX, 배포 파이프라인 목표 |
| 기출 분석 & 예상 20선 | [06-reports/itpe-analysis-and-predictions.md](06-reports/itpe-analysis-and-predictions.md) | 제120회~제140회(2020~2026) 출제경향 분석 및 제141회 대비 적중 예상 20선 |

## 운영·세션 자료

- 세션 핸드오프(SSOT): [Session_Handoff.md](Session_Handoff.md)
- 세션 로그 인덱스: [Session_Index.md](Session_Index.md), [sessions/](sessions/)
- 검토 흐름: [06-reports/review-inbox/README.md](06-reports/review-inbox/README.md), [06-reports/digests/README.md](06-reports/digests/README.md)
