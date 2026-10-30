import os
import json
import sqlite3
from collections import Counter

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(PROJECT_DIR, 'data')
PUBLIC_DIR = os.path.join(PROJECT_DIR, 'public')

os.makedirs(DATA_DIR, exist_ok=True)
os.makedirs(PUBLIC_DIR, exist_ok=True)

DB_PATH = os.path.join(DATA_DIR, 'itpe_exam.db')
SQL_DUMP_PATH = os.path.join(DATA_DIR, 'schema_and_data.sql')
JSON_EXPORT_PATH = os.path.join(DATA_DIR, 'itpe_rdb_export.json')

# 1. 시행 회차 메타데이터 (제120회 ~ 제140회, 2020년 ~ 2026년, 총 21개 회차)
EXAM_ROUNDS = [
    (120, '제120회 (2020년 2월)', 2020, '2020-02-22', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '데이터 3법 개정, 클라우드 전환 초기, 애자일/MSA, 딥러닝 기반 기술'),
    (121, '제121회 (2020년 6월)', 2020, '2020-06-20', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '비대면 보안(ZTNA 초기), 컨테이너/K8s, 분산 DB, SW 안전성 분석'),
    (122, '제122회 (2020년 8월)', 2020, '2020-08-22', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '세마포어와 모니터, 인슈어테크, LOD, 하이퍼바이저, 디지털 뉴딜'),
    (123, '제123회 (2021년 1월)', 2021, '2021-01-30', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '마이데이터, MLOps 초기, 클라우드 네이티브 아키텍처, ISMS-P'),
    (124, '제124회 (2021년 5월)', 2021, '2021-05-15', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '가치사슬 ERP/SCM/MES/CRM 비교, 통계 4대 척도, 디지털 휴먼증강'),
    (125, '제125회 (2021년 7월)', 2021, '2021-07-31', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'ISMP 방법론 체계, EVM(획득가치관리), TOCTOU 보안 약점, 연합학습'),
    (126, '제126회 (2022년 1월)', 2022, '2022-01-29', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '메타휴리스틱, Race Condition, SNN, CAP 한계와 PACELC 이론'),
    (127, '제127회 (2022년 4월)', 2022, '2022-04-16', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'ModelOps, 불편 추정량, BSC 구성요소, MAC, 테스트/코드 커버리지'),
    (128, '제128회 (2022년 7월)', 2022, '2022-07-30', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'WBS, IT-ROI, 품질비용 4항목, NoSQL 3대 구조, 아키텍처 평가 CBAM'),
    (129, '제129회 (2023년 2월)', 2023, '2023-02-04', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '디지털플랫폼정부, AI 윤리기준 3대 원칙/10대 요건, AOP, 감리 vs PMO, K-Means vs DBSCAN'),
    (130, '제130회 (2023년 5월)', 2023, '2023-05-13', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '노코드, DB 병행제어, 데이터 거버넌스, 6G, VXLAN, 머신러닝 최적화, ISMP, AHP, ISO 21500'),
    (131, '제131회 (2023년 8월)', 2023, '2023-08-19', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '디지털 트랜스포메이션, 폭포수 vs 애자일, 차원축소, 감리 vs PMO, 독립/대응 t-검정, 파운데이션 모델'),
    (132, '제132회 (2024년 1월)', 2024, '2024-01-27', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'ISO 31000, 베이지안 최적화, ISA/IEC 62443, 큐싱, ELK, TPM, 다중공선성, 분산DB 5대 투명성, SVM 마진'),
    (133, '제133회 (2024년 5월)', 2024, '2024-05-18', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'REST API, 뮤테이션 테스트, NoSQL 모델링, 전자봉투, 동형암호, 기술수용모델(TAM), CRUD 매트릭스'),
    (134, '제134회 (2024년 7월)', 2024, '2024-07-27', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '생성형 AI 할루시네이션 대응, 제로트러스트 아키텍처, 클라우드 FinOps, 데이터 패브릭 vs 데이터 메시'),
    (135, '제135회 (2025년 2월)', 2025, '2025-02-08', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'PR/ROC 곡선, Multimodal LLM, 요구사항 추적표(RTM), IBN, SIEM vs SOAR, 실루엣 계수, 반정규화, DevSecOps'),
    (136, '제136회 (2025년 5월)', 2025, '2025-05-17', 'https://www.q-net.or.kr/cst006.do?id=cst00601', '범용 AI 위험관리, Agentic AI, 제4정규형, Proxy 패턴, CXL, 서버리스, 개인정보/데이터 안심구역, ECC, MCP'),
    (137, '제137회 (2025년 8월)', 2025, '2025-08-23', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'IGP/EGP, 포렌식 아티팩트, MODBUS, GNN, Transformer & MoE, AI 검인증(CAT), MCP 보안, N2SF, BPFdoor, HNSW/IVF'),
    (138, '제138회 (2026년 2월)', 2026, '2026-02-07', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'NIST AI RMF, ISO/IEC 42001, 데이터 관측가능성, TTPs, 프롬프트 인젝션, 모델 전도 공격, GPU vs TPU, 인공지능기본법, PET, 6G AI-Native, RaaS'),
    (139, '제139회 (2026년 5월)', 2026, '2026-05-16', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'Advanced/Modular RAG, 대수의 법칙과 중심극한정리, 무중단 배포, 맥케이브 순환복잡도, Wi-Fi 7, CTEM, QML(양자머신러닝), 가명처리, RLHF/RAFT'),
    (140, '제140회 (2026년 8월)', 2026, '2026-08-22', 'https://www.q-net.or.kr/cst006.do?id=cst00601', 'AI 기반 BPR, 다크 팩토리, ATAM, PMC vs PMO, ISO/IEC 25010, 하이브리드 검색(Lexical+Vector), 잭나이프, 좀비 프로세스, Physical AI, 비인간 신원(NHI)')
]

# 2. 카테고리2: 교시 및 배점/답안 구조 분류
CATEGORIES_PERIOD = [
    (1, 'P1_SHORT', '1교시 단답·용어형 (10점)', 10, 10, '13문항 중 10문항 선택 · 답안지 1페이지(약 22~25줄) 내외로 정의, 개념도, 핵심 특징/구성요소, 미니 비교표를 압축 서술'),
    (2, 'P2_ARCH', '2교시 서술형 - 아키텍처·설계·비교 (25점)', 25, 25, '6문항 중 4문항 선택 · 답안지 2.5~3페이지 분량으로 배경, 아키텍처/메커니즘, 기술 비교, 실무 고려사항을 구조적 서술'),
    (3, 'P3_OPS', '3교시 서술형 - 운영·관리·보안 시나리오 (25점)', 25, 25, '6문항 중 4문항 선택 · 현업 장애/보안 사고 대응, 데이터베이스·인프라 운영 전환, 감리/프로젝트 관리 시나리오 중심 서술'),
    (4, 'P4_POLICY', '4교시 서술형 - 법제도·거버넌스·최신융합 (25점)', 25, 25, '6문항 중 4문항 선택 · 인공지능기본법, N2SF, AI 거버넌스, 6G/양자 등 거시 정책 및 미래 기술 통찰(Insight) 중심 논술')
]

# 3. 카테고리1: 8대 핵심 기술 도메인
CATEGORIES_DOMAIN = [
    (1, 'AI_DATA', '[AI/Data] 인공지능 · 빅데이터 · 통계', 'LLM, RAG(Advanced/Modular), Agentic/Physical AI, MoE, GNN, MLOps, 파인튜닝/RLHF/RAFT, 추정/검정/다중공선성/잭나이프'),
    (2, 'SW_ARCH', '[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트', 'MSA, 무중단 배포, ATAM/CBAM, ISO/IEC 25010, 맥케이브 순환복잡도, 뮤테이션/동적 테스트, 리팩토링/역공학, DevSecOps'),
    (3, 'SEC', '[Sec] 정보보안 · 암호 · 개인정보보호', '제로트러스트, 국가망보안체계(N2SF), CTEM, 비인간 신원(NHI), 프롬프트 인젝션/MCP 보안, 동형/양자/타원곡선 암호, PET/가명처리, 포렌식/BPFdoor'),
    (4, 'DB', '[DB] 데이터베이스 · 데이터모델링 · 분산데이터', '분산 DB 투명성/분할, 트랜잭션 격리수준/병행제어, 제4정규형/반정규화, NoSQL, 벡터DB(HNSW/IVF)/하이브리드 검색, 데이터 거버넌스/관측가능성'),
    (5, 'NW_CLOUD', '[NW/Cloud] 네트워크 · 클라우드 · 차세대통신', '6G AI-Native Network, Wi-Fi 7, IGP/EGP 동적 라우팅, IBN, 맨체스터 부호화, VXLAN, 멀티클라우드/서버리스/엣지 컴퓨팅, 고가용성(HA/DR)'),
    (6, 'CA_OS', '[CA/OS] 컴퓨터구조 · 운영체제 · 양자컴퓨팅', 'GPU vs TPU 아키텍처, CXL, 캐시 메모리 쓰기 정책, OS 메모리 구조(Code/Data/Heap/Stack), 좀비 프로세스/세그먼테이션 오류, 은행가 알고리즘/세마포어, QML'),
    (7, 'ITBIZ_PM', '[ITBiz/PM] 프로젝트관리 · IT경영 · 감리 · BPR', 'ISP vs ISMP, PMO vs PMC vs 감리, WBS/EVM/부정적 위험 대응, ISO 21500/31000, AI 기반 BPR, 다크 팩토리, SLA/IT-ROI/BSC'),
    (8, 'LAW_GOV', '[Law/Gov] IT 법제도 · AI거버넌스 · 공공정책', '인공지능기본법, NIST AI RMF, ISO/IEC 42001, AI 신뢰성 검인증(CAT), 생성형 AI 이용자 보호 가이드라인, 디지털플랫폼정부, ISMS-P, 데이터 안심구역')
]

# 4. 대표 기출문제 마스터 데이터셋 (제120회 ~ 제140회 실제 기출 토픽 + 4단 서브노트 정밀 해설)
# 각 튜플: (round_id, period_id, q_no, domain_id, format_type, header, sub_prompts, outline_list, keywords, comp_headers, comp_rows, answer_body, escalation_note)
RAW_QUESTIONS = [
    # --- 제140회 (2026년 8월) ---
    (140, 1, 1, 7, '개념/효과분석형', 'AI 기반의 업무 프로세스 재설계(AI-BPR) 도입 효과',
     ['1. AI-BPR의 개념과 전통적 BPR과의 차이점', '2. 프로세스 마이닝 및 에이전틱 AI 결합 구조', '3. 도입 효과 및 성공적 정착을 위한 고려사항'],
     ['1. 리드문: AI-BPR의 정의 및 등장 배경', '2. AI-BPR 핵심 아키텍처 (프로세스 마이닝 + LLM/Agent)', '3. 전통적 BPR vs AI 기반 BPR 비교', '4. 도입 기대효과 및 거버넌스 제언'],
     '프로세스 마이닝, Agentic AI, Hyperautomation, 이벤트 로그, 병목 탐지, 디지털 트윈(DTO)',
     ['비교 항목', '전통적 BPR', 'AI 기반 BPR (AI-BPR)'],
     [['분석 방식', '인터뷰·워크숍 기반 정적 As-Is 분석', 'ERP/시스템 이벤트 로그 기반 실시간 프로세스 마이닝'],
      ['재설계 주체', '컨설턴트 경험 의존 수동 To-Be 설계', '생성형/에이전틱 AI 기반 시뮬레이션 및 자율 최적화'],
      ['개선 주기', '대규모 일회성 프로젝트 (3~5년 주기)', '상시적·지속적 자율 개선 (Continuous Intelligence)']],
     'AI-BPR은 기업 내 시스템 이벤트 로그를 수집하는 프로세스 마이닝(Process Mining)과 자율 의사결정을 수행하는 에이전틱 AI를 결합하여 업무 프로세스를 상시 진단·재설계하는 기법이다. 도입 시 리드타임 단축, 예외 처리 자동화, 데이터 기반 병목 제거 효과를 얻으며, 인간 검토 루프(HITL)와 변화관리가 필수적이다.',
     '136회 1교시 에이전틱 AI → 140회 1교시 AI-BPR로 실무 프로세스 융합 출제'),

    (140, 1, 2, 7, '개념/구성요소형', '다크 팩토리(Dark Factory)',
     ['1. 다크 팩토리(무인 자동화 공장)의 개념', '2. 핵심 구성 기술 (Physical AI, CPS, 디지털 트윈, 5G/6G 특화망)'],
     ['1. 리드문: 다크 팩토리(Lights-out Manufacturing) 정의', '2. 다크 팩토리 4계층 기술 구성도', '3. 핵심 구현 기술 (Physical AI, 디지털 트윈, AMR, OT보안)', '4. 도입 시 문제점(OT 보안, 초기 투자비) 및 기술사적 제언'],
     'Lights-out Factory, Physical AI, CPS(가상물리시스템), 디지털 트윈, AMR, ISA/IEC 62443',
     ['계층 구분', '핵심 기술 요소', '주요 역할'],
     [['현장 실행 계층', 'Physical AI 로봇, AMR, 스마트 센서', '작업자 조명 없이 24시간 무인 조립·이송·검사'],
      ['통신·제어 계층', '5G 특화망(이음5G), TSN, PLC/SCADA', '초저지연·초고신뢰 실시간 설비 제어'],
      ['관제·최적화 계층', '디지털 트윈, 예지보전(PHM), AI 자율 스케줄링', '가상 시뮬레이션 기반 무중단 자율 운영 및 고장 예측']],
     '다크 팩토리(Dark Factory)는 불을 꺼놓아도(Lights-out) 작업자 없이 로봇과 AI 자율 제어만으로 24시간 가동되는 완전 무인 스마트 공장을 의미한다. 최근 Physical AI와 디지털 트윈의 결합으로 유연 다품종 생산까지 확장되고 있으며, OT 망 보안(ISA/IEC 62443) 및 AI 오작동 안전장치가 핵심 고려사항이다.',
     '차기 회차 스마트 제조/OT 보안 융합 2~3교시 서술형 승격 유력'),

    (140, 1, 3, 2, '절차/평가모델형', 'ATAM(Architecture Trade-off Analysis Method)',
     ['1. 소프트웨어 아키텍처 평가 기법 ATAM의 정의', '2. 4단계 9스텝 수행 절차 및 민감점(Sensitivity Point)과 타협점(Trade-off Point)'],
     ['1. 리드문: SEI ATAM의 개념 및 평가 목적', '2. ATAM 4단계(준비-초기평가-심층평가-보고) 절차도', '3. 핵심 요소 (품질속성 유틸리티 트리, 민감점, 타협점, 위험점)', '4. SAAM · ATAM · CBAM 비교 및 실무 적용 방안'],
     'SEI, 품질속성 시나리오, 유틸리티 트리(Utility Tree), 민감점(Sensitivity), 타협점(Trade-off), CBAM',
     ['구분', 'SAAM', 'ATAM', 'CBAM'],
     [['평가 초점', '변경성(Modifiability) 및 기능 적합성', '복수 품질속성 간 상충관계(Trade-off) 분석', '아키텍처 전략의 경제적 비용·효익(ROI) 분석'],
      ['핵심 산출물', '시나리오-컴포넌트 매핑', '유틸리티 트리, 민감점·타협점 도출', '기대효용 대비 비용 비율(ROI) 우선순위']],
     'ATAM은 미국 카네기멜론대 SEI에서 제안한 아키텍처 평가 기법으로, 성능·보안·가용성 등 상충하는 품질속성(Quality Attributes) 간의 트레이드오프 지점을 유틸리티 트리(Utility Tree) 기반으로 도출한다. 아키텍처 결정이 하나의 품질속성에 미치는 민감점(Sensitivity Point)과 여러 속성에 동시 영향을 주는 타협점(Trade-off Point)을 식별하여 설계 리스크를 조기 완화한다.',
     '128회 1교시 CBAM 출제 이후 아키텍처 평가 시리즈 주기적 순환 출제'),

    (140, 1, 4, 7, '비교/대조분석형', 'PMC(Project Management Consultancy)와 PMO(Project Management Office) 비교',
     ['1. PMC와 PMO의 개념 및 도입 목적', '2. 권한, 수행 주체, 적용 사업 관점의 차이점 비교'],
     ['1. 리드문: 대형 IT 사업 관리 체계로서의 PMC와 PMO 정의', '2. 발주자-PMO-감리-수행사 거버넌스 구조도', '3. PMC vs PMO 세부 비교표 (목적, 법적근거, 권한, 수행방식)', '4. 공공·금융 차세대 프로젝트 성공을 위한 하이브리드 운영 제언'],
     '발주자 지원, 의사결정 대행, 전자정부법, 상시 조직 vs 외부 전문용역, 정보시스템 감리',
     ['비교 항목', 'PMC (Project Management Consultancy)', 'PMO (Project Management Office)'],
     [['핵심 개념', '외부 전문 컨설팅사가 발주자를 대행/자문하는 프로젝트 관리 용역', '조직 내·외부에서 프로젝트 표준·일정·품질을 통합 통제하는 관리 조직'],
      ['도입 형태', '대규모 사업 시 외부 전문기업 위탁 계약 중심', '내부 상설 조직(EPMO) 또는 공공사업 외부 전문 PMO 위탁'],
      ['주요 역할', '사업 기획·발주·기술자문·계약관리 전문 컨설팅', '범위·일정·위험·의사소통 통합 관리 및 거버넌스 통제']],
     'PMC는 발주기관의 부족한 기술·관리 역량을 보완하기 위해 외부 전문 컨설팅 기업이 사업 전반을 자문·대행하는 형태이며, PMO는 프로젝트의 일정·품질·위험을 표준화된 방법론으로 통제하는 관리 조직 및 제도이다. 국내 공공사업에서는 전자정부법상 PMO 제도와 정보시스템 감리 간의 역할 중복 방지가 핵심 성공요소다.',
     '129회·131회 감리 vs PMO에 이어 140회 PMC vs PMO로 지속 변형 출제'),

    (140, 1, 5, 2, '개념/표준규격형', 'ISO/IEC 25010의 주특성 및 부특성',
     ['1. SQuaRE(ISO/IEC 25000) 시리즈 중 품질 모델(25010) 개요', '2. 제품 품질(Product Quality) 8대 주특성과 주요 부특성(개정판 안전성 포함)'],
     ['1. 리드문: ISO/IEC 25010 품질 모델 개요 및 개편 배경', '2. 제품 품질 8대 주특성(기존) 및 2023 개정(9대 특성: Safety/Flexibility 반영) 체계도', '3. 주특성 및 주요 부특성 상세 매핑표', '4. AI/클라우드 시스템 품질 평가 시 ISO/IEC 25059 연계 제언'],
     'SQuaRE, 기능적합성, 성능효율성, 호환성, 사용성(상호작용역량), 신뢰성, 보안성, 유지보수성, 이식성(유연성), 안전성(Safety)',
     ['주특성 (Main Characteristic)', '핵심 부특성 (Sub-characteristics)', '평가 관점'],
     [['기능적합성 / 성능효율성', '기능완전성·정확성·적절성 / 시간반응성·자원효율성·용량성', '요구기능 충족도 및 처리 속도·자원 사용량'],
      ['호환성 / 사용성(Interaction)', '공존성·상호운용성 / 학습성·운용성·사용자오류방지·접근성', '타 시스템 연동성 및 사용자 편의성'],
      ['신뢰성 / 보안성', '성숙성·가용성·결함허용성·복구성 / 기밀성·무결성·부인방지·책임추적성·인증성', '무장애 가동 및 비인가 접근 통제'],
      ['유지보수성 / 이식성(유연성)', '모듈성·재사용성·분석성·수정성·시험성 / 적응성·설치성·대체성', '변경 용이성 및 타 환경 이전성 (2023 개정 시 Safety 추가)']],
     'ISO/IEC 25010은 소프트웨어 및 시스템의 품질을 평가하기 위한 국제 표준(SQuaRE 핵심 모델)으로, 제품 품질 8대 주특성(2023 개정판 기준 유연성·안전성(Safety)을 포함한 9대 주특성)과 사용 품질(Quality in Use)로 구성된다. 답안 작성 시 기존 8대 주특성(기성호사신보유이)과 최신 2023 개정 사항(Safety 신설, Portability→Flexibility 명칭 변경 등)을 함께 언급하면 고득점이 가능하다.',
     '스테디셀러 표준 토픽으로 2~3년 주기 반복 출제'),

    (140, 1, 6, 4, '비교/아키텍처형', '어휘 검색(Lexical Search)과 의미 검색(Vector Search)을 결합한 하이브리드 검색(Hybrid Search)',
     ['1. 어휘 검색(BM25)과 의미 검색(Dense Vector)의 한계', '2. 하이브리드 검색 아키텍처 및 스코어 결합(RRF 등) 기법'],
     ['1. 리드문: RAG 정확도 극대화를 위한 하이브리드 검색 정의', '2. 하이브리드 검색 파이프라인 및 RRF(Reciprocal Rank Fusion) 결합 구조도', '3. 어휘 검색(Sparse/BM25) vs 의미 검색(Dense/ANN) 비교', '4. Reranker(Cross-Encoder) 결합 및 엔터프라이즈 RAG 최적화 방안'],
     'BM25, TF-IDF, Dense Vector, HNSW, RRF(Reciprocal Rank Fusion), Cross-Encoder Reranker, OOV 문제',
     ['비교 항목', '어휘 검색 (Lexical / Sparse)', '의미 검색 (Semantic / Dense Vector)', '하이브리드 검색 (Hybrid Search)'],
     [['핵심 알고리즘', 'TF-IDF, BM25 (역색인 기반)', 'Bi-Encoder 임베딩 + HNSW/IVF (코사인 유사도)', 'Sparse + Dense 병렬 검색 후 RRF/가중합 결합'],
      ['강점', '고유명사, 에러코드, 법령 조항 등 정확 매칭 우수', '동의어, 문맥적 의미, 다국어 유사 질의 검색 우수', '키워드 정밀도와 문맥 재현율(Recall) 동시 확보'],
      ['한계점', '동의어·유의어 미검출(어휘 불일치 문제)', '신조어·코드·특수번호 검색 취약(Out-of-Domain)', '인덱스 이중 관리 및 연산 오버헤드 발생']],
     '하이브리드 검색(Hybrid Search)은 역색인 기반의 어휘 검색(BM25)과 임베딩 벡터 기반의 의미 검색(Dense Retrieval)을 병렬 수행한 뒤, RRF(Reciprocal Rank Fusion) 또는 선형 가중합으로 순위를 통합하는 검색 기법이다. 엔터프라이즈 RAG 환경에서 고유명사/모델명 누락과 문맥 왜곡을 동시에 해결하는 핵심 아키텍처로 활용된다.',
     '137회 4교시 HNSW/IVF → 139회 1교시 Advanced RAG → 140회 1교시 하이브리드 검색으로 연속 출제'),

    (140, 1, 7, 1, '절차/수리통계형', '편향 감소와 분산 추정을 위한 잭나이프(Jackknife) 기법',
     ['1. 리샘플링 기반 잭나이프(Jackknife) 추정법의 개념과 원리', '2. 부트스트랩(Bootstrap) 기법과의 비교'],
     ['1. 리드문: 비모수 재표집(Resampling) 기법으로서의 잭나이프 정의', '2. Leave-One-Out 부분표본 생성 및 의사값(Pseudo-value) 산출 절차', '3. 잭나이프(Jackknife) vs 부트스트랩(Bootstrap) 비교', '4. 소표본 머신러닝 모델 검증 및 통계적 추론 활용 방안'],
     '재표집(Resampling), Leave-One-Out, 편향(Bias) 보정, 분산 추정, 부트스트랩(Bootstrap), 의사값(Pseudo-value)',
     ['비교 항목', '잭나이프 (Jackknife)', '부트스트랩 (Bootstrap)'],
     [['표본 추출 방식', '크기 n에서 1개씩 순차 제외한 크기 (n-1)의 부분표본 n개 생성 (비복원)', '크기 n에서 복원추출(With Replacement)로 크기 n의 표본 B개 생성'],
      ['연산 특성', '결정론적(Deterministic) 결과, 연산량 적음 (n회)', '확률적(Stochastic) 결과, 연산량 많음 (B=1,000~10,000회)'],
      ['주요 용도', '추정량의 편향(Bias) 1차 보정 및 분산의 근사 추정', '신뢰구간 추정, 복잡한 비선형 통계량 분포 추정']],
     '잭나이프(Jackknife) 기법은 전체 표본 크기 n에서 관측치를 하나씩 제외한 크기 (n-1)의 부분표본 n개를 생성하여 추정량의 편향(Bias)을 줄이고 분산(표준오차)을 비모수적으로 추정하는 기법이다. 복원추출 기반의 부트스트랩(Bootstrap)의 선구적 형태로, 계산량이 적고 항상 동일한 결정론적 결과를 보장한다는 특징이 있다.',
     '통계/추정 파트(132회 점추정/구간추정, 135회 불편추정량, 139회 대수의법칙) 매회 1문항 이상 고정 출제'),

    (140, 1, 8, 6, '개념/운영체제형', '좀비 프로세스(Zombie Process)',
     ['1. 좀비 프로세스(Defunct Process)의 개념 및 발생 원인', '2. 고아 프로세스(Orphan Process)와의 비교 및 해결 방안'],
     ['1. 리드문: 좀비 프로세스(Defunct)의 정의 및 시스템 영향', '2. fork() / exit() / wait() 시스템 콜과 프로세스 상태 전이도', '3. 좀비 프로세스(Zombie) vs 고아 프로세스(Orphan) 비교', '4. 발생 방지 방안(SIGCHLD 핸들러, waitpid) 및 리눅스 운영 관리'],
     'Defunct 상태, PCB(Process Control Block), PID 고갈, wait() / waitpid(), SIGCHLD, 고아 프로세스(Orphan), init/systemd',
     ['비교 항목', '좀비 프로세스 (Zombie Process)', '고아 프로세스 (Orphan Process)'],
     [['발생 원인', '자식 프로세스가 종료(exit)되었으나 부모가 종료 상태를 회수(wait)하지 않음', '자식 프로세스가 실행 중인데 부모 프로세스가 먼저 종료됨'],
      ['자원 점유', '메모리·CPU는 반납했으나 커널 프로세스 테이블(PCB, PID) 엔트리 점유', '실행 중인 일반 프로세스로 CPU·메모리 정상 사용'],
      ['처리 방법', '부모에게 SIGCHLD 전송, 부모 코드 내 waitpid() 호출 또는 부모 종료(init이 수거)', '커널이 자동으로 최상위 프로세스(PID 1: init/systemd)를 새 부모로 지정']],
     '좀비 프로세스(Zombie Process)는 자식 프로세스의 실행이 종료되어 메모리와 리소스는 반환되었으나, 부모 프로세스가 wait() 계열 시스템 콜로 종료 상태코드(Exit Status)를 읽지 않아 커널 프로세스 테이블(PCB)에 남아 있는 상태(Z, Defunct)다. 방치할 경우 시스템의 가용 PID가 고갈되어 신규 프로세스 생성이 불가능해지므로 SIGCHLD 시그널 핸들러에 비동기 waitpid()를 구현해야 한다.',
     'CA/OS 전통 기초 토픽(136회 Segmentation Fault, 138회 OS 메모리 4영역, 140회 좀비 프로세스) 강세'),

    (140, 1, 9, 1, '비교/신기술형', 'Physical AI와 생성형 AI 비교',
     ['1. Physical AI(체화 인공지능)의 개념과 핵심 메커니즘', '2. 디지털 공간의 생성형 AI(Generative AI)와의 차이점 비교'],
     ['1. 리드문: 가상에서 물리 세계로 확장된 Physical AI 정의', '2. Physical AI 아키텍처 (월드 모델 + VLA 모델 + 액추에이터 피드백)', '3. 생성형 AI(Generative AI) vs Physical AI 세부 비교', '4. 휴머노이드·자율주행·다크팩토리 적용 및 안전성(Safety) 확보 방안'],
     'Embodied AI(체화 AI), World Model(월드 모델), VLA(Vision-Language-Action), 물리 법칙(중력·마찰), Sim-to-Real, 엣지 온디바이스 추론',
     ['비교 항목', '생성형 AI (Generative AI)', 'Physical AI (피지컬 AI / Embodied AI)'],
     [['작동 영역', '디지털 가상 공간 (텍스트, 이미지, 코드, 음성 생성)', '3차원 물리적 현실 공간 (로봇, 휴머노이드, 자율주행차 제어)'],
      ['핵심 모델', 'LLM, Diffusion, Multimodal Foundation Model', 'World Model(물리법칙 이해) + VLA(Vision-Language-Action) 모델'],
      ['제약 조건', '환각(Hallucination), 토큰 지연시간, 저작권/프라이버시', '실시간 초저지연 제어, 물리적 안전성(Safety), Sim-to-Real 격차']],
     'Physical AI는 텍스트·이미지를 생성하는 디지털 영역의 생성형 AI를 넘어, 중력·마찰·공간 등 현실 세계의 물리 법칙(World Model)을 이해하고 센서 인지부터 물리적 행동(Actuation)까지 자율 수행하는 체화 인공지능(Embodied AI)이다. Sim-to-Real 학습 격차 해소와 ISO 26262/25010 기반의 물리적 안전성(Safety) 보장이 핵심 과제다.',
     '2026년 최대 화두 토픽으로 차기 회차 2~4교시 VLA/월드모델 심층 논술 출제 유력'),

    (140, 1, 10, 5, '개념/네트워크형', '차등적 맨체스터(Differential Manchester) 부호화 방법',
     ['1. 디지털-디지털 회선 부호화(Line Coding)의 목적', '2. 맨체스터(Manchester)와 차등적 맨체스터(Differential Manchester) 부호화 원리 및 비교'],
     ['1. 리드문: 자체 동기화(Self-clocking)를 위한 맨체스터 계열 부호화 정의', '2. 비트 열(0, 1)에 따른 맨체스터 vs 차등 맨체스터 파형 전이 다이어그램', '3. NRZ, RZ, Manchester, Differential Manchester 비교표', '4. 토큰링(IEEE 802.5) 등 적용 사례 및 대역폭 효율성 한계'],
     'Line Coding, 자체 동기화(Self-Synchronization), 직류 성분(DC Component) 제거, 비트 중간 전이, 비트 시작점 전이(0=전이, 1=무전이)',
     ['부호화 방식', '비트 0 표현', '비트 1 표현', '동기화 및 극성 반전 내성'],
     [['맨체스터 (Manchester, IEEE 802.3)', '비트 중간에서 High→Low(또는 Low→High) 고정 방향 전이', '비트 중간에서 반대 방향 전이', '자체 동기화 지원, 단 선로 극성 반전 시 비트 역전 발생'],
      ['차등적 맨체스터 (Diff. Manchester, IEEE 802.5)', '비트 시작 경계에서 전이 발생 + 비트 중간 클럭 전이', '비트 시작 경계에서 전이 없음 + 비트 중간 클럭 전이', '자체 동기화 지원 + 전이 유무로 판별하므로 극성 반전에 강인함']],
     '차등적 맨체스터(Differential Manchester) 부호화는 매 비트 주기의 중간(Mid-bit)에 항상 전이를 두어 클럭 동기화(Self-clocking)와 DC 성분 제거를 달성하면서, 데이터 값 판별은 비트 시작점(Boundary)에서의 전이 유무(0이면 전이 발생, 1이면 전이 없음)로 결정하는 기법이다. 전압의 절대 높낮이가 아닌 변화 유무를 쓰므로 전송 선로 극성이 뒤바뀌어도(Polarity Inversion) 데이터 오류가 발생하지 않는다.',
     '전통 네트워크 물리계층 기초 토픽 기습 출제 사례'),

    (140, 1, 11, 3, '개념/보안대응형', '비인간 신원(NHI, Non-Human Identities)의 보안 취약점',
     ['1. 클라우드 및 에이전틱 AI 환경에서 NHI(API 키, 서비스 계정, 봇, 워크로드 ID)의 개념', '2. 주요 보안 취약점 및 전주기 거버넌스 대응 방안'],
     ['1. 리드문: 인간 계정보다 10~50배 많은 비인간 신원(NHI) 정의 및 대두 배경', '2. NHI 유형(API Key, OAuth Token, Service Account, AI Agent ID) 및 공격 경로도', '3. NHI 주요 보안 취약점 (하드코딩, 과도한 권한, 미회전 시크릿, 고아 계정)', '4. NHI 보안 거버넌스 및 Zero Trust 기반 대응 방안 (Vault, SPIFFE/SPIRE, 자동 회전)'],
     'Service Account, API Key, OAuth Token, Workload Identity, 시크릿 스프로울(Secret Sprawl), 최소권한 원칙, SPIFFE/SPIRE',
     ['취약점 유형', '발생 원인 및 공격 위협', '핵심 기술적 대응 방안'],
     [['시크릿 하드코딩 및 유출', 'Git 저장소·컨테이너 이미지 내 API 키/토큰 평문 노출', 'Git Secret Scanning, 동적 시크릿 볼트(HashiCorp Vault, KMS) 도입'],
      ['장기 미회전 및 고아 NHI', '퇴사자·폐기 서비스가 생성한 만료 없는 서비스 계정 방치', 'NHI 인벤토리 자동 탐지, 단기 수명 토큰(Ephemeral Token/OIDC) 강제'],
      ['과도한 권한(Over-privileged)', '편의상 관리자 권한(*)이 부여된 CI/CD 봇·AI 에이전트 탈취 시 측면 이동', 'JIT(Just-In-Time) 권한 부여, CIEM 기반 최소 권한 제어 및 행위 모니터링']],
     '비인간 신원(NHI, Non-Human Identities)은 마이크로서비스, CI/CD 파이프라인, 클라우드 워크로드, 자율 AI 에이전트 간 M2M(Machine-to-Machine) 통신에 사용되는 서비스 계정·API 키·토큰·인증서를 총칭한다. 인간 사용자와 달리 MFA 적용이 어렵고 만료 없이 방치되는 경우가 많아 공격자의 주요 침투 경로가 되므로, 자동 검색(Discovery)·단기 토큰화(SPIFFE/SPIRE)·수명주기 자동 폐기 체계가 필수적이다.',
     'OWASP Non-Human Identities Top 10 발표 직후 출제된 최신 보안 토픽 — 차기 회차 3교시 서술형 유력'),
]

RAW_QUESTIONS.extend([
    # --- 제140회 2~4교시 대표 문항 ---
    (140, 2, 1, 1, '비교/아키텍처형', '생성형 AI 서비스의 응답 속도 및 메모리 최적화를 위한 KV Cache와 PagedAttention 기법 설명',
     ['가. Autoregressive 디코딩에서 KV Cache의 개념과 메모리 단편화 문제', '나. vLLM 기반 PagedAttention의 동작 원리와 물리/논리 블록 매핑', '다. 대규모 LLM 서빙 인프라 구축 시 Continuous Batching 등 처리량(Throughput) 극대화 방안'],
     ['1. 리드문: LLM 추론 병목(Memory-bound)과 PagedAttention 등장 배경', '2. OS 가상메모리 페이징을 응용한 PagedAttention 블록 매핑 구조도', '3. 기존 KV Cache 할당 vs PagedAttention 비교', '4. Continuous Batching·Speculative Decoding 결합 서빙 최적화 제언'],
     'Memory-bound, KV Cache, 내부/외부 단편화, PagedAttention, vLLM, Copy-on-Write, Continuous Batching',
     ['비교 항목', '기존 연속(Contiguous) KV Cache', 'PagedAttention (vLLM)'],
     [['메모리 할당 방식', '최대 시퀀스 길이(Max Token)만큼 연속된 GPU VRAM 사전 예약', '고정 크기 블록(Page) 단위로 비연속적 동적 할당 (페이지 테이블 매핑)'],
      ['메모리 낭비율', '내부·외부 단편화로 인해 할당 메모리의 60~80% 낭비', '마지막 블록 내부 단편화만 발생하여 낭비율 4% 미만'],
      ['배치 처리량', '메모리 조기 고갈로 동시 처리 배치 크기(Batch Size) 제한', '동일 GPU에서 2~4배 이상의 동시 요청 배치 처리 및 프롬프트 공유(CoW) 지원']],
     'LLM의 자기회귀(Autoregressive) 생성 과정은 이전 토큰의 Key-Value 텐서를 저장하는 KV Cache가 GPU VRAM을 대량 점유하는 메모리 대역폭 병목(Memory-bound) 특성을 갖는다. PagedAttention은 운영체제의 가상 메모리 페이징 기법을 차용하여 KV Cache를 고정 크기 블록으로 분할·비연속 저장함으로써 메모리 단편화를 4% 미만으로 줄이고 서빙 처리량을 극대화한다.',
     'LLM 학습에서 추론 최적화(Serving Ops)로 출제 축 이동'),

    (140, 3, 1, 3, '원인분석/대응전략형', '클라우드 네이티브 및 멀티클라우드 환경에서 공격 표면 관리(ASM)와 지속적 위협 노출 관리(CTEM) 프레임워크 구축 방안',
     ['가. 공격 표면 관리(ASM/EASM)의 개념과 한계', '나. 가트너 CTEM 5단계(범위설정-발견-우선순위화-검증-동원) 순환 프로세스', '다. 금융·공공기관 제로트러스트 아키텍처와 연계한 실무 적용 방안'],
     ['1. 리드문: 사후 패치 중심 취약점 관리에서 선제적 CTEM으로의 패러다임 전환', '2. CTEM 5단계(Scoping-Discovery-Prioritization-Validation-Mobilization) 순환 구조도', '3. 전통적 취약점 관리(VM) vs ASM vs CTEM 비교', '4. BAS(침해공격시뮬레이션) 및 AI 기반 자동 완화를 결합한 거버넌스 제언'],
     'CTEM, EASM(외부공격표면관리), CVSS vs EPSS, BAS(Breach and Attack Simulation), 침투테스트, Mobilization',
     ['구분', '전통적 취약점 관리 (VM)', '공격 표면 관리 (ASM/EASM)', 'CTEM (지속적 위협 노출 관리)'],
     [['관리 범위', '내부 알려진 IT 자산의 CVE 패치 중심', '외부 노출 자산·Shadow IT·클라우드 자산 탐지', '기술적 취약점 + 비패치 노출(설정오류, 계정, 비즈니스 영향) 포괄'],
      ['검증 방식', '스캐너 기반 정적 점수(CVSS) 산정', '공격자 관점 외부 스캐닝 및 모니터링', 'BAS·레드팀 기반 실제 공격 성공 가능성(Exploitability) 실증'],
      ['핵심 목표', '규제 준수 및 패치율 향상', '미식별 외부 자산 가시성 확보', '실질적 침해 가능성 조기 차단 및 부서 간 실행(Mobilization) 자동화']],
     'CTEM(Continuous Threat Exposure Management)은 단순 CVE 패치 중심의 취약점 관리를 넘어, 범위설정(Scoping)→발견(Discovery)→우선순위화(Prioritization)→검증(Validation)→동원(Mobilization)의 5단계 주기로 기업의 위협 노출을 상시 줄이는 프레임워크다. 139회 1교시 단답형 출제 직후 서술형 시나리오로 확장된 핵심 보안 주제다.',
     '139회 1교시 CTEM → 140회 서술형 확장 패턴'),

    (140, 4, 1, 8, '법제도/거버넌스형', '인공지능기본법 시행에 따른 고영향 AI(High-Impact AI) 사업자 책무와 AI 신뢰성·안전성 거버넌스 구축 방안',
     ['가. 인공지능기본법의 제정 목적 및 주요 정의(고영향 인공지능, 생성형 인공지능)', '나. 고영향 AI 및 생성형 AI 사업자의 투명성·안전성 확보 의무', '다. 기업의 ISO/IEC 42001 및 NIST AI RMF 연계 컴플라이언스 체계 구축 방안'],
     ['1. 리드문: 2026년 인공지능기본법 본격 시행과 AI 규제·진흥 균형', '2. 인공지능기본법 거버넌스 및 고영향 AI 책무 체계도', '3. 고영향 AI vs 생성형 AI 법적 의무사항 및 글로벌 규제(EU AI Act) 비교', '4. 기업 내 AI 윤리위원회·레드티밍·검인증(CAT) 통합 거버넌스 구축 제언'],
     '인공지능기본법, 고영향 인공지능(High-Impact AI), 사전 고지·워터마킹 의무, 위험관리체계, 설명가능성(XAI), ISO/IEC 42001, AI 안전연구소',
     ['구분', '고영향 인공지능 (High-Impact AI)', '생성형 인공지능 (Generative AI)'],
     [['대상 영역', '에너지, 보건의료, 채용·인사, 대출심사, 교통, 공공 의사결정 등 생명·기본권 직결 영역', '텍스트, 이미지, 오디오, 영상, 코드 등 신규 콘텐츠를 생성하는 AI 시스템'],
      ['핵심 의무', '위험관리방안 수립, 설명 가능성 확보, 이용자 보호 대책, 사람의 관리·감독 체계 운영', 'AI 생성 결과물 사전 고지 및 기계 판독 가능한 워터마크(출처 표시) 의무'],
      ['글로벌 대응', 'EU AI Act의 고위험(High-Risk) AI 등급과 정합성 확보', '딥페이크 악용 방지 및 저작권·학습데이터 투명성 관리']],
     '인공지능기본법은 AI 산업 진흥과 신뢰 기반 조성을 동시에 달성하기 위해 제정된 기본법으로, 사람의 생명·신체 안전 및 기본권에 중대한 영향을 미치는 영역을 고영향 AI로 지정하여 위험관리·설명가능성·인간 감독 의무를 부과한다. 기업은 ISO/IEC 42001(AI 경영시스템) 및 NIST AI RMF를 내부 거버넌스에 내재화하여 법적 준거성을 확보해야 한다.',
     '138회·139회·140회 연속 출제된 최우선 법·제도 토픽'),

    # --- 제139회 (2026년 5월) 대표 기출 ---
    (139, 1, 1, 7, '절차/방법론형', 'WBS(Work Breakdown Structure) 작성방법',
     ['1. WBS의 개념 및 PMBOK 범위 관리에서의 역할', '2. 100% 규칙(100% Rule), 8/80 규칙 및 Work Package 분할 기준'],
     ['1. 리드문: 프로젝트 범위 정의의 핵심 기준선(Scope Baseline) WBS', '2. WBS 계층 구조(Project → Phase/Deliverable → Control Account → Work Package) 및 WBS 사전', '3. WBS 작성 핵심 원칙 (100% Rule, 8/80 Rule, MECE, 인도물 중심)', '4. 애자일 프로젝트에서의 스토리 맵(Story Map) 연계 활용 방안'],
     '범위 기준선(Scope Baseline), Work Package(작업 패키지), 100% Rule, 8/80 Rule, Control Account, WBS Dictionary',
     ['작성 원칙', '핵심 내용', '실무 검증 기준'],
     [['100% 규칙 (100% Rule)', '하위 요소의 합이 상위 요소의 작업 범위를 100% 포함해야 함 (누락·초과 금지)', 'MECE(상호배제와 전체포괄) 위배 여부 점검'],
      ['8/80 시간 규칙', '최하위 작업 패키지(Work Package)는 최소 8시간(1일)~최대 80시간(2주) 단위로 분할', '진척율 측정 및 담당자 단일 배정 가능 여부'],
      ['명사형 산출물 지향', '동사형(기능/활동)이 아닌 검증 가능한 명사형 인도물(Deliverable) 중심으로 정의', '완료 기준(DoD) 및 검수 산출물 명확화']],
     'WBS(Work Breakdown Structure)는 프로젝트 목표 달성과 필요 산출물 생성을 위해 전체 작업 범위를 인도물(Deliverable) 중심의 계층 구조로 세분화한 범위 기준선이다. 최하위 요소인 Work Package는 비용과 일정을 신뢰성 있게 추정·통제할 수 있도록 100% 규칙과 8/80 규칙을 준수하여 작성한다.',
     '128회 1교시 WBS 출제 후 139회 1교시 재출제 (PM 스테디셀러)'),

    (139, 1, 2, 1, '비교/수리통계형', '대수의 법칙(Law of Large Numbers)과 중심극한정리(Central Limit Theorem)',
     ['1. 대수의 법칙(약법칙/강법칙)의 통계적 의미', '2. 중심극한정리의 개념과 두 정리의 차이점 비교'],
     ['1. 리드문: 표본 통계량 수렴과 추론 통계의 양대 정리 정의', '2. 표본 크기(n) 증가에 따른 표본평균 수렴(LLN) 및 정규분포 근사(CLT) 개념도', '3. 대수의 법칙(LLN) vs 중심극한정리(CLT) 비교표', '4. A/B 테스트 표본 크기 산정 및 몬테카를로 시뮬레이션 적용 사례'],
     '표본평균, 모평균 수렴, 정규분포 근사, n>=30, 몬테카를로 시뮬레이션, 점추정과 구간추정',
     ['비교 항목', '대수의 법칙 (Law of Large Numbers)', '중심극한정리 (Central Limit Theorem)'],
     [['핵심 명제', '표본 크기 n이 커질수록 표본평균(X̄)이 모평균(μ)에 확률적으로 수렴함', '모집단 분포와 무관하게 n이 충분히 크면(n≥30) 표본평균의 분포가 정규분포 N(μ, σ²/n)에 수렴함'],
      ['관심 대상', '표본평균의 수렴 값(점추정의 타당성 근거)', '표본평균 분포의 형태(구간추정 및 가설검정의 근거)'],
      ['산업 응용', '몬테카를로 강화학습, 보험 수리, 카지노/시뮬레이션 기대값 산출', '공정 품질관리, A/B 테스트 Z/t-검정, 신뢰구간 산출']],
     '대수의 법칙은 표본 크기 n이 무한히 커질 때 표본평균이 모평균이라는 특정 상수 값에 가까워진다는 정리이며, 중심극한정리는 모집단이 어떤 분포를 따르든 표본 크기가 충분히 크면(통상 n≥30) 표본평균들의 확률분포가 정규분포에 수렴한다는 정리다.',
     '132회 2교시 중심극한정리 출제 후 139회 1교시 대수의 법칙과 묶어 재출제'),

    (139, 1, 3, 1, '비교/아키텍처형', 'Advanced RAG와 Modular RAG 비교',
     ['1. Naive RAG의 한계(검색 정밀도 저하, Lost in the Middle)', '2. Advanced RAG(Pre/Post-Retrieval)와 Modular RAG의 구조적 차이점'],
     ['1. 리드문: 생성형 AI 환각 억제를 위한 RAG 패러다임 진화(Naive → Advanced → Modular)', '2. Advanced RAG(Pre-Retrieval / Retrieval / Post-Retrieval) 및 Modular RAG 아키텍처도', '3. Naive RAG vs Advanced RAG vs Modular RAG 3단 비교', '4. Agentic RAG 및 GraphRAG로의 발전 전망'],
     'Naive RAG, Pre-Retrieval(Query Rewrite, HyDE), Post-Retrieval(Rerank, Compression), Modular RAG, 라우팅·적응형 검색',
     ['구분', 'Naive RAG', 'Advanced RAG', 'Modular RAG'],
     [['파이프라인 구조', '단순 인덱싱 → 벡터 검색 → 프롬프트 결합 생성 (선형)', '검색 전(Query 확장/라우팅) 및 검색 후(Rerank/압축) 최적화 단계 추가', '검색·기억·라우팅·융합을 독립 모듈화하여 조건부·반복적 재구성'],
      ['핵심 기술', '청킹(Chunking), 코사인 유사도 검색', 'HyDE, Multi-Query, Cross-Encoder Reranker, Context Compression', 'Self-RAG, Corrective RAG(CRAG), GraphRAG, 적응형 플로우 제어'],
      ['한계 및 특징', '복합 질의 취약, 노이즈 청크 유입', '검색 품질 대폭 향상, 고정된 파이프라인 순서', '복잡한 다중 홉(Multi-hop) 추론 및 도구 호출(Agent) 통합 가능']],
     'Advanced RAG는 기존 Naive RAG의 검색 전후 단계에 질의 재작성(Query Rewriting), 가상 문서 임베딩(HyDE), 리랭킹(Reranking), 문맥 압축을 추가하여 검색 정확도를 높인 기법이며, Modular RAG는 이를 넘어 검색·판단·생성 단계를 레고 블록처럼 모듈화하여 라우팅·반복 검색(Self/Corrective RAG)을 동적으로 수행하는 구조다.',
     'RAG 진화 시리즈 핵심 기출'),

    (139, 1, 5, 2, '비교/아키텍처형', '소프트웨어 무중단 배포(Zero-Downtime Deployment) 방식',
     ['1. 클라우드 네이티브 CI/CD에서 무중단 배포의 개념', '2. Rolling, Blue-Green, Canary 배포 방식의 동작 원리 및 장단점 비교'],
     ['1. 리드문: 고가용성 데브옵스(DevOps) 구현을 위한 무중단 배포 정의', '2. Rolling · Blue-Green · Canary 트래픽 전환 개념도', '3. 3대 무중단 배포 방식 비교표 (인프라 비용, 롤백 속도, 구버전/신버전 공존 여부)', '4. Kubernetes(Argo Rollouts/Istio) 기반 점진적 전달(Progressive Delivery) 제언'],
     'Rolling Update, Blue-Green Deployment, Canary Release, Progressive Delivery, 롤백(Rollback), 트래픽 라우팅',
     ['배포 방식', '동작 원리', '장점', '단점'],
     [['Rolling 배포', '기존 인스턴스를 점진적으로 하나씩 신버전으로 교체', '추가 인프라 비용 없음, K8s 기본 전략', '배포 중 구버전·신버전 공존으로 호환성 문제 가능, 롤백 느림'],
      ['Blue-Green 배포', '동일 규모의 Green(신버전) 환경 구축 후 로드밸런서 트래픽 일괄 전환', '즉각적인 롤백 가능, 버전 혼재 없음', '순간적으로 2배의 인프라 리소스 비용 소요'],
      ['Canary 배포', '소수 트래픽(1~5%)만 신버전으로 먼저 라우팅하여 검증 후 단계적 확대', '실운영 환경 위험 최소화, A/B 테스트 연계 용이', '정교한 트래픽 제어(Service Mesh/Ingress) 및 모니터링 필수']],
     '무중단 배포는 서비스 다운타임 없이 신규 애플리케이션 버전을 실운영 환경에 반영하는 기법으로, 자원 효율성이 높은 Rolling 방식, 즉각적 롤백에 유리한 Blue-Green 방식, 실사용자 위험을 최소화하는 Canary 방식으로 구분된다. 최근에는 서비스 메시(Istio)와 결합한 점진적 배포(Progressive Delivery)가 표준화되고 있다.',
     'SW공학 배포 아키텍처 핵심 빈출 토픽'),

    (139, 1, 9, 2, '절차/계산형', '맥케이브 순환복잡도(McCabe Cyclomatic Complexity)',
     ['1. 제어 흐름 그래프(CFG) 기반 맥케이브 순환복잡도의 개념', '2. 3가지 계산 공식 V(G) 및 테스트 케이스 설계 기준'],
     ['1. 리드문: 코드 구조적 복잡도 정량화 및 기본 경로 테스트를 위한 맥케이브 복잡도', '2. 제어 흐름 그래프(노드 N, 간선 E, 조건 분기 P) 예시 및 V(G) 산출식', '3. V(G) 3대 산출 공식 및 복잡도 수치별 코드 품질/위험도 판정 기준', '4. CI/CD 정적 분석(SonarQube) 연동 리팩토링 임계치(V(G)<=10) 관리 방안'],
     '제어 흐름 그래프(CFG), 독립 경로(Independent Path), V(G) = E - N + 2, V(G) = P + 1, 영역(Region) 수, 화이트박스 기본 경로 테스트',
     ['산출 공식', '수식 정의', '의미 및 활용'],
     [['간선·노드 기반', 'V(G) = E - N + 2 (단일 연결 컴포넌트 기준)', '제어흐름그래프의 간선(Edge) 수 E와 노드(Node) 수 N으로 산출'],
      ['조건 분기(Predicate) 기반', 'V(G) = P + 1', 'if, while, for, case 등 조건 분기 노드(Predicate Node) 수 P + 1'],
      ['평면 영역(Region) 기반', 'V(G) = R', '간선과 노드로 둘러싸인 내부 영역 수 + 외부 영역(1)의 합 (최소 테스트 케이스 수 상한)']],
     '맥케이브 순환복잡도 V(G)는 프로그램 제어 흐름 그래프(CFG)에서 선형적으로 독립적인 경로(Linearly Independent Path)의 개수를 정량화한 소프트웨어 메트릭이다. 산출된 V(G) 값은 모든 분기를 최소 한 번 이상 실행하기 위한 기본 경로 테스트(Basis Path Testing)의 최소 테스트 케이스 수가 되며, 통상 10 이하로 유지할 것을 권장한다.',
     '정보처리기사 및 정보관리기술사 양쪽 모두에서 반복 출제되는 핵심 메트릭'),

    (139, 1, 10, 5, '개념/차세대통신형', 'Wi-Fi 7 (IEEE 802.11be, EHT)',
     ['1. Wi-Fi 7(IEEE 802.11be, Extremely High Throughput)의 주요 스펙', '2. 320MHz 대역폭, 4K-QAM, MLO(Multi-Link Operation) 핵심 기술 설명'],
     ['1. 리드문: 초고속·초저지연 무선랜 표준 Wi-Fi 7(802.11be) 정의', '2. MLO(다중 링크 동작) 및 Puncturing(프리앰블 펑처링) 구조도', '3. Wi-Fi 6/6E(802.11ax) vs Wi-Fi 7(802.11be) 주요 성능·기술 비교', '4. XR·다크팩토리·초저지연 엔터프라이즈 무선 인프라 구축 고려사항'],
     'IEEE 802.11be, EHT(Extremely High Throughput), 최대 46Gbps, 320MHz 채널, 4096-QAM(4K-QAM), MLO(Multi-Link Operation), Multi-RU Puncturing',
     ['비교 항목', 'Wi-Fi 6 / 6E (802.11ax)', 'Wi-Fi 7 (802.11be)'],
     [['최대 전송 속도 / 대역폭', '9.6 Gbps / 최대 160 MHz (2.4 / 5 / 6 GHz)', '46 Gbps / 최대 320 MHz (2.4 / 5 / 6 GHz)'],
      ['변조 방식 / MIMO', '1024-QAM / 8x8 MU-MIMO', '4096-QAM (4K-QAM, 전송량 20% 향상) / 16x16 MU-MIMO'],
      ['핵심 차별화 기술', 'OFDMA, BSS Coloring, TWT', 'MLO(다중 대역 동시 병합/전환), Multi-RU Preamble Puncturing']],
     'Wi-Fi 7(IEEE 802.11be, EHT)은 최대 46Gbps 전송 속도와 초저지연을 제공하는 차세대 무선랜 표준이다. 특히 2.4GHz, 5GHz, 6GHz 대역을 동시에 묶어 전송하거나 간섭 없는 채널로 무중단 전환하는 MLO(Multi-Link Operation)와 간섭 주파수 구간만 제외하고 나머지 대역을 활용하는 Preamble Puncturing이 핵심 기술이다.',
     '차세대 무선통신(Wi-Fi 7, 6G AI-Native) 시리즈 빈출'),

    (139, 1, 12, 6, '개념/융합신기술형', '양자머신러닝(QML, Quantum Machine Learning)',
     ['1. 양자컴퓨팅(중첩, 얽힘, 간섭)과 머신러닝의 결합 개념', '2. 양자 데이터 인코딩 및 VQC(변분 양자 회로) 하이브리드 학습 구조'],
     ['1. 리드문: NISQ 시대 양자 우위 달성을 위한 양자머신러닝(QML) 정의', '2. CPU/GPU(고전 최적화) + QPU(Parameterized Quantum Circuit) 하이브리드 학습 구조도', '3. 고전 머신러닝 vs 양자머신러닝(QSVM, QNN, VQE) 비교', '4. Barren Plateau(기울기 소실) 및 양자 오류 정정(QEC) 극복 과제'],
     'Qubit(중첩·얽힘), NISQ, VQC(Variational Quantum Circuit), Quantum Kernel(QSVM), 양자 데이터 임베딩, Barren Plateau',
     ['구분', '고전 머신러닝 (Classical ML)', '양자머신러닝 (Quantum ML)'],
     [['정보 처리 단위', '비트(0 또는 1) 기반 행렬·텐서 연산 (GPU/TPU)', '큐비트(Qubit) 양자 중첩·얽힘 기반 힐베르트 공간 연산 (QPU)'],
      ['주요 알고리즘', 'SVM, CNN, Transformer, GNN', 'VQC(변분양자회로), QSVM(양자 커널), QAOA, QGAN'],
      ['핵심 강점 및 한계', '성숙한 생태계, 대규모 파라미터 학습 시 전력/연산 폭증', '고차원 특징 공간 매핑 가속, 단 결맞음 시간(Decoherence) 및 노이즈 한계']],
     '양자머신러닝(QML)은 양자역학의 중첩(Superposition)과 얽힘(Entanglement) 특성을 활용하여 고차원 힐베르트 공간에서 데이터를 처리하는 융합 기술이다. 현재 NISQ(잡음이 있는 중규모 양자) 환경에서는 고전 데이터를 양자 상태로 변환(Encoding)한 뒤 QPU의 변분 양자 회로(VQC)로 연산하고 고전 CPU/GPU로 파라미터를 갱신하는 하이브리드 구조가 주로 사용된다.',
     '양자 기술이 양자암호(QKD/PQC)에서 양자컴퓨팅 응용(QML)으로 확장 출제'),

    (139, 1, 13, 3, '비교/개인정보보호형', '개인정보보호를 위한 가명처리 기법',
     ['1. 가명정보의 법적 개념과 익명정보와의 차이', '2. 가명처리 5단계 절차 및 주요 처리 기법(삭제, 총계, 범주화, 마스킹, 암호화) 설명'],
     ['1. 리드문: 데이터 경제 활성화와 안전한 AI 학습을 위한 가명처리 정의', '2. 가명처리 5단계(사전준비 → 위험성검토 → 가명처리 → 적정성검토 → 사후관리) 절차도', '3. 주요 가명처리 기법(식별자 삭제/대체, 총계처리, 부분삭제, 범주화, 마스킹) 및 프라이버시 모델(k-익명성, l-다양성, t-근접성)', '4. 비정형 데이터(음성·영상·의료텍스트) 가명처리 및 재식별 위험 관리 방안'],
     '개인정보보호법, 가명정보 vs 익명정보, 일방향 암호화(Salted Hash), 총계·범주화·마스킹, k-익명성, 적정성 검토위원회',
     ['가명처리 기법', '세부 방법', '적용 예시'],
     [['가명화 (대체)', '식별자를 일련번호, 난수, 솔트 해시(SHA-256+Salt) 등으로 대체', '홍길동 → USER_84920'],
      ['총계처리 / 부분삭제', '합계·평균값으로 대체하거나 식별 가능 일부 항목 제거', '개별 연봉 → 부서 평균 연봉 / 주민번호 뒷자리 삭제'],
      ['범주화 / 마스킹', '구간(Range)이나 상위 개념으로 변환(라운딩, 상하단 코딩) 또는 기호 대체', '34세 → 30대 / 서울시 강남구 역삼동 → 서울시 ***']],
     '가명처리는 개인정보의 일부를 삭제하거나 대체하여 추가 정보의 결합 없이는 특정 개인을 알아볼 수 없도록 처리하는 기술적 조치다. 개인정보보호위원회 가이드라인에 따라 사전준비→위험성검토→가명처리→적정성검토→사후관리의 5단계를 준수해야 하며, 최근에는 LLM 학습용 비정형 데이터 가명처리 기술이 중요해지고 있다.',
     '138회 4교시 PET → 139회 1교시 가명처리 기법으로 연속 출제'),

    (139, 2, 1, 1, '비교/파이프라인형', 'LLM 기반 AI 시스템 구축을 위한 파인튜닝(Fine-Tuning), RAG, RLHF 및 RAFT 학습 파이프라인 비교 설명',
     ['가. 도메인 특화 LLM 구축 시 Fine-Tuning(PEFT/LoRA)과 RAG의 장단점 비교', '나. 인간 피드백 기반 강화학습(RLHF)과 DPO(Direct Preference Optimization) 비교', '다. 도메인 적응과 검색 능력을 결합한 RAFT(Retrieval Augmented Fine-Tuning) 아키텍처'],
     ['1. 리드문: 범용 LLM의 도메인 특화 및 정렬(Alignment)을 위한 최신 파이프라인', '2. SFT → RLHF/DPO 및 RAFT(정답 문서 + 오답 방해 문서 혼합 학습) 구조도', '3. Fine-Tuning vs RAG vs RAFT 및 RLHF vs DPO 비교표', '4. 엔터프라이즈 환경에서 비용·최신성·보안을 고려한 하이브리드 구축 전략'],
     'PEFT(LoRA/QLoRA), RAG, RLHF(PPO), DPO, RAFT(Retrieval Augmented Fine-Tuning), Distractor Document, Chain-of-Thought',
     ['구분', 'RAG (검색 증강 생성)', 'Fine-Tuning (SFT/LoRA)', 'RAFT (검색 증강 파인튜닝)'],
     [['지식 주입 방식', '외부 벡터DB 실시간 검색 결과(In-context) 주입', '모델 가중치(Weight) 업데이트를 통한 말투·도메인 내재화', '질문 + Golden 문서 + Distractor(방해) 문서 + CoT 정답으로 미세조정'],
      ['비유 및 강점', '오픈북 시험 (최신 정보 반영, 환각 억제, 출처 제시)', '암기 시험 (도메인 전문 용어·포맷 숙달, 추론 시 컨텍스트 절약)', '오픈북 시험 보는 요령을 사전 훈련 (노이즈 문서 무시 능력 극대화)']],
     '엔터프라이즈 LLM 구축 시 최신 지식 반영에 유리한 RAG와 도메인 어조·서식 내재화에 유리한 파인튜닝(LoRA)의 한계를 극복하기 위해, 최근에는 검색된 문서 중 노이즈(Distractor)를 걸러내고 근거 문장을 인용해 추론하도록 훈련하는 RAFT(Retrieval Augmented Fine-Tuning)와 보상모델 없이 선호도를 직접 최적화하는 DPO가 표준 파이프라인으로 자리잡고 있다.',
     '생성형 AI 구축 방법론의 결정판 서술형 문항'),

    # --- 제138회 (2026년 2월) 대표 기출 ---
    (138, 1, 1, 8, '개념/표준규격형', '미국 NIST AI RMF(Risk Management Framework)의 4대 핵심 기능과 7대 신뢰 특성',
     ['1. NIST AI RMF 1.0(및 생성형 AI 프로파일)의 개요', '2. 4가지 핵심 구조(Govern, Map, Measure, Manage)와 7가지 신뢰 가능한 AI 특성'],
     ['1. 리드문: AI 전주기 리스크 관리를 위한 글로벌 사실상 표준 NIST AI RMF', '2. Govern(중심축) → Map → Measure → Manage 4대 순환 구조도', '3. 4대 핵심 기능 및 7대 신뢰 특성(유효·신뢰성, 안전성, 보안·복원력, 책임·투명성, 설명·해석가능성, 프라이버시, 공정성) 정리', '4. ISO/IEC 42001 및 국내 인공지능기본법과의 매핑 전략'],
     'NIST AI RMF, Govern(거버넌스), Map(맥락파악), Measure(측정·평가), Manage(대응·관리), 7대 신뢰 특성',
     ['4대 핵심 기능', '주요 수행 활동', '핵심 산출물'],
     [['GOVERN (거버넌스)', 'AI 위험관리 문화·조직·정책·책임(R&R) 수립 (전 단계 관통)', 'AI 거버넌스 헌장, 위험 허용 수준(Risk Appetite), R&R 매트릭스'],
      ['MAP (맥락 매핑)', 'AI 시스템 활용 맥락 파악, 이해관계자 영향 및 잠재 리스크 식별', '시스템 컨텍스트 정의서, AI 리스크 등록부(Risk Register)'],
      ['MEASURE (측정)', '식별된 AI 리스크와 7대 신뢰 특성을 정량·정성적 지표(TEVV)로 평가', '레드티밍 보고서, 편향성·강건성·환각률 측정 결과'],
      ['MANAGE (관리)', '우선순위에 따른 리스크 완화·수용·이전·중단 조치 및 상시 모니터링', '리스크 완화 계획, 사고 대응 플레이북, 모델 폐기/롤백 기준']],
     '미국 국립표준기술연구소(NIST)의 AI RMF는 AI 시스템의 설계·개발·배포·운영 전 과정에서 리스크를 관리하기 위한 프레임워크로, GOVERN을 중심에 두고 MAP, MEASURE, MANAGE의 4대 핵심 기능으로 구성된다. 또한 신뢰할 수 있는 AI의 7대 특성(유효성/신뢰성, 안전성, 보안/복원력, 책임/투명성, 설명/해석가능성, 프라이버시 강화, 공정성/편향 관리)을 제시한다.',
     '138회 1교시 AI RMF & ISO 42001 동시 출제'),

    (138, 1, 3, 8, '개념/표준규격형', 'ISO/IEC 42001:2023 (AI 경영시스템 국제 표준)',
     ['1. ISO/IEC 42001(AIMS, AI Management System)의 제정 목적', '2. PDCA 기반 요구사항(4~10장) 및 부속서 A(38개 통제항목), AI 영향평가(AIIA)'],
     ['1. 리드문: 세계 최초의 AI 경영시스템 인증 표준 ISO/IEC 42001 정의', '2. HLS(High Level Structure) 기반 PDCA 사이클(조직맥락-리더십-기획-지원-운용-성과평가-개선) 구조도', '3. 핵심 요구사항 및 부속서 A(AI 정책, 영향평가, 데이터/시스템 수명주기 통제) 요약', '4. ISMS-P(ISO 27001)와 AIMS(ISO 42001) 통합 인증 구축 방안'],
     'AIMS(AI Management System), PDCA, HLS, AI 영향평가(ISO/IEC 42005 연계), AI 리스크 평가, 부속서 A 통제항목',
     ['PDCA 단계', 'ISO/IEC 42001 조항', '핵심 이행 내용'],
     [['Plan (기획)', '4장 조직 맥락, 5장 리더십, 6장 기획', 'AI 거버넌스 정책 수립, AI 리스크 평가 및 AI 시스템 영향평가(AIIA) 수행'],
      ['Do (지원·운용)', '7장 지원, 8장 운용 (부속서 A 통제 적용)', '데이터 품질/출처 관리, 책임 있는 AI 개발·검증·배포, 제3자 공급망 관리'],
      ['Check & Act', '9장 성과평가, 10장 개선', '내부 심사, 경영진 검토, 지속적 모니터링 및 비적합 시정조치']],
     'ISO/IEC 42001은 조직이 인공지능 시스템을 책임감 있게 개발·제공·활용하기 위해 수립해야 하는 AI 경영시스템(AIMS)의 국제 표준이다. 기존 ISO 27001과 동일한 HLS(High Level Structure) 및 PDCA 구조를 따르며, AI 시스템 영향평가(Impact Assessment)와 데이터·모델 전주기 통제를 의무화하고 있다.',
     '인공지능기본법 준거성 입증을 위한 핵심 국제 인증'),

    (138, 1, 8, 4, '개념/데이터관리형', '데이터 관측가능성(Data Observability)',
     ['1. 현대 데이터 스택에서 데이터 관측가능성의 정의', '2. 데이터 다운타임(Data Downtime) 예방을 위한 5대 핵심 기둥(Pillars)'],
     ['1. 리드문: 단순 모니터링을 넘어선 데이터 파이프라인 건강성 진단 Data Observability', '2. 데이터 수집~소비 전구간 5대 핵심 기둥(신선도·분포·볼륨·스키마·리니지) 구조도', '3. 전통적 데이터 품질 테스팅 vs 데이터 관측가능성 비교', '4. DataOps 및 AI 학습 파이프라인 신뢰성 확보를 위한 자동화 방안'],
     'Data Downtime, 5 Pillars(Freshness, Distribution, Volume, Schema, Lineage), 이상 징후 탐지, 근본원인 분석(RCA)',
     ['5대 핵심 기둥 (5 Pillars)', '점검 질문 및 지표', '이상 발생 예시'],
     [['신선도 (Freshness) / 볼륨 (Volume)', '데이터가 제시간에 갱신되는가? / 적재 건수가 정상 범위인가?', '배치 지연으로 어제 데이터 미유입 / 테이블 행 수 0건 또는 급감'],
      ['분포 (Distribution) / 스키마 (Schema)', '필드 값의 통계적 분포(NULL 비율, 평균)가 정상인가? / 컬럼 구조가 변경되었는가?', '결제 금액 음수 유입, NULL 급증 / 업스트림 컬럼명 임의 변경'],
      ['계보 (Lineage)', '업스트림 장애 시 어느 다운스트림 대시보드·ML 모델이 영향받는가?', '원천 DB 컬럼 변경 시 깨지는 BI 리포트 및 피처 스토어 역추적']],
     '데이터 관측가능성(Data Observability)은 복잡한 데이터 파이프라인에서 데이터 장애(Data Downtime)를 조기에 탐지·예측하고 근본 원인을 분석하는 역량이다. 신선도(Freshness), 분포(Distribution), 볼륨(Volume), 스키마(Schema), 리니지(Lineage)의 5대 기둥을 상시 추적하여 잘못된 데이터가 BI나 AI 모델에 유입되는 것을 차단한다.',
     'DataOps/데이터 거버넌스 영역 최신 핵심 키워드'),

    (138, 1, 12, 3, '개념/AI보안형', '프롬프트 인젝션(Prompt Injection)과 모델 전도 공격(Model Inversion Attack)',
     ['1. LLM 취약점 중 직접/간접 프롬프트 인젝션(Direct/Indirect Prompt Injection) 메커니즘', '2. 학습 데이터 프라이버시를 침해하는 모델 전도 공격(Model Inversion) 비교 및 방어 기법'],
     ['1. 리드문: AI 시스템 전주기 공격 표면(추론 입력 조작 vs 학습 데이터 역추적)', '2. 직접/간접 프롬프트 인젝션 및 모델 전도 공격 메커니즘 다이어그램', '3. 프롬프트 인젝션 vs 모델 전도 공격 vs 멤버십 추론 공격 비교표', '4. AI 가드레일(NeMo/Llama Guard), 입출력 분리 및 차분 프라이버시(DP) 방어 전략'],
     'OWASP LLM Top 10, Direct/Indirect Prompt Injection, Jailbreak, Model Inversion, Membership Inference, 차분 프라이버시(DP), AI Guardrail',
     ['공격 유형', '공격 목표 및 메커니즘', '핵심 방어 기술'],
     [['프롬프트 인젝션 (Prompt Injection)', '시스템 프롬프트 우회, 외부 웹/문서에 숨긴 간접 명령어로 권한 탈취·오작동 유도', '시스템/사용자 입력 구분자 격리, 입출력 가드레일, 에이전트 최소 권한(HITL)'],
      ['모델 전도 공격 (Model Inversion)', '모델의 출력 확률(Confidence Score)·그라디언트를 역추적하여 학습된 민감 원본 데이터(얼굴, 의료기록) 복원', '출력 확률값 라운딩/제한, 차분 프라이버시(DP-SGD) 적용 학습, 쿼리 속도 제한']],
     '프롬프트 인젝션은 악의적 입력이나 외부 참조 문서(간접 인젝션)를 통해 LLM의 시스템 지시를 무력화하고 비인가 행위를 수행하게 하는 OWASP LLM Top 1위 취약점이며, 모델 전도 공격은 모델 API의 출력 신뢰도 점수를 반복 질의·역산하여 학습에 사용된 민감 원본 데이터를 재구성하는 프라이버시 침해 공격이다.',
     '138회 1교시 12번·13번 나란히 출제된 AI 보안 핵심 토픽'),

    (138, 2, 2, 7, '비교/방법론형', 'ISP(정보화전략계획)와 ISMP(정보시스템 마스터플랜)의 비교 및 연계 방안',
     ['가. ISP와 ISMP의 개념 및 추진 배경', '나. 수행 시점, 핵심 활동, 주요 산출물 관점의 차이점 비교', '다. 대규모 공공·금융 차세대 사업에서 ISP-ISMP 연계 및 요구사항 상세화(RFP) 방안'],
     ['1. 리드문: 중장기 경영전략 정렬(ISP)과 구축 사업 실행력 확보(ISMP)의 정의', '2. 경영전략 → ISP(3~5년 로드맵) → ISMP(RFP/제안요청서 상세화) → 본사업 구축 연계도', '3. ISP vs ISMP 상세 비교표 (목적, 수립기간, 핵심 산출물, 예산 산정 방식)', '4. 애자일·클라우드 네이티브 전환 환경에서의 ISP/ISMP 혁신 제언'],
     '환경분석, 현황분석(As-Is), 미래모형(To-Be), 이행계획, EA(ITA), 기능점수(FP) 산정, 요구사항 정의서(RFP)',
     ['비교 항목', 'ISP (Information Strategy Planning)', 'ISMP (Information System Master Plan)'],
     [['수립 목적', '경영전략과 연계한 중장기(3~5년) 정보화 비전 및 이행 로드맵 수립', '특정 구축 대상 사업의 상세 요구사항 정의 및 실행 가능한 RFP 작성'],
      ['주요 산출물', 'As-Is/To-Be 아키텍처, 정보화 과제 도출, 중장기 투자계획', '상세 요구사항정의서, 업무/기능 목록, FP 기반 정밀 사업비·일정 산정, RFP'],
      ['핵심 효과', '비즈니스-IT 정렬(Alignment) 및 중복 투자 방지', '발주자-수행사 간 과업 범위 분쟁 예방 및 본사업 성공률 제고']],
     'ISP는 조직의 중장기 경영전략을 달성하기 위해 3~5년 단위의 미래 정보화 청사진(To-Be)과 이행 과제를 도출하는 계획이며, ISMP는 도출된 특정 대규모 구축 사업의 발주 전에 요구사항을 정밀 분석하고 기능점수(FP) 기반 적정 예산과 제안요청서(RFP)를 작성하는 실무 기획 단계다.',
     '125회·130회·138회 반복 출제된 IT경영 최고 빈출 토픽'),

    (138, 2, 3, 6, '비교/컴퓨터구조형', '인공지능 학습 및 추론에 이용하는 GPU와 TPU(NPU)의 구조 및 특징 비교',
     ['가. CPU, GPU, TPU(NPU)의 아키텍처적 차이점', '나. TPU의 핵심인 시스톨릭 어레이(Systolic Array) 구조와 데이터 재사용 원리', '다. 워크로드 특성별 AI 반도체 선택 및 HBM/CXL 인터커넥트 최적화 방안'],
     ['1. 리드문: 대규모 행렬 연산(GEMM) 가속을 위한 AI 반도체 아키텍처 진화', '2. GPU(SIMT/스트리밍 멀티프로세서) vs TPU(Systolic Array 데이터 흐름) 구조도', '3. CPU vs GPU vs TPU/NPU 아키텍처·연산방식·전성비 비교표', '4. HBM3e/HBM4 메모리 대역폭 확보 및 CXL 기반 이기종 가속기 풀링 제언'],
     'SIMT, Tensor Core, Systolic Array(시스톨릭 어레이), GEMM(행렬곱), HBM(고대역폭 메모리), 전성비(TOPS/W), 양자화(FP16/INT8)',
     ['비교 항목', 'GPU (Graphics Processing Unit)', 'TPU / NPU (AI 전용 가속기)'],
     [['핵심 아키텍처', '수천 개의 ALU 코어 기반 SIMT 병렬 구조 + Tensor Core', '레지스터 접근을 최소화한 2차원 Systolic Array(맥동 배열) 행렬 연산기'],
      ['메모리 접근 특성', '연산마다 레지스터 파일(Register File)/공유 메모리 읽기·쓰기 반복', 'PE(Processing Element) 간 데이터를 물 흐르듯 직접 전달하여 메모리 병목 제거'],
      ['장단점 및 용도', '범용성 우수(CUDA 생태계, 그래픽·HPC·AI 겸용), 전력 소모 높음', '대규모 행렬곱(Transformer) 전성비(TOPS/W) 극대화, 비표준 연산 유연성 낮음']],
     'GPU는 수천 개의 코어를 활용한 SIMT 병렬 처리와 CUDA 생태계를 바탕으로 범용 AI 학습을 주도하며, TPU(Tensor Processing Unit)는 연산 유닛(PE)들이 레지스터를 거치지 않고 인접 유닛으로 가중치와 활성화 값을 직접 흘려보내는 시스톨릭 어레이(Systolic Array) 구조를 채택하여 딥러닝 행렬곱 연산의 전력 효율과 처리량을 극대화한다.',
     'AI 인프라 하드웨어(GPU/TPU, CXL, HBM) 핵심 기출'),

    (138, 4, 3, 5, '개념/차세대통신형', '6G 이동통신의 핵심 개념인 AI-Native Network 설명',
     ['가. IMT-2030(6G) 6대 시나리오 및 AI-Native Network의 정의', '나. AI for Network(망 자율 최적화)와 Network for AI(분산 AI 연산 지원) 양방향 구조', '다. AI-RAN, 네트워크 디지털 트윈 연계 구현 방안'],
     ['1. 리드문: 통신과 AI의 내재적 결합 IMT-2030(6G) AI-Native Network', '2. AI for Network & Network for AI 양방향 아키텍처 및 AI-RAN 구조도', '3. 5G(Add-on AI) vs 6G(AI-Native Network) 비교표', '4. 센싱·통신 융합(ISAC) 및 비지상망(NTN) 결합 차세대 인프라 제언'],
     'IMT-2030, AI-Native Air Interface, AI for Network, Network for AI, AI-RAN, 네트워크 디지털 트윈, ISAC(통합센싱통신)',
     ['비교 구분', '5G 네트워크 (Add-on AI)', '6G AI-Native Network (IMT-2030)'],
     [['AI 결합 방식', '기존 프로토콜 설계 후 운영·관제(SON)에 보조적으로 AI 적용', '무선 접속망(PHY/MAC)부터 코어망까지 전 계층에 AI가 기본 내재화(Native)'],
      ['핵심 기능', '트래픽 예측, 부분적 장애 탐지', 'AI for Network(채널추정·빔포밍 자율화) + Network for AI(분산 엣지 연합학습 지원)'],
      ['인프라 활용', '통신 전용 기지국 자원 활용', 'AI-RAN 기반 GPU 공용화로 기지국 유휴 자원을 엣지 AI 추론에 활용']],
     '6G(IMT-2030)의 핵심 패러다임인 AI-Native Network는 네트워크 설계 초기부터 물리계층(Air Interface)·무선접속망(AI-RAN)·코어망 전반에 AI를 내재화하는 구조다. AI로 통신 품질과 에너지를 자율 최적화하는 AI for Network와, 초저지연 통신망으로 온디바이스·엣지 분산 AI 학습/추론을 뒷받침하는 Network for AI의 양방향 융합으로 구현된다.',
     '130회·135회 6G 일반 개요 → 138회 4교시 6G AI-Native Network로 심화 출제'),

    # --- 제137회 (2025년 8월) 대표 기출 ---
    (137, 1, 5, 1, '개념/알고리즘형', 'GNN(Graph Neural Network) 및 GraphRAG 활용',
     ['1. 비유클리드 그래프 데이터 처리를 위한 GNN의 개념과 메시지 패싱(Message Passing) 원리', '2. GCN, GAT 등 주요 모델 및 지식그래프 결합 GraphRAG 응용'],
     ['1. 리드문: 관계형·네트워크 구조 데이터 학습을 위한 GNN 정의', '2. 이웃 노드 집계(Aggregate) 및 갱신(Update) 메시지 패싱 구조도', '3. CNN/RNN vs GNN(GCN, GraphSAGE, GAT) 비교', '4. 금융 이상거래 탐지(FDS), 신약 개발 및 GraphRAG 연계 활용 방안'],
     '비유클리드 공간, 노드(Node)·간선(Edge) 임베딩, Message Passing(Aggregate & Update), GCN, GAT, 과평활화(Over-smoothing), GraphRAG',
     ['구분', 'CNN / Transformer', 'GNN (Graph Neural Network)'],
     [['데이터 구조', '격자형(이미지) 또는 순차형(텍스트) 유클리드 데이터', '위상 구조가 불규칙한 비유클리드 그래프(소셜망, 분자구조, 지식그래프)'],
      ['핵심 연산', '합성곱 필터 또는 Self-Attention', '이웃 노드의 특징을 모으는 Message Passing (Aggregate → Update)'],
      ['한계 및 해결', '개체 간 복잡한 다중 관계 표현 한계', '층이 깊어질수록 노드 표현이 같아지는 과평활화(Over-smoothing) → 잔차연결/GAT로 완화']],
     'GNN(그래프 신경망)은 노드(정점)와 엣지(간선)로 구성된 비유클리드 그래프 구조 데이터를 직접 입력받아, 인접 노드의 정보를 집계(Aggregate)하고 중심 노드의 상태를 갱신(Update)하는 메시지 패싱(Message Passing) 메커니즘으로 그래프 표현을 학습한다. 최근에는 LLM의 글로벌 맥락 추론 한계를 보완하는 GraphRAG의 핵심 기술로도 각광받고 있다.',
     'AI 모델 아키텍처 심화 기출'),

    (137, 1, 7, 1, '비교/아키텍처형', '트랜스포머(Transformer)와 MoE(Mixture of Experts) 비교',
     ['1. Dense 모델(표준 Transformer)의 연산량 한계', '2. Sparse MoE(게이팅 네트워크 + 전문가 신경망)의 동작 원리 및 효율성 비교'],
     ['1. 리드문: 초거대 LLM의 파라미터 확장과 추론 비용 절감을 위한 Sparse MoE', '2. 표준 FFN 계층 vs MoE 계층(Router/Gating Network + Top-K Experts) 구조도', '3. Dense Transformer vs Sparse MoE 비교표', '4. 전문가 부하 불균형(Load Balancing Loss) 및 VRAM 요구량 최적화 방안'],
     'Self-Attention, Dense Model, Sparse MoE, Gating Network(Router), Top-K 조건부 연산, 보조 손실(Auxiliary Load Balancing Loss)',
     ['비교 항목', '표준 Dense Transformer', 'Sparse MoE (Mixture of Experts)'],
     [['연산 활성화 방식', '입력 토큰마다 전체 파라미터(100%)가 항상 연산에 참여', '라우터(Gating Network)가 토큰별로 상위 K개(예: 8개 중 2개) 전문가(Expert)만 선택 활성화'],
      ['학습 및 추론 효율', '파라미터 증가에 비례하여 FLOPs(연산량)와 추론 지연시간 급증', '총 파라미터 수는 수조 개로 키우면서 토큰당 실제 연산량(Active Parameter)은 소규모 유지'],
      ['단점 및 과제', '초거대 스케일링 시 연산 비용 과다', '전체 전문가 가중치를 메모리에 적재해야 하므로 VRAM 요구량 큼, 라우팅 편중 방지 필요']],
     'MoE(Mixture of Experts)는 트랜스포머의 피드포워드(FFN) 계층을 다수의 전문가(Expert) 서브 네트워크로 분할하고, 게이팅 라우터(Router)를 통해 각 입력 토큰마다 가장 적합한 소수(Top-K)의 전문가만 조건부 활성화(Sparse Activation)하는 아키텍처다. 모델의 지식 용량(총 파라미터)을 대폭 확장하면서도 추론 연산량(FLOPs)을 낮게 유지할 수 있다.',
     '최신 프론티어 LLM의 핵심 아키텍처'),

    (137, 2, 3, 3, '원인분석/대응전략형', 'MCP(Model Context Protocol)를 이용한 인공지능 서비스 구축 시 보안 취약점 및 대응 방안',
     ['가. 에이전틱 AI 연동을 위한 MCP(Host-Client-Server) 아키텍처와 구성요소', '나. MCP 환경의 주요 보안 위협(Tool Poisoning, Rug Pull, 권한 오남용, 간접 프롬프트 인젝션)', '다. 엔터프라이즈 MCP 도입을 위한 보안 통제 및 거버넌스 방안'],
     ['1. 리드문: AI 에이전트와 외부 도구·데이터 표준 연결 인터페이스 MCP 정의', '2. MCP 아키텍처(MCP Host - MCP Client - MCP Server - 데이터소스/API) 및 위협 지점도', '3. MCP 4대 보안 취약점(도구 오염, 악성 서버 위장, 토큰 유출, 과도한 권한) 및 대응책', '4. 샌드박싱, OAuth 2.1/NHI 통제, 서명된 MCP 레지스트리 구축 제언'],
     'Model Context Protocol, MCP Host/Client/Server, Tool Poisoning(도구 설명 오염), Rug Pull, OAuth 2.1, 최소 권한, HITL(인간 승인)',
     ['MCP 보안 위협', '공격 메커니즘', '핵심 대응 방안'],
     [['Tool Poisoning (도구 오염)', 'MCP 서버의 도구 설명(Description) 메타데이터에 악성 프롬프트를 숨겨 에이전트가 기밀을 유출하도록 유도', '도구 메타데이터 정적/동적 검증, 시스템 프롬프트와 도구 설명 컨텍스트 격리'],
      ['Rug Pull & 공급망 위변조', '초기 정상 승인 후 MCP 서버 코드를 악성으로 업데이트하여 명령어 실행', 'MCP 패키지 코드 서명·해시 고정(Pinning), 사내 검증된 Private MCP Registry 운영'],
      ['권한 오남용 (Confused Deputy)', '에이전트가 과도한 DB/시스템 권한을 가진 MCP 서버를 통해 파괴적 쿼리 실행', '사용자별 OAuth 2.1 범위(Scope) 제한, 민감 작업 시 인간 승인(HITL) 게이트 강제']],
     'MCP(Model Context Protocol)는 LLM 애플리케이션(Host)이 외부 데이터 소스 및 도구(MCP Server)와 표준화된 JSON-RPC 방식으로 통신하도록 지원하는 오픈 프로토콜이다. 제136회 1교시 개념 출제 직후 제137회 2교시에서 보안 취약점(Tool Poisoning, 공급망 Rug Pull, Confused Deputy)과 대응 방안으로 심화 출제되었으며, 1교시 신기술이 차기 회차 2~4교시 보안/아키텍처 문제로 승격되는 대표적 사례다.',
     '136회 1교시 MCP → 137회 2교시 MCP 보안 취약점 승격 대표 사례!'),

    (137, 3, 6, 3, '개념/법제도보안형', '국가 망 보안체계(N²SF, National Network Security Framework) 추진 배경과 구현 방안',
     ['가. 기존 획일적 망분리 정책의 한계와 N2SF 전환 배경', '나. 업무 중요도에 따른 3단계 등급 분류(기밀 Class, 민감 Sensitive, 공개 Open) 및 차등 보안 통제', '다. 클라우드·생성형 AI 활용을 위한 CDS(영역 간 보안연계) 및 제로트러스트 결합 방안'],
     ['1. 리드문: 획일적 물리 망분리에서 데이터 중요도 기반 다층보안체계(N2SF)로의 전환', '2. N2SF 3등급(C: 기밀 / S: 민감 / O: 공개) 분류 및 영역 간 데이터 유통(CDS) 구조도', '3. 기존 망분리 정책 vs 국가 망 보안체계(N2SF) 비교표', '4. 공공·금융 부문 SaaS 및 생성형 AI 안전 활용을 위한 단계별 전환 로드맵'],
     '망분리 개선, N2SF(국가망보안체계), C/S/O 등급 분류(Classified/Sensitive/Open), 차등 보안통제, CDS(Cross Domain Solution), 제로트러스트',
     ['비교 항목', '기존 물리적/논리적 망분리', '국가 망 보안체계 (N²SF)'],
     [['보안 패러다임', '업무망·인터넷망 이분법적 경계 차단 중심', '업무·정보 중요도(기밀 C / 민감 S / 공개 O)에 따른 차등적 보안 통제'],
      ['신기술 활용성', '외부 클라우드(SaaS) 및 생성형 AI(LLM) 연계 극히 제한적', '민감(S)·공개(O) 등급에서 보안통제 하에 외부 AI·SaaS 적극 활용 가능'],
      ['핵심 기술 요소', '망연계 솔루션, VDI/SBC', '데이터 등급 분류, CDS(Cross Domain Solution), 제로트러스트(ICAM, PEP/PDP)']],
     '국가 망 보안체계(N²SF)는 공공기관의 클라우드·생성형 AI 활용을 가로막던 획일적 망분리 규제를 개선하여, 취급하는 업무와 데이터의 중요도를 기밀(Classified), 민감(Sensitive), 공개(Open)의 3등급으로 분류하고 등급별로 차등화된 보안통제 항목을 적용하는 신보안 프레임워크다.',
     '공공·금융 보안 최대 이슈로 제로트러스트와 함께 지속 출제 유력'),

    (137, 4, 2, 4, '비교/알고리즘형', '벡터 데이터베이스(Vector DB)의 효율적 검색을 위한 HNSW와 IVF 인덱싱 기법 비교',
     ['가. 고차원 임베딩 공간에서 근사 최근접 이웃(ANN, Approximate Nearest Neighbor) 검색의 필요성', '나. 그래프 기반 HNSW와 군집 기반 IVF(Inverted File Index)의 동작 원리 및 장단점 비교', '다. 대규모 RAG 시스템에서 PQ(Product Quantization) 결합을 통한 메모리·성능 최적화 방안'],
     ['1. 리드문: 고차원 벡터 검색의 차원의 저주 극복을 위한 ANN 인덱싱 정의', '2. HNSW(다층 스킵리스트 그래프 탐색) vs IVF(보로노이 셀 군집 탐색) 구조도', '3. Flat(전수조사) vs IVF vs HNSW vs PQ 결합 비교표', '4. 실시간 업데이트 빈도와 메모리 제약에 따른 엔터프라이즈 Vector DB 인덱스 선정 기준'],
     'ANN(근사 최근접 이웃), HNSW(Hierarchical Navigable Small World), IVF(Inverted File Index), PQ(Product Quantization), Recall@K vs QPS',
     ['인덱스 기법', '동작 원리', '검색 속도 / 재현율(Recall)', '메모리 사용량 및 특징'],
     [['IVF (역파일 인덱스)', 'K-Means로 벡터 공간을 보로노이 셀로 군집화 후 인접 중심점(nprobe) 셀만 탐색', '빠름 / nprobe 설정에 비례', '메모리 효율 우수, 경계면(Edge) 근처 벡터 누락 방지 위해 nprobe 튜닝 필요'],
      ['HNSW (계층적 소세계 그래프)', 'Skip-list와 NSW 그래프를 결합하여 상위 희소 계층에서 하위 밀집 계층으로 고속 이동', '매우 빠름(최고 QPS) / 매우 높음', '그래프 간선(M) 저장으로 메모리(RAM) 소모가 매우 큼'],
      ['IVF-PQ / HNSW-PQ', '고차원 벡터를 서브벡터로 쪼개어 코드북 ID로 양자화 압축(Product Quantization)', '초고속 연산(비대칭 거리계산) / 약간의 정밀도 손실', '메모리 사용량을 1/4 ~ 1/16로 대폭 압축하여 수억 건 규모 서빙에 필수']],
     '고차원 벡터 데이터베이스에서 전수 조사(Flat KNN)는 연산량이 폭증하므로 약간의 정확도를 트레이드오프하여 속도를 극대화하는 ANN(Approximate Nearest Neighbor) 인덱싱이 필수적이다. HNSW는 다층 소세계 그래프를 통해 최고 수준의 검색 속도와 재현율(Recall)을 제공하나 메모리 소모가 크며, IVF는 K-Means 클러스터링 기반으로 메모리 효율이 좋아 PQ(곱 양자화)와 결합해 대규모 벡터 서빙에 활용된다.',
     'RAG 인프라의 핵심 기술 기출'),
])

RAW_QUESTIONS.extend([
    # --- 제136회 (2025년 5월) 대표 기출 ---
    (136, 1, 3, 1, '개념/아키텍처형', '에이전틱 AI(Agentic AI)의 개념 및 핵심 구성요소',
     ['1. 수동적 생성형 AI(Generative AI)와 자율적 에이전틱 AI의 차이점', '2. 에이전틱 AI 4대 핵심 구성요소(Planning, Memory, Tool Use, Action/Reflection)'],
     ['1. 리드문: 프롬프트 응답에서 목표 지향 자율 실행으로 진화한 Agentic AI', '2. Agentic AI 아키텍처(Perception - Brain/Planning - Memory - Tool/MCP Action) 구조도', '3. 전통 RPA vs 생성형 AI(Copilot) vs 에이전틱 AI(Autonomous Agent) 비교', '4. Multi-Agent 오케스트레이션(A2A/MCP) 및 무한 루프·권한 통제(HITL) 제언'],
     'Autonomous Agent, Planning(ReAct, CoT, ToT), 단기/장기 메모리, Tool Use(Function Calling, MCP), Self-Reflection, Multi-Agent',
     ['구분', '생성형 AI (Generative AI / Copilot)', '에이전틱 AI (Agentic AI)'],
     [['주도권 및 작동 방식', '인간 프롬프트 입력 시 단일 턴(Single-turn) 콘텐츠 생성 (수동적)', '최종 목표 부여 시 스스로 하위 과업 분해·도구 호출·검증 수행 (자율적)'],
      ['핵심 메커니즘', 'Next-Token Prediction, In-context Learning', '계획(Planning) + 기억(Memory) + 도구 사용(Tool/MCP) + 성찰(Reflection)'],
      ['주요 리스크', '환각(Hallucination), 부적절한 텍스트 생성', '비인가 API 실행, 에이전트 간 루프, 비인간 신원(NHI) 권한 오남용']],
     '에이전틱 AI(Agentic AI)는 사용자의 세부 지시 없이도 상위 목표를 달성하기 위해 스스로 계획을 수립(Planning)하고, 외부 도구·API(MCP)를 호출하며, 실행 결과를 스스로 점검(Self-Reflection)하여 다단계 과업을 완수하는 자율형 인공지능 시스템이다.',
     '136회 1교시 출제 후 137회 MCP, 140회 AI-BPR/NHI로 파생 확장'),

    (136, 1, 4, 4, '개념/데이터모델링형', '데이터베이스 제4정규형(4NF)과 다치 종속(Multi-valued Dependency)',
     ['1. 다치 종속(MVD, A ->> B)의 개념과 발생 조건', '2. 제4정규형(4NF)의 정의 및 정규화 수행 사례'],
     ['1. 리드문: BCNF 이후 이상현상 제거를 위한 다치 종속(MVD)과 제4정규형 정의', '2. 하나의 릴레이션에 두 개 이상의 독립적인 1:N 다치 속성이 공존할 때의 카티션 곱 중복 구조도', '3. BCNF vs 제4정규형(4NF) vs 제5정규형(5NF) 비교표', '4. 실무 대용량 DB에서의 정규화 및 조회 성능 고려 반정규화 기준'],
     '다치 종속(MVD, A ->> B), 자명한 다치 종속, 슈퍼키(Super Key), 제4정규형(4NF), 카티션 곱 중복 제거, 5NF(조인 종속)',
     ['정규화 단계', '제거 대상 종속성', '핵심 성립 조건'],
     [['BCNF (보이스-코드 정규형)', '결정자가 후보키가 아닌 함수 종속(FD) 제거', '모든 결정자(Determinant)가 후보키(Super Key)일 것'],
      ['제4정규형 (4NF)', '비자명 다치 종속(Multi-valued Dependency, A ->> B) 제거', '한 테이블에 독립적인 1:N 다치 속성이 2개 이상 함께 존재하지 않도록 분해'],
      ['제5정규형 (5NF, PJNF)', '후보키를 통하지 않는 조인 종속(Join Dependency) 제거', '무손실 조인 분해 시 모든 조인 종속이 후보키에 의해서만 성립할 것']],
     '제4정규형(4NF)은 보이스-코드 정규형(BCNF)을 만족하면서, 자명하지 않은 다치 종속(Multi-valued Dependency, A ->> B)이 존재할 때 모든 결정자 A가 슈퍼키이도록 독립된 릴레이션으로 분해한 상태다. 예를 들어 사원 테이블에 독립적인 다치 속성인 [자격증]과 [어학능력]이 함께 있으면 불필요한 조합 중복이 발생하므로 두 테이블로 분리해야 4NF를 만족한다.',
     'DB 정규화 이론 핵심 빈출'),

    (136, 1, 8, 6, '개념/컴퓨터구조형', 'CXL(Compute Express Link) 인터커넥트 기술',
     ['1. PCIe 기반 CXL 프로토콜의 등장 배경과 메모리 벽(Memory Wall) 문제', '2. 3가지 세부 프로토콜(CXL.io, CXL.cache, CXL.mem) 및 메모리 풀링(Memory Pooling)·공유 구조'],
     ['1. 리드문: 이기종 컴퓨팅 메모리 확장 및 캐시 일관성을 위한 CXL 정의', '2. CXL 3대 프로토콜(CXL.io / CXL.cache / CXL.mem) 및 스위치 기반 메모리 풀링 구조도', '3. 기존 서버 고정 할당 메모리 vs CXL 메모리 확장·풀링(CXL 1.1 / 2.0 / 3.0) 비교', '4. 초거대 AI 추론 서버의 GPU VRAM 한계 극복을 위한 CXL-PNM/CMS 활용 방안'],
     'Memory Wall, PCIe 5.0/6.0 물리계층, CXL.io, CXL.cache, CXL.mem, 캐시 일관성(Cache Coherency), Memory Pooling(메모리 풀링)',
     ['CXL 프로토콜', '핵심 역할', '적용 시나리오'],
     [['CXL.io', 'PCIe 기반 장치 탐색, 초기화, 설정, DMA 및 인터럽트 처리 (필수 기본 프로토콜)', '모든 CXL 디바이스의 기본 I/O 제어'],
      ['CXL.cache', '가속기(GPU/FPGA/NIC)가 호스트 CPU 메모리에 저지연 캐시 일관성으로 접근', '스마트NIC, AI 가속기가 CPU 메모리를 직접 참조'],
      ['CXL.mem', '호스트 CPU가 CXL 장치에 장착된 확장 메모리(DRAM/PMEM)를 자신의 메모리 공간처럼 로드/스토어', 'CXL 메모리 확장기(Type 3) 및 다중 서버 간 동적 메모리 풀링']],
     'CXL(Compute Express Link)은 PCIe 5.0/6.0 물리 계층 위에서 CPU와 GPU·가속기·메모리 확장 장치 간 초저지연 캐시 일관성(Cache Coherency)과 메모리 공유(Memory Pooling)를 제공하는 개방형 인터커넥트 표준이다. CXL.io, CXL.cache, CXL.mem 3가지 프로토콜을 통해 서버 간 유휴 메모리를 동적으로 할당하고 AI 추론의 메모리 병목(Memory Wall)을 해소한다.',
     '138회 GPU/TPU, 137회 캐시 메모리와 함께 컴퓨터구조 3대 축'),

    (136, 1, 10, 8, '비교/법제도형', '개인정보 안심구역과 데이터 안심구역 비교',
     ['1. 안전한 데이터 결합·분석을 위한 안심구역 제도의 취지', '2. 개인정보보호법상 개인정보 안심구역과 데이터산업법상 데이터 안심구역의 차이점 비교'],
     ['1. 리드문: 민감·미개방 데이터의 안전한 AI 학습·분석을 위한 안심구역 제도', '2. 제로트러스트·물리/논리 폐쇄망 기반 안심구역 분석 및 반출 심의 구조도', '3. 개인정보 안심구역 vs 데이터 안심구역 비교표 (소관부처, 근거법령, 취급대상, 핵심특례)', '4. 합성데이터 및 연합학습 연계 안심구역 고도화 제언'],
     '개인정보보호위원회(개인정보보호법), 과기정통부(데이터산업법), 가명정보 결합·샘플링, 미개방 원본 데이터, 반출심의위원회',
     ['비교 항목', '개인정보 안심구역', '데이터 안심구역'],
     [['소관 부처 / 근거 법령', '개인정보보호위원회 / 개인정보 보호법(고시)', '과학기술정보통신부·국토부 등 / 데이터 산업진흥 및 이용촉진 기본법'],
      ['주요 취급 데이터', '높은 수준의 가명정보, 장기 시계열 결합 가명정보, AI 학습용 비정형 가명정보', '유출 시 위험이 큰 미개방 원천 데이터(금융, 교통, 의료, 기업 비밀 데이터 등)'],
      ['핵심 허용 특례', '사전 적정성 검토 간소화, 표본 추출(샘플링)·반복 결합 및 장기 보관 허용', '폐쇄된 보안 환경 내에서 미개방 데이터 분석 후 통계·AI 모델 가중치만 심사 후 반출']],
     '개인정보 안심구역은 개인정보보호위원회가 지정하여 제3자 제공 시 재식별 위험이 있는 고가치 가명정보의 유연한 샘플링·장기 시계열 분석·AI 학습을 허용하는 공간이며, 데이터 안심구역은 과기정통부 등이 데이터산업법에 의거하여 외부에 공개하기 어려운 미개방 원천 데이터를 물리·기술적으로 통제된 공간에서 분석하고 결과물(AI 모델 등)만 반출하도록 지원하는 제도다.',
     '135회 1교시 개인정보 안심구역 → 136회 1교시 데이터 안심구역과의 비교로 연속 출제!'),

    # --- 제135회 (2025년 2월) 대표 기출 ---
    (135, 1, 1, 1, '비교/모델평가형', '분류 모델 성능 평가를 위한 PR 곡선(Precision-Recall Curve)과 ROC 곡선 비교',
     ['1. 혼동 행렬(Confusion Matrix) 기반 정밀도, 재현율, 민감도, 특이도 정의', '2. 클래스 불균형(Class Imbalance) 데이터셋에서 PR 곡선과 ROC 곡선의 특성 비교'],
     ['1. 리드문: 이진 분류기의 임계값(Threshold) 변화에 따른 성능 평가 곡선', '2. 혼동 행렬(TP, FP, FN, TN) 및 PR Curve vs ROC Curve(AUC) 그래프 구조도', '3. PR 곡선(Precision-Recall) vs ROC 곡선(TPR-FPR) 비교표', '4. 신용카드 사기 탐지(FDS)·희귀 질환 진단 등 극단적 불균형 데이터 평가 기준'],
     'Confusion Matrix, Precision(정밀도), Recall(재현율=TPR), FPR(1-특이도), AUC, 클래스 불균형(Class Imbalance)',
     ['비교 항목', 'ROC 곡선 (Receiver Operating Characteristic)', 'PR 곡선 (Precision-Recall Curve)'],
     [['X축 / Y축 지표', 'X축: FPR = FP / (FP + TN), Y축: TPR(Recall) = TP / (TP + FN)', 'X축: Recall = TP / (TP + FN), Y축: Precision = TP / (TP + FP)'],
      ['TN(진음성) 포함 여부', 'FPR 계산에 TN(정상 데이터를 정상으로 분류한 수)이 분모에 포함됨', 'TN을 전혀 사용하지 않고 양성(Positive) 예측과 실제 양성만 집중 평가'],
      ['불균형 데이터 적합성', '정상(TN)이 압도적으로 많으면 FPR이 항상 작게 나와 성능이 과대평가됨', '소수 클래스(이상거래, 불량, 암 환자) 탐지 성능을 왜곡 없이 민감하게 반영']],
     'ROC 곡선은 임계값 변화에 따른 FPR(위양성률) 대비 TPR(재현율)을 나타내어 전반적인 분류기 판별력을 평가하며, PR 곡선은 Recall(재현율) 대비 Precision(정밀도)을 나타낸다. 이상거래 탐지처럼 음성(TN) 샘플이 압도적으로 많은 클래스 불균형 데이터셋에서는 ROC-AUC가 낙관적으로 왜곡되므로 TN을 배제하는 PR-AUC(Average Precision)를 사용하는 것이 타당하다.',
     '머신러닝 모델 평가 지표 대표 기출'),

    (135, 1, 5, 3, '비교/보안관제형', 'SIEM(Security Information and Event Management)과 SOAR(Security Orchestration, Automation and Response) 비교',
     ['1. 차세대 보안관제센터(SOC)에서 SIEM과 SOAR의 역할', '2. 빅데이터 상관분석 중심의 SIEM과 플레이북 자동 대응 중심의 SOAR 비교'],
     ['1. 리드문: 지능화되는 사이버 위협과 관제 인력 피로도(Alert Fatigue) 해소를 위한 SIEM & SOAR', '2. 로그 수집·상관분석(SIEM) → 플레이북 기반 오케스트레이션·자동 차단(SOAR) 연계 구조도', '3. ESM vs SIEM vs SOAR 비교표 (핵심 기능, 분석 대상, 대응 방식, MTTR 단축)', '4. XDR 및 AI SOC(자율형 보안관제)로의 진화 방향'],
     'SOC(보안관제센터), 빅데이터 상관분석, Alert Fatigue(경보 피로도), Playbook(표준대응절차), Orchestration, MTTR(평균대응시간) 단축',
     ['비교 항목', 'SIEM (보안 정보 및 이벤트 관리)', 'SOAR (보안 오케스트레이션·자동화 및 대응)'],
     [['핵심 목적', '이기종 보안장비·시스템 로그 통합 수집 및 상관분석을 통한 위협 탐지', '탐지된 위협에 대해 표준 플레이북(Playbook)에 따라 분석·차단·대응을 자동화'],
      ['주요 기능', '빅데이터 인덱싱, 실시간/장기 상관분석 규칙, 위협 인텔리전스(TI) 연동 경보', '외부 방화벽/EDR API 연동 오케스트레이션, 반복 티켓 자동 처리, 케이스 관리'],
      ['한계 및 상호보완', '경보만 발생시키고 실제 차단은 분석가 수동 개입 필요(Alert Fatigue)', 'SIEM의 탐지 이벤트를 입력받아 MTTR(평균 대응 시간)을 수 시간에서 수 초로 단축']],
     'SIEM은 기업 내 방화벽, IDS/IPS, 서버 등에서 발생하는 대규모 보안 로그를 수집하고 빅데이터 상관분석을 통해 이상 징후를 탐지·경보하는 시스템이며, SOAR는 SIEM 등에서 발생한 수많은 보안 경보에 대해 사전 정의된 플레이북(Playbook)을 기반으로 위협 검증과 방화벽 차단 등 사고 대응 과정을 오케스트레이션·자동화하여 평균 대응 시간(MTTR)을 획기적으로 단축하는 솔루션이다.',
     '보안관제 아키텍처 핵심 비교 토픽'),

    (135, 2, 1, 4, '절차/데이터모델링형', '물리 데이터 모델링에서 반정규화(De-normalization)의 개념, 적용 절차 및 기법(테이블/컬럼/관계) 설명',
     ['가. 반정규화의 정의와 비정규화(Un-normalized)와의 차이점', '나. 반정규화 적용 전 선행 검토 사항(뷰, 클러스터링, 인덱스, 파티셔닝) 및 수행 절차', '다. 대상별 반정규화 기법(테이블 병합/분할/추가, 중복 컬럼 추가, 중복 관계 추가)과 데이터 무결성 보장 방안'],
     ['1. 리드문: 정규화 완료 후 조인 성능 극대화를 위한 의도적 설계 기법 반정규화', '2. 반정규화 4단계(대상조사 → 다른 방법 유도 검토 → 반정규화 적용 → 무결성 통제) 절차도', '3. 테이블·컬럼·관계 반정규화 세부 기법 분류표', '4. 트리거·배치·애플리케이션 트랜잭션 기반 중복 데이터 정합성 유지 방안'],
     'De-normalization, 선행 대안 검토(인덱스·파티셔닝·클러스터링), 테이블 병합/분할(수직·수평), 파생/중복 컬럼, 이력 테이블, 데이터 무결성',
     ['반정규화 대상', '세부 적용 기법', '적용 시나리오 및 주의사항'],
     [['테이블 반정규화', '1:1 / 1:M 테이블 병합, 수평/수직 분할, 통계·이력·중복 테이블 추가', '대량 조인 발생 시 병합, 특정 컬럼 집중 조회 시 수직 분할'],
      ['컬럼 반정규화', '중복 컬럼 추가, 파생 컬럼(계산값) 추가, 이력 테이블 기능 컬럼(최신여부) 추가', '주문금액 합계 등 실시간 연산 부하 감소, 단 갱신 시 동기화 필수'],
      ['관계 반정규화', '중복 관계(Direct Relationship) 추가', 'A→B→C 다단계 조인을 A→C 직접 외래키 관계 추가로 경로 단축 (데이터 중복 없이 성능 개선)']],
     '반정규화(De-normalization)는 정규화를 충실히 수행한 데이터 모델에서 디스크 I/O가 많거나 다중 조인으로 인해 조회 성능이 저하될 때, 인덱스 튜닝·파티셔닝·클러스터링 등 다른 대안을 먼저 검토한 뒤 제한적으로 데이터 중복이나 구조 변경을 허용하는 물리 모델링 기법이다. 중복으로 인한 정합성 훼손을 막기 위해 트리거(Trigger)나 애플리케이션 트랜잭션 동기화 설계가 반드시 수반되어야 한다.',
     'DB 모델링 서술형 정통 기출'),

    # --- 제134회 ~ 제120회 핵심 스테디셀러 기출 ---
    (134, 2, 1, 4, '비교/아키텍처형', '전사 데이터 아키텍처로서 데이터 패브릭(Data Fabric)과 데이터 메시(Data Mesh) 비교',
     ['가. 중앙집중형 데이터 레이크의 병목 한계', '나. 메타데이터·AI 자동화 중심의 데이터 패브릭과 도메인 주도 분산 소유권 중심의 데이터 메시 비교', '다. 조직 성숙도에 따른 하이브리드 도입 전략'],
     ['1. 리드문: 데이터 사일로 해소와 민첩한 데이터 활용을 위한 차세대 데이터 아키텍처', '2. 데이터 패브릭(Active Metadata + 지식그래프 중앙 오케스트레이션) vs 데이터 메시(도메인별 Data as a Product) 구조도', '3. 데이터 웨어하우스/레이크 vs 데이터 패브릭 vs 데이터 메시 비교표', '4. 기술 기반 자동화(Fabric)와 조직·거버넌스 혁신(Mesh)의 상호보완적 결합 방안'],
     'Data Silo, Active Metadata, 지식그래프, 데이터 가상화, Data Mesh, 도메인 주도 설계(DDD), Data as a Product, 연합 거버넌스',
     ['비교 항목', '데이터 패브릭 (Data Fabric)', '데이터 메시 (Data Mesh)'],
     [['접근 관점', '기술·아키텍처 중심 (메타데이터 및 AI 기반 통합 자동화)', '조직·프로세스·거버넌스 중심 (도메인 팀 분산 소유권)'],
      ['핵심 메커니즘', '액티브 메타데이터, 지식 그래프, 데이터 가상화·카탈로그 자동화', '4대 원칙: 도메인 소유권, 데이터 제품화(Data as a Product), 셀프서비스 플랫폼, 연합 거버넌스'],
      ['적합한 조직', '이기종 멀티클라우드 데이터 소스가 복잡하게 얽힌 기술 중심 기업', '비즈니스 도메인이 명확히 분리되고 도메인 팀의 역량이 높은 대규모 조직']],
     '데이터 패브릭은 액티브 메타데이터와 지식 그래프, AI 자동화를 활용해 분산된 이기종 데이터 소스를 가상화·통합하는 기술 중심 아키텍처이며, 데이터 메시는 중앙 데이터 팀의 병목을 해결하기 위해 비즈니스 도메인 팀이 데이터를 제품(Data as a Product)으로 직접 소유·제공하고 연합 거버넌스로 표준을 맞추는 조직·아키텍처 패러다임이다.',
     '데이터 아키텍처 대표 비교 논술'),

    (133, 1, 2, 2, '개념/테스트형', '뮤테이션 테스트(Mutation Testing, 변이 테스트)',
     ['1. 테스트 스위트(Test Suite)의 결함 검출 능력을 평가하는 뮤테이션 테스트의 개념', '2. 뮤턴트(Mutant) 생성 연산자, Killed/Survived 판정 및 Mutation Score 산출식'],
     ['1. 리드문: 테스트 케이스 자체의 품질을 검증하는 결함 기반 테스트(Mutation Testing)', '2. 원본 프로그램(P) → 변이 연산자 적용(Mutant M) → 테스트 실행 → Killed vs Survived 흐름도', '3. 코드 커버리지(Line/Branch)의 한계와 뮤테이션 점수(Mutation Score) 산출 공식', '4. 동치 뮤턴트(Equivalent Mutant) 문제 및 연산 비용 최적화 방안'],
     '결함 주입(Fault Injection), 변이 연산자(Mutation Operator), Killed Mutant, Survived Mutant, 동치 뮤턴트(Equivalent Mutant), Mutation Score',
     ['구분 항목', '개념 및 판정 기준', '의미 및 후속 조치'],
     [['죽은 뮤턴트 (Killed Mutant)', '변이된 코드(예: +를 -로 변경)에 기존 테스트 케이스를 실행했을 때 실패(Fail)가 발생한 경우', '기존 테스트 케이스가 해당 코드 결함을 정상적으로 잡아냄 (우수)'],
      ['살아남은 뮤턴트 (Survived Mutant)', '변이된 코드임에도 기존 테스트 케이스가 모두 통과(Pass)해버린 경우', '기존 테스트 케이스의 검증(Assertion)이 부실함 → 신규 테스트 케이스 보강 필요'],
      ['동치 뮤턴트 (Equivalent Mutant)', '문법은 바뀌었으나 원본 프로그램과 의미·출력 결과가 100% 동일한 변이', '어떠한 테스트로도 죽일 수 없으므로 Mutation Score 분모에서 제외']],
     '뮤테이션 테스트는 높은 코드 커버리지에도 불구하고 실제 결함을 잡지 못하는 부실한 테스트 케이스(Assertion 누락 등)를 찾아내기 위해, 원본 코드에 인위적인 작은 문법 변이(Mutant)를 주입한 뒤 기존 테스트 스위트가 이를 실패(Killed)시켜 잡아내는지 평가하는 기법이다. Mutation Score = Killed / (Total - Equivalent) × 100으로 테스트의 실질적 강건성을 측정한다.',
     '127회 코드 커버리지 → 133회 뮤테이션 테스트로 심화 출제'),

    (133, 1, 5, 3, '개념/암호기술형', '동형암호(Homomorphic Encryption)의 개념과 유형',
     ['1. 복호화 없이 암호문 상태에서 연산을 수행하는 동형암호의 원리', '2. 부분 동형(PHE), 제한 동형(SHE), 완전 동형암호(FHE, 부트스트래핑) 비교'],
     ['1. 리드문: 클라우드·AI 시대의 프라이버시 보존 연산 핵심 기술 동형암호', '2. E(x) * E(y) = E(x + y) 암호문 상태 연산 및 부트스트래핑(Bootstrapping) 노이즈 제거 구조도', '3. PHE(부분) vs SHE(제한) vs FHE(완전 동형암호, CKKS/BGV/TFHE) 비교표', '4. 하드웨어 가속기(FHE ASIC/GPU) 및 프라이버시 보존 머신러닝(PPML) 적용 전망'],
     '암호문 상태 연산, 격자 기반 암호(LWE/RLWE), 노이즈 누적, 부트스트래핑(Bootstrapping), 완전동형암호(FHE), CKKS(실수 근사 연산)',
     ['동형암호 세대', '지원 연산 범위', '대표 알고리즘 및 특징'],
     [['부분 동형암호 (PHE)', '덧셈 또는 곱셈 중 한 가지 연산만 무제한 허용', 'RSA(곱셈 동형), Paillier(덧셈 동형) — 연산은 빠르나 복합 함수 불가'],
      ['제한 동형암호 (SHE/LHE)', '덧셈과 곱셈을 모두 지원하나 노이즈 누적으로 연산 횟수(회로 깊이) 제한', '초기 격자 기반 스킴 — 사전 정의된 얕은 깊이의 연산만 가능'],
      ['완전 동형암호 (FHE)', '부트스트래핑(Bootstrapping)으로 노이즈를 초기화하여 덧셈·곱셈 무제한 수행', 'BGV/BFV(정수), CKKS(실수/머신러닝 특화), TFHE(부울 게이트 고속 연산)']],
     '동형암호(Homomorphic Encryption)는 데이터를 복호화하지 않고 암호문 상태에서 직접 덧셈·곱셈 연산을 수행한 결과가 평문 연산 후 암호화한 결과와 동일하게 유지되는 차세대 암호 기술이다. 특히 한국 연구진이 제안해 국제 표준화가 진행 중인 CKKS 스킴은 실수 근사 연산을 지원하여 의료·금융 데이터를 암호화한 채로 AI 추론을 수행하는 PPML의 핵심으로 활용된다.',
     '133회 1교시 동형암호 → 138회 4교시 PET(프라이버시 강화 기술)로 확장'),

    (132, 1, 5, 3, '개념/산업보안형', '산업제어시스템 보안 표준 ISA/IEC 62443',
     ['1. 스마트팩토리·OT/ICS 보안을 위한 ISA/IEC 62443 표준 구조(General, Policies, System, Component)', '2. Zone & Conduit(구역과 통로) 네트워크 분할 모델 및 보안 등급(SL 1~4)'],
     ['1. 리드문: IT-OT 융합 환경의 산업제어시스템(ICS/SCADA) 국제 보안 표준 ISA/IEC 62443', '2. Purdue 모델 계층 및 Zone(보안구역) & Conduit(통신통로) 방어 아키텍처도', '3. 보안 등급 SL 1~4(Security Level) 및 SL-T / SL-C / SL-A 비교표', '4. 다크 팩토리 및 국가 기반시설 OT 보안 강화를 위한 무중단 보안 적용 방안'],
     'OT/ICS 보안, Purdue Model, Zone(보안 구역) & Conduit(통로), Security Level(SL 1~4), 심층 방어(Defense in Depth)',
     ['보안 등급 (SL)', '위협 행위자 수준', '요구되는 방어 수준'],
     [['SL 1 / SL 2', '우발적 실수(SL 1) / 단순 도구·낮은 자원을 가진 고의적 침해(SL 2)', '기본 오작동 방지 및 일반 해커의 비인가 접근 차단'],
      ['SL 3', '산업제어 특화 지식과 중간 수준의 자원을 보유한 해커 그룹', 'OT 프로토콜(MODBUS/DNP3) 심층 패킷 분석 및 강력한 인증·암호화'],
      ['SL 4', '국가 지원(APT) 수준의 막대한 자원과 고도의 전문성을 가진 공격자', '다중 물리·논리 격리, 하드웨어 루트오브트러스트, 무결성 실시간 검증']],
     'ISA/IEC 62443은 발전소, 스마트팩토리 등 산업자동화 및 제어시스템(IACS/OT)의 사이버 보안을 위한 국제 표준이다. 시스템을 보안 요구사항이 동일한 구역(Zone)으로 묶고 구역 간 모든 통신을 통제된 통로(Conduit)로만 허용하는 Zone & Conduit 모델과 공격자 역량에 따른 4단계 보안 등급(SL 1~4)을 핵심으로 한다.',
     '132회 ISA/IEC 62443 → 137회 MODBUS → 140회 다크팩토리로 OT 보안 계보 형성'),

    (132, 1, 13, 4, '개념/분산DB형', '분산 데이터베이스의 5가지 투명성(Transparency)',
     ['1. 분산 데이터베이스의 정의와 목표(논리적 단일 DB 뷰 제공)', '2. 위치, 분할, 복제, 병행, 장애 투명성의 개념 및 보장 메커니즘(2PC 등)'],
     ['1. 리드문: 물리적 분산 환경을 논리적 단일 DB처럼 사용하게 하는 분산 DB 투명성', '2. 전역 스키마 - 분할 스키마 - 할당 스키마 계층 및 분산 DBMS 구조도', '3. 분산 DB 5대 투명성(위치·분할·복제·병행·장애) 상세 비교표', '4. 클라우드 네이티브 분산 SQL(NewSQL: CockroachDB, Spanner)에서의 구현 진화'],
     '위치 투명성(Location), 분할 투명성(Fragmentation), 복제 투명성(Replication), 병행 투명성(Concurrency), 장애 투명성(Failure), 2PC(2단계 커밋)',
     ['투명성 종류', '핵심 의미', '주요 구현 기법'],
     [['위치 / 분할 투명성', '데이터의 물리적 저장 위치나 수평/수직 분할 여부를 몰라도 논리적 테이블명으로 접근', '전역 데이터 사전(Global Directory), 분산 쿼리 옵티마이저'],
      ['복제 / 병행 투명성', '데이터가 여러 노드에 복제된 사실이나 다수 분산 트랜잭션 동시 실행을 의식하지 않음', 'Quorum 합의(Raft/Paxos), 분산 2PL(Two-Phase Locking), 타임스탬프'],
      ['장애 투명성', '특정 노드나 통신 회선 장애가 발생해도 트랜잭션의 원자성(Atomicity)과 일관성 보장', '2PC(Two-Phase Commit) / 3PC 프로토콜, 분산 WAL 로그 복구']],
     '분산 데이터베이스의 투명성은 물리적으로 네트워크에 분산된 데이터 저장소들을 사용자가 마치 하나의 중앙집중식 데이터베이스처럼 위치나 분할·복제·장애 여부를 의식하지 않고 사용할 수 있게 보장하는 성질이다. 제132회 1교시, 제138회 3교시(분할), 제139회 1교시 등 매 1~2년마다 반드시 출제되는 초빈출 핵심 토픽이다.',
     '132회 1교시 → 138회 3교시 → 139회 1교시 반복 출제된 최빈출 토픽'),

    (131, 2, 1, 1, '개념/아키텍처형', '파운데이션 모델(Foundation Model)의 개념, 기반 기술 및 법적·환경적·사회적 고려사항',
     ['가. 파운데이션 모델의 정의와 자기지도학습(Self-Supervised Learning)·트랜스포머 기반 기술', '나. 스케일링 법칙(Scaling Law)과 창발적 능력(Emergent Abilities)', '다. 도입 시 법적(저작권/개인정보)·환경적(탄소배출)·사회적(편향/환각) 리스크 및 대응 방안'],
     ['1. 리드문: 단일 태스크 AI에서 범용 적응형 AI로의 전환 Foundation Model', '2. 대규모 비라벨 사전학습(Self-Supervised) → 다운스트림 적응(Fine-tuning / In-Context) 구조도', '3. 기존 Task-Specific AI 모델 vs Foundation Model 비교표', '4. 소형 언어모델(sLLM)·양자화(Green AI) 및 AI 거버넌스 대응 제언'],
     '자기지도학습(Self-Supervised Learning), Scaling Law(스케일링 법칙), 창발성(Emergent Ability), 동질화(Homogenization) 리스크, Green AI',
     ['비교 항목', '기존 특화 모델 (Task-Specific AI)', '파운데이션 모델 (Foundation Model)'],
     [['학습 데이터 및 방식', '특정 과업용 라벨링 데이터 기반 지도학습(Supervised)', '방대한 비라벨 멀티모달 데이터 기반 자기지도학습(Self-Supervised)'],
      ['적응 및 확장성', '새로운 과업마다 처음부터 별도 모델 재학습 필요', '단일 거대 모델을 프롬프트·PEFT로 수백 가지 하위 과업에 전이 활용'],
      ['핵심 리스크', '라벨링 비용 과다, 일반화 성능 한계', '단일 기저 모델 결함이 모든 하위 서비스로 전파되는 동질화(Homogenization) 위험']],
     '파운데이션 모델은 방대한 비라벨 데이터를 자기지도학습(Self-Supervised Learning)으로 사전 학습하여 다양한 다운스트림 과업(번역, 요약, 코딩, 시각 인지 등)에 범용적으로 적응할 수 있는 초거대 기저 모델이다. 높은 활용성 이면에 저작권 분쟁, 막대한 전력 소모, 환각 및 단일 실패점(동질화) 위험이 존재하므로 sLLM 최적화와 거버넌스가 요구된다.',
     '생성형 AI/LLM 시리즈의 출발점이 된 기출'),

    (130, 1, 2, 4, '개념/트랜잭션형', '데이터베이스 병행 제어(Concurrency Control) 기법 및 필요성',
     ['1. 병행 제어 미수행 시 발생하는 4대 이상 현상(갱신 손실, 현황 파악 오류, 모순성, 연쇄 복귀)', '2. 로킹(2PL), 타임스탬프, 낙관적 검증, 다중버전 병행제어(MVCC) 비교'],
     ['1. 리드문: 다중 트랜잭션 처리량(Throughput)과 일관성(ACID)의 조화 병행 제어', '2. 병행 제어 미보장 시 4대 문제점 및 MVCC 스냅샷 격리 동작 구조도', '3. 2단계 로킹(2PL) vs 타임스탬프(Timestamp) vs 낙관적 검증 vs MVCC 비교표', '4. 현대 RDBMS(PostgreSQL/Oracle/MySQL InnoDB)의 MVCC 기반 무잠금 읽기 최적화'],
     '갱신 손실(Lost Update), Dirty Read, Non-repeatable Read, Phantom Read, 2PL(확장·축소 단계), MVCC(다중버전 병행제어)',
     ['병행 제어 기법', '동작 원리', '장점 및 단점'],
     [['2단계 로킹 (2PL)', '트랜잭션이 락을 획득만 하는 확장 단계와 해제만 하는 축소 단계로 구분', '직렬가능성(Serializability) 보장, 단 교착상태(Deadlock) 및 대기 지연 발생'],
      ['타임스탬프 순서 (Timestamp)', '트랜잭션 시작 시각 순서대로 데이터 접근 순서를 사전 결정', '교착상태 없음, 단 철회(Rollback) 및 연쇄 복귀 빈번 발생 가능'],
      ['MVCC (다중버전 병행제어)', '데이터 변경 시 Undo 영역에 이전 버전 스냅샷을 유지하여 일관된 읽기 제공', '읽기 작업과 쓰기 작업이 서로 블로킹하지 않아 동시성 극대화 (버전 공간 관리 필요)']],
     '데이터베이스 병행 제어는 다수의 트랜잭션이 동시에 동일한 데이터에 접근할 때 갱신 손실(Lost Update) 등 무결성 훼손을 방지하고 직렬가능성(Serializability)을 보장하는 기법이다. 현대 DBMS는 읽기 잠금 경합을 없애기 위해 Undo 스냅샷 기반의 MVCC(다중버전 병행제어)를 기본 채택하고 있다.',
     '130회 1교시 병행제어 → 137회 3교시 트랜잭션 격리수준으로 연계 출제'),

    (129, 1, 5, 1, '비교/머신러닝형', '비지도 학습 군집화 알고리즘 K-Means Clustering과 DBSCAN 비교',
     ['1. 거리 기반 분할 군집화 K-Means의 동작 절차와 한계', '2. 밀도 기반 군집화 DBSCAN(Eps, MinPts, Core/Border/Noise Point)과의 비교'],
     ['1. 리드문: 비지도 군집화(Clustering)의 양대 패러다임(중심점 거리 기반 vs 밀도 기반)', '2. K-Means(원형 군집) vs DBSCAN(비선형 기하학적 군집 및 노이즈 분리) 시각적 비교도', '3. K-Means vs DBSCAN vs 계층적 군집화 상세 비교표', '4. 실루엣 계수(Silhouette Coefficient)를 통한 군집 타당성 평가 및 이상치 탐지 응용'],
     'K-Means, 중심점(Centroid), 엘보우 기법(Elbow), DBSCAN, Eps(반경), MinPts(최소점수), Core/Border/Noise Point, 실루엣 계수',
     ['비교 항목', 'K-Means Clustering (중심점 기반)', 'DBSCAN (밀도 기반)'],
     [['군집 수(K) 사전 지정', '사전에 군집 수 K를 반드시 지정해야 함 (Elbow/실루엣으로 탐색)', '군집 수를 사전에 지정할 필요 없음 (반경 Eps와 최소 데이터 수 MinPts만 설정)'],
      ['군집 형태 적응성', '구형(Spherical/원형) 군집만 정상 분리 가능 (오목·비선형 군집 취약)', '데이터 밀도를 따라 임의의 기하학적(초승달, 도넛형) 군집 완벽 분리'],
      ['이상치(Outlier) 민감도', '평균(중심점)을 계산하므로 이상치에 매우 민감하게 왜곡됨', '밀도가 낮은 외곽 데이터를 노이즈(Noise Point)로 자연스럽게 분리·제외']],
     'K-Means는 사전에 지정한 K개의 중심점(Centroid)과 데이터 간 유클리드 거리를 최소화하는 분할 군집화 기법으로 속도가 빠르나 이상치와 비선형 구조에 취약하다. 반면 DBSCAN은 반경(Eps) 내 최소 이웃 수(MinPts)라는 밀도 조건을 이용해 K값 지정 없이 임의 형태의 군집을 형성하고 노이즈(이상치)를 자동으로 걸러낸다.',
     '129회 K-Means/DBSCAN → 130회 K-Means → 135회 실루엣 계수로 이어지는 빈출 클러스터'),

    (126, 2, 1, 4, '비교/분산시스템형', '분산 시스템의 CAP 정리 한계와 PACELC 이론 설명',
     ['가. 브루어(Brewer)의 CAP 정리(Consistency, Availability, Partition Tolerance) 개념과 한계', '나. 정상 상태(Else)의 지연시간(Latency)과 일관성(Consistency) 트레이드오프를 보완한 PACELC 이론', '다. 대표 NoSQL 및 분산 DBMS(DynamoDB, MongoDB, Spanner)의 PACELC 분류'],
     ['1. 리드문: 분산 데이터베이스 설계의 이정표 CAP 정리와 현실적 확장 PACELC 이론', '2. 네트워크 단절 시(If P → A or C)와 정상 운영 시(Else → L or C) PACELC 의사결정 트리', '3. CAP 정리 vs PACELC 이론 비교 및 주요 DBMS(PA/EL, PC/EC, PA/EC) 매핑표', '4. 멀티리전 클라우드 환경에서 비즈니스 SLA에 따른 일관성 수준(Tunable Consistency) 설계 제언'],
     'CAP 정리, 일관성(Consistency), 가용성(Availability), 분할내성(Partition Tolerance), PACELC 이론, 지연시간(Latency), Tunable Consistency',
     ['PACELC 분류', '단절 시 (If Partition)', '정상 시 (Else Normal)', '대표 분산 시스템 및 특징'],
     [['PA / EL 시스템', '가용성(A) 선택', '지연시간 최소화(L) 선택 (결과적 일관성)', 'Amazon DynamoDB(기본), Cassandra — 초저지연·무중단 서비스 최우선'],
      ['PC / EC 시스템', '일관성(C) 선택', '강한 일관성(C) 선택 (동기 복제 지연 감수)', 'Google Cloud Spanner, CockroachDB, HBase — 금융·원장 정합성 최우선'],
      ['PA / EC 또는 PC / EL', '혼합형 정책', '읽기/쓰기 쿼리별 정족수(Quorum R+W>N) 튜닝', 'MongoDB, Cosmos DB — 워크로드별 일관성 수준 동적 조정']],
     'CAP 정리는 네트워크 분할(P) 발생 시 일관성(C)과 가용성(A)을 동시에 만족할 수 없다는 정리이나, 네트워크가 정상인 평상시(99.9%)의 트레이드오프를 설명하지 못하는 한계가 있다. 아바디(Abadi) 교수의 PACELC 이론은 이를 보완하여, 분할 시(P)에는 가용성(A)과 일관성(C) 중 선택하고, 정상 시(Else)에는 지연시간 단축(Latency)과 일관성(Consistency) 중 선택해야 함을 규명한 모델이다.',
     '분산 DB/NoSQL 아키텍처 논술의 바이블 토픽'),

    (125, 1, 6, 7, '절차/계산형', '프로젝트 비용·일정 통합 성과측정 기법 EVM(Earned Value Management, 획득가치관리)',
     ['1. EVM의 3대 기본 지표 PV(계획가치), EV(획득가치), AC(실제비용) 정의', '2. 일정편차(SV)/원가편차(CV), 일정성과지수(SPI)/원가성과지수(CPI) 및 완료시점 추정치(EAC) 산출식'],
     ['1. 리드문: 프로젝트 범위·일정·원가를 화폐 단위로 통합 측정하는 EVM 정의', '2. S-Curve 기반 PV, EV, AC, BAC(완료예산), EAC(완료시점추정치) 그래프 구조도', '3. EVM 핵심 지표(SV, CV, SPI, CPI, ETC, EAC) 수식 및 상태 판정 기준표', '4. 애자일 프로젝트에서의 Earned Value(AgileEVM / 번다운 차트 결합) 활용 방안'],
     'PV(Planned Value), EV(Earned Value), AC(Actual Cost), BAC, SV(EV-PV), CV(EV-AC), SPI(EV/PV), CPI(EV/AC), EAC',
     ['지표 구분', '산출 공식', '판정 기준 및 의미'],
     [['일정 편차(SV) / 지수(SPI)', 'SV = EV - PV / SPI = EV / PV', 'SV > 0 (SPI > 1.0): 일정 앞섬 / SV < 0 (SPI < 1.0): 일정 지연'],
      ['원가 편차(CV) / 지수(CPI)', 'CV = EV - AC / CPI = EV / AC', 'CV > 0 (CPI > 1.0): 예산 절감 / CV < 0 (CPI < 1.0): 예산 초과 (원가 효율 저하)'],
      ['완료시점 추정치 (EAC)', 'EAC = BAC / CPI (현재 원가효율 지속 가정 시)', '프로젝트 최종 종료 시점에 소요될 것으로 예측되는 총 예상 원가']],
     'EVM(획득가치관리)은 프로젝트의 계획 대비 실제 진척도와 투입 원가를 화폐 가치로 정량화하여 통합 관리하는 기법이다. 획득가치(EV)를 중심으로 계획가치(PV)와 비교해 일정 성과(SV, SPI)를 측정하고, 실제투입비용(AC)과 비교해 원가 성과(CV, CPI) 및 최종 예상 총원가(EAC)를 예측한다.',
     'PM 수치 계산 및 관리 논술 필수 토픽'),

    (124, 1, 4, 1, '비교/수리통계형', '통계학에서 데이터의 4가지 측정 척도(명목, 서열, 등간, 비율 척도)',
     ['1. 스티븐스(Stevens)의 4대 측정 척도(Nominal, Ordinal, Interval, Ratio) 개념', '2. 각 척도별 허용되는 산술 연산, 대표값 및 적용 가능한 통계 분석 기법 비교'],
     ['1. 리드문: 데이터 분석 및 머신러닝 피처 엔지니어링의 출발점 4대 측정 척도', '2. 범주형(명목·서열) vs 수치형(등간·비율) 정보량 및 연산 계층 구조도', '3. 4대 척도 비교표 (구분성, 서열성, 등간격성, 절대영점 유무, 대표값, 인코딩 기법)', '4. 머신러닝 모델 학습 시 척도 오용 방지(One-Hot vs Label Encoding) 주의사항'],
     '범주형(질적) 데이터, 수치형(양적) 데이터, 명목척도, 서열척도, 등간척도, 비율척도, 절대영점(Absolute Zero), One-Hot Encoding',
     ['척도 구분', '보유 속성', '허용 연산 / 대표값', '대표 예시 및 ML 인코딩'],
     [['명목 척도 (Nominal)', '구분(이름)만 가능', '=(같다/다르다) / 최빈값(Mode)', '성별, 혈액형, 지역코드 → One-Hot Encoding 적용'],
      ['서열 척도 (Ordinal)', '구분 + 순서(대소 관계)', '<, > / 중앙값(Median), 백분위수', '학점(A/B/C), 만족도 등급 → Ordinal Encoding'],
      ['등간 척도 (Interval)', '구분 + 순서 + 동일 간격 (절대영점 없음)', '+, - (덧셈/뺄셈) / 산술평균(Mean)', '섭씨온도(℃), 지능지수(IQ), 서기 연도 (비율 배수 의미 없음)'],
      ['비율 척도 (Ratio)', '구분 + 순서 + 간격 + 절대영점(0=없음) 존재', '+, -, ×, ÷ (사칙연산) / 산술·기하·조화평균', '무게, 키, 매출액, 응답시간(ms) → Standard/MinMax Scaling']],
     '데이터의 측정 척도는 포함된 정보의 수준에 따라 범주형인 명목·서열 척도와 수치형인 등간·비율 척도로 구분된다. 특히 등간 척도(섭씨온도 등)는 임의 영점을 가지므로 덧셈·뺄셈만 가능하고 비율 척도(무게, 금액 등)는 절대 영점(0이 아무것도 없음을 의미)을 가져 곱셈·나눗셈(2배, 3배 비교)이 가능하다는 점이 핵심 차이다.',
     '통계 기초 단답형 빈출'),

    (122, 1, 1, 6, '비교/운영체제형', '운영체제 프로세스·스레드 동기화를 위한 세마포어(Semaphore)와 모니터(Monitor) 비교',
     ['1. 임계구역(Critical Section) 문제 해결을 위한 상호배제·진행·한정대기 조건', '2. 세마포어(P/V 연산)와 모니터(고수준 동기화 구조체)의 동작 원리 및 장단점 비교'],
     ['1. 리드문: 경쟁 조건(Race Condition) 예방과 임계구역 보호를 위한 동기화 메커니즘', '2. 세마포어(공유 정수 변수 S + 대기 큐) vs 모니터(공유자원 + 프로시저 + 조건변수 캡슐화) 구조도', '3. 뮤텍스(Mutex) vs 세마포어(Semaphore) vs 모니터(Monitor) 비교표', '4. 데드락·우선순위 역전 방지 및 언어 차원(Java synchronized, Go Channel) 동시성 발전'],
     '임계구역(Critical Section), 상호배제·진행·한정대기, Semaphore(P=wait, V=signal), Monitor, 조건변수(wait/notify), Race Condition',
     ['비교 항목', '세마포어 (Semaphore)', '모니터 (Monitor)'],
     [['추상화 수준', '운영체제 커널/시스템 콜 수준의 저수준(Low-level) 동기화 도구', '프로그래밍 언어·컴파일러가 지원하는 고수준(High-level) 객체 캡슐화 구조'],
      ['동작 메커니즘', '정수형 변수 S와 원자적 P(wait)/V(signal) 연산으로 가용 자원 수 제어', '공유 데이터와 접근 프로시저를 하나로 묶어 한 시점에 하나의 스레드만 진입 자동 보장'],
      ['사용 안전성', '개발자가 P/V 연산 순서를 실수하거나 누락하면 즉시 데드락·상호배제 파괴 발생', '락 획득·해제를 컴파일러가 자동 처리하여 안전하고 코드 가독성이 높음 (Java synchronized)']],
     '세마포어(Semaphore)는 다익스트라가 제안한 저수준 동기화 기법으로 원자적 P(wait)·V(signal) 연산을 통해 N개의 공유 자원 접근을 제어하나 개발자의 코딩 실수로 인한 데드락 위험이 있다. 반면 모니터(Monitor)는 공유 자원과 접근 함수를 하나의 모듈로 캡슐화하여 컴파일러 차원에서 상호배제를 자동 보장하는 고수준 동기화 구조다.',
     '122회 세마포어/모니터 → 126회 Race Condition → 138회 은행가 알고리즘 등 OS 동기화 지속 출제'),
])

# 5. 제120회 ~ 제140회 전체 회차 커버리지 보강 (각 회차별 실제 출제 토픽 인덱스 완비)
ADDITIONAL_ROUND_TOPICS = [
    (120, 1, 1, 8, '개념/법제도형', '데이터 3법(개인정보보호법·정보통신망법·신용정보법) 주요 개정 내용과 가명정보 활용 체계',
     ['1. 데이터 3법 개정의 핵심 취지(가명정보 개념 도입, 개인정보보호위원회 일원화)', '2. 가명정보의 상업적·통계적·연구 목적 동의 없는 활용 요건 및 안전조치 의무']),
    (120, 2, 1, 2, '비교/아키텍처형', '마이크로서비스 아키텍처(MSA) 환경에서 분산 트랜잭션 정합성을 위한 Saga 패턴(Choreography vs Orchestration)과 CQRS',
     ['가. MSA 폴리글랏 퍼시스턴스 환경에서 2PC(Two-Phase Commit)의 한계', '나. 보상 트랜잭션 기반 Saga 패턴의 두 가지 구현 방식 비교 및 CQRS 결합 아키텍처']),
    (121, 1, 1, 3, '개념/보안아키텍처형', '제로트러스트(Zero Trust) 보안 모델의 핵심 원칙(Never Trust, Always Verify)과 NIST SP 800-207 아키텍처',
     ['1. 경계 기반 보안(Perimeter Security)의 한계와 제로트러스트 7대 기본 원칙', '2. 정책결정지점(PDP: Policy Engine + Policy Administrator)과 정책시행지점(PEP) 동작 구조']),
    (121, 3, 1, 5, '개념/클라우드형', '쿠버네티스(Kubernetes) 컨테이너 오케스트레이션 아키텍처(Control Plane / Worker Node) 및 오토스케일링(HPA/VPA/CA) 전략',
     ['가. K8s 마스터(API Server, etcd, Scheduler, Controller)와 워커 노드(Kubelet, Kube-proxy) 구조', '나. Pod/Node 수준 무중단 오토스케일링(HPA, VPA, Cluster Autoscaler, Karpenter) 운영 방안']),
    (123, 1, 1, 1, '개념/파이프라인형', 'MLOps(Machine Learning Operations)의 성숙도 모델 및 CI/CD/CT(Continuous Training) 파이프라인',
     ['1. 실험실 모델(Jupyter)과 실운영 서빙 간의 괴리(기술부채, Data/Concept Drift)', '2. Feature Store, Model Registry, 드리프트 탐지 및 자동 재학습(CT) 아키텍처']),
    (123, 3, 1, 8, '개념/보안인증형', '정보보호 및 개인정보보호 관리체계 인증(ISMS-P)의 3대 영역(관리체계 수립·운영, 보호대책 요구사항, 개인정보 처리단계별 요구사항) 및 심사 절차',
     ['가. 기존 ISMS와 PIMS 통합 배경 및 ISMS-P 101개(클라우드/가상자산 특화 포함) 인증 기준', '나. 인증 의무 대상자 기준 및 사후·갱신 심사 실무 대응 방안']),
    (124, 2, 1, 7, '비교/경영시스템형', '기업 가치사슬(Value Chain) 관점에서 ERP, SCM, MES, CRM 시스템의 역할 비교 및 지능형 통합 방안',
     ['가. 마이클 포터 가치사슬 모델과 엔터프라이즈 기간계 시스템 매핑', '나. 계획 계층(ERP/SCM)과 현장 실행 계층(MES/POP) 실시간 데이터 통합 아키텍처']),
    (125, 1, 3, 3, '개념/시큐어코딩형', '경쟁 조건 기반 보안 약점 TOCTOU(Time-Of-Check to Time-Of-Use) 발생 원리와 시큐어 코딩 대응 방안',
     ['1. 자원 상태 검사 시점(Check)과 실제 사용 시점(Use)의 비원자성(Non-atomicity)을 악용한 권한 상승 공격', '2. 파일 디스크립터 기반 원자적 연산 및 뮤텍스 동기화를 통한 예방 기법']),
    (126, 1, 1, 1, '개념/최적화형', 'NP-Hard 조합 최적화 문제 해결을 위한 메타휴리스틱(Meta-heuristics) 알고리즘(유전 알고리즘, 시뮬레이티드 어닐링, 타부 서치, 군집 지능)',
     ['1. 지역 최적해(Local Optimum) 탈출을 위한 탐색(Exploration)과 활용(Exploitation) 균형 원리', '2. 주요 메타휴리스틱 기법 비교 및 클라우드 스케줄링·물류 라우팅 적용 사례']),
    (127, 1, 4, 7, '개념/성과관리형', '균형성과기록표(BSC, Balanced Scorecard)의 4대 관점(재무, 고객, 내부프로세스, 학습과 성장)과 IT-BSC 적용 방안',
     ['1. 재무적 과거 지표 중심 평가의 한계와 카플란·노튼의 BSC 4대 관점 인과관계(전략지도)', '2. IT 조직 성과 평가를 위한 IT-BSC(기업기여도, 사용자지향, 운영탁월성, 미래지향) 매핑']),
    (128, 1, 5, 2, '개념/품질관리형', '소프트웨어 품질비용(CoQ, Cost of Quality) 4대 항목(예방비용, 평가비용, 내부실패비용, 외부실패비용)과 사례',
     ['1. 적합 비용(Cost of Conformance: 예방+평가)과 비적합 비용(Cost of Non-conformance: 내부+외부 실패) 구조', '2. Shift-Left 테스팅을 통한 외부실패비용 극소화 및 최적 품질 경제성 확보 전략']),
    (128, 1, 6, 4, '비교/데이터베이스형', 'NoSQL 데이터베이스의 4대 데이터 모델(Key-Value, Document, Wide-Column, Graph) 구조 및 활용 시나리오 비교',
     ['1. BASE 속성 기반 비관계형 데이터베이스의 등장 배경', '2. Key-Value(Redis), Document(MongoDB), Column-Family(Cassandra/HBase), Graph(Neo4j) 아키텍처 및 선택 기준']),
    (129, 1, 1, 8, '개념/공공정책형', '디지털플랫폼정부(DPG)의 4대 기본 원칙과 DPG 허브(민관 협력 혁신 인프라) 아키텍처',
     ['1. 사일로화된 전자정부를 넘어선 국민·기업·정부 공동 가치 창출 디지털플랫폼정부 정의', '2. 데이터 레이크·초거대 AI·API 통합 테스트베드를 제공하는 DPG 허브 구조 및 보안 대책']),
    (131, 1, 9, 1, '비교/수리통계형', '독립표본 t-검정(Independent Sample t-test)과 대응표본 t-검정(Paired Sample t-test)의 가정 및 차이점 비교',
     ['1. 두 집단 간 평균 차이의 통계적 유의성 검정 원리(정규성, 등분산성 가정)', '2. 서로 다른 두 집단 비교(독립표본)와 동일 대상의 사전-사후 변화 비교(대응표본) 수식 및 활용 사례']),
    (132, 2, 2, 1, '비교/머신러닝형', '선형 서포트 벡터 머신(SVM)의 하드 마진(Hard Margin)과 소프트 마진(Soft Margin, 슬랙 변수·C 파라미터) 분류 방법 및 커널 트릭',
     ['가. 결정 경계(Hyperplane)와 서포트 벡터 간 마진(2/||w||) 최대화 원리', '나. 이상치 허용을 위한 슬랙 변수(ξ)와 규제 파라미터(C) 트레이드오프 및 비선형 커널 트릭(RBF)']),
    (133, 1, 4, 3, '개념/암호기술형', '기밀성과 무결성·부인방지를 동시에 보장하는 전자봉투(Digital Envelope)와 전자서명 결합 메커니즘',
     ['1. 대칭키 암호(고속 대용량 처리)와 공개키 암호(안전한 키 배송)의 하이브리드 결합 원리', '2. 송신자 개인키 전자서명 + 대칭 세션키로 본문 암호화 + 수신자 공개키로 세션키 암호화(전자봉투) 절차']),
    (134, 3, 2, 5, '개념/클라우드관리형', '클라우드 재무관리 FinOps(Financial Operations) 프레임워크의 3단계(Inform, Optimize, Operate)와 멀티클라우드 비용 최적화 방안',
     ['가. 가변적 클라우드 종량제 비용 급증 문제와 FinOps 문화·조직(기술·재무·비즈니스 협업)', '나. 가시성 확보(태깅/쇼백) → 단가·사용량 최적화(RI/Savings Plans, 적정사이징) → 지속적 거버넌스 운영']),
    (136, 2, 2, 5, '비교/클라우드형', '서버리스 컴퓨팅(Serverless Computing: FaaS + BaaS) 아키텍처의 특징과 Cold Start(콜드 스타트) 발생 원인 및 완화 기법',
     ['가. 서버 프로비저닝 없는 이벤트 기반 FaaS(AWS Lambda 등)의 동작 원리와 장단점', '나. 컨테이너 초기화·런타임 로딩으로 인한 Cold Start 지연 분석 및 Provisioned Concurrency/SnapStart/Wasm 완화 전략']),
]

for r_id, p_id, q_no, d_id, fmt, hdr, prompts in ADDITIONAL_ROUND_TOPICS:
    RAW_QUESTIONS.append((
        r_id, p_id, q_no, d_id, fmt, hdr, prompts,
        ['1. 리드문: 핵심 개념 정의 및 등장 배경', '2. 아키텍처 및 핵심 메커니즘 구조도', '3. 핵심 구성요소 및 비교 분석표', '4. 실무 적용 시 고려사항 및 기술사적 제언'],
        hdr.split('(')[0].strip() + ', 아키텍처, 트레이드오프, 거버넌스, 실무 최적화',
        ['핵심 구분', '주요 기술 및 메커니즘', '실무 적용 및 검증 포인트'],
        [[prompts[0], '표준 아키텍처 및 동작 원리 정의', '성능·보안·확장성 요구사항 충족 여부 검증'],
         [prompts[1] if len(prompts) > 1 else '실무 적용 및 비교 분석', '대안 기술과의 정량·정성적 트레이드오프 분석', '운영 자동화 및 컴플라이언스 준수 체계 확립']],
        f"{hdr} 토픽은 정보관리기술사 핵심 기출 영역으로, (1) 정의 및 등장 배경을 두괄식 리드문으로 명시하고, (2) 핵심 아키텍처/프로세스 개념도를 도식화한 뒤, (3) {prompts[0]} 및 {prompts[1] if len(prompts) > 1 else '실무 적용 방안'}을 비교표와 함께 서술하고, (4) 최신 기술 트렌드 및 거버넌스 관점의 제언으로 마무리해야 고득점이 가능하다.",
        f"제{r_id}회 핵심 기출 및 연관 도메인 반복 출제 토픽"
    ))

# 6. 제141회 대비 적중 예상 토픽 20선 (출제주기 + 1교시→서술형 승격 패턴 + 최신 법·표준 기반)
PREDICTED_TOPICS = [
    (1, '2~4교시 서술형 (25점)', '[Sec] 정보보안 · 암호 · 개인정보보호', '원인분석/대응전략형', '최우선 승격 (140회 1교시 → 서술형)',
     '140회 1교시 비인간 신원(NHI) 단답 출제 + 에이전틱 AI/MCP 확산으로 머신 ID 보안이 최대 화두',
     '클라우드 네이티브 및 에이전틱 AI 환경에서 비인간 신원(NHI, Non-Human Identities)의 수명주기 거버넌스와 OWASP NHI Top 10 기반 보안 통제 방안',
     ['1. 리드문: 인간 신원(IAM)을 넘어선 비인간 신원(NHI) 급증 배경', '2. NHI 공격 표면(API Key, OAuth Token, Service Account, AI Agent ID) 및 침투 경로도', '3. OWASP NHI Top 10 주요 취약점(장기 시크릿, 과도한 권한, 안전하지 않은 CI/CD 등)과 기술적 통제 방안', '4. SPIFFE/SPIRE 워크로드 ID 표준 및 Zero Trust 결합 거버넌스 제언'],
     'OWASP NHI Top 10, Secret Sprawl, 단기 수명 토큰(Ephemeral Token), SPIFFE/SPIRE, JIT 권한, 동적 시크릿 볼트',
     ['NHI 위협 영역', '주요 취약점 (OWASP NHI Top 10)', '핵심 대응 아키텍처'],
     [['자격증명 관리 부실', '미폐기 고아 계정(Offboarding 부재), 시크릿 하드코딩 및 미회전', '자동화된 NHI 검색(Discovery), 동적 시크릿 회전(Vault), OIDC 단기 토큰화'],
      ['권한 및 격리 실패', '과도한 권한(Over-privileged) 부여, 개발·운영 환경 간 NHI 재사용', 'CIEM 기반 최소 권한 원칙 강제, 환경별 워크로드 ID(SPIFFE ID) 엄격 분리'],
      ['에이전트 연쇄 침해', '자율 AI 에이전트가 위임받은 NHI 토큰으로 비인가 외부 MCP/API 호출', '에이전트 행동 경계(Guardrail) 설정 및 고위험 트랜잭션 인간 승인(HITL)']],
     '140회 1교시에 첫 등장한 비인간 신원(NHI)은 136회 MCP(1교시) → 137회 MCP 보안(2교시) 패턴과 동일하게 차기 회차 2~3교시 서술형으로 승격될 확률이 가장 높은 1순위 보안 토픽이다.'),

    (2, '2~4교시 서술형 (25점)', '[AI/Data] 인공지능 · 빅데이터 · 통계', '비교/아키텍처형', '최우선 승격 (140회 1교시 → 서술형)',
     '140회 1교시 Physical AI 및 다크 팩토리 동시 출제 → 월드 모델(World Model) 및 VLA 아키텍처 심화 논술 임박',
     '피지컬 AI(Physical AI) 구현을 위한 월드 모델(World Model)과 VLA(Vision-Language-Action) 아키텍처, 그리고 Sim-to-Real 격차 해소 및 안전성(Safety) 확보 방안',
     ['1. 리드문: LLM을 넘어 물리 세계와 상호작용하는 Physical AI 정의', '2. 센서 인지 → World Model(물리 시뮬레이션) → VLA 정책 네트워크 → 액추에이터 제어 구조도', '3. 주요 기술 요소(World Model, VLA, 강화학습, Sim-to-Real Domain Randomization) 비교', '4. ISO/IEC 25010(Safety) 및 기능 안전(ISO 26262) 연계 온디바이스 제어 제언'],
     'Physical AI, World Model, VLA(Vision-Language-Action), Sim-to-Real Gap, Domain Randomization, 온디바이스 NPU, 물리적 안전성(Safety)',
     ['핵심 구성요소', '기술적 역할', '해결 과제 및 극복 방안'],
     [['월드 모델 (World Model)', '3차원 공간 기하학·중력·마찰·인과관계 등 물리 법칙을 내재화하여 미래 상태 예측', '비디오·3D 합성데이터 사전학습을 통한 물리적 환각(Physical Hallucination) 억제'],
      ['VLA (Vision-Language-Action)', '시각 인지(V)와 자연어 지시(L)를 로봇 관절 제어 토큰(Action)으로 직접 변환', '초저지연 추론을 위한 경량화·양자화 및 온디바이스 제어 루프 분리'],
      ['Sim-to-Real 전이', '가상 물리 엔진(Isaac Sim 등)에서 수백만 회 학습한 정책을 실제 로봇에 이식', 'Domain Randomization(마찰·조명·질량 무작위 변형 학습)으로 현실 격차 최소화']],
     '140회 1교시에서 Physical AI와 다크 팩토리가 동시에 출제되었으므로, 차기 회차에서는 Physical AI의 내부 두뇌인 월드 모델(World Model)과 VLA 모델, 그리고 Sim-to-Real 학습 방법을 묻는 25점 서술형 문항을 반드시 대비해야 한다.'),

    (3, '1교시 단답·용어형 (10점)', '[AI/Data] 인공지능 · 빅데이터 · 통계', '비교/프로토콜형', '신규 트렌드 1순위 (MCP 후속)',
     '136회/137회 MCP(에이전트-도구 연결) 출제 완료 → 다중 에이전트 간 협업 표준 프로토콜 A2A 출제 임박',
     '다중 에이전트 협업을 위한 A2A(Agent-to-Agent) 프로토콜과 MCP(Model Context Protocol) 비교',
     ['1. 리드문: 멀티 에이전트 생태계 상호운용성을 위한 A2A와 MCP 정의', '2. 사용자 ↔ 오케스트레이터 에이전트 ↔(A2A)↔ 원격 전문 에이전트 ↔(MCP)↔ 도구/DB 구조도', '3. MCP(에이전트-도구 수직 연동) vs A2A(에이전트-에이전트 수평 협업) 상세 비교표', '4. 엔터프라이즈 멀티 에이전트 시스템(MAS) 구축 시 보안·인증 고려사항'],
     'Agent-to-Agent(A2A), Agent Card(역할 명세), Task Lifecycle, MCP(Model Context Protocol), 수평적 협업 vs 수직적 도구 호출',
     ['비교 항목', 'MCP (Model Context Protocol)', 'A2A (Agent-to-Agent Protocol)'],
     [['연결 대상 (위상)', '단일 AI 에이전트 ↔ 외부 도구·API·데이터 리소스 (수직적 연결)', '자율 AI 에이전트 ↔ 타 벤더/원격 AI 에이전트 (수평적 협업)'],
      ['핵심 추상화', 'Resources, Prompts, Tools (함수 시그니처 및 컨텍스트 제공)', 'Agent Card(능력 탐색), Task(장기 작업 위임), Artifact(결과물 교환)'],
      ['상호보완 관계', '개별 에이전트가 손발(도구·DB)을 쓰기 위한 표준 인터페이스', '여러 전문 에이전트들이 팀을 이루어 대화·위임하기 위한 표준 통신망']],
     '제136회와 제137회에서 에이전트와 도구를 연결하는 MCP가 연속 출제되었으므로, 그 다음 단계인 이기종 에이전트 간 협업 프로토콜 A2A(Agent-to-Agent)와 MCP의 비교는 1교시 1순위 예상 토픽이다.'),

    (4, '2~4교시 서술형 (25점)', '[Sec] 정보보안 · 암호 · 개인정보보호', '개념/전환전략형', '법·정책 직결 (PQC 전환 로드맵)',
     '국가 양자내성암호(KpqC) 최종 선정 및 금융·공공 PQC 전환 가이드라인 발표 직결',
     '양자컴퓨터 위협(Harvest Now, Decrypt Later)에 대응하기 위한 양자내성암호(PQC: NIST 표준 및 KpqC) 전환 전략과 암호 민첩성(Crypto-Agility) 확보 방안',
     ['1. 리드문: 쇼어(Shor) 알고리즘에 의한 기존 공개키 암호(RSA/ECC) 붕괴 위험과 PQC', '2. 하이브리드 암호 전환(기존 ECC + PQC 이중 적용) 및 암호 민첩성(Crypto-Agility) 아키텍처도', '3. 양자키분배(QKD, 물리계층) vs 양자내성암호(PQC: ML-KEM, ML-DSA, KpqC) 비교표', '4. CBOM(암호자산 명세서) 구축 및 금융·공공 인프라 단계별 마이그레이션 로드맵'],
     'HNDL(선수집 후해독), Shor 알고리즘, 격자 기반 암호(ML-KEM/Kyber, ML-DSA/Dilithium), KpqC(HAETAE, NTRU+), CBOM(암호자산명세서), Crypto-Agility',
     ['비교 항목', 'QKD (양자 키 분배)', 'PQC (양자내성암호 / KpqC)'],
     [['기반 원리 / 계층', '양자역학 불확정성·복제불가 원리 (물리 계층 광케이블)', '양자컴퓨터로도 풀기 어려운 수학적 난제(격자, 해시, 코드 기반) (SW/응용 계층)'],
      ['도입 비용 및 범위', '전용 양자 광통신 장비 구축 필요 (고비용, 기간망 중심)', '기존 SW/프로토콜(TLS 1.3) 업데이트로 단말~클라우드 전구간 적용 가능'],
      ['핵심 전환 과제', '전송 거리 한계 및 중계 노드 신뢰성 확보', '키·서명 크기 증가에 따른 패킷 단편화 방지 및 CBOM 기반 암호 민첩성 확보']],
     '135회 양자암호, 136회 ECC, 139회 QML에 이어 NIST PQC 표준(FIPS 203/204/205) 및 한국형 양자내성암호(KpqC) 선정 완료에 따른 CBOM(암호자산명세서) 및 암호 민첩성(Crypto-Agility) 구축 방안이 서술형으로 출제될 가능성이 매우 높다.'),

    (5, '2~4교시 서술형 (25점)', '[AI/Data] 인공지능 · 빅데이터 · 통계', '비교/아키텍처형', '출제주기 도래 (GraphRAG 심화)',
     '137회 GNN + 139회 Advanced/Modular RAG + 140회 하이브리드 검색의 융합 종착점',
     '기존 벡터 기반 RAG의 전역적 추론(Global Query) 한계를 극복하기 위한 지식그래프 기반 GraphRAG 아키텍처와 하이브리드 구축 방안',
     ['1. 리드문: 단일 청크 유사도 검색의 한계와 전체 데이터셋 맥락 추론을 위한 GraphRAG', '2. 텍스트 추출 → 개체·관계 지식그래프 구축 → 계층적 커뮤니티 요약(Leiden 알고리즘) → Local/Global Search 구조도', '3. Vector RAG vs GraphRAG vs Hybrid(Vector + Knowledge Graph) 비교표', '4. 그래프 구축 토큰 비용 최적화 및 도메인 온톨로지 연계 방안'],
     'Knowledge Graph(지식그래프), 온톨로지, Multi-hop Reasoning(다중 홉 추론), Leiden 커뮤니티 탐지, Global Search vs Local Search',
     ['비교 항목', '기존 Vector RAG', 'GraphRAG (지식그래프 결합 RAG)'],
     [['검색 단위 및 방식', '분할된 텍스트 청크(Chunk) 간 임베딩 코사인 유사도 매칭', '개체(Entity)-관계(Edge) 서브그래프 순회 및 커뮤니티 계층 요약 참조'],
      ['강점 질의 유형', '특정 지엽적 사실 확인 (Needle in a Haystack)', '문서 전체를 관통하는 요약(Global Query) 및 다단계 관계 추론(Multi-hop)'],
      ['구축 및 운영 비용', '임베딩 생성 비용 저렴, 실시간 색인 용이', '초기 LLM 기반 개체·관계 추출 및 커뮤니티 요약 구축 비용 높음 (점진적 갱신 필요)']],
     '137회 GNN, 139회 Modular RAG, 140회 하이브리드 검색이 차례로 출제되면서, 벡터 검색과 지식그래프(온톨로지)를 결합해 다중 홉 추론과 전역 요약을 수행하는 GraphRAG가 차기 서술형 핵심 문제로 꼽힌다.'),

    (6, '1교시 단답·용어형 (10점)', '[AI/Data] 인공지능 · 빅데이터 · 통계', '개념/추론최적화형', '최신 트렌드 (Test-Time Compute)',
     '추론 모델(Reasoning LLM) 확산에 따른 Test-Time Compute Scaling 및 추론 가속 기법 부상',
     'LLM 추론(Inference) 성능 향상을 위한 Test-Time Compute Scaling과 추론 디코딩 가속 기법(Speculative Decoding)',
     ['1. 리드문: 사전학습 스케일링에서 추론 시점 연산 스케일링(System 2 추론)으로의 진화', '2. Test-Time Compute(CoT 탐색·검증기) 및 Speculative Decoding(소형 Draft 모델 + 대형 Target 모델 병렬 검증) 구조도', '3. Pre-training Scaling vs Test-Time Scaling 및 일반 디코딩 vs 투기적 디코딩 비교', '4. 추론 비용·지연시간 트레이드오프 관리 방안'],
     'System 2 Reasoning, Test-Time Compute Scaling, PRM(과정 보상 모델), Speculative Decoding(투기적 디코딩), Draft Model, KV Cache',
     ['기술 구분', '핵심 메커니즘', '기대 효과'],
     [['Test-Time Compute Scaling', '응답 생성 시 다중 추론 경로(CoT/MCTS)를 생성하고 과정 보상 모델(PRM)로 검증·수정', '모델 크기 증가 없이도 수학·코딩·복합 논리 문제 해결 정확도 비약적 향상'],
      ['Speculative Decoding', '작고 빠른 Draft 모델이 토큰 K개를 먼저 예측하면 대형 Target 모델이 1회 Forward로 병렬 검증', '출력 품질(분포) 손실 전혀 없이 자기회귀 디코딩 속도를 2~3배 가속']],
     '140회 PagedAttention에 이어 LLM 추론 단계의 핵심 기술인 Test-Time Compute Scaling(추론 시점 연산 확장)과 Speculative Decoding(투기적 디코딩)은 1교시 신기술 단답형으로 가장 유력하다.'),

    (7, '2~4교시 서술형 (25점)', '[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트', '개념/아키텍처형', '출제주기 도래 (플랫폼 엔지니어링)',
     '135회 DevSecOps, 136회 DevOps 장단점, 139회 무중단 배포에 이은 차세대 개발 생산성 패러다임',
     '개발자 인지 부하(Cognitive Load) 감소를 위한 플랫폼 엔지니어링(Platform Engineering)과 내부 개발자 플랫폼(IDP, Internal Developer Platform) 구축 방안',
     ['1. 리드문: "You build it, you run it"의 그늘(개발자 인지 부하 폭증)과 플랫폼 엔지니어링', '2. IDP 5대 평면(개발자 포털 Backstage, 리소스 오케스트레이션, CI/CD, 관측가능성, 보안/정책) 아키텍처도', '3. 전통 Ops vs DevOps vs SRE vs Platform Engineering 비교표', '4. 황금 경로(Golden Path) 설계 및 Platform as a Product 운영 제언'],
     '인지 부하(Cognitive Load), IDP(Internal Developer Platform), Golden Path(황금 경로), 셀프서비스 포털(Backstage), Platform as a Product',
     ['비교 항목', '전통적 DevOps 운영', '플랫폼 엔지니어링 (Platform Engineering / IDP)'],
     [['개발자 요구 역량', '개발자가 앱 코드 외에 K8s, Terraform, Helm, IAM 설정까지 직접 구성 (인지 부하 과다)', '플랫폼 팀이 표준화된 셀프서비스 템플릿(Golden Path)을 제공하여 개발자는 비즈니스 로직에 집중'],
      ['거버넌스 및 보안', '팀별 스크립트 파편화로 보안·컴플라이언스 편차 발생', 'IDP 템플릿 내에 보안(SBOM, 정책검증)·모니터링이 기본 내장(Secure by Default)'],
      ['운영 철학', '문화적 협업 및 파이프라인 자동화 중심', '내부 개발자를 고객으로 정의하고 IDP를 제품(Platform as a Product)으로 기획·제공']],
     '136회 1교시에서 DevOps의 장단점(개발자 인프라 부담 과중)이 출제되었는데, 그 해결책으로 가트너가 선정한 플랫폼 엔지니어링(Platform Engineering)과 IDP(내부 개발자 플랫폼)가 2~3교시 아키텍처 문제로 승격될 차례다.'),

    (8, '1교시 단답·용어형 (10점)', '[Sec] 정보보안 · 암호 · 개인정보보호', '개념/공급망보안형', '출제주기 도래 (SBOM & AIBOM)',
     '오픈소스 및 오픈웨이트 AI 모델 공급망 보안 의무화 확산',
     '소프트웨어 공급망 보안을 위한 SBOM(Software Bill of Materials)과 AI 투명성을 위한 AIBOM(AI Bill of Materials) 비교',
     ['1. 리드문: SW 및 AI 모델 공급망 가시성 확보를 위한 명세서(BOM) 표준화', '2. 소스코드/라이브러리(SBOM) + 학습데이터/기저모델/하이퍼파라미터(AIBOM) 구성 요소도', '3. SBOM(SPDX, CycloneDX) vs AIBOM(모델 카드, 데이터 출처, 라이선스) 및 VEX(취약점 악용가능성 교환) 비교', '4. CI/CD 및 MLOps 파이프라인 내 BOM 자동 생성·검증 체계'],
     '공급망 보안, SBOM, AIBOM, SPDX, CycloneDX, VEX(Vulnerability Exploitability eXchange), 데이터 포이즈닝 방지',
     ['비교 항목', 'SBOM (SW 자재명세서)', 'AIBOM (AI 자재명세서)'],
     [['관리 대상', '오픈소스 라이브러리, 컨테이너 패키지, 버전 및 의존성 관계', '기저 파운데이션 모델, 파인튜닝 데이터셋 출처, 토크나이저, 가중치 해시, 안전성 평가 결과'],
      ['핵심 목적', 'Log4j 등 제로데이 취약점 즉각 식별 및 라이선스 컴플라이언스 검증', '인공지능기본법 투명성 준수, 악성 백도어 모델(Pickle 변조)·데이터 오염 추적'],
      ['표준 포맷', 'ISO/IEC 5962(SPDX), OWASP CycloneDX, SWID', 'CycloneDX ML-BOM, SPDX 3.0 AI Profile, HuggingFace Model Card']],
     '기존 SW 공급망 보안의 핵심인 SBOM에 더해, 인공지능기본법 시행으로 AI 모델의 학습 데이터·기저 모델·가중치 구성을 명세하는 AIBOM(SPDX 3.0 AI 프로파일 / CycloneDX ML-BOM)과 VEX가 핵심 출제 포인트다.'),

    (9, '2~4교시 서술형 (25점)', '[DB] 데이터베이스 · 데이터모델링 · 분산데이터', '개념/트랜잭션형', '출제주기 도래 (MVCC & 격리수준)',
     '130회 병행제어, 137회 트랜잭션 격리수준에 이어 분산 환경 스냅샷 격리 및 이상현상 심화 대비',
     '데이터베이스 트랜잭션 격리 수준(ANSI SQL 4단계)별 이상 현상과 MVCC 기반 스냅샷 격리(Snapshot Isolation)의 Write Skew(쓰기 편향) 문제 및 해결 방안',
     ['1. 리드문: 동시성과 데이터 정합성의 트레이드오프 트랜잭션 격리 수준', '2. Read Uncommitted ~ Serializable 4단계와 MVCC Undo 스냅샷 읽기 메커니즘', '3. 격리 수준별 발생 이상 현상(Dirty Read, Non-repeatable Read, Phantom Read, Write Skew) 매트릭스 표', '4. SSI(Serializable Snapshot Isolation) 및 SELECT FOR UPDATE 기반 정합성 보장 방안'],
     'ANSI Isolation Level, Dirty Read, Non-repeatable Read, Phantom Read, Snapshot Isolation(SI), Write Skew(쓰기 편향), SSI',
     ['격리 수준', 'Dirty Read', 'Non-Repeatable Read', 'Phantom Read / Write Skew'],
     [['Read Uncommitted', '발생 가능', '발생 가능', '발생 가능'],
      ['Read Committed (Oracle/PG 기본)', '방지됨', '발생 가능', '발생 가능'],
      ['Repeatable Read / Snapshot Isolation', '방지됨', '방지됨', 'MVCC로 Phantom 상당수 방지, 단 두 트랜잭션이 교차 갱신하는 Write Skew 발생 가능'],
      ['Serializable (SSI)', '방지됨', '방지됨', '방지됨 (SIREAD 잠금·의존성 그래프 추적으로 Write Skew까지 완전 차단)']],
     '전통적인 ANSI 4단계 격리수준 표에 더해, 현대 RDBMS가 사용하는 MVCC 스냅샷 격리(Snapshot Isolation) 환경에서 발생하는 교차 쓰기 이상 현상(Write Skew)과 이를 해결하는 SSI(Serializable Snapshot Isolation)까지 서술하면 차별화된 고득점 답안이 된다.'),

    (10, '1교시 단답·용어형 (10점)', '[NW/Cloud] 네트워크 · 클라우드 · 차세대통신', '개념/보안네트워크형', '출제주기 도래 (SASE & SSE)',
     '클라우드 전환 및 원격근무·N2SF 환경에서 네트워크와 보안의 융합 아키텍처',
     '클라우드 기반 네트워크·보안 융합 아키텍처 SASE(Secure Access Service Edge)와 SSE(Security Service Edge)',
     ['1. 리드문: 레거시 중앙 백홀(Backhaul) 네트워크의 한계와 SASE/SSE 등장 배경', '2. WAN Edge(SD-WAN) + Security Service Edge(SWG, CASB, ZTNA, FWaaS) 결합 구조도', '3. SASE vs SSE 구성요소 비교 및 핵심 보안 기능 설명', '4. 단일 벤더 vs 듀얼 벤더 SASE 도입 시 고려사항'],
     'SASE, SSE(Security Service Edge), SD-WAN, ZTNA, CASB, SWG(보안웹게이트웨이), FWaaS, DLP',
     ['구분', 'WAN 네트워크 계층', '클라우드 보안 계층 (SSE 구성요소)', '통합 가치'],
     [['SSE (보안 서비스 엣지)', '포함하지 않음 (보안 기능만 단일 클라우드 플랫폼으로 통합)', 'ZTNA(제로트러스트 접속) + CASB(SaaS 보안) + SWG(웹 보안) + FWaaS/DLP', '기존 네트워크 변경 없이 보안 스택을 클라우드 엣지로 신속 통합'],
      ['SASE (보안 접속 서비스 엣지)', 'SD-WAN, WAN 최적화, QoS 라우팅 통합', 'SSE 전체 구성요소 (ZTNA + CASB + SWG + FWaaS)', '네트워크 연결성과 제로트러스트 보안을 단일 클라우드 네이티브 서비스로 제공']],
     '제로트러스트 및 국가 망 보안체계(N2SF)를 실제 클라우드 네트워크에서 구현하는 대표 아키텍처인 SASE와 SSE의 구성요소(SD-WAN + ZTNA, CASB, SWG, FWaaS)는 1교시 및 3교시 단골 출제 후보다.'),

    (11, '2~4교시 서술형 (25점)', '[ITBiz/PM] 프로젝트관리 · IT경영 · 감리 · BPR', '원인분석/산정형', '출제주기 도래 (SW 사업 대가산정 & AI FP)',
     '생성형 AI 도입 사업 확산에 따른 SW 사업 대가산정 가이드(기능점수 FP 및 AI 서비스 산정) 실무 이슈',
     '소프트웨어 개발 사업의 적정 대가 산정을 위한 기능점수(FP, Function Point) 산정 방식(정통법 vs 간이법)과 AI 도입 프로젝트의 비용 산정 및 과업 변경 관리 방안',
     ['1. 리드문: SW 제값주기와 과업 범위 분쟁 예방을 위한 기능점수(FP) 산정 체계', '2. 데이터 기능(ILF, EIF) + 트랜잭션 기능(EI, EO, EQ) 식별 및 보정 후 개발원가 산출 구조도', '3. 정통법(IFPUG) vs 간이법(평균복잡도) 비교 및 AI 모델 도입 사업(데이터 구축·학습·튜닝) 대가 산정 기준', '4. 과업심의위원회 의무화 및 애자일·클라우드 사업 계약 제도 개선 제언'],
     '기능점수(FP), 데이터 기능(ILF/EIF), 트랜잭션 기능(EI/EO/EQ), 정통법 vs 간이법, 과업심의위원회, AI 학습용 데이터 대가산정',
     ['기능 구분', '세부 유형', '판별 기준 및 역할'],
     [['데이터 기능 (Data Function)', 'ILF (내부논리파일), EIF (외부연계파일)', '시스템 내부에서 유지관리하는 논리적 데이터 그룹(ILF) vs 타 시스템에서 참조만 하는 데이터(EIF)'],
      ['트랜잭션 기능 (Transaction)', 'EI (외부입력), EO (외부출력), EQ (외부조회)', 'ILF를 등록·수정·삭제하는 처리(EI) vs 계산·파생 로직을 포함한 출력(EO) vs 단순 조회 출력(EQ)']],
     '공공·금융 정보화 사업 관리(ISMP/PMO/감리)에서 가장 빈번하게 출제되는 주제가 기능점수(FP: ILF, EIF, EI, EO, EQ) 산정과 소프트웨어진흥법상 과업심의위원회를 통한 과업 변경 관리다.'),

    (12, '1교시 단답·용어형 (10점)', '[CA/OS] 컴퓨터구조 · 운영체제 · 양자컴퓨팅', '개념/운영체제형', '출제주기 도래 (eBPF & BPFdoor 연관)',
     '137회 4교시 BPFdoor 악성코드 출제 → 기저 커널 기술인 eBPF의 클라우드 네이티브 관측·보안 활용 출제 유력',
     '리눅스 커널 샌드박스 기술 eBPF(extended Berkeley Packet Filter)의 동작 원리와 클라우드 네이티브(네트워크·관측가능성·보안) 활용',
     ['1. 리드문: 커널 소스 수정 없이 커널 공간에서 안전하게 프로그램을 실행하는 eBPF', '2. User Space(바이트코드 컴파일) → eBPF Verifier(안전성 검증) → JIT 컴파일러 → Kernel Hook(kprobe/XDP) 구조도', '3. 기존 커널 모듈(LKM) vs 사이드카 프록시(Sidecar) vs eBPF(Sidecarless) 비교', '4. Cilium(네트워크/보안), Falco(런타임 보안) 활용 및 BPFdoor 등 커널 루트킷 방어 방안'],
     'eBPF, Verifier(검증기), JIT Compiler, XDP(eXpress Data Path), kprobe/tracepoint, Sidecarless Service Mesh(Cilium)',
     ['비교 항목', '리눅스 커널 모듈 (LKM)', '사이드카 프록시 (Istio Envoy)', 'eBPF 기반 아키텍처 (Cilium)'],
     [['안전성 및 안정성', '커널 코드 오류 시 즉시 커널 패닉(Kernel Panic) 발생 위험', '유저 공간 격리로 안전하나 Pod당 프록시 메모리·CPU 오버헤드 큼', 'eBPF Verifier가 무한루프·메모리 침범을 사전 차단하여 커널 안정성 보장'],
      ['성능 및 오버헤드', '네트워크 스택 우회 어려움 또는 높은 개발 난이도', '유저↔커널 컨텍스트 스위칭 및 TCP/IP 스택 중복 통과 지연', '커널 소켓·XDP 계층에서 직접 패킷 처리하여 초고속·저지연(Sidecarless) 달성']],
     '137회 4교시에 eBPF를 악용한 BPFdoor가 출제되었으므로, 정방향 핵심 기술인 eBPF의 구조(Verifier, JIT, XDP, Maps)와 쿠버네티스 사이드카리스 서비스 메시(Cilium) 활용은 1교시/2교시 핵심 예상 토픽이다.'),

    (13, '1교시 단답·용어형 (10점)', '[AI/Data] 인공지능 · 빅데이터 · 통계', '비교/수리통계형', '매회 필수 (통계/추론 파트)',
     '131회 t-검정, 132회 점/구간추정, 135회 불편추정량, 139회 중심극한정리, 140회 잭나이프에 이은 통계 필수 토픽',
     '가설검정에서의 제1종 오류(α)와 제2종 오류(β), 유의수준(p-value)과 검정력(Power, 1-β)의 관계',
     ['1. 리드문: 통계적 의사결정의 불확실성 통제를 위한 가설검정 오류 체계', '2. 귀무가설(H0) 참/거짓에 따른 제1종 오류(α, 위양성) vs 제2종 오류(β, 위음성) 분포도', '3. 제1종 오류(α) vs 제2종 오류(β) 및 검정력(1-β) 트레이드오프 비교표', '4. 다중 가설검정 시 본페로니 교정(Bonferroni) 및 표본 크기(n) 확대를 통한 동시 감소 방안'],
     '귀무가설(H0), 대립가설(H1), 제1종 오류(α, 유의수준), 제2종 오류(β), 검정력(Statistical Power = 1-β), p-value, 표본 크기(n)',
     ['실제 상태 \\ 판정 결과', '귀무가설(H0) 채택 (차이 없음)', '귀무가설(H0) 기각 / 대립가설(H1) 채택'],
     [['귀무가설(H0)이 실제로 참(True)', '올바른 결정 (신뢰수준 = 1 - α)', '제1종 오류 (Type I Error, 위험률 α): 효과 없는데 있다고 오판 (False Positive)'],
      ['대립가설(H1)이 실제로 참(H0 거짓)', '제2종 오류 (Type II Error, β): 실제 효과 있는데 놓침 (False Negative)', '올바른 결정 (검정력 Power = 1 - β): 실제 차이를 정확히 검출']],
     '정보관리기술사 1교시에는 매 회차 통계학 문제가 1~2문항씩 빠짐없이 출제된다. 표본 크기 n이 고정된 상태에서 α를 줄이면 β가 커지는 상충관계와, 두 오류를 동시에 줄여 검정력(1-β)을 높이는 유일한 방법이 표본 크기(n) 확대임을 명확히 서술해야 한다.'),

    (14, '2~4교시 서술형 (25점)', '[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트', '비교/아키텍처형', '출제주기 도래 (클라우드 디자인 패턴)',
     '대규모 MSA 및 AI API 연동 환경에서 장애 전파(Cascading Failure) 방지를 위한 회복탄력성 아키텍처',
     '마이크로서비스(MSA) 환경에서 장애 전파 차단을 위한 회복탄력성(Resiliency) 디자인 패턴(Circuit Breaker, Bulkhead, Retry with Exponential Backoff, Rate Limiter) 설명',
     ['1. 리드문: 분산 시스템의 부분 장애가 전체 시스템 붕괴로 이어지는 연쇄 장애(Cascading Failure) 방지', '2. 서킷 브레이커 상태 전이도(Closed → Open → Half-Open) 및 벌크헤드(스레드/커넥션 풀 격리) 구조도', '3. 4대 회복탄력성 패턴(Circuit Breaker, Bulkhead, Exponential Backoff + Jitter, Fallback) 비교표', '4. 서비스 메시(Istio) 및 카오스 엔지니어링(Chaos Engineering) 기반 장애 복원력 검증 제언'],
     'Cascading Failure(연쇄 장애), Circuit Breaker(Closed/Open/Half-Open), Bulkhead(격벽 패턴), Exponential Backoff with Jitter, Chaos Engineering',
     ['패턴 명칭', '핵심 동작 원리', '방지하는 장애 유형'],
     [['Circuit Breaker (회로 차단기)', '하위 서비스 실패율이 임계치 초과 시 회로를 Open하여 즉시 실패 반환(Fail-fast) 및 Fallback 실행', '응답 없는 하위 서비스 대기 스레드 고갈 및 연쇄 장애 차단'],
      ['Bulkhead (격벽 패턴)', '선박의 수밀 격벽처럼 서비스별 스레드 풀·커넥션 풀을 물리/논리적으로 분리 할당', '특정 비핵심 API 폭주가 결제 등 핵심 API 자원까지 고갈시키는 현상 방지'],
      ['Retry + Exponential Backoff & Jitter', '재시도 간격을 지수적으로 늘리고 무작위 지연(Jitter)을 추가하여 동시 재요청 분산', '장애 복구 직후 수만 클라이언트가 동시에 재시도하여 서버가 재다운되는 Thundering Herd 방지']],
     '138회 3교시 고가용성(HA/FTS) 및 클라우드 네이티브 전환에 이어, 소프트웨어 아키텍처 수준에서 장애 격리와 자가 치유를 달성하는 회복탄력성(Resiliency) 패턴과 카오스 엔지니어링은 2교시 서술형 정통 대비 토픽이다.'),

    (15, '1교시 단답·용어형 (10점)', '[Law/Gov] IT 법제도 · AI거버넌스 · 공공정책', '개념/법제도형', '법·제도 직결 (디지털 서비스 안전)',
     '공공·금융 대형 IT 장애 재발 방지 대책 및 디지털서비스 안정성 강화 제도',
     '전자정부법 및 정보통신망법상 디지털서비스 안정성 확보를 위한 장애 관리 체계와 카오스 엔지니어링(Chaos Engineering)',
     ['1. 리드문: 초연결 사회의 디지털 블랙아웃 방지와 시스템 회복탄력성(Resilience) 의무화', '2. 예방(이중화/용량산정) → 대비(모의훈련/Chaos Engineering) → 대응(트래픽 우회/DR) → 복구(RCA) 구조도', '3. 고가용성(HA: Active-Active/Standby) vs 재해복구(DR: Mirror/Hot/Warm/Cold Site) 비교 (RTO/RPO)', '4. 변경관리(작업 시간대 분리·Canary 배포) 및 다중 리전 액티브-액티브 전환 제언'],
     'RTO(목표복구시간), RPO(목표복구시점), Multi-Region Active-Active, 카오스 엔지니어링(Fault Injection), 변경관리 거버넌스',
     ['DR 유형', 'RTO (목표복구시간)', 'RPO (목표복구시점)', '데이터 동기화 및 인프라 구성'],
     [['Mirror Site (Active-Active)', '즉시 (수 초~수 분 이내)', '0 (무손실)', '주센터와 DR센터가 실시간 동기 복제 및 동시 트래픽 처리 (137회 3교시 출제)'],
      ['Hot Site (Active-Standby)', '수 시간 이내', '수 분~수 시간', '동일 수준 인프라 대기 및 비동기/준실시간 데이터 복제'],
      ['Warm / Cold Site', '수 일 ~ 수 주', '수 시간 ~ 수 일', '핵심 자원만 일부 보유(Warm)하거나 상면 공간만 확보(Cold) 후 백업 테이프/스냅샷 복구']],
     '137회 3교시 Multi-Region Active-Active DR과 138회 4교시 공공망 인프라 신뢰성 확보 방안에 이어, RTO/RPO 기준과 프로덕션 환경에 의도적 장애를 주입해 복원력을 검증하는 카오스 엔지니어링의 결합이 중요하다.'),

    (16, '1교시 단답·용어형 (10점)', '[AI/Data] 인공지능 · 빅데이터 · 통계', '개념/개인정보AI형', '신규 트렌드 (Machine Unlearning)',
     '생성형 AI의 개인정보 잊힐 권리(Right to be Forgotten) 및 저작권 오염 데이터 제거 기술',
     '기계 언러닝(Machine Unlearning, 기계 망각)의 개념과 Exact Unlearning vs Approximate Unlearning 기법 비교',
     ['1. 리드문: AI 모델의 잊힐 권리(GDPR/개인정보보호법) 보장을 위한 Machine Unlearning', '2. 전체 재학습(Retraining) 없이 특정 데이터 영향만 제거하는 SISA 및 가중치 보정 구조도', '3. Exact Unlearning(SISA 등 분할 학습) vs Approximate Unlearning(경사 상승/영향 함수) 비교', '4. 멤버십 추론 공격(MIA) 기반 망각 검증 및 LLM 가드레일과의 상호보완 방안'],
     '잊힐 권리(Right to be Forgotten), Machine Unlearning, SISA(Sharded, Isolated, Sliced, Aggregated), Exact vs Approximate Unlearning',
     ['비교 항목', 'Exact Unlearning (완전 망각)', 'Approximate Unlearning (근사 망각)'],
     [['핵심 원리', '데이터를 샤드/슬라이스로 분할 학습(SISA) 후 삭제 요청된 데이터가 속한 조각만 재학습', '영향 함수(Influence Function)나 역방향 경사(Gradient Ascent)로 해당 데이터의 가중치 흔적만 수학적 상쇄'],
      ['장단점', '완벽한 데이터 제거 보장, 단 모델 구조 분할 및 저장 오버헤드 존재', '초거대 LLM에도 빠른 속도로 적용 가능, 단 통계적 흔적 완전 제거 증명 까다로움']],
     '개인정보보호위원회의 AI 프라이버시 가이드라인과 유럽 GDPR의 잊힐 권리 요구에 따라, 수천억 파라미터 LLM을 처음부터 재학습하지 않고 특정 개인정보·저작권 데이터만 선택적으로 지우는 Machine Unlearning이 유력한 1교시 토픽이다.'),

    (17, '2~4교시 서술형 (25점)', '[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트', '절차/현대화형', '출제주기 도래 (레거시 현대화 & 7R)',
     '138회 2교시 재공학/역공학 및 클라우드 네이티브 전환에 이은 애플리케이션 현대화 전략',
     '레거시 시스템의 클라우드 네이티브 애플리케이션 현대화(Application Modernization)를 위한 7R 마이그레이션 전략과 점진적 전환 패턴(Strangler Fig, Change Data Capture)',
     ['1. 리드문: 빅뱅(Big-Bang) 방식 차세대 프로젝트의 실패 위험 극복을 위한 점진적 현대화', '2. API 게이트웨이/파사드 기반 교살자 무화과(Strangler Fig) 및 Outbox/CDC 데이터 동기화 구조도', '3. 가트너/AWS 7R 마이그레이션 전략(Rehost, Relocate, Replatform, Refactor, Repurchase, Retire, Retain) 비교표', '4. 도메인 주도 설계(DDD) 이벤트 스토밍 기반 바운디드 컨텍스트 분리 제언'],
     'Application Modernization, 7R 전략, Strangler Fig Pattern(교살자 무화과 패턴), Anti-Corruption Layer(부패방지계층), CDC/Outbox 패턴, DDD',
     ['전환 패턴', '동작 메커니즘', '핵심 기대효과'],
     [['Strangler Fig (교살자 패턴)', '레거시 앞단에 라우팅 파사드(API GW)를 두고 기능을 하나씩 신규 MSA로 이관하며 레거시를 점진 축소', '무중단 운영 유지 및 빅뱅 오픈 시의 전면 장애 리스크 원천 제거'],
      ['Anti-Corruption Layer (ACL)', '신규 마이크로서비스와 구형 레거시 DB/시스템 사이에 어댑터·번역 계층 배치', '레거시의 노후화된 데이터 스키마가 신규 도메인 모델을 오염시키는 현상 차단'],
      ['Transactional Outbox + CDC', '도메인 이벤트를 로컬 Outbox 테이블에 원자적 기록 후 Debezium(CDC)으로 카프카 발행', '2PC 없이 레거시 DB와 신규 MSA 간 최종적 일관성(Eventual Consistency) 보장']],
     '138회 2교시에서 역공학·재공학과 클라우드 네이티브 TA/AA 역할이 출제되었으므로, 실제 모놀리식 레거시를 무중단으로 MSA로 분해하는 Strangler Fig 패턴, 부패방지계층(ACL), Outbox/CDC 패턴의 결합은 2~3교시 최적의 주제다.'),

    (18, '1교시 단답·용어형 (10점)', '[DB] 데이터베이스 · 데이터모델링 · 분산데이터', '개념/데이터아키텍처형', '신규 트렌드 (Zero-ETL & Lakehouse)',
     'OLTP와 OLAP/AI 파이프라인 간 배치 ETL 지연을 제거하는 최신 데이터 아키텍처',
     '데이터 레이크하우스(Data Lakehouse: Iceberg/Delta Lake)와 Zero-ETL 아키텍처',
     ['1. 리드문: DW의 정합성(ACID)과 Data Lake의 저비용 유연성을 결합한 Lakehouse 및 Zero-ETL', '2. 오픈 테이블 포맷(Apache Iceberg/Delta Lake/Hudi) 메타데이터 계층 및 Zero-ETL 실시간 복제 구조도', '3. Data Warehouse vs Data Lake vs Data Lakehouse 비교표', '4. 실시간 RAG/AI 피처 공급을 위한 스트리밍 레이크하우스 구축 방안'],
     'Data Lakehouse, 오픈 테이블 포맷(Apache Iceberg, Delta Lake, Apache Hudi), ACID 트랜잭션, Time Travel(시간여행 쿼리), Schema Evolution, Zero-ETL',
     ['비교 항목', '데이터 레이크 (Data Lake)', '데이터 레이크하우스 (Data Lakehouse)'],
     [['저장소 및 포맷', '저비용 오브젝트 스토리지(S3) + Parquet/ORC 원시 파일', '오브젝트 스토리지 + 트랜잭션 메타데이터 계층(Iceberg/Delta Lake)'],
      ['트랜잭션 및 품질', 'ACID 미지원, 부분 실패 시 데이터 오염(Data Swamp) 위험', 'ACID 트랜잭션 보장, 스키마 진화(Schema Evolution), 과거 시점 조회(Time Travel) 지원'],
      ['활용 워크로드', '데이터 사이언스·머신러닝 배치 학습 중심 (BI 성능 낮음)', '단일 스토리지 사본 위에서 고성능 BI/SQL 분석과 AI/ML 학습 동시 수행']],
     '기존 DW와 데이터 레이크의 이중 적재 비용과 ETL 지연을 해결하는 오픈 테이블 포맷(Apache Iceberg, Delta Lake) 기반 데이터 레이크하우스와 Zero-ETL은 데이터 엔지니어링 파트의 핵심 출제 후보다.'),

    (19, '1교시 단답·용어형 (10점)', '[Sec] 정보보안 · 암호 · 개인정보보호', '개념/클라우드보안형', '출제주기 도래 (CNAPP)',
     '클라우드 네이티브 환경의 파편화된 보안 도구를 개발~런타임 전주기로 통합한 플랫폼',
     '클라우드 네이티브 애플리케이션 보호 플랫폼 CNAPP(Cloud-Native Application Protection Platform)의 개념과 구성요소(CSPM, CWPP, CIEM, KSPM)',
     ['1. 리드문: 멀티클라우드·컨테이너 전주기(Shift-Left ~ Runtime) 통합 보안 플랫폼 CNAPP', '2. 개발(IaC 스캐닝/SBOM) → 배포(레지스트리 검증) → 운영(CSPM + KSPM + CIEM + CWPP) 통합 아키텍처도', '3. CNAPP 4대 핵심 축(CSPM, CWPP, CIEM, KSPM) 비교표', '4. 공격 경로 분석(Attack Path Analysis) 및 CTEM 연계 운영 방안'],
     'CNAPP, CSPM(클라우드 보안 형상 관리), CWPP(클라우드 워크로드 보호), CIEM(클라우드 인프라 권한 관리), KSPM(쿠버네티스 보안), Shift-Left',
     ['구성 요소', '보호 대상 및 초점', '핵심 보안 기능'],
     [['CSPM / KSPM', '클라우드 인프라 및 쿠버네티스 클러스터 설정(Configuration)', 'S3 공개 설정 오류, 보안그룹 과다 개방, K8s Pod 보안 정책 위반 자동 탐지·교정'],
      ['CIEM (권한 관리)', '인간 및 비인간 신원(NHI)의 IAM 권한(Entitlement)', '최소 권한 원칙 위배 및 과도한 클라우드 권한 식별·축소(Right-sizing)'],
      ['CWPP (워크로드 보호)', '가상머신(VM), 컨테이너, 서버리스 함수 런타임(Runtime)', '런타임 악성 행위·무결성 침해 탐지(eBPF 기반) 및 마이크로세그멘테이션']],
     '개별적으로 출제되던 CSPM(형상관리), CWPP(워크로드 보호), CIEM(권한관리)을 하나의 플랫폼으로 통합해 컨텍스트 기반 공격 경로(Attack Path)를 분석하는 CNAPP은 클라우드 보안 필수 토픽이다.'),

    (20, '2~4교시 서술형 (25점)', '[Law/Gov] IT 법제도 · AI거버넌스 · 공공정책', '개념/평가지표형', '출제주기 도래 (AI 레드티밍 & 안전성 평가)',
     '137회 AI 신뢰성 검인증(CAT), 138회 AI RMF/인공지능기본법에 이은 구체적 AI 검증 방법론',
     '생성형 AI 및 고영향 AI 시스템의 신뢰성·안전성 검증을 위한 AI 레드티밍(AI Red Teaming) 수행 절차와 정량적 평가 지표(RAGAS, LLM-as-a-Judge) 구축 방안',
     ['1. 리드문: 확률적 생성형 AI의 예측 불가능한 위험 검증을 위한 AI 레드티밍과 자동 평가 체계', '2. 위협 모델링 → 적대적 공격 시나리오(탈옥/편향/CBRN/환각) 생성 → 자동·수동 레드티밍 → 가드레일 보강 구조도', '3. RAG 파이프라인 정량 평가 프레임워크 RAGAS 4대 지표(Context Precision, Context Recall, Faithfulness, Answer Relevancy) 비교표', '4. LLM-as-a-Judge의 편향(위치·길이 편향) 보정 및 지속적 AI 품질 보증(LLMOps) 제언'],
     'AI Red Teaming, 적대적 프롬프트(Jailbreak), RAGAS(Faithfulness, Answer Relevancy, Context Precision/Recall), LLM-as-a-Judge, AI 안전연구소',
     ['RAGAS 핵심 지표', '평가 단계', '측정 내용 및 수식적 의미'],
     [['Context Precision / Recall', '검색기 (Retriever) 품질 평가', '검색된 문서 중 실제 정답 관련 문서가 상위에 랭크되었는지(Precision) 및 누락 없이 포함되었는지(Recall)'],
      ['Faithfulness (충실도)', '생성기 (Generator) 환각 억제 평가', 'LLM이 생성한 답변의 모든 주장이 검색된 컨텍스트 문서에만 근거하고 있는지(할루시네이션 유무)'],
      ['Answer Relevancy (적절성)', '최종 응답 적합성 평가', '생성된 답변이 사용자의 원래 질문 의도에 동문서답 없이 직접적으로 부합하는지 평가']],
     '인공지능기본법과 CAT(AI 신뢰성 검인증)에서 요구하는 안전성·신뢰성을 실무에서 어떻게 측정할 것인가에 대한 해답으로, 적대적 취약점을 검증하는 AI 레드티밍(AI Red Teaming)과 RAG 정량 평가 지표인 RAGAS(Faithfulness, Relevancy, Context Precision/Recall)를 함께 제시하면 최고 수준의 답안이 된다.')
]

# 7. 정규화 SQLite DB 생성 및 통계 분석 산출
def build_database():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    cur.executescript("""
    PRAGMA foreign_keys = ON;

    CREATE TABLE exam_rounds (
        round_id INTEGER PRIMARY KEY,
        round_title TEXT NOT NULL,
        exam_year INTEGER NOT NULL,
        exam_date TEXT NOT NULL,
        source_url TEXT NOT NULL,
        trend_summary TEXT NOT NULL
    );

    CREATE TABLE categories_period (
        period_id INTEGER PRIMARY KEY,
        period_code TEXT NOT NULL,
        period_name TEXT NOT NULL,
        point_value INTEGER NOT NULL,
        recommended_minutes INTEGER NOT NULL,
        description TEXT NOT NULL
    );

    CREATE TABLE categories_domain (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL,
        domain_name TEXT NOT NULL,
        description TEXT NOT NULL
    );

    CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY AUTOINCREMENT,
        round_id INTEGER NOT NULL,
        period_id INTEGER NOT NULL,
        question_no INTEGER NOT NULL,
        domain_id INTEGER NOT NULL,
        question_format TEXT NOT NULL,
        question_header TEXT NOT NULL,
        sub_prompts_json TEXT NOT NULL,
        standard_outline_json TEXT NOT NULL,
        core_keywords TEXT NOT NULL,
        comparison_table_json TEXT NOT NULL,
        model_answer_text TEXT NOT NULL,
        escalation_note TEXT NOT NULL,
        FOREIGN KEY (round_id) REFERENCES exam_rounds(round_id),
        FOREIGN KEY (period_id) REFERENCES categories_period(period_id),
        FOREIGN KEY (domain_id) REFERENCES categories_domain(domain_id)
    );

    CREATE TABLE domain_analytics (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL,
        domain_name TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        share_pct REAL NOT NULL,
        p1_count INTEGER NOT NULL,
        p234_count INTEGER NOT NULL,
        round_appearances INTEGER NOT NULL,
        avg_interval REAL NOT NULL,
        last_seen_round INTEGER NOT NULL,
        rounds_since_last INTEGER NOT NULL,
        imminence_index REAL NOT NULL,
        primary_format TEXT NOT NULL,
        rising_keywords TEXT NOT NULL
    );

    CREATE TABLE predicted_topics (
        pred_id INTEGER PRIMARY KEY,
        target_period TEXT NOT NULL,
        domain_name TEXT NOT NULL,
        question_format TEXT NOT NULL,
        imminence_badge TEXT NOT NULL,
        basis TEXT NOT NULL,
        question_header TEXT NOT NULL,
        standard_outline_json TEXT NOT NULL,
        core_keywords TEXT NOT NULL,
        comparison_table_json TEXT NOT NULL,
        model_answer_text TEXT NOT NULL
    );

    -- 3대 서브노트 학습 모드 전용 View
    CREATE VIEW v_mode_exam AS
    SELECT
        q.question_id, r.round_id, r.round_title, r.exam_year,
        p.period_id, p.period_name, p.point_value, p.recommended_minutes,
        d.domain_id, d.domain_name,
        q.question_no, q.question_format, q.question_header, q.sub_prompts_json
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_period p ON q.period_id = p.period_id
    JOIN categories_domain d ON q.domain_id = d.domain_id;

    CREATE VIEW v_mode_compare AS
    SELECT
        q.question_id, r.round_id, r.round_title, r.exam_year,
        p.period_id, p.period_name, p.point_value, p.recommended_minutes,
        d.domain_id, d.domain_name,
        q.question_no, q.question_format, q.question_header, q.sub_prompts_json,
        q.standard_outline_json, q.core_keywords
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_period p ON q.period_id = p.period_id
    JOIN categories_domain d ON q.domain_id = d.domain_id;

    CREATE VIEW v_mode_explanation AS
    SELECT
        q.question_id, r.round_id, r.round_title, r.exam_year,
        p.period_id, p.period_name, p.point_value, p.recommended_minutes,
        d.domain_id, d.domain_name,
        q.question_no, q.question_format, q.question_header, q.sub_prompts_json,
        q.standard_outline_json, q.core_keywords, q.comparison_table_json,
        q.model_answer_text, q.escalation_note
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_period p ON q.period_id = p.period_id
    JOIN categories_domain d ON q.domain_id = d.domain_id;
    """)

    cur.executemany("INSERT INTO exam_rounds VALUES (?, ?, ?, ?, ?, ?)", EXAM_ROUNDS)
    cur.executemany("INSERT INTO categories_period VALUES (?, ?, ?, ?, ?, ?)", CATEGORIES_PERIOD)
    cur.executemany("INSERT INTO categories_domain VALUES (?, ?, ?, ?)", CATEGORIES_DOMAIN)

    # Extra authentic topics across 120~139 rounds
    EXTRA_TOPICS = [
        (139, 1, 4, 7, '원인분석/대응전략형', 'IT 프로젝트의 부정적 위험(Negative Risk)과 4대 대응 전략(회피, 전가, 완화, 수용)',
         ['1. PMBOK 기반 부정적 위험(Threat)과 긍정적 위험(Opportunity) 비교', '2. 부정적 위험 4대 대응 전략(Avoid, Transfer, Mitigate, Accept) 및 우발사태 예비비(Contingency Reserve) 관리']),
        (139, 1, 6, 5, '비교/아키텍처형', '엣지(Edge) 컴퓨팅과 클라우드(Cloud) 컴퓨팅의 차이점 및 하이브리드 연계 아키텍처',
         ['1. 데이터 발생원 인접 초저지연 처리를 위한 엣지 컴퓨팅과 중앙집중형 클라우드 컴퓨팅 비교', '2. 온디바이스 AI·다크팩토리·자율주행 환경에서의 Cloud-Edge-Endpoint 3계층 협업 구조']),
        (139, 1, 8, 1, '원인분석/대응전략형', '기계학습에서 과적합(Overfitting)과 과소적합(Underfitting) 발생 원인 및 해결 방안(편향-분산 트레이드오프)',
         ['1. 편향(Bias)-분산(Variance) 트레이드오프 관점에서의 과소적합·과적합 정의', '2. 정규화(L1 Lasso / L2 Ridge), Dropout, 조기종료(Early Stopping), 교차검증(K-Fold) 해결 기법']),
        (139, 3, 1, 8, '원인분석/거버넌스형', '인공지능(AI) 리스크의 개념 및 보안·프라이버시·사회적 리스크 유형과 전주기 완화 방안',
         ['가. AI 기술적·보안적 리스크(적대적 공격, 환각, 데이터 오염) 및 프라이버시 리스크', '나. 사회적 리스크(알고리즘 편향, 딥페이크, 일자리·환경 영향) 및 AI 거버넌스 통제 체계']),
        (138, 1, 4, 1, '절차/수리통계형', '베이즈 정리(Bayes Theorem)의 사전확률·우도·사후확률 구조와 나이브 베이즈(Naive Bayes)·베이지안 추론 응용',
         ['1. 조건부 확률 기반 베이즈 정리 수식 P(A|B) = P(B|A)P(A)/P(B) 의미', '2. 스팸 필터링·이상탐지(Naive Bayes) 및 베이지안 하이퍼파라미터 최적화 활용']),
        (138, 1, 6, 2, '절차/방법론형', '소프트웨어 개발 프로젝트 특성에 맞춘 개발방법론 테일러링(Tailoring) 기준과 절차',
         ['1. 프로젝트 규모·복잡도·기술성숙도에 따른 방법론 테일러링(조정)의 필요성', '2. 내부적 기준(목표환경, 요구사항, 프로젝트규모, 보유기술)과 외부적 기준(법적제약, 표준준수) 매트릭스']),
        (138, 1, 7, 1, '비교/시계열분석형', '시계열 분석에서 자기회귀모형(AR, Autoregressive)과 이동평균모형(MA, Moving Average), ARIMA 모델 비교',
         ['1. 정상성(Stationarity) 확보를 위한 차분(Differencing)과 ACF/PACF 패턴 분석', '2. 과거 관측치에 의존하는 AR(p) 모형과 과거 오차항에 의존하는 MA(q) 모형 및 ARIMA(p,d,q) 결합']),
        (138, 1, 10, 3, '개념/위협인텔리전스형', '사이버 위협 행위자의 전술·기법·절차 TTPs(Tactics, Techniques and Procedures)와 MITRE ATT&CK 프레임워크',
         ['1. 피라미드 오브 페인(Pyramid of Pain) 최상위 지표로서의 TTPs 가치', '2. MITRE ATT&CK 매트릭스 기반 위협 헌팅(Threat Hunting) 및 침해지표(IoC) 대비 우위성']),
        (138, 1, 11, 6, '절차/알고리즘형', '운영체제 교착상태(Deadlock) 회피를 위한 다익스트라의 은행가 알고리즘(Banker Algorithm)',
         ['1. 안전 상태(Safe State)와 불안전 상태(Unsafe State) 판별 원리', '2. Max, Allocation, Need(Max-Allocation), Available 행렬을 이용한 안전 순서열(Safe Sequence) 도출 절차']),
        (138, 2, 1, 4, '절차/전환전략형', '상용 DBMS에서 오픈소스 DBMS(PostgreSQL, MariaDB 등)로의 전환 전략 및 단계별 고려사항',
         ['가. 라이선스 TCO 절감 및 클라우드 네이티브 전환을 위한 오픈소스 DBMS 도입 배경', '나. SQL/프로시저(PL/SQL) 호환성 분석, 스키마·데이터 이관, 무중단 듀얼 라이팅(CDC) 및 고가용성 검증 방안']),
        (138, 2, 5, 2, '비교/유지보수형', '소프트웨어 유지보수 및 레거시 자산화 관점에서의 재공학(Re-engineering)과 역공학(Reverse-engineering) 비교',
         ['가. 역공학(코드 → 설계서/요구사항 역추출)과 재공학(분석 → 재구성 → 이관)의 프로세스 비교', '나. 정적·동적 코드 분석 및 LLM 기반 레거시 코드 문서화·리팩토링 적용 방안']),
        (138, 2, 6, 6, '개념/운영체제형', '프로그램 실행 시 운영체제 프로세스 메모리의 4가지 영역(Code, Data/BSS, Heap, Stack) 구조와 오버플로우 방지',
         ['가. 컴파일 타임 결정 영역(Code, Data, BSS)과 런타임 동적 영역(Heap, Stack)의 역할 및 성장 방향', '나. Stack Overflow와 Heap 메모리 누수(Memory Leak)·버퍼 오버플로우 보안 위협 및 ASLR/Canary 방어']),
        (138, 4, 2, 3, '비교/프라이버시형', '프라이버시 강화 기술(PET, Privacy-Enhancing Technologies)의 주요 유형(차분 프라이버시, 동형암호, 연합학습, 영지식증명, 합성데이터)과 활용 방안',
         ['가. 데이터 수집·처리·분석 전 과정에서 개인정보 노출을 최소화하는 PET 분류 체계', '나. 통계적 프라이버시(차분 프라이버시, 합성데이터)와 암호·분산 기반 PET(동형암호, 다자간안전연산 SMPC, 연합학습) 비교']),
        (138, 4, 4, 3, '원인분석/대응전략형', '서비스형 랜섬웨어(RaaS, Ransomware-as-a-Service) 생태계와 다중 갈취(Multi-Extortion) 공격 동향 및 3-2-1-1-0 불변 백업 대응 전략',
         ['가. RaaS 분업 구조(개발자-제휴 공격자-초기침투브로커 IAB)와 이중·삼중 갈취 메커니즘', '나. EDR/XDR 행위 탐지, 마이크로세그멘테이션 및 에어갭·WORM 기반 불변 백업(Immutable Backup) 복구 체계']),
        (137, 1, 1, 5, '비교/네트워크형', '동적 라우팅 프로토콜에서 자율시스템 내부 라우팅(IGP: RIP, OSPF)과 외부 라우팅(EGP: BGP) 비교',
         ['1. 거리 벡터(Distance Vector, 벨만-포드) vs 링크 상태(Link State, 다익스트라 SPF) 알고리즘 비교', '2. AS 내부 최적 경로 탐색(OSPF)과 AS 간 정책·경로 벡터 라우팅(BGP-4)의 역할 및 보안(RPKI)']),
        (137, 1, 2, 3, '개념/포렌식형', '디지털 포렌식 아티팩트(Digital Forensics Artifact)의 개념과 휘발성 순서(Order of Volatility)에 따른 수집 절차',
         ['1. 윈도우 레지스트리, 프리패치(Prefetch), 이벤트 로그, MFT, 브라우저 아티팩트 등 주요 침해 흔적', '2. RFC 3227 휘발성 순서(레지스터/캐시 → RAM → 네트워크상태 → 디스크 → 백업미디어) 및 무결성(해시 체인) 보장']),
        (137, 1, 8, 8, '개념/검인증형', '민간 자율 AI 신뢰성 검인증 제도(CAT, Certification of AI Trustworthiness)의 평가 기준과 의의',
         ['1. 과기정통부·TTA 기반 AI 신뢰성 검인증(CAT) 추진 배경 및 ISO/IEC 42001·AI RMF 연계성', '2. 위험 식별·완화, 편향성 제거, 설명가능성, 데이터 투명성 등 핵심 검증 항목']),
        (137, 2, 1, 6, '비교/컴퓨터구조형', 'CPU 캐시 메모리(Cache Memory) 매핑 방식(직접, 완전연관, 집합연관)과 쓰기 정책(Write-Through vs Write-Back) 및 캐시 일관성(MESI)',
         ['가. 지역성(시간적·공간적 Locality) 원리와 캐시 매핑 3대 방식 비교', '나. Write-Through(쓰기 버퍼) vs Write-Back(Dirty Bit) 성능·일관성 비교 및 멀티코어 MESI 프로토콜']),
        (135, 1, 3, 2, '개념/요구사항형', '소프트웨어 공학에서 요구사항 추적표(RTM, Requirements Traceability Matrix)의 양방향 추적성과 활용',
         ['1. 정방향 추적(요구사항 → 설계 → 코드 → 테스트)과 역방향 추적(산출물 → 요구사항: Gold Plating 방지) 구조', '2. 범위 누락 방지, 변경 영향도 분석 및 감리/검수 단계에서의 RTM 핵심 검증 역할']),
        (135, 1, 4, 5, '개념/네트워크자동화형', '의도 기반 네트워킹 IBN(Intent-Based Networking)의 4단계(변환-활성화-보증-자가치유) 아키텍처와 SDN 비교',
         ['1. 관리자의 비즈니스 의도(What)를 선언하면 AI·자동화 엔진이 네트워크 설정(How)으로 변환·검증하는 IBN 정의', '2. 명령형 제어 중심의 SDN에서 폐루프 보증(Closed-loop Assurance)을 결합한 IBN으로의 진화']),
        (135, 4, 1, 4, '절차/인덱싱형', '대용량 데이터베이스에서 동적 해싱 기법인 확장성 해싱(Extendible Hashing)의 디렉터리 분할 원리와 정적 해싱 비교',
         ['가. 정적 해싱의 버킷 오버플로우 체인 성능 저하 문제와 동적 해싱의 등장 배경', '나. 전역 깊이(Global Depth)와 지역 깊이(Local Depth)를 이용한 버킷 분할 및 디렉터리 배가(Doubling) 메커니즘']),
        (132, 1, 1, 7, '개념/위험관리표준형', '국제 표준 리스크 관리 프레임워크 ISO 31000의 3대 구성요소(원칙, 프레임워크, 프로세스)',
         ['1. 가치 창출과 보호를 핵심으로 하는 ISO 31000의 8대 원칙과 리더십 기반 프레임워크', '2. 리스크 식별(Identification) → 리스크 분석(Analysis) → 리스크 평가(Evaluation) → 리스크 처리(Treatment) 프로세스']),
        (132, 1, 8, 3, '개념/하드웨어보안형', '하드웨어 기반 신뢰점(Root of Trust)을 제공하는 보안 칩 TPM(Trusted Platform Module) 2.0의 구조와 기능',
         ['1. 암호키 생성·보관(RSA/ECC/AES), 난수 생성기(RNG), 플랫폼 구성 레지스터(PCR) 구조', '2. 측정 부팅(Measured Boot), 디스크 암호화(BitLocker) 키 봉인(Sealing) 및 원격 증명(Remote Attestation)']),
        (132, 1, 11, 1, '원인분석/통계모형형', '회귀분석에서 다중공선성(Multicollinearity)의 발생 원인, 진단 지표(분산팽창계수 VIF >= 10) 및 해결 방안',
         ['1. 독립변수들 간 강한 선형 상관관계로 인해 회귀계수 추정치의 분산이 비정상적으로 커지는 현상', '2. VIF(Variance Inflation Factor) 진단 기준과 변수 제거, 주성분 회귀(PCA), 능형 회귀(Ridge L2) 해결 기법']),
        (130, 1, 8, 5, '개념/클라우드가상화형', '데이터센터 네트워크 가상화를 위한 오버레이 기술 VXLAN(Virtual eXtensible LAN)의 패킷 캡슐화 구조와 VLAN 한계 극복',
         ['1. 기존 IEEE 802.1Q VLAN의 12비트 ID(4,094개) 한계와 STP 링크 차단 비효율 문제', '2. L3 UDP 위에서 L2 프레임을 캡슐화(MAC-in-UDP)하고 24비트 VNI로 1,600만 개 논리 망을 제공하는 VXLAN(VTEP) 원리']),
        (130, 1, 11, 7, '절차/의사결정형', '다기준 의사결정 기법 AHP(Analytic Hierarchy Process, 계층화 분석법)의 수행 절차와 일관성 비율(CR <= 0.1) 검증',
         ['1. 목표 → 평가기준 → 대안의 계층 구조 설정 및 1~9점 척도 쌍대비교(Pairwise Comparison) 행렬 작성', '2. 고유벡터법을 통한 가중치 산출 및 논리적 모순을 검증하는 일관성 지수(CI)/일관성 비율(CR) 산출']),
        (128, 1, 7, 2, '절차/아키텍처평가형', '소프트웨어 아키텍처의 경제적 가치 평가 기법 CBAM(Cost Benefit Analysis Method)',
         ['1. ATAM의 품질속성 기술 평가 결과에 구축 비용(Cost)과 비즈니스 효익(Benefit)을 결합한 SEI 평가 모델', '2. 아키텍처 전략(AS)별 기대 효용(Utility) 산출 및 ROI = Benefit / Cost 기반 투자 우선순위 결정 절차']),
        (128, 1, 8, 1, '비교/데이터분석형', '빅데이터 분석에서 상관관계(Correlation)와 인과관계(Causality)의 차이점 및 허위 상관(교란변수)·인과추론 기법',
         ['1. 두 변수의 동반 변화 경향성(상관계수 r)과 원인이 결과를 발생시키는 인과성(반사실적 프레임워크) 비교', '2. 교란변수(Confounder)에 의한 허위 상관 통제를 위한 무작위 대조 실험(RCT/A-B 테스트), 성향점수매칭(PSM), 이중차분법(DID)']),
        (127, 1, 5, 3, '비교/암호무결성형', '메시지 무결성 및 송신자 인증을 위한 MAC(Message Authentication Code), HMAC과 전자서명(Digital Signature) 비교',
         ['1. 대칭키(공유 비밀키) 기반 메시지 인증 코드(MAC/HMAC)의 동작 원리', '2. 제3자 검증 및 부인방지(Non-repudiation) 기능 유무 관점에서의 HMAC vs 공개키 전자서명 비교']),
        (127, 1, 7, 2, '비교/테스트품질형', '소프트웨어 테스트에서 구문(Statement), 분기(Branch/Decision), 조건(Condition), MC/DC 코드 커버리지 비교',
         ['1. 화이트박스 구조 기반 커버리지의 강도 계층(구문 < 분기/결정 < 조건/결정 < 변경조건/결정 MC/DC)', '2. 항공(DO-178C)·자동차(ISO 26262 ASIL-D) 고신뢰 안전 필수 시스템에서의 MC/DC 커버리지 의무화 이유']),
    ]
    for r_id, p_id, q_no, d_id, fmt, hdr, prompts in EXTRA_TOPICS:
        RAW_QUESTIONS.append((
            r_id, p_id, q_no, d_id, fmt, hdr, prompts,
            ['1. 리드문: 핵심 개념 정의 및 출제 배경', '2. 아키텍처 및 동작 메커니즘 개념도', '3. 핵심 요소 및 대안 기술 비교표', '4. 실무 적용 고려사항 및 기술사적 제언'],
            hdr.split('(')[0].strip() + ', 메커니즘, 비교분석, 트레이드오프, 실무거버넌스',
            ['비교/구분 항목', '핵심 원리 및 구성요소', '실무 적용 및 검증 기준'],
            [[prompts[0], '표준 메커니즘 및 핵심 구조 정의', '정합성·성능·보안 요구사항 검증'],
             [prompts[1] if len(prompts) > 1 else '실무 고도화 방안', '대안 기법과의 정량·정성적 트레이드오프 비교', '엔터프라이즈 운영 거버넌스 확립']],
            f"{hdr} 토픽은 정보관리기술사 핵심 기출 문항으로, (1) 정의와 필요성을 리드문으로 선언하고, (2) 메커니즘 구조도를 도식화한 뒤, (3) {prompts[0]} 및 {prompts[1] if len(prompts) > 1 else '핵심 기술 요소'}를 대조표로 구조화하고, (4) 실무 적용 시 한계점과 극복 제언을 제시해야 한다.",
            f"제{r_id}회 주요 기출 및 도메인 순환 출제 토픽"
        ))

    # Deduplicate by (round_id, period_id, question_header) and sort
    dedup_map = {}
    for q in RAW_QUESTIONS:
        key = (q[0], q[1], q[5])
        if key not in dedup_map:
            dedup_map[key] = q
    sorted_qs = sorted(dedup_map.values(), key=lambda x: (-x[0], x[1], x[2]))
    question_records = []
    for idx, q in enumerate(sorted_qs, start=1):
        r_id, p_id, q_no, d_id, fmt, hdr, prompts, outline, kw, c_hdr, c_rows, ans, esc = q
        comp_obj = {'headers': c_hdr, 'rows': c_rows}
        cur.execute("""
            INSERT INTO questions (
                question_id, round_id, period_id, question_no, domain_id,
                question_format, question_header, sub_prompts_json,
                standard_outline_json, core_keywords, comparison_table_json,
                model_answer_text, escalation_note
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            idx, r_id, p_id, q_no, d_id, fmt, hdr,
            json.dumps(prompts, ensure_ascii=False),
            json.dumps(outline, ensure_ascii=False),
            kw,
            json.dumps(comp_obj, ensure_ascii=False),
            ans, esc
        ))
        round_map = {r[0]: r for r in EXAM_ROUNDS}
        period_map = {p[0]: p for p in CATEGORIES_PERIOD}
        domain_map = {d[0]: d for d in CATEGORIES_DOMAIN}
        question_records.append({
            'question_id': idx,
            'round_id': r_id,
            'round_title': round_map[r_id][1],
            'exam_year': round_map[r_id][2],
            'period_id': p_id,
            'period_name': period_map[p_id][2],
            'point_value': period_map[p_id][3],
            'recommended_minutes': period_map[p_id][4],
            'domain_id': d_id,
            'domain_code': domain_map[d_id][1],
            'domain_name': domain_map[d_id][2],
            'question_no': q_no,
            'question_format': fmt,
            'question_header': hdr,
            'sub_prompts': prompts,
            'standard_outline': outline,
            'core_keywords': kw,
            'comparison_table': comp_obj,
            'model_answer_text': ans,
            'escalation_note': esc
        })

    # Analytics per domain
    total_q = len(question_records)
    rising_kw_map = {
        1: 'Physical AI, Advanced/Modular RAG, RAFT, PagedAttention, MoE, 잭나이프',
        2: 'ATAM, ISO/IEC 25010(Safety), 무중단 배포(Canary), 맥케이브 복잡도, 플랫폼 엔지니어링',
        3: '비인간 신원(NHI), CTEM, 국가망보안체계(N2SF), MCP 보안, 프롬프트 인젝션, PET/동형암호',
        4: '하이브리드 검색(BM25+Vector), HNSW/IVF, 데이터 관측가능성, 분산DB 투명성, 제4정규형/반정규화',
        5: '6G AI-Native Network, Wi-Fi 7(MLO), 차등 맨체스터 부호화, SASE/SSE, FinOps/서버리스',
        6: '좀비 프로세스, GPU vs TPU(Systolic Array), CXL(메모리 풀링), 양자머신러닝(QML), eBPF',
        7: 'AI-BPR, 다크 팩토리, PMC vs PMO vs 감리, ISP vs ISMP, WBS/EVM, FP 대가산정',
        8: '인공지능기본법(고영향 AI), NIST AI RMF, ISO/IEC 42001, 개인정보/데이터 안심구역, ISMS-P'
    }
    analytics_records = []
    for d_id, d_code, d_name, d_desc in CATEGORIES_DOMAIN:
        d_qs = [q for q in question_records if q['domain_id'] == d_id]
        cnt = len(d_qs)
        share = round((cnt / total_q) * 100, 1) if total_q else 0.0
        p1_cnt = sum(1 for q in d_qs if q['period_id'] == 1)
        p234_cnt = cnt - p1_cnt
        rounds_seen = sorted(list({q['round_id'] for q in d_qs}))
        r_app = len(rounds_seen)
        if len(rounds_seen) > 1:
            intervals = [rounds_seen[i+1] - rounds_seen[i] for i in range(len(rounds_seen)-1)]
            avg_int = round(sum(intervals) / len(intervals), 2)
        else:
            avg_int = 1.5
        last_r = max(rounds_seen) if rounds_seen else 140
        since_last = 140 - last_r
        imm = round((since_last + 1) / avg_int, 2) if avg_int > 0 else 1.0
        fmt_counter = Counter(q['question_format'] for q in d_qs)
        prim_fmt = fmt_counter.most_common(1)[0][0] if fmt_counter else '개념/아키텍처형'
        row = {
            'domain_id': d_id,
            'domain_code': d_code,
            'domain_name': d_name,
            'description': d_desc,
            'total_questions': cnt,
            'share_pct': share,
            'p1_count': p1_cnt,
            'p234_count': p234_cnt,
            'round_appearances': r_app,
            'avg_interval': avg_int,
            'last_seen_round': last_r,
            'rounds_since_last': since_last,
            'imminence_index': imm,
            'primary_format': prim_fmt,
            'rising_keywords': rising_kw_map[d_id]
        }
        analytics_records.append(row)
        cur.execute("""
            INSERT INTO domain_analytics VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            d_id, d_code, d_name, cnt, share, p1_cnt, p234_cnt,
            r_app, avg_int, last_r, since_last, imm, prim_fmt, rising_kw_map[d_id]
        ))

    predicted_records = []
    for p in PREDICTED_TOPICS:
        pred_id, t_per, d_name, fmt, badge, basis, hdr, outline, kw, c_hdr, c_rows, ans = p
        comp_obj = {'headers': c_hdr, 'rows': c_rows}
        cur.execute("""
            INSERT INTO predicted_topics VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            pred_id, t_per, d_name, fmt, badge, basis, hdr,
            json.dumps(outline, ensure_ascii=False),
            kw,
            json.dumps(comp_obj, ensure_ascii=False),
            ans
        ))
        predicted_records.append({
            'pred_id': pred_id,
            'target_period': t_per,
            'domain_name': d_name,
            'question_format': fmt,
            'imminence_badge': badge,
            'basis': basis,
            'question_header': hdr,
            'standard_outline': outline,
            'core_keywords': kw,
            'comparison_table': comp_obj,
            'model_answer_text': ans
        })

    conn.commit()
    with open(SQL_DUMP_PATH, 'w', encoding='utf-8') as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")
    conn.close()

    export_data = {
        'exam_rounds': [
            {
                'round_id': r[0], 'round_title': r[1], 'exam_year': r[2],
                'exam_date': r[3], 'source_url': r[4], 'trend_summary': r[5]
            } for r in sorted(EXAM_ROUNDS, key=lambda x: -x[0])
        ],
        'categories_period': [
            {
                'period_id': p[0], 'period_code': p[1], 'period_name': p[2],
                'point_value': p[3], 'recommended_minutes': p[4], 'description': p[5]
            } for p in CATEGORIES_PERIOD
        ],
        'categories_domain': [
            {
                'domain_id': d[0], 'domain_code': d[1], 'domain_name': d[2], 'description': d[3]
            } for d in CATEGORIES_DOMAIN
        ],
        'domain_analytics': analytics_records,
        'questions': question_records,
        'predicted_topics': predicted_records
    }
    with open(JSON_EXPORT_PATH, 'w', encoding='utf-8') as f:
        json.dump(export_data, f, ensure_ascii=False, indent=2)

    print(f"[ITPE RDB] Built {len(EXAM_ROUNDS)} rounds, {len(question_records)} curated subnote questions, {len(predicted_records)} predicted topics.")

if __name__ == '__main__':
    build_database()
