"""
Merge 2023 Rounds 1, 2, 3 (60 past practical questions) into certs/eip/ RDB,
preserving all 380 existing questions (2020-2022, 2024-2026) and 20 predicted_questions,
and rebuild SQLite DB, SQL dump, JSON export, and certs/eip/index.html.

Note on source URLs:
chobopark.tistory.com/391, /463, /467 are unrelated blog posts (coding test / travel / shopping).
The actual [2023년 1회/2회/3회] 정보처리기사 실기 복원 문제 posts on chobopark.tistory.com
(verified from chobopark's own navigation table) are:
  - 2023년 1회: https://chobopark.tistory.com/372
  - 2023년 2회: https://chobopark.tistory.com/420
  - 2023년 3회: https://chobopark.tistory.com/453
"""

import os
import re
import json
import sqlite3
import requests
from html import unescape
from html.parser import HTMLParser
from collections import Counter

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(PROJECT_DIR, 'data')
IMG_DIR = os.path.join(PROJECT_DIR, 'images', 'questions')
DB_PATH = os.path.join(DATA_DIR, 'eip_exam.db')
SQL_DUMP_PATH = os.path.join(DATA_DIR, 'schema_and_data.sql')
JSON_EXPORT_PATH = os.path.join(DATA_DIR, 'eip_rdb_export.json')
INDEX_HTML_PATH = os.path.join(PROJECT_DIR, 'index.html')

os.makedirs(IMG_DIR, exist_ok=True)
os.makedirs(DATA_DIR, exist_ok=True)

ROUNDS_2023 = [
    (11, '2023년 1회', 2023, 1, 'https://chobopark.tistory.com/372'),
    (12, '2023년 2회', 2023, 2, 'https://chobopark.tistory.com/420'),
    (13, '2023년 3회', 2023, 3, 'https://chobopark.tistory.com/453'),
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


class CodeCellParser(HTMLParser):
    """Parse ColorScripter code <td> safely across nested <div>/<span> elements."""
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.lines = []
        self.cur = []
        self.in_cs_footer = False

    def handle_starttag(self, tag, attrs):
        t = tag.lower()
        if t == 'br':
            self.lines.append(''.join(self.cur).rstrip())
            self.cur = []
        elif t == 'div':
            if self.cur:
                self.lines.append(''.join(self.cur).rstrip())
                self.cur = []
        elif t == 'a':
            for k, v in attrs:
                if k == 'href' and v and 'colorscripter.com' in v:
                    self.in_cs_footer = True

    def handle_endtag(self, tag):
        t = tag.lower()
        if t == 'div':
            if self.cur:
                self.lines.append(''.join(self.cur).rstrip())
                self.cur = []
        elif t == 'a':
            self.in_cs_footer = False

    def handle_data(self, data):
        if self.in_cs_footer:
            return
        txt = data.replace('\xa0', ' ').replace('\u2003', ' ')
        if '\n' in txt and not txt.strip():
            return
        self.cur.append(txt.replace('\r', '').replace('\n', ''))


def extract_colorscripter_table(cs_html):
    tds = re.findall(r'<td[^>]*>(.*?)</td>', cs_html, re.S | re.I)
    target = tds[1] if len(tds) >= 2 else cs_html
    p = CodeCellParser()
    p.feed(target)
    p.close()
    if p.cur:
        p.lines.append(''.join(p.cur).rstrip())
    lines = [l for l in p.lines if 'Colored by Color Scripter' not in l]
    while lines and not lines[0].strip():
        lines.pop(0)
    while lines and not lines[-1].strip():
        lines.pop()
    return '\n'.join(lines)


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
        resp = requests.get(clean_url, headers={'User-Agent': 'Mozilla/5.0'}, timeout=15)
        resp.raise_for_status()
        with open(fpath, 'wb') as f:
            f.write(resp.content)
        return {'local': web_path, 'remote': clean_url}
    except Exception as e:
        print(f"Warning: Failed to download image {clean_url}: {e}")
        return {'local': clean_url, 'remote': clean_url}


def parse_html_segment(html_fragment, qid, is_answer=False):
    codes = []
    tables = []
    images = []

    frag = re.sub(r'<script[^>]*>.*?</script>', '', html_fragment, flags=re.S | re.I)
    frag = re.sub(r'<ins[^>]*class="adsbygoogle"[^>]*>.*?</ins>', '', frag, flags=re.S | re.I)
    frag = re.sub(r'\(adsbygoogle\s*=\s*window\.adsbygoogle\s*\|\|\s*\[\]\)\.push\(\{\}\);?', '', frag, flags=re.I)

    img_idx = 1
    def repl_img(match):
        nonlocal img_idx
        tag = match.group(0)
        m_src = re.search(r'src="([^"]+)"', tag, re.I)
        if m_src:
            src_u = m_src.group(1)
            if 'no-image' not in src_u:
                local_obj = download_image(src_u, qid, img_idx)
                img_idx += 1
                images.append(local_obj)
        return ""
    frag = re.sub(r'<figure[^>]*>.*?<img[^>]+>.*?</figure>|<img[^>]+>', repl_img, frag, flags=re.S | re.I)

    def repl_cs(match):
        c = extract_colorscripter_table(match.group(0))
        if c:
            codes.append(c)
        return "\n"
    frag = re.sub(r'<table[^>]*class="[^"]*colorscripter-code-table[^"]*"[^>]*>.*?</table>', repl_cs, frag, flags=re.S | re.I)
    frag = re.sub(r'<table[^>]*>(?:(?!</table).)*?(?:Colored by Color Scripter|colorscripter\.com).*?</table>', repl_cs, frag, flags=re.S | re.I)

    def repl_pre(match):
        inner = match.group(1)
        inner = re.sub(r'<br\s*/?>', '\n', inner, flags=re.I)
        inner = re.sub(r'<[^>]+>', '', inner)
        inner = unescape(inner).replace('\xa0', ' ').strip()
        if inner:
            codes.append(inner)
        return "\n"
    frag = re.sub(r'<pre[^>]*>(.*?)</pre>', repl_pre, frag, flags=re.S | re.I)

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
                c_lines = [re.sub(r'[ \t]{2,}', ' ', cl).strip() for cl in c_txt.split('\n') if cl.strip()]
                clean_cells.append('\n'.join(c_lines))
            if any(clean_cells):
                parsed_rows.append(clean_cells)
        if parsed_rows:
            if len(parsed_rows) == 1 and len(parsed_rows[0]) == 1:
                cell_content = parsed_rows[0][0]
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

    frag = re.sub(r'</?(?:p|div|h[1-6]|li|ul|ol|blockquote)[^>]*>', '\n', frag, flags=re.I)
    frag = re.sub(r'<br\s*/?>', '\n', frag, flags=re.I)
    frag = re.sub(r'<[^>]+>', '', frag)
    frag = unescape(frag).replace('\xa0', ' ').replace('\u2003', ' ').replace('\u200b', '')

    lines = []
    for l in frag.split('\n'):
        ls = re.sub(r'[ \t]{2,}', ' ', l).strip()
        if not ls or ls in ('반응형', 'Colored by Color Scripter', 'cs'):
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
            if re.match(r'^(\[보기\]|\[학생\]|\[성적\]|조건\s*:|결과값\s*$|결과\s*테이블\s*$)', l):
                in_code = False
                if l not in ('결과값', '결과 테이블'):
                    q_lines.append(l)
            else:
                c_lines.append(l)
        else:
            q_lines.append(l)
    while c_lines and c_lines[-1] in ('결과값', '결과 테이블'):
        c_lines.pop()
    return q_lines, '\n'.join(c_lines)


def flatten_tables_text(tables):
    parts = []
    for t in tables or []:
        if t.get('type') == 'box':
            parts.append(t.get('content', ''))
        elif t.get('type') == 'grid':
            for r in t.get('rows', []):
                parts.append(' '.join(r))
    return '\n'.join(parts)


def classify_question(header, q_body, code_snippet, answer_text, tables=None):
    tbl_text = flatten_tables_text(tables)
    full_text = f"{header}\n{q_body}\n{tbl_text}\n{code_snippet}"

    if re.search(r'(?:Java|자바)\s*(?:소스\s*)?코드|(?:Java|자바)의\s*문제|(?:Java|자바)에\s*대한|밑줄에\s*들어갈\s*키워드', header, re.I) or re.search(r'System\.out\.|public\s+static\s+void\s+main|class\s+\w+\s+extends|implements\s+\w+|println\s*\(', full_text):
        if not re.search(r'JavaScript', full_text, re.I):
            return 'Java', 'java'

    if re.search(r'파이썬|Python', header, re.I) or (code_snippet and re.search(r'def\s+\w+\s*\(|print\s*\(|lambda\s+', code_snippet) and not re.search(r'#include|System\.out|printf', code_snippet)):
        return 'Python', 'python'

    if re.search(r'C\s*언어|C\s*코드', header, re.I) or re.search(r'#include\b|scanf\s*\(|int\s+main\s*\(|void\s+main\s*\(|printf\s*\(|struct\s+\w+\s*\{', full_text):
        if not re.search(r'데니스\s*리치', full_text):
            if code_snippet or re.search(r'출력|결과|코드|알맞는\s*값|배열|C\s*언어|C\s*코드|기호', header, re.I):
                return 'C언어', 'c'

    if re.search(r'SQL|SELECT\b.*FROM\b|INSERT\s+INTO\b|UPDATE\b.*SET\b|DELETE\s+FROM\b|CREATE\s+TABLE\b|ALTER\s+TABLE\b|CREATE\s+INDEX\b|CREATE\s+DOMAIN\b|GRANT\b.*TO\b|UNION\b', full_text, re.I):
        if not re.search(r'Injection|인젝션', full_text, re.I):
            if code_snippet or re.search(r'SQL|쿼리|문장|구문|결과|출력|튜플|카운트|인덱스\s*생성|도메인을\s*정의|데이터\s*삽입', full_text, re.I):
                return 'SQL', 'sql'

    if re.search(r'디자인\s*패턴|GoF|생성\s*패턴|구조\s*패턴|행위\s*패턴|Singleton|Factory|Builder|Prototype|Adapter|Bridge|Composite|Decorator|Facade|Flyweight|Proxy|Observer|Strategy|Template\s*Method|Command|Iterator|Visitor|Mediator|Memento|Chain\s*of', full_text, re.I):
        return '디자인 패턴', None
    if re.search(r'살충제\s*패러독스|테스트|테스팅|커버리지|동등\s*분할|동치\s*분할|경계값|화이트\s*박스|블랙\s*박스|오라클|인스펙션|워크스루|V\s*모델|(?:^|[\s,(·])결함', full_text, re.I):
        return '소프트웨어 테스트/품질', None
    if re.search(r'결합도|응집도|Coupling|Cohesion', full_text, re.I):
        return '결합도/응집도', None
    if re.search(r'UML|다이어그램|액터|유스케이스|시퀀스|럼바우|기능적\s*요구사항|비기능적', full_text, re.I):
        return '요구사항/UML/설계', None
    if re.search(r'애자일|스크럼|XP|폭포수|나선형|형상\s*통제|형상\s*관리|형상\s*감사|릴리스\s*노트|버전\s*관리|Git|SVN|CVS|LoC|COCOMO|기능\s*점수|Fan-in|Fan-out|공통\s*모듈|리팩토링', full_text, re.I):
        return '소프트웨어 공학/방법론', None
    if re.search(r'정규형|정규화|비정규화|반정규화|이상\s*현상|함수적\s*종속|1NF|2NF|3NF|BCNF|4NF|5NF|DB\s*설계|데이터베이스\s*설계|개념적\s*설계|논리적\s*설계|물리적\s*설계|외부\s*스키마|개념\s*스키마|내부\s*스키마|스키마|파일\s*구조|인덱스|해싱\s*접근', full_text, re.I):
        return '데이터베이스(설계/정규화)', None
    if re.search(r'관계\s*대수|관계\s*해석|카디널리티|차수|튜플|도메인|기본키|외래키|슈퍼키|후보키|대체키|무결성|릴레이션|Degree|Cardinality|Attribute|R%S|디비전', full_text, re.I):
        return '데이터베이스(관계대수/구조)', None
    if re.search(r'트랜잭션|원자성|일관성|격리성|영속성|ACID|회복|Rollback|Commit|Redo|Undo|체크포인트|지연\s*갱신|즉시\s*갱신|병행\s*제어|로킹', full_text, re.I):
        return '데이터베이스(트랜잭션/회복)', None
    if re.search(r'AJAX|SOAP|REST|RESTful|WSDL|UDDI|EAI|ESB|웹\s*서비스|웹서비스', full_text, re.I):
        return '인터페이스/연계/웹기술', None
    if re.search(r'ICMP|ARP|RARP|OSPF|RIP|BGP|L2TP|HDLC|NAT\b|ATM\b|해밍|Hamming|CRC|서브넷|CIDR|IPv4|IPv6|OSI\s*7|회선\s*교환|데이터그램|가상\s*회선', full_text, re.I):
        return '네트워크/프로토콜', None
    if re.search(r'보안|암호|대칭키|비대칭키|공개키|RSA|AES|DES|SEED|ARIA|IDEA|SKIPJACK|SHA|MD5|스니핑|스푸핑|스머프|랜드\s*어택|DDoS|웜|바이러스|랜섬웨어|트로이\s*목마|AAA|접근\s*통제|접근통제|DAC|MAC\b|RBAC|XSS|SQL\s*Injection|세션\s*하이재킹|기밀성|무결성|가용성|IPSec|SSL|TLS|SSH\b|OAuth|침입|템퍼\s*프루핑|템퍼프루핑', full_text, re.I):
        return '보안/암호학', None
    if re.search(r'네트워크|라우팅|프로토콜|TCP|UDP|핸드셰이크|토폴로지|애드혹|Ad-hoc|DNS|DHCP|MAC\s*주소|스위칭|패킷', full_text, re.I):
        return '네트워크/프로토콜', None
    if re.search(r'스케줄링|FCFS|SJF|SRT|RR\b|라운드로빈|HRN|페이지\s*교체|FIFO|LRU|LFU|NUR|OPT|스래싱|워킹셋|PFF|교착상태|데드락|상호배제|상태\s*전이도', full_text, re.I):
        return '운영체제(스케줄링/메모리)', None
    if re.search(r'리눅스|유닉스|명령어|chmod|chown|fork|ls\b|pwd|grep|find|cat\b|kill|ps\b|데니스\s*리치', full_text, re.I):
        return '운영체제(명령어/기초)', None
    if re.search(r'인터페이스|JSON|XML', full_text, re.I):
        return '인터페이스/연계/웹기술', None
    return '소프트웨어 일반/신기술', None


def determine_question_format(header, q_body, code_snippet, sub_type):
    full_q = f"{header}\n{q_body}"
    if sub_type in ('C언어', 'Java', 'Python'):
        if re.search(r'밑줄|빈칸|괄호|알맞는\s*키워드|알맞은\s*코드|알맞는\s*연산자|알맞는\s*값|기호를\s*작성', header):
            return '코드 빈칸 완성형'
        return '코드 출력 결과형'
    if sub_type == 'SQL':
        if re.search(r'결과값|결과\s*테이블|출력되는', full_q):
            return 'SQL 결과 도출형'
        if re.search(r'작성하시오|구문을\s*완성|빈칸|괄호|쿼리를\s*작성', full_q):
            return 'SQL 작성·빈칸형'
        return 'SQL 결과 도출형'
    if re.search(r'서술하시오|설명하시오|약술하시오|약술하십시오|개념을\s*쓰시오|목적에\s*대하여', full_q):
        return '서술·약술형'
    if re.search(r'계산식|몇\s*개|횟수를|시간을\s*구하시오|결과값을\s*작성|할당\s*가능한.*IP|부재\s*횟수|우선순위|평균\s*대기시간', full_q):
        return '수식·계산 도출형'
    if re.search(r'보기에서|보기에\s*골라|보기에\s*맞게|기호를\s*골라|기호로\s*쓰시오|나열하시오|고르시오', full_q):
        return '보기·기호 선택형'
    if re.search(r'괄호|빈칸|\(\s*\)|\[\s*\]', full_q):
        return '괄호 빈칸 채우기형'
    return '핵심 용어 단답형'


def generate_auto_explanation(header, body, code, ans, sub_type):
    if sub_type == 'C언어':
        hints = ["[C언어 실행 과정 분석]"]
        if '*' in code or '&' in code or '->' in code:
            hints.append("• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.")
        if 'for' in code or 'while' in code:
            hints.append("• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.")
        if 'void ' in code or 'int ' in code:
            hints.append("• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.")
        hints.append(f"• 표준 출력(printf) 형식 지정자에 따라 최종 도출되는 정답은 [{ans}] 입니다.")
        return '\n'.join(hints)
    elif sub_type == 'Java':
        hints = ["[Java 객체지향 실행 과정 분석]"]
        if 'extends' in code or 'super' in code:
            hints.append("• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)")
        if 'static' in code:
            hints.append("• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.")
        hints.append(f"• System.out 출력문 및 조건 로직에 따라 최종 도출되는 정답은 [{ans}] 입니다.")
        return '\n'.join(hints)
    elif sub_type == 'Python':
        hints = ["[Python 코드 실행 과정 분석]"]
        if ':' in code and '[' in code:
            hints.append("• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)")
        hints.append("• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 문자열·입출력 처리를 반영합니다.")
        hints.append(f"• 실행 결과로 최종 도출되는 정답은 [{ans}] 입니다.")
        return '\n'.join(hints)
    elif sub_type == 'SQL':
        return (
            f"[SQL 질의 분석 및 풀이]\n"
            f"• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML·집합 연산(UNION) 제약 규칙을 적용합니다.\n"
            f"• 조건 필터링 및 집계·정렬 규칙을 반영한 최종 정답은 [{ans}] 입니다."
        )
    else:
        return (
            f"[{sub_type} 핵심 개념 해설]\n"
            f"• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [{ans}] 입니다.\n"
            f"• 학습 가이드: [{sub_type}] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요."
        )


def split_answer_and_explanation(moreless_lines, qid, q_header, q_body, code_snippet, sub_type):
    if not moreless_lines:
        return "복원 답안 참조", generate_auto_explanation(q_header, q_body, code_snippet, "복원 답안", sub_type)

    joined_ml = '\n'.join(moreless_lines)
    if sub_type == 'SQL' and re.match(r'^\s*(?:SELECT|INSERT|INSTER|UPDATE|DELETE|CREATE|ALTER|DROP|GRANT|REVOKE)\b', joined_ml, re.I):
        sql_ans = []
        exp_rest = []
        in_exp = False
        for l in moreless_lines:
            if not in_exp and not re.search(r'(입니다|합니다|이므로|때문에|해설\s*:)', l):
                sql_ans.append(l)
            else:
                in_exp = True
                exp_rest.append(l)
        ans_str = '\n'.join(sql_ans).strip()
        exp_str = '\n'.join(exp_rest).strip() or generate_auto_explanation(q_header, q_body, code_snippet, ans_str, sub_type)
        return ans_str, exp_str

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


def shift_existing_2024_plus_images(existing_questions):
    """Rename q_<old_id>_<idx>.png for old_id >= 201 -> q_<old_id+60>_<idx>.png safely in 2 phases."""
    renames = []
    for q in existing_questions:
        if q['year'] >= 2024:
            old_qid = q['question_id']
            new_qid = old_qid + 60
            for idx, im in enumerate(q.get('images', []), 1):
                old_local = im.get('local', '')
                if old_local.startswith('/images/questions/'):
                    old_fname = os.path.basename(old_local)
                    new_fname = f"q_{new_qid:03d}_{idx}.png"
                    old_path = os.path.join(IMG_DIR, old_fname)
                    new_path = os.path.join(IMG_DIR, new_fname)
                    if old_fname != new_fname and os.path.exists(old_path):
                        renames.append((old_path, new_path))
                    im['local'] = f"/images/questions/{new_fname}"
            q['images_json'] = json.dumps(q.get('images', []), ensure_ascii=False)

    # Two-phase rename to avoid any filename collisions
    temp_map = []
    for old_path, new_path in renames:
        tmp_path = old_path + ".tmp_shift"
        if os.path.exists(old_path):
            os.rename(old_path, tmp_path)
            temp_map.append((tmp_path, new_path))
    for tmp_path, new_path in temp_map:
        if os.path.exists(new_path):
            os.remove(new_path)
        os.rename(tmp_path, new_path)
    if temp_map:
        print(f"Shifted {len(temp_map)} existing 2024~2026 image files (+60 QID offset).")


def fetch_and_parse_2023():
    parsed_rounds = []
    parsed_questions = []
    pat = re.compile(
        r'<div[^>]*data-ke-type="moreLess"[^>]*>.*?<a[^>]*>더보기</a>\s*<div class="moreless-content">(.*?)</div>\s*</div>',
        flags=re.S | re.I
    )
    q_global_id = 201

    for r_id, r_name, yr, r_num, url in ROUNDS_2023:
        print(f"Fetching {r_name}: {url}")
        resp = requests.get(url, headers={'User-Agent': 'Mozilla/5.0'}, timeout=20)
        resp.raise_for_status()
        html = resp.text

        m_art = re.search(r'<div class=["\'](?:tt_article_useless_p_margin|contents_style)[^>]*>(.*)', html, re.S)
        if m_art:
            html = m_art.group(1)
        html = re.sub(r'<table[^>]*>(?:(?!</table).)*?클릭하면 해당 페이지로 이동됩니다.*?</table\s*>', '', html, flags=re.S | re.I)

        pos = 0
        q_num = 1
        theory_cnt = 0
        code_cnt = 0

        for m in pat.finditer(html):
            q_html = html[pos:m.start()]
            ans_html = m.group(1)
            pos = m.end()

            q_lines, q_codes, q_tables, q_images = parse_html_segment(q_html, q_global_id, is_answer=False)
            ans_lines, ans_codes, ans_tables, _ = parse_html_segment(ans_html, q_global_id, is_answer=True)

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

            sub_type, code_lang = classify_question(header, q_body, code_snippet, '\n'.join(ans_lines), tables=q_tables)
            minor_id = MINOR_NAME_TO_ID[sub_type]
            major_id = MINOR_ID_TO_MAJOR[minor_id]

            if major_id == 2:
                code_cnt += 1
            else:
                theory_cnt += 1

            q_format = determine_question_format(header, q_body, code_snippet, sub_type)
            ans_text, exp_text = split_answer_and_explanation(ans_lines, q_global_id, header, q_body, code_snippet, sub_type)

            # Fix minor source typos cleanly while preserving meaning
            if r_num == 2 and q_num == 4 and 'INSTER INTO' in ans_text:
                ans_text = ans_text.replace('INSTER INTO', 'INSERT INTO')
            if r_num == 3 and q_num == 5 and ans_text.strip() == '→':
                ans_text = '-> (→)'
            if r_num == 3 and q_num == 17 and '(1) laas' in ans_text:
                ans_text = ans_text.replace('(1) laas', '(1) IaaS')

            parsed_questions.append({
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
                'source_url': url,
            })
            q_global_id += 1
            q_num += 1

        if q_num - 1 != 20:
            raise RuntimeError(f"Expected 20 questions for {r_name}, got {q_num - 1}")

        parsed_rounds.append({
            'round_id': r_id,
            'year': yr,
            'round_num': r_num,
            'round_title': r_name,
            'source_url': url,
            'total_questions': q_num - 1,
            'theory_count': theory_cnt,
            'code_count': code_cnt,
        })
        print(f"  Parsed {r_name}: 20 questions (theory={theory_cnt}, code={code_cnt})")

    return parsed_rounds, parsed_questions


def compute_analytics(all_questions, rounds_meta):
    total_rounds = len(rounds_meta)
    total_q_count = len(all_questions)
    analytics_rows = []
    for minor_id, major_id, minor_code, minor_name, desc in CATEGORIES_MINOR:
        qs = [q for q in all_questions if q['minor_id'] == minor_id]
        q_cnt = len(qs)
        r_ids = sorted(list(set(q['round_id'] for q in qs)))
        r_app = len(r_ids)

        if r_app > 1:
            diffs = [r_ids[i] - r_ids[i - 1] for i in range(1, r_app)]
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
            'format_distribution': fmt_dist,
        })
    return analytics_rows


def build_sqlite(target_db_path, rounds_meta, all_questions, analytics_rows, predicted_questions):
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
    chk = cur.execute("PRAGMA integrity_check").fetchone()[0]
    assert chk == 'ok', f"SQLite integrity check failed: {chk}"
    with open(SQL_DUMP_PATH, 'w', encoding='utf-8') as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")
    conn.close()


def sync_index_html(export_payload):
    with open(INDEX_HTML_PATH, 'r', encoding='utf-8') as f:
        idx_html = f.read()

    rdb_json_str = json.dumps(export_payload, ensure_ascii=False, indent=2)
    idx_html, n_sub = re.subn(
        r'<script id="rdbDataScript">\s*window\.RDB_DATA\s*=\s*\{.*?\};\s*</script>',
        lambda m: f'<script id="rdbDataScript">\n    window.RDB_DATA = {rdb_json_str};\n  </script>',
        idx_html,
        flags=re.S
    )
    assert n_sub == 1, f"Expected 1 rdbDataScript block, matched {n_sub}"

    total_rounds = len(export_payload['exam_rounds'])
    total_qs = len(export_payload['questions'])
    total_all = total_qs + len(export_payload['predicted_questions'])

    idx_html = idx_html.replace('19개 회차', f'{total_rounds}개 회차')
    idx_html = idx_html.replace('380문항', f'{total_qs}문항')
    idx_html = idx_html.replace('정보처리기사 실기 (400)', f'정보처리기사 실기 ({total_all})')
    idx_html = idx_html.replace('cnt / 380', f'cnt / {total_qs}')
    idx_html = idx_html.replace('/ 19회', f'/ {total_rounds}회')
    idx_html = idx_html.replace('selectedRoundId: 19,', f'selectedRoundId: {total_rounds},')
    idx_html = idx_html.replace('// 기본 선택: 2024년 1회', '// 기본 선택: 최신 회차 (2026년 3회)')

    # Make analytics KPI cards dynamically computed from window.RDB_DATA (idempotent across reruns)
    old_kpi_block = re.search(
        r'(?:const visualCnt = .*?)?const kpiGrid = document\.getElementById\(\'analyticsKpiGrid\'\);\s*kpiGrid\.innerHTML = `.*?`;',
        idx_html,
        flags=re.S
    )
    if old_kpi_block:
        dynamic_kpi = """const visualCnt = data.questions.reduce((acc, q) => acc + (q.images ? q.images.length : 0) + (q.tables ? q.tables.length : 0), 0);
      const recentRounds = data.exam_rounds.filter(r => r.year >= 2024);
      const recentCodeAvgPct = recentRounds.length
        ? (recentRounds.reduce((s, r) => s + (r.code_count / r.total_questions) * 100, 0) / recentRounds.length).toFixed(1)
        : '0.0';
      const recentCodeAvgCnt = recentRounds.length
        ? (recentRounds.reduce((s, r) => s + r.code_count, 0) / recentRounds.length).toFixed(1)
        : '0.0';
      const topCodes = [...data.category_analytics].filter(c => c.major_id === 2).sort((a, b) => b.total_questions - a.total_questions);
      const topTheories = [...data.category_analytics].filter(c => c.major_id === 1).sort((a, b) => b.total_questions - a.total_questions);
      const topImminent = [...data.category_analytics].sort((a, b) => b.imminence_index - a.imminence_index).slice(0, 3);

      const kpiGrid = document.getElementById('analyticsKpiGrid');
      kpiGrid.innerHTML = `
        <div class="bg-[var(--card)] border border-[var(--border)] rounded-xl p-3.5 shadow-sm">
          <div class="text-xs text-[var(--muted-foreground)]">수록 기출 데이터 총계</div>
          <div class="text-lg font-bold mt-1">${data.questions.length}문항 <span class="text-xs font-normal text-blue-500">(${data.exam_rounds.length}개 회차 완비)</span></div>
          <div class="text-xs text-[var(--muted-foreground)] mt-1">이론 ${theoryCnt}문항 · 코드 ${codeCnt}문항 · 시각·표 자료 ${visualCnt}건</div>
        </div>
        <div class="bg-[var(--card)] border border-[var(--border)] rounded-xl p-3.5 shadow-sm">
          <div class="text-xs text-[var(--muted-foreground)]">최근 회차(2024~2026) 코드 비중</div>
          <div class="text-lg font-bold mt-1 text-amber-500">평균 ${recentCodeAvgPct}% <span class="text-xs font-normal">(회차당 ${recentCodeAvgCnt}문항)</span></div>
          <div class="text-xs text-[var(--muted-foreground)] mt-1">2020년 초기(27.5%) 대비 코드 중요도 대폭 상승</div>
        </div>
        <div class="bg-[var(--card)] border border-[var(--border)] rounded-xl p-3.5 shadow-sm">
          <div class="text-xs text-[var(--muted-foreground)]">최다 빈출 코드 / 이론 주제</div>
          <div class="text-lg font-bold mt-1 text-emerald-500">${escapeHtml(topCodes[0]?.minor_name || '-')} (${topCodes[0]?.total_questions || 0}) · ${escapeHtml(topCodes[1]?.minor_name || '-')} (${topCodes[1]?.total_questions || 0})</div>
          <div class="text-xs text-[var(--muted-foreground)] mt-1">이론 1위: ${escapeHtml(topTheories[0]?.minor_name || '-')}(${topTheories[0]?.total_questions || 0}문항) · 2위: ${escapeHtml(topTheories[1]?.minor_name || '-')}(${topTheories[1]?.total_questions || 0}문항)</div>
        </div>
        <div class="bg-[var(--card)] border border-[var(--border)] rounded-xl p-3.5 shadow-sm">
          <div class="text-xs text-[var(--muted-foreground)]">출제 주기 도래 (🔥 출제 유력 주제)</div>
          <div class="text-lg font-bold mt-1 text-rose-500 truncate" title="${topImminent.map(x => escapeHtml(x.minor_name)).join(' · ')}">${topImminent.map(x => escapeHtml(x.minor_name.split('(')[0])).join(' · ')}</div>
          <div class="text-xs text-[var(--muted-foreground)] mt-1">평균 출제 간격 대비 미출제 경과가 긴 우선 학습 대상</div>
        </div>
      `;"""
        idx_html = idx_html[:old_kpi_block.start()] + dynamic_kpi + idx_html[old_kpi_block.end():]

    # IME-safe Enter submit guard
    idx_html = idx_html.replace(
        "onkeydown=\"if(event.key==='Enter') checkSingleAnswer('${uKey}')\"",
        "onkeydown=\"if(event.key==='Enter' && !event.isComposing && event.keyCode!==229){event.preventDefault(); checkSingleAnswer('${uKey}');}\""
    )

    # Also update fallback fetch to try ./data/eip_rdb_export.json first
    idx_html = idx_html.replace(
        "const res = await fetch('/api/init');",
        "const res = await fetch('./data/eip_rdb_export.json').catch(() => fetch('/api/init'));"
    )

    with open(INDEX_HTML_PATH, 'w', encoding='utf-8') as f:
        f.write(idx_html)


def main():
    with open(JSON_EXPORT_PATH, 'r', encoding='utf-8') as f:
        existing = json.load(f)

    existing_rounds = existing['exam_rounds']
    existing_questions = existing['questions']
    predicted_questions = existing['predicted_questions']

    has_2023 = any(r['year'] == 2023 for r in existing_rounds)

    if not has_2023:
        assert len(existing_rounds) == 19, f"Expected 19 existing rounds, got {len(existing_rounds)}"
        assert len(existing_questions) == 380, f"Expected 380 existing questions, got {len(existing_questions)}"
        shift_existing_2024_plus_images(existing_questions)
        rounds_pre = [r for r in existing_rounds if r['year'] <= 2022]
        rounds_post = []
        for r in existing_rounds:
            if r['year'] >= 2024:
                r_copy = dict(r)
                r_copy['round_id'] = r['round_id'] + 3
                rounds_post.append(r_copy)

        qs_pre = [q for q in existing_questions if q['year'] <= 2022]
        qs_post = []
        for q in existing_questions:
            if q['year'] >= 2024:
                q_copy = dict(q)
                q_copy['round_id'] = q['round_id'] + 3
                q_copy['question_id'] = q['question_id'] + 60
                qs_post.append(q_copy)
    else:
        print("2023 rounds already present in existing JSON; re-fetching 2023 and preserving non-2023 rows.")
        rounds_pre = [r for r in existing_rounds if r['year'] <= 2022]
        rounds_post = [r for r in existing_rounds if r['year'] >= 2024]
        qs_pre = [q for q in existing_questions if q['year'] <= 2022]
        qs_post = [q for q in existing_questions if q['year'] >= 2024]

    rounds_2023, qs_2023 = fetch_and_parse_2023()

    rounds_meta = rounds_pre + rounds_2023 + rounds_post
    all_questions = qs_pre + qs_2023 + qs_post

    # Validate chronological order and sequential IDs
    rounds_meta.sort(key=lambda r: (r['year'], r['round_num']))
    all_questions.sort(key=lambda q: (q['year'], q['round_num'], q['question_num']))
    for idx, r in enumerate(rounds_meta, 1):
        assert r['round_id'] == idx, f"Round ID mismatch at {idx}: {r}"
    for idx, q in enumerate(all_questions, 1):
        assert q['question_id'] == idx, f"Question ID mismatch at {idx}: {q['round_title']} #{q['question_num']}"

    analytics_rows = compute_analytics(all_questions, rounds_meta)

    build_sqlite(DB_PATH, rounds_meta, all_questions, analytics_rows, predicted_questions)

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
        'predicted_questions': predicted_questions,
    }

    with open(JSON_EXPORT_PATH, 'w', encoding='utf-8') as f:
        json.dump(export_payload, f, ensure_ascii=False, indent=2)

    sync_index_html(export_payload)

    print(f"DONE! {len(rounds_meta)} rounds, {len(all_questions)} past questions, {len(predicted_questions)} predicted questions.")


if __name__ == '__main__':
    main()
