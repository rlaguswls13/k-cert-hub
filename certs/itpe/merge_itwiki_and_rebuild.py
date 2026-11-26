import os
import re
import json
import time
import sqlite3
import argparse
import html as html_lib
import urllib.parse
from collections import Counter
from difflib import SequenceMatcher
from html.parser import HTMLParser

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(PROJECT_DIR, 'data')
CURATED_PATH = os.path.join(DATA_DIR, 'curated_subnotes_102.json')
PUBLISHED_PATH = os.path.join(DATA_DIR, 'published_questions_120_140.json')
DB_PATH = os.path.join(DATA_DIR, 'itpe_exam.db')
SQL_DUMP_PATH = os.path.join(DATA_DIR, 'schema_and_data.sql')
JSON_EXPORT_PATH = os.path.join(DATA_DIR, 'itpe_rdb_export.json')

# Verified matches between curated (round_id, period_id, q_no) and official Q-Net/ITwiki q_no
EXPLICIT_MATCH_PAIRS = {
    (139, 2, 1): 2,   # RLHF vs RAFT
    (138, 2, 2): 2,   # ISP & ISMP
    (138, 2, 6): 6,   # 4 memory areas
    (138, 4, 2): 6,   # PET
    (138, 4, 4): 5,   # RaaS
    (133, 1, 4): 4,   # 전자봉투
    (128, 1, 5): 5,   # 품질비용
    (128, 1, 6): 6,   # NoSQL
    (127, 1, 7): 7,   # 테스트/코드 커버리지
}

# Weighted regex classification across the 8 ITPE domains
# Note: use (?<![a-z0-9])...(?![a-z0-9]) instead of \b because Korean Hangul chars are \w in Python re.
B_L = r'(?<![a-z0-9])'
B_R = r'(?![a-z0-9])'

DOMAIN_REGEX_RULES = {
    8: [  # LAW_GOV: IT 법제도 · AI거버넌스 · 공공정책
        (r'인공지능\s*기본법|인공지능\s*발전과\s*신뢰|고영향\s*인공지능|지능정보화\s*기본법|데이터\s*산업법|데이터\s*산업진흥', 18),
        (r'이용자\s*보호\s*가이드라인|개인정보\s*보호법|개인정보보호법|전자정부법|소프트웨어\s*산업\s*진흥법|소프트웨어\s*진흥법|소프트웨어진흥법|정보통신망법|전자서명법|데이터\s*3법', 16),
        (r'안전성\s*확보조치\s*기준|자율점검표|내부관리계획|비식별조치\s*가이드라인|데이터\s*안심구역|개인정보\s*안심구역|데이터\s*주권', 15),
        (r'공인인증서|사설인증서|국가인공지능전략위원회|망중립성|디지털세|정보윤리|ai\s*윤리|인공지능\s*윤리', 14),
        (r'공공\s*sla|공공부문|공공소프트웨어|공공\s*소프트웨어|디지털\s*정부서비스|디지털\s*뉴딜|정보시스템\s*등급제|전자정부\s*평가', 13),
        (r'ai\s*거버넌스|신뢰성\s*검인증|인공지능\s*신뢰성|it\s*거버넌스|디지털\s*역기능|정보보호\s*관리체계|정보보호\s*컴플라이언스', 13),
        (r'오픈소스\s*라이선스|허용적\s*라이선스|카피레프트|sspl|bsl|copyleft|permissive\s*license|오픈소스의\s*개념', 14),
        (r'조달청|협상에\s*의한\s*계약|제안서\s*평가|전문평가제도|단계별\s*발주|분할\s*발주|하도급\s*구조|과업\s*변경', 14),
        (r'정보기술자\s*등급제|it직무제|sw\s*대가산정|소프트웨어\s*사업\s*대가산정|운영단계\s*대가산정|규모\s*산정\s*방식', 13),
        (r'법적\s*이슈|법제도|레그테크|regtech|esg|보안인증제도|csap|iso\s*14000|모바일\s*신분증|전자문서증명서|디지털교과서|디지털\s*교과서', 12),
        (rf'{B_L}isms(?:-p)?{B_R}|{B_L}ciso{B_R}|{B_L}cbpr{B_R}|{B_L}fips{B_R}|{B_L}gadi{B_R}', 12),
    ],
    3: [  # SEC: 정보보안 · 암호 · 개인정보보호
        (r'제로\s*트러스트|zero\s*trust|랜섬웨어|raas|인포스틸러|infostealer|bpfdoor|백도어|악성코드|큐싱|qshing', 16),
        (r'포렌식|안티포렌식|침해사고|공격\s*표면|공격\s*벡터|측면\s*이동|크리덴셜\s*스터핑|적대적\s*공격|네트워크\s*스캐닝|emp공격', 15),
        (r'동형\s*암호|양자\s*암호|양자암호|양자키분배|양자내성암호|대칭\s*암호|비대칭\s*암호|블록\s*암호|암호문\s*공격', 15),
        (r'해시\s*함수|해쉬\s*알고리즘|단방향\s*해시|rainbow\s*table|키스트레칭|해시\s*솔트|rsa.*dsa|타원곡선\s*암호', 15),
        (r'전자봉투|전자서명|바이오정보|생체인증|무자각\s*지속\s*인증|접근\s*제어|접근제어|접근\s*통제|사용자\s*인증\s*요소|식별.*인증|변조.*위조', 14),
        (rf'{B_L}(?:pqc|qkd|tls|ssl|ipsec|vpn|ids|ips|owasp|sbom|pbd|pet|mpc|cdr|siem|soar|kyc|nac|ldap|did|secaas|jwt|ctem|tpm){B_R}', 14),
        (r'시큐어\s*코딩|secure\s*sdlc|devsecops|공급망\s*보안|보안\s*위험|보안위협|보안\s*대책|보안\s*취약점|보안\s*요소|보안\s*체계|보안\s*부서|웹\s*방화벽|침입탐지|침입방지', 14),
        (r'privacy\s*by\s*design|privacy\s*enhancing\s*technology|차분\s*프라이버시|다자간\s*계산|가명처리|가명·익명|익명처리|비식별|common\s*criteria|iso/iec\s*27017|신속\s*확인제도|안면인식\s*결제', 14),
        (r'딥페이크|deepfake|ai\s*보안|llm.*보안|인젝션|모델\s*전도\s*공격|파일\s*슬랙|분산\s*id|jason\s*web\s*token|블록체인|consensus\s*algorithm', 13),
        (r'위험분석|정량적\s*위험|보안|암호|프라이버시', 6),
    ],
    4: [  # DB: 데이터베이스 · 데이터모델링 · 분산데이터
        (rf'데이터베이스|{B_L}(?:dbms|rdbms|nosql|sql|ddl|erd|ldw|da|dba|imdf|pacelc|cap){B_R}|text2sql', 15),
        (r'정규화|반정규화|제4정규형|제5정규형|이상현상|anomaly|함수\s*종속|무결성\s*제약|참조무결성|데이터\s*무결성', 16),
        (r'트랜잭션|격리\s*수준|격리수준|병행\s*제어|병행수행|팬텀충돌|동시성\s*제어', 15),
        (r'인덱스|다차원\s*색인|확장성\s*해싱|extendible\s*hashing|클러스터드\s*인덱스|mongodb|column\s*family', 15),
        (r'데이터\s*모델링|데이터\s*관계\s*모델링|바커|관계형\s*데이터|스타\s*스키마|crud\s*매트릭스|식별.*비식별', 15),
        (r'데이터\s*웨어하우스|데이터웨어하우스|데이터\s*레이크|data\s*lake|데이터\s*늪|data\s*swamp|데이터\s*복제|데이터를\s*복제|데이터\s*통합|마이그레이션', 14),
        (r'데이터\s*분할|수평분할|수직분할|벡터\s*데이터베이스|vector\s*database|공간\s*db|공간\s*연산자|ogc', 15),
        (r'데이터\s*거버넌스|데이터\s*표준화|데이터\s*품질|정보\s*생명주기|linked\s*open\s*data|(?<![a-z])lod(?![a-z])|데이터\s*관측', 13),
    ],
    1: [  # AI_DATA: 인공지능 · 빅데이터 · 통계
        (r'머신\s*러닝|머신러닝|기계학습|딥\s*러닝|딥러닝|인공신경망|신경망|역전파|활성화\s*함수|피드포워드|모델옵스|modelops', 15),
        (rf'{B_L}(?:llm|plm|rag|mas|vae|gan|svm|gnn|som|agi|ani|moe){B_R}|거대\s*언어|대형언어모델|언어모델|프롬프트\s*엔지니어링|하네스\s*엔지니어링|파인튜닝|다중\s*에이전트|초거대\s*ai', 15),
        (r'multimodal|멀티모달|앙상블|서포트\s*벡터|유전\s*알고리즘|메타휴리스틱|강화학습|그래프신경망|연합학습|온디바이스\s*ai|k-means|dbscan', 15),
        (r'efficientnet|efficientdet|snn|spiking\s*neural|뉴로모픽|의사결정나무|지니\s*지수|엔트로피\s*지수|tf-idf|형태소\s*분석|베이즈|베이지안', 15),
        (r'군집|클러스터링|연관\s*규칙|데이터\s*마이닝|데이터마이닝|오피니언\s*마이닝|텍스트\s*마이닝|임베딩|자연어\s*처리', 14),
        (r'이항\s*분포|포아송\s*분포|정규분포|베르누이\s*분포|기하\s*분포|중심극한정리|t-검정|z-검정|가설\s*검정|기술통계|추론통계|다변량|주성분|다차원척도', 16),
        (r'불편추정량|불편\s*추정량|점추정|구간추정|타당도.*신뢰도|실루엣\s*계수|혼동행렬|f1-score|다중공선성|등분산성|회귀분석|회귀모형|표본추출', 15),
        (r'아웃라이어|outlier|이상치|편향|bias|과적합|과소적합|차원\s*축소|a/b\s*테스팅|어노테이션|합성데이터|학습용\s*데이터|데이터\s*시각화|pr.*roc', 13),
        (r'터보퀀트|turboquant|양자화|텐서플로|하이퍼파라미터|술어\s*논리|시계열\s*딥러닝|시계열\s*데이터|딥뷰|deepview|데이터옵스|dataops|워크플로우.*백필|빅데이터', 13),
        (r'정보이론|샤논|인공지능|(?<![a-z])ai(?![a-z])', 5),
    ],
    2: [  # SW_ARCH: 소프트웨어공학 · 아키텍처 · 테스트
        (r'소프트웨어\s*테스트|블랙박스|화이트박스|통합테스트|커버리지|동등\s*분할|경계값|회귀\s*테스트|몽키\s*테스트|카오스\s*테스트|뮤테이션|동적\s*테스트|메타모픽|인스펙션', 16),
        (r'결합도|응집도|정보은닉|캡슐화|객체지향|디자인\s*패턴|디자인패턴|프록시|의존성\s*주입|의존성\s*역전|리팩토링|aop|스프링\s*부트|spring\s*boot', 15),
        (r'기술\s*부채|기술부채|코드스멜|유지보수|3r|역공학|재공학|형상관리|요구공학|요구사항|유즈케이스|유스케이스|use\s*case|좋은\s*소프트웨어|안전성\s*진단', 15),
        (rf'{B_L}(?:uml|gof|eda|devops|ci/cd|alm|srgm|oas|rest|soap|awt|swing|atam|cbam|mcp){B_R}|다이어그램|클래스\s*다이어그램|활동다이어그램|상태\s*다이어그램|아키텍처\s*스타일|소프트웨어\s*아키텍처', 15),
        (r'모놀리스|마이크로서비스|event\s*driven|데브옵스|애자일|agile|폭포수|스크럼|scrum|칸반|제품계열|product\s*line|무중단\s*배포|배포\s*전략|테일러링|순환복잡도', 14),
        (r'품질보증|사용성\s*평가|신뢰성\s*성장\s*모델|ui/ux|반응형\s*웹|서비스\s*워커|스프라이트|슈퍼앱|다크패턴|메타버스|가상융합|웹\s*성능|웹기반서비스.*성능|프론트-엔드', 13),
        (r'오픈\s*api|개방형\s*api|api\s*gateway|스크래핑|웹크롤링|웹3\.0|파이썬|자바|정규\s*표현식|유한오토마타|o-notation|알고리즘의\s*복잡도', 13),
        (r'데이터\s*구조|자료\s*구조|자료구조|스택\(stack\)|선형\s*자료|비선형\s*자료|큐\(queue\)|정렬\s*알고리즘|이진\s*탐색\s*트리|트리정렬|방향성\s*비순환\s*그래프|최단경로', 14),
        (r'소프트웨어\s*품질|품질비용|코드형\s*인프라|가상물리시스템|소프트웨어\s*공학|25010', 12),
    ],
    5: [  # NW_CLOUD: 네트워크 · 클라우드 · 차세대통신
        (r'라우팅|거리\s*벡터|링크\s*상태|소켓\s*통신|슬라이딩윈도우|혼잡제어|오류\s*제어|통신\s*프로토콜|무선\s*통신|해저케이블|차량·사물|vehicle\s*to\s*everything', 15),
        (rf'{B_L}(?:ospf|rip|bgp|tcp|sctp|arq|csma|cdma|tdma|vlan|vpn|nfv|sdn|vlsm|wfq|noma|fso|sdr|qos|diffserv|intserv|webrtc|vxlan|ibn|modbus){B_R}', 15),
        (r'osi\s*7|프레임릴레이|서브네팅|슈퍼네팅|웨이티드\s*페어큐잉|5g|6g|wi-fi|802\.11|nfc|c-v2x|이동통신|맨체스터', 15),
        (r'멀티클라우드|서버리스|serverless|클라우드\s*컴퓨팅|클라우드\s*네이티브|클라우드\s*관리\s*플랫폼|클라우드\s*아웃소싱|daas', 14),
        (rf'{B_L}(?:baas|faas|iaas|paas|saas|hpa|fts|drs|bcp|dci|das|nas|san){B_R}', 14),
        (r'쿠버네티스|kubernetes|컨테이너|가상머신|도커|오토\s*스케일링|메시지큐잉|대기행렬|부하\s*분산', 14),
        (r'고가용성|재해복구|active-active|active-passive|pilot\s*light|데이터센터|데이터\s*센터|스토리지\s*가상화|블록\s*스토리지|파일\s*스토리지|오브젝트\s*스토리지|하이퍼바이저|원격\s*데스크톱', 14),
    ],
    6: [  # CA_OS: 컴퓨터구조 · 운영체제 · 양자컴퓨팅
        (r'운영체제|리눅스\s*커널|프로세스\s*(?:동기화|간\s*통신|스케줄링|메모리|상태)|좀비\s*프로세스|뮤텍스|세마포어|모니터\(|모니터\b(?!링)|교착\s*상태|교착상태|은행가\s*알고리즘|race\s*condition|우선순위\s*역전', 16),
        (r'cpu\s*스케줄링|디스크\s*스케줄링|가상메모리|동적\s*메모리|메모리\s*누수|단편화|세그먼테이션|스레싱|thrashing|빅\s*엔디언|리틀\s*엔디언|인터리빙', 16),
        (rf'{B_L}(?:sjf|srt|sstf|sltf|raid|gpgpu|hbm|ipc|hci|elk|cxl){B_R}|캐시\s*메모리|캐시\s*쓰기|캐시\s*일관성|멀티\s*gpu|고대역\s*초고속\s*메모리|병렬처리\s*시스템', 15),
        (r'인터미턴트\s*컴퓨팅|응용\s*프로그램\s*가상화|메모리\s*반도체|비메모리\s*반도체|반도체\s*생태계|ai\s*슈퍼컴퓨팅|퍼듀.*모델', 14),
        (r'양자\s*컴퓨팅|양자머신러닝|큐비트|qubit', 14),
    ],
    7: [  # ITBIZ_PM: 프로젝트관리 · IT경영 · 감리 · BPR
        (r'프로젝트\s*관리|프로그램\s*관리|포트폴리오\s*관리|감리|전략적\s*기업경영|경영환경|가치사슬|기술수용모델|획득가치관리|부정적\s*위험', 15),
        (rf'{B_L}(?:pmo|isp|ismp|bpr|wbs|evm|roi|bsc|sla|itsm|swot|3c|pest|scm|erp|mes|crm|coe|mece|hazop|pop|ahp|pmc|ta와\s*aa){B_R}', 15),
        (r'규모산정|비용\s*산정|기능점수|it\s*투자|성과관리|성과측정|서비스\s*수준\s*협약|서비스수준협약|iso/iec\s*20000|iso\s*21500|iso\s*31000|균형성과기록표', 15),
        (r'리스크\s*대응|위험관리|갈등.*해결|터크만|tuckman|tam-sam-som|공급망\s*관리|공급망관리|isa-88|스마트팩토리|스마트\s*팩토리|다크\s*팩토리|디자인\s*싱킹', 15),
        (r'화이트\s*레이블|그로스\s*해킹|앰비언트\s*커머스|오픈\s*뱅킹|인슈어테크|마이데이터|pay\s*later|qr코드\s*기반의\s*결제|바코드|디파이|de-fi|대체불가능\s*토큰|데이터\s*커머스|핀테크', 14),
        (r'데이터\s*거래|데이터\s*가치평가|데이터\s*자산화|디지털\s*트랜스포메이션|디지털\s*혁신|ax\(|ai\s*전환|로우코드|노코드|운영환경\s*변환|오픈\s*가능여부|정보시스템\s*구축업체|디지털\s*휴먼|전문성의\s*민주화|디지털\s*트윈|행동인터넷|지능형\s*cctv|앰비언트\s*컴퓨팅', 13),
    ]
}

DOMAIN_META = {
    1: ('AI_DATA', '[AI/Data] 인공지능 · 빅데이터 · 통계'),
    2: ('SW_ARCH', '[SW/Arch] 소프트웨어공학 · 아키텍처 · 테스트'),
    3: ('SEC', '[Sec] 정보보안 · 암호 · 개인정보보호'),
    4: ('DB', '[DB] 데이터베이스 · 데이터모델링 · 분산데이터'),
    5: ('NW_CLOUD', '[NW/Cloud] 네트워크 · 클라우드 · 차세대통신'),
    6: ('CA_OS', '[CA/OS] 컴퓨터구조 · 운영체제 · 양자컴퓨팅'),
    7: ('ITBIZ_PM', '[ITBiz/PM] 프로젝트관리 · IT경영 · 감리 · BPR'),
    8: ('LAW_GOV', '[Law/Gov] IT 법제도 · AI거버넌스 · 공공정책'),
}


def norm(s):
    return re.sub(r'[^0-9a-z가-힣]', '', s.lower())


def tokens(s):
    return set(re.findall(r'[a-z0-9]{2,}|[가-힣]{2,}', s.lower()))


def match_curated_to_parsed(curated_list, parsed_list):
    used = set()
    for cq in curated_list:
        r_id, p_id, c_no = cq['round_id'], cq['period_id'], cq['question_no']
        if (r_id, p_id, c_no) in EXPLICIT_MATCH_PAIRS:
            used.add((r_id, p_id, EXPLICIT_MATCH_PAIRS[(r_id, p_id, c_no)]))
            continue
        c_hdr = cq['question_header']
        cands = [
            pq for pq in parsed_list
            if pq['round_id'] == r_id and pq['period_id'] == p_id
            and (r_id, p_id, pq['question_no']) not in used
        ]
        stops = {'설명하시오', '설명', '비교', '대하여', '다음', '내용을', '개념', '특징', '종류', '절차', '방안', '구분', '활용', '차이점', '문제점', '고려사항', '기반', '관점', '환경에서'}
        c_tok = tokens(c_hdr) - stops
        c_n = norm(c_hdr)
        best = None
        best_sc = 0.0
        for pq in cands:
            p_full = pq['header'] + ' ' + ' '.join(pq.get('subs', []))
            p_tok = tokens(p_full) - stops
            seq = SequenceMatcher(None, c_n, norm(pq['header'])).ratio()
            jacc = len(c_tok & p_tok) / max(1, len(c_tok | p_tok))
            ov = len(c_tok & p_tok) / max(1, min(len(c_tok), len(p_tok)))
            sc = max(seq, 0.5 * jacc + 0.5 * ov) + (0.12 if pq['question_no'] == c_no else 0.0)
            if sc > best_sc:
                best_sc = sc
                best = pq
        if best and best_sc >= 0.45:
            used.add((r_id, p_id, best['question_no']))
    return used


def classify_domain(q):
    text = (q['header'] + ' ' + ' '.join(q.get('subs', []))).lower()
    scores = {d: 0 for d in range(1, 9)}
    for d, rules in DOMAIN_REGEX_RULES.items():
        for pat, w in rules:
            if re.search(pat, text):
                scores[d] += w

    # Disambiguations for cross-domain questions
    if 'fifo' in text and ('웨이티드 페어큐잉' in text or 'wfq' in text):
        scores[5] += 20
    if '이진 탐색 트리' in text and '라우팅 테이블' in text:
        scores[5] += 18
    if '메타모픽 테스트' in text or '뉴런 커버리지' in text:
        scores[2] += 14
    if '스토리지 가상화' in text:
        scores[5] += 14
    if 'elk(' in text:
        scores[4] += 10
        scores[5] += 10
    if '인공지능' in text and ('법적' in text or '윤리' in text or '거버넌스' in text or '기본법' in text or '가이드라인' in text or '신뢰성' in text):
        scores[8] += 15
    if '데이터 거래' in text or '데이터 가치평가' in text or '데이터 자산화' in text:
        scores[7] += 12
    if 'ai' in text and ('데이터센터' in text or '데이터 센터' in text):
        scores[5] += 16
    if '공공부문' in text and ('초거대' in text or '가이드라인' in text or 'saas' in text):
        scores[8] += 14
    if '다크패턴' in text:
        scores[8] += 12
    if '정보시스템 구축업체 선정' in text or '협상에 의한 계약' in text:
        scores[8] += 14
    if '클라우드' in text and '보안' in text and ('인증' in text or '고려해야 할 보안' in text):
        scores[3] += 8
        scores[8] += 8

    best_d, best_sc = max(scores.items(), key=lambda x: (x[1], -x[0]))
    if best_sc == 0:
        return 8 if q['period_id'] == 4 else 2, 0
    return best_d, best_sc


def classify_format(q):
    full = (q['header'] + ' ' + ' '.join(q.get('subs', []))).lower()
    if any(k in full for k in ['비교', '차이점', '차이', '대조']) or re.search(r'[a-z0-9가-힣]+\s*과\s*[a-z0-9가-힣]+\s*(?:비교|차이)', full):
        return '비교/대조분석형'
    if any(k in full for k in ['법', '가이드라인', '제도', '윤리', '거버넌스', '컴플라이언스', '인증제도', '계약']):
        return '법제도/거버넌스형'
    if any(k in full for k in ['보안', '위협', '취약점', '공격', '장애', '대응', '방지', '해결', '원인']):
        return '원인분석/대응전략형'
    if any(k in full for k in ['절차', '단계', '작성', '계산', '구현', '설계', '다이어그램', 'erd', 'sql', 'ddl', '테스트 케이스']):
        return '절차/설계구현형'
    if any(k in full for k in ['사례', '전환', '도입', '적용 방안', '구축']):
        return '실무/시나리오형'
    return '개념/정의형'


def extract_topic_title(header, subs):
    h = header.strip()
    if len(h) < 30 and ('다음' in h) and subs:
        s0 = re.sub(r'^[가나다라마1-9]\.\s*', '', subs[0]).strip()
        s0 = re.sub(r'\s*(?:의 개념.*|에 대하여.*)$', '', s0).strip()
        if s0:
            return f"{s0} ({h.rstrip('.')})"
    # If multi-sentence scenario, pick the sentence asking the core subject
    sents = [s.strip() for s in re.split(r'\.\s+', h) if s.strip()]
    target = h
    if len(sents) >= 2:
        # Look for sentence before "다음을 설명하시오" or sentence containing "에 대하여" / "대해" / "비교"
        cand_sents = [s for s in sents if not re.match(r'^(?:다음을|다음\s*내용을|각\s*항목을)\s*(?:설명|작성|답)하시오', s)]
        for s in reversed(cand_sents):
            if any(k in s for k in ['에 대하여', '에 대해', '과 관련하여', '와 관련하여', '비교', '설명하시오']):
                target = s
                break
        else:
            target = cand_sents[-1] if cand_sents else sents[0]
    topic = re.sub(r'\s*(?:와 관련하여|에 대하여|에 대해|과 관련하여)?\s*다음(?:의|을| 내용(?:을|에 대하여)| 각 항목을)?\s*(?:설명|작성|비교|답)하시오\.?$', '', target)
    topic = re.sub(r'\s*(?:를|을)?\s*(?:각각\s*)?(?:비교하여\s*|비교\s*)?설명하시오\.?$', '', topic).strip()
    topic = re.sub(r'^.*?(?:따라|대두되고 있다\.|증가하고 있다\.|진행되고 있다\.)\s*', '', topic).strip()
    if len(topic) > 75:
        # Trim leading background clause up to comma if still very long
        m_tail = re.search(r',\s*([^,]{8,70})$', topic)
        if m_tail:
            topic = m_tail.group(1).strip()
    return topic if len(topic) >= 3 else h


def extract_keywords(header, subs, domain_id):
    full = header + ' ' + ' '.join(subs)
    found = []
    seen = set()

    # 1. Acronyms & parenthetical English terms
    for m in re.findall(r'([A-Za-z][A-Za-z0-9/\- &]{1,36})', full):
        t = re.sub(r'\s+', ' ', m).strip(' .,-/')
        if len(t) >= 2 and t.lower() not in {'or', 'and', 'the', 'for', 'of', 'in', 'to', 'by', 'as', 'is', 'vs'} and t.lower() not in seen:
            seen.add(t.lower())
            found.append(t)

    # 2. Meaningful Korean compound noun phrases (2~12 chars) from original header & original subs only
    stop_kr = {
        '대하여', '관련하여', '설명하시오', '작성하시오', '답하시오', '다음을', '다음의', '다음에', '다음',
        '각각', '개념', '특징', '종류', '필요성', '정의', '구성요소', '절차', '방안', '방법', '비교',
        '고려사항', '기대효과', '장단점', '차이점', '문제점', '활용', '기능', '유형', '목적', '원리',
        '역할', '구조', '기법', '측면', '관점', '구분', '시사점', '내용을', '내용', '항목을', '기업은',
        '기업', '기관', '최근', '사례', '전망', '현황', '동향', '이유', '배경', '요소', '가지', '이상',
        '핵심', '주요', '기반', '통한', '대한', '위한', '따른', '있다', '있는', '경우', '발생', '원인',
        '대책', '해결', '해결방안', '적용', '도입', '구축', '제시', '기준', '방식', '영향', '중요성'
    }
    for w in re.findall(r'[가-힣]{2,12}', full):
        w_clean = re.sub(r'(?:에서|으로|부터|까지|에|의|을|를|이|가|은|는|와|과|로|도)$', '', w)
        if len(w_clean) >= 2 and w_clean not in stop_kr and w_clean not in seen:
            seen.add(w_clean)
            found.append(w_clean)

    # 3. Domain core filler keywords if fewer than 5
    domain_defaults = {
        1: ['아키텍처', '성능지표', '학습·추론 최적화', '신뢰성'],
        2: ['품질속성', '유지보수성', '설계원칙', '검증전략'],
        3: ['기밀성·무결성', '보안통제', '위협모델링', '대응아키텍처'],
        4: ['데이터 정합성', '성능·확장성', '인덱싱/분할', '무결성'],
        5: ['프로토콜 스택', '대역폭·지연시간', '고가용성', '트래픽 제어'],
        6: ['자원스케줄링', '메모리 계층', '동기화·일관성', '성능병목'],
        7: ['거버넌스', 'ROI·성과지표', '리스크 관리', '이해관계자 정렬'],
        8: ['법적 근거', '컴플라이언스', '관리체계', '공공정책'],
    }
    for dkw in domain_defaults[domain_id]:
        if len(found) >= 7:
            break
        if dkw.lower() not in seen:
            seen.add(dkw.lower())
            found.append(dkw)
    return ', '.join(found[:8])


def split_compared_entities(topic):
    clean = re.sub(r'\s*(?:비교|차이점|차이|의 비교).*$', '', topic).strip()
    if ',' in clean and len(clean.split(',')) >= 2:
        parts = [p.strip() for p in clean.split(',') if p.strip()]
        if len(parts) <= 4:
            return parts
    m = re.split(r'\s*(?:와|과)\s+', clean)
    if len(m) == 2 and all(len(x) >= 2 for x in m):
        return m
    return []


def enrich_published_question(pq):
    d_id, _ = classify_domain(pq)
    d_code, d_name = DOMAIN_META[d_id]
    fmt = classify_format(pq)
    orig_hdr = pq['header']
    subs = list(pq.get('subs', []))
    topic = extract_topic_title(orig_hdr, subs)

    if len(orig_hdr) < 30 and '다음' in orig_hdr and subs:
        disp_hdr = topic
    else:
        disp_hdr = orig_hdr

    # Extract keywords strictly from original wording before synthetic sub_prompts
    keywords = extract_keywords(orig_hdr, subs, d_id)

    if subs:
        final_subs = subs
    else:
        if fmt == '비교/대조분석형':
            final_subs = [
                f"1. {topic}의 핵심 개념 정의 및 등장 배경",
                f"2. 주요 구성요소·동작 메커니즘 및 비교 기준별 차이점",
                f"3. 실무 적용 시 트레이드오프 및 선정·고도화 고려사항"
            ]
        elif fmt == '원인분석/대응전략형':
            final_subs = [
                f"1. {topic}의 개념 및 발생 원인·위협 메커니즘",
                f"2. 기술적·관리적 대응 방안 및 아키텍처 통제 전략"
            ]
        elif fmt == '절차/설계구현형':
            final_subs = [
                f"1. {topic}의 정의 및 핵심 원리",
                f"2. 단계별 수행 절차·구현 메커니즘 및 실무 검증 기준"
            ]
        else:
            final_subs = [
                f"1. {topic}의 개념 정의 및 필요성",
                f"2. 핵심 구성요소·동작 원리 및 실무 활용 방안"
            ]

    # Build clean 4-dan standard outline without mid-word truncation
    if subs:
        sub_labels = [re.sub(r'^[가나다라마1-9]\.\s*', '', s).strip() for s in subs[:2]]
        sub_hint = ' 및 '.join(lbl[:38].rstrip(' ,·(') for lbl in sub_labels)
    else:
        sub_hint = f"{topic} 핵심 메커니즘·비교 기준"

    domain_tag = d_name.split(']')[0].strip('[')
    standard_outline = [
        f"1. 리드문: {topic}의 핵심 정의 및 출제·도입 배경",
        f"2. 구조·원리: {topic} 아키텍처 개념도 및 동작 메커니즘",
        f"3. 핵심 논점: {sub_hint} 정밀 분석 및 비교표",
        f"4. 제언·고려사항: 실무 적용 한계 극복 및 {domain_tag} 거버넌스 제언"
    ]

    entities = split_compared_entities(topic) if fmt == '비교/대조분석형' else []
    if len(entities) >= 2 and len(entities) <= 3:
        comp_headers = ['비교 항목'] + [e[:36] for e in entities]
        comp_rows = [
            ['핵심 개념·목적'] + [f"{e[:24]}의 고유 목적 및 적용 영역 정의" for e in entities],
            ['동작 원리·구조'] + ['핵심 메커니즘·프로토콜 및 구성요소' for _ in entities],
            ['장단점 및 선택 기준'] + ['성능·보안·비용 트레이드오프 기반 실무 적용성' for _ in entities],
        ]
    elif subs:
        comp_headers = ['출제 세부 항목', '핵심 서술 키워드 및 원리', '기술사 답안 가산점 포인트']
        comp_rows = []
        for s in subs[:4]:
            s_clean = s[:75]
            s_kw = extract_keywords(s, [], d_id)
            first_kw = s_kw.split(',')[0].strip()
            comp_rows.append([
                s_clean,
                f"{first_kw} 중심 메커니즘·절차 구조화",
                '개념도/흐름도 도식화 및 정량·정성 비교 근거 제시'
            ])
    else:
        comp_headers = ['4단 답안 구성', '핵심 작성 내용', '채점 강조 포인트']
        comp_rows = [
            ['1단: 정의 및 배경', f"{topic}의 두괄식 정의와 기술적·비즈니스 등장 배경", '핵심 키워드 2~3개 포함 3~4줄 리드문 압축'],
            ['2단: 구조 및 메커니즘', f"{topic}의 구성요소·처리 흐름 개념도 및 핵심 원리", '블록 다이어그램·순서도 시각화'],
            ['3단: 비교 및 실무 적용', f"{topic}의 주요 특징, 대안 기술 비교 및 실무 구현 방안", '비교 매트릭스·수치/표준 규격 명시'],
            ['4단: 한계 및 제언', f"{topic} 도입 시 제약사항·보안/성능 리스크 및 해결 방안", '현업 아키텍처 개선 및 거버넌스 통찰'],
        ]

    sub_summary = ' · '.join(re.sub(r'^[가나다라마1-9]\.\s*', '', s) for s in final_subs[:3])
    top_kws = ', '.join(k.strip() for k in keywords.split(',')[:4] if k.strip())
    model_answer_text = (
        f"본 문항은 제{pq['round_id']}회 {pq['period_id']}교시 {pq['question_no']}번({d_name}) 실제 기출 토픽으로, "
        f"'{topic}'의 핵심 개념과 실무 적용성을 묻는다. "
        f"답안 서술 시 (1) 두괄식 리드문으로 정의·배경을 명확히 선언하고, "
        f"(2) 핵심 아키텍처 또는 처리 절차를 도해로 구조화한 뒤, "
        f"(3) 세부 요구사항({sub_summary})을 필수 키워드({top_kws})와 비교표로 논리 전개하며, "
        f"(4) 실무 적용 시 트레이드오프·보안/성능 고려사항 및 최신 표준 연계 제언으로 마무리해야 고득점이 가능하다."
    )

    escalation_note = f"제{pq['round_id']}회 {pq['period_id']}교시 #{pq['question_no']} 실제 기출 · {d_name} ({pq['source']})"

    return {
        'round_id': pq['round_id'],
        'period_id': pq['period_id'],
        'question_no': pq['question_no'],
        'domain_id': d_id,
        'domain_code': d_code,
        'domain_name': d_name,
        'question_format': fmt,
        'question_header': disp_hdr,
        'sub_prompts': final_subs,
        'standard_outline': standard_outline,
        'core_keywords': keywords,
        'comparison_table': {'headers': comp_headers, 'rows': comp_rows},
        'model_answer_text': model_answer_text,
        'escalation_note': escalation_note,
        'source': pq['source'],
    }


def rebuild_all():
    with open(CURATED_PATH, 'r', encoding='utf-8') as f:
        base = json.load(f)
    with open(PUBLISHED_PATH, 'r', encoding='utf-8') as f:
        published = json.load(f)

    curated_qs = base['questions']
    exam_rounds = base['exam_rounds']
    categories_period = base['categories_period']
    categories_domain = base['categories_domain']
    predicted_topics = base['predicted_topics']

    round_map = {r['round_id']: r for r in exam_rounds}
    period_map = {p['period_id']: p for p in categories_period}
    domain_map = {d['domain_id']: d for d in categories_domain}

    matched_pub_keys = match_curated_to_parsed(curated_qs, published)

    merged = []
    for cq in curated_qs:
        rec = dict(cq)
        rec['source'] = rec.get('source') or 'ITPE 정밀 4단 서브노트'
        merged.append(rec)

    zero_score_count = 0
    for pq in published:
        key = (pq['round_id'], pq['period_id'], pq['question_no'])
        if key in matched_pub_keys:
            continue
        d_id, sc = classify_domain(pq)
        if sc == 0:
            zero_score_count += 1
        enr = enrich_published_question(pq)
        r_meta = round_map[enr['round_id']]
        p_meta = period_map[enr['period_id']]
        d_meta = domain_map[enr['domain_id']]
        enr['round_title'] = r_meta['round_title']
        enr['exam_year'] = r_meta['exam_year']
        enr['period_name'] = p_meta['period_name']
        enr['point_value'] = p_meta['point_value']
        enr['recommended_minutes'] = p_meta['recommended_minutes']
        enr['domain_code'] = d_meta['domain_code']
        enr['domain_name'] = d_meta['domain_name']
        merged.append(enr)

    # Sort newest round first, then period 1->4, then question_no, curated first on ties
    merged.sort(key=lambda x: (-x['round_id'], x['period_id'], x['question_no'], 0 if x['source'] == 'ITPE 정밀 4단 서브노트' else 1))
    for idx, rec in enumerate(merged, start=1):
        rec['question_id'] = idx

    # Update exam_rounds with accurate per-round question_count
    round_counts = Counter(q['round_id'] for q in merged)
    updated_rounds = []
    for r in sorted(exam_rounds, key=lambda x: -x['round_id']):
        r_copy = dict(r)
        r_copy['question_count'] = round_counts[r['round_id']]
        updated_rounds.append(r_copy)

    # Recompute domain_analytics
    total_q = len(merged)
    rising_kw_map = {a['domain_id']: a['rising_keywords'] for a in base['domain_analytics']}
    analytics_records = []
    for d in categories_domain:
        d_id = d['domain_id']
        d_qs = [q for q in merged if q['domain_id'] == d_id]
        cnt = len(d_qs)
        share = round((cnt / total_q) * 100, 1) if total_q else 0.0
        p1_cnt = sum(1 for q in d_qs if q['period_id'] == 1)
        p234_cnt = cnt - p1_cnt
        rounds_seen = sorted({q['round_id'] for q in d_qs})
        r_app = len(rounds_seen)
        if len(rounds_seen) > 1:
            intervals = [rounds_seen[i+1] - rounds_seen[i] for i in range(len(rounds_seen)-1)]
            avg_int = round(sum(intervals) / len(intervals), 2)
        else:
            avg_int = 1.0
        last_r = max(rounds_seen) if rounds_seen else 140
        since_last = 140 - last_r
        imm = round((since_last + 1) / avg_int, 2) if avg_int > 0 else 1.0
        fmt_counter = Counter(q['question_format'] for q in d_qs)
        prim_fmt = fmt_counter.most_common(1)[0][0] if fmt_counter else '개념/정의형'
        analytics_records.append({
            'domain_id': d_id,
            'domain_code': d['domain_code'],
            'domain_name': d['domain_name'],
            'description': d['description'],
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
            'rising_keywords': rising_kw_map[d_id],
        })

    # Rebuild SQLite DB
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
        trend_summary TEXT NOT NULL,
        question_count INTEGER NOT NULL DEFAULT 0
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
        source TEXT NOT NULL DEFAULT 'ITPE 정밀 4단 서브노트',
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

    CREATE VIEW v_mode_exam AS
    SELECT
        q.question_id, r.round_id, r.round_title, r.exam_year,
        p.period_id, p.period_name, p.point_value, p.recommended_minutes,
        d.domain_id, d.domain_name,
        q.question_no, q.question_format, q.question_header, q.sub_prompts_json, q.source
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
        q.standard_outline_json, q.core_keywords, q.source
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
        q.model_answer_text, q.escalation_note, q.source
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_period p ON q.period_id = p.period_id
    JOIN categories_domain d ON q.domain_id = d.domain_id;
    """)

    for r in updated_rounds:
        cur.execute(
            "INSERT INTO exam_rounds VALUES (?, ?, ?, ?, ?, ?, ?)",
            (r['round_id'], r['round_title'], r['exam_year'], r['exam_date'], r['source_url'], r['trend_summary'], r['question_count'])
        )
    for p in categories_period:
        cur.execute(
            "INSERT INTO categories_period VALUES (?, ?, ?, ?, ?, ?)",
            (p['period_id'], p['period_code'], p['period_name'], p['point_value'], p['recommended_minutes'], p['description'])
        )
    for d in categories_domain:
        cur.execute(
            "INSERT INTO categories_domain VALUES (?, ?, ?, ?)",
            (d['domain_id'], d['domain_code'], d['domain_name'], d['description'])
        )
    for q in merged:
        cur.execute("""
            INSERT INTO questions (
                question_id, round_id, period_id, question_no, domain_id,
                question_format, question_header, sub_prompts_json,
                standard_outline_json, core_keywords, comparison_table_json,
                model_answer_text, escalation_note, source
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            q['question_id'], q['round_id'], q['period_id'], q['question_no'], q['domain_id'],
            q['question_format'], q['question_header'],
            json.dumps(q['sub_prompts'], ensure_ascii=False),
            json.dumps(q['standard_outline'], ensure_ascii=False),
            q['core_keywords'],
            json.dumps(q['comparison_table'], ensure_ascii=False),
            q['model_answer_text'], q['escalation_note'], q['source']
        ))
    for a in analytics_records:
        cur.execute(
            "INSERT INTO domain_analytics VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                a['domain_id'], a['domain_code'], a['domain_name'], a['total_questions'], a['share_pct'],
                a['p1_count'], a['p234_count'], a['round_appearances'], a['avg_interval'],
                a['last_seen_round'], a['rounds_since_last'], a['imminence_index'],
                a['primary_format'], a['rising_keywords']
            )
        )
    for p in predicted_topics:
        cur.execute(
            "INSERT INTO predicted_topics VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                p['pred_id'], p['target_period'], p['domain_name'], p['question_format'],
                p['imminence_badge'], p['basis'], p['question_header'],
                json.dumps(p['standard_outline'], ensure_ascii=False),
                p['core_keywords'],
                json.dumps(p['comparison_table'], ensure_ascii=False),
                p['model_answer_text']
            )
        )

    conn.commit()
    with open(SQL_DUMP_PATH, 'w', encoding='utf-8') as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")
    conn.close()

    export_data = {
        'exam_rounds': updated_rounds,
        'categories_period': categories_period,
        'categories_domain': categories_domain,
        'domain_analytics': analytics_records,
        'questions': merged,
        'predicted_topics': predicted_topics,
    }
    with open(JSON_EXPORT_PATH, 'w', encoding='utf-8') as f:
        json.dump(export_data, f, ensure_ascii=False, indent=2)

    src_cnt = Counter(q['source'] for q in merged)
    print(f"[ITPE MERGE] Built {len(updated_rounds)} rounds, {len(merged)} questions (zero_score_domain={zero_score_count}), {len(predicted_topics)} predicted topics.")
    print(f"[ITPE MERGE] Sources: {dict(src_cnt)}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Merge ITwiki / Q-Net published questions with curated 4-dan subnotes and rebuild ITPE RDB.')
    args = parser.parse_args()
    rebuild_all()
