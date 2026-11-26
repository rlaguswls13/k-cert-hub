BEGIN TRANSACTION;
CREATE TABLE categories_domain (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL UNIQUE,
        domain_name TEXT NOT NULL,
        domain_name_en TEXT NOT NULL,
        official_weight_pct REAL NOT NULL,
        task_range TEXT NOT NULL,
        description TEXT NOT NULL
    );
INSERT INTO "categories_domain" VALUES(1,'D1_SECURE','Domain 1: 안전한 아키텍처 설계','Design Secure Architectures',30.0,'1.1–1.3','IAM/Identity Center 접근 제어, 멀티 계정 SCP/Organizations, KMS/Secrets Manager 암호화, VPC/WAF/Shield/PrivateLink 보안 설계');
INSERT INTO "categories_domain" VALUES(2,'D2_RESILIENT','Domain 2: 복원력이 뛰어난 아키텍처 설계','Design Resilient Architectures',26.0,'2.1–2.2','느슨한 결합(SQS/SNS/EventBridge/Step Functions), 다중 AZ/다중 리전 고가용성, DR 전략(Pilot Light/Warm Standby), Aurora/DynamoDB 복구');
INSERT INTO "categories_domain" VALUES(3,'D3_PERFORMANT','Domain 3: 고성능 아키텍처 설계','Design High-Performing Architectures',24.0,'3.1–3.5','S3 Express One Zone/EFS/EBS io2 스토리지, Lambda/Fargate/Batch 탄력 컴퓨팅, ElastiCache/Aurora Reader, CloudFront/Global Accelerator/TGW');
INSERT INTO "categories_domain" VALUES(4,'D4_COST','Domain 4: 비용 최적화 아키텍처 설계','Design Cost-Optimized Architectures',20.0,'4.1–4.4','Compute Savings Plans/Spot/RI, Graviton(arm64), S3/EBS 수명 주기·스냅샷 아카이브, VPC Gateway Endpoint·IPv4·데이터 전송 비용 절감');
CREATE TABLE categories_qtype (
        qtype_id INTEGER PRIMARY KEY,
        qtype_code TEXT NOT NULL UNIQUE,
        qtype_name TEXT NOT NULL,
        description TEXT NOT NULL
    );
INSERT INTO "categories_qtype" VALUES(1,'SINGLE','단일 선택 (Single Choice)','4개 선택지 중 최적의 아키텍처 1개 선택');
INSERT INTO "categories_qtype" VALUES(2,'MULTI','복수 선택 (Multiple Response)','5개 선택지 중 요구사항을 충족하는 복수 정답(2개) 선택');
CREATE TABLE cert_metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
    );
INSERT INTO "cert_metadata" VALUES('cert_id','aws-saa-c03');
INSERT INTO "cert_metadata" VALUES('exam_code','SAA-C03');
INSERT INTO "cert_metadata" VALUES('title','AWS Certified Solutions Architect - Associate (SAA-C03) RDB');
INSERT INTO "cert_metadata" VALUES('level','Associate');
INSERT INTO "cert_metadata" VALUES('cert_group','AWS 클라우드 자격');
INSERT INTO "cert_metadata" VALUES('exam_stage','필기');
INSERT INTO "cert_metadata" VALUES('passing_score','720');
INSERT INTO "cert_metadata" VALUES('score_scale','100-1000');
INSERT INTO "cert_metadata" VALUES('exam_question_count','65');
INSERT INTO "cert_metadata" VALUES('exam_duration_minutes','130');
INSERT INTO "cert_metadata" VALUES('updated_at','2026-11-26');
CREATE TABLE domain_analytics (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL,
        domain_name TEXT NOT NULL,
        domain_name_en TEXT NOT NULL,
        official_weight_pct REAL NOT NULL,
        total_questions INTEGER NOT NULL,
        bank_share_pct REAL NOT NULL,
        single_count INTEGER NOT NULL,
        multi_count INTEGER NOT NULL,
        official_pdf_count INTEGER NOT NULL,
        mit_count INTEGER NOT NULL,
        top_keywords TEXT NOT NULL,
        FOREIGN KEY (domain_id) REFERENCES categories_domain(domain_id)
    );
INSERT INTO "domain_analytics" VALUES(1,'D1_SECURE','Domain 1: 안전한 아키텍처 설계','Design Secure Architectures',30.0,45,30.0,36,9,3,42,'Amazon S3, AWS KMS, AWS WAF, AWS CloudTrail, Application Load Balancer (ALB), Amazon VPC');
INSERT INTO "domain_analytics" VALUES(2,'D2_RESILIENT','Domain 2: 복원력이 뛰어난 아키텍처 설계','Design Resilient Architectures',26.0,39,26.0,32,7,3,36,'Amazon SQS, EC2 Auto Scaling, Multi-AZ, High Availability, Amazon RDS, Application Load Balancer (ALB)');
INSERT INTO "domain_analytics" VALUES(3,'D3_PERFORMANT','Domain 3: 고성능 아키텍처 설계','Design High-Performing Architectures',24.0,36,24.0,30,6,2,34,'Multi-AZ, Amazon Aurora, Read Scaling, Amazon CloudFront, Amazon DynamoDB, Amazon EC2');
INSERT INTO "domain_analytics" VALUES(4,'D4_COST','Domain 4: 비용 최적화 아키텍처 설계','Design Cost-Optimized Architectures',20.0,30,20.0,25,5,2,28,'Cost Optimization, Amazon EC2, Spot Instances, Amazon S3, Amazon DynamoDB, FinOps');
CREATE TABLE exam_rounds (
        round_id INTEGER PRIMARY KEY,
        round_code TEXT NOT NULL UNIQUE,
        round_title TEXT NOT NULL,
        source_name TEXT NOT NULL,
        question_target INTEGER NOT NULL,
        description TEXT NOT NULL
    );
INSERT INTO "exam_rounds" VALUES(1,'OFFICIAL_SAMPLE','공식 샘플 10선 (AWS Official PDF)','AWS Official Sample Questions PDF',10,'AWS 공식 SAA-C03 Sample Exam Questions PDF 원문 10문항 (단일·복수 선택 포함 + 한국어 아키텍처 핵심 해설)');
INSERT INTO "exam_rounds" VALUES(2,'CLOUDCERTPREP','핵심 기초 20선 (CloudCertPrep MIT)','CloudCertPrep (MIT)',20,'CloudCertPrep MIT 오픈소스 4대 도메인 기초 시나리오 20문항 (영문 원문 + 한국어 아키텍처 핵심 해설)');
INSERT INTO "exam_rounds" VALUES(3,'MOCK_SET_1','실전 모의고사 1회 (공식 비율 60문항)','Power-xc/aws-saa-cert-quiz (MIT)',60,'공식 시험 도메인 가중치(30/26/24/20%)를 그대로 반영한 한국어 실전 시나리오 60문항 (단일·복수 선택 혼합)');
INSERT INTO "exam_rounds" VALUES(4,'MOCK_SET_2','실전 모의고사 2회 (심화 시나리오 60문항)','Power-xc/aws-saa-cert-quiz (MIT)',60,'보안·고복원력·고성능·FinOps 심화 아키텍처 트레이드오프 60문항 (도메인 비율 30/26/24/20% 유지)');
CREATE TABLE question_choices (
        choice_id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        choice_index INTEGER NOT NULL,
        choice_key TEXT NOT NULL,
        choice_text TEXT NOT NULL,
        is_correct INTEGER NOT NULL CHECK(is_correct IN (0, 1)),
        FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
    );
INSERT INTO "question_choices" VALUES(1,1,0,'A','Configure a NAT gateway in a public subnet.',1);
INSERT INTO "question_choices" VALUES(2,1,1,'B','Define a custom route table with a route to the NAT gateway for internet traffic and associate it with the private subnets for the application tier.',1);
INSERT INTO "question_choices" VALUES(3,1,2,'C','Assign Elastic IP addresses to the EC2 instances.',0);
INSERT INTO "question_choices" VALUES(4,1,3,'D','Define a custom route table with a route to the internet gateway for internet traffic and associate it with the private subnets for the application tier.',0);
INSERT INTO "question_choices" VALUES(5,1,4,'E','Configure a NAT instance in a private subnet.',0);
INSERT INTO "question_choices" VALUES(6,2,0,'A','Modify the application to store the data on instance store volumes. Reattach the volumes while restarting them.',0);
INSERT INTO "question_choices" VALUES(7,2,1,'B','Snapshot the EC2 instances before stopping them. Restore the snapshot after restarting the instances.',0);
INSERT INTO "question_choices" VALUES(8,2,2,'C','Run the applications on EC2 instances enabled for hibernation. Hibernate the instances before the 2-week company shutdown.',1);
INSERT INTO "question_choices" VALUES(9,2,3,'D','Note the Availability Zone for each EC2 instance before stopping it. Restart the instances in the same Availability Zones after the 2-week company shutdown.',0);
INSERT INTO "question_choices" VALUES(10,3,0,'A','Deploy an Application Load Balancer configured with a listener for the private IP address and register the primary EC2 instance with the load balancer. Upon failure, de-register the instance and register the standby EC2 instance.',0);
INSERT INTO "question_choices" VALUES(11,3,1,'B','Configure a custom DHCP option set. Configure DHCP to assign the same private IP address to the standby EC2 instance when the primary EC2 instance fails.',0);
INSERT INTO "question_choices" VALUES(12,3,2,'C','Attach a secondary elastic network interface to the EC2 instance configured with the private IP address. Move the network interface to the standby EC2 instance if the primary EC2 instance becomes unreachable.',1);
INSERT INTO "question_choices" VALUES(13,3,3,'D','Associate an Elastic IP address with the network interface of the primary EC2 instance. Disassociate the Elastic IP from the primary instance upon failure and associate it with a standby EC2 instance.',0);
INSERT INTO "question_choices" VALUES(14,4,0,'A','Enable cross-origin resource sharing (CORS) on the S3 bucket.',1);
INSERT INTO "question_choices" VALUES(15,4,1,'B','Enable S3 Versioning on the S3 bucket.',0);
INSERT INTO "question_choices" VALUES(16,4,2,'C','Provide the users with a signed URL for the script.',0);
INSERT INTO "question_choices" VALUES(17,4,3,'D','Configure an S3 bucket policy to allow public execute privileges.',0);
INSERT INTO "question_choices" VALUES(18,5,0,'A','Use server-side encryption with Amazon S3 managed encryption keys (SSE-S3).',0);
INSERT INTO "question_choices" VALUES(19,5,1,'B','Use server-side encryption with AWS KMS managed encryption keys (SSE-KMS).',0);
INSERT INTO "question_choices" VALUES(20,5,2,'C','Use server-side encryption with customer-provided encryption keys (SSE-C).',1);
INSERT INTO "question_choices" VALUES(21,5,3,'D','Use client-side encryption to provide at-rest encryption.',1);
INSERT INTO "question_choices" VALUES(22,5,4,'E','Use an AWS Lambda function invoked by Amazon S3 events to encrypt the data using the customer’s keys.',0);
INSERT INTO "question_choices" VALUES(23,6,0,'A','Deploy On-Demand Instances during periods of high demand.',1);
INSERT INTO "question_choices" VALUES(24,6,1,'B','Create a second EC2 reservation for additional instances.',0);
INSERT INTO "question_choices" VALUES(25,6,2,'C','Deploy Spot Instances during periods of high demand.',0);
INSERT INTO "question_choices" VALUES(26,6,3,'D','Increase the EC2 instance size in the EC2 reservation to support the increased workload.',0);
INSERT INTO "question_choices" VALUES(27,7,0,'A','Migrate the front-end application to AWS Lambda. Use Amazon API Gateway to route user requests to the Lambda functions.',0);
INSERT INTO "question_choices" VALUES(28,7,1,'B','Scale the database horizontally by converting it to a Multi-AZ deployment. Configure the front-end application to write to both the primary and secondary DB instances.',0);
INSERT INTO "question_choices" VALUES(29,7,2,'C','Configure the front-end application to send votes to an Amazon Simple Queue Service (Amazon SQS) queue. Provision worker instances to read the SQS queue and write the vote information to the database.',1);
INSERT INTO "question_choices" VALUES(30,7,3,'D','Use Amazon EventBridge (Amazon CloudWatch Events) to create a scheduled event to re-provision the database with larger, memory optimized instances during voting periods. When voting ends, re-provision the database to use smaller instances.',0);
INSERT INTO "question_choices" VALUES(31,8,0,'A','Create new public and private subnets in the same AZ.',0);
INSERT INTO "question_choices" VALUES(32,8,1,'B','Create an Amazon EC2 Auto Scaling group and Application Load Balancer spanning multiple AZs for the web application instances.',1);
INSERT INTO "question_choices" VALUES(33,8,2,'C','Add the existing web application instances to an Auto Scaling group behind an Application Load Balancer.',0);
INSERT INTO "question_choices" VALUES(34,8,3,'D','Create new public and private subnets in a new AZ. Create a database using an EC2 instance in the public subnet in the new AZ. Migrate the old database contents to the new database.',0);
INSERT INTO "question_choices" VALUES(35,8,4,'E','Create new public and private subnets in the same VPC, each in a new AZ. Create an Amazon RDS Multi-AZ DB instance in the private subnets. Migrate the old database contents to the new DB instance.',1);
INSERT INTO "question_choices" VALUES(36,9,0,'A','Configure a Network Load Balancer with a slow start configuration.',0);
INSERT INTO "question_choices" VALUES(37,9,1,'B','Configure Amazon ElastiCache for Redis to offload direct requests from the EC2 instances.',0);
INSERT INTO "question_choices" VALUES(38,9,2,'C','Configure an Auto Scaling step scaling policy with an EC2 instance warmup condition.',1);
INSERT INTO "question_choices" VALUES(39,9,3,'D','Configure Amazon CloudFront to use an Application Load Balancer as the origin.',0);
INSERT INTO "question_choices" VALUES(40,10,0,'A','Enable read-through caching on the Aurora database.',0);
INSERT INTO "question_choices" VALUES(41,10,1,'B','Update the application to read from the Multi-AZ standby instance.',0);
INSERT INTO "question_choices" VALUES(42,10,2,'C','Create an Aurora replica and modify the application to use the appropriate endpoints.',1);
INSERT INTO "question_choices" VALUES(43,10,3,'D','Create a second Aurora database and link it to the primary database as a read replica.',0);
INSERT INTO "question_choices" VALUES(44,11,0,'A','SSE-S3',1);
INSERT INTO "question_choices" VALUES(45,11,1,'B','SSE-KMS',0);
INSERT INTO "question_choices" VALUES(46,11,2,'C','SSE-C',0);
INSERT INTO "question_choices" VALUES(47,11,3,'D','Client-side encryption',0);
INSERT INTO "question_choices" VALUES(48,12,0,'A','AWS KMS',0);
INSERT INTO "question_choices" VALUES(49,12,1,'B','AWS CloudHSM',1);
INSERT INTO "question_choices" VALUES(50,12,2,'C','AWS Secrets Manager',0);
INSERT INTO "question_choices" VALUES(51,12,3,'D','AWS Certificate Manager',0);
INSERT INTO "question_choices" VALUES(52,13,0,'A','S3 ACL',0);
INSERT INTO "question_choices" VALUES(53,13,1,'B','S3 bucket policy with a Condition element',1);
INSERT INTO "question_choices" VALUES(54,13,2,'C','S3 Object Lock',0);
INSERT INTO "question_choices" VALUES(55,13,3,'D','S3 Versioning',0);
INSERT INTO "question_choices" VALUES(56,14,0,'A','VPC Peering',0);
INSERT INTO "question_choices" VALUES(57,14,1,'B','VPC Flow Logs',1);
INSERT INTO "question_choices" VALUES(58,14,2,'C','NAT Gateway',0);
INSERT INTO "question_choices" VALUES(59,14,3,'D','Internet Gateway',0);
INSERT INTO "question_choices" VALUES(60,15,0,'A','Amazon CloudWatch',0);
INSERT INTO "question_choices" VALUES(61,15,1,'B','AWS CloudTrail',1);
INSERT INTO "question_choices" VALUES(62,15,2,'C','AWS Config',0);
INSERT INTO "question_choices" VALUES(63,15,3,'D','Amazon GuardDuty',0);
INSERT INTO "question_choices" VALUES(64,16,0,'A','Deploy to a single AZ with Auto Scaling',0);
INSERT INTO "question_choices" VALUES(65,16,1,'B','Deploy across multiple AZs with an Application Load Balancer',1);
INSERT INTO "question_choices" VALUES(66,16,2,'C','Deploy to a single AZ with a larger instance type',0);
INSERT INTO "question_choices" VALUES(67,16,3,'D','Deploy to a single Region with CloudFront',0);
INSERT INTO "question_choices" VALUES(68,17,0,'A','Read Replicas',0);
INSERT INTO "question_choices" VALUES(69,17,1,'B','Multi-AZ deployment',1);
INSERT INTO "question_choices" VALUES(70,17,2,'C','Aurora Serverless',0);
INSERT INTO "question_choices" VALUES(71,17,3,'D','RDS Proxy',0);
INSERT INTO "question_choices" VALUES(72,18,0,'A','Amazon SQS',1);
INSERT INTO "question_choices" VALUES(73,18,1,'B','Amazon RDS',0);
INSERT INTO "question_choices" VALUES(74,18,2,'C','Amazon EC2',0);
INSERT INTO "question_choices" VALUES(75,18,3,'D','Amazon S3',0);
INSERT INTO "question_choices" VALUES(76,19,0,'A','S3 Standard',0);
INSERT INTO "question_choices" VALUES(77,19,1,'B','S3 Glacier Instant Retrieval',0);
INSERT INTO "question_choices" VALUES(78,19,2,'C','S3 Glacier Deep Archive',1);
INSERT INTO "question_choices" VALUES(79,19,3,'D','S3 One Zone-IA',0);
INSERT INTO "question_choices" VALUES(80,20,0,'A','DynamoDB Streams',0);
INSERT INTO "question_choices" VALUES(81,20,1,'B','Point-in-time recovery (PITR)',1);
INSERT INTO "question_choices" VALUES(82,20,2,'C','DynamoDB Accelerator (DAX)',0);
INSERT INTO "question_choices" VALUES(83,20,3,'D','Global tables',0);
INSERT INTO "question_choices" VALUES(84,21,0,'A','Amazon EC2',0);
INSERT INTO "question_choices" VALUES(85,21,1,'B','Amazon CloudFront',1);
INSERT INTO "question_choices" VALUES(86,21,2,'C','AWS Global Accelerator',0);
INSERT INTO "question_choices" VALUES(87,21,3,'D','Amazon Route 53',0);
INSERT INTO "question_choices" VALUES(88,22,0,'A','Amazon EC2',0);
INSERT INTO "question_choices" VALUES(89,22,1,'B','Amazon ECS on EC2',0);
INSERT INTO "question_choices" VALUES(90,22,2,'C','AWS Fargate',1);
INSERT INTO "question_choices" VALUES(91,22,3,'D','AWS Elastic Beanstalk',0);
INSERT INTO "question_choices" VALUES(92,23,0,'A','DynamoDB Streams',0);
INSERT INTO "question_choices" VALUES(93,23,1,'B','DynamoDB global tables',0);
INSERT INTO "question_choices" VALUES(94,23,2,'C','DynamoDB Accelerator (DAX)',1);
INSERT INTO "question_choices" VALUES(95,23,3,'D','DynamoDB on-demand capacity',0);
INSERT INTO "question_choices" VALUES(96,24,0,'A','Amazon SQS',0);
INSERT INTO "question_choices" VALUES(97,24,1,'B','Amazon Kinesis Data Streams',1);
INSERT INTO "question_choices" VALUES(98,24,2,'C','Amazon SNS',0);
INSERT INTO "question_choices" VALUES(99,24,3,'D','Amazon MQ',0);
INSERT INTO "question_choices" VALUES(100,25,0,'A','Amazon EBS',0);
INSERT INTO "question_choices" VALUES(101,25,1,'B','Amazon EFS',1);
INSERT INTO "question_choices" VALUES(102,25,2,'C','Amazon S3',0);
INSERT INTO "question_choices" VALUES(103,25,3,'D','AWS Storage Gateway',0);
INSERT INTO "question_choices" VALUES(104,26,0,'A','On-Demand Instances',0);
INSERT INTO "question_choices" VALUES(105,26,1,'B','Reserved Instances',0);
INSERT INTO "question_choices" VALUES(106,26,2,'C','Spot Instances',1);
INSERT INTO "question_choices" VALUES(107,26,3,'D','Dedicated Hosts',0);
INSERT INTO "question_choices" VALUES(108,27,0,'A','AWS Budgets',0);
INSERT INTO "question_choices" VALUES(109,27,1,'B','AWS Trusted Advisor',1);
INSERT INTO "question_choices" VALUES(110,27,2,'C','AWS Cost Explorer',0);
INSERT INTO "question_choices" VALUES(111,27,3,'D','AWS Pricing Calculator',0);
INSERT INTO "question_choices" VALUES(112,28,0,'A','Use Reserved Instances',0);
INSERT INTO "question_choices" VALUES(113,28,1,'B','Use On-Demand Instances and stop them after hours',1);
INSERT INTO "question_choices" VALUES(114,28,2,'C','Use Spot Instances',0);
INSERT INTO "question_choices" VALUES(115,28,3,'D','Use Dedicated Hosts',0);
INSERT INTO "question_choices" VALUES(116,29,0,'A','S3 Versioning',0);
INSERT INTO "question_choices" VALUES(117,29,1,'B','S3 Lifecycle policies',1);
INSERT INTO "question_choices" VALUES(118,29,2,'C','S3 Replication',0);
INSERT INTO "question_choices" VALUES(119,29,3,'D','S3 Object Lock',0);
INSERT INTO "question_choices" VALUES(120,30,0,'A','Complex SQL queries with joins',0);
INSERT INTO "question_choices" VALUES(121,30,1,'B','Consistent single-digit millisecond latency at any scale',1);
INSERT INTO "question_choices" VALUES(122,30,2,'C','ACID transactions across multiple tables',0);
INSERT INTO "question_choices" VALUES(123,30,3,'D','Schema enforcement and referential integrity',0);
INSERT INTO "question_choices" VALUES(124,31,0,'A','ALB 보안 그룹의 인바운드를 CloudFront 오리진 대상 AWS 관리형 접두사 목록으로만 허용한다',1);
INSERT INTO "question_choices" VALUES(125,31,1,'B','ALB 보안 그룹에서 0.0.0.0/0의 443을 허용하고 NACL로 CloudFront 도메인 이름만 허용한다',0);
INSERT INTO "question_choices" VALUES(126,31,2,'C','AWS Shield Standard가 CloudFront를 거치지 않은 직접 접근을 자동으로 차단하도록 의존한다',0);
INSERT INTO "question_choices" VALUES(127,31,3,'D','CloudFront가 오리진 요청에 비밀 사용자 지정 헤더를 추가하게 하고 ALB 앞 WAF에서 헤더가 없는 요청을 차단한다',1);
INSERT INTO "question_choices" VALUES(128,31,4,'E','CloudFront 서명된 URL을 필수로 설정하면 ALB에 대한 직접 접근도 함께 차단된다',0);
INSERT INTO "question_choices" VALUES(129,32,0,'A','작업 역할(task role)에만 권한을 부여하고 작업 실행 역할에는 권한을 주지 않는다',0);
INSERT INTO "question_choices" VALUES(130,32,1,'B','작업 정의의 environment 필드에 비밀 ARN을 값으로 넣어 ECS가 자동으로 치환하게 한다',0);
INSERT INTO "question_choices" VALUES(131,32,2,'C','작업 정의의 컨테이너 secrets 필드에 환경 변수 이름과 비밀 ARN을 지정한다',1);
INSERT INTO "question_choices" VALUES(132,32,3,'D','작업 실행 역할에 secretsmanager:GetSecretValue(고객 관리형 키 사용 시 kms:Decrypt) 권한을 부여한다',1);
INSERT INTO "question_choices" VALUES(133,32,4,'E','Dockerfile의 ENV에 비밀번호를 넣고 이미지를 프라이빗 ECR 저장소에 보관한다',0);
INSERT INTO "question_choices" VALUES(134,33,0,'A','역할을 AdministratorAccess로 바꾸고 SCP로 위험한 작업만 거부한다',0);
INSERT INTO "question_choices" VALUES(135,33,1,'B','권한 경계에 PowerUserAccess를 설정하여 권한이 자동으로 줄어들게 한다',0);
INSERT INTO "question_choices" VALUES(136,33,2,'C','Trusted Advisor의 비용 최적화 점검 결과에 따라 사용하지 않는 권한이 자동 제거되게 한다',0);
INSERT INTO "question_choices" VALUES(137,33,3,'D','IAM Access Analyzer 미사용 액세스 결과를 확인해 쓰이지 않은 서비스와 작업 권한을 제거한다',1);
INSERT INTO "question_choices" VALUES(138,33,4,'E','IAM 최종 액세스 정보를 검토해 역할이 사용하지 않은 서비스의 권한을 정책에서 삭제한다',1);
INSERT INTO "question_choices" VALUES(139,34,0,'A','계정마다 IAM SAML 공급자와 역할을 만들고 Okta 애플리케이션을 계정 수만큼 구성한다',0);
INSERT INTO "question_choices" VALUES(140,34,1,'B','Okta 그룹마다 계정별 IAM 사용자를 만들고 액세스 키를 90일마다 교체하는 자동화를 작성한다',0);
INSERT INTO "question_choices" VALUES(141,34,2,'C','Cognito 자격 증명 풀에 Okta를 OIDC 공급자로 연결하고 인증된 역할을 매핑해 직원이 AWS 콘솔과 CLI에 로그인하게 한다',0);
INSERT INTO "question_choices" VALUES(142,34,3,'D','IAM Identity Center에 Okta를 외부 IdP로 연결(SAML·SCIM)하고 그룹에 권한 세트를 계정별로 할당한다',1);
INSERT INTO "question_choices" VALUES(143,35,0,'A','Lambda 권한 부여자를 만들고 JWT 서명을 직접 검증하도록 코드를 구현한다',0);
INSERT INTO "question_choices" VALUES(144,35,1,'B','API Gateway 사용 계획과 API 키를 발급해 앱이 x-api-key 헤더를 보내게 한다',0);
INSERT INTO "question_choices" VALUES(145,35,2,'C','API Gateway에 Cognito 사용자 풀 권한 부여자를 만들어 각 메서드에 연결한다',1);
INSERT INTO "question_choices" VALUES(146,35,3,'D','메서드 인증을 AWS_IAM으로 설정하고 앱이 사용자 풀 토큰으로 SigV4 서명을 생성하게 한다',0);
INSERT INTO "question_choices" VALUES(147,36,0,'A','AWS Artifact에서 AWS의 PCI DSS 준수 보고서를 내려받아 감사인에게 제출한다',0);
INSERT INTO "question_choices" VALUES(148,36,1,'B','Audit Manager의 PCI DSS 프레임워크 평가로 증거를 자동 수집하고 보고서를 생성한다',1);
INSERT INTO "question_choices" VALUES(149,36,2,'C','AWS Security Hub의 PCI DSS 표준을 활성화하고 준수 점수 화면을 캡처해 제출한다',0);
INSERT INTO "question_choices" VALUES(150,36,3,'D','AWS Config 규칙 평가 결과를 S3로 내보내 스프레드시트로 정리해 증거로 제출한다',0);
INSERT INTO "question_choices" VALUES(151,37,0,'A','복제 규칙의 접두사 필터를 제거해 모든 객체를 복제 대상으로 만들고 복제 시간 제어(RTC)를 활성화해 지연을 줄인다',0);
INSERT INTO "question_choices" VALUES(152,37,1,'B','원본 객체를 SSE-S3로 다시 암호화해야만 교차 계정 복제가 가능하다',0);
INSERT INTO "question_choices" VALUES(153,37,2,'C','버킷 키를 활성화하면 복제 역할에 KMS 권한을 주지 않아도 복제된다',0);
INSERT INTO "question_choices" VALUES(154,37,3,'D','규칙에서 SSE-KMS 객체 복제를 활성화하고 도쿄 Region의 KMS 키를 지정하며 복제 역할에 키 권한을 부여한다',1);
INSERT INTO "question_choices" VALUES(155,38,0,'A','SCP에서 aws:RequestedRegion이 승인 Region이 아닌 요청을 거부하되 NotAction으로 글로벌 서비스를 예외 처리한다',1);
INSERT INTO "question_choices" VALUES(156,38,1,'B','모든 계정에 IAM 정책을 배포해 승인되지 않은 Region의 작업을 거부하고 변경 시 Config로 감지한다',0);
INSERT INTO "question_choices" VALUES(157,38,2,'C','SCP에서 승인 Region 밖의 모든 작업을 예외 없이 거부하고 IAM, CloudFront, Route 53 같은 글로벌 서비스도 같은 규칙으로 처리한다',0);
INSERT INTO "question_choices" VALUES(158,38,3,'D','Config 규칙으로 허용 Region 밖에 생성된 리소스를 탐지하고 Systems Manager Automation으로 자동 삭제한다',0);
INSERT INTO "question_choices" VALUES(159,39,0,'A','Amazon Macie 민감 데이터 검색 작업을 매일 실행하여 악성 파일을 식별한다',0);
INSERT INTO "question_choices" VALUES(160,39,1,'B','Amazon Inspector가 S3 버킷의 객체를 지속적으로 스캔하도록 활성화한다',0);
INSERT INTO "question_choices" VALUES(161,39,2,'C','EC2 Auto Scaling 그룹에 ClamAV를 설치하고 S3 이벤트를 SQS 큐에 넣어 스캔 작업자가 객체를 검사하고 결과를 태그로 기록하게 한다',0);
INSERT INTO "question_choices" VALUES(162,39,3,'D','버킷에 GuardDuty Malware Protection for S3를 활성화하고 검사 결과 태그나 EventBridge로 후속 처리를 제어한다',1);
INSERT INTO "question_choices" VALUES(163,40,0,'A','Amazon Inspector EC2 스캔을 하이브리드 모드로 켜서 SSM Agent 기반 스캔과 EBS 스냅샷 기반 에이전트리스 스캔을 함께 쓴다',1);
INSERT INTO "question_choices" VALUES(164,40,1,'B','Systems Manager Patch Manager의 스캔 작업을 매일 예약하고 비준수 인스턴스 보고서를 확인한다',0);
INSERT INTO "question_choices" VALUES(165,40,2,'C','Amazon GuardDuty Malware Protection for EC2를 활성화해 인스턴스의 취약한 패키지를 탐지하고 결과를 Security Hub로 전송해 심각도별로 확인한다',0);
INSERT INTO "question_choices" VALUES(166,40,3,'D','AWS Config 관리형 규칙으로 인스턴스의 패키지 버전을 평가하고 비준수 리소스를 집계해 확인한다',0);
INSERT INTO "question_choices" VALUES(167,41,0,'A','계정 A의 버킷 정책에서 B의 역할에 s3:GetObject만 허용하면 KMS 복호화는 S3 서비스가 대신 처리하므로 계정 B와 KMS 키 정책에는 추가 설정이 필요 없다',0);
INSERT INTO "question_choices" VALUES(168,41,1,'B','계정 A의 버킷 정책과 키 정책에서 B의 역할을 허용하고 B 역할의 IAM 정책에도 s3:GetObject와 kms:Decrypt를 부여한다',1);
INSERT INTO "question_choices" VALUES(169,41,2,'C','계정 B 역할의 IAM 정책에만 버킷과 키에 대한 권한을 부여하면 계정 A의 정책 없이도 접근된다',0);
INSERT INTO "question_choices" VALUES(170,41,3,'D','계정 A 버킷을 AWS 관리형 키 aws/s3로 다시 암호화하고 버킷 정책으로 B를 허용한다',0);
INSERT INTO "question_choices" VALUES(171,42,0,'A','서울 Region에서 인증서 한 개를 요청해 CloudFront와 ALB에 모두 연결한다',0);
INSERT INTO "question_choices" VALUES(172,42,1,'B','us-east-1에서 인증서 한 개를 요청해 CloudFront와 서울 ALB에 모두 연결한다',0);
INSERT INTO "question_choices" VALUES(173,42,2,'C','CloudFront용은 us-east-1, ALB용은 서울에서 각각 DNS 검증 퍼블릭 인증서를 요청한다',1);
INSERT INTO "question_choices" VALUES(174,42,3,'D','공인 CA에서 구매한 인증서를 ACM으로 가져와 두 Region에서 사용한다',0);
INSERT INTO "question_choices" VALUES(175,43,0,'A','Shield Standard에 의존하고 Auto Scaling 최대 용량을 늘려 공격 트래픽을 흡수한다',0);
INSERT INTO "question_choices" VALUES(176,43,1,'B','Shield Advanced를 구독해 보호 리소스를 등록하고 SRT와 연결하며 WAF 속도 기반 규칙을 구성한다',1);
INSERT INTO "question_choices" VALUES(177,43,2,'C','WAF 관리형 규칙만 적용하고 공격이 발생하면 AWS Support에 사례를 열어 지원을 요청한다',0);
INSERT INTO "question_choices" VALUES(178,43,3,'D','Route 53 상태 확인과 CloudWatch 경보로 공격을 탐지해 Lambda가 보안 그룹을 수정하게 한다',0);
INSERT INTO "question_choices" VALUES(179,44,0,'A','S3 버킷 정책에 Macie 서비스 주체의 s3:GetObject 권한을 추가하여 KMS 복호화 권한도 함께 부여되게 한다',0);
INSERT INTO "question_choices" VALUES(180,44,1,'B','대상 버킷의 기본 암호화를 SSE-S3로 변경한 뒤 기존 객체를 모두 다시 업로드하여 키 의존성을 제거한다',0);
INSERT INTO "question_choices" VALUES(181,44,2,'C','KMS 키 정책에서 Macie 서비스 연결 역할이 해당 키로 객체를 복호화할 수 있도록 허용한다',1);
INSERT INTO "question_choices" VALUES(182,44,3,'D','S3 Bucket Keys를 활성화하여 Macie가 버킷 수준 키로 객체를 복호화할 수 있도록 설정한다',0);
INSERT INTO "question_choices" VALUES(183,45,0,'A','각 서비스 결과를 EventBridge로 중앙 S3 버킷에 보내고 Athena 쿼리와 QuickSight 대시보드로 조회한다',0);
INSERT INTO "question_choices" VALUES(184,45,1,'B','Amazon Detective 동작 그래프를 조직 전체로 확장하여 서비스별 결과를 하나의 그래프에서 확인한다',0);
INSERT INTO "question_choices" VALUES(185,45,2,'C','Security Hub 위임 관리자 계정을 지정해 조직 계정을 자동으로 등록하고 교차 Region 집계를 구성한다',1);
INSERT INTO "question_choices" VALUES(186,45,3,'D','각 계정의 CloudWatch 대시보드를 교차 계정 관찰성으로 연결하고 서비스별 지표를 모아서 본다',0);
INSERT INTO "question_choices" VALUES(187,46,0,'A','위임이 필요할 때마다 키 정책에 principal을 추가하고 작업이 끝나면 키 정책을 이전 버전으로 되돌린다',0);
INSERT INTO "question_choices" VALUES(188,46,1,'B','CreateGrant로 위임하고 RevokeGrant로 취소한다',1);
INSERT INTO "question_choices" VALUES(189,46,2,'C','위임 대상마다 새 KMS 키를 만들고 작업이 끝나면 즉시 삭제 예약해 접근을 회수한다',0);
INSERT INTO "question_choices" VALUES(190,46,3,'D','IAM policy에 kms:* 를 허용하면 키 정책과 무관하게 접근이 위임된다',0);
INSERT INTO "question_choices" VALUES(191,47,0,'A','AWS Network Firewall에 TLS_SNI 기준 허용 도메인 규칙 그룹을 적용하고 나머지 아웃바운드 트래픽은 기본 작업으로 드롭한다',1);
INSERT INTO "question_choices" VALUES(192,47,1,'B','Route 53 Resolver DNS Firewall로 승인된 도메인 외의 DNS 질의를 차단하는 규칙 그룹을 모든 VPC에 연결하고 위반 질의를 지속적으로 모니터링한다',0);
INSERT INTO "question_choices" VALUES(193,47,2,'C','서버 보안 그룹의 아웃바운드 규칙에 파트너 도메인 이름을 대상으로 지정하고 나머지는 거부한다',0);
INSERT INTO "question_choices" VALUES(194,47,3,'D','EC2에 Squid 프록시를 구성해 허용 도메인 목록을 관리하고 서버가 프록시를 통해서만 나가게 한다',0);
INSERT INTO "question_choices" VALUES(195,48,0,'A','Parameter Store SecureString에 저장하고 EventBridge와 Lambda로 직접 만든 회전 로직을 30일마다 실행한다',0);
INSERT INTO "question_choices" VALUES(196,48,1,'B','KMS 키 자동 회전을 활성화하여 비밀번호가 30일마다 새 값으로 교체되게 한다',0);
INSERT INTO "question_choices" VALUES(197,48,2,'C','비밀번호를 사용자 데이터 스크립트에 넣고 Auto Scaling 인스턴스를 30일마다 교체한다',0);
INSERT INTO "question_choices" VALUES(198,48,3,'D','Secrets Manager에 자격 증명을 저장하고 RDS용 관리형 회전을 30일로 설정한 뒤 DR Region에 비밀 복제본을 구성한다',1);
INSERT INTO "question_choices" VALUES(199,49,0,'A','기존 비암호화 파일 시스템의 설정을 수정해 저장 데이터 암호화를 켠다',0);
INSERT INTO "question_choices" VALUES(200,49,1,'B','파일 시스템을 생성할 때 저장 데이터 암호화를 활성화한다',1);
INSERT INTO "question_choices" VALUES(201,49,2,'C','기본 NFS 마운트를 사용하면 NFSv4가 자동으로 TLS로 전송 데이터를 암호화한다',0);
INSERT INTO "question_choices" VALUES(202,49,3,'D','보안 그룹에서 2049 포트를 VPN 대역으로만 허용하면 전송 중 암호화가 적용된다',0);
INSERT INTO "question_choices" VALUES(203,49,4,'E','EFS 마운트 헬퍼의 TLS 옵션을 사용해 클라이언트가 파일 시스템을 마운트한다',1);
INSERT INTO "question_choices" VALUES(204,50,0,'A','버킷 버전 관리를 활성화한다',1);
INSERT INTO "question_choices" VALUES(205,50,1,'B','버킷 정책에서 Principal을 "*"로 하는 Allow 문을 추가한다',0);
INSERT INTO "question_choices" VALUES(206,50,2,'C','객체를 S3 Standard에서 Intelligent-Tiering으로 옮긴다',0);
INSERT INTO "question_choices" VALUES(207,50,3,'D','S3 Object Lock을 compliance 모드로 활성화하고 보존 기간을 지정한다',1);
INSERT INTO "question_choices" VALUES(208,50,4,'E','S3 서버 액세스 로그만 활성화한다',0);
INSERT INTO "question_choices" VALUES(209,51,0,'A','각 멤버 계정의 IAM 정책에서 같은 작업을 거부하도록 배포한다',0);
INSERT INTO "question_choices" VALUES(210,51,1,'B','SCP로 멤버 계정에서 cloudtrail:StopLogging, cloudtrail:DeleteTrail, guardduty:DeleteDetector 같은 작업을 거부한다',1);
INSERT INTO "question_choices" VALUES(211,51,2,'C','StopLogging 이벤트를 감지하면 멤버 관리자에게 알림을 보내는 CloudWatch 경보를 만든다',0);
INSERT INTO "question_choices" VALUES(212,51,3,'D','Config 규칙이 비활성화를 감지하면 사람이 승인한 뒤 수동으로 재활성화한다',0);
INSERT INTO "question_choices" VALUES(213,51,4,'E','관리 계정에서 조직 트레일을 만들어 모든 계정의 이벤트를 중앙 S3 버킷으로 전달한다',1);
INSERT INTO "question_choices" VALUES(214,52,0,'A','Shield Standard만 사용하고 추가 조치는 하지 않는다',0);
INSERT INTO "question_choices" VALUES(215,52,1,'B','ALB에 AWS WAF web ACL과 관리형 규칙을 연결한다',1);
INSERT INTO "question_choices" VALUES(216,52,2,'C','GuardDuty를 활성화해 공격 트래픽을 자동으로 차단한다',0);
INSERT INTO "question_choices" VALUES(217,52,3,'D','ALB를 AWS Shield Advanced 보호 리소스로 등록한다',1);
INSERT INTO "question_choices" VALUES(218,52,4,'E','서브넷 NACL에 공격 IP를 모두 수동으로 추가한다',0);
INSERT INTO "question_choices" VALUES(219,53,0,'A','웹 ACL에 AWS 관리형 IP 평판 목록 규칙 그룹을 추가한다',0);
INSERT INTO "question_choices" VALUES(220,53,1,'B','속도 기반 규칙에 URI 경로가 /login인 요청만 집계하는 범위 축소 문을 추가한다',1);
INSERT INTO "question_choices" VALUES(221,53,2,'C','범위 축소 없이 속도 기반 규칙을 5분당 100회로 설정해 모든 경로에 적용한다',0);
INSERT INTO "question_choices" VALUES(222,53,3,'D','ALB 보안 그룹에서 /login 경로로 접근하는 IP 대역을 제한한다',0);
INSERT INTO "question_choices" VALUES(223,54,0,'A','IAM credential report를 내려받아 role이 최근 호출한 서비스별 사용 현황을 확인하고 policy를 직접 작성한다',0);
INSERT INTO "question_choices" VALUES(224,54,1,'B','AWS Trusted Advisor의 보안 점검 결과로 policy를 자동 생성한다',0);
INSERT INTO "question_choices" VALUES(225,54,2,'C','Access Analyzer policy generation으로 CloudTrail 기반 최소 권한 policy를 생성한다',1);
INSERT INTO "question_choices" VALUES(226,54,3,'D','AWS Config로 role의 변경 이력을 조회해 필요한 권한을 추정한다',0);
INSERT INTO "question_choices" VALUES(227,55,0,'A','고객 VPC마다 업체 VPC와 VPC 피어링을 만들고 보안 그룹으로 접근 범위를 제한한다',0);
INSERT INTO "question_choices" VALUES(228,55,1,'B','NLB를 엔드포인트 서비스로 노출하고 고객이 자신의 VPC에 인터페이스 엔드포인트를 만들어 연결한다',1);
INSERT INTO "question_choices" VALUES(229,55,2,'C','Transit Gateway에 모든 VPC를 연결하고 라우팅 테이블을 분리해 접근 범위를 고객별로 제한한다',0);
INSERT INTO "question_choices" VALUES(230,55,3,'D','고객마다 Site-to-Site VPN 연결을 만들어 업체 VPC와 연결한다',0);
INSERT INTO "question_choices" VALUES(231,56,0,'A','permissions boundary 조건이 있을 때만 iam:CreateRole을 허용하고 boundary는 S3·DynamoDB만 허용한다',1);
INSERT INTO "question_choices" VALUES(232,56,1,'B','리드에게 IAMFullAccess를 부여하고 CloudTrail 알람으로 사후에 과도한 권한이 부여되었는지 점검한다',0);
INSERT INTO "question_choices" VALUES(233,56,2,'C','OU에 SCP를 적용해 S3와 DynamoDB를 제외한 모든 서비스를 거부하고 모든 개발 계정에 동일하게 적용한다',0);
INSERT INTO "question_choices" VALUES(234,56,3,'D','리드가 만든 모든 role에 AdministratorAccess를 연결하고 태그로 사용을 구분한다',0);
INSERT INTO "question_choices" VALUES(235,57,0,'A','두 서비스가 하나의 task execution role을 공유하고 두 DynamoDB 테이블 모두에 대한 권한을 그 role에 부여한다',0);
INSERT INTO "question_choices" VALUES(236,57,1,'B','서비스별 task role에 해당 테이블 권한만 부여하고 이미지 pull·로그 권한은 task execution role에 둔다',1);
INSERT INTO "question_choices" VALUES(237,57,2,'C','Fargate 작업에 EC2 instance profile을 연결하고 두 테이블에 대한 권한을 부여한다',0);
INSERT INTO "question_choices" VALUES(238,57,3,'D','서비스마다 IAM 사용자 액세스 키를 만들어 환경 변수로 주입하고 키는 분기마다 교체한다',0);
INSERT INTO "question_choices" VALUES(239,58,0,'A','고객사마다 IAM SAML provider를 만들어 직원이 AWS 콘솔의 IAM role을 맡아 앱에 로그인하게 한다',0);
INSERT INTO "question_choices" VALUES(240,58,1,'B','IAM Identity Center에 모든 고객 직원을 등록하고 앱 로그인과 API 인증에 Identity Center를 사용한다',0);
INSERT INTO "question_choices" VALUES(241,58,2,'C','Cognito identity pool만 구성해 각 IdP 토큰을 API Gateway에 직접 전달한다',0);
INSERT INTO "question_choices" VALUES(242,58,3,'D','Cognito user pool에 SAML·Google IdP를 연동하고 Cognito authorizer를 사용한다',1);
INSERT INTO "question_choices" VALUES(243,59,0,'A','서브넷 NACL에 국가별 CIDR 목록을 직접 입력해 거부하고 목록 변경 시 정기적으로 갱신한다',0);
INSERT INTO "question_choices" VALUES(244,59,1,'B','Shield Advanced를 구독해 악성 IP와 국가 차단이 모든 CloudFront 배포에 자동 적용되게 한다',0);
INSERT INTO "question_choices" VALUES(245,59,2,'C','GuardDuty 위협 목록을 활성화하면 CloudFront 요청이 자동으로 차단된다',0);
INSERT INTO "question_choices" VALUES(246,59,3,'D','WAF에 geo match 규칙과 Amazon IP reputation list 관리형 규칙 그룹을 추가한다',1);
INSERT INTO "question_choices" VALUES(247,60,0,'A','AWS WAF를 VPC에 연결해 DNS 질의를 검사한다',0);
INSERT INTO "question_choices" VALUES(248,60,1,'B','AWS Network Firewall을 배포하고 firewall endpoint로 모든 트래픽을 우회시킨다',0);
INSERT INTO "question_choices" VALUES(249,60,2,'C','Route 53 Resolver DNS Firewall을 구성하고 관리형 도메인 목록 규칙 그룹을 VPC에 연결한다',1);
INSERT INTO "question_choices" VALUES(250,60,3,'D','GuardDuty를 활성화해 악성 도메인 질의를 자동으로 막는다',0);
INSERT INTO "question_choices" VALUES(251,61,0,'A','VPC Traffic Mirroring으로 모든 패킷을 수집해 별도 분석 서버에서 포트별로 점검한다',0);
INSERT INTO "question_choices" VALUES(252,61,1,'B','CloudTrail 관리 이벤트를 켜서 거부된 연결 시도의 출발지와 포트를 확인한다',0);
INSERT INTO "question_choices" VALUES(253,61,2,'C','VPC Flow Logs를 S3로 게시하고 Athena로 REJECT 레코드를 쿼리한다',1);
INSERT INTO "question_choices" VALUES(254,61,3,'D','GuardDuty findings 목록에서 거부된 트래픽을 조회한다',0);
INSERT INTO "question_choices" VALUES(255,62,0,'A','DB 비밀번호를 Lambda 환경 변수와 EC2 user data에 저장하고 분기마다 값을 교체한다',0);
INSERT INTO "question_choices" VALUES(256,62,1,'B','DB 마스터 계정 비밀번호를 SSM Parameter Store에 일반 문자열로 저장하고 애플리케이션이 읽게 한다',0);
INSERT INTO "question_choices" VALUES(257,62,2,'C','RDS IAM 데이터베이스 인증을 활성화하고 role이 만든 인증 토큰으로 SSL 연결한다',1);
INSERT INTO "question_choices" VALUES(258,62,3,'D','security group에서 애플리케이션 IP만 허용하고 비밀번호를 코드에 둔다',0);
INSERT INTO "question_choices" VALUES(259,63,0,'A','Site-to-Site VPN',1);
INSERT INTO "question_choices" VALUES(260,63,1,'B','AWS Direct Connect',0);
INSERT INTO "question_choices" VALUES(261,63,2,'C','AWS AppSync를 통한 API 연결',0);
INSERT INTO "question_choices" VALUES(262,63,3,'D','VPC peering',0);
INSERT INTO "question_choices" VALUES(263,64,0,'A','AWS Shield Standard',0);
INSERT INTO "question_choices" VALUES(264,64,1,'B','AWS WAF',1);
INSERT INTO "question_choices" VALUES(265,64,2,'C','AWS Shield Advanced',0);
INSERT INTO "question_choices" VALUES(266,64,3,'D','AWS GuardDuty',0);
INSERT INTO "question_choices" VALUES(267,65,0,'A','trust policy에 aws:MultiFactorAuthPresent가 true인 경우만 AssumeRole을 허용하는 조건을 둔다',1);
INSERT INTO "question_choices" VALUES(268,65,1,'B','개발자 전원에게 가상 MFA 장치를 할당하고 프로덕션 role을 사용할 때 MFA를 쓰도록 권장하는 지침을 배포한다',0);
INSERT INTO "question_choices" VALUES(269,65,2,'C','프로덕션 계정의 security group에서 MFA 인증을 마친 사용자의 IP 주소만 허용하도록 규칙을 구성한다',0);
INSERT INTO "question_choices" VALUES(270,65,3,'D','AssumeRole 호출 후 CloudTrail 로그를 분석해 MFA 없이 만들어진 세션을 사후에 찾아 종료한다',0);
INSERT INTO "question_choices" VALUES(271,66,0,'A','버킷 정책에서 aws:SourceVpce가 해당 endpoint ID가 아닌 요청을 Deny한다',1);
INSERT INTO "question_choices" VALUES(272,66,1,'B','S3 Gateway endpoint policy에서 해당 버킷만 허용하고 버킷 정책은 변경하지 않는다',0);
INSERT INTO "question_choices" VALUES(273,66,2,'C','VPC의 NACL에서 S3의 퍼블릭 IP 대역으로 향하는 트래픽을 허용한다',0);
INSERT INTO "question_choices" VALUES(274,66,3,'D','버킷에 security group을 연결해 VPC CIDR의 요청만 허용한다',0);
INSERT INTO "question_choices" VALUES(275,67,0,'A','KMS DeleteKey API를 호출해 키를 즉시 영구 삭제하고, 문제가 생기면 사전에 받아 둔 키 자료로 복구한다',0);
INSERT INTO "question_choices" VALUES(276,67,1,'B','키 삭제를 예약해 대기 기간을 두고 키 사용 시도를 CloudWatch 알람으로 감시하며 필요하면 삭제를 취소한다',1);
INSERT INTO "question_choices" VALUES(277,67,2,'C','키 자동 교체를 활성화해 사용되지 않는 이전 키 구성 요소가 자동으로 삭제되게 하여 키를 정리한다',0);
INSERT INTO "question_choices" VALUES(278,67,3,'D','키 별칭(alias)을 삭제하면 키도 함께 삭제되므로 별칭부터 삭제한다',0);
INSERT INTO "question_choices" VALUES(279,68,0,'A','Aurora 글로벌 데이터베이스에 ap-northeast-2 보조 클러스터를 추가한다',1);
INSERT INTO "question_choices" VALUES(280,68,1,'B','기본 클러스터의 자동 백업 보존 기간을 35일로 늘린다',0);
INSERT INTO "question_choices" VALUES(281,68,2,'C','Route 53 장애 조치 레코드와 상태 검사로 기본 리전 ALB에서 DR 리전 ALB로 DNS를 전환한다',1);
INSERT INTO "question_choices" VALUES(282,68,3,'D','기본 리전의 다른 AZ에 Aurora 복제본을 추가한다',0);
INSERT INTO "question_choices" VALUES(283,68,4,'E','Route 53 레코드의 TTL을 86400초로 설정해 DNS 조회를 줄인다',0);
INSERT INTO "question_choices" VALUES(284,69,0,'A','어플라이언스 Auto Scaling 그룹을 여러 AZ에 걸쳐 두고 GWLB 대상 그룹의 상태 검사로 비정상 인스턴스를 제외한다',1);
INSERT INTO "question_choices" VALUES(285,69,1,'B','모든 AZ의 트래픽을 한 AZ의 엔드포인트 하나로 보내 세션을 한곳에서 처리한다',0);
INSERT INTO "question_choices" VALUES(286,69,2,'C','어플라이언스 앞에 Application Load Balancer를 두고 HTTP 헤더로 트래픽을 라우팅한다',0);
INSERT INTO "question_choices" VALUES(287,69,3,'D','각 AZ마다 Gateway Load Balancer 엔드포인트를 만들고 해당 AZ 서브넷의 라우팅이 같은 AZ의 엔드포인트를 가리키게 한다',1);
INSERT INTO "question_choices" VALUES(288,69,4,'E','어플라이언스 인스턴스에 탄력적 IP 주소를 연결하고 라우팅 테이블에서 직접 가리킨다',0);
INSERT INTO "question_choices" VALUES(289,70,0,'A','DLQ를 제거해 실패한 메시지가 성공할 때까지 계속 재시도되게 한다',0);
INSERT INTO "question_choices" VALUES(290,70,1,'B','이벤트 소스 매핑에 ReportBatchItemFailures를 활성화하고 실패한 메시지 ID만 반환한다',1);
INSERT INTO "question_choices" VALUES(291,70,2,'C','큐의 수신 메시지 대기 시간을 0으로 설정해 short polling을 사용한다',0);
INSERT INTO "question_choices" VALUES(292,70,3,'D','함수에서 예외를 던져 배치 전체를 실패로 보고한다',0);
INSERT INTO "question_choices" VALUES(293,70,4,'E','큐의 가시성 제한 시간을 함수 제한 시간의 6배 이상으로 설정한다',1);
INSERT INTO "question_choices" VALUES(294,71,0,'A','기본(MREC) 모드의 글로벌 테이블을 세 리전에 구성하고 강한 일관성 읽기를 사용한다',0);
INSERT INTO "question_choices" VALUES(295,71,1,'B','한 리전 테이블에 PITR을 켜고 다른 리전에 주기적으로 복원한다',0);
INSERT INTO "question_choices" VALUES(296,71,2,'C','DynamoDB Streams와 Lambda로 다른 두 리전 테이블에 쓰기를 복제한다',0);
INSERT INTO "question_choices" VALUES(297,71,3,'D','다중 리전 강력한 일관성(MRSC) 모드의 글로벌 테이블을 세 리전에 구성한다',1);
INSERT INTO "question_choices" VALUES(298,72,0,'A','기존 다중 AZ 인스턴스에 읽기 전용 복제본을 추가하고 애플리케이션이 복제본으로 장애 조치하게 한다',0);
INSERT INTO "question_choices" VALUES(299,72,1,'B','Single-AZ로 전환하고 자동 백업 주기를 5분으로 단축한다',0);
INSERT INTO "question_choices" VALUES(300,72,2,'C','다른 리전에 교차 리전 읽기 전용 복제본을 만들고 장애 시 승격한다',0);
INSERT INTO "question_choices" VALUES(301,72,3,'D','다중 AZ DB 클러스터 배포로 전환해 서로 다른 AZ의 읽기 가능한 대기 인스턴스 2개를 사용한다',1);
INSERT INTO "question_choices" VALUES(302,73,0,'A','단일 NAT 게이트웨이를 더 큰 대역폭의 NAT 인스턴스로 교체한다',0);
INSERT INTO "question_choices" VALUES(303,73,1,'B','AZ-a에 NAT 게이트웨이를 하나 더 만들어 모든 프라이빗 서브넷 라우팅 테이블의 기본 경로에 추가한다',0);
INSERT INTO "question_choices" VALUES(304,73,2,'C','AZ마다 NAT 게이트웨이를 두고 AZ별 프라이빗 라우팅 테이블이 같은 AZ의 NAT를 가리키게 한다',1);
INSERT INTO "question_choices" VALUES(305,73,3,'D','모든 프라이빗 서브넷에 퍼블릭 IP를 할당하고 인터넷 게이트웨이로 직접 라우팅한다',0);
INSERT INTO "question_choices" VALUES(306,74,0,'A','최소 용량을 최대 부하 수준으로 올려 항상 실행한다',0);
INSERT INTO "question_choices" VALUES(307,74,1,'B','ASG 웜 풀에 사전 초기화한 인스턴스를 Stopped로 두고 수명 주기 후크로 초기화 완료를 보장한다',1);
INSERT INTO "question_choices" VALUES(308,74,2,'C','웜 풀을 Running 상태로 구성해 사전 초기화한 인스턴스를 켜 둔 채 대기시키고 스케일 아웃 시 바로 투입한다',0);
INSERT INTO "question_choices" VALUES(309,74,3,'D','예약 조정으로 매일 정해진 시각에 용량을 미리 늘린다',0);
INSERT INTO "question_choices" VALUES(310,75,0,'A','내부 ALB의 DNS 이름을 대상으로 하는 엔드포인트 상태 검사를 만들어 장애 조치 기본 레코드에 연결한다',0);
INSERT INTO "question_choices" VALUES(311,75,1,'B','기본·보조 레코드에 가중치 라우팅을 적용하고 장애 시 가중치를 수동으로 바꾼다',0);
INSERT INTO "question_choices" VALUES(312,75,2,'C','ALB 상태를 나타내는 CloudWatch 경보 기반 Route 53 상태 검사를 기본 레코드에 연결한다',1);
INSERT INTO "question_choices" VALUES(313,75,3,'D','지연 시간 기반 라우팅 레코드를 만들고 상태 검사 없이 TTL을 1초로 설정한다',0);
INSERT INTO "question_choices" VALUES(314,76,0,'A','API Gateway의 스로틀링 한도를 처리 시스템 속도에 맞춰 낮춘다',0);
INSERT INTO "question_choices" VALUES(315,76,1,'B','API Gateway 캐시를 활성화해 반복 요청을 흡수한다',0);
INSERT INTO "question_choices" VALUES(316,76,2,'C','API Gateway의 AWS 서비스 통합으로 요청을 SQS에 바로 넣고 처리 시스템이 자체 속도로 소비하게 한다',1);
INSERT INTO "question_choices" VALUES(317,76,3,'D','ALB 뒤의 EC2 Auto Scaling 그룹에 접수 서버를 두고 서버가 레거시 시스템을 동기 호출한 뒤 응답하게 한다',0);
INSERT INTO "question_choices" VALUES(318,77,0,'A','AZ마다 고정 IP를 가진 Network Load Balancer를 앞단에 두고 ALB를 대상으로 등록한다',1);
INSERT INTO "question_choices" VALUES(319,77,1,'B','Application Load Balancer만 사용하고 Route 53 별칭 레코드로 노출해 파트너가 도메인 이름으로 접속하게 한다',0);
INSERT INTO "question_choices" VALUES(320,77,2,'C','Network Load Balancer만 사용하고 URL 경로별 리스너 규칙을 설정한다',0);
INSERT INTO "question_choices" VALUES(321,77,3,'D','Classic Load Balancer에 탄력적 IP 주소를 연결해 사용한다',0);
INSERT INTO "question_choices" VALUES(322,78,0,'A','함수에 SQS 데드 레터 큐를 구성하고 보상 처리 함수가 큐를 폴링하게 한다',0);
INSERT INTO "question_choices" VALUES(323,78,1,'B','함수의 비동기 호출 설정에서 실패 시(on-failure) 대상을 보상 처리 Lambda 함수로 지정한다',1);
INSERT INTO "question_choices" VALUES(324,78,2,'C','함수 코드의 try/catch에서 보상 처리 함수를 동기 호출한다',0);
INSERT INTO "question_choices" VALUES(325,78,3,'D','MaximumRetryAttempts를 0으로 설정하고 CloudWatch 경보로 알림만 보내 운영자가 수동으로 보상 처리하게 한다',0);
INSERT INTO "question_choices" VALUES(326,79,0,'A','자체 관리형 권한 StackSet을 만들고 계정마다 실행 역할을 수동으로 생성한다',0);
INSERT INTO "question_choices" VALUES(327,79,1,'B','계정 생성 이벤트로 실행되는 Lambda가 AssumeRole로 각 계정에 스택을 만들게 한다',0);
INSERT INTO "question_choices" VALUES(328,79,2,'C','서비스 관리형 권한의 CloudFormation StackSet을 OU 대상으로 만들고 자동 배포를 활성화한다',1);
INSERT INTO "question_choices" VALUES(329,79,3,'D','관리 계정의 CloudFormation 중첩 스택 하나에 모든 계정과 리전의 리소스를 정의해 한 번의 스택 생성으로 배포한다',0);
INSERT INTO "question_choices" VALUES(330,80,0,'A','글로벌 데이터베이스의 failover를 수행해 보조 리전 클러스터를 승격한다',0);
INSERT INTO "question_choices" VALUES(331,80,1,'B','글로벌 데이터베이스의 switchover를 수행해 보조 리전 클러스터를 기본으로 승격한다',1);
INSERT INTO "question_choices" VALUES(332,80,2,'C','보조 클러스터를 글로벌 데이터베이스에서 분리(detach)해 독립 클러스터로 승격한다',0);
INSERT INTO "question_choices" VALUES(333,80,3,'D','us-east-1 클러스터의 스냅샷을 ap-northeast-2로 복사해 새 클러스터를 복원한다',0);
INSERT INTO "question_choices" VALUES(334,81,0,'A','Amazon EFS를 여러 AZ 마운트 대상으로 구성해 Windows 서버가 SMB로 접근하게 한다',0);
INSERT INTO "question_choices" VALUES(335,81,1,'B','서로 다른 AZ에 EC2 Windows 파일 서버 두 대를 두고 DFS 복제를 직접 구성한다',0);
INSERT INTO "question_choices" VALUES(336,81,2,'C','Amazon FSx for Windows File Server를 다중 AZ 배포로 구성한다',1);
INSERT INTO "question_choices" VALUES(337,81,3,'D','Amazon FSx for Lustre 영구 파일 시스템을 구성한다',0);
INSERT INTO "question_choices" VALUES(338,82,0,'A','S3 CRR로 복제 버킷을 두고 CloudFront 원본 그룹에 두 버킷을 기본·보조 원본으로 등록한다',1);
INSERT INTO "question_choices" VALUES(339,82,1,'B','배포를 두 개 만들고 Route 53 장애 조치 레코드로 전환한다',0);
INSERT INTO "question_choices" VALUES(340,82,2,'C','S3 버전 관리를 켜서 기본 버킷 객체를 보존한다',0);
INSERT INTO "question_choices" VALUES(341,82,3,'D','CloudFront TTL을 24시간으로 늘려 원본 장애 중에도 엣지 캐시에서 오래된 콘텐츠로 응답하게 한다',0);
INSERT INTO "question_choices" VALUES(342,83,0,'A','SQS FIFO 큐를 사용하고 모든 메시지에 동일한 MessageGroupId를 지정한다',0);
INSERT INTO "question_choices" VALUES(343,83,1,'B','SQS FIFO 큐를 사용하고 MessageGroupId에 주문 ID를 지정한다',1);
INSERT INTO "question_choices" VALUES(344,83,2,'C','SQS Standard 큐를 사용하고 메시지에 순번 속성을 넣어 컨슈머가 정렬해 처리한다',0);
INSERT INTO "question_choices" VALUES(345,83,3,'D','주문마다 SQS FIFO 큐를 하나씩 생성하고 컨슈머가 모든 큐를 폴링한다',0);
INSERT INTO "question_choices" VALUES(346,84,0,'A','Organizations에서 AWS Backup 정책을 만들어 OU에 연결하고 중앙 계정 볼트로의 교차 계정·교차 리전 복사 규칙을 포함한다',1);
INSERT INTO "question_choices" VALUES(347,84,1,'B','계정마다 백업 계획을 수동으로 만들고 담당자가 주기적으로 설정을 점검한다',0);
INSERT INTO "question_choices" VALUES(348,84,2,'C','각 계정에서 Data Lifecycle Manager로 EBS 스냅샷만 예약하고 다른 리전으로 복사한다',0);
INSERT INTO "question_choices" VALUES(349,84,3,'D','각 계정의 리소스를 S3로 내보내 교차 리전 복제를 구성한다',0);
INSERT INTO "question_choices" VALUES(350,84,4,'E','AWS Backup에서 교차 계정 백업을 활성화하고 중앙 계정의 대상 볼트에 Vault Lock을 설정한다',1);
INSERT INTO "question_choices" VALUES(351,85,0,'A','통신 지연을 줄이기 위해 podAffinity로 모든 파드를 같은 AZ에 모은다',0);
INSERT INTO "question_choices" VALUES(352,85,1,'B','관리형 노드 그룹이 3개 AZ의 서브넷에 걸쳐 노드를 생성하도록 구성한다',1);
INSERT INTO "question_choices" VALUES(353,85,2,'C','가장 큰 인스턴스 유형 노드 하나에 모든 파드를 배치한다',0);
INSERT INTO "question_choices" VALUES(354,85,3,'D','Deployment에 topology.kubernetes.io/zone 기준의 topologySpreadConstraints를 설정해 파드를 AZ에 분산한다',1);
INSERT INTO "question_choices" VALUES(355,85,4,'E','하나의 EBS 볼륨을 모든 AZ의 파드가 동시에 공유 마운트하도록 구성한다',0);
INSERT INTO "question_choices" VALUES(356,86,0,'A','ASG가 3개 AZ의 서브넷에 걸쳐 인스턴스를 균등 분산하게 하고 ALB도 3개 AZ에서 활성화한다',1);
INSERT INTO "question_choices" VALUES(357,86,1,'B','한 AZ를 잃어도 12대가 유지되도록 AZ당 6대씩 총 18대 수준으로 목표 용량과 최소 용량을 설정한다',1);
INSERT INTO "question_choices" VALUES(358,86,2,'C','비용 절감을 위해 AZ당 4대씩 총 12대만 유지하고 AZ 장애 시 확장을 기다린다',0);
INSERT INTO "question_choices" VALUES(359,86,3,'D','모든 인스턴스를 한 AZ에 배치하고 EBS 스냅샷을 다른 AZ에 복사한다',0);
INSERT INTO "question_choices" VALUES(360,86,4,'E','ALB를 단일 AZ 서브넷에만 연결해 교차 AZ 트래픽을 없앤다',0);
INSERT INTO "question_choices" VALUES(361,87,0,'A','백업 및 복원: 매일 스냅샷을 DR 리전으로 복사하고 장애 시 DB를 복원한다',0);
INSERT INTO "question_choices" VALUES(362,87,1,'B','웜 스탠바이: DR 리전에 축소된 전체 스택을 상시 가동하다가 장애 시 Auto Scaling으로 운영 규모까지 확장한다',0);
INSERT INTO "question_choices" VALUES(363,87,2,'C','멀티 사이트 액티브/액티브: 두 리전 모두 전체 용량으로 트래픽을 처리한다',0);
INSERT INTO "question_choices" VALUES(364,87,3,'D','파일럿 라이트: 데이터는 Aurora 글로벌 데이터베이스로 복제하고 서버 계층은 장애 시 기동한다',1);
INSERT INTO "question_choices" VALUES(365,88,0,'A','SNS FIFO 토픽에 서비스별 SQS FIFO 큐를 구독시키고 주문 ID를 메시지 그룹 ID로 사용한다',1);
INSERT INTO "question_choices" VALUES(366,88,1,'B','SNS 표준 토픽에 서비스별 SQS FIFO 큐를 구독시키고 각 큐에서 메시지 그룹 ID로 순서를 맞춘다',0);
INSERT INTO "question_choices" VALUES(367,88,2,'C','하나의 SQS FIFO 큐를 세 서비스가 함께 폴링하도록 한다',0);
INSERT INTO "question_choices" VALUES(368,88,3,'D','SNS FIFO 토픽에 세 서비스의 HTTPS 엔드포인트를 직접 구독시킨다',0);
INSERT INTO "question_choices" VALUES(369,89,0,'A','CPU 임계값 기준의 단순 조정(simple scaling) 정책을 구성하고 쿨다운을 늘려 불필요한 확장을 줄인다',0);
INSERT INTO "question_choices" VALUES(370,89,1,'B','예약된 작업으로 매일 오전 8시 50분에 고정 용량으로 늘린다',0);
INSERT INTO "question_choices" VALUES(371,89,2,'C','예측 조정(predictive scaling) 정책을 활성화하고 목표 추적 정책과 함께 사용한다',1);
INSERT INTO "question_choices" VALUES(372,89,3,'D','단계 조정(step scaling)의 경보 임계값을 낮춰 더 일찍 확장하게 한다',0);
INSERT INTO "question_choices" VALUES(373,90,0,'A','모든 인스턴스에 스케일 인 보호를 영구적으로 설정해 작업 중인 인스턴스가 종료되지 않게 한다',0);
INSERT INTO "question_choices" VALUES(374,90,1,'B','종료 전환에 수명 주기 후크를 추가하고 정리 후 CompleteLifecycleAction을 호출한다',1);
INSERT INTO "question_choices" VALUES(375,90,2,'C','스케일링 정책의 쿨다운 시간을 늘린다',0);
INSERT INTO "question_choices" VALUES(376,90,3,'D','종료 정책을 OldestInstance로 변경한다',0);
INSERT INTO "question_choices" VALUES(377,91,0,'A','Route 53 지연 시간 레코드에 상태 검사를 연결하고 TTL을 60초로 설정한다',0);
INSERT INTO "question_choices" VALUES(378,91,1,'B','AWS Global Accelerator에 두 리전의 NLB를 엔드포인트로 등록한다',1);
INSERT INTO "question_choices" VALUES(379,91,2,'C','Amazon CloudFront 배포에서 두 리전의 NLB를 원본 그룹으로 구성한다',0);
INSERT INTO "question_choices" VALUES(380,91,3,'D','리전마다 탄력적 IP 주소를 할당하고 클라이언트가 장애 시 다른 IP로 직접 재시도하게 한다',0);
INSERT INTO "question_choices" VALUES(381,92,0,'A','Direct Connect 게이트웨이를 TGW에 연결하고 BGP 동적 라우팅 VPN을 TGW에 백업으로 붙인다',1);
INSERT INTO "question_choices" VALUES(382,92,1,'B','정적 라우트 VPN을 Transit Gateway에 연결하고 Direct Connect 장애 시 운영자가 라우팅 테이블을 직접 수정해 전환한다',0);
INSERT INTO "question_choices" VALUES(383,92,2,'C','두 번째 Direct Connect 연결을 같은 로케이션에 추가한다',0);
INSERT INTO "question_choices" VALUES(384,92,3,'D','VPC마다 별도의 Site-to-Site VPN 연결을 만들어 백업 경로로 사용하고 Transit Gateway는 사용하지 않는다',0);
INSERT INTO "question_choices" VALUES(385,93,0,'A','새벽 2시 온디맨드 백업을 새 테이블로 복원하고 이후 발생한 변경은 포기한 채 복원본을 운영 테이블로 사용한다',0);
INSERT INTO "question_choices" VALUES(386,93,1,'B','다른 리전의 글로벌 테이블 복제본에서 삭제된 항목을 읽어 복구한다',0);
INSERT INTO "question_choices" VALUES(387,93,2,'C','PITR로 삭제 직전 시각의 새 테이블을 복원하고 필요한 항목만 운영 테이블에 반영한다',1);
INSERT INTO "question_choices" VALUES(388,93,3,'D','DynamoDB Streams 레코드를 7일 전부터 재생해 테이블을 되돌린다',0);
INSERT INTO "question_choices" VALUES(389,94,0,'A','하나의 SQS 큐에 발행하고 세 시스템이 같은 큐를 함께 폴링하며 메시지를 나눠 가진다',0);
INSERT INTO "question_choices" VALUES(390,94,1,'B','SNS 주제의 HTTP 엔드포인트로 세 시스템을 직접 구독시키고 필터링은 각 시스템 코드에서 처리한다',0);
INSERT INTO "question_choices" VALUES(391,94,2,'C','SNS 주제에 발행하고 시스템별 SQS를 구독시켜 배송 큐에만 국내 주문 필터를 둔다',1);
INSERT INTO "question_choices" VALUES(392,94,3,'D','Kinesis 데이터 스트림 샤드 하나에 발행하고 각 시스템이 같은 샤드를 폴링해 필요한 이벤트를 고른다',0);
INSERT INTO "question_choices" VALUES(393,95,0,'A','Warm standby',1);
INSERT INTO "question_choices" VALUES(394,95,1,'B','Backup and restore',0);
INSERT INTO "question_choices" VALUES(395,95,2,'C','Pilot light',0);
INSERT INTO "question_choices" VALUES(396,95,3,'D','Multi-site active-active',0);
INSERT INTO "question_choices" VALUES(397,96,0,'A','Aurora 클러스터에서 cross-region 스냅샷 복사를 매시간 실행하도록 예약한다',0);
INSERT INTO "question_choices" VALUES(398,96,1,'B','RDS 다중 AZ 인스턴스 배포를 사용해 다른 AZ에 동기 스탠바이를 둔다',0);
INSERT INTO "question_choices" VALUES(399,96,2,'C','Aurora Global Database를 구성하고 보조 리전 클러스터를 추가한다',1);
INSERT INTO "question_choices" VALUES(400,96,3,'D','AWS DMS 태스크를 두 리전 사이에 수동으로 구성해 지속적으로 복제한다',0);
INSERT INTO "question_choices" VALUES(401,97,0,'A','EventBridge 파트너 이벤트 소스와 규칙을 쓰고 이벤트 아카이브와 재생 기능을 활성화한다',1);
INSERT INTO "question_choices" VALUES(402,97,1,'B','Amazon SQS 표준 큐에 이벤트를 보관하고 소비자가 직접 처리한 오프셋을 기억해 두었다가 다시 읽는다',0);
INSERT INTO "question_choices" VALUES(403,97,2,'C','Amazon SNS 주제에 이벤트를 발행하고 구독자가 필요하면 과거 메시지를 다시 요청해 재생한다',0);
INSERT INTO "question_choices" VALUES(404,97,3,'D','Kinesis Data Firehose로 이벤트를 S3에 적재한 뒤 대상 기간의 객체를 직접 파싱해 재처리한다',0);
INSERT INTO "question_choices" VALUES(405,98,0,'A','Lambda 함수 하나가 모든 단계를 순서대로 실행하고 관리자 승인이 날 때까지 함수 안에서 대기한다',0);
INSERT INTO "question_choices" VALUES(406,98,1,'B','AWS Step Functions Express 워크플로로 모든 단계를 실행하고 승인을 며칠 동안 기다리게 한다',0);
INSERT INTO "question_choices" VALUES(407,98,2,'C','Step Functions Standard 워크플로를 쓰고 승인 단계는 작업 토큰 콜백 패턴으로 구현한다',1);
INSERT INTO "question_choices" VALUES(408,98,3,'D','Amazon SQS 큐 세 개를 만들고 각 단계의 워커가 서로의 큐를 폴링해 다음 단계를 진행한다',0);
INSERT INTO "question_choices" VALUES(409,99,0,'A','MSK Replicator로 소스 클러스터의 토픽을 다른 리전의 MSK 클러스터로 복제한다',1);
INSERT INTO "question_choices" VALUES(410,99,1,'B','EC2 인스턴스에 MirrorMaker 2를 설치하고 Auto Scaling 그룹으로 실행해 리전 간 복제를 수행한다',0);
INSERT INTO "question_choices" VALUES(411,99,2,'C','토픽을 소비해 다른 리전의 Kinesis Data Streams에 다시 쓰는 Lambda 함수를 이벤트 소스 매핑으로 실행한다',0);
INSERT INTO "question_choices" VALUES(412,99,3,'D','MSK Connect에 S3 sink 커넥터를 배포해 토픽 데이터를 S3로 전달한다',1);
INSERT INTO "question_choices" VALUES(413,99,4,'E','S3 버킷에 Cross-Region Replication을 설정하고 MSK 브로커의 로컬 디스크를 S3에 마운트해 보관한다',0);
INSERT INTO "question_choices" VALUES(414,100,0,'A','학습 인스턴스를 서로 다른 세 AZ에 분산하고 AZ 사이에서 EFA 트래픽을 주고받게 한다',0);
INSERT INTO "question_choices" VALUES(415,100,1,'B','EFA를 지원하는 인스턴스 유형에 EFA 인터페이스를 연결하고 NCCL이 Libfabric을 통해 EFA를 사용하게 한다',1);
INSERT INTO "question_choices" VALUES(416,100,2,'C','EFA는 시간당 별도 요금이 부과되므로 학습 시간이 짧을 때만 연결한다',0);
INSERT INTO "question_choices" VALUES(417,100,3,'D','인스턴스를 같은 AZ의 같은 서브넷에 두어 EFA 트래픽이 AZ와 서브넷 경계를 넘지 않게 한다',1);
INSERT INTO "question_choices" VALUES(418,100,4,'E','다른 VPC의 학습 인스턴스와 VPC 피어링을 만들어 EFA 트래픽을 라우팅한다',0);
INSERT INTO "question_choices" VALUES(419,101,0,'A','요청 시 AWS SDK로 DynamoDB를 조회해 사용자 권한 정보를 읽어 응답에 반영한다',0);
INSERT INTO "question_choices" VALUES(420,101,1,'B','수 초가 걸리는 이미지 변환을 수행해 응답으로 반환한다',0);
INSERT INTO "question_choices" VALUES(421,101,2,'C','쿼리 문자열 정렬과 불필요한 파라미터 제거로 캐시 키를 정규화해 캐시 적중률을 높인다',1);
INSERT INTO "question_choices" VALUES(422,101,3,'D','응답 헤더에 보안 헤더를 추가하고 요청 URL을 다른 경로로 리다이렉트한다',1);
INSERT INTO "question_choices" VALUES(423,101,4,'E','POST 요청 본문을 읽어 외부 결제 서비스로 전달한다',0);
INSERT INTO "question_choices" VALUES(424,102,0,'A','io2 볼륨에 Multi-Attach를 활성화하고 두 Nitro 인스턴스에 연결한 뒤 클러스터 인식 파일 시스템을 사용한다',1);
INSERT INTO "question_choices" VALUES(425,102,1,'B','gp3 볼륨에 Multi-Attach를 활성화하고 두 인스턴스에 연결한 뒤 XFS로 포맷한다',0);
INSERT INTO "question_choices" VALUES(426,102,2,'C','Amazon EFS 파일 시스템을 두 인스턴스에 마운트하고 NFS로 공유한다',0);
INSERT INTO "question_choices" VALUES(427,102,3,'D','하나의 EBS 볼륨을 두 인스턴스에 번갈아 연결·분리하는 스크립트를 failover 시 실행하고 파일 시스템을 마운트 해제한 뒤 다시 마운트한다',0);
INSERT INTO "question_choices" VALUES(428,103,0,'A','Valkey(클러스터 모드 활성화)로 샤드와 복제본을 구성한다',0);
INSERT INTO "question_choices" VALUES(429,103,1,'B','ElastiCache for Memcached 클러스터를 구성한다',1);
INSERT INTO "question_choices" VALUES(430,103,2,'C','Amazon MemoryDB로 영속성을 갖춘 클러스터를 구성하고 다중 AZ 복제를 켠다',0);
INSERT INTO "question_choices" VALUES(431,103,3,'D','DynamoDB와 DAX를 구성해 캐시 계층으로 사용한다',0);
INSERT INTO "question_choices" VALUES(432,104,0,'A','Memcached 클러스터를 여러 AZ에 노드를 분산해 구성하고 클라이언트가 노드를 샤딩하게 한다',0);
INSERT INTO "question_choices" VALUES(433,104,1,'B','DynamoDB 테이블 앞에 DAX 클러스터를 두고 점수 항목을 정렬해 조회한다',0);
INSERT INTO "question_choices" VALUES(434,104,2,'C','Valkey 또는 Redis OSS 복제 그룹에 다중 AZ 자동 장애 조치를 켜고 sorted set을 쓴다',1);
INSERT INTO "question_choices" VALUES(435,104,3,'D','Memcached 노드마다 리더보드 복사본을 두고 앱에서 정렬해 반환한다',0);
INSERT INTO "question_choices" VALUES(436,105,0,'A','7일이 지난 인덱스를 매일 S3로 내보내고 삭제한 뒤, 감사 시 Athena로 직접 조회하도록 감사 도구의 쿼리를 변경하고 보관 기간은 S3 수명 주기 규칙으로 관리한다',0);
INSERT INTO "question_choices" VALUES(437,105,1,'B','UltraWarm 노드를 활성화하고 Index State Management 정책으로 7일이 지난 인덱스를 warm 스토리지로 자동 이전한다',1);
INSERT INTO "question_choices" VALUES(438,105,2,'C','모든 데이터 노드를 더 큰 인스턴스 유형으로 교체하고 EBS 볼륨을 키워 인덱스를 모두 한 계층에 유지한다',0);
INSERT INTO "question_choices" VALUES(439,105,3,'D','7일이 지난 인덱스의 replica shard를 0개로 줄여 같은 데이터 노드의 EBS 볼륨에 그대로 보관한다',0);
INSERT INTO "question_choices" VALUES(440,106,0,'A','지역별로 테이블 데이터를 S3 프리픽스에 복사하고 IAM 정책으로 프리픽스별 접근을 제한한다',0);
INSERT INTO "question_choices" VALUES(441,106,1,'B','Lake Formation에서 행 필터 식과 제외 컬럼을 지정한 data filter를 만들고 각 역할에 해당 필터로 SELECT 권한을 부여한다',1);
INSERT INTO "question_choices" VALUES(442,106,2,'C','지역별 Athena 워크그룹을 만들고 워크그룹마다 쿼리 결과 위치와 스캔 한도를 따로 지정한다',0);
INSERT INTO "question_choices" VALUES(443,106,3,'D','Glue ETL 작업으로 PII 컬럼을 제거한 지역별 테이블을 주기적으로 S3에 새로 만들어 각 팀에 노출하고 지역별 IAM 역할에만 해당 테이블의 읽기 권한을 부여한다',0);
INSERT INTO "question_choices" VALUES(444,107,0,'A','CloudFront Functions의 viewer request 함수에서 외부 API를 호출한다',0);
INSERT INTO "question_choices" VALUES(445,107,1,'B','CloudFront 캐시 정책에 토큰 헤더를 포함해 캐시 키 수준에서 검증한다',0);
INSERT INTO "question_choices" VALUES(446,107,2,'C','Lambda@Edge 함수를 사용해 네트워크 호출과 요청 본문 검사를 수행한다',1);
INSERT INTO "question_choices" VALUES(447,107,3,'D','AWS WAF 규칙으로 토큰 문자열을 매칭해 외부 인증 서비스 호출 없이 차단한다',0);
INSERT INTO "question_choices" VALUES(448,108,0,'A','Provisioned throughput으로 변경하고 피크 처리량에 맞춰 항상 해당 값을 프로비저닝한다',0);
INSERT INTO "question_choices" VALUES(449,108,1,'B','파일 시스템에 더미 데이터를 추가해 저장 용량을 늘려 Bursting 기본 처리량을 높인다',0);
INSERT INTO "question_choices" VALUES(450,108,2,'C','Max I/O 성능 모드로 새 파일 시스템을 만들고 데이터를 마이그레이션한다',0);
INSERT INTO "question_choices" VALUES(451,108,3,'D','Elastic throughput 모드로 변경해 워크로드에 따라 처리량이 자동으로 확장·축소되게 한다',1);
INSERT INTO "question_choices" VALUES(452,109,0,'A','Lambda 함수로 작업을 분할해 실행하고 Step Functions로 순서를 제어한다',0);
INSERT INTO "question_choices" VALUES(453,109,1,'B','온디맨드 EC2 인스턴스 Auto Scaling 그룹에 SQS 큐 기반 작업 처리 소프트웨어를 직접 구축한다',0);
INSERT INTO "question_choices" VALUES(454,109,2,'C','Fargate 온디맨드 작업으로 ECS 서비스를 만들고 밤새 작업 수만큼 태스크를 유지한다',0);
INSERT INTO "question_choices" VALUES(455,109,3,'D','AWS Batch의 관리형 컴퓨팅 환경에서 Spot 인스턴스를 사용하고 작업을 작업 큐에 제출한다',1);
INSERT INTO "question_choices" VALUES(456,110,0,'A','VPC마다 virtual private gateway에 VPN 연결을 여러 개 만들고 ECMP를 사용한다',0);
INSERT INTO "question_choices" VALUES(457,110,1,'B','Transit Gateway에 VPN 연결을 여러 개 만들고 ECMP로 트래픽을 분산한다',1);
INSERT INTO "question_choices" VALUES(458,110,2,'C','VPN 터널 하나의 처리량 한도를 AWS Support에 증설 요청한다',0);
INSERT INTO "question_choices" VALUES(459,110,3,'D','Accelerated VPN만 활성화해 터널 한 개로 5Gbps를 확보한다',0);
INSERT INTO "question_choices" VALUES(460,111,0,'A','Route 53 failover 레코드에 리전별 ALB를 등록하고 TTL을 아주 낮게 설정해 전환한다',0);
INSERT INTO "question_choices" VALUES(461,111,1,'B','ALB마다 탄력적 IP 주소를 직접 할당해 고객사에 알려준다',0);
INSERT INTO "question_choices" VALUES(462,111,2,'C','Amazon CloudFront 배포를 만들고 ALB를 origin으로 지정한다',0);
INSERT INTO "question_choices" VALUES(463,111,3,'D','Global Accelerator의 anycast 정적 IP에 리전별 ALB endpoint group을 연결한다',1);
INSERT INTO "question_choices" VALUES(464,112,0,'A','OpenSearch Service 도메인에 상품 데이터를 색인하고 검색을 OpenSearch가 처리하도록 변경한다',1);
INSERT INTO "question_choices" VALUES(465,112,1,'B','RDS for MySQL에 읽기 전용 복제본을 추가하고 검색 전용 replica에서 같은 LIKE 쿼리를 실행하도록 변경한다',0);
INSERT INTO "question_choices" VALUES(466,112,2,'C','상품을 Amazon DynamoDB에 저장하고 Scan 작업에 filter expression을 적용해 검색 결과를 반환한다',0);
INSERT INTO "question_choices" VALUES(467,112,3,'D','상품 데이터를 Amazon S3로 내보내고 요청마다 Amazon Athena 쿼리를 실행해 검색 결과를 반환한다',0);
INSERT INTO "question_choices" VALUES(468,113,0,'A','읽기 전용 쿼리는 reader 엔드포인트로 보내 Aurora가 reader들 사이에서 연결을 분산하게 한다',1);
INSERT INTO "question_choices" VALUES(469,113,1,'B','읽기 전용 쿼리를 각 reader의 인스턴스 엔드포인트로 직접 보내고 애플리케이션이 순환하게 한다',0);
INSERT INTO "question_choices" VALUES(470,113,2,'C','쓰기와 DDL은 클러스터 엔드포인트로 유지해 장애 조치 후에도 새 writer로 연결되게 한다',1);
INSERT INTO "question_choices" VALUES(471,113,3,'D','모든 reader의 승급 우선순위(promotion tier)를 같게 설정해 읽기 쿼리가 균등 분산되게 한다',0);
INSERT INTO "question_choices" VALUES(472,113,4,'E','Route 53 가중치 레코드에 reader 인스턴스 IP를 직접 등록하고 장애 때 수동으로 갱신한다',0);
INSERT INTO "question_choices" VALUES(473,114,0,'A','기존 1Gbps 회선으로 DataSync 작업 하나만 실행해 400TB 전체를 전송한다',0);
INSERT INTO "question_choices" VALUES(474,114,1,'B','10Gbps Direct Connect를 개통하고 DataSync 에이전트와 작업을 여러 개로 나눠 병렬로 전송한다',1);
INSERT INTO "question_choices" VALUES(475,114,2,'C','S3 Transfer Acceleration을 활성화해 1Gbps 회선의 한계를 넘어선다',0);
INSERT INTO "question_choices" VALUES(476,114,3,'D','전체 전송 후 DataSync 작업을 스케줄로 반복 실행해 변경된 데이터만 증분 동기화하고 컷오버한다',1);
INSERT INTO "question_choices" VALUES(477,114,4,'E','Site-to-Site VPN 터널을 추가해 회선 대역폭을 두 배로 늘린다',0);
INSERT INTO "question_choices" VALUES(478,115,0,'A','각 가용 영역의 public subnet에 웹 티어 배포, private subnet에 애플리케이션/DB 티어 배포',1);
INSERT INTO "question_choices" VALUES(479,115,1,'B','모든 인스턴스를 단일 가용 영역의 public subnet에 배포하여 관리 단순화',0);
INSERT INTO "question_choices" VALUES(480,115,2,'C','Application Load Balancer를 여러 가용 영역에 배포하고 traffic 분산',1);
INSERT INTO "question_choices" VALUES(481,115,3,'D','보안을 위해 모든 서브넷을 private으로 설정하고 NAT gateway 없이 아웃바운드 접근만 제한',0);
INSERT INTO "question_choices" VALUES(482,115,4,'E','각 가용 영역의 Network ACL을 stateful 필터링용으로 구성해 security group을 대체한다',0);
INSERT INTO "question_choices" VALUES(483,116,0,'A','AWS Direct Connect 파트너를 통해 hosted connection을 주문한다',1);
INSERT INTO "question_choices" VALUES(484,116,1,'B','1Gbps 이상 dedicated connection을 직접 주문하고 로케이션에 장비를 설치한다',0);
INSERT INTO "question_choices" VALUES(485,116,2,'C','Site-to-Site VPN 터널을 여러 개 만들어 공용 인터넷으로 500Mbps를 확보한다',0);
INSERT INTO "question_choices" VALUES(486,116,3,'D','100Gbps dedicated connection을 주문해 필요한 대역폭을 나눠 사용한다',0);
INSERT INTO "question_choices" VALUES(487,117,0,'A','피크 기준의 RCU/WCU를 provisioned 모드로 상시 프로비저닝한다',0);
INSERT INTO "question_choices" VALUES(488,117,1,'B','provisioned 모드에 Auto Scaling을 설정하고 목표 사용률을 70%로 둔다',0);
INSERT INTO "question_choices" VALUES(489,117,2,'C','DynamoDB 테이블을 on-demand 용량 모드로 설정한다',1);
INSERT INTO "question_choices" VALUES(490,117,3,'D','provisioned 모드에서 reserved capacity를 구매해 피크 용량을 확보한다',0);
INSERT INTO "question_choices" VALUES(491,118,0,'A','lazy loading으로 캐시 미스 시에만 데이터베이스에서 읽어 채우고 TTL을 1시간으로 둔다',0);
INSERT INTO "question_choices" VALUES(492,118,1,'B','캐시를 사용하지 않고 읽기 전용 복제본을 늘려 읽기를 분산한다',0);
INSERT INTO "question_choices" VALUES(493,118,2,'C','캐시 TTL을 24시간으로 설정해 만료 시 새로 읽어 채운다',0);
INSERT INTO "question_choices" VALUES(494,118,3,'D','write-through 전략으로 데이터베이스에 쓸 때 캐시도 함께 갱신한다',1);
INSERT INTO "question_choices" VALUES(495,119,0,'A','여러 VPC에서 직접 VPC peering 설정',0);
INSERT INTO "question_choices" VALUES(496,119,1,'B','AWS Direct Connect로 모든 VPC 연결',0);
INSERT INTO "question_choices" VALUES(497,119,2,'C','AWS Transit Gateway로 hub-and-spoke 네트워크 토폴로지 구성',1);
INSERT INTO "question_choices" VALUES(498,119,3,'D','각 VPC에 Application Load Balancer 배포 후 Route 53으로 라우팅',0);
INSERT INTO "question_choices" VALUES(499,120,0,'A','단일 AZ Amazon RDS 인스턴스',0);
INSERT INTO "question_choices" VALUES(500,120,1,'B','Amazon Aurora 클러스터(자동 장애 조치)',1);
INSERT INTO "question_choices" VALUES(501,120,2,'C','Amazon RDS 다중 AZ DB 인스턴스 배포(standby 1개)',0);
INSERT INTO "question_choices" VALUES(502,120,3,'D','수동 스탠바이 인스턴스 관리',0);
INSERT INTO "question_choices" VALUES(503,121,0,'A','Application Load Balancer (ALB) with 연결 드레이닝 활성화',0);
INSERT INTO "question_choices" VALUES(504,121,1,'B','Network Load Balancer (NLB) with UDP 지원',1);
INSERT INTO "question_choices" VALUES(505,121,2,'C','Classic Load Balancer with TCP 연결 재사용',0);
INSERT INTO "question_choices" VALUES(506,121,3,'D','AWS Global Accelerator with Standard 가속기',0);
INSERT INTO "question_choices" VALUES(507,122,0,'A','Kinesis Data Streams로 수집, Athena로 분석, QuickSight로 시각화',0);
INSERT INTO "question_choices" VALUES(508,122,1,'B','Amazon Data Firehose로 수집, S3 저장, Athena로 분석, QuickSight로 시각화',1);
INSERT INTO "question_choices" VALUES(509,122,2,'C','S3로 저장, Redshift로 로드, QuickSight로 시각화',0);
INSERT INTO "question_choices" VALUES(510,122,3,'D','SQS로 메시지 수집, Lambda로 처리, DynamoDB로 저장',0);
INSERT INTO "question_choices" VALUES(511,123,0,'A','AWS PrivateLink를 사용하여 VPC endpoint 생성',1);
INSERT INTO "question_choices" VALUES(512,123,1,'B','VPC peering과 security group 규칙만 사용',0);
INSERT INTO "question_choices" VALUES(513,123,2,'C','Application Load Balancer와 NAT gateway를 통한 라우팅',0);
INSERT INTO "question_choices" VALUES(514,123,3,'D','AWS VPN과 route table 수정',0);
INSERT INTO "question_choices" VALUES(515,124,0,'A','EC2 인스턴스 그룹에 Kubernetes를 수동 설치한다',0);
INSERT INTO "question_choices" VALUES(516,124,1,'B','Amazon EKS를 사용한다',1);
INSERT INTO "question_choices" VALUES(517,124,2,'C','Amazon ECS를 EC2 론칭 타입으로 사용한다',0);
INSERT INTO "question_choices" VALUES(518,124,3,'D','AWS Fargate를 사용한다',0);
INSERT INTO "question_choices" VALUES(519,125,0,'A','Amazon RDS 멀티 마스터 설정',0);
INSERT INTO "question_choices" VALUES(520,125,1,'B','Amazon Aurora 글로벌 데이터베이스',0);
INSERT INTO "question_choices" VALUES(521,125,2,'C','Amazon Neptune 그래프 데이터베이스',0);
INSERT INTO "question_choices" VALUES(522,125,3,'D','Amazon DynamoDB 글로벌 테이블',1);
INSERT INTO "question_choices" VALUES(523,126,0,'A','S3 Standard 버킷에 데이터를 두고 S3 Transfer Acceleration을 활성화한다',0);
INSERT INTO "question_choices" VALUES(524,126,1,'B','데이터를 S3 Glacier Instant Retrieval 스토리지 클래스로 저장한다',0);
INSERT INTO "question_choices" VALUES(525,126,2,'C','컴퓨팅과 같은 AZ에 S3 Express One Zone directory bucket을 만든다',1);
INSERT INTO "question_choices" VALUES(526,126,3,'D','S3 Standard-IA 클래스에 저장하고 객체마다 multipart upload로 올린다',0);
INSERT INTO "question_choices" VALUES(527,127,0,'A','통신사 5G 네트워크 안에 있는 AWS Wavelength Zone에 게임 서버를 배포한다',1);
INSERT INTO "question_choices" VALUES(528,127,1,'B','Amazon CloudFront로 게임 서버 응답을 캐시해 엣지 로케이션에서 반환한다',0);
INSERT INTO "question_choices" VALUES(529,127,2,'C','가장 가까운 AWS 리전에 게임 서버를 배포하고 Global Accelerator를 앞단에 둔다',0);
INSERT INTO "question_choices" VALUES(530,127,3,'D','대도시의 AWS Local Zone에 게임 서버를 배포하고 인터넷으로 단말과 연결한다',0);
INSERT INTO "question_choices" VALUES(531,128,0,'A','EC2, Fargate, Lambda 사용량에 적용되는 Compute Savings Plans를 구매한다',1);
INSERT INTO "question_choices" VALUES(532,128,1,'B','m5 패밀리에 대한 3년 EC2 Instance Savings Plans를 구매한다',0);
INSERT INTO "question_choices" VALUES(533,128,2,'C','RDS for PostgreSQL 인스턴스에는 RDS Reserved DB Instances를 구매한다',1);
INSERT INTO "question_choices" VALUES(534,128,3,'D','EC2 인스턴스에 3년 Standard 예약 인스턴스를 구매한다',0);
INSERT INTO "question_choices" VALUES(535,128,4,'E','RDS 사용량까지 포함되도록 Compute Savings Plans의 시간당 약정을 크게 설정한다',0);
INSERT INTO "question_choices" VALUES(536,129,0,'A','90일 보관 스냅샷을 포함한 모든 스냅샷을 즉시 Archive 계층으로 이동한다',0);
INSERT INTO "question_choices" VALUES(537,129,1,'B','7년 보관 대상 스냅샷을 EBS Snapshots Archive 계층으로 이동한다',1);
INSERT INTO "question_choices" VALUES(538,129,2,'C','7년 보관 스냅샷을 재해 복구를 위해 다른 리전으로 복사해 이중으로 보관한다',0);
INSERT INTO "question_choices" VALUES(539,129,3,'D','Amazon Data Lifecycle Manager 정책으로 일일 스냅샷을 90일 후 자동 삭제한다',1);
INSERT INTO "question_choices" VALUES(540,129,4,'E','원본 EBS 볼륨을 sc1 유형으로 변경해 스냅샷 크기를 줄인다',0);
INSERT INTO "question_choices" VALUES(541,130,0,'A','버킷의 기본 스토리지 클래스를 S3 Intelligent-Tiering으로 바꿔 미완료 파트가 자동으로 더 저렴한 계층으로 이동하게 한다',0);
INSERT INTO "question_choices" VALUES(542,130,1,'B','버킷에 AbortIncompleteMultipartUpload 수명 주기 규칙을 설정해 시작 후 일정 일수가 지난 미완료 업로드를 자동 삭제한다',1);
INSERT INTO "question_choices" VALUES(543,130,2,'C','현재 버전 객체에 만료 규칙을 추가해 일정 기간이 지난 객체를 삭제한다',0);
INSERT INTO "question_choices" VALUES(544,130,3,'D','S3 Storage Lens 대시보드에서 미완료 업로드 용량을 확인하고 매월 수동으로 삭제한다',0);
INSERT INTO "question_choices" VALUES(545,131,0,'A','모든 함수에 프로비저닝된 동시성을 설정해 초기화 시간을 제거한다',0);
INSERT INTO "question_choices" VALUES(546,131,1,'B','Lambda SnapStart를 활성화해 호출 시간을 줄인다',0);
INSERT INTO "question_choices" VALUES(547,131,2,'C','함수를 EC2 Graviton 인스턴스의 컨테이너로 옮겨 상시 실행한다',0);
INSERT INTO "question_choices" VALUES(548,131,3,'D','함수 아키텍처를 arm64(Graviton2)로 변경한다',1);
INSERT INTO "question_choices" VALUES(549,132,0,'A','각 멤버 계정의 Trusted Advisor 콘솔에 로그인해 점검 결과를 내보내고 스프레드시트로 합친다',0);
INSERT INTO "question_choices" VALUES(550,132,1,'B','AWS Config 집계자(aggregator)를 만들고 관리형 규칙으로 유휴 리소스를 점검해 조직 단위로 조회한다',0);
INSERT INTO "question_choices" VALUES(551,132,2,'C','관리 계정에서 Trusted Advisor 조직 보기를 활성화하고 지원 플랜 요건을 충족한 뒤 비용 최적화 점검 보고서를 생성한다',1);
INSERT INTO "question_choices" VALUES(552,132,3,'D','Compute Optimizer를 조직 전체에서 신뢰할 수 있는 서비스로 활성화하고, 위임된 관리자 계정에서 유휴 로드 밸런서와 미연결 탄력적 IP 주소 권장 사항을 모아 조회한다',0);
INSERT INTO "question_choices" VALUES(553,133,0,'A','AWS Cost Categories에 계정·태그 기준의 사업부 규칙을 만들고 공유 계정 비용을 비례 배분하는 split charge 규칙을 추가한다',1);
INSERT INTO "question_choices" VALUES(554,133,1,'B','공유 계정의 모든 리소스에 사업부 태그를 붙이고 Cost Explorer 태그 필터로 사업부별 비용을 조회한다',0);
INSERT INTO "question_choices" VALUES(555,133,2,'C','Cost and Usage Report를 Athena로 쿼리해 사업부 비율대로 비용을 나누는 SQL을 만들고 Lambda와 EventBridge로 매월 자동 실행해 결과를 저장한다',0);
INSERT INTO "question_choices" VALUES(556,133,3,'D','AWS Organizations SCP로 공유 계정 리소스의 비용이 각 사업부 계정 청구서에 포함되도록 설정한다',0);
INSERT INTO "question_choices" VALUES(557,134,0,'A','follower fetching을 활성화한다(브로커 RackAwareReplicaSelector, 컨슈머 client.rack=자신의 AZ)',1);
INSERT INTO "question_choices" VALUES(558,134,1,'B','토픽의 복제 계수를 1로 낮춰 브로커 간 복제 트래픽을 없앤다',0);
INSERT INTO "question_choices" VALUES(559,134,2,'C','모든 컨슈머를 한 AZ에 몰아 배치한다',0);
INSERT INTO "question_choices" VALUES(560,134,3,'D','컨슈머와 브로커 사이 트래픽을 Transit Gateway를 거치도록 라우팅하고 중앙 라우팅 테이블에서 AZ 간 전송 경로를 관리한다',0);
INSERT INTO "question_choices" VALUES(561,135,0,'A','각 ALB를 NLB로 교체하고 호스트 이름으로 서비스를 구분한다',0);
INSERT INTO "question_choices" VALUES(562,135,1,'B','서비스마다 API Gateway REST API를 만들어 ALB를 제거하고 VPC 링크로 연결한다',0);
INSERT INTO "question_choices" VALUES(563,135,2,'C','ALB 하나로 통합해 호스트 기반 규칙과 SNI 다중 인증서로 서비스별 대상 그룹에 라우팅한다',1);
INSERT INTO "question_choices" VALUES(564,135,3,'D','모든 ALB 앞에 CloudFront 배포를 두어 ALB 요금을 줄인다',0);
INSERT INTO "question_choices" VALUES(565,136,0,'A','Transit Gateway에 VPN 연결을 여러 개 만들어 ECMP로 대역폭을 늘린다',0);
INSERT INTO "question_choices" VALUES(566,136,1,'B','AWS Direct Connect 전용 연결을 구성하고 프라이빗 가상 인터페이스로 전환한다',1);
INSERT INTO "question_choices" VALUES(567,136,2,'C','S3 Transfer Acceleration을 활성화해 데이터센터와 S3 사이 전송을 가속한다',0);
INSERT INTO "question_choices" VALUES(568,136,3,'D','매월 AWS Snowball Edge 디바이스를 주문해 데이터를 오프라인으로 옮긴다',0);
INSERT INTO "question_choices" VALUES(569,137,0,'A','Lambda@Edge 함수의 메모리를 최소 크기로 줄인다',0);
INSERT INTO "question_choices" VALUES(570,137,1,'B','로직을 origin request 이벤트로 옮겨 캐시 미스 때만 실행되게 한다',0);
INSERT INTO "question_choices" VALUES(571,137,2,'C','로직을 CloudFront Functions의 viewer 이벤트 함수로 이전한다',1);
INSERT INTO "question_choices" VALUES(572,137,3,'D','로직을 Lambda@Edge에서 빼고 오리진 ALB의 리스너 규칙과 Lambda 대상 그룹으로 처리하도록 변경한다',0);
INSERT INTO "question_choices" VALUES(573,138,0,'A','AWS Budgets에서 Savings Plans 사용률 예산과 RI 사용률 예산을 만들고 임계값 미만이 되면 SNS나 이메일로 알린다',1);
INSERT INTO "question_choices" VALUES(574,138,1,'B','AWS Budgets에서 월 목표 금액의 비용 예산을 만들고 실제 지출이 초과하면 알린다',0);
INSERT INTO "question_choices" VALUES(575,138,2,'C','Cost Anomaly Detection 모니터를 서비스별로 만들어 비정상 지출 알림을 받는다',0);
INSERT INTO "question_choices" VALUES(576,138,3,'D','CloudWatch에서 EC2 CPUUtilization 알람을 만들고 평균 사용률이 낮아지면 FinOps 팀 주소로 SNS 알림을 보내도록 인스턴스 그룹마다 구성한다',0);
INSERT INTO "question_choices" VALUES(577,139,0,'A','자동 할당 퍼블릭 IP를 탄력적 IP 주소로 교체해 고정 주소로 사용한다',0);
INSERT INTO "question_choices" VALUES(578,139,1,'B','서브넷의 퍼블릭 IP 자동 할당만 끄고 인스턴스는 퍼블릭 서브넷에 그대로 두어 주소 수를 줄인다',0);
INSERT INTO "question_choices" VALUES(579,139,2,'C','인스턴스에 IPv6 주소만 부여하고 IPv4 연결은 제거한다',0);
INSERT INTO "question_choices" VALUES(580,139,3,'D','인스턴스를 프라이빗 서브넷으로 옮기고 AZ별 NAT Gateway로 아웃바운드를 제공한다',1);
INSERT INTO "question_choices" VALUES(581,140,0,'A','S3와 DynamoDB 모두 인터페이스 엔드포인트(AWS PrivateLink)로 연결한다',0);
INSERT INTO "question_choices" VALUES(582,140,1,'B','VPC에 S3용 게이트웨이 엔드포인트를 만들고 서브넷 라우팅 테이블에 연결한다',1);
INSERT INTO "question_choices" VALUES(583,140,2,'C','서브넷을 퍼블릭으로 바꾸고 인스턴스에 퍼블릭 IP를 부여해 인터넷 게이트웨이를 사용한다',0);
INSERT INTO "question_choices" VALUES(584,140,3,'D','NAT Gateway를 NAT 인스턴스로 교체해 시간당 요금을 낮춘다',0);
INSERT INTO "question_choices" VALUES(585,140,4,'E','VPC에 DynamoDB용 게이트웨이 엔드포인트를 만들고 서브넷 라우팅 테이블에 연결한다',1);
INSERT INTO "question_choices" VALUES(586,141,0,'A','세션 테이블을 Standard-IA로 변경해 저장 요금을 낮춘다',0);
INSERT INTO "question_choices" VALUES(587,141,1,'B','감사 테이블에 90일 TTL을 설정해 오래된 항목을 삭제한다',0);
INSERT INTO "question_choices" VALUES(588,141,2,'C','감사 테이블의 테이블 클래스를 DynamoDB Standard-IA로 변경한다',1);
INSERT INTO "question_choices" VALUES(589,141,3,'D','Lambda가 세션 테이블을 주기적으로 Scan해 만료 항목을 삭제한다',0);
INSERT INTO "question_choices" VALUES(590,141,4,'E','세션 테이블에 TTL 속성을 설정해 만료된 항목을 자동 삭제한다',1);
INSERT INTO "question_choices" VALUES(591,142,0,'A','API 서버의 상시 사용량 기준으로 Compute Savings Plans를 구매한다',1);
INSERT INTO "question_choices" VALUES(592,142,1,'B','배치 처리 워크로드에도 3년 Standard 예약 인스턴스를 구매한다',0);
INSERT INTO "question_choices" VALUES(593,142,2,'C','API 서버를 모두 Spot Instances로 전환한다',0);
INSERT INTO "question_choices" VALUES(594,142,3,'D','배치 처리 서버를 Dedicated Hosts에서 실행한다',0);
INSERT INTO "question_choices" VALUES(595,142,4,'E','배치 처리 워크로드에는 Spot Instances를 사용한다',1);
INSERT INTO "question_choices" VALUES(596,143,0,'A','기존 RI를 취소하고 남은 기간의 선결제 금액을 환불받은 뒤 xlarge 다중 AZ RI를 새로 구매한다',0);
INSERT INTO "question_choices" VALUES(597,143,1,'B','추가 조치 없이 인스턴스를 수정한다. RDS RI는 같은 패밀리에서 크기 유연성이 적용되어 정규화 단위가 같다',1);
INSERT INTO "question_choices" VALUES(598,143,2,'C','기존 2xlarge RI를 xlarge 다중 AZ RI로 교환하도록 AWS에 요청한다',0);
INSERT INTO "question_choices" VALUES(599,143,3,'D','변경 전에 xlarge 다중 AZ RI를 추가 구매하고 기존 RI는 그대로 둔다',0);
INSERT INTO "question_choices" VALUES(600,144,0,'A','기존 로그 그룹의 보존 기간을 1일로 단축한다',0);
INSERT INTO "question_choices" VALUES(601,144,1,'B','모든 로그를 Kinesis Data Streams로 보내고 소비자 애플리케이션이 S3에 저장하게 한다',0);
INSERT INTO "question_choices" VALUES(602,144,2,'C','로그 그룹마다 구독 필터를 만들어 Firehose로 S3에 전달하고 로그 그룹은 삭제한다',0);
INSERT INTO "question_choices" VALUES(603,144,3,'D','해당 로그를 Infrequent Access 로그 클래스의 새 로그 그룹으로 보내도록 설정한다',1);
INSERT INTO "question_choices" VALUES(604,145,0,'A','Cost Explorer의 Unblended 비용 보기를 사용하고 RI를 구매한 달의 선결제 금액은 보고서에서 수동으로 제외한다',0);
INSERT INTO "question_choices" VALUES(605,145,1,'B','All Upfront RI를 No Upfront 옵션으로 교환해 매달 같은 금액이 청구되도록 한다',0);
INSERT INTO "question_choices" VALUES(606,145,2,'C','AWS Budgets에서 사업부별 비용 예산을 만들고 RI 구매 월의 초과 알림을 예외 처리한다',0);
INSERT INTO "question_choices" VALUES(607,145,3,'D','Cost Explorer에서 상각(Amortized) 비용 보기를 선택하고 사업부 태그나 Cost Category로 그룹화한다',1);
INSERT INTO "question_choices" VALUES(608,146,0,'A','온디맨드 컴퓨트 환경을 만들고 야간 사용량 기준으로 3년 Compute Savings Plans를 구매해 상시 단가를 낮추고 중단 가능성을 없앤다',0);
INSERT INTO "question_choices" VALUES(609,146,1,'B','Spot 컴퓨트 환경에서 단일 인스턴스 유형과 BEST_FIT 할당 전략을 사용해 최저가 풀만 선택한다',0);
INSERT INTO "question_choices" VALUES(610,146,2,'C','Spot 컴퓨트 환경에서 다양한 인스턴스 유형을 허용하고 SPOT_PRICE_CAPACITY_OPTIMIZED 전략과 작업 재시도를 설정한다',1);
INSERT INTO "question_choices" VALUES(611,146,3,'D','Dedicated Hosts 위에 컴퓨트 환경을 구성해 인스턴스 중단 가능성을 없앤다',0);
INSERT INTO "question_choices" VALUES(612,147,0,'A','AWS DMS로 운영 DB 전체를 테스트 클러스터로 매번 복제한다',0);
INSERT INTO "question_choices" VALUES(613,147,1,'B','Aurora 클로닝(copy-on-write)으로 테스트 클러스터를 만들고 끝나면 삭제한다',1);
INSERT INTO "question_choices" VALUES(614,147,2,'C','스냅샷 복원 뒤 테스트가 끝나면 삭제하는 작업을 Step Functions로 자동화한다',0);
INSERT INTO "question_choices" VALUES(615,147,3,'D','운영 클러스터의 Aurora 읽기 전용 복제본에 접속해 테스트를 수행한다',0);
INSERT INTO "question_choices" VALUES(616,148,0,'A','r6gd 노드 유형의 데이터 계층화(data tiering)를 사용해 노드 수를 줄인다',1);
INSERT INTO "question_choices" VALUES(617,148,1,'B','노드 유형을 r6g.8xlarge로 키우고 노드 수를 절반으로 줄여 인스턴스 관리 수를 줄인다',0);
INSERT INTO "question_choices" VALUES(618,148,2,'C','Memcached 엔진으로 교체해 멀티스레드 효율로 노드 수를 줄인다',0);
INSERT INTO "question_choices" VALUES(619,148,3,'D','복제본 노드를 제거하고 기본 노드만 유지한다',0);
INSERT INTO "question_choices" VALUES(620,149,0,'A','Lambda 함수 3개를 arm64 아키텍처로 변경하고 메모리를 조정해 함수 실행 요금을 줄인다',0);
INSERT INTO "question_choices" VALUES(621,149,1,'B','Express 워크플로 유형의 새 상태 머신으로 전환해 실행·시간·메모리 기준으로 과금되게 한다',1);
INSERT INTO "question_choices" VALUES(622,149,2,'C','Standard 워크플로의 실행 기록 보존 기간을 30일로 단축한다',0);
INSERT INTO "question_choices" VALUES(623,149,3,'D','CloudWatch Logs 로깅 수준을 ERROR로 낮춘다',0);
INSERT INTO "question_choices" VALUES(624,150,0,'A','Transit Gateway에 두 VPC를 연결한다',0);
INSERT INTO "question_choices" VALUES(625,150,1,'B','인터넷 게이트웨이를 통해 퍼블릭 IP로 통신한다',0);
INSERT INTO "question_choices" VALUES(626,150,2,'C','NLB 뒤에 서비스를 두고 PrivateLink 엔드포인트로 연결한다',0);
INSERT INTO "question_choices" VALUES(627,150,3,'D','VPC peering 연결을 구성한다',1);
CREATE TABLE question_keywords (
        kw_id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        keyword TEXT NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
    );
INSERT INTO "question_keywords" VALUES(1,1,'NAT Gateway');
INSERT INTO "question_keywords" VALUES(2,1,'Private Subnet');
INSERT INTO "question_keywords" VALUES(3,1,'Public Subnet');
INSERT INTO "question_keywords" VALUES(4,1,'Route Table');
INSERT INTO "question_keywords" VALUES(5,1,'VPC');
INSERT INTO "question_keywords" VALUES(6,2,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(7,2,'EC2 Hibernation');
INSERT INTO "question_keywords" VALUES(8,2,'Amazon EBS');
INSERT INTO "question_keywords" VALUES(9,2,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(10,2,'RAM Persistence');
INSERT INTO "question_keywords" VALUES(11,3,'Elastic Network Interface (ENI)');
INSERT INTO "question_keywords" VALUES(12,3,'Private IPv4');
INSERT INTO "question_keywords" VALUES(13,3,'Failover');
INSERT INTO "question_keywords" VALUES(14,3,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(15,3,'High Availability');
INSERT INTO "question_keywords" VALUES(16,4,'Amazon S3');
INSERT INTO "question_keywords" VALUES(17,4,'CORS (Cross-Origin Resource Sharing)');
INSERT INTO "question_keywords" VALUES(18,4,'Browser Security');
INSERT INTO "question_keywords" VALUES(19,4,'HTTP Headers');
INSERT INTO "question_keywords" VALUES(20,4,'Bucket Configuration');
INSERT INTO "question_keywords" VALUES(21,5,'Amazon S3');
INSERT INTO "question_keywords" VALUES(22,5,'SSE-C');
INSERT INTO "question_keywords" VALUES(23,5,'Client-Side Encryption');
INSERT INTO "question_keywords" VALUES(24,5,'Encryption at Rest');
INSERT INTO "question_keywords" VALUES(25,5,'Key Management');
INSERT INTO "question_keywords" VALUES(26,6,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(27,6,'On-Demand Instances');
INSERT INTO "question_keywords" VALUES(28,6,'Reserved Instances');
INSERT INTO "question_keywords" VALUES(29,6,'Spot Instances');
INSERT INTO "question_keywords" VALUES(30,6,'Batch Processing');
INSERT INTO "question_keywords" VALUES(31,7,'Amazon SQS');
INSERT INTO "question_keywords" VALUES(32,7,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(33,7,'Decoupling');
INSERT INTO "question_keywords" VALUES(34,7,'EC2 Auto Scaling');
INSERT INTO "question_keywords" VALUES(35,7,'Worker Pattern');
INSERT INTO "question_keywords" VALUES(36,8,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(37,8,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(38,8,'EC2 Auto Scaling');
INSERT INTO "question_keywords" VALUES(39,8,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(40,8,'High Availability');
INSERT INTO "question_keywords" VALUES(41,9,'EC2 Auto Scaling');
INSERT INTO "question_keywords" VALUES(42,9,'Step Scaling Policy');
INSERT INTO "question_keywords" VALUES(43,9,'Instance Warmup');
INSERT INTO "question_keywords" VALUES(44,9,'Burst Traffic');
INSERT INTO "question_keywords" VALUES(45,9,'Elastic Compute');
INSERT INTO "question_keywords" VALUES(46,10,'Amazon Aurora');
INSERT INTO "question_keywords" VALUES(47,10,'Aurora Replica');
INSERT INTO "question_keywords" VALUES(48,10,'Reader Endpoint');
INSERT INTO "question_keywords" VALUES(49,10,'Read Scaling');
INSERT INTO "question_keywords" VALUES(50,10,'Shared Storage');
INSERT INTO "question_keywords" VALUES(51,11,'Amazon S3');
INSERT INTO "question_keywords" VALUES(52,11,'SSE-S3');
INSERT INTO "question_keywords" VALUES(53,11,'SSE-KMS');
INSERT INTO "question_keywords" VALUES(54,11,'AES-256');
INSERT INTO "question_keywords" VALUES(55,11,'Encryption at Rest');
INSERT INTO "question_keywords" VALUES(56,12,'AWS CloudHSM');
INSERT INTO "question_keywords" VALUES(57,12,'AWS KMS');
INSERT INTO "question_keywords" VALUES(58,12,'HSM');
INSERT INTO "question_keywords" VALUES(59,12,'FIPS 140-2/3');
INSERT INTO "question_keywords" VALUES(60,12,'Cryptographic Keys');
INSERT INTO "question_keywords" VALUES(61,13,'Amazon S3');
INSERT INTO "question_keywords" VALUES(62,13,'Bucket Policy');
INSERT INTO "question_keywords" VALUES(63,13,'IAM Role');
INSERT INTO "question_keywords" VALUES(64,13,'Condition Element');
INSERT INTO "question_keywords" VALUES(65,13,'Access Control');
INSERT INTO "question_keywords" VALUES(66,14,'Amazon VPC');
INSERT INTO "question_keywords" VALUES(67,14,'VPC Flow Logs');
INSERT INTO "question_keywords" VALUES(68,14,'ENI');
INSERT INTO "question_keywords" VALUES(69,14,'Network Monitoring');
INSERT INTO "question_keywords" VALUES(70,14,'Security Analysis');
INSERT INTO "question_keywords" VALUES(71,15,'AWS CloudTrail');
INSERT INTO "question_keywords" VALUES(72,15,'API Logging');
INSERT INTO "question_keywords" VALUES(73,15,'Compliance');
INSERT INTO "question_keywords" VALUES(74,15,'Governance');
INSERT INTO "question_keywords" VALUES(75,15,'Audit');
INSERT INTO "question_keywords" VALUES(76,16,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(77,16,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(78,16,'High Availability');
INSERT INTO "question_keywords" VALUES(79,16,'Fault Tolerance');
INSERT INTO "question_keywords" VALUES(80,16,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(81,17,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(82,17,'Multi-AZ Deployment');
INSERT INTO "question_keywords" VALUES(83,17,'Automatic Failover');
INSERT INTO "question_keywords" VALUES(84,17,'Synchronous Replication');
INSERT INTO "question_keywords" VALUES(85,17,'High Availability');
INSERT INTO "question_keywords" VALUES(86,18,'Amazon SQS');
INSERT INTO "question_keywords" VALUES(87,18,'Decoupling');
INSERT INTO "question_keywords" VALUES(88,18,'Message Queue');
INSERT INTO "question_keywords" VALUES(89,18,'Resilience');
INSERT INTO "question_keywords" VALUES(90,18,'Microservices');
INSERT INTO "question_keywords" VALUES(91,19,'Amazon S3');
INSERT INTO "question_keywords" VALUES(92,19,'S3 Glacier Deep Archive');
INSERT INTO "question_keywords" VALUES(93,19,'Storage Classes');
INSERT INTO "question_keywords" VALUES(94,19,'Cold Storage');
INSERT INTO "question_keywords" VALUES(95,19,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(96,20,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(97,20,'PITR (Point-in-Time Recovery)');
INSERT INTO "question_keywords" VALUES(98,20,'Backup & Restore');
INSERT INTO "question_keywords" VALUES(99,20,'Data Protection');
INSERT INTO "question_keywords" VALUES(100,20,'Continuous Backups');
INSERT INTO "question_keywords" VALUES(101,21,'Amazon CloudFront');
INSERT INTO "question_keywords" VALUES(102,21,'CDN');
INSERT INTO "question_keywords" VALUES(103,21,'Edge Locations');
INSERT INTO "question_keywords" VALUES(104,21,'Static Content');
INSERT INTO "question_keywords" VALUES(105,21,'Low Latency');
INSERT INTO "question_keywords" VALUES(106,22,'AWS Fargate');
INSERT INTO "question_keywords" VALUES(107,22,'Amazon ECS');
INSERT INTO "question_keywords" VALUES(108,22,'Serverless Containers');
INSERT INTO "question_keywords" VALUES(109,22,'Compute');
INSERT INTO "question_keywords" VALUES(110,22,'Elasticity');
INSERT INTO "question_keywords" VALUES(111,23,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(112,23,'DynamoDB Accelerator (DAX)');
INSERT INTO "question_keywords" VALUES(113,23,'In-Memory Cache');
INSERT INTO "question_keywords" VALUES(114,23,'Microsecond Latency');
INSERT INTO "question_keywords" VALUES(115,23,'Read Performance');
INSERT INTO "question_keywords" VALUES(116,24,'Amazon Kinesis Data Streams');
INSERT INTO "question_keywords" VALUES(117,24,'Real-Time Streaming');
INSERT INTO "question_keywords" VALUES(118,24,'IoT');
INSERT INTO "question_keywords" VALUES(119,24,'Data Ingestion');
INSERT INTO "question_keywords" VALUES(120,24,'Analytics');
INSERT INTO "question_keywords" VALUES(121,25,'Amazon EFS');
INSERT INTO "question_keywords" VALUES(122,25,'Shared File Storage');
INSERT INTO "question_keywords" VALUES(123,25,'NFS');
INSERT INTO "question_keywords" VALUES(124,25,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(125,25,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(126,26,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(127,26,'Spot Instances');
INSERT INTO "question_keywords" VALUES(128,26,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(129,26,'Fault-Tolerant Workloads');
INSERT INTO "question_keywords" VALUES(130,26,'EC2 Pricing');
INSERT INTO "question_keywords" VALUES(131,27,'AWS Trusted Advisor');
INSERT INTO "question_keywords" VALUES(132,27,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(133,27,'Underutilized Resources');
INSERT INTO "question_keywords" VALUES(134,27,'Cloud Governance');
INSERT INTO "question_keywords" VALUES(135,27,'Recommendations');
INSERT INTO "question_keywords" VALUES(136,28,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(137,28,'On-Demand Instances');
INSERT INTO "question_keywords" VALUES(138,28,'Non-Production Scheduling');
INSERT INTO "question_keywords" VALUES(139,28,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(140,28,'Compute Savings');
INSERT INTO "question_keywords" VALUES(141,29,'Amazon S3');
INSERT INTO "question_keywords" VALUES(142,29,'S3 Lifecycle Policies');
INSERT INTO "question_keywords" VALUES(143,29,'Storage Tiering');
INSERT INTO "question_keywords" VALUES(144,29,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(145,29,'Automation');
INSERT INTO "question_keywords" VALUES(146,30,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(147,30,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(148,30,'NoSQL vs Relational');
INSERT INTO "question_keywords" VALUES(149,30,'Single-Digit Millisecond');
INSERT INTO "question_keywords" VALUES(150,30,'Database Selection');
INSERT INTO "question_keywords" VALUES(151,31,'Amazon CloudFront');
INSERT INTO "question_keywords" VALUES(152,31,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(153,31,'AWS WAF');
INSERT INTO "question_keywords" VALUES(154,31,'Managed Prefix List');
INSERT INTO "question_keywords" VALUES(155,31,'Custom Origin Header');
INSERT INTO "question_keywords" VALUES(156,32,'Amazon ECS');
INSERT INTO "question_keywords" VALUES(157,32,'AWS Fargate');
INSERT INTO "question_keywords" VALUES(158,32,'AWS Secrets Manager');
INSERT INTO "question_keywords" VALUES(159,32,'Task Execution Role');
INSERT INTO "question_keywords" VALUES(160,32,'Container Security');
INSERT INTO "question_keywords" VALUES(161,33,'AWS IAM');
INSERT INTO "question_keywords" VALUES(162,33,'IAM Access Analyzer');
INSERT INTO "question_keywords" VALUES(163,33,'Last Accessed Info');
INSERT INTO "question_keywords" VALUES(164,33,'Least Privilege');
INSERT INTO "question_keywords" VALUES(165,33,'AWS CloudTrail');
INSERT INTO "question_keywords" VALUES(166,34,'IAM Identity Center');
INSERT INTO "question_keywords" VALUES(167,34,'SAML 2.0');
INSERT INTO "question_keywords" VALUES(168,34,'SCIM');
INSERT INTO "question_keywords" VALUES(169,34,'AWS Organizations');
INSERT INTO "question_keywords" VALUES(170,34,'Identity Federation');
INSERT INTO "question_keywords" VALUES(171,35,'Amazon API Gateway');
INSERT INTO "question_keywords" VALUES(172,35,'Amazon Cognito');
INSERT INTO "question_keywords" VALUES(173,35,'User Pool Authorizer');
INSERT INTO "question_keywords" VALUES(174,35,'JWT');
INSERT INTO "question_keywords" VALUES(175,35,'REST API Security');
INSERT INTO "question_keywords" VALUES(176,36,'AWS Audit Manager');
INSERT INTO "question_keywords" VALUES(177,36,'PCI DSS');
INSERT INTO "question_keywords" VALUES(178,36,'AWS Config');
INSERT INTO "question_keywords" VALUES(179,36,'AWS CloudTrail');
INSERT INTO "question_keywords" VALUES(180,36,'Compliance Automation');
INSERT INTO "question_keywords" VALUES(181,37,'Amazon S3');
INSERT INTO "question_keywords" VALUES(182,37,'Cross-Region Replication (CRR)');
INSERT INTO "question_keywords" VALUES(183,37,'SSE-KMS');
INSERT INTO "question_keywords" VALUES(184,37,'Cross-Account Access');
INSERT INTO "question_keywords" VALUES(185,37,'AWS KMS');
INSERT INTO "question_keywords" VALUES(186,38,'AWS Organizations');
INSERT INTO "question_keywords" VALUES(187,38,'Service Control Policy (SCP)');
INSERT INTO "question_keywords" VALUES(188,38,'aws:RequestedRegion');
INSERT INTO "question_keywords" VALUES(189,38,'NotAction');
INSERT INTO "question_keywords" VALUES(190,38,'Data Residency');
INSERT INTO "question_keywords" VALUES(191,39,'Amazon GuardDuty');
INSERT INTO "question_keywords" VALUES(192,39,'Malware Protection for S3');
INSERT INTO "question_keywords" VALUES(193,39,'Amazon S3');
INSERT INTO "question_keywords" VALUES(194,39,'Amazon EventBridge');
INSERT INTO "question_keywords" VALUES(195,39,'Serverless Security');
INSERT INTO "question_keywords" VALUES(196,40,'Amazon Inspector');
INSERT INTO "question_keywords" VALUES(197,40,'Vulnerability Management');
INSERT INTO "question_keywords" VALUES(198,40,'CVE');
INSERT INTO "question_keywords" VALUES(199,40,'Agentless Scanning');
INSERT INTO "question_keywords" VALUES(200,40,'AWS Systems Manager');
INSERT INTO "question_keywords" VALUES(201,41,'AWS KMS');
INSERT INTO "question_keywords" VALUES(202,41,'Amazon S3');
INSERT INTO "question_keywords" VALUES(203,41,'Cross-Account Access');
INSERT INTO "question_keywords" VALUES(204,41,'Key Policy');
INSERT INTO "question_keywords" VALUES(205,41,'IAM Policy');
INSERT INTO "question_keywords" VALUES(206,42,'AWS Certificate Manager (ACM)');
INSERT INTO "question_keywords" VALUES(207,42,'Amazon CloudFront');
INSERT INTO "question_keywords" VALUES(208,42,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(209,42,'us-east-1');
INSERT INTO "question_keywords" VALUES(210,42,'TLS Encryption');
INSERT INTO "question_keywords" VALUES(211,43,'AWS Shield Advanced');
INSERT INTO "question_keywords" VALUES(212,43,'Shield Response Team (SRT)');
INSERT INTO "question_keywords" VALUES(213,43,'AWS WAF');
INSERT INTO "question_keywords" VALUES(214,43,'Rate-Based Rules');
INSERT INTO "question_keywords" VALUES(215,43,'DDoS Cost Protection');
INSERT INTO "question_keywords" VALUES(216,44,'Amazon Macie');
INSERT INTO "question_keywords" VALUES(217,44,'AWS KMS');
INSERT INTO "question_keywords" VALUES(218,44,'Service-Linked Role');
INSERT INTO "question_keywords" VALUES(219,44,'PII Discovery');
INSERT INTO "question_keywords" VALUES(220,44,'Key Policy');
INSERT INTO "question_keywords" VALUES(221,45,'AWS Security Hub');
INSERT INTO "question_keywords" VALUES(222,45,'ASFF');
INSERT INTO "question_keywords" VALUES(223,45,'Cross-Region Aggregation');
INSERT INTO "question_keywords" VALUES(224,45,'Delegated Administrator');
INSERT INTO "question_keywords" VALUES(225,45,'AWS Organizations');
INSERT INTO "question_keywords" VALUES(226,46,'AWS KMS');
INSERT INTO "question_keywords" VALUES(227,46,'KMS Grant');
INSERT INTO "question_keywords" VALUES(228,46,'CreateGrant');
INSERT INTO "question_keywords" VALUES(229,46,'RevokeGrant');
INSERT INTO "question_keywords" VALUES(230,46,'Customer Managed Key');
INSERT INTO "question_keywords" VALUES(231,47,'AWS Network Firewall');
INSERT INTO "question_keywords" VALUES(232,47,'TLS_SNI');
INSERT INTO "question_keywords" VALUES(233,47,'Stateful Rule Group');
INSERT INTO "question_keywords" VALUES(234,47,'Egress Filtering');
INSERT INTO "question_keywords" VALUES(235,47,'Amazon VPC');
INSERT INTO "question_keywords" VALUES(236,48,'AWS Secrets Manager');
INSERT INTO "question_keywords" VALUES(237,48,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(238,48,'Automatic Rotation');
INSERT INTO "question_keywords" VALUES(239,48,'Cross-Region Replication');
INSERT INTO "question_keywords" VALUES(240,48,'Credential Management');
INSERT INTO "question_keywords" VALUES(241,49,'Amazon EFS');
INSERT INTO "question_keywords" VALUES(242,49,'Encryption at Rest');
INSERT INTO "question_keywords" VALUES(243,49,'Encryption in Transit');
INSERT INTO "question_keywords" VALUES(244,49,'TLS');
INSERT INTO "question_keywords" VALUES(245,49,'EFS Mount Helper');
INSERT INTO "question_keywords" VALUES(246,50,'Amazon S3');
INSERT INTO "question_keywords" VALUES(247,50,'S3 Object Lock');
INSERT INTO "question_keywords" VALUES(248,50,'Compliance Mode');
INSERT INTO "question_keywords" VALUES(249,50,'S3 Versioning');
INSERT INTO "question_keywords" VALUES(250,50,'Ransomware Protection');
INSERT INTO "question_keywords" VALUES(251,51,'AWS Organizations');
INSERT INTO "question_keywords" VALUES(252,51,'Service Control Policy (SCP)');
INSERT INTO "question_keywords" VALUES(253,51,'AWS CloudTrail');
INSERT INTO "question_keywords" VALUES(254,51,'Centralized Logging');
INSERT INTO "question_keywords" VALUES(255,51,'Preventive Guardrail');
INSERT INTO "question_keywords" VALUES(256,52,'AWS WAF');
INSERT INTO "question_keywords" VALUES(257,52,'AWS Shield Advanced');
INSERT INTO "question_keywords" VALUES(258,52,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(259,52,'DDoS Mitigation');
INSERT INTO "question_keywords" VALUES(260,52,'SQL Injection');
INSERT INTO "question_keywords" VALUES(261,53,'AWS WAF');
INSERT INTO "question_keywords" VALUES(262,53,'Rate-Based Rule');
INSERT INTO "question_keywords" VALUES(263,53,'Scope-Down Statement');
INSERT INTO "question_keywords" VALUES(264,53,'Brute-Force Protection');
INSERT INTO "question_keywords" VALUES(265,53,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(266,54,'IAM Access Analyzer');
INSERT INTO "question_keywords" VALUES(267,54,'Policy Generation');
INSERT INTO "question_keywords" VALUES(268,54,'AWS CloudTrail');
INSERT INTO "question_keywords" VALUES(269,54,'Least Privilege');
INSERT INTO "question_keywords" VALUES(270,54,'IAM Policy');
INSERT INTO "question_keywords" VALUES(271,55,'AWS PrivateLink');
INSERT INTO "question_keywords" VALUES(272,55,'Network Load Balancer (NLB)');
INSERT INTO "question_keywords" VALUES(273,55,'VPC Endpoint Service');
INSERT INTO "question_keywords" VALUES(274,55,'Overlapping CIDR');
INSERT INTO "question_keywords" VALUES(275,55,'SaaS Networking');
INSERT INTO "question_keywords" VALUES(276,56,'AWS IAM');
INSERT INTO "question_keywords" VALUES(277,56,'Permissions Boundary');
INSERT INTO "question_keywords" VALUES(278,56,'Privilege Escalation Prevention');
INSERT INTO "question_keywords" VALUES(279,56,'IAM Delegation');
INSERT INTO "question_keywords" VALUES(280,56,'Condition Key');
INSERT INTO "question_keywords" VALUES(281,57,'Amazon ECS');
INSERT INTO "question_keywords" VALUES(282,57,'AWS Fargate');
INSERT INTO "question_keywords" VALUES(283,57,'Task Role');
INSERT INTO "question_keywords" VALUES(284,57,'Task Execution Role');
INSERT INTO "question_keywords" VALUES(285,57,'Least Privilege');
INSERT INTO "question_keywords" VALUES(286,58,'Amazon Cognito');
INSERT INTO "question_keywords" VALUES(287,58,'User Pool');
INSERT INTO "question_keywords" VALUES(288,58,'SAML Federation');
INSERT INTO "question_keywords" VALUES(289,58,'API Gateway Authorizer');
INSERT INTO "question_keywords" VALUES(290,58,'JWT');
INSERT INTO "question_keywords" VALUES(291,59,'AWS WAF');
INSERT INTO "question_keywords" VALUES(292,59,'Geo Match Rule');
INSERT INTO "question_keywords" VALUES(293,59,'Amazon IP Reputation List');
INSERT INTO "question_keywords" VALUES(294,59,'Amazon CloudFront');
INSERT INTO "question_keywords" VALUES(295,59,'Edge Security');
INSERT INTO "question_keywords" VALUES(296,60,'Route 53 Resolver DNS Firewall');
INSERT INTO "question_keywords" VALUES(297,60,'Managed Domain Lists');
INSERT INTO "question_keywords" VALUES(298,60,'Amazon VPC');
INSERT INTO "question_keywords" VALUES(299,60,'DNS Security');
INSERT INTO "question_keywords" VALUES(300,60,'Outbound Protection');
INSERT INTO "question_keywords" VALUES(301,61,'VPC Flow Logs');
INSERT INTO "question_keywords" VALUES(302,61,'Amazon S3');
INSERT INTO "question_keywords" VALUES(303,61,'Amazon Athena');
INSERT INTO "question_keywords" VALUES(304,61,'Network Troubleshooting');
INSERT INTO "question_keywords" VALUES(305,61,'Serverless Analytics');
INSERT INTO "question_keywords" VALUES(306,62,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(307,62,'IAM Database Authentication');
INSERT INTO "question_keywords" VALUES(308,62,'TLS/SSL');
INSERT INTO "question_keywords" VALUES(309,62,'Ephemeral Token');
INSERT INTO "question_keywords" VALUES(310,62,'AWS IAM');
INSERT INTO "question_keywords" VALUES(311,63,'AWS Site-to-Site VPN');
INSERT INTO "question_keywords" VALUES(312,63,'IPsec');
INSERT INTO "question_keywords" VALUES(313,63,'Hybrid Networking');
INSERT INTO "question_keywords" VALUES(314,63,'Amazon VPC');
INSERT INTO "question_keywords" VALUES(315,63,'Rapid Deployment');
INSERT INTO "question_keywords" VALUES(316,64,'AWS WAF');
INSERT INTO "question_keywords" VALUES(317,64,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(318,64,'Layer 7 Security');
INSERT INTO "question_keywords" VALUES(319,64,'XSS');
INSERT INTO "question_keywords" VALUES(320,64,'SQL Injection');
INSERT INTO "question_keywords" VALUES(321,65,'AWS IAM');
INSERT INTO "question_keywords" VALUES(322,65,'MFA');
INSERT INTO "question_keywords" VALUES(323,65,'Trust Policy');
INSERT INTO "question_keywords" VALUES(324,65,'aws:MultiFactorAuthPresent');
INSERT INTO "question_keywords" VALUES(325,65,'AWS STS');
INSERT INTO "question_keywords" VALUES(326,66,'Amazon S3');
INSERT INTO "question_keywords" VALUES(327,66,'VPC Gateway Endpoint');
INSERT INTO "question_keywords" VALUES(328,66,'Bucket Policy');
INSERT INTO "question_keywords" VALUES(329,66,'aws:SourceVpce');
INSERT INTO "question_keywords" VALUES(330,66,'Network Isolation');
INSERT INTO "question_keywords" VALUES(331,67,'AWS KMS');
INSERT INTO "question_keywords" VALUES(332,67,'Key Deletion Waiting Period');
INSERT INTO "question_keywords" VALUES(333,67,'Amazon CloudWatch');
INSERT INTO "question_keywords" VALUES(334,67,'Data Protection');
INSERT INTO "question_keywords" VALUES(335,67,'Customer Managed Key');
INSERT INTO "question_keywords" VALUES(336,68,'Amazon Aurora Global Database');
INSERT INTO "question_keywords" VALUES(337,68,'Amazon Route 53');
INSERT INTO "question_keywords" VALUES(338,68,'Disaster Recovery');
INSERT INTO "question_keywords" VALUES(339,68,'RPO/RTO');
INSERT INTO "question_keywords" VALUES(340,68,'Failover Routing');
INSERT INTO "question_keywords" VALUES(341,69,'Gateway Load Balancer (GWLB)');
INSERT INTO "question_keywords" VALUES(342,69,'GWLB Endpoint');
INSERT INTO "question_keywords" VALUES(343,69,'Inspection VPC');
INSERT INTO "question_keywords" VALUES(344,69,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(345,69,'Auto Scaling');
INSERT INTO "question_keywords" VALUES(346,70,'Amazon SQS');
INSERT INTO "question_keywords" VALUES(347,70,'AWS Lambda');
INSERT INTO "question_keywords" VALUES(348,70,'ReportBatchItemFailures');
INSERT INTO "question_keywords" VALUES(349,70,'Visibility Timeout');
INSERT INTO "question_keywords" VALUES(350,70,'Partial Batch Response');
INSERT INTO "question_keywords" VALUES(351,71,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(352,71,'Global Tables');
INSERT INTO "question_keywords" VALUES(353,71,'MRSC (Multi-Region Strong Consistency)');
INSERT INTO "question_keywords" VALUES(354,71,'RPO 0');
INSERT INTO "question_keywords" VALUES(355,71,'Multi-Region');
INSERT INTO "question_keywords" VALUES(356,72,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(357,72,'Multi-AZ DB Cluster');
INSERT INTO "question_keywords" VALUES(358,72,'Readable Standby');
INSERT INTO "question_keywords" VALUES(359,72,'Fast Failover');
INSERT INTO "question_keywords" VALUES(360,72,'PostgreSQL');
INSERT INTO "question_keywords" VALUES(361,73,'NAT Gateway');
INSERT INTO "question_keywords" VALUES(362,73,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(363,73,'Route Table');
INSERT INTO "question_keywords" VALUES(364,73,'Zonal Isolation');
INSERT INTO "question_keywords" VALUES(365,73,'Amazon VPC');
INSERT INTO "question_keywords" VALUES(366,74,'EC2 Auto Scaling');
INSERT INTO "question_keywords" VALUES(367,74,'Warm Pool');
INSERT INTO "question_keywords" VALUES(368,74,'Lifecycle Hook');
INSERT INTO "question_keywords" VALUES(369,74,'Scale-Out Latency');
INSERT INTO "question_keywords" VALUES(370,74,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(371,75,'Amazon Route 53');
INSERT INTO "question_keywords" VALUES(372,75,'CloudWatch Alarm');
INSERT INTO "question_keywords" VALUES(373,75,'Private Hosted Zone');
INSERT INTO "question_keywords" VALUES(374,75,'Internal ALB');
INSERT INTO "question_keywords" VALUES(375,75,'Health Check');
INSERT INTO "question_keywords" VALUES(376,76,'Amazon API Gateway');
INSERT INTO "question_keywords" VALUES(377,76,'Amazon SQS');
INSERT INTO "question_keywords" VALUES(378,76,'AWS Service Integration');
INSERT INTO "question_keywords" VALUES(379,76,'Serverless');
INSERT INTO "question_keywords" VALUES(380,76,'Load Leveling');
INSERT INTO "question_keywords" VALUES(381,77,'Network Load Balancer (NLB)');
INSERT INTO "question_keywords" VALUES(382,77,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(383,77,'Static IP');
INSERT INTO "question_keywords" VALUES(384,77,'Path-Based Routing');
INSERT INTO "question_keywords" VALUES(385,77,'Amazon ECS');
INSERT INTO "question_keywords" VALUES(386,78,'AWS Lambda');
INSERT INTO "question_keywords" VALUES(387,78,'Asynchronous Invocation');
INSERT INTO "question_keywords" VALUES(388,78,'Lambda Destinations');
INSERT INTO "question_keywords" VALUES(389,78,'On-Failure');
INSERT INTO "question_keywords" VALUES(390,78,'Error Handling');
INSERT INTO "question_keywords" VALUES(391,79,'AWS CloudFormation');
INSERT INTO "question_keywords" VALUES(392,79,'StackSets');
INSERT INTO "question_keywords" VALUES(393,79,'Service-Managed Permissions');
INSERT INTO "question_keywords" VALUES(394,79,'AWS Organizations');
INSERT INTO "question_keywords" VALUES(395,79,'Automated Deployment');
INSERT INTO "question_keywords" VALUES(396,80,'Amazon Aurora Global Database');
INSERT INTO "question_keywords" VALUES(397,80,'Switchover');
INSERT INTO "question_keywords" VALUES(398,80,'RPO 0');
INSERT INTO "question_keywords" VALUES(399,80,'Planned Maintenance');
INSERT INTO "question_keywords" VALUES(400,80,'Multi-Region');
INSERT INTO "question_keywords" VALUES(401,81,'Amazon FSx for Windows File Server');
INSERT INTO "question_keywords" VALUES(402,81,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(403,81,'Active Directory');
INSERT INTO "question_keywords" VALUES(404,81,'SMB');
INSERT INTO "question_keywords" VALUES(405,81,'NTFS ACL');
INSERT INTO "question_keywords" VALUES(406,82,'Amazon CloudFront');
INSERT INTO "question_keywords" VALUES(407,82,'Origin Failover');
INSERT INTO "question_keywords" VALUES(408,82,'Origin Group');
INSERT INTO "question_keywords" VALUES(409,82,'S3 Cross-Region Replication (CRR)');
INSERT INTO "question_keywords" VALUES(410,82,'High Availability');
INSERT INTO "question_keywords" VALUES(411,83,'Amazon SQS');
INSERT INTO "question_keywords" VALUES(412,83,'SQS FIFO');
INSERT INTO "question_keywords" VALUES(413,83,'MessageGroupId');
INSERT INTO "question_keywords" VALUES(414,83,'Ordered Processing');
INSERT INTO "question_keywords" VALUES(415,83,'Parallel Consumers');
INSERT INTO "question_keywords" VALUES(416,84,'AWS Backup');
INSERT INTO "question_keywords" VALUES(417,84,'AWS Organizations');
INSERT INTO "question_keywords" VALUES(418,84,'Backup Policy');
INSERT INTO "question_keywords" VALUES(419,84,'Cross-Account Backup');
INSERT INTO "question_keywords" VALUES(420,84,'Vault Lock');
INSERT INTO "question_keywords" VALUES(421,85,'Amazon EKS');
INSERT INTO "question_keywords" VALUES(422,85,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(423,85,'Managed Node Groups');
INSERT INTO "question_keywords" VALUES(424,85,'Topology Spread Constraints');
INSERT INTO "question_keywords" VALUES(425,85,'High Availability');
INSERT INTO "question_keywords" VALUES(426,86,'EC2 Auto Scaling');
INSERT INTO "question_keywords" VALUES(427,86,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(428,86,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(429,86,'Capacity Planning');
INSERT INTO "question_keywords" VALUES(430,86,'Fault Tolerance');
INSERT INTO "question_keywords" VALUES(431,87,'Disaster Recovery');
INSERT INTO "question_keywords" VALUES(432,87,'Pilot Light');
INSERT INTO "question_keywords" VALUES(433,87,'Aurora Global Database');
INSERT INTO "question_keywords" VALUES(434,87,'RPO/RTO');
INSERT INTO "question_keywords" VALUES(435,87,'EC2 Auto Scaling');
INSERT INTO "question_keywords" VALUES(436,88,'Amazon SNS');
INSERT INTO "question_keywords" VALUES(437,88,'SNS FIFO');
INSERT INTO "question_keywords" VALUES(438,88,'Amazon SQS');
INSERT INTO "question_keywords" VALUES(439,88,'SQS FIFO');
INSERT INTO "question_keywords" VALUES(440,88,'Event-Driven Architecture');
INSERT INTO "question_keywords" VALUES(441,89,'EC2 Auto Scaling');
INSERT INTO "question_keywords" VALUES(442,89,'Predictive Scaling');
INSERT INTO "question_keywords" VALUES(443,89,'Target Tracking');
INSERT INTO "question_keywords" VALUES(444,89,'Proactive Scaling');
INSERT INTO "question_keywords" VALUES(445,89,'Machine Learning');
INSERT INTO "question_keywords" VALUES(446,90,'EC2 Auto Scaling');
INSERT INTO "question_keywords" VALUES(447,90,'Lifecycle Hooks');
INSERT INTO "question_keywords" VALUES(448,90,'CompleteLifecycleAction');
INSERT INTO "question_keywords" VALUES(449,90,'Graceful Shutdown');
INSERT INTO "question_keywords" VALUES(450,90,'Amazon S3');
INSERT INTO "question_keywords" VALUES(451,91,'AWS Global Accelerator');
INSERT INTO "question_keywords" VALUES(452,91,'Anycast Static IP');
INSERT INTO "question_keywords" VALUES(453,91,'UDP');
INSERT INTO "question_keywords" VALUES(454,91,'Network Load Balancer (NLB)');
INSERT INTO "question_keywords" VALUES(455,91,'Multi-Region Failover');
INSERT INTO "question_keywords" VALUES(456,92,'AWS Direct Connect');
INSERT INTO "question_keywords" VALUES(457,92,'AWS Transit Gateway');
INSERT INTO "question_keywords" VALUES(458,92,'Site-to-Site VPN');
INSERT INTO "question_keywords" VALUES(459,92,'BGP Routing');
INSERT INTO "question_keywords" VALUES(460,92,'Hybrid Failover');
INSERT INTO "question_keywords" VALUES(461,93,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(462,93,'PITR (Point-in-Time Recovery)');
INSERT INTO "question_keywords" VALUES(463,93,'Global Tables');
INSERT INTO "question_keywords" VALUES(464,93,'Data Recovery');
INSERT INTO "question_keywords" VALUES(465,93,'Operational Safety');
INSERT INTO "question_keywords" VALUES(466,94,'Amazon SNS');
INSERT INTO "question_keywords" VALUES(467,94,'SNS Subscription Filter Policy');
INSERT INTO "question_keywords" VALUES(468,94,'Amazon SQS');
INSERT INTO "question_keywords" VALUES(469,94,'Fan-Out');
INSERT INTO "question_keywords" VALUES(470,94,'Decoupling');
INSERT INTO "question_keywords" VALUES(471,95,'Disaster Recovery');
INSERT INTO "question_keywords" VALUES(472,95,'Warm Standby');
INSERT INTO "question_keywords" VALUES(473,95,'RTO/RPO');
INSERT INTO "question_keywords" VALUES(474,95,'Auto Scaling');
INSERT INTO "question_keywords" VALUES(475,95,'Multi-Region');
INSERT INTO "question_keywords" VALUES(476,96,'Amazon Aurora Global Database');
INSERT INTO "question_keywords" VALUES(477,96,'Cross-Region Replication');
INSERT INTO "question_keywords" VALUES(478,96,'Disaster Recovery');
INSERT INTO "question_keywords" VALUES(479,96,'Sub-Second Replication');
INSERT INTO "question_keywords" VALUES(480,96,'PostgreSQL');
INSERT INTO "question_keywords" VALUES(481,97,'Amazon EventBridge');
INSERT INTO "question_keywords" VALUES(482,97,'Event Archive and Replay');
INSERT INTO "question_keywords" VALUES(483,97,'SaaS Partner Integration');
INSERT INTO "question_keywords" VALUES(484,97,'Event-Driven Architecture');
INSERT INTO "question_keywords" VALUES(485,97,'Serverless');
INSERT INTO "question_keywords" VALUES(486,98,'AWS Step Functions');
INSERT INTO "question_keywords" VALUES(487,98,'Callback Pattern');
INSERT INTO "question_keywords" VALUES(488,98,'Task Token');
INSERT INTO "question_keywords" VALUES(489,98,'Serverless Workflow');
INSERT INTO "question_keywords" VALUES(490,98,'Error Handling');
INSERT INTO "question_keywords" VALUES(491,99,'Amazon MSK');
INSERT INTO "question_keywords" VALUES(492,99,'MSK Replicator');
INSERT INTO "question_keywords" VALUES(493,99,'MSK Connect');
INSERT INTO "question_keywords" VALUES(494,99,'Amazon S3');
INSERT INTO "question_keywords" VALUES(495,99,'Apache Kafka');
INSERT INTO "question_keywords" VALUES(496,100,'Elastic Fabric Adapter (EFA)');
INSERT INTO "question_keywords" VALUES(497,100,'Libfabric');
INSERT INTO "question_keywords" VALUES(498,100,'NCCL');
INSERT INTO "question_keywords" VALUES(499,100,'Distributed ML Training');
INSERT INTO "question_keywords" VALUES(500,100,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(501,101,'Amazon CloudFront');
INSERT INTO "question_keywords" VALUES(502,101,'CloudFront Functions');
INSERT INTO "question_keywords" VALUES(503,101,'Cache Key Normalization');
INSERT INTO "question_keywords" VALUES(504,101,'Security Headers');
INSERT INTO "question_keywords" VALUES(505,101,'Edge Compute');
INSERT INTO "question_keywords" VALUES(506,102,'Amazon EBS');
INSERT INTO "question_keywords" VALUES(507,102,'EBS Multi-Attach');
INSERT INTO "question_keywords" VALUES(508,102,'io2');
INSERT INTO "question_keywords" VALUES(509,102,'Nitro System');
INSERT INTO "question_keywords" VALUES(510,102,'Cluster-Aware File System');
INSERT INTO "question_keywords" VALUES(511,103,'Amazon ElastiCache');
INSERT INTO "question_keywords" VALUES(512,103,'Memcached');
INSERT INTO "question_keywords" VALUES(513,103,'Multi-Threaded Caching');
INSERT INTO "question_keywords" VALUES(514,103,'Horizontal Scaling');
INSERT INTO "question_keywords" VALUES(515,103,'In-Memory Cache');
INSERT INTO "question_keywords" VALUES(516,104,'Amazon ElastiCache');
INSERT INTO "question_keywords" VALUES(517,104,'Valkey / Redis OSS');
INSERT INTO "question_keywords" VALUES(518,104,'Sorted Set');
INSERT INTO "question_keywords" VALUES(519,104,'Multi-AZ Auto Failover');
INSERT INTO "question_keywords" VALUES(520,104,'Real-Time Leaderboard');
INSERT INTO "question_keywords" VALUES(521,105,'Amazon OpenSearch Service');
INSERT INTO "question_keywords" VALUES(522,105,'UltraWarm');
INSERT INTO "question_keywords" VALUES(523,105,'ISM (Index State Management)');
INSERT INTO "question_keywords" VALUES(524,105,'Log Analytics');
INSERT INTO "question_keywords" VALUES(525,105,'Storage Optimization');
INSERT INTO "question_keywords" VALUES(526,106,'AWS Lake Formation');
INSERT INTO "question_keywords" VALUES(527,106,'Data Filter');
INSERT INTO "question_keywords" VALUES(528,106,'Row/Column-Level Security');
INSERT INTO "question_keywords" VALUES(529,106,'Amazon Athena');
INSERT INTO "question_keywords" VALUES(530,106,'AWS Glue Data Catalog');
INSERT INTO "question_keywords" VALUES(531,107,'Lambda@Edge');
INSERT INTO "question_keywords" VALUES(532,107,'Amazon CloudFront');
INSERT INTO "question_keywords" VALUES(533,107,'External API Call');
INSERT INTO "question_keywords" VALUES(534,107,'Request Body Inspection');
INSERT INTO "question_keywords" VALUES(535,107,'Edge Security');
INSERT INTO "question_keywords" VALUES(536,108,'Amazon EFS');
INSERT INTO "question_keywords" VALUES(537,108,'Elastic Throughput');
INSERT INTO "question_keywords" VALUES(538,108,'Amazon EKS');
INSERT INTO "question_keywords" VALUES(539,108,'Spike Workload');
INSERT INTO "question_keywords" VALUES(540,108,'Shared File Storage');
INSERT INTO "question_keywords" VALUES(541,109,'AWS Batch');
INSERT INTO "question_keywords" VALUES(542,109,'Spot Instances');
INSERT INTO "question_keywords" VALUES(543,109,'Container Workloads');
INSERT INTO "question_keywords" VALUES(544,109,'Managed Compute Environment');
INSERT INTO "question_keywords" VALUES(545,109,'High-Throughput Computing');
INSERT INTO "question_keywords" VALUES(546,110,'AWS Transit Gateway');
INSERT INTO "question_keywords" VALUES(547,110,'ECMP (Equal-Cost Multi-Path)');
INSERT INTO "question_keywords" VALUES(548,110,'Site-to-Site VPN');
INSERT INTO "question_keywords" VALUES(549,110,'Bandwidth Aggregation');
INSERT INTO "question_keywords" VALUES(550,110,'Hybrid Networking');
INSERT INTO "question_keywords" VALUES(551,111,'AWS Global Accelerator');
INSERT INTO "question_keywords" VALUES(552,111,'Anycast Static IP');
INSERT INTO "question_keywords" VALUES(553,111,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(554,111,'Multi-Region Failover');
INSERT INTO "question_keywords" VALUES(555,111,'TCP Performance');
INSERT INTO "question_keywords" VALUES(556,112,'Amazon OpenSearch Service');
INSERT INTO "question_keywords" VALUES(557,112,'Full-Text Search');
INSERT INTO "question_keywords" VALUES(558,112,'Fuzzy Matching');
INSERT INTO "question_keywords" VALUES(559,112,'Autocomplete');
INSERT INTO "question_keywords" VALUES(560,112,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(561,113,'Amazon Aurora');
INSERT INTO "question_keywords" VALUES(562,113,'Reader Endpoint');
INSERT INTO "question_keywords" VALUES(563,113,'Cluster Endpoint');
INSERT INTO "question_keywords" VALUES(564,113,'Read Scaling');
INSERT INTO "question_keywords" VALUES(565,113,'Automatic Failover');
INSERT INTO "question_keywords" VALUES(566,114,'AWS DataSync');
INSERT INTO "question_keywords" VALUES(567,114,'AWS Direct Connect');
INSERT INTO "question_keywords" VALUES(568,114,'S3 Migration');
INSERT INTO "question_keywords" VALUES(569,114,'Incremental Sync');
INSERT INTO "question_keywords" VALUES(570,114,'High Throughput');
INSERT INTO "question_keywords" VALUES(571,115,'Amazon VPC');
INSERT INTO "question_keywords" VALUES(572,115,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(573,115,'Public & Private Subnets');
INSERT INTO "question_keywords" VALUES(574,115,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(575,115,'3-Tier Architecture');
INSERT INTO "question_keywords" VALUES(576,116,'AWS Direct Connect');
INSERT INTO "question_keywords" VALUES(577,116,'Hosted Connection');
INSERT INTO "question_keywords" VALUES(578,116,'APN Partner');
INSERT INTO "question_keywords" VALUES(579,116,'Dedicated Bandwidth');
INSERT INTO "question_keywords" VALUES(580,116,'Hybrid Networking');
INSERT INTO "question_keywords" VALUES(581,117,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(582,117,'On-Demand Capacity');
INSERT INTO "question_keywords" VALUES(583,117,'Burst Traffic');
INSERT INTO "question_keywords" VALUES(584,117,'Throttling Prevention');
INSERT INTO "question_keywords" VALUES(585,117,'Serverless Database');
INSERT INTO "question_keywords" VALUES(586,118,'Amazon ElastiCache');
INSERT INTO "question_keywords" VALUES(587,118,'Write-Through');
INSERT INTO "question_keywords" VALUES(588,118,'Cache Strategy');
INSERT INTO "question_keywords" VALUES(589,118,'Data Freshness');
INSERT INTO "question_keywords" VALUES(590,118,'Cache Miss Prevention');
INSERT INTO "question_keywords" VALUES(591,119,'AWS Transit Gateway');
INSERT INTO "question_keywords" VALUES(592,119,'Hub-and-Spoke');
INSERT INTO "question_keywords" VALUES(593,119,'Multi-VPC');
INSERT INTO "question_keywords" VALUES(594,119,'Centralized Routing');
INSERT INTO "question_keywords" VALUES(595,119,'Network Scalability');
INSERT INTO "question_keywords" VALUES(596,120,'Amazon Aurora');
INSERT INTO "question_keywords" VALUES(597,120,'Aurora Replicas');
INSERT INTO "question_keywords" VALUES(598,120,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(599,120,'Read Scaling');
INSERT INTO "question_keywords" VALUES(600,120,'Automatic Failover');
INSERT INTO "question_keywords" VALUES(601,121,'Network Load Balancer (NLB)');
INSERT INTO "question_keywords" VALUES(602,121,'UDP Support');
INSERT INTO "question_keywords" VALUES(603,121,'Layer 4 Load Balancing');
INSERT INTO "question_keywords" VALUES(604,121,'IoT Ingestion');
INSERT INTO "question_keywords" VALUES(605,121,'Ultra-Low Latency');
INSERT INTO "question_keywords" VALUES(606,122,'Amazon Data Firehose');
INSERT INTO "question_keywords" VALUES(607,122,'Amazon S3');
INSERT INTO "question_keywords" VALUES(608,122,'Amazon Athena');
INSERT INTO "question_keywords" VALUES(609,122,'Amazon QuickSight');
INSERT INTO "question_keywords" VALUES(610,122,'Streaming Analytics');
INSERT INTO "question_keywords" VALUES(611,123,'AWS PrivateLink');
INSERT INTO "question_keywords" VALUES(612,123,'VPC Endpoint Service');
INSERT INTO "question_keywords" VALUES(613,123,'Cross-Account Networking');
INSERT INTO "question_keywords" VALUES(614,123,'Microservices');
INSERT INTO "question_keywords" VALUES(615,123,'Private Connectivity');
INSERT INTO "question_keywords" VALUES(616,124,'Amazon EKS');
INSERT INTO "question_keywords" VALUES(617,124,'Kubernetes');
INSERT INTO "question_keywords" VALUES(618,124,'Containers');
INSERT INTO "question_keywords" VALUES(619,124,'Managed Control Plane');
INSERT INTO "question_keywords" VALUES(620,124,'Multi-AZ');
INSERT INTO "question_keywords" VALUES(621,125,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(622,125,'Global Tables');
INSERT INTO "question_keywords" VALUES(623,125,'Multi-Active Replication');
INSERT INTO "question_keywords" VALUES(624,125,'NoSQL');
INSERT INTO "question_keywords" VALUES(625,125,'Eventual Consistency');
INSERT INTO "question_keywords" VALUES(626,126,'Amazon S3 Express One Zone');
INSERT INTO "question_keywords" VALUES(627,126,'Directory Bucket');
INSERT INTO "question_keywords" VALUES(628,126,'Single-Digit Millisecond');
INSERT INTO "question_keywords" VALUES(629,126,'ML Training');
INSERT INTO "question_keywords" VALUES(630,126,'High Request Rate');
INSERT INTO "question_keywords" VALUES(631,127,'AWS Wavelength');
INSERT INTO "question_keywords" VALUES(632,127,'5G Edge Computing');
INSERT INTO "question_keywords" VALUES(633,127,'Ultra-Low Latency');
INSERT INTO "question_keywords" VALUES(634,127,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(635,127,'Mobile Gaming');
INSERT INTO "question_keywords" VALUES(636,128,'Compute Savings Plans');
INSERT INTO "question_keywords" VALUES(637,128,'RDS Reserved Instances');
INSERT INTO "question_keywords" VALUES(638,128,'AWS Graviton');
INSERT INTO "question_keywords" VALUES(639,128,'AWS Fargate');
INSERT INTO "question_keywords" VALUES(640,128,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(641,129,'EBS Snapshots Archive');
INSERT INTO "question_keywords" VALUES(642,129,'Amazon Data Lifecycle Manager (DLM)');
INSERT INTO "question_keywords" VALUES(643,129,'Amazon EBS');
INSERT INTO "question_keywords" VALUES(644,129,'Snapshot Retention');
INSERT INTO "question_keywords" VALUES(645,129,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(646,130,'Amazon S3');
INSERT INTO "question_keywords" VALUES(647,130,'S3 Lifecycle');
INSERT INTO "question_keywords" VALUES(648,130,'AbortIncompleteMultipartUpload');
INSERT INTO "question_keywords" VALUES(649,130,'Multipart Upload');
INSERT INTO "question_keywords" VALUES(650,130,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(651,131,'AWS Lambda');
INSERT INTO "question_keywords" VALUES(652,131,'AWS Graviton2');
INSERT INTO "question_keywords" VALUES(653,131,'arm64');
INSERT INTO "question_keywords" VALUES(654,131,'Serverless Cost');
INSERT INTO "question_keywords" VALUES(655,131,'Instruction Set Architecture');
INSERT INTO "question_keywords" VALUES(656,132,'AWS Trusted Advisor');
INSERT INTO "question_keywords" VALUES(657,132,'Organizational View');
INSERT INTO "question_keywords" VALUES(658,132,'AWS Organizations');
INSERT INTO "question_keywords" VALUES(659,132,'FinOps');
INSERT INTO "question_keywords" VALUES(660,132,'Idle Resources');
INSERT INTO "question_keywords" VALUES(661,133,'AWS Cost Categories');
INSERT INTO "question_keywords" VALUES(662,133,'Split Charge Rules');
INSERT INTO "question_keywords" VALUES(663,133,'Cost Allocation');
INSERT INTO "question_keywords" VALUES(664,133,'Cost Explorer');
INSERT INTO "question_keywords" VALUES(665,133,'AWS Budgets');
INSERT INTO "question_keywords" VALUES(666,134,'Amazon MSK');
INSERT INTO "question_keywords" VALUES(667,134,'Follower Fetching');
INSERT INTO "question_keywords" VALUES(668,134,'RackAwareReplicaSelector');
INSERT INTO "question_keywords" VALUES(669,134,'Cross-AZ Data Transfer');
INSERT INTO "question_keywords" VALUES(670,134,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(671,135,'Application Load Balancer (ALB)');
INSERT INTO "question_keywords" VALUES(672,135,'Host-Based Routing');
INSERT INTO "question_keywords" VALUES(673,135,'SNI (Server Name Indication)');
INSERT INTO "question_keywords" VALUES(674,135,'Microservices');
INSERT INTO "question_keywords" VALUES(675,135,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(676,136,'AWS Direct Connect');
INSERT INTO "question_keywords" VALUES(677,136,'Private Virtual Interface');
INSERT INTO "question_keywords" VALUES(678,136,'Data Transfer Cost');
INSERT INTO "question_keywords" VALUES(679,136,'Hybrid Networking');
INSERT INTO "question_keywords" VALUES(680,136,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(681,137,'Amazon CloudFront');
INSERT INTO "question_keywords" VALUES(682,137,'CloudFront Functions');
INSERT INTO "question_keywords" VALUES(683,137,'Lambda@Edge');
INSERT INTO "question_keywords" VALUES(684,137,'Edge Cost Optimization');
INSERT INTO "question_keywords" VALUES(685,137,'Viewer Request/Response');
INSERT INTO "question_keywords" VALUES(686,138,'AWS Budgets');
INSERT INTO "question_keywords" VALUES(687,138,'Savings Plans Utilization');
INSERT INTO "question_keywords" VALUES(688,138,'RI Utilization');
INSERT INTO "question_keywords" VALUES(689,138,'FinOps');
INSERT INTO "question_keywords" VALUES(690,138,'Cost Monitoring');
INSERT INTO "question_keywords" VALUES(691,139,'Amazon VPC');
INSERT INTO "question_keywords" VALUES(692,139,'Public IPv4 Pricing');
INSERT INTO "question_keywords" VALUES(693,139,'NAT Gateway');
INSERT INTO "question_keywords" VALUES(694,139,'Private Subnet');
INSERT INTO "question_keywords" VALUES(695,139,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(696,140,'VPC Gateway Endpoint');
INSERT INTO "question_keywords" VALUES(697,140,'Amazon S3');
INSERT INTO "question_keywords" VALUES(698,140,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(699,140,'NAT Gateway');
INSERT INTO "question_keywords" VALUES(700,140,'Data Transfer Cost');
INSERT INTO "question_keywords" VALUES(701,141,'Amazon DynamoDB');
INSERT INTO "question_keywords" VALUES(702,141,'DynamoDB Standard-IA');
INSERT INTO "question_keywords" VALUES(703,141,'DynamoDB TTL');
INSERT INTO "question_keywords" VALUES(704,141,'Storage Optimization');
INSERT INTO "question_keywords" VALUES(705,141,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(706,142,'Compute Savings Plans');
INSERT INTO "question_keywords" VALUES(707,142,'Spot Instances');
INSERT INTO "question_keywords" VALUES(708,142,'Amazon EC2');
INSERT INTO "question_keywords" VALUES(709,142,'AWS Fargate');
INSERT INTO "question_keywords" VALUES(710,142,'Cost Optimization');
INSERT INTO "question_keywords" VALUES(711,143,'Amazon RDS');
INSERT INTO "question_keywords" VALUES(712,143,'Reserved DB Instances');
INSERT INTO "question_keywords" VALUES(713,143,'Size Flexibility');
INSERT INTO "question_keywords" VALUES(714,143,'PostgreSQL');
INSERT INTO "question_keywords" VALUES(715,143,'Normalized Units');
INSERT INTO "question_keywords" VALUES(716,144,'Amazon CloudWatch Logs');
INSERT INTO "question_keywords" VALUES(717,144,'Infrequent Access Log Class');
INSERT INTO "question_keywords" VALUES(718,144,'Logs Insights');
INSERT INTO "question_keywords" VALUES(719,144,'Log Cost Optimization');
INSERT INTO "question_keywords" VALUES(720,144,'Observability');
INSERT INTO "question_keywords" VALUES(721,145,'AWS Cost Explorer');
INSERT INTO "question_keywords" VALUES(722,145,'Amortized Costs');
INSERT INTO "question_keywords" VALUES(723,145,'All Upfront RI');
INSERT INTO "question_keywords" VALUES(724,145,'FinOps');
INSERT INTO "question_keywords" VALUES(725,145,'Chargeback');
INSERT INTO "question_keywords" VALUES(726,146,'AWS Batch');
INSERT INTO "question_keywords" VALUES(727,146,'Spot Instances');
INSERT INTO "question_keywords" VALUES(728,146,'SPOT_PRICE_CAPACITY_OPTIMIZED');
INSERT INTO "question_keywords" VALUES(729,146,'Allocation Strategy');
INSERT INTO "question_keywords" VALUES(730,146,'Batch Cost Optimization');
INSERT INTO "question_keywords" VALUES(731,147,'Amazon Aurora');
INSERT INTO "question_keywords" VALUES(732,147,'Aurora Cloning');
INSERT INTO "question_keywords" VALUES(733,147,'Copy-on-Write');
INSERT INTO "question_keywords" VALUES(734,147,'Test Environment');
INSERT INTO "question_keywords" VALUES(735,147,'Storage Cost Optimization');
INSERT INTO "question_keywords" VALUES(736,148,'Amazon ElastiCache');
INSERT INTO "question_keywords" VALUES(737,148,'Data Tiering');
INSERT INTO "question_keywords" VALUES(738,148,'r6gd Nodes');
INSERT INTO "question_keywords" VALUES(739,148,'NVMe SSD');
INSERT INTO "question_keywords" VALUES(740,148,'Memory Cost Optimization');
INSERT INTO "question_keywords" VALUES(741,149,'AWS Step Functions');
INSERT INTO "question_keywords" VALUES(742,149,'Express Workflows');
INSERT INTO "question_keywords" VALUES(743,149,'Standard Workflows');
INSERT INTO "question_keywords" VALUES(744,149,'Idempotent Processing');
INSERT INTO "question_keywords" VALUES(745,149,'Serverless Cost');
INSERT INTO "question_keywords" VALUES(746,150,'VPC Peering');
INSERT INTO "question_keywords" VALUES(747,150,'AWS Transit Gateway');
INSERT INTO "question_keywords" VALUES(748,150,'Data Transfer Cost');
INSERT INTO "question_keywords" VALUES(749,150,'Inter-VPC Networking');
INSERT INTO "question_keywords" VALUES(750,150,'Cost Optimization');
CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY,
        round_id INTEGER NOT NULL,
        question_no INTEGER NOT NULL,
        domain_id INTEGER NOT NULL,
        qtype_id INTEGER NOT NULL,
        qtype TEXT NOT NULL CHECK(qtype IN ('SINGLE', 'MULTI')),
        source TEXT NOT NULL,
        source_ref_id TEXT NOT NULL UNIQUE,
        language TEXT NOT NULL,
        title TEXT NOT NULL,
        question_text TEXT NOT NULL,
        choices_json TEXT NOT NULL,
        answer_index INTEGER,
        answer_indices_json TEXT NOT NULL,
        answer_keys TEXT NOT NULL,
        answer_text TEXT NOT NULL,
        keywords_json TEXT NOT NULL,
        keywords_text TEXT NOT NULL,
        explanation TEXT NOT NULL,
        FOREIGN KEY (round_id) REFERENCES exam_rounds(round_id),
        FOREIGN KEY (domain_id) REFERENCES categories_domain(domain_id),
        FOREIGN KEY (qtype_id) REFERENCES categories_qtype(qtype_id)
    );
INSERT INTO "questions" VALUES(1,1,1,1,2,'MULTI','AWS Official Sample Questions PDF','aws-pdf-01','en','프라이빗 서브넷 EC2 패치 다운로드를 위한 NAT Gateway 라우팅 설계','A company runs a public-facing three-tier web application in a VPC across multiple Availability Zones. Amazon EC2 instances for the application tier running in private subnets need to download software patches from the internet. However, the EC2 instances cannot be directly accessible from the internet. Which actions should be taken to allow the EC2 instances to download the needed patches? (Select TWO.)','[{"key": "A", "text": "Configure a NAT gateway in a public subnet."}, {"key": "B", "text": "Define a custom route table with a route to the NAT gateway for internet traffic and associate it with the private subnets for the application tier."}, {"key": "C", "text": "Assign Elastic IP addresses to the EC2 instances."}, {"key": "D", "text": "Define a custom route table with a route to the internet gateway for internet traffic and associate it with the private subnets for the application tier."}, {"key": "E", "text": "Configure a NAT instance in a private subnet."}]',NULL,'[0, 1]','A, B','A, B — A) Configure a NAT gateway in a public subnet. / B) Define a custom route table with a route to the NAT gateway for internet traffic and associate it with the private subnets for the application tier.','["NAT Gateway", "Private Subnet", "Public Subnet", "Route Table", "VPC"]','NAT Gateway, Private Subnet, Public Subnet, Route Table, VPC','A NAT gateway forwards traffic from the EC2 instances in the private subnet to the internet or other AWS services, and then sends the response back to the instances. After a NAT gateway is created, the route tables for private subnets must be updated to point internet traffic to the NAT gateway.

[핵심 아키텍처 포인트] 프라이빗 서브넷의 아웃바운드 인터넷 통신은 퍼블릭 서브넷에 NAT Gateway를 배치하고 프라이빗 라우팅 테이블의 0.0.0.0/0 경로를 NAT Gateway로 지정해야 인바운드 노출 없이 패치를 다운로드할 수 있습니다.');
INSERT INTO "questions" VALUES(2,1,2,4,1,'SINGLE','AWS Official Sample Questions PDF','aws-pdf-02','en','장기 미사용 기간 중 메모리 상태 유지를 위한 EC2 최대 절전 모드(Hibernation)','A solutions architect wants to design a solution to save costs for Amazon EC2 instances that do not need to run during a 2-week company shutdown. The applications running on the EC2 instances store data in instance memory that must be present when the instances resume operation. Which approach should the solutions architect recommend to shut down and resume the EC2 instances?','[{"key": "A", "text": "Modify the application to store the data on instance store volumes. Reattach the volumes while restarting them."}, {"key": "B", "text": "Snapshot the EC2 instances before stopping them. Restore the snapshot after restarting the instances."}, {"key": "C", "text": "Run the applications on EC2 instances enabled for hibernation. Hibernate the instances before the 2-week company shutdown."}, {"key": "D", "text": "Note the Availability Zone for each EC2 instance before stopping it. Restart the instances in the same Availability Zones after the 2-week company shutdown."}]',2,'[2]','C','C — C) Run the applications on EC2 instances enabled for hibernation. Hibernate the instances before the 2-week company shutdown.','["Amazon EC2", "EC2 Hibernation", "Amazon EBS", "Cost Optimization", "RAM Persistence"]','Amazon EC2, EC2 Hibernation, Amazon EBS, Cost Optimization, RAM Persistence','Hibernating EC2 instances save the contents of instance memory to an Amazon Elastic Block Store (Amazon EBS) root volume. When the instances restart, the instance memory contents are reloaded.

[핵심 아키텍처 포인트] EC2 Hibernation은 인스턴스 메모리(RAM) 내용을 루트 EBS 볼륨에 저장한 뒤 중지하므로 컴퓨팅 요금을 절감하면서 재시작 시 메모리 상태를 그대로 복원할 수 있습니다.');
INSERT INTO "questions" VALUES(3,1,3,2,1,'SINGLE','AWS Official Sample Questions PDF','aws-pdf-03','en','프라이빗 IPv4 기반 모니터링 인스턴스의 보조 ENI 빠른 장애 조치','A company plans to run a monitoring application on an Amazon EC2 instance in a VPC. Connections are made to the EC2 instance using the instance’s private IPv4 address. A solutions architect needs to design a solution that will allow traffic to be quickly directed to a standby EC2 instance if the application fails and becomes unreachable. Which approach will meet these requirements?','[{"key": "A", "text": "Deploy an Application Load Balancer configured with a listener for the private IP address and register the primary EC2 instance with the load balancer. Upon failure, de-register the instance and register the standby EC2 instance."}, {"key": "B", "text": "Configure a custom DHCP option set. Configure DHCP to assign the same private IP address to the standby EC2 instance when the primary EC2 instance fails."}, {"key": "C", "text": "Attach a secondary elastic network interface to the EC2 instance configured with the private IP address. Move the network interface to the standby EC2 instance if the primary EC2 instance becomes unreachable."}, {"key": "D", "text": "Associate an Elastic IP address with the network interface of the primary EC2 instance. Disassociate the Elastic IP from the primary instance upon failure and associate it with a standby EC2 instance."}]',2,'[2]','C','C — C) Attach a secondary elastic network interface to the EC2 instance configured with the private IP address. Move the network interface to the standby EC2 instance if the primary EC2 instance becomes unreachable.','["Elastic Network Interface (ENI)", "Private IPv4", "Failover", "Amazon EC2", "High Availability"]','Elastic Network Interface (ENI), Private IPv4, Failover, Amazon EC2, High Availability','A secondary elastic network interface can be added to an EC2 instance. While primary network interfaces cannot be detached from an instance, secondary network interfaces can be detached and attached to a different EC2 instance.

[핵심 아키텍처 포인트] 기본(Primary) ENI는 인스턴스에서 분리할 수 없지만 보조(Secondary) ENI는 프라이빗 IP를 유지한 채 대기 EC2 인스턴스로 즉시 재연결할 수 있어 빠른 장애 조치가 가능합니다.');
INSERT INTO "questions" VALUES(4,1,4,1,1,'SINGLE','AWS Official Sample Questions PDF','aws-pdf-04','en','외부 웹페이지 JavaScript 인증 GET 요청 허용을 위한 Amazon S3 CORS 설정','An analytics company is planning to offer a web analytics service to its users. The service will require that the users’ webpages include a JavaScript script that makes authenticated GET requests to the company’s Amazon S3 bucket. What must a solutions architect do to ensure that the script will successfully execute?','[{"key": "A", "text": "Enable cross-origin resource sharing (CORS) on the S3 bucket."}, {"key": "B", "text": "Enable S3 Versioning on the S3 bucket."}, {"key": "C", "text": "Provide the users with a signed URL for the script."}, {"key": "D", "text": "Configure an S3 bucket policy to allow public execute privileges."}]',0,'[0]','A','A — A) Enable cross-origin resource sharing (CORS) on the S3 bucket.','["Amazon S3", "CORS (Cross-Origin Resource Sharing)", "Browser Security", "HTTP Headers", "Bucket Configuration"]','Amazon S3, CORS (Cross-Origin Resource Sharing), Browser Security, HTTP Headers, Bucket Configuration','Web browsers will block running a script that originates from a server with a domain name that is different from the webpage. Amazon S3 can be configured with CORS to send HTTP headers that allow the script to run.

[핵심 아키텍처 포인트] 브라우저는 동일 출처 정책(SOP)에 따라 다른 도메인에서 S3로 보내는 스크립트 요청을 차단하므로, S3 버킷에 CORS 규칙을 활성화해 허용 오리진과 GET 메서드 헤더를 반환해야 합니다.');
INSERT INTO "questions" VALUES(5,1,5,1,2,'MULTI','AWS Official Sample Questions PDF','aws-pdf-05','en','온프레미스 키 보관 요건을 충족하는 S3 저장 시 암호화 옵션 (SSE-C · 클라이언트 측 암호화)','A company’s security team requires that all data stored in the cloud be encrypted at rest at all times using encryption keys stored on premises. Which encryption options meet these requirements? (Select TWO.)','[{"key": "A", "text": "Use server-side encryption with Amazon S3 managed encryption keys (SSE-S3)."}, {"key": "B", "text": "Use server-side encryption with AWS KMS managed encryption keys (SSE-KMS)."}, {"key": "C", "text": "Use server-side encryption with customer-provided encryption keys (SSE-C)."}, {"key": "D", "text": "Use client-side encryption to provide at-rest encryption."}, {"key": "E", "text": "Use an AWS Lambda function invoked by Amazon S3 events to encrypt the data using the customer’s keys."}]',NULL,'[2, 3]','C, D','C, D — C) Use server-side encryption with customer-provided encryption keys (SSE-C). / D) Use client-side encryption to provide at-rest encryption.','["Amazon S3", "SSE-C", "Client-Side Encryption", "Encryption at Rest", "Key Management"]','Amazon S3, SSE-C, Client-Side Encryption, Encryption at Rest, Key Management','Server-side encryption with customer-provided keys (SSE-C) enables Amazon S3 to encrypt objects on the server side using an encryption key provided in the PUT request. The same key must be provided in the GET requests for Amazon S3 to decrypt the object. Customers also have the option to encrypt data on the client side before uploading it to Amazon S3, and then they can decrypt the data after downloading it. AWS software development kits (SDKs) provide an S3 encryption client that streamlines the process.

[핵심 아키텍처 포인트] 암호화 키를 AWS 외부(온프레미스)에만 보관해야 할 때는 요청마다 키를 전달하는 SSE-C 또는 업로드 전 AWS SDK 등으로 직접 암호화하는 클라이언트 측 암호화(CSE)를 사용합니다.');
INSERT INTO "questions" VALUES(6,1,6,4,1,'SINGLE','AWS Official Sample Questions PDF','aws-pdf-06','en','중단 불가 월말 배치 부하 급증에 대응하는 EC2 On-Demand 확장 전략','A company uses Amazon EC2 Reserved Instances to run its data processing workload. The nightly job typically takes 7 hours to run and must finish within a 10-hour time window. The company anticipates temporary increases in demand at the end of each month that will cause the job to run over the time limit with the capacity of the current resources. Once started, the processing job cannot be interrupted before completion. The company wants to implement a solution that would provide increased resource capacity as cost-effectively as possible. What should a solutions architect do to accomplish this?','[{"key": "A", "text": "Deploy On-Demand Instances during periods of high demand."}, {"key": "B", "text": "Create a second EC2 reservation for additional instances."}, {"key": "C", "text": "Deploy Spot Instances during periods of high demand."}, {"key": "D", "text": "Increase the EC2 instance size in the EC2 reservation to support the increased workload."}]',0,'[0]','A','A — A) Deploy On-Demand Instances during periods of high demand.','["Amazon EC2", "On-Demand Instances", "Reserved Instances", "Spot Instances", "Batch Processing"]','Amazon EC2, On-Demand Instances, Reserved Instances, Spot Instances, Batch Processing','While Spot Instances would be the least costly option, they are not suitable for jobs that cannot be interrupted or must complete within a certain time period. On-Demand Instances would be billed for the number of seconds they are running.

[핵심 아키텍처 포인트] Spot 인스턴스는 2분 경고 후 중단될 수 있어 중단 불가 작업에 부적합하며, 월말 일시적 부하 증가분만 초 단위 과금되는 On-Demand 인스턴스로 보충하는 것이 가장 비용 효율적입니다.');
INSERT INTO "questions" VALUES(7,1,7,2,1,'SINGLE','AWS Official Sample Questions PDF','aws-pdf-07','en','실시간 투표 트래픽 급증 흡수 및 RDS 보호를 위한 Amazon SQS 디커플링','A company runs an online voting system for a weekly live television program. During broadcasts, users submit hundreds of thousands of votes within minutes to a front-end fleet of Amazon EC2 instances that run in an Auto Scaling group. The EC2 instances write the votes to an Amazon RDS database. However, the database is unable to keep up with the requests that come from the EC2 instances. A solutions architect must design a solution that processes the votes in the most efficient manner and without downtime. Which solution meets these requirements?','[{"key": "A", "text": "Migrate the front-end application to AWS Lambda. Use Amazon API Gateway to route user requests to the Lambda functions."}, {"key": "B", "text": "Scale the database horizontally by converting it to a Multi-AZ deployment. Configure the front-end application to write to both the primary and secondary DB instances."}, {"key": "C", "text": "Configure the front-end application to send votes to an Amazon Simple Queue Service (Amazon SQS) queue. Provision worker instances to read the SQS queue and write the vote information to the database."}, {"key": "D", "text": "Use Amazon EventBridge (Amazon CloudWatch Events) to create a scheduled event to re-provision the database with larger, memory optimized instances during voting periods. When voting ends, re-provision the database to use smaller instances."}]',2,'[2]','C','C — C) Configure the front-end application to send votes to an Amazon Simple Queue Service (Amazon SQS) queue. Provision worker instances to read the SQS queue and write the vote information to the database.','["Amazon SQS", "Amazon RDS", "Decoupling", "EC2 Auto Scaling", "Worker Pattern"]','Amazon SQS, Amazon RDS, Decoupling, EC2 Auto Scaling, Worker Pattern','Decouple the ingestion of votes from the database to allow the voting system to continue processing votes without waiting for the database writes. Add dedicated workers to read from the SQS queue to allow votes to be entered into the database at a controllable rate. The votes will be added to the database as fast as the database can process them, but no votes will be lost.

[핵심 아키텍처 포인트] 대량 쓰기 폭주가 DB로 직접 몰릴 때는 프런트엔드와 DB 사이에 SQS 큐를 두어 요청을 버퍼링하고, 워커 인스턴스가 DB가 감당 가능한 속도로 소비하도록 분리(Decoupling)해야 무중단 처리가 가능합니다.');
INSERT INTO "questions" VALUES(8,1,8,2,2,'MULTI','AWS Official Sample Questions PDF','aws-pdf-08','en','단일 AZ 2계층 웹·DB 아키텍처의 다중 AZ 고가용성 전환 (ALB · ASG · RDS Multi-AZ)','A company has a two-tier application architecture that runs in public and private subnets. Amazon EC2 instances running the web application are in the public subnet and an EC2 instance for the database runs on the private subnet. The web application instances and the database are running in a single Availability Zone (AZ). Which combination of steps should a solutions architect take to provide high availability for this architecture? (Select TWO.)','[{"key": "A", "text": "Create new public and private subnets in the same AZ."}, {"key": "B", "text": "Create an Amazon EC2 Auto Scaling group and Application Load Balancer spanning multiple AZs for the web application instances."}, {"key": "C", "text": "Add the existing web application instances to an Auto Scaling group behind an Application Load Balancer."}, {"key": "D", "text": "Create new public and private subnets in a new AZ. Create a database using an EC2 instance in the public subnet in the new AZ. Migrate the old database contents to the new database."}, {"key": "E", "text": "Create new public and private subnets in the same VPC, each in a new AZ. Create an Amazon RDS Multi-AZ DB instance in the private subnets. Migrate the old database contents to the new DB instance."}]',NULL,'[1, 4]','B, E','B, E — B) Create an Amazon EC2 Auto Scaling group and Application Load Balancer spanning multiple AZs for the web application instances. / E) Create new public and private subnets in the same VPC, each in a new AZ. Create an Amazon RDS Multi-AZ DB instance in the private subnets. Migrate the old database contents to the new DB instance.','["Multi-AZ", "Application Load Balancer (ALB)", "EC2 Auto Scaling", "Amazon RDS", "High Availability"]','Multi-AZ, Application Load Balancer (ALB), EC2 Auto Scaling, Amazon RDS, High Availability','Create new subnets in a new Availability Zone (AZ) to provide a redundant network. Create an Auto Scaling group with instances in two AZs behind the load balancer to ensure high availability of the web application and redistribution of web traffic between the two public AZs. Create an RDS DB instance in the two private subnets to make the database tier highly available too.

[핵심 아키텍처 포인트] 단일 AZ 장애를 극복하려면 웹 계층은 다중 AZ 서브넷에 걸친 ALB + Auto Scaling 그룹으로 분산하고, 데이터베이스는 프라이빗 다중 AZ 서브넷에 RDS Multi-AZ 인스턴스로 마이그레이션해야 합니다.');
INSERT INTO "questions" VALUES(9,1,9,3,1,'SINGLE','AWS Official Sample Questions PDF','aws-pdf-09','en','부팅 워밍업 시간이 있는 EC2 Auto Scaling 급증 트래픽 과잉 확장 방지','A website runs a custom web application that receives a burst of traffic each day at noon. The users upload new pictures and content daily, but have been complaining of timeouts. The architecture uses Amazon EC2 Auto Scaling groups, and the application consistently takes 1 minute to initiate upon boot up before responding to user requests. How should a solutions architect redesign the architecture to better respond to changing traffic?','[{"key": "A", "text": "Configure a Network Load Balancer with a slow start configuration."}, {"key": "B", "text": "Configure Amazon ElastiCache for Redis to offload direct requests from the EC2 instances."}, {"key": "C", "text": "Configure an Auto Scaling step scaling policy with an EC2 instance warmup condition."}, {"key": "D", "text": "Configure Amazon CloudFront to use an Application Load Balancer as the origin."}]',2,'[2]','C','C — C) Configure an Auto Scaling step scaling policy with an EC2 instance warmup condition.','["EC2 Auto Scaling", "Step Scaling Policy", "Instance Warmup", "Burst Traffic", "Elastic Compute"]','EC2 Auto Scaling, Step Scaling Policy, Instance Warmup, Burst Traffic, Elastic Compute','The current configuration puts new EC2 instances into service before they are able to respond to transactions. This could also cause the instances to overscale. With a step scaling policy, you can specify the number of seconds that it takes for a newly launched instance to warm up. Until its specified warm-up time has expired, an EC2 instance is not counted toward the aggregated metrics of the Auto Scaling group. While scaling out, the Auto Scaling logic does not consider EC2 instances that are warming up as part of the current capacity of the Auto Scaling group. Therefore, multiple alarm breaches that fall in the range of the same step adjustment result in a single scaling activity. This ensures that you do not add more instances than you need.

[핵심 아키텍처 포인트] 부팅 후 초기화에 1분이 걸리는 애플리케이션은 Step Scaling 정책에 인스턴스 워밍업(Warmup) 시간을 지정해야, 준비 중인 인스턴스가 지표 집계에서 제외되어 불필요한 과잉 스케일 아웃을 막을 수 있습니다.');
INSERT INTO "questions" VALUES(10,1,10,3,1,'SINGLE','AWS Official Sample Questions PDF','aws-pdf-10','en','Amazon Aurora 쓰기 지연 완화를 위한 Aurora Replica 읽기 트래픽 분리','An application running on AWS uses an Amazon Aurora Multi-AZ DB cluster deployment for its database. When evaluating performance metrics, a solutions architect discovered that the database reads are causing high I/O and adding latency to the write requests against the database. What should the solutions architect do to separate the read requests from the write requests?','[{"key": "A", "text": "Enable read-through caching on the Aurora database."}, {"key": "B", "text": "Update the application to read from the Multi-AZ standby instance."}, {"key": "C", "text": "Create an Aurora replica and modify the application to use the appropriate endpoints."}, {"key": "D", "text": "Create a second Aurora database and link it to the primary database as a read replica."}]',2,'[2]','C','C — C) Create an Aurora replica and modify the application to use the appropriate endpoints.','["Amazon Aurora", "Aurora Replica", "Reader Endpoint", "Read Scaling", "Shared Storage"]','Amazon Aurora, Aurora Replica, Reader Endpoint, Read Scaling, Shared Storage','Aurora Replicas provide a way to offload read traffic. Aurora Replicas share the same underlying storage as the main database, so lag time is generally very low. Aurora Replicas have their own endpoints, so the application will need to be configured to direct read traffic to the new endpoints.

[핵심 아키텍처 포인트] Aurora Multi-AZ 스탠바이는 장애 조치용이며, 읽기 I/O 부하를 분리하려면 Aurora Replica를 추가하고 애플리케이션이 읽기 전용 쿼리를 Reader 엔드포인트로 보내도록 구성해야 합니다.');
INSERT INTO "questions" VALUES(11,2,1,1,1,'SINGLE','CloudCertPrep (MIT)','saa-d1-001','en','Amazon S3 완전 관리형 기본 암호화 옵션 (SSE-S3 vs SSE-KMS)','A company wants to ensure that data stored in Amazon S3 is encrypted at rest using keys fully managed by AWS, with no customer-managed key configuration, no per-key access policies, and no AWS KMS audit trail. Which encryption option should they use?','[{"key": "A", "text": "SSE-S3"}, {"key": "B", "text": "SSE-KMS"}, {"key": "C", "text": "SSE-C"}, {"key": "D", "text": "Client-side encryption"}]',0,'[0]','A','A — A) SSE-S3','["Amazon S3", "SSE-S3", "SSE-KMS", "AES-256", "Encryption at Rest"]','Amazon S3, SSE-S3, SSE-KMS, AES-256, Encryption at Rest','SSE-S3 uses Amazon S3 managed keys (AES-256) with no customer involvement, no per-key policies, and no KMS audit trail. SSE-KMS uses AWS KMS keys (AWS-managed or customer-managed) and adds KMS access policies and CloudTrail integration, which is more than the requirement asks for. SSE-C requires the customer to provide and manage their own keys on every request. Client-side encryption happens before upload and is fully customer-managed.

[핵심 아키텍처 포인트] 키 관리 정책이나 KMS CloudTrail 감사 추적이 필요 없는 완전 관리형 S3 서버 측 암호화는 SSE-S3를 사용합니다.');
INSERT INTO "questions" VALUES(12,2,2,1,1,'SINGLE','CloudCertPrep (MIT)','saa-d1-002','en','전용 하드웨어 보안 모듈(HSM) 암호화 키 저장 서비스 (AWS CloudHSM)','Which AWS service provides a managed hardware security module (HSM) for cryptographic key storage?','[{"key": "A", "text": "AWS KMS"}, {"key": "B", "text": "AWS CloudHSM"}, {"key": "C", "text": "AWS Secrets Manager"}, {"key": "D", "text": "AWS Certificate Manager"}]',1,'[1]','B','B — B) AWS CloudHSM','["AWS CloudHSM", "AWS KMS", "HSM", "FIPS 140-2/3", "Cryptographic Keys"]','AWS CloudHSM, AWS KMS, HSM, FIPS 140-2/3, Cryptographic Keys','AWS CloudHSM provides dedicated HSM instances. KMS is a managed key service but uses shared infrastructure. Secrets Manager stores secrets, not HSM keys. ACM manages SSL/TLS certificates.

[핵심 아키텍처 포인트] 공유 인프라 기반 관리형 키 서비스인 KMS와 달리 단일 테넌트 전용 하드웨어 HSM 인스턴스가 필요할 때는 AWS CloudHSM을 선택합니다.');
INSERT INTO "questions" VALUES(13,2,3,1,1,'SINGLE','CloudCertPrep (MIT)','saa-d1-003','en','특정 IAM 역할만 허용하는 S3 버킷 정책 Condition 제어','A solutions architect needs to restrict access to an S3 bucket so that only a specific IAM role can access it. What should they configure?','[{"key": "A", "text": "S3 ACL"}, {"key": "B", "text": "S3 bucket policy with a Condition element"}, {"key": "C", "text": "S3 Object Lock"}, {"key": "D", "text": "S3 Versioning"}]',1,'[1]','B','B — B) S3 bucket policy with a Condition element','["Amazon S3", "Bucket Policy", "IAM Role", "Condition Element", "Access Control"]','Amazon S3, Bucket Policy, IAM Role, Condition Element, Access Control','A bucket policy with a Condition element can restrict access to a specific IAM role ARN. ACLs are legacy and less precise. Object Lock prevents deletion. Versioning preserves object versions.

[핵심 아키텍처 포인트] 레거시 ACL 대신 S3 버킷 정책의 Principal 또는 Condition 조건 키를 사용하면 특정 IAM Role ARN으로 접근을 정밀하게 제한할 수 있습니다.');
INSERT INTO "questions" VALUES(14,2,4,1,1,'SINGLE','CloudCertPrep (MIT)','saa-d1-004','en','VPC 네트워크 인터페이스(ENI) IP 트래픽 모니터링 (VPC Flow Logs)','Which feature of Amazon VPC allows you to monitor network traffic flowing to and from network interfaces?','[{"key": "A", "text": "VPC Peering"}, {"key": "B", "text": "VPC Flow Logs"}, {"key": "C", "text": "NAT Gateway"}, {"key": "D", "text": "Internet Gateway"}]',1,'[1]','B','B — B) VPC Flow Logs','["Amazon VPC", "VPC Flow Logs", "ENI", "Network Monitoring", "Security Analysis"]','Amazon VPC, VPC Flow Logs, ENI, Network Monitoring, Security Analysis','VPC Flow Logs capture information about IP traffic going to and from network interfaces in a VPC. VPC Peering connects VPCs. NAT Gateway enables outbound internet for private subnets. Internet Gateway connects a VPC to the internet.

[핵심 아키텍처 포인트] VPC Flow Logs는 VPC·서브넷·ENI 단위로 송수신되는 IP 트래픽의 허용(ACCEPT)/거부(REJECT) 메타데이터를 수집해 네트워크 진단과 보안 감사에 활용됩니다.');
INSERT INTO "questions" VALUES(15,2,5,1,1,'SINGLE','CloudCertPrep (MIT)','saa-d1-005','en','규정 준수를 위한 모든 AWS API 호출 감사 로깅 (AWS CloudTrail)','A company requires all API calls to AWS services to be logged for compliance. Which service should they enable?','[{"key": "A", "text": "Amazon CloudWatch"}, {"key": "B", "text": "AWS CloudTrail"}, {"key": "C", "text": "AWS Config"}, {"key": "D", "text": "Amazon GuardDuty"}]',1,'[1]','B','B — B) AWS CloudTrail','["AWS CloudTrail", "API Logging", "Compliance", "Governance", "Audit"]','AWS CloudTrail, API Logging, Compliance, Governance, Audit','AWS CloudTrail records API calls made to AWS services. CloudWatch monitors metrics and logs. AWS Config tracks resource configurations. GuardDuty is a threat detection service.

[핵심 아키텍처 포인트] AWS 계정 내 모든 API 호출과 관리 이벤트를 기록해 거버넌스·컴플라이언스 감사를 지원하는 핵심 서비스는 AWS CloudTrail입니다.');
INSERT INTO "questions" VALUES(16,2,6,2,1,'SINGLE','CloudCertPrep (MIT)','saa-d2-001','en','단일 가용 영역(AZ) 장애 대비 다중 AZ ALB 고가용성 아키텍처','A web application must remain available even if an entire Availability Zone fails. Which architecture pattern achieves this?','[{"key": "A", "text": "Deploy to a single AZ with Auto Scaling"}, {"key": "B", "text": "Deploy across multiple AZs with an Application Load Balancer"}, {"key": "C", "text": "Deploy to a single AZ with a larger instance type"}, {"key": "D", "text": "Deploy to a single Region with CloudFront"}]',1,'[1]','B','B — B) Deploy across multiple AZs with an Application Load Balancer','["Multi-AZ", "Application Load Balancer (ALB)", "High Availability", "Fault Tolerance", "Amazon EC2"]','Multi-AZ, Application Load Balancer (ALB), High Availability, Fault Tolerance, Amazon EC2','Multi-AZ deployment with an ALB distributes traffic across AZs, providing resilience against a single AZ failure. A single AZ deployment, regardless of scaling or instance size, cannot survive an AZ outage.

[핵심 아키텍처 포인트] 단일 AZ 내부의 Auto Scaling이나 인스턴스 스케일업은 AZ 전체 장애를 견딜 수 없으므로, 여러 AZ에 걸쳐 배포하고 ALB로 트래픽을 분산해야 합니다.');
INSERT INTO "questions" VALUES(17,2,7,2,1,'SINGLE','CloudCertPrep (MIT)','saa-d2-002','en','다른 AZ 대기 복제본으로 자동 장애 조치하는 Amazon RDS Multi-AZ','Which Amazon RDS feature provides automatic failover to a standby replica in a different Availability Zone?','[{"key": "A", "text": "Read Replicas"}, {"key": "B", "text": "Multi-AZ deployment"}, {"key": "C", "text": "Aurora Serverless"}, {"key": "D", "text": "RDS Proxy"}]',1,'[1]','B','B — B) Multi-AZ deployment','["Amazon RDS", "Multi-AZ Deployment", "Automatic Failover", "Synchronous Replication", "High Availability"]','Amazon RDS, Multi-AZ Deployment, Automatic Failover, Synchronous Replication, High Availability','Multi-AZ deployment maintains a synchronous standby replica in a different AZ with automatic failover. Read Replicas are for read scaling, not automatic failover. Aurora Serverless auto-scales capacity. RDS Proxy manages database connections.

[핵심 아키텍처 포인트] RDS Multi-AZ는 다른 AZ에 동기식 대기 복제본을 유지하며 장애 시 자동 페일오버를 수행합니다(Read Replica는 비동기 읽기 확장용).');
INSERT INTO "questions" VALUES(18,2,8,2,1,'SINGLE','CloudCertPrep (MIT)','saa-d2-003','en','가변 처리 부하 대응을 위한 애플리케이션 컴포넌트 디커플링 (Amazon SQS)','A company needs to decouple their application components to handle variable processing loads. Which service should they use?','[{"key": "A", "text": "Amazon SQS"}, {"key": "B", "text": "Amazon RDS"}, {"key": "C", "text": "Amazon EC2"}, {"key": "D", "text": "Amazon S3"}]',0,'[0]','A','A — A) Amazon SQS','["Amazon SQS", "Decoupling", "Message Queue", "Resilience", "Microservices"]','Amazon SQS, Decoupling, Message Queue, Resilience, Microservices','Amazon SQS is a fully managed message queuing service that decouples application components. RDS is a database service. EC2 is a compute service. S3 is object storage.

[핵심 아키텍처 포인트] 트래픽 변동성이 큰 환경에서는 Amazon SQS 메시지 큐로 생산자와 소비자를 분리해 부하 급증 시에도 시스템 전체 장애를 방지합니다.');
INSERT INTO "questions" VALUES(19,2,9,2,1,'SINGLE','CloudCertPrep (MIT)','saa-d2-004','en','분기별 1회 미만 접근 · 12시간 복구 허용 장기 아카이브 (S3 Glacier Deep Archive)','Which S3 storage class should be used for data that is accessed less than once per quarter and can tolerate retrieval times of 12 hours?','[{"key": "A", "text": "S3 Standard"}, {"key": "B", "text": "S3 Glacier Instant Retrieval"}, {"key": "C", "text": "S3 Glacier Deep Archive"}, {"key": "D", "text": "S3 One Zone-IA"}]',2,'[2]','C','C — C) S3 Glacier Deep Archive','["Amazon S3", "S3 Glacier Deep Archive", "Storage Classes", "Cold Storage", "Cost Optimization"]','Amazon S3, S3 Glacier Deep Archive, Storage Classes, Cold Storage, Cost Optimization','Glacier Deep Archive is the lowest-cost storage class, suitable for data accessed rarely with retrieval times of 12-48 hours. Glacier Instant Retrieval provides millisecond access. One Zone-IA stores data in one AZ.

[핵심 아키텍처 포인트] 분기 1회 미만으로 거의 접근하지 않고 12~48시간 복구 지연을 허용할 수 있는 장기 데이터는 최저 비용 계층인 S3 Glacier Deep Archive가 최적입니다.');
INSERT INTO "questions" VALUES(20,2,10,2,1,'SINGLE','CloudCertPrep (MIT)','saa-d2-005','en','실수 테이블 삭제 복구를 위한 Amazon DynamoDB 시점 복구(PITR)','An application uses Amazon DynamoDB and must be able to recover from accidental table deletion. Which feature should be enabled?','[{"key": "A", "text": "DynamoDB Streams"}, {"key": "B", "text": "Point-in-time recovery (PITR)"}, {"key": "C", "text": "DynamoDB Accelerator (DAX)"}, {"key": "D", "text": "Global tables"}]',1,'[1]','B','B — B) Point-in-time recovery (PITR)','["Amazon DynamoDB", "PITR (Point-in-Time Recovery)", "Backup & Restore", "Data Protection", "Continuous Backups"]','Amazon DynamoDB, PITR (Point-in-Time Recovery), Backup & Restore, Data Protection, Continuous Backups','Point-in-time recovery allows continuous backups of DynamoDB tables and restoration to any point in the last 35 days. Streams captures table changes. DAX is an in-memory cache. Global tables provide multi-region replication.

[핵심 아키텍처 포인트] DynamoDB PITR을 활성화하면 최근 35일 이내의 임의 초 단위 시점으로 새 테이블에 연속 백업 복구가 가능해 실수 삭제에 대비할 수 있습니다.');
INSERT INTO "questions" VALUES(21,2,11,3,1,'SINGLE','CloudCertPrep (MIT)','saa-d3-001','en','전 세계 사용자 대상 정적 콘텐츠 초저지연 전송 (Amazon CloudFront)','A company needs to serve static content to users worldwide with low latency. Which AWS service should they use?','[{"key": "A", "text": "Amazon EC2"}, {"key": "B", "text": "Amazon CloudFront"}, {"key": "C", "text": "AWS Global Accelerator"}, {"key": "D", "text": "Amazon Route 53"}]',1,'[1]','B','B — B) Amazon CloudFront','["Amazon CloudFront", "CDN", "Edge Locations", "Static Content", "Low Latency"]','Amazon CloudFront, CDN, Edge Locations, Static Content, Low Latency','CloudFront is a CDN that caches content at edge locations worldwide for low-latency delivery. Global Accelerator improves availability and performance for dynamic content. Route 53 is a DNS service. EC2 is a compute service.

[핵심 아키텍처 포인트] 전 세계 엣지 로케이션에 정적 콘텐츠를 캐싱하여 지연을 최소화하려면 Amazon CloudFront CDN을 배치해야 합니다.');
INSERT INTO "questions" VALUES(22,2,12,3,1,'SINGLE','CloudCertPrep (MIT)','saa-d3-002','en','서버·클러스터 관리 없는 서버리스 컨테이너 실행 (AWS Fargate)','Which service should be used to run containers without managing servers or clusters?','[{"key": "A", "text": "Amazon EC2"}, {"key": "B", "text": "Amazon ECS on EC2"}, {"key": "C", "text": "AWS Fargate"}, {"key": "D", "text": "AWS Elastic Beanstalk"}]',2,'[2]','C','C — C) AWS Fargate','["AWS Fargate", "Amazon ECS", "Serverless Containers", "Compute", "Elasticity"]','AWS Fargate, Amazon ECS, Serverless Containers, Compute, Elasticity','AWS Fargate is a serverless compute engine for containers that removes the need to manage servers. ECS on EC2 requires managing EC2 instances. Elastic Beanstalk is a PaaS for web applications.

[핵심 아키텍처 포인트] EC2 인스턴스나 클러스터를 직접 프로비저닝·관리하지 않고 컨테이너를 실행하려면 서버리스 컴퓨팅 엔진인 AWS Fargate를 사용합니다.');
INSERT INTO "questions" VALUES(23,2,13,3,1,'SINGLE','CloudCertPrep (MIT)','saa-d3-003','en','Amazon DynamoDB 마이크로초 단위 읽기 캐싱 가속기 (DAX)','An application requires sub-millisecond read latency for a DynamoDB table. Which feature should a solutions architect recommend?','[{"key": "A", "text": "DynamoDB Streams"}, {"key": "B", "text": "DynamoDB global tables"}, {"key": "C", "text": "DynamoDB Accelerator (DAX)"}, {"key": "D", "text": "DynamoDB on-demand capacity"}]',2,'[2]','C','C — C) DynamoDB Accelerator (DAX)','["Amazon DynamoDB", "DynamoDB Accelerator (DAX)", "In-Memory Cache", "Microsecond Latency", "Read Performance"]','Amazon DynamoDB, DynamoDB Accelerator (DAX), In-Memory Cache, Microsecond Latency, Read Performance','DAX is an in-memory cache for DynamoDB that provides microsecond read latency. Streams captures changes. Global tables provide multi-region replication. On-demand capacity auto-scales throughput.

[핵심 아키텍처 포인트] DynamoDB 읽기 지연을 밀리초에서 마이크로초(서브밀리초) 단위로 낮추려면 API 호환 인메모리 캐시인 DAX를 앞에 배치합니다.');
INSERT INTO "questions" VALUES(24,2,14,3,1,'SINGLE','CloudCertPrep (MIT)','saa-d3-004','en','IoT 센서 실시간 스트리밍 데이터 수집·처리 (Amazon Kinesis Data Streams)','A company needs to process real-time streaming data from IoT sensors. Which service should they use?','[{"key": "A", "text": "Amazon SQS"}, {"key": "B", "text": "Amazon Kinesis Data Streams"}, {"key": "C", "text": "Amazon SNS"}, {"key": "D", "text": "Amazon MQ"}]',1,'[1]','B','B — B) Amazon Kinesis Data Streams','["Amazon Kinesis Data Streams", "Real-Time Streaming", "IoT", "Data Ingestion", "Analytics"]','Amazon Kinesis Data Streams, Real-Time Streaming, IoT, Data Ingestion, Analytics','Kinesis Data Streams is designed for real-time streaming data ingestion and processing. SQS is for message queuing. SNS is for pub/sub notifications. Amazon MQ is a managed message broker.

[핵심 아키텍처 포인트] 대규모 IoT 센서의 실시간 스트리밍 데이터를 순서대로 수집하고 즉각 분석·처리하는 데는 Kinesis Data Streams가 적합합니다.');
INSERT INTO "questions" VALUES(25,2,15,3,1,'SINGLE','CloudCertPrep (MIT)','saa-d3-005','en','다중 AZ EC2 인스턴스 동시 마운트 관리형 공유 파일 스토리지 (Amazon EFS)','Which AWS service provides a fully managed, highly available, and scalable file storage for use with EC2 instances across multiple Availability Zones?','[{"key": "A", "text": "Amazon EBS"}, {"key": "B", "text": "Amazon EFS"}, {"key": "C", "text": "Amazon S3"}, {"key": "D", "text": "AWS Storage Gateway"}]',1,'[1]','B','B — B) Amazon EFS','["Amazon EFS", "Shared File Storage", "NFS", "Multi-AZ", "Amazon EC2"]','Amazon EFS, Shared File Storage, NFS, Multi-AZ, Amazon EC2','Amazon EFS provides scalable, elastic file storage accessible from multiple EC2 instances across AZs. EBS is block storage attached to a single instance. S3 is object storage. Storage Gateway connects on-premises to AWS storage.

[핵심 아키텍처 포인트] 여러 AZ의 수많은 Linux EC2 인스턴스가 동시에 마운트해 탄력적으로 확장하는 완전 관리형 공유 파일 시스템은 Amazon EFS입니다(EBS는 단일 AZ).');
INSERT INTO "questions" VALUES(26,2,16,4,1,'SINGLE','CloudCertPrep (MIT)','saa-d4-001','en','중단 허용 워크로드의 EC2 컴퓨팅 비용 최대 90% 절감 (Spot Instances)','A company wants to reduce EC2 costs for workloads that can tolerate interruptions. Which purchasing option should they use?','[{"key": "A", "text": "On-Demand Instances"}, {"key": "B", "text": "Reserved Instances"}, {"key": "C", "text": "Spot Instances"}, {"key": "D", "text": "Dedicated Hosts"}]',2,'[2]','C','C — C) Spot Instances','["Amazon EC2", "Spot Instances", "Cost Optimization", "Fault-Tolerant Workloads", "EC2 Pricing"]','Amazon EC2, Spot Instances, Cost Optimization, Fault-Tolerant Workloads, EC2 Pricing','Spot Instances offer up to 90% discount but can be interrupted. On-Demand has no discount. Reserved Instances require commitment. Dedicated Hosts provide physical server isolation.

[핵심 아키텍처 포인트] 작업 중단 및 재시작을 허용할 수 있는 배치·분석 워크로드는 유휴 EC2 용량을 최대 90% 할인 가격으로 쓰는 Spot Instances가 가장 경제적입니다.');
INSERT INTO "questions" VALUES(27,2,17,4,1,'SINGLE','CloudCertPrep (MIT)','saa-d4-002','en','유휴 리소스 식별 및 비용 최적화 권장 사항 제공 (AWS Trusted Advisor)','Which AWS service helps identify underutilized resources and provides cost optimization recommendations?','[{"key": "A", "text": "AWS Budgets"}, {"key": "B", "text": "AWS Trusted Advisor"}, {"key": "C", "text": "AWS Cost Explorer"}, {"key": "D", "text": "AWS Pricing Calculator"}]',1,'[1]','B','B — B) AWS Trusted Advisor','["AWS Trusted Advisor", "Cost Optimization", "Underutilized Resources", "Cloud Governance", "Recommendations"]','AWS Trusted Advisor, Cost Optimization, Underutilized Resources, Cloud Governance, Recommendations','Trusted Advisor inspects your AWS environment and provides recommendations for cost optimization, security, performance, and fault tolerance. Cost Explorer visualizes costs. Budgets sets alerts. Pricing Calculator estimates costs.

[핵심 아키텍처 포인트] AWS 계정의 저사용 인스턴스·유휴 볼륨·보안·성능 항목을 자동 점검해 실행 가능한 절감 권고를 제시하는 서비스는 AWS Trusted Advisor입니다.');
INSERT INTO "questions" VALUES(28,2,18,4,1,'SINGLE','CloudCertPrep (MIT)','saa-d4-003','en','업무 시간 외 개발 환경 EC2 비용 절감 전략 (On-Demand 중지 스케줄링)','A company runs a development environment that is only used during business hours. Which approach minimizes costs?','[{"key": "A", "text": "Use Reserved Instances"}, {"key": "B", "text": "Use On-Demand Instances and stop them after hours"}, {"key": "C", "text": "Use Spot Instances"}, {"key": "D", "text": "Use Dedicated Hosts"}]',1,'[1]','B','B — B) Use On-Demand Instances and stop them after hours','["Amazon EC2", "On-Demand Instances", "Non-Production Scheduling", "Cost Optimization", "Compute Savings"]','Amazon EC2, On-Demand Instances, Non-Production Scheduling, Cost Optimization, Compute Savings','Stopping On-Demand instances when not in use eliminates compute charges (only storage costs remain). Reserved Instances are for steady-state workloads. Spot Instances can be interrupted. Dedicated Hosts are expensive.

[핵심 아키텍처 포인트] 업무 시간에만 쓰는 개발 환경은 약정이 불필요하며 미사용 시간대에 On-Demand 인스턴스를 Stop해 컴퓨팅 과금을 제거하는 것이 가장 효율적입니다.');
INSERT INTO "questions" VALUES(29,2,19,4,1,'SINGLE','CloudCertPrep (MIT)','saa-d4-004','en','접근 패턴 기반 S3 스토리지 클래스 자동 계층 이동 (S3 Lifecycle 정책)','Which S3 feature can automatically move objects to cheaper storage classes based on access patterns?','[{"key": "A", "text": "S3 Versioning"}, {"key": "B", "text": "S3 Lifecycle policies"}, {"key": "C", "text": "S3 Replication"}, {"key": "D", "text": "S3 Object Lock"}]',1,'[1]','B','B — B) S3 Lifecycle policies','["Amazon S3", "S3 Lifecycle Policies", "Storage Tiering", "Cost Optimization", "Automation"]','Amazon S3, S3 Lifecycle Policies, Storage Tiering, Cost Optimization, Automation','S3 Lifecycle policies automatically transition objects between storage classes or expire them based on rules. Versioning preserves object versions. Replication copies objects across buckets. Object Lock prevents deletion.

[핵심 아키텍처 포인트] 객체 생성 경과일 규칙에 따라 Standard → IA → Glacier로 자동 전환하거나 만료 삭제하려면 S3 Lifecycle 정책을 구성합니다.');
INSERT INTO "questions" VALUES(30,2,20,4,1,'SINGLE','CloudCertPrep (MIT)','saa-d4-005','en','Amazon RDS vs Amazon DynamoDB 선택 기준 (일관된 한 자릿수 ms 지연)','A solutions architect needs to choose between Amazon RDS and Amazon DynamoDB. Which factor most favours DynamoDB?','[{"key": "A", "text": "Complex SQL queries with joins"}, {"key": "B", "text": "Consistent single-digit millisecond latency at any scale"}, {"key": "C", "text": "ACID transactions across multiple tables"}, {"key": "D", "text": "Schema enforcement and referential integrity"}]',1,'[1]','B','B — B) Consistent single-digit millisecond latency at any scale','["Amazon DynamoDB", "Amazon RDS", "NoSQL vs Relational", "Single-Digit Millisecond", "Database Selection"]','Amazon DynamoDB, Amazon RDS, NoSQL vs Relational, Single-Digit Millisecond, Database Selection','DynamoDB provides consistent single-digit millisecond performance at any scale. RDS is better for complex SQL queries, multi-table ACID transactions, and schema enforcement.

[핵심 아키텍처 포인트] 복잡한 SQL JOIN·다중 테이블 ACID는 RDS가 유리하며, 규모와 무관하게 일관된 한 자릿수 밀리초 응답 성능과 수평 확장이 핵심이면 DynamoDB가 적합합니다.');
INSERT INTO "questions" VALUES(31,3,1,1,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-128','ko','CloudFront 우회 ALB 직접 접근 차단을 위한 다계층 방어','회사의 인터넷 경계 ALB는 퍼블릭 서브넷에 유지되며 앞에 CloudFront가 있습니다. 사용자가 CloudFront를 우회해 ALB로 직접 접근하지 못하게 하는 계층 방어를 구성하려 합니다. WAF와 보안 그룹 규칙은 직접 IP 목록을 관리하지 않고 AWS가 갱신하는 항목을 사용하려 합니다. 두 가지를 선택하십시오. (2개 선택)','[{"key": "A", "text": "ALB 보안 그룹의 인바운드를 CloudFront 오리진 대상 AWS 관리형 접두사 목록으로만 허용한다"}, {"key": "B", "text": "ALB 보안 그룹에서 0.0.0.0/0의 443을 허용하고 NACL로 CloudFront 도메인 이름만 허용한다"}, {"key": "C", "text": "AWS Shield Standard가 CloudFront를 거치지 않은 직접 접근을 자동으로 차단하도록 의존한다"}, {"key": "D", "text": "CloudFront가 오리진 요청에 비밀 사용자 지정 헤더를 추가하게 하고 ALB 앞 WAF에서 헤더가 없는 요청을 차단한다"}, {"key": "E", "text": "CloudFront 서명된 URL을 필수로 설정하면 ALB에 대한 직접 접근도 함께 차단된다"}]',NULL,'[0, 3]','A, D','A, D — A) ALB 보안 그룹의 인바운드를 CloudFront 오리진 대상 AWS 관리형 접두사 목록으로만 허용한다 / D) CloudFront가 오리진 요청에 비밀 사용자 지정 헤더를 추가하게 하고 ALB 앞 WAF에서 헤더가 없는 요청을 차단한다','["Amazon CloudFront", "Application Load Balancer (ALB)", "AWS WAF", "Managed Prefix List", "Custom Origin Header"]','Amazon CloudFront, Application Load Balancer (ALB), AWS WAF, Managed Prefix List, Custom Origin Header','정답(A, D): 접두사 목록은 네트워크 계층에서 CloudFront 외 IP를 막고, 비밀 헤더 검증은 내 배포에서 온 요청인지 애플리케이션 계층에서 확인합니다. B는 NACL이 도메인을 이해하지 못하고, C는 Shield Standard가 접근 경로를 제한하지 않으며, E는 서명된 URL이 ALB 직접 접근을 막지 못합니다.
참고: How do I configure AWS WAF IP set rules for an Application Load Balancer origin behind CloudFront? - AWS re:Post Knowledge Center

[핵심 아키텍처 포인트] CloudFront 관리형 접두사 목록으로 ALB 보안 그룹의 L4 접근을 제한하고, WAF에서 비밀 커스텀 헤더를 검증해 내 배포 외 경로의 우회 요청을 차단합니다.');
INSERT INTO "questions" VALUES(32,3,2,1,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-164','ko','ECS Fargate Secrets Manager 민감 정보 안전 주입 구성','ECS Fargate 작업이 시작될 때 Secrets Manager에 저장된 DB 비밀번호를 환경 변수로 받아야 합니다. 비밀번호가 작업 정의 JSON이나 컨테이너 이미지에 평문으로 포함되어서는 안 됩니다. 컨테이너 이미지는 여러 환경에서 재사용되므로 이미지에 비밀이 포함되면 안 되고 작업 정의도 버전 관리에 저장됩니다. 필요한 두 가지 구성을 선택하십시오. (2개 선택)','[{"key": "A", "text": "작업 역할(task role)에만 권한을 부여하고 작업 실행 역할에는 권한을 주지 않는다"}, {"key": "B", "text": "작업 정의의 environment 필드에 비밀 ARN을 값으로 넣어 ECS가 자동으로 치환하게 한다"}, {"key": "C", "text": "작업 정의의 컨테이너 secrets 필드에 환경 변수 이름과 비밀 ARN을 지정한다"}, {"key": "D", "text": "작업 실행 역할에 secretsmanager:GetSecretValue(고객 관리형 키 사용 시 kms:Decrypt) 권한을 부여한다"}, {"key": "E", "text": "Dockerfile의 ENV에 비밀번호를 넣고 이미지를 프라이빗 ECR 저장소에 보관한다"}]',NULL,'[2, 3]','C, D','C, D — C) 작업 정의의 컨테이너 secrets 필드에 환경 변수 이름과 비밀 ARN을 지정한다 / D) 작업 실행 역할에 secretsmanager:GetSecretValue(고객 관리형 키 사용 시 kms:Decrypt) 권한을 부여한다','["Amazon ECS", "AWS Fargate", "AWS Secrets Manager", "Task Execution Role", "Container Security"]','Amazon ECS, AWS Fargate, AWS Secrets Manager, Task Execution Role, Container Security','정답(C, D): 시작 시 비밀을 주입하는 주체는 ECS 에이전트라서 작업 실행 역할에 권한이 필요하고, secrets 필드가 ARN을 참조합니다. A는 주입 시점에 실행 역할이 사용되므로 실패하고, B는 environment가 ARN을 문자열 그대로 전달하며, E는 평문이 이미지에 남습니다.
참고: Pass Secrets Manager secrets through Amazon ECS environment variables - Amazon ECS Developer Guide

[핵심 아키텍처 포인트] 컨테이너 시작 시 Secrets Manager 값을 주입하려면 작업 정의의 secrets 필드에 ARN을 지정하고, ECS 에이전트가 사용하는 Task Execution Role에 GetSecretValue 권한을 부여해야 합니다.');
INSERT INTO "questions" VALUES(33,3,3,1,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-167','ko','CloudTrail 기반 IAM 역할 최소 권한 점진적 축소 전략','계약업체용 IAM 역할에 PowerUserAccess가 부여되어 있습니다. 보안 팀은 실제로 사용하는 권한만 남기도록 최소 권한으로 줄이려 합니다. 역할은 6개월 전에 만들어졌고 CloudTrail 활동 기록이 충분히 쌓여 있으며 추가 도구 구매는 원하지 않습니다. 업무 중단 없이 권한을 점진적으로 줄여야 합니다. 이를 위한 두 가지 조치를 선택하십시오. (2개 선택)','[{"key": "A", "text": "역할을 AdministratorAccess로 바꾸고 SCP로 위험한 작업만 거부한다"}, {"key": "B", "text": "권한 경계에 PowerUserAccess를 설정하여 권한이 자동으로 줄어들게 한다"}, {"key": "C", "text": "Trusted Advisor의 비용 최적화 점검 결과에 따라 사용하지 않는 권한이 자동 제거되게 한다"}, {"key": "D", "text": "IAM Access Analyzer 미사용 액세스 결과를 확인해 쓰이지 않은 서비스와 작업 권한을 제거한다"}, {"key": "E", "text": "IAM 최종 액세스 정보를 검토해 역할이 사용하지 않은 서비스의 권한을 정책에서 삭제한다"}]',NULL,'[3, 4]','D, E','D, E — D) IAM Access Analyzer 미사용 액세스 결과를 확인해 쓰이지 않은 서비스와 작업 권한을 제거한다 / E) IAM 최종 액세스 정보를 검토해 역할이 사용하지 않은 서비스의 권한을 정책에서 삭제한다','["AWS IAM", "IAM Access Analyzer", "Last Accessed Info", "Least Privilege", "AWS CloudTrail"]','AWS IAM, IAM Access Analyzer, Last Accessed Info, Least Privilege, AWS CloudTrail','정답(D, E): 미사용 액세스 결과와 최종 액세스 정보는 실제 사용 이력으로 불필요한 권한을 식별하게 해 줍니다. A는 권한을 오히려 확대하고, B는 경계가 권한을 부여하지도 줄이지도 않으며 동일 범위이고, C는 IAM 권한을 정리하는 기능이 없습니다.
참고: IAM Access Analyzer findings - AWS Identity and Access Management User Guide

[핵심 아키텍처 포인트] 운영 중단 없이 과도한 권한을 줄이려면 IAM Access Analyzer 미사용 액세스 결과와 최종 액세스 정보를 교차 검증해 실제 미사용 서비스 권한부터 안전하게 제거합니다.');
INSERT INTO "questions" VALUES(34,3,4,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-142','ko','다중 계정 환경 외부 IdP(Okta) SAML·SCIM 통합 SSO 구성','회사는 AWS Organizations의 60개 계정에 대해 외부 IdP(Okta)의 그룹 기준으로 콘솔과 CLI 접근을 부여하려 합니다. 장기 액세스 키는 쓰지 않고, 입퇴사 시 IdP의 사용자 변경이 자동 반영되어야 하며, 계정마다 IAM 사용자를 관리하는 방식은 피해야 합니다. IdP의 그룹 구조는 이미 정리되어 있고 보안 팀은 최소 인력으로 운영합니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "계정마다 IAM SAML 공급자와 역할을 만들고 Okta 애플리케이션을 계정 수만큼 구성한다"}, {"key": "B", "text": "Okta 그룹마다 계정별 IAM 사용자를 만들고 액세스 키를 90일마다 교체하는 자동화를 작성한다"}, {"key": "C", "text": "Cognito 자격 증명 풀에 Okta를 OIDC 공급자로 연결하고 인증된 역할을 매핑해 직원이 AWS 콘솔과 CLI에 로그인하게 한다"}, {"key": "D", "text": "IAM Identity Center에 Okta를 외부 IdP로 연결(SAML·SCIM)하고 그룹에 권한 세트를 계정별로 할당한다"}]',3,'[3]','D','D — D) IAM Identity Center에 Okta를 외부 IdP로 연결(SAML·SCIM)하고 그룹에 권한 세트를 계정별로 할당한다','["IAM Identity Center", "SAML 2.0", "SCIM", "AWS Organizations", "Identity Federation"]','IAM Identity Center, SAML 2.0, SCIM, AWS Organizations, Identity Federation','정답(D): Identity Center는 외부 IdP와 SAML·SCIM으로 연동해 사용자·그룹을 자동 동기화하고 권한 세트로 다수 계정에 접근을 부여합니다. A는 계정별 설정과 사용자 동기화가 수동이고, B는 장기 키를 사용하며, C는 직원용 콘솔 SSO를 위한 서비스가 아닙니다.
참고: Configure SAML and SCIM with Microsoft Entra ID and IAM Identity Center - AWS IAM Identity Center User Guide

[핵심 아키텍처 포인트] 수십 개 계정의 직원 콘솔·CLI SSO와 입퇴사 자동 동기화는 IAM Identity Center에 외부 IdP를 SAML·SCIM으로 연동해 장기 키 없이 관리하는 것이 표준입니다.');
INSERT INTO "questions" VALUES(35,3,5,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-174','ko','API Gateway REST API용 Cognito 사용자 풀 토큰 무코드 인증','회사는 API Gateway REST API 뒤에 Lambda 백엔드를 운영하며 Cognito 사용자 풀에 이미 사용자가 있습니다. 유효한 사용자 풀 토큰이 있는 요청만 허용하되, 토큰 검증 코드를 직접 작성하거나 서명 키를 관리하는 일은 피하고 운영 노력을 최소화하고 싶습니다. 백엔드 팀은 인증 로직을 새로 작성할 여력이 없고 보안 심사를 빠르게 통과해야 합니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "Lambda 권한 부여자를 만들고 JWT 서명을 직접 검증하도록 코드를 구현한다"}, {"key": "B", "text": "API Gateway 사용 계획과 API 키를 발급해 앱이 x-api-key 헤더를 보내게 한다"}, {"key": "C", "text": "API Gateway에 Cognito 사용자 풀 권한 부여자를 만들어 각 메서드에 연결한다"}, {"key": "D", "text": "메서드 인증을 AWS_IAM으로 설정하고 앱이 사용자 풀 토큰으로 SigV4 서명을 생성하게 한다"}]',2,'[2]','C','C — C) API Gateway에 Cognito 사용자 풀 권한 부여자를 만들어 각 메서드에 연결한다','["Amazon API Gateway", "Amazon Cognito", "User Pool Authorizer", "JWT", "REST API Security"]','Amazon API Gateway, Amazon Cognito, User Pool Authorizer, JWT, REST API Security','정답(C): Cognito 사용자 풀 권한 부여자는 API Gateway가 토큰 검증을 대신하므로 코드와 키 관리가 필요 없습니다. A는 검증 코드를 직접 작성·운영해야 하고, B는 API 키가 사용량 제어용이며 인증 수단이 아니고, D는 AWS 자격 증명이 따로 필요합니다.
참고: Control access to a REST API with Amazon Cognito user pools as authorizer - Amazon API Gateway Developer Guide

[핵심 아키텍처 포인트] Cognito 사용자 풀 권한 부여자를 메서드에 연결하면 API Gateway가 JWT 서명 검증을 대신 처리하므로 별도 검증 코드나 키 관리가 필요 없습니다.');
INSERT INTO "questions" VALUES(36,3,6,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-143','ko','PCI DSS 컴플라이언스 감사 증거 자동 수집 (AWS Audit Manager)','핀테크 회사는 PCI DSS 감사를 위해 AWS 계정에서 통제 증거(구성 스냅샷, CloudTrail 활동, Config 준수 결과)를 지속적으로 수집해 감사 보고서를 만들어야 합니다. 감사인이 요청할 때마다 스크린샷을 모으는 수작업을 없애려 합니다. 감사는 분기마다 반복되며 여러 계정의 증거를 한 곳에서 모아 제출해야 합니다. 어떤 서비스를 사용해야 합니까?','[{"key": "A", "text": "AWS Artifact에서 AWS의 PCI DSS 준수 보고서를 내려받아 감사인에게 제출한다"}, {"key": "B", "text": "Audit Manager의 PCI DSS 프레임워크 평가로 증거를 자동 수집하고 보고서를 생성한다"}, {"key": "C", "text": "AWS Security Hub의 PCI DSS 표준을 활성화하고 준수 점수 화면을 캡처해 제출한다"}, {"key": "D", "text": "AWS Config 규칙 평가 결과를 S3로 내보내 스프레드시트로 정리해 증거로 제출한다"}]',1,'[1]','B','B — B) Audit Manager의 PCI DSS 프레임워크 평가로 증거를 자동 수집하고 보고서를 생성한다','["AWS Audit Manager", "PCI DSS", "AWS Config", "AWS CloudTrail", "Compliance Automation"]','AWS Audit Manager, PCI DSS, AWS Config, AWS CloudTrail, Compliance Automation','정답(B): Audit Manager는 프레임워크 통제에 맞춰 CloudTrail, Config, Security Hub 등에서 증거를 자동 수집하고 감사 보고서를 만듭니다. A는 AWS 자체의 준수 문서이지 고객 환경의 증거가 아니고, C는 점검 결과일 뿐 증거 수집·보고 체계가 없으며, D는 수작업 정리입니다.
참고: Understanding AWS Audit Manager concepts and terminology - AWS Audit Manager User Guide

[핵심 아키텍처 포인트] CloudTrail·Config·Security Hub 등의 통제 증거를 규제 프레임워크별로 지속 수집해 감사 보고서로 생성하려면 AWS Audit Manager를 사용합니다.');
INSERT INTO "questions" VALUES(37,3,7,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-161','ko','교차 리전·교차 계정 SSE-KMS S3 객체 복제(CRR) 구성','서울 Region 버킷의 SSE-KMS 객체를 다른 계정의 도쿄 Region 버킷으로 복제해야 합니다. 복제 규칙은 만들었지만 SSE-KMS 객체가 복제되지 않습니다. 대상 버킷은 다른 계정의 도쿄 Region에 있으며 보안 팀은 암호화 키를 대상 Region에서 별도로 관리합니다. 원본 객체는 수십만 개이며 모두 같은 KMS 키로 암호화되어 있습니다. 필요한 조치는 무엇입니까?','[{"key": "A", "text": "복제 규칙의 접두사 필터를 제거해 모든 객체를 복제 대상으로 만들고 복제 시간 제어(RTC)를 활성화해 지연을 줄인다"}, {"key": "B", "text": "원본 객체를 SSE-S3로 다시 암호화해야만 교차 계정 복제가 가능하다"}, {"key": "C", "text": "버킷 키를 활성화하면 복제 역할에 KMS 권한을 주지 않아도 복제된다"}, {"key": "D", "text": "규칙에서 SSE-KMS 객체 복제를 활성화하고 도쿄 Region의 KMS 키를 지정하며 복제 역할에 키 권한을 부여한다"}]',3,'[3]','D','D — D) 규칙에서 SSE-KMS 객체 복제를 활성화하고 도쿄 Region의 KMS 키를 지정하며 복제 역할에 키 권한을 부여한다','["Amazon S3", "Cross-Region Replication (CRR)", "SSE-KMS", "Cross-Account Access", "AWS KMS"]','Amazon S3, Cross-Region Replication (CRR), SSE-KMS, Cross-Account Access, AWS KMS','정답(D): SSE-KMS 객체는 복제 규칙에서 명시적으로 포함해야 하고, 대상 Region의 키를 지정하며 복제 역할에 복호화·암호화 권한이 있어야 합니다. A는 필터와 무관하게 KMS 객체가 건너뛰어지고, B는 SSE-KMS 복제가 지원되므로 불필요하며, C는 키 권한을 대체하지 않습니다.
참고: Replicating encrypted objects (SSE-S3, SSE-KMS, DSSE-KMS, SSE-C) - Amazon S3 User Guide

[핵심 아키텍처 포인트] SSE-KMS 암호화 객체는 S3 복제 규칙에서 KMS 복제 옵션을 명시적으로 활성화하고 대상 리전 KMS 키 지정 및 복제 IAM 역할의 복호화·암호화 권한이 필요합니다.');
INSERT INTO "questions" VALUES(38,3,8,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-132','ko','글로벌 서비스 예외를 포함한 리전 제한 SCP 데이터 거주성 통제','한 회사는 데이터 거주성 규정에 따라 서울(ap-northeast-2)과 도쿄(ap-northeast-1) 외 Region에서는 리소스를 만들 수 없게 해야 합니다. 멤버 계정 관리자도 우회할 수 없어야 하고, IAM, CloudFront, Route 53 같은 글로벌 서비스는 계속 사용 가능해야 합니다. 감사 때 어떤 계정에서도 우회 사례가 없음을 보여 줄 수 있어야 합니다. 어떤 접근이 가장 적합합니까?','[{"key": "A", "text": "SCP에서 aws:RequestedRegion이 승인 Region이 아닌 요청을 거부하되 NotAction으로 글로벌 서비스를 예외 처리한다"}, {"key": "B", "text": "모든 계정에 IAM 정책을 배포해 승인되지 않은 Region의 작업을 거부하고 변경 시 Config로 감지한다"}, {"key": "C", "text": "SCP에서 승인 Region 밖의 모든 작업을 예외 없이 거부하고 IAM, CloudFront, Route 53 같은 글로벌 서비스도 같은 규칙으로 처리한다"}, {"key": "D", "text": "Config 규칙으로 허용 Region 밖에 생성된 리소스를 탐지하고 Systems Manager Automation으로 자동 삭제한다"}]',0,'[0]','A','A — A) SCP에서 aws:RequestedRegion이 승인 Region이 아닌 요청을 거부하되 NotAction으로 글로벌 서비스를 예외 처리한다','["AWS Organizations", "Service Control Policy (SCP)", "aws:RequestedRegion", "NotAction", "Data Residency"]','AWS Organizations, Service Control Policy (SCP), aws:RequestedRegion, NotAction, Data Residency','정답(A): SCP는 멤버 계정 관리자도 우회할 수 없는 상한이며, 글로벌 서비스는 us-east-1 등 엔드포인트를 쓰므로 NotAction으로 예외를 두어야 정상 동작합니다. B는 관리자가 정책을 바꿀 수 있고, C는 글로벌 서비스까지 막으며, D는 생성 후 삭제하는 사후 대응입니다.
참고: Deny access to AWS based on the requested AWS Region - AWS Control Tower

[핵심 아키텍처 포인트] aws:RequestedRegion 조건으로 승인 리전 외 작업을 거부할 때는 IAM·CloudFront·Route 53 등 us-east-1 기반 글로벌 서비스를 NotAction으로 예외 처리해야 장애를 방지합니다.');
INSERT INTO "questions" VALUES(39,3,9,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-152','ko','S3 업로드 파일 서버리스 자동 악성코드 스캔 (GuardDuty Malware Protection)','사용자가 파일을 업로드하는 S3 버킷에서 악성코드가 포함된 파일이 후속 처리 파이프라인으로 넘어가기 전에 탐지되어야 합니다. 스캔 서버를 직접 운영하고 싶지 않으며 새로 업로드되는 객체가 자동으로 검사되어야 합니다. 업로드 파일은 하루 수만 개이며 개별 파일 크기는 수 GB까지 다양합니다. 개발 팀은 스캔 코드를 직접 작성하지 않으려 합니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "Amazon Macie 민감 데이터 검색 작업을 매일 실행하여 악성 파일을 식별한다"}, {"key": "B", "text": "Amazon Inspector가 S3 버킷의 객체를 지속적으로 스캔하도록 활성화한다"}, {"key": "C", "text": "EC2 Auto Scaling 그룹에 ClamAV를 설치하고 S3 이벤트를 SQS 큐에 넣어 스캔 작업자가 객체를 검사하고 결과를 태그로 기록하게 한다"}, {"key": "D", "text": "버킷에 GuardDuty Malware Protection for S3를 활성화하고 검사 결과 태그나 EventBridge로 후속 처리를 제어한다"}]',3,'[3]','D','D — D) 버킷에 GuardDuty Malware Protection for S3를 활성화하고 검사 결과 태그나 EventBridge로 후속 처리를 제어한다','["Amazon GuardDuty", "Malware Protection for S3", "Amazon S3", "Amazon EventBridge", "Serverless Security"]','Amazon GuardDuty, Malware Protection for S3, Amazon S3, Amazon EventBridge, Serverless Security','정답(D): GuardDuty Malware Protection for S3는 새로 업로드된 객체를 자동 스캔하고 결과를 태그와 EventBridge로 알려 줍니다. A는 PII 같은 민감 데이터를 찾는 서비스이고, B는 EC2·ECR·Lambda 취약점을 스캔하며 S3 객체 악성코드를 검사하지 않고, C는 서버 운영 부담이 생깁니다.
참고: GuardDuty Malware Protection for S3 - Amazon GuardDuty User Guide

[핵심 아키텍처 포인트] 별도 스캔 서버나 코드 없이 S3 신규 업로드 객체의 악성코드를 검사하고 후속 워크플로를 분기하려면 GuardDuty Malware Protection for S3를 활성화합니다.');
INSERT INTO "questions" VALUES(40,3,10,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-154','ko','SSM Agent 미설치 레거시 포함 EC2 CVE 지속 스캔 (Inspector 하이브리드)','한 회사는 EC2 인스턴스 수백 대의 소프트웨어 취약점(CVE)을 지속적으로 점검하고 결과를 심각도별로 중앙에서 확인해야 합니다. 일부 레거시 인스턴스는 보안 정책상 SSM Agent를 설치할 수 없으며, 새 CVE가 공개되면 수동 스캔 없이 자동으로 재평가되어야 합니다. 점검 대상에는 방화벽 정책 때문에 외부 패키지 저장소에 접근할 수 없는 인스턴스도 포함되어 있습니다. 운영 오버헤드를 최소화하는 방법은 무엇입니까?','[{"key": "A", "text": "Amazon Inspector EC2 스캔을 하이브리드 모드로 켜서 SSM Agent 기반 스캔과 EBS 스냅샷 기반 에이전트리스 스캔을 함께 쓴다"}, {"key": "B", "text": "Systems Manager Patch Manager의 스캔 작업을 매일 예약하고 비준수 인스턴스 보고서를 확인한다"}, {"key": "C", "text": "Amazon GuardDuty Malware Protection for EC2를 활성화해 인스턴스의 취약한 패키지를 탐지하고 결과를 Security Hub로 전송해 심각도별로 확인한다"}, {"key": "D", "text": "AWS Config 관리형 규칙으로 인스턴스의 패키지 버전을 평가하고 비준수 리소스를 집계해 확인한다"}]',0,'[0]','A','A — A) Amazon Inspector EC2 스캔을 하이브리드 모드로 켜서 SSM Agent 기반 스캔과 EBS 스냅샷 기반 에이전트리스 스캔을 함께 쓴다','["Amazon Inspector", "Vulnerability Management", "CVE", "Agentless Scanning", "AWS Systems Manager"]','Amazon Inspector, Vulnerability Management, CVE, Agentless Scanning, AWS Systems Manager','정답(A): Inspector는 연속 스캔과 새 CVE 발표 시 자동 재평가를 제공하며, 에이전트 설치가 불가능한 인스턴스는 EBS 스냅샷 기반 에이전트리스 스캔으로 커버합니다. B는 SSM Agent가 필요하고, C는 악성코드 탐지 기능이라 CVE를 평가하지 않으며, D는 패키지 취약점을 검사하지 못합니다.
참고: Automated resource scanning with Amazon Inspector

[핵심 아키텍처 포인트] Inspector 하이브리드 모드는 SSM Agent 기반 실시간 검사와 EBS 스냅샷 기반 에이전트리스 스캔을 결합해 레거시 서버까지 새 CVE를 자동 재평가합니다.');
INSERT INTO "questions" VALUES(41,3,11,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-158','ko','SSE-KMS 암호화 S3 버킷 교차 계정 읽기 권한 삼중 허용','계정 A의 S3 버킷은 고객 관리형 KMS 키로 SSE-KMS 암호화되어 있습니다. 계정 B의 분석 역할이 이 버킷의 객체를 읽어야 합니다. 분석 역할은 읽기만 수행하며, 계정 A의 보안 팀은 키 정책의 허용 범위를 최소로 유지하려 하고 키를 AWS 관리형 키로 되돌리는 것은 허용하지 않습니다. 교차 계정 접근을 위해 필요한 구성은 무엇입니까?','[{"key": "A", "text": "계정 A의 버킷 정책에서 B의 역할에 s3:GetObject만 허용하면 KMS 복호화는 S3 서비스가 대신 처리하므로 계정 B와 KMS 키 정책에는 추가 설정이 필요 없다"}, {"key": "B", "text": "계정 A의 버킷 정책과 키 정책에서 B의 역할을 허용하고 B 역할의 IAM 정책에도 s3:GetObject와 kms:Decrypt를 부여한다"}, {"key": "C", "text": "계정 B 역할의 IAM 정책에만 버킷과 키에 대한 권한을 부여하면 계정 A의 정책 없이도 접근된다"}, {"key": "D", "text": "계정 A 버킷을 AWS 관리형 키 aws/s3로 다시 암호화하고 버킷 정책으로 B를 허용한다"}]',1,'[1]','B','B — B) 계정 A의 버킷 정책과 키 정책에서 B의 역할을 허용하고 B 역할의 IAM 정책에도 s3:GetObject와 kms:Decrypt를 부여한다','["AWS KMS", "Amazon S3", "Cross-Account Access", "Key Policy", "IAM Policy"]','AWS KMS, Amazon S3, Cross-Account Access, Key Policy, IAM Policy','정답(B): 교차 계정 접근은 리소스 쪽(버킷 정책, 키 정책)과 사용자 쪽 IAM 정책이 모두 허용해야 하며 KMS 키 정책이 B를 허용해야 복호화됩니다. A는 키 권한이 없어 실패하고, C는 소유 계정 정책 없이 교차 계정이 허용되지 않으며, D는 AWS 관리형 키가 교차 계정 사용을 지원하지 않습니다.
참고: Allow users in other accounts to use a KMS key - AWS Key Management Service Developer Guide

[핵심 아키텍처 포인트] 고객 관리형 KMS 키로 암호화된 S3 객체를 다른 계정이 읽으려면 소유 계정의 버킷 정책·KMS 키 정책 허용과 요청 계정의 IAM 역할 권한이 모두 충족되어야 합니다.');
INSERT INTO "questions" VALUES(42,3,12,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-140','ko','CloudFront 및 서울 리전 ALB 구간의 리전별 ACM 인증서 배치','서울 Region의 ALB 뒤에 웹 애플리케이션이 있고 그 앞에 CloudFront 배포를 둡니다. 사용자-CloudFront 구간과 CloudFront-ALB 구간 모두 도메인 이름으로 TLS를 쓰며 인증서 갱신은 자동이어야 합니다. 도메인은 Route 53 호스팅 영역에 있습니다. ACM 인증서를 어떻게 발급해야 합니까?','[{"key": "A", "text": "서울 Region에서 인증서 한 개를 요청해 CloudFront와 ALB에 모두 연결한다"}, {"key": "B", "text": "us-east-1에서 인증서 한 개를 요청해 CloudFront와 서울 ALB에 모두 연결한다"}, {"key": "C", "text": "CloudFront용은 us-east-1, ALB용은 서울에서 각각 DNS 검증 퍼블릭 인증서를 요청한다"}, {"key": "D", "text": "공인 CA에서 구매한 인증서를 ACM으로 가져와 두 Region에서 사용한다"}]',2,'[2]','C','C — C) CloudFront용은 us-east-1, ALB용은 서울에서 각각 DNS 검증 퍼블릭 인증서를 요청한다','["AWS Certificate Manager (ACM)", "Amazon CloudFront", "Application Load Balancer (ALB)", "us-east-1", "TLS Encryption"]','AWS Certificate Manager (ACM), Amazon CloudFront, Application Load Balancer (ALB), us-east-1, TLS Encryption','정답(C): CloudFront에 쓰는 ACM 인증서는 us-east-1에 있어야 하고, ALB는 자신과 같은 Region의 인증서를 쓰며, DNS 검증은 CNAME이 유지되면 자동 갱신됩니다. A는 CloudFront가 서울 인증서를 쓸 수 없고, B는 ALB가 다른 Region 인증서를 쓸 수 없으며, D는 가져온 인증서가 자동 갱신되지 않습니다.
참고: Supported services for ACM certificates - AWS Certificate Manager User Guide

[핵심 아키텍처 포인트] CloudFront 배포용 ACM 인증서는 반드시 us-east-1에서 발급해야 하며, 백엔드 ALB용 인증서는 ALB와 동일한 리전(서울)에서 발급해야 합니다.');
INSERT INTO "questions" VALUES(43,3,13,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-165','ko','DDoS 대응 SRT 지원 및 요금 보호를 위한 Shield Advanced + WAF 속도 제한','미디어 회사는 CloudFront, ALB, 탄력적 IP 주소에 대한 DDoS 공격으로 트래픽이 급증해 발생하는 요금과 대응 지연이 걱정됩니다. 공격 중 AWS 전문 팀의 24시간 지원과 비용 보호가 필요하고 L7 요청 폭주에는 사용자 지정 완화도 필요합니다. 공격이 연중 몇 차례 예상되며 요금 급증으로 인한 예산 초과를 막아야 합니다. 어떤 구성이 적합합니까?','[{"key": "A", "text": "Shield Standard에 의존하고 Auto Scaling 최대 용량을 늘려 공격 트래픽을 흡수한다"}, {"key": "B", "text": "Shield Advanced를 구독해 보호 리소스를 등록하고 SRT와 연결하며 WAF 속도 기반 규칙을 구성한다"}, {"key": "C", "text": "WAF 관리형 규칙만 적용하고 공격이 발생하면 AWS Support에 사례를 열어 지원을 요청한다"}, {"key": "D", "text": "Route 53 상태 확인과 CloudWatch 경보로 공격을 탐지해 Lambda가 보안 그룹을 수정하게 한다"}]',1,'[1]','B','B — B) Shield Advanced를 구독해 보호 리소스를 등록하고 SRT와 연결하며 WAF 속도 기반 규칙을 구성한다','["AWS Shield Advanced", "Shield Response Team (SRT)", "AWS WAF", "Rate-Based Rules", "DDoS Cost Protection"]','AWS Shield Advanced, Shield Response Team (SRT), AWS WAF, Rate-Based Rules, DDoS Cost Protection','정답(B): Shield Advanced는 SRT 지원과 DDoS 관련 비용 보호를 제공하며 속도 기반 규칙은 L7 완화와 비용 보호 요건에 필요합니다. A는 비용 보호와 전문 팀 지원이 없고, C는 공격 중 즉각적인 전문 대응을 보장하지 못하며, D는 직접 만든 대응이라 대규모 DDoS를 막기 어렵습니다.
참고: AWS WAF - Rate-based rules - AWS Best Practices for DDoS Resiliency

[핵심 아키텍처 포인트] DDoS 트래픽 급증 요금 보호와 AWS 전문 대응팀(SRT) 연계를 위해서는 Shield Advanced 보호 리소스 등록과 WAF 속도 기반 완화 규칙이 필요합니다.');
INSERT INTO "questions" VALUES(44,3,14,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-172','ko','고객 관리형 KMS 암호화 S3 버킷 대상 Amazon Macie PII 스캔 권한 설정','한 회사는 조직의 여러 계정에 흩어진 S3 버킷에서 개인정보(PII)를 찾기 위해 Amazon Macie 민감 데이터 검색 작업을 실행했습니다. 대상 버킷의 객체는 고객 관리형 KMS 키로 SSE-KMS 암호화되어 있는데, 작업 결과에서 해당 객체들이 분석되지 못하고 접근 오류로 표시됩니다. 암호화 요구사항을 유지하면서 문제를 해결하는 방법은 무엇입니까?','[{"key": "A", "text": "S3 버킷 정책에 Macie 서비스 주체의 s3:GetObject 권한을 추가하여 KMS 복호화 권한도 함께 부여되게 한다"}, {"key": "B", "text": "대상 버킷의 기본 암호화를 SSE-S3로 변경한 뒤 기존 객체를 모두 다시 업로드하여 키 의존성을 제거한다"}, {"key": "C", "text": "KMS 키 정책에서 Macie 서비스 연결 역할이 해당 키로 객체를 복호화할 수 있도록 허용한다"}, {"key": "D", "text": "S3 Bucket Keys를 활성화하여 Macie가 버킷 수준 키로 객체를 복호화할 수 있도록 설정한다"}]',2,'[2]','C','C — C) KMS 키 정책에서 Macie 서비스 연결 역할이 해당 키로 객체를 복호화할 수 있도록 허용한다','["Amazon Macie", "AWS KMS", "Service-Linked Role", "PII Discovery", "Key Policy"]','Amazon Macie, AWS KMS, Service-Linked Role, PII Discovery, Key Policy','정답(C): Macie는 서비스 연결 역할로 객체를 읽으므로 SSE-KMS 객체를 분석하려면 KMS 키 정책이 그 역할의 복호화를 허용해야 합니다. A는 버킷 정책이 KMS 권한을 부여하지 못하고, B는 암호화 요구사항을 약화시키며 재업로드 부담이 큽니다. D는 요청 비용 절감 기능일 뿐 복호화 권한을 대체하지 않습니다.
참고: How automated sensitive data discovery works - Amazon Macie

[핵심 아키텍처 포인트] Macie가 고객 관리형 KMS 키로 암호화된 S3 객체를 복호화해 민감 데이터를 검사하려면 KMS 키 정책에서 Macie 서비스 연결 역할의 Decrypt 권한을 허용해야 합니다.');
INSERT INTO "questions" VALUES(45,3,15,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-129','ko','다중 계정·다중 리전 보안 결과 ASFF 통합 집계 (AWS Security Hub)','여러 Region에서 40개 계정을 운영하는 회사는 GuardDuty, Inspector, Macie 결과를 보안 팀이 한 곳에서 표준 형식(ASFF)으로 보고 우선순위를 정하길 원합니다. 새로 추가되는 계정도 자동으로 포함되어야 하며 직접 개발하는 수집 파이프라인은 피해야 합니다. 보안 팀 인력이 적어 직접 개발한 수집 파이프라인은 유지보수할 수 없습니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "각 서비스 결과를 EventBridge로 중앙 S3 버킷에 보내고 Athena 쿼리와 QuickSight 대시보드로 조회한다"}, {"key": "B", "text": "Amazon Detective 동작 그래프를 조직 전체로 확장하여 서비스별 결과를 하나의 그래프에서 확인한다"}, {"key": "C", "text": "Security Hub 위임 관리자 계정을 지정해 조직 계정을 자동으로 등록하고 교차 Region 집계를 구성한다"}, {"key": "D", "text": "각 계정의 CloudWatch 대시보드를 교차 계정 관찰성으로 연결하고 서비스별 지표를 모아서 본다"}]',2,'[2]','C','C — C) Security Hub 위임 관리자 계정을 지정해 조직 계정을 자동으로 등록하고 교차 Region 집계를 구성한다','["AWS Security Hub", "ASFF", "Cross-Region Aggregation", "Delegated Administrator", "AWS Organizations"]','AWS Security Hub, ASFF, Cross-Region Aggregation, Delegated Administrator, AWS Organizations','정답(C): Security Hub는 여러 보안 서비스의 결과를 ASFF로 집계하며 위임 관리자와 조직 통합으로 신규 계정을 자동 포함하고 집계 Region으로 모읍니다. A는 직접 파이프라인을 만들어야 하고, B는 조사 도구이지 결과 집계 서비스가 아니며, D는 보안 결과가 아닌 지표용입니다.
참고: Cross-Region aggregation - AWS Security Hub User Guide

[핵심 아키텍처 포인트] Security Hub 위임 관리자 지정과 교차 리전 집계를 활성화하면 별도 ETL 파이프라인 없이 조직 전체 GuardDuty·Inspector·Macie 결과를 ASFF로 통합 조회합니다.');
INSERT INTO "questions" VALUES(46,3,16,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-062','ko','키 정책 수정 없는 KMS CMK 임시·프로그래밍 위임 (CreateGrant)','한 회사는 CMK로 암호화된 리소스를 EBS와 같은 AWS 서비스가 사용자 대신 사용할 수 있도록 일시적으로 위임하려 합니다. 키 정책을 매번 편집하지 않고 프로그램적으로 위임하고 필요 시 즉시 취소할 수 있어야 합니다. 서비스가 대신 키를 쓰는 기간은 짧고 작업마다 다릅니다. 어떤 KMS 기능을 사용해야 합니까?','[{"key": "A", "text": "위임이 필요할 때마다 키 정책에 principal을 추가하고 작업이 끝나면 키 정책을 이전 버전으로 되돌린다"}, {"key": "B", "text": "CreateGrant로 위임하고 RevokeGrant로 취소한다"}, {"key": "C", "text": "위임 대상마다 새 KMS 키를 만들고 작업이 끝나면 즉시 삭제 예약해 접근을 회수한다"}, {"key": "D", "text": "IAM policy에 kms:* 를 허용하면 키 정책과 무관하게 접근이 위임된다"}]',1,'[1]','B','B — B) CreateGrant로 위임하고 RevokeGrant로 취소한다','["AWS KMS", "KMS Grant", "CreateGrant", "RevokeGrant", "Customer Managed Key"]','AWS KMS, KMS Grant, CreateGrant, RevokeGrant, Customer Managed Key','정답(B): grant는 키 정책을 바꾸지 않고 특정 principal에 제한된 KMS 작업을 프로그램적으로 위임하며, 서비스 통합(EBS, RDS 등)에서도 쓰이고 RevokeGrant로 취소할 수 있습니다. 키 정책 반복 수정(A)은 운영 부담이 크고, 키를 새로 만드는 방식(C)은 비효율적이며, IAM policy의 kms:* 허용(D)은 키 정책이 IAM policy 사용을 허용하도록 되어 있을 때만 효력이 있고 키 정책과 무관하게 접근이 위임되지 않습니다.

[핵심 아키텍처 포인트] 키 정책을 빈번히 편집하지 않고 AWS 서비스나 특정 주체에 임시 KMS 작업 권한을 프로그래밍 방식으로 위임·즉시 회수하려면 KMS Grant(CreateGrant/RevokeGrant)를 사용합니다.');
INSERT INTO "questions" VALUES(47,3,17,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-168','ko','TLS 복호화 없이 허용 도메인 기반 아웃바운드 통제 (Network Firewall TLS_SNI)','프라이빗 서브넷의 결제 배치 서버는 승인된 파트너 도메인 3개에만 HTTPS로 나갈 수 있어야 합니다. TLS 복호화는 하지 않으며, 도메인 대신 IP 주소로 직접 연결을 시도하는 트래픽도 차단되어야 합니다. 이미 NAT 게이트웨이를 사용 중입니다. 운영 인력이 적어 직접 관리해야 하는 서버는 최소화하려 합니다. 요구사항을 충족하는 가장 적합한 방법은 무엇입니까?','[{"key": "A", "text": "AWS Network Firewall에 TLS_SNI 기준 허용 도메인 규칙 그룹을 적용하고 나머지 아웃바운드 트래픽은 기본 작업으로 드롭한다"}, {"key": "B", "text": "Route 53 Resolver DNS Firewall로 승인된 도메인 외의 DNS 질의를 차단하는 규칙 그룹을 모든 VPC에 연결하고 위반 질의를 지속적으로 모니터링한다"}, {"key": "C", "text": "서버 보안 그룹의 아웃바운드 규칙에 파트너 도메인 이름을 대상으로 지정하고 나머지는 거부한다"}, {"key": "D", "text": "EC2에 Squid 프록시를 구성해 허용 도메인 목록을 관리하고 서버가 프록시를 통해서만 나가게 한다"}]',0,'[0]','A','A — A) AWS Network Firewall에 TLS_SNI 기준 허용 도메인 규칙 그룹을 적용하고 나머지 아웃바운드 트래픽은 기본 작업으로 드롭한다','["AWS Network Firewall", "TLS_SNI", "Stateful Rule Group", "Egress Filtering", "Amazon VPC"]','AWS Network Firewall, TLS_SNI, Stateful Rule Group, Egress Filtering, Amazon VPC','정답(A): Network Firewall의 도메인 목록 규칙은 HTTPS의 SNI로 도메인을 매칭하며 기본 드롭 설정으로 IP 직접 연결도 막습니다. B는 DNS 질의만 통제해 IP 직접 연결을 막지 못하고, C는 보안 그룹이 도메인 이름을 지원하지 않으며, D는 가능하지만 프록시 운영 부담이 큽니다.
참고: RulesSourceList - AWS Network Firewall API Reference

[핵심 아키텍처 포인트] 프라이빗 서브넷 아웃바운드에서 TLS 복호화 없이 특정 도메인만 허용하고 IP 직접 접속까지 차단하려면 AWS Network Firewall의 도메인 목록(TLS_SNI) + 기본 드롭 규칙을 씁니다.');
INSERT INTO "questions" VALUES(48,3,18,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-180','ko','RDS 자격 증명 30일 자동 회전 및 DR 리전 복제 (Secrets Manager)','RDS for MySQL 관리자 자격 증명을 30일마다 교체해야 하며, 애플리케이션은 실행 시 비밀을 조회하므로 코드 변경 없이 최신 비밀번호를 쓸 수 있어야 합니다. DR용으로 다른 Region에도 같은 비밀이 있어야 하고 운영 노력은 최소화해야 합니다. 보안 감사에서는 비밀번호 교체 이력이 자동으로 남아야 합니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "Parameter Store SecureString에 저장하고 EventBridge와 Lambda로 직접 만든 회전 로직을 30일마다 실행한다"}, {"key": "B", "text": "KMS 키 자동 회전을 활성화하여 비밀번호가 30일마다 새 값으로 교체되게 한다"}, {"key": "C", "text": "비밀번호를 사용자 데이터 스크립트에 넣고 Auto Scaling 인스턴스를 30일마다 교체한다"}, {"key": "D", "text": "Secrets Manager에 자격 증명을 저장하고 RDS용 관리형 회전을 30일로 설정한 뒤 DR Region에 비밀 복제본을 구성한다"}]',3,'[3]','D','D — D) Secrets Manager에 자격 증명을 저장하고 RDS용 관리형 회전을 30일로 설정한 뒤 DR Region에 비밀 복제본을 구성한다','["AWS Secrets Manager", "Amazon RDS", "Automatic Rotation", "Cross-Region Replication", "Credential Management"]','AWS Secrets Manager, Amazon RDS, Automatic Rotation, Cross-Region Replication, Credential Management','정답(D): Secrets Manager는 RDS 자격 증명 자동 회전과 Region 간 복제를 기본 제공해 운영 부담이 가장 적습니다. A는 회전 로직을 직접 만들어 운영해야 하고, B는 암호화 키를 회전할 뿐 DB 비밀번호는 바뀌지 않으며, C는 비밀번호를 평문 스크립트에 두는 안티패턴입니다.
참고: Rotate AWS Secrets Manager secrets - AWS Secrets Manager User Guide

[핵심 아키텍처 포인트] Secrets Manager는 RDS 엔진용 관리형 자동 회전 람다와 타 리전 비밀 복제를 기본 제공해 애플리케이션 코드 수정 없이 30일 주기 교체를 달성합니다.');
INSERT INTO "questions" VALUES(49,4,1,1,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-136','ko','Amazon EFS 저장 시 및 전송 중 암호화 동시 적용','EFS 파일 시스템에 개인정보가 저장됩니다. 보안 요구사항은 저장 시 암호화와 전송 중 암호화를 모두 만족하는 것입니다. 대상은 Linux 웹 서버 수십 대이며 파일 시스템은 아직 생성되지 않았습니다. 두 요구사항은 별도 설정이므로 각각 충족해야 하며 애플리케이션 코드는 수정하지 않습니다. 이를 위한 두 가지 조치를 선택하십시오. (2개 선택)','[{"key": "A", "text": "기존 비암호화 파일 시스템의 설정을 수정해 저장 데이터 암호화를 켠다"}, {"key": "B", "text": "파일 시스템을 생성할 때 저장 데이터 암호화를 활성화한다"}, {"key": "C", "text": "기본 NFS 마운트를 사용하면 NFSv4가 자동으로 TLS로 전송 데이터를 암호화한다"}, {"key": "D", "text": "보안 그룹에서 2049 포트를 VPN 대역으로만 허용하면 전송 중 암호화가 적용된다"}, {"key": "E", "text": "EFS 마운트 헬퍼의 TLS 옵션을 사용해 클라이언트가 파일 시스템을 마운트한다"}]',NULL,'[1, 4]','B, E','B, E — B) 파일 시스템을 생성할 때 저장 데이터 암호화를 활성화한다 / E) EFS 마운트 헬퍼의 TLS 옵션을 사용해 클라이언트가 파일 시스템을 마운트한다','["Amazon EFS", "Encryption at Rest", "Encryption in Transit", "TLS", "EFS Mount Helper"]','Amazon EFS, Encryption at Rest, Encryption in Transit, TLS, EFS Mount Helper','정답(B, E): 저장 시 암호화는 생성 시점에 지정해야 하고, 전송 중 암호화는 마운트 헬퍼의 TLS 옵션으로 활성화합니다. A는 기존 파일 시스템에 암호화를 켤 수 없고, C는 기본 NFS 마운트가 암호화되지 않으며, D는 접근 제어일 뿐 암호화가 아닙니다.
참고: Encrypting data in transit - Amazon Elastic File System User Guide

[핵심 아키텍처 포인트] EFS 저장 시 암호화는 파일 시스템 생성 시점에만 설정 가능하며, 전송 중 암호화는 Linux 클라이언트가 EFS 마운트 헬퍼의 tls 옵션을 사용해 마운트함으로써 적용합니다.');
INSERT INTO "questions" VALUES(50,4,2,1,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-111','ko','랜섬웨어 대응 S3 Object Lock Compliance 모드 WORM 보호','한 회사는 랜섬웨어로 인한 S3 데이터의 삭제와 덮어쓰기 피해를 막고, 감사 규정상 지정된 기간 동안 객체를 변경할 수 없는 상태로 보관해야 합니다. 침해된 관리자 자격 증명으로도 객체가 영구 삭제되지 않도록 이전 버전 복구도 가능해야 합니다. 두 가지 구성을 선택하십시오. (2개 선택)','[{"key": "A", "text": "버킷 버전 관리를 활성화한다"}, {"key": "B", "text": "버킷 정책에서 Principal을 \"*\"로 하는 Allow 문을 추가한다"}, {"key": "C", "text": "객체를 S3 Standard에서 Intelligent-Tiering으로 옮긴다"}, {"key": "D", "text": "S3 Object Lock을 compliance 모드로 활성화하고 보존 기간을 지정한다"}, {"key": "E", "text": "S3 서버 액세스 로그만 활성화한다"}]',NULL,'[0, 3]','A, D','A, D — A) 버킷 버전 관리를 활성화한다 / D) S3 Object Lock을 compliance 모드로 활성화하고 보존 기간을 지정한다','["Amazon S3", "S3 Object Lock", "Compliance Mode", "S3 Versioning", "Ransomware Protection"]','Amazon S3, S3 Object Lock, Compliance Mode, S3 Versioning, Ransomware Protection','정답(A, D): 버전 관리는 삭제와 덮어쓰기에서 이전 버전을 복구할 수 있게 하고, Object Lock compliance 모드는 보존 기간 동안 관리자·루트도 객체 버전을 삭제하거나 보존 설정을 바꾸지 못하는 WORM을 제공합니다(Object Lock에는 버전 관리가 필요). 광범위한 Allow(B)는 위험을 키우고, Intelligent-Tiering(C)은 비용 최적화일 뿐이며, 액세스 로그(E)는 탐지용입니다.

[핵심 아키텍처 포인트] 루트·관리자 계정 탈취 상황에서도 데이터 삭제·변조를 막으려면 S3 버킷 버전 관리를 켠 뒤 Object Lock Compliance 모드로 보존 기간을 강제해야 합니다.');
INSERT INTO "questions" VALUES(51,4,3,1,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-133','ko','Organizations SCP 및 조직 트레일을 활용한 중앙 감사 로그 보호','회사는 조직 멤버 계정의 관리자가 CloudTrail 로깅을 중지하거나 GuardDuty를 비활성화하지 못하게 하고, 모든 계정의 API 활동을 중앙에 일관되게 기록해야 합니다. 멤버 계정은 40개이며 규정상 로그는 별도 계정에 보관되어야 하고 사후 알림만으로는 충분하지 않습니다. 이를 위한 두 가지 조치를 선택하십시오. (2개 선택)','[{"key": "A", "text": "각 멤버 계정의 IAM 정책에서 같은 작업을 거부하도록 배포한다"}, {"key": "B", "text": "SCP로 멤버 계정에서 cloudtrail:StopLogging, cloudtrail:DeleteTrail, guardduty:DeleteDetector 같은 작업을 거부한다"}, {"key": "C", "text": "StopLogging 이벤트를 감지하면 멤버 관리자에게 알림을 보내는 CloudWatch 경보를 만든다"}, {"key": "D", "text": "Config 규칙이 비활성화를 감지하면 사람이 승인한 뒤 수동으로 재활성화한다"}, {"key": "E", "text": "관리 계정에서 조직 트레일을 만들어 모든 계정의 이벤트를 중앙 S3 버킷으로 전달한다"}]',NULL,'[1, 4]','B, E','B, E — B) SCP로 멤버 계정에서 cloudtrail:StopLogging, cloudtrail:DeleteTrail, guardduty:DeleteDetector 같은 작업을 거부한다 / E) 관리 계정에서 조직 트레일을 만들어 모든 계정의 이벤트를 중앙 S3 버킷으로 전달한다','["AWS Organizations", "Service Control Policy (SCP)", "AWS CloudTrail", "Centralized Logging", "Preventive Guardrail"]','AWS Organizations, Service Control Policy (SCP), AWS CloudTrail, Centralized Logging, Preventive Guardrail','정답(B, E): SCP는 멤버 계정 관리자도 우회할 수 없는 예방 통제이고, 조직 트레일은 신규 계정을 포함해 중앙 기록을 보장합니다. A는 멤버 관리자가 정책을 변경할 수 있고, C는 알림뿐이라 중지를 막지 못하며, D는 사후 수동 대응입니다.
참고: Creating a trail for an organization - AWS CloudTrail User Guide

[핵심 아키텍처 포인트] SCP로 멤버 계정 관리자의 CloudTrail 중지·GuardDuty 비활성화 API를 원천 차단하고, 조직 트레일로 신규 계정 포함 모든 이벤트를 중앙 보안 계정 S3에 집약합니다.');
INSERT INTO "questions" VALUES(52,4,4,1,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-110','ko','ALB L7 SQLi 차단 및 DDoS 비용·전문 대응 결합 아키텍처','한 전자상거래 회사의 ALB 기반 웹 서비스가 SQL injection 시도와 대규모 DDoS 공격을 동시에 받고 있습니다. 보안팀은 애플리케이션 계층 공격을 걸러내는 동시에 DDoS 대응 전문가의 지원과 공격 중 발생한 확장 비용 보호도 받으려 합니다. 두 가지 조치를 선택하십시오. (2개 선택)','[{"key": "A", "text": "Shield Standard만 사용하고 추가 조치는 하지 않는다"}, {"key": "B", "text": "ALB에 AWS WAF web ACL과 관리형 규칙을 연결한다"}, {"key": "C", "text": "GuardDuty를 활성화해 공격 트래픽을 자동으로 차단한다"}, {"key": "D", "text": "ALB를 AWS Shield Advanced 보호 리소스로 등록한다"}, {"key": "E", "text": "서브넷 NACL에 공격 IP를 모두 수동으로 추가한다"}]',NULL,'[1, 3]','B, D','B, D — B) ALB에 AWS WAF web ACL과 관리형 규칙을 연결한다 / D) ALB를 AWS Shield Advanced 보호 리소스로 등록한다','["AWS WAF", "AWS Shield Advanced", "Application Load Balancer (ALB)", "DDoS Mitigation", "SQL Injection"]','AWS WAF, AWS Shield Advanced, Application Load Balancer (ALB), DDoS Mitigation, SQL Injection','정답(B, D): WAF는 SQL injection 같은 L7 공격을 걸러내고, Shield Advanced는 향상된 DDoS 보호와 대응팀 지원, 비용 보호를 제공합니다. Shield Standard만(A)으로는 지원과 비용 보호가 없고, GuardDuty(C)는 탐지 서비스이며, NACL 수동 관리(E)는 대규모 분산 공격에 확장되지 않습니다.

[핵심 아키텍처 포인트] WAF 관리형 규칙으로 SQLi 등 L7 공격을 차단하고, Shield Advanced로 DDoS 대응팀(SRT) 지원과 공격 트래픽 확장 비용 보호를 동시에 확보합니다.');
INSERT INTO "questions" VALUES(53,4,5,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-178','ko','정상 트래픽 영향 없는 로그인 경로 전용 WAF 속도 기반 규칙 (Scope-Down)','쇼핑몰은 ALB 앞에 AWS WAF를 사용합니다. 로그인 경로(/login)에 대한 무차별 대입 공격을 줄이려고 같은 IP에서 5분에 100회를 넘는 /login 요청만 차단하려 합니다. 정상 사용자의 상품 조회 트래픽에는 영향이 없어야 합니다. 상품 조회 트래픽은 하루 수백만 건이라 오탐이 발생하면 매출에 영향이 큽니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "웹 ACL에 AWS 관리형 IP 평판 목록 규칙 그룹을 추가한다"}, {"key": "B", "text": "속도 기반 규칙에 URI 경로가 /login인 요청만 집계하는 범위 축소 문을 추가한다"}, {"key": "C", "text": "범위 축소 없이 속도 기반 규칙을 5분당 100회로 설정해 모든 경로에 적용한다"}, {"key": "D", "text": "ALB 보안 그룹에서 /login 경로로 접근하는 IP 대역을 제한한다"}]',1,'[1]','B','B — B) 속도 기반 규칙에 URI 경로가 /login인 요청만 집계하는 범위 축소 문을 추가한다','["AWS WAF", "Rate-Based Rule", "Scope-Down Statement", "Brute-Force Protection", "Application Load Balancer (ALB)"]','AWS WAF, Rate-Based Rule, Scope-Down Statement, Brute-Force Protection, Application Load Balancer (ALB)','정답(B): 범위 축소 문이 있는 속도 기반 규칙은 /login 요청만 IP별로 집계해 임계치를 넘는 IP를 차단합니다. A는 요청 빈도를 보지 않고 알려진 악성 IP만 차단하며, C는 상품 조회까지 집계되어 정상 사용자가 차단될 수 있고, D는 보안 그룹이 L7 경로를 구분하지 못합니다.
참고: AWS WAF - Rate-based rules - AWS Best Practices for DDoS Resiliency

[핵심 아키텍처 포인트] WAF 속도 기반 규칙에 URI 경로(/login)를 지정하는 Scope-Down Statement를 추가하면 일반 상품 조회 트래픽 오탐 없이 특정 경로의 무차별 대입만 차단합니다.');
INSERT INTO "questions" VALUES(54,4,6,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-057','ko','90일 CloudTrail 활동 이력 기반 최소 권한 정책 자동 초안 생성','개발 단계에서 PowerUserAccess로 배포된 애플리케이션 role이 운영에 올라갔습니다. 보안팀은 지난 90일간의 CloudTrail 활동에 근거해 이 role이 실제로 사용한 작업만 허용하는 최소 권한 policy 초안을 만들고 싶습니다. 운영팀은 권한 설계를 처음부터 다시 하고 싶지 않습니다. 가장 적절한 방법은 무엇입니까?','[{"key": "A", "text": "IAM credential report를 내려받아 role이 최근 호출한 서비스별 사용 현황을 확인하고 policy를 직접 작성한다"}, {"key": "B", "text": "AWS Trusted Advisor의 보안 점검 결과로 policy를 자동 생성한다"}, {"key": "C", "text": "Access Analyzer policy generation으로 CloudTrail 기반 최소 권한 policy를 생성한다"}, {"key": "D", "text": "AWS Config로 role의 변경 이력을 조회해 필요한 권한을 추정한다"}]',2,'[2]','C','C — C) Access Analyzer policy generation으로 CloudTrail 기반 최소 권한 policy를 생성한다','["IAM Access Analyzer", "Policy Generation", "AWS CloudTrail", "Least Privilege", "IAM Policy"]','IAM Access Analyzer, Policy Generation, AWS CloudTrail, Least Privilege, IAM Policy','정답(C): Access Analyzer policy generation은 CloudTrail 로그를 분석해 principal이 실제 사용한 작업과 서비스를 바탕으로 최소 권한 policy 초안을 생성합니다. credential report(A)는 IAM 사용자 자격 증명 현황 보고서이고, Trusted Advisor(B)는 policy를 생성하지 않으며, Config(D)는 구성 변경 이력이라 사용 권한 추적과 다릅니다.

[핵심 아키텍처 포인트] Access Analyzer Policy Generation은 지정 기간의 CloudTrail 로그를 분석해 해당 역할이 실제로 호출한 AWS 서비스·액션만 포함한 최소 권한 정책 초안을 생성합니다.');
INSERT INTO "questions" VALUES(55,4,7,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-176','ko','중복 CIDR 고객 VPC 대상 단방향 사설 SaaS 노출 (AWS PrivateLink)','SaaS 업체는 NLB 뒤의 서비스를 200개 고객 VPC에 비공개로 제공하려 합니다. 고객 VPC의 CIDR이 서로 겹치고 업체 VPC와도 겹칠 수 있으며, 고객이 업체 VPC 전체에 접근해서는 안 됩니다. 연결은 고객에서 업체 방향으로만 시작되어야 합니다. 고객 수는 계속 늘어날 예정이며 고객마다 별도의 네트워크 설정을 요구해서는 안 됩니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "고객 VPC마다 업체 VPC와 VPC 피어링을 만들고 보안 그룹으로 접근 범위를 제한한다"}, {"key": "B", "text": "NLB를 엔드포인트 서비스로 노출하고 고객이 자신의 VPC에 인터페이스 엔드포인트를 만들어 연결한다"}, {"key": "C", "text": "Transit Gateway에 모든 VPC를 연결하고 라우팅 테이블을 분리해 접근 범위를 고객별로 제한한다"}, {"key": "D", "text": "고객마다 Site-to-Site VPN 연결을 만들어 업체 VPC와 연결한다"}]',1,'[1]','B','B — B) NLB를 엔드포인트 서비스로 노출하고 고객이 자신의 VPC에 인터페이스 엔드포인트를 만들어 연결한다','["AWS PrivateLink", "Network Load Balancer (NLB)", "VPC Endpoint Service", "Overlapping CIDR", "SaaS Networking"]','AWS PrivateLink, Network Load Balancer (NLB), VPC Endpoint Service, Overlapping CIDR, SaaS Networking','정답(B): PrivateLink는 CIDR이 겹쳐도 되고 소비자가 특정 서비스에만 단방향으로 접근하게 합니다. A는 CIDR이 겹치면 피어링을 만들 수 없고 VPC 전체가 연결되며, C는 겹치는 CIDR 간 라우팅이 불가능하고, D는 VPN 라우팅도 CIDR 중복과 운영 부담 문제가 있습니다.
참고: AWS PrivateLink Concepts - AWS PrivateLink Guide

[핵심 아키텍처 포인트] 고객 VPC 간 CIDR이 겹쳐도 NLB를 PrivateLink 엔드포인트 서비스로 게시하면 고객 VPC의 인터페이스 엔드포인트에서 제공사 서비스로만 단방향 비공개 통신이 가능합니다.');
INSERT INTO "questions" VALUES(56,4,8,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-053','ko','권한 상승 방지 조건 포함 개발팀 IAM 역할 생성 위임 (Permissions Boundary)','한 회사는 개발팀 리드에게 IAM role을 직접 만들 수 있는 권한을 위임하려 합니다. 단, 새로 만든 role은 S3와 DynamoDB 관련 권한만 가질 수 있어야 하고, 개발자가 자신에게 더 큰 권한을 부여하는 권한 상승은 막아야 합니다. 위임 후에도 보안팀이 권한 범위를 통제해야 합니다. 가장 적절한 방법은 무엇입니까?','[{"key": "A", "text": "permissions boundary 조건이 있을 때만 iam:CreateRole을 허용하고 boundary는 S3·DynamoDB만 허용한다"}, {"key": "B", "text": "리드에게 IAMFullAccess를 부여하고 CloudTrail 알람으로 사후에 과도한 권한이 부여되었는지 점검한다"}, {"key": "C", "text": "OU에 SCP를 적용해 S3와 DynamoDB를 제외한 모든 서비스를 거부하고 모든 개발 계정에 동일하게 적용한다"}, {"key": "D", "text": "리드가 만든 모든 role에 AdministratorAccess를 연결하고 태그로 사용을 구분한다"}]',0,'[0]','A','A — A) permissions boundary 조건이 있을 때만 iam:CreateRole을 허용하고 boundary는 S3·DynamoDB만 허용한다','["AWS IAM", "Permissions Boundary", "Privilege Escalation Prevention", "IAM Delegation", "Condition Key"]','AWS IAM, Permissions Boundary, Privilege Escalation Prevention, IAM Delegation, Condition Key','정답(A): permissions boundary는 IAM 엔터티가 가질 수 있는 최대 권한을 제한하며, iam:PermissionsBoundary 조건 키로 boundary 없이는 role 생성을 막을 수 있어 안전한 권한 위임이 가능합니다. IAMFullAccess(B)는 권한 상승이 가능하고, OU 전체 SCP(C)는 다른 팀의 업무까지 제한하며, AdministratorAccess(D)는 최소 권한 위반입니다.

[핵심 아키텍처 포인트] 역할 생성 위임 시 iam:PermissionsBoundary 조건 키로 허용된 권한 경계 부착을 강제하면 위임받은 개발자가 경계를 넘는 권한 상승 역할을 만들 수 없습니다.');
INSERT INTO "questions" VALUES(57,4,9,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-056','ko','ECS Fargate 애플리케이션 권한과 에이전트 실행 권한 분리 (Task Role vs Execution Role)','한 회사는 ECS on Fargate에서 주문 서비스와 결제 서비스를 별도 서비스로 운영합니다. 각 서비스는 서로 다른 DynamoDB 테이블에만 접근해야 하며(least privilege), 컨테이너 이미지 가져오기와 로그 전송에 쓰는 권한은 애플리케이션 코드가 사용하는 권한과 분리하려 합니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "두 서비스가 하나의 task execution role을 공유하고 두 DynamoDB 테이블 모두에 대한 권한을 그 role에 부여한다"}, {"key": "B", "text": "서비스별 task role에 해당 테이블 권한만 부여하고 이미지 pull·로그 권한은 task execution role에 둔다"}, {"key": "C", "text": "Fargate 작업에 EC2 instance profile을 연결하고 두 테이블에 대한 권한을 부여한다"}, {"key": "D", "text": "서비스마다 IAM 사용자 액세스 키를 만들어 환경 변수로 주입하고 키는 분기마다 교체한다"}]',1,'[1]','B','B — B) 서비스별 task role에 해당 테이블 권한만 부여하고 이미지 pull·로그 권한은 task execution role에 둔다','["Amazon ECS", "AWS Fargate", "Task Role", "Task Execution Role", "Least Privilege"]','Amazon ECS, AWS Fargate, Task Role, Task Execution Role, Least Privilege','정답(B): ECS에서 task role은 컨테이너 애플리케이션이 AWS API를 호출할 때 쓰는 권한이고, task execution role은 ECR 이미지 pull·CloudWatch Logs 전송 등 ECS 에이전트용입니다. 공유 role(A)은 최소 권한을 위반하고, Fargate에는 instance profile(C)이 없으며, 액세스 키(D)는 장기 자격 증명이라 부적절합니다.

[핵심 아키텍처 포인트] 컨테이너 코드의 DynamoDB API 호출에는 서비스별 Task Role을 부여하고, ECR 이미지 풀과 CloudWatch 로그 전송은 Task Execution Role로 분리합니다.');
INSERT INTO "questions" VALUES(58,4,10,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-061','ko','B2B SAML 및 소셜(Google) 통합 JWT 인증 (Amazon Cognito User Pool)','한 SaaS 회사의 웹 앱은 기업 고객의 직원이 각자의 SAML IdP로, 일반 고객은 Google 계정으로 로그인해야 합니다. 백엔드는 API Gateway이며 표준 JWT 토큰으로 인증하고, 회사가 직접 인증 서버를 구현하고 싶지 않습니다. 가장 적절한 구성은 무엇입니까?','[{"key": "A", "text": "고객사마다 IAM SAML provider를 만들어 직원이 AWS 콘솔의 IAM role을 맡아 앱에 로그인하게 한다"}, {"key": "B", "text": "IAM Identity Center에 모든 고객 직원을 등록하고 앱 로그인과 API 인증에 Identity Center를 사용한다"}, {"key": "C", "text": "Cognito identity pool만 구성해 각 IdP 토큰을 API Gateway에 직접 전달한다"}, {"key": "D", "text": "Cognito user pool에 SAML·Google IdP를 연동하고 Cognito authorizer를 사용한다"}]',3,'[3]','D','D — D) Cognito user pool에 SAML·Google IdP를 연동하고 Cognito authorizer를 사용한다','["Amazon Cognito", "User Pool", "SAML Federation", "API Gateway Authorizer", "JWT"]','Amazon Cognito, User Pool, SAML Federation, API Gateway Authorizer, JWT','정답(D): Cognito user pool은 SAML·OIDC·소셜 IdP를 federation 하여 통합 JWT를 발급하고 API Gateway Cognito authorizer가 이를 검증합니다. IAM SAML provider(A)는 AWS 접근용이고, Identity Center(B)는 자사 직원(workforce)용이며, identity pool 단독(C)은 JWT가 아니라 AWS 자격 증명을 발급합니다.

[핵심 아키텍처 포인트] 직원용 Identity Center와 달리 외부 B2B SAML·소셜 사용자를 통합 인증하고 API Gateway용 표준 JWT를 발급할 때는 Cognito User Pool 연합 인증을 사용합니다.');
INSERT INTO "questions" VALUES(59,4,11,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-082','ko','CloudFront 앞단 국가 차단 및 AWS 관리형 악성 IP 차단 (AWS WAF)','한 미디어 회사는 CloudFront 뒤의 웹 사이트에 대해 특정 국가에서의 접속을 차단하고, 알려진 악성 IP 목록에서 오는 요청도 막고 싶습니다. 규칙 목록을 직접 유지보수하는 부담은 최소화해야 합니다. 규칙 목록의 유지보수는 AWS 관리형 기능에 최대한 맡기려 합니다. 어떤 구성이 적합합니까?','[{"key": "A", "text": "서브넷 NACL에 국가별 CIDR 목록을 직접 입력해 거부하고 목록 변경 시 정기적으로 갱신한다"}, {"key": "B", "text": "Shield Advanced를 구독해 악성 IP와 국가 차단이 모든 CloudFront 배포에 자동 적용되게 한다"}, {"key": "C", "text": "GuardDuty 위협 목록을 활성화하면 CloudFront 요청이 자동으로 차단된다"}, {"key": "D", "text": "WAF에 geo match 규칙과 Amazon IP reputation list 관리형 규칙 그룹을 추가한다"}]',3,'[3]','D','D — D) WAF에 geo match 규칙과 Amazon IP reputation list 관리형 규칙 그룹을 추가한다','["AWS WAF", "Geo Match Rule", "Amazon IP Reputation List", "Amazon CloudFront", "Edge Security"]','AWS WAF, Geo Match Rule, Amazon IP Reputation List, Amazon CloudFront, Edge Security','정답(D): WAF는 geo match로 국가를 제어하고 AWS 관리형 IP reputation 규칙 그룹으로 악성 IP 목록을 자동 갱신된 상태로 사용할 수 있습니다. NACL 수동 CIDR 관리(A)는 유지 부담이 크고 CloudFront 앞단에 적용되지 않으며, Shield Advanced(B)는 DDoS 보호가 목적이고, GuardDuty(C)는 탐지 서비스로 요청을 차단하지 않습니다.

[핵심 아키텍처 포인트] CloudFront에 연결한 WAF에 Geo Match 규칙과 AWS 관리형 Amazon IP Reputation List 규칙 그룹을 적용하면 운영 부담 없이 국가별·악성 IP 차단이 가능합니다.');
INSERT INTO "questions" VALUES(60,4,12,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-105','ko','방화벽 장비 없이 VPC 내부 악성 도메인 DNS 질의 차단 (Route 53 Resolver DNS Firewall)','한 회사는 VPC 내부 워크로드가 악성 도메인에 대한 DNS 조회를 하지 못하게 하려 합니다. VPC Resolver로 들어오는 DNS 질의 수준에서 AWS 관리형 도메인 목록으로 차단하고, 별도의 방화벽 인프라 배포는 피하고 싶습니다. 악성 도메인 목록은 AWS가 지속적으로 갱신해 주기를 원합니다. 무엇을 사용해야 합니까?','[{"key": "A", "text": "AWS WAF를 VPC에 연결해 DNS 질의를 검사한다"}, {"key": "B", "text": "AWS Network Firewall을 배포하고 firewall endpoint로 모든 트래픽을 우회시킨다"}, {"key": "C", "text": "Route 53 Resolver DNS Firewall을 구성하고 관리형 도메인 목록 규칙 그룹을 VPC에 연결한다"}, {"key": "D", "text": "GuardDuty를 활성화해 악성 도메인 질의를 자동으로 막는다"}]',2,'[2]','C','C — C) Route 53 Resolver DNS Firewall을 구성하고 관리형 도메인 목록 규칙 그룹을 VPC에 연결한다','["Route 53 Resolver DNS Firewall", "Managed Domain Lists", "Amazon VPC", "DNS Security", "Outbound Protection"]','Route 53 Resolver DNS Firewall, Managed Domain Lists, Amazon VPC, DNS Security, Outbound Protection','정답(C): Route 53 Resolver DNS Firewall은 VPC의 DNS 질의를 도메인 목록 기준으로 허용·차단하며 관리형 도메인 목록을 제공합니다. WAF(A)는 HTTP 요청용이라 VPC DNS에 연결되지 않고, Network Firewall(B)은 firewall endpoint 배포와 라우팅이 필요하며, GuardDuty(D)는 탐지 서비스입니다.

[핵심 아키텍처 포인트] VPC DNS Resolver 단계에서 AWS 관리형 위협 도메인 목록으로 악성 도메인 질의를 차단하려면 별도 어플라이언스 없이 Route 53 Resolver DNS Firewall을 활성화합니다.');
INSERT INTO "questions" VALUES(61,4,13,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-080','ko','ENI 거부 트래픽 장기 분석 및 SQL 조회 (VPC Flow Logs + S3 + Athena)','운영팀은 EC2 인스턴스에 대한 연결 시도가 실패하는 현상을 조사하며, 거부(REJECT)된 트래픽이 어떤 출발지 IP와 포트에서 얼마나 발생하는지 한 달치 로그로 장기 분석하려 합니다. 운영 비용과 서버 관리 부담은 최소화해야 합니다. 로그는 한 달 이상 보관하고 필요할 때 SQL로 조회해야 합니다. 가장 적절한 방법은 무엇입니까?','[{"key": "A", "text": "VPC Traffic Mirroring으로 모든 패킷을 수집해 별도 분석 서버에서 포트별로 점검한다"}, {"key": "B", "text": "CloudTrail 관리 이벤트를 켜서 거부된 연결 시도의 출발지와 포트를 확인한다"}, {"key": "C", "text": "VPC Flow Logs를 S3로 게시하고 Athena로 REJECT 레코드를 쿼리한다"}, {"key": "D", "text": "GuardDuty findings 목록에서 거부된 트래픽을 조회한다"}]',2,'[2]','C','C — C) VPC Flow Logs를 S3로 게시하고 Athena로 REJECT 레코드를 쿼리한다','["VPC Flow Logs", "Amazon S3", "Amazon Athena", "Network Troubleshooting", "Serverless Analytics"]','VPC Flow Logs, Amazon S3, Amazon Athena, Network Troubleshooting, Serverless Analytics','정답(C): Flow Logs는 ENI 수준의 허용·거부 메타데이터를 기록하며 S3에 저장해 Athena로 서버리스 분석을 할 수 있어 비용 효율적입니다. Traffic Mirroring(A)은 패킷 수집용이라 비용·관리 부담이 크고, CloudTrail(B)은 API 호출만 기록하며, GuardDuty(D)는 위협 탐지 결과만 제공합니다.

[핵심 아키텍처 포인트] VPC Flow Logs를 비용 효율적인 S3로 장기 저장하고 Amazon Athena로 SQL 쿼리하면 서버 관리 없이 REJECT 패킷의 출발지 IP·포트를 분석할 수 있습니다.');
INSERT INTO "questions" VALUES(62,4,14,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-098','ko','DB 비밀번호 저장 없는 단기 토큰 인증 (RDS IAM 데이터베이스 인증)','Lambda 함수와 EC2 애플리케이션이 RDS for PostgreSQL에 접속합니다. 보안팀은 애플리케이션이 DB 비밀번호를 저장하거나 관리하지 않고 IAM 자격 증명으로 만든 단기 토큰으로 인증하길 원합니다. 토큰은 짧은 시간만 유효해야 하고 SSL 연결이 필요합니다. 가장 적절한 방법은 무엇입니까?','[{"key": "A", "text": "DB 비밀번호를 Lambda 환경 변수와 EC2 user data에 저장하고 분기마다 값을 교체한다"}, {"key": "B", "text": "DB 마스터 계정 비밀번호를 SSM Parameter Store에 일반 문자열로 저장하고 애플리케이션이 읽게 한다"}, {"key": "C", "text": "RDS IAM 데이터베이스 인증을 활성화하고 role이 만든 인증 토큰으로 SSL 연결한다"}, {"key": "D", "text": "security group에서 애플리케이션 IP만 허용하고 비밀번호를 코드에 둔다"}]',2,'[2]','C','C — C) RDS IAM 데이터베이스 인증을 활성화하고 role이 만든 인증 토큰으로 SSL 연결한다','["Amazon RDS", "IAM Database Authentication", "TLS/SSL", "Ephemeral Token", "AWS IAM"]','Amazon RDS, IAM Database Authentication, TLS/SSL, Ephemeral Token, AWS IAM','정답(C): IAM DB 인증은 role의 권한으로 15분 유효한 인증 토큰을 만들어 비밀번호 없이 연결하며 SSL이 필요합니다. 환경 변수와 user data(A)는 비밀번호를 저장하는 방식이고, 평문 Parameter Store(B)는 보호가 부족하며, 코드 내 비밀번호(D)는 네트워크 제한만으로 자격 증명 노출을 막지 못합니다.

[핵심 아키텍처 포인트] RDS IAM DB 인증을 활성화하면 IAM 역할 권한으로 발급한 15분 유효 임시 토큰과 SSL 연결을 통해 코드나 환경 변수에 비밀번호를 저장하지 않고 접속합니다.');
INSERT INTO "questions" VALUES(63,4,15,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-025','ko','신속 구축 가능한 온프레미스-AWS 암호화 IPsec 연결 (Site-to-Site VPN)','한 회사가 온프레미스 데이터 센터와 AWS VPC 간에 보안 통신 채널을 구축해야 합니다. 온프레미스 네트워크 사이즈가 작고 지연시간이 중요하지 않으며, 빠른 구성을 원합니다. AWS Direct Connect는 너무 오래 걸린다고 판단했습니다. 가장 적절한 솔루션은 무엇입니까?','[{"key": "A", "text": "Site-to-Site VPN"}, {"key": "B", "text": "AWS Direct Connect"}, {"key": "C", "text": "AWS AppSync를 통한 API 연결"}, {"key": "D", "text": "VPC peering"}]',0,'[0]','A','A — A) Site-to-Site VPN','["AWS Site-to-Site VPN", "IPsec", "Hybrid Networking", "Amazon VPC", "Rapid Deployment"]','AWS Site-to-Site VPN, IPsec, Hybrid Networking, Amazon VPC, Rapid Deployment','Site-to-Site VPN은 인터넷을 통해 IPSec 터널로 보안 연결을 제공하며, 즉시 구성 가능합니다. AWS Direct Connect(B)는 전용 네트워크 연결로 더 빠른 속도와 안정성을 제공하지만 구성에 수주가 걸립니다. AppSync(C)는 GraphQL API 서비스이고, VPC peering(D)은 VPC 간 연결입니다.

[핵심 아키텍처 포인트] 전용선 개통(Direct Connect)에 수 주를 기다릴 수 없고 소규모 트래픽을 빠르게 암호화 연결해야 할 때는 인터넷 기반 IPsec Site-to-Site VPN이 적합합니다.');
INSERT INTO "questions" VALUES(64,4,16,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-026','ko','ALB 앞단 L7 웹 공격(SQLi · XSS) 검사 및 차단 (AWS WAF)','회사의 웹 애플리케이션이 대규모 DDoS 공격을 받고 있습니다. Application Load Balancer 앞단에서 HTTP/HTTPS 계층의 공격(SQL injection, cross-site scripting 등)을 차단해야 합니다. 어떤 AWS 서비스를 사용해야 합니까?','[{"key": "A", "text": "AWS Shield Standard"}, {"key": "B", "text": "AWS WAF"}, {"key": "C", "text": "AWS Shield Advanced"}, {"key": "D", "text": "AWS GuardDuty"}]',1,'[1]','B','B — B) AWS WAF','["AWS WAF", "Application Load Balancer (ALB)", "Layer 7 Security", "XSS", "SQL Injection"]','AWS WAF, Application Load Balancer (ALB), Layer 7 Security, XSS, SQL Injection','AWS WAF는 ALB, CloudFront, API Gateway에 연결되어 L7(애플리케이션) 계층의 SQL injection, XSS 같은 공격을 검사하고 차단합니다. AWS Shield(A, C)는 주로 L3/L4 DDoS 방어이고, GuardDuty(D)는 위협 탐지 및 모니터링 서비스입니다.

[핵심 아키텍처 포인트] L3/L4 DDoS 방어 서비스인 Shield와 달리 HTTP/HTTPS 본문·헤더의 SQLi·XSS 등 애플리케이션 계층(L7) 공격 필터링은 AWS WAF가 담당합니다.');
INSERT INTO "questions" VALUES(65,4,17,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-055','ko','MFA 인증 필수 조건을 강제하는 IAM 역할 신뢰 정책 (aws:MultiFactorAuthPresent)','한 회사는 프로덕션 계정의 PowerAdmin role을 개발자가 필요할 때 임시로 맡게 하고 있습니다. 감사 결과, 비밀번호만 탈취되어도 이 role을 맡을 수 있는 구조가 지적되었습니다. 반드시 MFA로 인증한 세션에서만 role을 assume하도록 강제하려 합니다. 이를 가장 확실하게 구현하는 방법은 무엇입니까?','[{"key": "A", "text": "trust policy에 aws:MultiFactorAuthPresent가 true인 경우만 AssumeRole을 허용하는 조건을 둔다"}, {"key": "B", "text": "개발자 전원에게 가상 MFA 장치를 할당하고 프로덕션 role을 사용할 때 MFA를 쓰도록 권장하는 지침을 배포한다"}, {"key": "C", "text": "프로덕션 계정의 security group에서 MFA 인증을 마친 사용자의 IP 주소만 허용하도록 규칙을 구성한다"}, {"key": "D", "text": "AssumeRole 호출 후 CloudTrail 로그를 분석해 MFA 없이 만들어진 세션을 사후에 찾아 종료한다"}]',0,'[0]','A','A — A) trust policy에 aws:MultiFactorAuthPresent가 true인 경우만 AssumeRole을 허용하는 조건을 둔다','["AWS IAM", "MFA", "Trust Policy", "aws:MultiFactorAuthPresent", "AWS STS"]','AWS IAM, MFA, Trust Policy, aws:MultiFactorAuthPresent, AWS STS','정답(A): trust policy의 aws:MultiFactorAuthPresent 조건은 MFA 없이 로그인한 세션이 role을 assume하지 못하도록 강제합니다. MFA 장치 할당만으로는(B) 사용이 강제되지 않고, security group(C)은 IAM 인증과 무관하며, 사후 분석(D)은 예방 통제가 아닙니다.

[핵심 아키텍처 포인트] 역할 신뢰 정책(Trust Policy)의 Condition에 aws:MultiFactorAuthPresent: true를 명시하면 비밀번호가 탈취되어도 MFA 없이는 AssumeRole할 수 없습니다.');
INSERT INTO "questions" VALUES(66,4,18,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-059','ko','지정 VPC 엔드포인트 경유 요청만 허용하는 S3 버킷 정책 (aws:SourceVpce)','한 회사는 민감한 S3 버킷에 VPC 내부 워크로드만 접근하게 하려 합니다. 인터넷이나 다른 경로로 들어오는 요청은 자격 증명이 유효해도 거부해야 하며, VPC에는 S3 Gateway endpoint가 이미 있습니다. 자격 증명이 유출되어도 VPC 밖에서는 데이터를 읽을 수 없어야 합니다. 가장 적절한 방법은 무엇입니까?','[{"key": "A", "text": "버킷 정책에서 aws:SourceVpce가 해당 endpoint ID가 아닌 요청을 Deny한다"}, {"key": "B", "text": "S3 Gateway endpoint policy에서 해당 버킷만 허용하고 버킷 정책은 변경하지 않는다"}, {"key": "C", "text": "VPC의 NACL에서 S3의 퍼블릭 IP 대역으로 향하는 트래픽을 허용한다"}, {"key": "D", "text": "버킷에 security group을 연결해 VPC CIDR의 요청만 허용한다"}]',0,'[0]','A','A — A) 버킷 정책에서 aws:SourceVpce가 해당 endpoint ID가 아닌 요청을 Deny한다','["Amazon S3", "VPC Gateway Endpoint", "Bucket Policy", "aws:SourceVpce", "Network Isolation"]','Amazon S3, VPC Gateway Endpoint, Bucket Policy, aws:SourceVpce, Network Isolation','정답(A): 버킷 정책의 aws:SourceVpce 조건은 지정한 endpoint를 거치지 않는 요청을 버킷 측에서 거부합니다. endpoint policy만(B) 쓰면 endpoint를 통한 요청만 제어할 뿐 다른 경로의 접근은 막지 못합니다. NACL(C)로는 S3 접근 경로를 제한할 수 없고, S3 버킷에는 security group을 연결할 수 없습니다(D).

[핵심 아키텍처 포인트] S3 버킷 정책에서 StringNotEquals aws:SourceVpce 조건으로 명시적 Deny를 설정하면 유효한 IAM 자격 증명이 있더라도 지정 VPC 엔드포인트를 통하지 않은 모든 접근이 차단됩니다.');
INSERT INTO "questions" VALUES(67,4,19,1,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d1-063','ko','실수 삭제 방지를 위한 KMS CMK 삭제 예약 대기 기간 및 CloudWatch 경보 감시','한 회사가 사용 여부가 불분명한 고객 관리형 KMS 키를 정리하려 합니다. 이 키로 암호화된 데이터가 남아 있다면 영구 손실을 피해야 하고, 실수로 삭제를 요청했을 때 되돌릴 수 있어야 합니다. 삭제된 키로 암호화된 데이터는 복구할 수 없으므로 신중해야 합니다. 보안팀은 감사 로그도 남겨야 합니다. 가장 안전한 절차는 무엇입니까?','[{"key": "A", "text": "KMS DeleteKey API를 호출해 키를 즉시 영구 삭제하고, 문제가 생기면 사전에 받아 둔 키 자료로 복구한다"}, {"key": "B", "text": "키 삭제를 예약해 대기 기간을 두고 키 사용 시도를 CloudWatch 알람으로 감시하며 필요하면 삭제를 취소한다"}, {"key": "C", "text": "키 자동 교체를 활성화해 사용되지 않는 이전 키 구성 요소가 자동으로 삭제되게 하여 키를 정리한다"}, {"key": "D", "text": "키 별칭(alias)을 삭제하면 키도 함께 삭제되므로 별칭부터 삭제한다"}]',1,'[1]','B','B — B) 키 삭제를 예약해 대기 기간을 두고 키 사용 시도를 CloudWatch 알람으로 감시하며 필요하면 삭제를 취소한다','["AWS KMS", "Key Deletion Waiting Period", "Amazon CloudWatch", "Data Protection", "Customer Managed Key"]','AWS KMS, Key Deletion Waiting Period, Amazon CloudWatch, Data Protection, Customer Managed Key','정답(B): KMS 키는 즉시 삭제할 수 없고 7~30일 대기 기간의 pending deletion 상태를 거치며, 이 기간에 사용 시도를 모니터링하고 삭제를 취소할 수 있습니다. 즉시 영구 삭제(A)는 불가능하며 위험하고, 자동 교체(C)는 키 삭제와 무관하고, 별칭 삭제(D)는 키를 삭제하지 않습니다.

[핵심 아키텍처 포인트] KMS CMK는 즉시 삭제되지 않고 7~30일의 예약 대기 기간 동안 비활성(PendingDeletion) 상태로 유지되므로 CloudWatch 경보로 호출 시도를 감시한 뒤 안전하게 취소·확정할 수 있습니다.');
INSERT INTO "questions" VALUES(68,3,19,2,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-116','ko','리전 장애 RPO 수 초·RTO 수 분 달성을 위한 Aurora Global Database + Route 53 장애 조치','Aurora PostgreSQL 기반 3계층 웹 서비스를 us-east-1(기본)에서 운영하며 ap-northeast-2에 DR을 구성하려 합니다. 리전 장애 시 RPO는 수 초, RTO는 수 분이어야 하고, 전환 후에도 사용자는 같은 도메인으로 접속해야 합니다. 앞단 웹 계층은 두 리전에 같은 AMI로 배포할 수 있습니다. 어떤 조치를 조합해야 합니까? (2개 선택)','[{"key": "A", "text": "Aurora 글로벌 데이터베이스에 ap-northeast-2 보조 클러스터를 추가한다"}, {"key": "B", "text": "기본 클러스터의 자동 백업 보존 기간을 35일로 늘린다"}, {"key": "C", "text": "Route 53 장애 조치 레코드와 상태 검사로 기본 리전 ALB에서 DR 리전 ALB로 DNS를 전환한다"}, {"key": "D", "text": "기본 리전의 다른 AZ에 Aurora 복제본을 추가한다"}, {"key": "E", "text": "Route 53 레코드의 TTL을 86400초로 설정해 DNS 조회를 줄인다"}]',NULL,'[0, 2]','A, C','A, C — A) Aurora 글로벌 데이터베이스에 ap-northeast-2 보조 클러스터를 추가한다 / C) Route 53 장애 조치 레코드와 상태 검사로 기본 리전 ALB에서 DR 리전 ALB로 DNS를 전환한다','["Amazon Aurora Global Database", "Amazon Route 53", "Disaster Recovery", "RPO/RTO", "Failover Routing"]','Amazon Aurora Global Database, Amazon Route 53, Disaster Recovery, RPO/RTO, Failover Routing','A과 C가 정답입니다. 글로벌 데이터베이스는 스토리지 수준 복제로 보조 리전 지연이 짧아 RPO가 수 초 수준이고 장애 시 보조 클러스터를 승격할 수 있으며, Route 53 장애 조치가 사용자를 DR 리전 엔드포인트로 전환합니다. B은 백업이라 RPO가 길고, D는 같은 리전 안에 머물러 리전 장애를 막지 못하며, E은 전환을 늦춥니다.
참고: Using switchover or failover in Amazon Aurora Global Database - Amazon Aurora 사용 설명서 및 How health checks work in complex Amazon Route 53 configurations

[핵심 아키텍처 포인트] Aurora Global Database의 스토리지 수준 리전 간 복제로 RPO 수 초를 달성하고, Route 53 상태 검사·장애 조치 레코드로 동일 도메인 트래픽을 DR 리전으로 자동 전환합니다.');
INSERT INTO "questions" VALUES(69,3,20,2,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-140','ko','3개 AZ 교차 트래픽 없는 고가용성 패킷 검사 (GWLB + 다중 AZ ASG + AZ별 GWLBe)','검사 VPC에서 서드파티 방화벽 어플라이언스를 Gateway Load Balancer 뒤에 배포하고 3개 AZ의 애플리케이션 VPC 트래픽을 검사하려 합니다. 한 AZ 장애에도 검사가 중단되지 않고 AZ 간 불필요한 트래픽이 생기지 않아야 합니다. 트래픽은 앞단에서 VPC 라우팅으로 어플라이언스에 전달됩니다. 어떤 구성이 필요합니까? (2개 선택)','[{"key": "A", "text": "어플라이언스 Auto Scaling 그룹을 여러 AZ에 걸쳐 두고 GWLB 대상 그룹의 상태 검사로 비정상 인스턴스를 제외한다"}, {"key": "B", "text": "모든 AZ의 트래픽을 한 AZ의 엔드포인트 하나로 보내 세션을 한곳에서 처리한다"}, {"key": "C", "text": "어플라이언스 앞에 Application Load Balancer를 두고 HTTP 헤더로 트래픽을 라우팅한다"}, {"key": "D", "text": "각 AZ마다 Gateway Load Balancer 엔드포인트를 만들고 해당 AZ 서브넷의 라우팅이 같은 AZ의 엔드포인트를 가리키게 한다"}, {"key": "E", "text": "어플라이언스 인스턴스에 탄력적 IP 주소를 연결하고 라우팅 테이블에서 직접 가리킨다"}]',NULL,'[0, 3]','A, D','A, D — A) 어플라이언스 Auto Scaling 그룹을 여러 AZ에 걸쳐 두고 GWLB 대상 그룹의 상태 검사로 비정상 인스턴스를 제외한다 / D) 각 AZ마다 Gateway Load Balancer 엔드포인트를 만들고 해당 AZ 서브넷의 라우팅이 같은 AZ의 엔드포인트를 가리키게 한다','["Gateway Load Balancer (GWLB)", "GWLB Endpoint", "Inspection VPC", "Multi-AZ", "Auto Scaling"]','Gateway Load Balancer (GWLB), GWLB Endpoint, Inspection VPC, Multi-AZ, Auto Scaling','A과 D가 정답입니다. 어플라이언스를 다중 AZ ASG로 두고 GWLB 상태 검사로 장애 인스턴스를 우회하며, AZ별 엔드포인트로 같은 AZ 안에서 검사해 AZ 독립성과 교차 AZ 트래픽 최소화를 얻습니다. B은 단일 AZ 장애점이며 교차 AZ 트래픽이 생기고, C는 GWLB가 GENEVE로 L3 패킷을 전달하는 방식과 맞지 않고, E은 부하 분산과 장애 우회가 없습니다.
참고: Target groups for your Gateway Load Balancers - Elastic Load Balancing 사용 설명서

[핵심 아키텍처 포인트] 서드파티 방화벽을 다중 AZ Auto Scaling 그룹으로 구성하고 각 AZ마다 GWLB 엔드포인트를 두어 로컬 AZ 내에서 GENEVE로 검사하면 AZ 장애 격리와 교차 AZ 비용 절감을 동시에 얻습니다.');
INSERT INTO "questions" VALUES(70,3,21,2,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-110','ko','SQS-Lambda 부분 배치 실패 격리 및 스로틀 중복 방지 (ReportBatchItemFailures · Visibility Timeout)','SQS Standard 큐를 소스로 하는 Lambda 함수가 배치 크기 10으로 메시지를 처리합니다. 배치에 잘못된 메시지가 1개만 있어도 10개 전체가 재시도되어 정상 메시지가 중복 처리되고, 그 사이 함수가 스로틀되면 메시지가 처리 중에 다시 보입니다. 중복과 불필요한 재시도를 줄이려면 어떤 조치를 해야 합니까? (2개 선택)','[{"key": "A", "text": "DLQ를 제거해 실패한 메시지가 성공할 때까지 계속 재시도되게 한다"}, {"key": "B", "text": "이벤트 소스 매핑에 ReportBatchItemFailures를 활성화하고 실패한 메시지 ID만 반환한다"}, {"key": "C", "text": "큐의 수신 메시지 대기 시간을 0으로 설정해 short polling을 사용한다"}, {"key": "D", "text": "함수에서 예외를 던져 배치 전체를 실패로 보고한다"}, {"key": "E", "text": "큐의 가시성 제한 시간을 함수 제한 시간의 6배 이상으로 설정한다"}]',NULL,'[1, 4]','B, E','B, E — B) 이벤트 소스 매핑에 ReportBatchItemFailures를 활성화하고 실패한 메시지 ID만 반환한다 / E) 큐의 가시성 제한 시간을 함수 제한 시간의 6배 이상으로 설정한다','["Amazon SQS", "AWS Lambda", "ReportBatchItemFailures", "Visibility Timeout", "Partial Batch Response"]','Amazon SQS, AWS Lambda, ReportBatchItemFailures, Visibility Timeout, Partial Batch Response','B과 E가 정답입니다. 부분 배치 응답은 실패한 메시지만 큐에 남기고 성공분은 삭제하며, 가시성 제한 시간을 함수 제한 시간의 6배 이상으로 두면 스로틀 재시도 중에도 메시지가 다시 보이지 않습니다. A은 DLQ가 없어 독성 메시지가 무한 재시도되고, C는 폴링 방식이라 중복과 무관하며, D은 오히려 배치 전체를 재처리합니다.
참고: Handling errors for an SQS event source in Lambda 및 Creating and configuring an Amazon SQS event source mapping - AWS Lambda 개발자 가이드

[핵심 아키텍처 포인트] ReportBatchItemFailures로 실패한 메시지 ID만 반환해 정상 메시지 재처리를 막고, SQS 가시성 제한 시간을 Lambda 타임아웃의 6배 이상으로 설정해 스로틀 재시도 중 중복 수신을 방지합니다.');
INSERT INTO "questions" VALUES(71,3,22,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-142','ko','다중 리전 RPO 0 · 글로벌 강한 일관성 읽기 (DynamoDB MRSC Global Tables)','결제 원장 서비스가 DynamoDB를 us-east-1, us-east-2, us-west-2 세 리전에서 사용합니다. 어느 리전 장애에도 데이터 손실(RPO 0)이 없어야 하며, 어느 리전에서든 강한 일관성 읽기가 항상 최신 값을 반환해야 합니다. 트랜잭션 API는 사용하지 않고 쓰기 지연 증가는 허용됩니다. 리전 간 복제 지연으로 인한 오래된 읽기는 감사 요건상 허용되지 않습니다. 어떤 구성이 적합합니까?','[{"key": "A", "text": "기본(MREC) 모드의 글로벌 테이블을 세 리전에 구성하고 강한 일관성 읽기를 사용한다"}, {"key": "B", "text": "한 리전 테이블에 PITR을 켜고 다른 리전에 주기적으로 복원한다"}, {"key": "C", "text": "DynamoDB Streams와 Lambda로 다른 두 리전 테이블에 쓰기를 복제한다"}, {"key": "D", "text": "다중 리전 강력한 일관성(MRSC) 모드의 글로벌 테이블을 세 리전에 구성한다"}]',3,'[3]','D','D — D) 다중 리전 강력한 일관성(MRSC) 모드의 글로벌 테이블을 세 리전에 구성한다','["Amazon DynamoDB", "Global Tables", "MRSC (Multi-Region Strong Consistency)", "RPO 0", "Multi-Region"]','Amazon DynamoDB, Global Tables, MRSC (Multi-Region Strong Consistency), RPO 0, Multi-Region','D가 정답입니다. MRSC 글로벌 테이블은 쓰기를 최소 한 개의 다른 리전에 동기 복제한 뒤 성공을 반환하고, 모든 리전에서 강한 일관성 읽기가 최신 값을 줍니다(세 리전 구성, 트랜잭션 API 미지원). A은 비동기 복제라 RPO 0과 리전 간 최신 읽기를 보장하지 못하고, B는 복원 주기만큼 유실되며, C은 일관성과 충돌 처리를 직접 구현해야 합니다.
참고: Overview of global tables - AWS Prescriptive Guidance (Using DynamoDB global tables)

[핵심 아키텍처 포인트] 세 리전 구성의 DynamoDB 다중 리전 강력한 일관성(MRSC) 글로벌 테이블은 최소 1개 타 리전 동기 복제 후 쓰기를 완료하므로 리전 장애 시 RPO 0과 전 리전 최신 읽기를 보장합니다.');
INSERT INTO "questions" VALUES(72,3,23,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-139','ko','약 35초 빠른 장애 조치 및 대기 읽기 분산을 위한 RDS Multi-AZ DB 클러스터 전환','RDS for PostgreSQL 운영 DB가 다중 AZ 인스턴스 배포로 실행 중이며, 장애 조치에 1~2분이 걸려 SLA를 위반합니다. 같은 엔진을 유지하면서 장애 조치 시간을 약 35초 수준으로 줄이고 읽기 트래픽도 대기 인스턴스로 분산하고 싶습니다. 데이터 손실은 없어야 합니다. 쓰기 지연 증가는 허용되며 DB 엔진 변경은 허용되지 않습니다. 가장 적합한 방법은 무엇입니까?','[{"key": "A", "text": "기존 다중 AZ 인스턴스에 읽기 전용 복제본을 추가하고 애플리케이션이 복제본으로 장애 조치하게 한다"}, {"key": "B", "text": "Single-AZ로 전환하고 자동 백업 주기를 5분으로 단축한다"}, {"key": "C", "text": "다른 리전에 교차 리전 읽기 전용 복제본을 만들고 장애 시 승격한다"}, {"key": "D", "text": "다중 AZ DB 클러스터 배포로 전환해 서로 다른 AZ의 읽기 가능한 대기 인스턴스 2개를 사용한다"}]',3,'[3]','D','D — D) 다중 AZ DB 클러스터 배포로 전환해 서로 다른 AZ의 읽기 가능한 대기 인스턴스 2개를 사용한다','["Amazon RDS", "Multi-AZ DB Cluster", "Readable Standby", "Fast Failover", "PostgreSQL"]','Amazon RDS, Multi-AZ DB Cluster, Readable Standby, Fast Failover, PostgreSQL','D가 정답입니다. 다중 AZ DB 클러스터는 서로 다른 AZ의 읽기 가능한 대기 인스턴스 2개로 동기 복제하고 보통 35초 안팎에 장애 조치하며 읽기 분산도 가능합니다. A은 복제본이 비동기라 데이터 손실 가능성이 있고 자동 장애 조치 대상이 아니며, B는 가용성을 낮추고, C은 리전 DR용이라 승격이 수동이고 지연이 큽니다.
참고: Choose the right Amazon RDS deployment option: single-AZ instance, Multi-AZ instance, or Multi-AZ database cluster - AWS Database Blog

[핵심 아키텍처 포인트] 단일 대기 인스턴스(1~2분 장애 조치)와 달리 RDS Multi-AZ DB 클러스터는 서로 다른 AZ에 2개의 읽기 가능 대기 인스턴스를 두어 약 35초 내 장애 조치와 읽기 확장을 제공합니다.');
INSERT INTO "questions" VALUES(73,3,24,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-154','ko','단일 AZ NAT 장애 격리 및 교차 AZ 전송 비용 제거 (AZ별 NAT Gateway 분리)','3개 AZ에 걸친 VPC의 프라이빗 서브넷 인스턴스들이 소프트웨어 업데이트를 위해 단일 NAT 게이트웨이(AZ-a의 퍼블릭 서브넷)를 사용합니다. AZ-a에 장애가 나면 다른 AZ의 인스턴스도 아웃바운드 인터넷이 끊깁니다. 트래픽은 AZ마다 비슷하며 NAT 게이트웨이 데이터 처리 요금도 고려해야 합니다. 가용성을 높이면서 AZ 간 데이터 전송은 피하려면 어떻게 구성해야 합니까?','[{"key": "A", "text": "단일 NAT 게이트웨이를 더 큰 대역폭의 NAT 인스턴스로 교체한다"}, {"key": "B", "text": "AZ-a에 NAT 게이트웨이를 하나 더 만들어 모든 프라이빗 서브넷 라우팅 테이블의 기본 경로에 추가한다"}, {"key": "C", "text": "AZ마다 NAT 게이트웨이를 두고 AZ별 프라이빗 라우팅 테이블이 같은 AZ의 NAT를 가리키게 한다"}, {"key": "D", "text": "모든 프라이빗 서브넷에 퍼블릭 IP를 할당하고 인터넷 게이트웨이로 직접 라우팅한다"}]',2,'[2]','C','C — C) AZ마다 NAT 게이트웨이를 두고 AZ별 프라이빗 라우팅 테이블이 같은 AZ의 NAT를 가리키게 한다','["NAT Gateway", "Multi-AZ", "Route Table", "Zonal Isolation", "Amazon VPC"]','NAT Gateway, Multi-AZ, Route Table, Zonal Isolation, Amazon VPC','C가 정답입니다. 영역(zonal) NAT 게이트웨이는 단일 AZ 리소스이므로 AZ마다 하나씩 두고 각 AZ가 로컬 NAT를 쓰게 하면 AZ 장애가 격리되고 교차 AZ 전송도 없습니다. A은 단일 인스턴스라 가용성이 낮고, B는 같은 AZ에 두 개를 둬도 AZ 장애를 막지 못하며 경로 대상은 하나만 지정되고, D은 프라이빗 인스턴스를 직접 노출합니다.
참고: Regional NAT gateways for automatic multi-AZ expansion - Amazon VPC 사용 설명서 (영역 NAT 게이트웨이 AZ별 구성)

[핵심 아키텍처 포인트] NAT Gateway는 단일 AZ 리소스이므로 AZ마다 퍼블릭 서브넷에 별도 NAT Gateway를 배치하고 각 AZ 프라이빗 라우팅 테이블이 동일 AZ NAT를 가리키도록 분리해야 합니다.');
INSERT INTO "questions" VALUES(74,3,25,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-130','ko','부팅 초기화 지연(9분) 최소화 및 상시 비용 절감을 위한 ASG Warm Pool (Stopped)','게임 매치메이킹 서비스의 EC2 인스턴스는 대용량 에셋을 내려받고 캐시를 예열하는 데 약 9분이 걸립니다. 접속이 폭주하면 새 인스턴스가 투입되기까지 지연되어 매치가 실패합니다. 접속 폭주 시점은 사전에 알 수 없습니다. 평소 트래픽은 낮은 편이라 상시 과잉 용량은 허용되지 않습니다. 평소 비용을 크게 늘리지 않으면서 스케일 아웃 지연을 1분 안팎으로 줄이려면 어떻게 해야 합니까?','[{"key": "A", "text": "최소 용량을 최대 부하 수준으로 올려 항상 실행한다"}, {"key": "B", "text": "ASG 웜 풀에 사전 초기화한 인스턴스를 Stopped로 두고 수명 주기 후크로 초기화 완료를 보장한다"}, {"key": "C", "text": "웜 풀을 Running 상태로 구성해 사전 초기화한 인스턴스를 켜 둔 채 대기시키고 스케일 아웃 시 바로 투입한다"}, {"key": "D", "text": "예약 조정으로 매일 정해진 시각에 용량을 미리 늘린다"}]',1,'[1]','B','B — B) ASG 웜 풀에 사전 초기화한 인스턴스를 Stopped로 두고 수명 주기 후크로 초기화 완료를 보장한다','["EC2 Auto Scaling", "Warm Pool", "Lifecycle Hook", "Scale-Out Latency", "Cost Optimization"]','EC2 Auto Scaling, Warm Pool, Lifecycle Hook, Scale-Out Latency, Cost Optimization','B가 정답입니다. 웜 풀의 Stopped 인스턴스는 미리 초기화되어 있어 스케일 아웃 시 빠르게 투입되고 볼륨과 EIP 비용만 발생하며, 수명 주기 후크가 초기화 완료 전 투입을 막습니다. A은 상시 최대 용량 비용이 크고, C는 대기 인스턴스의 컴퓨팅 비용이 계속 들며, D은 예측할 수 없는 폭주에 대응하지 못합니다.
참고: Decrease latency for applications with long boot times using warm pools - Amazon EC2 Auto Scaling 사용 설명서

[핵심 아키텍처 포인트] ASG 웜 풀에 사전 초기화한 인스턴스를 Stopped 상태로 유지하면 컴퓨팅 비용 없이 스토리지 비용만 내면서 급증 시 수명 주기 후크 검증을 거쳐 1분 내 신속 투입할 수 있습니다.');
INSERT INTO "questions" VALUES(75,3,26,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-147','ko','VPC 내부 전용 ALB의 Route 53 프라이빗 호스티드 존 자동 장애 조치 (CloudWatch 경보)','내부 전용 ALB(퍼블릭 IP 없음)로 서비스되는 사내 포털의 기본 사이트를 VPC에서 운영하고, 보조 사이트는 다른 리전에 있습니다. 기본 사이트에 장애가 나면 Route 53 프라이빗 호스티드 존의 레코드가 보조 사이트로 전환되어야 합니다. Route 53 상태 검사기는 VPC 내부 엔드포인트에 접근할 수 없다는 제약이 있습니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "내부 ALB의 DNS 이름을 대상으로 하는 엔드포인트 상태 검사를 만들어 장애 조치 기본 레코드에 연결한다"}, {"key": "B", "text": "기본·보조 레코드에 가중치 라우팅을 적용하고 장애 시 가중치를 수동으로 바꾼다"}, {"key": "C", "text": "ALB 상태를 나타내는 CloudWatch 경보 기반 Route 53 상태 검사를 기본 레코드에 연결한다"}, {"key": "D", "text": "지연 시간 기반 라우팅 레코드를 만들고 상태 검사 없이 TTL을 1초로 설정한다"}]',2,'[2]','C','C — C) ALB 상태를 나타내는 CloudWatch 경보 기반 Route 53 상태 검사를 기본 레코드에 연결한다','["Amazon Route 53", "CloudWatch Alarm", "Private Hosted Zone", "Internal ALB", "Health Check"]','Amazon Route 53, CloudWatch Alarm, Private Hosted Zone, Internal ALB, Health Check','C가 정답입니다. Route 53 상태 검사기는 VPC 밖에 있어 사설 엔드포인트를 직접 점검하지 못하므로, CloudWatch 경보 기반 상태 검사로 내부 상태를 반영해 장애 조치 레코드를 자동 전환합니다. A은 검사기가 내부 엔드포인트에 닿지 못해 항상 실패하고, B는 수동 전환이라 자동 장애 조치가 아니며, D은 상태 정보가 없어 장애 사이트로도 라우팅합니다.
참고: Performing Route 53 health checks on private resources in a VPC with AWS Lambda and Amazon CloudWatch - AWS Networking & Content Delivery Blog

[핵심 아키텍처 포인트] 퍼블릭 Route 53 상태 검사기는 VPC 사설 IP에 직접 닿지 못하므로, 내부 ALB 지표 기반 CloudWatch 경보를 연동한 Route 53 상태 검사로 리전 간 자동 페일오버를 구현합니다.');
INSERT INTO "questions" VALUES(76,3,27,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-129','ko','급격한 20배 트래픽 폭주 흡수용 서버리스 API Gateway-SQS 직접 통합','공개 이벤트 접수 REST API가 행사 때 평소의 20배까지 급증하며, 뒤쪽 레거시 처리 시스템의 처리량은 일정합니다. 클라이언트는 접수 확인(응답 코드 200대)만 받으면 되고 요청은 유실되면 안 됩니다. 접수 요청 본문은 수 KB의 JSON이며, 서버리스로 구현하고 싶어 합니다. 처리 시스템을 확장하지 않고 급증을 흡수하면서 운영 부담을 최소화하는 방법은 무엇입니까?','[{"key": "A", "text": "API Gateway의 스로틀링 한도를 처리 시스템 속도에 맞춰 낮춘다"}, {"key": "B", "text": "API Gateway 캐시를 활성화해 반복 요청을 흡수한다"}, {"key": "C", "text": "API Gateway의 AWS 서비스 통합으로 요청을 SQS에 바로 넣고 처리 시스템이 자체 속도로 소비하게 한다"}, {"key": "D", "text": "ALB 뒤의 EC2 Auto Scaling 그룹에 접수 서버를 두고 서버가 레거시 시스템을 동기 호출한 뒤 응답하게 한다"}]',2,'[2]','C','C — C) API Gateway의 AWS 서비스 통합으로 요청을 SQS에 바로 넣고 처리 시스템이 자체 속도로 소비하게 한다','["Amazon API Gateway", "Amazon SQS", "AWS Service Integration", "Serverless", "Load Leveling"]','Amazon API Gateway, Amazon SQS, AWS Service Integration, Serverless, Load Leveling','C가 정답입니다. SQS가 완충 역할을 해 급증을 흡수하고, 비동기 접수로 요청 유실 없이 즉시 응답할 수 있으며 Lambda나 서버 없이 구성됩니다. A은 한도를 넘는 요청이 429로 거부되어 유실되고, B는 쓰기 요청에는 캐시가 효과가 없으며, D은 동기 호출이라 레거시 시스템이 그대로 병목이고 서버 운영도 늘어납니다.
참고: Integrate Amazon API Gateway with Amazon SQS to handle asynchronous REST APIs - AWS Prescriptive Guidance

[핵심 아키텍처 포인트] API Gateway가 중간 Lambda 없이 SQS로 직접 메시지를 적재하면 클라이언트에게 즉시 200 응답을 반환하면서 백엔드 처리 속도에 맞춰 요청 유실 없이 비동기 처리할 수 있습니다.');
INSERT INTO "questions" VALUES(77,3,28,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-135','ko','고정 IP 제공 + L7 경로 기반 라우팅 동시 충족 (NLB 앞단 → ALB 대상 그룹)','파트너사 방화벽은 접속 대상을 고정 IP 주소로만 허용합니다. 회사의 HTTPS API는 경로 기반 라우팅으로 여러 마이크로서비스(ECS)에 분산되어야 하며 가용 영역 세 곳에 걸쳐 고가용성이어야 합니다. API 호출 클라이언트의 코드 변경은 불가합니다. 파트너는 방화벽 규칙 변경에 몇 주가 걸려 IP 변경이 어렵습니다. 가장 적합한 구성은 무엇입니까?','[{"key": "A", "text": "AZ마다 고정 IP를 가진 Network Load Balancer를 앞단에 두고 ALB를 대상으로 등록한다"}, {"key": "B", "text": "Application Load Balancer만 사용하고 Route 53 별칭 레코드로 노출해 파트너가 도메인 이름으로 접속하게 한다"}, {"key": "C", "text": "Network Load Balancer만 사용하고 URL 경로별 리스너 규칙을 설정한다"}, {"key": "D", "text": "Classic Load Balancer에 탄력적 IP 주소를 연결해 사용한다"}]',0,'[0]','A','A — A) AZ마다 고정 IP를 가진 Network Load Balancer를 앞단에 두고 ALB를 대상으로 등록한다','["Network Load Balancer (NLB)", "Application Load Balancer (ALB)", "Static IP", "Path-Based Routing", "Amazon ECS"]','Network Load Balancer (NLB), Application Load Balancer (ALB), Static IP, Path-Based Routing, Amazon ECS','A가 정답입니다. NLB는 AZ별 고정 IP를 제공하고 ALB를 대상으로 두면 ALB의 경로 기반 라우팅을 함께 쓸 수 있습니다. B은 ALB의 IP가 바뀔 수 있어 허용 목록에 쓸 수 없고, C는 NLB가 L4라 경로 기반 라우팅을 지원하지 않으며, D은 Classic Load Balancer에 탄력적 IP 주소를 연결할 수 없고 경로 라우팅도 불가합니다.
참고: Use an Application Load Balancer as a target of a Network Load Balancer - Elastic Load Balancing 사용 설명서

[핵심 아키텍처 포인트] NLB에 AZ별 탄력적 IP를 부여해 파트너 방화벽 고정 IP 요건을 충족하고, NLB의 대상으로 ALB를 연결하면 ECS 마이크로서비스의 L7 경로 기반 라우팅까지 함께 활용할 수 있습니다.');
INSERT INTO "questions" VALUES(78,3,29,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-124','ko','큐 폴링 없는 Lambda 비동기 호출 실패 보상 처리 (On-Failure Destination)','S3 이벤트로 비동기 호출되는 Lambda 함수가 이미지를 처리합니다. 재시도를 모두 소진하고 실패한 이벤트는 별도 큐나 폴링 구성 없이 다른 Lambda 함수로 직접 전달되어 보상 처리와 알림을 수행해야 합니다. 이 함수는 이미지 처리에 실패하면 고객에게 사과 알림을 보내야 하며, 실패 건은 하루 수십 건 수준입니다. 가장 적합한 방법은 무엇입니까?','[{"key": "A", "text": "함수에 SQS 데드 레터 큐를 구성하고 보상 처리 함수가 큐를 폴링하게 한다"}, {"key": "B", "text": "함수의 비동기 호출 설정에서 실패 시(on-failure) 대상을 보상 처리 Lambda 함수로 지정한다"}, {"key": "C", "text": "함수 코드의 try/catch에서 보상 처리 함수를 동기 호출한다"}, {"key": "D", "text": "MaximumRetryAttempts를 0으로 설정하고 CloudWatch 경보로 알림만 보내 운영자가 수동으로 보상 처리하게 한다"}]',1,'[1]','B','B — B) 함수의 비동기 호출 설정에서 실패 시(on-failure) 대상을 보상 처리 Lambda 함수로 지정한다','["AWS Lambda", "Asynchronous Invocation", "Lambda Destinations", "On-Failure", "Error Handling"]','AWS Lambda, Asynchronous Invocation, Lambda Destinations, On-Failure, Error Handling','B가 정답입니다. 비동기 호출의 on-failure destination은 재시도가 소진된 실패 이벤트를 Lambda 함수 등으로 직접 전달하므로 큐나 폴링 없이 보상 처리를 시작할 수 있습니다. A은 큐와 이벤트 소스 매핑을 따로 구성해야 하고, C는 타임아웃·크래시처럼 코드가 실행되지 못하는 실패를 놓치며, D은 실패 이벤트를 보존·전달하지 못합니다.
참고: How Lambda handles errors and retries with asynchronous invocation - AWS Lambda 개발자 가이드

[핵심 아키텍처 포인트] S3 등 비동기 호출 Lambda에서 재시도 소진 실패를 별도 SQS 폴링 없이 후속 처리하려면 비동기 호출 설정의 on-failure 대상에 보상 처리 Lambda 함수를 직접 지정합니다.');
INSERT INTO "questions" VALUES(79,3,30,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-113','ko','120개 조직 계정 다중 리전 표준 인프라 자동 배포 (CloudFormation StackSets)','AWS Organizations의 Workloads OU에는 계정 120개가 있고 매주 새 계정이 추가됩니다. 모든 계정의 us-east-1과 eu-west-1에 보안 로깅용 IAM 역할과 CloudWatch 로그 그룹을 일관되게 배포해야 하며, 새 계정에는 사람이 개입하지 않아도 자동 적용되어야 합니다. 가장 운영 오버헤드가 적은 방법은 무엇입니까?','[{"key": "A", "text": "자체 관리형 권한 StackSet을 만들고 계정마다 실행 역할을 수동으로 생성한다"}, {"key": "B", "text": "계정 생성 이벤트로 실행되는 Lambda가 AssumeRole로 각 계정에 스택을 만들게 한다"}, {"key": "C", "text": "서비스 관리형 권한의 CloudFormation StackSet을 OU 대상으로 만들고 자동 배포를 활성화한다"}, {"key": "D", "text": "관리 계정의 CloudFormation 중첩 스택 하나에 모든 계정과 리전의 리소스를 정의해 한 번의 스택 생성으로 배포한다"}]',2,'[2]','C','C — C) 서비스 관리형 권한의 CloudFormation StackSet을 OU 대상으로 만들고 자동 배포를 활성화한다','["AWS CloudFormation", "StackSets", "Service-Managed Permissions", "AWS Organizations", "Automated Deployment"]','AWS CloudFormation, StackSets, Service-Managed Permissions, AWS Organizations, Automated Deployment','C가 정답입니다. 서비스 관리형 StackSet은 Organizations와 통합되어 대상 계정에 필요한 IAM 역할을 자동 구성하고, 자동 배포가 OU에 새로 들어온 계정에 스택을 만듭니다. A은 계정마다 역할을 수동 준비해야 하고, B는 스크립트를 직접 유지해야 하며, D은 스택이 하나의 계정·리전 범위라 다른 계정에 배포할 수 없습니다.
참고: Create CloudFormation StackSets with service-managed permissions - AWS CloudFormation 사용 설명서

[핵심 아키텍처 포인트] 서비스 관리형 권한의 CloudFormation StackSets를 OU에 연결하고 자동 배포를 활성화하면 별도 IAM 역할 수동 생성 없이 신규 추가 계정에도 자동 적용됩니다.');
INSERT INTO "questions" VALUES(80,3,31,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-141','ko','계획된 리전 점검 시 데이터 손실 없는 Aurora Global Database Switchover','Aurora MySQL 글로벌 데이터베이스의 기본 리전(us-east-1)이 예정된 리전 점검 때문에 일시 중단됩니다. 데이터 손실 없이 쓰기 리전을 ap-northeast-2로 옮기고, 점검이 끝나면 되돌릴 수 있어야 합니다. 두 리전 모두 정상 상태입니다. 점검 시간 중에도 보조 리전의 읽기 서비스는 계속 유지됩니다. 어떤 작업을 해야 합니까?','[{"key": "A", "text": "글로벌 데이터베이스의 failover를 수행해 보조 리전 클러스터를 승격한다"}, {"key": "B", "text": "글로벌 데이터베이스의 switchover를 수행해 보조 리전 클러스터를 기본으로 승격한다"}, {"key": "C", "text": "보조 클러스터를 글로벌 데이터베이스에서 분리(detach)해 독립 클러스터로 승격한다"}, {"key": "D", "text": "us-east-1 클러스터의 스냅샷을 ap-northeast-2로 복사해 새 클러스터를 복원한다"}]',1,'[1]','B','B — B) 글로벌 데이터베이스의 switchover를 수행해 보조 리전 클러스터를 기본으로 승격한다','["Amazon Aurora Global Database", "Switchover", "RPO 0", "Planned Maintenance", "Multi-Region"]','Amazon Aurora Global Database, Switchover, RPO 0, Planned Maintenance, Multi-Region','B가 정답입니다. switchover는 보조 클러스터를 먼저 동기화한 뒤 역할을 교체해 RPO가 0이며, 두 리전이 정상일 때의 계획된 이전에 쓰고 복제 토폴로지를 유지해 되돌릴 수 있습니다. A은 비계획 장애용이라 복제 지연만큼 데이터가 유실될 수 있고, C는 복제 관계를 끊어 되돌리기 어렵고, D은 스냅샷 이후 쓰기가 유실되고 시간이 오래 걸립니다.
참고: Using switchover or failover in Amazon Aurora Global Database - Amazon Aurora 사용 설명서

[핵심 아키텍처 포인트] 양쪽 리전이 모두 정상인 계획된 쓰기 리전 전환에는 Failover 대신 Switchover를 사용해야 먼저 동기화를 완료해 RPO 0을 보장하고 기존 복제 토폴로지를 유지해 원복할 수 있습니다.');
INSERT INTO "questions" VALUES(81,3,32,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-156','ko','AD 통합 · NTFS ACL · 다중 AZ 자동 장애 조치 지원 완전 관리형 SMB (FSx for Windows)','Active Directory에 가입된 Windows 애플리케이션 서버 50대가 SMB 파일 공유를 사용하며 NTFS ACL과 DFS 네임스페이스를 유지해야 합니다. 파일 서버를 AWS로 옮기되 AZ 장애 시 수동 개입 없이 자동 장애 조치되어야 하고 서버 패치는 관리하고 싶지 않습니다. 가장 적합한 서비스는 무엇입니까?','[{"key": "A", "text": "Amazon EFS를 여러 AZ 마운트 대상으로 구성해 Windows 서버가 SMB로 접근하게 한다"}, {"key": "B", "text": "서로 다른 AZ에 EC2 Windows 파일 서버 두 대를 두고 DFS 복제를 직접 구성한다"}, {"key": "C", "text": "Amazon FSx for Windows File Server를 다중 AZ 배포로 구성한다"}, {"key": "D", "text": "Amazon FSx for Lustre 영구 파일 시스템을 구성한다"}]',2,'[2]','C','C — C) Amazon FSx for Windows File Server를 다중 AZ 배포로 구성한다','["Amazon FSx for Windows File Server", "Multi-AZ", "Active Directory", "SMB", "NTFS ACL"]','Amazon FSx for Windows File Server, Multi-AZ, Active Directory, SMB, NTFS ACL','C가 정답입니다. FSx for Windows File Server는 완전 관리형 SMB 파일 시스템으로 AD 통합, NTFS ACL, DFS를 지원하고 다중 AZ 배포가 대기 파일 서버로 자동 장애 조치합니다. A은 EFS가 NFS 기반이라 Windows SMB 요구를 충족하지 못하고, B는 패치와 복제를 직접 운영해야 하며, D은 HPC용 Linux 파일 시스템입니다.
참고: What is Amazon FSx for Windows File Server? - Amazon FSx for Windows File Server 사용 설명서

[핵심 아키텍처 포인트] Active Directory 도메인 가입·NTFS ACL·DFS 네임스페이스와 다중 AZ 자동 페일오버가 필요한 Windows 파일 워크로드는 완전 관리형 FSx for Windows File Server가 정답입니다.');
INSERT INTO "questions" VALUES(82,3,33,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-150','ko','DNS 변경 없는 S3 리전 장애 자동 전환 (S3 CRR + CloudFront Origin Group Failover)','정적 자산과 이미지 API 응답을 CloudFront로 제공하며 원본은 us-east-1의 S3 버킷입니다. 이 리전에 장애가 나도 뷰어의 GET 요청은 us-west-2의 복제 버킷에서 자동으로 응답되어야 하며, DNS 변경이나 애플리케이션 변경은 하지 않으려 합니다. 복구 목표는 사람이 개입하지 않는 자동 전환입니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "S3 CRR로 복제 버킷을 두고 CloudFront 원본 그룹에 두 버킷을 기본·보조 원본으로 등록한다"}, {"key": "B", "text": "배포를 두 개 만들고 Route 53 장애 조치 레코드로 전환한다"}, {"key": "C", "text": "S3 버전 관리를 켜서 기본 버킷 객체를 보존한다"}, {"key": "D", "text": "CloudFront TTL을 24시간으로 늘려 원본 장애 중에도 엣지 캐시에서 오래된 콘텐츠로 응답하게 한다"}]',0,'[0]','A','A — A) S3 CRR로 복제 버킷을 두고 CloudFront 원본 그룹에 두 버킷을 기본·보조 원본으로 등록한다','["Amazon CloudFront", "Origin Failover", "Origin Group", "S3 Cross-Region Replication (CRR)", "High Availability"]','Amazon CloudFront, Origin Failover, Origin Group, S3 Cross-Region Replication (CRR), High Availability','A가 정답입니다. 원본 그룹은 기본 원본이 지정한 상태 코드로 실패하면 GET·HEAD·OPTIONS 요청을 보조 원본으로 자동 전환하고, CRR이 보조 버킷에 같은 객체를 유지합니다. B은 배포와 DNS를 추가로 관리해야 하고, C는 같은 리전 장애에 도움이 되지 않으며, D은 캐시되지 않은 객체와 만료 이후 요청을 처리하지 못합니다.
참고: Optimize high availability with CloudFront origin failover - Amazon CloudFront 개발자 가이드

[핵심 아키텍처 포인트] S3 CRR로 보조 리전 버킷을 동기화하고 CloudFront 오리진 그룹에 기본·보조 S3 오리진을 등록하면 5xx 오류 시 뷰어 GET/HEAD 요청이 DNS 변경 없이 자동 전환됩니다.');
INSERT INTO "questions" VALUES(83,3,34,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-119','ko','주문 단위 순서 보장 및 다수 컨슈머 병렬 처리 (SQS FIFO MessageGroupId)','전자상거래 플랫폼의 주문 상태 변경 이벤트(결제 완료, 배송 시작 등)는 같은 주문 안에서는 반드시 순서대로 처리해야 하지만, 서로 다른 주문은 병렬로 처리해 처리량을 높여야 합니다. 컨슈머는 Auto Scaling 그룹의 여러 인스턴스입니다. 컨슈머 인스턴스 수는 트래픽에 따라 늘고 줄며, 하루 주문은 수백만 건입니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "SQS FIFO 큐를 사용하고 모든 메시지에 동일한 MessageGroupId를 지정한다"}, {"key": "B", "text": "SQS FIFO 큐를 사용하고 MessageGroupId에 주문 ID를 지정한다"}, {"key": "C", "text": "SQS Standard 큐를 사용하고 메시지에 순번 속성을 넣어 컨슈머가 정렬해 처리한다"}, {"key": "D", "text": "주문마다 SQS FIFO 큐를 하나씩 생성하고 컨슈머가 모든 큐를 폴링한다"}]',1,'[1]','B','B — B) SQS FIFO 큐를 사용하고 MessageGroupId에 주문 ID를 지정한다','["Amazon SQS", "SQS FIFO", "MessageGroupId", "Ordered Processing", "Parallel Consumers"]','Amazon SQS, SQS FIFO, MessageGroupId, Ordered Processing, Parallel Consumers','B가 정답입니다. FIFO는 같은 메시지 그룹 안에서 순서를 보장하고 서로 다른 그룹은 여러 컨슈머가 병렬 처리하므로, 주문 ID를 그룹으로 쓰면 요구를 충족합니다. A은 모든 메시지가 한 그룹이라 사실상 직렬 처리되고, C는 Standard가 순서와 중복을 보장하지 않아 컨슈머가 복잡해지며, D은 큐 수가 폭증해 관리할 수 없습니다.
참고: Using the message group ID with Amazon SQS FIFO Queues - Amazon SQS 개발자 가이드

[핵심 아키텍처 포인트] SQS FIFO 큐에서 주문 ID를 MessageGroupId로 지정하면 동일 주문 내 메시지는 엄격히 순차 처리되고 서로 다른 주문 그룹은 ASG 워커들이 병렬로 소비할 수 있습니다.');
INSERT INTO "questions" VALUES(84,4,20,2,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-128','ko','다중 계정 태그 기반 중앙 백업 및 변조 방지 보관 (AWS Backup 정책 + Vault Lock)','AWS Organizations의 40개 계정에서 RDS, EBS, DynamoDB 리소스를 태그 기준으로 매일 백업하고, 백업 사본을 중앙 보안 계정의 다른 리전 볼트에 보관해야 합니다. 개별 계정 관리자가 백업 정책을 임의로 변경하지 못해야 하며 운영 오버헤드는 최소여야 합니다. 어떤 조치를 해야 합니까? (2개 선택)','[{"key": "A", "text": "Organizations에서 AWS Backup 정책을 만들어 OU에 연결하고 중앙 계정 볼트로의 교차 계정·교차 리전 복사 규칙을 포함한다"}, {"key": "B", "text": "계정마다 백업 계획을 수동으로 만들고 담당자가 주기적으로 설정을 점검한다"}, {"key": "C", "text": "각 계정에서 Data Lifecycle Manager로 EBS 스냅샷만 예약하고 다른 리전으로 복사한다"}, {"key": "D", "text": "각 계정의 리소스를 S3로 내보내 교차 리전 복제를 구성한다"}, {"key": "E", "text": "AWS Backup에서 교차 계정 백업을 활성화하고 중앙 계정의 대상 볼트에 Vault Lock을 설정한다"}]',NULL,'[0, 4]','A, E','A, E — A) Organizations에서 AWS Backup 정책을 만들어 OU에 연결하고 중앙 계정 볼트로의 교차 계정·교차 리전 복사 규칙을 포함한다 / E) AWS Backup에서 교차 계정 백업을 활성화하고 중앙 계정의 대상 볼트에 Vault Lock을 설정한다','["AWS Backup", "AWS Organizations", "Backup Policy", "Cross-Account Backup", "Vault Lock"]','AWS Backup, AWS Organizations, Backup Policy, Cross-Account Backup, Vault Lock','A과 E가 정답입니다. Organizations 백업 정책은 OU 전체에 백업 계획과 복사 규칙을 일괄 적용해 개별 변경을 막고, 교차 계정 백업과 Vault Lock은 중앙 볼트에 변조되지 않는 사본을 보관합니다. B은 계정별 수작업이라 오버헤드가 크고, C는 EBS만 다뤄 RDS·DynamoDB가 빠지며, D은 AWS Backup의 복구 지점 관리 기능을 쓰지 못합니다.
참고: Automate centralized backup at scale across AWS services using AWS Backup - AWS Storage Blog

[핵심 아키텍처 포인트] Organizations Backup 정책을 OU에 연결해 멤버 계정의 정책 변경을 차단하고, 교차 계정 복사와 Vault Lock으로 중앙 보안 계정의 타 리전 볼트에 불변 백업을 보관합니다.');
INSERT INTO "questions" VALUES(85,4,21,2,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-134','ko','Amazon EKS 단일 AZ 장애 대비 다중 AZ 노드 그룹 + Pod Topology Spread Constraints','Amazon EKS에서 결제 API를 3개 AZ에 걸쳐 운영합니다. 현재 파드가 한 AZ의 노드에 몰려 있어 해당 AZ에 장애가 나면 서비스 전체가 중단됩니다. 파드는 현재 노드 2대에만 배치되어 있고 스토리지는 사용하지 않는 상태 없는 서비스입니다. AZ 하나가 사라져도 서비스가 유지되도록 하려면 어떤 변경을 해야 합니까? (2개 선택)','[{"key": "A", "text": "통신 지연을 줄이기 위해 podAffinity로 모든 파드를 같은 AZ에 모은다"}, {"key": "B", "text": "관리형 노드 그룹이 3개 AZ의 서브넷에 걸쳐 노드를 생성하도록 구성한다"}, {"key": "C", "text": "가장 큰 인스턴스 유형 노드 하나에 모든 파드를 배치한다"}, {"key": "D", "text": "Deployment에 topology.kubernetes.io/zone 기준의 topologySpreadConstraints를 설정해 파드를 AZ에 분산한다"}, {"key": "E", "text": "하나의 EBS 볼륨을 모든 AZ의 파드가 동시에 공유 마운트하도록 구성한다"}]',NULL,'[1, 3]','B, D','B, D — B) 관리형 노드 그룹이 3개 AZ의 서브넷에 걸쳐 노드를 생성하도록 구성한다 / D) Deployment에 topology.kubernetes.io/zone 기준의 topologySpreadConstraints를 설정해 파드를 AZ에 분산한다','["Amazon EKS", "Multi-AZ", "Managed Node Groups", "Topology Spread Constraints", "High Availability"]','Amazon EKS, Multi-AZ, Managed Node Groups, Topology Spread Constraints, High Availability','B과 D가 정답입니다. 노드가 여러 AZ에 있어야 하고, 토폴로지 분산 제약으로 파드 복제본이 AZ에 고르게 배치되어야 한 AZ를 잃어도 나머지에서 처리합니다. A은 오히려 단일 AZ에 집중시키고, C는 단일 노드 장애점이 되며, E은 EBS 볼륨이 단일 AZ에 묶여 다른 AZ에서 마운트할 수 없습니다.
참고: Designing for HA and resiliency in Amazon EKS applications - AWS Prescriptive Guidance

[핵심 아키텍처 포인트] EKS 관리형 노드 그룹을 3개 AZ 서브넷에 배치하고 Deployment에 topology.kubernetes.io/zone 분산 제약을 지정해야 파드가 여러 AZ에 고르게 분산되어 단일 AZ 장애를 견딥니다.');
INSERT INTO "questions" VALUES(86,4,22,2,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-152','ko','단일 AZ 장애 시에도 피크 용량(12대) 유지를 위한 다중 AZ N+1 용량 산정 (18대)','ASG와 ALB로 운영하는 웹 계층을 us-east-1의 3개 AZ에 배포합니다. 피크 시 필요한 인스턴스는 12대이고, AZ 하나가 완전히 장애가 나도 피크 부하를 계속 처리해야 하며 비용은 합리적으로 유지해야 합니다. 인스턴스는 모두 동일한 유형이며 AZ 간 데이터 전송 비용도 고려해야 합니다. 목표 가용성은 단일 AZ 장애 허용입니다. 어떤 구성이 적합합니까? (2개 선택)','[{"key": "A", "text": "ASG가 3개 AZ의 서브넷에 걸쳐 인스턴스를 균등 분산하게 하고 ALB도 3개 AZ에서 활성화한다"}, {"key": "B", "text": "한 AZ를 잃어도 12대가 유지되도록 AZ당 6대씩 총 18대 수준으로 목표 용량과 최소 용량을 설정한다"}, {"key": "C", "text": "비용 절감을 위해 AZ당 4대씩 총 12대만 유지하고 AZ 장애 시 확장을 기다린다"}, {"key": "D", "text": "모든 인스턴스를 한 AZ에 배치하고 EBS 스냅샷을 다른 AZ에 복사한다"}, {"key": "E", "text": "ALB를 단일 AZ 서브넷에만 연결해 교차 AZ 트래픽을 없앤다"}]',NULL,'[0, 1]','A, B','A, B — A) ASG가 3개 AZ의 서브넷에 걸쳐 인스턴스를 균등 분산하게 하고 ALB도 3개 AZ에서 활성화한다 / B) 한 AZ를 잃어도 12대가 유지되도록 AZ당 6대씩 총 18대 수준으로 목표 용량과 최소 용량을 설정한다','["EC2 Auto Scaling", "Application Load Balancer (ALB)", "Multi-AZ", "Capacity Planning", "Fault Tolerance"]','EC2 Auto Scaling, Application Load Balancer (ALB), Multi-AZ, Capacity Planning, Fault Tolerance','A과 B가 정답입니다. 다중 AZ 분산과 ALB 다중 AZ 활성화로 AZ 장애를 격리하고, 한 AZ가 사라져도 남은 두 AZ가 피크를 감당하도록 사전 용량(N+1)을 확보해야 합니다. C은 AZ 장애 시 용량이 8대로 줄어 피크를 못 견디고, D는 단일 AZ 장애점이며, E은 ALB가 단일 AZ 장애점이 됩니다.
참고: AWS Well-Architected Framework - Reliability Pillar

[핵심 아키텍처 포인트] 3개 AZ 중 1개 AZ가 완전히 소실되어도 피크 12대를 즉시 처리하려면 각 AZ에 6대씩 총 18대를 사전 분산 배치해 AZ 장애 시 남은 2개 AZ로 부하를 감당해야 합니다.');
INSERT INTO "questions" VALUES(87,4,23,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-151','ko','RPO 5분 · RTO 30분 최소 상시 비용 DR 전략 (Pilot Light)','SaaS 회사의 주문 시스템(ALB, EC2 Auto Scaling, Aurora MySQL)은 us-east-1에서 운영됩니다. DR 요건은 RPO 5분 이내, RTO 30분 이내이며 DR 리전 비용은 최소여야 합니다. 평소 DR 리전에 애플리케이션 서버를 상시 가동할 필요는 없습니다. 어떤 DR 전략이 가장 적합합니까?','[{"key": "A", "text": "백업 및 복원: 매일 스냅샷을 DR 리전으로 복사하고 장애 시 DB를 복원한다"}, {"key": "B", "text": "웜 스탠바이: DR 리전에 축소된 전체 스택을 상시 가동하다가 장애 시 Auto Scaling으로 운영 규모까지 확장한다"}, {"key": "C", "text": "멀티 사이트 액티브/액티브: 두 리전 모두 전체 용량으로 트래픽을 처리한다"}, {"key": "D", "text": "파일럿 라이트: 데이터는 Aurora 글로벌 데이터베이스로 복제하고 서버 계층은 장애 시 기동한다"}]',3,'[3]','D','D — D) 파일럿 라이트: 데이터는 Aurora 글로벌 데이터베이스로 복제하고 서버 계층은 장애 시 기동한다','["Disaster Recovery", "Pilot Light", "Aurora Global Database", "RPO/RTO", "EC2 Auto Scaling"]','Disaster Recovery, Pilot Light, Aurora Global Database, RPO/RTO, EC2 Auto Scaling','D가 정답입니다. 파일럿 라이트는 핵심 데이터를 계속 복제하고 서버 계층은 장애 시 기동해 RPO 5분과 RTO 30분을 충족하면서 평시 비용이 가장 낮습니다. A은 RPO가 백업 주기에 묶여 요건을 못 맞추고, B는 요건은 만족하지만 평시 서버 비용이 더 들며, C은 과잉 설계로 비용이 가장 큽니다.
참고: Disaster recovery options in the cloud - Disaster Recovery of Workloads on AWS: Recovery in the Cloud

[핵심 아키텍처 포인트] 파일럿 라이트(Pilot Light)는 Aurora 글로벌 DB 등 핵심 데이터만 상시 복제하고 웹·앱 컴퓨팅 계층은 장애 시에만 기동하여 5분 RPO·30분 RTO와 최소 평시 비용을 만족합니다.');
INSERT INTO "questions" VALUES(88,4,24,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-126','ko','다수 마이크로서비스 팬아웃 순서·중복제거 보장 (SNS FIFO → SQS FIFO)','재고 서비스, 정산 서비스, 분석 서비스가 같은 주문 이벤트를 각각 독립적으로 받아야 하며, 같은 주문의 이벤트는 각 서비스에서 순서대로 중복 없이 처리되어야 합니다. 서비스가 일시 중단되어도 이벤트는 유실되면 안 됩니다. 각 서비스의 처리 속도가 서로 다르고 한 서비스의 지연이 다른 서비스에 영향을 주면 안 됩니다. 가장 적합한 아키텍처는 무엇입니까?','[{"key": "A", "text": "SNS FIFO 토픽에 서비스별 SQS FIFO 큐를 구독시키고 주문 ID를 메시지 그룹 ID로 사용한다"}, {"key": "B", "text": "SNS 표준 토픽에 서비스별 SQS FIFO 큐를 구독시키고 각 큐에서 메시지 그룹 ID로 순서를 맞춘다"}, {"key": "C", "text": "하나의 SQS FIFO 큐를 세 서비스가 함께 폴링하도록 한다"}, {"key": "D", "text": "SNS FIFO 토픽에 세 서비스의 HTTPS 엔드포인트를 직접 구독시킨다"}]',0,'[0]','A','A — A) SNS FIFO 토픽에 서비스별 SQS FIFO 큐를 구독시키고 주문 ID를 메시지 그룹 ID로 사용한다','["Amazon SNS", "SNS FIFO", "Amazon SQS", "SQS FIFO", "Event-Driven Architecture"]','Amazon SNS, SNS FIFO, Amazon SQS, SQS FIFO, Event-Driven Architecture','A가 정답입니다. SNS FIFO 토픽은 메시지 그룹별 순서와 중복 제거를 유지하며 SQS 큐로 팬아웃하고, 큐가 서비스 중단 동안 메시지를 보관합니다. B은 표준 토픽이 FIFO 큐 순서를 보장하지 못하고, C는 메시지를 한 서비스만 소비해 팬아웃이 되지 않으며, D은 FIFO 토픽이 HTTP(S) 엔드포인트로 전달하지 못합니다.
참고: Amazon SNS message delivery for FIFO topics - Amazon SNS 개발자 가이드

[핵심 아키텍처 포인트] SNS FIFO 토픽에 서비스별 SQS FIFO 큐를 구독시키고 MessageGroupId를 통일하면 각 서비스가 독립적 속도로 유실 없이, 주문 단위 순서와 중복 제거를 유지하며 소비합니다.');
INSERT INTO "questions" VALUES(89,4,25,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-131','ko','주기 변동 웹 트래픽 선제적 용량 확보 (Predictive Scaling + Target Tracking)','B2B 웹 애플리케이션은 평일 오전 9시에 사용량이 가파르게 오르고 주말에는 낮습니다. 패턴은 반복되지만 매주 규모가 조금씩 달라 고정된 예약 값은 맞지 않습니다. 인스턴스 시작에 몇 분이 걸려 오전 9시 직후 응답이 느립니다. 운영팀은 코드나 애플리케이션 변경을 원하지 않으며 서버 비용도 신경 씁니다. 코드 변경 없이 부하가 오르기 전에 용량을 확보하려면 무엇을 사용해야 합니까?','[{"key": "A", "text": "CPU 임계값 기준의 단순 조정(simple scaling) 정책을 구성하고 쿨다운을 늘려 불필요한 확장을 줄인다"}, {"key": "B", "text": "예약된 작업으로 매일 오전 8시 50분에 고정 용량으로 늘린다"}, {"key": "C", "text": "예측 조정(predictive scaling) 정책을 활성화하고 목표 추적 정책과 함께 사용한다"}, {"key": "D", "text": "단계 조정(step scaling)의 경보 임계값을 낮춰 더 일찍 확장하게 한다"}]',2,'[2]','C','C — C) 예측 조정(predictive scaling) 정책을 활성화하고 목표 추적 정책과 함께 사용한다','["EC2 Auto Scaling", "Predictive Scaling", "Target Tracking", "Proactive Scaling", "Machine Learning"]','EC2 Auto Scaling, Predictive Scaling, Target Tracking, Proactive Scaling, Machine Learning','C가 정답입니다. 예측 조정은 과거 부하 이력으로 주기적 패턴을 예측해 수요가 오르기 전에 용량을 늘리고, 목표 추적이 예상 밖 변동을 보완합니다. A과 D은 반응형이라 부하가 오른 뒤에야 확장하고, B는 주말과 주별 규모 차이를 반영하지 못해 용량이 부족하거나 남습니다.
참고: Predictive scaling for Amazon EC2 Auto Scaling - Amazon EC2 Auto Scaling 사용 설명서

[핵심 아키텍처 포인트] 요일·주별 규모 변동이 있는 반복 패턴은 과거 지표를 학습해 부하 급증 전 인스턴스를 미리 기동하는 예측 조정(Predictive Scaling)과 목표 추적을 조합하는 것이 최선입니다.');
INSERT INTO "questions" VALUES(90,4,26,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-132','ko','스케일 인 종료 전 작업 정리 및 로그 업로드 보장 (ASG Terminating:Wait 수명 주기 후크)','Auto Scaling 그룹의 인스턴스는 종료되기 전에 처리 중인 작업 큐를 비우고 로컬 로그를 S3에 업로드해야 합니다. 현재는 스케일 인 때 인스턴스가 즉시 종료되어 로그가 유실됩니다. 스케일 인은 하루에도 여러 번 발생하며 정리에는 최대 10분이 걸립니다. 애플리케이션 코드를 크게 바꾸지 않고 종료를 일정 시간 보류하려면 어떻게 해야 합니까?','[{"key": "A", "text": "모든 인스턴스에 스케일 인 보호를 영구적으로 설정해 작업 중인 인스턴스가 종료되지 않게 한다"}, {"key": "B", "text": "종료 전환에 수명 주기 후크를 추가하고 정리 후 CompleteLifecycleAction을 호출한다"}, {"key": "C", "text": "스케일링 정책의 쿨다운 시간을 늘린다"}, {"key": "D", "text": "종료 정책을 OldestInstance로 변경한다"}]',1,'[1]','B','B — B) 종료 전환에 수명 주기 후크를 추가하고 정리 후 CompleteLifecycleAction을 호출한다','["EC2 Auto Scaling", "Lifecycle Hooks", "CompleteLifecycleAction", "Graceful Shutdown", "Amazon S3"]','EC2 Auto Scaling, Lifecycle Hooks, CompleteLifecycleAction, Graceful Shutdown, Amazon S3','B가 정답입니다. Terminating:Wait 수명 주기 후크는 인스턴스를 대기 상태로 두어 정리 스크립트가 끝난 뒤 종료되게 하며, 시간 초과에는 기본 결과가 적용됩니다. A은 스케일 인 자체를 막아 비용이 늘고, C는 확장·축소 간격만 조절하며, D은 어떤 인스턴스를 종료할지 정할 뿐 종료를 지연시키지 않습니다.
참고: Amazon EC2 Auto Scaling lifecycle hooks - Amazon EC2 Auto Scaling 사용 설명서

[핵심 아키텍처 포인트] ASG 종료 전환에 수명 주기 후크(Terminating:Wait)를 설정하면 인스턴스 종료를 최대 10분 이상 보류하여 큐 비우기 및 S3 로그 업로드를 완료한 뒤 안전하게 종료할 수 있습니다.');
INSERT INTO "questions" VALUES(91,4,27,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-149','ko','UDP 게임 서버 DNS 캐시 무관 초고속 리전 장애 조치 (AWS Global Accelerator)','UDP 기반 실시간 멀티플레이어 게임 서버가 us-east-1과 eu-west-1에서 NLB 뒤에 운영됩니다. 클라이언트에는 고정 IP를 배포해야 하고, DNS 캐시와 TTL에 관계없이 한 리전의 엔드포인트가 비정상이면 짧은 시간 안에 다른 리전으로 트래픽이 전환되어야 합니다. 서비스 중단 허용 시간은 수십 초 이내입니다. 어떤 서비스를 사용해야 합니까?','[{"key": "A", "text": "Route 53 지연 시간 레코드에 상태 검사를 연결하고 TTL을 60초로 설정한다"}, {"key": "B", "text": "AWS Global Accelerator에 두 리전의 NLB를 엔드포인트로 등록한다"}, {"key": "C", "text": "Amazon CloudFront 배포에서 두 리전의 NLB를 원본 그룹으로 구성한다"}, {"key": "D", "text": "리전마다 탄력적 IP 주소를 할당하고 클라이언트가 장애 시 다른 IP로 직접 재시도하게 한다"}]',1,'[1]','B','B — B) AWS Global Accelerator에 두 리전의 NLB를 엔드포인트로 등록한다','["AWS Global Accelerator", "Anycast Static IP", "UDP", "Network Load Balancer (NLB)", "Multi-Region Failover"]','AWS Global Accelerator, Anycast Static IP, UDP, Network Load Balancer (NLB), Multi-Region Failover','B가 정답입니다. Global Accelerator는 고정 애니캐스트 IP를 제공하고 엔드포인트 상태에 따라 트래픽을 정상 리전으로 DNS 캐시와 무관하게 전환하며 UDP도 지원합니다. A은 클라이언트와 리졸버의 DNS 캐싱에 의존하고 고정 IP도 없으며, C는 HTTP(S) 콘텐츠 전송용이라 UDP 게임 트래픽에 맞지 않고, D은 클라이언트 구현 부담이 크고 자동 전환이 아닙니다.
참고: AWS Global Accelerator FAQs

[핵심 아키텍처 포인트] Global Accelerator는 고정 애니캐스트 IP 2개를 제공하며 DNS TTL/캐싱에 구애받지 않고 엔드포인트 상태 검사 실패 시 수 초 내 정상 리전 NLB로 UDP·TCP 트래픽을 전환합니다.');
INSERT INTO "questions" VALUES(92,4,28,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-155','ko','Transit Gateway + Direct Connect 장애 시 BGP 동적 VPN 자동 백업 페일오버','회사는 us-east-1의 여러 VPC를 Transit Gateway로 묶고 온프레미스와 단일 AWS Direct Connect 연결로 통신합니다. Direct Connect 장애 시 수동 작업 없이 VPN으로 자동 전환되고 복구되면 Direct Connect로 되돌아가야 합니다. 비용은 최소로 하려 합니다. 가장 적합한 구성은 무엇입니까?','[{"key": "A", "text": "Direct Connect 게이트웨이를 TGW에 연결하고 BGP 동적 라우팅 VPN을 TGW에 백업으로 붙인다"}, {"key": "B", "text": "정적 라우트 VPN을 Transit Gateway에 연결하고 Direct Connect 장애 시 운영자가 라우팅 테이블을 직접 수정해 전환한다"}, {"key": "C", "text": "두 번째 Direct Connect 연결을 같은 로케이션에 추가한다"}, {"key": "D", "text": "VPC마다 별도의 Site-to-Site VPN 연결을 만들어 백업 경로로 사용하고 Transit Gateway는 사용하지 않는다"}]',0,'[0]','A','A — A) Direct Connect 게이트웨이를 TGW에 연결하고 BGP 동적 라우팅 VPN을 TGW에 백업으로 붙인다','["AWS Direct Connect", "AWS Transit Gateway", "Site-to-Site VPN", "BGP Routing", "Hybrid Failover"]','AWS Direct Connect, AWS Transit Gateway, Site-to-Site VPN, BGP Routing, Hybrid Failover','A가 정답입니다. BGP 동적 라우팅 VPN은 경로 광고 변화에 따라 Direct Connect 장애 시 자동 전환·복구되고, Transit Gateway 하나로 모든 VPC에 백업을 제공해 저렴합니다. B은 수동 개입이 필요하고, C는 같은 로케이션 장애에 취약하며 비용이 높고, D은 VPC마다 VPN을 운영해야 해 관리 부담이 큽니다.
참고: Maximum resiliency - AWS Direct Connect 사용 설명서

[핵심 아키텍처 포인트] Direct Connect 게이트웨이와 BGP 동적 라우팅 Site-to-Site VPN을 모두 Transit Gateway에 연결하면 전용선 장애 시 수동 개입 없이 다수 VPC가 자동 VPN 백업으로 전환됩니다.');
INSERT INTO "questions" VALUES(93,4,29,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-143','ko','DynamoDB 실수 대량 삭제 직전 시점 무중단 정밀 복구 (PITR 새 테이블 복원)','DynamoDB 주문 테이블에서 운영자가 어제 오후 3시 20분경 실수로 항목 수천 개를 삭제했습니다. 테이블은 글로벌 테이블이며 PITR이 켜져 있고, 야간 온디맨드 백업은 새벽 2시에 실행됩니다. 삭제 직전 시점의 데이터를 가능한 한 정확히 복구하되 현재 운영 테이블은 그대로 두고 검증하려 합니다. 어떤 방법이 적합합니까?','[{"key": "A", "text": "새벽 2시 온디맨드 백업을 새 테이블로 복원하고 이후 발생한 변경은 포기한 채 복원본을 운영 테이블로 사용한다"}, {"key": "B", "text": "다른 리전의 글로벌 테이블 복제본에서 삭제된 항목을 읽어 복구한다"}, {"key": "C", "text": "PITR로 삭제 직전 시각의 새 테이블을 복원하고 필요한 항목만 운영 테이블에 반영한다"}, {"key": "D", "text": "DynamoDB Streams 레코드를 7일 전부터 재생해 테이블을 되돌린다"}]',2,'[2]','C','C — C) PITR로 삭제 직전 시각의 새 테이블을 복원하고 필요한 항목만 운영 테이블에 반영한다','["Amazon DynamoDB", "PITR (Point-in-Time Recovery)", "Global Tables", "Data Recovery", "Operational Safety"]','Amazon DynamoDB, PITR (Point-in-Time Recovery), Global Tables, Data Recovery, Operational Safety','C가 정답입니다. PITR은 보존 기간 안의 임의 시점으로 새 테이블에 복원하므로 삭제 직전 상태를 정확히 얻고 운영 테이블은 유지됩니다. A은 새벽 이후 변경이 모두 유실되고, B는 글로벌 테이블이 삭제까지 복제해 복제본에도 항목이 없으며, D은 Streams 보존이 24시간이라 과거 변경 전체를 재생할 수 없습니다.
참고: Backup and restore for DynamoDB - Amazon DynamoDB 개발자 가이드

[핵심 아키텍처 포인트] 글로벌 테이블은 삭제 이벤트도 전 리전에 복제하므로, PITR로 삭제 직전 초 단위 시각의 별도 테이블을 복원해 검증 후 누락 항목만 운영 테이블에 반영해야 합니다.');
INSERT INTO "questions" VALUES(94,4,30,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-054','ko','이벤트 시스템별 독립 소비 및 조건부 수신 필터링 (SNS Filter Policy + SQS)','전자상거래 회사는 주문 완료 이벤트를 결제 분석, 재고 갱신, 배송 알림 세 시스템이 각자 받도록 하려 합니다. 배송 시스템은 국내 주문만 처리하고, 각 시스템은 장애 때 메시지를 잃지 않고 자기 속도로 소비해야 합니다. 국내 주문 외의 알림은 배송 시스템에 전달되지 않아야 합니다. 가장 적절한 아키텍처는 무엇입니까?','[{"key": "A", "text": "하나의 SQS 큐에 발행하고 세 시스템이 같은 큐를 함께 폴링하며 메시지를 나눠 가진다"}, {"key": "B", "text": "SNS 주제의 HTTP 엔드포인트로 세 시스템을 직접 구독시키고 필터링은 각 시스템 코드에서 처리한다"}, {"key": "C", "text": "SNS 주제에 발행하고 시스템별 SQS를 구독시켜 배송 큐에만 국내 주문 필터를 둔다"}, {"key": "D", "text": "Kinesis 데이터 스트림 샤드 하나에 발행하고 각 시스템이 같은 샤드를 폴링해 필요한 이벤트를 고른다"}]',2,'[2]','C','C — C) SNS 주제에 발행하고 시스템별 SQS를 구독시켜 배송 큐에만 국내 주문 필터를 둔다','["Amazon SNS", "SNS Subscription Filter Policy", "Amazon SQS", "Fan-Out", "Decoupling"]','Amazon SNS, SNS Subscription Filter Policy, Amazon SQS, Fan-Out, Decoupling','C가 정답입니다. SNS fan-out과 SQS 조합은 메시지를 내구성 있게 보관하고 시스템별로 독립 소비하며 필터 정책으로 서버 측 필터링합니다. A는 메시지를 경쟁 소비해 서로 나눠 가지며, B는 소비자가 장애 시 메시지를 잃을 수 있고, D는 필터링과 독립 소비 요건을 충족하지 않습니다.

[핵심 아키텍처 포인트] SNS 토픽 팬아웃으로 서비스별 SQS 큐를 구독시키고 배송 큐에 구독 필터 정책(Filter Policy)을 적용하면 소비자 코드 수정 없이 서버 측에서 국내 주문만 선별 전달합니다.');
INSERT INTO "questions" VALUES(95,4,31,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-090','ko','RTO 15분 · RPO 1분 축소 스택 상시 가동 DR 전략 (Warm Standby)','결제 서비스는 RTO 15분, RPO 1분 이내를 목표로 합니다. 즉시 전체 규모를 처리하지는 못해도 DR 리전에서 축소된 완전한 환경이 상시 실행되어 있다가 장애 시 빠르게 확장해 인계받는 방식이 비용상 적절합니다. 장애 시 트래픽이 급증해도 Auto Scaling으로 빠르게 확장할 수 있어야 합니다. 어떤 전략이 가장 적절합니까?','[{"key": "A", "text": "Warm standby"}, {"key": "B", "text": "Backup and restore"}, {"key": "C", "text": "Pilot light"}, {"key": "D", "text": "Multi-site active-active"}]',0,'[0]','A','A — A) Warm standby','["Disaster Recovery", "Warm Standby", "RTO/RPO", "Auto Scaling", "Multi-Region"]','Disaster Recovery, Warm Standby, RTO/RPO, Auto Scaling, Multi-Region','A가 정답입니다. warm standby는 축소된 전체 스택이 항상 실행되어 있어 장애 시 확장만 하면 되므로 분 단위 RTO를 낮은 비용으로 달성합니다. B와 C는 컴퓨팅을 처음부터 기동해야 해 15분이 어렵고, D는 요구보다 과도한 비용입니다.

[핵심 아키텍처 포인트] Warm Standby는 DR 리전에 축소된 전체 애플리케이션 스택을 상시 가동해 두어 장애 시 스케일 아웃만으로 분 단위 RTO(15분)를 Active-Active 대비 저렴하게 달성합니다.');
INSERT INTO "questions" VALUES(96,4,32,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-074','ko','1초 미만 리전 간 복제 지연 Aurora 관계형 DB DR (Aurora Global Database)','글로벌 SaaS 회사는 us-east-1의 Aurora PostgreSQL을 사용하며 리전 전체 장애에 대비해 ap-northeast-2에 읽기 전용 복제본을 두고 일반적으로 1초 미만의 복제 지연으로 장애 조치(승격)하려 합니다. 애플리케이션 코드 변경은 최소화해야 합니다. 어떤 기능이 가장 적합합니까?','[{"key": "A", "text": "Aurora 클러스터에서 cross-region 스냅샷 복사를 매시간 실행하도록 예약한다"}, {"key": "B", "text": "RDS 다중 AZ 인스턴스 배포를 사용해 다른 AZ에 동기 스탠바이를 둔다"}, {"key": "C", "text": "Aurora Global Database를 구성하고 보조 리전 클러스터를 추가한다"}, {"key": "D", "text": "AWS DMS 태스크를 두 리전 사이에 수동으로 구성해 지속적으로 복제한다"}]',2,'[2]','C','C — C) Aurora Global Database를 구성하고 보조 리전 클러스터를 추가한다','["Amazon Aurora Global Database", "Cross-Region Replication", "Disaster Recovery", "Sub-Second Replication", "PostgreSQL"]','Amazon Aurora Global Database, Cross-Region Replication, Disaster Recovery, Sub-Second Replication, PostgreSQL','C가 정답입니다. Aurora Global Database는 스토리지 계층 복제로 보통 1초 미만의 지연을 제공하고 보조 리전을 승격해 리전 장애에 대응합니다. A는 RPO가 시간 단위이고, B는 같은 리전 내 AZ 장애만 보호하며, D는 복잡하고 지연이 큽니다.

[핵심 아키텍처 포인트] Aurora Global Database는 전용 스토리지 복제 인프라를 통해 보통 1초 미만의 지연으로 보조 리전 클러스터를 유지하며 리전 장애 시 신속히 승격할 수 있습니다.');
INSERT INTO "questions" VALUES(97,4,33,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-055','ko','누락 SaaS 이벤트 특정 기간 재처리 (Amazon EventBridge Archive & Replay)','SaaS 파트너 시스템에서 발생한 결제 이벤트에 따라 서로 다른 AWS 서비스를 호출하고, 실수로 누락된 이벤트를 최근 7일치 중 특정 기간만 다시 재생해 테스트해야 합니다. 폴링이나 커스텀 통합 코드는 최소화하려 합니다. 운영 팀은 별도 폴링 코드나 사용자 지정 통합 서버를 만들고 싶지 않습니다. 가장 적절한 서비스는 무엇입니까?','[{"key": "A", "text": "EventBridge 파트너 이벤트 소스와 규칙을 쓰고 이벤트 아카이브와 재생 기능을 활성화한다"}, {"key": "B", "text": "Amazon SQS 표준 큐에 이벤트를 보관하고 소비자가 직접 처리한 오프셋을 기억해 두었다가 다시 읽는다"}, {"key": "C", "text": "Amazon SNS 주제에 이벤트를 발행하고 구독자가 필요하면 과거 메시지를 다시 요청해 재생한다"}, {"key": "D", "text": "Kinesis Data Firehose로 이벤트를 S3에 적재한 뒤 대상 기간의 객체를 직접 파싱해 재처리한다"}]',0,'[0]','A','A — A) EventBridge 파트너 이벤트 소스와 규칙을 쓰고 이벤트 아카이브와 재생 기능을 활성화한다','["Amazon EventBridge", "Event Archive and Replay", "SaaS Partner Integration", "Event-Driven Architecture", "Serverless"]','Amazon EventBridge, Event Archive and Replay, SaaS Partner Integration, Event-Driven Architecture, Serverless','A가 정답입니다. EventBridge는 SaaS 파트너 이벤트를 규칙으로 여러 대상에 라우팅하며 아카이브된 이벤트를 선택한 기간만 재생할 수 있습니다. B는 소비한 메시지를 다시 재생하는 기능이 없고, C는 저장·재생 기능이 없으며, D는 라우팅과 재생을 직접 만들어야 합니다.

[핵심 아키텍처 포인트] EventBridge 파트너 이벤트 버스에 이벤트 아카이브를 활성화하면 별도 저장 파이프라인 없이 원하는 과거 시간 범위의 이벤트만 규칙으로 재전송(Replay)할 수 있습니다.');
INSERT INTO "questions" VALUES(98,4,34,2,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d2-043','ko','장기 수동 승인 포함 서버리스 오케스트레이션 (Step Functions Wait for Task Token)','주문 처리 워크플로는 재고 확인, 결제, 배송 요청 단계로 이루어지며 결제 승인에는 관리자의 수동 승인이 최대 며칠 걸릴 수 있습니다. 각 단계의 재시도와 오류 처리를 코드 없이 정의하고 서버를 관리하지 않으려 합니다. 주문 건마다 단계 상태를 추적해야 하고 감사 목적으로 실행 이력도 확인할 수 있어야 합니다. 가장 적합한 구성은 무엇입니까?','[{"key": "A", "text": "Lambda 함수 하나가 모든 단계를 순서대로 실행하고 관리자 승인이 날 때까지 함수 안에서 대기한다"}, {"key": "B", "text": "AWS Step Functions Express 워크플로로 모든 단계를 실행하고 승인을 며칠 동안 기다리게 한다"}, {"key": "C", "text": "Step Functions Standard 워크플로를 쓰고 승인 단계는 작업 토큰 콜백 패턴으로 구현한다"}, {"key": "D", "text": "Amazon SQS 큐 세 개를 만들고 각 단계의 워커가 서로의 큐를 폴링해 다음 단계를 진행한다"}]',2,'[2]','C','C — C) Step Functions Standard 워크플로를 쓰고 승인 단계는 작업 토큰 콜백 패턴으로 구현한다','["AWS Step Functions", "Callback Pattern", "Task Token", "Serverless Workflow", "Error Handling"]','AWS Step Functions, Callback Pattern, Task Token, Serverless Workflow, Error Handling','C가 정답입니다. Standard 워크플로는 장기 실행을 지원하고 콜백 패턴으로 사람의 승인을 기다리며 재시도·Catch를 선언적으로 정의합니다. A는 Lambda 최대 실행 시간 제한이 있고, B는 Express의 실행 시간이 짧아 며칠 대기가 불가능하며, D는 오류 처리와 상태 추적을 직접 구현해야 합니다.

[핵심 아키텍처 포인트] Step Functions Standard 워크플로는 최대 1년 실행을 지원하며 작업 토큰 콜백 패턴(.waitForTaskToken)으로 수일이 걸리는 사람 승인 대기를 컴퓨팅 과금 없이 처리합니다.');
INSERT INTO "questions" VALUES(99,3,35,3,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-098','ko','관리형 MSK 리전 간 복제 및 서버리스 S3 내보내기 (MSK Replicator + MSK Connect)','스트리밍 플랫폼 팀이 Amazon MSK Provisioned 클러스터로 주문 이벤트를 처리합니다. 요구사항은 두 가지입니다. 첫째, 재해 복구를 위해 다른 리전의 MSK 클러스터로 토픽 데이터를 지속 복제해야 합니다. 둘째, 토픽 데이터를 S3로 계속 내보내야 하며, 커넥터를 실행할 서버나 워커 노드를 직접 관리하지 않으려 합니다. 이 요구사항을 가장 적은 운영 부담으로 충족하는 조합은 무엇입니까? (2개 선택)','[{"key": "A", "text": "MSK Replicator로 소스 클러스터의 토픽을 다른 리전의 MSK 클러스터로 복제한다"}, {"key": "B", "text": "EC2 인스턴스에 MirrorMaker 2를 설치하고 Auto Scaling 그룹으로 실행해 리전 간 복제를 수행한다"}, {"key": "C", "text": "토픽을 소비해 다른 리전의 Kinesis Data Streams에 다시 쓰는 Lambda 함수를 이벤트 소스 매핑으로 실행한다"}, {"key": "D", "text": "MSK Connect에 S3 sink 커넥터를 배포해 토픽 데이터를 S3로 전달한다"}, {"key": "E", "text": "S3 버킷에 Cross-Region Replication을 설정하고 MSK 브로커의 로컬 디스크를 S3에 마운트해 보관한다"}]',NULL,'[0, 3]','A, D','A, D — A) MSK Replicator로 소스 클러스터의 토픽을 다른 리전의 MSK 클러스터로 복제한다 / D) MSK Connect에 S3 sink 커넥터를 배포해 토픽 데이터를 S3로 전달한다','["Amazon MSK", "MSK Replicator", "MSK Connect", "Amazon S3", "Apache Kafka"]','Amazon MSK, MSK Replicator, MSK Connect, Amazon S3, Apache Kafka','A: MSK Replicator가 관리형으로 클러스터 간(리전 간 포함) 데이터를 복제합니다. D: MSK Connect가 커넥터 실행 인프라를 관리해 S3 연동에 서버 운영이 필요 없습니다. B의 MirrorMaker 2는 EC2 운영 부담이 있고, C의 Lambda 재전송은 코드 개발이 필요하며, E처럼 브로커 디스크를 S3에 마운트하는 방식은 존재하지 않습니다.
참고: Welcome to the Amazon MSK Developer Guide

[핵심 아키텍처 포인트] 워커 서버 관리 없이 MSK 토픽을 타 리전으로 복제하려면 MSK Replicator를 사용하고, S3로 지속 내보내려면 관리형 Kafka Connect 런타임인 MSK Connect S3 싱크 커넥터를 씁니다.');
INSERT INTO "questions" VALUES(100,3,36,3,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-125','ko','분산 LLM 학습 GPU 간 초저지연 OS 우회 통신 (EFA + Libfabric + 단일 AZ 서브넷)','회사는 대규모 언어 모델 학습 비용과 시간을 줄이려 하며 클러스터 구성은 AWS 문서의 권장 사항을 따르려 합니다. 머신러닝 팀이 여러 GPU 인스턴스로 분산 학습을 실행하며 NCCL을 사용해 인스턴스 간 통신 성능을 높이려 합니다. 학습 클러스터는 단일 VPC에서 실행되며 가용성보다 학습 속도가 우선입니다. EFA를 올바르게 적용하는 방법은 무엇입니까? (2개 선택)','[{"key": "A", "text": "학습 인스턴스를 서로 다른 세 AZ에 분산하고 AZ 사이에서 EFA 트래픽을 주고받게 한다"}, {"key": "B", "text": "EFA를 지원하는 인스턴스 유형에 EFA 인터페이스를 연결하고 NCCL이 Libfabric을 통해 EFA를 사용하게 한다"}, {"key": "C", "text": "EFA는 시간당 별도 요금이 부과되므로 학습 시간이 짧을 때만 연결한다"}, {"key": "D", "text": "인스턴스를 같은 AZ의 같은 서브넷에 두어 EFA 트래픽이 AZ와 서브넷 경계를 넘지 않게 한다"}, {"key": "E", "text": "다른 VPC의 학습 인스턴스와 VPC 피어링을 만들어 EFA 트래픽을 라우팅한다"}]',NULL,'[1, 3]','B, D','B, D — B) EFA를 지원하는 인스턴스 유형에 EFA 인터페이스를 연결하고 NCCL이 Libfabric을 통해 EFA를 사용하게 한다 / D) 인스턴스를 같은 AZ의 같은 서브넷에 두어 EFA 트래픽이 AZ와 서브넷 경계를 넘지 않게 한다','["Elastic Fabric Adapter (EFA)", "Libfabric", "NCCL", "Distributed ML Training", "Amazon EC2"]','Elastic Fabric Adapter (EFA), Libfabric, NCCL, Distributed ML Training, Amazon EC2','B: EFA는 Libfabric 기반의 OS 우회 통신을 제공하며 NCCL과 MPI를 지원합니다. D: EFA 트래픽은 AZ나 VPC를 넘을 수 없고 라우팅되지 않아 같은 AZ·서브넷에 두어야 합니다. 다중 AZ 분산과 VPC 피어링 라우팅은 불가능하며, EFA는 추가 비용 없이 사용할 수 있습니다.
참고: Elastic Fabric Adapter for AI/ML and HPC workloads on Amazon EC2

[핵심 아키텍처 포인트] EFA는 Libfabric OS 우회 통신으로 GPU 분산 학습(NCCL) 지연을 극소화하며, 라우팅되지 않는 특성상 반드시 같은 AZ·같은 서브넷 내에 인스턴스를 배치해야 동작합니다.');
INSERT INTO "questions" VALUES(101,3,37,3,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-144','ko','초당 수십만 요청 경량 엣지 변환 (CloudFront Functions 캐시 키·헤더·리다이렉트)','트래픽은 전 세계에서 발생하며 피크에는 초당 수십만 요청이 들어옵니다. 엣지 로직 비용을 줄이라는 요구도 있습니다. CDN 팀이 CloudFront 엣지 로직을 정리합니다. 요청량이 매우 많아 비용과 지연을 최소화해야 하며, 로직은 요청 정보만 다루는 가벼운 변환입니다. 다음 중 CloudFront Functions로 구현하기에 적합한 작업은 무엇입니까? (2개 선택)','[{"key": "A", "text": "요청 시 AWS SDK로 DynamoDB를 조회해 사용자 권한 정보를 읽어 응답에 반영한다"}, {"key": "B", "text": "수 초가 걸리는 이미지 변환을 수행해 응답으로 반환한다"}, {"key": "C", "text": "쿼리 문자열 정렬과 불필요한 파라미터 제거로 캐시 키를 정규화해 캐시 적중률을 높인다"}, {"key": "D", "text": "응답 헤더에 보안 헤더를 추가하고 요청 URL을 다른 경로로 리다이렉트한다"}, {"key": "E", "text": "POST 요청 본문을 읽어 외부 결제 서비스로 전달한다"}]',NULL,'[2, 3]','C, D','C, D — C) 쿼리 문자열 정렬과 불필요한 파라미터 제거로 캐시 키를 정규화해 캐시 적중률을 높인다 / D) 응답 헤더에 보안 헤더를 추가하고 요청 URL을 다른 경로로 리다이렉트한다','["Amazon CloudFront", "CloudFront Functions", "Cache Key Normalization", "Security Headers", "Edge Compute"]','Amazon CloudFront, CloudFront Functions, Cache Key Normalization, Security Headers, Edge Compute','C와 D는 CloudFront Functions가 맞는 사례(캐시 키 정규화, 헤더 조작, URL 리다이렉트·재작성)입니다. DynamoDB 조회와 외부 서비스 호출은 네트워크 접근이, 본문 처리는 요청 본문 접근이, 이미지 변환은 긴 실행 시간이 필요해 Lambda@Edge 영역입니다.
참고: Differences between CloudFront Functions and Lambda@Edge

[핵심 아키텍처 포인트] 네트워크나 본문 접근이 불필요한 쿼리 파라미터 정렬(캐시 키 정규화), 보안 헤더 추가, URL 리다이렉트는 서브밀리초 지연·초저비용의 CloudFront Functions가 적합합니다.');
INSERT INTO "questions" VALUES(102,3,38,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-118','ko','단일 AZ 클러스터 인식 소프트웨어 동시 블록 쓰기 (EBS io2 Multi-Attach)','온프레미스 클러스터 소프트웨어를 AWS로 옮기는 프로젝트이며 이전 후에도 소프트웨어 구조는 바꿀 수 없습니다. 고가용성 클러스터 소프트웨어를 쓰는 회사가 같은 AZ의 EC2 인스턴스 두 대에서 하나의 데이터 볼륨에 동시에 읽고 쓰려 합니다. 이 소프트웨어는 쓰기 순서와 I/O 펜싱을 직접 관리하며 블록 디바이스 수준 공유와 서브밀리초 지연이 필요합니다. 어떤 구성이 요구를 충족합니까?','[{"key": "A", "text": "io2 볼륨에 Multi-Attach를 활성화하고 두 Nitro 인스턴스에 연결한 뒤 클러스터 인식 파일 시스템을 사용한다"}, {"key": "B", "text": "gp3 볼륨에 Multi-Attach를 활성화하고 두 인스턴스에 연결한 뒤 XFS로 포맷한다"}, {"key": "C", "text": "Amazon EFS 파일 시스템을 두 인스턴스에 마운트하고 NFS로 공유한다"}, {"key": "D", "text": "하나의 EBS 볼륨을 두 인스턴스에 번갈아 연결·분리하는 스크립트를 failover 시 실행하고 파일 시스템을 마운트 해제한 뒤 다시 마운트한다"}]',0,'[0]','A','A — A) io2 볼륨에 Multi-Attach를 활성화하고 두 Nitro 인스턴스에 연결한 뒤 클러스터 인식 파일 시스템을 사용한다','["Amazon EBS", "EBS Multi-Attach", "io2", "Nitro System", "Cluster-Aware File System"]','Amazon EBS, EBS Multi-Attach, io2, Nitro System, Cluster-Aware File System','A: Multi-Attach는 io1/io2 볼륨을 같은 AZ의 최대 16개 Nitro 인스턴스에 연결하며 NVMe 예약으로 I/O 펜싱을 지원하고, XFS·EXT4 같은 표준 파일 시스템 대신 클러스터 파일 시스템이 필요합니다. gp3는 Multi-Attach 미지원이고, EFS는 블록 디바이스가 아니며, 번갈아 연결하는 방식은 동시 쓰기를 제공하지 않습니다.
참고: Attach an EBS volume to multiple EC2 instances using Multi-Attach

[핵심 아키텍처 포인트] 동시 블록 디바이스 쓰기와 NVMe I/O 펜싱이 필요한 클러스터 인식 SW는 같은 AZ의 Nitro 인스턴스들에 io2 Multi-Attach 볼륨을 연결해 서브밀리초 성능을 제공합니다.');
INSERT INTO "questions" VALUES(103,3,39,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-140','ko','멀티스레드 단순 객체 캐시 수평 확장 (ElastiCache for Memcached)','인프라 비용 최적화를 검토 중입니다. 웹 포털이 렌더링된 HTML 조각과 세션 외 단순 객체를 key-value로 캐시합니다. 데이터는 언제든 다시 만들 수 있어 복제나 영속성은 필요 없고, 코어가 많은 큰 노드를 활용하는 멀티스레드 처리와 수요에 따른 노드 수 자유로운 증감을 원합니다. 모델은 가능한 한 단순해야 합니다. 어떤 엔진이 적합합니까?','[{"key": "A", "text": "Valkey(클러스터 모드 활성화)로 샤드와 복제본을 구성한다"}, {"key": "B", "text": "ElastiCache for Memcached 클러스터를 구성한다"}, {"key": "C", "text": "Amazon MemoryDB로 영속성을 갖춘 클러스터를 구성하고 다중 AZ 복제를 켠다"}, {"key": "D", "text": "DynamoDB와 DAX를 구성해 캐시 계층으로 사용한다"}]',1,'[1]','B','B — B) ElastiCache for Memcached 클러스터를 구성한다','["Amazon ElastiCache", "Memcached", "Multi-Threaded Caching", "Horizontal Scaling", "In-Memory Cache"]','Amazon ElastiCache, Memcached, Multi-Threaded Caching, Horizontal Scaling, In-Memory Cache','B: Memcached는 단순한 key-value 모델, 멀티스레드 지원, 노드 추가·제거를 통한 수평 확장이 특징이라 재생성 가능한 객체 캐시에 맞습니다. Valkey 클러스터는 복제·영속성 같은 불필요한 기능과 단일 스레드 모델을, MemoryDB는 영속 데이터베이스용이라 단순 캐시에 과잉이며, DAX는 DynamoDB 전용입니다.
참고: Comparing node-based Valkey, Memcached, and Redis OSS clusters (Amazon ElastiCache)

[핵심 아키텍처 포인트] 복제·영속성이나 복합 자료구조가 불필요한 재생성 가능 객체 캐시는 멀티스레드 아키텍처로 대형 코어 노드 활용과 노드 증감이 자유로운 Memcached가 최적입니다.');
INSERT INTO "questions" VALUES(104,3,40,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-139','ko','실시간 게임 리더보드 및 다중 AZ 장애 조치 (ElastiCache Valkey/Redis Sorted Set)','게임 출시 이벤트 기간에는 동시 접속자가 급증하며 리더보드는 1초 이내에 갱신되어 보여야 합니다. 모바일 게임 회사가 실시간 리더보드로 상위 100명의 점수를 점수순으로 보여주고 점수는 초당 수천 번 갱신됩니다. AZ 장애가 나도 캐시 데이터가 유지되고 자동으로 장애 조치되어야 하며 읽기 노드도 확장하려 합니다. 어떤 ElastiCache 구성이 가장 적합합니까?','[{"key": "A", "text": "Memcached 클러스터를 여러 AZ에 노드를 분산해 구성하고 클라이언트가 노드를 샤딩하게 한다"}, {"key": "B", "text": "DynamoDB 테이블 앞에 DAX 클러스터를 두고 점수 항목을 정렬해 조회한다"}, {"key": "C", "text": "Valkey 또는 Redis OSS 복제 그룹에 다중 AZ 자동 장애 조치를 켜고 sorted set을 쓴다"}, {"key": "D", "text": "Memcached 노드마다 리더보드 복사본을 두고 앱에서 정렬해 반환한다"}]',2,'[2]','C','C — C) Valkey 또는 Redis OSS 복제 그룹에 다중 AZ 자동 장애 조치를 켜고 sorted set을 쓴다','["Amazon ElastiCache", "Valkey / Redis OSS", "Sorted Set", "Multi-AZ Auto Failover", "Real-Time Leaderboard"]','Amazon ElastiCache, Valkey / Redis OSS, Sorted Set, Multi-AZ Auto Failover, Real-Time Leaderboard','C: Valkey/Redis OSS는 sorted set 같은 복합 데이터 구조와 복제, 자동 장애 조치를 지원해 리더보드에 적합합니다. Memcached는 단순한 데이터 타입만 지원하고 복제와 자동 장애 조치가 없으며, DAX는 DynamoDB 읽기 가속용이라 점수순 실시간 집계 용도가 아닙니다.
참고: Comparing node-based Valkey, Memcached, and Redis OSS clusters (Amazon ElastiCache)

[핵심 아키텍처 포인트] 실시간 순위(Top 100) 정렬과 고가용성이 필요한 게임 리더보드는 Sorted Set 자료구조와 다중 AZ 자동 페일오버·읽기 확장을 지원하는 Valkey/Redis OSS가 적합합니다.');
INSERT INTO "questions" VALUES(105,3,41,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-097','ko','OpenSearch 대용량 감사 로그 조회 호환 저비용 계층화 (UltraWarm + ISM 정책)','한 보안 회사가 Amazon OpenSearch Service 도메인에 하루 수백 GB의 로그를 수집합니다. 최근 7일 데이터는 대시보드에서 자주 검색하지만 8~180일 데이터는 감사 목적으로 가끔 조회할 뿐 수정하지 않습니다. 현재 모든 인덱스가 EBS 기반 데이터 노드에 있어 스토리지 비용이 크게 늘었습니다. 기존 쿼리와 OpenSearch Dashboards를 그대로 쓰면서 비용을 가장 많이 줄이는 방법은 무엇입니까?','[{"key": "A", "text": "7일이 지난 인덱스를 매일 S3로 내보내고 삭제한 뒤, 감사 시 Athena로 직접 조회하도록 감사 도구의 쿼리를 변경하고 보관 기간은 S3 수명 주기 규칙으로 관리한다"}, {"key": "B", "text": "UltraWarm 노드를 활성화하고 Index State Management 정책으로 7일이 지난 인덱스를 warm 스토리지로 자동 이전한다"}, {"key": "C", "text": "모든 데이터 노드를 더 큰 인스턴스 유형으로 교체하고 EBS 볼륨을 키워 인덱스를 모두 한 계층에 유지한다"}, {"key": "D", "text": "7일이 지난 인덱스의 replica shard를 0개로 줄여 같은 데이터 노드의 EBS 볼륨에 그대로 보관한다"}]',1,'[1]','B','B — B) UltraWarm 노드를 활성화하고 Index State Management 정책으로 7일이 지난 인덱스를 warm 스토리지로 자동 이전한다','["Amazon OpenSearch Service", "UltraWarm", "ISM (Index State Management)", "Log Analytics", "Storage Optimization"]','Amazon OpenSearch Service, UltraWarm, ISM (Index State Management), Log Analytics, Storage Optimization','B: UltraWarm은 S3 기반의 읽기 전용 인덱스를 GiB당 낮은 비용으로 보관하며 같은 API와 Dashboards로 조회되고, ISM 정책으로 이전을 자동화합니다. A는 쿼리·도구 변경이 필요하고, C는 비용만 늘리며, D는 가용성을 낮추면서 절감 폭이 작습니다.
참고: UltraWarm storage for Amazon OpenSearch Service

[핵심 아키텍처 포인트] 7일 이후 읽기 전용 감사 로그는 ISM 정책으로 S3 기반 UltraWarm 노드로 자동 이동시키면 기존 OpenSearch 쿼리와 Dashboards를 그대로 쓰면서 스토리지 비용을 대폭 절감합니다.');
INSERT INTO "questions" VALUES(106,3,42,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-102','ko','데이터 복제 없는 Athena 행·컬럼·셀 단위 세밀한 접근 통제 (AWS Lake Formation)','데이터 레이크 S3의 고객 주문 테이블이 AWS Glue Data Catalog에 등록되어 있고 분석가는 Athena로 조회합니다. 각 지역 영업팀의 IAM 역할은 자기 지역(region 컬럼) 행만 볼 수 있어야 하고, 모든 영업팀은 customer_name과 phone 컬럼을 볼 수 없어야 합니다. 데이터를 지역별로 복제하거나 S3 프리픽스를 쪼개는 방식은 피하려 합니다. 가장 운영 효율적인 방법은 무엇입니까?','[{"key": "A", "text": "지역별로 테이블 데이터를 S3 프리픽스에 복사하고 IAM 정책으로 프리픽스별 접근을 제한한다"}, {"key": "B", "text": "Lake Formation에서 행 필터 식과 제외 컬럼을 지정한 data filter를 만들고 각 역할에 해당 필터로 SELECT 권한을 부여한다"}, {"key": "C", "text": "지역별 Athena 워크그룹을 만들고 워크그룹마다 쿼리 결과 위치와 스캔 한도를 따로 지정한다"}, {"key": "D", "text": "Glue ETL 작업으로 PII 컬럼을 제거한 지역별 테이블을 주기적으로 S3에 새로 만들어 각 팀에 노출하고 지역별 IAM 역할에만 해당 테이블의 읽기 권한을 부여한다"}]',1,'[1]','B','B — B) Lake Formation에서 행 필터 식과 제외 컬럼을 지정한 data filter를 만들고 각 역할에 해당 필터로 SELECT 권한을 부여한다','["AWS Lake Formation", "Data Filter", "Row/Column-Level Security", "Amazon Athena", "AWS Glue Data Catalog"]','AWS Lake Formation, Data Filter, Row/Column-Level Security, Amazon Athena, AWS Glue Data Catalog','B: Lake Formation data filter는 행·컬럼·셀 수준 보안을 원본 테이블 하나에서 구현하며 Athena 같은 통합 엔진이 적용합니다. A와 D는 데이터를 복제·가공해 관리가 늘고, C의 워크그룹은 행·컬럼 접근 제어 수단이 아닙니다.
참고: Data filtering and cell-level security in Lake Formation

[핵심 아키텍처 포인트] Lake Formation Data Filter를 사용하면 데이터 복제나 S3 프리픽스 분할 없이 단일 Glue 카탈로그 테이블에 대해 지역 행 필터 및 PII 컬럼 제외 제어를 적용합니다.');
INSERT INTO "questions" VALUES(107,3,43,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-143','ko','외부 HTTPS 토큰 검증 및 POST 본문 검사용 CloudFront 엣지 컴퓨팅 (Lambda@Edge)','보안 팀이 모든 요청에 대한 검증을 요구합니다. 미디어 회사가 CloudFront 뒤에서 유료 콘텐츠를 제공합니다. 요청마다 외부 SaaS 인증 서비스의 HTTPS API를 호출해 토큰을 검증하고 그 결과에 따라 응답해야 하며, 일부 요청은 POST 본문을 검사해야 합니다. 처리에 수 ms에서 수십 ms가 걸려도 괜찮습니다. 어떤 방법이 가장 적합합니까?','[{"key": "A", "text": "CloudFront Functions의 viewer request 함수에서 외부 API를 호출한다"}, {"key": "B", "text": "CloudFront 캐시 정책에 토큰 헤더를 포함해 캐시 키 수준에서 검증한다"}, {"key": "C", "text": "Lambda@Edge 함수를 사용해 네트워크 호출과 요청 본문 검사를 수행한다"}, {"key": "D", "text": "AWS WAF 규칙으로 토큰 문자열을 매칭해 외부 인증 서비스 호출 없이 차단한다"}]',2,'[2]','C','C — C) Lambda@Edge 함수를 사용해 네트워크 호출과 요청 본문 검사를 수행한다','["Lambda@Edge", "Amazon CloudFront", "External API Call", "Request Body Inspection", "Edge Security"]','Lambda@Edge, Amazon CloudFront, External API Call, Request Body Inspection, Edge Security','C: Lambda@Edge는 네트워크 접근과 요청 본문 접근, 더 긴 실행 시간, 외부 라이브러리를 지원합니다. CloudFront Functions는 네트워크 접근과 본문 접근이 불가능하고 서브밀리초 실행용입니다. 캐시 정책은 검증 수단이 아니며, WAF는 외부 서비스로 토큰의 유효성을 검증하지 못합니다.
참고: Differences between CloudFront Functions and Lambda@Edge

[핵심 아키텍처 포인트] CloudFront Functions는 외부 네트워크 호출과 요청 본문(Body) 접근이 불가하므로, 외부 SaaS 인증 API 호출이나 POST 본문 검사가 필요할 때는 Lambda@Edge를 사용합니다.');
INSERT INTO "questions" VALUES(108,3,44,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-120','ko','예측 불가 스파이크 EFS 처리량 자동 확장 및 종량 과금 (EFS Elastic Throughput)','EKS 클러스터의 여러 파드가 Amazon EFS 파일 시스템을 공유합니다. 평소 처리량은 거의 없지만 하루 몇 번 예측할 수 없는 시점에 짧게 수 GiB/s의 읽기·쓰기가 몰립니다. 평균 대비 최대 처리량 비율이 5% 이하이며, 기존 Bursting 모드에서는 버스트 크레딧이 소진되어 느려졌습니다. 처리량을 미리 산정하지 않고 운영 부담을 최소화하려 합니다. 어떻게 해야 합니까?','[{"key": "A", "text": "Provisioned throughput으로 변경하고 피크 처리량에 맞춰 항상 해당 값을 프로비저닝한다"}, {"key": "B", "text": "파일 시스템에 더미 데이터를 추가해 저장 용량을 늘려 Bursting 기본 처리량을 높인다"}, {"key": "C", "text": "Max I/O 성능 모드로 새 파일 시스템을 만들고 데이터를 마이그레이션한다"}, {"key": "D", "text": "Elastic throughput 모드로 변경해 워크로드에 따라 처리량이 자동으로 확장·축소되게 한다"}]',3,'[3]','D','D — D) Elastic throughput 모드로 변경해 워크로드에 따라 처리량이 자동으로 확장·축소되게 한다','["Amazon EFS", "Elastic Throughput", "Amazon EKS", "Spike Workload", "Shared File Storage"]','Amazon EFS, Elastic Throughput, Amazon EKS, Spike Workload, Shared File Storage','D: Elastic throughput은 예측하기 어렵거나 평균 대비 최대 비율이 5% 이하인 스파이크성 워크로드에 권장되며 사용한 만큼만 과금됩니다. A는 피크를 항상 프로비저닝해 비용이 크고, B는 비용만 늘려 확장성이 불확실하며, C의 Max I/O는 지연이 높고 Elastic 모드와 함께 쓸 수 없습니다.
참고: Amazon EFS performance specifications

[핵심 아키텍처 포인트] 평균 대비 피크 비율이 5% 이하인 예측 불가 스파이크 워크로드는 버스트 크레딧 고갈이나 과잉 프로비저닝 없이 사용한 만큼만 과금되는 EFS Elastic 모드가 권장됩니다.');
INSERT INTO "questions" VALUES(109,3,45,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-130','ko','일일 변동 대규모 컨테이너 유전체 분석 비용·큐 관리 자동화 (AWS Batch + Spot)','연구소 데이터 처리 파이프라인이며 작업 수가 매일 달라 용량을 예측하기 어렵습니다. 바이오 회사가 매일 밤 수천 개의 컨테이너화된 유전체 분석 작업을 실행합니다. 작업 하나가 몇 시간 걸리고 중단되면 재시도해도 괜찮으며 마감은 아침까지로 여유가 있습니다. 비용을 최소화하고 작업 대기열과 서버 프로비저닝을 직접 관리하지 않으려 합니다. 어떤 구성이 가장 적합합니까?','[{"key": "A", "text": "Lambda 함수로 작업을 분할해 실행하고 Step Functions로 순서를 제어한다"}, {"key": "B", "text": "온디맨드 EC2 인스턴스 Auto Scaling 그룹에 SQS 큐 기반 작업 처리 소프트웨어를 직접 구축한다"}, {"key": "C", "text": "Fargate 온디맨드 작업으로 ECS 서비스를 만들고 밤새 작업 수만큼 태스크를 유지한다"}, {"key": "D", "text": "AWS Batch의 관리형 컴퓨팅 환경에서 Spot 인스턴스를 사용하고 작업을 작업 큐에 제출한다"}]',3,'[3]','D','D — D) AWS Batch의 관리형 컴퓨팅 환경에서 Spot 인스턴스를 사용하고 작업을 작업 큐에 제출한다','["AWS Batch", "Spot Instances", "Container Workloads", "Managed Compute Environment", "High-Throughput Computing"]','AWS Batch, Spot Instances, Container Workloads, Managed Compute Environment, High-Throughput Computing','D: AWS Batch는 작업 큐와 컴퓨팅 프로비저닝을 관리하고 Spot 인스턴스를 사용해 중단 허용 작업의 비용을 줄입니다. A는 Lambda의 15분 실행 한도에 맞지 않고, B는 스케줄링 소프트웨어를 직접 운영해야 하며, C는 온디맨드 요금으로 비용이 높습니다.
참고: What is AWS Batch?

[핵심 아키텍처 포인트] 수 시간 걸리는 중단 허용 컨테이너 배치 작업이 불규칙하게 수천 개 발생할 때는 작업 큐·인프라 프로비저닝을 자동화하고 Spot 인스턴스를 활용하는 AWS Batch가 최적입니다.');
INSERT INTO "questions" VALUES(110,3,46,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-086','ko','단기 5Gbps 임시 VPN 대역폭 확장을 위한 Transit Gateway ECMP 다중 터널 병합','온프레미스와 AWS 사이에 인터넷 기반 Site-to-Site VPN으로 약 5Gbps를 임시로 확보해야 합니다. VPN 터널 하나의 처리량 한도 때문에 대역폭이 부족합니다. 임시 용도라 Direct Connect 개통을 기다릴 수 없고 필요한 기간은 몇 주뿐입니다. 여러 VPC가 연결되어 있고 설정을 단순하게 유지하려면 어떻게 해야 합니까?','[{"key": "A", "text": "VPC마다 virtual private gateway에 VPN 연결을 여러 개 만들고 ECMP를 사용한다"}, {"key": "B", "text": "Transit Gateway에 VPN 연결을 여러 개 만들고 ECMP로 트래픽을 분산한다"}, {"key": "C", "text": "VPN 터널 하나의 처리량 한도를 AWS Support에 증설 요청한다"}, {"key": "D", "text": "Accelerated VPN만 활성화해 터널 한 개로 5Gbps를 확보한다"}]',1,'[1]','B','B — B) Transit Gateway에 VPN 연결을 여러 개 만들고 ECMP로 트래픽을 분산한다','["AWS Transit Gateway", "ECMP (Equal-Cost Multi-Path)", "Site-to-Site VPN", "Bandwidth Aggregation", "Hybrid Networking"]','AWS Transit Gateway, ECMP (Equal-Cost Multi-Path), Site-to-Site VPN, Bandwidth Aggregation, Hybrid Networking','B: Transit Gateway는 VPN 연결 간 ECMP를 지원해 터널 처리량을 합산하고 여러 VPC에 공통으로 사용됩니다. A의 virtual private gateway는 ECMP를 지원하지 않고, C는 터널 한도를 늘릴 수 없으며, D는 지연을 줄일 뿐 터널당 한도를 바꾸지 않습니다.

[핵심 아키텍처 포인트] 단일 IPSec VPN 터널은 약 1.25Gbps 한계가 있으나, Transit Gateway에 여러 VPN 연결을 붙여 ECMP를 활성화하면 다수 터널의 대역폭을 합산해 5Gbps 이상을 확보할 수 있습니다.');
INSERT INTO "questions" VALUES(111,3,47,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-084','ko','고객 방화벽 고정 IP 허용 및 다중 리전 ALB TCP 초고속 장애 조치 (Global Accelerator)','B2B SaaS가 고객사 방화벽에 등록할 정적 IP 두 개를 제공해야 하며, 여러 리전의 ALB로 TCP 트래픽을 분산하고 리전 장애 시 수 초 내 failover되어야 합니다. DNS 캐싱에 의존하지 않아야 합니다. 고객사 보안팀은 허용 IP가 바뀌면 승인에 수 주가 걸린다고 합니다. 어떻게 구성해야 합니까?','[{"key": "A", "text": "Route 53 failover 레코드에 리전별 ALB를 등록하고 TTL을 아주 낮게 설정해 전환한다"}, {"key": "B", "text": "ALB마다 탄력적 IP 주소를 직접 할당해 고객사에 알려준다"}, {"key": "C", "text": "Amazon CloudFront 배포를 만들고 ALB를 origin으로 지정한다"}, {"key": "D", "text": "Global Accelerator의 anycast 정적 IP에 리전별 ALB endpoint group을 연결한다"}]',3,'[3]','D','D — D) Global Accelerator의 anycast 정적 IP에 리전별 ALB endpoint group을 연결한다','["AWS Global Accelerator", "Anycast Static IP", "Application Load Balancer (ALB)", "Multi-Region Failover", "TCP Performance"]','AWS Global Accelerator, Anycast Static IP, Application Load Balancer (ALB), Multi-Region Failover, TCP Performance','D: Global Accelerator는 고정 anycast IP 두 개를 제공하고 상태 확인으로 정상 리전에 트래픽을 즉시 전환합니다. A는 DNS 캐시에 의존하고, B는 ALB가 고정 탄력적 IP 주소를 지원하지 않으며, C는 TCP 동적 트래픽의 failover와 정적 IP 요건에 맞지 않습니다.

[핵심 아키텍처 포인트] ALB는 고정 IP가 없으므로 고객사 허용 목록용 고정 IP 2개와 DNS 캐싱 없는 리전 간 초고속 TCP 장애 조치를 구현하려면 Global Accelerator 앞에 리전별 ALB를 등록합니다.');
INSERT INTO "questions" VALUES(112,3,48,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-045','ko','RDS LIKE 쿼리 한계 극복 전문 검색·오타 허용·자동완성 (Amazon OpenSearch Service)','온라인 쇼핑몰이 Amazon RDS for MySQL의 LIKE 쿼리로 상품 검색을 제공하고 있습니다. 상품이 수백만 건으로 늘면서 검색이 느려졌고, 오타를 허용하는 검색과 형태소 기반 전문 검색, 카테고리 필터, 자동완성이 새로 필요해졌습니다. 운영 오버헤드를 최소화하면서 요구사항을 충족하는 방법은 무엇입니까?','[{"key": "A", "text": "OpenSearch Service 도메인에 상품 데이터를 색인하고 검색을 OpenSearch가 처리하도록 변경한다"}, {"key": "B", "text": "RDS for MySQL에 읽기 전용 복제본을 추가하고 검색 전용 replica에서 같은 LIKE 쿼리를 실행하도록 변경한다"}, {"key": "C", "text": "상품을 Amazon DynamoDB에 저장하고 Scan 작업에 filter expression을 적용해 검색 결과를 반환한다"}, {"key": "D", "text": "상품 데이터를 Amazon S3로 내보내고 요청마다 Amazon Athena 쿼리를 실행해 검색 결과를 반환한다"}]',0,'[0]','A','A — A) OpenSearch Service 도메인에 상품 데이터를 색인하고 검색을 OpenSearch가 처리하도록 변경한다','["Amazon OpenSearch Service", "Full-Text Search", "Fuzzy Matching", "Autocomplete", "Amazon RDS"]','Amazon OpenSearch Service, Full-Text Search, Fuzzy Matching, Autocomplete, Amazon RDS','A: OpenSearch Service는 전문 검색, fuzzy matching, 필터, 자동완성을 관리형으로 제공합니다. B는 LIKE의 구조적 한계를 해결하지 못하고, C의 Scan은 전문 검색이 불가하며 비용이 큽니다. D는 저지연 대화형 검색에 맞지 않습니다.

[핵심 아키텍처 포인트] 수백만 건 상품에서 LIKE 풀스캔으로 느려진 검색에 오타 허용(Fuzzy)·형태소 분석·패싯 필터·자동완성을 적용하려면 OpenSearch Service로 색인해 검색 부하를 오프로드합니다.');
INSERT INTO "questions" VALUES(113,4,35,3,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-136','ko','Aurora 장애 조치 자동 대응 및 80% 읽기 부하 분산 (Cluster + Reader 엔드포인트 분리)','Aurora PostgreSQL 클러스터에 writer 한 대와 reader 세 대가 있습니다. 웹 애플리케이션이 모든 쿼리를 클러스터 엔드포인트로 보내 writer가 과부하입니다. 읽기 쿼리가 80%입니다. 장애 조치 시에도 애플리케이션 연결 설정을 수동으로 바꾸지 않고 읽기 부하를 분산해야 합니다. 어떻게 구성해야 합니까? (2개 선택)','[{"key": "A", "text": "읽기 전용 쿼리는 reader 엔드포인트로 보내 Aurora가 reader들 사이에서 연결을 분산하게 한다"}, {"key": "B", "text": "읽기 전용 쿼리를 각 reader의 인스턴스 엔드포인트로 직접 보내고 애플리케이션이 순환하게 한다"}, {"key": "C", "text": "쓰기와 DDL은 클러스터 엔드포인트로 유지해 장애 조치 후에도 새 writer로 연결되게 한다"}, {"key": "D", "text": "모든 reader의 승급 우선순위(promotion tier)를 같게 설정해 읽기 쿼리가 균등 분산되게 한다"}, {"key": "E", "text": "Route 53 가중치 레코드에 reader 인스턴스 IP를 직접 등록하고 장애 때 수동으로 갱신한다"}]',NULL,'[0, 2]','A, C','A, C — A) 읽기 전용 쿼리는 reader 엔드포인트로 보내 Aurora가 reader들 사이에서 연결을 분산하게 한다 / C) 쓰기와 DDL은 클러스터 엔드포인트로 유지해 장애 조치 후에도 새 writer로 연결되게 한다','["Amazon Aurora", "Reader Endpoint", "Cluster Endpoint", "Read Scaling", "Automatic Failover"]','Amazon Aurora, Reader Endpoint, Cluster Endpoint, Read Scaling, Automatic Failover','A: reader 엔드포인트는 reader 사이의 연결을 자동 분산하고 장애 시 대상을 바꿉니다. C: 클러스터 엔드포인트는 장애 조치 후 새 writer를 가리킵니다. 인스턴스 엔드포인트는 인스턴스 장애를 자동 처리하지 못하고, 승급 우선순위는 읽기 분산과 무관하며, Route 53 수동 등록은 운영 부담이 큽니다.
참고: Amazon Aurora endpoint connections

[핵심 아키텍처 포인트] 쓰기·DDL은 항상 현재 Primary를 가리키는 Cluster 엔드포인트로, 80% 읽기 쿼리는 가용 Reader들 간 연결을 자동 분산하는 Reader 엔드포인트로 분리합니다.');
INSERT INTO "questions" VALUES(114,4,36,3,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-093','ko','400TB 3주 내 S3 이전 및 증분 동기화 (10Gbps Direct Connect + 다중 DataSync 작업)','제조 회사가 데이터센터의 400TB 데이터를 3주 안에 S3로 옮겨야 합니다. 현재 1Gbps 회선은 이론상 전송에만 약 37일이 걸리고, 이전 후에도 변경 데이터는 계속 동기화해야 합니다. 회사는 2주 안에 10Gbps AWS Direct Connect 연결을 개통할 수 있습니다. 적절한 방법은 무엇입니까? (2개 선택)','[{"key": "A", "text": "기존 1Gbps 회선으로 DataSync 작업 하나만 실행해 400TB 전체를 전송한다"}, {"key": "B", "text": "10Gbps Direct Connect를 개통하고 DataSync 에이전트와 작업을 여러 개로 나눠 병렬로 전송한다"}, {"key": "C", "text": "S3 Transfer Acceleration을 활성화해 1Gbps 회선의 한계를 넘어선다"}, {"key": "D", "text": "전체 전송 후 DataSync 작업을 스케줄로 반복 실행해 변경된 데이터만 증분 동기화하고 컷오버한다"}, {"key": "E", "text": "Site-to-Site VPN 터널을 추가해 회선 대역폭을 두 배로 늘린다"}]',NULL,'[1, 3]','B, D','B, D — B) 10Gbps Direct Connect를 개통하고 DataSync 에이전트와 작업을 여러 개로 나눠 병렬로 전송한다 / D) 전체 전송 후 DataSync 작업을 스케줄로 반복 실행해 변경된 데이터만 증분 동기화하고 컷오버한다','["AWS DataSync", "AWS Direct Connect", "S3 Migration", "Incremental Sync", "High Throughput"]','AWS DataSync, AWS Direct Connect, S3 Migration, Incremental Sync, High Throughput','B: 10Gbps라면 이론상 400TB가 약 4일(실효율을 감안해도 몇 주 이내)에 전송되고, 에이전트·작업을 나누면 병렬성이 높아집니다. D: DataSync는 변경분만 증분 전송하므로 컷오버까지 동기화를 유지할 수 있습니다. A는 이론상 37일이라 기한을 넘기고, C는 회선 대역폭을 늘리지 못하며, E의 VPN은 인터넷 기반이라 터널당 처리량 한도가 낮습니다.

[핵심 아키텍처 포인트] 1Gbps로는 기한 초과(37일)이므로 10Gbps Direct Connect를 개통하고 복수 DataSync 에이전트·작업으로 병렬 초기 전송 후 스케줄 증분 동기화로 무중단 컷오버합니다.');
INSERT INTO "questions" VALUES(115,4,37,3,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-033','ko','고가용성 다중 AZ 3티어 VPC 서브넷 계층 분리 및 ALB 트래픽 분산','한 금융 서비스 회사가 VPC 네트워크 아키텍처를 설계합니다. 웹 티어, 애플리케이션 티어, 데이터베이스 티어의 고가용성과 보안이 필요하며, 각 리전 내 여러 가용 영역에 걸쳐 배포됩니다. 다음 중 이 아키텍처 설계 모범 사례는? (2개 선택)','[{"key": "A", "text": "각 가용 영역의 public subnet에 웹 티어 배포, private subnet에 애플리케이션/DB 티어 배포"}, {"key": "B", "text": "모든 인스턴스를 단일 가용 영역의 public subnet에 배포하여 관리 단순화"}, {"key": "C", "text": "Application Load Balancer를 여러 가용 영역에 배포하고 traffic 분산"}, {"key": "D", "text": "보안을 위해 모든 서브넷을 private으로 설정하고 NAT gateway 없이 아웃바운드 접근만 제한"}, {"key": "E", "text": "각 가용 영역의 Network ACL을 stateful 필터링용으로 구성해 security group을 대체한다"}]',NULL,'[0, 2]','A, C','A, C — A) 각 가용 영역의 public subnet에 웹 티어 배포, private subnet에 애플리케이션/DB 티어 배포 / C) Application Load Balancer를 여러 가용 영역에 배포하고 traffic 분산','["Amazon VPC", "Multi-AZ", "Public & Private Subnets", "Application Load Balancer (ALB)", "3-Tier Architecture"]','Amazon VPC, Multi-AZ, Public & Private Subnets, Application Load Balancer (ALB), 3-Tier Architecture','A는 웹 티어의 공개 노출 필요성과 애플리케이션/DB 티어의 보안 요구사항에 맞는 모범 사례입니다. C는 여러 가용 영역에 걸친 ALB 배포로 고가용성을 보장합니다. B는 단일 AZ 의존으로 고가용성을 해치고, D는 아웃바운드 접근까지 막아 패치·API 호출이 불가능해지며, E는 Network ACL이 stateless이므로 stateful 필터링 및 security group 대체 설명이 틀립니다.

[핵심 아키텍처 포인트] 웹 티어를 다중 AZ ALB 뒤에 두고 애플리케이션·데이터베이스 티어를 프라이빗 서브넷에 격리 배치하는 것이 보안성과 고가용성을 겸비한 VPC 3티어 표준 아키텍처입니다.');
INSERT INTO "questions" VALUES(116,4,38,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-085','ko','전용 로케이션 장비 구축 없는 500Mbps 사설 전용선 신속 확보 (Direct Connect Hosted Connection)','중견기업이 온프레미스와 AWS 사이에 500Mbps 대역폭의 사설 전용 연결을 빠르게 확보해야 합니다. 직접 Direct Connect 로케이션에 장비를 설치하고 싶지 않으며 비용도 최소화하려 합니다. 현재는 인터넷 VPN을 쓰고 있어 지연과 대역폭 변동이 문제입니다. 가장 적절한 선택은 무엇입니까?','[{"key": "A", "text": "AWS Direct Connect 파트너를 통해 hosted connection을 주문한다"}, {"key": "B", "text": "1Gbps 이상 dedicated connection을 직접 주문하고 로케이션에 장비를 설치한다"}, {"key": "C", "text": "Site-to-Site VPN 터널을 여러 개 만들어 공용 인터넷으로 500Mbps를 확보한다"}, {"key": "D", "text": "100Gbps dedicated connection을 주문해 필요한 대역폭을 나눠 사용한다"}]',0,'[0]','A','A — A) AWS Direct Connect 파트너를 통해 hosted connection을 주문한다','["AWS Direct Connect", "Hosted Connection", "APN Partner", "Dedicated Bandwidth", "Hybrid Networking"]','AWS Direct Connect, Hosted Connection, APN Partner, Dedicated Bandwidth, Hybrid Networking','A: Direct Connect hosted connection은 APN 파트너가 제공하는 더 작은 용량(최소 50Mbps)의 연결로 빠른 프로비저닝이 가능합니다. B는 장비 설치가 필요하고 용량이 과하며, C는 공용 인터넷이라 사설 전용 연결이 아니며, D는 과잉입니다.

[핵심 아키텍처 포인트] 직접 코로케이션 장비를 설치하지 않고 1Gbps 미만의 500Mbps 전용 회선을 빠르게 개통하려면 AWS Direct Connect 파트너를 통한 Hosted Connection을 사용합니다.');
INSERT INTO "questions" VALUES(117,4,39,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-075','ko','예측 불가 티켓팅 급증 및 유휴 비용 제거 (DynamoDB On-Demand 용량 모드)','티켓팅 서비스가 인기 공연 오픈 때 몇 분 동안 DynamoDB 트래픽이 평소보다 크게 급증하고, 나머지 시간에는 거의 사용되지 않습니다. 인프라 팀은 부하 예측이 어렵고 별도의 스케일링 운영도 줄이고 싶어 합니다. 용량 계획이나 스케일링 설정 없이 급증을 처리하고 유휴 비용을 피하려면 어떻게 해야 합니까?','[{"key": "A", "text": "피크 기준의 RCU/WCU를 provisioned 모드로 상시 프로비저닝한다"}, {"key": "B", "text": "provisioned 모드에 Auto Scaling을 설정하고 목표 사용률을 70%로 둔다"}, {"key": "C", "text": "DynamoDB 테이블을 on-demand 용량 모드로 설정한다"}, {"key": "D", "text": "provisioned 모드에서 reserved capacity를 구매해 피크 용량을 확보한다"}]',2,'[2]','C','C — C) DynamoDB 테이블을 on-demand 용량 모드로 설정한다','["Amazon DynamoDB", "On-Demand Capacity", "Burst Traffic", "Throttling Prevention", "Serverless Database"]','Amazon DynamoDB, On-Demand Capacity, Burst Traffic, Throttling Prevention, Serverless Database','C: on-demand는 사전 용량 계획 없이 급증을 처리하고 사용한 요청만 과금합니다. A와 D는 유휴 시간에도 비용이 발생하고, B는 Auto Scaling 반응 지연 때문에 짧고 급격한 스파이크에서 throttling이 생길 수 있습니다.

[핵심 아키텍처 포인트] 짧고 극단적인 티켓팅 트래픽 급증과 긴 유휴 시간이 반복되는 워크로드는 Auto Scaling 반응 지연으로 인한 스로틀링을 막고 요청당 과금되는 DynamoDB On-Demand 모드가 적합합니다.');
INSERT INTO "questions" VALUES(118,4,40,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-079','ko','쓰기 시 캐시 동시 갱신으로 Stale 데이터·첫 조회 지연 방지 (Write-Through 캐싱)','상품 가격 정보를 조회하는 서비스에서 가격이 변경되면 즉시 모든 조회에 반영되어야 하고, 캐시 미스로 인한 첫 조회 지연도 줄여야 합니다. 쓰기 빈도는 낮습니다. 가격 변경은 하루 몇 번 발생하며 마케팅 팀이 결과를 즉시 확인해야 합니다. 어떤 ElastiCache 캐싱 전략이 가장 적절합니까?','[{"key": "A", "text": "lazy loading으로 캐시 미스 시에만 데이터베이스에서 읽어 채우고 TTL을 1시간으로 둔다"}, {"key": "B", "text": "캐시를 사용하지 않고 읽기 전용 복제본을 늘려 읽기를 분산한다"}, {"key": "C", "text": "캐시 TTL을 24시간으로 설정해 만료 시 새로 읽어 채운다"}, {"key": "D", "text": "write-through 전략으로 데이터베이스에 쓸 때 캐시도 함께 갱신한다"}]',3,'[3]','D','D — D) write-through 전략으로 데이터베이스에 쓸 때 캐시도 함께 갱신한다','["Amazon ElastiCache", "Write-Through", "Cache Strategy", "Data Freshness", "Cache Miss Prevention"]','Amazon ElastiCache, Write-Through, Cache Strategy, Data Freshness, Cache Miss Prevention','D: write-through는 쓰기마다 캐시를 갱신해 stale 데이터를 줄이고 캐시 미스를 방지합니다. A와 C는 TTL 동안 오래된 값이 노출되고 첫 조회가 느리며, B는 캐시의 지연 개선 효과를 포기합니다.

[핵심 아키텍처 포인트] 쓰기 빈도는 낮고 가격 변경 즉시 조회 일관성과 첫 조회 히트율이 중요할 때는 DB 쓰기와 동시에 캐시를 갱신하는 Write-Through 전략(TTL과 병행)이 적합합니다.');
INSERT INTO "questions" VALUES(119,4,41,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-036','ko','다수 VPC·리전 중앙 집중식 Hub-and-Spoke 라우팅 (AWS Transit Gateway)','한 기업이 AWS의 여러 VPC와 리전에 걸쳐 애플리케이션을 배포하고 있으며, 모든 VPC 간의 라우팅을 중앙화하고 보안 정책을 일관되게 적용하려고 합니다. VPC peering 대신 더 확장성 있는 hub-and-spoke 네트워크 토폴로지를 구성해야 합니다. 가장 적합한 AWS 서비스는 무엇입니까?','[{"key": "A", "text": "여러 VPC에서 직접 VPC peering 설정"}, {"key": "B", "text": "AWS Direct Connect로 모든 VPC 연결"}, {"key": "C", "text": "AWS Transit Gateway로 hub-and-spoke 네트워크 토폴로지 구성"}, {"key": "D", "text": "각 VPC에 Application Load Balancer 배포 후 Route 53으로 라우팅"}]',2,'[2]','C','C — C) AWS Transit Gateway로 hub-and-spoke 네트워크 토폴로지 구성','["AWS Transit Gateway", "Hub-and-Spoke", "Multi-VPC", "Centralized Routing", "Network Scalability"]','AWS Transit Gateway, Hub-and-Spoke, Multi-VPC, Centralized Routing, Network Scalability','AWS Transit Gateway는 중앙 hub로서 여러 VPC와 리전(peering 연결) 간의 라우팅을 중앙화하고 route table로 보안 정책을 일관되게 적용할 수 있습니다. VPC peering(A)은 full-mesh 구조라 VPC가 늘수록 연결 수가 폭증하고 전이적 라우팅이 안 되며, Direct Connect(B)는 온프레미스 연결용이고, ALB+Route 53(D)은 VPC 간 네트워크 라우팅 허브 역할을 하지 못합니다.

[핵심 아키텍처 포인트] 수십 개 VPC 간 Full-Mesh Peering의 복잡성을 피하고 보안·라우팅 정책을 중앙 허브에서 일관되게 통제하려면 AWS Transit Gateway를 구성합니다.');
INSERT INTO "questions" VALUES(120,4,42,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-025','ko','다중 읽기 복제본 및 자동 장애 조치 지원 고성능 관계형 DB (Amazon Aurora 클러스터)','대규모 엔터프라이즈 데이터베이스가 여러 가용 영역(AZ)에서 높은 가용성을 유지해야 합니다. 장애 조치 대상이 되는 읽기 가능한 복제본(reader)을 여러 개 두어 읽기 확장도 함께 해야 합니다. 가장 적절한 배포 옵션은 무엇입니까?','[{"key": "A", "text": "단일 AZ Amazon RDS 인스턴스"}, {"key": "B", "text": "Amazon Aurora 클러스터(자동 장애 조치)"}, {"key": "C", "text": "Amazon RDS 다중 AZ DB 인스턴스 배포(standby 1개)"}, {"key": "D", "text": "수동 스탠바이 인스턴스 관리"}]',1,'[1]','B','B — B) Amazon Aurora 클러스터(자동 장애 조치)','["Amazon Aurora", "Aurora Replicas", "Multi-AZ", "Read Scaling", "Automatic Failover"]','Amazon Aurora, Aurora Replicas, Multi-AZ, Read Scaling, Automatic Failover','Amazon Aurora 클러스터는 여러 AZ에 걸쳐 공유 스토리지를 사용하고 여러 reader가 장애 조치 대상이 되어 읽기 확장과 고가용성을 함께 제공합니다. 단일 AZ(A)는 위험하고, RDS 다중 AZ DB 인스턴스 배포(C)의 standby는 읽기를 받지 못하며 reader를 여러 개 둘 수 없고, 수동 관리(D)는 복잡합니다.

[핵심 아키텍처 포인트] Aurora는 공유 스토리지 기반으로 최대 15개의 읽기 전용 복제본(Reader)이 자동 장애 조치 대상이 되어 RDS Multi-AZ보다 높은 읽기 확장성과 빠른 복구를 제공합니다.');
INSERT INTO "questions" VALUES(121,4,43,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-030','ko','수천 개 IoT 센서 초당 대량 UDP 이벤트 초저지연 수신 (Network Load Balancer)','한 IoT 제조 회사가 수천 개의 센서에서 초당 대량의 이벤트를 수집하고, 실시간으로 처리하여 이상 감지 알림을 보냅니다. 낮은 지연 시간과 고처리량이 필수적입니다. 네트워크 계층에서 어떤 로드 밸런서를 사용해야 합니까?','[{"key": "A", "text": "Application Load Balancer (ALB) with 연결 드레이닝 활성화"}, {"key": "B", "text": "Network Load Balancer (NLB) with UDP 지원"}, {"key": "C", "text": "Classic Load Balancer with TCP 연결 재사용"}, {"key": "D", "text": "AWS Global Accelerator with Standard 가속기"}]',1,'[1]','B','B — B) Network Load Balancer (NLB) with UDP 지원','["Network Load Balancer (NLB)", "UDP Support", "Layer 4 Load Balancing", "IoT Ingestion", "Ultra-Low Latency"]','Network Load Balancer (NLB), UDP Support, Layer 4 Load Balancing, IoT Ingestion, Ultra-Low Latency','Network Load Balancer는 초저지연으로 초당 수백만 요청을 처리하는 계층 4 로드 밸런서로 UDP, TCP 등 비HTTP 트래픽에 적합해 센서 데이터 수집에 이상적입니다. ALB(A)는 HTTP/HTTPS 계층 7 라우팅용이고, Classic LB(C)는 이전 세대이며 UDP를 지원하지 않고, Global Accelerator(D)는 로드 밸런서가 아니라 트래픽 가속 서비스입니다.

[핵심 아키텍처 포인트] L7 HTTP/HTTPS 전용인 ALB와 달리 NLB는 L4에서 UDP 및 TCP 트래픽을 초당 수백만 요청 수준과 초저지연으로 처리할 수 있어 IoT 수집 관문에 최적입니다.');
INSERT INTO "questions" VALUES(122,4,44,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-044','ko','실시간 구매 데이터 서버리스 수집·저장·SQL 분석·BI 대시보드 (Firehose + S3 + Athena + QuickSight)','한 소매 회사가 고객 구매 데이터를 실시간으로 분석하여 대시보드에 시각화하고, 임원들이 의사결정을 위해 조회할 수 있게 하려고 합니다. 데이터는 다양한 소스에서 수집되며 계속 변합니다. 어떤 서비스 조합이 가장 적합합니까?','[{"key": "A", "text": "Kinesis Data Streams로 수집, Athena로 분석, QuickSight로 시각화"}, {"key": "B", "text": "Amazon Data Firehose로 수집, S3 저장, Athena로 분석, QuickSight로 시각화"}, {"key": "C", "text": "S3로 저장, Redshift로 로드, QuickSight로 시각화"}, {"key": "D", "text": "SQS로 메시지 수집, Lambda로 처리, DynamoDB로 저장"}]',1,'[1]','B','B — B) Amazon Data Firehose로 수집, S3 저장, Athena로 분석, QuickSight로 시각화','["Amazon Data Firehose", "Amazon S3", "Amazon Athena", "Amazon QuickSight", "Streaming Analytics"]','Amazon Data Firehose, Amazon S3, Amazon Athena, Amazon QuickSight, Streaming Analytics','Data Firehose가 수집한 데이터를 S3에 자동 적재하면 Athena가 직접 쿼리하고 QuickSight가 시각화하는 관리형 파이프라인이 완성됩니다. A는 Kinesis Data Streams가 S3로 자동 적재하지 않아 별도 컨슈머나 Firehose가 필요하고 Athena가 읽을 데이터가 없으며, C는 실시간 수집 구성이 없고, D는 분석 및 시각화 기능이 없습니다.

[핵심 아키텍처 포인트] Data Firehose가 스트리밍 데이터를 S3에 자동 적재·변환하고 Athena로 서버리스 SQL 분석 후 QuickSight로 시각화하면 최소 운영 부담의 실시간 BI 파이프라인이 완성됩니다.');
INSERT INTO "questions" VALUES(123,4,45,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-032','ko','인터넷 노출 없는 교차 계정 마이크로서비스 사설 서비스 통신 (AWS PrivateLink)','한 의료 기관이 VPC 내 여러 마이크로서비스 간의 안전하고 격리된 통신이 필요합니다. 서비스는 다른 AWS 계정의 리소스와도 안전하게 통신해야 합니다. 공개 인터넷 노출 없이 이를 달성하는 방법은 무엇입니까?','[{"key": "A", "text": "AWS PrivateLink를 사용하여 VPC endpoint 생성"}, {"key": "B", "text": "VPC peering과 security group 규칙만 사용"}, {"key": "C", "text": "Application Load Balancer와 NAT gateway를 통한 라우팅"}, {"key": "D", "text": "AWS VPN과 route table 수정"}]',0,'[0]','A','A — A) AWS PrivateLink를 사용하여 VPC endpoint 생성','["AWS PrivateLink", "VPC Endpoint Service", "Cross-Account Networking", "Microservices", "Private Connectivity"]','AWS PrivateLink, VPC Endpoint Service, Cross-Account Networking, Microservices, Private Connectivity','AWS PrivateLink는 특정 서비스를 소비자 VPC나 다른 AWS 계정에 AWS 네트워크 내부로 비공개 노출합니다. VPC peering(B)은 두 VPC 간 네트워크 전체를 연결해 특정 서비스만 노출하는 세분화된 제어가 어렵고 CIDR이 겹치면 쓸 수 없습니다. ALB+NAT(C)와 VPN(D)은 공개 노출 가능성이 있거나 서비스 단위 비공개 노출 방식이 아닙니다.

[핵심 아키텍처 포인트] 네트워크 전체를 연결하는 VPC Peering과 달리 PrivateLink는 특정 마이크로서비스 엔드포인트만 AWS 백본 망 내부로 다른 VPC·계정에 안전하게 노출합니다.');
INSERT INTO "questions" VALUES(124,4,46,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-016','ko','다중 AZ 고가용성 완전 관리형 Kubernetes 컨테이너 플랫폼 (Amazon EKS)','마이크로서비스들이 Docker 컨테이너로 패키징되고 AWS에 배포되어야 합니다. 완전히 관리되는 Kubernetes 환경이 필요하고 높은 가용성을 원합니다. 가장 적절한 솔루션은 무엇입니까?','[{"key": "A", "text": "EC2 인스턴스 그룹에 Kubernetes를 수동 설치한다"}, {"key": "B", "text": "Amazon EKS를 사용한다"}, {"key": "C", "text": "Amazon ECS를 EC2 론칭 타입으로 사용한다"}, {"key": "D", "text": "AWS Fargate를 사용한다"}]',1,'[1]','B','B — B) Amazon EKS를 사용한다','["Amazon EKS", "Kubernetes", "Containers", "Managed Control Plane", "Multi-AZ"]','Amazon EKS, Kubernetes, Containers, Managed Control Plane, Multi-AZ','Amazon EKS는 AWS에서 완전 관리되는 Kubernetes 컨트롤 플레인을 여러 AZ에 걸쳐 제공하고 업그레이드를 지원합니다. 수동 설치(A)는 관리 부담이 크고, ECS(C)는 Kubernetes가 아닌 AWS 고유 오케스트레이터이며, Fargate(D)는 컨테이너 컴퓨팅 엔진일 뿐 그 자체가 Kubernetes 컨트롤 플레인이 아닙니다.

[핵심 아키텍처 포인트] Docker 컨테이너 마이크로서비스를 표준 Kubernetes 생태계와 함께 완전 관리형 다중 AZ 컨트롤 플레인에서 운영하려면 Amazon EKS를 선택합니다.');
INSERT INTO "questions" VALUES(125,4,47,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-018','ko','글로벌 다중 리전 Multi-Active 저지연 NoSQL (DynamoDB Global Tables)','NoSQL 애플리케이션이 초당 수만 건의 쓰기와 읽기를 처리해야 합니다. 데이터는 지리적으로 여러 리전에서 접근해야 하고 일관성은 최종 일관성으로 충분합니다. 가장 적절한 데이터베이스는 무엇입니까?','[{"key": "A", "text": "Amazon RDS 멀티 마스터 설정"}, {"key": "B", "text": "Amazon Aurora 글로벌 데이터베이스"}, {"key": "C", "text": "Amazon Neptune 그래프 데이터베이스"}, {"key": "D", "text": "Amazon DynamoDB 글로벌 테이블"}]',3,'[3]','D','D — D) Amazon DynamoDB 글로벌 테이블','["Amazon DynamoDB", "Global Tables", "Multi-Active Replication", "NoSQL", "Eventual Consistency"]','Amazon DynamoDB, Global Tables, Multi-Active Replication, NoSQL, Eventual Consistency','Amazon DynamoDB 글로벌 테이블은 여러 리전에서 쓰기가 가능한 multi-active 복제를 제공하며 최종 일관성과 높은 처리량을 지원합니다. RDS는 멀티 리전 멀티 마스터(A)를 제공하지 않고, Aurora 글로벌 DB(B)는 단일 쓰기 리전 구조의 관계형 DB이며, Neptune(C)은 그래프용입니다.

[핵심 아키텍처 포인트] 전 세계 여러 리전에서 동시에 초당 수만 건의 로컬 읽기·쓰기를 처리하고 최종 일관성을 허용하는 NoSQL 워크로드는 DynamoDB 글로벌 테이블(Multi-Active)이 최적입니다.');
INSERT INTO "questions" VALUES(126,4,48,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-064','ko','GPU 학습용 단일 AZ 한 자릿수 밀리초 초고속 객체 스토리지 (S3 Express One Zone)','머신러닝 팀이 같은 AZ의 GPU 인스턴스에서 학습하면서 S3의 작은 학습 데이터 객체를 초당 수십만 번 읽습니다. 일관된 한 자릿수 밀리초 지연이 필요하고, 데이터는 원본이 다른 곳에 있어 단일 AZ 저장을 허용합니다. 학습 작업은 한 AZ에서만 실행되며 비용보다 읽기 지연이 더 중요합니다. 가장 적합한 스토리지는 무엇입니까?','[{"key": "A", "text": "S3 Standard 버킷에 데이터를 두고 S3 Transfer Acceleration을 활성화한다"}, {"key": "B", "text": "데이터를 S3 Glacier Instant Retrieval 스토리지 클래스로 저장한다"}, {"key": "C", "text": "컴퓨팅과 같은 AZ에 S3 Express One Zone directory bucket을 만든다"}, {"key": "D", "text": "S3 Standard-IA 클래스에 저장하고 객체마다 multipart upload로 올린다"}]',2,'[2]','C','C — C) 컴퓨팅과 같은 AZ에 S3 Express One Zone directory bucket을 만든다','["Amazon S3 Express One Zone", "Directory Bucket", "Single-Digit Millisecond", "ML Training", "High Request Rate"]','Amazon S3 Express One Zone, Directory Bucket, Single-Digit Millisecond, ML Training, High Request Rate','C: S3 Express One Zone은 단일 AZ에서 일관된 한 자릿수 ms 지연과 높은 요청률을 제공하며 컴퓨팅과 같은 AZ에 두면 최적입니다. A는 업로드 가속이라 읽기 지연과 무관하고, B와 D는 접근 빈도가 낮은 데이터용입니다.

[핵심 아키텍처 포인트] 컴퓨팅(GPU 인스턴스)과 동일 AZ에 S3 Express One Zone 디렉터리 버킷을 배치하면 기존 S3 대비 최대 10배 빠른 한 자릿수 밀리초 지연과 초당 수십만 요청을 처리합니다.');
INSERT INTO "questions" VALUES(127,4,49,3,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d3-056','ko','5G 통신사 망 내 초저지연 모바일 AR 게임 엣지 배포 (AWS Wavelength)','모바일 AR 게임 회사가 5G 이용자에게 단말에서 서버까지 왕복 지연시간을 최소화하려 합니다. 통신사 네트워크에서 인터넷 구간을 거치는 홉 수를 줄여야 하며, 게임 로직은 EC2에서 실행됩니다. 게임 서버는 EC2 기반이며 사용자는 통신사 5G 커버리지 지역에 집중되어 있습니다. 이 요구사항에 가장 적합한 배포 위치는 어디입니까?','[{"key": "A", "text": "통신사 5G 네트워크 안에 있는 AWS Wavelength Zone에 게임 서버를 배포한다"}, {"key": "B", "text": "Amazon CloudFront로 게임 서버 응답을 캐시해 엣지 로케이션에서 반환한다"}, {"key": "C", "text": "가장 가까운 AWS 리전에 게임 서버를 배포하고 Global Accelerator를 앞단에 둔다"}, {"key": "D", "text": "대도시의 AWS Local Zone에 게임 서버를 배포하고 인터넷으로 단말과 연결한다"}]',0,'[0]','A','A — A) 통신사 5G 네트워크 안에 있는 AWS Wavelength Zone에 게임 서버를 배포한다','["AWS Wavelength", "5G Edge Computing", "Ultra-Low Latency", "Amazon EC2", "Mobile Gaming"]','AWS Wavelength, 5G Edge Computing, Ultra-Low Latency, Amazon EC2, Mobile Gaming','A: Wavelength는 통신사 5G 네트워크 내부에 AWS 컴퓨팅을 두어 모바일 트래픽이 인터넷 구간을 거치지 않게 합니다. B는 개인화된 실시간 게임 트래픽 캐싱에 부적합하고, C와 D는 통신사 네트워크 밖이라 홉이 남습니다.

[핵심 아키텍처 포인트] 모바일 단말이 인터넷 구간을 거치지 않고 통신사 5G 코어 네트워크 내부에서 EC2 게임 서버에 직결되어 왕복 지연을 극소화하려면 AWS Wavelength Zone을 사용합니다.');
INSERT INTO "questions" VALUES(128,3,49,4,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-088','ko','Graviton·Fargate 전환 대비 유연한 약정 할인 조합 (Compute Savings Plans + RDS RI)','한 회사의 월 지출 구성은 EC2 온디맨드 55%, Fargate와 Lambda 20%, RDS for PostgreSQL 15%, 기타 10%입니다. 앞으로 1년간 EC2는 Graviton 인스턴스 패밀리로 바꿀 예정이고 ECS 워크로드는 Fargate와 EC2를 혼용하며 이동 중입니다. 약정 할인을 최대화하면서 이러한 변경에 유연한 구매 조합 두 가지는 무엇입니까? (2개 선택)','[{"key": "A", "text": "EC2, Fargate, Lambda 사용량에 적용되는 Compute Savings Plans를 구매한다"}, {"key": "B", "text": "m5 패밀리에 대한 3년 EC2 Instance Savings Plans를 구매한다"}, {"key": "C", "text": "RDS for PostgreSQL 인스턴스에는 RDS Reserved DB Instances를 구매한다"}, {"key": "D", "text": "EC2 인스턴스에 3년 Standard 예약 인스턴스를 구매한다"}, {"key": "E", "text": "RDS 사용량까지 포함되도록 Compute Savings Plans의 시간당 약정을 크게 설정한다"}]',NULL,'[0, 2]','A, C','A, C — A) EC2, Fargate, Lambda 사용량에 적용되는 Compute Savings Plans를 구매한다 / C) RDS for PostgreSQL 인스턴스에는 RDS Reserved DB Instances를 구매한다','["Compute Savings Plans", "RDS Reserved Instances", "AWS Graviton", "AWS Fargate", "Cost Optimization"]','Compute Savings Plans, RDS Reserved Instances, AWS Graviton, AWS Fargate, Cost Optimization','Compute Savings Plans는 인스턴스 패밀리·리전·OS와 무관하게 EC2, Fargate, Lambda에 적용되어 Graviton 전환과 혼용에 유연하고, RDS는 RDS RI로 커버합니다. EC2 Instance SP와 Standard RI는 패밀리에 고정되어 Graviton 이전 시 낭비되며, Compute SP는 RDS에 적용되지 않으므로 약정만 키우면 초과분이 낭비됩니다.
참고: Savings Plans User Guide – Savings Plans types / Amazon RDS User Guide – Reserved DB instances

[핵심 아키텍처 포인트] Compute Savings Plans는 EC2 인스턴스 패밀리(x86→Graviton)·Fargate·Lambda 간 전환에도 자동 적용되며, RDS 사용량은 별도 RDS 예약 인스턴스로 할인율과 유연성을 극대화합니다.');
INSERT INTO "questions" VALUES(129,3,50,4,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-095','ko','대량 EBS 스냅샷 장기 보관 비용 75% 절감 및 수명 주기 자동화 (Snapshots Archive + DLM)','감사에서 EBS 스냅샷 18만 개가 보존 정책 없이 쌓여 있음이 드러났습니다. 규정상 분기 말 스냅샷은 7년간 보관해야 하고 이 스냅샷의 복원은 하루 이상 걸려도 됩니다. 나머지 일일 스냅샷은 90일만 보관하면 되며 앞으로 쌓이는 스냅샷 관리는 자동화하려 합니다. 스냅샷은 모두 us-east-1에 있고 팀은 변경 관리가 쉬운 관리형 기능을 우선합니다. 비용을 줄이는 두 가지 조치는 무엇입니까? (2개 선택)','[{"key": "A", "text": "90일 보관 스냅샷을 포함한 모든 스냅샷을 즉시 Archive 계층으로 이동한다"}, {"key": "B", "text": "7년 보관 대상 스냅샷을 EBS Snapshots Archive 계층으로 이동한다"}, {"key": "C", "text": "7년 보관 스냅샷을 재해 복구를 위해 다른 리전으로 복사해 이중으로 보관한다"}, {"key": "D", "text": "Amazon Data Lifecycle Manager 정책으로 일일 스냅샷을 90일 후 자동 삭제한다"}, {"key": "E", "text": "원본 EBS 볼륨을 sc1 유형으로 변경해 스냅샷 크기를 줄인다"}]',NULL,'[1, 3]','B, D','B, D — B) 7년 보관 대상 스냅샷을 EBS Snapshots Archive 계층으로 이동한다 / D) Amazon Data Lifecycle Manager 정책으로 일일 스냅샷을 90일 후 자동 삭제한다','["EBS Snapshots Archive", "Amazon Data Lifecycle Manager (DLM)", "Amazon EBS", "Snapshot Retention", "Cost Optimization"]','EBS Snapshots Archive, Amazon Data Lifecycle Manager (DLM), Amazon EBS, Snapshot Retention, Cost Optimization','Archive 계층은 90일 이상 드물게 접근하는 스냅샷의 저장 비용을 최대 75%까지 줄여 주며 복원에 시간이 걸려도 되는 장기 보관에 맞습니다. DLM은 보존 일수 기준 생성·삭제를 자동화합니다. 90일짜리까지 아카이브하면 최소 보관 기간 비용이 생기고, 리전 복사는 비용을 늘리며, 볼륨 유형은 스냅샷 크기에 영향이 없습니다.
참고: Amazon EBS User Guide – Archive Amazon EBS snapshots / Amazon Data Lifecycle Manager

[핵심 아키텍처 포인트] 90일 이상 장기 보관(7년) 스냅샷은 EBS Snapshots Archive 계층으로 이동해 최대 75% 절감하고, 일일 90일 만료 생성·삭제는 DLM 정책으로 완전 자동화합니다.');
INSERT INTO "questions" VALUES(130,3,51,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-091','ko','미완료 S3 멀티파트 업로드 숨은 스토리지 과금 자동 정리 (AbortIncompleteMultipartUpload)','미디어 회사가 현장 장비에서 S3 버킷으로 수십 GB 영상을 멀티파트 업로드합니다. 네트워크 중단으로 완료되지 않은 업로드가 쌓여 객체 목록에는 보이지 않는데도 S3 스토리지 비용이 계속 늘고 있습니다. 버킷에는 수십만 개의 객체가 있어 개별 확인은 현실적이지 않고 객체 버전 관리는 꺼져 있습니다. 기존과 향후 업로드를 모두 포함해 가장 적은 운영 노력으로 비용 증가를 막으려면 어떻게 해야 합니까?','[{"key": "A", "text": "버킷의 기본 스토리지 클래스를 S3 Intelligent-Tiering으로 바꿔 미완료 파트가 자동으로 더 저렴한 계층으로 이동하게 한다"}, {"key": "B", "text": "버킷에 AbortIncompleteMultipartUpload 수명 주기 규칙을 설정해 시작 후 일정 일수가 지난 미완료 업로드를 자동 삭제한다"}, {"key": "C", "text": "현재 버전 객체에 만료 규칙을 추가해 일정 기간이 지난 객체를 삭제한다"}, {"key": "D", "text": "S3 Storage Lens 대시보드에서 미완료 업로드 용량을 확인하고 매월 수동으로 삭제한다"}]',1,'[1]','B','B — B) 버킷에 AbortIncompleteMultipartUpload 수명 주기 규칙을 설정해 시작 후 일정 일수가 지난 미완료 업로드를 자동 삭제한다','["Amazon S3", "S3 Lifecycle", "AbortIncompleteMultipartUpload", "Multipart Upload", "Cost Optimization"]','Amazon S3, S3 Lifecycle, AbortIncompleteMultipartUpload, Multipart Upload, Cost Optimization','미완료 멀티파트 업로드의 파트는 완료되거나 중단될 때까지 스토리지 요금이 발생하며, AbortIncompleteMultipartUpload 규칙으로 기존·신규 업로드를 모두 자동 정리할 수 있습니다. Intelligent-Tiering은 완료된 객체에 대한 기능이고, 객체 만료 규칙은 미완료 파트를 지우지 않으며, 수동 삭제는 지속적인 운영 부담입니다.
참고: Amazon S3 User Guide – Configuring a bucket lifecycle configuration to delete incomplete multipart uploads

[핵심 아키텍처 포인트] 네트워크 중단 등으로 미완료된 S3 멀티파트 업로드 파트는 객체 목록에 안 보여도 스토리지 비용이 누적되므로 수명 주기 규칙에 AbortIncompleteMultipartUpload를 필수 설정합니다.');
INSERT INTO "questions" VALUES(131,3,52,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-103','ko','순수 Python Lambda 함수 무코드 컴퓨팅 단가 20% 절감 (arm64 / Graviton2 전환)','순수 Python 3.12 코드와 순수 Python 패키지만 사용하는 Lambda 함수 30개가 x86_64 아키텍처에서 월 20억 번 호출됩니다. 호출당 실행 시간은 대부분 수백 ms이며 메모리 크기는 이미 최적화되어 있습니다. 함수는 컨테이너 이미지가 아닌 .zip 패키지로 배포되며 CI/CD 파이프라인으로 업데이트됩니다. 코드 변경을 최소화하면서 Lambda 요금을 줄이는 방법은 무엇입니까?','[{"key": "A", "text": "모든 함수에 프로비저닝된 동시성을 설정해 초기화 시간을 제거한다"}, {"key": "B", "text": "Lambda SnapStart를 활성화해 호출 시간을 줄인다"}, {"key": "C", "text": "함수를 EC2 Graviton 인스턴스의 컨테이너로 옮겨 상시 실행한다"}, {"key": "D", "text": "함수 아키텍처를 arm64(Graviton2)로 변경한다"}]',3,'[3]','D','D — D) 함수 아키텍처를 arm64(Graviton2)로 변경한다','["AWS Lambda", "AWS Graviton2", "arm64", "Serverless Cost", "Instruction Set Architecture"]','AWS Lambda, AWS Graviton2, arm64, Serverless Cost, Instruction Set Architecture','arm64 함수는 x86_64보다 GB-초 단가가 낮고 순수 Python 코드는 재빌드 없이 동작하는 경우가 많아, 설정 변경으로 요금을 줄입니다. 프로비저닝된 동시성은 대기 비용이 추가되고, SnapStart는 콜드 스타트 개선이 목적이며 복원 요금이 붙을 수 있습니다. EC2 이전은 운영 오버헤드가 커집니다.
참고: AWS Lambda Developer Guide – Selecting and configuring an instruction set architecture for your Lambda function

[핵심 아키텍처 포인트] 순수 Python 등 아키텍처 비의존 Lambda 함수는 명령어 세트를 x86_64에서 arm64(Graviton2)로 변경하는 것만으로 더 빠른 성능과 약 20% 낮은 GB-초 요금을 얻습니다.');
INSERT INTO "questions" VALUES(132,3,53,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-084','ko','60개 조직 계정 유휴 리소스 점검 중앙 보고서 자동화 (Trusted Advisor 조직 보기)','60개 계정을 운영하는 회사의 FinOps 팀이 모든 계정의 유휴 로드 밸런서, 연결되지 않은 탄력적 IP 주소, 사용률이 낮은 EBS 볼륨 같은 비용 최적화 점검 결과를 한곳에서 JSON/CSV 보고서로 받으려 합니다. 보고서는 Athena로 분석할 수 있는 기계 판독 형식이어야 하고, 계정 담당자에게 별도 권한을 요청하지 않으려 합니다. 계정마다 로그인하지 않고 AWS 관리형 기능만으로 구성하려면 어떻게 합니까?','[{"key": "A", "text": "각 멤버 계정의 Trusted Advisor 콘솔에 로그인해 점검 결과를 내보내고 스프레드시트로 합친다"}, {"key": "B", "text": "AWS Config 집계자(aggregator)를 만들고 관리형 규칙으로 유휴 리소스를 점검해 조직 단위로 조회한다"}, {"key": "C", "text": "관리 계정에서 Trusted Advisor 조직 보기를 활성화하고 지원 플랜 요건을 충족한 뒤 비용 최적화 점검 보고서를 생성한다"}, {"key": "D", "text": "Compute Optimizer를 조직 전체에서 신뢰할 수 있는 서비스로 활성화하고, 위임된 관리자 계정에서 유휴 로드 밸런서와 미연결 탄력적 IP 주소 권장 사항을 모아 조회한다"}]',2,'[2]','C','C — C) 관리 계정에서 Trusted Advisor 조직 보기를 활성화하고 지원 플랜 요건을 충족한 뒤 비용 최적화 점검 보고서를 생성한다','["AWS Trusted Advisor", "Organizational View", "AWS Organizations", "FinOps", "Idle Resources"]','AWS Trusted Advisor, Organizational View, AWS Organizations, FinOps, Idle Resources','Trusted Advisor 조직 보기는 Organizations의 모든 계정 점검 결과를 보고서로 집계합니다. 멤버 계정별 로그인은 수작업이며, Config 규칙은 EBS 사용률 같은 점검을 대신하지 못하고 직접 정의가 필요합니다. Compute Optimizer는 EC2·EBS·Lambda 등의 크기 권장 도구라 유휴 ELB·미연결 EIP를 다루지 않습니다.
참고: AWS Support User Guide – Organizational view for AWS Trusted Advisor

[핵심 아키텍처 포인트] 관리 계정에서 Trusted Advisor 조직 보기를 활성화하면 별도 스크립트나 멤버 계정 로그인 없이 전 계정의 유휴 ELB·미연결 EIP·저사용 EBS 점검 결과를 JSON/CSV로 일괄 내보낼 수 있습니다.');
INSERT INTO "questions" VALUES(133,3,54,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-083','ko','공유 서비스 계정 월 비용의 사업부 지출 비례 자동 배부 (AWS Cost Categories Split Charge)','한 회사의 공유 서비스 계정(네트워크, 로깅, 보안 도구)에서 발생하는 월 비용을 3개 사업부가 각자의 AWS 지출 비율에 따라 나누어 부담하기로 했습니다. 사업부는 여러 계정과 태그에 걸쳐 있으며, 재무팀은 Cost Explorer와 AWS Budgets에서 배부가 반영된 사업부별 금액을 보길 원합니다. 코드 개발 없이 구현하는 방법은 무엇입니까?','[{"key": "A", "text": "AWS Cost Categories에 계정·태그 기준의 사업부 규칙을 만들고 공유 계정 비용을 비례 배분하는 split charge 규칙을 추가한다"}, {"key": "B", "text": "공유 계정의 모든 리소스에 사업부 태그를 붙이고 Cost Explorer 태그 필터로 사업부별 비용을 조회한다"}, {"key": "C", "text": "Cost and Usage Report를 Athena로 쿼리해 사업부 비율대로 비용을 나누는 SQL을 만들고 Lambda와 EventBridge로 매월 자동 실행해 결과를 저장한다"}, {"key": "D", "text": "AWS Organizations SCP로 공유 계정 리소스의 비용이 각 사업부 계정 청구서에 포함되도록 설정한다"}]',0,'[0]','A','A — A) AWS Cost Categories에 계정·태그 기준의 사업부 규칙을 만들고 공유 계정 비용을 비례 배분하는 split charge 규칙을 추가한다','["AWS Cost Categories", "Split Charge Rules", "Cost Allocation", "Cost Explorer", "AWS Budgets"]','AWS Cost Categories, Split Charge Rules, Cost Allocation, Cost Explorer, AWS Budgets','Cost Categories의 split charge 규칙은 공유 비용을 비례·고정·균등 방식으로 사업부에 배분하며 Cost Explorer와 Budgets에서 필터로 쓸 수 있습니다. 공유 리소스 태깅은 단일 사업부로 귀속되지 않아 배부가 안 되고, Athena+Lambda는 개발이 필요합니다. SCP는 권한 제어 도구로 청구 귀속을 바꾸지 못합니다.
참고: AWS Billing and Cost Management User Guide – Managing your costs with AWS Cost Categories

[핵심 아키텍처 포인트] Cost Categories의 Split Charge 규칙을 사용하면 개발 없이 공유 계정(네트워크·보안 등) 비용을 각 사업부 지출 비율에 따라 배분하여 Cost Explorer와 Budgets에서 조회할 수 있습니다.');
INSERT INTO "questions" VALUES(134,3,55,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-115','ko','Amazon MSK 교차 AZ 컨슈머 데이터 전송 비용 제거 (Follower Fetching)','3개 AZ에 브로커가 분산된 Amazon MSK 클러스터를 같은 리전의 3개 AZ에 걸친 컨슈머 애플리케이션이 읽습니다. 컨슈머와 파티션 리더가 서로 다른 AZ에 있을 때 AZ 간 데이터 전송 요금이 월 수천 달러 발생합니다. 컨슈머 그룹은 AZ마다 하나씩 있으며 토픽의 복제 계수는 3입니다. 데이터 내구성과 가용성을 유지하면서 요금을 줄이려면 어떻게 해야 합니까?','[{"key": "A", "text": "follower fetching을 활성화한다(브로커 RackAwareReplicaSelector, 컨슈머 client.rack=자신의 AZ)"}, {"key": "B", "text": "토픽의 복제 계수를 1로 낮춰 브로커 간 복제 트래픽을 없앤다"}, {"key": "C", "text": "모든 컨슈머를 한 AZ에 몰아 배치한다"}, {"key": "D", "text": "컨슈머와 브로커 사이 트래픽을 Transit Gateway를 거치도록 라우팅하고 중앙 라우팅 테이블에서 AZ 간 전송 경로를 관리한다"}]',0,'[0]','A','A — A) follower fetching을 활성화한다(브로커 RackAwareReplicaSelector, 컨슈머 client.rack=자신의 AZ)','["Amazon MSK", "Follower Fetching", "RackAwareReplicaSelector", "Cross-AZ Data Transfer", "Cost Optimization"]','Amazon MSK, Follower Fetching, RackAwareReplicaSelector, Cross-AZ Data Transfer, Cost Optimization','follower fetching은 컨슈머가 같은 AZ의 팔로워 복제본에서 읽게 해 AZ 간 전송을 줄이며, 복제 계수와 가용성은 그대로입니다. 복제 계수 1은 내구성을 잃고, 한 AZ로 몰면 AZ 장애에 취약하며, Transit Gateway 경유는 처리 요금이 추가되어 비용이 늘어납니다.
참고: Amazon MSK Developer Guide – Follower fetching / AWS blog on reducing MSK consumer network cost with rack awareness

[핵심 아키텍처 포인트] MSK 브로커의 RackAwareReplicaSelector와 컨슈머 rack ID를 설정해 Follower Fetching을 활성화하면 컨슈머가 동일 AZ 내 팔로워 브로커에서 읽어 교차 AZ 전송 요금을 없앱니다.');
INSERT INTO "questions" VALUES(135,3,56,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-116','ko','다수 저트래픽 마이크로서비스 ALB 시간당 고정비 통합 절감 (호스트 기반 라우팅 + SNI)','한 회사가 마이크로서비스 45개를 서비스마다 별도의 ALB 45개로 노출하고 있으며 대부분 트래픽이 매우 낮아 로드 밸런서 시간당 요금이 큰 비중을 차지합니다. 모든 서비스는 HTTPS이고 서브도메인으로 구분됩니다. 서비스 간 트래픽은 서브도메인으로만 구분되며 각 서비스의 보안 그룹 규칙은 유지해야 합니다. 다중 AZ 가용성을 유지하면서 비용을 줄이는 방법은 무엇입니까?','[{"key": "A", "text": "각 ALB를 NLB로 교체하고 호스트 이름으로 서비스를 구분한다"}, {"key": "B", "text": "서비스마다 API Gateway REST API를 만들어 ALB를 제거하고 VPC 링크로 연결한다"}, {"key": "C", "text": "ALB 하나로 통합해 호스트 기반 규칙과 SNI 다중 인증서로 서비스별 대상 그룹에 라우팅한다"}, {"key": "D", "text": "모든 ALB 앞에 CloudFront 배포를 두어 ALB 요금을 줄인다"}]',2,'[2]','C','C — C) ALB 하나로 통합해 호스트 기반 규칙과 SNI 다중 인증서로 서비스별 대상 그룹에 라우팅한다','["Application Load Balancer (ALB)", "Host-Based Routing", "SNI (Server Name Indication)", "Microservices", "Cost Optimization"]','Application Load Balancer (ALB), Host-Based Routing, SNI (Server Name Indication), Microservices, Cost Optimization','ALB는 로드 밸런서마다 시간당 요금이 붙으므로 호스트 기반 라우팅과 SNI로 하나에 통합하면 개수에 비례한 고정 비용을 줄이면서 다중 AZ 구성을 유지합니다. NLB는 L7 호스트 라우팅을 하지 못하고, API Gateway는 요청당 요금이 추가되며, CloudFront는 ALB 개수를 줄이지 못합니다.
참고: Elastic Load Balancing User Guide – Application Load Balancer listener rules (host conditions) and SNI

[핵심 아키텍처 포인트] 45개 서비스마다 ALB를 두면 시간당 고정 요금이 45배 발생하므로 단일 ALB에 SNI 다중 인증서와 호스트 헤더 기반 라우팅 규칙을 구성해 대상 그룹과 개별 SG를 유지하며 비용을 대폭 줄입니다.');
INSERT INTO "questions" VALUES(136,3,57,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-119','ko','월 160TB 지속 하이브리드 전송 요금·지연 절감 (AWS Direct Connect Private VIF)','한 회사가 온프레미스 데이터센터에서 AWS로 월 40TB를 업로드하고 AWS에서 데이터센터로 월 120TB를 내려받습니다. 현재 Site-to-Site VPN과 인터넷 경로를 사용하며 데이터 전송 요금과 변동하는 지연이 문제입니다. 사용량은 향후 3년간 유지될 전망입니다. 비용과 지연 문제를 함께 줄이는 방법은 무엇입니까?','[{"key": "A", "text": "Transit Gateway에 VPN 연결을 여러 개 만들어 ECMP로 대역폭을 늘린다"}, {"key": "B", "text": "AWS Direct Connect 전용 연결을 구성하고 프라이빗 가상 인터페이스로 전환한다"}, {"key": "C", "text": "S3 Transfer Acceleration을 활성화해 데이터센터와 S3 사이 전송을 가속한다"}, {"key": "D", "text": "매월 AWS Snowball Edge 디바이스를 주문해 데이터를 오프라인으로 옮긴다"}]',1,'[1]','B','B — B) AWS Direct Connect 전용 연결을 구성하고 프라이빗 가상 인터페이스로 전환한다','["AWS Direct Connect", "Private Virtual Interface", "Data Transfer Cost", "Hybrid Networking", "Cost Optimization"]','AWS Direct Connect, Private Virtual Interface, Data Transfer Cost, Hybrid Networking, Cost Optimization','대량·지속적인 데이터 전송에는 Direct Connect가 인터넷 경로보다 낮은 데이터 전송 요금과 일관된 지연을 제공해 3년 유지되는 사용량에서 이점이 큽니다. VPN ECMP는 TGW 처리 요금이 추가되고 인터넷 변동성이 남으며, Transfer Acceleration은 추가 요금이 있고 AWS→온프레미스 다운로드를 줄이지 못하며, 매월 Snowball은 비현실적입니다.
참고: AWS Direct Connect User Guide – What is AWS Direct Connect (data transfer pricing and benefits)

[핵심 아키텍처 포인트] 월 120TB 이상의 대규모 아웃바운드 데이터 전송이 장기 지속될 때는 인터넷/VPN 대비 GB당 이그레스 요금이 크게 저렴하고 일관된 지연을 제공하는 Direct Connect 전용 연결이 경제적입니다.');
INSERT INTO "questions" VALUES(137,3,58,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-104','ko','월 수십억 건 경량 Viewer 요청 엣지 비용 극소화 (Lambda@Edge → CloudFront Functions)','이커머스 회사가 CloudFront 앞단의 viewer 이벤트에서 모든 요청의 URL을 /index.html로 재작성하고 응답에 보안 헤더를 추가하는 로직을 Lambda@Edge로 구현했는데, 월 수십억 건 요청에 비용이 큽니다. 로직은 네트워크 호출 없이 몇 줄의 JavaScript면 충분합니다. 지연 시간을 유지하며 비용을 줄이는 방법은 무엇입니까?','[{"key": "A", "text": "Lambda@Edge 함수의 메모리를 최소 크기로 줄인다"}, {"key": "B", "text": "로직을 origin request 이벤트로 옮겨 캐시 미스 때만 실행되게 한다"}, {"key": "C", "text": "로직을 CloudFront Functions의 viewer 이벤트 함수로 이전한다"}, {"key": "D", "text": "로직을 Lambda@Edge에서 빼고 오리진 ALB의 리스너 규칙과 Lambda 대상 그룹으로 처리하도록 변경한다"}]',2,'[2]','C','C — C) 로직을 CloudFront Functions의 viewer 이벤트 함수로 이전한다','["Amazon CloudFront", "CloudFront Functions", "Lambda@Edge", "Edge Cost Optimization", "Viewer Request/Response"]','Amazon CloudFront, CloudFront Functions, Lambda@Edge, Edge Cost Optimization, Viewer Request/Response','URL 재작성과 헤더 조작처럼 짧고 가벼운 로직은 CloudFront Functions가 더 저렴하고 서브밀리초로 실행됩니다. 메모리 축소는 viewer 이벤트에서 효과가 작고, origin request로 옮기면 캐시 적중 응답에는 헤더가 붙지 않아 요구가 깨집니다. ALB 처리는 엣지 지연과 오리진 부하를 되돌립니다.
참고: Amazon CloudFront Developer Guide – Differences between CloudFront Functions and Lambda@Edge

[핵심 아키텍처 포인트] 외부 통신 없이 요청 URL 재작성이나 보안 헤더 삽입만 수행하는 경량 엣지 로직은 Lambda@Edge 대비 약 1/6 비용과 서브밀리초 성능의 CloudFront Functions로 이전해야 합니다.');
INSERT INTO "questions" VALUES(138,3,59,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-086','ko','약정 할인 미활용 낭비 조기 감지를 위한 AWS Budgets SP/RI 사용률 알림','한 회사가 1년 Compute Savings Plans와 RDS 예약 인스턴스를 구매했습니다. 사업 축소로 컴퓨팅 사용량이 줄면 약정이 활용되지 못하고 낭비될 수 있어, 약정 사용률이 기준 이하로 떨어지면 FinOps 팀에 자동으로 알리려 합니다. 추가 인프라 없이 가장 적은 설정으로 구현하는 방법은 무엇입니까?','[{"key": "A", "text": "AWS Budgets에서 Savings Plans 사용률 예산과 RI 사용률 예산을 만들고 임계값 미만이 되면 SNS나 이메일로 알린다"}, {"key": "B", "text": "AWS Budgets에서 월 목표 금액의 비용 예산을 만들고 실제 지출이 초과하면 알린다"}, {"key": "C", "text": "Cost Anomaly Detection 모니터를 서비스별로 만들어 비정상 지출 알림을 받는다"}, {"key": "D", "text": "CloudWatch에서 EC2 CPUUtilization 알람을 만들고 평균 사용률이 낮아지면 FinOps 팀 주소로 SNS 알림을 보내도록 인스턴스 그룹마다 구성한다"}]',0,'[0]','A','A — A) AWS Budgets에서 Savings Plans 사용률 예산과 RI 사용률 예산을 만들고 임계값 미만이 되면 SNS나 이메일로 알린다','["AWS Budgets", "Savings Plans Utilization", "RI Utilization", "FinOps", "Cost Monitoring"]','AWS Budgets, Savings Plans Utilization, RI Utilization, FinOps, Cost Monitoring','AWS Budgets는 Savings Plans·RI의 사용률(utilization)과 적용 범위(coverage)를 기준으로 예산을 만들고 임계값 알림을 보낼 수 있습니다. 비용 예산은 지출 초과만 감지하므로 약정 낭비를 알지 못하고, 이상 탐지는 급증한 지출을 찾는 도구입니다. CPU 알람은 약정 활용도와 직접 관련이 없습니다.
참고: AWS Cost Management User Guide – Managing your costs with AWS Budgets (Savings Plans and RI budgets)

[핵심 아키텍처 포인트] 비용 금액 알림만으로는 약정 유휴 낭비를 놓칠 수 있으므로 AWS Budgets에서 Savings Plans·RI 사용률(Utilization) 예산을 설정해 기준치 미만 시 자동 경보를 받습니다.');
INSERT INTO "questions" VALUES(139,3,60,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-118','ko','EC2 800대 퍼블릭 IPv4 시간당 과금 절감 (프라이빗 서브넷 + AZ별 NAT Gateway 전환)','개발 조직의 계정에서 EC2 인스턴스 800대가 퍼블릭 서브넷에서 자동 할당 퍼블릭 IPv4 주소를 받고 있습니다. 인스턴스는 인터넷의 인바운드 요청을 받지 않고 IPv4 전용 외부 저장소에서 패키지를 내려받는 아웃바운드만 필요하며 월 전송량은 인스턴스당 수 GB입니다. 퍼블릭 IPv4 시간당 요금을 줄이는 가장 적절한 방법은 무엇입니까?','[{"key": "A", "text": "자동 할당 퍼블릭 IP를 탄력적 IP 주소로 교체해 고정 주소로 사용한다"}, {"key": "B", "text": "서브넷의 퍼블릭 IP 자동 할당만 끄고 인스턴스는 퍼블릭 서브넷에 그대로 두어 주소 수를 줄인다"}, {"key": "C", "text": "인스턴스에 IPv6 주소만 부여하고 IPv4 연결은 제거한다"}, {"key": "D", "text": "인스턴스를 프라이빗 서브넷으로 옮기고 AZ별 NAT Gateway로 아웃바운드를 제공한다"}]',3,'[3]','D','D — D) 인스턴스를 프라이빗 서브넷으로 옮기고 AZ별 NAT Gateway로 아웃바운드를 제공한다','["Amazon VPC", "Public IPv4 Pricing", "NAT Gateway", "Private Subnet", "Cost Optimization"]','Amazon VPC, Public IPv4 Pricing, NAT Gateway, Private Subnet, Cost Optimization','AWS는 실행 중인 인스턴스에 붙은 주소와 탄력적 IP 주소를 포함한 모든 퍼블릭 IPv4 주소에 시간당 요금을 부과합니다. 800개의 주소를 AZ별 NAT Gateway 몇 개의 주소로 줄이면 전송량이 적을 때 비용이 줄어듭니다. 탄력적 IP 주소도 과금되고, 주소 없이 퍼블릭 서브넷에 두면 아웃바운드가 막히며, IPv4 전용 저장소는 IPv6로 접근할 수 없습니다.
참고: Amazon VPC User Guide – IP addressing (public IPv4 addresses)

[핵심 아키텍처 포인트] 모든 퍼블릭 IPv4 주소에 시간당 요금이 부과되므로, 인바운드가 불필요한 EC2 800대는 프라이빗 서브넷으로 옮기고 소수의 AZ별 NAT Gateway로 아웃바운드를 집약해 IPv4 비용을 절감합니다.');
INSERT INTO "questions" VALUES(140,4,50,4,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-117','ko','NAT Gateway 대량 S3·DynamoDB 처리 요금 제거 (VPC Gateway Endpoints)','프라이빗 서브넷의 VPC 연결 Lambda와 EC2 배치 서버가 NAT Gateway를 통해 같은 리전의 S3 버킷과 DynamoDB 테이블에 월 80TB를 읽고 쓰며, NAT Gateway 데이터 처리 요금이 큽니다. 보안 요건상 트래픽은 인터넷을 거치지 않아야 합니다. 비용을 줄이는 두 가지 조치는 무엇입니까? (2개 선택)','[{"key": "A", "text": "S3와 DynamoDB 모두 인터페이스 엔드포인트(AWS PrivateLink)로 연결한다"}, {"key": "B", "text": "VPC에 S3용 게이트웨이 엔드포인트를 만들고 서브넷 라우팅 테이블에 연결한다"}, {"key": "C", "text": "서브넷을 퍼블릭으로 바꾸고 인스턴스에 퍼블릭 IP를 부여해 인터넷 게이트웨이를 사용한다"}, {"key": "D", "text": "NAT Gateway를 NAT 인스턴스로 교체해 시간당 요금을 낮춘다"}, {"key": "E", "text": "VPC에 DynamoDB용 게이트웨이 엔드포인트를 만들고 서브넷 라우팅 테이블에 연결한다"}]',NULL,'[1, 4]','B, E','B, E — B) VPC에 S3용 게이트웨이 엔드포인트를 만들고 서브넷 라우팅 테이블에 연결한다 / E) VPC에 DynamoDB용 게이트웨이 엔드포인트를 만들고 서브넷 라우팅 테이블에 연결한다','["VPC Gateway Endpoint", "Amazon S3", "Amazon DynamoDB", "NAT Gateway", "Data Transfer Cost"]','VPC Gateway Endpoint, Amazon S3, Amazon DynamoDB, NAT Gateway, Data Transfer Cost','S3와 DynamoDB 게이트웨이 엔드포인트는 추가 요금이 없고 트래픽이 AWS 네트워크 안에 머물러 NAT 처리 요금과 인터넷 경유를 모두 없앱니다. 인터페이스 엔드포인트는 시간당·GB당 요금이 붙고, 퍼블릭 IP 경유는 보안 요건을 깨며, NAT 인스턴스는 운영 부담을 키우면서 대용량 트래픽 문제를 해결하지 못합니다.
참고: Amazon VPC User Guide – Gateway endpoints for Amazon S3 and DynamoDB

[핵심 아키텍처 포인트] VPC 내 S3와 DynamoDB용 Gateway Endpoint는 시간당·GB당 추가 요금이 무료이므로 라우팅 테이블 연결만으로 월 80TB NAT Gateway 데이터 처리 비용과 인터넷 경유를 제거합니다.');
INSERT INTO "questions" VALUES(141,4,51,4,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-059','ko','DynamoDB 대용량 저빈도 테이블 및 만료 세션 비용 최적화 (Standard-IA + TTL)','한 회사의 DynamoDB에는 (1) 90일 이후 거의 읽지 않지만 7년간 보관해야 하는 감사 테이블(저장 용량이 처리량 비용보다 훨씬 큼)과 (2) 24시간 뒤에는 필요 없는 세션 항목이 계속 쌓이는 세션 테이블이 있습니다. 각 문제를 해결하는 비용 최적화 방법 두 가지는 무엇입니까? (2개 선택)','[{"key": "A", "text": "세션 테이블을 Standard-IA로 변경해 저장 요금을 낮춘다"}, {"key": "B", "text": "감사 테이블에 90일 TTL을 설정해 오래된 항목을 삭제한다"}, {"key": "C", "text": "감사 테이블의 테이블 클래스를 DynamoDB Standard-IA로 변경한다"}, {"key": "D", "text": "Lambda가 세션 테이블을 주기적으로 Scan해 만료 항목을 삭제한다"}, {"key": "E", "text": "세션 테이블에 TTL 속성을 설정해 만료된 항목을 자동 삭제한다"}]',NULL,'[2, 4]','C, E','C, E — C) 감사 테이블의 테이블 클래스를 DynamoDB Standard-IA로 변경한다 / E) 세션 테이블에 TTL 속성을 설정해 만료된 항목을 자동 삭제한다','["Amazon DynamoDB", "DynamoDB Standard-IA", "DynamoDB TTL", "Storage Optimization", "Cost Optimization"]','Amazon DynamoDB, DynamoDB Standard-IA, DynamoDB TTL, Storage Optimization, Cost Optimization','저장 비중이 큰 드문 접근 테이블은 Standard-IA(C)가, 만료 항목은 쓰기 용량을 소모하지 않는 TTL 삭제(E)가 적합합니다. A은 자주 읽고 쓰는 테이블이라 요청 단가가 더 높고, B는 7년 보관 요건 위반이며, D은 Scan·Delete로 용량을 소모합니다.

[핵심 아키텍처 포인트] 스토리지 비중이 큰 장기 저빈도 감사 테이블은 Standard-IA 테이블 클래스로 저장 비용을 약 60% 줄이고, 만료 세션은 WCU 소모 없는 무료 TTL 속성으로 자동 삭제합니다.');
INSERT INTO "questions" VALUES(142,4,52,4,2,'MULTI','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-052','ko','상시 API 서버 및 중단 허용 야간 배치 혼합 비용 최적화 (Compute SP + Spot)','한 플랫폼은 (1) 24시간 일정하게 실행되는 API 서버 군(단일 리전, 향후 Fargate 이전 가능성 있음)과 (2) 야간에만 실행되며 중단되어도 재시도할 수 있는 대규모 배치 처리로 구성됩니다. 두 워크로드 모두 비용을 효과적으로 줄이는 구매 전략 두 가지는 무엇입니까? (2개 선택)','[{"key": "A", "text": "API 서버의 상시 사용량 기준으로 Compute Savings Plans를 구매한다"}, {"key": "B", "text": "배치 처리 워크로드에도 3년 Standard 예약 인스턴스를 구매한다"}, {"key": "C", "text": "API 서버를 모두 Spot Instances로 전환한다"}, {"key": "D", "text": "배치 처리 서버를 Dedicated Hosts에서 실행한다"}, {"key": "E", "text": "배치 처리 워크로드에는 Spot Instances를 사용한다"}]',NULL,'[0, 4]','A, E','A, E — A) API 서버의 상시 사용량 기준으로 Compute Savings Plans를 구매한다 / E) 배치 처리 워크로드에는 Spot Instances를 사용한다','["Compute Savings Plans", "Spot Instances", "Amazon EC2", "AWS Fargate", "Cost Optimization"]','Compute Savings Plans, Spot Instances, Amazon EC2, AWS Fargate, Cost Optimization','상시 부하는 유연한 Compute Savings Plans(A)로, 중단 가능한 야간 배치는 Spot(E)으로 비용을 줄입니다. B은 하루 대부분 유휴 시간에도 약정 비용이 나가고, C는 24시간 API에 중단 위험이 있으며, D은 불필요한 고비용 구성입니다.

[핵심 아키텍처 포인트] 24시간 상시 가동되며 향후 Fargate 이전 가능성이 있는 API 군에는 유연한 Compute Savings Plans를, 중단·재시도 가능한 야간 배치에는 Spot 인스턴스를 적용합니다.');
INSERT INTO "questions" VALUES(143,4,53,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-114','ko','RDS PostgreSQL 동일 패밀리 인스턴스 크기·다중 AZ 유연성 활용 (정규화 단위 유지)','회사는 RDS for PostgreSQL db.r6g.2xlarge Single-AZ에 대해 1년 Reserved DB Instance를 구매했습니다. 최적화 결과 3개월 뒤 같은 리전에서 db.r6g.xlarge 다중 AZ 구성으로 바꿀 계획입니다. 새 예약을 구매하지 않고 기존 구매 할인을 최대한 유지하려면 어떻게 해야 합니까?','[{"key": "A", "text": "기존 RI를 취소하고 남은 기간의 선결제 금액을 환불받은 뒤 xlarge 다중 AZ RI를 새로 구매한다"}, {"key": "B", "text": "추가 조치 없이 인스턴스를 수정한다. RDS RI는 같은 패밀리에서 크기 유연성이 적용되어 정규화 단위가 같다"}, {"key": "C", "text": "기존 2xlarge RI를 xlarge 다중 AZ RI로 교환하도록 AWS에 요청한다"}, {"key": "D", "text": "변경 전에 xlarge 다중 AZ RI를 추가 구매하고 기존 RI는 그대로 둔다"}]',1,'[1]','B','B — B) 추가 조치 없이 인스턴스를 수정한다. RDS RI는 같은 패밀리에서 크기 유연성이 적용되어 정규화 단위가 같다','["Amazon RDS", "Reserved DB Instances", "Size Flexibility", "PostgreSQL", "Normalized Units"]','Amazon RDS, Reserved DB Instances, Size Flexibility, PostgreSQL, Normalized Units','PostgreSQL의 RDS RI는 같은 리전·엔진·인스턴스 패밀리 안에서 크기 유연성이 있고 Single-AZ와 다중 AZ에도 적용되며, 2xlarge Single-AZ(16단위)는 xlarge 다중 AZ(16단위)와 같습니다. RDS RI는 취소할 수 없고, 환불이나 새 RI 구매는 중복 지출이 됩니다.
참고: Amazon RDS User Guide – Reserved DB instances for Amazon RDS (size-flexible reserved DB instances)

[핵심 아키텍처 포인트] PostgreSQL용 RDS RI는 동일 패밀리·리전 내 크기 유연성이 Multi-AZ까지 자동 적용되므로, db.r6g.2xlarge Single-AZ(16단위)에서 db.r6g.xlarge Multi-AZ(16단위)로 변경해도 추가 비용 없이 할인이 그대로 이어집니다.');
INSERT INTO "questions" VALUES(144,4,54,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-107','ko','실시간 알람·필터 불필요 감사 로그 수집비 절감 (CloudWatch Logs Infrequent Access)','마이크로서비스 로그를 CloudWatch Logs에 수집하는 회사의 로그 수집 요금이 월 비용 1위입니다. 상당수 로그 그룹(감사·디버그용)은 CloudWatch Logs Insights로 가끔 조회만 하고 실시간 알람, 구독 필터, 지표 필터는 사용하지 않습니다. 가장 적은 변경으로 수집 비용을 줄이려면 어떻게 해야 합니까?','[{"key": "A", "text": "기존 로그 그룹의 보존 기간을 1일로 단축한다"}, {"key": "B", "text": "모든 로그를 Kinesis Data Streams로 보내고 소비자 애플리케이션이 S3에 저장하게 한다"}, {"key": "C", "text": "로그 그룹마다 구독 필터를 만들어 Firehose로 S3에 전달하고 로그 그룹은 삭제한다"}, {"key": "D", "text": "해당 로그를 Infrequent Access 로그 클래스의 새 로그 그룹으로 보내도록 설정한다"}]',3,'[3]','D','D — D) 해당 로그를 Infrequent Access 로그 클래스의 새 로그 그룹으로 보내도록 설정한다','["Amazon CloudWatch Logs", "Infrequent Access Log Class", "Logs Insights", "Log Cost Optimization", "Observability"]','Amazon CloudWatch Logs, Infrequent Access Log Class, Logs Insights, Log Cost Optimization, Observability','Infrequent Access 로그 클래스는 Standard보다 수집 단가가 낮고 Logs Insights 조회를 지원하며, 지표 필터·구독 필터가 필요 없는 로그에 맞습니다. 로그 클래스는 생성 시 정해지므로 새 로그 그룹을 쓰면 됩니다. 보존 기간 단축은 저장 비용에만 영향이 있고, Kinesis·Firehose 경유는 구성과 비용이 오히려 늘어납니다.
참고: Amazon CloudWatch Logs User Guide – Log classes

[핵심 아키텍처 포인트] 실시간 지표·구독 필터 없이 Logs Insights 간헐적 조회만 필요한 로그 그룹은 Infrequent Access 로그 클래스로 생성해 수집(Ingestion) 비용을 50% 절감합니다.');
INSERT INTO "questions" VALUES(145,4,55,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-082','ko','선결제 RI 구매 월 비용 왜곡 없는 사업부 공정 비교 (Cost Explorer 상각 비용 보기)','중앙 FinOps 팀이 3년 All Upfront 예약 인스턴스를 구매하고, 월별 비용을 12개 사업부에 배부합니다. RI를 구매한 달에는 구매 계정의 비용이 한꺼번에 크게 잡혀 사업부 간 비교가 왜곡됩니다. 약정 비용이 약정 기간에 걸쳐 고르게 반영된 사업부별 비용 보고서를 추가 개발 없이 얻으려면 어떻게 해야 합니까?','[{"key": "A", "text": "Cost Explorer의 Unblended 비용 보기를 사용하고 RI를 구매한 달의 선결제 금액은 보고서에서 수동으로 제외한다"}, {"key": "B", "text": "All Upfront RI를 No Upfront 옵션으로 교환해 매달 같은 금액이 청구되도록 한다"}, {"key": "C", "text": "AWS Budgets에서 사업부별 비용 예산을 만들고 RI 구매 월의 초과 알림을 예외 처리한다"}, {"key": "D", "text": "Cost Explorer에서 상각(Amortized) 비용 보기를 선택하고 사업부 태그나 Cost Category로 그룹화한다"}]',3,'[3]','D','D — D) Cost Explorer에서 상각(Amortized) 비용 보기를 선택하고 사업부 태그나 Cost Category로 그룹화한다','["AWS Cost Explorer", "Amortized Costs", "All Upfront RI", "FinOps", "Chargeback"]','AWS Cost Explorer, Amortized Costs, All Upfront RI, FinOps, Chargeback','상각 비용 보기는 선결제·월 약정 요금을 사용 기간에 나누어 배분해 월별 비교가 가능합니다. Unblended 보기는 결제 시점 기준이라 구매 월이 왜곡됩니다. 지불 옵션은 구매 후 교환으로 바꿀 수 없고, Budgets 알림은 비용 배분 문제를 해결하지 못합니다.
참고: AWS Billing and Cost Management User Guide – Exploring your data using Cost Explorer (amortized costs)

[핵심 아키텍처 포인트] 3년 선결제 RI 구매 달에 금액이 일시 급등하는 왜곡을 없애고 약정 기간에 걸쳐 월별로 균등 배분해 비교하려면 Cost Explorer의 상각(Amortized) 비용 보기를 사용합니다.');
INSERT INTO "questions" VALUES(146,4,56,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-100','ko','재시도 가능 컨테이너 배치 Spot 중단 최소화 (AWS Batch SPOT_PRICE_CAPACITY_OPTIMIZED)','연구소가 야간에 독립적인 시뮬레이션 작업 수천 개(각 20~40분)를 AWS Batch에서 실행합니다. 작업은 재시도가 가능하고 마감은 아침까지입니다. 작업 이미지는 컨테이너로 패키징되어 있고 팀은 클러스터를 직접 관리하지 않으려 합니다. 컴퓨팅 비용을 줄이면서 Spot 중단으로 인한 작업 재실행을 줄이려면 컴퓨트 환경을 어떻게 구성해야 합니까?','[{"key": "A", "text": "온디맨드 컴퓨트 환경을 만들고 야간 사용량 기준으로 3년 Compute Savings Plans를 구매해 상시 단가를 낮추고 중단 가능성을 없앤다"}, {"key": "B", "text": "Spot 컴퓨트 환경에서 단일 인스턴스 유형과 BEST_FIT 할당 전략을 사용해 최저가 풀만 선택한다"}, {"key": "C", "text": "Spot 컴퓨트 환경에서 다양한 인스턴스 유형을 허용하고 SPOT_PRICE_CAPACITY_OPTIMIZED 전략과 작업 재시도를 설정한다"}, {"key": "D", "text": "Dedicated Hosts 위에 컴퓨트 환경을 구성해 인스턴스 중단 가능성을 없앤다"}]',2,'[2]','C','C — C) Spot 컴퓨트 환경에서 다양한 인스턴스 유형을 허용하고 SPOT_PRICE_CAPACITY_OPTIMIZED 전략과 작업 재시도를 설정한다','["AWS Batch", "Spot Instances", "SPOT_PRICE_CAPACITY_OPTIMIZED", "Allocation Strategy", "Batch Cost Optimization"]','AWS Batch, Spot Instances, SPOT_PRICE_CAPACITY_OPTIMIZED, Allocation Strategy, Batch Cost Optimization','재시도 가능한 단기 배치는 Spot에 적합하고, 유형을 다양화한 가격·용량 최적화 전략이 중단이 적은 풀을 선택해 줍니다. 야간에만 쓰는 워크로드에 3년 약정은 낭비이고, 단일 유형 BEST_FIT은 최저가를 따라가 중단이 잦으며, Dedicated Hosts는 비용이 높고 이 요구와 무관합니다.
참고: AWS Batch User Guide – Compute environments (allocation strategies)

[핵심 아키텍처 포인트] 중단 허용 컨테이너 배치에서 비용 절감과 중단 최소화를 동시에 달성하려면 다양한 인스턴스 유형을 허용하고 용량·가격 균형을 맞추는 SPOT_PRICE_CAPACITY_OPTIMIZED 전략을 선택합니다.');
INSERT INTO "questions" VALUES(147,4,57,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-109','ko','20TB Aurora 테스트 복제 시간·스토리지 비용 극소화 (Aurora Fast Cloning)','개발팀이 20TB Aurora MySQL 운영 클러스터의 데이터로 주 2회 통합 테스트 환경을 만듭니다. 현재는 스냅샷 복원에 몇 시간이 걸리고 매번 20TB 스토리지 비용이 추가됩니다. 테스트 중 변경되는 데이터는 소량이며 테스트 DB는 운영 DB와 독립적이어야 합니다. 시간과 스토리지 비용을 줄이는 방법은 무엇입니까?','[{"key": "A", "text": "AWS DMS로 운영 DB 전체를 테스트 클러스터로 매번 복제한다"}, {"key": "B", "text": "Aurora 클로닝(copy-on-write)으로 테스트 클러스터를 만들고 끝나면 삭제한다"}, {"key": "C", "text": "스냅샷 복원 뒤 테스트가 끝나면 삭제하는 작업을 Step Functions로 자동화한다"}, {"key": "D", "text": "운영 클러스터의 Aurora 읽기 전용 복제본에 접속해 테스트를 수행한다"}]',1,'[1]','B','B — B) Aurora 클로닝(copy-on-write)으로 테스트 클러스터를 만들고 끝나면 삭제한다','["Amazon Aurora", "Aurora Cloning", "Copy-on-Write", "Test Environment", "Storage Cost Optimization"]','Amazon Aurora, Aurora Cloning, Copy-on-Write, Test Environment, Storage Cost Optimization','Aurora 클론은 원본과 데이터 페이지를 공유하다 변경된 페이지만 새로 저장하므로 생성이 빠르고 추가 스토리지가 변경량만큼만 듭니다. DMS 복제와 스냅샷 복원은 전체 20TB를 새로 만들고, 읽기 전용 복제본은 쓰기가 안 되고 운영 클러스터와 독립적이지도 않아 테스트에 맞지 않습니다.
참고: Amazon Aurora User Guide – Cloning a volume for an Amazon Aurora DB cluster

[핵심 아키텍처 포인트] Aurora 클로닝은 Copy-on-Write 방식으로 원본 페이지를 공유하므로 20TB DB도 몇 분 만에 독립 클러스터를 생성하고 변경된 델타 페이지 만큼만 추가 스토리지를 과금합니다.');
INSERT INTO "questions" VALUES(148,4,58,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-110','ko','대규모 Redis 캐시 핫 데이터 15% 메모리 비용 절감 (ElastiCache r6gd Data Tiering)','세션·프로필 캐시로 ElastiCache for Redis OSS(r6g.4xlarge 12노드, 복제 그룹, Multi-AZ)를 쓰는 서비스가 있습니다. 전체 데이터셋 600GB 중 자주 접근하는 비율은 약 15%이고 나머지는 가끔 읽습니다. SSD 접근으로 수백 마이크로초 지연이 늘어도 되며 고가용성은 유지해야 합니다. 비용을 줄이는 방법은 무엇입니까?','[{"key": "A", "text": "r6gd 노드 유형의 데이터 계층화(data tiering)를 사용해 노드 수를 줄인다"}, {"key": "B", "text": "노드 유형을 r6g.8xlarge로 키우고 노드 수를 절반으로 줄여 인스턴스 관리 수를 줄인다"}, {"key": "C", "text": "Memcached 엔진으로 교체해 멀티스레드 효율로 노드 수를 줄인다"}, {"key": "D", "text": "복제본 노드를 제거하고 기본 노드만 유지한다"}]',0,'[0]','A','A — A) r6gd 노드 유형의 데이터 계층화(data tiering)를 사용해 노드 수를 줄인다','["Amazon ElastiCache", "Data Tiering", "r6gd Nodes", "NVMe SSD", "Memory Cost Optimization"]','Amazon ElastiCache, Data Tiering, r6gd Nodes, NVMe SSD, Memory Cost Optimization','일부 데이터만 자주 접근하는 큰 데이터셋은 r6gd의 데이터 계층화가 덜 쓰는 값을 SSD로 내려 메모리 비용을 줄이며 클라이언트 변경 없이 쓸 수 있습니다. 노드 확대는 메모리 단가가 같아 절감이 없고, Memcached는 복제·장애 조치가 없어 요건을 못 맞추며, 복제본 제거는 고가용성 요구를 깹니다.
참고: Amazon ElastiCache User Guide – Data tiering

[핵심 아키텍처 포인트] 전체 데이터 중 일부(15%)만 빈번히 접근하는 대규모 Redis 워크로드는 r6gd 노드의 데이터 계층화를 통해 콜드 데이터를 NVMe SSD로 자동 오프로드하여 비용을 크게 절감합니다.');
INSERT INTO "questions" VALUES(149,4,59,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-105','ko','초대량 단기 멱등 오케스트레이션 비용 절감 (Step Functions Standard → Express 전환)','주문 이벤트마다 3개의 Lambda 함수를 순차 호출하는 Step Functions Standard 워크플로가 하루 1억 번 실행되며 각 실행은 2초 안에 끝납니다. 상태 전환 요금이 Lambda 요금을 넘어섰습니다. 작업은 멱등적이어서 최소 한 번 이상 실행되어도 문제가 없습니다. 가장 효과적인 비용 절감 방법은 무엇입니까?','[{"key": "A", "text": "Lambda 함수 3개를 arm64 아키텍처로 변경하고 메모리를 조정해 함수 실행 요금을 줄인다"}, {"key": "B", "text": "Express 워크플로 유형의 새 상태 머신으로 전환해 실행·시간·메모리 기준으로 과금되게 한다"}, {"key": "C", "text": "Standard 워크플로의 실행 기록 보존 기간을 30일로 단축한다"}, {"key": "D", "text": "CloudWatch Logs 로깅 수준을 ERROR로 낮춘다"}]',1,'[1]','B','B — B) Express 워크플로 유형의 새 상태 머신으로 전환해 실행·시간·메모리 기준으로 과금되게 한다','["AWS Step Functions", "Express Workflows", "Standard Workflows", "Idempotent Processing", "Serverless Cost"]','AWS Step Functions, Express Workflows, Standard Workflows, Idempotent Processing, Serverless Cost','짧고 대량이며 멱등적인 워크로드는 상태 전환당 과금되는 Standard 대신 Express가 훨씬 저렴합니다. 워크플로 유형은 생성 후 바꿀 수 없어 새로 만들어야 합니다. arm64 변경은 Lambda 요금만 줄이고, 보존 기간과 로깅 수준은 상태 전환 요금과 무관합니다.
참고: AWS Step Functions Developer Guide – Choosing workflow type in Step Functions

[핵심 아키텍처 포인트] 상태 전환당 과금되는 Standard 대신 실행 수·시간·메모리 기반으로 과금되는 Express 워크플로(최대 5분, 최소 1회 실행)로 새 상태 머신을 구성하면 초당 대량 2초 작업 비용을 대폭 낮춥니다.');
INSERT INTO "questions" VALUES(150,4,60,4,1,'SINGLE','Power-xc/aws-saa-cert-quiz (MIT)','pxc-d4-075','ko','동일 리전 2개 VPC 월 100TB 무과금 데이터 교환 연결 (VPC Peering)','네트워크 팀은 두 VPC의 연결 방식에 대한 설계 검토를 진행 중입니다. 한 회사의 두 VPC(분석용 VPC와 데이터용 VPC)가 같은 리전에서 월 100TB 이상의 데이터를 교환합니다. 다른 VPC와의 연결 계획은 없고 두 VPC의 CIDR는 겹치지 않습니다. 네트워크 비용을 최소화하는 연결 방식은 무엇입니까?','[{"key": "A", "text": "Transit Gateway에 두 VPC를 연결한다"}, {"key": "B", "text": "인터넷 게이트웨이를 통해 퍼블릭 IP로 통신한다"}, {"key": "C", "text": "NLB 뒤에 서비스를 두고 PrivateLink 엔드포인트로 연결한다"}, {"key": "D", "text": "VPC peering 연결을 구성한다"}]',3,'[3]','D','D — D) VPC peering 연결을 구성한다','["VPC Peering", "AWS Transit Gateway", "Data Transfer Cost", "Inter-VPC Networking", "Cost Optimization"]','VPC Peering, AWS Transit Gateway, Data Transfer Cost, Inter-VPC Networking, Cost Optimization','VPC peering은 시간당 연결 요금과 GB당 처리 요금이 없고 AZ 간·리전 간 데이터 전송 요금만 부과되어 대용량 단순 연결에 가장 저렴합니다(D). Transit Gateway(A)는 attachment 시간당 요금과 GB당 처리 요금이 있고, 인터넷 경유(B)는 퍼블릭 IP 전송 요금이 발생하며, PrivateLink(C)는 엔드포인트 시간당 요금과 GB 처리 요금이 있습니다.

[핵심 아키텍처 포인트] VPC Peering은 연결 시간당 요금과 GB당 처리 요금이 없어 동일 리전·비중복 CIDR의 2개 VPC 간 100TB 이상 대량 트래픽 교환 시 Transit Gateway나 PrivateLink 대비 가장 저렴합니다.');
CREATE INDEX idx_questions_round ON questions(round_id, question_no);
CREATE INDEX idx_questions_domain ON questions(domain_id);
CREATE INDEX idx_questions_qtype ON questions(qtype_id);
CREATE INDEX idx_questions_source ON questions(source);
CREATE INDEX idx_choices_qid ON question_choices(question_id, choice_index);
CREATE INDEX idx_keywords_kw ON question_keywords(keyword);
CREATE VIEW v_questions_full AS
    SELECT
        q.question_id,
        q.round_id,
        r.round_code,
        r.round_title,
        q.question_no,
        q.domain_id,
        d.domain_code,
        d.domain_name,
        d.domain_name_en,
        d.official_weight_pct,
        q.qtype_id,
        q.qtype,
        t.qtype_name,
        q.source,
        q.source_ref_id,
        q.language,
        q.title,
        q.question_text,
        q.choices_json,
        q.answer_index,
        q.answer_indices_json,
        q.answer_keys,
        q.answer_text,
        q.keywords_json,
        q.keywords_text,
        q.explanation
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_domain d ON q.domain_id = d.domain_id
    JOIN categories_qtype t ON q.qtype_id = t.qtype_id;
CREATE VIEW v_domain_summary AS
    SELECT
        d.domain_id,
        d.domain_name,
        d.official_weight_pct,
        a.total_questions,
        a.bank_share_pct,
        a.single_count,
        a.multi_count,
        a.official_pdf_count,
        a.mit_count,
        a.top_keywords
    FROM domain_analytics a
    JOIN categories_domain d ON a.domain_id = d.domain_id
    ORDER BY d.domain_id;
CREATE VIEW v_source_summary AS
    SELECT
        source,
        COUNT(*) AS question_count,
        SUM(CASE WHEN qtype = 'SINGLE' THEN 1 ELSE 0 END) AS single_count,
        SUM(CASE WHEN qtype = 'MULTI' THEN 1 ELSE 0 END) AS multi_count
    FROM questions
    GROUP BY source
    ORDER BY question_count DESC;
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('question_choices',627);
INSERT INTO "sqlite_sequence" VALUES('question_keywords',750);
COMMIT;
