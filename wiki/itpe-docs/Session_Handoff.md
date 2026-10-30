# Session Handoff — itpe-rdb-system

> **이 파일은 `itpe-rdb-system` 프로젝트의 최신 작업 상태 원본(SSOT)입니다.**
> 물리 경로: `D:\obsidian-storage\project-rag\itpe-rdb-system\Session_Handoff.md`
> 프로젝트 경로: `D:\coding-project\2026-project\itpe-rdb-system`

**Last updated:** 2026-10-26
**Status:** 정보관리기술사(제120회~제140회, 2020~2026년) RDB 구축, 4단 서브노트 해설 및 제141회 예상 토픽 20선 탑재, Node.js 웹 서버(`port 3001`) 구현, GitHub 배포 및 중앙 RAG 위키 연동 완료.

## Current state

- **데이터베이스 & 서브노트 파이프라인 (`rebuild_itpe_rdb.py`)**:
  - 제120회(2020년 2월) ~ 제140회(2026년 8월) 총 21개 회차 메타데이터 및 핵심 기출 서브노트, 제141회 대비 적중 예상 20선 RDB 구축 완료 (`data/itpe_exam.db`, `data/schema_and_data.sql`, `data/itpe_rdb_export.json`).
  - **2단계 분류 체계**:
    - 카테고리2(교시/배점): `1교시 단답·용어형(10점, 10분)` / `2교시 아키텍처·설계·비교(25점, 25분)` / `3교시 운영·관리·보안 시나리오(25점, 25분)` / `4교시 법제도·거버넌스·최신융합(25점, 25분)`
    - 카테고리1(8대 기술 도메인): `[AI/Data]`, `[SW/Arch]`, `[Sec]`, `[DB]`, `[NW/Cloud]`, `[CA/OS]`, `[ITBiz/PM]`, `[Law/Gov]`
- **3대 서브노트 학습 모드 UI/UX (`public/index.html`, `server.js`)**:
  - `① 실전 구상 모드 (문제 + 10분/25분 실전 타이머 + 내 4단 목차 초안 메모장)`
  - `② 목차·키워드 비교 모드 (문제 + 모범 4단 목차 + 필수 채점 키워드 배지)`
  - `③ 서브노트 해설 모드 (문제 + 4단 목차 + 핵심 비교표 + 완결 서브노트 해설 + 출제 계보)`

## Remaining tasks

- 제141회 이후 신규 기출문제 공개 시 `rebuild_itpe_rdb.py`에 토픽을 추가하고 재빌드하여 RDB 및 예상 토픽 임박도 지수 갱신.
