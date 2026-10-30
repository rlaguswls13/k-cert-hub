# API Contracts & CLI Interface — itpe-rdb-system

기본 포트: `3001` (`process.env.PORT` 우선 — `eip-rdb-system`의 `3000`번 포트와 동시 구동 가능하도록 분리)

| 메서드 | 엔드포인트 | 쿼리 파라미터 | 응답 요약 |
| --- | --- | --- | --- |
| `GET` | `/api/init` | 없음 | 전체 초기 데이터셋 (`exam_rounds`, `categories_period`, `categories_domain`, `domain_analytics`, `questions`, `predicted_topics`) |
| `GET` | `/api/rounds` | 없음 | 제120회~제140회(21개 회차) 메타데이터 및 트렌드 연표 |
| `GET` | `/api/analytics` | 없음 | 8대 기술 도메인별 빈도·교시 비중·임박도·급상승 키워드 배열 |
| `GET` | `/api/questions` | `round`, `period`, `domain`, `format`, `q`, `mode`(`exam`\|`compare`\|`explain`) | 조건 필터링 및 학습 모드별 필드 프로젝션이 적용된 기출 서브노트 목록 |
| `GET` | `/api/predictions` | `mode`(`exam`\|`compare`\|`explain`) | 제141회 대비 적중 예상 20선 (`mode`에 따라 목차·해설 마스킹 적용) |
