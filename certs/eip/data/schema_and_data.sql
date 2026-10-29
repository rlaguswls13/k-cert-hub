BEGIN TRANSACTION;
CREATE TABLE categories_major (
        major_id INTEGER PRIMARY KEY,
        major_code TEXT NOT NULL UNIQUE,
        major_name TEXT NOT NULL,
        description TEXT
    );
INSERT INTO "categories_major" VALUES(1,'THEORY','이론 문항','소프트웨어 공학, 데이터베이스, 네트워크, 정보보안, 운영체제 등 개념·설계·계산 문항');
INSERT INTO "categories_major" VALUES(2,'CODE','코드 문항','C언어, Java, Python 코드 실행 결과 도출 및 SQL 쿼리 작성·결과 도출 문항');
CREATE TABLE categories_minor (
        minor_id INTEGER PRIMARY KEY,
        major_id INTEGER NOT NULL,
        minor_code TEXT NOT NULL UNIQUE,
        minor_name TEXT NOT NULL,
        description TEXT,
        FOREIGN KEY (major_id) REFERENCES categories_major(major_id)
    );
INSERT INTO "categories_minor" VALUES(1,2,'CODE_C','C언어','포인터, 배열, 구조체, 문자열 처리, 재귀함수, 비트연산 등 C언어 코드 실행 결과');
INSERT INTO "categories_minor" VALUES(2,2,'CODE_JAVA','Java','클래스 상속, 오버라이딩(동적 바인딩), 생성자, static, 추상클래스/인터페이스 다형성');
INSERT INTO "categories_minor" VALUES(3,2,'CODE_SQL','SQL','SELECT(GROUP BY, HAVING, JOIN, 서브쿼리), DDL/DML/DCL 쿼리 작성 및 결과 도출');
INSERT INTO "categories_minor" VALUES(4,2,'CODE_PY','Python','리스트 슬라이싱, 딕셔너리, 집합(Set), 문자열 메서드, 람다/조건문 실행 결과');
INSERT INTO "categories_minor" VALUES(5,1,'TH_NET','네트워크/프로토콜','OSI 7계층, IPv4/IPv6, 서브넷팅/CIDR 계산, 라우팅(OSPF/RIP/BGP), ARP/RARP/ICMP/TCP');
INSERT INTO "categories_minor" VALUES(6,1,'TH_SW_GEN','소프트웨어 일반/신기술','신기술 용어, 클라우드, 빅데이터/마이닝, 회복탄력성(RTO/RPO), 아키텍처 및 일반 전산학');
INSERT INTO "categories_minor" VALUES(7,1,'TH_DB_REL','데이터베이스(관계대수/구조)','릴레이션 구성(차수/카디널리티/튜플/도메인), 키(Key)와 무결성 제약조건, 관계대수/관계해석');
INSERT INTO "categories_minor" VALUES(8,1,'TH_SEC','보안/암호학','대칭키/비대칭키 암호화 알고리즘, 해시, 네트워크/웹 공격기법(DoS, XSS, SQLi, 세션하이재킹), 접근통제/AAA');
INSERT INTO "categories_minor" VALUES(9,1,'TH_PATTERN','디자인 패턴','GoF 디자인 패턴(생성/구조/행위)의 목적 및 패턴별 특징/구현 매칭');
INSERT INTO "categories_minor" VALUES(10,1,'TH_TEST','소프트웨어 테스트/품질','화이트박스(구문/분기/조건 커버리지), 블랙박스(동치분할/경계값 등), 테스트 원리(살충제 패러독스), 정적/동적 테스트');
INSERT INTO "categories_minor" VALUES(11,1,'TH_UML','요구사항/UML/설계','UML 다이어그램(클래스/유스케이스/패키지/시퀀스/상태), 관계 표기, 럼바우 분석 기법, 요구사항 분류');
INSERT INTO "categories_minor" VALUES(12,1,'TH_OS_MEM','운영체제(스케줄링/메모리)','CPU 스케줄링(HRN, SJF, RR, SRT), 페이지 교체(LRU, FIFO, LFU), 교착상태(Deadlock)');
INSERT INTO "categories_minor" VALUES(13,1,'TH_DB_NORM','데이터베이스(설계/정규화)','DB 설계 단계(개념/논리/물리), 정규화(1NF~5NF, BCNF), 이상현상(삽입/삭제/갱신), 반정규화/인덱스');
INSERT INTO "categories_minor" VALUES(14,1,'TH_COUP','결합도/응집도','모듈 결합도(자-스-외-제-공-내) 및 응집도(우-논-시-절-통-순-기) 유형 판별 및 강도 순서');
INSERT INTO "categories_minor" VALUES(15,1,'TH_DB_TX','데이터베이스(트랜잭션/회복)','트랜잭션 4대 특성(ACID), 회복 기법(Redo/Undo, 즉시/지연 갱신), 병행제어/로킹');
INSERT INTO "categories_minor" VALUES(16,1,'TH_SW_ENG','소프트웨어 공학/방법론','애자일/XP/스크럼, 형상관리(식별/통제/감사/기록), 리팩토링, 비용산정(LoC/COCOMO), Fan-in/Fan-out');
INSERT INTO "categories_minor" VALUES(17,1,'TH_INTF','인터페이스/연계/웹기술','EAI/ESB 구축 유형, 웹서비스(SOAP/REST/WSDL/UDDI), 데이터 포맷(JSON/XML/AJAX)');
INSERT INTO "categories_minor" VALUES(18,1,'TH_OS_CLI','운영체제(명령어/기초)','유닉스/리눅스 기본 명령어(chmod, ls, pwd, cd, cp, ps, fork 등) 및 권한 설정');
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
INSERT INTO "category_analytics" VALUES(1,2,'C언어','코드',45,11.84,18,2.37,1.06,1,2,19,'2026년 3회',0,0.0,'코드 출력 결과형','코드 출력 결과형(44), 코드 빈칸 완성형(1)');
INSERT INTO "category_analytics" VALUES(2,2,'Java','코드',50,13.16,19,2.63,1.0,1,1,19,'2026년 3회',0,0.0,'코드 출력 결과형','코드 출력 결과형(46), 코드 빈칸 완성형(4)');
INSERT INTO "category_analytics" VALUES(3,2,'SQL','코드',31,8.16,17,1.63,1.12,1,2,19,'2026년 3회',0,0.0,'SQL 작성·빈칸형','SQL 작성·빈칸형(23), SQL 결과 도출형(8)');
INSERT INTO "category_analytics" VALUES(4,2,'Python','코드',23,6.05,17,1.21,1.06,1,2,19,'2026년 3회',0,0.0,'코드 출력 결과형','코드 출력 결과형(23)');
INSERT INTO "category_analytics" VALUES(5,1,'네트워크/프로토콜','이론',42,11.05,18,2.21,1.06,1,2,19,'2026년 3회',0,0.0,'핵심 용어 단답형','핵심 용어 단답형(26), 괄호 빈칸 채우기형(12), 수식·계산 도출형(3), 보기·기호 선택형(1)');
INSERT INTO "category_analytics" VALUES(6,1,'소프트웨어 일반/신기술','이론',42,11.05,15,2.21,1.29,1,2,19,'2026년 3회',0,0.0,'핵심 용어 단답형','핵심 용어 단답형(25), 괄호 빈칸 채우기형(6), 보기·기호 선택형(6), 서술·약술형(3), 수식·계산 도출형(2)');
INSERT INTO "category_analytics" VALUES(7,1,'데이터베이스(관계대수/구조)','이론',22,5.79,12,1.16,1.36,1,3,16,'2025년 3회',3,2.21,'핵심 용어 단답형','핵심 용어 단답형(13), 보기·기호 선택형(6), 괄호 빈칸 채우기형(3)');
INSERT INTO "category_analytics" VALUES(8,1,'보안/암호학','이론',22,5.79,14,1.16,1.31,1,2,19,'2026년 3회',0,0.0,'보기·기호 선택형','보기·기호 선택형(9), 핵심 용어 단답형(6), 서술·약술형(4), 괄호 빈칸 채우기형(3)');
INSERT INTO "category_analytics" VALUES(9,1,'디자인 패턴','이론',12,3.16,12,0.63,1.36,1,3,19,'2026년 3회',0,0.0,'괄호 빈칸 채우기형','괄호 빈칸 채우기형(6), 보기·기호 선택형(4), 핵심 용어 단답형(2)');
INSERT INTO "category_analytics" VALUES(10,1,'소프트웨어 테스트/품질','이론',28,7.37,17,1.47,1.12,1,2,19,'2026년 3회',0,0.0,'핵심 용어 단답형','핵심 용어 단답형(11), 보기·기호 선택형(9), 괄호 빈칸 채우기형(6), 서술·약술형(1), 수식·계산 도출형(1)');
INSERT INTO "category_analytics" VALUES(11,1,'요구사항/UML/설계','이론',12,3.16,11,0.63,1.8,1,3,19,'2026년 3회',0,0.0,'괄호 빈칸 채우기형','괄호 빈칸 채우기형(7), 핵심 용어 단답형(4), 보기·기호 선택형(1)');
INSERT INTO "category_analytics" VALUES(12,1,'운영체제(스케줄링/메모리)','이론',8,2.11,8,0.42,2.43,1,6,18,'2026년 2회',1,0.41,'수식·계산 도출형','수식·계산 도출형(5), 핵심 용어 단답형(2), 괄호 빈칸 채우기형(1)');
INSERT INTO "category_analytics" VALUES(13,1,'데이터베이스(설계/정규화)','이론',11,2.89,10,0.58,2.0,1,4,19,'2026년 3회',0,0.0,'핵심 용어 단답형','핵심 용어 단답형(4), 괄호 빈칸 채우기형(4), 서술·약술형(2), 보기·기호 선택형(1)');
INSERT INTO "category_analytics" VALUES(14,1,'결합도/응집도','이론',8,2.11,8,0.42,1.86,1,4,18,'2026년 2회',1,0.54,'보기·기호 선택형','보기·기호 선택형(3), 핵심 용어 단답형(3), 괄호 빈칸 채우기형(2)');
INSERT INTO "category_analytics" VALUES(15,1,'데이터베이스(트랜잭션/회복)','이론',6,1.58,5,0.32,1.75,1,2,8,'2022년 1회',11,6.29,'핵심 용어 단답형','핵심 용어 단답형(3), 서술·약술형(2), 보기·기호 선택형(1)');
INSERT INTO "category_analytics" VALUES(16,1,'소프트웨어 공학/방법론','이론',8,2.11,5,0.42,2.25,1,6,10,'2022년 3회',9,4.0,'괄호 빈칸 채우기형','괄호 빈칸 채우기형(2), 핵심 용어 단답형(2), 서술·약술형(2), 수식·계산 도출형(1), 보기·기호 선택형(1)');
INSERT INTO "category_analytics" VALUES(17,1,'인터페이스/연계/웹기술','이론',5,1.32,4,0.26,2.33,1,3,9,'2022년 2회',10,4.29,'핵심 용어 단답형','핵심 용어 단답형(3), 보기·기호 선택형(2)');
INSERT INTO "category_analytics" VALUES(18,1,'운영체제(명령어/기초)','이론',5,1.32,4,0.26,4.67,2,6,16,'2025년 3회',3,0.64,'핵심 용어 단답형','핵심 용어 단답형(4), 보기·기호 선택형(1)');
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
INSERT INTO "exam_rounds" VALUES(1,2020,1,'2020년 1회','https://chobopark.tistory.com/196',20,16,4);
INSERT INTO "exam_rounds" VALUES(2,2020,2,'2020년 2회','https://chobopark.tistory.com/195',20,15,5);
INSERT INTO "exam_rounds" VALUES(3,2020,3,'2020년 3회','https://chobopark.tistory.com/194',20,13,7);
INSERT INTO "exam_rounds" VALUES(4,2020,4,'2020년 4회','https://chobopark.tistory.com/192',20,14,6);
INSERT INTO "exam_rounds" VALUES(5,2021,1,'2021년 1회','https://chobopark.tistory.com/191',20,15,5);
INSERT INTO "exam_rounds" VALUES(6,2021,2,'2021년 2회','https://chobopark.tistory.com/210',20,12,8);
INSERT INTO "exam_rounds" VALUES(7,2021,3,'2021년 3회','https://chobopark.tistory.com/217',20,15,5);
INSERT INTO "exam_rounds" VALUES(8,2022,1,'2022년 1회','https://chobopark.tistory.com/271',20,13,7);
INSERT INTO "exam_rounds" VALUES(9,2022,2,'2022년 2회','https://chobopark.tistory.com/423',20,13,7);
INSERT INTO "exam_rounds" VALUES(10,2022,3,'2022년 3회','https://chobopark.tistory.com/424',20,15,5);
INSERT INTO "exam_rounds" VALUES(11,2024,1,'2024년 1회','https://chobopark.tistory.com/476',20,10,10);
INSERT INTO "exam_rounds" VALUES(12,2024,2,'2024년 2회','https://chobopark.tistory.com/483',20,10,10);
INSERT INTO "exam_rounds" VALUES(13,2024,3,'2024년 3회','https://chobopark.tistory.com/495',20,10,10);
INSERT INTO "exam_rounds" VALUES(14,2025,1,'2025년 1회','https://chobopark.tistory.com/540',20,10,10);
INSERT INTO "exam_rounds" VALUES(15,2025,2,'2025년 2회','https://chobopark.tistory.com/554',20,11,9);
INSERT INTO "exam_rounds" VALUES(16,2025,3,'2025년 3회','https://chobopark.tistory.com/558',20,11,9);
INSERT INTO "exam_rounds" VALUES(17,2026,1,'2026년 1회','https://chobopark.tistory.com/561',20,10,10);
INSERT INTO "exam_rounds" VALUES(18,2026,2,'2026년 2회','https://chobopark.tistory.com/562',20,9,11);
INSERT INTO "exam_rounds" VALUES(19,2026,3,'2026년 3회','https://ys-note.com/information-processing-engineer-practical-2026-3-answers/',20,9,11);
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
INSERT INTO "predicted_questions" VALUES(1,'이론','데이터베이스(트랜잭션/회복)','빈칸채우기(괄호형)','임박도 1위 (I = 5.71, 10회차 미출제)','트랜잭션/회복 영역은 평균 출제 주기가 1.75회차임에도 최근 10회차 연속 미출제되어 출제 임박도 지수가 가장 높은 최우선 출제 타겟입니다.','1. 데이터베이스 로그(Log) 기반 회복(Recovery) 기법에 대한 설명이다. 괄호 (1), (2)에 들어갈 알맞은 회복 연산을 쓰시오.','• ( 1 ): 트랜잭션이 성공적으로 완료(Commit)되었으나 변경 내용이 디스크에 반영되지 않은 경우, 로그 기록을 토대로 작업을 재실행하여 DB를 복구하는 연산
• ( 2 ): 트랜잭션 수행 도중 장애가 발생하여 비정상 종료된 경우, 트랜잭션이 가한 모든 변경 작업을 취소하고 장애 발생 이전 상태로 되돌리는 연산','','','(1) Redo (재실행)
(2) Undo (취소)','• Redo(재실행): 로그에 <Start>와 <Commit>이 모두 존재하는 트랜잭션의 변경 값을 디스크에 다시 반영합니다.
• Undo(취소): 로그에 <Start>만 있고 <Commit>이 없는 미완료 트랜잭션의 변경 내용을 이전 값(Before Image)으로 되돌립니다.');
INSERT INTO "predicted_questions" VALUES(2,'이론','네트워크/프로토콜','계산/도출형','최다 빈출 1위 (40문항, 회차당 2.2문제)','네트워크/프로토콜은 전체 이론 중 출제 빈도 1위(40문항)이며, 서브넷 마스크/CIDR 호스트 계산은 2~3회차 주기로 반복 출제됩니다.','2. C클래스 네트워크 192.168.10.0/24 대역을 서브넷 마스크 255.255.255.224로 서브넷팅할 때, (1) 생성되는 서브넷의 개수와 (2) 각 서브넷당 실제 할당 가능한 호스트 IP 개수를 쓰시오.','• 기준 네트워크: 192.168.10.0/24
• 적용 서브넷 마스크: 255.255.255.224 (/27)','','','(1) 8개
(2) 30개','1. 224를 2진수로 변환하면 11100000(2)이므로 네트워크(서브넷) 비트는 3비트, 호스트 비트는 5비트입니다.
2. 서브넷 개수 = 2^3 = 8개
3. 서브넷당 가용 호스트 IP 수 = 2^5 - 2 (네트워크 주소 및 브로드캐스트 주소 제외) = 32 - 2 = 30개');
INSERT INTO "predicted_questions" VALUES(3,'이론','디자인 패턴','단답형(용어/명칭)','상시 순환 (총 12문항, 평균 주기 1.40회차)','디자인 패턴은 거의 매 회차 출제되며, 생성/구조/행위 패턴이 교차 출제됩니다.','3. 다음이 설명하는 GoF 디자인 패턴의 명칭을 쓰시오.','한 객체의 상태가 변화하면 그 객체에 의존하는 다른 객체들에게 자동으로 알림이 전달되어 내용이 갱신되는 방식으로, 일대다(1:N) 의존 관계를 정의하는 행위(Behavioral) 디자인 패턴이다.','','','Observer (옵저버 패턴)','• Observer 패턴(행위 패턴): 주체(Subject) 객체의 상태 변화를 관찰자(Observer)들에게 통보하여 자동 갱신시키는 패턴입니다.');
INSERT INTO "predicted_questions" VALUES(4,'이론','데이터베이스(설계/정규화)','빈칸채우기(괄호형)','정기 순환 (총 10문항, 평균 주기 2.12회차)','DB 정규화 단계(도-부-이-결-다-조)는 단답형 및 빈칸형으로 꾸준히 출제되는 핵심 이론입니다.','4. 데이터베이스 정규화 단계에 대한 설명이다. 괄호 (1)~(3)에 해당하는 정규형 명칭을 쓰시오.','• ( 1 ): 기본키가 아닌 모든 속성이 기본키에 완전 함수 종속되도록 부분 함수적 종속(Partial Functional Dependency)을 제거한 정규형
• ( 2 ): 기본키가 아닌 속성 간에 발생하는 이행적 함수 종속(Transitive Functional Dependency)을 제거한 정규형
• ( 3 ): 릴레이션의 모든 결정자(Determinant)가 후보키(Candidate Key)가 되도록 분해한 강한 제3정규형','','','(1) 제2정규형 (2NF)
(2) 제3정규형 (3NF)
(3) BCNF (Boyce-Codd 정규형)','• 정규화 순서 암기(도-부-이-결-다-조): 도메인 원자값(1NF) -> 부분 함수 종속 제거(2NF) -> 이행적 함수 종속 제거(3NF) -> 결정자이면서 후보키가 아닌 것 제거(BCNF) -> 다치 종속 제거(4NF) -> 조인 종속 제거(5NF)');
INSERT INTO "predicted_questions" VALUES(5,'이론','결합도/응집도','보기선택/기호매칭형','격회차 고정 (총 8문항, 평균 주기 1.86회차)','결합도와 응집도는 주 출제방식이 보기선택/기호매칭형이며 약 1.86회차마다 반복 출제됩니다.','5. 다음 보기의 결합도(Coupling) 유형을 결합도가 약한(품질이 높은) 순서에서 강한(품질이 낮은) 순서로 기호를 나열하시오.','[보기]
ㄱ. 제어 결합도(Control)   ㄴ. 자료 결합도(Data)   ㄷ. 공통 결합도(Common)
ㄹ. 스탬프 결합도(Stamp)   ㅁ. 내용 결합도(Content)   ㅂ. 외부 결합도(External)','','','ㄴ -> ㄹ -> ㅂ -> ㄱ -> ㄷ -> ㅁ','• 결합도(약함/우수 -> 강함/불량): 자료(ㄴ) < 스탬프(ㄹ) < 외부(ㅂ) < 제어(ㄱ) < 공통(ㄷ) < 내용(ㅁ) [암기: 자-스-외-제-공-내]');
INSERT INTO "predicted_questions" VALUES(6,'이론','소프트웨어 테스트/품질','단답형(용어/명칭)','상위 빈출 (총 27문항, 평균 주기 1.13회차)','소프트웨어 테스트(27문항)는 블랙박스 기법과 화이트박스 커버리지가 번갈아 출제됩니다.','6. 화이트박스 테스트 커버리지 중 다음 설명에 해당하는 커버리지 명칭을 쓰시오.','• ( 1 ): 결정 포인트 내의 전체 조건식 결과가 참(True)/거짓(False)을 최소 한 번씩 만족하도록 수행하는 커버리지
• ( 2 ): 각 개별 조건식이 다른 조건식과 무관하게 독립적으로 전체 결정 결과에 영향을 미치도록 제어하는 변형 조건/결정 커버리지(약어 가능)','','','(1) 결정 커버리지 (또는 분기 커버리지, Branch Coverage)
(2) MC/DC (변형 조건/결정 커버리지)','• 구문(문장) 커버리지 < 조건 커버리지 / 결정(분기) 커버리지 < 조건/결정 커버리지 < 변형 조건/결정 커버리지(MC/DC) < 다중 조건 커버리지 순으로 강도가 높습니다.');
INSERT INTO "predicted_questions" VALUES(7,'이론','인터페이스/연계/웹기술','빈칸채우기(괄호형)','임박도 2위 (I = 3.86, 9회차 미출제)','인터페이스/연계 영역은 평균 주기가 2.33회차이나 최근 9회차 미출제되어 임박도 지수가 3.86으로 매우 높습니다.','7. 기업 애플리케이션 통합(EAI) 구축 유형 4가지 중 다음 설명에 해당하는 유형을 쓰시오.','• ( 1 ): 중간에 미들웨어 없이 애플리케이션 간을 1:1로 직접 연결하는 가장 단순한 방식이나 변경 및 유지보수가 어려운 유형
• ( 2 ): 단일 접점인 허브(Hub) 시스템을 통해 데이터를 전송하는 중앙 집중식 방식으로, 허브 장애 시 전체 영향이 발생하는 유형
• ( 3 ): 애플리케이션 사이에 미들웨어(버스)를 두어 처리하는 방식으로 확장성과 대용량 처리에 유리한 유형','','','(1) Point-to-Point
(2) Hub & Spoke
(3) Message Bus (ESB 방식)','• EAI 구축 4대 유형: Point-to-Point(1:1 직접 연결), Hub & Spoke(중앙 허브 경유), Message Bus(미들웨어 버스 경유), Hybrid(그룹 내 Hub & Spoke + 그룹 간 Message Bus 결합).');
INSERT INTO "predicted_questions" VALUES(8,'이론','소프트웨어 공학/방법론','단답형(용어/명칭)','임박도 3위 (I = 3.56, 8회차 미출제)','소프트웨어 공학/형상관리 영역은 최근 8회차 미출제로 임박도 3.56을 기록 중입니다.','8. 소프트웨어 형상 관리(Configuration Management)의 주요 절차에 관한 설명이다. 괄호 안에 알맞은 용어를 쓰시오.','• ( 1 ): 형상 관리 대상을 정의하고 구분하여 고유한 이름과 번호를 부여하는 활동
• ( 2 ): 형상 항목의 버전 및 변경 요구를 검토하고 승인하여 현재의 기준선(Baseline)에 반영될 수 있도록 제어하는 활동 (형상통제위원회 CCB 관여)','','','(1) 형상 식별 (Configuration Identification)
(2) 형상 통제 (Configuration Control)','• 형상관리 4대 절차: 형상 식별 -> 형상 통제 -> 형상 감사(무결성 검증) -> 형상 기록(상태 보고).');
INSERT INTO "predicted_questions" VALUES(9,'이론','데이터베이스(관계대수/구조)','단답형(용어/명칭)','임박도 4위 (I = 1.47, 21문항 빈출)','데이터베이스 관계대수/구조는 총 21문항 출제되었으며 최근 2회차 경과로 평균 주기(1.36회차)를 넘어섰습니다.','9. 다음 조건의 릴레이션 R과 S에 대하여 질문에 답하시오.','• 릴레이션 R: 속성(Attribute) 4개, 튜플(Tuple) 5개
• 릴레이션 S: 속성(Attribute) 3개, 튜플(Tuple) 4개

(1) 릴레이션 R의 차수(Degree)와 카디널리티(Cardinality)를 순서대로 쓰시오.
(2) 두 릴레이션의 카티션 프로덕트(교차곱, R × S) 결과 릴레이션의 차수와 카디널리티를 순서대로 쓰시오.','','','(1) 차수: 4, 카디널리티: 5
(2) 차수: 7, 카디널리티: 20','• 차수(Degree)는 속성(열)의 수, 카디널리티(Cardinality)는 튜플(행)의 수입니다.
• 카티션 프로덕트(R × S) 시 차수는 두 릴레이션 차수의 합(4 + 3 = 7)이 되고, 카디널리티는 두 릴레이션 카디널리티의 곱(5 × 4 = 20)이 됩니다.');
INSERT INTO "predicted_questions" VALUES(10,'이론','운영체제(스케줄링/메모리)','계산/도출형','계산형 대표 (평균 주기 2.83회차)','운영체제 영역은 주 출제방식이 계산/도출형(페이지 교체 및 스케줄링)입니다.','10. 페이지 참조 순서가 [ 1, 2, 3, 1, 4, 2, 5, 1, 2, 3 ] 이고 할당된 페이지 프레임 수가 3개일 때, LRU(Least Recently Used) 페이지 교체 알고리즘 수행 시 발생하는 페이지 부재(Page Fault) 횟수를 쓰시오. (단, 초기 프레임은 비어 있다.)','• 참조 문자열: 1, 2, 3, 1, 4, 2, 5, 1, 2, 3
• 프레임 수: 3개','','','8 (8회)','단계별 프레임 변화 (F=페이지 부재, H=히트):
1) ''1'' -> [1] (F1)
2) ''2'' -> [1, 2] (F2)
3) ''3'' -> [1, 2, 3] (F3)
4) ''1'' -> [2, 3, 1] (H - ''1''이 가장 최근 사용으로 갱신)
5) ''4'' -> 가장 오래전에 사용된 ''2'' 교체 -> [3, 1, 4] (F4)
6) ''2'' -> 가장 오래된 ''3'' 교체 -> [1, 4, 2] (F5)
7) ''5'' -> 가장 오래된 ''1'' 교체 -> [4, 2, 5] (F6)
8) ''1'' -> 가장 오래된 ''4'' 교체 -> [2, 5, 1] (F7)
9) ''2'' -> [5, 1, 2] (H - ''2''가 가장 최근 사용으로 갱신)
10) ''3'' -> 가장 오래된 ''5'' 교체 -> [1, 2, 3] (F8)
따라서 총 페이지 부재(Page Fault)는 8회 발생합니다.');
INSERT INTO "predicted_questions" VALUES(11,'코드','C언어','코드출력결과','코드 빈출 2위 (45문항, 회차당 2.5문제)','C언어 포인터와 1/2차원 배열 주소 연산은 18개 회차 중 17개 회차에 출제된 핵심 유형입니다.','11. 다음은 C언어 코드이다. 알맞는 출력 결과를 작성하시오.','','#include <stdio.h>

int main() {
    int a[3][3] = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9} };
    int *p = a[1];
    int res = *(p + 1) + *(*a + 2) + **(a + 2);
    printf("%d\n", res);
    return 0;
}','c','15','1. p = a[1] 이므로 p는 2행 시작 주소(&a[1][0])를 가리킵니다.
2. *(p + 1) = a[1][1] = 5
3. *(*a + 2) = *(a[0] + 2) = a[0][2] = 3
4. **(a + 2) = *(a[2]) = a[2][0] = 7
5. res = 5 + 3 + 7 = 15');
INSERT INTO "predicted_questions" VALUES(12,'코드','C언어','코드출력결과','코드 빈출 2위 (구조체 & 포인터)','최근 회차(2024~2026년)에서 C언어 구조체 배열과 구조체 포인터(->) 문제가 매 회차 1문제씩 출제되고 있습니다.','12. 다음 C언어 코드의 실행 결과를 쓰시오.','','#include <stdio.h>

struct Node {
    int val;
    struct Node *next;
};

int main() {
    struct Node n1 = {10, NULL};
    struct Node n2 = {20, &n1};
    struct Node n3 = {30, &n2};
    struct Node *p = &n3;

    int sum = 0;
    while (p != NULL) {
        sum += p->val;
        p = p->next;
    }
    printf("%d\n", sum);
    return 0;
}','c','60','1. 연결 리스트 구조: n3(30) -> n2(20) -> n1(10) -> NULL
2. while 루프를 따라 p->val을 누적 합산하면 30 + 20 + 10 = 60이 출력됩니다.');
INSERT INTO "predicted_questions" VALUES(13,'코드','C언어','코드출력결과','코드 빈출 2위 (재귀 함수)','재귀 호출(Recursion)과 조건 분기는 C언어와 Java에서 번갈아 출제되는 필수 알고리즘입니다.','13. 다음 C언어 코드의 실행 결과를 쓰시오.','','#include <stdio.h>

int recur(int n) {
    if (n <= 1) return n;
    if (n % 2 == 0) return n + recur(n / 2);
    else return recur(n - 1) + recur(n - 2);
}

int main() {
    printf("%d\n", recur(5));
    return 0;
}','c','11','1. recur(1) = 1, recur(0) = 0
2. recur(2) = 2 + recur(1) = 2 + 1 = 3
3. recur(3) = recur(2) + recur(1) = 3 + 1 = 4
4. recur(4) = 4 + recur(2) = 4 + 3 = 7
5. recur(5) = recur(4) + recur(3) = 7 + 4 = 11');
INSERT INTO "predicted_questions" VALUES(14,'코드','Java','코드출력결과','전체 빈출 1위 (48문항, 18회차 100% 개근)','Java는 18개 전 회차에 단 한 번도 빠지지 않고 출제(48문항)되었으며, 부모-자식 상속 시 필드 정적 바인딩 vs 메서드 동적 바인딩이 가장 많이 출제됩니다.','14. 다음 Java 코드의 출력 결과를 쓰시오.','','class A {
    int v = 5;
    int calc(int x) {
        return v + x;
    }
}

class B extends A {
    int v = 10;
    @Override
    int calc(int x) {
        return super.calc(x) + this.v;
    }
}

public class Main {
    public static void main(String[] args) {
        A obj = new B();
        System.out.println(obj.v + ", " + obj.calc(3));
    }
}','java','5, 18','1. 멤버 변수(필드)는 참조 변수 타입(A)을 따르므로 obj.v = 5 입니다.
2. 오버라이딩된 메서드는 실제 객체(B)의 calc(3)가 실행됩니다.
3. super.calc(3)은 A의 v(5) + 3 = 8을 반환하고, 여기에 B의 this.v(10)를 더하여 8 + 10 = 18이 반환됩니다.
4. 최종 출력: 5, 18');
INSERT INTO "predicted_questions" VALUES(15,'코드','Java','코드출력결과','전체 빈출 1위 (Singleton & static)','Java에서 static 인스턴스 공유 및 생성자 호출 순서 추적 문제는 오답률 1위 패턴입니다.','15. 다음 Java 코드의 출력 결과를 쓰시오.','','class Box {
    static int shared = 1;
    int local = 1;

    void up() {
        shared += 2;
        local += 2;
    }
}

public class Main {
    public static void main(String[] args) {
        Box b1 = new Box();
        Box b2 = new Box();
        b1.up();
        b2.up();
        System.out.printf("%d-%d", b1.shared, b2.local);
    }
}','java','5-3','1. shared는 static 변수이므로 b1, b2가 공유합니다. 초기값 1에서 b1.up()으로 3, b2.up()으로 5가 됩니다.
2. local은 인스턴스 변수이므로 b2.local은 초기값 1에서 b2.up() 한 번만 적용되어 3이 됩니다.
3. 출력 결과: 5-3');
INSERT INTO "predicted_questions" VALUES(16,'코드','Java','코드출력결과','전체 빈출 1위 (문자열 참조 비교)','Java의 String 리터럴 상수 풀(== 비교)과 new String() 힙 객체 비교(equals) 문제는 단골 기출입니다.','16. 다음 Java 코드의 출력 결과를 쓰시오.','','public class Main {
    public static void main(String[] args) {
        String s1 = "KOREA";
        String s2 = "KOREA";
        String s3 = new String("KOREA");

        System.out.print((s1 == s2) + " ");
        System.out.print((s1 == s3) + " ");
        System.out.print(s1.equals(s3));
    }
}','java','true false true','1. s1과 s2는 String Constant Pool의 동일한 리터럴 주소를 참조하므로 (s1 == s2)는 true입니다.
2. s3는 new 연산자로 Heap 영역에 새로운 객체를 생성하므로 (s1 == s3)는 false입니다.
3. equals()는 문자열 값 자체를 비교하므로 s1.equals(s3)는 true입니다.');
INSERT INTO "predicted_questions" VALUES(17,'코드','SQL','SQL쿼리작성/빈칸','코드 빈출 3위 (28문항, 회차당 1.56문제)','SQL은 총 28문항 출제되었으며 GROUP BY, HAVING, ORDER BY 구문 빈칸 및 작성 문제가 주를 이룹니다.','17. [주문] 테이블(고객ID, 주문금액)에서 고객별 주문 건수가 3건 이상인 고객의 ''고객ID''와 ''주문금액 합계''를 조회하되, 주문금액 합계가 높은 순(내림차순)으로 정렬하는 SQL 빈칸 (1)~(3)을 채우시오.','','SELECT 고객ID, SUM(주문금액) AS 총액
FROM 주문
GROUP BY 고객ID
(  1  ) (  2  )(*) >= 3
ORDER BY 총액 (  3  );','sql','(1) HAVING
(2) COUNT
(3) DESC','• GROUP BY 그룹에 대한 집계 조건절은 HAVING을 사용합니다.
• 튜플 건수를 세는 집계 함수는 COUNT(*)입니다.
• 내림차순 정렬 키워드는 DESC(오름차순은 ASC)입니다.');
INSERT INTO "predicted_questions" VALUES(18,'코드','SQL','SQL실행결과도출','코드 빈출 3위 (DISTINCT & NULL 집계)','COUNT(컬럼명) 시 NULL 값이 제외되는 특성과 DISTINCT 중복 제거 결과 도출은 SQL 결과 문제의 핵심 함정입니다.','18. 다음 [사원] 테이블에 대해 아래 SQL 문을 실행했을 때 출력되는 (1) 첫 번째 열의 값과 (2) 두 번째 열의 값을 쓰시오.','[사원 테이블]
사번 | 부서코드 | 보너스
1001 | D1 | 100
1002 | D1 | NULL
1003 | D2 | 200
1004 | D2 | 100
1005 | NULL | 300','SELECT COUNT(DISTINCT 부서코드), COUNT(보너스)
FROM 사원;','sql','(1) 2
(2) 4','1. COUNT(컬럼명)은 NULL 값을 제외하고 카운트합니다.
2. DISTINCT 부서코드에서 NULL을 제외한 고유값은 ''D1'', ''D2'' 2개이므로 첫 번째 결과는 2입니다.
3. 보너스 컬럼에서 NULL(1002번)을 제외한 행은 4개이므로 두 번째 결과는 4입니다.');
INSERT INTO "predicted_questions" VALUES(19,'코드','Python','코드출력결과','매 회차 고정 (21문항, 슬라이싱 & 리스트)','파이썬은 18개 회차 중 16개 회차에 출제(21문항)되었으며 문자열/리스트 슬라이싱과 컬렉션 조작이 80% 이상을 차지합니다.','19. 다음 Python 코드의 출력 결과를 쓰시오.','','text = "Information_Processing"
a = text[0:11:3]
b = text[-4:]
print(a + "-" + b[::-1])','python','Ioao-gnis','1. text[0:11]은 ''Information'' 입니다. 여기서 step=3으로 추출하면 인덱스 0(''I''), 3(''o''), 6(''a''), 9(''o'') -> ''Ioao''
2. text[-4:]는 뒤에서 4글자인 ''sing'' 입니다.
3. b[::-1]은 ''sing''을 역순으로 뒤집은 ''gnis'' 입니다.
4. 최종 출력: Ioao-gnis');
INSERT INTO "predicted_questions" VALUES(20,'코드','Python','코드출력결과','매 회차 고정 (람다 & 리스트 내포)','파이썬 함수 기본값 매개변수, 리스트 컴프리헨션, 세트(Set) 중복 제거 조합의 출제 빈도가 높습니다.','20. 다음 Python 코드의 출력 결과를 쓰시오.','','nums = [1, 2, 2, 3, 4, 4, 5]
unique_nums = list(set(nums))
res = [x * 2 for x in unique_nums if x % 2 == 1]
print(sum(res))','python','18','1. set(nums)로 중복이 제거되어 {1, 2, 3, 4, 5}가 됩니다.
2. 홀수(x % 2 == 1)인 원소는 1, 3, 5 이며, 각각 2를 곱하면 res = [2, 6, 10] 이 됩니다.
3. sum(res) = 2 + 6 + 10 = 18');
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
INSERT INTO "questions" VALUES(1,1,1,1,10,'서술·약술형','1. 살충제 패러독스의 개념에 관해서 서술하시오.','','','','[]','[]','동일한 테스트 케이스에 의한 반복적 테스트는 새로운 버그를 찾지 못한다는 테스트 원리','애플리케이션 테스트 : 애플리케이션에 잠재되어 있는 결함을 찾아내는 일련의 행위 또는 절차
절차 :
- 확인(Validation) : 개발된 소프트웨어가 고객의 요구사항을 만족하는가
- 검증(Verification) : 개발된 소프트웨어가 기능을 정확히 수행하는가
기본원리 :
-완벽한 테스트 불가능
: 애플리케이션 테스트는 소프트웨어의 잠재적 결함은 줄일 수 있지만 결함이 없다고 증명할 수는 없다.
- 결합 집중(Defect Clustering)
: 애플리케이션 결함은 대부분 개발자의 특성이나 애플리케이션 기능적 특징 때문에 모듈에 집중되어 있다.
- 파레토 법칙(Pareto Principle)
: 애플리케이션의 20%에 해당하는 코드에서 전체 결함의 80%가 발견된다.
- 살충제 패러독스(Pesticide Paradox)
: 동일한 테스트를 반복하면 더 이상 결함이 발견되지 않는 "살충제 패러독스" 현상이 발생. 지속적으로 테스트케이스 보안 개선
- 테스팅은 정황(Context) 의존
: 소프트웨어 특징, 테스트 환경, 테스터 역량 등 정황에 따라 테스트를 다르게 수행해야한다.
- 오류-부재의 궤변
: 소프트웨어 결함을 모두 제거해도, 결국 사용자의 요구사항을 만족시키지 못하면 해당 소프트웨어는 품질이 높지 않다');
INSERT INTO "questions" VALUES(2,1,2,1,6,'서술·약술형','2. 데이터 마이닝의 개념에 관해서 서술하시오.','','','','[]','[]','대규모로 저장된 데이터 안에서 체계적이고 자동적으로 통계적 규칙이나 패턴을 찾아내는 기술','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [대규모로 저장된 데이터 안에서 체계적이고 자동적으로 통계적 규칙이나 패턴을 찾아내는 기술] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(3,1,3,1,5,'핵심 용어 단답형','3. 프로토콜의 기본 요소 3가지를 쓰시오.','','','','[]','[]','구문(Syntax), 의미(Semantics) , 순서(Timing)
구문 : 데이터의 형식이나 부호화 및 신호 레벨 등을 규정
의미 : 전송의 조작이나 오류 제어를 위한 제어 정보에 대한 규정','순서 : 접속되어 있는 개체 간의 통신 속도의 조정이나 메세지의 순서 제어 등을 규정');
INSERT INTO "questions" VALUES(4,1,4,1,6,'핵심 용어 단답형','4. 다음이 설명하는 용어는 무엇인지 쓰시오.','W3C(World wide Web Consortium)에서 개발되었고, 웹 브라우저 간 호환이 되지 않는 문제와 SGML(Standard Generalized Markup Language)의 복잡함을 해결하기 위해 개발된 다목적 마크업 언어이다.','','','[]','[]','XML (eXtensible Markup Language)','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [XML (eXtensible Markup Language)] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(5,1,5,1,7,'핵심 용어 단답형','5. 속성-값(Attribute-value Pair)으로 이루어진 데이터 오프젝트를 전달하기 위해 사용하는 개방형 표준 포멧이다. Ajax(Asynchronous JavaScript and XML)에서 많이 사용되고 XML(eXtensible Markup Language)을 대체하는 주요 데이터 포맷이다. 언어 독립형 데이터 포맷으로 다양한 데이터 프로그래밍 언어에서 사용하고 있는 기술은 무엇인가?','','','','[]','[]','JSON(JavaScript Object Notation)','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [JSON(JavaScript Object Notation)] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(6,1,6,2,3,'SQL 결과 도출형','6. STUDENT 테이블에서 컴퓨터과 학생 50명, 인터넷과 학생 100명, 사무자동화과 학생 50명의 정보가 저장되어 있을 때, 다음 SQL문의 실행 결과에 따른 튜플의 수는? (단, DEPT 칼럼은 학과명이다.)','','1) SELECT DERP FROM STUDENT;
2) SELECT DISTINCT DEPT FROM STUDENT;
3) SELECT COUNT(DISTINCT DEPT) FROM STUDENT WHERE DEPT = ''컴퓨터과'';','sql','[]','[]','1. 200
2. 3
3. 1','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1. 200
2. 3
3. 1] 입니다.');
INSERT INTO "questions" VALUES(7,1,7,1,12,'수식·계산 도출형','7. 스케줄링 방식에서 HRN(Highest Response ratio Next) 우선순위 계산식을 쓰시오.','','','','[]','[]','(대기 시간 + 서비스 시간) / 서비스 시간','HRN 스케줄링 기법은 SJF 스케줄링 기법의 약점인 긴 작업과 짧은 작업 사이의 불평등을 보완하기 위한 방법으로, 위에 우선순위 계산식은 시스템 응답시간이 커질수록 우선순위가 높아진다는 의미 입니다.
위의 HRN를 비롯하여, SJF와 FIFO, 우선순위, 기반부는 비선점형 프로세스 스케줄링에 속합니다.
SJF(Shortest Job First) : 프로세스의 실행시간이 가장 적은 프로세스를 먼저 실행시키는 기법입니다.
FIFO(First In First Out)는 각 페이지가 주기억장치에 적재될 때마다 가장 먼저 들어왔던 페이지가 가장 오래 있었기 때문에 해당 페이지를 교체하는 기법입니다.
우선순위 : 미리 정의한 알고리즘대로 프로세스의 우선순위를 결정하는 방식기한부 : 프로세스마다 정해진 시간할당량만큼만 실행되도록 지정하는 방식');
INSERT INTO "questions" VALUES(8,1,8,1,15,'핵심 용어 단답형','8. 트랜잭션의 특징 중, 일관성 지속성 외 2개의 특성을 쓰시오.','','','','[]','[]','원자성, 독립성','원자성 : 트랜잭션이 데이터베이스에 모두 반영되던가, 전혀 반영되지 않아야 한다는 점
일관석 : 트랜잭션의 작업 처리 결과가 항상 일관성이 있어야 한다는 점
독립성 : 둘 이상의 트랜잭션이 동시에 실행되고 있을 경우, 어떤 하나의 트랜잭션이라도 다른 트랜잭션의 연산에 끼어들 수 없다는 점
지속성 : 트랜잭션이 성공적으로 완료되었을 경우, 결과는 영구적으로 반영되어야 한다는 점');
INSERT INTO "questions" VALUES(9,1,9,1,5,'핵심 용어 단답형','9. 공격자가 패킷의 출발지 주소나 포트를 임의로 변경해 출발지와 목적지 주소를 동일하게 함으로써 공격 대상 컴퓨터의 실행속도를 느리게 하거나 동작을 마비시켜 서비스 거부 상태에 빠지도록 하는 공격 방법은 무엇인가?','','','','[]','[]','랜드 어택 (Land Attack)','네트워크 공격 유형
서비스 거부 공격 (DOS - Denial of Service) :
표적이 되는 서비스 자원을 고갈시킬 목적으로 다수의 공격자 또는 시스템에서 대량의 데이터를 한 곳의 서버에 집중적으로 전송함으로써 표적이 되는 서버의 정상적인 기능을 방해하는 공격 방법으로, DDoS와의 차이점은 Attacker가 직접 공격을 수행
분산 서비스 거부 (DDoS -Distributed Denial of Service) :
Attacker가 여러 대의 컴퓨터를 감염시켜 동시에 한 타깃 시스템을 집중적으로 공격하는 방법으로써, 짧은 시간 안에 서버를 마비시킬 수 있으며 Dos보다 치명적이고 Dos와의 차이점은 실질적인 Attacker가 아닌 Attacker가 감염시킨 좀비 PC가 공격을 수행한다는 점
Ping of Death :
ping 명령을 전송할 때 패킷의 크기를 인터넷 프로토콜 허용 범위 이상으로 전송하여 네트워크를 마비시키는 공격 방법
Smurfing :IP또는 ICMP의 특성을 악용하여 엄청난 양의 데이터를 한 사이트에 집중적으로 보내냄으로써 네트워크 불능 상태로 만드는 공격
SYN Flooding : 공격자가 가상의 클라이언트로 위장하여 3-way-handshake 과정을 의도적으로 중단 시킴으로써 공격 대상자인 서버가 대기 상태에 놓여 정상적으로 서비스를 수행하지 못하게 하는 공격 방법
TearDrop :데이터의 송.수신 과정에서 패킷의 크기가 여러 개로 분할되어 전송할때 분할 순서를 변경시켜 수신측에서 패킷을 재조립할 때 오류로 인한 과부하를 발생시킴으로써 시스템이 다운되도록 하는 공격 방법Smurfing :IP또는 ICMP의 특성을 악용하여 엄청난 양의 데이터를 한 사이트에 집중적으로 보내냄으로써 네트워크 불능 상태로 만드는 공격');
INSERT INTO "questions" VALUES(10,1,10,1,7,'핵심 용어 단답형','10. RFC 1321로 지정되어 있으며, 주로 프로그램이나 파일이 원본 그대로 인지를 확인하는 무결성 검사 등에 사용된다. 1991년 로널드 라이베스트가 예전에 쓰이던 MD4를 대체하기 위해 고안된 128비트 암호화 해시 함수는 무엇인가?','','','','[]','[]','MD5','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [MD5] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(11,1,11,1,16,'괄호 빈칸 채우기형','11. 다음은 공통 모듈 구현의 개념에 대한 설명이다. 괄호 ( ) 안에 알맞은 용어를 쓰시오.','- 소프트웨어 개발에 있어 기능을 분할하고 추상화하여 성능을 향상시키고 유지보수를 효과적으로 하기 위한 공통 컴포넌트 구현 기법이다.
- 인터페이스 모듈, 데이터베이스 접근 모듈 등 필요한 공통 모듈을 구현한다.
- 모듈 간의 ( 1. ) 은/는 줄이고, ( 2 . ) 은/는 높은 공통 모듈 구현을 권한하고 있다.','','','[]','[]','1. 결합도
2. 응집도','[소프트웨어 공학/방법론 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 결합도
2. 응집도] 입니다.
• 학습 가이드: [소프트웨어 공학/방법론] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(12,1,12,2,1,'코드 출력 결과형','12. 다음은 C언어 소스 코드이다. 출력 결과를 쓰시오.','','#include <stdio.h>
 void main(){
 	int i,j;
    int temp;
    int a[5] = {75,95,85,100,50};
    
    for(i=0; i<4; i++){
    	for(j=0; j<4-i; j++){
        	if(a[j] > a[j+1]){
            	temp=a[j];
                a[j] = a[j+1];
                a[j+1] = temp;
             }
           }
        }
        
       	for(i=0; i<5; i++){
        	printf("%d", a[i]);
        }
  }','c','[]','[]','50758595100','[C언어 실행 과정 분석]
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [50758595100] 입니다.');
INSERT INTO "questions" VALUES(13,1,13,2,2,'코드 출력 결과형','13. 다음은 자바 소스코드이다. 출력 결과를 쓰시오.','','public class good {
	public static void main(String[] args){
    	int i;
        int[] a = {0,1,2,3};
        for(i=0; i<4; i++){
        	System.out.print(a[i] + " ");
        }
     }
 }','java','[]','[]','0 1 2 3','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [0 1 2 3] 입니다.');
INSERT INTO "questions" VALUES(14,1,14,2,2,'코드 출력 결과형','14. 다음은 자바 소스코드이다. 출력 결과를 쓰시오.','','public class good {
	public static void main(String[] args){
    	int i = 3;
        int k = 1;
        swich (i) {
        case 0;
        case 1;
        case 2;
        case 3 k = 0;
        case 4 k += 3;
        case 5 k -= 10;
        default: k--;
        }
        system.out.print(k);
     }
}','java','[]','[]','-8','switch case문에 break가 없는 점을 주의하셔야 합니다.');
INSERT INTO "questions" VALUES(15,1,15,1,16,'핵심 용어 단답형','15. 다음이 설명하는 제품 패키지 릴리스 노트의 작성 항목은 무엇인가?','[보기]
문서 이름(릴리스 노트 이름), 제품 이름, 버전 번호, 릴리스 날짜, 참고 날짜, 노트 버전 등의 정보','','','[]','[]','해더','릴리스 노트 :
개발 과정에서 정리된 릴리스 정보를 소프트웨어의 최종 사용자인 고객과 공유하기 위한 문서입니다.
릴리스 노트 항목 :
해더, 개요, 목적, 문제요약, 재현항목, 수정/개선 내용, 사용자 영향도, SW지원 영향도, 노트, 면책조항, 연락처
릴리스 노트 작성 순서 :
모듈 식별 > 릴리스 정보 확인 > 릴리스 노트 개요 작성 > 영향도 체크 > 정식 릴리스 노트 작성 > 추가 개선 항목 식별');
INSERT INTO "questions" VALUES(16,1,16,1,16,'수식·계산 도출형','16. LoC(Line of Code)가 30,000라인이고, 개발자가 5명이며, 개발자가 월평균 300라인을 개발한다. 이때 프로젝트 개발 기간과 계산식을 쓰시오.','','','','[]','[]','프로젝트 개발 기간 : 20개월
계산식 : (30,000라인 / 300라인) / 5명 = 20개월','[소프트웨어 공학/방법론 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [프로젝트 개발 기간 : 20개월
계산식 : (30,000라인 / 300라인) / 5명 = 20개월] 입니다.
• 학습 가이드: [소프트웨어 공학/방법론] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(17,1,17,1,13,'서술·약술형','17. 비정규화(De-Normalization)의 개념을 쓰시오','','','','[]','[]','정규화된 엔티티, 속성, 관계에 대해 성능 향상과 개발 운영의 단순화를 위해 중복, 통합, 분리 등을 수행하는 데이터모델링 기법','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [정규화된 엔티티, 속성, 관계에 대해 성능 향상과 개발 운영의 단순화를 위해 중복, 통합, 분리 등을 수행하는 데이터모델링 기법] 입니다.
• 학습 가이드: [데이터베이스(설계/정규화)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(18,1,18,1,6,'핵심 용어 단답형','18. OSI 계층 중 비트를 전송하는 계층은 무엇인가?','','','','[]','[]','물리 계층 (Physical Layer)','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [물리 계층 (Physical Layer)] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(19,1,19,1,6,'핵심 용어 단답형','19. 애플리케이션의 성능을 측정하기 위한 지표는 무엇인가?','','','','[{"type": "grid", "rows": [["지표", "설명"], ["( 1 )", "- 애플리케이션이 주어진 시간에 처리할 수 있는 트랜잭션의 수\n- 웹 애플리케이션의 경우 시간당 페이지수로 표현"], ["( 2 )", "- 사용자 입력이 끝난 후, 애플리케이션의 응답 출력이 개시될 때까지의 시간\n- 애플리케이션의 경우 메뉴 클릭 시 해당 메뉴가 나타나기까지 걸리는 시간"], ["( 3 )", "- 애플리케이션에 사용자가 요구를 입력한 시점부터 트랜잭션 처리 후 그 결과의 출력이 완료될 때까지 걸리는 시간"], ["자원 사용률", "- 애플리케이션이 트랜잭션을 처리하는 동안 사용하는 CPU 사용량 , 메모리 사용량, 네트워크 사용량"]]}]','[]','1. 처리량
2. 응답 시간
3. 경과 시간','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 처리량
2. 응답 시간
3. 경과 시간] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(20,1,20,1,11,'핵심 용어 단답형','20. 다음은 모듈의 관계를 나타낸 다이어그램이다. fan-in 개수가 2 이상인 모듈 명칭을 쓰시오.','','','','[]','[{"local": "/images/questions/q_020_1.png", "remote": "https://blog.kakaocdn.net/dna/qaQ59/btq8H41KRYo/AAAAAAAAAAAAAAAAAAAAAOsMDq2Fgpm1jZ449qrh3bzWU8qZZDsUkEnja_1cojQx/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=0AsKQ%2Bb9I4GvoL%2BZI%2BKaiVEik%2BQ%3D"}]','F,H','모듈에서 화살표가 나가는 경우 팬아웃이고 모듈에서 화살표가 들어오는 경우 팬인이라고 합니다.');
INSERT INTO "questions" VALUES(21,2,1,1,6,'핵심 용어 단답형','1. 정보시스템 운영 중 서버가 다운되거나 자연재해나 시스템 장애 등의 이유로 고객에게 서비스가 불가능한 경우가 종종 발생한다. 이와 같은 상황에서 비상사태 또는 업무중단 시정부터 업무가 복구되어 다시 정상 가동될때까지의 시간을 의미하는 용어가 무엇인지 쓰시오.','','','','[]','[]','재해 복구 시간 or RTO(Recovery Time Objective)','재해복구시점 (RPO : Recovery Point Objective) : 재해 발생시, 데이터손실을 수용 손실 허용 시점
네트워크복구시간 (RCO : Recovery Communication Objective) : 주 영업점과 DR센터 간 네트워크 복구 수준
재해복구범위(RSO : Recovery Scope Objective) : 업무 중요도에 따른 복구 대상시스템 선정');
INSERT INTO "questions" VALUES(22,2,2,2,4,'코드 출력 결과형','2. 다음은 파이썬 코드이다. 출력 결과를 쓰시오.','','a={''일본'',''중국'',''한국''}
a.add(''베트남'')
a.add(''중국'')
a.remove(''일본'')
a.update([''홍콩'',''한국'',''태국''])
print(a)','python','[]','[]','{''중국'',''한국'',''베트남'',''홍콩'',''태국''}','[Python 코드 실행 과정 분석]
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [{''중국'',''한국'',''베트남'',''홍콩'',''태국''}] 입니다.');
INSERT INTO "questions" VALUES(23,2,3,1,17,'핵심 용어 단답형','3. 브라우저가 가지고 있는 XMLHttpRequest 객체를 이용해서 전체 페이지를 새로 고치지 않고도 페이지의 일부분만을 위한 데이터를 로드하는 기법이며, 하이퍼텍스트 표기 언어(HTML)만으로 어려운 다양한 작업을 웹 페이지에서 구현해 이용자가 웹 페이지와 자유롭게 상호작용할 수 있도록 하는 기술명을 쓰시오.','','','','[]','[]','비동기 통신 기법 or AJAX(Asynchronous JavaScript and XML)','[인터페이스/연계/웹기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [비동기 통신 기법 or AJAX(Asynchronous JavaScript and XML)] 입니다.
• 학습 가이드: [인터페이스/연계/웹기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(24,2,4,1,6,'핵심 용어 단답형','4. 절차보다는 사람이 중심이 되어 변화에 유연하고 신속하게 적응하면서 효율적으로 시스템을 개발할 수 있는 신속 적응적 경량 개발방법론으로, 개발 기간이 짧고 신속하며, 워터폴에 대비되는 방법론으로 최근 회사에서 각광받는 방법론은 무엇인가?','','','','[]','[]','애자일 방법론','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [애자일 방법론] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(25,2,5,2,2,'코드 빈칸 완성형','5. 다음은 자바 코드이다. 다음 밑줄에 들어갈 키워드를 쓰시오.','','class parent
	public void show(){
    	system.out.println("Parent");
    }
}

class Child extends Parent{
	public void show(){
    	system.out.println("Child");
    }
}

public class good{
	public static void main(String[] args){
    	Parent pa = ____  Child();
        pa.show();
    }
}','java','[]','[]','new','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [new] 입니다.');
INSERT INTO "questions" VALUES(26,2,6,2,3,'SQL 작성·빈칸형','6. 학생 테이블은 학번, 이름, 학년, 수강과목, 점수, 연락처를 속성으로 가진다. 아래 조건을 만족하는 SQL문을 작성하시오.','1) 학생 테이블에서 3,4학년인 학번, 이름을 조회한다.
2) IN 연산자 사용해야 한다.
[학생]','','sql','[{"type": "grid", "rows": [["학번", "이름", "학년", "수강과목", "점수", "연락처"], ["1000", "김이름", "1", "수학", "90", "010-1111-2222"], ["2000", "장이름", "2", "과학", "95", "010-2222-2222"], ["3000", "허이름", "3", "미술", "90", "010-3333-3333"], ["4000", "조이름", "4", "음악", "95", "010-4444-4444"]]}]','[]','SELECT 학번, 이름 FROM 학생 WHERE 학년 IN (3,4);','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [SELECT 학번, 이름 FROM 학생 WHERE 학년 IN (3,4);] 입니다.');
INSERT INTO "questions" VALUES(27,2,7,1,15,'서술·약술형','7. 트랜잭션 Rollback에 대해 설명하시오.','','','','[]','[]','트랜잭션 처리 중 오류가 발생했을 때, 오류 이전의 특징 시점(SAVEPOINT, CHECKPOINT) 상태로 되돌려주는 제어어(명령문)이다.','[데이터베이스(트랜잭션/회복) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [트랜잭션 처리 중 오류가 발생했을 때, 오류 이전의 특징 시점(SAVEPOINT, CHECKPOINT) 상태로 되돌려주는 제어어(명령문)이다.] 입니다.
• 학습 가이드: [데이터베이스(트랜잭션/회복)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(28,2,8,1,7,'핵심 용어 단답형','8. 무결성과 인증을 보장하는 인증해더(AH)와 기밀성을 보장하는 암호화(ESP)를 이용한 프로토콜로 네트워크 계층(Network Layer)인 인터넷 프로토콜(IP)에 보안성을 제공해주는 표준화된 기술에 대해 쓰시오.','','','','[]','[]','IPSec(Internet Protocol Security)','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [IPSec(Internet Protocol Security)] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(29,2,9,1,10,'핵심 용어 단답형','9. 애플리케이션을 실행하지 않고, 소스 코드에 대한 코딩 표준, 코딩 스타일, 코드 복잡도 및 남은 결함을 발견하기 위해 사용하는 도구는 무엇인지 쓰시오.','','','','[]','[]','정적 분석 도구','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [정적 분석 도구] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(30,2,10,1,6,'핵심 용어 단답형','10. 다음 보기가 설명하는 패턴을 쓰시오. (영문 Full-Name으로 작성하시오)','[보기]
한 객체의 상태가 바뀌면 그 객체에 의존하는 다른 객체들이 연락이 가고 자동으로 내용이 갱신되는 방법으로 일대 다의 의존성을 가지며 상호작용하는 객체 사이에서는 가능하면 느슨하게 결합하는 디자인을 사용해야 한다.','','','[]','[]','Observer Pattern','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Observer Pattern] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(31,2,11,1,18,'핵심 용어 단답형','11. Linux 운영체제 위에서 구동하며 휴대폰 전화를 비롯한 휴대용 장치를 위한 운영체제와 미들웨어, 사용자 인터페이스 그리고 표준 응용프로그램(웹 브라우저 등) 등을 포함하고 있는 소프트웨어 스택이자 리눅스 모바일 운영체제로 개발자들이 자바와 코틀린 언어로 응용 프로그램을 작성할 수 있게 했고, 컴파일 된 바이트 코드를 구동할 수 있는 런타임 라이브러리를 제공하는 운영체제는 무언인지 쓰시오.','','','','[]','[]','안드로이드','[운영체제(명령어/기초) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [안드로이드] 입니다.
• 학습 가이드: [운영체제(명령어/기초)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(32,2,12,2,3,'SQL 작성·빈칸형','12. 학생 테이블의 name속성에 IDX_NAME 이름으로 인덱스 생성하는 SQL문을 작성하시오.','','','sql','[{"type": "grid", "rows": [["STID", "NAME", "SCORE", "DEPTID"], ["1000", "김이름", "90", "1"], ["2000", "허이름", "95", "2"], ["3000", "조이름", "90", "3"], ["4000", "장이름", "95", "4"]]}]','[]','CREATE INDEX IDX_NAME ON 학생(NAME);','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [CREATE INDEX IDX_NAME ON 학생(NAME);] 입니다.');
INSERT INTO "questions" VALUES(33,2,13,1,5,'괄호 빈칸 채우기형','13. 다음 설명 중 빈칸에 들어갈 알맞는 용어를 작성하시오.','HTTP, HTTPS SMTP를 통해서 XML 기반의 데이터를 주고받는 프로토콜로 웹 서비스 방식에 HTTP기반의 ( ) 을/를 사용하여 송수신한다. ( ) 대신 레스트풀(RESTful) 프로토콜로 대체할 수 있다.','','','[]','[]','SOAP (Simple Object Access Protocol)','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [SOAP (Simple Object Access Protocol)] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(34,2,14,1,8,'서술·약술형','14. SQL Injection이 무엇인지 서술하시오.','','','','[]','[]','응용 프로그램의 보안 취약점을 이용해서 악의적인 SQL 구문을 삽입, 실행시켜서 데이터베이스의 접근을 통해 정보를 탈취하거나 조작 등의 행위를 하는 공격 기법','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [응용 프로그램의 보안 취약점을 이용해서 악의적인 SQL 구문을 삽입, 실행시켜서 데이터베이스의 접근을 통해 정보를 탈취하거나 조작 등의 행위를 하는 공격 기법] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(35,2,15,1,18,'핵심 용어 단답형','15. 사용자에게 읽기 / 쓰기 / 실행 권한을 부여하고 그룹에게는 읽기 / 실행을 부여하고 그 이외에는 실행 권한을 a.txt에 부여하는 명령어를 한줄로 작성하시오 (8진법을 사용하시오)','','','','[]','[]','chmod 751 a.txt','[운영체제(명령어/기초) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [chmod 751 a.txt] 입니다.
• 학습 가이드: [운영체제(명령어/기초)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(36,2,16,1,6,'괄호 빈칸 채우기형','16. UI 설계 원칙에서 정확하고 완벽하게 사용자의 목표가 달성될 수 있도록 제작할 수 있어야 한다. 다음 빈칸에 들어갈 특징은 무엇인가?','직관성 - 누구나 쉽게 이해하고 사용할 수 있어야 한다.
학습성 - 누구나 쉽게 배우고 익힐 수 있어야 한다.
유연성 - 사용자의 요구사항을 최대한 수용하며 오류를 최소화해야 한다.
( ) - 사용자의 목적을 정확하게 달성하여야 한다.','','','[]','[]','유효성','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [유효성] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(37,2,17,1,6,'핵심 용어 단답형','17. 전 세계 오픈된 정보를 하나로 묶는 방식으로 link data와 open data의 합성어가 무엇인지 쓰시오.','','','','[]','[]','LOD (Linked Open Data)','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [LOD (Linked Open Data)] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(38,2,18,1,6,'보기·기호 선택형','18. 다음은 데이터 모델링 절차이다. 절차에 맞도록 보기에서 찾아 채우시오.','[보기]
1. 물리적 데이터 모델링
2. 개념적 데이터 모델링
3. 논리적 데이터 모델링
요구사항 분석 > ( 1. ) > ( 2. ) > ( 3. )','','','[]','[]','1. 개념적 데이터 모델링
2. 논리적 데이터 모델링
3. 물리적 데이터 모델링','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 개념적 데이터 모델링
2. 논리적 데이터 모델링
3. 물리적 데이터 모델링] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(39,2,19,2,2,'코드 출력 결과형','19. 다음은 자바 코드이다. 출력 결과를 쓰시오.','','class A{
	private int a;
    public A(int a){
    	this.a = a;
    }
    public void display(){
    	system.out.println("a=" + a);
    }
}

class B extends A {
	public B(int a){
    	super(a);
        super.display();
    }
}


public class good {
	public static void main(String[] args){
    	B obj = new B(10);
    }
}','java','[]','[]','a = 10','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [a = 10] 입니다.');
INSERT INTO "questions" VALUES(40,2,20,1,16,'괄호 빈칸 채우기형','20. 소프트웨어 개발 과정에서 변경 사항을 관리하는 기법은 ( ) 기법이라고 하며, ( ) 기법을 활용한 도구로는 CVS, SVN, Git 등이 있다. 빈칸에 알맞은 용어를 쓰시오.','','','','[]','[]','형상관리','[소프트웨어 공학/방법론 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [형상관리] 입니다.
• 학습 가이드: [소프트웨어 공학/방법론] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(41,3,1,1,16,'서술·약술형','1. 리팩토링의 목적에 대하여 서술하시오.','','','','[]','[]','복잡한 코드의 단순화, 소스의 가독성을 통해 유지보수성 향상, 유연한 시스템, 생산성 향상, 품질 향상이 있다.','[소프트웨어 공학/방법론 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [복잡한 코드의 단순화, 소스의 가독성을 통해 유지보수성 향상, 유연한 시스템, 생산성 향상, 품질 향상이 있다.] 입니다.
• 학습 가이드: [소프트웨어 공학/방법론] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(42,3,2,2,1,'코드 출력 결과형','2. 다음은 C언어 소스 코드이다. 출력 결과를 쓰시오.','','#include <stdio.h>
	void main(){
    	int i=0, c=0;
        while (i<10){
        i++;
        c*=i;
        }
        printf("%d",c);
   }','c','[]','[]','0','c가 0이므로 어떤수를 곱해도 0이 됩니다.');
INSERT INTO "questions" VALUES(43,3,3,1,5,'핵심 용어 단답형','3. 대표적인 내부 라우팅 프로토콜로 다익스트라 알고리즘을 이용한 대규모 네트워크에 적합한 링크 상태 라우팅 프로토콜로 불리는 라우팅 프로토콜은 무엇인가?','','','','[]','[]','OSPF(Open Shortest Path First)','OSPF(Open Shortest Path First)의 특징 :
다익스트라 알고리즘 사용 - 다익스트라 알고리즘 사용하는 내부 라우팅 프로토콜
라우팅 메트릭 지정 - 최소, 지연, 최대 처리량 등 관리자가 라우팅 메트릭 지정
AS분할 사용 - 자치 시스템을 지역으로 나누어 라우팅을 효과적으로 관리
홉 카운트 무제한 - 홉 카운트에 제한이 없다.
라우팅 : 어떤 네트워크 안에서 통신 데이터를 보낼 때 최적의 결로를 선택하는 과정입니다.');
INSERT INTO "questions" VALUES(44,3,4,1,16,'서술·약술형','4. 형상 통제를 설명하시오.','','','','[]','[]','형상 항목의 버전 관리를 위해서 변경 여부와 변경 활동을 통제하는 활동','형상 관리 절차 :
형상 식별 - 형상 관리 대상을 정의 및 식별하는 활동
형상 통제 - 형상 항목의 버전 관리를 위한 형상통제위원회 운영
형상 감사 - 소프트웨어 베이스라인의 무결성 평가
형상 기록 - 소프트웨어 현상 및 변경관리에 대한 각종 수행결과를 기록');
INSERT INTO "questions" VALUES(45,3,5,1,6,'괄호 빈칸 채우기형','5. 심리학자 톰 마릴은 컴퓨터가 메세지를 전달하고, 메세지가 제대로 도착했는지 확인하며, 도착하지 않았을 경우 메세지를 재전송하는 일련의 방법을 ''기술적 은어''를 뜻하는 ( )이라는 용어로 정의했다. 괄호 ( ) 안에 들어갈 용어를 쓰시오.','','','','[]','[]','프로토콜','프로토콜 : 서로 다른 시스템이나 기기들 간의 데이터 교환을 원할히 하기 위한 표준된 통신규약입니다.
프로토콜 기능 : 데이터 처리 기능 / 제어 기능 / 관리 기능');
INSERT INTO "questions" VALUES(46,3,6,1,5,'괄호 빈칸 채우기형','6. TCP/IP에서 오류가 발생하면 ( ) 메세지를 보내서 오류가 발생했음을 알린다. 괄호 ( )안에 들어갈 용어를 쓰시오.','','','','[]','[]','ICMP(Internet Control Message Protocol)','ICMP : IP 패킷을 처리할 때 발생하는 문제를 알려주는 프로토콜로, 메세지 형식은 8바이트의 헤더와 가변 길이의 데이터 영역으로 분리되어 있다.');
INSERT INTO "questions" VALUES(47,3,7,1,10,'핵심 용어 단답형','7. 다음 아래 제어 흐름 그래프가 분기 커버리지를 만족하기 위한 테스팅 순서를 쓰시오.','','','','[]','[{"local": "/images/questions/q_047_1.png", "remote": "https://blog.kakaocdn.net/dna/JIE3a/btq8H5sOaQq/AAAAAAAAAAAAAAAAAAAAAFzdB3wBnD25WvCpe6C-4l1qaFtovS0BL8rljez6n-2u/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=YvISGDZ0cYPOJ7XjAVmbECr3sJ4%3D"}]','1234561, 124567 or 1234567, 124561','결정 커버리지는 결정 포인트 내의 전체 조건식이 적어도 한 번은 참과 거짓의 결과를 수행해야 하기 때문에 첫 번째 분기문도 참, 거짓이 와야 하고, 두 번째 분기도 참, 거짓이 한 번씩 와야 한다.');
INSERT INTO "questions" VALUES(48,3,8,2,3,'SQL 작성·빈칸형','8. 다음 조건을 만족하면서, 과목별 점수의 평균이 90이 상인 과목이름, 최소점수, 최대점수를 구하는 SQL문을 작성하시오.','- 대소문자를 구분하지 않는다.
- WHERE 구분을 사용하지 않는다.
- GROUP BY, HAVING구문을 반드시 사용한다.
- 세미콜론(;)은 생략 가능하다.
- 별칭(AS)을 사용해야 한다.
[성적]
[결과]','','sql','[{"type": "grid", "rows": [["과목코드", "과목이름", "학점", "점수"], ["1000", "컴퓨터과학", "A+", "95"], ["2000", "운영체제", "B+", "85"], ["1000", "컴퓨터과학", "B+", "85"], ["2000", "운영체제", "B", "80"]]}, {"type": "grid", "rows": [["과목이름", "최소점수", "최대점수"], ["컴퓨터과학", "85", "95"]]}]','[]','SELECT 과목이름, MIN(점수) AS 최소점수, MAX(점수) AS 최대점수 FROM 성적
GROUP BY 과목이름 HAVING AVG(점수) >= 90;','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [SELECT 과목이름, MIN(점수) AS 최소점수, MAX(점수) AS 최대점수 FROM 성적
GROUP BY 과목이름 HAVING AVG(점수) >= 90;] 입니다.');
INSERT INTO "questions" VALUES(49,3,9,2,3,'SQL 작성·빈칸형','9. 학생 테이블에서 이름이 민수인 튜플을 삭제하는 SQL문을 작성하시오','[학생]','','sql','[{"type": "grid", "rows": [["학번", "이름", "점수", "과목이름"], ["1000", "김정미", "90", "알고리즘"], ["2000", "강은미", "95", "데이터베이스"], ["3000", "홍길동", "90", "전산수학"], ["4000", "민수", "95", "운영체제"]]}]','[]','DELETE FROM 학생 WHERE 이름 = ''민수'';','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [DELETE FROM 학생 WHERE 이름 = ''민수'';] 입니다.');
INSERT INTO "questions" VALUES(50,3,10,1,7,'핵심 용어 단답형','10. 릴레이션 A, B가 있을 때 릴레이션 B 조건에 맞는 것들만 릴레이션 A에서 튜플을 꺼내 프로젝션하는 관계 대수의 기호는 무엇인가?','','','','[]','[]','÷','순수관계연산자는 셀렉트(σ) / 프로젝트(π) / 조인(⋈) / 디비전(÷) 이 있습니다.
셀렉트 : 릴레이션에 존재하는 튜플들 중에서 특정 조건을 만족하는 튜플들의 부분집합을 구하여 새로운 릴레이션을 만듭니다.
프로젝트 : 주어진 릴레이션에서 속성 리스트에 제시된 속성 값만을 추출하여 새로운 릴레이션을 만듭니다.
(단 연산 결과에 중복이 발생하면 중복이 제거됩니다.)
조인 : 공통 속성을 중심으로 2개의 릴레이션을 하나로 합쳐서 새로운 릴레이션을 만듭니다.');
INSERT INTO "questions" VALUES(51,3,11,1,8,'서술·약술형','11. 다음 중 헝가리안 표기법(Hungarian Case)에 대해서 서술하시오.','','','','[]','[]','헝가리안 표기법은 식별자 표기 시 접두어에 자료형을 붙이는 표기법','식별자 표기법 :
카멜 표기법 - 식별자 표기 시에 여러 단어가 이어지면 첫 단어 시작만 소문자로 표시하고, 각 단어의 첫 글자는 대문자로 지정하는 표기법 (ex : goodMan)
파스칼 표기법 - 식별자 표기 시에 여러 단어가 이어지면 각 단어의 첫 글자는 대문자로 지정하는 표기법
(ex : GoodMan)
스네이크 표기법 - 식별자 표기 시에 여러 단어가 이어지면 단어 사이에 언더 바를 넣는 표기법 (ex : good_man)
헝가리안 표기법 - 식별자 표기 시, 접두어에 자료형을 붙이는 표기법
(ex : szGoodMan (sz는 String Zero로 약자로 문자열이 없다는 표기입니다.)');
INSERT INTO "questions" VALUES(52,3,12,1,10,'핵심 용어 단답형','12. 테스트의 종류 중, 둥치분할 테스트, 경계값 분석 테스트 등의 종류가 있는 테스트 기법을 쓰시오.','','','','[]','[]','블랙박스 테스트 (명세 기반 테스트)','블랙박스 테스트는 소프트웨어가 수행할 특정 기능을 알기 위해서 각 기능이 완전히 작동되는 것을 입증하는 테스트로 기능 테스트라고 불립니다.
동치 분할 검사 :
입력 자료에 초점을 맞춰 테스트 케이스를 만들고 검사하는 방법 (= 동등 분할 기법)
경계값 분석 :
입력 자료에만 치중한 동치 분할 기법을 보완한 기법으로, 입력 조건의 중간값보다 경계값에서 오류가 발생될 확률이 높다는 점을 이용하여 입력 조건의 경계값을 테스트 케이스로 선정하여 검사하는 기법
원인-효과 그래프 검사 :
입력 데이터 간의 관계와 출력에 영향을 미치는 상황을 체계적으로 분석한 다음 효용성이 높은 테스트 케이스를 선정하여 검사하는 기법
오류 예측 검사 :
과거의 경험이나 확인자의 감각으로 테스트하는 기법으로, 다른 블랙박스 테스트 기법으로는 찾아낼 수 없는 오류를 찾아내는 일력의 보충적 검사 기법 (= 데이터 확인 검사)
비교 검사 :
여러 버전의 프로그램에 동일한 테스트 자료를 제공하여 동일한 결과가 출력되는지 테스트하는 기법');
INSERT INTO "questions" VALUES(53,3,13,2,1,'코드 출력 결과형','13. 다음은 C언어 소스 코드이다. 출력 결과를 쓰시오.','','#include <studio.h>
int r1(){
	return 4;
}
int r10(){
	return (30+r1());
}
int r100(){
	return (200+r10());
}
int main(){
	printf("%d\n", r100());
    return 0;
}','c','[]','[]','234','[C언어 실행 과정 분석]
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [234] 입니다.');
INSERT INTO "questions" VALUES(54,3,14,1,6,'서술·약술형','14. DB스키마에 대해서 서술하시오.','','','','[]','[]','데이터베이스의 구조, 제약조건 등의 정보를 담고 있는 기본적인 구조','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [데이터베이스의 구조, 제약조건 등의 정보를 담고 있는 기본적인 구조] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(55,3,15,2,2,'코드 출력 결과형','15. 다음은 자바 코드이다. 출력 결과를 쓰시오.','','abstract class vehicle{
	private String name;
    abstract public String getName(String val);
    public String getName(){
    	return "vehicle name:" + name;
    }
	public void setName(String val){
    	name = val;
    }
}

class Car extends Vehicle{
	public Car(String val){
    	setName(val);
   }
public String getName(String val){
	return "Car name : " + val;
   }
public String getName(byte val[]){
	return "Car name : " + val;
   }
}

public class good {
	public Static void main(String[] args){
    Vehicle obj = new Car("Spark");
    System.out.print(obj.getName());
    }
}','java','[]','[]','Vehicle name : Spark','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• System.out 출력문에 의해 최종 도출되는 결과값은 [Vehicle name : Spark] 입니다.');
INSERT INTO "questions" VALUES(56,3,16,1,6,'핵심 용어 단답형','16. UI 설계 원칙 중 직관성에 대해서 쓰시오.','','','','[]','[]','누구나 쉽게 이해하고, 쉽게 사용할 수 있어야 하고,쉬운 검색, 쉬운 사용성, 일관성이 부특성을 가지고 있는 UI설계 원칙','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [누구나 쉽게 이해하고, 쉽게 사용할 수 있어야 하고,쉬운 검색, 쉬운 사용성, 일관성이 부특성을 가지고 있는 UI설계 원칙] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(57,3,17,2,2,'코드 출력 결과형','17. 다음은 자바 코드이다. 출력 결과를 쓰시오.','','public class good {
	public static void main(String[] args){
    int i=0;
    int sum=0;
    while (i<10){
    	i++;
        if(i%2 ==1)
        	continue;
        sum += i;
     }
     System.out.println(sum);
   }
}','java','[]','[]','30','2+4+6+8+10=30이 됩니다.');
INSERT INTO "questions" VALUES(58,3,18,1,17,'핵심 용어 단답형','18. EAI 유형에는 메세지 버스(Message bus), 하이브리드(Hybrid), ( 1. ), ( 2. ) 4가지가 있다.','','','','[]','[]','1. 포인트 투 포인트(Point-to-point)
2. 허브 앤 스포크(Hub & Spoke)','EAI (기업 내외부 정보시스템 통합)
EAI의 유형 (데이터 전송 모델)
메세지 버스 : 애플리케이션과 미들웨어간 웹서비스 인터페이스를 통해 전송
하이브리드 : 허브앤스포크와 메세지버스 혼합
포인트 투 포인트 : 1:1방식으로 애플리케이션 통합 수행
허브 앤 스포크 : 단일 접점인 허브시스템을 통해 데이터를 전송하는 중앙 집중 방식');
INSERT INTO "questions" VALUES(59,3,19,1,6,'핵심 용어 단답형','19. C++에서 생성자란 무엇인지 쓰시오.','','','','[]','[]','해당 클래스의 객체가 생성될 때 자동으로 호출되는 특수한 종류의 메서드','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [해당 클래스의 객체가 생성될 때 자동으로 호출되는 특수한 종류의 메서드] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(60,3,20,2,3,'SQL 작성·빈칸형','20. 학생 테이블에 주소 속성을 추가하는 SQL문을 작성하시오.','','( 1. ) TABLE 학생 ( 2. ) 주소 VARCHAR(20);','sql','[]','[]','1.ALTER
2.ADD','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1.ALTER
2.ADD] 입니다.');
INSERT INTO "questions" VALUES(61,4,1,1,5,'핵심 용어 단답형','1. 현재 IPv4의 확장형으로 IPv4가 가지고 있는 주소 고갈, 보안성, 이동성 지원 등의 문제점을 해결하기 위해서 개발된 128비트 주소체계를 갖는 차세대 인터넷 프로토콜은 무엇인가?','','','','[]','[]','IPv6','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [IPv6] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(62,4,2,1,9,'괄호 빈칸 채우기형','2. 목적에 따른 디자인 패턴의 유형에는 생성, 구조, ( ) 이/가 있다. 괄호 ( ) 안에 알맞는 유형을 쓰시오.','','','','[]','[]','행위
디자인 패턴
목적 : 생성 / 구조 / 행위
범위 : 클래스 / 객체','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [행위
디자인 패턴
목적 : 생성 / 구조 / 행위
범위 : 클래스 / 객체] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(63,4,3,1,11,'핵심 용어 단답형','3. 다음은 판매와 관련된 다이어그램이다. 해당 다이어그램의 명칭을 쓰시오.','','','','[]','[{"local": "/images/questions/q_063_1.png", "remote": "https://blog.kakaocdn.net/dna/bkiTui/btq8rfIotzc/AAAAAAAAAAAAAAAAAAAAACjs6hKeZd02u3Yf1I6WbR7S1-0hw9c10MVYKQZhGY-d/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=tdKLMW4HrBU%2BtJHyk%2BwEYhnF0t4%3D"}]','패키지 다이어그램','UML(Unified Modeling Laguage)다이어그램 :
UML 다이어그램은 통합 모델링 언어를 사용하여 시스템 상호작용, 업무흐름, 시스템 구조, 컴포넌스 관계 등을 그린 도면입니다. 사용이유는 프로그래밍을 단순화 시켜 표현하여 의사소통하기 좋고, 대규모 프로젝트 구조의 로드맵을 만들거나 개발을 위한 시스템 구축에 기본을 마련합니다.
UML 다이어그램의 종류 :
클래스 다이어그램 / 객체 다이어그램 / 유스케이스 다이어그램 / 상태 다이어그램 / 시퀸스 다이어그램 /
활동 다이어그램 / 통신 다이어그램 / 컴포넌트 다이어그램 / 배포 다이어그램 / 복합체 구조 다이어그램 /
교류 개요 다이어그램 / 타이밍 다이어그램 / 패키지 다이어그램
패키지 다이어그램은 UML 다이어그램의 안에 속하는 다이어그램입니다.
폴더 모양의 패키지와 점섬으로 표시된 의존관계, import라는 스테레오 타입 표기를 통해 패키지 다이어그램인지 파악합니다.');
INSERT INTO "questions" VALUES(64,4,4,1,15,'핵심 용어 단답형','4. 데이터베이스의 회복(Recovery) 기법 중 Rollback 시 Redo, Undo가 모두 실행되는 트랜잭션 처리법으로 트랜잭션 수행 중 갱신 결과를 바로 DB에 반영하는 기법은 무엇인가?','','','','[]','[]','즉각 갱신 회복 기법','회복 기법 종류 :
로그 기반 회복 기법 - 지연 갱신 회복 기법 / 즉각 갱신 회복 기법
체크 포인트 회복 기법
그림자 페이징 회복 기법
미디어 회복 기법
지연 갱신 회복 기법 :
트랜잭션의 부분 완료 상태에선 변경 내용을 로그 파일에만 저장
체크 포인트 회복 기법 :
장애 발생 시, 검사점(checkpoint) 이전에 처리된 트랜잭션은 회복에서 제외하고 검사점 이후에 처리된 트랜잭션은 회복 작업 수행
그림자 페이징 회복 기법 :
트랜잭션이 실행되는 메모리상의 current page table과 하드디스크의 shadow page table이용
미디어 회복 기법 :
디스크와 같은 비휘발성 저장 장치가 손상되는 장애 발생을 대비한 회복 기법');
INSERT INTO "questions" VALUES(65,4,5,2,2,'코드 출력 결과형','5. 다음은 n이 10일 때, 10을 2진수로 변환하는 자바 소스 코드이다. 1,2에 알맞는 값을 적으시오.','[출력결과] : 00001010','class good {
	public static void main (String[] args) {
    	int[]a = new int[8];
        int i=0; int n=10;
        while (  1.  ) {
        	a[i++] = (  2.  );
            n /= 2;
        }
        for(i=7; i>=0; i--){
         System.out.print(a[i]);
        }
     }
  }','java','[]','[]','1. n > 0 or n >=1 or i < 8 or i <= 7
2. n%2 or n&1','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [1. n > 0 or n >=1 or i < 8 or i <= 7
2. n%2 or n&1] 입니다.');
INSERT INTO "questions" VALUES(66,4,6,2,2,'코드 출력 결과형','6. 다음은 자바 소스 코드이다. 출력 결과를 보고 , 1,2에 알맞는 값을 적으시오.','[출력 결과]
1 4 7 10 13
2 5 8 11 14
3 6 9 12 15','public class good {
	public static void main(String[] args) {
    	int[][]a = new int[(1.)][(2.)];
        for(int i = 0; i <3; i++){
        for(int j=0; j < 5; j++){
        a[i][j] = j*3+(i+1);
        	System.out.print(a[i][j]+"");
         }
         System.out.println();
       }
     }
   }','java','[]','[]','1. 3
2. 5','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [1. 3
2. 5] 입니다.');
INSERT INTO "questions" VALUES(67,4,7,1,8,'서술·약술형','7. 스니핑(Sniffing)에 대하여 서술하시오.','','','','[]','[]','암호화되지 않은 패킷들을 수집하여 순서대로 재조합 후 ID, PW와 같은 중요한 정보를 유출하기 위한 수동적인 형태의 공격','네트워크 공격 기법
스니핑 / 네트워크 스캐너, 스니퍼 / 패스워드 크래킹 / IP 스푸핑 / ARP 스푸핑 / ICMP Redirect 공격 / 트로이 목마
IP스푸핑 : 발신지 IP나 목적지 IP를 위조하여 공격하는 기법
ARP스푸핑 : MAC 주소를 위조하여 랜상에서의 통신 흐름을 왜곡시키는 공격 기법
트로이 목마 : 사용자가 원하는 무언가로 변장해 시스템 방어망을 뚫고 들어가는 공격 기법');
INSERT INTO "questions" VALUES(68,4,8,1,5,'핵심 용어 단답형','8. IP 패킷에서 외부의 공인 IP주소와 포트 주소에 해당하는 내부 IP주소를 재기록하여 라우터를 통해 네트워크 트래픽을 주고받는 기술은 무엇인가?','','','','[]','[]','NAT(Network Address Transformation)','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [NAT(Network Address Transformation)] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(69,4,9,2,4,'코드 출력 결과형','9. 다음은 파이썬 소스 코드이다. 출력 결과를 쓰시오.','','lol = [[1,2,3],[4,5],[6,7,8,9]]
print(lol[0])
print(lol[2][1])
	for sub in lol:
   	for item in sub:
        	print(item, end = '''')
      	print()','python','[]','[]','[1,2,3]
7
123
45
6789','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [[1,2,3]
7
123
45
6789] 입니다.');
INSERT INTO "questions" VALUES(70,4,10,1,6,'핵심 용어 단답형','10. 분산 컴퓨팅 기술 기반의 데이터 위변조 방지 기술로 P2P방식을 기반으로 하여 소규모 데이터들이 연결되어 형성된 ''블록''이라는 분산 데이터 저장 환경에 관리 대상 데이터를 저장함으로써 누구도 임의로 수정할 수 없고 누구나 변경의 결과를 열람할 수 있게끔 만드는 기술은 무엇인가?','','','','[]','[]','블록체인','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [블록체인] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(71,4,11,1,6,'핵심 용어 단답형','11. 오픈 소스 기반으로 한 분산 컴퓨팅 플랫폼으로, 일반 PC급 컴퓨터들로 가상화된 대형 스토리지를 형성하고 그 안에 보관된 거대한 데이터 세트를 병렬로 처리할 수 있도록 개발된 자바 소프트웨어 프레임워크로 구글, 야후 등에 적용한 기술은 무엇인가?','','','','[]','[]','하둡','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [하둡] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(72,4,12,1,13,'핵심 용어 단답형','12. 이상 현상의 종류 3가지를 쓰시오.','','','','[]','[]','삽입 이상, 삭제 이상, 갱신 이상
데이터베이스의 이상현상 3가지','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [삽입 이상, 삭제 이상, 갱신 이상
데이터베이스의 이상현상 3가지] 입니다.
• 학습 가이드: [데이터베이스(설계/정규화)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(73,4,13,1,12,'핵심 용어 단답형','13. 다음은 프로세스 상태 전이도이다. 1,2,3에 알맞은 상태를 쓰시오.','','','','[]','[{"local": "/images/questions/q_073_1.png", "remote": "https://blog.kakaocdn.net/dna/oavAC/btq8reW1qxc/AAAAAAAAAAAAAAAAAAAAAGy_Nf5XZ7C2VI-aYHy_-kGNjPWKBdqv-vWuBPeWjRLv/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=aHi6WssKvZEDUX69Ke4Rj6UYpgM%3D"}]','1. 준비
2. 실행
3. 대기','[운영체제(스케줄링/메모리) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 준비
2. 실행
3. 대기] 입니다.
• 학습 가이드: [운영체제(스케줄링/메모리)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(74,4,14,1,10,'수식·계산 도출형','14. 테스트 오라클 중 특정한 몇 개의 입력값에 대해서만 기대하는 결과를 제공해주는 오라클은 무엇인가?','','','','[]','[]','샘플링 오라클','테스트 오라클은 테스트의 결과가 참인지 거짓인지를 판단하기 위해서 사전에 정의된 참값을 입력하여 비교하는 기법
테스트 오라클 유형 :
참 오라클 - 모든 입력값에 대하여 기대하는 결과를 생성하여 오류 검출
샘플링 오라클 - 특정한 몇 개의 입력값에 대해서만 기대하는 결과를 제공
휴리스틱 오라클 - 샘플링 오라클을 개선 / 특정 입력값에 올바른 결과를 제공하고 나머지 값은 휴리스틱(추정)으로 처리
일관성 검사 오라클 - 애플리케이션 변경이 있을 때, 수행 전과 후의 결괏값이 동일한지 확인');
INSERT INTO "questions" VALUES(75,4,15,1,10,'핵심 용어 단답형','15. 점수에 따른 성적 부여가 잘 되었는지 테스트하고자 한다. 아래에 알맞는 테스트 기법은 무엇인가?','[테스트 값] : -10점 / 30점 / 65점 / 75점 / 85점 / 95점 / 110점','','','[{"type": "grid", "rows": [["점수", "성적"], ["0 ~ 59", "가"], ["60 ~ 69", "양"], ["70 ~ 79", "미"], ["80 ~ 89", "우"], ["90 ~ 100", "수"]]}]','[]','동등분할 테스트','동등분할 테스트는 입력 데이터의 영역을 유사한 도메인별로 유효 값 / 무효 값을 그룹핑하여 대푯값 테스트 케이스를 도출하여 테스트하는 기법 (블랙박스 테스트)
데이터 영역에 가까운 값이 아닌 영역 내에 있는 일반 값들로 테스트한다.');
INSERT INTO "questions" VALUES(76,4,16,2,3,'SQL 작성·빈칸형','16. 다음 조건을 만족하면서 학과별로 튜플 수가 얼마인지 구하는 SQL문을 작성하시오.','- 대소문자를 구분하지 않는다.
- WHERE 구문을 사용하지 않는다.
- GROUP BY 를 사용한다.
- 세미콜론(;)은 생략 가능하다.
- 별칭(AS)을 사용해야 한다. (별칭 사용 시 별칭은 작은 따옴표를 써야 함)
- 집계 함수를 사용해야 한다.
[학생]
[결과]','','sql','[{"type": "grid", "rows": [["학과", "학생"], ["전기", "이순신"], ["컴퓨터", "안중근"], ["컴퓨터", "윤봉길"], ["전자", "이봉창"], ["전자", "강우규"]]}, {"type": "grid", "rows": [["학과", "학과별튜플수"], ["전기", "1"], ["컴퓨터", "2"], ["전자", "2"]]}]','[]','SELECT 학과, COUNT(학과) AS 학과별튜플수 FROM 학생 GROUP BY 학과;','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [SELECT 학과, COUNT(학과) AS 학과별튜플수 FROM 학생 GROUP BY 학과;] 입니다.');
INSERT INTO "questions" VALUES(77,4,17,1,18,'핵심 용어 단답형','17. 데니스 리치와 켄톰슨 등이 함께 벨 연구소를 통해 만든 운영체제이며, 90% 이상 C언어로 구현되어 있고, 시스템 프로그램이 모듈화되어 있어서 다른 하드웨어 기종으로 쉽게 이식 가능하며 계층적 트리 구조를 가짐으로써 통합적인 파일 관리가 용이한 운영체제는 무엇인가?','','','','[]','[]','유닉스','유닉스 계열 운영체제의 특징 :
대화식 운영체제 기능 제공 / 다중 작업 기능 제공 / 다중 사용자 기능 제공 / 이식성 제공 / 계층적 트리 구조 파일 시스템 제공');
INSERT INTO "questions" VALUES(78,4,18,2,1,'코드 출력 결과형','18. 다음은 C언어 소스 코드이다. 출력값을 쓰시오.','','#include <stdio.h>

void main(){
	char *p = "KOREA"
    printf("%s\n" , p);
    printf("%s\n" , p+3);
    printf("%c\n" , *p);
    printf("%c\n" , *(p+3));
    printf("%c\n" , *p+2);','c','[]','[]','KOREA
EA
K
E
M','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [KOREA
EA
K
E
M] 입니다.');
INSERT INTO "questions" VALUES(79,4,19,2,2,'코드 출력 결과형','19. 다음은 자바 소스 코드이다. 출력 결과를 쓰시오.','','class parent{
	public int compute(int num){
    	if(num <=1) return num;
        return compute(num-1) + compute(num-2);
    }
 }
 
 class Child extends parent {
 	public int compute(int num){
    	if(num<=1) return num;
        	return compute(num-1) + compute(num-3);
        }
   }
   
  class good{
  	public static void main (String[] args){
    parent obj = new Child();
    System.out.print(obj.compute(4));
   }
 }','java','[]','[]','1','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [1] 입니다.');
INSERT INTO "questions" VALUES(80,4,20,1,8,'서술·약술형','20. 정보보안에서 가용성(Availablility) 에 대하여 서술하시오.','','','','[]','[]','권한을 가진 사용자가 애플리케이션이 원하는 서비스를 지속 사용할 수 있도록 보장하는 특성
SW개발 보안의 3개 요소 : 기밀성 / 무결성 / 가용성','기밀성 : 인가되지 않은 개인 혹은 시스템 접근에 따라 정보 공개 및 노출을 차단하는 특성
무결성 : 정당한 방법을 따르지 않고선 데이터가 변경될 수 없으며, 데이터의 정확성 및 완정성과 고의/악의로 변경되거나 훼손 또는 파괴되지 않음을 보장하는 특성');
INSERT INTO "questions" VALUES(81,5,1,1,5,'핵심 용어 단답형','1. 물리 네트워크(MAC) 주소에 해당하는 IP 주소를 알려주는 프로토콜로 역순 주소 결정 프로토콜을 무엇이라고 하는지 쓰시오.','','','','[]','[]','RARP (Reverse Address Resolution Protocol)','OSI 7계층은 국제표준화기구(International Standard Organization, ISO)에서 발표한 네트워크 표준 모델로써 네트워크 통신의 각 과정을 계층별로 개념화한 모델이기에 각 계층의 구간별로 데이터의 움직임을 알수 있고, 장치간의 데이터 통신을 설명하는데 유용하게 활용됩니다.
[1계층] 물리 계층 : 전선, 전파, 광섬유, 동축케이블, 도피관, PSTN, DSU, CSU, Modem
[2계층] 데이터 링크 계층 : Ethernet, ToKen Ring, PPP, HDLC, ISDN, ATM
[3계층] 네트워크 계층 : IP, ARP, RARP, ICMP, IGMP, 라우팅 프로토콜
[4계층] 전송 계층 : TCP, UDP, RTP, SCTP, SPX
[5계층] 세션 계층 : TLS, SSH, ISO 8327 / CCITTX225, RPC, NetBIOS
[6계층] 표현 계층 : JPEG, MPEG, XDR, ASN1, SMB, AFP
[7계층] 응용 계층 : HTTP, SMTP, SNMP, FTP, Telnet, SSH&SCP, NFS, RTSP');
INSERT INTO "questions" VALUES(82,5,2,1,11,'괄호 빈칸 채우기형','2. 다음은 DB 설계 절차에 관한 설명이다. 다음 빈칸에 들어갈 알맞은 용어를 쓰시오.','- ( 1. )은/는 특정 DBMS의 특성 및 성능을 고려하여 데이터베이스 저장 구조로 변환하는 과정으로 결과로 나오는 명세서는 테이블 정의서 등이 있다.
- ( 2. )은/는 현실 세계에 대한 인식을 추상적, 개념적으로 표현하여 개념적 구조를 도출하는 과정으로 주요 산출물에는 E-R 다이어그램이 있다.
- ( 3. )은/는 목표 DBMS에 맞는 스키마 설계, 트랜잭션 인터페이스를 설계하는 정규화 과정을 수행한다.
[보기] : 구현 / 개념적 설계 / 논리적 설계 / 요구사항 분석 / 물리적 설계','','','[]','[]','1. 물리적 설계
2. 개념적 설계
3. 논리적 설계','DB설계 절차 :
요구사항 분석 > 개념적 설계 > 논리적 설계 > 물리적 설계 > 구현');
INSERT INTO "questions" VALUES(83,5,3,1,6,'괄호 빈칸 채우기형','3. 다음은 요구사항의 분류에 대한 설명이다. 괄호 ( ) 안에 들어갈 요구사항의 유형에 대해서 쓰시오.','- ( 1. ) 요구사항은 시스템이 제공하는 기능, 서비스에 대한 요구사항이다.
- ( 2. ) 요구사항은 시스템이 수행하는 기능 이외의 사항, 시스템 구축에 대한 제약사항에 관한 요구사항이다.','','','[]','[]','1. 기능적
2. 비기능적','요구사항이란 시스템 개발 분야에서 어떤 과제를 수행하기 위해, 필요한 조건이나 능력을 말합니다.
- 기능적 요구사항 : 사용자 요구사항, 시스템 요구사항
- 비 기능적 요구사항 : 제품 요구사항, 조직 요구사항, 외부 요구사항');
INSERT INTO "questions" VALUES(84,5,4,1,5,'핵심 용어 단답형','4. 웹 서비스명, 제공 위치, 메세지 포맷, 프로토콜 정보 등 웹 서비스에 대한 상세 정보가 기술된 XML 형식으로 구성된 언어를 무엇이라고 하는지 쓰시오.','','','','[]','[]','WSDL','WSDL(Web Services Description Language의 약자)은 웹 서비스 기술언어 또는 기술된 정의 파일의 총칭으로 XML로 기술됩니다. 웹 서비스의 구체적 내용이 기술되어 있으며 서비스 제공 장소, 서비스 메시지 포맷, 프로토콜 등이 기술됩니다.');
INSERT INTO "questions" VALUES(85,5,5,2,4,'코드 출력 결과형','5. 다음은 파이썬 코드이다. 출력 결과를 쓰시오.','','class good :
	li = ["seoul", "kyeonggi","inchon","daejeon","daegu","pusan"]

g = good()
str01 = ''''
for i in g.li:
	str01 = str01 + i[0]
    
print(str01)','python','[]','[]','skiddp
각 단어들의 0번째(첫번째 글자) row 출력','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [skiddp
각 단어들의 0번째(첫번째 글자) row 출력] 입니다.');
INSERT INTO "questions" VALUES(86,5,6,2,3,'SQL 결과 도출형','6. 다음 SQL 실행 결과를 숫자만 쓰시오.','','SELECT COUNT(*) FROM 급여
WHERE EMPNO > 100 AND SAL >= 3000 OR EMPNO = 200;','sql','[{"type": "grid", "rows": [["EMPNO", "SAL"], ["100", "1000"], ["200", "3000"], ["300", "1500"]]}]','[]','답 : 1','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [답 : 1] 입니다.');
INSERT INTO "questions" VALUES(87,5,7,2,2,'코드 출력 결과형','7. 다음 Java 프로그램 결과를 쓰시오.','','public class good{
	public static void main(String[] args){
    	int[][]arr = new int[][]{{45,50,75},{89}};
        System.out.println(arr[0].length);
        System.out.println(arr[1].length);
        System.out.println(arr[0][0]);
        System.out.println(arr[0][1]);
        System.out.println(arr[1][0]);','java','[]','[]','3
1
45
50
89','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [3
1
45
50
89] 입니다.');
INSERT INTO "questions" VALUES(88,5,8,1,13,'핵심 용어 단답형','8. 정규화된 엔티티, 속성, 관계에 대해 성능 향상과 개발 운영의 단순화를 위해 중복, 통합, 분리 등을 수행하는 데이터 모델링의 기법을 무엇이라고 하는지 쓰시오.','','','','[]','[]','비정규화 or 반정규화 or 역정규화','반정규화 방법 :
테이블 통합, 테이블 분할, 중복 테이블 추가, 중복 속성 추가');
INSERT INTO "questions" VALUES(89,5,9,1,10,'핵심 용어 단답형','9. 다음은 블랙박스 기법에 대한 예제이다. 블랙박스 기법 두 가지를 쓰시오.','예)
1. 0 <= x <= 10이면 -1 0 10 11 검사
2. 입력 데이터의 영역을 유사한 도메인별로 유횻값 / 무횻값을 그룹핑하여 나누어서 검사','','','[]','[]','1. 경곗값 분석
2. 동등분할 테스트','블랙박스 테스트 종류
동치 분할 검사(동등분할기법) :
입력 자료에 초점을 맞춰 테스트 케이스를 만들고 검사하는 방법
경계값 분석 :
동치 분할 기법을 보완한 기법으로 입력 조건의 중간값보다 경계값에서 오류가 발생될 확률이 높다는 점을 이용하여 입력 조건의 경계값을 테스트 케이스로 선정하여 검사하는 기법
원인-효과 그래프 검사 :
입력 데이터 간의 관계와 출력에 영향을 미치는 상황을 체계적으로 분석한 다음, 효용성이 높은 테스트 케이스를 선정하여 검사하는 기법
오류 예측 검사 :
과거의 경험이나 확인자의 감각으로 테스트하는 기법
비교 검사 :
여러 버전의 프로그램에 동일한 테스트 자료를 제공하여 동일한 결과가 출력되는지 확인하는 기법');
INSERT INTO "questions" VALUES(90,5,10,1,10,'보기·기호 선택형','10. 다음은 테스트 종류에 대한 설명이다. 빈칸에 들어갈 알맞은 용어를 보기에서 찾아 기호로 쓰시오.','- ( 1. ) 은/는 개별 모듈, 서브루틴이 정상적으로 실행되는지 확인
- ( 2. ) 은/는 인터페이스 간 시스템이 정상적으로 실행되는지 확인
[보기] : 시스템 테스트 / 인수 테스트 / 알파 테스트 / 단위 테스트 / 통합 테스트 / 회귀 테스트','','','[]','[]','1. 단위 테스트
2. 통합 테스트','시스템 테스트 :
구현된 시스템이 정해진 요건에 적합한지 여부를 평가하기 위해 실제 운용과 같은 환경에서 시스템 전체에 대해서 행하는 테스트
인수 테스트 :
계약상의 요구 사항이 만족되었는지 확인하기 위해, 설치 후 구입자의 현장에서 납품자도 참가하여 구입자에 의해 실시되는 시스템 또는 기능 단위 테스트
알파 테스트 :
특정 사용자들에 의해 개발자 관점에서 수행 (가장 자주 사용)
회귀 테스트 :
어플리케이션에 대하여 변경, 결함 수정 또는 기능개선 등과 같은 원인으로 프로그램 코드에 대하여 물리적인 변경이 발생했을 경우, 새로운 결함에 대비하여 이미 실시했던 테스트케이스를 재시험하는 테스트');
INSERT INTO "questions" VALUES(91,5,11,1,5,'괄호 빈칸 채우기형','11. 다음은 빈칸에 들어갈 알맞은 용어를 쓰시오.','- IPv6는 ( 1. ) 비트 길이를 가진다.
- IPv4는 길이 32bit이며, ( 2. ) 비트씩 네 부분으로 나눈다.','','','[]','[]','1. 128
2. 8','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 128
2. 8] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(92,5,12,1,6,'핵심 용어 단답형','12. 공유메모리, 소켓, 세마포어, 메세지 큐 등 프로세스 간 통신하는 기술을 무엇이라고 하는지 쓰시오.','','','','[]','[]','IPC (Inter Process Communication)','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [IPC (Inter Process Communication)] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(93,5,13,1,6,'핵심 용어 단답형','13. 시스템 통합에 사용되는 솔루션으로 구축 유형에는 Point to Point, Hub & Spoke, Message Bus가 있다. 기업에서 운영되는 서로 다른 플랫폼 및 애플리케이션 간의 정보를 전달, 연계 , 통합이 가능하도록 해주는 솔루션을 무엇이라고 하는지 쓰시오.','','','','[]','[]','EAI (Enterprise Application integration)','EAI 구축 유형 :
포인트 투 포인트 - 가장 기초적인 애플리케이션 통합 방법 ( 1:1 단순 통합 방법) / 개발자간 대화를 통해 통합 가능
허브 앤 스포크 - 단일한 접점의 허브 시스템을 통하여 데이터를 전송하는 중앙 집중적 방식
메세지 버스 - 애플리케이션 사이 미들웨어를 두어 연계하는 통합 방식 / 뛰어난 확장성과 대용량 데이터 처리 가능
하이브리드 - 그룹 내는 허브 앤 스포크 방식 / 그룹 간에는 메세지 버스 방식 사용하는 통합 방식');
INSERT INTO "questions" VALUES(94,5,14,1,7,'핵심 용어 단답형','14. 주어진 테이블의 Cardinality / Degree를 구하시오.','','','','[{"type": "grid", "rows": [["학번", "이름", "학년", "학과"], ["20202020", "김제원", "3", "무역과"], ["20202021", "김한국", "1", "통신과"], ["20202022", "허달력", "4", "영어과"], ["20202023", "이소파", "2", "영어과"], ["20202024", "장가위", "3", "중국어과"]]}]','[]','Cardinality : 5
Degree : 4
Cardinality : 데이터의 행의 수
Degree : 속성의 수','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Cardinality : 5
Degree : 4
Cardinality : 데이터의 행의 수
Degree : 속성의 수] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(95,5,15,2,1,'코드 출력 결과형','15. 다음은 C언어 프로그램이다. 실행 결과를 쓰시오.','','#include <stdio.h>

struct good {
	char name[10];
    int age;
 };
 
 void main(){
 	struct good s[] = {"Kim",28,"Lee",38,"Seo",50,"Park",35};
    
    struct good *p;
    p = s;
    p++;
    printf("%s\n", p-> name);
    printf("%d\n", p-> age);','c','[]','[]','Lee
38','p++로 인해 s[1]가 되면서 두번째 배열인 Lee와 38이 출력이 된다.');
INSERT INTO "questions" VALUES(96,5,16,1,7,'핵심 용어 단답형','16. 데이터 모델 구성요소 3가지를 쓰시오.','- 데이터베이스에 저장된 실제 데이터를 처리하는 작업에 대한 명세로서 데이터베이스를 조작하는 기본 도구이다.
- 개체 데이터 모델에서는 ( 1. ) 을/를 이용하여 실제 데이터를 처리하는 작업에 대한 명세를 나타내는데 논리 데이터 모델에서는 ( 2. ) 을/를 어떻게 나타낼 것인지 표현한다.
- ( 3. ) 은/는 데이터 무결성 유지를 위한 db의 보편적 방법으로 릴레이션의 특정 칼럼에 설정하는 제약을 의미하며, 개체무결성과 참조 무결성 등이 있다.','','','[]','[]','1.연산
2. 구조
3. 제약조건','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1.연산
2. 구조
3. 제약조건] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(97,5,17,2,2,'코드 출력 결과형','17. 다음은 Java 프로그램이다. 실행 결과를 쓰시오.','','public class good {
	public static void main(String[] args){
    int i, j;
    for(j=0, i=0; i<=5; i++){
    j+=i;
    System.out.print(i);
    if(i==5){
    System.out.print("=");
    System.out.print(j);
   }else{
   	System.out.print("+");
	}
   }
  }
 }','java','[]','[]','0 + 1 + 2 + 3 + 4 + 5 = 15','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [0 + 1 + 2 + 3 + 4 + 5 = 15] 입니다.');
INSERT INTO "questions" VALUES(98,5,18,1,6,'핵심 용어 단답형','18. 시스템 객체의 접근을 개인 또는 그룹의 식별자에 기반을 둔 방법, 어떤 종류의 접근 권한을 가진 사용자가 다른 사용자에 자신의 판단에 따라 권한을 허용하는 접근제어 방식은 ?','','','','[]','[]','임의적 접근 통제 or DAC (Discretionary Access Control)','접근 통제는 사람이나 프로세스가 시스템이나 파일에 접근 여부를 허가하거나 거부하는 기능을 말합니다.
서버 접근통제 유형 - 임의적 접근통제 / 강제적 접근통제 / 역할 기반 접근통제
임의적 접근 통제(DAC - Discretionary Access Control) : 시스템 객체에 대한 접근을 사용자나 그룹의 신분을 기준으로 제한하는 방법
강제적 접근 통제(MAC - Mandatory Access Control) : 미리 정해진 정책과 보안 등급에 의거하여 주체에게 허용된 접근 권한과 객체에게 부여된 허용 등급을 비교하여 접근을 통제하는 모델
역할기반 접근 통제(RBAC - Role Based Access Control) : DAC와 MAC의 단점을 보완한 방식으로 멀티 프로그래밍 환경에서의 보완 처리를 위해 제안되었으며 사용자에게 할당된 역할에 기반하여 접근을 통제하며 중앙에서 집중적으로 관리');
INSERT INTO "questions" VALUES(99,5,19,1,14,'보기·기호 선택형','19. 다음은 결합도에 대한 설명이다. 빈칸에 들어갈 알맞은 용어를 보기에서 찾아 기호로 쓰시오.','- ( 1. ) 은/는 다른 모듈 내부에 있는 변수나 기능을 다른 모듈에서 사용하는 경우의 결합도
- ( 2. ) 은/는 모듈 간의 인터페이스로 배열이나 객체, 구조 등이 전달되는 경우의 결합도
- ( 3. ) 은/는 파라미터가 아닌 모듈 밖에 선언된 전역 변수를 참조하고 전역 변수를 갱신하는 식으로 상호작용하는 경우의 결합도
[보기] : 자료 결합도 / 스탬프 결합도 / 제어 결합도 / 공통 결합도 / 내용 결합도 / 외부 결합도','','','[]','[]','1. 내용 결합도
2. 스탬프 결합도
3. 공통 결합도','결합도와 품질(낮은 품질에서 좋은 품질 순) :
내용결합도 > 공통 결합도 > 외부 결합도 > 제어 결합도 > 스탬프 결합도 > 자료 결합도
외부 결합도 : 어떤 모듈에서 반환한 값을 다른 모듈에서 참조해서 사용하는 경우
제어 결합도 : 단순히 처리를 해야할 대상인 값만 전달되는게 아니라 어떻게 처리를 해야 한다는 제어요소가 전달
자료 결합도 : 모듈간의 인터페이스 전달되는 파라미터를 통해서만 모듈간의 상호 작용이 일어나는 경우');
INSERT INTO "questions" VALUES(100,5,20,1,5,'괄호 빈칸 채우기형','20. 괄호 안에 공통으로 들어갈 공격 기법을 적으시오.','- ( ) 은/는 ''세션을 가로채다'' 라는 의미로 정상적 연결을 RST 패킷을 통해 종료시킨 후 재연결 시 희생자가 아닌 공격자에게 연결한다.
- ( ) 은/는 세션 관리 취약점을 이용한 공격 기법이다.','','','[]','[]','세션 하이재킹','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [세션 하이재킹] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(101,6,1,1,5,'핵심 용어 단답형','1. 네트워크 장치를 필요로하지 않고 네트워크 토폴로지가 동적으로 변화되는 특징이 있으며 응용 분야로는 긴급 구조, 긴급 회의, 전쟁터에서의 군사 네트워크에 활용되는 네트워크는?','','','','[]','[]','애드혹 네트워크(Ad-hoc Network)','무선 네트워크 구성 방식 :
애드혹 네트워크 - 센서망, 재난망에 사용되며 구성이 빠르고 모든 단말이 동등한 자격으로 망을 구성
Infrastructure 네트워크 - 이동통신망,Wi-Fi에 사용되며 중앙집중형 방식
메쉬 네트워크 - 무선백본망에 사용되며 신뢰성이 우수하고, 계층적인 구조를 가지고 있음');
INSERT INTO "questions" VALUES(102,6,2,1,17,'핵심 용어 단답형','2. 다음 (1), (2)에 알맞는 답안을 쓰시오.','(1) 사람의 감정이나 경험을 나타내는 개념
(2) 사용자 인터페이스. 예로는 CLI이 있다.','','','[]','[]','(1) UX(User Experience) / (2) UI(User Interface)','[인터페이스/연계/웹기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) UX(User Experience) / (2) UI(User Interface)] 입니다.
• 학습 가이드: [인터페이스/연계/웹기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(103,6,3,1,15,'서술·약술형','3. 트랜잭션의 특징 중, 원자성에 대해 약술하십시오.','','','','[]','[]','모두 반영되거나 아니면 전혀 반영되지 않아야 한다.
트랜젝션 특징 - 원자성, 일관성 , 독립성, 지속성
일관성 : 트랜잭션의 작업 처리 결과가 항상 일관성이 있어야 한다는 것','독립성 : 둘 이상의 트랜잭션이 동시에 실행되고 있을 경우, 어떤 하나의 트랜잭션이라도 다른 트랜잭션의 연산에 끼어 들 수 없다는 점
지속성 : 트랜잭션이 성공적으로 완료되었을 경우에 결과는 영구적으로 반영되어야 한다는 점');
INSERT INTO "questions" VALUES(104,6,4,1,13,'괄호 빈칸 채우기형','4. 다음은 제 ( ) 정규형으로써, 부분 함수적 종속성을 제거하여, 완전 함수적 종속을 만족하는 정규형은?','','','','[]','[{"local": "/images/questions/q_104_1.png", "remote": "https://blog.kakaocdn.net/dna/dHdhZL/btrdOv773IC/AAAAAAAAAAAAAAAAAAAAACtpXobKHolQB7BXFzoKfK-5AFNkDicDuFPK6JhdMg3X/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=SKRCwpgDW%2FB880gG2fp%2BMrBT8Q8%3D"}]','제 2 정규형','- 기본키(주문번호 컬럼)이 제품번호에 의해 결정될 수 있기때문에 분해를 해야합니다.
- 부분 함수적 종속성 : 기본키의 부분집합이 결정자가 되버린 현상
제 1정규형 : 도메인이 원자값
제 2정규형 : 부분 함수적 종속 제거
제 3정규형 : 이행적 함수 종속 제거
BCNF : 결정자이면서 후보키가 아닌 것 제거
제 4정규형 : 다치 종속 제거
제 5정규형 : 조인 종속 제거');
INSERT INTO "questions" VALUES(105,6,5,2,3,'SQL 작성·빈칸형','5. 다음은 테이블을 수정할때의 상황입니다. SQL 보기에서 괄호안에 알맞는 문장을 작성하시오.','( 1 ) 테이블명 ( 2 ) 컬럼 = 값 WHERE 점수 >= 90;','','sql','[]','[]','1. UPDATE
2. SET','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1. UPDATE
2. SET] 입니다.');
INSERT INTO "questions" VALUES(106,6,6,2,3,'SQL 작성·빈칸형','6. 다음 SQL 보기에서 JOIN할 경우 괄호안에 알맞는 문장을 작성하시오.','','SELECT .... FROM 학생정보 a JOIN 학과정보 b ( 1 ) a.학과 = b.( 2 )','sql','[]','[]','1. ON
2. 학과','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1. ON
2. 학과] 입니다.');
INSERT INTO "questions" VALUES(107,6,7,2,4,'코드 출력 결과형','7. 파이썬 비트 연산자 코드 결과','','a = 100
result = 0
for i in range(1,3);
   result = a >> i
   result = result + 1
pirnt(result)','python','[]','[]','26','[Python 코드 실행 과정 분석]
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [26] 입니다.');
INSERT INTO "questions" VALUES(108,6,8,1,8,'핵심 용어 단답형','8. 미국 국립 표준 기술연구소 (NIST), DES를 대체하며, 128 비트 블록 크기와 128,192,256비트 키 크기의 대칭 키 암호화 방식은?','','','','[]','[]','AES (Advanced Encryption Standard)','대칭키 알고리즘 :
동일한 키를 사용하여 암호화와 복호화를 하는 것을 의미하며 가장많이 사용하는 알고리즘이 AES 입니다.');
INSERT INTO "questions" VALUES(109,6,9,1,10,'핵심 용어 단답형','9. 화이트박스 테스트 검중 중에, 각 번호에 해당하는 단어 선택해주시오. (실제 시험문제에서는 보기가 주어집니다.)','1. 최소 한번은 모든 문장 수행
2. 결정(Decision) 검증기준이라고도 하며, 조건별 참 / 거짓
3. 2번과 달리 전체 조건식을 무시하며, 조건 상관없이 개별 조건 참 / 거짓','','','[]','[]','1. 문장
2. 결정
3. 조건','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 문장
2. 결정
3. 조건] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(110,6,10,2,3,'SQL 작성·빈칸형','10. SQL문에서 괄호안에 알맞은 답안을 작성하시오. (실제 시험에는 결과 이미지가 있습니다.)','(''이름''이란 컬럼에 ''이''로 시작하는 문자열을 ''내림차순''하는 쿼리 결과 내용입니다.)','SELECT .... FROM ... WHERE ''이름'' LIKE ( 1 ) ORDER BY ''컬럼명'' ( 2 )','sql','[]','[]','1. 이%
2. DESC','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1. 이%
2. DESC] 입니다.');
INSERT INTO "questions" VALUES(111,6,11,1,14,'핵심 용어 단답형','11. 응집도 문제로써, 각 번호에 해당하는 응집도를 쓰시오. (실제 시험문제에서는 보기가 주어집니다.)','1. 입출력 간 연관성은 없으나, 순서에 따라 수행되는 것
2. 동일한 입력과 출력 사용
3. 하나의 기능에 모두 기어하고 밀접하게 연관되어 있는 것 (그룹화)','','','[]','[]','1. 절차적 응집도
2. 교환적 응집도
3. 기능적 응집도','응집도 순서 (낮은것부터 높은 순서)
우연적 > 논리적 > 시간적 > 절차적 > 교환적 > 순차적 > 기능적
우연적 응집도 : 모듈 내부의 각 구성요소들이 연관이 없을 경우
논리적 응집도 : 유사한 성격을 갖거나 특정 형태로 분류되는 처리 요소들이 한 모듈에서 처리되는 경우
시간적 응집도 : 연관된 기능이라기보단 특정 시간에 처리되어야 하는 활동들을 한 모듈에서 처리할 경우
순차적 응집도 : 모듈 내에서 한 활동으로부터 나온 출력값을 다른 활동이 사용할 경우');
INSERT INTO "questions" VALUES(112,6,12,1,5,'핵심 용어 단답형','12. 패킷교환방식 중에서, 번호에 해당하는 방식을 적으시오.','1. 목적지 호스트와 미리 연결한 후, 통신하는 연결형 교환 방식
2. 헤더에 붙어서 개별적으로 전달하는 비연결형 교환 방식','','','[]','[]','1. 가상 회선 방식
2. 데이터그램 방식','패킷교환방식(저장 방식) : 패킷이라는 단위를 사용하여 데이터를 송신하고 수신합니다. 패킷이란 정보를 일정한 크기로 분할한 뒤 각각의 패킷에 송수신 주소 및 부가 정보를 입력한 것으로 현재 컴퓨터 네트워크에서 주로 사용하는 방식입니다. (EX : 인터넷)
* 반대개념
회선 교환 방식(비 저장 방식) : 물리적 전용선을 활용하여 데이터 전달 경로가 정해진 후 동일 경로로만 전달이 됩니다. 데이터를 동시에 전송할 수 있는 양을 의미하는 대역폭이 고정되고 안정적인 전송률을 확보할 수 있습니다. (EX : 전화망)');
INSERT INTO "questions" VALUES(113,6,13,1,9,'괄호 빈칸 채우기형','13. 괄호 ( ) 안에 알맞는 단어를 쓰시오.','디자인 패턴 중에서 ( )패턴은 반복적으로 사용되는 객체들의 상호작용을 패턴화 한 것으로,
클래스나 객체들이 상호작용하는 방법이다. 알고리즘의 패턴에는 Interpreter, Observer, Command 가 있다.','','','[]','[]','행위(behavioral)','행위패턴은 객체나 클래스 간의 교류 방법에 대해 정의하는 방법을 제시합니다.
행위패턴 클래스 : Interpreter, Template
행위패턴 객체 : Chain of Responsibility, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Visitor');
INSERT INTO "questions" VALUES(114,6,14,1,15,'핵심 용어 단답형','14. 병행제어기법 중, 접근한 데이터에 대한 연산을 모두 마칠때까지 상호배제하는 기법을 무엇이라 하는지 작성하시오.','','','','[]','[]','로킹','병행제어란 다중 프로그램이 이점을 활용하여 동시에 여러 개의 트랜잭션을 병행수행할 때, 동시에 실행되는 트랜잭션들이 데이터베이스의 일관성을 파괴하지 않도록 트랜잭션 간의 상호작용을 제어하는 것입니다.
병행제어기법 - 로킹, 타임 스탬프 순서, 최적 병행 수행, 다중 버전 기법
타임 스탬프 순서(Time Stamp Ordering) : 트랜잭션과 트랜잭션이 읽거나 갱신한 데이터에 대해 트랜잭션이 실행을 시작하기 전에 시간표(time stamp)를 부여하여 부여된 시간에 따라 작업을 수행하는 기법
최적 병행 수행(검증기법, 낙관적 기법) : 병행수행하고자 하는 대부분의 트랜잭션이 읽기 전용 트랜잭션일 경우, 트랜잭션 간의 충동률이 매우 낮아서 병행제어 기법을 사용하지 않고 실행되어도 이 중의 많은 트랜잭션은 시스템의 상태를 일관성 있게 유지한다는 점을 이용한 기법
다중 버전 기법 : 타임 스탬프의 개념을 이용한 기법으로 타임 스탬프는 트랜잭션 및 데이터들이 이용될 때의 시간을 시간표로 관리하지만 다중 버전 기법은 갱신될 때마다의 버전을 부여하여 관리하는 기법');
INSERT INTO "questions" VALUES(115,6,15,1,11,'핵심 용어 단답형','15. 럼바우 데이터 모델링에 관한 설명으로써, 보기에 해당하는 답안을 작성하시오.','(실제 시험문제에서는 보기가 주어집니다.)
1. 입력값이 출력값일 때 ex) 자료 흐름도(DFD)
2. 시간에 따라 변하는 것 ex) 상태 다이어그램(상태도)
3. 객체들 간의 관계를 정의 ex) ER다이어그램(ERD)','','','[]','[]','1. Function Modeling
2. Dynamic Modeling
3. Object Modeling','럼바우 객체지향 분석 기법은 소프트웨어 구성 요소를 그래픽 표기법을 이용하여 모델링하는 분석 기법입니다.
분석활동 : 객체 모델링(Object Modeling), 동적 모델링(Dynamic Modeling), 기능 모델링(Functional Modeling)
럼바우 객체지향 분석 기법의 절차 :
객체 모델링 > 동적 모델링 > 기능 모델링');
INSERT INTO "questions" VALUES(116,6,16,2,1,'코드 출력 결과형','16. 다음은 C언어에 관한 소스코드이다. 실행 결과값을 작성하시오.','','int main(){
   int res;
   res = mp(2,10);
   printf("%d",res);
   return 0;
}

int mp(int base, int exp) {
   int res = 1;
   for(int i=0; i < exp; i++){
      res = res * base;
   }
   
   return res;
}','c','[]','[]','1024','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [1024] 입니다.');
INSERT INTO "questions" VALUES(117,6,17,2,2,'코드 출력 결과형','17. 클래스 내에서 객체 생성 없이 사용할 수 있는 메소드로써 출력 결과를 작성하시오.','','public class Test {
   public static void main(String[] args){
      system.out.print(Test.check(1));
   }
   
   (    )  String check (int num) {
      return (num >= 0) ? "positive" : "negative";
   }
}

[출력결과]
positive','java','[]','[]','static','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [static] 입니다.');
INSERT INTO "questions" VALUES(118,6,18,2,4,'코드 출력 결과형','18. 다음은 C언어 문제이다. 출력값을 작성하시오.','','int main(){

int ary[3];
int s = 0;
*(ary+0)=1;
ary[1] = *(ary+0)+2;
ary[2] = *ary+3;
for(int i=0; i<3; i++){
  s=s+ary[i]
}

print("%d",s);

}','python','[]','[]','8','[Python 코드 실행 과정 분석]
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [8] 입니다.');
INSERT INTO "questions" VALUES(119,6,19,2,2,'코드 출력 결과형','19. 다음은 JAVA 관한 문제이다. 알맞는 출력값을 작성하시오.','','public class ovr1 {
	public static void main(String[] args){
    	ovr1 a1 = new ovr1();
        ovr2 a2 = new ovr2();
        System.out.println(a1.sun(3,2) + a2.sun(3,2));
    }
    
    int sun(int x, int y){
    	return x + y;
    }
}

class ovr2 extends ovr1 {

	int sun(int x, int y){
    	return x - y + super.sun(x,y);
    }

}','java','[]','[]','11','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [11] 입니다.');
INSERT INTO "questions" VALUES(120,6,20,1,10,'괄호 빈칸 채우기형','20. 다음 괄호 안에 알맞은 답안을 작성하시오.','- 테스트 하네스의 도구 구성 요소 중, 상향식 테스트시, 상위 모듈 역할을 대신하는 테스트 드라이버와 하향식 테스트 시, 하위 모듈 역할을 대신하는 테스트 ( ) 이 있다.','','','[]','[]','스텁','테스트 하네스란 시스템 및 시스템 컴포넌트 시험하는 환경의 일부분으로 시험을 지원하는 목적 하에 생성된 코드와 데이터를 뜻합니다. 시험 드라이버라고도 하며, 일반적으로 단위 시험이나 모듈 시험에 사용하기 위해 코드 개발자가 만듭니다.
테스트 하네스 도구 구성 요소 :테스트 드라이버, 테스트 스텁, 테스트 슈트, 테스트 케이스, 테스트 스크립트, 목 오브젝트');
INSERT INTO "questions" VALUES(121,7,1,2,2,'코드 출력 결과형','1. 다음 Java 코드에 대한 알맞는 출력값을 쓰시오.','','class Connection {
  private static Connection _inst = null;
  private int count = 0;
    static public Connection get() {
      if(_inst == null) {
      _inst = new Connection();
      return _inst;
      }
    return _inst;
    }
  public void count() { count ++; }
  public int getCount() { return count; }
}

public class testcon {
  public static void main(String[] args) {
    Connection conn1 = Connection.get();
    conn1.count();
    Connection conn2 = Connection.get();
    conn2.count();
    Connection conn3 = Connection.get();
    conn3.count();

    System.out.print(conn1.getCount());
  }
}','java','[]','[]','3','1.
conn1을 생성하여 Connection.get()을 호출할 때,
_inst는 null이므로 Connection() 객체를 생성합니다.
(객체를 생성하면 인스턴스를 생성하고 참조값을 return하기 때문에
여기서 부터는 _inst가 null이 아니게 됩니다.)
conn1.count() 는 0에서 count++ 하므로 1이 됩니다.
2.
conn2를 생성하고 다시 get()을 호출하면 _inst는 null이 아니기 때문에
객체를 생성하지 않고 count 값을 그대로 가지고 갑니다.
그래서 conn2.count() 는 1에서 count++ 하므로 2가 됩니다.
3. conn3.count()도 마찬가지로 위의 시스템처럼 진행되므로 2에서 count++로 3이 됩니다.');
INSERT INTO "questions" VALUES(122,7,2,1,8,'보기·기호 선택형','2. 다음은 정보 보호 기술인 AAA에 대한 설명이다. 각 설명에 맞는 답을 고르시오','(실제 기출문제에서는 답의 보기 중, A에 대한 보기가 주어집니다.(오답 중, Application 등..))
1. 시스템을 접근하기 전에 접근 시도하는 사용자의 신원을 검증
2. 검증된 사용자에게 어떤 수준의 권한과 서비스를 허용
3. 사용자의 자원(시간,정보,위치 등)에 대한 사용 정보를 수집','','','[]','[]','1.Authentication
2.Authorization
3.Accounting','AAA는 유무선 이동 및 인터넷 환경에서 가입자에 대한 안전하고,
신뢰성 있는 인증, 권한 검증 등의 기능을 체계적으로 제공하는 정보 보호 기술입니다.
신분을 확인하는 인증(authentication)
접근·허가를 결정하는 인가(authorization)
리소스 사용정보를 수집·관리하는 계정(accounting)
위의 3가지를 통합한 보안소프트웨어로 3A라고도 합니다.');
INSERT INTO "questions" VALUES(123,7,3,1,6,'서술·약술형','3. Grant의 기능에 대해 간략하게 약술하시오.','','','','[]','[]','사용자(User)에게 접속권한, 오브젝트 생성권한, DBA 권한 등을 부여할 수 있는 명령어','Grant는 사용자에게 접속권한, 오브젝트 생성권한, DBA 권한 등을 부여할 수 있는 명령어이며,
Revoke는 사용자에게 부여한 권한을 다시 회수하는 명령어입니다.');
INSERT INTO "questions" VALUES(124,7,4,1,5,'괄호 빈칸 채우기형','4. 다음 중, 설명에 대한 괄호( ) 안에 들어가는 내용에 대해 작성하시오.','(설명과 함께 동작과정 이미지가 있습니다.)
( ) 스푸핑은 근거리 통신망 하에서 ( ) 메시지를 이용하여 상대방의 데이터 패킷을 중간에서 가로채는 중간자 공격 기법이다. 이 공격은 데이터 링크 상의 프로토콜인 ( )를 이용하기 때문에 근거리상의 통신에서만 사용할 수 있는 공격이다.','','','[]','[]','ARP','위 내용은 ARP 스푸핑에 대한 내용이고 ARP에 대해 알아보겠습니다.
ARP :
ARP는 (Address Resolution Protocol) 의 약자로 주소 결정 프로토콜이라 불립니다.
네트워크 상에서 IP주소를 물리적 네트워크 주소(이더넷)로
대응(bind)시키기 위해 사용되는 프로토콜이며,인터넷 계층에 속해있습니다.');
INSERT INTO "questions" VALUES(125,7,5,1,14,'핵심 용어 단답형','5. 다음은 Coupling에 대한 설명이다. 설명에 대한 Coupling 종류를 영문으로 작성하시오.','어떤 모듈이 다른 모듈의 내부 논리 조직을 제어하기 위한 목적으로 제어 신호를 이용하여 통신하는 경우의 결합도
하위 모듈에서 상위 모듈로 제어 신호가 이동하여 상위 모듈에게 처리 명령을 부여하는 권리 전도 현상이 발생','','','[]','[]','control','소프트웨어 공학에서 coupling이란 결합도를 의미합니다.
결합도는 약할수록 모듈의 독립성이 높아지는데,
내용 > 공통 > 외부 > 제어 > 스탬프 > 자료 결합도 순으로 결합도가 약해집니다.
영어용어의 출제가 빈번해지면서 영어용어도 같이 숙지할 필요가 있어보입니다.
내용 결합도(Content Coupling)
공통 결합도(Common Coupling)
외부 결합도(External Coupling)
제어 결합도(Control Coupling)
스탬프 결합도(Stamp Coupling)
자료 결합도(Data Coupling)');
INSERT INTO "questions" VALUES(126,7,6,1,5,'핵심 용어 단답형','6. OSI 7 Layer의 설명으로 해당되는 설명의 답을 작성하시오.','1. 물리계층을 통해 송수신되는 정보의 오류와 흐름을 관리하여 안전한 정보의 전달을 수행할 수 있도록 도와주는 역할
2. 데이터를 목적지까지 가장 안전하고 빠르게 전달하는 기능
3. 수신자에서 데이터의 압축을 풀수 있는 방식으로 된 데이터 압축','','','[]','[]','1. 데이터링크
2. 네트워크
3. 표현','OSI 7 Layer :
OSI 7 Layer란 네트워크에서 통신이 일어나는 과정을 단계별로 파악하기 위해 7단계로 나눈 것을 말합니다.
1 Layer - 물리계층(Physical Layer)
단순 데이터를 전기적인 신호로 변환(on/off)해서 주고받는 기능만 하며,
케이블, 리피터, 허브를 통해 데이터를 전송합니다.
2 Layer - 데이터 링크계층(DataLink Layer)
물리계층을 통해 송수신되는 정보의 오류와 흐름을 관리하여 안전한 정보의 전달을 수행하도록 역할합니다.
MAC주소를 가지고 통신을 합니다.
3 Layer - 네트워크 계층(NetWork Layer)
전송 데이터를 목적지까지 경로를 찾아 전송하는 계층입니다.주소(IP)를 정하고, 경로(route)를 선택하여 패킷을 전달하는 것이 핵심입니다.
4 Layer - 전송 계층(Transport)
데이터를 전송하고 전송 속도를 조절하며 오류가 발생된 부분은 다시 맞춰주며,
주로 TCP프로토콜을 사용합니다.
5 Layer - 세션 계층(Session)
네트워크의 양쪽 연결을 관리하고 지속적으로 연결을 시켜줍니다.
TCP/IP의 세션을 만들고 없애는 것을 반복합니다.
6 Layer - 표현 계층(Presentation)
응용계층으로부터 전달받거나 전송하는 데이터의 인코딩(언어처리) 및 디코딩이 이루어 집니다.
JPEG,TIFF,GIF 등의 다양한 포멧을 지원합니다.
7 Layer - 응용계층(Application)
사용자가 네트워크에 접근할 수 있도록 도와줍니다.
사용자에게 보이는 유일한 계층으로 메일전송/인터넷접속 등의 작업을 수행합니다.');
INSERT INTO "questions" VALUES(127,7,7,1,6,'보기·기호 선택형','7. 다음 중, 설명에 대한 괄호 ( ) 안에 들어갈 알맞는 보기를 고르시오.','(실제 기출문제에서는 답에 대한 영어용어의 보기가 주어집니다.)
눈에 보이지 않는 것을 개념적으로 표현하는 것이 ''추상화''라하며,
이는 실세계의 복잡한 상황을 간결하고 명확하게 개념화(槪念化)하는 것이다.
( 1 )은 클래스들 사이의 전체 또는 부분 같은 관계를 나타내는 것이고,
( 2 )은 한 클래스가 다른 클래스를 포함하는 상위 개념일 때 IS-A관계라하며, 일반화 관계로 모델링한다.','','','[]','[]','1. Aggregation
2. Generalization','UML다이어그램의 구조 다이어그램안에 클래스 다이어그램에 대한 종류 문제입니다.
UML :
UML(Unified Modeling Language)는 통합 모델링 언어라 불리며,
시스템을 모델로 표현해주는 대표적인 모델링 언어입니다.
UML 다이어그램 종류
1. 구조 다이어그램 (Structure Diagram)
(1) 클래스 다이어그램 (이곳에 해당됩니다.)
(2) 객체 다이어그램
(3) 복합체 구조 다이어그램
(4) 배치 다이어그램
(5) 컴포넌트 다이어그램
(6) 패키지 다이어그램
2. 행위 다이어그램 (Behavior Diagram)
(1) 활동 다이어그램
(2) 상태 머신 다이어그램
(3) 유즈 케이스 다이어그램
(4) 상호작용 다이어그램
클래스 다이어그램 (Class Diagram) :
시간에 따라 변하지 않는 시스템의 정적인 면을 보여주는 대표적인 UML 구조 다이어그램이며,
시스템을 구성하는 클래스들 사이의 관계를 표현합니다.
UML에서 제공하는 클래스 사이의 관계 :
(1) 연관 관계 (association) : 클래스들이 개념상 서로 연결되어 있음을 나타냅니다.
(2) 일반화 관계 (generalization) : 상속 관계를 설명합니다. (위 문제 참조)
(3) 집합관계 :
1) 집약 관계(aggregation) : 클래스 사이의 전체 또는 부분 같은 관계를 나타냅니다. (객체 라이프 타임 : 독립적)
2) 합성 관계 (composition) : 클래스 사이의 전체 또는 부분 같은 관계를 나타냅니다. (객체 라이프 타임 : 의존적)
(4) 의존 관계 (dependency) : 연관 관계와 같이 한 클래스가 다른 클래스에서 제공하는 기능을 사용합니다.
(5) 실체화 관계 (realization) : 인터페이스와 구현 클래스 사이의 관계를 나타냅니다.');
INSERT INTO "questions" VALUES(128,7,8,1,10,'보기·기호 선택형','8. 다음은 테스트케이스의 구성요소에 대한 설명이다. 괄호 ( ) 안에 들어갈 알맞는 보기를 고르시오.','(실제 기출문제에서는 답에 대한 보기가 주어집니다.)','','','[]','[{"local": "/images/questions/q_128_1.png", "remote": "https://blog.kakaocdn.net/dna/bR6fYx/btrh2ibdoHd/AAAAAAAAAAAAAAAAAAAAAFqJZMd4x78vZxq3GZ5KCBm_7ImfAlR8i98sUbcV2fk_/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=3hQXHM4kG8bRv4UXaZJAa%2BqRQ3M%3D"}]','1. 테스트 조건
2. 테스트 데이터
3. 예상 결과','테스트 케이스란 특정 프로그램의 부분 및 경로를 실행해보거나,
요구사항에 준수하는지 확인하기 위해 개발된 입력 값, 조건, 예상된 결과 세트입니다.
케스트 케이스를 함으로써 오류감소 / 비용감소 / 의사소통의 효과가 나타납니다.
테스트 케이스의 설계 기법 종류로는
블랙박스 기법의 명세기반 / 경험기반 기법과
화이트박스 기법의 구조기반 기법이 있습니다.');
INSERT INTO "questions" VALUES(129,7,9,1,10,'보기·기호 선택형','9. 다음 중, 설명에 대한 괄호 ( ) 안에 들어갈 알맞는 보기를 고르시오.','(실제 기출문제에서는 답에 대한 보기 중, 영문 보기가 주어집니다.)
( ) 통해 요구사항 명세를 입력 조건과 출력 조건 간의 논리적 관계로 표현하고,
이를 기반으로 테스트케이스를 도출한다.
( )의 ‘원인(causes)’은 입력 조건을 의미하고 ‘결과(effects)’는 입력 조건의 결과를 의미하며,
원인과 결과 간의 논리적 관계를 AND, OR, NOT 같은 boolean 연산자를 사용하여 표현한다.','','','[]','[]','cause effect graph','동적 테스트(Dynamic Test)
- 테스트데이터를 이용해 실제 프로그램을 실행함으로써 오류를 찾는 과정입니다.
• 명세 기반 테스트(Black Box Test)
1) 신택스 기법(Syntax Analysis)
2) 동등 분할 기법(Equivalence Partitioning Analysis)
3) 경계 값 분석 기법(Boundary Value Analysis)
4) 원인-결과 그래프 기법(Cause-Effect Graph Analysis)
5) 의사결정 테이블 기법(Decision Table Analysis)
• 구현 기반 테스트(White Box Test)
1) 문장 검증 기준(Statement Coverage)
2) 분기 검증 기준(Branch Coverage)
3) 조건 검증 기준(Condition Coverage)
4) 분기/조건 검증 기준(Branch/Condition Coverage)
5) 다중 조건 검증 기준(Multiple Condition Coverage)
6) 기본 경로 테스트(Basic Path Test)');
INSERT INTO "questions" VALUES(130,7,10,1,8,'보기·기호 선택형','10. 다음 중, 설명에 대한 괄호 ( ) 안에 들어갈 알맞는 보기를 고르시오.','( )는 블록 암호의 일종으로, 미국 NBS (National Bureau of Standards, 현재 NIST)에서 국가 표준으로 정한 암호이다.
( )는 64비트 평문을 64비트 암호문으로 암호화하는 대칭키 암호 알고리즘이다.
( )의 키는 7비트마다 오류검출을 위한 정보가 1비트씩 들어가기 때문에 실질적으로는 56비트이다.','','','[]','[]','DES','DES(Data Encryption Standard)와 AES(Advanced Encryption Standard)는 대칭키 암호화 방식 중 하나입니다.
DES의 취약점을 보완하기 위해 만들어진 고급 암호 화 표준 방식이 AES입니다.
DES와 다르게 128비트 평문을 128비트로 암호화 하였으며,
10/12/14 라운드 수와 이에 대응해 128/192/256비트의 키길이를 갖습니다.(AES-128/AES-192/AES-256)
하기 때문에 안전하여 현재 보편적으로 사용되는 암호화 방식입니다.');
INSERT INTO "questions" VALUES(131,7,11,2,2,'코드 출력 결과형','11. 다음 Java 코드에 대한 알맞는 출력값을 쓰시오.','','public class testco {
 public static void main(String[] args) {
  int a = 3, b = 4, c = 3, d = 5;
  if((a == 2 | a == c) & !(c > d) & (1 == b ^ c != d)) {
   a = b + c;
    if(7 == b ^ c != a) {
     System.out.println(a);
    } else {
    System.out.println(b);
    }
  } else {
    a = c + d;
    if(7 == c ^ d != a) {
    System.out.println(a);
    } else {
    System.out.println(d);
    }
  }
 }
}','java','[]','[]','7','& : 비트연산자로써 같은 자리를 비교했을때 모두 같을 경우 True / 아니면 False
| : 비트연산자로써 같은 자리를 비교했을때 하나라도 조건이 맞을 경우 True / 아니면 False
^ : XOR연산자로써 두 값이 같으면 False / 아니면 True');
INSERT INTO "questions" VALUES(132,7,12,2,1,'코드 출력 결과형','12. 다음 C언어에 대한 알맞는 출력값을 쓰시오.','','#include <stdio.h>

int main(){
int *arr[3];
int a = 12, b = 24, c = 36;
arr[0] = &a;
arr[1] = &b;
arr[2] = &c;

printf("%d\n", *arr[1] + **arr + 1);

}','c','[]','[]','37
*array[1] = 24
**array + 1 = 12 + 1 = 13
24 + 13 = 37','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [37
*array[1] = 24
**array + 1 = 12 + 1 = 13
24 + 13 = 37] 입니다.');
INSERT INTO "questions" VALUES(133,7,13,1,6,'수식·계산 도출형','13. 다음은, 테이블에서 조건값을 실행한 화면이다. 이에 대한 알맞는 결과값을 작성하시오.','','','','[]','[{"local": "/images/questions/q_133_1.png", "remote": "https://blog.kakaocdn.net/dna/R2rn8/btrnwAk3QLa/AAAAAAAAAAAAAAAAAAAAAE84-yuMXg9KEwKrfeCU9twWTroHueW-5_GYLqAny9Ej/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=UQgzSOPTHFmKhrhzZCSb031NvBE%3D"}]','4','cross join은 join을 해서 나올 수 있는 모든 행의 조합을 보여주는 것으로 각 결과를 곱해주면 됩니다.
즉, S로 시작하는 A.NAME의 개수는 2개, T를 포함하는 A.NAME의 개수 또한 2개이므로 2*2 = 4가 됩니다.');
INSERT INTO "questions" VALUES(134,7,14,2,4,'코드 출력 결과형','14. 다음 파이썬 코드이다. 알맞는 출력값을 쓰시오.','','a,b = 100, 200
print(a==b)','python','[]','[]','False','여기서는 앞글자를 대문자로 표기하는 것이 포인트입니다.');
INSERT INTO "questions" VALUES(135,7,15,1,11,'괄호 빈칸 채우기형','15. 다음 중, 설명에 대한 괄호 ( ) 안에 들어갈 알맞는 답을 작성하시오.','( ) 다이어그램은 문제 해결을 위한 도메인 구조를 나타내어 보이지 않는 도메인 안의 개념과
같은 추상적인 개념을 기술하기 위해 나타낸 것이다.
또한 소프트웨어의 설계 혹은 완성된 소프트웨어의 구현 설명을 목적으로 사용할 수 있다.
( ) 다이어그램의 형식은 ( )를 포함하여 속성(attribute)과 메서드(method)가 있다.','','','[]','[]','클래스','UML(Unified Modeling Language)은 통합 모델링 언어라고 합니다.
UML를 사용하면
의미가 명확하고 소통이 원활해 지며,
전체 시스템 구조와 클래스 간의 의존성 파악도 쉬우며,
원활한 유지보수를 위한 문서 활용으로도 사용됩니다.
UML다이어그램은
구조 다이어그램 (Structure Diagram : 정적) 과
행위 다이어그램 (Behavior Diagram : 동적) 으로 나뉘는데
클래스 다이어그램은 구조 다이어그램에 속합니다.');
INSERT INTO "questions" VALUES(136,7,16,1,9,'보기·기호 선택형','16. 다음 중, 설명에 대한 괄호 ( ) 안에 들어갈 알맞는 보기를 고르시오.','(실제 기출문제에서는 답에 대한 보기 중, 영문 보기가 주어집니다.)
( ) 패턴은 객체지향 디자인 패턴이다.
( )는 부모(상위) 클래스에 알려지지 않은 구체 클래스를 생성하는 패턴이며,
자식(하위) 클래스가 어떤 객체를 생성할지를 결정하도록 하는 패턴이기도 하다.
부모(상위) 클래스 코드에 구체 클래스 이름을 감추기 위한 방법으로도 사용한다.','','','[]','[]','Factory method','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Factory method] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(137,7,17,2,1,'코드 출력 결과형','17. 다음 C언어에 대한 알맞는 출력값을 쓰시오.','','#include <stdio.h>

struct jsu {
  char name[12];
  int os, db, hab, hhab;
};

int main(){
struct jsu st[3] = {{"데이터1", 95, 88},
                    {"데이터2", 84, 91},
                    {"데이터3", 86, 75}};
struct jsu* p;

p = &st[0];

(p + 1)->hab = (p + 1)->os + (p + 2)->db;
(p + 1)->hhab = (p+1)->hab + p->os + p->db;

printf("%d\n", (p+1)->hab + (p+1)->hhab);
}','c','[]','[]','501','jsu에는 {name, os, db, hab, hhab} 이런형태의 데이터가 들어가 있습니다.
p = &st[0]; :
p = {"데이터1", 95, 88}
(p+1)→hab = (p+1)→os + (p+2)→db; :
(p+1) = {"데이터2", 84, 91}, (p+2) = {"데이터3", 86, 75}
(p+1)→os + (p+2)→db : 84 + 75 = 159
(p+1)→hhab = (p+1)→hab + p→os + p→db; :
(p+1)→hab + p→os + p→db : 159 + 95 + 88 = 342
printf("%d", (p+1)→hab + (p+1)→hhab) :
(p+1)→hab + (p+1)→hhab : 159 + 342 = 501');
INSERT INTO "questions" VALUES(138,7,18,1,13,'괄호 빈칸 채우기형','18. 다음은, 파일 구조(File Structures)에 대한 설명이다. 괄호 ( ) 안에 들어갈 알맞는 답을 작성하시오.','파일구조는 파일을 구성하는 레코드들이 보조기억장치에 편성되는 방식으로 접근 방식에 따라 방식이 달라진다.
접근 방법중, 레코드들을 키-값 순으로 정렬하여 기록하고, 레코드의 키 항목만을 모은 ( )을 구성하여 편성하는 방식이 있으며, 레코드를 참조할 때는 ( ) 이 가르키는 주소를 사용하여 직접 참조할 수 있다. 파일 구조에는 순차 접근, ( ) 접근, 해싱 접근이 있다.','','','[]','[]','인덱스 (색인)','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [인덱스 (색인)] 입니다.
• 학습 가이드: [데이터베이스(설계/정규화)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(139,7,19,1,8,'괄호 빈칸 채우기형','19. 다음 설명에 대한 알맞는 답을 영문약어로 작성하시오.','( )는 사용자가 그래픽을 통해 컴퓨터와 정보를 교환하는 환경을 말한다.
이전까지 사용자 인터페이스는 키보드를 통해 명령어로 작업을 수행시켰지만
( )에서는 키보드 뿐만 아니라 마우스 등을 이용하여 화면의 메뉴 중 하나를 선택하여 작업을 수행한다.
화면에 아이콘을 띄어 마우스를 이용하여 화면에 있는 아이콘을 클릭하여 작업을 수행하는 방식이다.
대표적으로는 마이크로소프트의 Windows, 애플의 Mac 운영체제 등이 있다.','','','[]','[]','GUI','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [GUI] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(140,7,20,1,10,'괄호 빈칸 채우기형','20. 다음은 소프트웨어 통합 테스트에 대한 설명이다. 괄호 ( ) 안에 들어갈 알맞는 답을 작성하시오.','( 1. ) 방식은 이름에서도 알 수 있듯이, 하위 모듈부터 시작하여 상위 모듈로 테스트를 진행하는 방식이며,
이 방식을 사용하기 위해서는 ( 2. )가 필요하다.
( 2. )는 이미 존재하는 하위 모듈과 존재하지 않은 상위 모듈에 대한 인터페이스 역할을 한다.','','','[]','[]','1. 상향식
2. 테스트 드라이버','모듈을 통합하는 과정에서 모듈 간 호환성의 문제를 찾아내기 위해 수행되는 테스트입니다.
즉, 모듈 간의 인터페이스가 올바르게 작동하는지를 테스트하게 됩니다.
통합 테스트에는 아래와 같은 방식이 존재합니다.
1. 빅뱅(Big Bang) 접근법 : 모든 구성 요소들을 한꺼번에 통합된 후에 테스트 수행
2. 점증적(incremental) 접근법 : 논리적으로 연관된 두개 또는 그 이상의 모듈을 조합시켜서 수행
(1) 하향식(Top Down) 접근법 :
소프트웨어 시스템의 제어 흐름이 위에서 아래로 발생
(테스팅을 위해 스텁의 도움이 필요)
(2) 상향식(Bottom Up) 접근법 :
모든 모듈들이 테스트될 때까지 더 낮은 레벨에 있는 각 모듈은 더 위에 있는 모듈과 함께 테스트 수행
(테스팅을 위한 드라이버의 도움이 필요)
(3) 샌드위치 접근법 : 하향식과 상향식 접근법의 조합');
INSERT INTO "questions" VALUES(141,8,1,1,5,'핵심 용어 단답형','1. 아래 설명에 맞는 RAID 단계를 숫자로 작성하시오.','- Striping(스트라이핑) 구현 방식
- I/O 로드의 분산으로 매우 빠른 속도
- 데이터를 블럭으로 분할 저장하며, 각 블럭은 다른 디스크로 나뉘어 저장','','','[]','[]','0','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [0] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(142,8,2,1,15,'보기·기호 선택형','2. 다음 설명을 확인하여 해당하는 항목을 보기에서 찾아 적으시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, rollback 등..))
1. 오류가 발생하기 전까지의 사항을 로그(log)로 기록해 놓고, 이전 상태로 되돌아간 후, 실패가 발생하기 전까지의 과정을 그대로 따라가는 현상
2. 작업을 취소하여 트랜잭션을 이전 상태로 되돌리는 것','','','[]','[]','1. redo
2. undo','[데이터베이스(트랜잭션/회복) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. redo
2. undo] 입니다.
• 학습 가이드: [데이터베이스(트랜잭션/회복)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(143,8,3,2,2,'코드 출력 결과형','3. 다음 자바 문법에 알맞는 출력 결과를 작성하시오.','','class A {
  int a;
  int b;
}

  public class Main {

  static void func1(A m){
   m.a *= 10;
  }

  static void func2(A m){
    m.a += m.b;
  }

  public static void main(String args[]){

  A m = new A();

  m.a = 100;
  func1(m);
  m.b = m.a;
  func2(m);

  System.out.printf("%d", m.a);

  }
}','java','[]','[]','2000','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [2000] 입니다.');
INSERT INTO "questions" VALUES(144,8,4,2,3,'SQL 작성·빈칸형','4. 다음 SQL 결과에 알맞는 쿼리을 작성하시오.','','SELECT name, score FROM 성적 ( 1 ) BY ( 2 ) ( 3 )','sql','[]','[{"local": "/images/questions/q_144_1.png", "remote": "https://blog.kakaocdn.net/dna/uEqo5/btrCITDzsQ5/AAAAAAAAAAAAAAAAAAAAAGpz6sul64daWvkKDeHLmkGeeTlmJGv8rtI27qb1-rRW/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=fAiEsaVNFambxTPKOEtImnNg9ig%3D"}]','1. ORDER
2. score
3. DESC','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1. ORDER
2. score
3. DESC] 입니다.');
INSERT INTO "questions" VALUES(145,8,5,1,13,'서술·약술형','5. 데이터베이스의 이상현상 중, 삭제 이상에 대해 서술하시오.','','','','[]','[]','데이터를 삭제할 경우 원하지 않는 다른 데이터도 삭제되어버리는 이상','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [데이터를 삭제할 경우 원하지 않는 다른 데이터도 삭제되어버리는 이상] 입니다.
• 학습 가이드: [데이터베이스(설계/정규화)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(146,8,6,2,4,'코드 출력 결과형','6. 다음은 파이썬 코드에서 출력되는 a와 b의 값을 작성하시오.','','def exam(num1, num2=2):
  print(''a='', num1, ''b='', num2)
exam(20)','python','[]','[]','a= 20 b= 2','[Python 코드 실행 과정 분석]
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [a= 20 b= 2] 입니다.');
INSERT INTO "questions" VALUES(147,8,7,1,6,'보기·기호 선택형','7. 다음 설명과 관련된 답을 보기에서 골라 작성하시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, remove, sort 등..))
1. 요소를 확장해준다는 의미를 가지고 있으며, 모든 항목을 하나의 요소로 추가
2. 리스트 내부 요소를 꺼내주는 함수로써, 그 요소는 리스트 안에서 삭제하고 그 값을 반환
3. 리스트 내부의 요소의 순서는 뒤집는 역할','','','[]','[]','1. extend
2. pop
3. reverse','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. extend
2. pop
3. reverse] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(148,8,8,1,7,'핵심 용어 단답형','8. 다음 아래 단어를 영어 약자로 작성하시오.','임시 키 무결성 프로토콜','','','[]','[]','TKIP (Temporal Key Integrity Protocol)','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [TKIP (Temporal Key Integrity Protocol)] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(149,8,9,1,6,'핵심 용어 단답형','9. 다음 중, 설명에 대한 답을 영어 약자로 작성하시오.','키보드나 마우스와 같은 장치 없이 말이나 행동 그리고 감정과 같은 인간의 자연스러운 표현으로 컴퓨터나 장치를 제어할 수 있는 환경','','','[]','[]','NUI','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [NUI] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(150,8,10,1,10,'핵심 용어 단답형','10. 다음은 분석도구에 대한 설명으로 보기에 알맞는 답을 작성하시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, running analysis 등..))
1. 소스 코드의 실행 없이, 코드의 의미를 분석해 결함을 찾아내는 원시적 코드 분석 기법
2. 소스 코드를 실행하여 프로그램 동작이나 반응을 추적하고 코드에 존재하는 메모리 누수, 스레드 결함 등을 분석','','','[]','[]','1. static
2. dynamic','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. static
2. dynamic] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(151,8,11,2,2,'코드 빈칸 완성형','11. 다음 Java 코드 중에서 밑줄에 들어갈 알맞는 코드를 작성하시오.','','class Car implements Runnable{
  int a;

  public void run(){
     system.out.println("message")
  }
}

public class Main{
  public static void main(String args[]){
    Thread t1 = new Thread(new ___());
    t1.start();
  }
}','java','[]','[]','Car','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [Car] 입니다.');
INSERT INTO "questions" VALUES(152,8,12,1,10,'핵심 용어 단답형','12. 다음 설명에 대한 알맞는 단어를 작성하시오.','자바 프로그래밍 언어를 이용한 xUnit의 테스트 기법으로써 숨겨진 단위 테스트를 끌어내어 정형화시켜 단위 테스트를 쉽게 해주는 테스트용 Framework이다.','','','[]','[]','JUnit','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [JUnit] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(153,8,13,1,10,'핵심 용어 단답형','13. 다음 보기 중에서 블랙박스 테스트 기법을 3가지 골라 작성하시오.','','','','[]','[{"local": "/images/questions/q_153_1.png", "remote": "https://blog.kakaocdn.net/dna/qF3gz/btrCLADst4N/AAAAAAAAAAAAAAAAAAAAAPMlILODV_JxRx5zW8aFrSoy4091ZPX6hQX3VcFjaElc/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=AQAcOFA5BWjaz%2FTXDB55VyrOysM%3D"}]','ㄷ, ㄹ, ㅂ','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄷ, ㄹ, ㅂ] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(154,8,14,2,1,'코드 출력 결과형','14. 다음 소스코드에서 입력값이 5가 들어왔을때 출력되는 값을 작성하시오.','','#include <stdio.h>
int func(int a) {
  if (a <= 1) return 1;
  return a * func(a - 1);
}

int main() {
  int a;
  scanf("%d", &a);
  printf("%d", func(a));

}','c','[]','[]','120','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [120] 입니다.');
INSERT INTO "questions" VALUES(155,8,15,2,1,'코드 빈칸 완성형','15. 다음 중, 괄호 ( ) 안에 들어갈 연산자를 써서 정수를 역순으로 출력하는 알맞는 답을 작성하시오.','결과 : 4321','#include <stdio.h>
int main() {

  int number = 1234;
  int div = 10;
  int result = 0;

  while (number ( 1 ) 0) {

    result = result * div;
    result = result + number ( 2 ) div;
    number = number ( 3 ) div;

  }

  printf("%d", result);return 0;

}','c','[]','[]','1. >
2. %
3. /','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [1. >
2. %
3. /] 입니다.');
INSERT INTO "questions" VALUES(156,8,16,1,6,'핵심 용어 단답형','16. 다음 설명에 대한 답을 영어 약자로 작성하시오.','정보보호 관리체계의 영문 약자','','','[]','[]','ISMS (Information Security Management System)','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ISMS (Information Security Management System)] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(157,8,17,1,7,'보기·기호 선택형','17. 다음 설명 중, 괄호 ( ) 안에 들어가는 알맞는 답을 보기에서 선택하여 작성하시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, 참조성, 무결성 등..))
1. 슈퍼키는 ( 1 ) 의 속성을 갖는다.
2. 후보키는 ( 1 ) 와/과 ( 2 ) 의 속성을 갖는다.','','','[]','[]','1. 유일성
2. 최소성','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 유일성
2. 최소성] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(158,8,18,1,6,'핵심 용어 단답형','18. 다음 설명과 관련된 답을 보기에 찾아서 작서하시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, Pharming, Ransomware등..))
이 공격은 APT 공격에서 주로 쓰이는 공격으로, 공격 대상이 방문할 가능성이 있는 합법적인 웹 사이트를 미리 감염시킨 뒤, 잠복하고 있다가 공격 대상이 방문하면 대상의 컴퓨터에 악성코드를 설치하는 방식','','','[]','[]','watering hole','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [watering hole] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(159,8,19,2,1,'코드 출력 결과형','19. 다음 소스코드가 실행할 때의 출력값을 작성하시오.','','#include <stdio.h>
int isPrime(int number) {
  int i;
  for (i=2; i<number; i++) {
    if (number % i == 0) return 0;
  }
  return 1;
}

int main(void) {
  int number = 13195, max_div=0, i;
  for (i=2; i<number; i++)
  if (isPrime(i) == 1 && number % i == 0) max_div = i;
  printf("%d", max_div);
  return 0;
}','c','[]','[]','29','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [29] 입니다.');
INSERT INTO "questions" VALUES(160,8,20,1,10,'괄호 빈칸 채우기형','20. 다음은 V모델에서의 테스트 단계에 대한 설명으로 괄호안에 들어갈 답을 작성하시오.','','','','[]','[{"local": "/images/questions/q_160_1.png", "remote": "https://blog.kakaocdn.net/dna/bNLeA3/btrCMbi8wE3/AAAAAAAAAAAAAAAAAAAAACS_CgMqjt6zFAMVDj9LSQ5zH_5R4-V_n31j6OaRDPf8/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=xZkGbg3ogiaoVPRZF37tMxr%2FRH4%3D"}]','1. 단위 테스트
2. 통합 테스트
3. 시스템 테스트
4. 인수 테스트','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 단위 테스트
2. 통합 테스트
3. 시스템 테스트
4. 인수 테스트] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(161,9,1,1,7,'괄호 빈칸 채우기형','1. 다음은 관계 데이터 모델에 대한 설명이다. 괄호안에 들어가는 용어를 작성하시오.','( )은 /는 관계 데이터의 연산을 표현하는 방법으로, 원하는 정보를 정의할 때는 계산 수식을 사용한다.
수학의 predicate calculus에 기반을 두고 있으며, 관계 데이터 모델의 제안자인 codd가 수학에 가까운 기반을 두고 특별히 관계 데이터베이스를 위해 제안하여 탄생하였다.
( ) /은/는 원하는 정보가 무엇이라는 것만 정의하는 비절차적 특성을 지니며, 튜블 ( )와/과 도메인 ( ) 이/가 있다.','','','[]','[]','관계해석','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [관계해석] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(162,9,2,1,8,'보기·기호 선택형','2. 다음은 대칭 키 알고리즘에 대한 설명이다. 해당 설명에 맞는 용어를 보기에 골라 작성하시오.','1. Xuejia Lai와 James Messey 가 만든 알고리즘으로 PES(Proposed Encryption Standard)에서 IPES(Improved PES)로 변경되었다가, 1991년에 제작된 블록 암호 알고리즘으로 현재 국제 데이터 암호화 알고리즘으로 사용되고 있다. 64비트 블록을 128비트의 key를 이용하여 8개의 라운드로 구성되어 있다.
2. 미국의 NSA에서 개발한 Clipper 칩에 내장되는 블록 알고리즘이다. 전화기와 같은 음성을 암호화 하는데 주로 사용되며 64비트 입출력에 80비트의 키 총 32라운드를 가진다.','','','[]','[]','1.IDEA
2.SKIPJACK','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1.IDEA
2.SKIPJACK] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(163,9,3,2,3,'SQL 작성·빈칸형','3. H회사의 전체 제품 단가 보다 큰 제품 출력을 하고자 한다. 괄호안에 들어갈 알맞는 용어를 작성하시오.','[제품테이블]','SELECT 제조사, 제품명, 단가
FROM 제품
WHERE 단가 > ( ) (SELECT 단가 FROM 제품 WHERE 제조사=''H'')','sql','[]','[{"local": "/images/questions/q_163_1.png", "remote": "https://blog.kakaocdn.net/dna/bsS2lh/btsCX4ru0Xg/AAAAAAAAAAAAAAAAAAAAAOcgsnx9SfGMIWdDsv3pjyb3vUhghOgI5BFzcIgt3Vkb/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=%2BL5gpdGzzUzF5J9KD9x4BGKFNAg%3D"}]','ALL','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [ALL] 입니다.');
INSERT INTO "questions" VALUES(164,9,4,2,3,'SQL 작성·빈칸형','4. 다음 SQL 결과에 알맞는 답을 작성하시오.','[TABLE]','SELECT count(col2)
FROM TABLE
WHERE col1 in(2,3) or col2 in(3,5);','sql','[]','[{"local": "/images/questions/q_164_1.png", "remote": "https://blog.kakaocdn.net/dna/tgfeI/btsCZgyM9H0/AAAAAAAAAAAAAAAAAAAAAAfaSaiHsttAJUuyxzzjIurwV8RwcfTgRK8zF1yNeFdi/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=vQ8X8yTK2Pvbha7r%2BZ4uHkYAhQY%3D"}]','4','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [4] 입니다.');
INSERT INTO "questions" VALUES(165,9,5,1,5,'괄호 빈칸 채우기형','5. 다음은 네트워크에 관련한 내용이다. 괄호안에 들어갈 알맞는 답을 작성하시오.','( )은/는 인터넷을 통해 디바이스 간에 사설 네트워크 연결을 생성하며, 퍼블릭 네트워크를 통해 데이터를 안전하게 익명으로 전송하는 데 사용된다.
또한 사용자 IP 주소를 마스킹하고 데이터를 암호화하여 수신 권한이 없는 사람이 읽을 수 없도록 한다.','','','[]','[]','VPN','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [VPN] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(166,9,6,1,17,'보기·기호 선택형','6. 다음은 SOLID 원칙에 관한 내용이다. 괄호안에 알맞는 단어를 보기에서 고르시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, SRP, LSP 등..))
( ) 은/는 클라이언트가 자신이 이용하지 않는 메서드에 의존하지 않아야 한다는 원칙이다.
( ) 은/는 큰 덩어리의 인터페이스들을 구체적이고 작은 단위들로 분리시킴으로써 클라이언트들이 꼭 필요한 메서드들만 이용할 수 있게 한다.
예를 들어 하나의 복합기에 프린터와 복사기, 팩스 메서드가 있는데 이 세가지 메서드는 같은 파일에 존재하므로 프린터 로직만 바뀌어도 복사기와 팩스도 재컴파일을 해야한다.
그러므로 ( ) 을/를 적용하여 로직이 바뀌어도 다른 메서드는 영향을 받지 않도록 해야한다.','','','[]','[]','ISP (Interface segregation principle)','[인터페이스/연계/웹기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ISP (Interface segregation principle)] 입니다.
• 학습 가이드: [인터페이스/연계/웹기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(167,9,7,2,2,'코드 출력 결과형','7. 다음 자바 코드에 알맞는 출력값을 작성하시오.','','','java','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15", "public static void main(String args[]){\nint i = 3; int k = 1;\nswitch(i) {\ncase 1: k += 1;\ncase 2: k++;\ncase 3: k = 0;\ncase 4: k += 3;\ncase 5: k -= 10;\ndefault: k--;\n}\nSystem.out.print(k);\n}\nColored by Color Scripter", "cs"]]}]','[]','-8','[Java 객체지향 실행 과정 분석]
• System.out 출력문에 의해 최종 도출되는 결과값은 [-8] 입니다.');
INSERT INTO "questions" VALUES(168,9,8,1,6,'핵심 용어 단답형','8. 다음 소스코드에 대한 출력값을 작성하시오.','','','','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13", "struct A{\nint n,\nint g\n}\nint main(){\nA a = new A[2]\nfor(i=0; i <2; i++) {\na[i].n = i,\na[i].g=i+1\n}\nSystem.out.printf(a[0].n + a[1].g);\n}\nColored by Color Scripter", "cs"]]}]','[]','2','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [2] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(169,9,9,1,5,'괄호 빈칸 채우기형','9. IP 주소가 139.127.19.132이고 서브넷마스크 255.255.255.192일 때 아래의 답을 작성하시오.','(10진수로 표기)
(1) 괄호안에 들어갈 네트워크 주소 : 139.127.19.( )
(2) 해당 네트워크 주소와 브로드캐스트 주소를 제외한 호스트 개수','','','[]','[]','128 , 62','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [128 , 62] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(170,9,10,1,10,'괄호 빈칸 채우기형','10. 다음 설명에 대한 괄호안에 알맞는 단어를 작성하시오.','1. ( ) 테스트는 하드웨어나 소프트웨어의 개발 단계에서 상용화하기 전에 실시하는 제품 검사 작업. 제품의 결함 여부, 제품으로서의 가치 등을 평가하기 위해 실시한다. 선발된 잠재 고객으로 하여금 일정 기간 무료로 사용하게 한 후에 나타난 여러 가지 오류를 수정, 보완한다. 공식적인 제품으로 발매하기 이전에 최종적으로 실시하는 검사 작업이다.
2. ( ) 테스트는 새로운 제품 개발 과정에서 이루어지는 첫 번째 테스트. 즉, 시제품이 운영되는 동안의 신제품 연구와 개발 과정 단계에서 초기 작동의 결과를 평가하는 수단이며 개발 회사 내부에서 이루어지는 테스트로서 단위 테스트, 구성 테스트, 시스템 테스트 등을 포함한다.','','','[]','[]','베타, 알파','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [베타, 알파] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(171,9,11,1,10,'보기·기호 선택형','11. 다음 설명에 알맞는 테스트 용어를 보기에서 골라 작성하시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, Iterating등..))
오류를 제거하거나 수정한 시스템이나 시스템 컴포넌트 또는 프로그램이 오류 제거와 수정에 의해 새로이 유입된 오류가 없는지를 확인하는 일종의 반복 시험이다.
반복적인 시험이 필요한 이유는 오류가 제거·수정되는 상당수의 시스템이 의도치 않았던 오동작이나 새로운 형태의 오류를 일으키기 때문이다.
결국, 수정·변경된 시스템이나 시스템 컴포넌트 또는 프로그램이 명세된 요구 사항을 충족시키는지를 확인하는 시험의 한 형태이다.','','','[]','[]','Regression','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Regression] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(172,9,12,1,6,'핵심 용어 단답형','12. 다음 테이블에서 πTTL(employee)에 대한 연산 결과 값을 작성하시오.','[employee테이블]','','','[]','[{"local": "/images/questions/q_172_1.png", "remote": "https://blog.kakaocdn.net/dna/ciEqnk/btsC5YDmqrh/AAAAAAAAAAAAAAAAAAAAANWPC8whsCRtZTb-RB-J7RHvuEfPLxoxXgJ1I-APFJh1/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=UlnGeh5mI6jvFNa1PChA6Pnggas%3D"}]','1. TTL
2. 부장
3. 대리
4. 과장
5. 차장','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. TTL
2. 부장
3. 대리
4. 과장
5. 차장] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(173,9,13,2,4,'코드 출력 결과형','13. 다음은 파이썬 코드이다. 알맞는 출력값을 작성하시오.','','','python','[{"type": "grid", "rows": [["1\n2\n3\n4", "a = \"REMEMBER NOVEMBER\"\nb = a[:3] + a[12:16];\nc = \"R AND %s\" % \"STR\";\nprint(b+c);", "cs"]]}]','[]','REMEMBER AND STR','[Python 코드 실행 과정 분석]
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [REMEMBER AND STR] 입니다.');
INSERT INTO "questions" VALUES(174,9,14,1,7,'핵심 용어 단답형','14. 다음 설명에 대해 보기에 주어진 답을 골라 작성하시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, ARP, RARP 등..))
1. 라우터로 상호 접속이 되어있는 여러 개의 네트워크 집합으로 도메인 혹은 자율시스템(Autonomous System, AS)이라고 한다.
같은 도메인 내에 존재하는 라우터는 도메인 내부 라우터가 되고 도메인 외부에 존재하는 라우터는 도메인 외부 라우터가 되는데, 여기서 도메인 내부 경로 설정을 가르킨다.
2. 시스템 사이에 경로 설정 정보 등을 교환하기 위해 사용하는 프로토콜로써,
다른 도메인 사이에 라우팅 시 정리된 관리가 거의 없고 많은 경우에 신용도가 매우 낮아 빠른 수행보다는 보안과 제어가 본래의 목적이다.
3. IP 라우팅 프로토콜의 한 종류로써 RIP(routing information protocol)보다 규모가 큰 네트워크에서도 사용할 수 있다.
규모가 크고 복잡한 TCP/IP 네트워크에서 RIP의 단점을 개선한 라우팅 프로토콜로써 RIP에 비해 자세한 제어가 가능하고, 관리 정보의 트래픽도 줄일 수 있다.
4. 서로 다른 자율 시스템(AS)의 라우터 간에 라우팅 정보를 교환하는 데 사용되는 외부 게이트웨이 프로토콜(EGP)이다.
각 목적지에 대한 전체 경로가 포함되며, 다른 시스템과 교환하는 네트워크 도달 가능성 정보의 데이터베이스를 유지한다.
네트워크 도달 가능성 정보를 사용하여 AS 연결 그래프를 구성하며, 이를 통해 라우팅 루프를 제거하고 AS 수준에서 정책 결정을 실행할 수 있다.','','','[]','[]','1. IGP
2. EGP
3. OSPF
4. BGP','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. IGP
2. EGP
3. OSPF
4. BGP] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(175,9,15,2,1,'코드 출력 결과형','15. 다음 C언어에서 출력에 대한 알맞은 답을 작성하시오.','','#include <stdio.h>

int len(char*p);

int main(){

  char* p1 = "2022";
  char* p2 = "202207";

  int a = len(p1);
  int b = len(p2);

  printf("%d", a + b);

}

int len(char* p){
  int r = 0;
  while(*p != ''\0''){
    p++;
    r++;
 }
 return r;
}','c','[]','[]','10','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [10] 입니다.');
INSERT INTO "questions" VALUES(176,9,16,2,1,'코드 출력 결과형','16. 다음 C언어 코드에서 알맞는 출력값을 작성하시오.','','','c','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19", "#include <stdio.h>\nint main(int argc, char *argv[]) {\nint a[4] = {0, 2, 4, 8};\nint b[3] = {};\nint i = 1;\nint sum = 0;\nint *p1;\nfor (i; i < 4; i++) {\np1 = a + i;\nb[i-1] = *p1 - a[i-1];\nsum = sum + b[i-1] + a[i];\n}\nprintf(\"%d\", sum);\nreturn 0;\n}\nColored by Color Scripter", "cs"]]}]','[]','22','[C언어 실행 과정 분석]
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [22] 입니다.');
INSERT INTO "questions" VALUES(177,9,17,2,2,'코드 출력 결과형','17. 다음 자바코드에서 알맞는 출력값을 작성하시오.','','','java','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21", "public class Conv{\npublic Conv(int a) {\nthis.a = a;\n}\nint func() {\nint b =1;\nfor (int i=1; i<a; i++){\nb = a * i + b\n}\nreturn a +b;\n}\nint a;\n}\npublic static void main(String[] args){\nConv obj = new Conv(3);\nobj.a=5;\nint b = obj.func();\nsystem.out.print(obj.a + b);\ni\n}\nColored by Color Scripter", "cs"]]}]','[]','61','[Java 객체지향 실행 과정 분석]
• System.out 출력문에 의해 최종 도출되는 결과값은 [61] 입니다.');
INSERT INTO "questions" VALUES(178,9,18,1,7,'보기·기호 선택형','18. 다음은 함수 종속성에 대한 설명이다. 해당 문제에 대한 알맞는 답을 보기에서 골라 작성하시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, union 등..))
1. 성적은 {학생,학과}에 대해서 ( ) Functional Dependency이다.
2. 성적은 학과만 알아도 식별이 가능하므로, 이 경우에는 성적 속성은 기본키에 ( ) Functional Dependency이다.
3. 릴레이션에서 X, Y, Z라는 3 개의 속성이 있을 때 X→Y, Y→Z 이란 종속 관계가 있을 경우, X→Z가 성립될 경우','','','[]','[{"local": "/images/questions/q_178_1.png", "remote": "https://blog.kakaocdn.net/dna/dwxbKs/btsCVHKbX1G/AAAAAAAAAAAAAAAAAAAAAHpCevhbn5bkhzNeFabt-jk3O783zzgyvzFhP7_jj8cj/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=s4iPkkLngwtQo1d50Oq%2BSfPwq7Y%3D"}]','1. Full
2. Partial
3. Transitive','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. Full
2. Partial
3. Transitive] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(179,9,19,1,17,'보기·기호 선택형','19. 다음 설명에 대한 알맞는 답을 보기에서 고르시오.','(실제 기출문제에서는 답의 보기가 주어집니다.(오답 중, ajax, 등..))
1. 인터넷에서, 웹 서버와 사용자의 인터넷 브라우저 사이에 문서를 전송하기 위해 사용되는 통신 규약을 말한다.
인터넷에서 하이퍼텍스트(hypertext) 문서를 교환하기 위하여 사용되는 통신규약이다.
이 규약에 맞춰 개발해서 서로 정보를 교환할 수 있게 되었다.
2. 문자, 그래픽, 음성 및 영상을 하나의 연상 거미집(Web of Association)과 같이 서로 연결시켜, 제시된 순서에 관계없이 이용자가 관련된 정보를 검색할 수 있도록 하는 정보 제공 방법이다.
즉, 한 페이지에서 링크된 순서에 상관없이 사용자들이 원하는 정보를 클릭함으로써 원하는 정보에 쉽게 접근하는 방식을 말한다.
3. 웹 페이지 표시를 위해 개발된 지배적인 마크업 언어다.
또한, 제목, 단락, 목록 등과 같은 본문을 위한 구조적 의미를 나타내는 것뿐만 아니라 링크, 인용과 그 밖의 항목으로 구조적 문서를 만들 수 있는 방법을 제공한다.','','','[]','[]','ㅇ. HTTP
ㄹ. Hypertext
ㅂ. HTML','[인터페이스/연계/웹기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㅇ. HTTP
ㄹ. Hypertext
ㅂ. HTML] 입니다.
• 학습 가이드: [인터페이스/연계/웹기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(180,9,20,1,16,'핵심 용어 단답형','20. 다음 모듈 F에 대한 Fan-in과 Fan-out을 작성하시오.','','','','[]','[{"local": "/images/questions/q_180_1.png", "remote": "https://blog.kakaocdn.net/dna/7rUn8/btsC2xTZYee/AAAAAAAAAAAAAAAAAAAAAJHQ82vln75ifQ37NX2AnUI06OIwV9ReHhjfS-_HA0iL/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=BsPmSkBFCRwwZCruYHp%2BjFY8UrY%3D"}]','Fan-in : 3
Fan-out : 2','[소프트웨어 공학/방법론 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Fan-in : 3
Fan-out : 2] 입니다.
• 학습 가이드: [소프트웨어 공학/방법론] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(181,10,1,2,1,'코드 출력 결과형','1. 아래는 C언어의 2차원 배열 형태이다. field의 경우 2차원 배열 형태는 예시처럼 출력되므로, 이를 참고하여 mines의 2차원 배열 형태를 작성하시오.','','','c','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23\n24\n25\n26\n27\n28\n29\n30\n31\n32\n33", "void main{\nfield {{0,1,0,1},{0,0,0,1},{1,1,1,0},{0,1,1,1}};\nmines {{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}};\nint w = 4, h = 4;\nfor(y=0; y<h; y++) {\nfor(x=0; x<w; x++) {\nif(field[y][x] == 0) continue;\nfor(i=y-1; i<=y+1; i++) {\nfor(j=x-1; j<=x+1; j++) {\nif(calculate(w,h,j,i) == 1) {\nmines[i][j] += 1;\n}\n}\n}\n}\n}\nfor(y=0; y<h; y++){\nfor(x=0; x<w; x++)\nprintf(\"%d\", mines[y][x]);\nprintf(\"\\n\");\n}\n}\nint calculate(w,h,j,i) {\nif (i >= 0 && i < h && j >= 0 && j < w) return 1;\nreturn 0;\n}\nColored by Color Scripter", "cs"]]}]','[{"local": "/images/questions/q_181_1.png", "remote": "https://blog.kakaocdn.net/dna/cCbUxZ/btsC34D6MjF/AAAAAAAAAAAAAAAAAAAAAN7qlVhxL0nqGPbxmxuYzdCQqGFVUJi3FfPHHkScqCtR/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=SLUrUzFO%2FJdZr%2FSJM9yi1dWtebg%3D"}]','1, 1, 3, 2
3, 4, 5, 3
3, 5, 6, 4
3, 5, 5, 3','[C언어 실행 과정 분석]
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [1, 1, 3, 2
3, 4, 5, 3
3, 5, 6, 4
3, 5, 5, 3] 입니다.');
INSERT INTO "questions" VALUES(182,10,2,1,7,'핵심 용어 단답형','2. 아래 예시를 보고 관계 대수에 대한 기호를 작성하시오.','','','','[]','[{"local": "/images/questions/q_182_1.png", "remote": "https://blog.kakaocdn.net/dna/AToWM/btsC4w1uWTW/AAAAAAAAAAAAAAAAAAAAABJT34k-xTyp8d65iUEZvWAeg8qXqajb-82iT-s0jC_f/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=yJ2MOyzTN4xe9d31K92NHO0Bi5Y%3D"}]','U, -, X, π, ⋈','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [U, -, X, π, ⋈] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(183,10,3,1,9,'괄호 빈칸 채우기형','3. 다음은 디자인 패턴에 대한 설명이다. 괄호안에 알맞는 답을 작성하시오.','(기호식 보기가 있습니다. ex: Abstract Factory, Mediator 등)
( 1 )은/는 기능을 처리하는 클래스와 구현을 담당하는 추상 클래스로 구별한다.
구현뿐 아니라 추상화도 독립적 변경이 필요할 때 브리지 패턴을 사용한다.
기존 시스템에 부수적인 새로운 기능들을 지속적으로 추가할 때 사용하면 유용하며,
새로운 인터페이스를 정의하여 기존 프로그램의 변경 없이 기능을 확장할 수 있다.
( 2 )은/는 한 객체의 상태가 변화하면 객체에 상속되어 있는 다른 객체들에게 변화된 상태를 전달해주는 패턴이다.
일대다 관계를 가지며, ​주로 분산된 시스템 간에 이벤트를 생성·발행(Publish)하고, 이를 수신(Subscribe)해야 할 때 이용한다.','','','[]','[]','1. Bridge
2. Observer','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. Bridge
2. Observer] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(184,10,4,1,6,'핵심 용어 단답형','4. 아래 코드에 대한 출력 값을 작성하시오.','','','','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16", "void main{\nint []result = int[5];\nint []arr = [77,32,10,99,50];\nfor(int i = 0; i < 5; i++) {\nresult[i] = 1;\nfor(int j = 0; j < 5; j++) {\nif(arr[i] <arr[j]) result[i]++;\n}\n}\nfor(int k = 0; k < 5; k++) {\nprintf(result[k]);\n}\n}\nColored by Color Scripter", "cs"]]}]','[]','24513','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [24513] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(185,10,5,1,5,'핵심 용어 단답형','5. 아래 코드에 대한 출력 값을 작성하시오.','첫번째 네트워크 주소가 192.168.1.0/24일때 FLSM 3개로 분할했을때
두번째 네트워크 브로드캐스드 IP를 10진수로 변환한 값을 작성하시오.','','','[]','[]','192.168.1.127','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [192.168.1.127] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(186,10,6,1,6,'보기·기호 선택형','6. 아래 표를 확인하여 보기에 알맞는 값을 고르시오.','(기호식 보기가 있습니다. ex: Boundary Value Partitioning​, Equivalence Partitioning 등)','','','[]','[{"local": "/images/questions/q_186_1.png", "remote": "https://blog.kakaocdn.net/dna/cqQGyy/btsCZgMmZH6/AAAAAAAAAAAAAAAAAAAAAJpxkYDyTwSJZWp3PJ1nhcodZkfZPJ2wgmtApb1o0Ohu/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=a6GgtKB6VqTf0Z%2BmYMTWFUhBTro%3D"}, {"local": "/images/questions/q_186_2.png", "remote": "https://blog.kakaocdn.net/dna/behP47/btsC4aYxDRn/AAAAAAAAAAAAAAAAAAAAAMP0Nd1uVYkOwjjhSTrgxJttP24v6ZBmnUrXyMzo4295/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=A93WBxvEa04gh1O4tprJJ0K4wjY%3D"}]','Boundary Value Analysis','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Boundary Value Analysis] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(187,10,7,1,18,'핵심 용어 단답형','7. 아래 데이터 명령어를 적용할 경우 알맞는 출력값을 작성하시오.​','​
​','','','[]','[{"local": "/images/questions/q_187_1.png", "remote": "https://blog.kakaocdn.net/dna/H8BvW/btsCX4kLwNa/AAAAAAAAAAAAAAAAAAAAAE1yuWHODH-48-95pyCaufeZeUiGHPPZ5mZ9B1sciVLd/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=0hHfd9i8cFQX1UhEQCuHJUp%2F3ZI%3D"}]','(1). 3
(2). 4','[운영체제(명령어/기초) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1). 3
(2). 4] 입니다.
• 학습 가이드: [운영체제(명령어/기초)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(188,10,8,1,8,'핵심 용어 단답형','8. 아래 설명에 대한 알맞는 답을 작성하시오.','( 1 ) 은/는 보안학적 측면에서 기술적인 방법이 아닌 사람들간의 기본적인 신뢰를 기반으로 사람을 속여 비밀 정보를 획득하는 기법이다.
( 2 ) 은/는 빅데이터(Big Data)와 비슷하면서도 구조화돼 있지 않고, 더는 사용하지 않는 ‘죽은’ 데이터를 의미한다. 일반적으로 정보를 수집해 저장한 이후 분석이나 특별한 목적을 위해 활용하는 데이터가 아니며, 저장공간만 차지하고 이러한 이유로 심각한 보안 위험을 초래할 수 있다.','','','[]','[]','1. 사회공학
2. 다크 데이터','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 사회공학
2. 다크 데이터] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(189,10,9,2,4,'코드 출력 결과형','9. 다음 파이썬 코드에 대한 출력값을 작성하시오.','','','python','[{"type": "grid", "rows": [["1\n2\n3\n4", "TestList = [1,2,3,4,5]\nTestList = list(map(lambda num : num + 100, TestList)))\nprint(TestList)\nColored by Color Scripter", "cs"]]}]','[]','[101,102,103,104,105]','[Python 코드 실행 과정 분석]
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [[101,102,103,104,105]] 입니다.');
INSERT INTO "questions" VALUES(190,10,10,1,5,'괄호 빈칸 채우기형','10. 다음 보안 관련 설명으로 가장 알맞는 용어를 작성하시오.','( ) 은/는 머신러닝 기술을 이용하여 IT 시스템에서 발생하는 대량의 로그를 통합관리 및 분석하여 사전에 위협에 대응하는 보안 솔루션이다.
서로 다른 기종의 보안솔루션 로그 및 이벤트를 중앙에서 통합 수집하여 분석할 수 있으며, 네트워크 상태의 monitoring 및 이상징후를 미리 감지할 수 있다.
네트워크 이기종 장비 간 로그의 상관관계 분석
이상징후의 행위 기반 및 문맥 기반 분석 기능
각 로그의 상관관계를 조건식에 따라 검색하여 분석이 가능
이벤트 및 로그의 이상패턴을 인식해 잠재적 위협이 발생시 알림 기능','','','[]','[]','SIEM','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [SIEM] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(191,10,11,1,16,'보기·기호 선택형','11. 다음 보기 중, 형상 관리 항목을 3가지 고르시오.','','','','[]','[{"local": "/images/questions/q_191_1.png", "remote": "https://blog.kakaocdn.net/dna/yWgMF/btsC4De589v/AAAAAAAAAAAAAAAAAAAAAPtgmsvQa36FmeLFxVyEJEZMT8d3rsalCshpAMg2EzXN/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=FlQTmmPO9CmGl9cYef4PVwS9htY%3D"}]','CVS, SVN, GIT','[소프트웨어 공학/방법론 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [CVS, SVN, GIT] 입니다.
• 학습 가이드: [소프트웨어 공학/방법론] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(192,10,12,2,3,'SQL 결과 도출형','12. STUDENT 테이블에서 컴퓨터과 학생 50명, 전기과 학생 100명, 인터넷과 학생 50명의 정보가 저장되어 있을 때, 다음 SQL문의 실행 결과에 따른 튜플의 수는? (단, DEPT 칼럼은 학과명이다.)','','1) SELECT DERP FROM STUDENT;
2) SELECT DISTINCT DEPT FROM STUDENT;
3) SELECT COUNT(DISTINCT DEPT) FROM STUDENT WHERE DEPT = ''인터넷과'';','sql','[]','[]','1) 200
2) 3
3) 1','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1) 200
2) 3
3) 1] 입니다.');
INSERT INTO "questions" VALUES(193,10,13,1,6,'핵심 용어 단답형','13. 다음 코드에 대한 출력 값을 작성하시오.','','','','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19", "int n;\nint k;\nint s;\nint el = 0;\nfor(n=6; n<=30; n++){\ns=0;\nk=n/2;\nfor(int j=1; j<=k; j++){\nif(n%j==0){\ns=s+j;\n}\n}\nif(s==n){\nel++;\n}\n}\nprintf(\"%d\", el);", "cs"]]}]','[]','2','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [2] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(194,10,14,1,7,'보기·기호 선택형','14. 아래 설명에 대하여 알맞는 답을 보기에서 고르시오.','(기호식 보기가 있습니다. ex: CSRF 등)
( 1 )은/는 프로세서(processor) 안에 독립적인 보안 구역을 따로 두어 중요한 정보를 보호하는 ARM사에서 개발한 하드웨어 기반의 보안 기술로 프로세서(processor) 안에 독립적인 보안 구역을 별도로 하여, 중요한 정보를 보호하는 하드웨어 기반의 보안 기술이다.
( 2 )은/는 사용자들이 사이트에 접속할 때 주소를 잘못 입력하거나 철자를 빠뜨리는 실수를 이용하기 위해 유사한 유명 도메인을 미리 등록하는 일로 URL 하이재킹(hijacking)이라고도 한다.','','','[]','[]','1. Trustzone
2. typosquatting','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. Trustzone
2. typosquatting] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(195,10,15,1,6,'괄호 빈칸 채우기형','15. 아래 설명에 대하여 알맞는 용어를 작성하시오.','( )은/는 여러 개의 사이트에서 한번의 로그인으로 여러가지 다른 사이트들을 자동적으로 접속하여 이용하는 방법을 말한다. 일반적으로 서로 다른 시스템 및 사이트에서 각각의 사용자 정보를 관리하게 되는데 이때 하나의 사용자 정보를 기반으로 여러 시스템을 하나의 통합 인증을 사용하게 하는 것을 말한다.
즉 하나의 시스템에서 인증을 할 경우 타 시스템에서는 인증 정보가 있는지 확인하고 있으면 로그인 처리를 하도록 하고, 없는 경우 다시 통합 인증을 할 수 있도록 만드는 것을 의미한다.','','','[]','[]','SSO','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [SSO] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(196,10,16,1,12,'괄호 빈칸 채우기형','16. 다음은 스케줄링에 관한 내용이다. 괄호안에 알맞는 답을 작성하시오.','','','','[]','[{"local": "/images/questions/q_196_1.png", "remote": "https://blog.kakaocdn.net/dna/bQsUms/btsC2x0JYh0/AAAAAAAAAAAAAAAAAAAAAItpqpYUHQqLDi2XYJ8MYUqmIy4FQgZub0VkX4CfK8se/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=wLg%2B6PTCunCFXlMQFYAtDQnvVgw%3D"}]','SJF, RR, SRT','[운영체제(스케줄링/메모리) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [SJF, RR, SRT] 입니다.
• 학습 가이드: [운영체제(스케줄링/메모리)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(197,10,17,1,11,'괄호 빈칸 채우기형','17. 다음은 UML에 관한 설명이다. 괄호안에 알맞는 답을 작성하시오.','UML은 통합 모델링 언어로써, 시스템을 모델로 표현해주는 대표적인 모델링 언어이다.
구성 요소로는 사물, ( 1 ), 다이어그램으로 이루어져 있으며, 구조 다이어그램 중, ( 2 ) 다이어그램은 시스템에서 사용되는 객체 타입을 정의하고, 그들 간의 존재하는 정적인 관계를 다양한 방식으로 표현한 다이어그램이다.
또한 UML 모델링에서 ( 3 )은/는 클래스와 같은 기타 모델 요소 또는 컴포넌트가 구현해야 하는 오퍼레이션 세트를 정의하는 모델 요소이다.','','','[]','[]','1. 관계
2. 클래스
3. 인터페이스','[요구사항/UML/설계 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 관계
2. 클래스
3. 인터페이스] 입니다.
• 학습 가이드: [요구사항/UML/설계] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(198,10,18,1,11,'괄호 빈칸 채우기형','18. 다음은 E-R다이어그램에 관한 설명이다. 괄호 안에 알맞는 답을 작성하시오.','(아래 그래프 기호는 정확히 기억이 나지 않아 임의로 작성한 것이니 참고만 해주세요.)
( 1 ) : 개체집합 - 관계집합 연결
( 2 ) : 개체 집합과의 연결
( 3 ) : 관계집합 - 관계집합의 속성 연결
( 4 ) : 두 개체집합 관계에서 생성되는 값을 저장하는 속성
( 5 ) : 같은 속성을 공유하는 개체들의 모임','','','[]','[{"local": "/images/questions/q_198_1.png", "remote": "https://blog.kakaocdn.net/dna/tLYA3/btsC4KeezeX/AAAAAAAAAAAAAAAAAAAAAG7YB91wu6Cls8kiwkbB6Ni5df0SysazYiNsMSZ9c0p6/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=F%2BgDMsIfPA5rvGTPhb7pddkdmE8%3D"}]','1. 실선 (ㄷ)
2. 관계집합 (ㅂ)
3. 점선 (ㄹ)
4. 관계집합의 속성 (ㄴ)
5. 개체집합 (ㄱ)','[요구사항/UML/설계 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 실선 (ㄷ)
2. 관계집합 (ㅂ)
3. 점선 (ㄹ)
4. 관계집합의 속성 (ㄴ)
5. 개체집합 (ㄱ)] 입니다.
• 학습 가이드: [요구사항/UML/설계] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(199,10,19,2,2,'코드 출력 결과형','19. 다음 자바 코드에 대한 출력 값을 작성하시오.','','','java','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22", "public class Main {\nstatic int[] MakeArray(){\nint[] tempArr = new int[4];\nfor(int i=0; i<tempArr.Length;i++){\ntempArr[i] = i;\n}\nreturn tempArr;\n}\npublic static void main(String[] args){\nint[] intArr;\nintArr = MakeArray();\nfor(int i=0; i < intArr.Length; i++)\nSystem.out.print(intArr[i]);\n}\n}\nColored by Color Scripter", "cs"]]}]','[]','0123','[Java 객체지향 실행 과정 분석]
• System.out 출력문에 의해 최종 도출되는 결과값은 [0123] 입니다.');
INSERT INTO "questions" VALUES(200,10,20,2,2,'코드 출력 결과형','20. 다음 자바 코드에 대한 출력 값을 작성하시오.','','','java','[{"type": "grid", "rows": [["1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11", "public class Exam {\npublic static void main(String[] args){\nint a = 0;\nfor(int i=1; i<999; i++){\nif(i%3==0 && i%2!=0)\na = i;\n}\nSystem.out.print(a);\n}\n}\nColored by Color Scripter", "cs"]]}]','[]','993','[Java 객체지향 실행 과정 분석]
• System.out 출력문에 의해 최종 도출되는 결과값은 [993] 입니다.');
INSERT INTO "questions" VALUES(201,11,1,2,2,'코드 출력 결과형','1. 다음 Java 코드에서 알맞는 출력 값을 작성하시오.','','class Connection {

    private static Connection _inst = null;
    private int count = 0;

    static public Connection get() {
        if(_inst == null) {
            _inst = new Connection();
            return _inst;
        }
        return _inst;
    }

    public void count() {
         count++;
    }

    public int getCount() {
         return count;
    }
}


public class main {

    public static void main(String[] args) {

        Connection conn1 = Connection.get();
        conn1.count();

        Connection conn2 = Connection.get();
        conn2.count();

        Connection conn3 = Connection.get();
        conn3.count();

        conn1.count();
        System.out.print(conn1.getCount());
    }

}','java','[]','[]','4','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [4] 입니다.');
INSERT INTO "questions" VALUES(202,11,2,2,1,'코드 출력 결과형','2. 다음 C언어 코드에서 알맞는 출력 값을 작성하시오.','','#include <stdio.h>

int main() {

    int v1 = 0, v2 = 35, v3 = 29;

    if(v1 > v2 ? v2 : v1) {
        v2 = v2 << 2;
    }else{
        v3 = v3 << 2;
    }

    printf("%d", v2+v3);

}','c','[]','[]','151','[C언어 실행 과정 분석]
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [151] 입니다.');
INSERT INTO "questions" VALUES(203,11,3,1,14,'보기·기호 선택형','3. 다음은 응집도와 관련해서 보기에서 응집도가 높은 순으로 나열하시오.','보기','','','[{"type": "box", "content": "ㄱ. 기능 ㄴ. 교환 ㄷ. 우연 ㄹ. 시간"}]','[]','ㄱ, ㄴ, ㄹ, ㄷ','[결합도/응집도 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄱ, ㄴ, ㄹ, ㄷ] 입니다.
• 학습 가이드: [결합도/응집도] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(204,11,4,2,1,'코드 출력 결과형','4. 다음은 C언어에 대한 문제이다. 알맞는 출력 값을 작성하시오.','','#include <stdio.h>
#include <string.h>

void reverse(char* str){
    int len = strlen(str);
    char temp;
    char*p1 = str;
    char*p2 = str + len - 1;
    while(p1<p2){
        temp = *p1;
        *p1 = *p2;
        *p2 = temp;
        p1++;
        p2--;
    }
}

int main(int argc, char* argv[]){
    char str[100] = "ABCDEFGH";

    reverse(str);

    int len = strlen(str);

    for(int i=1; i<len; i+=2){
        printf("%c",str[i]);
    }

    printf("\n");

    return 0;

}','c','[]','[]','GECA','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [GECA] 입니다.');
INSERT INTO "questions" VALUES(205,11,5,1,5,'수식·계산 도출형','5. 아래 그림에서의 네트워크에서 라우터을 통한 할당 가능한 2번, 4번, 5번의 IP를 작성하시오.','1) 192.168.35.3/24
3) 129.200.10.16/22
6) 192.168.36.24/24
보기
192.168.35.0
192.168.35.72
192.168.36.0
192.168.36.249
129.200.8.0
129.200.8.249','','','[]','[{"local": "/images/questions/q_205_1.png", "remote": "https://blog.kakaocdn.net/dna/bHTbEI/btsHqLsBYPd/AAAAAAAAAAAAAAAAAAAAAIMm2bQrfA7pDuPPzWrNJY_wzyMU_mYXW-zf3w4iVs4z/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=tOfy1Rxm0UBE%2Fc%2BHlrN5supoTmA%3D"}]','2)192.168.35.72
4)129.200.8.249
5)192.168.36.249','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [2)192.168.35.72
4)129.200.8.249
5)192.168.36.249] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(206,11,6,1,13,'핵심 용어 단답형','6. 아래 표에서 나타나고 있는 정규형을 작성하시오.','','','','[{"type": "grid", "rows": [["고객아이디", "강좌명", "강사번호"], ["apple", "영어회화", "P001"], ["banana", "기초토익", "P002"], ["carrot", "영어회화", "P001"], ["carrot", "기초토익", "P004"], ["orange", "영어회화", "P003"], ["orange", "기초토익", "P004"]]}]','[]','제 3정규형','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [제 3정규형] 입니다.
• 학습 가이드: [데이터베이스(설계/정규화)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(207,11,7,1,5,'핵심 용어 단답형','7. 아래의 내용에서 설명하는 네트워크 용어를 영문 약자로 작성하시오.','1. 대표적인 링크 상태 라우팅 프로토콜이다. 이것은 인터넷에서 연결된 링크의 상태를 감시하여 최적의 경로를 선택한다는것이다.
2. 단일 자율 시스템 내에서 라우팅 정보를 배포하는 데 사용되는 내부 게이트웨이 프로토콜이다.
3. 모든 대상에 도달하기 위한 최단 경로를 구축하고 계산하며 최단 경로는 Dijkstra 알고리즘을 사용하여 계산된다.','','','[]','[]','OSPF (Open Shortest Path First)','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [OSPF (Open Shortest Path First)] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(208,11,8,1,7,'핵심 용어 단답형','8. 아래 내용의 각각의 설명에 대한 답을 작성하시오.','(1) 조인에 참여하는 두 릴레이션의 속성 값을 비교하여 조건을 만족하는 튜플만 반환한다.
(2) 조건이 정확하게 ''='' 등호로 일치하는 결과를 반환한다.
(3) ( (2) ) 조인에서 조인에 참여한 속성이 두 번 나오지 않도록 중복된 속성을 제거한 결과를 반환한다.','','','[]','[]','(1) 세타 조인
(2) 동등 조인
(3) 자연 조인','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) 세타 조인
(2) 동등 조인
(3) 자연 조인] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(209,11,9,1,12,'수식·계산 도출형','9. 다음은 운영체제 페이지 순서를 참고하여 할당된 프레임의 수가 3개일 때 LRU와 LFU 알고리즘의 페이지 부재 횟수를 작성하시오.','페이지 참조 순서 : 1, 2, 3, 1, 2, 4, 1, 2, 5, 7
(1) LRU :
(2) LFU :','','','[]','[]','(1) : 6
(2) : 6','[운영체제(스케줄링/메모리) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) : 6
(2) : 6] 입니다.
• 학습 가이드: [운영체제(스케줄링/메모리)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(210,11,10,2,2,'코드 출력 결과형','10. 아래 JAVA언어 코드의 실행 순서를 중복 번호없이 작성하시오.','실행 순서 : 5 → ( ) → ( ) → ( ) → ( ) → ( )','class Parent {
    int x, y;

    Parent(int x, int y) { ①
        this.x=x;
        this y=y;
    }

    int getT() { ②
        return x*y;
    }
}



​class Child extend Parent {
    int x;

    Child (int x) { ③
        super(x+1, x);
        this.x=x;
    }

    int getT(int n){ ④
        return super.getT()+n;
    }
}



class Main {
    public static void main(String[] args) { ⑤
        Parent parent = new Child(3); ⑥
        System.out.println(parent.getT()); ⑦
    }
}','java','[]','[]','6 3 1 7 2','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [6 3 1 7 2] 입니다.');
INSERT INTO "questions" VALUES(211,11,11,2,1,'코드 출력 결과형','11. 다음 C언어의 알맞는 출력값을 작성하시오.','','#include <stdio.h>


typedef struct{
    int accNum;
    double bal;
}BankAcc;



double sim_pow(double base, int year){
    int i;
    double r = 1.0;

    for(i=0; i<year; i++){
        r = r*base;
    }
    return r;
}



void initAcc(BankAcc *acc, int x, double y){
    acc -> accNum = x;
    acc -> bal = y;
}



void xxx(BankAcc *acc, double *en){
    if (*en > 0 && *en < acc -> bal) {
        acc -> bal = acc -> bal-*en;
    }else{
        acc -> bal = acc -> bal+*en;
    }
}



void yyy(BankAcc *acc){
    acc -> bal = acc -> bal * sim_pow((1+0.1),3);
}


int main(){

    BankAcc myAcc;
    initAcc(&myAcc, 9981, 2200.0);
    double amount = 100.0;
    xxx(&myAcc, &amount);
    yyy(&myAcc);
    printf("%d and %.2f", myAcc.accNum, myAcc.bal);
    return 0;

}','c','[]','[]','9981 and 2795.10','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [9981 and 2795.10] 입니다.');
INSERT INTO "questions" VALUES(212,11,12,2,4,'코드 출력 결과형','12. 다음 파이썬 코드에 대한 알맞는 출력 값을 작성하시오.','','a = ["Seoul", "Kyeonggi", "Incheon", "Daejun", "Daegu", "Pusan"]
str = "S"

for i in a:
    str = str + i[1]

print(str)','python','[]','[]','Seynaau','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [Seynaau] 입니다.');
INSERT INTO "questions" VALUES(213,11,13,2,3,'SQL 작성·빈칸형','13. 아래 보기의 SQL 문장과 테이블을 참고하여 출력 값을 표로 작성하시오.','보기','SELECT
    B
FROM
    R1
WHERE
    C IN (SELECT C FROM R2 WHERE D="k");','sql','[]','[{"local": "/images/questions/q_213_1.png", "remote": "https://blog.kakaocdn.net/dna/cdGyt7/btsHrT44l4V/AAAAAAAAAAAAAAAAAAAAAJ7pvKDZrvZliNMonxEJjJWyOPXgzfu0vTF8HJGlC8Gr/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=SmkWLqUPI67KVg0JqLvg27XVgnE%3D"}]','B
a
b','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [B
a
b] 입니다.');
INSERT INTO "questions" VALUES(214,11,14,1,10,'보기·기호 선택형','14. 아래는 애플리케이션 테스트 관리에 대한 내용이다. 설명하는 답을 보기에서 골라 작성하시오.','1. 모든 분기와 조건의 조합을 고려하나 모든 조합을 테스트하는 대신에 테스트가 필요한 중요한 조합을 찾아내는데에 중점을 둔다.
2. 특정 조건을 수행할 때 다른 조건과는 상관없이 전체 결과에 영향을 미치는 조건만을 테스트한다.
3. 각각의 파라미터는 적어도 한 번은 최종 결과에 영향을 주어야 한다.
보기
ㄱ. 구문 커버리지 ㄴ. 결정 커버리지 ㄷ. 조건 커버리지 ㄹ. 변경 조건/결정 커버리지 ㅁ.다중 조건 커버리지 ㅂ.경로 커버리지 ㅅ.조건/결정 커버리지','','','[]','[]','ㄹ.변경 조건/결정 커버리지','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄹ.변경 조건/결정 커버리지] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(215,11,15,1,8,'보기·기호 선택형','15. 다음 아래 내용을 보고 보기에서 알맞는 용어를 골라 작성하시오.','인터넷 공격자의 존재를 숨기면서 이 공격자에게 시스템에 대한 무제한 접근 권한을 부여하는 악성 프로그램이다.
해커가 자신의 존재를 숨기면서 허가되지 않은 컴퓨터나 소프트웨어에 접근할 수 있도록 설계된 도구이다.
일반적으로 펌웨어, 가상화 계층 등의 다양한 시스템 영역에서 작동하며, 운영체제의 시스템콜을 해킹하여 악성코드의 실행여부를 숨겨 안티바이러스 탐지를 우회할 수 있다.
보기','','','[{"type": "box", "content": "ㄱ.Worm ㄴ.Trojan horse ㄷ.Backdoor ㄹ.Virus ㅁ.Ransomware ㅂ.Spyware ㅅ.Rootkit"}]','[]','ㅅ','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㅅ] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(216,11,16,2,2,'코드 출력 결과형','16. 다음 Java 코드를 보고 알맞는 출력 값을 작성하시오.','','class classOne {
    int a, b;

    public classOne(int a, int b) {
        this.a = a;
        this.b = b;
    }

    public void print() {
        System.out.println(a + b);
    }

}
class classTwo extends classOne {
    int po = 3;

    public classTwo(int i) {
        super(i, i+1);
    }

    public void print() {
        System.out.println(po*po);
    }
}

public class main {
    public static void main(String[] args) {
        classOne one = new classTwo(10);
        one.print();
    }
}','java','[]','[]','9','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [9] 입니다.');
INSERT INTO "questions" VALUES(217,11,17,1,8,'보기·기호 선택형','17. 다음 아래 내용을 보고 보기에서 알맞는 용어를 골라 작성하시오.','1. 불특정 다수가 아닌 명확한 표적을 정하여 지속적인 정보수집 후 공격감행할 수 있다.
2. 시스템에 직접 침투하는 것뿐 아니라 표적 내부직원들이 이용하는 다양한 단말을 대상으로 한다.
3. 한가지 기술만이 아닌 Zero-day 취약점, 악성코드 등 다양한 보안 위협 공격 기술을 사용한다.
4. 일반적으로 공격은 침투, 검색, 수집 및 유출의 4단계로 실행되며, 각 단계별로 다양한 공격 기술을 사용한다.
보기','','','[{"type": "box", "content": "ㄱ.사회공학 기법 ㄴ.Adware ㄷ.MITM ㄹ.XDR ㅁ.Replace attack ㅂ.key logger attack ㅅ.APT"}]','[]','ㅅ','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㅅ] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(218,11,18,2,3,'SQL 작성·빈칸형','18. 아래의 SQL 코드와 테이블을 참고하여 결과 값을 작성하시오.','','SELECT
    COUNT(*)
FROM
    TABLE
WHERE
    EMPNO > 100
AND
    SAL >= 3000 OR EMPNO = 200','sql','[]','[{"local": "/images/questions/q_218_1.png", "remote": "https://blog.kakaocdn.net/dna/dR34LK/btsHqjES9Ot/AAAAAAAAAAAAAAAAAAAAAF89NFObm5YWW0w5qpXaAW3PMG8OFFO8H7eBSDJRlOnx/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=dhaq7qNe5WD82z8%2FlxLQ3P5Z7wo%3D"}]','1','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1] 입니다.');
INSERT INTO "questions" VALUES(219,11,19,2,1,'코드 출력 결과형','19. 다음 C언어 코드의 알맞는 출력 값을 작성하시오.','','#include<stdio.h>
#include<ctype.h>

int main(){
    char*p = "It is 8";
    char result[100];
    int i;

    for(i=0; p[i]!=''\0''; i++){
        if(isupper(p[i]))
            result[i] = (p[i]-''A''+5)% 25 + ''A'';
        else if(islower(p[i]))
            result[i] = (p[i]-''a''+10)% 26 + ''a'';
        else if(isdigit(p[i]))
            result[i] = (p[i]-''0''+3)% 10 + ''0'';
        else if(!(isupper(p[i]) || islower(p[i]) || isdigit(p[i])))
            result[i] = p[i];
    }

    result[i] = ''\0'';
    printf("%s\n",result);

    return 0;
}','c','[]','[]','Nd sc 1','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [Nd sc 1] 입니다.');
INSERT INTO "questions" VALUES(220,11,20,1,9,'핵심 용어 단답형','20. 다음 아래의 내용을 보고 알맞는 용어를 작성하시오.','구체적인 클래스에 의존하지 않고 서로 연관되거나 의존적인 객체들의 조합을 만드는 인터페이스를 제공하는 패턴이다.
연관성이 있는 객체 군이 여러개 있을 경우 이들을 묶어 추상화하고, 어떤 구체적인 상황이 주어지면 팩토리 객체에서 집합으로 묶은 객체 군을 구현화 하는 생성 패턴이다
관련성 있는 여러 종류의 객체를 일관된 방식으로 생성하는 경우에 유용하다.
kit라고도 불린다.','','','[]','[]','Abstract Factory','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Abstract Factory] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(221,12,1,2,2,'코드 출력 결과형','1. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class Main {
    public static void main(String[] args) {
        int[] a = new int[]{1, 2, 3, 4};
        int[] b = new int[]{1, 2, 3, 4};
        int[] c = new int[]{1, 2, 3};

        check(a, b);
        check(a, c);
        check(b, c);
    }

    public static void check(int[] a, int[] b) {
        if (a==b) {
            System.out.print("O");
        }else{
            System.out.print("N");
        }

    }
}','java','[]','[]','NNN','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [NNN] 입니다.');
INSERT INTO "questions" VALUES(222,12,2,1,7,'핵심 용어 단답형','2. 다음 문제에서 설명하는 용어를 작성하시오.','데이터를 중복시켜 성능을 향상시키기 위한 기법으로 데이터를 중복 저장하거나
테이블을 합치는 등으로 성능을 향상시키지만 데이터 무결성이 저하될 수 있는 기법','','','[]','[]','반정규화','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [반정규화] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(223,12,3,2,3,'SQL 작성·빈칸형','3. 다음은 SQL에 관한 문제이다. 아래 SQL 구문의 빈칸을 작성하시오.','테이블
사원 [사원번호(PK), 이름, 나이, 부서]
부서 [사원번호(PK), 이름, 주소, 나이]
신입 사원이 들어와서 사원 테이블에 추가','INSERT INTO 사원 (사원번호, 이름, 주소, 부서) [ ① ] (32431, ''정실기'', ''서울'', ''영업'');
위에 신입사원을 검색하면서 부서 테이블에 추가
INSERT INTO 부서 (사원번호, 이름, 나이, 부서)
[ ② ] 사원번호, 이름, 나이, 23 FROM 사원 WHERE 이름 = ''정실기'';
전체 사원 테이블 조회
SELECT * [ ③ ] 사원;
퇴사로 인해 부서에 해당하는 값을 ''퇴사''로 변경
UPDATE 사원 [ ④ ] 부서 = ''퇴사'' WHERE 사원번호 = 32431;','sql','[]','[]','① : VALUES
② : SELECT
③ : FROM
④ : SET','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [① : VALUES
② : SELECT
③ : FROM
④ : SET] 입니다.');
INSERT INTO "questions" VALUES(224,12,4,1,7,'핵심 용어 단답형','4. 다음 릴레이션의 Cardinality와 Degree를 작성하시오.','Cardinality : ( ① )
Degree : ( ② )','','','[]','[{"local": "/images/questions/q_224_1.png", "remote": "https://blog.kakaocdn.net/dna/9GCnk/btsIQHjwfX4/AAAAAAAAAAAAAAAAAAAAAFcwOwpSbNpVcvUGl9r3CTTjPEncjPAQEPGf6rQv7RxE/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=q%2BGLlXPZakyM5YJmkhhhUtyvIyQ%3D"}]','① : 5
② : 4','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [① : 5
② : 4] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(225,12,5,1,5,'핵심 용어 단답형','5. 다음은 프로토콜에 대한 내용이다. 아래 내용을 읽고 알맞는 답을 작성하시오.','- Network layer에서 IP패킷을 암호화하고 인증하는 등의 보안을 위한 표준이다.
- 기업에서 사설 인터넷망으로 사용할 수 있는 VPN을 구현하는데 사용되는 프로토콜이다.
- AH(Authentication Header)와 ESP(Encapsulating Security Payload)라는 두 가지 보안 프로토콜을 사용한다.','','','[]','[]','IPSec','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [IPSec] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(226,12,6,2,4,'코드 출력 결과형','6. 다음은 Python에 대한 문제이다. 아래 코드를 읽고 알맞는 출력 값을 작성하시오.','','def fnCalculation(x,y):
    result = 0;
    for i in range(len(x)):
     temp = x[i:i+len(y)]
     if temp == y:
       result += 1;
    return result

a = "abdcabcabca"
p1 = "ab";
p2 = "ca";

out = f"ab{fnCalculation(a,p1)}ca{fnCalculation(a,p2)}"
print(out)','python','[]','[]','ab3ca3','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [ab3ca3] 입니다.');
INSERT INTO "questions" VALUES(227,12,7,1,8,'핵심 용어 단답형','7. 아래 설명하는 내용을 확인하여 알맞는 알고리즘을 작성하시오.','- 대칭키 알고리즘으로 1997년 NIST(미국 국립기술표준원)에서 DES를 대체하기 위해 생성되었다.
- 128비트, 192비트 또는 256비트의 가변 키 크기와 128비트의 고정 블록 크기를 사용한다.
- 높은 안전성과 효율성, 속도 등으로 인해 DES 대신 전 세계적으로 많이 사용되고 있다.','','','[]','[]','AES','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [AES] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(228,12,8,1,5,'핵심 용어 단답형','8. 패킷 교환 방식 중에 연결형과 비연결형에 해당하는 방식을 작성하시오.','① 연결형 교환 방식
② 비연결형 교환 방식','','','[]','[]','① 가상회선
② 데이터그램','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [① 가상회선
② 데이터그램] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(229,12,9,1,6,'보기·기호 선택형','9. 아래 내용을 확인하고 보기에서 알맞는 답을 고르시오.','실행 순서가 밀접한 관계를 갖는 기능을 모아 모듈로 구성한다.
한 모듈 내부의 한 기능 요소에 의한 출력 자료가 다음 기능 원소의 입력 자료로서 제공되는 형태이다.
보기
ㄱ. 기능적(functional) ㄴ. 우연적(Coincidental) ㄷ. 통신적(Communication) ㄹ. 절차적(Procedural) ㅁ. 시간적(Temporal) ㅂ. 순차적(sequential) ㅅ. 논리적(Logical)','','','[]','[]','ㅂ','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㅂ] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(230,12,10,1,9,'보기·기호 선택형','10. 아래는 디자인 패턴에 관한 설명이다. 아래 설명을 읽고 보기에서 알맞는 용어를 작성하시오.','- 컬렉션 객체의 내부 구조를 노출하지 않고 순차적으로 접근할 수 있게 하는 패턴이다.
- 이 패턴은 객체의 내부 표현 방식에 독립적으로 요소에 접근할 수 있도록 해준다
- 반복 프로세스를 캡슐화하여 클라이언트 코드에서는 컬렉션의 구체적인 구현에 종속되지 않도록 한다.
보기','','','[{"type": "grid", "rows": [["생성패턴", "구조패턴", "행위패턴"], ["Singleton", "Adapter", "Iterator"], ["Factory Method", "Bridge", "Visitor"], ["Abstract Factory", "Composite", "Observer"]]}]','[]','Iterator','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Iterator] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(231,12,11,1,5,'핵심 용어 단답형','11. 아래 그림을 바탕으로 RIP을 구성하여 최단 경로 비용을 계산하여 흐름에 맞게 작성하시오.','예제
A →','','','[]','[{"local": "/images/questions/q_231_1.png", "remote": "https://blog.kakaocdn.net/dna/bDn5o2/btsIQLTXSHe/AAAAAAAAAAAAAAAAAAAAAJFzRUUsEI7beM5FTIMGSH1FCvW-dE-ni6ipmIyST9YZ/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=24rnW70c%2BmrnHS2D3bZtpwpQtGE%3D"}]','A → D → C → F','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [A → D → C → F] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(232,12,12,1,12,'수식·계산 도출형','12. 아래의 표를 확인하여 SRT 스케줄링의 평균 대기시간을 계산하여 작성하시오.','','','','[{"type": "grid", "rows": [["프로세스", "도착 시간", "서비스 시간"], ["A", "0", "8"], ["B", "1", "4"], ["C", "2", "9"], ["D", "3", "5"]]}]','[]','6.5','[운영체제(스케줄링/메모리) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [6.5] 입니다.
• 학습 가이드: [운영체제(스케줄링/메모리)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(233,12,13,2,1,'코드 출력 결과형','13. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

int main() {
    int arr[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    int* parr[2] = {arr[1], arr[2]};
    printf("%d", parr[1][1] + *(parr[1]+2) + **parr);

    return 0;
}','c','[]','[]','21','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [21] 입니다.');
INSERT INTO "questions" VALUES(234,12,14,2,2,'코드 출력 결과형','14. 다음은 Java 언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class Main {
    public static void main(String[] args) {
        int a[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
        ODDNumber OE = new ODDNumber();
        System.out.print(OE.sum(a, true) + ", " + OE.sum(a, false));
    }
}

interface Number {
    int sum(int[] a, boolean odd);
}

class ODDNumber implements Number {
    public int sum(int[] a, boolean odd) {
        int result = 0;
        for(int i=0; i < a.length; i++){
            if((odd && a[i] % 2 != 0) || (!odd && a[i] % 2 == 0))
                result += a[i];
        }
        return result;
    }
}','java','[]','[]','25, 20','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [25, 20] 입니다.');
INSERT INTO "questions" VALUES(235,12,15,2,1,'코드 출력 결과형','15. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>
#include <string.h>

void sumFn(char* d, const char* s) {

    while (*s) {
        *d = *s;
        d++;
        s++;
    }
    *d = ''\0'';
}

int main() {
   const char* str1 = "first";
    char str2[50] = "teststring";
    int result=0;
    sumFn(str2, str1);

    for (int i = 0; str2[i] != ''\0''; i++) {
        result += i;
    }
    printf("%d", result);

    return 0;
}','c','[]','[]','10','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [10] 입니다.');
INSERT INTO "questions" VALUES(236,12,16,1,14,'괄호 빈칸 채우기형','16. 아래는 소프트웨어 설계에 대한 내용이다. 내용을 읽고 괄호안에 알맞는 답을 작성하시오.','- 어떤 모듈이 다른 모듈 내부의 논리적인 흐름을 제어하기 위해, 제어를 통신하거나 제어 요소를 전달하는 결합도이다.
- 한 모듈이 다른 모듈의 상세한 처리 절차를 알고 있어 이를 통제하는 경우나 처리 기능이 두 모듈에 분리되어 설계된 경우에 발생한다.
( ) Coupling','','','[]','[]','제어 or Control','[결합도/응집도 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [제어 or Control] 입니다.
• 학습 가이드: [결합도/응집도] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(237,12,17,2,2,'코드 출력 결과형','17. 다음은 Java에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력 값을 작성하시오.','','class Main {
    public static void main(String[] args) {
        String str = "abacabcd";
        boolean[] seen = new boolean[256];
        System.out.print(calculFn(str, str.length()-1, seen));
    }

    public static String calculFn(String str, int index, boolean[] seen) {
        if(index < 0) return "";
        char c = str.charAt(index);
        String result = calculFn(str, index-1, seen);
        if(!seen[c]) {
            seen[c] = true;
            return c + result;
        }
        return result;
    }
}','java','[]','[]','dcba','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [dcba] 입니다.');
INSERT INTO "questions" VALUES(238,12,18,2,1,'코드 출력 결과형','18. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력 값을 작성하시오.','','#include <stdio.h>

void swap(int a, int b) {
    int t = a;
    a = b;
    b = t;
}

int main() {

    int a = 11;
    int b = 19;
    swap(a, b);

    switch(a) {
        case 1:
            b += 1;
        case 11:
            b += 2;
        default:
            b += 3;
        break;
    }

    printf("%d", a-b);
}','c','[]','[]','-13','[C언어 실행 과정 분석]
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [-13] 입니다.');
INSERT INTO "questions" VALUES(239,12,19,2,1,'코드 출력 결과형','19. 다음은 C언어의 구조체에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력 값을 작성하시오.','','#include <stdio.h>

struct node {
    int n1;
    struct node *n2;
};

int main() {

    struct node a = {10, NULL};
    struct node b = {20, NULL};
    struct node c = {30, NULL};

    struct node *head = &a;
    a.n2 = &b;
    b.n2 = &c;

    printf("%d\n", head->n2->n1);

    return 0;
}','c','[]','[]','20','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [20] 입니다.');
INSERT INTO "questions" VALUES(240,12,20,2,2,'코드 출력 결과형','20. 다음은 Java에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력 값을 작성하시오.','','class Main {
    public static void main(String[] args) {
        String str = "ITISTESTSTRING";
        String[] result = str.split("T");
        System.out.print(result[3]);
    }
}','java','[]','[]','S','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [S] 입니다.');
INSERT INTO "questions" VALUES(241,13,1,2,2,'코드 출력 결과형','1. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main{
  static String[] s = new String[3];

  static void func(String[]s, int size){
    for(int i=1; i<size; i++){
      if(s[i-1].equals(s[i])){
        System.out.print("O");
      }else{
        System.out.print("N");
      }
    }
      for (String m : s){
        System.out.print(m);
      }
    }


  public static void main(String[] args){
    s[0] = "A";
    s[1] = "A";
    s[2] = new String("A");

    func(s, 3);
  }
}','java','[]','[]','OOAAA','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [OOAAA] 입니다.');
INSERT INTO "questions" VALUES(242,13,2,2,4,'코드 출력 결과형','2. 다음은 파이썬에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','def func(lst):
  for i in range(len(lst) //2):
    lst[i], lst[-i-1] = lst[-i-1], lst[i]

lst = [1,2,3,4,5,6]
func(lst)
print(sum(lst[::2]) - sum(lst[1::2]))','python','[]','[]','3','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [3] 입니다.');
INSERT INTO "questions" VALUES(243,13,3,2,3,'SQL 작성·빈칸형','3. 아래의 employee테이블과 project테이블을 참고하여 보기의 SQL명령어에 알맞는 출력 값을 작성하시오.','보기','SELECT
    count(*)
FROM employee AS e JOIN project AS p ON e.project_id = p.project_id
WHERE p.name IN (
    SELECT name FROM project p WHERE p.project_id IN (
        SELECT project_id FROM employee GROUP BY project_id HAVING count(*) < 2
    )
);','sql','[]','[{"local": "/images/questions/q_243_1.png", "remote": "https://blog.kakaocdn.net/dna/9Duij/btsKhmXLACx/AAAAAAAAAAAAAAAAAAAAAJ7Z6wb65tBG8qfWhrB_xN_Eay6h24r_fPFYzm7NtBE5/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=py3M8gPVgARfSsFupUcEtpPeFbA%3D"}]','1','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1] 입니다.');
INSERT INTO "questions" VALUES(244,13,4,1,12,'수식·계산 도출형','4. 다음은 운영체제 페이지 순서를 참고하여 할당된 프레임의 수가 3개일 때 LRU 알고리즘의 페이지 부재 횟수를 작성하시오.','페이지 참조 순서 : 7 0 1 2 0 3 0 4 2 3 0 3 2 1 2 0 1 7 0 1','','','[]','[]','12','[운영체제(스케줄링/메모리) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [12] 입니다.
• 학습 가이드: [운영체제(스케줄링/메모리)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(245,13,5,1,5,'핵심 용어 단답형','5. 다음은 네트워크 취약점에 대한 문제이다. 아래 내용을 보고 알맞는 용어를 작성하시오.','- IP나 ICMP의 특성을 악용하여 엄청난 양의 데이터를 한 사이트에 집중적으로 보냄으로써 네트워크의 일부를 불능 상태로 만드는 공격이다.
- 여러 호스트가 특정 대상에게 다량의 ICMP Echo Reply 를 보내게 하여 서비스거부(DoS)를 유발시키는 보안공격이다.
- 공격 대상 호스트는 다량으로 유입되는 패킷으로 인해 서비스 불능 상태에 빠진다.','','','[]','[]','스머프(Smurf) 또는 스머핑(Smurfing)','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [스머프(Smurf) 또는 스머핑(Smurfing)] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(246,13,6,1,9,'괄호 빈칸 채우기형','6. 다음은 GoF 디자인 패턴과 관련된 문제이다. 괄호안에 알맞는 용어를 작성하시오.','( ) 패턴은 클래스나 객체들이 서로 상호작용하는 방법이나 책임 분배 방법을 정의하는 패턴이다.
( ) 패턴은 객체들 간의 통신 방법을 정의하고 알고리즘을 캡슐화하여 객체 간의 결합도를 낮춘다.
( ) 패턴은 Chain of Responsibility나 Command 또는 Observer 패턴이 있다.','','','[]','[]','행위','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [행위] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(247,13,7,2,1,'코드 출력 결과형','7. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

int func(){
 static int x =0;
  x+=2;
  return x;
}

int main(){
  int x = 1;
  int sum=0;
  for(int i=0;i<4;i++) {
    x++;
    sum+=func();
  }
  printf("%d", sum);

  return 0;
}','c','[]','[]','20','[C언어 실행 과정 분석]
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [20] 입니다.');
INSERT INTO "questions" VALUES(248,13,8,1,7,'괄호 빈칸 채우기형','8. 다음은 무결성제약조건에 대한 문제이다. 아래 표에서 어떠한 ( ) 무결성을 위반하였는지 작성하시오.','','','','[]','[{"local": "/images/questions/q_248_1.png", "remote": "https://blog.kakaocdn.net/dna/nh0RX/btsKgJl3Fa7/AAAAAAAAAAAAAAAAAAAAAG3F7y15SpGBFn7EpGA8Tqt3MwIPtZOIhTFksxToLV5O/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=V%2BW%2BojQHr%2FfmY3aHWY0uWDRO%2BKw%3D"}]','개체','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [개체] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(249,13,9,1,5,'핵심 용어 단답형','9. 다음은 URL 구조에 관한 문제이다 . 아래 보기의 순서대로 URL에 해당하는 번호를 작성하시오.','보기
query : 서버에 전달할 추가 데이터
path : 서버 내의 특정 자원을 가리키는 경로
scheme : 리소스에 접근하는 방법이나 프로토콜
authority : 사용자 정보, 호스트명, 포트 번호
fragment : 특정 문서 내의 위치','','','[]','[{"local": "/images/questions/q_249_1.png", "remote": "https://blog.kakaocdn.net/dna/bge1Ni/btsKfy62Ji6/AAAAAAAAAAAAAAAAAAAAADDVvxyjlpIU2PB6-m4-7z3CDSaXrwMa09a2ffodtExB/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=RyPEmctNOCJOEayHLKNGz115EJg%3D"}]','43125','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [43125] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(250,13,10,2,4,'코드 출력 결과형','10. 다음은 파이썬에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','def func(value):
    if type(value) == type(100):
        return 100
    elif type(value) == type(""):
        return len(value)
    else:
        return 20


a = ''100.0''
b = 100.0
c = (100, 200)

print(func(a) + func(b) + func(c))','python','[]','[]','45','[Python 코드 실행 과정 분석]
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [45] 입니다.');
INSERT INTO "questions" VALUES(251,13,11,2,2,'코드 출력 결과형','11. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main{
  public static void main(String[] args){
    Base a =  new Derivate();
    Derivate b = new Derivate();

    System.out.print(a.getX() + a.x + b.getX() + b.x);
  }
}


class Base{
  int x = 3;

  int getX(){
     return x * 2;
  }
}

class Derivate extends Base{
  int x = 7;

  int getX(){
     return x * 3;
  }
}','java','[]','[]','52','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [52] 입니다.');
INSERT INTO "questions" VALUES(252,13,12,2,1,'코드 출력 결과형','12. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

struct Node {
 int value;
 struct Node* next;
};

void func(struct Node* node){
  while(node != NULL && node->next != NULL){
     int t = node->value;
     node->value = node->next->value;
     node->next->value = t;
     node = node->next->next;
  }
}

int main(){
  struct Node n1 = {1, NULL};
  struct Node n2 = {2, NULL};
  struct Node n3 = {3, NULL};

  n1.next = &n3;
  n3.next = &n2;

  func(&n1);

  struct Node* current = &n1;

  while(current != NULL){
    printf("%d", current->value);
    current = current->next;
 }

 return 0;

}','c','[]','[]','312','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [312] 입니다.');
INSERT INTO "questions" VALUES(253,13,13,1,10,'보기·기호 선택형','13. 다음은 테스트 커버리지에 대한 문제이다. 아래 내용에 알맞는 답을 보기에서 골라 작성하시오.','1. 테스트를 통해 프로그램의 모든 문장을 최소한 한 번씩 실행했는지를 측정
2. 프로그램 내의 모든 분기(조건문)의 각 분기를 최소한 한 번씩 실행했는지를 측정
3. 복합 조건 내의 각 개별 조건이 참과 거짓으로 평가되는 경우를 모두 테스트했는지를 측정
보기
ㄱ. 조건 ㄴ. 경로 ㄷ. 결정 ㄹ. 분기 ㅁ.함수 ㅂ. 문장 ㅅ. 루프','','','[]','[]','1. 문장
2. 분기
3. 조건','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 문장
2. 분기
3. 조건] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(254,13,14,1,11,'핵심 용어 단답형','14.아래는 UML클래스의 관계에 관한 문제이다. 보기를 보고 알맞는 관계를 선택하여 작성하시오.','보기
ㄱ. 의존 ㄴ. 연관 ㄷ. 일반화','','','[]','[{"local": "/images/questions/q_254_1.png", "remote": "https://blog.kakaocdn.net/dna/uev6c/btsKheTOKch/AAAAAAAAAAAAAAAAAAAAAEwYju5DTzHQzGaTpqTmpYyFCvpFpBfnZJ4Y4VLYPDnh/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=2QHkQSNRAh6vHLwjuuSKBw8Uye4%3D"}]','(1) 연관
(2) 일반화
(3) 의존','[요구사항/UML/설계 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) 연관
(2) 일반화
(3) 의존] 입니다.
• 학습 가이드: [요구사항/UML/설계] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(255,13,15,1,7,'보기·기호 선택형','15. 다음은 데이터베이스에 관한 문제이다. 아래 내용을 읽고 알맞는 답을 보기에서 찾아 골라 작성하시오.','(1) 다른 테이블, 릴레이션의 기본 키를 참조하는 속성 또는 속성들의 집합
(2) 테이블에서 각 행을 유일하게 식별할 수 있는 최소한의 속성들의 집합
(3) 후보 키 중에서 선정된 기본 키를 제외한 나머지 후보 키
(4) 테이블에서 각 행을 유일하게 식별할 수 있는 속성들의 집합
ㄱ. 슈퍼키 ㄴ. 외래키 ㄷ. 대체키 ㄹ. 후보키','','','[]','[]','(1) 외래키
(2) 후보키
(3) 대체키
(4) 슈퍼키','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) 외래키
(2) 후보키
(3) 대체키
(4) 슈퍼키] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(256,13,16,2,1,'코드 출력 결과형','16. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

void func(int** arr, int size){
  for(int i=0; i<size; i++){
     *(*arr + i) = (*(*arr+i) + i) % size;
  }
}

int main(){
  int arr[] = {3,1, 4, 1, 5};
  int* p = arr;
  int** pp = &p;
  int num = 6;

  func(pp, 5);
  num = arr[2];
  printf("%d", num);

  return 0;
}','c','[]','[]','1','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [1] 입니다.');
INSERT INTO "questions" VALUES(257,13,17,1,5,'핵심 용어 단답형','17. 다음 아래 내용을 보고 알맞는 용어를 작성하시오. (3글자로 작성)','- 공용 네트워크를 통해 사설 네트워크를 확장하는 기술이다.
- 사용자의 IP 주소를 숨기고, 사용자가 어디에서 접속하는지를 추적하기 어렵게 만든다.
- 종류로는 IPsec 또는 SSL, L2TP 등이 있다.','','','[]','[]','VPN','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [VPN] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(258,13,18,2,2,'코드 출력 결과형','18. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class ExceptionHandling {
  public static void main(String[] args) {
      int sum = 0;
      try {
          func();
      } catch (NullPointerException e) {
          sum = sum + 1;
      } catch (Exception e) {
          sum = sum + 10;
      } finally {
          sum = sum + 100;
      }
      System.out.print(sum);
  }

  static void func() throws Exception {
      throw new NullPointerException();
  }
}','java','[]','[]','101','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [101] 입니다.');
INSERT INTO "questions" VALUES(259,13,19,2,2,'코드 출력 결과형','19. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class Main {

  public static class Collection<T>{
    T value;

    public Collection(T t){
        value = t;
    }

    public void print(){
       new Printer().print(value);
    }

   class Printer{
      void print(Integer a){
        System.out.print("A" + a);
      }
      void print(Object a){
        System.out.print("B" + a);
      }
      void print(Number a){
        System.out.print("C" + a);
      }
   }
 }

  public static void main(String[] args) {
      new Collection<>(0).print();
  }

}','java','[]','[]','B0','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [B0] 입니다.');
INSERT INTO "questions" VALUES(260,13,20,1,5,'핵심 용어 단답형','20. 다음은 네트워크에 대한 문제이다. 아래 내용을 보고 알맞는 용어를 작성하시오.','- 중앙 관리나 고정된 인프라 없이 임시로 구성되는 네트워크이다.
- 일반적으로 무선 통신을 통해 노드들이 직접 연결되어 데이터를 주고받는다.
- 긴급 구조, 긴급 회의, 군사적인 상황 등에서 유용하게 활용될 수 있다.
ㄱ.Infrastructure Network ㄴ. Firmware Network ㄷ. Peer-to-Peer Network ㄹ. Ad-hoc Network ㅁ. Mesh Network ㅂ.Sensor Network ㅅ.Virtual Private Network','','','[]','[]','ㄹ. (Ad-hoc Network)','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄹ. (Ad-hoc Network)] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(261,14,1,1,11,'괄호 빈칸 채우기형','1. 다음은 네트워크 보완에 관련된 문제이다. 괄호안에 알맞는 용어를 작성하시오.','( )은/는 ''세션을 가로채다.'' 라는 의미로 다른 사람의 세션 상태를 훔치거나 도용하여 액세스하는 해킹 기법이다.
TCP ( )은/는 TCP의 3-way 핸드셰이크가 완료된 후에 공격자가 시퀀스 번호 등을 조작하여 정상적인 세션을 가로채고 인증 없이 통신을 탈취하는 공격 공격이다.','','','[]','[]','세션 하이재킹','[요구사항/UML/설계 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [세션 하이재킹] 입니다.
• 학습 가이드: [요구사항/UML/설계] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(262,14,2,1,7,'보기·기호 선택형','2. 다음은 제약조건과 관련된 문제이다. 괄호안에 알맞는 용어를 보기에 골라 작성하시오.','[보기]
개체, 참조, 도메인','','','[]','[{"local": "/images/questions/q_262_1.png", "remote": "https://blog.kakaocdn.net/dna/zQKG3/btsNAiF6b8L/AAAAAAAAAAAAAAAAAAAAAEa_W4EUTDLlkXQKJW6z5pdQtR8cuby6AE9Gn06UIVEM/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=GADgwmkbjj3jkEaRZpYauHIZGbo%3D"}]','ㄱ. 도메인
ㄴ. 개체
ㄷ. 참조','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄱ. 도메인
ㄴ. 개체
ㄷ. 참조] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(263,14,3,1,6,'괄호 빈칸 채우기형','3. 아래의 내용에서 설명 글의 괄호안의 용어를 영문 약자로 작성하시오.','( ) 은/는 3글자의 영어 약자로 이루어진 오류 기법으로 데이터를 전송하거나 저장할 때 데이터의 오류를 감지하는 데 사용되는 오류 검출 코드이다.
( ) 은/는 데이터에 체크섬을 추가하여 데이터를 전송하거나 저장한 후, 수신 또는 읽을 때 이 체크섬을 다시 계산하여 데이터가 변경되었는지 확인하는 기법이다.
( ) 은/는 데이터 전송의 안정성을 높이는 데 중요한 역할을 한다.
데이터는 이진수(0과 1)로 표현되며 정해진 다항식(x³ + x + 1)을 기반으로 데이터를 2진수 나눗셈하고나머지를 ( ) 값으로 삼는다.','','','[]','[]','CRC','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [CRC] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(264,14,4,1,8,'보기·기호 선택형','4. 다음은 악성코드 관련된 문제이다. 아래 내용을 확인하여 보기에 골라 작성하시오.','사용자가 원치 않는 소프트웨어를 구매하도록 조작하기 위해 사회 공학을 사용하여 충격, 불안 또는 위협에 대한 인식을 유발하는 악성 소프트웨어의 한 형태이다.
‘겁을 주다’라는 영어 단어에서 유래한 것으로 공포를 이용하여 피해자를 속여 대가를 지불 하거나 특정 행동을 유도하는 랜섬웨어이다.
가짜 바이러스 경고나 시스템 문제를 표시하여 사용자가 돈을 지불하거나 특정 소프트웨어를 설치하도록 속이는 방식으로 작동한다.
보기
ㄱ. 컴포넌트 웨어 ㄴ. 유즈웨어 ㄷ. 셔블웨어 ㄹ. 스캐어 웨어 ㅁ. 안티 스파이 웨어 ㅂ. 네트웨어 ㅅ. 그룹웨어 ㅇ. 애드웨어','','','[]','[]','ㄹ','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄹ] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(265,14,5,2,2,'코드 출력 결과형','5. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main {

  public static void main(String[] args) {

    int a=5,b=0;

    try{
      System.out.print(a/b);
    }catch(ArithmeticException e){
      System.out.print("출력1");
    }catch(ArrayIndexOutOfBoundsException e) {
      System.out.print("출력2");
    }catch(NumberFormatException e) {
      System.out.print("출력3");
    }catch(Exception e){
      System.out.print("출력4");
    }finally{
      System.out.print("출력5");
    }
  }
}','java','[]','[]','출력1출력5','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [출력1출력5] 입니다.');
INSERT INTO "questions" VALUES(266,14,6,1,5,'핵심 용어 단답형','6. 아래 내용은 ARP/RARP에 대한 설명이다. 각 설명에 해당하는 것을 작성하시오.','( 1 ) 은/는 네트워크상에서 IP 주소를 MAC 주소로 변환하는 프로토콜이고,
( 2 ) 은/는 MAC 주소를 IP 주소로 변환하는 프로토콜이다.','','','[]','[]','(1) ARP
(2) RARP','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) ARP
(2) RARP] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(267,14,7,2,3,'SQL 작성·빈칸형','7. 다음은 SQL 문제이다. 아래 두 테이블을 참고하여 보기에 쿼리 실행 결과를 작성하시오.','[보기]','SELECT name, incentive FROM emp, sal WHERE emp.id = sal.id and incentives >= 500','sql','[]','[{"local": "/images/questions/q_267_1.png", "remote": "https://blog.kakaocdn.net/dna/F7Tnq/btsNzZtANQz/AAAAAAAAAAAAAAAAAAAAAK1cx-4kJpaMoUmRFCPQDT5G_pIphsY5oeoaQzKY76x6/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=v237yKIpHywK6Y4FL%2Bfu%2FAAcMb4%3D"}]','name | incentives
이순신 | 1000','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [name | incentives
이순신 | 1000] 입니다.');
INSERT INTO "questions" VALUES(268,14,8,1,7,'보기·기호 선택형','8. 아래는 데이터베이스에 관련된 설명이다. 알맞는 용어를 보기에서 골라 괄호를 작성하시오.','1. 릴레이션에서 속성의 개수를 의미 : ( 1 )
2. 릴레이션에서 튜플의 개수를 의미 : ( 2 )
3. 한 릴레이션의 속상이 다른 릴레이션의 기본 키를 참조할 때, 참조하는 속성을 의미 : ( 3 )
4. 특정 속성에 대해 입력될 수 있는 값의 유형이나 범위를 의미하고 무결성을 보장하는 기준 : ( 4 )
[보기]
ㄱ. domain ㄴ. primary ㄷ. degree ㄹ. candidate ㅁ. cardinality ㅂ. attribute ㅅ. foreign','','','[]','[]','(1) ㄷ
(2) ㅁ
(3) ㅅ
(4) ㄱ','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) ㄷ
(2) ㅁ
(3) ㅅ
(4) ㄱ] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(269,14,9,1,5,'보기·기호 선택형','9. IP 주소가 192.168.35.10, 서브넷 255.255.252.0인 PC에서 브로드캐스팅으로 다른 IP로 정보를 전달한다고 할 때 수신할 수 있는 알맞는 IP를 보기에서 골라 모두 작성하시오.','[보기]
ㄱ. 192.168.34.1
ㄴ. 192.168.32.19
ㄷ. 192.168.35.200
ㄹ. 192.168.33.138
ㅁ. 192.168.35.50','','','[]','[]','ㄱ,ㄴ,ㄷ,ㄹ,ㅁ','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄱ,ㄴ,ㄷ,ㄹ,ㅁ] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(270,14,10,2,1,'코드 출력 결과형','10. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>
char Data[5] = {''B'', ''A'', ''D'', ''E''};
char c;

int main(){
    int i, temp, temp2;

    c = ''C'';
    printf("%d\n", Data[3]-Data[1]);

    for(i=0;i<5;++i){
        if(Data[i]>c)
            break;
    }

    temp = Data[i];
    Data[i] = c;
    i++;

    for(;i<5;++i){
        temp2 = Data[i];
        Data[i] = temp;
        temp = temp2;
    }

    for(i=0;i<5;i++){
        printf("%c", Data[i]);
    }
}','c','[]','[]','4
BACDE','[C언어 실행 과정 분석]
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [4
BACDE] 입니다.');
INSERT INTO "questions" VALUES(271,14,11,2,1,'코드 출력 결과형','11. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>
#include <stdlib.h>

void set(int** arr, int* data, int rows, int cols) {
    for (int i = 0; i < rows * cols; ++i) {
        arr[((i + 1) / rows) % rows][(i + 1) % cols] = data[i];
    }
}

int main() {
    int rows = 3, cols = 3, sum = 0;
    int data[] = {5, 2, 7, 4, 1, 8, 3, 6, 9};
    int** arr;
    arr = (int**) malloc(sizeof(int*) * rows);
    for (int i = 0; i < cols; i++) {
        arr[i] = (int*) malloc(sizeof(int) * cols);
    }

    set(arr, data, rows, cols);

    for (int i = 0; i < rows * cols; i++) {
        sum += arr[i / rows][i % cols] * (i % 2 == 0 ? 1 : -1);
    }

    for(int i=0; i<rows; i++) {
        free(arr[i]);
    }
    free(arr);

    printf("%d", sum);
}','c','[]','[]','13','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [13] 입니다.');
INSERT INTO "questions" VALUES(272,14,12,1,14,'핵심 용어 단답형','12. 다음은 결합도와 관련된 내용이다. 보기에 알맞는 답을 골라 작성하시오.','(1) 다른 모듈 내부에 있는 변수나 기능을 다른 모듈에서 사용하는 경우의 결합도
(2) 모듈 간의 인터페이스로 배열이나 오브젝트, 자료구조 등이 전달되는 경우의 결합도
(3) 파라미터가 아닌 모듈 밖에 선언되어 있는 전역 변수를 참조하고 전역 변수를 갱신하는 식으로 상호작용하는 경우의 결합도
[보기]
ㄱ. 자료 결합도 ㄴ. 스탬프 결합도 ㄷ. 제어 결합도 ㄹ. 공통 결합도 ㅁ. 내용 결합도 ㅂ. 외부 결합도','','','[]','[]','(1) ㅁ
(2) ㄴ
(3) ㄹ','[결합도/응집도 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) ㅁ
(2) ㄴ
(3) ㄹ] 입니다.
• 학습 가이드: [결합도/응집도] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(273,14,13,2,2,'코드 출력 결과형','13. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main {
    public static void main(String[] args) {
        new Child();
        System.out.println(Parent.total);
    }
}


class Parent {
    static int total = 0;
    int v = 1;

    public Parent() {
        total += (++v);
        show();
    }

    public void show() {
        total += total;
    }
}


class Child extends Parent {
    int v = 10;

    public Child() {
        v += 2;
        total += v++;
        show();
    }

    @Override
    public void show() {
        total += total * 2;
    }
}','java','[]','[]','54','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [54] 입니다.');
INSERT INTO "questions" VALUES(274,14,14,1,9,'보기·기호 선택형','14. 아래는 디자인 패턴에 대한 설명이다. 알맞는 답을 보기에 골라 작성하시오.','서로 다른 인터페이스를 가진 클래스들을 연결해 사용 가능하게 한다.
기존 클래스(Adaptee)를 원하는 인터페이스(Target)에 맞게 변환하는 어댑터(Adapter)를 만든다.
기존 클래스를 감싸서(wrapper) 인터페이스를 변환해주는 역할을 한다.','','','[]','[{"local": "/images/questions/q_274_1.png", "remote": "https://blog.kakaocdn.net/dna/oCM2H/btsNzMAY2Vl/AAAAAAAAAAAAAAAAAAAAAI7nU4pEShdC4QU1bezXWzN8QaWWxsCQJI6lxs7fAj-m/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=mruEQeQwqgrdJtXOcgoBJQSFRiM%3D"}]','Adapter','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Adapter] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(275,14,15,1,10,'괄호 빈칸 채우기형','15. 문장(Statement) 커버리지 테스트를 수행하려고 한다. 코드를 아래의 제어 흐름도 빈칸에 연결되도록 작성하고 문장 커버리지 순서대로 작성하시오.','[흐름도]
1. ( ① ) 2. ( ② ) 3. ( ③ ) 4. ( ④ ) 5. ( ⑤ ) 6. ( ⑥ )
문장 커버리지 순서 1 → 2 → ( ⑦ )','int Main(int b[], int m, int x) {
    int a = 0;
    while (a < m || b[a] < x) {
        if (b[a] < 0)
            b[a] = -b[a];
        a++;
    }
    return 1;
}','','[]','[{"local": "/images/questions/q_275_1.png", "remote": "https://blog.kakaocdn.net/dna/dK8Uvu/btsNBHY9xSO/AAAAAAAAAAAAAAAAAAAAALKBOe-hfTV3FscLa7xdAqX4hNMqJ41TcqTsgB1SHIEc/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=bK76ktoAc6Q1P5TYF1vZB6wCqI8%3D"}]','(1) int a = 0
(2) a < m || b[a] < x
(3) b[a] < 0
(4) b[a] = -b[a];
(5) a++;
(6) return 1;
(7) ③ → ④ → ⑤ → ② → ⑥','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) int a = 0
(2) a < m || b[a] < x
(3) b[a] < 0
(4) b[a] = -b[a];
(5) a++;
(6) return 1;
(7) ③ → ④ → ⑤ → ② → ⑥] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(276,14,16,2,2,'코드 출력 결과형','16. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main {

    public static void main(String[] args) {
        int[] data = {3, 5, 8, 12, 17};
        System.out.println(func(data, 0, data.length - 1));
    }

    static int func(int[] a, int st, int end) {
        if (st >= end) return 0;
        int mid = (st + end) / 2;
        return a[mid] + Math.max(func(a, st, mid), func(a, mid + 1, end));
    }

}','java','[]','[]','20','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [20] 입니다.');
INSERT INTO "questions" VALUES(277,14,17,2,4,'코드 출력 결과형','17. 다음은 파이썬에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class Node:
    def __init__(self, value):
        self.value = value
        self.children = []

def tree(li):
    nodes = [Node(i) for i in li]
    for i in range(1, len(li)):
        nodes[(i - 1) // 2].children.append(nodes[i])
    return nodes[0]

def calc(node, level=0):
    if node is None:
        return 0
    return (node.value if level % 2 == 1 else 0) + sum(calc(n, level + 1) for n in node.children)

li = [3, 5, 8, 12, 15, 18, 21]

root = tree(li)

print(calc(root))','python','[]','[]','13','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [13] 입니다.');
INSERT INTO "questions" VALUES(278,14,18,2,1,'코드 출력 결과형','18. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>
#include <stdlib.h>

typedef struct Data {
    int value;
    struct Data *next;
} Data;

Data* insert(Data* head, int value) {
    Data* new_node = (Data*)malloc(sizeof(Data));
    new_node->value = value;
    new_node->next = head;
    return new_node;
}

Data* reconnect(Data* head, int value) {
    if (head == NULL || head->value == value) return head;
    Data *prev = NULL, *curr = head;
    while (curr != NULL && curr->value != value) {
        prev = curr;
        curr = curr->next;
    }

    if (curr != NULL && prev != NULL) {
        prev->next = curr->next;
        curr->next = head;
        head = curr;
    }
    return head;
}

int main() {

    Data *head = NULL, *curr;
    for (int i = 1; i <= 5; i++)
        head = insert(head, i);
    head = reconnect(head, 3);
    for (curr = head; curr != NULL; curr = curr->next)
        printf("%d", curr->value);
    return 0;
}','c','[]','[]','35421','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [35421] 입니다.');
INSERT INTO "questions" VALUES(279,14,19,2,1,'코드 출력 결과형','19.다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

typedef struct student {
    char* name;
    int score[3];
} Student;

int dec(int enc) {
    return enc & 0xA5;
}

int sum(Student* p) {
    return dec(p->score[0]) + dec(p->score[1]) + dec(p->score[2]);
}

int main() {
    Student s[2] = { "Kim", {0xA0, 0xA5, 0xDB}, "Lee", {0xA0, 0xED, 0x81} };
    Student* p = s;
    int result = 0;

    for (int i = 0; i < 2; i++) {
        result += sum(&s[i]);
    }
    printf("%d", result);
    return 0;
}','c','[]','[]','908','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [908] 입니다.');
INSERT INTO "questions" VALUES(280,14,20,2,2,'코드 출력 결과형','20. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main {
  public static void main(String[] args) {
    System.out.println(calc("5"));
  }

  static int calc(int value) {
    if (value <= 1) return value;
    return calc(value - 1) + calc(value - 2);
  }

  static int calc(String str) {
    int value = Integer.valueOf(str);
    if (value <= 1) return value;
    return calc(value - 1) + calc(value - 3);
  }
}','java','[]','[]','4','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [4] 입니다.');
INSERT INTO "questions" VALUES(281,15,1,1,13,'괄호 빈칸 채우기형','1. 다음은 파일 구조와 관련된 설명이다. 설명을 읽고 괄호 안에 들어갈 가장 알맞은 용어를 작성하시오.','데이터베이스의 물리 설계 시, 레코드에 접근하는 방법은 순차 접근 방법, [ ] 방법, 해싱 방법 등이 있다.
이 중 [ ] 방법은 레코드의 키 값과 포인터를 쌍으로 묶어 저장하며 검색 시 키 값을 기준으로 빠르게 탐색할 수 있도록 설계되어 있다.
이 방식은 검색 속도가 빠르며 <키 값, 포인터> 쌍으로 구성된 자료 구조를 사용하여 해당 키가 가리키는 주소를 통해 원하는 레코드를 직접 찾을 수 있다.','','','[{"type": "grid", "rows": [["접근 방법", "설명"], ["순차 접근", "레코드를 처음부터 하나씩 검사"], ["[ ] 접근", "키-값 쌍으로 구성되어 빠르게 검색"], ["해싱 접근", "해시 함수를 이용해 직접 주소 계산 후 접근"]]}]','[]','인덱스 or 색인','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [인덱스 or 색인] 입니다.
• 학습 가이드: [데이터베이스(설계/정규화)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(282,15,2,1,13,'보기·기호 선택형','2. 다음은 데이터베이스 릴레이션의 구성 요소 중 하나에 대한 설명이다. 설명을 읽고 보기에서 알맞은 기호를 골라 작성하시오.','릴레이션(Relation)에서 열(Column)을 의미하며 데이터 항목의 속성(Attribute) 또는 특성을 나타낸다.
각 열은 고유한 이름을 가지며 특정 도메인(Domain)에서 정의된 값을 갖는다.
예를 들어 "학생" 릴레이션에서 학번, 이름, 전공 등은 각각 하나의 열이며 이 열들은 학생의 고유한 속성을 나타낸다.
이 개념은 파일 구조에서의 필드(Field)에 해당하며 릴레이션에서 행(Row, Tuple)의 구성 요소가 된다.
[보기]
ㄱ. Cardinality
ㄴ. Domain
ㄷ. Attribute
ㅁ. Degree
ㅂ. Schema
ㅅ. Tuple','','','[]','[]','ㄷ. Attribute','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄷ. Attribute] 입니다.
• 학습 가이드: [데이터베이스(설계/정규화)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(283,15,3,1,5,'핵심 용어 단답형','3. 다음은 정보보안 관련 문제이다. 아래 내용을 보고 알맞는 단어를 작성하시오.','원격 접속과 관련된 보안 프로토콜이며 암호화된 통신을 제공하는 보안 접속용 프로토콜이다.
공개키 기반의 인증 방식을 사용하며 암호화된 데이터 전송을 지원한다.
주로 원격 서버에 안전하게 접속할 때 사용되며 기본 포트 번호는 22번이다.
Telnet의 보안 취약점을 보완한 대안으로 널리 사용된다.','','','[]','[]','SSH','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [SSH] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(284,15,4,1,12,'핵심 용어 단답형','4. 스케줄링 알고리즘에 관한 다음 설명을 읽고 (1)과 (2)에 알맞은 스케줄링 알고리즘의 명칭을 각각 쓰시오.','(1) CPU burst 시간이 짧은 프로세스를 우선적으로 처리하는 스케줄링 방식이다. "Shortest Next CPU Burst"라고도 불리며 선점형 또는 비선점형으로 구현될 수 있다.
(2) 위의 스케줄링 방식을 선점형으로 구현한 형태로 실행 중인 프로세스보다 더 짧은 burst 시간을 가진 프로세스가 도착하면 현재 CPU를 선점한다.','','','[]','[]','(1) SJF (Shortest Job First)
(2) SRT (Shortest Remaining Time)','[운영체제(스케줄링/메모리) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(1) SJF (Shortest Job First)
(2) SRT (Shortest Remaining Time)] 입니다.
• 학습 가이드: [운영체제(스케줄링/메모리)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(285,15,5,2,2,'코드 출력 결과형','5. 다음은 Java의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','public class Main {
    public static void change(String[] data, String s){
        data[0] = s;
        s = "Z";
    }

    public static void main(String[] args) {
        String data[] = { "A" };
        String s = "B";

        change(data, s);
        System.out.print(data[0] + s);
    }
}','java','[]','[]','BB','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [BB] 입니다.');
INSERT INTO "questions" VALUES(286,15,6,1,5,'괄호 빈칸 채우기형','6. 다음은 IP 주소와 서브넷 마스크에 관한 문제이다. 주어진 정보를 참고하여 괄호 안에 들어갈 알맞은 값을 쓰시오.','호스트의 IP 주소가 223.13.234.132이고 서브넷 마스크가 255.255.255.192일 때 다음 물음에 답하시오.
이 호스트가 속한 네트워크 주소는 223.13.234.( ① )이다.
이 네트워크에서 사용 가능한 호스트 수는 ( ② )개이다.
(단, 네트워크 주소와 브로드캐스트 주소는 제외한다.)','','','[]','[]','① 128
② 62','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [① 128
② 62] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(287,15,7,1,9,'핵심 용어 단답형','7. 다음은 디자인 패턴에 관한 문제이다. 아래 내용을 보고 알맞는 단어를 작성하시오.','어떤 객체에 대한 접근을 제어하거나 추가적인 기능을 부여하기 위해 해당 객체의 대리 객체를 사용하는 방식의 디자인 패턴이다.
실제 객체에 대한 접근 전에 필요한 작업을 수행할 수 있으며 실제 객체의 생성을 지연시켜 메모리와 자원을 절약할 수 있다.
또한, 실제 객체를 감추어 정보은닉을 강화할 수 있다는 장점이 있다.','','','[]','[]','Proxy','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [Proxy] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(288,15,8,1,5,'괄호 빈칸 채우기형','8. 다음은 웹 데이터 교환 방식에 관한 문제이다. 아래 설명을 읽고 괄호 안에 들어갈 알맞은 용어를 작성하시오.','( )은/는 웹 페이지 전체를 다시 불러오지 않고 JavaScript와 XML(또는 JSON)을 이용하여 일부 콘텐츠만 비동기적으로 갱신할 수 있는 기술이다.
( )은/는 HTML만으로는 구현하기 어려운 동적인 기능들을 가능하게 하여 사용자가 웹 페이지와 보다 자유롭게 상호작용할 수 있도록 해주는 웹 개발 기법이다.','','','[]','[]','AJAX','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [AJAX] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(289,15,9,2,2,'코드 출력 결과형','9. 다음은 Java언어의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','public class Main {

    static interface F {
        int apply(int x) throws Exception;
    }

    public static int run(F f) {
        try {
            return f.apply(3);
        } catch (Exception e) {
            return 7;
        }
    }

    public static void main(String[] args) {

        F f = (x) -> {
            if (x > 2) {
                throw new Exception();
            }
            return x * 2;
        };

        System.out.print(run(f) + run((int n) -> n + 9));
    }

}','java','[]','[]','19','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [19] 입니다.');
INSERT INTO "questions" VALUES(290,15,10,2,2,'코드 출력 결과형','10. 다음은 Java언어의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','public class Main{

    public static class Parent {

        public int x(int i) { return i + 2; }
        public static String id() { return "P";}

    }

    public static class Child extends Parent {

        public int x(int i) { return i + 3; }
        public String x(String s) { return s + "R"; }
        public static String id() { return "C"; }

    }

    public static void main(String[] args) {

        Parent ref = new Child();
        System.out.println(ref.x(2) + ref.id());

    }

}','java','[]','[]','5P','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [5P] 입니다.');
INSERT INTO "questions" VALUES(291,15,11,1,10,'핵심 용어 단답형','11. 다음 아래 제어 흐름 그래프가 분기 커버리지를 만족하기 위한 테스팅 순서를 쓰시오.','','','','[]','[{"local": "/images/questions/q_291_1.png", "remote": "https://blog.kakaocdn.net/dna/ontAh/btsPr5j39Go/AAAAAAAAAAAAAAAAAAAAAF7OOTxRSmoqRdz_y53RaHGui4wnxMDfWWDkzR0IAnjI/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=Id%2FxlH2bQg3mYGV7esS%2BWViijZY%3D"}]','1234561, 124567 or 1234567, 124561','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1234561, 124567 or 1234567, 124561] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(292,15,12,2,1,'코드 출력 결과형','12. 다음은 C언어의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','#include <stdio.h>
#define SIZE 3

typedef struct {
    int a[SIZE];
    int front;
    int rear;
} Queue;

void enq(Queue* q, int val){
    q->a[q->rear] = val;
    q->rear = (q->rear + 1) % SIZE;
}

int deq(Queue* q) {
    int val = q->a[q->front];
    q->front = (q->front + 1) % SIZE;
    return val;
}

int main() {
    Queue q = {{0}, 0, 0};

    enq(&q,1); enq(&q,2); deq(&q); enq(&q, 3);

    int first = deq(&q);
    int second = deq(&q);
    printf("%d 그리고 %d", first, second);

    return 0;
}','c','[]','[]','2 그리고 3','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [2 그리고 3] 입니다.');
INSERT INTO "questions" VALUES(293,15,13,1,5,'수식·계산 도출형','13. 라운드로빈(RR) 방식을 이용하고 아래 내용을 참고하여 평균대기시간을 구하시오.','운영체제에서 라운드로빈(Round Robin, RR) 스케줄링은 각 프로세스에 동일한 시간 할당량(타임 퀀텀)을 순차적으로 부여하며 CPU를 할당하는 방식이다.
다음은 4개의 프로세스가 서로 다른 시간에 도착하며 각기 다른 실행 시간을 가지는 상황이다. 이때 시간 할당량은 4ms이고 컨텍스트 스위칭 시간은 무시한다고 가정한다.
아래 정보를 바탕으로 라운드로빈(RR) 방식으로 CPU 스케줄링을 수행할 경우 모든 프로세스의 평균 대기시간(Average Waiting Time)은 얼마인가?','','','[{"type": "grid", "rows": [["프로세스", "도착 시간(ms)", "실행 시간(ms)"], ["P1", "0", "8"], ["P2", "1", "4"], ["P3", "2", "9"], ["P4", "3", "5"]]}]','[]','11.75ms','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [11.75ms] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(294,15,14,2,1,'코드 출력 결과형','14. 다음은 C언어의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','#include <stdio.h>

struct dat {
    int x;
    int y;
};

int main() {
    struct dat a[] = {{1, 2}, {3, 4}, {5, 6}};
    struct dat* ptr = a;
    struct dat** pptr = &ptr;

    (*pptr)[1] = (*pptr)[2];
    printf("%d 그리고 %d", a[1].x, a[1].y);

    return 0;
}','c','[]','[]','5 그리고 6','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [5 그리고 6] 입니다.');
INSERT INTO "questions" VALUES(295,15,15,2,2,'코드 출력 결과형','15. 다음은 Java언어의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','public class Main{
    public static class BO {
        public int v;
        public BO(int v) {
            this.v = v;
        }
    }
    public static void main(String[] args) {
        BO a = new BO(1);
        BO b = new BO(2);
        BO c = new BO(3);
        BO[] arr = {a, b, c};
        BO t = arr[0];
        arr[0] = arr[2];
        arr[2] = t;
        arr[1].v = arr[0].v;
        System.out.println(a.v + "a" + b.v + "b" + c.v);
    }
}','java','[]','[]','1a3b3','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [1a3b3] 입니다.');
INSERT INTO "questions" VALUES(296,15,16,2,1,'코드 출력 결과형','16. 다음은 C언어의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','#include <stdio.h>
#include <stdlib.h>

struct node {
    int p;
    struct node* n;
};

int main() {
    struct node a = {1, NULL};
    struct node b = {2, NULL};
    struct node c = {3, NULL};

    a.n = &b; b.n = &c; c.n = NULL;
    c.n = &a; a.n = &b; b.n = NULL;
    struct node* head = &c;
    printf("%d %d %d", head->p, head->n->p, head->n->n->p);
    return 0;
}','c','[]','[]','3 1 2','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [3 1 2] 입니다.');
INSERT INTO "questions" VALUES(297,15,17,2,4,'코드 출력 결과형','17. 다음은 Pyhon언어의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','lst = [1,2,3]
dst = {i : i* 2 for i in lst}
s = set(dst.values())
lst[0] = 99
dst[2]=7
s.add(99)
print(len(s & set(dst.values())))','python','[]','[]','2','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [2] 입니다.');
INSERT INTO "questions" VALUES(298,15,18,2,1,'코드 출력 결과형','18. 다음은 C언어의 문제이다. 아래 코드를 보고 알맞는 출력값을 작성하시오.','','#include <stdio.h>
#include <stdlib.h>

struct node {
    char c;
    struct node* p;
};

struct node* func(char* s) {
    struct node* h = NULL, *n;

    while(*s) {
        n = malloc(sizeof(struct node));
        n->c = *s++;
        n->p = h;
        h = n;
    }

    return h;
}

int main() {
    struct node* n = func("BEST");

    while(n) {
        putchar(n->c);
        struct node* t = n;
        n = n->p;
        free(t);
    }

    return 0;
}','c','[]','[]','TSEB','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [TSEB] 입니다.');
INSERT INTO "questions" VALUES(299,15,19,1,5,'핵심 용어 단답형','19. 다음은 TCP 통신 과정에서 발생할 수 있는 보안 취약점에 대한 설명이다. 이를 이용한 공격 기법으로 옳은 것은?','TCP는 연결을 수립하기 위해 클라이언트가 서버에 SYN 패킷을 보내고 서버는 SYN-ACK 패킷으로 응답한 후 클라이언트가 다시 ACK 패킷을 보내는 3-way-handshake 과정을 거친다.
이때 공격자는 클라이언트 역할로 수많은 SYN 패킷을 서버에 전송한 뒤 마지막 ACK를 고의로 보내지 않아 서버가 연결 대기 상태를 계속 유지하게 만든다.
이로 인해 서버의 연결 대기 큐가 가득 차면서 정상적인 접속 요청을 처리하지 못하게 되어 서비스 거부 상태가 발생한다.','','','[]','[]','SYN Flooding','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [SYN Flooding] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(300,15,20,1,6,'핵심 용어 단답형','20. 다음 테이블에서 πTTL(employee)에 대한 연산 결과 값을 작성하시오.','[employee테이블]','','','[]','[{"local": "/images/questions/q_300_1.png", "remote": "https://blog.kakaocdn.net/dna/yRw19/btsPrsmwocC/AAAAAAAAAAAAAAAAAAAAAGj9fscjC-kGGNZajz0zMo_o1cfYQ2xxHnU3YH5rGA9p/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=sREpyu5URXWDeiexFM9xKLu8VqA%3D"}]','1. TTL
2. 부장
3. 대리
4. 과장
5. 차장','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. TTL
2. 부장
3. 대리
4. 과장
5. 차장] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(301,16,1,1,11,'괄호 빈칸 채우기형','1. 다음은 UML ( ) 다이어그램이다. 아래 내용을 보고 다이어그램의 관계를 확인하여 명칭을 작성하시오.','( ) 다이어그램이란
시스템을 폴더 모양의 ( ) 단위로 구분하여 구성 요소 간의 관계를 표현하는 UML 구조 다이어그램이다.
하나의 ( ) 안에는 여러 클래스나 하위 ( ) 가 포함될 수 있으며,
( ) 간에는 «import», «access», «merge» 등의 관계를 통해 의존성(Dependency) 을 표현한다.
이 다이어그램은 코드의 실제 구조(폴더 구조)와 비슷하게 표현되기 때문에
소프트웨어의 모듈화, 재사용성, 의존 관계를 시각적으로 설계할 때 자주 사용된다.','','','[]','[]','패키지','[요구사항/UML/설계 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [패키지] 입니다.
• 학습 가이드: [요구사항/UML/설계] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(302,16,2,1,10,'핵심 용어 단답형','2. 다음은 소프트웨어 테스트 기법 중 하나에 대한 설명이다.','소프트웨어 테스트의 구조 기반(화이트박스) 기법 중 하나로,
결정 포인트(Decision Point) 내에 존재하는 모든 개별 조건식(Atomic Condition) 을 대상으로 하는 커버리지 기준이 있다.
하나의 결정문(예: if (A && B) 또는 if (X > 10 || Y == 0)) 안에는
여러 개의 조건식이 포함될 수 있는데 이 커버리지는
각각의 조건식이 True와 False 두 가지 경우를 모두 한 번 이상 만족하도록
테스트 케이스를 설계해야 한다.
즉, 모든 개별 조건이 두 방향의 결과를 거쳐야 “커버되었다”고 판단하지만
그렇다고 해서 전체 결정식(Decision Expression) 의 결과(True/False)가
모두 수행된다고 보장하지는 않는다.
[보기]
ㄱ. 경로(Path)
ㄴ. 결정(Decision)
ㄷ. 조건/결정(Condition/Decision)
ㄹ. 변경 조건/결정(Modified Condition/Decision, MC/DC)
ㅁ. 다중 조건(Multiple Condition)
ㅂ. 문장(Statement)
ㅅ. 분기(Branch)
ㅇ. 조건(Condition)
ㅈ. 루프(Loop)','','','[]','[]','조건 커버리지 (Condition Coverage)','• 조건 커버리지(Condition Coverage): 결정 포인트 내에 존재하는 모든 개별 조건식(Atomic Condition)이 참(True)과 거짓(False)을 최소 한 번 이상 만족하도록 테스트 케이스를 설계하는 화이트박스 테스트 기법입니다.
• 개별 조건식은 모두 T/F를 거치더라도 전체 결정문(Decision)의 결과가 한쪽으로만 치우칠 수 있다는 특징이 있습니다.');
INSERT INTO "questions" VALUES(303,16,3,1,18,'보기·기호 선택형','3. 다음은 유닉스(Unix) 또는 리눅스(Linux) 환경에서 자주 사용하는 기본 명령어에 대한 설명이다.','각 설명에 맞는 명령어를 보기에서 골라 연결하시오.
1. 현재 작업 중인 디렉터리의 경로를 출력한다. ( )
2. 디렉터리의 내용(파일 및 하위 디렉터리)을 목록으로 표시한다. ( )
3. 다른 디렉터리로 이동한다. ( )
4. 파일을 복사한다. ( )
[보기]
ls, cd, cp, pwd','','','[]','[]','1.pwd
2.ls
3.cd
4.cp','[운영체제(명령어/기초) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1.pwd
2.ls
3.cd
4.cp] 입니다.
• 학습 가이드: [운영체제(명령어/기초)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(304,16,4,1,8,'보기·기호 선택형','4. 다음은 오류검출 방식을 설명하는 내용이다. 설명의 빈칸 (①)~(⑤) 에 들어갈 알맞은 용어를 <보기>에서 고르시오.','(①) 코드는 전송 데이터에 여러 개의 검사 비트를 추가하여 오류를 검출하고 수정까지 가능한 방법이다.
이 코드는 재전송 없이 수신 측에서 자체 수정하는 (②) 방식에 속한다.
이에 반해 오류 발생 시 송신 측에 재전송을 요구하는 방식은 (③)이라 하며, 여기에 포함되는 대표적 검출 기법으로 (④) 검사와 (⑤) 검사가 있다.
(④) 검사는 데이터 블록 끝에 1비트 검사 비트를 추가하여 오류를 검출한다.
(⑤) 검사는 송신측과 수신측이 동일한 특정 다항식을 사용하여 오류를 검출한다.
[보기]
㉠ CRC ㉡ FEC ㉢ BEC ㉣ NAK ㉤ Parity ㉥ MD5 ㉦ BCD ㉧ Hamming','','','[]','[]','① ㉧ Hamming
② ㉡ FEC
③ ㉢ BEC
④ ㉤ Parity
⑤ ㉠ CRC','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [① ㉧ Hamming
② ㉡ FEC
③ ㉢ BEC
④ ㉤ Parity
⑤ ㉠ CRC] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(305,16,5,2,1,'코드 출력 결과형','5. 다음은 C코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

struct Test {
    int i;
    const char *g;
};

int main() {
    struct Test test[] = {{1, "AB"}, {2, "DC"}, {3, "EB"}};
    struct Test *p = &test[1];
    printf("%s", p->g + (p->i - 1));
    return 0;
}','c','[]','[]','C','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [C] 입니다.');
INSERT INTO "questions" VALUES(306,16,6,2,1,'코드 출력 결과형','6. 다음은 C코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

int main(void) {
    char str[] = "REPUBLICOFKOREA";
    int a = 0;

    while (str[a] != ''\0'')
        ++a;

    putchar(str[a - 2]);
    return 0;
}','c','[]','[]','E','[C언어 실행 과정 분석]
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [E] 입니다.');
INSERT INTO "questions" VALUES(307,16,7,2,1,'코드 출력 결과형','7. 다음은 C코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

struct Node {
    struct Node* next;
    unsigned int x;
};

int main() {
    struct Node t1 = { 0, 5u };
    struct Node t2 = { 0, 7u };
    struct Node t3 = { 0, 11u };

    t3.next = &t2;
    t2.next = &t1;

    struct Node* curr = &t3;
    int sum = 0;

    while (curr) {
        sum = sum * 3 + curr->x;
        curr = curr->next;
    }

    sum = (sum ^ 42u) + 100u;

    printf("%u\n", sum);
}','c','[]','[]','187','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [187] 입니다.');
INSERT INTO "questions" VALUES(308,16,8,2,2,'코드 빈칸 완성형','8. 아래 코드는 Machine 이라는 인터페이스를 정의하고 WashingMachine 클래스에서 해당 인터페이스를 사용하고자 한다. 빈칸에 들어갈 올바른 키워드를 작성하시오.','','interface Machine {
    void run();
}

class WashingMachine (____빈칸____) Machine {
    private String name;

    public WashingMachine() {
        this.name = "LG Washer";
    }

    public void run() {
        System.out.println("Washing machine running");
    }
}

public class Main {
    public static void main(String[] args) {
        WashingMachine wm = new WashingMachine();
        wm.run();
    }
}','java','[]','[]','implements','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [implements] 입니다.');
INSERT INTO "questions" VALUES(309,16,9,2,4,'코드 출력 결과형','9. 다음은 파이썬에 대한 문제이다. 아래 코드를 확인하여 출력값에 알맞는 값을 작성하시오.','[ 출력값 ]
{0: (①, ②), 1: (③, ④), 2: (⑤, ⑥), 3: (⑦, ⑧)}','data = [
    [3, 5, 2, 4, 1],
    [4, 5, 1],
    [4, 4, 1, 5, 4],
    [4, 5]
]

result = {}

for index, lis in enumerate(data):
    list_sum = sum(lis)
    list_len = len(lis)

    result[index] = (list_sum, list_len)

print(result)','python','[]','[]','①=15, ②=5, ③=10, ④=3, ⑤=18, ⑥=5, ⑦=9, ⑧=2','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [①=15, ②=5, ③=10, ④=3, ⑤=18, ⑥=5, ⑦=9, ⑧=2] 입니다.');
INSERT INTO "questions" VALUES(310,16,10,1,6,'수식·계산 도출형','10. 다음은 테이블에서 조건값을 실행한 화면이다. 이에 대한 알맞는 결과값을 작성하시오.','','','','[]','[{"local": "/images/questions/q_310_1.png", "remote": "https://blog.kakaocdn.net/dna/3xNUN/dJMcahvY69C/AAAAAAAAAAAAAAAAAAAAADw45hfOG4ELvqVn1Ydu87lx5vaNXH94n0GSMrwIQCOA/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=dw%2FW0%2BznzGRa89hyjL0dhlkcQ90%3D"}]','4','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [4] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(311,16,11,1,8,'핵심 용어 단답형','11. 다음 설명에 해당하는 인증 기술을 쓰시오.','한 번 사용하면 즉시 폐기되어 재사용이 불가능하다.
서버와 토큰(또는 앱)은 시간 동기화나 카운터 기반 방식으로 매번 새로운 값을 생성하고, 내부 검증은 해시 함수를 이용한 방식으로 서버에 평문을 저장하지 않고도 유효성을 확인할 수 있다.
이 특성 때문에 은행 인증 등 고보안 영역에서 널리 사용되며 재전송 공격 방지와 사용자 편의성을 동시에 만족한다.','','','[]','[]','OTP','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [OTP] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(312,16,12,2,2,'코드 빈칸 완성형','12. 다음은 Java의 상속과 생성자 호출에 관한 코드이다. 밑줄에 알맞은 단어를 작성하시오.','','class Rectangle {

    int width, height;

    Rectangle(int width, int height) {
        this.width = width;
        this.height = height;
    }
}

class Square extends Rectangle {

    Square(int a) {
        ____(a,a);
    }

    int getSquareArea() {
        return width * height;
    }
}

public class Main {
    public static void main(String[] args) {
        Square sq = new Square(10);
        System.out.println(sq.getSquareArea());
    }
}','java','[]','[]','super','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [super] 입니다.');
INSERT INTO "questions" VALUES(313,16,13,1,6,'핵심 용어 단답형','13. 다음은 인증 및 자원 접근 방식에 대한 설명이다. 알맞은 단어를 작성하시오.','사용자가 새로운 사이트에 가입하지 않고 평소에 이용하던 서비스의 계정으로 로그인할 수 있게 해주는 기술이다.
사용자의 비밀번호는 절대 전달되지 않으며 사용자가 승인한 범위에 대해서만 접근 권한이 위임된다.
이 방식은 직접 인증(Authentication)을 수행하지 않고 "인가(Authorization)" 절차를 통해 접근 권한을 제3자에게 부여한다.
인증 완료 후, 서비스 제공자는 Access Token을 발급하며 애플리케이션은 이 토큰을 이용해 API를 호출하여 필요한 정보에 접근한다.
대표적인 예는 소셜 로그인이며 SSO(Single Sign-On)과 달리 동일 시스템 내 인증이 아니라 서로 다른 서비스 간의 권한 위임에 초점이 맞춰져 있다.','','','[]','[]','OAuth','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [OAuth] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(314,16,14,1,7,'핵심 용어 단답형','14. 다음 아래의 테이블을 확인하여 R%S의 결과를 테이블 형태로 기재하시오.','','','','[]','[{"local": "/images/questions/q_314_1.png", "remote": "https://blog.kakaocdn.net/dna/nQ3eR/dJMcai2Jn1f/AAAAAAAAAAAAAAAAAAAAAELHm-w1OFo4fvfDFdSFQJ2TgYLyEdMLMu72VQKV9sEE/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=XzYy98cT4SNMwizVYRpD5HXR4A0%3D"}]','A
a1','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [A
a1] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(315,16,15,2,1,'코드 출력 결과형','15. 다음은 C코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>
int main() {
    int x=7, y=4, z;
    z = y%3<3 ? 2 : 1;
    z = z & z >> 1;
    z = x>5 && z<=3 ? z*x : z/x;
    printf("%d", z);
    return 0;
}','c','[]','[]','0','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [0] 입니다.');
INSERT INTO "questions" VALUES(316,16,16,1,7,'괄호 빈칸 채우기형','16. 관계형 데이터베이스 개념에 대한 설명이다. 빈칸에 들어갈 용어를 <보기>에서 골라 순서대로 쓰시오.','ㄱ. 테이블에서 한 행(Row)을 의미하며, 하나의 레코드를 구성하는 요소
ㄴ. 실제 데이터가 저장되어 있는 테이블의 내용 전체를 의미하며, 데이터의 상태를 나타낸다.
ㄷ. 테이블에 저장된 행(Row)의 총 개수를 의미한다.
[보기]
스키마(Structure) 속성(Attribute) 튜플(Tuple)
차수(Degree) 인스턴스(Instance) 카디널리티(Cardinality)','','','[]','[]','ㄱ. 튜플
ㄴ. 인스턴스
ㄷ. 카디널리티','[데이터베이스(관계대수/구조) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄱ. 튜플
ㄴ. 인스턴스
ㄷ. 카디널리티] 입니다.
• 학습 가이드: [데이터베이스(관계대수/구조)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(317,16,17,2,2,'코드 출력 결과형','17. 다음은 Java에 대한 코드이다. 알맞는 출력값을 작성하시오.','','enum Tri {
    A("A"), B("AB"), C("ABC");

    private String code;

    Tri(String code) {
        this.code = code;
    }

    public String code() {
        return code;
    }
}

public class Main {
    public static void main(String[] args) {
        Tri t = Tri.values()[Tri.A.name().length()];
        System.out.print(t.code());
    }
}','java','[]','[]','AB','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [AB] 입니다.');
INSERT INTO "questions" VALUES(318,16,18,1,8,'괄호 빈칸 채우기형','18. 다음은 정보보안에서 사용하는 접근통제(Access Control) 방식에 대한 설명이다.','설명에 해당하는 접근통제 모델을 <보기>에서 골라 빈칸에 작성하시오.
[보기]
DAC MAC RBAC','','','[{"type": "grid", "rows": [["ㄱ", "중앙에서 보안 정책을 일괄적으로 설정하며, 주체(사용자)가 임의로 수정하거나 변경할 수 없다. 주로 군사 기밀, 국가 보안과 같은 높은 보안 수준이 요구되는 환경에서 사용된다. 보안 등급(Top Secret / Secret / Confidential 등)에 따라 접근 여부가 결정된다."], ["ㄴ", "조직 내에서 부여된 직무나 역할(Role)에 따라 접근 권한을 부여하는 방식이다. 개별 사용자에게 직접 권한을 설정하지 않고, 역할에 권한을 묶어 부여하기 때문에 관리가 용이하며 직무 변경 시 역할만 변경하면 된다."], ["ㄷ", "자원의 소유자(Owner)가 해당 자원에 대한 접근 권한을 자유롭게 부여하거나 회수할 수 있는 방식이다. 파일이나 폴더의 소유자가 읽기/쓰기/실행 권한을 설정하는 것이 대표적인 예로 사용자의 임의 설정이 가능해 보안성이 상대적으로 낮다."]]}]','[]','ㄱ. MAC
ㄴ. RBAC
ㄷ. DAC','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄱ. MAC
ㄴ. RBAC
ㄷ. DAC] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(319,16,19,1,10,'보기·기호 선택형','19. 다음은 테스트케이스의 구성요소에 대한 설명이다. 괄호 ( ) 안에 들어갈 알맞는 보기를 고르시오.','[보기]
ㄱ. 테스트 조건 ㄴ. 테스트 환경 ㄷ. 테스트 유형 ㄹ. 테스트 데이터
ㅁ. 예상 결과 ㅂ. 수행 단계 ㅅ. 성공/실패 기준','','','[]','[{"local": "/images/questions/q_319_1.png", "remote": "https://blog.kakaocdn.net/dna/ceJ8aE/dJMcaacyBpw/AAAAAAAAAAAAAAAAAAAAAADJIY3nqTo1a7xE3SURgAb3TNV6FPn10AsS2T_M2YUI/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=5%2Bj1cuxgDsEYvV%2FsWiaO8JyAF8M%3D"}]','(왼쪽순으로)
ㄱ
ㄹ
ㅁ','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [(왼쪽순으로)
ㄱ
ㄹ
ㅁ] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(320,16,20,2,3,'SQL 작성·빈칸형','20. 다음은 SQL에 관한 문제이다. 아래 A테이블을 참고하여 쿼리의 결과를 작성하시오.','[ SQL ]','SELECT count(col2) FROM A WHERE col1 IN (2, 3) OR col2 IN (3, 5)','sql','[]','[{"local": "/images/questions/q_320_1.png", "remote": "https://blog.kakaocdn.net/dna/rZWcv/dJMcagjxAYd/AAAAAAAAAAAAAAAAAAAAAORRhi_VXk_jvqfTMe3nWuUAB7JHDQh2F2QSrSsAhHrM/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=4wlaqUXmpmv%2B7E8cFrgMtiye20g%3D"}]','4','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [4] 입니다.');
INSERT INTO "questions" VALUES(321,17,1,2,1,'코드 출력 결과형','1. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

double arr1(int p[], int len) {
    double av = 0;
    int i;
    for (i = 0; i < len; i++) {
        av += (double) p[i];
    }
    return av / len;
}

double arr2(int * p, int len) {
    double av = 0;
    int i;
    for (i = 0; i < len; i++) {
        av += (double)( * (p + i));
    }
    return av / len;
}

int main() {
    int arr[10] = {
        80,
        20,
        50,
        55,
        45,
        95,
        55,
        10,
        40,
        80
    };
    int len = 10;

    printf("%.2f", arr1(arr, len) + arr2(arr, len));

    return 0;
}','c','[]','[]','106.00','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 반복문 제어 흐름: 루프 변수의 초기값, 조건식, 증감 폭을 단계별로 대입하여 변수 상태 변화를 계산합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [106.00] 입니다.');
INSERT INTO "questions" VALUES(322,17,2,1,9,'괄호 빈칸 채우기형','2. 다음 설명에 해당하는 디자인 패턴의 유형을 괄호( ) 안에 쓰시오.','• ( ㄱ ) 패턴은 기능의 클래스 계층과 구현의 클래스 계층을 연결
• ( ㄴ ) 패턴은 한 객체의 상태가 바뀌면 그 객체에 의존','','','[]','[]','ㄱ. Bridge
ㄴ. Observer','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄱ. Bridge
ㄴ. Observer] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(323,17,3,1,6,'괄호 빈칸 채우기형','3. 데이터베이스(DB) 설계 절차를 순서대로 나타낸 것이다. 각 빈칸에 들어갈 알맞은 용어를 쓰시오.','','','','[]','[{"local": "/images/questions/q_323_1.png", "remote": "https://blog.kakaocdn.net/dna/bz3PSN/dJMcabDWLOf/AAAAAAAAAAAAAAAAAAAAAMfACIdyKtB0JQwv0XStEBX054bg-hZUA0mhRO0T_ssC/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=Kc1bfYFSCtpVBTrJKZLL6HjP4Ec%3D"}]','ㄱ.요구사항 분석
ㄴ.개념적 설계
ㄷ.논리적 설계
ㄹ.물리적 설계
ㅁ.구현','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄱ.요구사항 분석
ㄴ.개념적 설계
ㄷ.논리적 설계
ㄹ.물리적 설계
ㅁ.구현] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(324,17,4,1,11,'보기·기호 선택형','4. 다음은 비기능적 요구사항에 대한 설명이다. 각 항목이 의미하는 요구사항 유형을 보기에서 골라 쓰시오.','1. 시스템 운영 중 로그 관리 및 모니터링 기능을 제공해야 한다.
2. 시스템 운영 시 최소 메모리 용량을 확보해야 하며, 자원 사용량은 제한 범위 내에 있어야 한다.
3. 사용자 요청에 대한 응답 시간은 최대 1분을 초과하지 않아야 한다.
보기
신뢰성, 가용성, 운영, 유지보수성, 자원, 성능, 이식성 ,보안, 품질','','','[]','[]','1. 운영
2. 자원
3. 성능','[요구사항/UML/설계 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 운영
2. 자원
3. 성능] 입니다.
• 학습 가이드: [요구사항/UML/설계] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(325,17,5,1,6,'핵심 용어 단답형','5. 다음 용어의 영문 약자를 쓰시오.','정보보호 관리체계','','','[]','[]','ISMS','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ISMS] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(326,17,6,1,5,'핵심 용어 단답형','6. HDLC는 비트 중심의 데이터 링크 제어 프로토콜로, 프레임 단위로 데이터를 전송하며 흐름 제어 및 오류 복구 기능을 제공한다. 다음 설명을 읽고 알맞은 용어를 쓰시오.','HDLC 구성 요소
1. HDLC 프레임의 구성 단위로, 실제 사용자 데이터를 전송하는 프레임
2. 데이터 링크의 흐름을 관리하고 오류 제어 및 통신 상태를 감시하는 프레임
3. 순서 번호 없이 링크 설정, 해제, 모드 설정 등 제어 기능을 수행하는 프레임
4. 두 국(Station)이 동등한 위치에서 서로 명령과 응답을 주고받는 모드
5. 종국(Secondary)이 주국(Primary)의 허가 없이도 자발적으로 응답을 전송할 수 있는 모드','','','[]','[]','1. 정보
2. 감독
3. 비번호
4. 비동기 균형 모드
5. 비동기 응답 모드','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 정보
2. 감독
3. 비번호
4. 비동기 균형 모드
5. 비동기 응답 모드] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(327,17,7,2,2,'코드 출력 결과형','7. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class A {
    String f(Object x) {
        return "1";
    }

    String g() {
        return f("a");
    }
}

class B extends A {
    String f(Object x) {
        return "2";
    }

    String f(String x) {
        return "3";
    }
}

public class Main {
    public static void main(String[] args) {
        A a = new B();
        System.out.println(a.g());
    }
}','java','[]','[]','2','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [2] 입니다.');
INSERT INTO "questions" VALUES(328,17,8,2,4,'코드 출력 결과형','8. 아래 파이썬 코드가 있다. 입력값으로 HumanDev를 주었을 때 출력되는 결과를 쓰시오.','','i = input()
x = []

for word in i.split():
    x.append(word)

y = ''''.join(x)
z = ''''.join(c for c in y[::-1] if c not in ''ong'')

print(z)','python','[]','[]','veDamuH','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [veDamuH] 입니다.');
INSERT INTO "questions" VALUES(329,17,9,2,3,'SQL 결과 도출형','9. 아래 조건을 참고하여 각 SQL 구문을 실행했을 때 반환되는 행(Row)의 수를 쓰시오.','(단, DEPT 칼럼은 학과명이다.)
테이블 조건
STUDENT 테이블에는 다음 세 학과의 학생 정보가 저장되어 있다.
컴퓨터과 50명 · 인터넷과 100명 · 사무자동화과 50
SQL 구문
1. SELECT DEPT FROM STUDENT;
2. SELECT DISTINCT DEPT FROM STUDENT;
3. SELECT COUNT(DISTINCT DEPT) FROM STUDENT
WHERE DEPT = ''컴퓨터과'';','','sql','[]','[]','1. 200
2. 3
3. 1','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1. 200
2. 3
3. 1] 입니다.');
INSERT INTO "questions" VALUES(330,17,10,2,3,'SQL 작성·빈칸형','10. 아래는 선수(PLAYER) 정보를 관리하는 테이블을 정의하는 SQL 문이다. 팀(TEAM) 테이블의 특정 칼럼을 참조하는 외래키 제약 조건을 추가하려 할 때, 괄호 ①~⑤에 들어갈 적절한 예약어(keyword) 또는 칼럼명을 아래 조건을 참고하여 쓰시오.','조건
외래키 제약 조건의 이름은 TEAM_TF 로 지정한다.
PLAYER 테이블의 TEAM_ID 칼럼이 외래키 역할을 한다.
TEAM 테이블의 TEAM_ID2 칼럼을 참조 대상으로 한다.
SQL 문','CREATE TABLE PLAYER (
PLAYER_ID CHAR(7) NOT NULL,
PLAYER_NAME VARCHAR2(20) NOT NULL,
TEAM_ID CHAR(3) NOT NULL,
PRIMARY KEY (PLAYER_ID),
( 1 ) TEAM_TF
( 2 ) KEY ( 3 )
( 4 ) TEAM ( 5 )
);','sql','[]','[]','1. CONSTRAINT
2. FOREIGN
3. TEAM_ID
4. REFERENCES
5. TEAM_ID2','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1. CONSTRAINT
2. FOREIGN
3. TEAM_ID
4. REFERENCES
5. TEAM_ID2] 입니다.');
INSERT INTO "questions" VALUES(331,17,11,1,5,'핵심 용어 단답형','11. 두 호스트 a, b의 IP 주소와 서브넷 마스크가 주어졌을 때, 각 호스트가 속한 네트워크 주소를 CIDR 표기법으로 쓰시오.','조건
· 호스트 a의 IP 주소: 192.168.11.20
· 호스트 b의 IP 주소: 192.168.12.200
· 서브넷 마스크: 255.255.254.0
구하는 것
a. 호스트 a (192.168.11.20) 가 속한 네트워크 주소
b. 호스트 b (192.168.12.200) 가 속한 네트워크 주소','','','[]','[]','a. 192.168.10.0/23
b. 192.168.12.0/23','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [a. 192.168.10.0/23
b. 192.168.12.0/23] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(332,17,12,2,1,'코드 출력 결과형','12. 다음은 C언어에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','struct fns {
    int* (*fn)(int*);
} mine;

int* dummy(int *d) {
    return d + 1;
}

int main() {
    struct fns mine;
    int n[] = {16, 32};
    mine.fn = dummy;
    printf("%x", *mine.fn(n));
    return 0;
}','c','[]','[]','20','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [20] 입니다.');
INSERT INTO "questions" VALUES(333,17,13,2,4,'코드 출력 결과형','13. 다음은 파이썬에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','lst = list(range(10))
for c in lst[::-2]:
    print(c, end=''A'')
print()','python','[]','[]','9A7A5A3A1A','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [9A7A5A3A1A] 입니다.');
INSERT INTO "questions" VALUES(334,17,14,2,4,'코드 출력 결과형','14. 아래 파이썬 코드를 실행했을 때 출력되는 값을 쓰시오.','','def f(a):
    m = [[x] for x in a]
    b = m[:]
    for i in range(len(b) - 1):
        b[i+1] += b[i]
    return sum(len(x) for x in m)

print(f([1, 2, 3, 4]))','python','[]','[]','10','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [10] 입니다.');
INSERT INTO "questions" VALUES(335,17,15,1,6,'핵심 용어 단답형','15. 다음은 특정 공격 기법에 대한 설명이다. 아래 내용을 읽고 해당하는 공격 기법을 [보기]에서 골라 쓰시오.','원본 데이터 파일은 별도로 존재하며, 공격자는 해당 파일의 경로를 가리키는 특수 파일을 생성한다. 프로그램이 임시 파일을 생성하는 순간을 틈타 해당 임시 파일을 미리 준비한 특수 파일로 교체한다. 이후 프로그램이 임시 파일의 존재를 확인하면 교체된 파일을 정상으로 인식하고 동작하게 된다.
공격 절차
1. 공격자는 실제 파일이 아닌, 특정 파일의 경로를 참조하는 특수 파일을 미리 준비한다.
2. 프로그램이 임시 파일을 생성하는 시점을 노려 해당 임시 파일을 준비한 특수 파일로 교체한다.
3. 프로그램이 임시 파일의 존재 여부를 확인할 때, 조건에 부합하면 정상으로 판단하고 동작하며 부합하지 않으면 임시 파일을 삭제한다.
[보기]
하드링크 / 심볼릭링크 / 소프트링크 / 정적링크 / 동적링크','','','[]','[]','심볼릭링크','[소프트웨어 일반/신기술 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [심볼릭링크] 입니다.
• 학습 가이드: [소프트웨어 일반/신기술] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(336,17,16,1,8,'핵심 용어 단답형','16. 다음은 특정 보안 공격 기법에 대한 설명이다. 해당하는 공격 기법의 명칭을 쓰시오.','공격자는 목표 대상이 업무 또는 관심사로 인해 자주 방문하는 합법적인 웹사이트를 사전에 파악한다.
해당 사이트에 악성코드를 삽입하여 감염시켜 놓고, 피해자가 해당 사이트에 접속하는 순간 피해자의 시스템에 악성 프로그램이 자동으로 설치되도록 유도한다. 공격자는 불특정 다수를 노리는 것이 아니라 특정 조직이나 인물을 겨냥하며, 접속자의 IP나 환경 조건을 확인하여 목표 대상에게만 선택적으로 악성코드가 실행되도록 설계하는 경우도 있다.
피해자는 정상적인 사이트를 방문했을 뿐이므로 감염 사실을 인지하기 어렵다는 특징이 있다.','','','[]','[]','워터링 홀 (Watering Hole)','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [워터링 홀 (Watering Hole)] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(337,17,17,2,2,'코드 출력 결과형','17.다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main {
    public static void main(String[] args) {
        int x1 = 9;
        int x2 = 2;
        String x3 = "3";
        System.out.println(x1 + x2 + "2" + x3);
    }
}','java','[]','[]','1123','[Java 객체지향 실행 과정 분석]
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [1123] 입니다.');
INSERT INTO "questions" VALUES(338,17,18,2,3,'SQL 작성·빈칸형','18. 다음은 SQL에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','SELECT COUNT(*)
FROM employee e
JOIN dept d ON e.dep_id = d.dept_id
WHERE d.budget > (
SELECT AVG(budget) FROM dept
);','sql','[]','[{"local": "/images/questions/q_338_1.png", "remote": "https://blog.kakaocdn.net/dna/bcwdlQ/dJMcaduV5BY/AAAAAAAAAAAAAAAAAAAAACLQegXzkNQDpKJQCJYGDtH8WcNVf4O8rjbmiTqOe0FD/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=i2N52BV7YzivGJ6KApKO4sRBHUU%3D"}]','2','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [2] 입니다.');
INSERT INTO "questions" VALUES(339,17,19,1,10,'괄호 빈칸 채우기형','19.다음은 통합 테스트에서 사용되는 더미 모듈에 대한 설명이다. 괄호 안에 들어갈 알맞은 용어를 쓰시오.','( 1 ) 은/는 하위 모듈을 대신하여 단순한 결과값만 반환하도록 임시로 작성된 더미 모듈로, 하향식 통합 테스트 수행 시 필요하다.
( 2 ) 은/는 상위 모듈을 대신하여 하위 모듈의 데이터 입력과 출력을 확인하기 위한 더미 모듈로, 상향식 통합 테스트 수행 시 필요하다.','','','[]','[]','1. 스텁
2. 드라이버','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 스텁
2. 드라이버] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(340,17,20,1,14,'괄호 빈칸 채우기형','20. 다음은 응집도의 유형에 대한 설명이다. 괄호 안에 들어갈 알맞은 용어를 쓰시오.','( 1 ) 은/는 모듈이 다수의 관련 기능을 가질 때, 모듈 안의 구성요소들이 그 기능을 순차적으로 수행하는 경우의 응집도이다.
( 2 ) 은/는 동일한 입력과 출력을 사용하여 서로 다른 기능을 수행하는 활동들이 모여 있는 경우의 응집도이다.
( 3 ) 은/는 모듈 내부의 모든 기능이 단일한 목적을 위해 수행되는 경우의 응집도이다.','','','[]','[]','1. 절차
2. 교환
3. 기능','[결합도/응집도 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [1. 절차
2. 교환
3. 기능] 입니다.
• 학습 가이드: [결합도/응집도] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(341,18,1,1,10,'보기·기호 선택형','1. 다음은 블랙박스 테스트 기법에 대한 설명이다. 괄호 ( ) 안에 들어갈 말을 보기에서 골라 쓰시오.','( )은 프로그램의 입력 조건을 유효한 값과 유효하지 않은 값의 영역으로 나누고, 각 영역을
대표할 수 있는 값을 선정하여 테스트 케이스를 설계하는 명세 기반(블랙박스) 테스트 기법이다.
위 표에서 테스트 값으로 60을 입력하였을 때, 예상 결과와 실제 결과가 모두 등급 D로
일치하였다. 이는 ( ) 기법을 적용하여 각 등급 구간의 대표값을 테스트한 사례이다.
보기
ㄱ. 동치분할 (Equivalence Partitioning)
ㄴ. 경계값분석 (Boundary Value Analysis)
ㄷ. 결정테이블 테스트 (Decision Table Testing)
ㄹ. 상태전이 테스트 (State Transition Testing)','','','[]','[{"local": "/images/questions/q_341_1.png", "remote": "https://blog.kakaocdn.net/dna/cs8zYV/dJMcag7j8qX/AAAAAAAAAAAAAAAAAAAAAM1CaaVDMUc3j9v1W9_UIS5HyLYdBwSPYCSTOevXvrmT/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=b12Aaeub1iUd0UF1bZVEyA2T0nU%3D"}]','ㄱ. 동치분할 (Equivalence Partitioning)','[소프트웨어 테스트/품질 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㄱ. 동치분할 (Equivalence Partitioning)] 입니다.
• 학습 가이드: [소프트웨어 테스트/품질] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(342,18,2,2,2,'코드 출력 결과형','2. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class A {
    private int a;

    public A(int a) {
        this.a = a;
    }

    void print() {
        System.out.print(a + "a");
    }
}

class B extends A {
    private int b;

    B(int a, int b) {
        super(a);
        this.b = b;
    }

    void print() {
        super.print();
        System.out.print(b + "b");
    }
}

public class Main {
    public static void main(String[] args) {
        B obj = new B(10, 20);
        obj.print();
    }
}','java','[]','[]','10a20b','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [10a20b] 입니다.');
INSERT INTO "questions" VALUES(343,18,3,1,14,'보기·기호 선택형','3. 다음은 소프트웨어 모듈 간의 결합도(Coupling)에 대한 설명이다. 괄호 안에 들어갈 말을 보기에서 골라 기호로 쓰시오.','( )는 한 모듈이 다른 모듈 내부에 있는 변수나 기능을 직접 참조하거나 사용하는 경우에 발생하는 결합도로, 결합도 종류 중 결합 강도가 가장 높은 형태이다.
보기
ㄱ. 자료결합도 (Data Coupling)
ㄴ. 스탬프결합도 (Stamp Coupling)
ㄷ. 제어결합도 (Control Coupling)
ㄹ. 외부결합도 (External Coupling)
ㅁ. 내용결합도 (Content Coupling)
ㅂ. 공통결합도 (Common Coupling)','','','[]','[]','ㅁ. 내용결합도 (Content Coupling)','[결합도/응집도 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [ㅁ. 내용결합도 (Content Coupling)] 입니다.
• 학습 가이드: [결합도/응집도] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(344,18,4,1,5,'괄호 빈칸 채우기형','4. 다음은 라우팅 프로토콜에 대한 설명이다. 괄호 안에 들어갈 알맞은 용어를 쓰시오.','( )는 링크 상태(Link State) 알고리즘을 사용하는 대표적인 내부 라우팅 프로토콜(IGP)이다. 다익스트라(Dijkstra) 알고리즘을 이용하여 최단 경로를 탐색하며, 대규모 네트워크에 적합하고 멀티캐스트를 지원한다.','','','[]','[]','OSPF (Open Shortest Path First)','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [OSPF (Open Shortest Path First)] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(345,18,5,2,4,'코드 출력 결과형','5.다음은 파이썬 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class LocationDict:
    locations = {
        "NYC": "New York",
        "LON": "London",
        "PAR": "Paris",
        "TKY": "Tokyo"
    }

tmpdict = LocationDict()
str01 = ""
for key, location in tmpdict.locations.items():
    keyk = key[-1]
    locationk = location[0]
    str01 += keyk + locationk

print(str01, end="")','python','[]','[]','CNNLRPYT','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [CNNLRPYT] 입니다.');
INSERT INTO "questions" VALUES(346,18,6,2,4,'코드 출력 결과형','6.다음은 파이썬 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','a = "_THIS_IS_KIM_SPEAKING"
b = a[:4]
c = a[6:8]
d = a[18:]
e = b + c + d
print(e)','python','[]','[]','_THIISING','[Python 코드 실행 과정 분석]
• 시퀀스 슬라이싱: sequence[시작:끝:증감폭] 규칙에 따라 부분 리스트/문자열을 추출합니다. (음수 step은 역방향 탐색)
• 자료구조 및 내장 함수: 리스트, 딕셔너리, 집합(Set)의 메서드 및 조건부 컴프리헨션 결과를 반영합니다.
• print() 문에 의해 최종 출력되는 결과값은 [_THIISING] 입니다.');
INSERT INTO "questions" VALUES(347,18,7,2,1,'코드 출력 결과형','7. 다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

typedef struct N {
    int v;
    struct N* a;
    struct N* b;
} N;

int c = 0;
int ans = 0;

void pst(N *n) {
    if (!n) return;
    pst(n->a);
    pst(n->b);
    if (++c == 3) ans = n->v;
}

int main() {
    N ne = {35, 0, 0};
    N nd = {64, 0, 0};
    N nc = {53, 0, 0};
    N nb = {12, &ne, &nc};
    N na = {21, &nb, &nd};

    pst(&na);
    printf("%d\n", ans);
    return 0;
}','c','[]','[]','12','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [12] 입니다.');
INSERT INTO "questions" VALUES(348,18,8,1,12,'수식·계산 도출형','8. 다음 프로세스들을 SRT(Shortest Remaining Time) 스케줄링 기법으로 처리할 때, 평균 대기시간을 구하시오. (단위: ms)','','','','[]','[{"local": "/images/questions/q_348_1.png", "remote": "https://blog.kakaocdn.net/dna/bg1SJ4/dJMcabZlvUE/AAAAAAAAAAAAAAAAAAAAAMOykm5WvUEmLnQnGZkjPwZWIQDzJ1id3L6tIA4EvfCz/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=6H9fQludOAJD3rdMZBD6ELQYotY%3D"}]','6.5ms','[운영체제(스케줄링/메모리) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [6.5ms] 입니다.
• 학습 가이드: [운영체제(스케줄링/메모리)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(349,18,9,2,1,'코드 출력 결과형','9.다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

void fn1(int* i) { *i = 50; }
void fn2(int i) { i = 60; }

void fn34(int* p) {
    printf("3. %d\n", *p);
    printf("4. %d\n", *(p + 3));
}

int main() {
    int i = 30;
    int list[] = {2, 4, 6, 8, 10};

    fn1(&i);
    printf("1. %d\n", i);

    fn2(i);
    printf("2. %d\n", i);

    fn34(list);

    return 0;
}','c','[]','[]','1. 50
2. 50
3. 2
4. 8','[C언어 실행 과정 분석]
• 포인터 및 주소 연산: 배열의 시작 주소와 포인터 연산(*(p + i), p->필드)이 가리키는 메모리 위치를 순서대로 추적합니다.
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [1. 50
2. 50
3. 2
4. 8] 입니다.');
INSERT INTO "questions" VALUES(350,18,10,1,5,'괄호 빈칸 채우기형','10. 다음은 네트워크 A, B, C에 속한 호스트의 IP 주소 목록이다. 괄호 안에 들어갈 수 있는 IP 주소를 각각 하나씩 쓰시오.','','','','[]','[{"local": "/images/questions/q_350_1.png", "remote": "https://blog.kakaocdn.net/dna/cBrkGy/dJMcabZlxM4/AAAAAAAAAAAAAAAAAAAAAK25-IeVuinOb3t586IVwhdnyju1Rx1u0i649P00UC17/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=Q8jfXXt%2FJUOXueHT%2F84LQekFgu4%3D"}]','2. 192.168.35.72
4. 129.200.8.249
5. 192.168.36.249','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [2. 192.168.35.72
4. 129.200.8.249
5. 192.168.36.249] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(351,18,11,1,9,'괄호 빈칸 채우기형','11. 다음은 GoF(Gang of Four) 디자인 패턴에 대한 설명이다. 괄호 안에 들어갈 알맞은 용어를 쓰시오.','( )는 서로 관련 있는 여러 객체(제품군)를 생성하기 위한 인터페이스를 제공하는 생성 패턴으로, Kit이라고도 불린다. 이 패턴을 사용하면 구체적인 클래스를 지정하지 않고도 연관된 제품군 전체를 한 번에 변경할 수 있다.','','','[]','[]','추상 팩토리 (Abstract Factory)','[디자인 패턴 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [추상 팩토리 (Abstract Factory)] 입니다.
• 학습 가이드: [디자인 패턴] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(352,18,12,2,3,'SQL 작성·빈칸형','12. 다음 <학생> 테이블에서 성이 ''이''씨인 학생의 정보를 조회하되, 학번을 기준으로 내림차순 정렬하여 출력하고자 한다. SQL문의 괄호 안에 들어갈 알맞은 내용을 각각 쓰시오.','','','sql','[]','[{"local": "/images/questions/q_352_1.png", "remote": "https://blog.kakaocdn.net/dna/cFBUQ1/dJMcahSFE1V/AAAAAAAAAAAAAAAAAAAAAITWrNrt-YgbCprVUhfw4gZL2o3iiY3752R-XD5nPxD0/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=pGjbq98bpWhkIJdViEkfXKik%2BbE%3D"}]','1. 이%
2. DESC','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [1. 이%
2. DESC] 입니다.');
INSERT INTO "questions" VALUES(353,18,13,2,3,'SQL 결과 도출형','13. 다음 <A>, <B> 테이블과 SQL문을 참고하여, SQL문을 실행했을 때 출력되는 RESULT 값을 구하시오.','','','sql','[]','[{"local": "/images/questions/q_353_1.png", "remote": "https://blog.kakaocdn.net/dna/p4Lvi/dJMcadW6aGU/AAAAAAAAAAAAAAAAAAAAACefJ-y05TFYmxnsghCGFshdirzb7a9EN3FvWP4cRzTi/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=%2BPhI6mDQS2ZHHWt%2FDl%2FBV2Pp0OI%3D"}]','3','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [3] 입니다.');
INSERT INTO "questions" VALUES(354,18,14,2,3,'SQL 결과 도출형','14. 다음 <A>, <B> 테이블과 SQL문을 참고하여, SQL문을 실행했을 때 출력되는 결과값을 구하시오.','','','sql','[]','[{"local": "/images/questions/q_354_1.png", "remote": "https://blog.kakaocdn.net/dna/b3mEm8/dJMcadW7PRw/AAAAAAAAAAAAAAAAAAAAALaV3vhhQ45c1Y0NutdbO5wNoFYJy_jBNRXI_X1JTB4F/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=JLmhTu4D8b8jDIafR%2FurQhlNMLw%3D"}]','2','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [2] 입니다.');
INSERT INTO "questions" VALUES(355,18,15,2,2,'코드 출력 결과형','15. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class A {
    int a;
    private int b;
    protected int c;

    void set(int aa, int bb, int cc) {
        a = aa;
        b = bb;
        c = cc;
    }

    int hap() { return a + b + c; }
}

class B extends A {
    public int hap() { return a * c; }
}

public class Main {
    public static void main(String[] args) {
        A aaa = new A();
        B bbb = new B();

        aaa.set(1, 5, 3);
        bbb.set(10, 30, 50);

        System.out.print(aaa.hap() + bbb.hap());
    }
}','java','[]','[]','509','[Java 객체지향 실행 과정 분석]
• 상속 및 다형성(동적 바인딩): 부모 클래스 생성자(super)가 먼저 실행되며, 오버라이딩된 메서드는 실제 생성된 자식 인스턴스 기준으로 호출됩니다. (단, 멤버 필드는 참조 변수 타입을 따릅니다.)
• static 정적 멤버: 클래스 메모리에 단 하나만 존재하여 모든 객체 인스턴스가 값을 공유하고 누적합니다.
• System.out 출력문에 의해 최종 도출되는 결과값은 [509] 입니다.');
INSERT INTO "questions" VALUES(356,18,16,1,5,'핵심 용어 단답형','16. 다음은 IP 주소 서브네팅(Subnetting)에 대한 설명이다. 물음에 답하시오.','10.0.0.0/27 네트워크를 동일한 크기의 2개 서브넷으로 분할하였다.
- 첫 번째 서브넷: 10.0.0.0 ~ 10.0.0.15
- 두 번째 서브넷: 10.0.0.16 ~ 10.0.0.31
이때 10.0.0.1이 속한 서브넷의 프리픽스 길이(비트 수)를 구하시오.','','','[]','[]','28','[네트워크/프로토콜 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [28] 입니다.
• 학습 가이드: [네트워크/프로토콜] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(357,18,17,1,8,'핵심 용어 단답형','17. 다음 설명에 해당하는 보안 기술 용어를 쓰시오.','입력값의 길이와 상관없이 항상 정해진 길이의 결과값을 만들어내는 암호 기술이 있다.
이 기술은 단방향성을 가지고 있어 결과값만으로는 원래의 입력값을 알아낼 수 없으며, 서로 다른 두 입력값이 같은 결과값을 만들어내는 경우가 최대한 발생하지 않도록 설계되어야 한다.
이러한 성질을 가진 암호 기술을 무엇이라 하는가?','','','[]','[]','해시','[보안/암호학 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [해시] 입니다.
• 학습 가이드: [보안/암호학] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(358,18,18,2,1,'코드 출력 결과형','18.다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

int c(int n) {
    if (n <= 1) return n;
    return c(n - 1) + c(n - 3);
}

int main() {
    printf("%d", c(5));
    return 0;
}','c','[]','[]','1','[C언어 실행 과정 분석]
• 함수 호출 및 반환: 매개변수 전달 방식(Call by Value / Reference)과 재귀·호출 반환값을 확인합니다.
• 표준 출력(printf) 형식 지정자에 따라 최종 출력되는 정답은 [1] 입니다.');
INSERT INTO "questions" VALUES(359,18,19,2,3,'SQL 작성·빈칸형','19. 다음은 SEASON이라는 도메인을 정의하면서, 입력 가능한 값을 봄/여름/가을/겨울로 제한하는 SQL문이다. 괄호 안에 들어갈 알맞은 키워드를 쓰시오','','','sql','[]','[{"local": "/images/questions/q_359_1.png", "remote": "https://blog.kakaocdn.net/dna/3iiFP/dJMcagGmJVU/AAAAAAAAAAAAAAAAAAAAAJuIYd5Zoos16JeRryLDf36vYRHiZPcPSsFA3NrNwmUP/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=8EUZw%2FGWnrrjXI1dYjkrKcaPOsk%3D"}]','CHECK','[SQL 질의 분석 및 풀이]
• SQL 문법 체계(SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY) 및 DDL/DML 제약 규칙을 적용합니다.
• 조건 필터링 및 집계 함수(COUNT, SUM, AVG 등, NULL 제외 규칙 유의)를 수행한 최종 정답은 [CHECK] 입니다.');
INSERT INTO "questions" VALUES(360,18,20,1,13,'핵심 용어 단답형','20. 아래 표에서 나타나고 있는 정규형을 작성하시오.','','','','[]','[{"local": "/images/questions/q_360_1.png", "remote": "https://blog.kakaocdn.net/dna/qHioy/dJMcaixnbjc/AAAAAAAAAAAAAAAAAAAAAGoeHCXF7A6pig90kFsjsgfYTTzutbRh61KrzGVQAXL-/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1793458799&allow_ip=&allow_referer=&signature=rKOa%2B1jvt5ocP8lH2wA03eGTrwM%3D"}]','제 3정규형','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 핵심 키워드: 지문에서 제시한 요구 조건과 특징을 만족하는 기술/개념은 [제 3정규형] 입니다.
• 학습 가이드: [데이터베이스(설계/정규화)] 분류에서 반복 출제되는 핵심 개념이므로 정확한 영문 약어와 한글 명칭을 함께 숙지하세요.');
INSERT INTO "questions" VALUES(361,19,1,2,3,'SQL 결과 도출형','1. 다음 테이블 <A>와 <B>에 대해 아래 SQL문을 실행했을 때 출력되는 result 값을 작성하시오.','','SELECT COUNT(*) AS result
FROM A
LEFT JOIN B ON A.id = B.id
WHERE B.id IS NULL;','sql','[{"type": "grid", "rows": [["[테이블 A] id"], ["1"], ["2"], ["3"]]}, {"type": "grid", "rows": [["[테이블 B] id"], ["1"]]}]','[]','2','[SQL 질의 분석 및 풀이]
• LEFT JOIN(LEFT OUTER JOIN)은 왼쪽 테이블(A)의 모든 행(1, 2, 3)을 유지하고, 오른쪽 테이블(B)에 매칭되는 값이 없으면 NULL로 채웁니다.
• 조인 결과: (1, 1), (2, NULL), (3, NULL)
• WHERE B.id IS NULL 조건에 의해 B에 매칭되지 않은 id=2, id=3 두 행만 남으므로 COUNT(*) 결과는 2입니다.');
INSERT INTO "questions" VALUES(362,19,2,1,13,'괄호 빈칸 채우기형','2. 다음 설명에 해당하는 데이터베이스 설계 단계를 <보기>에서 골라 ①~③에 알맞은 단계를 쓰시오.','① 운영체제와 목표 DBMS의 특성을 고려하여 데이터베이스의 내부 저장 구조, 인덱스, 접근 경로 등을 설계하는 단계
② 요구사항 분석 결과를 바탕으로 특정 DBMS에 독립적인 개념 스키마를 설계하고 E-R 다이어그램으로 표현하는 단계
③ 개념적 구조를 목표 DBMS에 맞는 관계형 테이블 구조와 논리적 스키마로 변환하고 정규화를 수행하는 단계','','','[{"type": "box", "content": "개념적 설계, 논리적 설계, 물리적 설계"}]','[]','① 물리적 설계
② 개념적 설계
③ 논리적 설계','[데이터베이스(설계/정규화) 핵심 개념 해설]
• 전체 DB 설계 순서: 요구조건 분석 → 개념적 설계(ERD, DBMS 독립적) → 논리적 설계(릴레이션 스키마 변환, 정규화, 트랜잭션 인터페이스) → 물리적 설계(내부 저장 구조, 인덱스, 접근 경로) → 구현
• 지문은 순서를 섞어서 제시했으므로 단서 키워드(① 내부 저장 구조/인덱스 = 물리적 설계, ② DBMS 독립적/E-R 다이어그램 = 개념적 설계, ③ 테이블 구조/스키마/정규화 = 논리적 설계)로 정확히 매칭해야 합니다.');
INSERT INTO "questions" VALUES(363,19,3,2,3,'SQL 작성·빈칸형','3. 다음 <STUDENT> 테이블에서 학생의 이름(name)과 점수(score)를 점수가 높은 순서(내림차순)로 조회하도록 SQL문의 빈칸 ①~③을 채우시오.','','SELECT name, score
FROM STUDENT
( ① ) BY ( ② ) ( ③ );','sql','[{"type": "grid", "rows": [["id", "name", "score"], ["1", "김민수", "80"], ["2", "이지은", "95"], ["3", "박서준", "70"], ["4", "최유진", "85"]]}]','[]','① ORDER
② score
③ DESC','[SQL 질의 분석 및 풀이]
• 정렬 절은 ORDER BY <컬럼명> [ASC|DESC] 구문을 사용합니다.
• 점수가 높은 순서(내림차순)로 정렬해야 하므로 ① ORDER, ② score, ③ DESC 를 작성합니다. (① 뒤에 BY가 이미 인쇄되어 있으므로 ①에는 ORDER만 작성)');
INSERT INTO "questions" VALUES(364,19,4,1,9,'보기·기호 선택형','4. 다음 설명에 해당하는 GoF 디자인 패턴을 <보기>에서 골라 기호를 쓰시오.','생성(Creational) 패턴 중 하나로, 객체를 생성하기 위한 인터페이스를 상위 클래스에서 정의하고, 실제로 어떤 클래스의 인스턴스를 생성할지는 서브클래스(하위 클래스)에서 결정하도록 위임하는 디자인 패턴이다.','','','[{"type": "box", "content": "ㄱ. Adapter   ㄴ. Singleton   ㄷ. Template Method   ㄹ. Decorator\nㅁ. Observer   ㅂ. Strategy   ㅅ. Factory Method   ㅇ. Mediator"}]','[]','ㅅ. Factory Method (팩토리 메서드)','[디자인 패턴 핵심 개념 해설]
• Factory Method(팩토리 메서드, 생성 패턴): 상위 클래스에서는 객체 생성 인터페이스만 정의하고 실제 구체 클래스 인스턴스 생성을 하위 클래스에 위임하는 패턴입니다. (Virtual Constructor라고도 함)
• 함정 비교: Template Method(행위 패턴)는 알고리즘의 골격을 상위 클래스에 정의하고 세부 단계를 하위 클래스에서 구현하는 것이며, "생성 패턴" 및 "객체 생성 위임"이 핵심 단서이므로 Factory Method가 정답입니다.');
INSERT INTO "questions" VALUES(365,19,5,2,1,'코드 출력 결과형','5. 다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

int add(int a, int b) {
    return a + b;
}
int sub(int a, int b) {
    return a - b;
}

typedef struct {
    int value;
    int (*fn)(int, int);
} Item;

int main(void) {
    Item arr[2] = {{3, add}, {10, sub}};
    Item *p = arr;
    Item *ptr;
    int a, b;

    p++;
    ptr = p;
    a = p->value;
    p--;
    b = p->value;

    printf("%d", ptr->fn(a, b));
    return 0;
}','c','[]','[]','7','[C언어 실행 과정 분석]
• Item *p = arr; → p는 arr[0]({3, add})을 가리킵니다.
• p++; → p가 arr[1]({10, sub})로 이동합니다.
• ptr = p; → ptr도 현재 p가 가리키는 arr[1]의 주소를 복사받아 저장합니다.
• a = p->value; → arr[1].value 이므로 a = 10 입니다.
• p--; b = p->value; → p만 다시 arr[0]으로 이동하여 b = 3 이 됩니다. (단, ptr은 여전히 arr[1]을 가리킴)
• ptr->fn(a, b)는 arr[1].fn(10, 3) 즉 sub(10, 3)을 호출하므로 10 - 3 = 7이 출력됩니다.');
INSERT INTO "questions" VALUES(366,19,6,1,8,'괄호 빈칸 채우기형','6. 다음 설명에 해당하는 대칭키 블록 암호화 알고리즘을 괄호 ①, ②에 각각 쓰시오.','① 스위스의 Xuejia Lai와 James Massey가 개발한 대칭키 블록 암호 알고리즘으로, PES와 IPES를 거쳐 ( ① )(으)로 명명되었다. 128비트 키를 사용하여 64비트 평문 블록을 8라운드에 걸쳐 암호화한다.
② ( ② )은/는 미국 국가안보국(NSA)이 개발한 Clipper 칩에 내장된 대칭키 블록 암호 알고리즘이다. Fortezza 카드에 칩 형태로 구현되었으며 64비트 입출력 블록, 80비트 키, 32라운드로 동작한다.','','','[]','[]','① IDEA
② Skipjack','[보안/암호학 핵심 개념 해설]
• IDEA (International Data Encryption Algorithm): Lai와 Massey가 개발(PES → IPES → IDEA), 128비트 키 / 64비트 블록 / 8라운드 대칭키 블록 암호.
• Skipjack: 미국 NSA가 개발하여 클리퍼(Clipper) 칩 및 Fortezza 카드에 탑재한 음성·통신용 대칭키 블록 암호 (80비트 키 / 64비트 블록 / 32라운드).');
INSERT INTO "questions" VALUES(367,19,7,1,10,'보기·기호 선택형','7. 다음은 입력값의 범위에 따라 처리하는 프로그램의 테스트 데이터와 결과이다. 적용된 블랙박스 테스트 기법을 <보기>에서 골라 기호를 쓰시오.','입력값은 0 이상 100 이하의 정수이고, 세 구간(0 이상 10 미만 / 10 이상 70 미만 / 70 이상 100 이하)으로 나누어 처리하며 범위를 벗어난 입력값은 오류로 처리한다.','','','[{"type": "grid", "rows": [["테스트 데이터", "-1", "0", "1", "9", "10", "11", "69", "70", "71", "99", "100", "101"], ["테스트 결과", "오류", "정상", "정상", "정상", "정상", "정상", "정상", "정상", "정상", "정상", "정상", "오류"]]}, {"type": "box", "content": "ㄱ. 동치 분할 테스트   ㄴ. 원인-결과 그래프 테스트   ㄷ. 결정 테이블 테스트   ㄹ. 경계값 분석\nㅁ. 오류 예측 테스트   ㅂ. 상태 전이 테스트   ㅅ. 유스케이스 테스트   ㅇ. 비교 테스트"}]','[]','ㄹ. 경계값 분석 (Boundary Value Analysis)','[소프트웨어 테스트/품질 핵심 개념 해설]
• 경계값 분석(Boundary Value Analysis): 입력 조건의 중간값보다 경계(0, 10, 70, 100) 및 그 인접값(-1·0·1, 9·10·11, 69·70·71, 99·100·101)에서 결함이 발생할 확률이 높다는 점을 이용해 테스트 케이스를 선정하는 블랙박스 테스트 기법입니다.');
INSERT INTO "questions" VALUES(368,19,8,1,8,'보기·기호 선택형','8. 다음 설명에 해당하는 접근 통제(Access Control) 방식을 <보기>에서 골라 쓰시오.','사용자에게 개별적으로 접근 권한을 부여하면 직책이나 업무가 바뀔 때마다 권한이 누적되어 관리가 복잡해진다. 이를 해결하기 위해 조직의 직무·직책(역할)별로 필요한 접근 권한을 미리 정의해 두고, 사용자에게는 해당 역할을 부여하여 자원에 접근하도록 통제하는 방식이다.','','','[{"type": "box", "content": "MAC, DAC, RBAC, PBAC"}]','[]','RBAC (Role-Based Access Control)','[보안/암호학 핵심 개념 해설]
• RBAC(역할 기반 접근 통제): 권한을 개인이 아닌 직무·직책(Role)에 할당하고 사용자에게 역할을 부여하는 방식입니다.
• DAC(임의적 접근 통제): 데이터 소유자의 재량으로 신분(ID)에 따라 권한 부여.
• MAC(강제적 접근 통제): 시스템이 보안 등급(Label)에 따라 강제 통제.');
INSERT INTO "questions" VALUES(369,19,9,2,1,'코드 출력 결과형','9. 다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

typedef struct Node {
    int value;
    struct Node *left;
    struct Node *right;
} Node;

int cnt = 0;

void pre(Node *n) {
    if (!n) return;
    if (++cnt == 3) {
        printf("%d", n->value);
        return;
    }
    pre(n->left);
    pre(n->right);
}

int main(void) {
    Node n4 = {4, NULL, NULL};
    Node n5 = {5, NULL, NULL};
    Node n2 = {2, &n4, &n5};
    Node n3 = {3, NULL, NULL};
    Node n1 = {1, &n2, &n3};

    pre(&n1);
    return 0;
}','c','[]','[]','4','[C언어 실행 과정 분석]
• 트리 구조: 루트 n1(1)의 왼쪽 자식은 n2(2), 오른쪽 자식은 n3(3)이며, n2(2)의 왼쪽 자식은 n4(4), 오른쪽 자식은 n5(5)입니다.
• pre() 함수는 자식 노드 재귀 호출 전에 ++cnt를 수행하므로 전위 순회(Pre-order: 현재 노드 → 왼쪽 → 오른쪽) 순서로 카운트합니다.
• 방문 순서: 1번째 n1(1) [cnt=1] → 2번째 n2(2) [cnt=2] → 3번째 n4(4) [cnt=3].
• cnt가 3이 되는 순간 n4->value 인 4를 출력합니다.');
INSERT INTO "questions" VALUES(370,19,10,1,5,'수식·계산 도출형','10. 192.168.1.0/24 네트워크를 FLSM 방식으로 3개 네트워크에 사용할 수 있도록 서브네팅하려 한다. IP Subnet-zero를 적용하며 첫 번째 네트워크가 192.168.1.0/26일 때, 두 번째 네트워크의 브로드캐스트 주소를 10진수로 쓰시오.','','','','[]','[]','192.168.1.127','[네트워크/프로토콜 계산 풀이]
• 192.168.1.0/24 대역을 최소 3개 이상의 동일 크기 서브넷(FLSM)으로 나누려면 2비트(2² = 4개 서브넷)가 필요하여 프리픽스는 /26(마스크 255.255.255.192)이 됩니다.
• 호스트 비트가 6비트이므로 각 서브넷의 블록 크기는 2⁶ = 64입니다.
• 1번째 서브넷: 192.168.1.0 ~ 192.168.1.63
• 2번째 서브넷: 192.168.1.64 ~ 192.168.1.127 (네트워크 주소: 192.168.1.64, 브로드캐스트 주소: 192.168.1.127)
• 따라서 두 번째 네트워크의 브로드캐스트 주소는 192.168.1.127 입니다.');
INSERT INTO "questions" VALUES(371,19,11,1,11,'괄호 빈칸 채우기형','11. 다음 UML(Unified Modeling Language) 구성 요소에 대한 설명을 읽고 빈칸 ①~③에 들어갈 알맞은 용어를 쓰시오.','• UML의 3대 기본 구성 요소는 사물(Things), ( ① ), 다이어그램(Diagrams)이다.
• 구조(정적) 사물 중 ( ② )은/는 동일한 속성, 연산, 관계, 의미를 공유하는 객체들의 집합을 정의한다.
• 구조(정적) 사물 중 ( ③ )은/는 클래스나 컴포넌트가 외부에 제공하는 서비스나 기능을 명세하는 연산(Operation)들의 집합으로, 구현 내용은 포함하지 않으며 <<interface>> 스테레오타입 기호로 표기한다.','','','[]','[]','① 관계 (Relationships)
② 클래스 (Class)
③ 인터페이스 (Interface)','[요구사항/UML/설계 핵심 개념 해설]
• ① UML 3대 구성 요소는 사물(Things), 관계(Relationships), 다이어그램(Diagrams)입니다.
• ② 공통된 속성과 연산을 공유하는 객체들의 집합(틀)은 클래스(Class)입니다.
• ③ 구현 없이 외부에 제공하는 오퍼레이션(연산)의 집합만 명세하는 사물은 인터페이스(Interface)입니다.');
INSERT INTO "questions" VALUES(372,19,12,2,3,'SQL 결과 도출형','12. 다음 <SALES> 테이블에 대해 아래 SQL문을 실행했을 때 출력되는 RESULT 값을 작성하시오.','','SELECT MAX(AMOUNT) AS RESULT
FROM SALES
WHERE YEAR = 2023
  AND QUARTER IN (
      SELECT QUARTER
      FROM SALES
      WHERE YEAR = 2023
        AND AMOUNT < (
            SELECT AVG(AMOUNT)
            FROM SALES
            WHERE YEAR = 2023
        )
  );','sql','[{"type": "grid", "rows": [["YEAR", "QUARTER", "AMOUNT"], ["2023", "1", "100"], ["2023", "2", "150"], ["2023", "3", "130"], ["2023", "4", "170"], ["2024", "1", "120"], ["2024", "3", "200"]]}]','[]','130','[SQL 질의 분석 및 풀이]
1. 가장 안쪽 서브쿼리: 2023년 데이터의 AMOUNT 평균 = (100 + 150 + 130 + 170) / 4 = 137.5
2. 가운데 서브쿼리: 2023년 행 중 AMOUNT < 137.5 인 분기(QUARTER)는 1분기(100)와 3분기(130) → QUARTER IN (1, 3)
3. 메인 쿼리: YEAR = 2023 이면서 QUARTER가 1 또는 3인 행(100, 130) 중 MAX(AMOUNT)를 구하므로 정답은 130 입니다. (바깥 WHERE절에 YEAR = 2023 조건이 있으므로 2024년 3분기 200은 제외됨)');
INSERT INTO "questions" VALUES(373,19,13,2,1,'코드 출력 결과형','13. 다음은 C언어 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','#include <stdio.h>

typedef struct Node {
    int x;
    int (*fn)(struct Node **);
} Node;

int incr(Node **pp) {
    Node *n = *pp;
    n->x = n->x + 1;
    return n->x;
}

int fn_cnt(Node **pp) {
    Node *p = *pp;
    int a = p->fn(pp);
    int b = p->fn(pp);
    return b;
}

int main(void) {
    Node a = {11, incr};
    Node *p = &a;
    Node **pp = &p;
    printf("%d\n", fn_cnt(pp));
    return 0;
}','c','[]','[]','13','[C언어 실행 과정 분석]
• Node a = {11, incr}; 이고 p는 &a, 이중 포인터 pp는 &p를 가리킵니다.
• fn_cnt(pp) 내부에서 p->fn(pp)는 incr(pp)를 호출하며, *pp는 원본 구조체 a를 가리키므로 호출할 때마다 a.x 원본 값이 1씩 증가합니다.
• 첫 번째 호출: a.x가 11 → 12가 되고 a = 12 반환.
• 두 번째 호출: a.x가 12 → 13이 되고 b = 13 반환.
• 최종 반환값 b = 13 이 출력됩니다.');
INSERT INTO "questions" VALUES(374,19,14,2,2,'코드 출력 결과형','14. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main {
    static class Parent {
        int a = 1;
        int meth() {
            return a;
        }
    }
    static class Child extends Parent {
        int a = 1;
        int meth() {
            return a + super.a;
        }
    }
    public static void main(String[] args) {
        Parent obj = new Child();
        System.out.println(obj.meth());
    }
}','java','[]','[]','2','[Java 객체지향 실행 과정 분석]
• Parent obj = new Child(); 업캐스팅 상태에서 오버라이딩된 인스턴스 메서드 obj.meth()를 호출하면 실제 생성된 자식 객체(Child)의 meth()가 동적 바인딩되어 실행됩니다.
• Child.meth() 내부에서 a는 Child의 필드(1)이고, super.a는 부모 Parent의 필드(1)이므로 1 + 1 = 2 가 출력됩니다.');
INSERT INTO "questions" VALUES(375,19,15,2,2,'코드 출력 결과형','15. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오. (출력 문자열의 공백 포함)','','public class Main {
    public static void main(String[] args) {
        int[][] a = {{0}, {1}, {2}};
        int[][] b = new int[3][];
        for (int i = 0; i < a.length; i++) {
            b[i] = a[i];
        }
        a[1] = new int[]{9};
        b[2][0] = 3;
        System.out.println(a[2][0] + " 그리고 " + b[1][0]);
    }
}','java','[]','[]','3 그리고 1','[Java 객체지향 실행 과정 분석]
• for문에서 b[i] = a[i]; 는 각 1차원 행 배열의 참조(주소)를 얕은 복사(Shallow Copy)합니다.
• a[1] = new int[]{9}; 는 a[1] 칸에 새로운 배열 객체 {9}의 주소를 재할당할 뿐이므로, b[1]은 여전히 기존 배열 {1}을 가리킵니다. 따라서 b[1][0]은 1입니다.
• b[2][0] = 3; 은 a[2]와 b[2]가 함께 공유하고 있는 행 배열의 0번째 원소 값을 직접 3으로 수정하므로 a[2][0]도 3이 됩니다.
• 따라서 최종 출력값은 "3 그리고 1" 입니다.');
INSERT INTO "questions" VALUES(376,19,16,1,8,'보기·기호 선택형','16. 다음 설명의 괄호 안에 공통으로 들어갈 보안 위협 용어를 <보기>에서 골라 기호를 쓰시오.','공격자가 시스템에 불법 침입한 뒤 자신의 존재와 활동 흔적을 숨기면서 시스템에 대한 최고 관리자 접근 권한(Root)을 지속적으로 유지하기 위해 사용하는 악성 도구 모음을 ( )이라고 한다. ( )은 백도어, 트로이 목마 등을 포함할 수 있으며, 커널이나 정상적인 운영체제 시스템 기능을 변조하여 프로세스·파일·로그 탐지를 회피한다.','','','[{"type": "box", "content": "ㄱ. Adware   ㄴ. Virus   ㄷ. Spyware   ㄹ. Keylogger\nㅁ. Ransomware   ㅂ. Worm   ㅅ. Rootkit   ㅇ. Trace Route"}]','[]','ㅅ. Rootkit (루트킷)','[보안/암호학 핵심 개념 해설]
• Rootkit(루트킷): 관리자 권한(Root) + 도구 모음(Kit)의 합성어로, 시스템 침입 후 해킹 사실과 악성 프로세스를 은폐하면서 관리자 권한을 지속 유지하는 악성 도구 집합입니다.');
INSERT INTO "questions" VALUES(377,19,17,2,2,'코드 출력 결과형','17. 다음은 Java 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','public class Main {
    static String convert(int value) {
        Integer num = value;
        return num.toString();
    }
    static String convert(double value) {
        Double num = null;
        if (value > 1) {
            num = value * 2;
        }
        return num.toString();
    }
    public static void main(String[] args) {
        try {
            System.out.println(convert(1.0));
        } catch (Exception e) {
            System.out.println("error");
        }
    }
}','java','[]','[]','error','[Java 객체지향 실행 과정 분석]
• convert(1.0) 호출 시 인자 1.0이 실수(double) 리터럴이므로 메서드 오버로딩 규칙에 의해 convert(double value)가 호출됩니다.
• if (value > 1) 에서 1.0 > 1 은 거짓(false)이므로 num은 초기값인 null 상태로 남습니다.
• return num.toString(); 실행 시 null 참조에 대해 인스턴스 메서드를 호출하므로 NullPointerException 예외가 발생합니다.
• main의 catch (Exception e) 블록으로 제어가 이동하여 "error"가 출력됩니다.');
INSERT INTO "questions" VALUES(378,19,18,1,6,'보기·기호 선택형','18. 다음 설명에 해당하는 소프트웨어 공급망 보안 용어를 <보기>에서 골라 쓰시오.','소프트웨어를 구성하는 오픈소스, 서드파티 라이브러리 등의 구성 요소와 버전, 라이선스, 의존 관계를 기록한 메타데이터 명세서(목록)이다. 소프트웨어 공급망의 투명성을 확보하고 Log4j 등 특정 컴포넌트의 보안 취약점 영향을 즉각 파악·관리하는 데 활용되며, 미국 연방정부에 소프트웨어를 공급할 때 제출이 의무화된 목록이다.','','','[{"type": "box", "content": "IAM, ZTA, SBOM, Privacy Sandbox, Cyber Resilience, RASP, Data Leakage Prevention, Cyber Kill Chain, Attack Surface"}]','[]','SBOM (Software Bill of Materials)','[소프트웨어 일반/신기술 핵심 개념 해설]
• SBOM(Software Bill of Materials, 소프트웨어 자재 명세서): 소프트웨어 개발 시 포함된 오픈소스 및 컴포넌트의 내역을 목록화한 명세서로, 소프트웨어 공급망 보안(Supply Chain Security)의 핵심 요소입니다. 대표 표준 포맷으로 SPDX, CycloneDX 등이 있습니다.');
INSERT INTO "questions" VALUES(379,19,19,2,4,'코드 출력 결과형','19. 다음은 파이썬(Python) 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','class NumberList:
    def __init__(self):
        self.data = [3, 5, 7, 9, 11]

    def change(self, index, value):
        if 0 <= index < len(self.data):
            self.data[index] = value

class Calculator(NumberList):
    def total(self):
        total = sum(self.data)
        return total

    def increase(self):
        for i in range(len(self.data)):
            self.data[i] += 1

calculator = Calculator()
calculator.change(2, 15)
calculator.increase()
print(calculator.total(), end="")','python','[]','[]','48','[Python 코드 실행 과정 분석]
• Calculator() 인스턴스 생성 시 부모 클래스 NumberList의 __init__이 호출되어 self.data = [3, 5, 7, 9, 11] 로 초기화됩니다.
• calculator.change(2, 15) 호출 시 인덱스 2(세 번째 원소 7)가 15로 변경되어 [3, 5, 15, 9, 11] 이 됩니다.
• calculator.increase() 호출 시 모든 원소에 1씩 더해져 [4, 6, 16, 10, 12] 가 됩니다.
• calculator.total() 은 리스트의 합계 4 + 6 + 16 + 10 + 12 = 48 을 반환하여 출력합니다.');
INSERT INTO "questions" VALUES(380,19,20,2,4,'코드 출력 결과형','20. 다음은 파이썬(Python) 코드에 대한 문제이다. 아래 코드를 확인하여 알맞는 출력값을 작성하시오.','','def f(x=[1]):
    x.append(x[-1] + 2)
    return x[-1]

print(max(f(), f()) - min(f(), f()))','python','[]','[]','-2','[Python 코드 실행 과정 분석]
• 파이썬 함수의 가변 기본 인자(Mutable Default Argument) x=[1]은 함수 정의 시점(def)에 단 한 번만 생성되며, 이후 인자 없이 f()를 호출할 때마다 동일한 리스트 객체 x를 계속 공유합니다.
• 1번째 f() 호출 (max 첫 인자): x가 [1, 3]이 되고 3 반환
• 2번째 f() 호출 (max 둘째 인자): x가 [1, 3, 5]가 되고 5 반환 → max(3, 5) = 5
• 3번째 f() 호출 (min 첫 인자): x가 [1, 3, 5, 7]이 되고 7 반환
• 4번째 f() 호출 (min 둘째 인자): x가 [1, 3, 5, 7, 9]가 되고 9 반환 → min(7, 9) = 7
• 따라서 5 - 7 = -2 가 출력됩니다.');
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
COMMIT;
