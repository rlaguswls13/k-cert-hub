import os
import re
import json
import sqlite3
import urllib.request
from html import unescape
from collections import Counter

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
PUBLIC_DIR = os.path.join(PROJECT_DIR, 'public')
IMG_DIR = os.path.join(PUBLIC_DIR, 'images', 'questions')
DATA_DIR = os.path.join(PROJECT_DIR, 'data')
RAW_JSON_PATH = os.path.join(DATA_DIR, 'articles_raw.json')

os.makedirs(IMG_DIR, exist_ok=True)
os.makedirs(DATA_DIR, exist_ok=True)

DB_PATH = os.path.join(DATA_DIR, 'eip_exam.db')
SQL_DUMP_PATH = os.path.join(DATA_DIR, 'schema_and_data.sql')
JSON_EXPORT_PATH = os.path.join(DATA_DIR, 'eip_rdb_export.json')

with open(RAW_JSON_PATH, 'r', encoding='utf-8') as f:
    raw_articles = {a['url']: a for a in json.load(f)}

URL_ORDER = [
    (1,  '2020년 1회', 2020, 1, 'https://chobopark.tistory.com/196'),
    (2,  '2020년 2회', 2020, 2, 'https://chobopark.tistory.com/195'),
    (3,  '2020년 3회', 2020, 3, 'https://chobopark.tistory.com/194'),
    (4,  '2020년 4회', 2020, 4, 'https://chobopark.tistory.com/192'),
    (5,  '2021년 1회', 2021, 1, 'https://chobopark.tistory.com/191'),
    (6,  '2021년 2회', 2021, 2, 'https://chobopark.tistory.com/210'),
    (7,  '2021년 3회', 2021, 3, 'https://chobopark.tistory.com/217'),
    (8,  '2022년 1회', 2022, 1, 'https://chobopark.tistory.com/271'),
    (9,  '2022년 2회', 2022, 2, 'https://chobopark.tistory.com/423'),
    (10, '2022년 3회', 2022, 3, 'https://chobopark.tistory.com/424'),
    (11, '2024년 1회', 2024, 1, 'https://chobopark.tistory.com/476'),
    (12, '2024년 2회', 2024, 2, 'https://chobopark.tistory.com/483'),
    (13, '2024년 3회', 2024, 3, 'https://chobopark.tistory.com/495'),
    (14, '2025년 1회', 2025, 1, 'https://chobopark.tistory.com/540'),
    (15, '2025년 2회', 2025, 2, 'https://chobopark.tistory.com/554'),
    (16, '2025년 3회', 2025, 3, 'https://chobopark.tistory.com/558'),
    (17, '2026년 1회', 2026, 1, 'https://chobopark.tistory.com/561'),
    (18, '2026년 2회', 2026, 2, 'https://chobopark.tistory.com/562'),
]

CATEGORIES_MAJOR = [
    (1, 'THEORY', '이론 문항', '소프트웨어 공학, 데이터베이스, 네트워크, 정보보안, 운영체제 등 개념·설계·계산 문항'),
    (2, 'CODE',   '코드 문항', 'C언어, Java, Python 코드 실행 결과 도출 및 SQL 쿼리 작성·결과 도출 문항'),
]

CATEGORIES_MINOR = [
    (1,  2, 'CODE_C',      'C언어',                    '포인터, 배열, 구조체, 문자열 처리, 재귀함수, 비트연산 등 C언어 코드 실행 결과'),
    (2,  2, 'CODE_JAVA',   'Java',                     '클래스 상속, 오버라이딩(동적 바인딩), 생성자, static, 추상클래스/인터페이스 다형성'),
    (3,  2, 'CODE_SQL',    'SQL',                      'SELECT(GROUP BY, HAVING, JOIN, 서브쿼리), DDL/DML/DCL 쿼리 작성 및 결과 도출'),
    (4,  2, 'CODE_PY',     'Python',                   '리스트 슬라이싱, 딕셔너리, 집합(Set), 문자열 메서드, 람다/조건문 실행 결과'),
    (5,  1, 'TH_NET',      '네트워크/프로토콜',        'OSI 7계층, IPv4/IPv6, 서브넷팅/CIDR 계산, 라우팅(OSPF/RIP/BGP), ARP/RARP/ICMP/TCP'),
    (6,  1, 'TH_SW_GEN',   '소프트웨어 일반/신기술',   '신기술 용어, 클라우드, 빅데이터/마이닝, 회복탄력성(RTO/RPO), 아키텍처 및 일반 전산학'),
    (7,  1, 'TH_DB_REL',   '데이터베이스(관계대수/구조)','릴레이션 구성(차수/카디널리티/튜플/도메인), 키(Key)와 무결성 제약조건, 관계대수/관계해석'),
    (8,  1, 'TH_SEC',      '보안/암호학',              '대칭키/비대칭키 암호화 알고리즘, 해시, 네트워크/웹 공격기법(DoS, XSS, SQLi, 세션하이재킹), 접근통제/AAA'),
    (9,  1, 'TH_PATTERN',  '디자인 패턴',              'GoF 디자인 패턴(생성/구조/행위)의 목적 및 패턴별 특징/구현 매칭'),
    (10, 1, 'TH_TEST',     '소프트웨어 테스트/품질',   '화이트박스(구문/분기/조건 커버리지), 블랙박스(동치분할/경계값 등), 테스트 원리(살충제 패러독스), 정적/동적 테스트'),
    (11, 1, 'TH_UML',      '요구사항/UML/설계',        'UML 다이어그램(클래스/유스케이스/패키지/시퀀스/상태), 관계 표기, 럼바우 분석 기법, 요구사항 분류'),
    (12, 1, 'TH_OS_MEM',   '운영체제(스케줄링/메모리)', 'CPU 스케줄링(HRN, SJF, RR, SRT), 페이지 교체(LRU, FIFO, LFU), 교착상태(Deadlock)'),
    (13, 1, 'TH_DB_NORM',  '데이터베이스(설계/정규화)', 'DB 설계 단계(개념/논리/물리), 정규화(1NF~5NF, BCNF), 이상현상(삽입/삭제/갱신), 반정규화/인덱스'),
    (14, 1, 'TH_COUP',     '결합도/응집도',            '모듈 결합도(자-스-외-제-공-내) 및 응집도(우-논-시-절-통-순-기) 유형 판별 및 강도 순서'),
    (15, 1, 'TH_DB_TX',    '데이터베이스(트랜잭션/회복)','트랜잭션 4대 특성(ACID), 회복 기법(Redo/Undo, 즉시/지연 갱신), 병행제어/로킹'),
    (16, 1, 'TH_SW_ENG',   '소프트웨어 공학/방법론',   '애자일/XP/스크럼, 형상관리(식별/통제/감사/기록), 리팩토링, 비용산정(LoC/COCOMO), Fan-in/Fan-out'),
    (17, 1, 'TH_INTF',     '인터페이스/연계/웹기술',   'EAI/ESB 구축 유형, 웹서비스(SOAP/REST/WSDL/UDDI), 데이터 포맷(JSON/XML/AJAX)'),
    (18, 1, 'TH_OS_CLI',   '운영체제(명령어/기초)',    '유닉스/리눅스 기본 명령어(chmod, ls, pwd, cd, cp, ps, fork 등) 및 권한 설정'),
]

MINOR_NAME_TO_ID = {row[3]: row[0] for row in CATEGORIES_MINOR}
MINOR_ID_TO_MAJOR = {row[0]: row[1] for row in CATEGORIES_MINOR}

def download_image(url, qid, idx):
    clean_url = unescape(url)
    if clean_url.startswith('//'):
        clean_url = 'https:' + clean_url
    fname = f"q_{qid:03d}_{idx}.png"
    fpath = os.path.join(IMG_DIR, fname)
    web_path = f"/images/questions/{fname}"
    
    if os.path.exists(fpath) and os.path.getsize(fpath) > 100:
        return {'local': web_path, 'remote': clean_url}
    try:
        req = urllib.request.Request(clean_url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = resp.read()
            with open(fpath, 'wb') as f:
                f.write(data)
        return {'local': web_path, 'remote': clean_url}
    except Exception as e:
        print(f"Warning: Failed to download image {clean_url}: {e}")
        return {'local': clean_url, 'remote': clean_url}

def extract_colorscripter_table(cs_html):
    # Extract all white-space: pre divs in the code column
    lines = re.findall(r'<div[^>]*white-space:\s*pre[^>]*>(.*?)</div>', cs_html, re.S | re.I)
    if not lines:
        # Fallback: look at second td
        tds = re.findall(r'<td[^>]*>(.*?)</td>', cs_html, re.S | re.I)
        if len(tds) >= 2:
            lines = re.findall(r'<div[^>]*>(.*?)</div>', tds[1], re.S | re.I)
    code_lines = []
    for l in lines:
        # Strip HTML tags FIRST, then unescape entities like &lt;stdio.h&gt;
        clean_l = re.sub(r'<[^>]+>', '', l)
        clean_l = unescape(clean_l).replace('\xa0', ' ').replace('\u2003', ' ')
        code_lines.append(clean_l.rstrip())
    while code_lines and not code_lines[-1].strip():
        code_lines.pop()
    while code_lines and not code_lines[0].strip():
        code_lines.pop(0)
    return '\n'.join(code_lines)

def parse_html_segment(html_fragment, qid, is_answer=False):
    codes = []
    tables = []
    images = []
    
    # 0. Remove AdSense / script blocks
    frag = re.sub(r'<script[^>]*>.*?</script>', '', html_fragment, flags=re.S | re.I)
    frag = re.sub(r'<ins[^>]*class="adsbygoogle"[^>]*>.*?</ins>', '', frag, flags=re.S | re.I)
    frag = re.sub(r'\(adsbygoogle\s*=\s*window\.adsbygoogle\s*\|\|\s*\[\]\)\.push\(\{\}\);?', '', frag, flags=re.I)
    
    # 1. Extract images (<img src="...">)
    img_idx = 1
    def repl_img(match):
        nonlocal img_idx
        tag = match.group(0)
        m_src = re.search(r'src="([^"]+)"', tag, re.I)
        if m_src:
            src = m_src.group(1)
            if 'no-image' not in src:
                local_src = download_image(src, qid, img_idx)
                img_idx += 1
                images.append(local_src)
        return ""
    frag = re.sub(r'<figure[^>]*>.*?<img[^>]+>.*?</figure>|<img[^>]+>', repl_img, frag, flags=re.S | re.I)
    
    # 2. Extract ColorScripter tables (match <table class="colorscripter-code-table">...</table> directly!)
    def repl_cs(match):
        c = extract_colorscripter_table(match.group(0))
        if c:
            codes.append(c)
        return "\n"
    frag = re.sub(r'<table[^>]*class="[^"]*colorscripter-code-table[^"]*"[^>]*>.*?</table>', repl_cs, frag, flags=re.S | re.I)
    
    # 3. Extract <pre> blocks
    def repl_pre(match):
        inner = match.group(1)
        inner = re.sub(r'<br\s*/?>', '\n', inner, flags=re.I)
        inner = re.sub(r'<[^>]+>', '', inner)
        inner = unescape(inner).replace('\xa0', ' ').strip()
        if inner:
            codes.append(inner)
        return "\n"
    frag = re.sub(r'<pre[^>]*>(.*?)</pre>', repl_pre, frag, flags=re.S | re.I)
    
    # 4. Extract regular data tables (<table...>)
    def repl_table(match):
        t_html = match.group(0)
        if '클릭하면 해당 페이지로 이동됩니다' in t_html:
            return ""
        rows_raw = re.findall(r'<tr[^>]*>(.*?)</tr>', t_html, flags=re.S | re.I)
        parsed_rows = []
        for r in rows_raw:
            cells = re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>', r, flags=re.S | re.I)
            clean_cells = []
            for c in cells:
                c_txt = re.sub(r'</?(?:p|div|li|br)[^>]*>', '\n', c, flags=re.I)
                c_txt = re.sub(r'<[^>]+>', '', c_txt)
                c_txt = unescape(c_txt).replace('\xa0', ' ').replace('\u2003', ' ').strip()
                # normalize multiple spaces on each line
                c_lines = [re.sub(r'[ \t]{2,}', ' ', cl).strip() for cl in c_txt.split('\n') if cl.strip()]
                clean_cells.append('\n'.join(c_lines))
            if any(clean_cells):
                parsed_rows.append(clean_cells)
        if parsed_rows:
            # Check if it's a single-cell box (like [보기] box or code box)
            if len(parsed_rows) == 1 and len(parsed_rows[0]) == 1:
                cell_content = parsed_rows[0][0]
                # Check if this single-cell table is actually source code or SQL!
                if re.search(r'(#include|public\s+class|void\s+main|int\s+main|SELECT\s+.*FROM|CREATE\s+TABLE|ALTER\s+TABLE|UPDATE\s+.*SET|DELETE\s+FROM)', cell_content, re.I):
                    codes.append(cell_content)
                    return "\n"
                tables.append({'type': 'box', 'content': cell_content})
                return "\n"
            else:
                tables.append({'type': 'grid', 'rows': parsed_rows})
                return "\n"
        return ""
    frag = re.sub(r'<table[^>]*>.*?</table>', repl_table, frag, flags=re.S | re.I)
    
    # 5. Convert block tags to newlines, strip remaining HTML tags, then unescape
    frag = re.sub(r'</?(?:p|div|h[1-6]|li|ul|ol|blockquote)[^>]*>', '\n', frag, flags=re.I)
    frag = re.sub(r'<br\s*/?>', '\n', frag, flags=re.I)
    frag = re.sub(r'<[^>]+>', '', frag)
    frag = unescape(frag).replace('\xa0', ' ').replace('\u2003', ' ')
    
    lines = []
    for l in frag.split('\n'):
        # Collapse excessive spaces (e.g., "다음은     블랙박스     테스트" -> "다음은 블랙박스 테스트")
        ls = re.sub(r'[ \t]{2,}', ' ', l).strip()
        if not ls:
            continue
        if ls in ('반응형', 'Colored by Color Scripter', 'cs'):
            continue
        lines.append(ls)
        
    return lines, codes, tables, images

def separate_inline_code(lines, existing_codes, header):
    if existing_codes:
        return lines, '\n\n'.join(existing_codes)
        
    full_txt = '\n'.join(lines)
    is_code_q = bool(re.search(r'(C\s*언어|자바|Java|파이썬|Python|SQL|소스\s*코드|코드이다)', header, re.I))
    if not is_code_q and not re.search(r'(#include|public\s+class|System\.out|SELECT\s+.*FROM)', full_txt, re.I):
        return lines, ""
        
    q_lines = []
    c_lines = []
    in_code = False
    for idx, l in enumerate(lines):
        if idx == 0:
            q_lines.append(l)
            continue
        if not in_code and re.search(r'^(#include|import\s+|class\s+\w+|public\s+class|void\s+main|int\s+main|def\s+\w+|SELECT\s+|CREATE\s+TABLE|ALTER\s+TABLE|UPDATE\s+|INSERT\s+INTO|DELETE\s+FROM|\(\s*1\.?\s*\)\s*TABLE|1\)\s*SELECT|\w+\s*=\s*[\[\{\'\"]|for\s*\(|while\s*\()', l, re.I):
            in_code = True
        if in_code:
            # If we hit "[보기]" or "[학생]" table title after SQL, move back to q_lines
            if re.match(r'^(\[보기\]|\[학생\]|\[성적\]|조건\s*:)', l):
                in_code = False
                q_lines.append(l)
            else:
                c_lines.append(l)
        else:
            q_lines.append(l)
    return q_lines, '\n'.join(c_lines)

def classify_question(header, q_body, code_snippet, answer_text):
    full_text = f"{header}\n{q_body}\n{code_snippet}"
    
    # 1. Explicit Header & Code checks for Programming Languages
    if re.search(r'(?:Java|자바)\s*(?:소스\s*)?코드|Java의\s*문제|Java에\s*대한|밑줄에\s*들어갈\s*키워드', header, re.I) or re.search(r'System\.out\.|public\s+static\s+void\s+main|class\s+\w+\s+extends|implements\s+\w+', full_text):
        if not re.search(r'JavaScript', full_text, re.I):
            return 'Java', 'java'
            
    if re.search(r'파이썬|Python', header, re.I) or (code_snippet and re.search(r'def\s+\w+\s*\(|print\s*\(|lambda\s+', code_snippet) and not re.search(r'#include|System\.out|printf', code_snippet)):
        return 'Python', 'python'
        
    if re.search(r'C\s*언어|C\s*코드', header, re.I) or re.search(r'#include\s*<|scanf\s*\(|int\s+main\s*\(|void\s+main\s*\(|printf\s*\(|struct\s+\w+\s*\{', full_text):
        if not re.search(r'데니스\s*리치', full_text): # UNIX description mentions C language
            if code_snippet or re.search(r'출력|결과|코드|알맞는\s*값|배열|C\s*언어|C\s*코드', header, re.I):
                return 'C언어', 'c'
            
    if re.search(r'SQL|SELECT\b.*FROM\b|INSERT\s+INTO\b|UPDATE\b.*SET\b|DELETE\s+FROM\b|CREATE\s+TABLE\b|ALTER\s+TABLE\b|CREATE\s+INDEX\b|CREATE\s+DOMAIN\b|GRANT\b.*TO\b', full_text, re.I):
        if not re.search(r'Injection|인젝션', full_text, re.I):
            if code_snippet or re.search(r'SQL|쿼리|문장|구문|결과|출력|튜플|카운트|인덱스\s*생성|도메인을\s*정의', full_text, re.I):
                return 'SQL', 'sql'

    # 2. Theory classifications
    if re.search(r'살충제\s*패러독스|테스트|커버리지|동등\s*분할|동치\s*분할|경계값|화이트\s*박스|블랙\s*박스|오라클|인스펙션|워크스루|결함|V\s*모델', full_text, re.I):
        return '소프트웨어 테스트/품질', None
    if re.search(r'디자인\s*패턴|GoF|생성\s*패턴|구조\s*패턴|행위\s*패턴|Singleton|Factory|Builder|Prototype|Adapter|Bridge|Composite|Decorator|Facade|Flyweight|Proxy|Observer|Strategy|Template\s*Method|Command|Iterator|Visitor|Mediator|Memento|Chain\s*of', full_text, re.I):
        return '디자인 패턴', None
    if re.search(r'결합도|응집도|Coupling|Cohesion', full_text, re.I):
        return '결합도/응집도', None
    if re.search(r'UML|다이어그램|액터|유스케이스|시퀀스|럼바우|기능적\s*요구사항|비기능적', full_text, re.I):
        return '요구사항/UML/설계', None
    if re.search(r'애자일|스크럼|XP|폭포수|나선형|형상\s*통제|형상\s*관리|형상\s*감사|릴리스\s*노트|버전\s*관리|Git|SVN|CVS|LoC|COCOMO|기능\s*점수|Fan-in|Fan-out|공통\s*모듈|리팩토링', full_text, re.I):
        return '소프트웨어 공학/방법론', None
    if re.search(r'정규형|정규화|비정규화|반정규화|이상\s*현상|함수적\s*종속|1NF|2NF|3NF|BCNF|4NF|5NF|DB\s*설계|개념적\s*설계|논리적\s*설계|물리적\s*설계|파일\s*구조|인덱스|해싱\s*접근', full_text, re.I):
        return '데이터베이스(설계/정규화)', None
    if re.search(r'관계\s*대수|관계\s*해석|카디널리티|차수|튜플|도메인|기본키|외래키|슈퍼키|후보키|대체키|무결성|릴레이션|Degree|Cardinality|Attribute|R%S|디비전', full_text, re.I):
        return '데이터베이스(관계대수/구조)', None
    if re.search(r'트랜잭션|원자성|일관성|격리성|영속성|ACID|회복|Rollback|Commit|Redo|Undo|체크포인트|지연\s*갱신|즉시\s*갱신|병행\s*제어|로킹', full_text, re.I):
        return '데이터베이스(트랜잭션/회복)', None
    if re.search(r'네트워크|IPv4|IPv6|서브넷|CIDR|라우팅|OSPF|RIP|BGP|ARP|RARP|ICMP|IGMP|프로토콜|OSI\s*7|TCP|UDP|핸드셰이크|토폴로지|애드혹|Ad-hoc|DNS|DHCP|MAC\s*주소|스위칭|패킷|회선\s*교환|데이터그램', full_text, re.I):
        return '네트워크/프로토콜', None
    if re.search(r'보안|암호|대칭키|비대칭키|공개키|RSA|AES|DES|SEED|ARIA|IDEA|SKIPJACK|SHA|MD5|스니핑|스푸핑|스머프|랜드\s*어택|DDoS|웜|바이러스|랜섬웨어|AAA|접근통제|DAC|MAC\b|RBAC|XSS|SQL\s*Injection|세션\s*하이재킹|기밀성|무결성|가용성|IPSec|SSL|TLS|SSH\b|침입', full_text, re.I):
        return '보안/암호학', None
    if re.search(r'스케줄링|FCFS|SJF|SRT|RR\b|라운드로빈|HRN|페이지\s*교체|FIFO|LRU|LFU|NUR|OPT|스래싱|워킹셋|PFF|교착상태|데드락|상호배제|상태\s*전이도', full_text, re.I):
        return '운영체제(스케줄링/메모리)', None
    if re.search(r'리눅스|유닉스|명령어|chmod|chown|fork|ls\b|pwd|grep|find|cat\b|kill|ps\b|데니스\s*리치', full_text, re.I):
        return '운영체제(명령어/기초)', None
    if re.search(r'인터페이스|EAI|ESB|SOAP|REST|RESTful|WSDL|UDDI|JSON|XML|AJAX|웹서비스', full_text, re.I):
        return '인터페이스/연계/웹기술', None
    return '소프트웨어 일반/신기술', None

def determine_question_format(header, q_body, code_snippet, sub_type):
    full_q = f"{header}\n{q_body}"
    if sub_type in ('C언어', 'Java', 'Python'):
        if re.search(r'밑줄|빈칸|괄호|알맞는\s*키워드', header):
            return '코드 빈칸 완성형'
        return '코드 출력 결과형'
    if sub_type == 'SQL':
        if re.search(r'작성하시오|구문을\s*완성|빈칸|괄호', full_q):
            return 'SQL 작성·빈칸형'
        return 'SQL 결과 도출형'
    if re.search(r'서술하시오|설명하시오|약술하시오|약술하십시오|개념을\s*쓰시오|목적에\s*대하여', full_q):
        return '서술·약술형'
    if re.search(r'계산식|몇\s*개|횟수를|시간을\s*구하시오|결과값을\s*작성|할당\s*가능한.*IP|부재\s*횟수|우선순위|평균\s*대기시간', full_q):
        return '수식·계산 도출형'
    if re.search(r'보기에서|보기에\s*골라|기호를\s*골라|기호로\s*쓰시오|나열하시오|고르시오', full_q):
        return '보기·기호 선택형'
    if re.search(r'괄호|빈칸|\(\s*\)|\[\s*\]', full_q):
        return '괄호 빈칸 채우기형'
    return '핵심 용어 단답형'

def generate_auto_explanation(header, body, code, ans, sub_type):
    if sub_type == 'C언어':
        hints = ["[C언어 실행 과정 분석]"]
        if '*' in code or '&' in code:
            hints.append("• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.")
        if 'for' in code or 'while' in code:
            hints.append("• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.")
        if 'void ' in code or 'int ' in code:
            hints.append("• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.")
        hints.append(f"• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [{ans}] 입니다.")
        return '\n'.join(hints)
    elif sub_type == 'Java':
        hints = ["[Java 객체지향 실행 과정 분석]"]
        if 'extends' in code or 'super' in code:
            hints.append("• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)")
        if 'static' in code:
            hints.append("• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.")
        hints.append(f"• System.out 출력문에 의해 최종 도출되는 결과값은 [{ans}] 입니다.")
        return '\n'.join(hints)
    elif sub_type == 'Python':
        hints = ["[Python 코드 실행 과정 분석]"]
        if ':' in code and '[' in code:
            hints.append("• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)")
        hints.append("• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.")
        hints.append(f"• print() 문에 의해 최종 출력되는 결과값은 [{ans}] 입니다.")
        return '\n'.join(hints)
    elif sub_type == 'SQL':
        return (
            f"[SQL 질의 분석 및 풀이]\n"
            f"• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.\n"
            f"• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [{ans}] 입니다."
        )
    else:
        return (
            f"[{sub_type} 핵심 개념 해설]\n"
            f"• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [{ans}] 입니다.\n"
            f"• 학습 가이드: [{sub_type}] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요."
        )

def split_answer_and_explanation(moreless_lines, qid, q_header, q_body, code_snippet, sub_type):
    # Known typo fix in source blog: QID 302 (2025년 3회 2번) has "ㅇ" instead of "조건 커버리지"
    if qid == 302:
        return (
            "조건 커버리지 (Condition Coverage)",
            "• 조건 커버리지(Condition Coverage): 결정 포인트 내에 존재하는 모든 개별 조건식(Atomic Condition)이 참(True)과 거짓(False)을 최소 한 번 이상 만족하도록 테스트 케이스를 설계하는 화이트박스 테스트 기법입니다.\n• 개별 조건식은 모두 T/F를 거치더라도 전체 결정문(Decision)의 결과가 한쪽으로만 치우칠 수 있다는 특징이 있습니다."
        )
        
    if not moreless_lines:
        return "복원 답안 참조", generate_auto_explanation(q_header, q_body, code_snippet, "복원 답안", sub_type)
        
    ans_lines = []
    exp_lines = []
    mode = 'ANS'
    
    for idx, line in enumerate(moreless_lines):
        if idx == 0:
            ans_lines.append(line)
            continue
        if mode == 'ANS':
            is_sub_num = bool(re.match(r'^(?:[1-7][\.\)\s]|[\(\[]([1-7]|[ㄱ-ㅎ]|[a-gA-G])[\)\]]|[ㄱ-ㅎ][\.\)\s]|[①-⑦])\s*', line))
            is_matrix_row = bool(re.match(r'^[0-9]+(\s*,\s*[0-9]+)+$', line))
            is_explanation_sentence = bool(re.search(r'(생성하여|호출할|호출하면|따라서|때문에|의미합니다|기법입니다|프로토콜입니다|특징\s*:|절차\s*:|종류\s*:|마찬가지로|진행되므로)', line))
            
            if is_explanation_sentence or line in ('1.', '2.', '3.'):
                mode = 'EXP'
                exp_lines.append(line)
            elif is_sub_num and len(line) < 80:
                ans_lines.append(line)
            elif is_matrix_row:
                ans_lines.append(line)
            elif len(moreless_lines) <= 5 and len(line) < 45 and not line.endswith(('다.', '니다.', '이다.', ':')):
                ans_lines.append(line)
            else:
                mode = 'EXP'
                exp_lines.append(line)
        else:
            exp_lines.append(line)
            
    ans_str = '\n'.join(ans_lines).strip()
    exp_str = '\n'.join(exp_lines).strip()
    if not exp_str:
        exp_str = generate_auto_explanation(q_header, q_body, code_snippet, ans_str, sub_type)
    return ans_str, exp_str

all_questions = []
rounds_meta = []
q_global_id = 1

for r_id, r_name, yr, r_num, url in URL_ORDER:
    html = raw_articles[url]['html']
    html = re.sub(r'<table[^>]*>(?:(?!</table).)*?클릭하면 해당 페이지로 이동됩니다.*?</table\s*>', '', html, flags=re.S | re.I)
    
    pattern = re.compile(r'<div[^>]*data-ke-type="moreLess"[^>]*>.*?<a[^>]*>더보기</a>\s*<div class="moreless-content">(.*?)</div>\s*</div>', flags=re.S | re.I)
    
    pos = 0
    q_num = 1
    theory_cnt = 0
    code_cnt = 0
    
    for m in pattern.finditer(html):
        q_html = html[pos:m.start()]
        ans_html = m.group(1)
        pos = m.end()
        
        q_lines, q_codes, q_tables, q_images = parse_html_segment(q_html, q_global_id, is_answer=False)
        ans_lines, ans_codes, ans_tables, ans_images = parse_html_segment(ans_html, q_global_id, is_answer=True)
        
        # Locate question header line (e.g., "1. ...", "11. ...")
        start_idx = 0
        for idx, l in enumerate(q_lines):
            if re.match(rf'^(?:\[?문제\s*)?{q_num}\s*[\.번\)]', l):
                start_idx = idx
                break
        q_lines = q_lines[start_idx:]
        
        header = q_lines[0] if q_lines else f"{q_num}. 문항 {q_num}"
        q_lines_sep, code_snippet = separate_inline_code(q_lines, q_codes, header)
        
        body_lines = q_lines_sep[1:] if len(q_lines_sep) > 1 else []
        q_body = '\n'.join(body_lines).strip()
        
        if ans_codes:
            ans_lines.extend(ans_codes)
        if ans_tables:
            for t in ans_tables:
                if t['type'] == 'grid':
                    for r in t['rows']:
                        ans_lines.append(' | '.join(r))
                else:
                    ans_lines.append(t['content'])
                    
        sub_type, code_lang = classify_question(header, q_body, code_snippet, '\n'.join(ans_lines))
        minor_id = MINOR_NAME_TO_ID[sub_type]
        major_id = MINOR_ID_TO_MAJOR[minor_id]
        
        if major_id == 2:
            code_cnt += 1
        else:
            theory_cnt += 1
            
        q_format = determine_question_format(header, q_body, code_snippet, sub_type)
        ans_text, exp_text = split_answer_and_explanation(ans_lines, q_global_id, header, q_body, code_snippet, sub_type)
        
        all_questions.append({
            'question_id': q_global_id,
            'round_id': r_id,
            'round_title': r_name,
            'year': yr,
            'round_num': r_num,
            'question_num': q_num,
            'major_id': major_id,
            'major_name': '코드' if major_id == 2 else '이론',
            'minor_id': minor_id,
            'minor_name': sub_type,
            'question_format': q_format,
            'question_header': header,
            'question_body': q_body,
            'code_snippet': code_snippet,
            'code_lang': code_lang or '',
            'tables_json': json.dumps(q_tables, ensure_ascii=False),
            'images_json': json.dumps(q_images, ensure_ascii=False),
            'tables': q_tables,
            'images': q_images,
            'answer_text': ans_text,
            'explanation_text': exp_text,
            'source_url': url
        })
        
        q_global_id += 1
        q_num += 1
        
    rounds_meta.append({
        'round_id': r_id,
        'year': yr,
        'round_num': r_num,
        'round_title': r_name,
        'source_url': url,
        'total_questions': q_num - 1,
        'theory_count': theory_cnt,
        'code_count': code_cnt
    })

# --- 2026년 3회 (제19회차, 2026년 10월 시행) 복원 20문항 추가 ---
R19_SOURCE_URL = 'https://ys-note.com/information-processing-engineer-practical-2026-3-answers/'
ROUND_2026_3_RAW = [
    (1, 'SQL', 'sql', 'SQL 결과 도출형',
     '1. 다음 테이블 <A>와 <B>에 대해 아래 SQL문을 실행했을 때 출력되는 result 값을 작성하시오.',
     '',
     'SELECT COUNT(*) AS result\nFROM A\nLEFT JOIN B ON A.id = B.id\nWHERE B.id IS NULL;',
     [
         {'type': 'grid', 'rows': [['[테이블 A] id'], ['1'], ['2'], ['3']]},
         {'type': 'grid', 'rows': [['[테이블 B] id'], ['1']]}
     ],
     '2',
     '[SQL 질의 분석 및 풀이]\n• LEFT JOIN(LEFT OUTER JOIN)은 왼쪽 테이블(A)의 모든 행(1, 2, 3)을 유지하고, 오른쪽 테이블(B)에 매칭되는 값이 없으면 NULL로 채웁니다.\n• 조인 결과: (1, 1), (2, NULL), (3, NULL)\n• WHERE B.id IS NULL 조건에 의해 B에 매칭되지 않은 id=2, id=3 두 행만 남으므로 COUNT(*) 결과는 2입니다.'),

    (2, '데이터베이스(설계/정규화)', '', '괄호 빈칸 채우기형',
     '2. 다음 설명에 해당하는 데이터베이스 설계 단계를 <보기>에서 골라 ①~③에 알맞은 단계를 쓰시오.',
     '① 운영체제와 목표 DBMS의 특성을 고려하여 데이터베이스의 내부 저장 구조, 인덱스, 접근 경로 등을 설계하는 단계\n② 요구사항 분석 결과를 바탕으로 특정 DBMS에 독립적인 개념 스키마를 설계하고 E-R 다이어그램으로 표현하는 단계\n③ 개념적 구조를 목표 DBMS에 맞는 관계형 테이블 구조와 논리적 스키마로 변환하고 정규화를 수행하는 단계',
     '',
     [{'type': 'box', 'content': '개념적 설계, 논리적 설계, 물리적 설계'}],
     '① 물리적 설계\n② 개념적 설계\n③ 논리적 설계',
     '[데이터베이스(설계/정규화) 핵심 개념 해설]\n• 전체 DB 설계 순서: 요구조건 분석 → 개념적 설계(ERD, DBMS 독립적) → 논리적 설계(릴레이션 스키마 변환, 정규화, 트랜잭션 인터페이스) → 물리적 설계(내부 저장 구조, 인덱스, 접근 경로) → 구현\n• 지문은 순서를 섞어서 제시했으므로 단서 키워드(① 내부 저장 구조/인덱스 = 물리적 설계, ② DBMS 독립적/E-R 다이어그램 = 개념적 설계, ③ 테이블 구조/스키마/정규화 = 논리적 설계)로 정확히 매칭해야 합니다.'),

    (3, 'SQL', 'sql', 'SQL 작성·빈칸형',
     '3. 다음 <STUDENT> 테이블에서 학생의 이름(name)과 점수(score)를 점수가 높은 순서(내림차순)로 조회하도록 SQL문의 빈칸 ①~③을 채우시오.',
     '',
     'SELECT name, score\nFROM STUDENT\n( ① ) BY ( ② ) ( ③ );',
     [{'type': 'grid', 'rows': [['id', 'name', 'score'], ['1', '김민수', '80'], ['2', '이지은', '95'], ['3', '박서준', '70'], ['4', '최유진', '85']]}],
     '① ORDER\n② score\n③ DESC',
     '[SQL 질의 분석 및 풀이]\n• 정렬 절은 ORDER BY <컬럼명> [ASC|DESC] 구문을 사용합니다.\n• 점수가 높은 순서(내림차순)로 정렬해야 하므로 ① ORDER, ② score, ③ DESC 를 작성합니다. (① 뒤에 BY가 이미 인쇄되어 있으므로 ①에는 ORDER만 작성)'),

    (4, '디자인 패턴', '', '보기·기호 선택형',
     '4. 다음 설명에 해당하는 GoF 디자인 패턴을 <보기>에서 골라 기호를 쓰시오.',
     '생성(Creational) 패턴 중 하나로, 객체를 생성하기 위한 인터페이스를 상위 클래스에서 정의하고, 실제로 어떤 클래스의 인스턴스를 생성할지는 서브클래스(하위 클래스)에서 결정하도록 위임하는 디자인 패턴이다.',
     '',
     [{'type': 'box', 'content': 'ㄱ. Adapter   ㄴ. Singleton   ㄷ. Template Method   ㄹ. Decorator\nㅁ. Observer   ㅂ. Strategy   ㅅ. Factory Method   ㅇ. Mediator'}],
     'ㅅ. Factory Method (팩토리 메서드)',
     '[디자인 패턴 핵심 개념 해설]\n• Factory Method(팩토리 메서드, 생성 패턴): 상위 클래스에서는 객체 생성 인터페이스만 정의하고 실제 구체 클래스 인스턴스 생성을 하위 클래스에 위임하는 패턴입니다. (Virtual Constructor라고도 함)\n• 함정 비교: Template Method(행위 패턴)는 알고리즘의 골격을 상위 클래스에 정의하고 세부 단계를 하위 클래스에서 구현하는 것이며, "생성 패턴" 및 "객체 생성 위임"이 핵심 단서이므로 Factory Method가 정답입니다.'),

    (5, 'C언어', 'c', '코드 출력 결과형',
     '5. 다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.',
     '',
     '#include <stdio.h>\n\nint add(int a, int b) {\n    return a + b;\n}\nint sub(int a, int b) {\n    return a - b;\n}\n\ntypedef struct {\n    int value;\n    int (*fn)(int, int);\n} Item;\n\nint main(void) {\n    Item arr[2] = {{3, add}, {10, sub}};\n    Item *p = arr;\n    Item *ptr;\n    int a, b;\n\n    p++;\n    ptr = p;\n    a = p->value;\n    p--;\n    b = p->value;\n\n    printf("%d", ptr->fn(a, b));\n    return 0;\n}',
     [],
     '7',
     '[C언어 실행 과정 분석]\n• Item *p = arr; → p는 arr[0]({3, add})을 가리킵니다.\n• p++; → p가 arr[1]({10, sub})로 이동합니다.\n• ptr = p; → ptr도 현재 p가 가리키는 arr[1]의 주소를 복사받아 저장합니다.\n• a = p->value; → arr[1].value 이므로 a = 10 입니다.\n• p--; b = p->value; → p만 다시 arr[0]으로 이동하여 b = 3 이 됩니다. (단, ptr은 여전히 arr[1]을 가리킴)\n• ptr->fn(a, b)는 arr[1].fn(10, 3) 즉 sub(10, 3)을 호출하므로 10 - 3 = 7이 출력됩니다.'),

    (6, '보안/암호학', '', '괄호 빈칸 채우기형',
     '6. 다음 설명에 해당하는 대칭키 블록 암호화 알고리즘을 괄호 ①, ②에 각각 쓰시오.',
     '① 스위스의 Xuejia Lai와 James Massey가 개발한 대칭키 블록 암호 알고리즘으로, PES와 IPES를 거쳐 ( ① )(으)로 명명되었다. 128비트 키를 사용하여 64비트 평문 블록을 8라운드에 걸쳐 암호화한다.\n② ( ② )은/는 미국 국가안보국(NSA)이 개발한 Clipper 칩에 내장된 대칭키 블록 암호 알고리즘이다. Fortezza 카드에 칩 형태로 구현되었으며 64비트 입출력 블록, 80비트 키, 32라운드로 동작한다.',
     '',
     [],
     '① IDEA\n② Skipjack',
     '[보안/암호학 핵심 개념 해설]\n• IDEA (International Data Encryption Algorithm): Lai와 Massey가 개발(PES → IPES → IDEA), 128비트 키 / 64비트 블록 / 8라운드 대칭키 블록 암호.\n• Skipjack: 미국 NSA가 개발하여 클리퍼(Clipper) 칩 및 Fortezza 카드에 탑재한 음성·통신용 대칭키 블록 암호 (80비트 키 / 64비트 블록 / 32라운드).'),

    (7, '소프트웨어 테스트/품질', '', '보기·기호 선택형',
     '7. 다음은 입력값의 범위에 따라 처리하는 프로그램의 테스트 데이터와 결과이다. 적용된 블랙박스 테스트 기법을 <보기>에서 골라 기호를 쓰시오.',
     '입력값은 0 이상 100 이하의 정수이고, 세 구간(0 이상 10 미만 / 10 이상 70 미만 / 70 이상 100 이하)으로 나누어 처리하며 범위를 벗어난 입력값은 오류로 처리한다.',
     '',
     [
         {'type': 'grid', 'rows': [
             ['테스트 데이터', '-1', '0', '1', '9', '10', '11', '69', '70', '71', '99', '100', '101'],
             ['테스트 결과', '오류', '정상', '정상', '정상', '정상', '정상', '정상', '정상', '정상', '정상', '정상', '오류']
         ]},
         {'type': 'box', 'content': 'ㄱ. 동치 분할 테스트   ㄴ. 원인-결과 그래프 테스트   ㄷ. 결정 테이블 테스트   ㄹ. 경계값 분석\nㅁ. 오류 예측 테스트   ㅂ. 상태 전이 테스트   ㅅ. 유스케이스 테스트   ㅇ. 비교 테스트'}
     ],
     'ㄹ. 경계값 분석 (Boundary Value Analysis)',
     '[소프트웨어 테스트/품질 핵심 개념 해설]\n• 경계값 분석(Boundary Value Analysis): 입력 조건의 중간값보다 경계(0, 10, 70, 100) 및 그 인접값(-1·0·1, 9·10·11, 69·70·71, 99·100·101)에서 결함이 발생할 확률이 높다는 점을 이용해 테스트 케이스를 선정하는 블랙박스 테스트 기법입니다.'),

    (8, '보안/암호학', '', '보기·기호 선택형',
     '8. 다음 설명에 해당하는 접근 통제(Access Control) 방식을 <보기>에서 골라 쓰시오.',
     '사용자에게 개별적으로 접근 권한을 부여하면 직책이나 업무가 바뀔 때마다 권한이 누적되어 관리가 복잡해진다. 이를 해결하기 위해 조직의 직무·직책(역할)별로 필요한 접근 권한을 미리 정의해 두고, 사용자에게는 해당 역할을 부여하여 자원에 접근하도록 통제하는 방식이다.',
     '',
     [{'type': 'box', 'content': 'MAC, DAC, RBAC, PBAC'}],
     'RBAC (Role-Based Access Control)',
     '[보안/암호학 핵심 개념 해설]\n• RBAC(역할 기반 접근 통제): 권한을 개인이 아닌 직무·직책(Role)에 할당하고 사용자에게 역할을 부여하는 방식입니다.\n• DAC(임의적 접근 통제): 데이터 소유자의 재량으로 신분(ID)에 따라 권한 부여.\n• MAC(강제적 접근 통제): 시스템이 보안 등급(Label)에 따라 강제 통제.'),

    (9, 'C언어', 'c', '코드 출력 결과형',
     '9. 다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.',
     '',
     '#include <stdio.h>\n\ntypedef struct Node {\n    int value;\n    struct Node *left;\n    struct Node *right;\n} Node;\n\nint cnt = 0;\n\nvoid pre(Node *n) {\n    if (!n) return;\n    if (++cnt == 3) {\n        printf("%d", n->value);\n        return;\n    }\n    pre(n->left);\n    pre(n->right);\n}\n\nint main(void) {\n    Node n4 = {4, NULL, NULL};\n    Node n5 = {5, NULL, NULL};\n    Node n2 = {2, &n4, &n5};\n    Node n3 = {3, NULL, NULL};\n    Node n1 = {1, &n2, &n3};\n\n    pre(&n1);\n    return 0;\n}',
     [],
     '4',
     '[C언어 실행 과정 분석]\n• 트리 구조: 루트 n1(1)의 왼쪽 자식은 n2(2), 오른쪽 자식은 n3(3)이며, n2(2)의 왼쪽 자식은 n4(4), 오른쪽 자식은 n5(5)입니다.\n• pre() 함수는 자식 노드 재귀 호출 전에 ++cnt를 수행하므로 전위 순회(Pre-order: 현재 노드 → 왼쪽 → 오른쪽) 순서로 카운트합니다.\n• 방문 순서: 1번째 n1(1) [cnt=1] → 2번째 n2(2) [cnt=2] → 3번째 n4(4) [cnt=3].\n• cnt가 3이 되는 순간 n4->value 인 4를 출력합니다.'),

    (10, '네트워크/프로토콜', '', '수식·계산 도출형',
     '10. 192.168.1.0/24 네트워크를 FLSM 방식으로 3개 네트워크에 사용할 수 있도록 서브네팅하려 한다. IP Subnet-zero를 적용하며 첫 번째 네트워크가 192.168.1.0/26일 때, 두 번째 네트워크의 브로드캐스트 주소를 10진수로 쓰시오.',
     '',
     '',
     [],
     '192.168.1.127',
     '[네트워크/프로토콜 계산 풀이]\n• 192.168.1.0/24 대역을 최소 3개 이상의 동일 크기 서브넷(FLSM)으로 나누려면 2비트(2² = 4개 서브넷)가 필요하여 프리픽스는 /26(마스크 255.255.255.192)이 됩니다.\n• 호스트 비트가 6비트이므로 각 서브넷의 블록 크기는 2⁶ = 64입니다.\n• 1번째 서브넷: 192.168.1.0 ~ 192.168.1.63\n• 2번째 서브넷: 192.168.1.64 ~ 192.168.1.127 (네트워크 주소: 192.168.1.64, 브로드캐스트 주소: 192.168.1.127)\n• 따라서 두 번째 네트워크의 브로드캐스트 주소는 192.168.1.127 입니다.'),

    (11, '요구사항/UML/설계', '', '괄호 빈칸 채우기형',
     '11. 다음 UML(Unified Modeling Language) 구성 요소에 대한 설명을 읽고 빈칸 ①~③에 들어갈 알맞은 용어를 쓰시오.',
     '• UML의 3대 기본 구성 요소는 사물(Things), ( ① ), 다이어그램(Diagrams)이다.\n• 구조(정적) 사물 중 ( ② )은/는 동일한 속성, 연산, 관계, 의미를 공유하는 객체들의 집합을 정의한다.\n• 구조(정적) 사물 중 ( ③ )은/는 클래스나 컴포넌트가 외부에 제공하는 서비스나 기능을 명세하는 연산(Operation)들의 집합으로, 구현 내용은 포함하지 않으며 <<interface>> 스테레오타입 기호로 표기한다.',
     '',
     [],
     '① 관계 (Relationships)\n② 클래스 (Class)\n③ 인터페이스 (Interface)',
     '[요구사항/UML/설계 핵심 개념 해설]\n• ① UML 3대 구성 요소는 사물(Things), 관계(Relationships), 다이어그램(Diagrams)입니다.\n• ② 공통된 속성과 연산을 공유하는 객체들의 집합(틀)은 클래스(Class)입니다.\n• ③ 구현 없이 외부에 제공하는 오퍼레이션(연산)의 집합만 명세하는 사물은 인터페이스(Interface)입니다.'),

    (12, 'SQL', 'sql', 'SQL 결과 도출형',
     '12. 다음 <SALES> 테이블에 대해 아래 SQL문을 실행했을 때 출력되는 RESULT 값을 작성하시오.',
     '',
     'SELECT MAX(AMOUNT) AS RESULT\nFROM SALES\nWHERE YEAR = 2023\n  AND QUARTER IN (\n      SELECT QUARTER\n      FROM SALES\n      WHERE YEAR = 2023\n        AND AMOUNT < (\n            SELECT AVG(AMOUNT)\n            FROM SALES\n            WHERE YEAR = 2023\n        )\n  );',
     [{'type': 'grid', 'rows': [
         ['YEAR', 'QUARTER', 'AMOUNT'],
         ['2023', '1', '100'],
         ['2023', '2', '150'],
         ['2023', '3', '130'],
         ['2023', '4', '170'],
         ['2024', '1', '120'],
         ['2024', '3', '200']
     ]}],
     '130',
     '[SQL 질의 분석 및 풀이]\n1. 가장 안쪽 서브쿼리: 2023년 데이터의 AMOUNT 평균 = (100 + 150 + 130 + 170) / 4 = 137.5\n2. 가운데 서브쿼리: 2023년 행 중 AMOUNT < 137.5 인 분기(QUARTER)는 1분기(100)와 3분기(130) → QUARTER IN (1, 3)\n3. 메인 쿼리: YEAR = 2023 이면서 QUARTER가 1 또는 3인 행(100, 130) 중 MAX(AMOUNT)를 구하므로 정답은 130 입니다. (바깥 WHERE절에 YEAR = 2023 조건이 있으므로 2024년 3분기 200은 제외됨)'),

    (13, 'C언어', 'c', '코드 출력 결과형',
     '13. 다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.',
     '',
     '#include <stdio.h>\n\ntypedef struct Node {\n    int x;\n    int (*fn)(struct Node **);\n} Node;\n\nint incr(Node **pp) {\n    Node *n = *pp;\n    n->x = n->x + 1;\n    return n->x;\n}\n\nint fn_cnt(Node **pp) {\n    Node *p = *pp;\n    int a = p->fn(pp);\n    int b = p->fn(pp);\n    return b;\n}\n\nint main(void) {\n    Node a = {11, incr};\n    Node *p = &a;\n    Node **pp = &p;\n    printf("%d\\n", fn_cnt(pp));\n    return 0;\n}',
     [],
     '13',
     '[C언어 실행 과정 분석]\n• Node a = {11, incr}; 이고 p는 &a, 이중 포인터 pp는 &p를 가리킵니다.\n• fn_cnt(pp) 내부에서 p->fn(pp)는 incr(pp)를 호출하며, *pp는 원본 구조체 a를 가리키므로 호출할 때마다 a.x 원본 값이 1씩 증가합니다.\n• 첫 번째 호출: a.x가 11 → 12가 되고 a = 12 반환.\n• 두 번째 호출: a.x가 12 → 13이 되고 b = 13 반환.\n• 최종 반환값 b = 13 이 출력됩니다.'),

    (14, 'Java', 'java', '코드 출력 결과형',
     '14. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.',
     '',
     'public class Main {\n    static class Parent {\n        int a = 1;\n        int meth() {\n            return a;\n        }\n    }\n    static class Child extends Parent {\n        int a = 1;\n        int meth() {\n            return a + super.a;\n        }\n    }\n    public static void main(String[] args) {\n        Parent obj = new Child();\n        System.out.println(obj.meth());\n    }\n}',
     [],
     '2',
     '[Java 객체지향 실행 과정 분석]\n• Parent obj = new Child(); 업캐스팅 상태에서 오버라이딩된 인스턴스 메서드 obj.meth()를 호출하면 실제 생성된 자식 객체(Child)의 meth()가 동적 바인딩되어 실행됩니다.\n• Child.meth() 내부에서 a는 Child의 필드(1)이고, super.a는 부모 Parent의 필드(1)이므로 1 + 1 = 2 가 출력됩니다.'),

    (15, 'Java', 'java', '코드 출력 결과형',
     '15. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오. (출력 문자열의 공백 포함)',
     '',
     'public class Main {\n    public static void main(String[] args) {\n        int[][] a = {{0}, {1}, {2}};\n        int[][] b = new int[3][];\n        for (int i = 0; i < a.length; i++) {\n            b[i] = a[i];\n        }\n        a[1] = new int[]{9};\n        b[2][0] = 3;\n        System.out.println(a[2][0] + " 그리고 " + b[1][0]);\n    }\n}',
     [],
     '3 그리고 1',
     '[Java 객체지향 실행 과정 분석]\n• for문에서 b[i] = a[i]; 는 각 1차원 행 배열의 참조(주소)를 얕은 복사(Shallow Copy)합니다.\n• a[1] = new int[]{9}; 는 a[1] 칸에 새로운 배열 객체 {9}의 주소를 재할당할 뿐이므로, b[1]은 여전히 기존 배열 {1}을 가리킵니다. 따라서 b[1][0]은 1입니다.\n• b[2][0] = 3; 은 a[2]와 b[2]가 함께 공유하고 있는 행 배열의 0번째 원소 값을 직접 3으로 수정하므로 a[2][0]도 3이 됩니다.\n• 따라서 최종 출력값은 "3 그리고 1" 입니다.'),

    (16, '보안/암호학', '', '보기·기호 선택형',
     '16. 다음 설명의 괄호 안에 공통으로 들어갈 보안 위협 용어를 <보기>에서 골라 기호를 쓰시오.',
     '공격자가 시스템에 불법 침입한 뒤 자신의 존재와 활동 흔적을 숨기면서 시스템에 대한 최고 관리자 접근 권한(Root)을 지속적으로 유지하기 위해 사용하는 악성 도구 모음을 ( )이라고 한다. ( )은 백도어, 트로이 목마 등을 포함할 수 있으며, 커널이나 정상적인 운영체제 시스템 기능을 변조하여 프로세스·파일·로그 탐지를 회피한다.',
     '',
     [{'type': 'box', 'content': 'ㄱ. Adware   ㄴ. Virus   ㄷ. Spyware   ㄹ. Keylogger\nㅁ. Ransomware   ㅂ. Worm   ㅅ. Rootkit   ㅇ. Trace Route'}],
     'ㅅ. Rootkit (루트킷)',
     '[보안/암호학 핵심 개념 해설]\n• Rootkit(루트킷): 관리자 권한(Root) + 도구 모음(Kit)의 합성어로, 시스템 침입 후 해킹 사실과 악성 프로세스를 은폐하면서 관리자 권한을 지속 유지하는 악성 도구 집합입니다.'),

    (17, 'Java', 'java', '코드 출력 결과형',
     '17. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.',
     '',
     'public class Main {\n    static String convert(int value) {\n        Integer num = value;\n        return num.toString();\n    }\n    static String convert(double value) {\n        Double num = null;\n        if (value > 1) {\n            num = value * 2;\n        }\n        return num.toString();\n    }\n    public static void main(String[] args) {\n        try {\n            System.out.println(convert(1.0));\n        } catch (Exception e) {\n            System.out.println("error");\n        }\n    }\n}',
     [],
     'error',
     '[Java 객체지향 실행 과정 분석]\n• convert(1.0) 호출 시 인자 1.0이 실수(double) 리터럴이므로 메서드 오버로딩 규칙에 의해 convert(double value)가 호출됩니다.\n• if (value > 1) 에서 1.0 > 1 은 거짓(false)이므로 num은 초기값인 null 상태로 남습니다.\n• return num.toString(); 실행 시 null 참조에 대해 인스턴스 메서드를 호출하므로 NullPointerException 예외가 발생합니다.\n• main의 catch (Exception e) 블록으로 제어가 이동하여 "error"가 출력됩니다.'),

    (18, '소프트웨어 일반/신기술', '', '보기·기호 선택형',
     '18. 다음 설명에 해당하는 소프트웨어 공급망 보안 용어를 <보기>에서 골라 쓰시오.',
     '소프트웨어를 구성하는 오픈소스, 서드파티 라이브러리 등의 구성 요소와 버전, 라이선스, 의존 관계를 기록한 메타데이터 명세서(목록)이다. 소프트웨어 공급망의 투명성을 확보하고 Log4j 등 특정 컴포넌트의 보안 취약점 영향을 즉각 파악·관리하는 데 활용되며, 미국 연방정부에 소프트웨어를 공급할 때 제출이 의무화된 목록이다.',
     '',
     [{'type': 'box', 'content': 'IAM, ZTA, SBOM, Privacy Sandbox, Cyber Resilience, RASP, Data Leakage Prevention, Cyber Kill Chain, Attack Surface'}],
     'SBOM (Software Bill of Materials)',
     '[소프트웨어 일반/신기술 핵심 개념 해설]\n• SBOM(Software Bill of Materials, 소프트웨어 자재 명세서): 소프트웨어 개발 시 포함된 오픈소스 및 컴포넌트의 내역을 목록화한 명세서로, 소프트웨어 공급망 보안(Supply Chain Security)의 핵심 요소입니다. 대표 표준 포맷으로 SPDX, CycloneDX 등이 있습니다.'),

    (19, 'Python', 'python', '코드 출력 결과형',
     '19. 다음은 파이썬(Python) 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.',
     '',
     'class NumberList:\n    def __init__(self):\n        self.data = [3, 5, 7, 9, 11]\n\n    def change(self, index, value):\n        if 0 <= index < len(self.data):\n            self.data[index] = value\n\nclass Calculator(NumberList):\n    def total(self):\n        total = sum(self.data)\n        return total\n\n    def increase(self):\n        for i in range(len(self.data)):\n            self.data[i] += 1\n\ncalculator = Calculator()\ncalculator.change(2, 15)\ncalculator.increase()\nprint(calculator.total(), end="")',
     [],
     '48',
     '[Python 코드 실행 과정 분석]\n• Calculator() 인스턴스 생성 시 부모 클래스 NumberList의 __init__이 호출되어 self.data = [3, 5, 7, 9, 11] 로 초기화됩니다.\n• calculator.change(2, 15) 호출 시 인덱스 2(세 번째 원소 7)가 15로 변경되어 [3, 5, 15, 9, 11] 이 됩니다.\n• calculator.increase() 호출 시 모든 원소에 1씩 더해져 [4, 6, 16, 10, 12] 가 됩니다.\n• calculator.total() 은 리스트의 합계 4 + 6 + 16 + 10 + 12 = 48 을 반환하여 출력합니다.'),

    (20, 'Python', 'python', '코드 출력 결과형',
     '20. 다음은 파이썬(Python) 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.',
     '',
     'def f(x=[1]):\n    x.append(x[-1] + 2)\n    return x[-1]\n\nprint(max(f(), f()) - min(f(), f()))',
     [],
     '-2',
     '[Python 코드 실행 과정 분석]\n• 파이썬 함수의 가변 기본 인자(Mutable Default Argument) x=[1]은 함수 정의 시점(def)에 단 한 번만 생성되며, 이후 인자 없이 f()를 호출할 때마다 동일한 리스트 객체 x를 계속 공유합니다.\n• 1번째 f() 호출 (max 첫 인자): x가 [1, 3]이 되고 3 반환\n• 2번째 f() 호출 (max 둘째 인자): x가 [1, 3, 5]가 되고 5 반환 → max(3, 5) = 5\n• 3번째 f() 호출 (min 첫 인자): x가 [1, 3, 5, 7]이 되고 7 반환\n• 4번째 f() 호출 (min 둘째 인자): x가 [1, 3, 5, 7, 9]가 되고 9 반환 → min(7, 9) = 7\n• 따라서 5 - 7 = -2 가 출력됩니다.')
]

r19_theory_cnt = 0
r19_code_cnt = 0
for q_num, sub_type, c_lang, q_fmt, hdr, body, code_snip, tbls, ans_t, exp_t in ROUND_2026_3_RAW:
    minor_id = MINOR_NAME_TO_ID[sub_type]
    major_id = MINOR_ID_TO_MAJOR[minor_id]
    if major_id == 2:
        r19_code_cnt += 1
    else:
        r19_theory_cnt += 1
    all_questions.append({
        'question_id': q_global_id,
        'round_id': 19,
        'round_title': '2026년 3회',
        'year': 2026,
        'round_num': 3,
        'question_num': q_num,
        'major_id': major_id,
        'major_name': '코드' if major_id == 2 else '이론',
        'minor_id': minor_id,
        'minor_name': sub_type,
        'question_format': q_fmt,
        'question_header': hdr,
        'question_body': body,
        'code_snippet': code_snip,
        'code_lang': c_lang,
        'tables_json': json.dumps(tbls, ensure_ascii=False),
        'images_json': '[]',
        'tables': tbls,
        'images': [],
        'answer_text': ans_t,
        'explanation_text': exp_t,
        'source_url': R19_SOURCE_URL
    })
    q_global_id += 1

rounds_meta.append({
    'round_id': 19,
    'year': 2026,
    'round_num': 3,
    'round_title': '2026년 3회',
    'source_url': R19_SOURCE_URL,
    'total_questions': 20,
    'theory_count': r19_theory_cnt,
    'code_count': r19_code_cnt
})

print(f"Clean parse complete: {len(all_questions)} questions across {len(rounds_meta)} rounds.")

# Load existing predicted questions from previous export if available
prev_json_path = JSON_EXPORT_PATH if os.path.exists(JSON_EXPORT_PATH) else os.path.join(PROJECT_DIR, 'eip_rdb_export.json')
predicted_questions = []
if os.path.exists(prev_json_path):
    with open(prev_json_path, 'r', encoding='utf-8') as f:
        prev_data = json.load(f)
        predicted_questions = prev_data.get('predicted_questions', [])

# Compute Analytics for each Minor Category (Category 1)
total_rounds = len(rounds_meta)
total_q_count = len(all_questions)

analytics_rows = []
for minor_id, major_id, minor_code, minor_name, desc in CATEGORIES_MINOR:
    qs = [q for q in all_questions if q['minor_id'] == minor_id]
    q_cnt = len(qs)
    r_ids = sorted(list(set(q['round_id'] for q in qs)))
    r_app = len(r_ids)
    
    if r_app > 1:
        diffs = [r_ids[i] - r_ids[i-1] for i in range(1, r_app)]
        avg_int = round(sum(diffs) / len(diffs), 2)
        min_int = min(diffs)
        max_int = max(diffs)
    elif r_app == 1:
        avg_int = float(total_rounds)
        min_int = total_rounds
        max_int = total_rounds
    else:
        avg_int = 0.0
        min_int = 0
        max_int = 0
        
    last_r_id = r_ids[-1] if r_ids else 0
    last_r_title = next((r['round_title'] for r in rounds_meta if r['round_id'] == last_r_id), '-')
    gap = total_rounds - last_r_id if last_r_id else total_rounds
    imminence = round(gap / avg_int, 2) if avg_int > 0 else 0.0
    
    fmt_counter = Counter(q['question_format'] for q in qs)
    primary_fmt = fmt_counter.most_common(1)[0][0] if fmt_counter else '-'
    fmt_dist = ", ".join(f"{k}({v})" for k, v in fmt_counter.most_common())
    
    analytics_rows.append({
        'minor_id': minor_id,
        'major_id': major_id,
        'minor_code': minor_code,
        'minor_name': minor_name,
        'major_name': '코드' if major_id == 2 else '이론',
        'description': desc,
        'total_questions': q_cnt,
        'share_pct': round(q_cnt / total_q_count * 100, 2),
        'round_appearances': r_app,
        'avg_per_round': round(q_cnt / total_rounds, 2),
        'avg_interval': avg_int,
        'min_interval': min_int,
        'max_interval': max_int,
        'last_seen_round_id': last_r_id,
        'last_seen_round_title': last_r_title,
        'rounds_since_last': gap,
        'imminence_index': imminence,
        'primary_format': primary_fmt,
        'format_distribution': fmt_dist
    })

def build_sqlite(target_db_path):
    if os.path.exists(target_db_path):
        os.remove(target_db_path)
    conn = sqlite3.connect(target_db_path)
    cur = conn.cursor()
    cur.executescript("""
    PRAGMA foreign_keys = ON;

    CREATE TABLE categories_major (
        major_id INTEGER PRIMARY KEY,
        major_code TEXT NOT NULL UNIQUE,
        major_name TEXT NOT NULL,
        description TEXT
    );

    CREATE TABLE categories_minor (
        minor_id INTEGER PRIMARY KEY,
        major_id INTEGER NOT NULL,
        minor_code TEXT NOT NULL UNIQUE,
        minor_name TEXT NOT NULL,
        description TEXT,
        FOREIGN KEY (major_id) REFERENCES categories_major(major_id)
    );

    CREATE TABLE exam_rounds (
        round_id INTEGER PRIMARY KEY,
        year INTEGER NOT NULL,
        round_num INTEGER NOT NULL,
        round_title TEXT NOT NULL,
        source_url TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        theory_count INTEGER NOT NULL,
        code_count INTEGER NOT NULL
    );

    CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY,
        round_id INTEGER NOT NULL,
        question_num INTEGER NOT NULL,
        major_id INTEGER NOT NULL,
        minor_id INTEGER NOT NULL,
        question_format TEXT NOT NULL,
        question_header TEXT NOT NULL,
        question_body TEXT,
        code_snippet TEXT,
        code_lang TEXT,
        tables_json TEXT,
        images_json TEXT,
        answer_text TEXT NOT NULL,
        explanation_text TEXT NOT NULL,
        FOREIGN KEY (round_id) REFERENCES exam_rounds(round_id),
        FOREIGN KEY (major_id) REFERENCES categories_major(major_id),
        FOREIGN KEY (minor_id) REFERENCES categories_minor(minor_id)
    );

    CREATE TABLE category_analytics (
        minor_id INTEGER PRIMARY KEY,
        major_id INTEGER NOT NULL,
        minor_name TEXT NOT NULL,
        major_name TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        share_pct REAL NOT NULL,
        round_appearances INTEGER NOT NULL,
        avg_per_round REAL NOT NULL,
        avg_interval REAL NOT NULL,
        min_interval INTEGER NOT NULL,
        max_interval INTEGER NOT NULL,
        last_seen_round_id INTEGER NOT NULL,
        last_seen_round_title TEXT NOT NULL,
        rounds_since_last INTEGER NOT NULL,
        imminence_index REAL NOT NULL,
        primary_format TEXT NOT NULL,
        format_distribution TEXT NOT NULL,
        FOREIGN KEY (minor_id) REFERENCES categories_minor(minor_id),
        FOREIGN KEY (major_id) REFERENCES categories_major(major_id)
    );

    CREATE TABLE predicted_questions (
        pred_id INTEGER PRIMARY KEY,
        major_name TEXT NOT NULL,
        minor_name TEXT NOT NULL,
        question_format TEXT NOT NULL,
        imminence_badge TEXT NOT NULL,
        basis TEXT NOT NULL,
        question_header TEXT NOT NULL,
        question_body TEXT,
        code_snippet TEXT,
        code_lang TEXT,
        answer_text TEXT NOT NULL,
        explanation_text TEXT NOT NULL
    );

    CREATE VIEW v_mode_exam AS
    SELECT 
        q.question_id, r.round_title, q.question_num,
        cmj.major_name AS category2_domain, cmn.minor_name AS category1_type,
        q.question_format, q.question_header, q.question_body,
        q.code_snippet, q.code_lang, q.tables_json, q.images_json
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_major cmj ON q.major_id = cmj.major_id
    JOIN categories_minor cmn ON q.minor_id = cmn.minor_id;

    CREATE VIEW v_mode_compare AS
    SELECT 
        q.question_id, r.round_title, q.question_num,
        cmj.major_name AS category2_domain, cmn.minor_name AS category1_type,
        q.question_format, q.question_header, q.question_body,
        q.code_snippet, q.code_lang, q.tables_json, q.images_json,
        q.answer_text
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_major cmj ON q.major_id = cmj.major_id
    JOIN categories_minor cmn ON q.minor_id = cmn.minor_id;

    CREATE VIEW v_mode_explanation AS
    SELECT 
        q.question_id, r.round_title, q.question_num,
        cmj.major_name AS category2_domain, cmn.minor_name AS category1_type,
        q.question_format, q.question_header, q.question_body,
        q.code_snippet, q.code_lang, q.tables_json, q.images_json,
        q.answer_text, q.explanation_text
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_major cmj ON q.major_id = cmj.major_id
    JOIN categories_minor cmn ON q.minor_id = cmn.minor_id;

    CREATE INDEX idx_questions_round ON questions(round_id);
    CREATE INDEX idx_questions_major ON questions(major_id);
    CREATE INDEX idx_questions_minor ON questions(minor_id);
    CREATE INDEX idx_questions_format ON questions(question_format);
    """)

    cur.executemany("INSERT INTO categories_major VALUES (?, ?, ?, ?)", CATEGORIES_MAJOR)
    cur.executemany("INSERT INTO categories_minor VALUES (?, ?, ?, ?, ?)", CATEGORIES_MINOR)

    for r in rounds_meta:
        cur.execute("INSERT INTO exam_rounds VALUES (?, ?, ?, ?, ?, ?, ?, ?)", (
            r['round_id'], r['year'], r['round_num'], r['round_title'], r['source_url'],
            r['total_questions'], r['theory_count'], r['code_count']
        ))

    for q in all_questions:
        cur.execute("INSERT INTO questions VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (
            q['question_id'], q['round_id'], q['question_num'], q['major_id'], q['minor_id'],
            q['question_format'], q['question_header'], q['question_body'], q['code_snippet'],
            q['code_lang'], q['tables_json'], q['images_json'], q['answer_text'], q['explanation_text']
        ))

    for a in analytics_rows:
        cur.execute("INSERT INTO category_analytics VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (
            a['minor_id'], a['major_id'], a['minor_name'], a['major_name'], a['total_questions'],
            a['share_pct'], a['round_appearances'], a['avg_per_round'], a['avg_interval'],
            a['min_interval'], a['max_interval'], a['last_seen_round_id'], a['last_seen_round_title'],
            a['rounds_since_last'], a['imminence_index'], a['primary_format'], a['format_distribution']
        ))

    for p in predicted_questions:
        cur.execute("INSERT INTO predicted_questions VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (
            p['pred_id'], p['major_name'], p['minor_name'], p['question_format'],
            p['imminence_badge'], p['basis'], p['question_header'], p['question_body'],
            p['code_snippet'], p['code_lang'], p['answer_text'], p['explanation_text']
        ))

    conn.commit()
    with open(SQL_DUMP_PATH, 'w', encoding='utf-8') as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")
    conn.close()

build_sqlite(DB_PATH)

export_payload = {
    'categories_major': [
        {'major_id': r[0], 'major_code': r[1], 'major_name': r[2], 'description': r[3]}
        for r in CATEGORIES_MAJOR
    ],
    'categories_minor': [
        {'minor_id': r[0], 'major_id': r[1], 'minor_code': r[2], 'minor_name': r[3], 'description': r[4]}
        for r in CATEGORIES_MINOR
    ],
    'exam_rounds': rounds_meta,
    'category_analytics': analytics_rows,
    'questions': all_questions,
    'predicted_questions': predicted_questions
}

with open(JSON_EXPORT_PATH, 'w', encoding='utf-8') as f:
    json.dump(export_payload, f, ensure_ascii=False, indent=2)

# Sync public/index.html inline RDB_DATA and counters
INDEX_HTML_PATH = os.path.join(PUBLIC_DIR, 'index.html')
if os.path.exists(INDEX_HTML_PATH):
    with open(INDEX_HTML_PATH, 'r', encoding='utf-8') as f:
        idx_html = f.read()
    rdb_json_str = json.dumps(export_payload, ensure_ascii=False, indent=2)
    idx_html = re.sub(
        r'<script id="rdbDataScript">\s*window\.RDB_DATA\s*=\s*\{.*?\};\s*</script>',
        lambda m: f'<script id="rdbDataScript">\n    window.RDB_DATA = {rdb_json_str};\n  </script>',
        idx_html,
        flags=re.S
    )
    idx_html = idx_html.replace('18개 회차', f'{len(rounds_meta)}개 회차')
    idx_html = idx_html.replace('360문항', f'{len(all_questions)}문항')
    idx_html = idx_html.replace('cnt / 360', f'cnt / {len(all_questions)}')
    idx_html = idx_html.replace('/ 18회', f'/ {len(rounds_meta)}회')
    idx_html = idx_html.replace('selectedRoundId: 11,', 'selectedRoundId: 19,')
    with open(INDEX_HTML_PATH, 'w', encoding='utf-8') as f:
        f.write(idx_html)

print("Successfully rebuilt clean SQLite RDB, downloaded images, exported JSON, and synced public/index.html!")



