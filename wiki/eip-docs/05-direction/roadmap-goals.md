# Roadmap & Goals — eip-rdb-system

## 1. 완료된 마일스톤 (M1 ~ M4)

- **[완료] M1. 18회차(360문항) 기출 수집 및 RDB 정규화**:
  - 2020년 1회 ~ 2026년 2회 전 문항 수집, 카테고리2(이론/코드) 및 카테고리1(18개 세부 유형) 매핑, SQLite DB 및 SQL 덤프 생성.
- **[완료] M2. 데이터 파싱 결함 전수 감사 및 0건 달성**:
  - ColorScripter 코드 줄바꿈/인덴트 복원, `<stdio.h>` 등 C 헤더 복원, 70개 원본 다이어그램/표 이미지 로컬 다운로드(`public/images/questions/`), 중첩 HTML 표(`tables_json`) 및 보기(`choices_text`) 분리, 원본 블로그 오타 교정.
- **[완료] M3. UI/UX 개선 및 Node.js 웹 서버 패키징**:
  - 3대 학습 모드(실전 풀이 / 정답 확인 / 완전 해설), 인라인 정답/해설 개별 토글, 채점 요약 배너 및 오답 필터, 다크/라이트 모드, 키보드 단축키, 무의존성 `server.js` 및 `Dockerfile` 구성.
- **[완료] M4. 프로젝트 이관, GitHub 배포 및 중앙 RAG 위키 구축**:
  - `D:\coding-project\2026-project\eip-rdb-system` 생성 및 Git/GitHub 배포.
  - `D:\obsidian-storage\project-rag\eip-rdb-system` 중앙 위키 연동.

## 2. 향후 확장 목표 (Backlog)

- **M5. 신규 기출 회차 자동 증분 파이프라인**: 2026년 3회 이후 시험 복원본 공개 시 URL만 추가하면 자동으로 이미지 다운로드 및 RDB/예상문제 임박도 지수를 재계산하는 증분 스크립트 옵션 추가.
- **M6. 사용자 북마크 & 메모 내보내기**: 브라우저 `localStorage`에 저장된 채점 결과(맞힌 문제/틀린 문제)를 JSON/CSV로 백업·복원하는 기능.
