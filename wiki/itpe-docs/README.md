# itpe-rdb-system 프로젝트 위키

이 디렉터리는 `itpe-rdb-system` (정보관리기술사 기출문제 RDB & 출제경향·4단 서브노트 플랫폼) 프로젝트가 소유하는 중앙 프로젝트 RAG 볼트(`D:\obsidian-storage\project-rag\itpe-rdb-system`)다.

- **프로젝트 소스 경로**: `D:\coding-project\2026-project\itpe-rdb-system`
- **중앙 위키 경로**: `D:\obsidian-storage\project-rag\itpe-rdb-system` (로컬 프로젝트의 `wiki/` 정션 및 `.wiki/README.md`와 연동)

## 시작점

- [index.md](index.md): 위키 전체 문서 탐색 인덱스
- [Session_Handoff.md](Session_Handoff.md): 최신 세션 작업 상태 및 핸드오프 (SSOT)
- [Session_Index.md](Session_Index.md): 세션 로그 인덱스

## 핵심 아키텍처 & 스키마 문서

- [03-schemas/db-schemas.md](03-schemas/db-schemas.md): SQLite RDB (`data/itpe_exam.db`) 6대 정규화 테이블 및 3대 서브노트 학습 모드 뷰(`v_mode_*`) 명세
- [03-schemas/api-contracts.md](03-schemas/api-contracts.md): Node.js (`server.js`, 포트 3001) REST API 엔드포인트 계약 및 CLI (`query_rdb.py`) 인터페이스
- [05-direction/domain-mindmap.md](05-direction/domain-mindmap.md): 정보관리기술사 교시별(1~4교시) × 8대 기술 도메인 분류 체계 및 교시 승격 패턴
- [05-direction/roadmap-goals.md](05-direction/roadmap-goals.md): 서브노트 데이터 확장 및 UI/UX 고도화 로드맵
- [06-reports/itpe-analysis-and-predictions.md](06-reports/itpe-analysis-and-predictions.md): 제120회~제140회 출제경향 분석 및 제141회 대비 적중 예상 20선 리포트
