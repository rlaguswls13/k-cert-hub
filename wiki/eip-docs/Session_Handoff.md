# Session Handoff — eip-rdb-system

> **이 파일은 `eip-rdb-system` 프로젝트의 최신 작업 상태 원본(SSOT)입니다.**
> 물리 경로: `D:\obsidian-storage\project-rag\eip-rdb-system\Session_Handoff.md`
> 프로젝트 경로: `D:\coding-project\2026-project\eip-rdb-system`

**Last updated:** 2026-10-26
**Status:** 2026년 3회(제19회차) 실기 기출 20문항 업데이트 완료(총 19개 회차, 380문항), SQLite RDB 및 웹앱(`public/index.html`) 동기화, GitHub 푸시 완료.

## Current state

- **데이터베이스 & 정제 파이프라인 (`rebuild_clean_rdb.py`)**:
  - 2020년 1회 ~ 2026년 3회 (**총 19개 회차, 380문항**) 전수 파싱 및 RDB 구축 완료 (`data/eip_exam.db`, `data/schema_and_data.sql`, `data/eip_rdb_export.json`).
  - **2026년 3회(제19회차, 문항 ID 361~380) 신규 반영**:
    - 코드 11문항(C언어 3, Java 3, SQL 3, Python 2) + 이론 9문항(DB 설계 단계, Factory Method, IDEA/Skipjack, 경계값 분석, RBAC, FLSM 서브네팅, UML 구성요소, 루트킷, SBOM) 수록 및 컴파일·쿼리 검증 완료.
  - **데이터 깨짐 0건 달성**:
    1. Tistory ColorScripter 코드 블록 줄바꿈·들여쓰기 및 `#include <stdio.h>` 헤더 누락 복원 완료.
    2. 지문 내 표·다이어그램·순서도·토폴로지 원본 이미지 70개 로컬 다운로드 완료 (`public/images/questions/q_XXX_Y.png`).
    3. HTML 중첩 테이블(`tables_json`) 및 `<보기>` 박스(`choices_text`) 구조화 분리 완료.
    4. 원본 블로그 오탈자(QID 302 정답 `'ㅇ'` → `'조건 커버리지 (Condition Coverage)'`) 및 카테고리 오분류(QID 344 OSPF → `네트워크/프로토콜`) 교정 완료.
- **UI/UX 및 용어 개선 (`public/index.html`, `server.js`)**:
  - 직관적인 한국어 용어 적용 (`실전 풀이 모드`, `정답 확인 모드`, `완전 해설 모드`, `대분류 (문제 형태)`, `세부 출제 영역`, `출제 임박도`, `미출제 경과`).
  - 다크/라이트 테마 토글, 시험모드 내 인라인 정답/해설 개별 토글 버튼, 채점 요약 배너(맞힌 문항 / 확인한 문항 / 남은 문항) 및 오답 모아보기 필터, 단축키(`1`/`2`/`3`, `/`), 인쇄/PDF 최적화(`@media print`) 구현 완료.

## Remaining tasks

- 신규 기출 회차(예: 2026년 3회 이후) 발표 시 `data/articles_raw.json`에 원문 추가 후 `python rebuild_clean_rdb.py` 실행하여 RDB 및 정적 JSON 갱신.
