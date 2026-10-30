# eip-rdb-system 프로젝트 위키

이 디렉터리는 `eip-rdb-system` (정보처리기사 실기 기출문제 RDB & 출제경향 분석 플랫폼) 프로젝트가 소유하는 중앙 프로젝트 RAG 볼트(`D:\obsidian-storage\project-rag\eip-rdb-system`)다.

- **프로젝트 소스 경로**: `D:\coding-project\2026-project\eip-rdb-system`
- **중앙 위키 경로**: `D:\obsidian-storage\project-rag\eip-rdb-system` (로컬 프로젝트의 `wiki/` 정션 및 `.wiki/README.md`와 연동)

## 시작점

- [index.md](index.md): 위키 전체 문서 탐색 인덱스
- [Session_Handoff.md](Session_Handoff.md): 최신 세션 작업 상태 및 핸드오프 (SSOT)
- [Session_Index.md](Session_Index.md): 세션 로그 인덱스

## 핵심 아키텍처 & 스키마 문서

- [03-schemas/db-schemas.md](03-schemas/db-schemas.md): SQLite RDB (`data/eip_exam.db`) 5대 정규화 테이블 및 3대 학습 모드 뷰(`v_mode_*`) 명세
- [03-schemas/api-contracts.md](03-schemas/api-contracts.md): Node.js (`server.js`) REST API 엔드포인트 계약 및 CLI (`query_rdb.py`) 인터페이스
- [05-direction/domain-mindmap.md](05-direction/domain-mindmap.md): 정보처리기사 실기 2대 대분류(이론/코드) × 18개 세부유형 분류 체계
- [05-direction/roadmap-goals.md](05-direction/roadmap-goals.md): 데이터 정제, UI/UX 고도화, 배포 로드맵
- [06-reports/qna-analysis-and-predictions.md](06-reports/qna-analysis-and-predictions.md): 2020~2026(18회차 360문항) 출제빈도·출제주기 분석 및 적중 예상 20선 리포트
