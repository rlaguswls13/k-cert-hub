BEGIN TRANSACTION;
CREATE TABLE categories_domain (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL UNIQUE,
        domain_name TEXT NOT NULL,
        subject_id INTEGER NOT NULL REFERENCES categories_subject(subject_id),
        description TEXT NOT NULL
    );
INSERT INTO "categories_domain" VALUES(1,'MODEL_BASIC','1과목 · 데이터 모델링 · 엔터티 · 식별자',1,'모델링 3요소/3단계, ANSI-SPARC 3단계 스키마, 엔터티·속성·도메인·관계, ERD(IE/바커), 본질/인조 식별자');
INSERT INTO "categories_domain" VALUES(2,'MODEL_PERF','1과목 · 정규화 · 반정규화 · 성능 모델링',1,'함수적 종속성, 1NF~BCNF 정규화 및 이상현상, 반정규화 기법, 슈퍼/서브타입 변환, 상호배타적 관계, 파티셔닝');
INSERT INTO "categories_domain" VALUES(3,'SQL_BASIC','2과목 · SQL 기본 · 함수 · 관리구문(DML/DDL/TCL/DCL)',2,'SQL 실행순서, CHAR/VARCHAR, NULL 3값 논리, 단일행/집계/CASE 함수, GROUP BY/HAVING/ORDER BY, DML·DDL·TCL·DCL');
INSERT INTO "categories_domain" VALUES(4,'SQL_JOIN_SUB','2과목 · 조인(JOIN) · 서브쿼리 · 집합연산자',2,'EQUI/NON-EQUI/SELF/OUTER/NATURAL/USING/CROSS JOIN, 스칼라/인라인뷰/중첩 서브쿼리, EXISTS/NOT IN, 집합연산자');
INSERT INTO "categories_domain" VALUES(5,'SQL_ADV','2과목 · 그룹함수 · 윈도우함수 · 계층형 질의',2,'ROLLUP/CUBE/GROUPING SETS/GROUPING, RANK/DENSE_RANK/ROW_NUMBER/LAG/LEAD/NTILE/ROWS vs RANGE, START WITH/CONNECT BY');
INSERT INTO "categories_domain" VALUES(6,'SQL_2024','2과목 · 2024 신유형 (Top-N · PIVOT · 정규표현식)',2,'ROWNUM/OFFSET·FETCH/TOP WITH TIES, PIVOT/UNPIVOT(LONG↔WIDE), REGEXP_SUBSTR/REPLACE/INSTR/LIKE/COUNT');
CREATE TABLE categories_qtype (
        qtype_id INTEGER PRIMARY KEY,
        qtype_code TEXT NOT NULL UNIQUE,
        qtype_name TEXT NOT NULL,
        description TEXT NOT NULL
    );
INSERT INTO "categories_qtype" VALUES(1,'MCQ','객관식 4지선다','SQLD 표준 4지선다 CBT 객관식 문항');
INSERT INTO "categories_qtype" VALUES(2,'SHORT','주관식 단답형','핵심 SQL 키워드·함수명·결과값 직접 입력 단답형 문항');
CREATE TABLE categories_subject (
        subject_id INTEGER PRIMARY KEY,
        subject_code TEXT NOT NULL UNIQUE,
        subject_name TEXT NOT NULL,
        weight_pct INTEGER NOT NULL,
        pass_cut INTEGER NOT NULL,
        description TEXT NOT NULL
    );
INSERT INTO "categories_subject" VALUES(1,'SUBJ_1','1과목: 데이터 모델링의 이해',20,40,'데이터 모델링의 이해, 엔터티·속성·관계·식별자, 정규화와 성능 데이터 모델링 (실제 시험 10문항 / 20점)');
INSERT INTO "categories_subject" VALUES(2,'SUBJ_2','2과목: SQL 기본 및 활용',80,40,'SQL 기본, DML/DDL/TCL/DCL, 조인·서브쿼리·집합연산자, 그룹·윈도우·계층형 질의, 2024 신유형 (실제 시험 40문항 / 80점)');
CREATE TABLE domain_analytics (
        domain_id INTEGER PRIMARY KEY REFERENCES categories_domain(domain_id),
        subject_id INTEGER NOT NULL,
        subject_name TEXT NOT NULL,
        domain_name TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        share_pct REAL NOT NULL,
        mcq_count INTEGER NOT NULL,
        short_count INTEGER NOT NULL,
        round_appearances INTEGER NOT NULL
    );
INSERT INTO "domain_analytics" VALUES(1,1,'1과목: 데이터 모델링의 이해','1과목 · 데이터 모델링 · 엔터티 · 식별자',15,13.6,14,1,3);
INSERT INTO "domain_analytics" VALUES(2,1,'1과목: 데이터 모델링의 이해','1과목 · 정규화 · 반정규화 · 성능 모델링',13,11.8,12,1,4);
INSERT INTO "domain_analytics" VALUES(3,2,'2과목: SQL 기본 및 활용','2과목 · SQL 기본 · 함수 · 관리구문(DML/DDL/TCL/DCL)',24,21.8,23,1,4);
INSERT INTO "domain_analytics" VALUES(4,2,'2과목: SQL 기본 및 활용','2과목 · 조인(JOIN) · 서브쿼리 · 집합연산자',20,18.2,18,2,4);
INSERT INTO "domain_analytics" VALUES(5,2,'2과목: SQL 기본 및 활용','2과목 · 그룹함수 · 윈도우함수 · 계층형 질의',22,20.0,19,3,3);
INSERT INTO "domain_analytics" VALUES(6,2,'2과목: SQL 기본 및 활용','2과목 · 2024 신유형 (Top-N · PIVOT · 정규표현식)',16,14.5,14,2,2);
CREATE TABLE exam_rounds (
        round_id INTEGER PRIMARY KEY,
        round_title TEXT NOT NULL,
        exam_year INTEGER NOT NULL,
        exam_date TEXT NOT NULL,
        agency TEXT NOT NULL,
        key_trend TEXT NOT NULL
    );
INSERT INTO "exam_rounds" VALUES(1,'2024 신유형 집중 (PIVOT · Top-N · 정규표현식)',2024,'2024-03-09','K-Data 개정기준','제52회~2026년 개정 출제기준 신유형(PIVOT/UNPIVOT, OFFSET/FETCH, REGEXP_*) 완벽 대비');
INSERT INTO "exam_rounds" VALUES(2,'쪽집게 실전 기출 세트 A (모델링 · SQL 기본)',2023,'2023-06-10','공개 특강·기출복원','엔터티/정규화/식별자, DDL·DML·TCL·DCL, NULL 3값 논리 및 단일행/CASE 함수 핵심');
INSERT INTO "exam_rounds" VALUES(3,'쪽집게 실전 기출 세트 B (조인 · 서브쿼리 · 윈도우 · 계층)',2023,'2023-09-09','공개 특강·기출복원','표준조인/OUTER JOIN, EXISTS/NOT IN, ROLLUP/CUBE, 윈도우 함수(RANK/LAG/LEAD/ROWS) 및 계층형 질의');
INSERT INTO "exam_rounds" VALUES(4,'2024~2026 개정 모의고사 (1과목 20% · 2과목 80%)',2025,'2025-05-31','K-Data 출제기준','실제 SQLD 시험(50문항, 1과목 10 + 2과목 40) 출제 비중 및 과락 기준 반영 실전 모의세트');
INSERT INTO "exam_rounds" VALUES(5,'2026 빈출 함정 & 핵심 단답 마스터',2026,'2026-08-22','K-Data · 통합RDB','K-Cert Hub 핵심 4문항 계승 및 오답률 높은 NULL/반정규화/윈도우프레임/단답형 집중 공략');
CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY AUTOINCREMENT,
        round_id INTEGER NOT NULL REFERENCES exam_rounds(round_id),
        question_no INTEGER NOT NULL,
        subject_id INTEGER NOT NULL REFERENCES categories_subject(subject_id),
        domain_id INTEGER NOT NULL REFERENCES categories_domain(domain_id),
        qtype_id INTEGER NOT NULL REFERENCES categories_qtype(qtype_id),
        title TEXT NOT NULL,
        question_text TEXT NOT NULL,
        code_or_log TEXT NOT NULL DEFAULT '',
        choices_json TEXT NOT NULL DEFAULT '[]',
        answer_index INTEGER NOT NULL DEFAULT -1,
        answer_text TEXT NOT NULL,
        acceptable_answers TEXT NOT NULL DEFAULT '',
        core_keywords TEXT NOT NULL,
        explanation TEXT NOT NULL,
        source TEXT NOT NULL,
        study_tip TEXT NOT NULL
    );
INSERT INTO "questions" VALUES(1,2,1,1,1,1,'데이터 모델링의 3가지 핵심 특징','복잡한 현실 세계의 비즈니스 프로세스와 데이터 구조를 일정한 표기법에 의해 표현하는 데이터 모델링의 3가지 핵심 특징으로 가장 올바르게 짝지어진 것은?','','["추상화(Abstraction), 단순화(Simplification), 명확화(Clarity)", "정규화(Normalization), 추상화(Abstraction), 독립화(Independence)", "단순화(Simplification), 무결성(Integrity), 캡슐화(Encapsulation)", "명확화(Clarity), 종속화(Dependency), 다형화(Polymorphism)"]',0,'① 추상화(Abstraction), 단순화(Simplification), 명확화(Clarity)','','데이터 모델링 특징, 추상화, 단순화, 명확화','데이터 모델링의 3대 특징은 ① 추상화(현실 세계를 일정한 형식에 맞추어 간략하게 표현), ② 단순화(복잡한 현실 세계를 약속된 규약에 의해 제한된 표기법이나 언어로 쉽게 이해할 수 있도록 표현), ③ 명확화(애매모호함을 제거하고 누구나 이해하기 쉽게 정확하게 현상을 기술)입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','1과목 첫 단원 필수 암기: 모델링 3특징(추·단·명) vs 3요소(Things·Attributes·Relationships).');
INSERT INTO "questions" VALUES(2,2,2,1,1,1,'데이터 모델링 시 유의점 3가지 (중복·비유연성·비일관성)','데이터 모델링 시 주의해야 할 3가지 사항 중, 사소한 업무 변화에도 데이터 모델이 수시로 변경되어 유지보수가 어려워지는 현상을 피하기 위해 데이터의 정의를 데이터의 사용 프로세스와 분리해야 한다는 원칙과 관련된 항목은?','','["중복(Duplication)", "비유연성(Inflexibility)", "비일관성(Inconsistency)", "비원자성(Non-Atomicity)"]',1,'② 비유연성(Inflexibility)','','모델링 유의점, 비유연성, 데이터 정의와 프로세스 분리','데이터 모델링의 3대 유의점은 ① 중복(여러 장소에 같은 정보 저장 금지), ② 비유연성(데이터 정의를 프로세스와 분리해 사소한 업무 변화에 잦은 모델 변경 방지), ③ 비일관성(데이터 간 상호 모순 발생 방지, 예: 신용 상태 갱신 시 연관 잔액 정보의 불일치 차단)입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','키워드 매칭: 중복(동일 정보) / 비유연성(프로세스 분리) / 비일관성(모순·상반).');
INSERT INTO "questions" VALUES(3,2,3,1,1,1,'ANSI-SPARC 3단계 스키마 구조와 데이터 독립성','ANSI-SPARC에서 정의한 데이터베이스 3단계 구조(Three-Level Architecture)에서 아래 설명이 가리키는 스키마 구조로 가장 적절한 것은?','• 모든 사용자 관점을 통합한 조직 전체 관점의 통합적 표현
• 모든 응용 시스템들이나 사용자들이 필요로 하는 데이터를 통합한 조직 전체의 DB를 기술한 것으로, DB에 저장되는 데이터와 그들 간의 관계를 표현하는 스키마','["외부 스키마(External Schema)", "개념 스키마(Conceptual Schema)", "내부 스키마(Internal Schema)", "물리 스키마(Physical Schema)"]',1,'② 개념 스키마(Conceptual Schema)','','ANSI-SPARC, 개념 스키마, 논리적 독립성, 물리적 독립성','외부 스키마는 개별 사용자/응용 관점(View), 개념 스키마는 조직 전체의 통합된 논리적 관점, 내부 스키마는 물리적 저장장치 관점입니다. 외부↔개념 사상은 논리적 독립성(개념 스키마가 바뀌어도 외부 스키마 영향 없음), 개념↔내부 사상은 물리적 독립성을 보장합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','외부(사용자) - 개념(조직 전체 통합) - 내부(물리 저장). 논리적/물리적 독립성 사상 구조도 함께 출제됩니다.');
INSERT INTO "questions" VALUES(4,4,4,1,1,1,'데이터 모델링의 3단계 (개념적 · 논리적 · 물리적 모델링)','데이터 모델링의 3단계 중, 업무 중심적이고 포괄적인 수준의 모델링을 수행하며 전사적 데이터 모델링 시 핵심 엔터티와 그들 간의 관계를 발견하여 ERD를 생성하는 단계는?','','["개념적 데이터 모델링(Conceptual Data Modeling)", "논리적 데이터 모델링(Logical Data Modeling)", "물리적 데이터 모델링(Physical Data Modeling)", "객체지향 데이터 모델링(Object-Oriented Data Modeling)"]',0,'① 개념적 데이터 모델링(Conceptual Data Modeling)','','개념적 모델링, 논리적 모델링, 물리적 모델링, 추상화 수준','개념적 모델링은 추상화 수준이 가장 높고 업무 중심적·포괄적으로 핵심 엔터티와 관계를 도출합니다. 논리적 모델링은 키·속성·관계·정규화를 구체화하며 재사용성이 가장 높습니다. 물리적 모델링은 특정 DBMS의 성능·저장구조·인덱스·파티셔닝을 반영하므로 가장 구체적입니다.','SQLD 2024 개정 출제기준 핵심문제','추상화 수준: 개념 > 논리 > 물리 / 재사용성 최고: 논리적 모델링.');
INSERT INTO "questions" VALUES(5,2,5,1,1,1,'ERD(Entity Relationship Diagram) 작성 절차 6단계','IE(Information Engineering) 표기법 등을 활용하여 ERD를 작성하는 일반적인 6단계 절차로 가장 올바른 순서는?','','["엔터티 도출 및 그리기 → 엔터티 배치 → 관계 설정 → 관계명 서술 → 관계의 참여도 기술 → 관계의 필수 여부 확인", "엔터티 배치 → 엔터티 도출 및 그리기 → 관계명 서술 → 관계 설정 → 관계의 필수 여부 확인 → 관계의 참여도 기술", "엔터티 도출 및 그리기 → 관계 설정 → 엔터티 배치 → 관계의 참여도 기술 → 관계명 서술 → 관계의 필수 여부 확인", "엔터티 도출 및 그리기 → 엔터티 배치 → 관계의 참여도 기술 → 관계 설정 → 관계의 필수 여부 확인 → 관계명 서술"]',0,'① 엔터티 도출 및 그리기 → 엔터티 배치 → 관계 설정 → 관계명 서술 → 관계의 참여도 기술 → 관계의 필수 여부 확인','','ERD 작성 순서, 엔터티 배치, 관계의 참여도, 필수 여부','ERD 작성 6단계는 ① 엔터티를 그린다 → ② 엔터티를 적절하게 배치한다(가장 중요한 엔터티를 좌상단에 배치) → ③ 엔터티 간 관계를 설정한다 → ④ 관계명을 기술한다 → ⑤ 관계의 참여도(1:1, 1:M, M:N)를 기술한다 → ⑥ 관계의 필수 여부를 기술한다 순서입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','암기 팁: "도·배·관·명·참·필" (도출→배치→관계설정→관계명→참여도→필수여부).');
INSERT INTO "questions" VALUES(6,2,6,1,1,1,'엔터티(Entity)의 성립 특징으로 부적절한 것','데이터 모델링에서 엔터티(Entity)가 갖추어야 할 특징에 대한 설명으로 가장 부적절한 것은?','','["반드시 해당 업무에서 필요로 하고 관리하고자 하는 정보여야 한다.", "유일한 식별자에 의해 식별이 가능해야 한다.", "영속적으로 존재하는 1개 이상의 인스턴스의 집합이어야 한다.", "반드시 2개 이상의 속성을 가져야 하며 다른 엔터티와 최소 1개 이상의 관계를 가져야 한다."]',2,'③ 영속적으로 존재하는 1개 이상의 인스턴스의 집합이어야 한다.','','엔터티 특징, 인스턴스 2개 이상, 속성 2개 이상, 관계 1개 이상','엔터티는 반드시 영속적으로 존재하는 **2개 이상**의 인스턴스 집합이어야 합니다(단 1건만 존재하는 대상은 엔터티로 보기 어렵습니다). 또한 반드시 속성이 있어야 하며(보통 2개 이상), 업무 프로세스에 의해 이용되고 다른 엔터티와 최소 1개 이상의 관계를 가져야 합니다(통계·코드성 엔터티는 관계 생략 예외 가능).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','인스턴스 2개 이상, 속성 2개 이상, 관계 1개 이상(코드/통계성 엔터티 예외).');
INSERT INTO "questions" VALUES(7,2,7,1,1,1,'엔터티의 분류 (유무형 기준 vs 발생 시점 기준)','엔터티를 발생 시점(Time of Occurrence)에 따라 분류할 때, 업무에서 원래 존재하는 정보로 다른 엔터티로부터 주식별자를 상속받지 않고 자신의 고유한 주식별자를 가지며 사원·부서·고객 등이 해당하는 유형은?','','["기본 엔터티(Fundamental Entity)", "중심 엔터티(Main Entity)", "행위 엔터티(Active Entity)", "개념 엔터티(Conceptual Entity)"]',0,'① 기본 엔터티(Fundamental Entity)','','기본 엔터티, 중심 엔터티, 행위 엔터티, 유형/개념/사건 엔터티','발생 시점 기준 분류는 ① 기본 엔터티(독립 생성, 사원·고객·상품), ② 중심 엔터티(기본 엔터티로부터 발생하며 업무의 중심 역할, 계약·사고·주문·청구), ③ 행위 엔터티(2개 이상의 부모 엔터티로부터 발생하며 내용이 자주 바뀌거나 양이 증가, 주문내역·결제이력)입니다. 개념 엔터티는 유무형 기준(유형/개념/사건) 분류입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','유무형 기준: 유형/개념/사건 | 발생시점 기준: 기본(키엔터티)/중심/행위.');
INSERT INTO "questions" VALUES(8,2,8,1,1,1,'속성(Attribute)의 특성에 따른 분류 — 파생속성','데이터 모델링에서 데이터를 조회할 때 빠른 성능을 낼 수 있도록 하기 위해 원래 속성의 값을 계산하여 미리 저장할 수 있도록 만든 속성에 해당하는 것은?','예) 주문 엔터티의 주문금액 합계(총결제금액), 사원 테이블의 근속연수 또는 평균 급여 컬럼 등','["파생속성(Derived Attribute)", "기본속성(Basic Attribute)", "설계속성(Designed Attribute)", "주식별자 속성(PK Attribute)"]',0,'① 파생속성(Derived Attribute)','','파생속성, 기본속성, 설계속성, 데이터 정합성','특성에 따른 속성 분류는 ① 기본속성(업무로부터 추출한 원래의 속성, 예: 이름·단가), ② 설계속성(업무에 없으나 데이터 모델링 시 규칙화를 위해 새로 만든 속성, 예: 상품코드·일련번호), ③ 파생속성(다른 속성에 영향을 받아 계산·가공되어 발생하는 속성, 예: 합계·평균)입니다. 파생속성은 조회 성능을 높이지만 정합성 유지 관리가 필요합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','파생속성은 데이터 정합성을 해칠 수 있으므로 꼭 필요한 경우에만 최소화하여 설계합니다.');
INSERT INTO "questions" VALUES(9,4,9,1,1,1,'도메인(Domain)의 개념과 속성의 특징','데이터 모델링에서 도메인(Domain)과 속성(Attribute)에 대한 설명으로 가장 부적절한 것은?','','["도메인은 각 속성이 가질 수 있는 값의 범위(데이터 타입, 크기, 제약조건)를 의미한다.", "하나의 엔터티 내에서 각 속성은 반드시 하나의 값(원자값)만을 가져야 한다.", "속성의 명칭이 동일하더라도 엔터티의 특성에 따라 서로 다른 도메인을 가질 수 있다.", "하나의 속성이 여러 개의 값을 갖는 다중값 속성은 별도의 엔터티로 분리하지 않고 콤마(,)로 구분해 저장하는 것이 원칙이다."]',3,'④ 하나의 속성이 여러 개의 값을 갖는 다중값 속성은 별도의 엔터티로 분리하지 않고 콤마(,)로 구분해 저장하는 것이 원칙이다.','','도메인, 원자값, 다중값 속성, 제1정규형','하나의 속성이 여러 개의 값을 갖는 다중값 속성(Multi-Valued Attribute, 예: 하나의 컬럼에 전화번호 여러 개 저장)은 제1정규형(1NF)에 위배되므로 별도의 엔터티(테이블)로 분리해야 합니다.','SQLD 2024 개정 출제기준 핵심문제','속성 = 더 이상 쪼개지지 않는 최소의 데이터 단위(원자성).');
INSERT INTO "questions" VALUES(10,4,10,1,1,1,'관계(Relationship)의 구성요소 및 존재/행위 관계','엔터티 간의 관계(Relationship)에 대한 설명으로 가장 부적절한 것은?','','["관계의 표기법에는 관계명(Membership), 관계차수(Cardinality), 관계선택사양(Optionality) 세 가지 개념이 포함된다.", "존재에 의한 관계의 예로 \"사원은 부서에 소속된다\"를 들 수 있다.", "행위에 의한 관계의 예로 \"고객이 주문을 한다\"를 들 수 있다.", "ERD에서는 존재에 의한 관계와 행위에 의한 관계를 실선과 점선으로 엄격히 구분하여 표기한다."]',3,'④ ERD에서는 존재에 의한 관계와 행위에 의한 관계를 실선과 점선으로 엄격히 구분하여 표기한다.','','관계의 구성요소, 존재 관계, 행위 관계, IE 표기법','ERD(IE 표기법)에서는 존재에 의한 관계와 행위에 의한 관계를 따로 구분해 표기하지 않습니다(클래스 다이어그램에서는 연관/의존으로 구분 가능). IE 표기법에서 실선/점선은 "식별자 관계 vs 비식별자 관계"를 구분하는 표기입니다.','SQLD 2024 개정 출제기준 핵심문제','ERD 실선/점선 = IE에서는 식별/비식별, 바커(Barker)에서는 필수/선택!');
INSERT INTO "questions" VALUES(11,4,11,1,1,1,'ERD 표기법 비교 — IE(까마귀발) 표기법 vs Barker 표기법','데이터 모델링의 두 대표 표기법인 IE(Information Engineering) 표기법과 Barker(바커) 표기법의 비교 설명으로 가장 올바른 것은?','[표기 비교 요약]
- IE 표기법: 관계선 실선/점선, 끝부분 원(O) 또는 막대(|)와 까마귀발
- Barker 표기법: 관계선 실선/점선, UID Bar(|), 엔터티 속성 앞 # / * / ○','["IE 표기법에서 관계선의 점선은 선택적 참여(Optional)를 의미하고, 실선은 필수적 참여를 의미한다.", "Barker 표기법에서 관계선의 점선은 비식별자 관계를 의미하고, 실선은 식별자 관계를 의미한다.", "Barker 표기법에서는 식별자 관계와 비식별자 관계를 UID Bar(|) 유무로 구분하며, 실선/점선은 필수/선택 여부를 나타낸다.", "IE 표기법에서는 속성 앞에 # 기호를 붙여 주식별자(PK)를 표시하고, ○ 기호로 NULL 허용을 표시한다."]',2,'③ Barker 표기법에서는 식별자 관계와 비식별자 관계를 UID Bar(|) 유무로 구분하며, 실선/점선은 필수/선택 여부를 나타낸다.','','IE 표기법, Barker 표기법, UID Bar, 선택적/필수적, 식별/비식별','① IE 표기법에서 실선/점선은 식별/비식별 관계이며, 필수/선택 여부는 관계선 끝의 원(O, 선택) 유무로 표기합니다. ② Barker 표기법에서 실선/점선은 필수/선택 여부이고, 식별/비식별 관계는 관계선 위의 UID Bar(|) 유무로 구분합니다. ④ #/* /○ 표기는 Barker 표기법의 속성 표기입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','매우 잦은 함정! IE(실선=식별, O=선택) vs Barker(실선=필수, UID Bar=식별).');
INSERT INTO "questions" VALUES(12,2,12,1,1,1,'고객과 주문 ERD 참여도(Optionality) 해석','아래 IE 표기법 기준 [고객]과 [주문] 엔터티 간의 관계 규칙을 해석한 내용으로 가장 부적절한 것은?','[고객] ----||--------O<---- [주문]
• 고객 쪽 관계선: 실선 막대(||, 1이며 필수)
• 주문 쪽 관계선: 원 + 까마귀발(O<, 0 이상 선택적 다수)
• 관계선 종류: 점선(비식별자 관계)','["한 명의 고객은 여러 개의 주문을 할 수 있으며, 주문을 아직 하지 않은 고객도 존재할 수 있다.", "하나의 주문은 반드시 한 명의 고객에 의해서만 생성된다.", "주문 테이블에 데이터를 입력할 때는 반드시 고객 테이블에 해당 고객 데이터가 먼저 존재해야 한다.", "고객 테이블에 데이터를 입력할 때는 주문 데이터가 존재하는 고객만을 입력할 수 있다."]',3,'④ 고객 테이블에 데이터를 입력할 때는 주문 데이터가 존재하는 고객만을 입력할 수 있다.','','ERD 해석, Optionality, 부모-자식 엔터티, 참여도','주문 쪽에 선택 표시(O<)가 있으므로 고객은 주문이 없어도(0건) 존재할 수 있습니다. 따라서 신규 고객을 입력할 때 주문 데이터가 미리 존재할 필요는 없습니다. 반면 고객 쪽은 필수(||)이므로 주문 생성 시에는 반드시 고객이 존재해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','까마귀발이 달린 쪽이 자식(M쪽)이며, 반대편(부모 쪽) 기호를 보고 자식이 부모를 필수/선택으로 참조하는지 읽습니다.');
INSERT INTO "questions" VALUES(13,2,13,1,1,1,'주식별자(Primary Identifier)의 4대 특징','엔터티 내에서 각 인스턴스를 유일하게 구분할 수 있는 주식별자가 반드시 만족해야 하는 4가지 특징에 대한 설명으로 가장 부적절한 것은?','','["유일성: 주식별자에 의해 엔터티 내에 모든 인스턴스들을 유일하게 구분해야 한다.", "최소성: 주식별자를 구성하는 속성의 수는 유일성을 만족하는 최소의 수가 되어야 한다.", "불변성: 주식별자가 한 번 특정 엔터티에 지정되면 그 식별자의 값은 변하지 않아야 한다.", "가변성: 업무 요건이 변경될 경우 주식별자 값은 NULL을 허용하여 유연하게 대체할 수 있어야 한다."]',3,'④ 가변성: 업무 요건이 변경될 경우 주식별자 값은 NULL을 허용하여 유연하게 대체할 수 있어야 한다.','','주식별자 특징, 유일성, 최소성, 불변성, 존재성','주식별자의 4대 특징은 ① 유일성, ② 최소성, ③ 불변성, ④ 존재성(주식별자가 지정되면 반드시 데이터 값이 존재해야 하며 NULL 불가)입니다. 가변성이나 NULL 허용은 주식별자 특징에 위배됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','암기 두문자: "유·최·불·존" (유일성, 최소성, 불변성, 존재성).');
INSERT INTO "questions" VALUES(14,4,14,1,1,1,'식별자 분류 기준과 본질식별자 vs 인조식별자','식별자를 대체 여부에 따라 분류한 본질식별자와 인조식별자에 대한 설명으로 가장 부적절한 것은?','• 주문(주문번호[PK], 고객번호)
• 주문상세(주문상세번호[PK], 주문번호[FK], 상품번호, 수량)  <-- 인조식별자 적용 사례','["본질식별자는 업무에 의해 자연스럽게 만들어지는 식별자이다.", "인조식별자는 업무적으로 꼭 필요하지 않지만 원조식별자가 복잡한 구성을 가질 때 인위적으로 만든 식별자이다.", "인조식별자를 사용하면 중복 데이터 발생 가능성이 높아져 데이터 품질이 저하될 수 있다.", "인조식별자를 사용하면 별도의 인덱스가 생성되지 않아 DML 성능이 항상 향상된다."]',3,'④ 인조식별자를 사용하면 별도의 인덱스가 생성되지 않아 DML 성능이 항상 향상된다.','','본질식별자, 인조식별자, 중복 데이터, 불필요한 인덱스','인조식별자(예: 일련번호 주문상세번호)를 PK로 생성하면 DBMS는 해당 PK에 대해 자동으로 UNIQUE INDEX를 생성합니다. 따라서 업무 조건에 불필요한 인덱스가 추가되어 저장공간을 낭비하고 INSERT/UPDATE/DELETE 시 인덱스 유지 비용으로 DML 성능이 저하될 수 있습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','식별자 4가지 분류: 대표성(주/보조), 생성여부(내부/외부), 속성수(단일/복합), 대체여부(본질/인조).');
INSERT INTO "questions" VALUES(15,5,15,1,1,2,'식별자 관계(실선) vs 비식별자 관계(점선) 개념 및 선택 기준','부모 엔터티의 주식별자가 자식 엔터티의 주식별자(PK)에는 포함되지 않고 일반 속성(FK)으로만 상속되어, 약한 종속 관계를 나타내며 IE 표기법에서 점선으로 표시되는 관계의 명칭을 쓰시오. (예: OOO 관계)','[부모 엔터티] 부서(부서코드[PK], 부서명)
       |
       : (점선 - 약한 종속)
       v
[자식 엔터티] 사원(사원번호[PK], 사원명, 부서코드[FK])','[]',-1,'비식별자 관계','비식별자 관계|비식별자관계|비식별 관계|비식별관계','식별자 관계, 비식별자 관계, 점선, 약한 종속, FK','• 식별자 관계(실선): 부모 PK가 자식 PK의 일부가 됨 (강한 종속, 1:1 또는 1:M)
• 비식별자 관계(점선): 부모 PK가 자식의 일반 속성(FK)으로 내려감
• 비식별자 선택 기준: 부모 없이 자식 생성 가능(NULL 허용), 여러 부모를 거쳐 PK 속성이 지나치게 길어져 SQL 조인이 복잡해질 때.','K-Cert Hub SQLD 미니팩 계승 (2024 개정 기준)','식별자 관계가 너무 깊어지면 자식 테이블의 PK 컬럼 수가 폭발하므로, 적정 수준에서 비식별자 관계로 전환하는 것이 실무 모델링의 핵심입니다.');
INSERT INTO "questions" VALUES(16,2,16,1,2,1,'함수적 종속성(Functional Dependency)과 결정자','릴레이션 R에서 속성 X의 값에 따라 속성 Y의 값이 유일하게 결정될 때 "X는 Y를 함수적으로 결정한다(X → Y)"고 한다. 이때 X와 Y의 관계에 대한 설명으로 옳은 것은?','사원(사번, 이름, 주민번호, 부서코드, 부서명)
• 사번 → 이름, 주민번호, 부서코드
• 부서코드 → 부서명','["X를 종속자(Dependent), Y를 결정자(Determinant)라고 한다.", "X를 결정자(Determinant), Y를 종속자(Dependent)라고 한다.", "부서코드 → 부서명 관계에서 부서명이 결정자이고 부서코드가 종속자이다.", "완전 함수 종속이란 기본키의 일부 속성에만 종속되는 경우를 말한다."]',1,'② X를 결정자(Determinant), Y를 종속자(Dependent)라고 한다.','','함수적 종속성, 결정자, 종속자, 완전 함수 종속','X → Y에서 좌변 X가 결정자, 우변 Y가 종속자입니다. 완전 함수 종속은 복합키 전체에 종속되는 경우를 말하며, 기본키의 일부분에만 종속되는 경우는 부분 함수 종속입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','화살표 시작점(X) = 결정자, 화살표 끝점(Y) = 종속자.');
INSERT INTO "questions" VALUES(17,2,17,1,2,1,'정규화가 필요한 이유 — 3대 이상 현상(Anomaly)','정규화되지 않은 테이블에서 발생하는 이상 현상(Anomaly) 중, 특정 학생이 수강을 취소하여 해당 튜플을 삭제할 때 원하지 않았던 강좌와 담당 교수 정보까지 함께 사라지는 현상은?','수강(학번[PK], 과목코드[PK], 학생명, 과목명, 담당교수)
• (202401, CS101, 김철수, 데이터베이스, 이교수) 행 삭제 시
  -> 데이터베이스 과목과 이교수 정보까지 DB에서 영구 소실','["삽입 이상(Insertion Anomaly)", "갱신 이상(Update Anomaly)", "삭제 이상(Deletion Anomaly)", "참조 이상(Reference Anomaly)"]',2,'③ 삭제 이상(Deletion Anomaly)','','이상현상, 삽입 이상, 갱신 이상, 삭제 이상','• 삽입 이상: 새 데이터를 삽입하기 위해 불필요한 데이터(예: 수강생 없는 신설 과목 등록 불가)를 함께 넣어야 하는 현상
• 갱신 이상: 중복된 튜플 중 일부만 수정되어 데이터 불일치 발생
• 삭제 이상: 튜플 삭제 시 연쇄적으로 필요한 다른 정보까지 함께 삭제되는 현상.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','정규화의 궁극적 목적은 중복 제거를 통한 이상 현상(삽입·갱신·삭제) 방지입니다.');
INSERT INTO "questions" VALUES(18,4,18,1,2,1,'제1정규형(1NF) — 도메인의 원자값과 반복 그룹 제거','다음 중 제1정규형(1NF)을 만족하지 못해 제1정규화 대상이 되는 테이블 설계 사례로 가장 적절한 것은?','CASE A: 회원(회원ID[PK], 회원명, 보유자격증1, 보유자격증2, 보유자격증3)
CASE B: 주문(주문번호[PK], 고객번호, 주문일자)
CASE C: 부서(부서코드[PK], 부서명, 위치)','["CASE A — 하나의 속성에 여러 값이 반복되거나 유사 속성(보유자격증1,2,3)이 반복 존재한다.", "CASE B — 고객번호가 주문번호에 종속되어 있다.", "CASE C — 부서명과 위치가 모두 부서코드에 종속되어 있다.", "CASE A, B, C 모두 제1정규형을 만족한다."]',0,'① CASE A — 하나의 속성에 여러 값이 반복되거나 유사 속성(보유자격증1,2,3)이 반복 존재한다.','','제1정규형, 1NF, 원자값, 반복 속성','제1정규형은 모든 속성의 도메인이 원자값(Atomic Value)으로만 구성되어야 하며, 다중값 속성이나 유사한 속성이 반복(보유자격증1, 2, 3 등)되는 경우 별도의 릴레이션(회원자격증)으로 분리하여 1NF를 만족시켜야 합니다.','SQLD 2024 개정 출제기준 핵심문제','정규화 암기법 "도·부·이·결·다·조": 1NF(도메인 원자값), 2NF(부분 종속), 3NF(이행 종속), BCNF(결정자 후보키), 4NF(다치), 5NF(조인).');
INSERT INTO "questions" VALUES(19,2,19,1,2,1,'제2정규형(2NF)과 부분 함수 종속 제거','아래와 같이 [수강지도] 엔터티를 설계하였을 때, 이 엔터티가 현재 만족하는 정규형과 앞으로 수행해야 할 정규화 단계로 가장 바르게 짝지어진 것은?','수강지도(학번[PK], 과목코드[PK], 성적, 지도교수)
• 함수 종속성:
  - (학번, 과목코드) → 성적
  - (학번) → 지도교수   <-- 복합키의 일부에만 종속','["제1정규형 — 제2정규화 대상", "제2정규형 — 제3정규화 대상", "제3정규형 — BCNF 정규화 대상", "BCNF — 제4정규화 대상"]',0,'① 제1정규형 — 제2정규화 대상','','제2정규화, 부분 함수 종속, 복합키, 수강지도','모든 속성이 원자값을 가지므로 제1정규형(1NF)은 만족하지만, 기본키가 (학번, 과목코드)인 복합키에서 일반 속성인 "지도교수"가 기본키 전체가 아닌 일부(학번)에만 종속되는 부분 함수 종속이 존재하므로 제2정규화 대상입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','기본키가 단일 컬럼(1개)인 테이블은 부분 함수 종속 자체가 발생할 수 없으므로 1NF이면 자동으로 2NF도 만족합니다.');
INSERT INTO "questions" VALUES(20,4,20,1,2,1,'제3정규형(3NF)과 이행적 함수 종속 제거','아래 [계좌] 테이블에서 이행적 함수 종속을 제거하기 위해 제3정규화를 수행한 결과로 가장 적절한 테이블 분리 방식은?','계좌(계좌번호[PK], 고객명, 관리점코드, 관리점명)
• 계좌번호 → 고객명, 관리점코드
• 관리점코드 → 관리점명','["계좌(계좌번호[PK], 고객명, 관리점코드[FK])와 관리점(관리점코드[PK], 관리점명)으로 분리", "계좌(계좌번호[PK], 고객명)와 관리점(관리점코드[PK], 관리점명)으로 분리(FK 제거)", "계좌(계좌번호[PK], 관리점코드[PK], 고객명, 관리점명)로 복합키 구성", "이미 모든 결정자가 후보키이므로 추가 분리가 불필요하다."]',0,'① 계좌(계좌번호[PK], 고객명, 관리점코드[FK])와 관리점(관리점코드[PK], 관리점명)으로 분리','','제3정규형, 3NF, 이행적 함수 종속, 외래키','계좌번호 → 관리점코드 → 관리점명의 이행적 함수 종속이 존재합니다. 제3정규화 시 관리점코드(결정자)와 관리점명(종속자)을 별도 테이블(관리점)로 분리하고, 기존 계좌 테이블에는 연결을 위한 외래키(관리점코드)를 남겨둡니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','분리 후 두 테이블을 조인할 수 있도록 결정자 컬럼(관리점코드)을 기존 테이블의 FK로 유지해야 무손실 분해가 됩니다.');
INSERT INTO "questions" VALUES(21,4,21,1,2,1,'BCNF (보이스-코드 정규형) 판별 기준','제3정규형(3NF)을 만족하지만 아래 조건을 갖는 [특강수강] 릴레이션이 BCNF를 위배하는 이유와 해결 방법으로 옳은 것은?','특강수강(학번[PK], 과목명[PK], 교수명)
• 한 학생은 한 과목에 대해 한 명의 교수에게만 수강
• 각 교수는 한 과목만 담당함 (교수명 → 과목명)
• 즉, (학번, 과목명) → 교수명  AND  교수명 → 과목명','["결정자인 \"교수명\"이 후보키가 아니므로, (학번, 교수명)과 (교수명, 과목명)으로 분해한다.", "학번이 교수명을 결정하므로, (학번, 과목명)만 남기고 교수명을 삭제한다.", "이행적 함수 종속이 존재하므로 제3정규화 대상이다.", "복합키가 존재하므로 제2정규화 대상이다."]',0,'① 결정자인 "교수명"이 후보키가 아니므로, (학번, 교수명)과 (교수명, 과목명)으로 분해한다.','','BCNF, 결정자가 후보키, 강한 제3정규형','BCNF는 릴레이션의 모든 결정자가 후보키(Candidate Key)여야 합니다. 위 사례에서 "교수명"은 과목명을 결정하는 결정자이지만 후보키가 아니므로 BCNF에 위배됩니다. 따라서 교수명이 PK가 되는 (교수명, 과목명) 테이블과 (학번, 교수명) 테이블로 분해합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','3NF까지는 일반속성이 키에 종속될 때를 다루고, BCNF는 "후보키의 일부가 일반속성에 종속"될 때(결정자가 후보키가 아닐 때) 분해합니다.');
INSERT INTO "questions" VALUES(22,2,22,1,2,1,'정규화가 데이터베이스 성능(조회 vs 입력·수정)에 미치는 영향','데이터 모델에 대해 정규화를 철저히 수행했을 때 나타나는 성능 및 구조적 변화에 대한 설명으로 가장 부적절한 것은?','','["데이터의 중복이 제거되어 테이블의 크기가 작아지므로 INSERT, UPDATE, DELETE 성능은 대체로 향상된다.", "테이블이 여러 개로 분해됨에 따라 여러 테이블의 데이터를 함께 조회할 때 조인(JOIN)이 발생하여 SELECT 속도가 느려질 수 있다.", "정규화를 수행하면 논리 데이터 모델의 유연성과 데이터 무결성이 향상된다.", "정규화를 수행할수록 테이블 수가 줄어들고 조인 연산이 감소하여 모든 SQL 조회 성능이 항상 빨라진다."]',3,'④ 정규화를 수행할수록 테이블 수가 줄어들고 조인 연산이 감소하여 모든 SQL 조회 성능이 항상 빨라진다.','','정규화 성능, 조인 부하, INSERT/UPDATE 성능 향상, 반정규화','정규화를 수행하면 테이블이 분해되어 테이블 수가 늘어나며, 분산된 데이터를 함께 조회하려면 조인(JOIN)이 필요해 SELECT 성능이 저하될 수 있습니다(단, 한 테이블 내 단일 조회는 행 크기 감소로 오히려 빨라지기도 함). 반면 중복 제거로 인해 입력·수정·삭제(DML) 성능은 향상됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','정규화 = 입력/수정/삭제 성능 UP, 다중 테이블 조회(조인) 부하 증가 가능.');
INSERT INTO "questions" VALUES(23,4,23,1,2,1,'반정규화(De-Normalization)의 개념과 수행 절차','반정규화(De-Normalization)에 대한 설명 및 수행 절차로 가장 부적절한 것은?','','["반정규화는 정규화된 데이터 모델에서 성능 향상과 개발·운영의 단순화를 위해 중복·통합·분리를 수행하는 기법이다.", "비정규화(Un-normalization)는 애초에 정규화를 전혀 수행하지 않은 상태를 뜻하므로 반정규화와 구분된다.", "반정규화 적용 전에는 반드시 반정규화 대상 조사(범위처리 빈도수, 통계처리 여부 등) 후 뷰·클러스터링·인덱스 조정 등 다른 방법을 먼저 검토해야 한다.", "반정규화를 수행하면 항상 데이터 무결성이 강화되고 데이터 모델의 유연성이 높아진다."]',3,'④ 반정규화를 수행하면 항상 데이터 무결성이 강화되고 데이터 모델의 유연성이 높아진다.','','반정규화 절차, 비정규화 차이, 다른 방법 검토, 무결성 저하','반정규화는 데이터 중복을 허용하므로 데이터의 무결성이 깨질 위험이 커지고 데이터 모델의 유연성이 낮아집니다. 반정규화 4단계 절차는 ① 반정규화 대상 조사 → ② 다른 방법 유도 검토(뷰, 클러스터링, 인덱스 조정, 응용 애플리케이션) → ③ 반정규화 적용(테이블·속성·관계)입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','반정규화 전 "다른 방법(뷰·클러스터링·인덱스·응용로직)"으로 해결 가능한지 먼저 검토하는 것이 원칙!');
INSERT INTO "questions" VALUES(24,3,24,1,2,1,'반정규화 기법 중 데이터 무결성에 영향을 주지 않는 기법','다음 중 반정규화 기법 가운데 데이터 중복으로 인한 무결성 훼손 위험이 가장 적거나(데이터 무결성을 깨뜨리지 않는), 여러 엔터티를 거쳐 조인해야 하는 SQL 문장을 단순화하기 위해 사용하는 반정규화 기법은?','[관계 경로]
부서 --(1:M)-- 팀 --(1:M)-- 사원
사원이 속한 최상위 부서코드를 매번 팀을 거쳐 조인하지 않고, 부서와 사원 사이에 직접 관계를 추가','["중복 컬럼 추가 (칼럼의 반정규화)", "중복 테이블 추가 (테이블의 반정규화)", "중복 관계 추가 (관계의 반정규화)", "파생 컬럼 추가 (집계값 저장)"]',2,'③ 중복 관계 추가 (관계의 반정규화)','','관계의 반정규화, 중복 관계 추가, 데이터 무결성, 조인 경로 단축','테이블·칼럼 반정규화는 데이터를 물리적으로 중복 저장하므로 데이터 무결성을 해칠 우려가 큽니다. 반면 관계의 반정규화(중복 관계 추가)는 데이터 자체를 중복시키는 것이 아니라 릴레이션 간 FK 참조 경로를 추가로 설정해 조인 단계를 줄이므로 데이터 무결성을 깨뜨리지 않으면서 SQL을 단순화할 수 있습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','SQLD 기출 단골: "데이터 무결성을 깨뜨리지 않는 반정규화 기법" = 중복 관계 추가!');
INSERT INTO "questions" VALUES(25,3,25,1,2,1,'슈퍼타입/서브타입 논리 모델의 물리 데이터 모델 변환 3가지','논리적 데이터 모델의 슈퍼타입/서브타입(Super/Sub Type)을 성능을 고려해 물리적 테이블로 변환하는 3가지 방법과 그 특성에 대한 설명으로 가장 부적절한 것은?','1. One-to-One Type (개별 테이블 변환)
2. Plus Type (슈퍼 + 서브 테이블 변환)
3. Single Type / All-in-One Type (통합 테이블 변환)','["One-to-One Type은 서브타입별로 개별 테이블을 도출하므로 트랜잭션이 서브타입 개별로 발생할 때 유리하다.", "Plus Type은 슈퍼타입과 서브타입을 각각의 테이블로 생성하므로 슈퍼+서브를 함께 처리할 때 조인이 발생한다.", "Single Type(All-in-One)은 모든 속성을 하나의 테이블로 통합하므로 NULL 값이 많아지고 블록 I/O가 증가할 수 있다.", "트랜잭션이 항상 전체 통합(일괄)으로 처리되는 경우에도 One-to-One Type으로 분리해야 UNION 성능이 가장 우수하다."]',3,'④ 트랜잭션이 항상 전체 통합(일괄)으로 처리되는 경우에도 One-to-One Type으로 분리해야 UNION 성능이 가장 우수하다.','','슈퍼타입/서브타입, One to One, Plus Type, Single Type','트랜잭션이 항상 전체 일괄로 처리되는데 테이블이 개별로(One-to-One) 분리되어 있으면 매번 UNION 연산이 발생해 성능이 저하됩니다. 일괄 처리가 주된 경우에는 Single Type(All-in-One)으로 통합하는 것이 유리합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','개별 처리 → One-to-One | 슈퍼+서브 공통 → Plus Type | 전체 일괄 처리 → Single(All-in-One).');
INSERT INTO "questions" VALUES(26,4,26,1,2,1,'상호배타적 관계(Exclusive Relationship / Arc)의 이해','데이터 모델에서 아래와 같은 상호배타적 관계(Arc)가 설계되었을 때, [주문] 테이블의 인스턴스 저장 규칙으로 가장 올바른 것은?','[개인고객] ──┐
             ├─(Arc 호)──▶ [주문](주문번호, 개인고객번호[FK], 법인고객번호[FK])
[법인고객] ──┘','["하나의 주문 행에는 개인고객번호와 법인고객번호가 반드시 모두 NULL이 아니어야 한다.", "하나의 주문 행에는 개인고객번호 또는 법인고객번호 중 정확히 하나만 값이 존재하고, 나머지 하나는 NULL이어야 한다.", "두 외래키 모두 NOT NULL 제약조건을 설정해야 한다.", "개인고객과 법인고객 테이블 간에 1:1 식별자 관계가 형성된다."]',1,'② 하나의 주문 행에는 개인고객번호 또는 법인고객번호 중 정확히 하나만 값이 존재하고, 나머지 하나는 NULL이어야 한다.','','상호배타적 관계, Arc, Exclusive OR, NULL 허용','상호배타적(Exclusive OR) 관계에서는 두 부모 엔터티 중 하나만 선택적으로 관계를 맺습니다. 따라서 주문 엔터티의 개인고객번호와 법인고객번호 FK 컬럼은 둘 다 NULL 허용으로 설계하되, 애플리케이션이나 CHECK 제약조건으로 둘 중 하나만 값이 들어가도록 관리합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','상호배타적 관계 = "개인 또는 법인 중 택 1", 두 FK가 동시에 NOT NULL일 수 없습니다.');
INSERT INTO "questions" VALUES(27,3,27,1,2,1,'대용량 테이블 파티셔닝(Partitioning) 기법 4종 비교','대용량 테이블의 성능 향상과 관리 편의성을 위해 논리적으로는 하나의 테이블이지만 물리적으로 여러 세그먼트(파티션)로 분할하는 파티셔닝 기법 중, 특정 코드 값(예: 지역코드 = ''서울'', ''부산'')을 기준으로 관리자가 분할 기준 값을 직접 지정하는 방식은?','','["Range Partition (범위 분할)", "List Partition (목록 분할)", "Hash Partition (해시 분할)", "Composite Partition (복합 분할)"]',1,'② List Partition (목록 분할)','','List Partition, Range Partition, Hash Partition, Composite Partition','• Range Partition: 날짜·숫자 범위 기준(가장 많이 사용)
• List Partition: 지역·부서코드 등 특정 이산 값 목록 기준(데이터 편향 가능)
• Hash Partition: 해시 함수를 이용해 균등 분산(특정 값 분포 파악·관리 어려움)
• Composite Partition: Range + Hash 등 복합 적용.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','Range(범위/날짜) / List(특정 목록값) / Hash(해시 균등분산) / Composite(복합).');
INSERT INTO "questions" VALUES(28,5,28,1,2,2,'Row Migration(행 이전) 방지를 위한 저장 파라미터','테이블의 기존 행이 UPDATE 되어 길이가 늘어났을 때, 현재 데이터 블록 내 여유 공간이 부족하여 행 전체가 다른 블록으로 이동하고 기존 블록에는 포인터 주소만 남는 현상을 행 이전(Row Migration)이라고 한다. 이를 방지하기 위해 블록 내에 미리 예약해 두는 빈 공간 비율 파라미터 명칭을 영문으로 쓰시오.','-- UPDATE로 행 크기 증가 시 블록 여유공간 부족 → Row Migration 발생
-- 테이블 생성 시 여유 공간 확보 파라미터: CREATE TABLE T (...) _______ 20;','[]',-1,'PCTFREE','PCTFREE|pctfree','Row Migration, Row Chaining, PCTFREE, DB_BLOCK_SIZE','행 이전(Row Migration)은 UPDATE 시 공간 부족으로 발생하며 테이블 생성/수정 시 PCTFREE를 충분히 설정해 예방합니다. 반면 처음부터 행 자체가 하나의 블록 크기보다 커서 여러 블록에 나뉘어 저장되는 현상은 행 연결(Row Chaining)이며 DB_BLOCK_SIZE를 키워 완화합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','Row Migration(UPDATE 공간 부족) → PCTFREE | Row Chaining(행이 블록보다 큼) → DB_BLOCK_SIZE.');
INSERT INTO "questions" VALUES(29,2,29,2,3,1,'SQL 문장의 논리적 실행 순서 (FROM → ORDER BY)','관계형 데이터베이스에서 SELECT 문장이 내부적으로 파싱·실행되는 논리적 처리 순서로 올바른 것은?','SELECT DEPTNO, COUNT(*) AS CNT
FROM EMP
WHERE SAL >= 1000
GROUP BY DEPTNO
HAVING COUNT(*) >= 3
ORDER BY CNT DESC;','["SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY", "FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY", "FROM → GROUP BY → WHERE → HAVING → SELECT → ORDER BY", "FROM → WHERE → SELECT → GROUP BY → HAVING → ORDER BY"]',1,'② FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY','','SQL 실행 순서, FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY','SQL은 FROM(테이블 확인) → WHERE(행 필터링) → GROUP BY(그룹화) → HAVING(그룹 필터링) → SELECT(컬럼 추출/별칭 부여) → ORDER BY(정렬) 순으로 논리적으로 실행됩니다. 따라서 SELECT 절에서 정의한 별칭(CNT)은 WHERE/GROUP BY/HAVING에서는 참조할 수 없고 ORDER BY에서만 사용할 수 있습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','실행순서 암기: "프·웨·그·해·셀·오" — SELECT 별칭은 ORDER BY에서만 사용 가능!');
INSERT INTO "questions" VALUES(30,2,30,2,3,1,'SELECT DISTINCT 다중 컬럼 및 별칭(Alias) 주의사항','다음 중 SELECT 절의 DISTINCT와 컬럼 별칭(Alias) 사용에 관한 설명으로 가장 부적절한 것은?','SELECT DISTINCT DEPTNO, JOB FROM EMP;
SELECT ENAME AS "사원 이름" FROM EMP ORDER BY "사원 이름";','["SELECT DISTINCT COL1, COL2 FROM TBL; 은 COL1과 COL2 두 컬럼의 조합이 모두 중복되는 행을 제거하여 출력한다.", "컬럼 별칭에 공백이나 특수문자가 포함되면 큰따옴표(\" \")로 묶어야 한다.", "SELECT 절에서 정의한 컬럼 별칭은 동일 쿼리의 WHERE 절 조건식에서도 바로 사용할 수 있다.", "FROM 절에서 테이블에 별칭(Alias)을 부여했다면 SELECT 절이나 WHERE 절에서는 원 테이블명이 아닌 별칭을 사용해야 한다."]',2,'③ SELECT 절에서 정의한 컬럼 별칭은 동일 쿼리의 WHERE 절 조건식에서도 바로 사용할 수 있다.','','DISTINCT, Alias, WHERE 절 오류, 테이블 별칭','WHERE 절은 SELECT 절보다 먼저 실행되므로 SELECT 절에서 정의한 컬럼 별칭을 WHERE 절에서 사용할 수 없습니다(ORA-00904 부적합한 식별자 오류). 또한 FROM 절에서 테이블 별칭을 지정하면 Oracle/SQL Server 모두 원래 테이블명 대신 별칭으로 컬럼을 한정해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','SELECT DISTINCT A, B 는 (A, B) 쌍 전체가 같은 경우만 중복 제거됩니다.');
INSERT INTO "questions" VALUES(31,4,31,2,3,1,'CHAR vs VARCHAR 데이터 저장 및 공백 비교 규칙','고정 길이 문자열 타입(CHAR)과 가변 길이 문자열 타입(VARCHAR/VARCHAR2)의 비교 연산 결과에 대한 설명으로 가장 올바른 것은?','CREATE TABLE T_STR (C1 CHAR(10), V1 VARCHAR2(10));
INSERT INTO T_STR VALUES (''ORACLE'', ''ORACLE'');','["CHAR(10) 컬럼 C1에 ''ORACLE''을 저장했을 때 WHERE C1 = ''ORACLE   '' 조건은 참(TRUE)으로 평가된다.", "VARCHAR2(10) 컬럼 V1에 ''ORACLE''을 저장했을 때 WHERE V1 = ''ORACLE   '' 조건은 참(TRUE)으로 평가된다.", "CHAR(10) 컬럼 C1에 대해 WHERE C1 = ''  ORACLE'' 조건은 앞 공백도 무시되므로 참(TRUE)이다.", "CHAR 타입과 VARCHAR2 타입 모두 문자열 끝의 공백 길이에 관계없이 동일하게 비교된다."]',0,'① CHAR(10) 컬럼 C1에 ''ORACLE''을 저장했을 때 WHERE C1 = ''ORACLE   '' 조건은 참(TRUE)으로 평가된다.','','CHAR, VARCHAR2, 뒤 공백 무시, 앞 공백 엄격 비교','CHAR 타입은 고정 길이만큼 뒤에 공백을 채워 저장하므로 비교 시 뒤 공백은 무시합니다(단, 앞 공백이 다르면 불일치). 반면 VARCHAR/VARCHAR2 타입은 입력된 길이 그대로 저장하므로 뒤 공백까지 정확히 일치해야 같은 값으로 인정합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','CHAR 비교 = 뒤 공백 무시(앞 공백은 다르면 FALSE) | VARCHAR 비교 = 모든 공백까지 엄격 비교!');
INSERT INTO "questions" VALUES(32,4,32,2,3,1,'Oracle vs SQL Server 빈 문자열('''') 및 묵시적 형변환 처리','Oracle과 SQL Server(MSSQL)의 문자열 처리 및 묵시적 형변환 규칙에 대한 설명으로 가장 부적절한 것은?','-- TBL_MIX(STR_COL VARCHAR2(10)) 데이터: ''0001'', ''100'', ''ABCDE''
SELECT * FROM TBL_MIX WHERE STR_COL = 100;','["빈 문자열('''')을 INSERT 하면 Oracle은 NULL로 저장하고, SQL Server는 빈 문자열('''') 그대로 저장한다.", "문자 컬럼(STR_COL)과 숫자 상수(100)를 비교하면 DBMS는 숫자 타입에 맞추어 문자 컬럼을 묵시적 형변환(TO_NUMBER)한다.", "위 TBL_MIX 테이블에 ''ABCDE'' 행이 존재할 때 WHERE STR_COL = 100 을 실행하면 숫자로 변환할 수 없어 오류가 발생할 수 있다.", "숫자 컬럼(NUM_COL)과 숫자처럼 생긴 문자 상수(''100'')를 비교할 때도 항상 형변환 오류가 발생한다."]',3,'④ 숫자 컬럼(NUM_COL)과 숫자처럼 생긴 문자 상수(''100'')를 비교할 때도 항상 형변환 오류가 발생한다.','','빈문자열, Oracle NULL, 묵시적 형변환, TO_NUMBER','문자와 숫자를 비교하면 숫자 타입으로 묵시적 형변환됩니다. 숫자 컬럼과 숫자로 변환 가능한 문자 상수(''100'')를 비교하면 상수 ''100''이 숫자 100으로 문제없이 변환됩니다. 반면 문자 컬럼에 ''ABCDE'' 같은 비숫자 값이 들어있는 상태에서 숫자 상수와 비교하면 풀스캔 중 TO_NUMBER 오류가 발생합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','문자 vs 숫자 비교 → 숫자 쪽으로 묵시적 변환! (인덱스 무력화 원인도 됨).');
INSERT INTO "questions" VALUES(33,2,33,2,3,1,'NULL의 3값 논리, 사칙연산 및 0 나누기 오류','아래 데이터를 가진 EMP 테이블에서 세 개의 SQL 문장을 차례대로 실행했을 때의 결과로 가장 적절한 것은?','EMP (ENAME 문자, SAL 숫자, COMM 숫자)
KING  | 0    | 300
QUEEN | 5000 | 0
SCOTT | 1000 | NULL

SQL1) SELECT SAL / COMM FROM EMP WHERE ENAME = ''KING'';
SQL2) SELECT SAL / COMM FROM EMP WHERE ENAME = ''QUEEN'';
SQL3) SELECT SAL / COMM FROM EMP WHERE ENAME = ''SCOTT'';','["0, 에러발생, NULL", "0, 에러발생, 에러발생", "에러발생, 에러발생, NULL", "0, NULL, NULL"]',0,'① 0, 에러발생, NULL','','NULL 산술연산, 0 나누기 오류, 3값 논리','• SQL1: 0 / 300 = 0
• SQL2: 5000 / 0 → 분모가 0이므로 제수(0)로 나누기 오류(ORA-01476) 발생
• SQL3: 1000 / NULL → NULL과의 모든 사칙연산 결과는 NULL입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','NULL은 0도 공백도 아닌 미지의 값! NULL과의 산술연산은 무조건 NULL, 비교연산(=, !=)은 UNKNOWN.');
INSERT INTO "questions" VALUES(34,2,34,2,3,1,'NULL 처리 함수 (NVL · NVL2 · NULLIF · COALESCE) 결과 계산','아래 TAB 테이블을 대상으로 SQL 문장을 수행했을 때 출력 결과 값으로 가장 적절한 것은?','TAB
COL1 | COL2 | COL3
  5  |  2   |  3
NULL |  1   |  3
NULL | NULL |  3

[SQL]
SELECT SUM(COALESCE(COL1, COL2, COL3)) FROM TAB;','["0", "9", "6", "14"]',1,'② 9','','COALESCE, NVL, NVL2, NULLIF','COALESCE(A, B, C)는 인수 중 NULL이 아닌 첫 번째 값을 반환합니다.
• 1행: COALESCE(5, 2, 3) = 5
• 2행: COALESCE(NULL, 1, 3) = 1
• 3행: COALESCE(NULL, NULL, 3) = 3
따라서 SUM 결과는 5 + 1 + 3 = 9입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','NVL(a,b) / NVL2(a,b,c) / NULLIF(a,b): a==b면 NULL, 아니면 a / COALESCE: 최초 비NULL.');
INSERT INTO "questions" VALUES(35,2,35,2,3,1,'COUNT(*) vs COUNT(컬럼) 및 SUM(COL1+COL2) vs SUM(COL1)+SUM(COL2)','아래와 같이 COL1, COL2, COL3을 가진 3건의 데이터가 있을 때, SQL1과 SQL2의 실행 결과를 순서대로 바르게 나열한 것은?','TBL_SUM
COL1 | COL2 | COL3
NULL | NULL |  1
  2  |  3   |  2
  1  | NULL | NULL

SQL1) SELECT SUM(COL1 + COL2 + COL3) FROM TBL_SUM;
SQL2) SELECT SUM(COL1) + SUM(COL2) + SUM(COL3) FROM TBL_SUM;','["7, 9", "9, 9", "7, 7", "NULL, 9"]',0,'① 7, 9','','SUM, NULL 연산 순서, 행 단위 덧셈 vs 컬럼 집계','• SQL1: 각 행별로 먼저 COL1+COL2+COL3를 계산합니다. 1행(NULL+NULL+1=NULL), 2행(2+3+2=7), 3행(1+NULL+NULL=NULL). SUM은 NULL을 제외하므로 7이 됩니다.
• SQL2: 각 컬럼별 SUM을 먼저 계산합니다. SUM(COL1)=3, SUM(COL2)=3, SUM(COL3)=3이므로 3+3+3 = 9가 됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','SQLD 초빈출 함정! 행 내부 + 연산은 하나라도 NULL이면 NULL, 집계함수 SUM/COUNT/AVG는 NULL을 무시하고 계산.');
INSERT INTO "questions" VALUES(36,4,36,2,3,1,'연산자 우선순위 및 LIKE ESCAPE / BETWEEN / IN 활용','다음 중 SQL 조건절에서 사용되는 연산자에 대한 설명으로 가장 부적절한 것은?','SELECT * FROM EMP WHERE EMAIL LIKE ''%@_%'' ESCAPE ''@'';
SELECT * FROM EMP WHERE SAL BETWEEN 1000 AND 3000;','["WHERE EMAIL LIKE ''%@_%'' ESCAPE ''@'' 는 이메일 문자열에 언더바(''_'') 문자가 포함된 모든 행을 검색한다.", "A BETWEEN 1000 AND 3000 은 A >= 1000 AND A <= 3000 과 동일하게 양 끝 경계값을 포함한다.", "논리 연산자의 우선순위는 일반적으로 NOT > AND > OR 순서로 평가된다.", "WHERE SAL NOT IN (1000, 2000) 과 WHERE NOT (SAL = 1000 AND SAL = 2000) 은 논리적으로 항상 동일한 조건이다."]',3,'④ WHERE SAL NOT IN (1000, 2000) 과 WHERE NOT (SAL = 1000 AND SAL = 2000) 은 논리적으로 항상 동일한 조건이다.','','연산자 우선순위, ESCAPE, BETWEEN, NOT IN, 드모르간','SAL IN (1000, 2000)은 (SAL = 1000 OR SAL = 2000)과 같습니다. 따라서 NOT IN (1000, 2000)은 NOT (SAL = 1000 OR SAL = 2000), 즉 (SAL != 1000 AND SAL != 2000)과 같습니다. ④는 OR 대신 AND를 썼으므로 항상 참(SAL이 NULL이 아닌 경우)이 되어 완전히 다릅니다.','SQLD 2024 개정 출제기준 핵심문제','연산자 우선순위: 괄호 > 산술(*,/ > +,-) > 연결(||) > 비교(=,>,<) > SQL연산자(BETWEEN/IN/LIKE/IS NULL) > NOT > AND > OR.');
INSERT INTO "questions" VALUES(37,4,37,2,3,1,'숫자 함수 (ROUND · TRUNC · CEIL · FLOOR · MOD) 결과 추론','Oracle 환경에서 아래 SQL을 실행했을 때 출력되는 결과 값으로 올바른 것은?','SELECT ROUND(456.78, -1) AS A,
       TRUNC(456.78, -1) AS B,
       CEIL(-3.2) AS C,
       FLOOR(-3.2) AS D
FROM DUAL;','["A=460, B=450, C=-3, D=-4", "A=457, B=456, C=-3, D=-4", "A=460, B=450, C=-4, D=-3", "A=456.8, B=456.7, C=-3, D=-3"]',0,'① A=460, B=450, C=-3, D=-4','','ROUND, TRUNC, CEIL, FLOOR, 음수 자릿수','• ROUND(456.78, -1): 일의 자리(6)에서 반올림 → 460
• TRUNC(456.78, -1): 일의 자리 이하 버림 → 450
• CEIL(-3.2): -3.2보다 크거나 같은 최소 정수(올림) → -3
• FLOOR(-3.2): -3.2보다 작거나 같은 최대 정수(내림) → -4.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','음수 올림/내림 주의! CEIL(-3.2) = -3, FLOOR(-3.2) = -4 (수직선에서 오른쪽이 올림, 왼쪽이 내림).');
INSERT INTO "questions" VALUES(38,4,38,2,3,1,'문자 함수 (SUBSTR · INSTR · LPAD · TRIM · CONCAT)','Oracle 환경에서 다음 문자 함수들의 실행 결과로 가장 올바르게 짝지어진 것은?','SELECT SUBSTR(''DATABASE'', -4, 3) AS R1,
       INSTR(''CORPORATE FLOOR'', ''OR'', 3, 2) AS R2,
       LPAD(''SQL'', 5, ''*'') AS R3
FROM DUAL;','["R1=''BAS'', R2=14, R3=''**SQL''", "R1=''BAS'', R2=5, R3=''**SQL''", "R1=''ABA'', R2=14, R3=''SQL**''", "R1=''BAS'', R2=2, R3=''**SQL''"]',0,'① R1=''BAS'', R2=14, R3=''**SQL''','','SUBSTR, INSTR, LPAD, 음수 시작위치','• SUBSTR(''DATABASE'', -4, 3): 뒤에서 4번째 글자 ''B''부터 3글자 추출 → ''BAS''
• INSTR(''CORPORATE FLOOR'', ''OR'', 3, 2): 3번째 위치(''R'')부터 검색하여 두 번째로 발견되는 ''OR''의 시작 위치 → 5번째 ''OR''(1번째) 지나 ''FLOOR''의 ''OR'' 시작 위치인 14 반환
• LPAD(''SQL'', 5, ''*''): 총 5자리 중 왼쪽 빈칸을 ''*''로 채움 → ''**SQL''.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','Oracle CONCAT(s1, s2)은 인수가 반드시 2개만 가능(SQL Server CONCAT은 가변 인수 가능).');
INSERT INTO "questions" VALUES(39,4,39,2,3,1,'날짜 함수 (TO_CHAR · TO_DATE · 날짜 산술 연산)','Oracle에서 날짜형 데이터와 변환 함수에 대한 설명으로 가장 부적절한 것은?','SELECT TO_CHAR(TO_DATE(''2026-05-01'', ''YYYY-MM-DD'') + 1/24, ''YYYY-MM-DD HH24:MI'') FROM DUAL;','["날짜형에 숫자 1을 더하면 1일(24시간)이 더해지고, 1/24를 더하면 1시간이 더해진다.", "위 쿼리의 실행 결과는 ''2026-05-01 01:00'' 이다.", "TO_CHAR 함수는 날짜형이나 숫자형 데이터를 지정된 포맷의 문자열로 변환한다.", "DATE 타입 컬럼인 SYSDATE를 TO_DATE(SYSDATE, ''YYYY-MM-DD'')로 변환하면 항상 안전하게 시분초만 제거된 DATE가 반환된다."]',3,'④ DATE 타입 컬럼인 SYSDATE를 TO_DATE(SYSDATE, ''YYYY-MM-DD'')로 변환하면 항상 안전하게 시분초만 제거된 DATE가 반환된다.','','TO_DATE, TO_CHAR, SYSDATE, 날짜 연산, TRUNC','TO_DATE의 첫 번째 인수는 문자열이어야 합니다. DATE 타입인 SYSDATE를 TO_DATE에 전달하면 묵시적으로 문자열(NLS_DATE_FORMAT)로 변환된 뒤 다시 파싱하므로 포맷 불일치 오류가 발생할 수 있습니다. 시분초를 제거하려면 TRUNC(SYSDATE)를 사용해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','1일 = 1, 1시간 = 1/24, 1분 = 1/24/60 = 1/1440.');
INSERT INTO "questions" VALUES(40,2,40,2,3,1,'CASE 표현식 (Simple vs Searched) 및 DECODE 결과 추론','아래 SEARCHED CASE 표현식과 완전히 동일한 결과를 반환하도록 SIMPLE CASE 표현식의 ( A )에 들어갈 구문과, DECODE(COL1, ''A'', 10, ''B'', 20, 30)에 대한 설명으로 옳은 것은?','-- [Searched CASE]
SELECT LOC,
       CASE WHEN LOCATION = ''SEOUL'' THEN ''EAST''
            ELSE ''ETC''
       END AS AREA
FROM DEPT;

-- [Simple CASE]
SELECT LOC,
       CASE (  A  )
            ELSE ''ETC''
       END AS AREA
FROM DEPT;','["(A): LOCATION WHEN ''SEOUL'' THEN ''EAST'' / DECODE의 마지막 인수가 생략되고 일치 항목이 없으면 NULL을 반환한다.", "(A): WHEN LOCATION = ''SEOUL'' THEN ''EAST'' / DECODE의 마지막 인수가 생략되면 0을 반환한다.", "(A): LOCATION = ''SEOUL'' WHEN THEN ''EAST'' / DECODE는 부등호(>) 비교가 가능하다.", "(A): LOCATION WHEN ''SEOUL'' THEN ''EAST'' / CASE 문에서 ELSE를 생략하면 에러가 발생한다."]',0,'① (A): LOCATION WHEN ''SEOUL'' THEN ''EAST'' / DECODE의 마지막 인수가 생략되고 일치 항목이 없으면 NULL을 반환한다.','','Simple CASE, Searched CASE, DECODE, ELSE 생략 NULL','Simple CASE 문은 `CASE 대상컬럼 WHEN 비교값 THEN 결과 ... ELSE 기본값 END` 형태입니다. 또한 DECODE와 CASE 모두 기본값(ELSE)을 생략하고 일치하는 조건이 없으면 NULL을 반환합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','CASE는 `=` 외에 `>`, `<`, `BETWEEN` 등 범위 조건 가능 | Simple CASE와 DECODE는 동등(`=`) 비교만 가능.');
INSERT INTO "questions" VALUES(41,2,41,2,3,1,'GROUP BY · HAVING · ORDER BY 문법 오류 판별','아래 SQL 문장 중 문법적 오류(실행 에러)가 발생하는 것은?','테이블: 지역별매출(지역, 년, 매출금액)','["SELECT 지역, SUM(매출금액) AS 매출금액 FROM 지역별매출 GROUP BY 지역 ORDER BY 매출금액;", "SELECT 지역, 년, 매출금액 FROM 지역별매출 ORDER BY 매출금액 DESC;", "SELECT 지역, SUM(매출금액) AS 매출금액 FROM 지역별매출 GROUP BY 지역 ORDER BY 년;", "SELECT 지역, SUM(매출금액) AS 매출금액 FROM 지역별매출 GROUP BY 지역 HAVING SUM(매출금액) > 1000 ORDER BY COUNT(*);"]',2,'③ SELECT 지역, SUM(매출금액) AS 매출금액 FROM 지역별매출 GROUP BY 지역 ORDER BY 년;','','GROUP BY, ORDER BY 오류, 집계함수, HAVING','GROUP BY 절을 사용한 쿼리에서는 GROUP BY에 명시된 컬럼(지역)과 집계함수만 SELECT, HAVING, ORDER BY 절에 사용할 수 있습니다. ③의 ORDER BY 절에는 GROUP BY에 없는 일반 컬럼 "년"이 사용되었으므로 오류가 발생합니다(④처럼 ORDER BY COUNT(*)는 집계함수이므로 정상 실행됨).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','GROUP BY 이후 단계(HAVING, SELECT, ORDER BY)에는 그룹핑 컬럼과 집계함수만 올 수 있습니다!');
INSERT INTO "questions" VALUES(42,2,42,2,3,1,'ORDER BY CASE 복합 정렬 결과 추론','아래 TBL1 테이블을 대상으로 SQL을 실행했을 때 출력되는 행의 순서(ID, AMT)로 올바른 것은?','TBL1
ID | AMT
A  | 50
A  | 200
B  | 300
C  | 100

[SQL]
SELECT ID, AMT
FROM TBL1
ORDER BY (CASE WHEN ID = ''A'' THEN 1 ELSE 2 END), AMT DESC;','["(B, 300) → (A, 200) → (C, 100) → (A, 50)", "(A, 200) → (A, 50) → (B, 300) → (C, 100)", "(A, 50) → (A, 200) → (B, 300) → (C, 100)", "(B, 300) → (C, 100) → (A, 200) → (A, 50)"]',1,'② (A, 200) → (A, 50) → (B, 300) → (C, 100)','','ORDER BY CASE, 복합 정렬, 내림차순','1차 정렬 기준 `CASE WHEN ID = ''A'' THEN 1 ELSE 2 END` (기본 ASC)에 의해 ID가 ''A''인 행들이 1순위로 먼저 나오고, 나머지(B, C)는 모두 2순위가 됩니다. 2차 정렬 기준 `AMT DESC`에 의해 A 그룹 내에서는 200 → 50 순, 나머지 그룹(B, C)에서는 300 → 100 순으로 정렬됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','ORDER BY에 CASE문을 쓰면 특정 코드/값을 최상단 또는 최하단으로 우선 배치할 수 있습니다.');
INSERT INTO "questions" VALUES(43,2,43,2,3,1,'ALTER TABLE 컬럼 수정 문법 (SQL Server vs Oracle)','데이터가 들어있지 않은 왼쪽의 [기관분류] 테이블(가)를 오른쪽(나)처럼 변경하고자 할 때, SQL Server 환경에서 올바른 SQL 문장은?','(가) 기관분류: 분류ID VARCHAR(10) NOT NULL, 분류명 VARCHAR(20) NOT NULL, 등록일자 VARCHAR(10) NULL
(나) 기관분류: 분류ID VARCHAR(10) NOT NULL, 분류명 VARCHAR(30) NOT NULL, 등록일자 DATE NOT NULL','["ALTER TABLE 기관분류 ALTER COLUMN (분류명 VARCHAR(30), 등록일자 DATE NOT NULL);", "ALTER TABLE 기관분류 ALTER COLUMN (분류명 VARCHAR(30) NOT NULL, 등록일자 DATE NOT NULL);", "ALTER TABLE 기관분류 ALTER COLUMN 분류명 VARCHAR(30) NULL;\nALTER TABLE 기관분류 ALTER COLUMN 등록일자 DATE;", "ALTER TABLE 기관분류 ALTER COLUMN 분류명 VARCHAR(30) NOT NULL;\nALTER TABLE 기관분류 ALTER COLUMN 등록일자 DATE NOT NULL;"]',3,'④ ALTER TABLE 기관분류 ALTER COLUMN 분류명 VARCHAR(30) NOT NULL;
ALTER TABLE 기관분류 ALTER COLUMN 등록일자 DATE NOT NULL;','','ALTER TABLE, ALTER COLUMN, MODIFY, SQL Server NULL 유지 불가','SQL Server에서 `ALTER COLUMN`은 괄호로 여러 컬럼을 동시에 수정할 수 없고 컬럼마다 별도 문장으로 작성해야 합니다. 또한 Oracle의 `MODIFY`는 기존 NOT NULL 제약이 유지되지만, SQL Server의 `ALTER COLUMN`은 NULL 여부를 명시하지 않으면 기본적으로 NULL 허용으로 변경되므로 반드시 `NOT NULL`을 다시 명시해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','Oracle = MODIFY (다중 컬럼 괄호 가능) | SQL Server = ALTER COLUMN (단일 컬럼씩만 수정, NOT NULL 재명시 필수).');
INSERT INTO "questions" VALUES(44,2,44,2,3,1,'INSERT 문장 오류 판별 (컬럼 수 · 크기 · NOT NULL)','아래 CREATE TABLE 문으로 생성된 TBL 테이블에 대하여 5개의 INSERT 문장을 실행할 때, 오류 없이 정상적으로 삽입이 성공하는 문장만 묶은 것은?','CREATE TABLE TBL (
  ID NUMBER PRIMARY KEY,
  AMT NUMBER NOT NULL,
  DEGREE VARCHAR2(3)
);

1. INSERT INTO TBL VALUES (1, 100);
2. INSERT INTO TBL (ID, AMT, DEGREE) VALUES (2, 200, ''ABCD'');
3. INSERT INTO TBL (ID, DEGREE) VALUES (4, ''X'');
4. INSERT INTO TBL (ID, AMT) VALUES (3, 500);
5. INSERT INTO TBL VALUES (5, 500, NULL);','["1, 2", "2, 3", "3, 4", "4, 5"]',3,'④ 4, 5','','INSERT, NOT NULL 제약, VARCHAR2 크기 초과, 컬럼 생략','• 1번 실패: 컬럼명을 생략했으므로 테이블의 전체 3개 컬럼 값을 모두 제공해야 함(2개만 입력).
• 2번 실패: DEGREE는 VARCHAR2(3)인데 ''ABCD''(4바이트)를 입력해 크기 초과.
• 3번 실패: NOT NULL 제약조건이 있는 AMT 컬럼 값이 누락됨.
• 4, 5번 성공: DEGREE는 NULL 허용이므로 생략하거나 NULL을 명시해 정상 삽입됨.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','INSERT 시 전체 컬럼 생략은 VALUES 개수 일치가 필수이며, NOT NULL 컬럼은 반드시 값이 들어가야 합니다.');
INSERT INTO "questions" VALUES(45,4,45,2,3,1,'DELETE vs TRUNCATE vs DROP 차이점 완벽 비교','테이블의 데이터를 삭제하거나 구조를 제거하는 명령어인 DELETE, TRUNCATE, DROP에 대한 비교 설명으로 가장 부적절한 것은?','','["DELETE는 DML로 WHERE 조건을 이용해 일부 행만 삭제할 수 있으며 COMMIT 전에는 ROLLBACK이 가능하다.", "TRUNCATE는 DDL로 테이블의 구조(정의)는 남기고 전체 데이터만 즉시 삭제하며 ROLLBACK이 불가능하다.", "DROP은 DDL로 테이블의 데이터와 구조(정의)를 모두 삭제한다.", "TRUNCATE TABLE EMP WHERE DEPTNO = 10; 구문을 사용하면 특정 부서의 데이터만 로그 없이 빠르게 삭제할 수 있다."]',3,'④ TRUNCATE TABLE EMP WHERE DEPTNO = 10; 구문을 사용하면 특정 부서의 데이터만 로그 없이 빠르게 삭제할 수 있다.','','DELETE, TRUNCATE, DROP, DDL, DML, ROLLBACK','TRUNCATE는 테이블 전체 데이터만 일괄 삭제할 수 있는 DDL이므로 WHERE 조건절을 사용할 수 없습니다. 일부 행만 조건부 삭제하려면 DML인 DELETE를 사용해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','DELETE(DML, 일부 가능, 롤백 O) | TRUNCATE(DDL, 전체만, 롤백 X, 구조 유지) | DROP(DDL, 구조+데이터 삭제, 롤백 X).');
INSERT INTO "questions" VALUES(46,4,46,2,3,1,'데이터베이스 제약조건 5종과 CTAS(CREATE TABLE AS SELECT) 특징','관계형 데이터베이스의 제약조건(Constraint)에 대한 설명으로 가장 부적절한 것은?','CREATE TABLE EMP_COPY AS SELECT * FROM EMP;','["PRIMARY KEY는 하나의 테이블에 한 개만 생성할 수 있으나, 여러 컬럼을 묶어 복합키로 구성할 수 있다.", "UNIQUE 제약조건이 설정된 컬럼은 중복된 값을 허용하지 않지만, NULL 값은 입력할 수 있다.", "FOREIGN KEY가 참조하는 부모 테이블의 컬럼은 반드시 사전에 PRIMARY KEY 또는 UNIQUE 제약조건이 설정되어 있어야 한다.", "CREATE TABLE EMP_COPY AS SELECT * FROM EMP; 로 테이블을 복제하면 PRIMARY KEY, UNIQUE, FOREIGN KEY 등 모든 제약조건이 그대로 복사된다."]',3,'④ CREATE TABLE EMP_COPY AS SELECT * FROM EMP; 로 테이블을 복제하면 PRIMARY KEY, UNIQUE, FOREIGN KEY 등 모든 제약조건이 그대로 복사된다.','','제약조건, CTAS, NOT NULL 복사, UNIQUE NULL 허용','Oracle에서 CTAS(CREATE TABLE ... AS SELECT)로 테이블을 복제할 경우 컬럼의 데이터 타입과 **NOT NULL** 속성만 복사되며, PRIMARY KEY, UNIQUE, FOREIGN KEY, CHECK 등 기타 제약조건과 인덱스는 복사되지 않습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','CTAS 시 NOT NULL만 복사됨! (PK/FK/UNIQUE/CHECK/INDEX 미복사).');
INSERT INTO "questions" VALUES(47,2,47,2,3,1,'FOREIGN KEY 참조 무결성 옵션 (ON DELETE CASCADE) 결과 건수','아래 SQL 문장이 순차적으로 실행되었을 때, A와 C의 SELECT 문장 실행 결과 건수로 올바른 것은?','CREATE TABLE 부서 (부서번호 CHAR(10) PRIMARY KEY, 부서명 CHAR(10));
CREATE TABLE 직원 (
  직원번호 CHAR(10) PRIMARY KEY,
  소속부서 CHAR(10) REFERENCES 부서(부서번호) ON DELETE CASCADE
);

INSERT INTO 부서 VALUES (''10'', ''영업과'');
INSERT INTO 부서 VALUES (''30'', ''기획과'');
INSERT INTO 직원 VALUES (''100'', ''10'');
INSERT INTO 직원 VALUES (''200'', ''30'');
INSERT INTO 직원 VALUES (''300'', ''30'');
COMMIT;

-- A. SELECT COUNT(직원번호) FROM 직원;
-- B. DELETE FROM 부서 WHERE 부서번호 = ''30'';
-- C. SELECT COUNT(직원번호) FROM 직원;','["3, 0", "3, 1", "3, 2", "3, 3"]',1,'② 3, 1','','ON DELETE CASCADE, ON DELETE SET NULL, 외래키, 참조 무결성','A 시점에는 직원이 3명(100, 200, 300)이므로 3입니다. B에서 부서번호 ''30''을 삭제하면 `ON DELETE CASCADE` 옵션에 의해 자식 테이블(직원)에서 소속부서가 ''30''인 직원 2명(200, 300)도 함께 연쇄 삭제됩니다. 따라서 C 시점에는 직원 ''100'' 1명만 남아 1이 출력됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','ON DELETE CASCADE(자식 행 동시 삭제) vs ON DELETE SET NULL(자식 FK만 NULL로 변경).');
INSERT INTO "questions" VALUES(48,2,48,2,3,1,'Oracle vs SQL Server DDL 묵시적 COMMIT 및 TCL 동작 차이','AUTO COMMIT이 FALSE인 상태에서 테이블 A에 대해 아래와 같은 SQL을 수행했을 때, 테이블 A의 ID ''001''에 해당하는 최종 VAL 값이 Oracle에서는 200, SQL Server에서는 100이 되었다. 다음 설명 중 가장 부적절한 것은?','테이블 A: (001, 100), (002, 200)

[SQL]
UPDATE A SET VAL = 200 WHERE ID = ''001'';
CREATE TABLE B (ID CHAR(3) PRIMARY KEY);
ROLLBACK;','["Oracle에서는 CREATE TABLE 문장을 수행하기 전후로 묵시적 COMMIT이 수행되어 VAL 값은 200으로 확정되었다.", "Oracle에서는 CREATE TABLE 문장 수행에 의해 VAL 값은 200이 되었지만, ROLLBACK 실행으로 인해 최종적으로 B 테이블은 생성이 취소되었다.", "SQL Server에서는 ROLLBACK 문장에 의해 UPDATE가 취소되어 VAL 값은 100이 되었다.", "SQL Server에서는 ROLLBACK 실행으로 인해 UPDATE가 취소되었으며, 최종적으로 B 테이블도 생성되지 않았다."]',1,'② Oracle에서는 CREATE TABLE 문장 수행에 의해 VAL 값은 200이 되었지만, ROLLBACK 실행으로 인해 최종적으로 B 테이블은 생성이 취소되었다.','','묵시적 COMMIT, DDL, Oracle vs SQL Server, ROLLBACK','Oracle에서는 DDL(CREATE/ALTER/DROP/TRUNCATE)을 실행하면 실행 직전까지의 트랜잭션이 묵시적으로 COMMIT 되며 DDL 자체도 즉시 확정되므로, 이후 ROLLBACK을 실행해도 B 테이블은 삭제되지 않고 유지됩니다. 반면 SQL Server는 트랜잭션 블록 내에서 DDL도 ROLLBACK이 가능합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','Oracle은 DDL = 자동 커밋(롤백 불가)! SQL Server는 명시적 트랜잭션 내 DDL 롤백 가능.');
INSERT INTO "questions" VALUES(49,2,49,2,3,1,'트랜잭션 격리성(Isolation) 부족 시 발생하는 이상 현상 3가지','데이터베이스 트랜잭션에 대한 격리성(Isolation)이 낮은 경우 발생할 수 있는 문제점에 대한 설명으로 가장 부적절한 것은?','','["Dirty Read: 다른 트랜잭션에 의해 수정되었으나 아직 커밋되지 않은(Uncommitted) 데이터를 읽는 현상", "Non-Repeatable Read: 한 트랜잭션 내에서 같은 쿼리를 두 번 수행할 때, 그 사이에 다른 트랜잭션이 값을 수정·삭제 후 커밋하여 두 결과가 달라지는 현상", "Phantom Read: 한 트랜잭션 내에서 같은 조건의 쿼리를 두 번 수행할 때, 다른 트랜잭션이 새 행을 삽입·커밋하여 첫 번째 쿼리에서 없던 유령 레코드가 나타나는 현상", "Dirty Read는 다른 트랜잭션에 의해 수정되었고 이미 COMMIT까지 완료된 데이터를 읽을 때 발생하는 현상이다."]',3,'④ Dirty Read는 다른 트랜잭션에 의해 수정되었고 이미 COMMIT까지 완료된 데이터를 읽을 때 발생하는 현상이다.','','트랜잭션 격리수준, Dirty Read, Non-Repeatable Read, Phantom Read','Dirty Read는 다른 트랜잭션이 수정만 하고 아직 COMMIT 하지 않은(롤백될 수 있는) 데이터를 읽어버리는 현상입니다. 이미 커밋된 데이터를 읽고 이전과 달라지는 현상은 Non-Repeatable Read입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','READ UNCOMMITTED → Dirty Read 발생 | READ COMMITTED → Non-Repeatable/Phantom 발생 | REPEATABLE READ → Phantom 발생 | SERIALIZABLE → 모두 방지.');
INSERT INTO "questions" VALUES(50,4,50,2,3,1,'DCL 권한 회수 — WITH GRANT OPTION vs WITH ADMIN OPTION','DCL(GRANT / REVOKE)의 중간 권한 부여 옵션인 WITH GRANT OPTION과 WITH ADMIN OPTION에 대한 설명으로 가장 부적절한 것은?','-- 오브젝트 권한 부여
GRANT SELECT ON EMP TO USER_A WITH GRANT OPTION;
-- USER_A가 USER_B에게 권한 재부여
GRANT SELECT ON SCOTT.EMP TO USER_B;

-- 시스템 권한 부여
GRANT CREATE TABLE TO USER_A WITH ADMIN OPTION;','["WITH GRANT OPTION으로 부여받은 오브젝트 권한은 중간관리자(USER_A)의 권한을 회수하면 제3자(USER_B)에게 부여된 권한도 함께 연쇄 회수된다.", "WITH ADMIN OPTION으로 부여받은 시스템 권한/롤은 중간관리자(USER_A)의 권한을 회수하더라도 제3자(USER_B)의 권한은 남아있다.", "오브젝트 권한을 ROLE에 담아 사용자에게 부여한 경우, 테이블 소유자가 그 사용자의 개별 오브젝트 권한을 REVOKE로 직접 회수할 수 있다.", "WITH GRANT OPTION으로 권한을 재부여받은 USER_B의 권한은 최초 소유자가 직접 회수할 수 없고 중간관리자(USER_A)를 통해서만 회수하거나 USER_A의 권한을 회수해야 한다."]',2,'③ 오브젝트 권한을 ROLE에 담아 사용자에게 부여한 경우, 테이블 소유자가 그 사용자의 개별 오브젝트 권한을 REVOKE로 직접 회수할 수 있다.','','DCL, WITH GRANT OPTION, WITH ADMIN OPTION, ROLE, REVOKE','ROLE을 통해 부여받은 권한은 사용자에게서 직접 회수할 수 없고, ROLE 자체에서 권한을 회수하거나 사용자에게서 ROLE을 REVOKE해야 합니다. ROLE에서 회수된 권한은 즉시 반영됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','WITH GRANT OPTION(오브젝트 권한, 연쇄 회수 O) vs WITH ADMIN OPTION(시스템/롤 권한, 연쇄 회수 X).');
INSERT INTO "questions" VALUES(51,3,51,2,3,1,'VIEW(뷰) 생성 및 조회 SQL 결과 추론','아래 테이블 TBL에 대하여 [뷰 생성 스크립트]를 실행한 후 [조회 SQL]을 수행했을 때의 실행 결과로 알맞은 것은?','TBL
COL1 | COL2
 A   | 10
 C   | 20
 C   | 10
 C   | NULL
NULL | 20

[뷰 생성 스크립트]
CREATE VIEW V_TBL AS
SELECT COL1, COL2 FROM TBL WHERE COL1 = ''C'';

[조회 SQL]
SELECT SUM(COL2) AS COL2
FROM V_TBL
WHERE COL2 > 10 AND COL1 = ''C'';','["0", "20", "30", "40"]',1,'② 20','','VIEW, 뷰 조회, NULL 비교, SUM','V_TBL 뷰는 TBL에서 COL1 = ''C''인 행 3건((C, 20), (C, 10), (C, NULL))만을 가집니다. 이 중 `COL2 > 10`을 만족하는 행은 (C, 20) 1건뿐이므로(NULL > 10은 UNKNOWN), SUM(COL2)의 결과는 20입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','VIEW 특징 3가지: 독립성, 편리성, 보안성 (물리적 저장공간 X, 인덱스 생성 불가).');
INSERT INTO "questions" VALUES(52,5,52,2,3,2,'오브젝트 권한 부여 및 회수 SQL 명령어 (DCL 단답)','특정 유저에게 테이블 조회 등의 오브젝트 권한을 부여할 때 사용하는 명령어(A)와, 부여된 권한을 회수할 때 사용하는 명령어(B)를 쉼표로 구분하여 대문자로 쓰시오. (예: AAA, BBB)','-- ( A ) SELECT ON EMP TO HR;
-- ( B ) SELECT ON EMP FROM HR;','[]',-1,'GRANT, REVOKE','GRANT, REVOKE|GRANT,REVOKE|grant, revoke|grant,revoke','DCL, GRANT, REVOKE, TO, FROM','권한 부여는 `GRANT 권한 ON 객체 TO 유저`, 권한 회수는 `REVOKE 권한 ON 객체 FROM 유저` 구문을 사용합니다(전치사 TO vs FROM 구분 주의).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','GRANT ... TO ... / REVOKE ... FROM ...');
INSERT INTO "questions" VALUES(53,3,53,2,4,1,'3개 테이블 조인 시 필요한 최소 조인 조건과 카티션 곱','아래 생산설비 데이터 모델(제품 - 생산제품 - 생산라인)에 대한 설명으로 가장 올바른 것은?','제품(제품코드[PK], 제품명, 제품유형코드, 단위)
생산제품(라인코드[PK,FK], 제품코드[PK,FK])
생산라인(라인코드[PK], 최초가동일자)','["제품, 생산제품, 생산라인 3개 엔터티를 INNER JOIN할 때 필요한 최소 조인 조건의 개수는 1개이다.", "제품과 생산라인 엔터티를 조인 조건 없이 직접 JOIN하면 카티션 곱(Cartesian Product)이 발생한다.", "특정 생산라인에서 생산되는 제품의 제품명을 조회할 때는 생산라인과 제품 2개 테이블만 조인하면 된다.", "제품과 생산라인 엔터티에는 교차 엔터티(생산제품)와 대응되지 않는 레코드가 절대 존재할 수 없다."]',1,'② 제품과 생산라인 엔터티를 조인 조건 없이 직접 JOIN하면 카티션 곱(Cartesian Product)이 발생한다.','','조인 조건 개수, N-1, 카티션 곱, 교차 엔터티','N개 테이블을 조인할 때는 최소 N-1개(3개면 2개)의 조인 조건이 필요합니다. 제품과 생산라인은 M:N 관계를 해소하는 교차 엔터티(생산제품)를 거쳐 연결되므로, 두 테이블을 직접 조인하면 공통 조인 키가 없어 카티션 곱이 발생합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','N개 테이블 조인 = 최소 N-1개의 조인 조건 필요.');
INSERT INTO "questions" VALUES(54,2,54,2,4,1,'다중 테이블 EQUI JOIN 조건과 컬럼 한정자 작성','아래 영화 데이터베이스 스키마에서 출연료가 800 이상인 영화명, 배우명, 출연료를 조회하는 SQL로 가장 적절한 것은?','배우(배우ID[PK], 배우명, 성별)
영화(영화번호[PK], 영화명, 제작년도)
출연(배우ID[PK,FK], 영화번호[PK,FK], 출연료)','["SELECT 출연.영화명, 영화.배우명, 출연.출연료 FROM 배우, 영화, 출연 WHERE 출연료 >= 800 AND 출연.영화번호 = 영화.영화번호 AND 출연.배우ID = 배우.배우ID;", "SELECT 영화.영화명, 배우.배우명, 출연료 FROM 영화, 배우, 출연 WHERE 출연료 > 800 AND 출연.영화번호 = 영화.영화번호 AND 영화.영화번호 = 배우.배우ID;", "SELECT 영화명, 배우명, 출연료 FROM 배우, 영화, 출연 WHERE 출연료 >= 800 AND 영화번호 = 영화.영화번호 AND 배우ID = 배우.배우ID;", "SELECT 영화.영화명, 배우.배우명, 출연료 FROM 배우, 영화, 출연 WHERE 출연료 >= 800 AND 출연.영화번호 = 영화.영화번호 AND 출연.배우ID = 배우.배우ID;"]',3,'④ SELECT 영화.영화명, 배우.배우명, 출연료 FROM 배우, 영화, 출연 WHERE 출연료 >= 800 AND 출연.영화번호 = 영화.영화번호 AND 출연.배우ID = 배우.배우ID;','','EQUI JOIN, 컬럼 한정자, 모호성 제거','① 영화명/배우명은 출연 테이블에 없는 컬럼입니다. ② > 800이 아니라 >= 800이며 영화번호=배우ID 조인 조건이 잘못되었습니다. ③ 영화번호, 배우ID가 두 테이블에 공통으로 존재해 테이블명을 생략하면 "열의 정의가 애매합니다" 오류가 발생합니다. ④가 유일하게 정확한 SQL입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','두 테이블에 동일한 이름의 컬럼이 존재하면 반드시 `테이블명.컬럼명` (또는 `별칭.컬럼명`)으로 명시해야 합니다.');
INSERT INTO "questions" VALUES(55,3,55,2,4,1,'NATURAL JOIN과 USING 조건절의 컬럼 별칭 제한','ANSI 표준 조인 중 NATURAL JOIN과 USING 조건절에 대한 설명으로 가장 부적절한 것은?','SELECT D.DEPTNO, D.DNAME, E.ENAME
FROM DEPT D JOIN EMP E USING (DEPTNO);','["NATURAL JOIN은 두 테이블 간 동일한 이름을 가진 모든 컬럼에 대해 자동으로 EQUI JOIN을 수행한다.", "NATURAL JOIN 사용 시 조인에 사용된 동일 컬럼에는 SELECT 절이나 WHERE 절에서 테이블명이나 별칭(Alias)을 붙일 수 없다.", "USING 절에 사용된 조인 컬럼(예: DEPTNO)에도 SELECT 절에서 테이블명이나 별칭(D.DEPTNO)을 붙이면 오류가 발생한다.", "NATURAL JOIN과 USING 절은 두 테이블의 조인 조건을 더욱 명확히 하기 위해 하나의 JOIN 문에 함께 쓸 수 있다."]',3,'④ NATURAL JOIN과 USING 절은 두 테이블의 조인 조건을 더욱 명확히 하기 위해 하나의 JOIN 문에 함께 쓸 수 있다.','','NATURAL JOIN, USING, 식별자 금지, 데이터 타입','NATURAL JOIN과 USING 절, ON 절은 함께 사용할 수 없습니다. 또한 위 code_or_log의 `SELECT D.DEPTNO ... USING (DEPTNO)` 역시 조인 컬럼인 DEPTNO에 별칭 `D.`를 붙였기 때문에 실제로 에러가 발생합니다(조인 컬럼은 `DEPTNO`처럼 식별자 없이 써야 함).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','NATURAL JOIN & USING 절의 핵심 규칙: 조인에 참여하는 컬럼에는 절대 테이블명/Alias를 붙이지 않는다!');
INSERT INTO "questions" VALUES(56,3,56,2,4,1,'LEFT OUTER JOIN에서 ON 절 조건 vs WHERE 절 조건 결과 차이','아래 TAB1, TAB2 테이블에 대하여 SQL1과 SQL2를 각각 실행했을 때 출력되는 결과 건수로 올바른 것은?','TAB1 (C1)         TAB2 (C1, C2)
1                   1, 2
2                   2, 5
3                   3, 1

SQL1) SELECT * FROM TAB1 A LEFT OUTER JOIN TAB2 B
      ON (A.C1 = B.C1 AND B.C2 BETWEEN 1 AND 3);

SQL2) SELECT * FROM TAB1 A LEFT OUTER JOIN TAB2 B
      ON (A.C1 = B.C1)
      WHERE B.C2 BETWEEN 1 AND 3;','["SQL1: 3건, SQL2: 2건", "SQL1: 2건, SQL2: 2건", "SQL1: 3건, SQL2: 3건", "SQL1: 2건, SQL2: 3건"]',0,'① SQL1: 3건, SQL2: 2건','','LEFT OUTER JOIN, ON 절 필터, WHERE 절 필터','• SQL1: `B.C2 BETWEEN 1 AND 3`이 ON 절에 있으므로, 조인 시점에 TAB2의 C1=2 행(C2=5)만 매칭에서 탈락하고 기준 테이블 TAB1의 행(1, 2, 3)은 모두 보존되어 총 3건이 출력됩니다(2번 행의 B 컬럼들은 NULL).
• SQL2: 먼저 LEFT JOIN으로 3건이 만들어진 뒤 WHERE 절에서 `B.C2 BETWEEN 1 AND 3`으로 필터링하므로 B.C2=5인 2번 행이 탈락해 총 2건만 출력됩니다(사실상 INNER JOIN과 동일 결과).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','OUTER JOIN 시 B 테이블 조건을 WHERE에 쓰면 NULL 행이 다 날아가 INNER JOIN처럼 변합니다! 반드시 ON 절에 두어야 합니다.');
INSERT INTO "questions" VALUES(57,3,57,2,4,1,'Oracle (+) 기호 외부조인을 ANSI 표준 OUTER JOIN으로 변환','아래 Oracle 전용 문법의 조인 쿼리를 ANSI 표준 SQL 문법으로 올바르게 변환한 것은?','SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A, DEPT B
WHERE A.DEPTNO(+) = B.DEPTNO;','["FROM EMP A LEFT OUTER JOIN DEPT B ON A.DEPTNO = B.DEPTNO", "FROM EMP A RIGHT OUTER JOIN DEPT B ON A.DEPTNO = B.DEPTNO", "FROM EMP A FULL OUTER JOIN DEPT B ON A.DEPTNO = B.DEPTNO", "FROM EMP A INNER JOIN DEPT B ON A.DEPTNO = B.DEPTNO"]',1,'② FROM EMP A RIGHT OUTER JOIN DEPT B ON A.DEPTNO = B.DEPTNO','','Oracle (+), OUTER JOIN, RIGHT OUTER JOIN, ANSI 표준','Oracle의 `(+)` 기호는 데이터가 부족해서 NULL이 채워지는 쪽에 붙입니다. `A.DEPTNO(+) = B.DEPTNO`는 A(EMP) 쪽이 NULL로 채워지고 B(DEPT)가 기준 테이블이므로 ANSI 표준으로는 `EMP A RIGHT OUTER JOIN DEPT B` (또는 `DEPT B LEFT OUTER JOIN EMP A`)가 됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','(+)가 붙은 쪽이 NULL이 채워지는 쪽 → 반대쪽 테이블이 기준(주) 테이블!');
INSERT INTO "questions" VALUES(58,3,58,2,4,1,'FULL OUTER JOIN과 집합 연산자 등가 SQL 판별','두 테이블 TBL1과 TBL2에 대해 (1), (2), (3)의 SQL을 실행했을 때, 실행 결과가 항상 같은 것끼리 묶인 것은? (단, ID는 각 테이블의 PK이며 문법 오타는 보정된 것으로 가정)','(1) SELECT A.ID, B.ID FROM TBL1 A FULL OUTER JOIN TBL2 B ON A.ID = B.ID;

(2) SELECT A.ID, B.ID FROM TBL1 A LEFT OUTER JOIN TBL2 B ON A.ID = B.ID
    UNION ALL
    SELECT A.ID, B.ID FROM TBL1 A RIGHT OUTER JOIN TBL2 B ON A.ID = B.ID;

(3) SELECT A.ID, B.ID FROM TBL1 A, TBL2 B WHERE A.ID = B.ID
    UNION ALL
    SELECT A.ID, NULL FROM TBL1 A WHERE NOT EXISTS (SELECT 1 FROM TBL2 B WHERE A.ID = B.ID)
    UNION ALL
    SELECT NULL, B.ID FROM TBL2 B WHERE NOT EXISTS (SELECT 1 FROM TBL1 A WHERE B.ID = A.ID);','["(1), (2)", "(1), (3)", "(2), (3)", "(1), (2), (3)"]',1,'② (1), (3)','','FULL OUTER JOIN, UNION ALL, NOT EXISTS, 중복 제거','(1) FULL OUTER JOIN은 (교집합) + (TBL1에만 있는 행) + (TBL2에만 있는 행)을 반환하며 (3)의 3개 SELECT를 UNION ALL한 결과와 정확히 일치합니다. 반면 (2)는 LEFT JOIN과 RIGHT JOIN을 UNION ALL 했으므로 교집합 영역이 2번 중복 출력됩니다(UNION을 써야 FULL OUTER JOIN과 동일).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','FULL OUTER JOIN = (LEFT JOIN) UNION (RIGHT JOIN) [중복제거 UNION 필수!].');
INSERT INTO "questions" VALUES(59,3,59,2,4,1,'SELF JOIN을 수행해야 하는 데이터 구조','SQL에서 동일 테이블을 두 번 이상 참조하여 조인하는 SELF JOIN을 수행해야 하는 경우로 가장 적절한 것은?','SELECT E.ENAME AS 사원명, M.ENAME AS 관리자명
FROM EMP E LEFT OUTER JOIN EMP M ON E.MGR = M.EMPNO;','["한 테이블 내에서 두 컬럼 이상이 서로 내부적인 연관관계(예: 사원번호와 관리자사번)를 가지고 있다.", "두 개의 서로 다른 테이블에 연관된 컬럼은 없으나 모든 조합을 조인해야 한다.", "두 테이블에 공통 컬럼이 존재하고 두 테이블이 1:M 연관관계가 있다.", "한 테이블의 모든 컬럼을 중복 제거하여 단일 행으로 요약해야 한다."]',0,'① 한 테이블 내에서 두 컬럼 이상이 서로 내부적인 연관관계(예: 사원번호와 관리자사번)를 가지고 있다.','','SELF JOIN, 계층 구조, MGR, EMPNO','SELF JOIN은 하나의 테이블 내에서 두 컬럼이 상하·계층적 연관관계를 가질 때(예: EMP 테이블의 MGR이 같은 테이블의 EMPNO를 참조), 같은 테이블에 서로 다른 별칭(E, M)을 부여해 조인하는 기법입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','SELF JOIN 시 반드시 서로 다른 테이블 별칭(Alias)을 부여해야 합니다.');
INSERT INTO "questions" VALUES(60,3,60,2,4,1,'CROSS JOIN (카티션 곱) 결과 행 수와 표준 문법','4개의 행을 가진 EMP 테이블과 3개의 행을 가진 DEPT 테이블을 대상으로 아래 두 SQL 문장을 실행했을 때, 사례 2의 빈칸에 들어갈 키워드와 출력 행의 개수로 올바른 것은?','-- [사례 1]
SELECT ENAME, DNAME FROM EMP, DEPT;

-- [사례 2]
SELECT ENAME, DNAME FROM EMP (      ) DEPT;','["NATURAL JOIN / 4건", "CROSS JOIN / 12건", "CROSS JOIN / 7건", "INNER JOIN / 12건"]',1,'② CROSS JOIN / 12건','','CROSS JOIN, 카티션 곱, M×N','조인 조건 없이 두 테이블을 나열한 사례 1은 카티션 곱(Cartesian Product)이며, ANSI 표준 SQL에서는 `CROSS JOIN`으로 표현합니다. 결과 행 수는 두 테이블 행 수의 곱인 4 × 3 = 12건이 됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','CROSS JOIN에는 ON 절이나 USING 절을 사용할 수 없습니다.');
INSERT INTO "questions" VALUES(61,2,61,2,4,1,'INNER JOIN + GROUP BY + HAVING COUNT 조건 결합','아래 테이블 스키마에서 "구매 이력이 있는 고객 중 구매 횟수가 5회 이상인 고객의 이름과 등급을 출력하시오"라는 질의에 대해 (ㄱ), (ㄴ)에 들어갈 구문으로 가장 적절한 것은?','[테이블]
고객(고객번호[PK], 이름, 등급)
구매이력(구매번호[PK], 구매금액, 고객번호[FK])

[SQL]
SELECT A.이름, A.등급
FROM 고객 A
(  ㄱ  )
GROUP BY A.이름, A.등급
(  ㄴ  );','["(ㄱ) INNER JOIN 구매이력 B ON A.고객번호 = B.고객번호\n(ㄴ) HAVING SUM(B.구매번호) >= 5", "(ㄱ) INNER JOIN 구매이력 B ON A.고객번호 = B.고객번호\n(ㄴ) HAVING COUNT(B.구매번호) >= 5", "(ㄱ) LEFT OUTER JOIN 구매이력 B ON A.고객번호 = B.고객번호\n(ㄴ) HAVING SUM(B.구매번호) >= 5", "(ㄱ) INNER JOIN 구매이력 B ON A.고객번호 = B.고객번호\n(ㄴ) WHERE B.구매번호 >= 5"]',1,'② (ㄱ) INNER JOIN 구매이력 B ON A.고객번호 = B.고객번호 / (ㄴ) HAVING COUNT(B.구매번호) >= 5','','INNER JOIN, GROUP BY, HAVING COUNT','구매 이력이 있는 고객만 대상이므로 INNER JOIN으로 고객번호를 연결하고, 고객별 구매 횟수(건수)가 5회 이상인 그룹을 필터링해야 하므로 GROUP BY 뒤에 `HAVING COUNT(B.구매번호) >= 5`를 작성해야 합니다(SUM이 아닌 COUNT, WHERE가 아닌 HAVING).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','건수 = COUNT, 그룹 필터링 = HAVING!');
INSERT INTO "questions" VALUES(62,3,62,2,4,1,'집합 연산자 4종 (UNION · UNION ALL · INTERSECT · MINUS) 특징','SQL의 집합 연산자에 대한 설명으로 가장 부적절한 것은?','집합 A = {가, 나, 다, 라},  집합 B = {다, 라, 마, 바}','["집합 A와 B의 교집합 {다, 라}를 구하는 SQL 집합 연산자는 INTERSECT이다.", "UNION은 중복을 제거하고 정렬 작업을 수행하므로 정렬·중복제거를 하지 않는 UNION ALL보다 일반적으로 느리다.", "집합 연산자 사용 시 두 SELECT 문장의 컬럼 개수와 각 위치의 데이터 타입이 일치해야 하며, 컬럼명이 다르면 첫 번째 SELECT의 컬럼명이 결과 헤더로 사용된다.", "ORDER BY 절은 집합 연산으로 연결되는 개별 SELECT 문장마다 각각 자유롭게 작성할 수 있다."]',3,'④ ORDER BY 절은 집합 연산으로 연결되는 개별 SELECT 문장마다 각각 자유롭게 작성할 수 있다.','','UNION, UNION ALL, INTERSECT, MINUS, EXCEPT, ORDER BY','집합 연산자 사용 시 ORDER BY 절은 개별 SELECT 문장 중간에 넣을 수 없고(인라인 뷰로 감싸지 않는 한), 전체 SQL 문장의 **가장 마지막에 한 번만** 사용할 수 있습니다. 참고로 SQL Server에서는 차집합 연산자로 MINUS 대신 EXCEPT를 사용합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','집합 연산자 3대 규칙: ① 컬럼 개수 동일 ② 대응 컬럼 데이터 타입 호환 ③ ORDER BY는 맨 마지막에 한 번만!');
INSERT INTO "questions" VALUES(63,3,63,2,4,1,'UNION과 UNION ALL 혼합 서브쿼리 결과 건수 추론','아래 TBL1, TBL2 테이블에 대하여 UNION과 UNION ALL이 혼합된 SQL을 수행했을 때의 결과로 가장 적절한 것은?','TBL1 (COL1, COL2)      TBL2 (COL1, COL2)
AA | A1                AA | A1
AB | A2                AB | A2
                       AC | A3
                       AD | A4

[SQL]
SELECT COL1, COL2, COUNT(*) AS CNT
FROM (
  SELECT COL1, COL2 FROM TBL1
  UNION
  SELECT COL1, COL2 FROM TBL2
  UNION ALL
  SELECT COL1, COL2 FROM TBL1
)
GROUP BY COL1, COL2
ORDER BY COL1;','["(AA,A1,2), (AB,A2,2), (AC,A3,1), (AD,A4,1)", "(AA,A1,3), (AB,A2,3), (AC,A3,1), (AD,A4,1)", "(AA,A1,1), (AB,A2,1), (AC,A3,1), (AD,A4,1)", "(AA,A1,3), (AB,A2,3), (AC,A3,2), (AD,A4,2)"]',0,'① (AA,A1,2), (AB,A2,2), (AC,A3,1), (AD,A4,1)','','UNION, UNION ALL, 집합 연산 우선순위, 위에서 아래로','동일한 우선순위를 갖는 집합 연산자(UNION, UNION ALL)는 **위에서 아래로** 순차 평가됩니다.
1단계 `TBL1 UNION TBL2`: 중복 제거되어 {(AA,A1), (AB,A2), (AC,A3), (AD,A4)} 4건.
2단계 `UNION ALL TBL1`: 중복 허용해 {(AA,A1), (AB,A2)} 2건 추가.
따라서 GROUP BY 결과 AA와 AB는 CNT=2, AC와 AD는 CNT=1이 됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','Oracle에서 INTERSECT는 UNION/UNION ALL/MINUS보다 우선순위가 높으며, 나머지는 위에서 아래로 실행됩니다.');
INSERT INTO "questions" VALUES(64,3,64,2,4,1,'서브쿼리의 사용 위치 및 특징 판별','아래 서브쿼리에 대한 설명 중 옳은 것끼리만 묶인 것은?','가) 서브쿼리는 단일 행(Single Row) 또는 복수 행(Multi Row) 비교 연산자와 함께 사용할 수 있다.
나) 서브쿼리는 SELECT 절, FROM 절, WHERE 절, HAVING 절, ORDER BY 절 등에서 사용할 수 있다.
다) 서브쿼리의 결과가 복수 행을 반환하는 경우에는 ''='', ''<='', ''>='' 등의 단일 행 연산자와 함께 사용할 수 없다.
라) 연관(Correlated) 서브쿼리는 서브쿼리가 메인쿼리 컬럼을 전혀 포함하지 않고 독립적으로 실행되는 서브쿼리이다.','["나, 라", "가, 나, 라", "가, 나, 다", "가, 다, 라"]',2,'③ 가, 나, 다','','서브쿼리, 연관 서브쿼리, 인라인뷰, 스칼라 서브쿼리','라)는 비연관(Uncorrelated) 서브쿼리에 대한 설명입니다. 연관(Correlated) 서브쿼리는 서브쿼리 내부에 메인쿼리의 컬럼을 참조하여 메인쿼리의 각 행마다 반복 실행되는 서브쿼리입니다. 참고로 GROUP BY 절에는 서브쿼리를 사용할 수 없습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','서브쿼리 불가 위치: GROUP BY 절! | 서브쿼리 내 ORDER BY: 인라인 뷰(Top-N) 외 일반 중첩 서브쿼리에서는 불가.');
INSERT INTO "questions" VALUES(65,3,65,2,4,1,'다중 행 서브쿼리 비교 연산자 (IN · ANY · ALL · > ALL vs > ANY)','서브쿼리가 {100, 200, 300} 3개의 값을 반환할 때, 메인쿼리 조건식의 의미와 단일행/다중행 연산자 사용 규칙으로 가장 부적절한 것은?','WHERE SAL > ANY (100, 200, 300)
WHERE SAL > ALL (100, 200, 300)','["WHERE SAL > ANY (100, 200, 300) 은 SAL > 100 (서브쿼리 결과의 최솟값보다 큼)과 동일하다.", "WHERE SAL > ALL (100, 200, 300) 은 SAL > 300 (서브쿼리 결과의 최댓값보다 큼)과 동일하다.", "다중 행 서브쿼리 연산자(IN, ANY, ALL)는 서브쿼리가 우연히 1건 이하의 행만 반환하는 경우에도 문법적으로 사용할 수 있다.", "WHERE SAL <> ANY (100, 200, 300) 은 SAL이 100, 200, 300 중 어느 것과도 같지 않은 행만 출력한다."]',3,'④ WHERE SAL <> ANY (100, 200, 300) 은 SAL이 100, 200, 300 중 어느 것과도 같지 않은 행만 출력한다.','','ANY, ALL, IN, <> ANY 함정, 다중행 서브쿼리','`ANY`는 OR 조건입니다. 따라서 `SAL <> ANY (100, 200, 300)`은 `(SAL != 100 OR SAL != 200 OR SAL != 300)`이 되므로 SAL이 100이어도 `100 != 200`이 참이 되어 NULL을 제외한 **모든 행이 참**이 됩니다! 어느 것과도 같지 않으려면 `<> ALL` (또는 `NOT IN`)을 써야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','ANY = OR (하나라도 만족) | ALL = AND (모두 만족). `<> ANY` 함정에 절대 속지 마세요!');
INSERT INTO "questions" VALUES(66,3,66,2,4,1,'연관 서브쿼리와 EXISTS 연산자 동작 결과 건수','아래 STUDENT와 DEPARTMENT 테이블에 대하여 EXISTS를 사용한 SQL 문장의 실행 결과 건수로 올바른 것은?','STUDENT (student_id, st_name, dept_id)
101 Yoo 1 | 102 Kim 3 | 103 Lee 2 | 104 Park 1 | 105 Choi 2 | 106 Jeong 1

DEPARTMENT (dept_id, dept_name)
1 컴퓨터공학과 | 2 원자력공학과 | 3 전자계산학과

[SQL]
SELECT COUNT(*)
FROM student s
WHERE EXISTS (
  SELECT 1 FROM department d
  WHERE s.dept_id = d.dept_id AND d.dept_id = 3
);','["0", "1", "3", "6"]',1,'② 1','','EXISTS, 연관 서브쿼리, Semi-Join, COUNT(*)','EXISTS는 서브쿼리의 SELECT 절 값(1, ''X'' 등)과 무관하게 서브쿼리를 만족하는 행이 1건이라도 존재하면 TRUE를 반환합니다. dept_id가 3인 학생은 (102 Kim 3) 1명뿐이므로 COUNT(*)는 1입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','EXISTS는 조건을 만족하는 첫 번째 행을 찾는 즉시 TRUE를 반환하고 탐색을 멈추므로(Short-circuit) 대용량에서 IN보다 유리할 때가 많습니다.');
INSERT INTO "questions" VALUES(67,3,67,2,4,1,'EXISTS 서브쿼리 내 HAVING COUNT(*) 비교 해석','아래 [회원], [메일발송], [이벤트] 테이블 모델을 기준으로 작성된 SQL 문장에 대한 설명으로 가장 올바른 것은?','회원(회원ID, 회원명, 이메일) / 이벤트(이벤트ID, 시작일자) / 메일발송(이벤트ID, 회원ID, 발송일자)

SELECT A.회원ID, A.회원명, A.이메일
FROM 회원 A
WHERE EXISTS (
  SELECT 1
  FROM 이벤트 B, 메일발송 C
  WHERE B.시작일자 >= ''2021.10.01''       -- ⓐ
    AND B.이벤트ID = C.이벤트ID
    AND A.회원ID = C.회원ID             -- ⓑ
  HAVING COUNT(*) < (
    SELECT COUNT(*) FROM 이벤트 WHERE 시작일자 >= ''2021.10.01''
  )                                     -- ⓒ
);','["2021.10.01 이후 시작된 이벤트에 대해 메일 발송 기록이 있는 모든 회원을 추출하는 SQL이다.", "ⓑ를 제거하고 EXISTS 연산자를 IN 연산자로 변경해도 결과는 항상 동일하다.", "ⓒ는 2021.10.01 이후 시작된 전체 이벤트 건수와 해당 회원의 발송 건수를 비교해 일부만 발송된(전체 미만) 회원을 판별하는 조건이다.", "GROUP BY 없이 HAVING 절을 단독으로 사용했으므로 문법 에러가 발생한다."]',2,'③ ⓒ는 2021.10.01 이후 시작된 전체 이벤트 건수와 해당 회원의 발송 건수를 비교해 일부만 발송된(전체 미만) 회원을 판별하는 조건이다.','','EXISTS, HAVING COUNT(*), GROUP BY 생략, 연관 서브쿼리','서브쿼리 전체가 하나의 그룹으로 집계될 때는 GROUP BY 없이도 HAVING COUNT(*)를 사용할 수 있습니다(④ 오답). 단, 메일발송 기록이 0건인 회원은 COUNT(*)=0 이 되어 조건 `0 < 전체이벤트수`를 만족하므로 결국 메일발송이 1건도 없거나 일부만 발송된 회원이 조회됩니다(① 오답). ③이 정확한 해석입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','GROUP BY 없이 SELECT/HAVING에 집계함수를 쓰면 테이블 전체를 1개 그룹으로 봅니다!');
INSERT INTO "questions" VALUES(68,4,68,2,4,1,'다중 컬럼 서브쿼리 (Pairwise vs Unpairwise 비교)','EMP 테이블에 아래 데이터가 존재할 때, Pairwise 다중 컬럼 서브쿼리(SQL1)와 Unpairwise 단일 컬럼 서브쿼리 조합(SQL2)의 결과 건수 차이로 올바른 것은?','EMP (EMPNO, DEPTNO, SAL)
(1, 10, 1000), (2, 20, 2000), (3, 10, 2000), (4, 20, 1000)
-- 조건 대상: (DEPTNO=10, SAL=1000) 과 (DEPTNO=20, SAL=2000)

SQL1) SELECT EMPNO FROM EMP
      WHERE (DEPTNO, SAL) IN ((10, 1000), (20, 2000));

SQL2) SELECT EMPNO FROM EMP
      WHERE DEPTNO IN (10, 20) AND SAL IN (1000, 2000);','["SQL1: 2건, SQL2: 4건", "SQL1: 4건, SQL2: 2건", "SQL1: 2건, SQL2: 2건", "SQL1: 오류발생, SQL2: 4건"]',0,'① SQL1: 2건, SQL2: 4건','','다중 컬럼 서브쿼리, Pairwise, Unpairwise','SQL1(Pairwise)은 (DEPTNO, SAL) 쌍이 정확히 (10, 1000) 또는 (20, 2000)인 행만 선택하므로 1, 2번 2건만 출력됩니다. 반면 SQL2(Unpairwise)는 DEPTNO가 10 또는 20이면서 SAL이 1000 또는 2000인 모든 조합((10, 2000), (20, 1000) 포함)을 허용하므로 1, 2, 3, 4번 총 4건이 출력됩니다.','SQLD 2024 개정 출제기준 핵심문제','참고: SQL Server는 `(A, B) IN (SELECT ...)` 다중 컬럼 쌍 비교 문법을 직접 지원하지 않으며 Oracle 등에서 지원합니다.');
INSERT INTO "questions" VALUES(69,5,69,2,4,1,'NOT IN과 NOT EXISTS에서 NULL 값 포함 시 동작 차이','서브쿼리의 반환 결과 집합에 NULL 값이 포함되어 있을 때(예: {10, 20, NULL}), `WHERE DEPTNO NOT IN (서브쿼리)`의 결과 건수가 0건이 되는 이유와 해결 방법으로 가장 적절한 것은?','SELECT ENAME FROM EMP
WHERE DEPTNO NOT IN (SELECT DEPTNO FROM DEPT_TEMP); -- 결과: (10, 20, NULL)','["NOT IN은 내부적으로 OR 조건으로 전개되며 NULL 비교가 TRUE가 되어 전체가 0건이 된다.", "NOT IN은 `DEPTNO != 10 AND DEPTNO != 20 AND DEPTNO != NULL`로 전개되며, `!= NULL`이 UNKNOWN이 되어 전체 AND가 FALSE(UNKNOWN) 처리된다. 서브쿼리에 IS NOT NULL 조건을 추가하거나 NOT EXISTS를 써야 한다.", "IN 연산자 역시 서브쿼리에 NULL이 포함되면 무조건 결과 건수가 0건이 된다.", "NOT EXISTS도 서브쿼리 결과에 NULL이 있으면 무조건 0건을 반환한다."]',1,'② NOT IN은 `DEPTNO != 10 AND DEPTNO != 20 AND DEPTNO != NULL`로 전개되며, `!= NULL`이 UNKNOWN이 되어 전체 AND가 FALSE(UNKNOWN) 처리된다. 서브쿼리에 IS NOT NULL 조건을 추가하거나 NOT EXISTS를 써야 한다.','','NOT IN, NOT EXISTS, NULL, UNKNOWN, 3값 논리','IN은 OR 조건이므로 NULL이 섞여 있어도 다른 일치 값(TRUE OR UNKNOWN = TRUE)을 반환하지만, NOT IN은 AND 조건이므로 하나라도 UNKNOWN이 되면 전체가 UNKNOWN이 되어 0건이 반환됩니다. NOT EXISTS는 조인 조건 매칭 여부(TRUE/FALSE)만 보므로 NULL이 있어도 정상 동작합니다.','K-Cert Hub SQLD 미니팩 계승 (2024 개정 기준)','SQLD & 정처기 실기 부동의 1위 함정! `NOT IN (NULL)` = 0건 | `NOT EXISTS` = 정상 반환.');
INSERT INTO "questions" VALUES(70,4,70,2,4,1,'스칼라 서브쿼리(Scalar Subquery) 반환 행 수 제약과 NULL 처리','SELECT 절에 위치하는 스칼라 서브쿼리(Scalar Subquery)에 대한 설명으로 가장 부적절한 것은?','SELECT E.EMPNO, E.ENAME,
       (SELECT D.DNAME FROM DEPT D WHERE D.DEPTNO = E.DEPTNO) AS DNAME
FROM EMP E;','["스칼라 서브쿼리는 한 행, 한 컬럼(1×1)의 단일 값만 반환해야 한다.", "스칼라 서브쿼리가 특정 메인 행에 대해 2건 이상의 행을 반환하면 런타임 에러가 발생한다.", "스칼라 서브쿼리에서 조건을 만족하는 행이 0건이면 에러가 발생하지 않고 NULL을 반환한다(OUTER JOIN과 유사).", "스칼라 서브쿼리 내부에서는 메인쿼리(EMP E)의 컬럼을 참조할 수 없다."]',3,'④ 스칼라 서브쿼리 내부에서는 메인쿼리(EMP E)의 컬럼을 참조할 수 없다.','','스칼라 서브쿼리, 단일값, 2건 이상 에러, 0건 NULL','스칼라 서브쿼리는 위 예제(`WHERE D.DEPTNO = E.DEPTNO`)처럼 메인쿼리의 컬럼을 참조하는 연관 서브쿼리 형태로 매우 자주 사용됩니다. 0건 반환 시 NULL을 반환해 LEFT OUTER JOIN과 유사한 결과를 내며, 2건 이상 반환 시 오류가 발생합니다.','SQLD 2024 개정 출제기준 핵심문제','스칼라 서브쿼리 3원칙: 1건=값, 0건=NULL, 2건 이상=에러!');
INSERT INTO "questions" VALUES(71,5,71,2,4,2,'LEFT OUTER JOIN ON 절 vs WHERE 절 필터 조건 위치 (단답)','LEFT OUTER JOIN 수행 시 기준 테이블(왼쪽)의 모든 행을 NULL 매칭 포함하여 그대로 유지하면서 오른쪽 테이블(B)의 조건(예: B.STATUS = ''Y'')만 조인 단계에서 거르고 싶다면, 해당 조건은 WHERE 절이 아닌 어느 절에 작성해야 하는지 대문자로 쓰시오.','SELECT A.ID, B.VAL
FROM TBL_A A LEFT OUTER JOIN TBL_B B
  (    ) (A.ID = B.ID AND B.STATUS = ''Y'');','[]',-1,'ON','ON|on|ON 절|ON절','LEFT OUTER JOIN, ON 절, 조인 조건','OUTER JOIN에서 비기준(오른쪽) 테이블에 대한 필터 조건을 WHERE 절에 두면 NULL로 채워진 행들이 모두 제거되어 INNER JOIN과 같은 결과가 됩니다. 조인 대상만 제한하고 왼쪽 행을 보존하려면 반드시 ON 절에 함께 기술해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','OUTER JOIN에서 오른쪽 테이블 필터 조건 = ON 절에 위치!');
INSERT INTO "questions" VALUES(72,5,72,2,4,2,'NOT IN 서브쿼리 NULL 함정 회피 대체 연산자 (단답)','서브쿼리 결과에 NULL 값이 포함되어 있을 때 `NOT IN` 사용 시 0건이 반환되는 문제를 회피하기 위해, 서브쿼리에 `IS NOT NULL`을 추가하는 방법 외에 `NOT IN` 대신 사용할 수 있는 SQL 연산자 키워드를 대문자로 쓰시오.','SELECT * FROM DEPT D
WHERE (        ) (SELECT 1 FROM EMP E WHERE E.DEPTNO = D.DEPTNO);','[]',-1,'NOT EXISTS','NOT EXISTS|not exists','NOT EXISTS, NOT IN, NULL 안전성','NOT EXISTS는 서브쿼리에서 조인 조건에 일치하는 행의 존재 여부(TRUE/FALSE)만 검사하므로 서브쿼리 테이블의 컬럼에 NULL이 존재하더라도 0건이 되는 함정 없이 정확히 차집합 결과를 반환합니다.','K-Cert Hub SQLD 미니팩 계승 (2024 개정 기준)','Anti-Join 구현 시 NULL 안전성을 위해 `NOT EXISTS` 사용을 습관화하세요.');
INSERT INTO "questions" VALUES(73,3,73,2,5,1,'GROUPING SETS 함수의 특징과 총계 출력 방법','GROUP BY 절에 사용하는 GROUPING SETS 함수에 대한 설명으로 가장 부적절한 것은?','SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
GROUP BY GROUPING SETS (DEPTNO, JOB, ());','["GROUPING SETS(A, B)는 GROUP BY A와 GROUP BY B의 결과를 UNION ALL 한 것과 동일하다.", "GROUPING SETS(A, B)는 인수의 나열 순서가 결과 행의 집계 구성에 영향을 주지 않는다.", "GROUPING SETS(A, B)는 기본적으로 전체 총계(Grand Total)를 함께 출력한다.", "GROUPING SETS(A, B, ())처럼 빈 괄호 () 또는 NULL을 인수로 추가하면 전체 총계도 함께 출력할 수 있다."]',2,'③ GROUPING SETS(A, B)는 기본적으로 전체 총계(Grand Total)를 함께 출력한다.','','GROUPING SETS, UNION ALL, 총계 미출력, ()','ROLLUP과 CUBE는 기본적으로 전체 총계를 포함하지만, GROUPING SETS는 명시된 그룹핑 대상들만 독립적으로 집계하므로 전체 총계를 출력하려면 반드시 `()` 또는 `NULL`을 인수로 추가해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','GROUPING SETS(A, B) = A별 + B별 (총계 X) | GROUPING SETS(A, B, ()) = A별 + B별 + 총계.');
INSERT INTO "questions" VALUES(74,3,74,2,5,1,'ROLLUP(A, B) vs ROLLUP(B, A) 계층적 소계 차이','ROLLUP 함수의 동작 원리와 컬럼 순서에 따른 결과 차이에 대한 설명으로 가장 올바른 것은?','SELECT DEPTNO, JOB, SUM(SAL) FROM EMP GROUP BY ROLLUP(DEPTNO, JOB);
SELECT DEPTNO, JOB, SUM(SAL) FROM EMP GROUP BY ROLLUP(JOB, DEPTNO);','["ROLLUP(A, B)와 ROLLUP(B, A)는 나열 순서와 무관하게 항상 동일한 소계 그룹들을 출력한다.", "ROLLUP(A, B)는 (A, B)별 집계, A별 소계, 전체 총계 3가지 레벨을 출력하므로 인수의 순서에 따라 소계 기준이 달라진다.", "ROLLUP(A, B)는 B별 소계까지 자동으로 함께 출력한다.", "ROLLUP(A, B, C)는 총 2^3 = 8가지 레벨의 집계를 생성한다."]',1,'② ROLLUP(A, B)는 (A, B)별 집계, A별 소계, 전체 총계 3가지 레벨을 출력하므로 인수의 순서에 따라 소계 기준이 달라진다.','','ROLLUP, 계층적 소계, 순서 중요, N+1 레벨','ROLLUP은 오른쪽에서 왼쪽으로 컬럼을 하나씩 빼며 계층적 소계를 생성합니다. `ROLLUP(A, B)`는 `(A, B) → (A) → ()` 순서로 N+1=3가지 레벨을 출력하며, `ROLLUP(B, A)`는 `(B, A) → (B) → ()`를 출력하므로 순서가 중요합니다. 2^N개를 생성하는 것은 CUBE입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','ROLLUP(A, B) != ROLLUP(B, A) [순서 중요!] | CUBE(A, B) == CUBE(B, A) [순서 무관].');
INSERT INTO "questions" VALUES(75,4,75,2,5,1,'CUBE(A, B)와 GROUPING SETS 등가 변환','아래 `GROUP BY CUBE(DEPTNO, JOB)` 문장과 완전히 동일한 집계 결과를 출력하는 GROUPING SETS 표현식은?','SELECT DEPTNO, JOB, SUM(SAL) AS TOTAL_SAL
FROM EMP
GROUP BY CUBE(DEPTNO, JOB);','["GROUP BY GROUPING SETS ((DEPTNO, JOB), DEPTNO, ())", "GROUP BY GROUPING SETS ((DEPTNO, JOB), DEPTNO, JOB)", "GROUP BY GROUPING SETS ((DEPTNO, JOB), DEPTNO, JOB, ())", "GROUP BY GROUPING SETS (DEPTNO, JOB, ())"]',2,'③ GROUP BY GROUPING SETS ((DEPTNO, JOB), DEPTNO, JOB, ())','','CUBE, GROUPING SETS, 다차원 조합, 2^N','CUBE(DEPTNO, JOB)는 가능한 모든 다차원 조합인 ① (DEPTNO, JOB)별, ② DEPTNO별, ③ JOB별, ④ 전체 총계 () 총 2^2 = 4가지 레벨을 출력합니다. 참고로 ①번은 `ROLLUP(DEPTNO, JOB)`과 동일한 표현입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','CUBE(A, B) = GROUPING SETS((A, B), A, B, ()) | ROLLUP(A, B) = GROUPING SETS((A, B), A, ()).');
INSERT INTO "questions" VALUES(76,5,76,2,5,1,'ROLLUP vs CUBE vs GROUPING SETS 출력 행 수 비교','GROUP BY 대상 컬럼 (A, B)에서 A의 고유값이 3개, B의 고유값이 2개이고 모든 (A, B) 조합이 최소 1건씩 존재할 때, ROLLUP(A, B), CUBE(A, B), GROUPING SETS(A, B)를 실행한 총 출력 행의 개수를 순서대로 바르게 나열한 것은?','-- A 고유값: 3개 (a1, a2, a3)
-- B 고유값: 2개 (b1, b2)
-- (A, B) 실제 조합: 3 × 2 = 6개','["ROLLUP: 10행, CUBE: 12행, GROUPING SETS: 5행", "ROLLUP: 9행, CUBE: 12행, GROUPING SETS: 6행", "ROLLUP: 10행, CUBE: 11행, GROUPING SETS: 5행", "ROLLUP: 9행, CUBE: 11행, GROUPING SETS: 5행"]',0,'① ROLLUP: 10행, CUBE: 12행, GROUPING SETS: 5행','','ROLLUP 행 수, CUBE 행 수, GROUPING SETS 행 수','• ROLLUP(A, B): (A, B) 6행 + (A) 3행 + () 1행 = 10행
• CUBE(A, B): (A, B) 6행 + (A) 3행 + (B) 2행 + () 1행 = 12행
• GROUPING SETS(A, B): (A) 3행 + (B) 2행 = 5행.','K-Cert Hub SQLD 미니팩 계승 (2024 개정 기준)','조합별 행 수를 직접 더해 검산하면 실수를 완전히 없앨 수 있습니다.');
INSERT INTO "questions" VALUES(77,4,77,2,5,1,'GROUPING() 함수 반환값과 소계/총계 라벨링','ROLLUP 또는 CUBE와 함께 사용하는 `GROUPING(컬럼)` 함수에 대한 설명과 아래 SQL의 출력 라벨로 가장 적절한 것은?','SELECT CASE GROUPING(DEPTNO) WHEN 1 THEN ''ALL_DEPT'' ELSE TO_CHAR(DEPTNO) END AS DEPT,
       CASE GROUPING(JOB)    WHEN 1 THEN ''ALL_JOB''  ELSE JOB END AS JOB,
       SUM(SAL) AS TOTAL_SAL
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB);','["GROUPING(컬럼)은 해당 컬럼이 소계/총계 계산으로 인해 NULL로 집계된 행이면 1, 일반 데이터 그룹 행이면 0을 반환한다.", "GROUPING(컬럼)은 일반 그룹 행이면 1, 소계/총계 행이면 0을 반환한다.", "전체 총계(Grand Total) 행에서는 DEPT = 실제부서코드, JOB = ALL_JOB 으로 출력된다.", "원본 데이터의 DEPTNO에 실제 NULL 값이 존재하면 GROUPING(DEPTNO)는 1을 반환한다."]',0,'① GROUPING(컬럼)은 해당 컬럼이 소계/총계 계산으로 인해 NULL로 집계된 행이면 1, 일반 데이터 그룹 행이면 0을 반환한다.','','GROUPING 함수, 소계 1, 일반행 0, NULL 구분','GROUPING(컬럼)은 해당 컬럼이 GROUP BY 집계(소계/총계)에 의해 생략된 행이면 1, 실제 데이터 그룹이면 0을 반환합니다. 따라서 원본 데이터 자체에 들어있는 NULL(그룹핑 결과 NULL이 아닌 실제 NULL)에 대해서는 0을 반환하여 소계 NULL과 정확히 구별할 수 있습니다.','SQLD 2024 개정 출제기준 핵심문제','GROUPING(col) = 1 이면 "소계/총계로 합쳐진 행"! 전체 총계 행은 둘 다 1이므로 (ALL_DEPT, ALL_JOB).');
INSERT INTO "questions" VALUES(78,5,78,2,5,1,'RANK() vs DENSE_RANK() vs ROW_NUMBER() 동점자 순위 비교','점수(SCORE)가 (100, 90, 90, 80)인 4명의 학생에 대해 내림차순으로 `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`를 각각 적용했을 때 출력되는 순위 결과를 순서대로 나열한 것은?','SELECT SCORE,
       RANK() OVER (ORDER BY SCORE DESC) AS R1,
       DENSE_RANK() OVER (ORDER BY SCORE DESC) AS R2,
       ROW_NUMBER() OVER (ORDER BY SCORE DESC) AS R3
FROM STUDENT;','["RANK: (1,2,2,4) / DENSE_RANK: (1,2,2,3) / ROW_NUMBER: (1,2,3,4)", "RANK: (1,2,2,3) / DENSE_RANK: (1,2,2,4) / ROW_NUMBER: (1,2,3,4)", "RANK: (1,2,3,4) / DENSE_RANK: (1,2,2,3) / ROW_NUMBER: (1,2,2,4)", "RANK: (1,2,2,4) / DENSE_RANK: (1,2,3,4) / ROW_NUMBER: (1,2,2,3)"]',0,'① RANK: (1,2,2,4) / DENSE_RANK: (1,2,2,3) / ROW_NUMBER: (1,2,3,4)','','RANK, DENSE_RANK, ROW_NUMBER, 동점자 처리','• RANK(): 동점자에게 같은 순위 부여 후 다음 순위를 건너뜀 (1, 2, 2, 4)
• DENSE_RANK(): 동점자에게 같은 순위 부여 후 다음 순위를 연속 부여 (1, 2, 2, 3)
• ROW_NUMBER(): 동점자 여부와 무관하게 고유한 일련번호 부여 (1, 2, 3, 4).','K-Cert Hub SQLD 미니팩 계승 (2024 개정 기준)','세 순위 함수 모두 OVER() 내부에 ORDER BY 절이 필수입니다!');
INSERT INTO "questions" VALUES(79,3,79,2,5,1,'ROW_NUMBER() OVER(PARTITION BY ... ORDER BY ...) 그룹별 Top-1 추출','아래 추천내역 테이블에서 SQL을 수행했을 때 출력되는 결과로 가장 적절한 것은?','테이블: 추천내역 (추천경로, 추천인, 피추천인, 추천점수)
SNS      | 나한일 | 강감찬 | 75
SNS      | 이순신 | 강감찬 | 90
이벤트   | 홍길동 | 강감찬 | 80
이벤트   | 정치인 | 이순신 | 78
홈페이지 | 정치인 | 허민   | 93
홈페이지 | 홍두깨 | 심청이 | 99

[SQL]
SELECT 추천경로, 추천인, 피추천인, 추천점수
FROM (
  SELECT 추천경로, 추천인, 피추천인, 추천점수,
         ROW_NUMBER() OVER (PARTITION BY 추천경로 ORDER BY 추천점수 DESC) AS RNUM
  FROM 추천내역
)
WHERE RNUM = 1;','["(SNS, 나한일, 강감찬, 75), (이벤트, 정치인, 이순신, 78), (홈페이지, 정치인, 허민, 93)", "(홈페이지, 홍두깨, 심청이, 99) 1건만 출력", "(SNS, 이순신, 강감찬, 90), (이벤트, 홍길동, 강감찬, 80), (홈페이지, 홍두깨, 심청이, 99)", "전체 6건이 추천점수 내림차순으로 모두 출력"]',2,'③ (SNS, 이순신, 강감찬, 90), (이벤트, 홍길동, 강감찬, 80), (홈페이지, 홍두깨, 심청이, 99)','','ROW_NUMBER, PARTITION BY, 그룹별 1위 추출, 인라인뷰','`PARTITION BY 추천경로`로 추천경로별 그룹을 나누고 `ORDER BY 추천점수 DESC`로 각 그룹 내에서 점수가 가장 높은 행에 RNUM=1을 부여했습니다. 바깥 쿼리에서 `WHERE RNUM = 1`로 필터링하므로 각 추천경로별 최고 점수 행 3건이 출력됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','그룹별 최대/최소 1건 추출 패턴: 인라인뷰에서 `ROW_NUMBER() OVER(PARTITION BY 그룹 ORDER BY 기준 DESC)` 후 `WHERE RN = 1`.');
INSERT INTO "questions" VALUES(80,4,80,2,5,1,'RANK(값) WITHIN GROUP (ORDER BY ...) 일반 집계 함수형 순위','윈도우 함수가 아닌 일반 집계 함수 형태로 특정 값(예: 급여 3000)이 테이블 내 정렬 순서에서 몇 번째 순위에 해당하는지 확인하려 할 때 사용하는 올바른 SQL 구문은?','EMP 급여 데이터: (800, 1600, 2975, 3000, 5000)','["SELECT RANK(3000) OVER (ORDER BY SAL DESC) FROM EMP;", "SELECT RANK(3000) WITHIN GROUP (ORDER BY SAL DESC) FROM EMP;", "SELECT WITHIN GROUP (ORDER BY SAL DESC) RANK(3000) FROM EMP;", "SELECT DENSE_RANK() WITHIN GROUP (3000 ORDER BY SAL DESC) FROM EMP;"]',1,'② SELECT RANK(3000) WITHIN GROUP (ORDER BY SAL DESC) FROM EMP;','','RANK WITHIN GROUP, 가상 순위, 일반 집계함수','`RANK(값) WITHIN GROUP (ORDER BY 컬럼 [ASC|DESC])`는 해당 값이 정렬된 데이터 집합에 포함된다고 가정했을 때의 순위를 반환하는 집계 함수(1행 반환)입니다. 위 급여 데이터(5000, 3000, 2975, 1600, 800) 내림차순에서 3000의 순위는 2가 됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','RANK(값) 뒤에는 OVER가 아니라 `WITHIN GROUP (ORDER BY ...)`가 옵니다!');
INSERT INTO "questions" VALUES(81,4,81,2,5,1,'윈도우 함수 OVER 절 내부 문법 순서 및 특징','윈도우 함수(Window Function)에 대한 설명으로 가장 부적절한 것은?','SELECT ENAME, DEPTNO, SAL,
       SUM(SAL) OVER (PARTITION BY DEPTNO ORDER BY EMPNO) AS CUM_SAL
FROM EMP;','["윈도우 함수는 GROUP BY를 사용하지 않고도 기존 행의 수를 유지하면서 그룹별 합계·평균·순위 등을 함께 출력할 수 있다.", "OVER() 절 내부에서 절의 기술 순서는 반드시 PARTITION BY → ORDER BY → ROWS|RANGE 순서를 지켜야 한다.", "윈도우 함수는 SELECT 절이나 ORDER BY 절에서는 사용할 수 있으나, WHERE 절에서는 직접 사용할 수 없다.", "집계형 윈도우 함수(SUM, AVG, MIN, MAX, COUNT)를 사용할 때도 OVER() 내부에 ORDER BY 절을 반드시 생략 없이 적어야 한다."]',3,'④ 집계형 윈도우 함수(SUM, AVG, MIN, MAX, COUNT)를 사용할 때도 OVER() 내부에 ORDER BY 절을 반드시 생략 없이 적어야 한다.','','윈도우 함수, OVER 절 순서, WHERE 사용 불가, 누적합','순위 함수(RANK, DENSE_RANK, ROW_NUMBER), LAG/LEAD, NTILE 등은 ORDER BY가 필수이지만, 집계형 윈도우 함수(`SUM(SAL) OVER(PARTITION BY DEPTNO)` 또는 `SUM(SAL) OVER()`)는 ORDER BY를 생략하면 해당 파티션/전체 합계를 출력하며, ORDER BY를 적으면 누적합으로 동작합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','WHERE 절은 윈도우 함수보다 먼저 실행되므로 윈도우 함수 결과를 조건으로 쓰려면 인라인 뷰로 감싸야 합니다.');
INSERT INTO "questions" VALUES(82,3,82,2,5,1,'윈도우 프레임 ROWS vs RANGE 기본값(동점자 누적합 차이)','아래 T_WIN 테이블에 대해 SQL1(프레임 생략: 기본 RANGE)과 SQL2(ROWS 지정)를 실행했을 때, 각 행의 S1, S2 출력 결과로 올바른 것은?','T_WIN
ID | AMT
1  | 100
2  | 200
3  | 200
4  | 300

[SQL]
SELECT ID, AMT,
       SUM(AMT) OVER (ORDER BY AMT) AS S1,
       SUM(AMT) OVER (ORDER BY AMT ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS S2
FROM T_WIN;','["S1: (100, 500, 500, 800) / S2: (100, 300, 500, 800)", "S1: (100, 300, 500, 800) / S2: (100, 500, 500, 800)", "S1: (100, 300, 500, 800) / S2: (100, 300, 500, 800)", "S1: (100, 500, 500, 800) / S2: (100, 500, 500, 800)"]',0,'① S1: (100, 500, 500, 800) / S2: (100, 300, 500, 800)','','ROWS, RANGE, 기본 윈도우 프레임, 동점자 누적합','OVER 절에 ORDER BY만 있고 프레임을 생략하면 기본값은 `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`입니다. RANGE는 논리적 값 기준이므로 AMT가 200으로 같은 ID=2, 3 행을 하나의 묶음으로 처리해 둘 다 100+200+200 = 500이 됩니다. 반면 ROWS는 물리적 행 기준이므로 ID=2는 300, ID=3은 500이 됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','ORDER BY만 있을 때 기본값 = RANGE (동점자 한꺼번에 합산)! 물리적 순차 누적은 반드시 `ROWS` 명시!');
INSERT INTO "questions" VALUES(83,4,83,2,5,1,'윈도우 프레임 BETWEEN N PRECEDING AND N FOLLOWING 이동합 계산','아래 T_SALE 테이블에 대해 이동합 윈도우 함수를 실행했을 때, 3번째 행(DAY=3)과 4번째 행(DAY=4)의 MOV_SUM 값을 순서대로 바르게 나열한 것은?','T_SALE (DAY, AMT)
(1, 10), (2, 20), (3, 30), (4, 40)

[SQL]
SELECT DAY, AMT,
       SUM(AMT) OVER (ORDER BY DAY ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MOV_SUM
FROM T_SALE;','["60, 90", "90, 70", "60, 70", "50, 90"]',1,'② 90, 70','','ROWS BETWEEN, PRECEDING, FOLLOWING, 이동합','`ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING`은 [바로 앞 1행 ~ 현재 행 ~ 바로 뒤 1행]의 합을 구합니다.
• DAY=1: (10 + 20) = 30
• DAY=2: (10 + 20 + 30) = 60
• DAY=3: (20 + 30 + 40) = 90
• DAY=4: (30 + 40) = 70 (뒤 행 없음).','SQLD 2024 개정 출제기준 핵심문제','PRECEDING(이전 행), CURRENT ROW(현재 행), FOLLOWING(이후 행).');
INSERT INTO "questions" VALUES(84,4,84,2,5,1,'윈도우 프레임 시작점·끝점 키워드 사용 제약','윈도우 함수의 `ROWS|RANGE BETWEEN A AND B` 구문에서 시작점(A)과 끝점(B) 지정 시 문법 오류가 발생하는 잘못된 표현은?','','["ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW", "ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING", "ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING", "ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEDING"]',3,'④ ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEDING','','UNBOUNDED PRECEDING, UNBOUNDED FOLLOWING, 윈도우 프레임 제약','UNBOUNDED PRECEDING(파티션의 맨 처음 행)은 끝점(B)에 사용할 수 없으며, 반대로 UNBOUNDED FOLLOWING(파티션의 맨 마지막 행)은 시작점(A)에 사용할 수 없습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','시작점 A는 항상 끝점 B보다 앞이거나 같아야 합니다(UNBOUNDED PRECEDING은 시작점 전용, UNBOUNDED FOLLOWING은 끝점 전용).');
INSERT INTO "questions" VALUES(85,3,85,2,5,1,'LAG()와 LEAD() 이전 행 · 이후 행 참조 함수','아래 EMP 테이블 데이터에 대하여 LAG 및 LEAD 함수를 사용한 SQL을 실행했을 때, 각 행의 PREV_SAL, NEXT_SAL 값 중 ''C'' 사원의 (PREV_SAL, NEXT_SAL) 결과로 올바른 것은?','EMP (ENAME, SAL)
A | 1000
B | 2000
C | 3000

[SQL]
SELECT ENAME, SAL,
       LAG(SAL, 2, 0) OVER (ORDER BY SAL) AS PREV_SAL,
       LEAD(SAL, 1, -1) OVER (ORDER BY SAL) AS NEXT_SAL
FROM EMP;','["(1000, -1)", "(2000, 0)", "(1000, 0)", "(0, -1)"]',0,'① (1000, -1)','','LAG, LEAD, offset, default 값','• `LAG(SAL, 2, 0)`: 현재 행 기준 2칸 이전 행의 SAL을 가져오고, 없으면 기본값 0을 반환합니다. C(3행)에서 2칸 이전은 A(1행)이므로 1000입니다.
• `LEAD(SAL, 1, -1)`: 현재 행 기준 1칸 이후 행의 SAL을 가져오고, 없으면 기본값 -1을 반환합니다. C(3행)는 마지막 행이므로 -1을 반환합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','LAG(컬럼, N, 기본값) = N행 이전 | LEAD(컬럼, N, 기본값) = N행 이후 (N 생략 시 1, 기본값 생략 시 NULL).');
INSERT INTO "questions" VALUES(86,4,86,2,5,1,'FIRST_VALUE()와 LAST_VALUE() 기본 프레임 함정 해결','부서 내에서 급여가 가장 높은 사원의 이름(LAST_VALUE 기준)을 모든 사원 행에 동일하게 출력하려고 아래 SQL1을 작성하였으나 의도와 다르게 각 행 자기 자신의 이름이 출력되었다. 이를 해결하기 위해 SQL2의 빈칸에 들어가야 할 프레임 지정은?','-- [SQL1: 의도 실패 — 매 행 자기 자신 출력]
SELECT ENAME, SAL, LAST_VALUE(ENAME) OVER (ORDER BY SAL) FROM EMP;

-- [SQL2: 수정]
SELECT ENAME, SAL,
       LAST_VALUE(ENAME) OVER (ORDER BY SAL (                    )) AS MAX_ENAME
FROM EMP;','["ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW", "ROWS BETWEEN CURRENT ROW AND CURRENT ROW", "ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING", "RANGE BETWEEN 1 PRECEDING AND CURRENT ROW"]',2,'③ ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING','','LAST_VALUE, FIRST_VALUE, UNBOUNDED FOLLOWING, 윈도우 프레임','ORDER BY만 쓰고 프레임을 생략하면 기본 프레임이 `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`이므로, LAST_VALUE는 매 행마다 "현재 행까지의 마지막 값(=자기 자신 또는 동점자 마지막)"을 반환합니다. 파티션 전체의 진짜 마지막 값을 보려면 끝점을 `UNBOUNDED FOLLOWING`까지 확장해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','FIRST_VALUE는 기본 프레임에서도 첫 행이 포함되어 정상 작동하지만, LAST_VALUE는 반드시 `UNBOUNDED FOLLOWING` 프레임을 명시해야 전체 최댓값이 나옵니다!');
INSERT INTO "questions" VALUES(87,4,87,2,5,1,'NTILE(N) 버킷 분할 시 나머지 행 배분 규칙','총 7명의 사원이 있는 테이블에 대해 `NTILE(3) OVER (ORDER BY SAL DESC)`를 실행했을 때, 그룹 번호(1, 2, 3)별로 배정되는 사원 수의 분포로 올바른 것은?','SELECT ENAME, SAL, NTILE(3) OVER (ORDER BY SAL DESC) AS GRP FROM EMP; -- 총 7행','["1그룹: 3명, 2그룹: 2명, 3그룹: 2명", "1그룹: 2명, 2그룹: 2명, 3그룹: 3명", "1그룹: 3명, 2그룹: 3명, 3그룹: 1명", "1그룹: 2명, 2그룹: 3명, 3그룹: 2명"]',0,'① 1그룹: 3명, 2그룹: 2명, 3그룹: 2명','','NTILE, 버킷 분할, 나머지 우선 배분','NTILE(N)은 전체 행 수(7)를 N(3)으로 나눈 몫(2)만큼 각 그룹에 기본 배정하고, 나머지(7 mod 3 = 1) 행은 **앞쪽 그룹(1번 그룹부터)에 1개씩 우선 배분**합니다. 따라서 1그룹 3명, 2그룹 2명, 3그룹 2명이 됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','NTILE 나머지 배분: 무조건 1번 버킷부터 차례로 +1명씩!');
INSERT INTO "questions" VALUES(88,4,88,2,5,1,'비율 관련 윈도우 함수 (RATIO_TO_REPORT · CUME_DIST · PERCENT_RANK)','비율 관련 윈도우 함수 3종에 대한 설명으로 가장 부적절한 것은?','-- 4개 행의 값: (100, 200, 200, 500), 합계 = 1000','["RATIO_TO_REPORT(SAL) OVER () 는 파티션 내 전체 합계(1000) 대비 현재 행 급여의 비율을 구하므로 ORDER BY 절을 함께 사용할 수 없다.", "CUME_DIST() OVER (ORDER BY SAL) 은 현재 행 이하의 누적 행 수 비율을 반환하며 결과 범위는 0 < 값 <= 1 이다.", "PERCENT_RANK() OVER (ORDER BY SAL) 은 (순위 - 1) / (전체행수 - 1) 로 계산되며 첫 번째 행은 항상 0, 결과 범위는 0 <= 값 <= 1 이다.", "SQL Server와 Oracle 모두 RATIO_TO_REPORT 함수를 표준으로 동일하게 제공한다."]',3,'④ SQL Server와 Oracle 모두 RATIO_TO_REPORT 함수를 표준으로 동일하게 제공한다.','','RATIO_TO_REPORT, CUME_DIST, PERCENT_RANK, 비율 함수','RATIO_TO_REPORT는 Oracle에서 제공하는 함수이며 SQL Server에서는 지원하지 않습니다(SQL Server에서는 `SAL / SUM(SAL) OVER()`로 계산). 또한 CUME_DIST와 PERCENT_RANK는 ORDER BY가 필수이고, RATIO_TO_REPORT는 ORDER BY를 사용할 수 없습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','CUME_DIST(0 초과~1 이하) vs PERCENT_RANK(0 이상~1 이하, 첫 행=0) | RATIO_TO_REPORT는 ORDER BY 금지!');
INSERT INTO "questions" VALUES(89,3,89,2,5,1,'계층형 질의 START WITH · CONNECT BY PRIOR 순방향/역방향 전개','사원(사원번호, 사원명, 관리자사번) 테이블에서 최상위 관리자(관리자사번 IS NULL)부터 시작하여 하위 사원으로 내려가는 **순방향 전개**를 수행하는 올바른 계층형 질의 구문은?','사원(사원번호, 사원명, 관리자사번)
• (100, 사장, NULL)
• (200, 부장, 100)
• (300, 대리, 200)','["START WITH 관리자사번 IS NULL CONNECT BY PRIOR 사원번호 = 관리자사번", "START WITH 관리자사번 IS NULL CONNECT BY PRIOR 관리자사번 = 사원번호", "START WITH 사원번호 = 300 CONNECT BY PRIOR 사원번호 = 관리자사번", "START WITH 관리자사번 IS NOT NULL CONNECT BY PRIOR 사원번호 = 관리자사번"]',0,'① START WITH 관리자사번 IS NULL CONNECT BY PRIOR 사원번호 = 관리자사번','','계층형 질의, START WITH, CONNECT BY PRIOR, 순방향 전개','`PRIOR` 키워드는 "직전(이전) 단계에서 읽은 행의 컬럼"을 의미합니다. 루트(100, 사장)에서 시작해 자식으로 내려가려면 이전 행의 `사원번호`(100)가 다음 행의 `관리자사번`(100)과 같아야 하므로 `CONNECT BY PRIOR 사원번호 = 관리자사번`이 순방향(Top-Down) 전개입니다. 반대로 `PRIOR 관리자사번 = 사원번호`는 자식이 부모를 찾는 역방향(Bottom-Up) 전개입니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','순방향 암기: `PRIOR 자식키 = 부모참조키` (예: `PRIOR 사원 = 관리자`) — PRIOR 쪽이 먼저 결정되는 부모 값!');
INSERT INTO "questions" VALUES(90,3,90,2,5,1,'계층형 질의 가상 컬럼 (LEVEL · CONNECT_BY_ISLEAF) 결과 추론','아래 계층 데이터를 대상으로 순방향 계층형 질의를 실행했을 때, 각 노드의 (LEVEL, CONNECT_BY_ISLEAF) 값으로 올바른 것은?','DEPT_HIER (DCODE, DNAME, PDEPT)
(1, ''사장실'', NULL)
(2, ''경영본부'', 1)
(3, ''개발본부'', 1)
(4, ''개발1팀'', 3)

SELECT DCODE, LEVEL, CONNECT_BY_ISLEAF AS ISLEAF
FROM DEPT_HIER
START WITH PDEPT IS NULL
CONNECT BY PRIOR DCODE = PDEPT;','["DCODE=2: (LEVEL=2, ISLEAF=1) / DCODE=3: (LEVEL=2, ISLEAF=0)", "DCODE=2: (LEVEL=2, ISLEAF=0) / DCODE=3: (LEVEL=2, ISLEAF=1)", "DCODE=1: (LEVEL=0, ISLEAF=0) / DCODE=4: (LEVEL=2, ISLEAF=1)", "DCODE=2: (LEVEL=1, ISLEAF=1) / DCODE=4: (LEVEL=3, ISLEAF=0)"]',0,'① DCODE=2: (LEVEL=2, ISLEAF=1) / DCODE=3: (LEVEL=2, ISLEAF=0)','','LEVEL, CONNECT_BY_ISLEAF, 리프 노드, 루트 레벨 1','루트(사장실, DCODE=1)의 LEVEL은 1부터 시작합니다. 경영본부(2)와 개발본부(3)는 LEVEL=2이며, 경영본부(2)는 하위에 자식 부서가 없는 최하위 노드이므로 CONNECT_BY_ISLEAF=1, 개발본부(3)는 개발1팀(4)을 자식으로 가지므로 CONNECT_BY_ISLEAF=0이 됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','루트 LEVEL = 1 | 최하위 리프 노드이면 CONNECT_BY_ISLEAF = 1, 자식이 있으면 0.');
INSERT INTO "questions" VALUES(91,4,91,2,5,1,'계층형 질의 함수 (CONNECT_BY_ROOT · SYS_CONNECT_BY_PATH · ORDER SIBLINGS BY)','Oracle 계층형 질의에서 제공하는 가상 함수 및 정렬 구문에 대한 설명으로 가장 부적절한 것은?','SELECT LEVEL, DNAME,
       CONNECT_BY_ROOT DNAME AS ROOT_NAME,
       SYS_CONNECT_BY_PATH(DNAME, ''>'') AS PATH
FROM DEPT_HIER
START WITH PDEPT IS NULL
CONNECT BY PRIOR DCODE = PDEPT
ORDER SIBLINGS BY DNAME ASC;','["CONNECT_BY_ROOT 컬럼명은 현재 행의 최상위 루트 노드에 해당하는 컬럼 값을 반환한다.", "SYS_CONNECT_BY_PATH(DNAME, ''>'')는 루트부터 현재 노드까지의 전개 경로를 구분자(''>'')로 연결하여 문자열로 반환한다.", "ORDER SIBLINGS BY는 계층 구조를 깨뜨리지 않으면서 같은 부모를 가진 형제(동일 레벨) 노드들 사이에서만 정렬을 수행한다.", "일반 ORDER BY 절을 사용하더라도 계층형 트리의 부모-자식 출력 순서는 절대로 깨지지 않는다."]',3,'④ 일반 ORDER BY 절을 사용하더라도 계층형 트리의 부모-자식 출력 순서는 절대로 깨지지 않는다.','','CONNECT_BY_ROOT, SYS_CONNECT_BY_PATH, ORDER SIBLINGS BY','계층형 질의 결과에 일반 `ORDER BY`를 사용하면 계층 트리 구조가 모두 무시되고 전체 행이 해당 컬럼 기준으로 재정렬됩니다. 계층 트리를 유지한 채 형제 노드 간 정렬을 하려면 반드시 `ORDER SIBLINGS BY`를 사용해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','계층 유지 정렬 = `ORDER SIBLINGS BY`!');
INSERT INTO "questions" VALUES(92,5,92,2,5,2,'계층형 질의 WHERE 절 vs CONNECT BY 절 조건 필터링 차이 (단답)','계층형 질의에서 특정 노드(예: 개발본부)와 그 하위 자식 노드들 전체를 아예 전개하지 않고 가지치기(Pruning)로 제외하려면 `WHERE` 절이 아니라 어느 절에 조건을 추가해야 하는지 쓰시오. (예: OOO OO)','-- ''개발본부''뿐만 아니라 그 하위 부서(개발1팀 등)까지 전부 전개에서 제외하려면?
START WITH PDEPT IS NULL
(          ) PRIOR DCODE = PDEPT AND DNAME <> ''개발본부'';','[]',-1,'CONNECT BY','CONNECT BY|connect by|CONNECT BY 절|CONNECT BY절','CONNECT BY, 가지치기, WHERE 필터링 차이','WHERE 절에 조건을 쓰면 계층 전개를 모두 끝낸 뒤 해당 노드만 결과에서 제거하므로 하위 자식 노드는 살아남습니다. 반면 CONNECT BY 절에 추가 조건을 두면 연결 조건 자체가 성립하지 않아 해당 노드와 그 하위 서브트리 전체가 전개에서 제외됩니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','서브트리 전체 제외 = CONNECT BY 절 조건 | 해당 노드 1개만 제외 = WHERE 절 조건.');
INSERT INTO "questions" VALUES(93,5,93,2,5,2,'소계와 총계 출력 결과를 보고 GROUP BY 그룹함수 채우기 (단답)','아래 BUY_HIST 조회 결과에서 (AA, 월별), (AA, 소계), (BB, 월별), (BB, 소계), ..., 마지막 행 전체 총계(16건, 1200)가 출력되었다. SQL의 빈칸 ( )에 들어갈 알맞은 그룹 함수명을 대문자로 쓰시오.','CUST_ID | MONTH  | TOTAL_CNT | TOTAL_AMT
AA      | 202001 | 1         | 234
AA      | 202002 | 2         | 54
AA      | NULL   | 3         | 288
BB      | 202001 | 3         | 65
BB      | NULL   | 3         | 65
NULL    | NULL   | 6         | 353

[SQL]
SELECT CUST_ID, MONTH, COUNT(*) "TOTAL_CNT", SUM(AMOUNT) "TOTAL_AMT"
FROM BUY_HIST
GROUP BY (        ) (CUST_ID, MONTH);','[]',-1,'ROLLUP','ROLLUP|rollup','ROLLUP, 소계, 총계, GROUP BY','결과를 보면 (CUST_ID, MONTH)별 집계, CUST_ID별 소계(MONTH=NULL), 그리고 전체 총계(둘 다 NULL)만 출력되고 MONTH별 소계(CUST_ID=NULL, MONTH=202001)는 없으므로 `ROLLUP`이 사용되었습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','CUBE였다면 (NULL, 202001) 같은 두 번째 컬럼 기준 소계 행도 함께 출력되었을 것입니다.');
INSERT INTO "questions" VALUES(94,5,94,2,5,2,'윈도우 함수 동점자 개별 행 누적합 프레임 키워드 (단답)','윈도우 함수에서 정렬 기준 컬럼(SAL)에 동일한 값이 존재할 때, 동점자를 한꺼번에 합산하지 않고 물리적인 행 순서대로 한 행씩 누적 합계를 계산하기 위해 빈칸에 들어가야 할 키워드를 대문자로 쓰시오.','SELECT ENAME, SAL,
       SUM(SAL) OVER (ORDER BY SAL (    ) BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CUM_SAL
FROM EMP;','[]',-1,'ROWS','ROWS|rows','ROWS, RANGE, 누적합, 물리적 행 단위','RANGE는 동일한 값을 하나의 범위로 묶어 동시에 연산하고, `ROWS`는 값이 같더라도 물리적인 각 행 단위로 순차 연산을 수행합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','물리 행 단위 = `ROWS` | 논리 값 범위 = `RANGE` (기본값).');
INSERT INTO "questions" VALUES(95,1,95,2,6,1,'Oracle ROWNUM 동작 원리와 잘못된 조건식 판별','Oracle에서 제공하는 의사 컬럼(Pseudo Column)인 ROWNUM의 동작 원리에 대한 설명으로 가장 부적절한 것은?','SQL1) SELECT * FROM EMP WHERE ROWNUM <= 5;
SQL2) SELECT * FROM EMP WHERE ROWNUM = 1;
SQL3) SELECT * FROM EMP WHERE ROWNUM = 2;
SQL4) SELECT * FROM EMP WHERE ROWNUM > 3;','["ROWNUM은 테이블에서 조건을 만족하며 출력되는 행에 대해 1부터 순차적으로 부여되는 가상의 번호이다.", "SQL1과 SQL2는 첫 번째 행부터 ROWNUM=1이 할당되므로 정상적으로 결과를 반환한다.", "SQL3(ROWNUM = 2)과 SQL4(ROWNUM > 3)는 1번 행이 WHERE 조건에서 탈락하여 번호가 2 이상으로 증가하지 못하므로 항상 0건을 반환한다.", "EMP 테이블에서 ROWNUM >= 10 과 같이 10 이상 조건을 주면 10번째 행부터 끝까지 정상 출력된다."]',3,'④ EMP 테이블에서 ROWNUM >= 10 과 같이 10 이상 조건을 주면 10번째 행부터 끝까지 정상 출력된다.','','ROWNUM, 의사 컬럼, 0건 반환, 인라인뷰 페이징','ROWNUM은 행이 WHERE 절을 통과해 결과 집합에 포함될 때 비로소 1, 2, 3... 순으로 카운트됩니다. 따라서 `ROWNUM >= 10`이나 `ROWNUM = 2`는 첫 번째 후보 행(ROWNUM=1)이 조건에 불합격해 버려지므로 계속 ROWNUM=1만 반복 검사하다 결국 0건이 반환됩니다. 10번째 이후를 얻으려면 인라인 뷰에서 ROWNUM에 별칭(RN)을 붙여 바깥 쿼리에서 `WHERE RN >= 10`으로 걸러야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','ROWNUM은 `<`, `<=`, `= 1`만 직접 사용 가능! `>`, `>= 2`, `= 2`는 반드시 인라인뷰 별칭으로 감싸야 합니다.');
INSERT INTO "questions" VALUES(96,1,96,2,6,1,'급여 상위 5명 추출 Top-N 쿼리 오류 판별 (ROWNUM vs FETCH)','EMP 테이블에서 급여(SAL)가 높은 순서대로 상위 5명을 추출하는 SQL 문장으로 가장 **적절하지 않은** 것은?','EMP(EMPNO, ENAME, DEPTNO, SAL)','["SELECT * FROM EMP ORDER BY SAL DESC FETCH FIRST 5 ROWS ONLY;", "SELECT * FROM EMP ORDER BY SAL DESC FETCH NEXT 5 ROW ONLY;", "SELECT * FROM (SELECT EMPNO, ENAME, DEPTNO, SAL, RANK() OVER(ORDER BY SAL DESC) AS SAL_RANK FROM EMP) WHERE SAL_RANK <= 5;", "SELECT * FROM (SELECT E.*, ROWNUM AS SAL_RANK FROM EMP E ORDER BY SAL DESC) WHERE SAL_RANK <= 5;"]',3,'④ SELECT * FROM (SELECT E.*, ROWNUM AS SAL_RANK FROM EMP E ORDER BY SAL DESC) WHERE SAL_RANK <= 5;','','Top-N 쿼리, ROWNUM 정렬 순서, FETCH FIRST, 인라인뷰','④의 인라인 뷰 내부를 보면 `SELECT E.*, ROWNUM ... ORDER BY SAL DESC`이므로, SQL 실행 순서상 ORDER BY보다 SELECT 절이 먼저 실행되면서 정렬되기 전 임의 순서대로 ROWNUM이 먼저 부여되고 그 뒤에 급여 순으로 정렬됩니다. 따라서 바깥에서 `SAL_RANK <= 5`를 걸면 급여 상위 5명이 아니라 테이블에서 무작위 5명이 추출됩니다. 올바른 ROWNUM 방식은 먼저 인라인 뷰에서 `ORDER BY SAL DESC`만 수행하고 바깥 쿼리에서 `WHERE ROWNUM <= 5`를 걸어야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','2024 신유형 단골! `FETCH FIRST`와 `FETCH NEXT`, `ROW`와 `ROWS`는 SQL에서 동일하게 동작합니다.');
INSERT INTO "questions" VALUES(97,1,97,2,6,1,'급여 낮은 순 6~8번째 행 추출 SQL 비교 (OFFSET · FETCH · 윈도우함수)','EMP 테이블에서 급여(SAL)가 낮은 순서대로 6~8번째에 해당하는 사원을 추출하는 SQL 문장으로 가장 **부적절한** 것은? (단, 급여에 중복 값이 있다고 가정할 때 1~5위에 5명이 배치된 상황)','EMP(EMPNO, ENAME, DEPTNO, SAL)','["SELECT EMPNO, ENAME, DEPTNO, SAL FROM (SELECT E.*, RANK() OVER(ORDER BY SAL) AS SAL_RANK FROM EMP E) WHERE SAL_RANK BETWEEN 6 AND 8;", "SELECT EMPNO, ENAME, DEPTNO, SAL FROM (SELECT E.*, DENSE_RANK() OVER(ORDER BY SAL) AS SAL_RANK FROM EMP E) WHERE SAL_RANK BETWEEN 5 AND 7;", "SELECT EMPNO, ENAME, DEPTNO, SAL FROM (SELECT E.*, ROWNUM AS SAL_RANK FROM EMP E ORDER BY SAL) WHERE SAL_RANK BETWEEN 6 AND 8;", "SELECT EMPNO, ENAME, DEPTNO, SAL FROM EMP ORDER BY SAL OFFSET 5 ROWS FETCH NEXT 3 ROWS ONLY;"]',2,'③ SELECT EMPNO, ENAME, DEPTNO, SAL FROM (SELECT E.*, ROWNUM AS SAL_RANK FROM EMP E ORDER BY SAL) WHERE SAL_RANK BETWEEN 6 AND 8;','','OFFSET, FETCH NEXT, ROWNUM 페이징 오류, RANK','③은 인라인 뷰에서 ORDER BY 정렬 전에 ROWNUM이 먼저 할당되므로 SAL 순서대로의 6~8번째 행을 추출할 수 없습니다. ④의 `OFFSET 5 ROWS FETCH NEXT 3 ROWS ONLY`는 앞 5개 행(1~5번째)을 건너뛰고 그 다음 3개 행(6, 7, 8번째)을 정확히 추출합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','OFFSET M ROWS FETCH NEXT N ROWS ONLY = M개 건너뛰고 N개 추출!');
INSERT INTO "questions" VALUES(98,1,98,2,6,1,'Top-N 쿼리 (ROWNUM · FETCH · OFFSET) 문법 진위 판별','2024 개정 출제기준에 추가된 Top-N Query에 대한 설명으로 가장 **틀린** 것은?','SELECT * FROM EMP ORDER BY SAL DESC OFFSET 3 ROWS FETCH NEXT 5 ROWS ONLY;','["ROW_NUMBER(), RANK() 등 윈도우 함수를 사용하여 상위 N개 값을 추출할 때는 인라인 뷰로 감싸야 한다.", "ROWNUM을 사용할 때는 먼저 인라인 뷰에서 ORDER BY로 데이터를 정렬한 뒤 바깥 쿼리에서 ROWNUM을 부여해 추출해야 한다.", "FETCH 절을 사용하면 인라인 뷰 없이 단일 SELECT 문장만으로도 정렬 순서대로의 상위 N개 행을 추출할 수 있다.", "OFFSET 절을 사용한 경우에는 FETCH 절에서 반드시 NEXT 키워드만 사용해야 하며 FIRST 키워드를 쓰면 구문 오류가 발생한다."]',3,'④ OFFSET 절을 사용한 경우에는 FETCH 절에서 반드시 NEXT 키워드만 사용해야 하며 FIRST 키워드를 쓰면 구문 오류가 발생한다.','','FETCH FIRST, FETCH NEXT, OFFSET, Top-N','ANSI SQL 및 Oracle 12c+ / SQL Server의 FETCH 절에서는 `FIRST`와 `NEXT` (그리고 `ROW`와 `ROWS`)가 의미적·문법적으로 완전히 호환되므로 OFFSET 유무와 관계없이 어느 쪽을 써도 오류가 발생하지 않습니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','FETCH FIRST/NEXT 및 ROW/ROWS는 서로 호환 가능하며, 동점자 포함 옵션은 `WITH TIES`입니다(ONLY 대신 WITH TIES 사용).');
INSERT INTO "questions" VALUES(99,1,99,2,6,1,'TOP (N) WITH TIES 및 FETCH ... WITH TIES 동점자 처리','아래 SCORE 테이블(총 5행)에 대해 Oracle의 `FETCH FIRST 2 ROWS WITH TIES` 또는 SQL Server의 `SELECT TOP (2) WITH TIES` 쿼리를 실행했을 때 출력되는 총 행의 수는?','SCORE_TBL (NAME, SCORE)
A | 95
B | 90
C | 90
D | 90
E | 80

[SQL]
SELECT NAME, SCORE FROM SCORE_TBL
ORDER BY SCORE DESC
FETCH FIRST 2 ROWS WITH TIES;','["2행", "3행", "4행", "5행"]',2,'③ 4행','','WITH TIES, 동점자 포함, Top-N, FETCH','ORDER BY SCORE DESC 기준 1번째는 A(95), 2번째는 B(90)입니다. `WITH TIES` 옵션을 지정하면 마지막 N번째(2번째) 행과 ORDER BY 기준 값이 동일한 동점자 행들(C 90, D 90)을 모두 추가로 포함하므로 A, B, C, D 총 4행이 출력됩니다.','SQLD 2024 개정 출제기준 핵심문제','WITH TIES는 반드시 ORDER BY 절과 함께 사용해야 하며, 마지막 행과 같은 값의 동점자를 모두 출력합니다.');
INSERT INTO "questions" VALUES(100,1,100,2,6,1,'LONG DATA(Tidy) vs WIDE DATA(Cross Table) 구조 비교','PIVOT과 UNPIVOT의 배경이 되는 LONG DATA 구조와 WIDE DATA 구조에 대한 설명으로 가장 부적절한 것은?','-- LONG DATA: (JOB, DEPTNO, CNT)  → 3개 컬럼이 행으로 누적
-- WIDE DATA: (JOB, "10", "20", "30") → DEPTNO 값이 컬럼 헤더로 전개','["LONG DATA는 하나의 속성이 하나의 컬럼으로 정의되어 값들이 여러 행으로 쌓이는 RDBMS의 기본 설계 방식이다.", "WIDE DATA는 행과 열의 교차표(Cross Table) 형태로 주로 데이터를 요약 보고할 목적으로 사용된다.", "WIDE DATA 구조에서는 새로운 분류 값(예: 부서 40)이 생길 때마다 테이블의 컬럼을 추가해야 하므로 RDBMS 설계에 비효율적이다.", "WIDE DATA는 LONG DATA에 비해 다른 정규화 테이블과의 조인(JOIN) 연산이 훨씬 자유롭고 유연하다."]',3,'④ WIDE DATA는 LONG DATA에 비해 다른 정규화 테이블과의 조인(JOIN) 연산이 훨씬 자유롭고 유연하다.','','LONG DATA, WIDE DATA, 교차표, PIVOT, UNPIVOT','WIDE DATA는 하나의 속성값이 여러 컬럼으로 흩어져 있어 다른 테이블과 조인 키로 연결하기 어렵고(조인 불가), 신규 값 추가 시 스키마 변경이 필요합니다. 반면 LONG DATA(Tidy Data)는 다른 테이블과의 조인 연산이 자연스럽게 가능합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','PIVOT = LONG → WIDE (UNSTACK) | UNPIVOT = WIDE → LONG (STACK).');
INSERT INTO "questions" VALUES(101,1,101,2,6,1,'PIVOT 구문에서 FROM 절 인라인 뷰 컬럼 제한의 중요성','EMP(EMPNO, ENAME, JOB, MGR, SAL, DEPTNO) 테이블에서 아래와 같은 교차표(행: JOB, 열: 부서번호 10/20/30, 값: 사원 수)를 만들기 위한 PIVOT 구문 중 결과 구조가 **적절하지 않은** 것은?','[원하는 결과 교차표]
JOB       | 10 | 20 | 30
CLERK     |  1 |  2 |  1
MANAGER   |  1 |  1 |  1
SALESMAN  |  0 |  0 |  4','["SELECT * FROM (SELECT EMPNO, JOB, DEPTNO FROM EMP) PIVOT (COUNT(EMPNO) FOR DEPTNO IN (10, 20, 30));", "SELECT * FROM (SELECT EMPNO, JOB, DEPTNO FROM EMP) PIVOT (COUNT(JOB) FOR DEPTNO IN (10, 20, 30));", "SELECT * FROM (SELECT JOB, DEPTNO FROM EMP) PIVOT (COUNT(DEPTNO) FOR DEPTNO IN (10, 20, 30));", "SELECT * FROM (SELECT ENAME, JOB, DEPTNO FROM EMP) PIVOT (COUNT(ENAME) FOR DEPTNO IN (10, 20, 30));"]',1,'② SELECT * FROM (SELECT EMPNO, JOB, DEPTNO FROM EMP) PIVOT (COUNT(JOB) FOR DEPTNO IN (10, 20, 30));','','PIVOT, STACK 컬럼, UNSTACK 컬럼, 인라인 뷰 제한','PIVOT은 FROM 절에 정의된 컬럼들 중 `PIVOT(...)` 내부의 집계 함수(VALUE)와 `FOR` 뒤의 컬럼(UNSTACK)을 **제외한 나머지 모든 컬럼**을 자동으로 그룹핑 기준(STACK 컬럼)으로 삼습니다. ②에서는 `COUNT(JOB)`과 `FOR DEPTNO`를 썼으므로 남아있는 `EMPNO`가 행 기준(STACK)이 되어 JOB별 집계가 아니라 EMPNO별 행으로 출력되어 버립니다!','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','PIVOT 핵심 암기: FROM 절 인라인뷰에는 반드시 [행기준(STACK) + 열기준(UNSTACK) + 집계값(VALUE)] 3종만 남기세요!');
INSERT INTO "questions" VALUES(102,1,102,2,6,1,'PIVOT 실행 결과 및 매칭 데이터 없음(NULL) 처리','아래 EMP_MINI 테이블을 대상으로 PIVOT 쿼리를 실행했을 때 출력되는 결과 값으로 올바른 것은?','EMP_MINI (JOB, DEPTNO, SAL)
CLERK   | 10 | 1300
CLERK   | 20 | 800
MANAGER | 10 | 2450
MANAGER | 30 | 2850

[SQL]
SELECT *
FROM EMP_MINI
PIVOT (SUM(SAL) FOR DEPTNO IN (10, 20, 30))
ORDER BY JOB;','["CLERK: (10=1300, 20=800, 30=NULL) / MANAGER: (10=2450, 20=NULL, 30=2850)", "CLERK: (10=1300, 20=800, 30=0) / MANAGER: (10=2450, 20=0, 30=2850)", "CLERK: (10=1300, 20=800, 30=NULL) / MANAGER 행은 20번이 없으므로 제외됨", "SUM 집계 함수 사용 시 FOR 뒤에 숫자 10, 20, 30을 쓰면 문법 오류가 발생한다."]',0,'① CLERK: (10=1300, 20=800, 30=NULL) / MANAGER: (10=2450, 20=NULL, 30=2850)','','PIVOT SUM, NULL 출력, IN 절 컬럼 생성','PIVOT 절의 `FOR DEPTNO IN (10, 20, 30)`은 IN에 나열된 순서대로 컬럼을 생성합니다. `SUM(SAL)`처럼 일반적으로 집계할 대상 행이 없는 교차 셀은 0이 아니라 `NULL`로 반환됩니다(COUNT의 경우 0 반환).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','PIVOT 집계 시 데이터 없는 셀: SUM/MAX/AVG → NULL | COUNT → 0.');
INSERT INTO "questions" VALUES(103,1,103,2,6,1,'UNPIVOT 숫자형 컬럼명 쌍따옴표(" ") 및 컬럼 순서 규칙','아래 WIDE 구조의 TEST1 테이블을 LONG 구조(JOB, DEPTNO, CNT)로 변환하고자 할 때 올바른 UNPIVOT SQL 구문은?','TEST1 (JOB, "10", "20", "30")
CLERK   | 1 | 2 | 1
MANAGER | 1 | 1 | 1

[원하는 출력]
JOB | DEPTNO | CNT','["SELECT * FROM TEST1 UNPIVOT (CNT FOR DEPTNO IN (\"10\", \"20\", \"30\"));", "SELECT * FROM TEST1 UNPIVOT (DEPTNO FOR CNT IN (\"10\", \"20\", \"30\"));", "SELECT * FROM TEST1 UNPIVOT (CNT FOR DEPTNO IN (10, 20, 30));", "SELECT * FROM TEST1 UNPIVOT (DEPTNO FOR CNT IN (10, 20, 30));"]',0,'① SELECT * FROM TEST1 UNPIVOT (CNT FOR DEPTNO IN ("10", "20", "30"));','','UNPIVOT, 숫자 컬럼명 쌍따옴표, VALUE FOR STACK','UNPIVOT 문법은 `UNPIVOT (VALUE컬럼명 FOR STACK컬럼명 IN (기존컬럼1, 기존컬럼2, ...))` 순서입니다. 따라서 값(CNT)이 FOR 앞에, 기존 컬럼 헤더들이 쌓일 새 컬럼(DEPTNO)이 FOR 뒤에 옵니다. 또한 `10`, `20`, `30`은 숫자가 아니라 테이블의 **컬럼 이름(식별자)**이므로 반드시 큰따옴표(`"10", "20", "30"`)로 감싸야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','UNPIVOT(새값컬럼 FOR 새구분컬럼 IN (원본컬럼명들)) — 숫자 이름 컬럼은 `"10"` 큰따옴표 필수!');
INSERT INTO "questions" VALUES(104,1,104,2,6,1,'UNPIVOT 문자형 컬럼명(따옴표 생략) 및 집계함수 금지 규칙','아래 TEST2 테이블을 대상으로 JOB별 급여 합계(SUM_SAL) 컬럼을 세로(LONG) 형태로 변환하는 올바른 UNPIVOT SQL 문장은?','TEST2 (DEPTNO, CLERK, SALESMAN, ANALYST, MANAGER, PRESIDENT)
10 | 1300 | NULL | NULL | 2450 | 5000
20 | 1900 | NULL | 6000 | 2975 | NULL','["SELECT * FROM TEST2 UNPIVOT (SUM(SAL) FOR JOB IN (''CLERK'',''SALESMAN'',''ANALYST'',''MANAGER'',''PRESIDENT''));", "SELECT * FROM TEST2 UNPIVOT (SUM_SAL FOR JOB IN (''CLERK'',''SALESMAN'',''ANALYST'',''MANAGER'',''PRESIDENT''));", "SELECT * FROM TEST2 UNPIVOT (SUM(SAL) FOR JOB IN (CLERK, SALESMAN, ANALYST, MANAGER, PRESIDENT));", "SELECT * FROM TEST2 UNPIVOT (SUM_SAL FOR JOB IN (CLERK, SALESMAN, ANALYST, MANAGER, PRESIDENT));"]',3,'④ SELECT * FROM TEST2 UNPIVOT (SUM_SAL FOR JOB IN (CLERK, SALESMAN, ANALYST, MANAGER, PRESIDENT));','','UNPIVOT, 홑따옴표 금지, SUM_SAL, INCLUDE NULLS','①, ②처럼 IN 절 안에 홑따옴표(''CLERK'')를 쓰면 문자열 상수로 인식되어 오류가 발생합니다(컬럼 식별자이므로 따옴표 없이 `CLERK` 또는 큰따옴표 `"CLERK"`). 또한 UNPIVOT은 이미 존재하는 셀 값을 세로로 내리는 기능이지 집계하는 기능이 아니므로 FOR 앞에 `SUM(SAL)` 같은 집계 함수를 쓸 수 없고 새 컬럼명(`SUM_SAL`)을 지정해야 합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','참고: UNPIVOT은 기본적으로 NULL 셀을 결과에서 제외하며, NULL 행도 포함하려면 `UNPIVOT INCLUDE NULLS (...)` 옵션을 사용합니다.');
INSERT INTO "questions" VALUES(105,1,105,2,6,1,'REGEXP_SUBSTR 인수 6개 및 REGEXP_REPLACE 활용 비교','EMPLOYEES 테이블의 JOB_ID 컬럼 값이 `''IT_PROG''`, `''AD_PRES''`, `''SA_MAN''` 형태일 때, 언더바(`_`) 앞부분(`''IT''`, `''AD''`, `''SA''`)만 추출하기 위한 함수식으로 **적절하지 않은** 것은?','-- JOB_ID 예시: ''IT_PROG'', ''AD_VP'', ''SA_REP''
-- 목표 출력: ''IT'', ''AD'', ''SA''
-- 참고: REGEXP_SUBSTR(대상, 패턴, [검색위치], [발견횟수], [옵션], [추출그룹])','["REGEXP_SUBSTR(JOB_ID, ''[^_]+'', 1, 1)", "REGEXP_SUBSTR(JOB_ID, ''(\\D+)_(\\D+)'', 1, 1, NULL, 1)", "REGEXP_REPLACE(JOB_ID, ''_.+$'', '''')", "REGEXP_SUBSTR(JOB_ID, ''\\D+'', 4)"]',3,'④ REGEXP_SUBSTR(JOB_ID, ''\D+'', 4)','','REGEXP_SUBSTR, 추출그룹, 정규표현식, \D+','④의 `REGEXP_SUBSTR(JOB_ID, ''\D+'', 4)`는 4번째 글자부터 시작해 숫자가 아닌 연속 문자를 추출하므로 `''IT_PROG''`에서 `''PROG''`를 추출하게 되어 앞부분(`''IT''`)을 얻을 수 없습니다. ②는 `(\D+)_(\D+)` 패턴에서 6번째 인수 추출그룹 `1`을 지정해 첫 번째 괄호 그룹(`''IT''`)을 정확히 추출합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','REGEXP_SUBSTR 6번째 인수(subexpr) = 괄호`(...)`로 묶은 서브패턴 중 추출할 그룹 번호!');
INSERT INTO "questions" VALUES(106,1,106,2,6,1,'REGEXP_REPLACE(대상, 패턴, 치환값, 시작위치, 발견횟수) 결과 추론','아래 PHONE_NUMBER 문자열에 대하여 `REGEXP_REPLACE` 함수를 실행했을 때 출력되는 결과로 올바른 것은?','SELECT REGEXP_REPLACE(''515.123.4567'', ''\d+'', ''XXX'', 1, 2) AS MASKED
FROM DUAL;','["XXX.123.4567", "515.XXX.4567", "XXX.XXX.XXX", "515.123.XXX"]',1,'② 515.XXX.4567','','REGEXP_REPLACE, 발견횟수, \d+, 마스킹','`REGEXP_REPLACE(원본, ''\d+'', ''XXX'', 1, 2)`는 원본 문자열의 1번째 위치부터 연속된 숫자(`\d+`) 패턴을 찾아 **2번째로 발견되는 부분만** ''XXX''로 치환하라는 의미입니다. 1번째 숫자 그룹은 `515`, 2번째 숫자 그룹은 `123`이므로 결과는 `515.XXX.4567`이 됩니다(발견횟수를 0 또는 생략하면 모두 치환).','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','발견횟수 N: 0이면 전체 치환, 2면 2번째 일치 항목만 치환!');
INSERT INTO "questions" VALUES(107,1,107,2,6,1,'REGEXP_COUNT 대소문자 무시 옵션(''i'') 및 문자 클래스([ko])','아래 4개의 문자열에 대하여 `REGEXP_COUNT(TEXT, ''[ko]'', 1, ''i'')`를 각각 실행했을 때 출력되는 결과 값을 순서대로 바르게 나열한 것은?','1) ''Korea''   2) ''Oracle''   3) ''SQL''   4) ''Book''

SELECT REGEXP_COUNT(TEXT, ''[ko]'', 1, ''i'') FROM T_TEXT;','["2, 1, 0, 3", "1, 1, 0, 2", "2, 1, 1, 3", "0, 1, 0, 3"]',0,'① 2, 1, 0, 3','','REGEXP_COUNT, 대소문자 무시, i 옵션, 문자 클래스','`[ko]`는 문자 `''k''` 또는 `''o''` 중 한 글자를 의미하며, 4번째 인수 `''i''` 옵션은 대소문자를 구분하지 않습니다.
1) `''Korea''`: K, o → 2개
2) `''Oracle''`: O → 1개
3) `''SQL''`: 없음 → 0개
4) `''Book''`: o, o, k → 3개.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','정규표현식 옵션: `i` (대소문자 무시), `c` (대소문자 구분, 기본값), `m` (멀티라인 ^/$).');
INSERT INTO "questions" VALUES(108,1,108,2,6,1,'REGEXP_INSTR 시작 위치 및 부정 문자 클래스([^ ]+) 위치 계산','아래 SQL 문장을 실행했을 때 반환되는 위치 값으로 올바른 것은?','-- 위치: 123456789012345678
-- 문자: ''HELLO SQL EMP DEPT''
SELECT REGEXP_INSTR(''HELLO SQL EMP DEPT'', ''[^ ]+'', 7, 3) AS POS
FROM DUAL;','["0", "10", "15", "11"]',2,'③ 15','','REGEXP_INSTR, 부정 문자 클래스, [^ ], 시작 위치','`[^ ]+`는 공백이 아닌 문자가 1개 이상 연속되는 패턴(즉, 공백으로 구분된 한 단어)을 의미합니다. 시작 위치가 `7`이므로 7번째 글자(`S` in `SQL`)부터 스캔을 시작하여 1번째 단어 `SQL`(7), 2번째 단어 `EMP`(11), **3번째 단어 `DEPT`의 시작 위치인 `15`**를 반환합니다.','tpdlshdmlrkfmcla/SQLD_SQLP 공개 자료 기반','문자열 인덱스는 1부터 시작! `[^ ]+` = 공백 제외 연속 문자열(단어).');
INSERT INTO "questions" VALUES(109,5,109,2,6,2,'WHERE 절 전용 정규표현식 필터 함수명 작성 (단답)','주어진 문자열이 정규표현식 패턴과 일치하는지 여부를 판단하여 참인 행만 필터링할 목적으로 주로 `WHERE` 절에서 사용하는 Oracle 정규표현식 함수명을 대문자로 쓰시오.','-- ID가 영문자로 시작하고 숫자로 끝나는 사원만 조회
SELECT * FROM PROFESSOR
WHERE (             )(ID, ''^[A-Za-z].*[0-9]$'');','[]',-1,'REGEXP_LIKE','REGEXP_LIKE|regexp_like','REGEXP_LIKE, 정규표현식, WHERE 절, ^, $','Oracle의 `REGEXP_LIKE(원본, 패턴, [옵션])`은 LIKE 연산자처럼 조건식(주로 WHERE 절)에서 사용되며 시작 위치나 발견 횟수 인수를 받지 않습니다. `^`는 문자열 시작, `$`는 문자열 끝을 의미합니다.','SQLD 2024 개정 출제기준 핵심문제','정규식 5대 함수: REGEXP_LIKE(조건판별), REGEXP_REPLACE(치환), REGEXP_SUBSTR(추출), REGEXP_INSTR(위치), REGEXP_COUNT(횟수).');
INSERT INTO "questions" VALUES(110,5,110,2,6,2,'교차표(WIDE)를 세로(LONG) 데이터로 변환하는 연산 키워드 (단답)','열 방향으로 펼쳐져 있는 교차표(Wide Data) 형태의 여러 컬럼들을 세로 방향의 행(Long/Tidy Data)으로 스택(Stack) 처리하여 변환할 때 사용하는 SQL 연산 키워드를 대문자로 쓰시오.','SELECT *
FROM SALES_WIDE
(        ) (AMT FOR MONTH IN ("01", "02", "03"));','[]',-1,'UNPIVOT','UNPIVOT|unpivot','UNPIVOT, WIDE to LONG, STACK','LONG → WIDE(행 데이터를 열 헤더로 펼침)는 `PIVOT`, WIDE → LONG(열 헤더를 행 데이터로 쌓음)은 `UNPIVOT`을 사용합니다.','SQLD 2024 개정 출제기준 핵심문제','2024 신유형 3대장: Top-N(FETCH/OFFSET), PIVOT/UNPIVOT, REGEXP_* 함수!');
CREATE VIEW v_mode_exam AS
    SELECT q.question_id, q.round_id, r.round_title, r.exam_year, r.agency,
           q.question_no, q.subject_id, s.subject_name, q.domain_id, d.domain_name,
           q.qtype_id, t.qtype_name, q.title, q.question_text, q.code_or_log,
           q.choices_json, q.source
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_subject s ON q.subject_id = s.subject_id
    JOIN categories_domain d ON q.domain_id = d.domain_id
    JOIN categories_qtype t ON q.qtype_id = t.qtype_id;
CREATE VIEW v_mode_compare AS
    SELECT q.question_id, q.round_id, r.round_title, r.exam_year, r.agency,
           q.question_no, q.subject_id, s.subject_name, q.domain_id, d.domain_name,
           q.qtype_id, t.qtype_name, q.title, q.question_text, q.code_or_log,
           q.choices_json, q.answer_index, q.answer_text, q.acceptable_answers,
           q.core_keywords, q.source
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_subject s ON q.subject_id = s.subject_id
    JOIN categories_domain d ON q.domain_id = d.domain_id
    JOIN categories_qtype t ON q.qtype_id = t.qtype_id;
CREATE VIEW v_mode_explanation AS
    SELECT q.question_id, q.round_id, r.round_title, r.exam_year, r.agency,
           q.question_no, q.subject_id, s.subject_name, q.domain_id, d.domain_name,
           q.qtype_id, t.qtype_name, q.title, q.question_text, q.code_or_log,
           q.choices_json, q.answer_index, q.answer_text, q.acceptable_answers,
           q.core_keywords, q.explanation, q.source, q.study_tip
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_subject s ON q.subject_id = s.subject_id
    JOIN categories_domain d ON q.domain_id = d.domain_id
    JOIN categories_qtype t ON q.qtype_id = t.qtype_id;
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('questions',110);
COMMIT;
