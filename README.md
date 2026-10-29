# 🎓 K-Cert Hub — 국가·민간 자격증 통합 RDB 학습 & 정보공유 채널

**K-Cert Hub**는 자격증별로 파편화된 기출문제와 학습 노트를 **단일 저장소(Single-Repo Monorepo)**로 통합하여, **국가기술자격(정보처리기사, 정보관리기술사, 정보보안기사, 빅데이터분석기사)**부터 **공인 민간자격(SQLD, ADsP)**까지 한곳에서 학습하고 합격수기·복원문제를 공유하는 오픈 채널입니다.

## 🌐 라이브 배포 주소 (GitHub Pages)
- **통합 포털 메인**: [https://rlaguswls13.github.io/k-cert-hub/](https://rlaguswls13.github.io/k-cert-hub/)
- **정보처리기사 실기 전용 RDB (380+20문항)**: [https://rlaguswls13.github.io/k-cert-hub/certs/eip/index.html](https://rlaguswls13.github.io/k-cert-hub/certs/eip/index.html)
- **정보관리기술사 전용 RDB (4단 서브노트 115선)**: [https://rlaguswls13.github.io/k-cert-hub/certs/itpe/index.html](https://rlaguswls13.github.io/k-cert-hub/certs/itpe/index.html)

## 📂 디렉터리 구조
```text
k-cert-hub/
├── index.html                  # K-Cert Hub 통합 포털 (통합 검색, 학습관, 합격수기 라운지, 일정/테크트리)
├── data/
│   └── hub_catalog.json        # 국가·민간 자격증 카탈로그, 미니 학습팩, 시험 일정, 커뮤니티 초기 데이터
├── certs/
│   ├── eip/                    # [국가기술자격] 정보처리기사 실기 RDB (2020~2026년 19개 회차 380문항 + 예상 20문항)
│   └── itpe/                   # [국가기술자격] 정보관리기술사 RDB (제120~140회 4단 서브노트 + 제141회 예상 20선)
├── server.js                   # 로컬 통합 정적/API 서버 (node server.js -> http://localhost:3080)
└── wiki/                       # Obsidian 중앙 지식베이스 (D:\obsidian-storage\project-rag\k-cert-hub) 연동
```
