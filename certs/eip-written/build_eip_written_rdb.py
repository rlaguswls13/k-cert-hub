"""
Build RDB (SQLite + SQL dump + JSON export) for 정보처리기사 필기 (EIP Written CBT).

Sources (public open-source learning repository):
  - 4 official Q-Net / 전자문제집 CBT (comcbt.com) past written exams (.hwp):
      2021-05-15 (2021년 2회), 2021-08-14 (2021년 3회),
      2022-03-05 (2022년 1회), 2022-04-24 (2022년 2회)
  - 5 subject study summary documents (.docx) parsed via zipfile + xml.etree.ElementTree.

Only self-contained text/code 4-option questions (excluding image-dependent HWP GSO items)
are included so every question renders completely and grades accurately.
"""

import argparse
import json
import os
import re
import sqlite3
import struct
import zipfile
import zlib
import xml.etree.ElementTree as ET
from collections import Counter

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(PROJECT_DIR, 'data')
os.makedirs(DATA_DIR, exist_ok=True)

DB_PATH = os.path.join(DATA_DIR, 'eip_written_exam.db')
SQL_DUMP_PATH = os.path.join(DATA_DIR, 'schema_and_data.sql')
JSON_EXPORT_PATH = os.path.join(DATA_DIR, 'eip_written_rdb_export.json')

DEFAULT_REPO_DIR = (
    r'C:\Users\rlagu\.gemini\antigravity\brain\50520b56-1f0f-4aae-809e-fae52b556413'
    r'\scratch\repos\Engineer_Information_Processing'
)

EXAMS = [
    (1, '2021년 2회 (2021.05.15)', 2021, '2021-05-15', '정보처리기사20210515(해설집).hwp'),
    (2, '2021년 3회 (2021.08.14)', 2021, '2021-08-14', '정보처리기사20210814(해설집).hwp'),
    (3, '2022년 1회 (2022.03.05)', 2022, '2022-03-05', '정보처리기사20220305(해설집).hwp'),
    (4, '2022년 2회 (2022.04.24)', 2022, '2022-04-24', '정보처리기사20220424(해설집).hwp'),
]

DOMAINS = [
    {
        'domain_id': 1,
        'domain_code': 'SUB1_SW_DESIGN',
        'domain_name': '1과목 소프트웨어 설계',
        'short_name': '소프트웨어 설계',
        'question_range': '1~20번',
        'description': '요구사항 확인, SDLC/애자일, 화면 설계(UI/UX), UML/애플리케이션 설계, 공통 모듈·디자인 패턴',
        'docx_file': '정보처리기사 필기, 1과목 소프트웨어 설계 무료공유.docx',
    },
    {
        'domain_id': 2,
        'domain_code': 'SUB2_SW_DEV',
        'domain_name': '2과목 소프트웨어 개발',
        'short_name': '소프트웨어 개발',
        'question_range': '21~40번',
        'description': '자료구조(스택·큐·트리·정렬/검색), 데이터 입출력 구현, 통합 구현, 패키징/형상관리, 애플리케이션 테스트',
        'docx_file': '정보처리기사 필기, 2과목 소프트웨어 개발 무료공유.docx',
    },
    {
        'domain_id': 3,
        'domain_code': 'SUB3_DB',
        'domain_name': '3과목 데이터베이스 구축',
        'short_name': '데이터베이스 구축',
        'question_range': '41~60번',
        'description': '논리/물리 DB 설계, 정규화/이상현상, 관계대수/관계해석, SQL(DDL/DML/DCL), 트랜잭션·병행제어·분산 DB',
        'docx_file': '정보처리기사 필기, 3과목 데이터베이스 구축 무료공유.docx',
    },
    {
        'domain_id': 4,
        'domain_code': 'SUB4_LANG',
        'domain_name': '4과목 프로그래밍 언어 활용',
        'short_name': '프로그래밍 언어 활용',
        'question_range': '61~80번',
        'description': '서버/개발환경 구축, C/Java/Python 언어 문법·연산자·자료구조, 운영체제(프로세스·메모리·유닉스), 네트워크(TCP/IP·서브넷)',
        'docx_file': '정보처리기사 필기, 4과목 프로그래밍 언어 활용 무료공유.docx',
    },
    {
        'domain_id': 5,
        'domain_code': 'SUB5_IS_MGMT',
        'domain_name': '5과목 정보시스템 구축관리',
        'short_name': '정보시스템 구축관리',
        'question_range': '81~100번',
        'description': '소프트웨어 개발 방법론·비용산정(COCOMO/LOC/FP), 프로젝트 일정관리(PERT/CPM), IT 신기술, 보안·암호·시큐어 코딩',
        'docx_file': '정보처리기사 필기, 5과목 정보시스템 구축 관리 무료공유.docx',
    },
]

DOMAIN_BY_ID = {d['domain_id']: d for d in DOMAINS}
CIRCLE_MARKS = ['①', '②', '③', '④']
KEY_MAP = {'①': 0, '②': 1, '③': 2, '④': 3}

# Domain-specific supplement for ultra-short community explanations
SHORT_EXPLANATION_HINTS = {
    (2, 67): 'Java 연산자 우선순위는 단항(--, ++, !) > 산술(*, /, %, +, -) > 시프트 > 관계(>, <, >=, <=) > 비트(&, ^, |) > 논리(&&, ||) > 삼항 > 대입(=, +=) 순입니다. 따라서 단항(--)가 가장 높고 대입(>= 와 혼동 주의, 문제에서는 대입/복합연산자 기준) 및 우선순위 체계를 비교해 정답을 고릅니다.',
    (3, 63): 'TCP/IP 프로토콜 스택은 네트워크 액세스 계층, 인터넷 계층(IP, ICMP, ARP, RARP), 전송 계층(TCP, UDP), 응용 계층(HTTP, FTP, SMTP, TELNET, DNS, SNMP)으로 구성됩니다.',
    (4, 92): '폭포수 모형은 각 단계를 순차적으로 완료한 뒤 다음 단계로 넘어가는 고전적 생명주기 모형으로, 중간 요구사항 변경이 어렵습니다. 반면 프로토타입/나선형/애자일 모형은 반복·점진적 개발에 적합합니다.',
}


def read_ole_streams(filepath):
    """Read streams from an OLE2 Compound Document (.hwp v5) using stdlib struct."""
    with open(filepath, 'rb') as f:
        data = f.read()

    sector_shift = struct.unpack_from('<H', data, 0x1E)[0]
    sector_size = 1 << sector_shift
    mini_sector_shift = struct.unpack_from('<H', data, 0x20)[0]
    mini_sector_size = 1 << mini_sector_shift
    fat_sectors_count = struct.unpack_from('<I', data, 0x2C)[0]
    first_dir_sector = struct.unpack_from('<I', data, 0x30)[0]
    mini_cutoff = struct.unpack_from('<I', data, 0x38)[0]
    first_minifat_sector = struct.unpack_from('<I', data, 0x3C)[0]
    first_difat_sector = struct.unpack_from('<I', data, 0x44)[0]
    num_difat_sectors = struct.unpack_from('<I', data, 0x48)[0]

    def sec_off(s):
        return (s + 1) * sector_size

    difat = list(struct.unpack_from('<109I', data, 0x4C))
    cur_difat = first_difat_sector
    for _ in range(num_difat_sectors):
        if cur_difat >= 0xFFFFFFFA:
            break
        off = sec_off(cur_difat)
        difat.extend(struct.unpack_from(f'<{sector_size // 4 - 1}I', data, off))
        cur_difat = struct.unpack_from('<I', data, off + sector_size - 4)[0]

    fat = []
    for s in difat[:fat_sectors_count]:
        if s >= 0xFFFFFFFA:
            continue
        off = sec_off(s)
        fat.extend(struct.unpack_from(f'<{sector_size // 4}I', data, off))

    def read_chain(start_sec):
        out = bytearray()
        s = start_sec
        seen = set()
        while s < 0xFFFFFFFA and s not in seen:
            seen.add(s)
            off = sec_off(s)
            out.extend(data[off:off + sector_size])
            s = fat[s]
        return bytes(out)

    dir_bytes = read_chain(first_dir_sector)
    entries = []
    for i in range(0, len(dir_bytes), 128):
        ent = dir_bytes[i:i + 128]
        if len(ent) < 128:
            break
        name_len = struct.unpack_from('<H', ent, 0x40)[0]
        obj_type = ent[0x42]
        if obj_type == 0:
            continue
        name = ent[:max(0, name_len - 2)].decode('utf-16le', errors='ignore')
        start_sec = struct.unpack_from('<I', ent, 0x74)[0]
        stream_size = (
            struct.unpack_from('<Q', ent, 0x78)[0]
            if sector_size == 4096
            else struct.unpack_from('<I', ent, 0x78)[0]
        )
        entries.append((name, obj_type, start_sec, stream_size))

    root_ent = entries[0]
    mini_stream = read_chain(root_ent[2])[:root_ent[3]] if root_ent[2] < 0xFFFFFFFA else b''
    minifat_bytes = read_chain(first_minifat_sector) if first_minifat_sector < 0xFFFFFFFA else b''
    minifat = list(struct.unpack_from(f'<{len(minifat_bytes) // 4}I', minifat_bytes)) if minifat_bytes else []

    def read_mini_chain(start_sec, size):
        out = bytearray()
        s = start_sec
        seen = set()
        while s < 0xFFFFFFFA and s not in seen and len(out) < size:
            seen.add(s)
            off = s * mini_sector_size
            out.extend(mini_stream[off:off + mini_sector_size])
            s = minifat[s]
        return bytes(out[:size])

    streams = {}
    for name, obj_type, start_sec, size in entries:
        if obj_type == 2:
            streams[name] = (
                read_mini_chain(start_sec, size) if size < mini_cutoff else read_chain(start_sec)[:size]
            )
    return streams


def parse_hwp_paragraphs(filepath):
    """Extract (level, text, embedded_obj_ids) tuples from HWP5 Section streams."""
    streams = read_ole_streams(filepath)
    fh = streams.get('FileHeader', b'')
    compressed = bool(struct.unpack_from('<I', fh, 36)[0] & 1) if len(fh) >= 40 else False
    paras = []

    for sname in sorted(k for k in streams if k.startswith('Section')):
        raw = zlib.decompress(streams[sname], -15) if compressed else streams[sname]
        pos = 0
        while pos + 4 <= len(raw):
            hdr = struct.unpack_from('<I', raw, pos)[0]
            pos += 4
            tag_id = hdr & 0x3FF
            level = (hdr >> 10) & 0x3FF
            size = (hdr >> 20) & 0xFFF
            if size == 0xFFF:
                size = struct.unpack_from('<I', raw, pos)[0]
                pos += 4
            rec = raw[pos:pos + size]
            pos += size
            if tag_id == 67:  # HWPTAG_PARA_TEXT
                chars = []
                objs = []
                i = 0
                while i + 1 < len(rec):
                    code = struct.unpack_from('<H', rec, i)[0]
                    if code < 32:
                        # Extended / inline controls occupy 8 wchars (16 bytes) in HWP5
                        if code in (1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23):
                            if code == 9:
                                chars.append(' ')
                            elif code == 11:
                                cid = rec[i + 2:i + 6][::-1].decode('ascii', errors='ignore')
                                objs.append(cid)
                            i += 16
                            continue
                        elif code in (10, 13):
                            chars.append('\n')
                        elif code == 24:
                            chars.append('-')
                        elif code in (30, 31):
                            chars.append(' ')
                        i += 2
                    else:
                        chars.append(chr(code))
                        i += 2
                txt = ''.join(chars).replace('\r', '').replace('\xa0', ' ').replace('\ufeff', '').strip()
                paras.append((level, txt, objs))
    return paras


def extract_answer_key(paras):
    start_idx = -1
    for idx, (_, txt, _) in enumerate(paras):
        if '오답 및 오탈자' in txt:
            start_idx = idx
            break
    if start_idx == -1:
        raise RuntimeError("Could not locate answer key table in HWP file.")
    answers = []
    for _, txt, _ in paras[start_idx:]:
        t = txt.strip()
        if t in KEY_MAP:
            answers.append(KEY_MAP[t])
    if len(answers) != 100:
        raise RuntimeError(f"Expected 100 answer key entries, got {len(answers)}")
    return {i + 1: ans for i, ans in enumerate(answers)}


def split_choices(q_part):
    idxs = [q_part.find(m) for m in CIRCLE_MARKS]
    if any(i == -1 for i in idxs) or not (idxs[0] < idxs[1] < idxs[2] < idxs[3]):
        return None, None
    stem = q_part[:idxs[0]].strip()
    choices = [
        re.sub(r'[ \t]{2,}', ' ', q_part[idxs[i] + 1:idxs[i + 1]].strip()).replace('\n', ' ')
        for i in range(3)
    ]
    choices.append(re.sub(r'[ \t]{2,}', ' ', q_part[idxs[3] + 1:].strip()).replace('\n', ' '))
    return stem, choices


def make_clean_title(stem):
    """Build a concise, clean, non-empty topic title from a question stem."""
    s = re.sub(r'^\d{1,3}\.\s*', '', stem).strip()
    s = re.sub(r'\s+', ' ', s)
    # Remove trailing question prompt phrases to make title scannable
    short = re.sub(
        r'\s*(?:에\s*대한\s*설명으로\s*(?:틀린|옳지\s*않은|옳은|거리가\s*먼|가장\s*적절하지\s*않은)\s*것은\??|'
        r'(?:으로|로)\s*(?:틀린|옳지\s*않은|옳은|가장\s*옳은|가장\s*적합한|가장\s*적절한|가장\s*거리가\s*먼|아닌|해당하지\s*않는|해당하는)\s*것은\??|'
        r'을\s*무엇이라\s*하는가\??|무엇인가\??)\s*$',
        '',
        s
    ).strip()
    candidate = short if len(short) >= 10 else s
    if len(candidate) > 68:
        cut = candidate[:65]
        if ' ' in cut[25:]:
            cut = cut.rsplit(' ', 1)[0]
        candidate = cut + '…'
    return candidate


def extract_keywords(stem, choices, explanation):
    text = f"{stem} {' '.join(choices)} {explanation}"
    # English acronyms / technical terms (2+ chars, avoid common filler)
    stop_en = {'is', 'are', 'the', 'and', 'for', 'not', 'with', 'from', 'that', 'this', 'use', 'used', 'comcbt', 'com', 'www'}
    en_terms = []
    seen = set()
    for tok in re.findall(r'\b[A-Za-z][A-Za-z0-9\-\+/]{1,22}\b', text):
        tl = tok.lower()
        if tl in stop_en or tl.isdigit():
            continue
        if tl not in seen:
            seen.add(tl)
            en_terms.append(tok)
        if len(en_terms) >= 4:
            break

    # Add key Korean CS noun compounds if we need more keywords
    ko_patterns = [
        '다이어그램', '요구사항', '애자일', '프로토타입', '폭포수', '나선형', '미들웨어',
        '디자인 패턴', '결합도', '응집도', '정규화', '이상현상', '관계대수', '트랜잭션',
        '인덱스', '뷰', '병행제어', '로킹', '스택', '큐', '트리', '정렬', '해싱',
        '화이트박스', '블랙박스', '테스트', '형상관리', '비용산정', '서브네팅',
        '프로토콜', '스케줄링', '교착상태', '페이지 교체', '접근통제', '암호화', '시큐어 코딩',
        '프레임워크', '객체지향', '캡슐화', '다형성', '상속', '모듈화', '인터페이스',
    ]
    ko_terms = []
    for kp in ko_patterns:
        if kp in text and kp.lower() not in seen:
            seen.add(kp.lower())
            ko_terms.append(kp)
        if len(en_terms) + len(ko_terms) >= 6:
            break

    kws = (en_terms + ko_terms)[:6]
    if not kws:
        # Fallback to first meaningful Korean words in stem
        words = [w for w in re.findall(r'[가-힣]{2,10}', stem) if w not in ('다음', '설명', '대한', '것은', '틀린', '옳은', '아닌')]
        kws = words[:4] or ['정보처리기사', '필기']
    return kws


def parse_multi_answer_note(stem, default_idx):
    """Detect official Q-Net multiple-answer or all-correct rulings inside stem notes."""
    indices = [default_idx]
    ruling_note = ''
    m_all = re.search(r'\((문제\s*오류로[^)]*모두\s*정답처리[^)]*)\)', stem)
    m_multi = re.search(r'\((문제\s*오류로[^)]*확정\s*답안\s*발표시\s*([0-9,\s]+)번이\s*정답처리[^)]*)\)', stem)
    if m_all:
        indices = [0, 1, 2, 3]
        ruling_note = '※ 공식 확정답안 안내: 출제 오류로 전원 정답(①~④ 모두 정답) 처리된 문항입니다.'
        stem = stem.replace(m_all.group(0), '').strip()
    elif m_multi:
        nums = [int(n) - 1 for n in re.findall(r'\d+', m_multi.group(2)) if 1 <= int(n) <= 4]
        if nums:
            indices = sorted(set(nums))
        ruling_note = f"※ 공식 확정답안 안내: 복수 정답({', '.join(CIRCLE_MARKS[i] for i in indices)}) 인정 문항입니다."
        stem = stem.replace(m_multi.group(0), '').strip()
    return stem, indices, ruling_note


def clean_explanation(exp_raw, round_id, qn, ans_text, ruling_note):
    txt = re.sub(r'\[해설작성자\s*:[^\]]*\]', '', exp_raw)
    lines = [re.sub(r'[ \t]{2,}', ' ', l).strip() for l in txt.split('\n')]
    lines = [l for l in lines if l]
    cleaned = '\n'.join(lines).strip()

    hint = SHORT_EXPLANATION_HINTS.get((round_id, qn))
    if hint:
        cleaned = f"{cleaned}\n{hint}" if cleaned else hint
    elif len(cleaned) < 20:
        cleaned = f"{cleaned}\n• 정답은 [{ans_text}] 입니다." if cleaned else f"• 정답은 [{ans_text}] 입니다."

    if ruling_note:
        cleaned = f"{ruling_note}\n{cleaned}"
    return cleaned.strip()


def extract_docx_study_notes(repo_dir):
    ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
    notes = []
    note_id = 1
    for dom in DOMAINS:
        fp = os.path.join(repo_dir, dom['docx_file'])
        if not os.path.exists(fp):
            continue
        with zipfile.ZipFile(fp) as z:
            root = ET.fromstring(z.read('word/document.xml'))
        paras = []
        for p in root.findall('.//w:p', ns):
            t = ''.join(x.text for x in p.findall('.//w:t', ns) if x.text).strip()
            t = re.sub(r'\s+', ' ', t)
            if t:
                paras.append(t)

        # Group high-yield headings (★★ or ★★★) with up to 6 bullet lines
        cur_title = None
        cur_pts = []
        dom_notes = []
        for line in paras:
            if line.startswith('<') or line.startswith('1. 꼭 알아야') or line.startswith('2. # =') or line.startswith('3. 시나공') or line.startswith('4. “Ctrl+F'):
                continue
            if '★★' in line:
                if cur_title and cur_pts:
                    dom_notes.append((cur_title, cur_pts[:6]))
                clean_h = re.sub(r'\s*__\s*.*$', '', line)
                clean_h = re.sub(r'\s*\(모델 사진 출처:[^)]*\)', '', clean_h)
                clean_h = clean_h.strip()
                cur_title = clean_h
                cur_pts = []
            elif cur_title is not None:
                if re.match(r'^(p\.\d|#|\-|▶|\d+\))', line):
                    if line.startswith('p.'):
                        continue
                    cleaned_pt = line.lstrip('-▶ ').strip()
                    if len(cleaned_pt) >= 6 and cleaned_pt not in cur_pts:
                        cur_pts.append(cleaned_pt)
                if len(cur_pts) >= 6:
                    dom_notes.append((cur_title, cur_pts))
                    cur_title = None
                    cur_pts = []
        if cur_title and cur_pts:
            dom_notes.append((cur_title, cur_pts[:6]))

        for t_title, t_pts in dom_notes[:12]:
            notes.append({
                'note_id': note_id,
                'domain_id': dom['domain_id'],
                'domain_name': dom['domain_name'],
                'topic_title': t_title,
                'summary_points': t_pts,
                'source_doc': dom['docx_file'],
            })
            note_id += 1
    return notes


def parse_all_exams(repo_dir):
    all_questions = []
    rounds_meta = []
    q_global_id = 1

    for r_id, r_title, yr, exam_date, fname in EXAMS:
        fp = os.path.join(repo_dir, fname)
        paras = parse_hwp_paragraphs(fp)
        akey = extract_answer_key(paras)

        cur_q = 0
        q_paras = {}
        q_has_gso = {}
        for lvl, txt, objs in paras:
            if '오답 및 오탈자' in txt:
                break
            m = re.match(r'^(\d{1,3})\.\s+(.+)', txt, re.S)
            if m and lvl == 1:
                qn = int(m.group(1))
                if qn == cur_q + 1 and 1 <= qn <= 100:
                    cur_q = qn
                    q_paras[cur_q] = []
                    q_has_gso[cur_q] = False
            if cur_q > 0:
                if any(o != 'tbl ' for o in objs):
                    q_has_gso[cur_q] = True
                if txt:
                    if any(b in txt for b in (
                        '전자문제집 CBT', '최강 자격증 기출문제', '기출문제 및 해설집 다운로드',
                        '본 해설집의 저작권', '카페, 블로그등', '오답 및 오탈자가 수정된',
                    )):
                        continue
                    if re.match(r'^\d과목\s*:', txt):
                        continue
                    q_paras[cur_q].append(txt)

        r_subj_counts = Counter()
        r_total = 0
        src_label = f"한국산업인력공단 기출문제 · 전자문제집 CBT 해설집 ({exam_date})"

        for qn in range(1, 101):
            if q_has_gso.get(qn, True):
                continue
            full_q = '\n'.join(q_paras[qn])
            if '<문제 해설>' not in full_q:
                continue
            q_part, exp_part = full_q.split('<문제 해설>', 1)
            stem_raw, choices = split_choices(q_part)
            if not stem_raw or not choices or any(not c for c in choices):
                continue

            domain_id = ((qn - 1) // 20) + 1
            domain_name = DOMAIN_BY_ID[domain_id]['domain_name']

            stem_clean, ans_indices, ruling_note = parse_multi_answer_note(stem_raw, akey[qn])
            stem_clean = re.sub(r'^\d{1,3}\.\s*', '', stem_clean).strip()
            stem_clean = re.sub(r'[ \t]{2,}', ' ', stem_clean)

            ans_idx = ans_indices[0]
            if len(ans_indices) == 1:
                ans_text = f"{CIRCLE_MARKS[ans_idx]} {choices[ans_idx]}"
            elif len(ans_indices) == 4:
                ans_text = f"①~④ 전원 정답 인정 (가답안: {CIRCLE_MARKS[akey[qn]]} {choices[akey[qn]]})"
            else:
                ans_text = " / ".join(f"{CIRCLE_MARKS[i]} {choices[i]}" for i in ans_indices) + " (복수정답 인정)"

            explanation = clean_explanation(exp_part, r_id, qn, ans_text, ruling_note)
            title = make_clean_title(stem_clean)
            keywords = extract_keywords(stem_clean, choices, explanation)

            all_questions.append({
                'question_id': q_global_id,
                'round_id': r_id,
                'round_title': r_title,
                'question_no': qn,
                'exam_stage': '필기',
                'domain_id': domain_id,
                'domain_name': domain_name,
                'qtype': '객관식 4지선다',
                'title': title,
                'question_text': stem_clean,
                'code_or_log': '',
                'choices': choices,
                'answer_index': ans_idx,
                'answer_indices': ans_indices,
                'answer_text': ans_text,
                'explanation': explanation,
                'keywords': keywords,
                'source': src_label,
            })

            r_subj_counts[domain_id] += 1
            r_total += 1
            q_global_id += 1

        rounds_meta.append({
            'round_id': r_id,
            'round_title': r_title,
            'exam_year': yr,
            'exam_date': exam_date,
            'agency': '한국산업인력공단 (Q-Net)',
            'source': src_label,
            'total_questions': r_total,
            'subject_counts': {str(k): r_subj_counts[k] for k in range(1, 6)},
        })
        print(f"Parsed {r_title}: {r_total} clean questions -> {dict(sorted(r_subj_counts.items()))}")

    return rounds_meta, all_questions


def compute_domain_analytics(all_questions, rounds_meta):
    total_q = len(all_questions)
    analytics = []
    for dom in DOMAINS:
        did = dom['domain_id']
        qs = [q for q in all_questions if q['domain_id'] == did]
        kw_counter = Counter(k for q in qs for k in q['keywords'])
        top_kws = [k for k, _ in kw_counter.most_common(6)]
        multi_cnt = sum(1 for q in qs if len(q['answer_indices']) > 1)
        analytics.append({
            'domain_id': did,
            'domain_name': dom['domain_name'],
            'short_name': dom['short_name'],
            'total_questions': len(qs),
            'share_pct': round(len(qs) / total_q * 100, 1) if total_q else 0.0,
            'round_appearances': len(set(q['round_id'] for q in qs)),
            'multi_answer_count': multi_cnt,
            'top_keywords': top_kws,
        })
    return analytics


def build_sqlite(rounds_meta, domains_out, all_questions, analytics, study_notes):
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.executescript("""
    PRAGMA foreign_keys = ON;

    CREATE TABLE rounds (
        round_id INTEGER PRIMARY KEY,
        round_title TEXT NOT NULL,
        exam_year INTEGER NOT NULL,
        exam_date TEXT NOT NULL,
        agency TEXT NOT NULL,
        source TEXT NOT NULL,
        total_questions INTEGER NOT NULL
    );

    CREATE TABLE domains (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL UNIQUE,
        domain_name TEXT NOT NULL,
        short_name TEXT NOT NULL,
        question_range TEXT NOT NULL,
        description TEXT NOT NULL,
        question_count INTEGER NOT NULL
    );

    CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY,
        round_id INTEGER NOT NULL,
        question_no INTEGER NOT NULL,
        exam_stage TEXT NOT NULL,
        domain_id INTEGER NOT NULL,
        qtype TEXT NOT NULL,
        title TEXT NOT NULL,
        question_text TEXT NOT NULL,
        code_or_log TEXT,
        choices_json TEXT NOT NULL,
        answer_index INTEGER NOT NULL,
        answer_indices_json TEXT NOT NULL,
        answer_text TEXT NOT NULL,
        explanation TEXT NOT NULL,
        keywords_json TEXT NOT NULL,
        source TEXT NOT NULL,
        FOREIGN KEY (round_id) REFERENCES rounds(round_id),
        FOREIGN KEY (domain_id) REFERENCES domains(domain_id)
    );

    CREATE TABLE domain_analytics (
        domain_id INTEGER PRIMARY KEY,
        domain_name TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        share_pct REAL NOT NULL,
        round_appearances INTEGER NOT NULL,
        multi_answer_count INTEGER NOT NULL,
        top_keywords TEXT NOT NULL,
        FOREIGN KEY (domain_id) REFERENCES domains(domain_id)
    );

    CREATE TABLE study_notes (
        note_id INTEGER PRIMARY KEY,
        domain_id INTEGER NOT NULL,
        topic_title TEXT NOT NULL,
        summary_points_json TEXT NOT NULL,
        source_doc TEXT NOT NULL,
        FOREIGN KEY (domain_id) REFERENCES domains(domain_id)
    );

    CREATE VIEW v_cbt_exam AS
    SELECT
        q.question_id, r.round_title, q.question_no, q.exam_stage,
        d.domain_name, q.qtype, q.title, q.question_text, q.code_or_log,
        q.choices_json, q.source
    FROM questions q
    JOIN rounds r ON q.round_id = r.round_id
    JOIN domains d ON q.domain_id = d.domain_id;

    CREATE VIEW v_cbt_explain AS
    SELECT
        q.question_id, r.round_title, q.question_no, q.exam_stage,
        d.domain_name, q.qtype, q.title, q.question_text, q.code_or_log,
        q.choices_json, q.answer_index, q.answer_indices_json, q.answer_text,
        q.explanation, q.keywords_json, q.source
    FROM questions q
    JOIN rounds r ON q.round_id = r.round_id
    JOIN domains d ON q.domain_id = d.domain_id;

    CREATE INDEX idx_written_round ON questions(round_id);
    CREATE INDEX idx_written_domain ON questions(domain_id);
    CREATE INDEX idx_written_qno ON questions(question_no);
    """)

    for r in rounds_meta:
        cur.execute(
            "INSERT INTO rounds VALUES (?, ?, ?, ?, ?, ?, ?)",
            (r['round_id'], r['round_title'], r['exam_year'], r['exam_date'], r['agency'], r['source'], r['total_questions']),
        )

    for d in domains_out:
        cur.execute(
            "INSERT INTO domains VALUES (?, ?, ?, ?, ?, ?, ?)",
            (d['domain_id'], d['domain_code'], d['domain_name'], d['short_name'], d['question_range'], d['description'], d['question_count']),
        )

    for q in all_questions:
        cur.execute(
            "INSERT INTO questions VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                q['question_id'], q['round_id'], q['question_no'], q['exam_stage'],
                q['domain_id'], q['qtype'], q['title'], q['question_text'], q['code_or_log'],
                json.dumps(q['choices'], ensure_ascii=False),
                q['answer_index'],
                json.dumps(q['answer_indices'], ensure_ascii=False),
                q['answer_text'], q['explanation'],
                json.dumps(q['keywords'], ensure_ascii=False),
                q['source'],
            ),
        )

    for a in analytics:
        cur.execute(
            "INSERT INTO domain_analytics VALUES (?, ?, ?, ?, ?, ?, ?)",
            (a['domain_id'], a['domain_name'], a['total_questions'], a['share_pct'], a['round_appearances'], a['multi_answer_count'], ', '.join(a['top_keywords'])),
        )

    for n in study_notes:
        cur.execute(
            "INSERT INTO study_notes VALUES (?, ?, ?, ?, ?)",
            (n['note_id'], n['domain_id'], n['topic_title'], json.dumps(n['summary_points'], ensure_ascii=False), n['source_doc']),
        )

    conn.commit()
    chk = cur.execute("PRAGMA integrity_check").fetchone()[0]
    assert chk == 'ok', f"SQLite integrity check failed: {chk}"
    with open(SQL_DUMP_PATH, 'w', encoding='utf-8') as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")
    conn.close()


def main():
    parser = argparse.ArgumentParser(description='Build 정보처리기사 필기 CBT RDB')
    parser.add_argument('--repo', default=DEFAULT_REPO_DIR, help='Path to Engineer_Information_Processing repo')
    args = parser.parse_args()

    rounds_meta, all_questions = parse_all_exams(args.repo)
    study_notes = extract_docx_study_notes(args.repo)
    analytics = compute_domain_analytics(all_questions, rounds_meta)

    domains_out = []
    for dom in DOMAINS:
        cnt = sum(1 for q in all_questions if q['domain_id'] == dom['domain_id'])
        domains_out.append({
            'domain_id': dom['domain_id'],
            'domain_code': dom['domain_code'],
            'domain_name': dom['domain_name'],
            'short_name': dom['short_name'],
            'question_range': dom['question_range'],
            'description': dom['description'],
            'question_count': cnt,
        })

    build_sqlite(rounds_meta, domains_out, all_questions, analytics, study_notes)

    payload = {
        'meta': {
            'cert_id': 'eip-written',
            'title': '정보처리기사 필기 CBT 기출 RDB · 5과목 과락방지 학습 플랫폼',
            'exam_stage': '필기',
            'rounds_count': len(rounds_meta),
            'questions_count': len(all_questions),
            'domains_count': len(domains_out),
            'notes_count': len(study_notes),
            'rounds_range': f"{rounds_meta[0]['round_title']} ~ {rounds_meta[-1]['round_title']} ({len(rounds_meta)}개 회차)",
            'pass_rule': '과목당 20문항(과락 40점 미만 시 불합격), 전 과목 평균 60점 이상 합격',
            'updated_at': '2026-11-26',
        },
        'rounds': rounds_meta,
        'domains': domains_out,
        'analytics': analytics,
        'study_notes': study_notes,
        'questions': all_questions,
    }

    with open(JSON_EXPORT_PATH, 'w', encoding='utf-8') as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)

    print(
        f"Built eip-written RDB: {len(all_questions)} questions across {len(rounds_meta)} rounds, "
        f"{len(study_notes)} study notes."
    )


if __name__ == '__main__':
    main()
