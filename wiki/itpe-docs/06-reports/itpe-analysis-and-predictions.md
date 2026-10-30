# 정보관리기술사(제120회~제140회) 출제경향 분석 및 제141회 대비 적중 예상 20선

## 1. 8대 핵심 기술 도메인별 출제 빈도 및 교시 비중 분석

| 도메인(카테고리1) | 수록 문항 | 비중 | 1교시(10점) | 2~4교시(25점) | 평균 출제주기 | 주요 출제방식 | 최근 급상승 키워드 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| **[AI/Data] 인공지능 · 빅데이터 · 통계** | 22문항 | 21.6% | 18문항 | 4문항 | 1.42회차 | 비교/아키텍처형 | Physical AI, Advanced/Modular RAG, RAFT, PagedAttention, MoE, 잭나이프 |
| **[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트** | 12문항 | 11.8% | 10문항 | 2문항 | 2.86회차 | 비교/아키텍처형 | ATAM, ISO/IEC 25010(Safety), 무중단 배포(Canary), 맥케이브 복잡도, 플랫폼 엔지니어링 |
| **[Sec] 정보보안 · 암호 · 개인정보보호** | 18문항 | 17.6% | 13문항 | 5문항 | 2.11회차 | 원인분석/대응전략형 | 비인간 신원(NHI), CTEM, 국가망보안체계(N2SF), MCP 보안, 프롬프트 인젝션, PET/동형암호 |
| **[DB] 데이터베이스 · 데이터모델링 · 분산데이터** | 12문항 | 11.8% | 6문항 | 6문항 | 1.56회차 | 비교/아키텍처형 | 하이브리드 검색(BM25+Vector), HNSW/IVF, 데이터 관측가능성, 분산DB 투명성, 제4정규형/반정규화 |
| **[NW/Cloud] 네트워크 · 클라우드 · 차세대통신** | 10문항 | 9.8% | 6문항 | 4문항 | 2.38회차 | 개념/차세대통신형 | 6G AI-Native Network, Wi-Fi 7(MLO), 차등 맨체스터 부호화, SASE/SSE, FinOps/서버리스 |
| **[CA/OS] 컴퓨터구조 · 운영체제 · 양자컴퓨팅** | 8문항 | 7.8% | 5문항 | 3문항 | 3.6회차 | 개념/운영체제형 | 좀비 프로세스, GPU vs TPU(Systolic Array), CXL(메모리 풀링), 양자머신러닝(QML), eBPF |
| **[ITBiz/PM] 프로젝트관리 · IT경영 · 감리 · BPR** | 11문항 | 10.8% | 9문항 | 2문항 | 2.29회차 | 개념/효과분석형 | AI-BPR, 다크 팩토리, PMC vs PMO vs 감리, ISP vs ISMP, WBS/EVM, FP 대가산정 |
| **[Law/Gov] IT 법제도 · AI거버넌스 · 공공정책** | 9문항 | 8.8% | 6문항 | 3문항 | 2.86회차 | 개념/표준규격형 | 인공지능기본법(고영향 AI), NIST AI RMF, ISO/IEC 42001, 개인정보/데이터 안심구역, ISMS-P |

---
## 2. 제141회 대비 적중 예상 20선 (4단 서브노트 요약)

### [예상 01] 클라우드 네이티브 및 에이전틱 AI 환경에서 비인간 신원(NHI, Non-Human Identities)의 수명주기 거버넌스와 OWASP NHI Top 10 기반 보안 통제 방안
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[Sec] 정보보안 · 암호 · 개인정보보호` | `최우선 승격 (140회 1교시 → 서술형)`
- **출제 예측 근거**: 140회 1교시 비인간 신원(NHI) 단답 출제 + 에이전틱 AI/MCP 확산으로 머신 ID 보안이 최대 화두
- **권장 4단 목차**: 1. 리드문: 인간 신원(IAM)을 넘어선 비인간 신원(NHI) 급증 배경 → 2. NHI 공격 표면(API Key, OAuth Token, Service Account, AI Agent ID) 및 침투 경로도 → 3. OWASP NHI Top 10 주요 취약점(장기 시크릿, 과도한 권한, 안전하지 않은 CI/CD 등)과 기술적 통제 방안 → 4. SPIFFE/SPIRE 워크로드 ID 표준 및 Zero Trust 결합 거버넌스 제언
- **필수 채점 키워드**: `OWASP NHI Top 10, Secret Sprawl, 단기 수명 토큰(Ephemeral Token), SPIFFE/SPIRE, JIT 권한, 동적 시크릿 볼트`
- **모범 서브노트 해설**: 140회 1교시에 첫 등장한 비인간 신원(NHI)은 136회 MCP(1교시) → 137회 MCP 보안(2교시) 패턴과 동일하게 차기 회차 2~3교시 서술형으로 승격될 확률이 가장 높은 1순위 보안 토픽이다.

### [예상 02] 피지컬 AI(Physical AI) 구현을 위한 월드 모델(World Model)과 VLA(Vision-Language-Action) 아키텍처, 그리고 Sim-to-Real 격차 해소 및 안전성(Safety) 확보 방안
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[AI/Data] 인공지능 · 빅데이터 · 통계` | `최우선 승격 (140회 1교시 → 서술형)`
- **출제 예측 근거**: 140회 1교시 Physical AI 및 다크 팩토리 동시 출제 → 월드 모델(World Model) 및 VLA 아키텍처 심화 논술 임박
- **권장 4단 목차**: 1. 리드문: LLM을 넘어 물리 세계와 상호작용하는 Physical AI 정의 → 2. 센서 인지 → World Model(물리 시뮬레이션) → VLA 정책 네트워크 → 액추에이터 제어 구조도 → 3. 주요 기술 요소(World Model, VLA, 강화학습, Sim-to-Real Domain Randomization) 비교 → 4. ISO/IEC 25010(Safety) 및 기능 안전(ISO 26262) 연계 온디바이스 제어 제언
- **필수 채점 키워드**: `Physical AI, World Model, VLA(Vision-Language-Action), Sim-to-Real Gap, Domain Randomization, 온디바이스 NPU, 물리적 안전성(Safety)`
- **모범 서브노트 해설**: 140회 1교시에서 Physical AI와 다크 팩토리가 동시에 출제되었으므로, 차기 회차에서는 Physical AI의 내부 두뇌인 월드 모델(World Model)과 VLA 모델, 그리고 Sim-to-Real 학습 방법을 묻는 25점 서술형 문항을 반드시 대비해야 한다.

### [예상 03] 다중 에이전트 협업을 위한 A2A(Agent-to-Agent) 프로토콜과 MCP(Model Context Protocol) 비교
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[AI/Data] 인공지능 · 빅데이터 · 통계` | `신규 트렌드 1순위 (MCP 후속)`
- **출제 예측 근거**: 136회/137회 MCP(에이전트-도구 연결) 출제 완료 → 다중 에이전트 간 협업 표준 프로토콜 A2A 출제 임박
- **권장 4단 목차**: 1. 리드문: 멀티 에이전트 생태계 상호운용성을 위한 A2A와 MCP 정의 → 2. 사용자 ↔ 오케스트레이터 에이전트 ↔(A2A)↔ 원격 전문 에이전트 ↔(MCP)↔ 도구/DB 구조도 → 3. MCP(에이전트-도구 수직 연동) vs A2A(에이전트-에이전트 수평 협업) 상세 비교표 → 4. 엔터프라이즈 멀티 에이전트 시스템(MAS) 구축 시 보안·인증 고려사항
- **필수 채점 키워드**: `Agent-to-Agent(A2A), Agent Card(역할 명세), Task Lifecycle, MCP(Model Context Protocol), 수평적 협업 vs 수직적 도구 호출`
- **모범 서브노트 해설**: 제136회와 제137회에서 에이전트와 도구를 연결하는 MCP가 연속 출제되었으므로, 그 다음 단계인 이기종 에이전트 간 협업 프로토콜 A2A(Agent-to-Agent)와 MCP의 비교는 1교시 1순위 예상 토픽이다.

### [예상 04] 양자컴퓨터 위협(Harvest Now, Decrypt Later)에 대응하기 위한 양자내성암호(PQC: NIST 표준 및 KpqC) 전환 전략과 암호 민첩성(Crypto-Agility) 확보 방안
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[Sec] 정보보안 · 암호 · 개인정보보호` | `법·정책 직결 (PQC 전환 로드맵)`
- **출제 예측 근거**: 국가 양자내성암호(KpqC) 최종 선정 및 금융·공공 PQC 전환 가이드라인 발표 직결
- **권장 4단 목차**: 1. 리드문: 쇼어(Shor) 알고리즘에 의한 기존 공개키 암호(RSA/ECC) 붕괴 위험과 PQC → 2. 하이브리드 암호 전환(기존 ECC + PQC 이중 적용) 및 암호 민첩성(Crypto-Agility) 아키텍처도 → 3. 양자키분배(QKD, 물리계층) vs 양자내성암호(PQC: ML-KEM, ML-DSA, KpqC) 비교표 → 4. CBOM(암호자산 명세서) 구축 및 금융·공공 인프라 단계별 마이그레이션 로드맵
- **필수 채점 키워드**: `HNDL(선수집 후해독), Shor 알고리즘, 격자 기반 암호(ML-KEM/Kyber, ML-DSA/Dilithium), KpqC(HAETAE, NTRU+), CBOM(암호자산명세서), Crypto-Agility`
- **모범 서브노트 해설**: 135회 양자암호, 136회 ECC, 139회 QML에 이어 NIST PQC 표준(FIPS 203/204/205) 및 한국형 양자내성암호(KpqC) 선정 완료에 따른 CBOM(암호자산명세서) 및 암호 민첩성(Crypto-Agility) 구축 방안이 서술형으로 출제될 가능성이 매우 높다.

### [예상 05] 기존 벡터 기반 RAG의 전역적 추론(Global Query) 한계를 극복하기 위한 지식그래프 기반 GraphRAG 아키텍처와 하이브리드 구축 방안
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[AI/Data] 인공지능 · 빅데이터 · 통계` | `출제주기 도래 (GraphRAG 심화)`
- **출제 예측 근거**: 137회 GNN + 139회 Advanced/Modular RAG + 140회 하이브리드 검색의 융합 종착점
- **권장 4단 목차**: 1. 리드문: 단일 청크 유사도 검색의 한계와 전체 데이터셋 맥락 추론을 위한 GraphRAG → 2. 텍스트 추출 → 개체·관계 지식그래프 구축 → 계층적 커뮤니티 요약(Leiden 알고리즘) → Local/Global Search 구조도 → 3. Vector RAG vs GraphRAG vs Hybrid(Vector + Knowledge Graph) 비교표 → 4. 그래프 구축 토큰 비용 최적화 및 도메인 온톨로지 연계 방안
- **필수 채점 키워드**: `Knowledge Graph(지식그래프), 온톨로지, Multi-hop Reasoning(다중 홉 추론), Leiden 커뮤니티 탐지, Global Search vs Local Search`
- **모범 서브노트 해설**: 137회 GNN, 139회 Modular RAG, 140회 하이브리드 검색이 차례로 출제되면서, 벡터 검색과 지식그래프(온톨로지)를 결합해 다중 홉 추론과 전역 요약을 수행하는 GraphRAG가 차기 서술형 핵심 문제로 꼽힌다.

### [예상 06] LLM 추론(Inference) 성능 향상을 위한 Test-Time Compute Scaling과 추론 디코딩 가속 기법(Speculative Decoding)
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[AI/Data] 인공지능 · 빅데이터 · 통계` | `최신 트렌드 (Test-Time Compute)`
- **출제 예측 근거**: 추론 모델(Reasoning LLM) 확산에 따른 Test-Time Compute Scaling 및 추론 가속 기법 부상
- **권장 4단 목차**: 1. 리드문: 사전학습 스케일링에서 추론 시점 연산 스케일링(System 2 추론)으로의 진화 → 2. Test-Time Compute(CoT 탐색·검증기) 및 Speculative Decoding(소형 Draft 모델 + 대형 Target 모델 병렬 검증) 구조도 → 3. Pre-training Scaling vs Test-Time Scaling 및 일반 디코딩 vs 투기적 디코딩 비교 → 4. 추론 비용·지연시간 트레이드오프 관리 방안
- **필수 채점 키워드**: `System 2 Reasoning, Test-Time Compute Scaling, PRM(과정 보상 모델), Speculative Decoding(투기적 디코딩), Draft Model, KV Cache`
- **모범 서브노트 해설**: 140회 PagedAttention에 이어 LLM 추론 단계의 핵심 기술인 Test-Time Compute Scaling(추론 시점 연산 확장)과 Speculative Decoding(투기적 디코딩)은 1교시 신기술 단답형으로 가장 유력하다.

### [예상 07] 개발자 인지 부하(Cognitive Load) 감소를 위한 플랫폼 엔지니어링(Platform Engineering)과 내부 개발자 플랫폼(IDP, Internal Developer Platform) 구축 방안
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트` | `출제주기 도래 (플랫폼 엔지니어링)`
- **출제 예측 근거**: 135회 DevSecOps, 136회 DevOps 장단점, 139회 무중단 배포에 이은 차세대 개발 생산성 패러다임
- **권장 4단 목차**: 1. 리드문: "You build it, you run it"의 그늘(개발자 인지 부하 폭증)과 플랫폼 엔지니어링 → 2. IDP 5대 평면(개발자 포털 Backstage, 리소스 오케스트레이션, CI/CD, 관측가능성, 보안/정책) 아키텍처도 → 3. 전통 Ops vs DevOps vs SRE vs Platform Engineering 비교표 → 4. 황금 경로(Golden Path) 설계 및 Platform as a Product 운영 제언
- **필수 채점 키워드**: `인지 부하(Cognitive Load), IDP(Internal Developer Platform), Golden Path(황금 경로), 셀프서비스 포털(Backstage), Platform as a Product`
- **모범 서브노트 해설**: 136회 1교시에서 DevOps의 장단점(개발자 인프라 부담 과중)이 출제되었는데, 그 해결책으로 가트너가 선정한 플랫폼 엔지니어링(Platform Engineering)과 IDP(내부 개발자 플랫폼)가 2~3교시 아키텍처 문제로 승격될 차례다.

### [예상 08] 소프트웨어 공급망 보안을 위한 SBOM(Software Bill of Materials)과 AI 투명성을 위한 AIBOM(AI Bill of Materials) 비교
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[Sec] 정보보안 · 암호 · 개인정보보호` | `출제주기 도래 (SBOM & AIBOM)`
- **출제 예측 근거**: 오픈소스 및 오픈웨이트 AI 모델 공급망 보안 의무화 확산
- **권장 4단 목차**: 1. 리드문: SW 및 AI 모델 공급망 가시성 확보를 위한 명세서(BOM) 표준화 → 2. 소스코드/라이브러리(SBOM) + 학습데이터/기저모델/하이퍼파라미터(AIBOM) 구성 요소도 → 3. SBOM(SPDX, CycloneDX) vs AIBOM(모델 카드, 데이터 출처, 라이선스) 및 VEX(취약점 악용가능성 교환) 비교 → 4. CI/CD 및 MLOps 파이프라인 내 BOM 자동 생성·검증 체계
- **필수 채점 키워드**: `공급망 보안, SBOM, AIBOM, SPDX, CycloneDX, VEX(Vulnerability Exploitability eXchange), 데이터 포이즈닝 방지`
- **모범 서브노트 해설**: 기존 SW 공급망 보안의 핵심인 SBOM에 더해, 인공지능기본법 시행으로 AI 모델의 학습 데이터·기저 모델·가중치 구성을 명세하는 AIBOM(SPDX 3.0 AI 프로파일 / CycloneDX ML-BOM)과 VEX가 핵심 출제 포인트다.

### [예상 09] 데이터베이스 트랜잭션 격리 수준(ANSI SQL 4단계)별 이상 현상과 MVCC 기반 스냅샷 격리(Snapshot Isolation)의 Write Skew(쓰기 편향) 문제 및 해결 방안
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[DB] 데이터베이스 · 데이터모델링 · 분산데이터` | `출제주기 도래 (MVCC & 격리수준)`
- **출제 예측 근거**: 130회 병행제어, 137회 트랜잭션 격리수준에 이어 분산 환경 스냅샷 격리 및 이상현상 심화 대비
- **권장 4단 목차**: 1. 리드문: 동시성과 데이터 정합성의 트레이드오프 트랜잭션 격리 수준 → 2. Read Uncommitted ~ Serializable 4단계와 MVCC Undo 스냅샷 읽기 메커니즘 → 3. 격리 수준별 발생 이상 현상(Dirty Read, Non-repeatable Read, Phantom Read, Write Skew) 매트릭스 표 → 4. SSI(Serializable Snapshot Isolation) 및 SELECT FOR UPDATE 기반 정합성 보장 방안
- **필수 채점 키워드**: `ANSI Isolation Level, Dirty Read, Non-repeatable Read, Phantom Read, Snapshot Isolation(SI), Write Skew(쓰기 편향), SSI`
- **모범 서브노트 해설**: 전통적인 ANSI 4단계 격리수준 표에 더해, 현대 RDBMS가 사용하는 MVCC 스냅샷 격리(Snapshot Isolation) 환경에서 발생하는 교차 쓰기 이상 현상(Write Skew)과 이를 해결하는 SSI(Serializable Snapshot Isolation)까지 서술하면 차별화된 고득점 답안이 된다.

### [예상 10] 클라우드 기반 네트워크·보안 융합 아키텍처 SASE(Secure Access Service Edge)와 SSE(Security Service Edge)
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[NW/Cloud] 네트워크 · 클라우드 · 차세대통신` | `출제주기 도래 (SASE & SSE)`
- **출제 예측 근거**: 클라우드 전환 및 원격근무·N2SF 환경에서 네트워크와 보안의 융합 아키텍처
- **권장 4단 목차**: 1. 리드문: 레거시 중앙 백홀(Backhaul) 네트워크의 한계와 SASE/SSE 등장 배경 → 2. WAN Edge(SD-WAN) + Security Service Edge(SWG, CASB, ZTNA, FWaaS) 결합 구조도 → 3. SASE vs SSE 구성요소 비교 및 핵심 보안 기능 설명 → 4. 단일 벤더 vs 듀얼 벤더 SASE 도입 시 고려사항
- **필수 채점 키워드**: `SASE, SSE(Security Service Edge), SD-WAN, ZTNA, CASB, SWG(보안웹게이트웨이), FWaaS, DLP`
- **모범 서브노트 해설**: 제로트러스트 및 국가 망 보안체계(N2SF)를 실제 클라우드 네트워크에서 구현하는 대표 아키텍처인 SASE와 SSE의 구성요소(SD-WAN + ZTNA, CASB, SWG, FWaaS)는 1교시 및 3교시 단골 출제 후보다.

### [예상 11] 소프트웨어 개발 사업의 적정 대가 산정을 위한 기능점수(FP, Function Point) 산정 방식(정통법 vs 간이법)과 AI 도입 프로젝트의 비용 산정 및 과업 변경 관리 방안
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[ITBiz/PM] 프로젝트관리 · IT경영 · 감리 · BPR` | `출제주기 도래 (SW 사업 대가산정 & AI FP)`
- **출제 예측 근거**: 생성형 AI 도입 사업 확산에 따른 SW 사업 대가산정 가이드(기능점수 FP 및 AI 서비스 산정) 실무 이슈
- **권장 4단 목차**: 1. 리드문: SW 제값주기와 과업 범위 분쟁 예방을 위한 기능점수(FP) 산정 체계 → 2. 데이터 기능(ILF, EIF) + 트랜잭션 기능(EI, EO, EQ) 식별 및 보정 후 개발원가 산출 구조도 → 3. 정통법(IFPUG) vs 간이법(평균복잡도) 비교 및 AI 모델 도입 사업(데이터 구축·학습·튜닝) 대가 산정 기준 → 4. 과업심의위원회 의무화 및 애자일·클라우드 사업 계약 제도 개선 제언
- **필수 채점 키워드**: `기능점수(FP), 데이터 기능(ILF/EIF), 트랜잭션 기능(EI/EO/EQ), 정통법 vs 간이법, 과업심의위원회, AI 학습용 데이터 대가산정`
- **모범 서브노트 해설**: 공공·금융 정보화 사업 관리(ISMP/PMO/감리)에서 가장 빈번하게 출제되는 주제가 기능점수(FP: ILF, EIF, EI, EO, EQ) 산정과 소프트웨어진흥법상 과업심의위원회를 통한 과업 변경 관리다.

### [예상 12] 리눅스 커널 샌드박스 기술 eBPF(extended Berkeley Packet Filter)의 동작 원리와 클라우드 네이티브(네트워크·관측가능성·보안) 활용
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[CA/OS] 컴퓨터구조 · 운영체제 · 양자컴퓨팅` | `출제주기 도래 (eBPF & BPFdoor 연관)`
- **출제 예측 근거**: 137회 4교시 BPFdoor 악성코드 출제 → 기저 커널 기술인 eBPF의 클라우드 네이티브 관측·보안 활용 출제 유력
- **권장 4단 목차**: 1. 리드문: 커널 소스 수정 없이 커널 공간에서 안전하게 프로그램을 실행하는 eBPF → 2. User Space(바이트코드 컴파일) → eBPF Verifier(안전성 검증) → JIT 컴파일러 → Kernel Hook(kprobe/XDP) 구조도 → 3. 기존 커널 모듈(LKM) vs 사이드카 프록시(Sidecar) vs eBPF(Sidecarless) 비교 → 4. Cilium(네트워크/보안), Falco(런타임 보안) 활용 및 BPFdoor 등 커널 루트킷 방어 방안
- **필수 채점 키워드**: `eBPF, Verifier(검증기), JIT Compiler, XDP(eXpress Data Path), kprobe/tracepoint, Sidecarless Service Mesh(Cilium)`
- **모범 서브노트 해설**: 137회 4교시에 eBPF를 악용한 BPFdoor가 출제되었으므로, 정방향 핵심 기술인 eBPF의 구조(Verifier, JIT, XDP, Maps)와 쿠버네티스 사이드카리스 서비스 메시(Cilium) 활용은 1교시/2교시 핵심 예상 토픽이다.

### [예상 13] 가설검정에서의 제1종 오류(α)와 제2종 오류(β), 유의수준(p-value)과 검정력(Power, 1-β)의 관계
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[AI/Data] 인공지능 · 빅데이터 · 통계` | `매회 필수 (통계/추론 파트)`
- **출제 예측 근거**: 131회 t-검정, 132회 점/구간추정, 135회 불편추정량, 139회 중심극한정리, 140회 잭나이프에 이은 통계 필수 토픽
- **권장 4단 목차**: 1. 리드문: 통계적 의사결정의 불확실성 통제를 위한 가설검정 오류 체계 → 2. 귀무가설(H0) 참/거짓에 따른 제1종 오류(α, 위양성) vs 제2종 오류(β, 위음성) 분포도 → 3. 제1종 오류(α) vs 제2종 오류(β) 및 검정력(1-β) 트레이드오프 비교표 → 4. 다중 가설검정 시 본페로니 교정(Bonferroni) 및 표본 크기(n) 확대를 통한 동시 감소 방안
- **필수 채점 키워드**: `귀무가설(H0), 대립가설(H1), 제1종 오류(α, 유의수준), 제2종 오류(β), 검정력(Statistical Power = 1-β), p-value, 표본 크기(n)`
- **모범 서브노트 해설**: 정보관리기술사 1교시에는 매 회차 통계학 문제가 1~2문항씩 빠짐없이 출제된다. 표본 크기 n이 고정된 상태에서 α를 줄이면 β가 커지는 상충관계와, 두 오류를 동시에 줄여 검정력(1-β)을 높이는 유일한 방법이 표본 크기(n) 확대임을 명확히 서술해야 한다.

### [예상 14] 마이크로서비스(MSA) 환경에서 장애 전파 차단을 위한 회복탄력성(Resiliency) 디자인 패턴(Circuit Breaker, Bulkhead, Retry with Exponential Backoff, Rate Limiter) 설명
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트` | `출제주기 도래 (클라우드 디자인 패턴)`
- **출제 예측 근거**: 대규모 MSA 및 AI API 연동 환경에서 장애 전파(Cascading Failure) 방지를 위한 회복탄력성 아키텍처
- **권장 4단 목차**: 1. 리드문: 분산 시스템의 부분 장애가 전체 시스템 붕괴로 이어지는 연쇄 장애(Cascading Failure) 방지 → 2. 서킷 브레이커 상태 전이도(Closed → Open → Half-Open) 및 벌크헤드(스레드/커넥션 풀 격리) 구조도 → 3. 4대 회복탄력성 패턴(Circuit Breaker, Bulkhead, Exponential Backoff + Jitter, Fallback) 비교표 → 4. 서비스 메시(Istio) 및 카오스 엔지니어링(Chaos Engineering) 기반 장애 복원력 검증 제언
- **필수 채점 키워드**: `Cascading Failure(연쇄 장애), Circuit Breaker(Closed/Open/Half-Open), Bulkhead(격벽 패턴), Exponential Backoff with Jitter, Chaos Engineering`
- **모범 서브노트 해설**: 138회 3교시 고가용성(HA/FTS) 및 클라우드 네이티브 전환에 이어, 소프트웨어 아키텍처 수준에서 장애 격리와 자가 치유를 달성하는 회복탄력성(Resiliency) 패턴과 카오스 엔지니어링은 2교시 서술형 정통 대비 토픽이다.

### [예상 15] 전자정부법 및 정보통신망법상 디지털서비스 안정성 확보를 위한 장애 관리 체계와 카오스 엔지니어링(Chaos Engineering)
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[Law/Gov] IT 법제도 · AI거버넌스 · 공공정책` | `법·제도 직결 (디지털 서비스 안전)`
- **출제 예측 근거**: 공공·금융 대형 IT 장애 재발 방지 대책 및 디지털서비스 안정성 강화 제도
- **권장 4단 목차**: 1. 리드문: 초연결 사회의 디지털 블랙아웃 방지와 시스템 회복탄력성(Resilience) 의무화 → 2. 예방(이중화/용량산정) → 대비(모의훈련/Chaos Engineering) → 대응(트래픽 우회/DR) → 복구(RCA) 구조도 → 3. 고가용성(HA: Active-Active/Standby) vs 재해복구(DR: Mirror/Hot/Warm/Cold Site) 비교 (RTO/RPO) → 4. 변경관리(작업 시간대 분리·Canary 배포) 및 다중 리전 액티브-액티브 전환 제언
- **필수 채점 키워드**: `RTO(목표복구시간), RPO(목표복구시점), Multi-Region Active-Active, 카오스 엔지니어링(Fault Injection), 변경관리 거버넌스`
- **모범 서브노트 해설**: 137회 3교시 Multi-Region Active-Active DR과 138회 4교시 공공망 인프라 신뢰성 확보 방안에 이어, RTO/RPO 기준과 프로덕션 환경에 의도적 장애를 주입해 복원력을 검증하는 카오스 엔지니어링의 결합이 중요하다.

### [예상 16] 기계 언러닝(Machine Unlearning, 기계 망각)의 개념과 Exact Unlearning vs Approximate Unlearning 기법 비교
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[AI/Data] 인공지능 · 빅데이터 · 통계` | `신규 트렌드 (Machine Unlearning)`
- **출제 예측 근거**: 생성형 AI의 개인정보 잊힐 권리(Right to be Forgotten) 및 저작권 오염 데이터 제거 기술
- **권장 4단 목차**: 1. 리드문: AI 모델의 잊힐 권리(GDPR/개인정보보호법) 보장을 위한 Machine Unlearning → 2. 전체 재학습(Retraining) 없이 특정 데이터 영향만 제거하는 SISA 및 가중치 보정 구조도 → 3. Exact Unlearning(SISA 등 분할 학습) vs Approximate Unlearning(경사 상승/영향 함수) 비교 → 4. 멤버십 추론 공격(MIA) 기반 망각 검증 및 LLM 가드레일과의 상호보완 방안
- **필수 채점 키워드**: `잊힐 권리(Right to be Forgotten), Machine Unlearning, SISA(Sharded, Isolated, Sliced, Aggregated), Exact vs Approximate Unlearning`
- **모범 서브노트 해설**: 개인정보보호위원회의 AI 프라이버시 가이드라인과 유럽 GDPR의 잊힐 권리 요구에 따라, 수천억 파라미터 LLM을 처음부터 재학습하지 않고 특정 개인정보·저작권 데이터만 선택적으로 지우는 Machine Unlearning이 유력한 1교시 토픽이다.

### [예상 17] 레거시 시스템의 클라우드 네이티브 애플리케이션 현대화(Application Modernization)를 위한 7R 마이그레이션 전략과 점진적 전환 패턴(Strangler Fig, Change Data Capture)
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트` | `출제주기 도래 (레거시 현대화 & 7R)`
- **출제 예측 근거**: 138회 2교시 재공학/역공학 및 클라우드 네이티브 전환에 이은 애플리케이션 현대화 전략
- **권장 4단 목차**: 1. 리드문: 빅뱅(Big-Bang) 방식 차세대 프로젝트의 실패 위험 극복을 위한 점진적 현대화 → 2. API 게이트웨이/파사드 기반 교살자 무화과(Strangler Fig) 및 Outbox/CDC 데이터 동기화 구조도 → 3. 가트너/AWS 7R 마이그레이션 전략(Rehost, Relocate, Replatform, Refactor, Repurchase, Retire, Retain) 비교표 → 4. 도메인 주도 설계(DDD) 이벤트 스토밍 기반 바운디드 컨텍스트 분리 제언
- **필수 채점 키워드**: `Application Modernization, 7R 전략, Strangler Fig Pattern(교살자 무화과 패턴), Anti-Corruption Layer(부패방지계층), CDC/Outbox 패턴, DDD`
- **모범 서브노트 해설**: 138회 2교시에서 역공학·재공학과 클라우드 네이티브 TA/AA 역할이 출제되었으므로, 실제 모놀리식 레거시를 무중단으로 MSA로 분해하는 Strangler Fig 패턴, 부패방지계층(ACL), Outbox/CDC 패턴의 결합은 2~3교시 최적의 주제다.

### [예상 18] 데이터 레이크하우스(Data Lakehouse: Iceberg/Delta Lake)와 Zero-ETL 아키텍처
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[DB] 데이터베이스 · 데이터모델링 · 분산데이터` | `신규 트렌드 (Zero-ETL & Lakehouse)`
- **출제 예측 근거**: OLTP와 OLAP/AI 파이프라인 간 배치 ETL 지연을 제거하는 최신 데이터 아키텍처
- **권장 4단 목차**: 1. 리드문: DW의 정합성(ACID)과 Data Lake의 저비용 유연성을 결합한 Lakehouse 및 Zero-ETL → 2. 오픈 테이블 포맷(Apache Iceberg/Delta Lake/Hudi) 메타데이터 계층 및 Zero-ETL 실시간 복제 구조도 → 3. Data Warehouse vs Data Lake vs Data Lakehouse 비교표 → 4. 실시간 RAG/AI 피처 공급을 위한 스트리밍 레이크하우스 구축 방안
- **필수 채점 키워드**: `Data Lakehouse, 오픈 테이블 포맷(Apache Iceberg, Delta Lake, Apache Hudi), ACID 트랜잭션, Time Travel(시간여행 쿼리), Schema Evolution, Zero-ETL`
- **모범 서브노트 해설**: 기존 DW와 데이터 레이크의 이중 적재 비용과 ETL 지연을 해결하는 오픈 테이블 포맷(Apache Iceberg, Delta Lake) 기반 데이터 레이크하우스와 Zero-ETL은 데이터 엔지니어링 파트의 핵심 출제 후보다.

### [예상 19] 클라우드 네이티브 애플리케이션 보호 플랫폼 CNAPP(Cloud-Native Application Protection Platform)의 개념과 구성요소(CSPM, CWPP, CIEM, KSPM)
- **예상 교시 / 도메인**: `1교시 단답·용어형 (10점)` | `[Sec] 정보보안 · 암호 · 개인정보보호` | `출제주기 도래 (CNAPP)`
- **출제 예측 근거**: 클라우드 네이티브 환경의 파편화된 보안 도구를 개발~런타임 전주기로 통합한 플랫폼
- **권장 4단 목차**: 1. 리드문: 멀티클라우드·컨테이너 전주기(Shift-Left ~ Runtime) 통합 보안 플랫폼 CNAPP → 2. 개발(IaC 스캐닝/SBOM) → 배포(레지스트리 검증) → 운영(CSPM + KSPM + CIEM + CWPP) 통합 아키텍처도 → 3. CNAPP 4대 핵심 축(CSPM, CWPP, CIEM, KSPM) 비교표 → 4. 공격 경로 분석(Attack Path Analysis) 및 CTEM 연계 운영 방안
- **필수 채점 키워드**: `CNAPP, CSPM(클라우드 보안 형상 관리), CWPP(클라우드 워크로드 보호), CIEM(클라우드 인프라 권한 관리), KSPM(쿠버네티스 보안), Shift-Left`
- **모범 서브노트 해설**: 개별적으로 출제되던 CSPM(형상관리), CWPP(워크로드 보호), CIEM(권한관리)을 하나의 플랫폼으로 통합해 컨텍스트 기반 공격 경로(Attack Path)를 분석하는 CNAPP은 클라우드 보안 필수 토픽이다.

### [예상 20] 생성형 AI 및 고영향 AI 시스템의 신뢰성·안전성 검증을 위한 AI 레드티밍(AI Red Teaming) 수행 절차와 정량적 평가 지표(RAGAS, LLM-as-a-Judge) 구축 방안
- **예상 교시 / 도메인**: `2~4교시 서술형 (25점)` | `[Law/Gov] IT 법제도 · AI거버넌스 · 공공정책` | `출제주기 도래 (AI 레드티밍 & 안전성 평가)`
- **출제 예측 근거**: 137회 AI 신뢰성 검인증(CAT), 138회 AI RMF/인공지능기본법에 이은 구체적 AI 검증 방법론
- **권장 4단 목차**: 1. 리드문: 확률적 생성형 AI의 예측 불가능한 위험 검증을 위한 AI 레드티밍과 자동 평가 체계 → 2. 위협 모델링 → 적대적 공격 시나리오(탈옥/편향/CBRN/환각) 생성 → 자동·수동 레드티밍 → 가드레일 보강 구조도 → 3. RAG 파이프라인 정량 평가 프레임워크 RAGAS 4대 지표(Context Precision, Context Recall, Faithfulness, Answer Relevancy) 비교표 → 4. LLM-as-a-Judge의 편향(위치·길이 편향) 보정 및 지속적 AI 품질 보증(LLMOps) 제언
- **필수 채점 키워드**: `AI Red Teaming, 적대적 프롬프트(Jailbreak), RAGAS(Faithfulness, Answer Relevancy, Context Precision/Recall), LLM-as-a-Judge, AI 안전연구소`
- **모범 서브노트 해설**: 인공지능기본법과 CAT(AI 신뢰성 검인증)에서 요구하는 안전성·신뢰성을 실무에서 어떻게 측정할 것인가에 대한 해답으로, 적대적 취약점을 검증하는 AI 레드티밍(AI Red Teaming)과 RAG 정량 평가 지표인 RAGAS(Faithfulness, Relevancy, Context Precision/Recall)를 함께 제시하면 최고 수준의 답안이 된다.
