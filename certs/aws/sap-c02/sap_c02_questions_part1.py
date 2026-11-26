# -*- coding: utf-8 -*-
"""
SAP-C02 Question Bank Part 1:
- Round 1: Official AWS Sample Questions PDF (10 questions, verbatim verified from AWS PDF)
- Round 2 (Set 1): Domain 1 — Design Solutions for Organizational Complexity (16 questions)
- Round 3 (Set 2): Domain 2 — Design for New Solutions (16 questions)
Total in Part 1: 42 questions.

Tuple schema for each question:
(
    round_id, question_no, domain_id, qtype_id, select_count,
    source, difficulty, title, question_text, architecture_context,
    options, correct_options, answer_text, core_keywords, explanation, exam_tip
)
"""

QUESTIONS_PART_1 = [
    # =========================================================================
    # ROUND 1: AWS Official Sample Questions PDF (10 Questions)
    # Source: https://d1.awsstatic.com/training-and-certification/docs-sa-pro/AWS-Certified-Solutions-Architect-Professional_Sample-Questions.pdf
    # =========================================================================
    (
        1, 1, 1, 1, 1,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #1] 멀티어카운트 환경에서 사업부 자율권을 유지하며 과다 과금 조기 경보 구축",
        (
            "A company has many AWS accounts that individual business groups own. One of the accounts was "
            "recently compromised. The attacker launched a large number of instances, resulting in a high bill for that account.\n\n"
            "The company addressed the security breach, but a solutions architect needs to develop a solution to "
            "prevent excessive spending in all accounts. Each business group wants to retain full control of its AWS account.\n\n"
            "Which solution should the solutions architect recommend to meet these requirements?"
        ),
        "Requirement Constraints:\n- Multiple AWS accounts owned by independent business groups\n- Must retain FULL control for each business group\n- Detect/prevent excessive unexpected spending promptly",
        [
            {"label": "A", "text": "Use AWS Organizations. Add each AWS account to the management account. Create an SCP that uses the ec2:instanceType condition key to prevent the launch of high-cost instance types in each account."},
            {"label": "B", "text": "Attach a new customer-managed IAM policy to an IAM group in each account. Configure the policy to use the ec2:instanceType condition key to prevent the launch of high-cost instance types. Place all the existing IAM users in each group."},
            {"label": "C", "text": "Turn on billing alerts for each AWS account. Create Amazon CloudWatch alarms that send an Amazon Simple Notification Service (Amazon SNS) notification to the account administrator whenever the account exceeds a designated spending threshold."},
            {"label": "D", "text": "Turn on AWS Cost Explorer in each account. Review the Cost Explorer reports for each account on a regular basis to ensure that spending does not exceed the desired amount."}
        ],
        ["C"],
        "C) Turn on billing alerts for each AWS account. Create Amazon CloudWatch alarms that send an Amazon Simple Notification Service (Amazon SNS) notification to the account administrator whenever the account exceeds a designated spending threshold.",
        "Billing Alerts, CloudWatch Billing Alarm, SNS, AWS Organizations SCP, Business Group Autonomy",
        (
            "• 정답(C): 각 사업부가 계정 제어권을 완전히 유지해야 하므로(Retain full control), 계정별 Billing Alerts를 활성화하고 CloudWatch 결제 경보가 임계치 초과 시 SNS로 즉시 통지하도록 구성하는 것이 요구사항을 충족합니다.\n"
            "• 오답 분석:\n"
            "  - A: SCP로 인스턴스 타입을 제한하면 각 사업부의 계정 자율성(Full control)을 침해하며, 저비용 인스턴스를 대량 기동하는 과금 공격은 막지 못합니다.\n"
            "  - B: IAM 정책 제한 역시 사업부의 자율 권한을 제한하고, 수량 폭증(Large number of instances)을 차단하지 못합니다.\n"
            "  - D: Cost Explorer 정기 수동 검토는 실시간·자동 경보를 제공하지 못해 사고를 조기에 인지할 수 없습니다."
        ),
        "SAP-C02 핵심 함정: 'Retain full control' 제약 조건이 나오면 강제 차단(SCP/IAM 제한) 오답을 배제하고 자동 경보/모니터링 옵션을 검토하세요."
    ),
    (
        1, 2, 1, 1, 1,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #2] AWS Organizations 전 계정 대상 서드파티 모니터링 솔루션 읽기 전용 권한 배포",
        (
            "A company has multiple AWS accounts in an organization in AWS Organizations. The company has "
            "integrated its on-premises Active Directory with AWS Single Sign-On (AWS SSO) to grant Active Directory "
            "users least privilege permissions to manage infrastructure across all the accounts.\n\n"
            "A solutions architect must integrate a third-party monitoring solution that requires read-only access "
            "across all AWS accounts. The monitoring solution will run in its own AWS account.\n\n"
            "What should the solutions architect do to provide the monitoring solution with the required permissions?"
        ),
        "Architecture Context:\n- Multi-account AWS Organizations (AD integrated via AWS SSO / IAM Identity Center)\n- 3rd-party monitoring runs in its OWN external AWS account\n- Needs persistent, automated read-only cross-account access across ALL member accounts",
        [
            {"label": "A", "text": "Create a user in an AWS SSO directory. Assign a read-only permissions set to the user. Assign all AWS accounts that need monitoring to the user. Provide the third-party monitoring solution with the user name and password."},
            {"label": "B", "text": "Create an IAM role in the organization's management account. Allow the AWS account of the third-party monitoring solution to assume the role."},
            {"label": "C", "text": "Invite the AWS account of the third-party monitoring solution to join the organization. Enable all features."},
            {"label": "D", "text": "Create an AWS CloudFormation template that defines a new IAM role for the third-party monitoring solution. Specify the AWS account of the third-party monitoring solution in the trust policy. Create the IAM role across all linked AWS accounts by using a stack set."}
        ],
        ["D"],
        "D) Create an AWS CloudFormation template that defines a new IAM role for the third-party monitoring solution. Specify the AWS account of the third-party monitoring solution in the trust policy. Create the IAM role across all linked AWS accounts by using a stack set.",
        "CloudFormation StackSets, Cross-Account IAM Role, Trust Policy, Organizations, Third-Party Monitoring",
        (
            "• 정답(D): AWS CloudFormation StackSets를 사용하면 단일 템플릿으로 조직 내 모든 연결(Member) 계정에 동일한 읽기 전용 IAM Role(신뢰 정책에 서드파티 모니터링 AWS 계정 ID 및 ExternalId 포함)을 일괄 자동 배포할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - A: AWS SSO(IAM Identity Center) 자격 증명은 사람 사용자용 임시 자격 증명(Short-lived session)이므로 비대화형 모니터링 솔루션이 지속 사용할 수 없습니다.\n"
            "  - B: 관리 계정(Management account)에 IAM Role을 생성해도 해당 Role은 관리 계정 리소스에만 접근할 수 있고 멤버 계정으로 자동 권한이 전파되지 않습니다.\n"
            "  - C: 타사 계정을 Organization에 초대해 합류시키더라도 다른 멤버 계정 내부 리소스에 대한 읽기 권한이 자동으로 부여되지 않습니다."
        ),
        "멀티어카운트 일괄 IAM Role/거버넌스 리소스 배포의 표준 정답은 항상 CloudFormation StackSets(서비스 관리형 권한)입니다."
    ),
    (
        1, 3, 2, 2, 2,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #3] S3 정적 웹 폼에서 API Gateway + Lambda 엔드포인트로 POST 호출 시 CORS 구성",
        (
            "A team is building an HTML form that is hosted in a public Amazon S3 bucket. The form uses "
            "JavaScript to post data to an Amazon API Gateway API endpoint. The API endpoint is integrated with "
            "AWS Lambda functions. The team has tested each method in the API Gateway console and has received valid responses.\n\n"
            "Which combination of steps must the team complete so that the form can successfully post to the API "
            "endpoint and receive a valid response? (Select TWO.)"
        ),
        "Origin 1 (Browser HTML/JS): http://[bucketname].s3-website-[region].amazonaws.com\nOrigin 2 (API Endpoint):     https://[api_id].execute-api.[region].amazonaws.com/prod",
        [
            {"label": "A", "text": "Configure the S3 bucket to allow cross-origin resource sharing (CORS)."},
            {"label": "B", "text": "Host the form on Amazon EC2 rather than on Amazon S3."},
            {"label": "C", "text": "Request a quota increase for API Gateway."},
            {"label": "D", "text": "Enable cross-origin resource sharing (CORS) in API Gateway."},
            {"label": "E", "text": "Configure the S3 bucket for web hosting."}
        ],
        ["D", "E"],
        "D, E) Enable cross-origin resource sharing (CORS) in API Gateway. / Configure the S3 bucket for web hosting.",
        "Amazon S3 Static Website Hosting, API Gateway CORS, Access-Control-Allow-Origin, Preflight OPTIONS",
        (
            "• 정답(D, E):\n"
            "  - E: S3 버킷에서 HTML 폼을 정적 웹사이트로 서빙하려면 S3 정적 웹사이트 호스팅(Static Website Hosting)을 활성화해야 합니다.\n"
            "  - D: 브라우저에서 S3 웹사이트 오리진의 JS가 다른 도메인(execute-api)의 API Gateway를 호출하므로, 응답 측인 API Gateway에서 CORS(OPTIONS 프리플라이트 및 Access-Control-Allow-Origin 헤더)를 활성화해야 합니다.\n"
            "• 오답 분석:\n"
            "  - A: CORS 헤더는 요청을 받는 대상 서버(API Gateway)가 반환해야 하므로, HTML을 호스팅하는 S3 버킷에 CORS를 설정해도 효과가 없습니다.\n"
            "  - B: 정적 웹페이지를 굳이 EC2로 옮길 필요가 없습니다.\n"
            "  - C: API Gateway 기본 쿼터는 리전당 10,000 RPS이며 콘솔 테스트가 정상 동작하므로 쿼터 문제가 아닙니다."
        ),
        "CORS는 항상 '리소스를 제공(응답)하는 API/백엔드 측'에 설정합니다. 요청 페이지를 서빙하는 S3 버킷이 아닙니다!"
    ),
    (
        1, 4, 3, 1, 1,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #4] 트래픽 급증 시 서버리스 API Gateway의 간헐적 HTTP 502 Bad Gateway 원인 해결",
        (
            "A company runs a serverless mobile app that uses Amazon API Gateway, AWS Lambda functions, "
            "Amazon Cognito, and Amazon DynamoDB. During large surges in traffic, users report intermittent system "
            "failures. The API Gateway API endpoint is returning HTTP status code 502 (Bad Gateway) errors to valid requests.\n\n"
            "Which solution will resolve this issue?"
        ),
        "Serverless Stack: Mobile Client -> API Gateway -> Lambda -> DynamoDB (Auth: Cognito)\nSymptom under traffic surge: Intermittent HTTP 502 (Bad Gateway) responses from API Gateway",
        [
            {"label": "A", "text": "Increase the concurrency quota for the Lambda functions. Configure Amazon CloudWatch to send notification alerts when the ConcurrentExecutions metric approaches the quota."},
            {"label": "B", "text": "Configure notification alerts for the quota of transactions per second on the API Gateway API endpoint. Create a Lambda function that will increase the quota when the quota is reached."},
            {"label": "C", "text": "Shard users to Amazon Cognito user pools in multiple AWS Regions to reduce user authentication latency."},
            {"label": "D", "text": "Use DynamoDB strongly consistent reads to ensure that the client application always receives the most recent data."}
        ],
        ["A"],
        "A) Increase the concurrency quota for the Lambda functions. Configure Amazon CloudWatch to send notification alerts when the ConcurrentExecutions metric approaches the quota.",
        "API Gateway 502 Bad Gateway, Lambda Concurrency Quota, ConcurrentExecutions, Throttling",
        (
            "• 정답(A): AWS Lambda가 계정 동시성 한도(Concurrency Quota, 기본 1,000)를 초과해 스로틀링되면, 프록시 통합된 API Gateway가 백엔드 호출 실패로 간주하여 간헐적으로 HTTP 502(Bad Gateway)를 반환합니다. 동시성 한도 상향 요청 및 `ConcurrentExecutions` CloudWatch 경보 구성이 정확한 해법입니다.\n"
            "• 오답 분석:\n"
            "  - B: API Gateway 자체의 RPS 쿼터가 초과되면 502가 아니라 HTTP 429(Too Many Requests)가 반환됩니다.\n"
            "  - C: 502 오류는 인증(Cognito)이 아닌 API Gateway 엔드포인트 호출 단계에서 발생하고 있습니다.\n"
            "  - D: DynamoDB 읽기 일관성 모드는 데이터 최신성 문제이지 502 Bad Gateway를 유발하지 않습니다."
        ),
        "API Gateway 상태 코드 감별: 429 = API GW 스로틀링, 502 = 백엔드(Lambda) 통합 오류/동시성 초과, 504 = 29초 통합 타임아웃."
    ),
    (
        1, 5, 3, 1, 1,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #5] 인바운드 HTTPS(443)만 허용된 ECS 클러스터 EC2 100대 무포트 원격 관리",
        (
            "A company is launching a new web service on an Amazon Elastic Container Service (Amazon ECS) "
            "cluster. The cluster consists of 100 Amazon EC2 instances. Company policy requires the security group "
            "on the cluster instances to block all inbound traffic except HTTPS (port 443).\n\n"
            "Which solution will meet these requirements?"
        ),
        "Security Constraint:\n- 100 EC2 container instances in ECS cluster\n- Security Group inbound rule: ONLY TCP 443 (HTTPS) allowed, SSH (22) and custom admin ports blocked",
        [
            {"label": "A", "text": "Change the SSH port to 2222 on the cluster instances by using a user data script. Log in to each instance by using SSH over port 2222."},
            {"label": "B", "text": "Change the SSH port to 2222 on the cluster instances by using a user data script. Use AWS Trusted Advisor to remotely manage the cluster instances over port 2222."},
            {"label": "C", "text": "Launch the cluster instances with no SSH key pairs. Use AWS Systems Manager Run Command to remotely manage the cluster instances."},
            {"label": "D", "text": "Launch the cluster instances with no SSH key pairs. Use AWS Trusted Advisor to remotely manage the cluster instances."}
        ],
        ["C"],
        "C) Launch the cluster instances with no SSH key pairs. Use AWS Systems Manager Run Command to remotely manage the cluster instances.",
        "AWS Systems Manager Run Command, Session Manager, Zero Inbound Ports, Outbound HTTPS 443, ECS",
        (
            "• 정답(C): AWS Systems Manager(SSM) Agent는 인바운드 포트를 전혀 열지 않고 아웃바운드 HTTPS(443) 연결만으로 동작합니다. SSH 키 페어 없이 인스턴스를 시작하고 SSM Run Command(또는 Session Manager)로 100대 인스턴스를 일괄 원격 관리하면 보안 정책을 100% 준수합니다.\n"
            "• 오답 분석:\n"
            "  - A, B: 보안 그룹에서 HTTPS(443) 외 모든 인바운드를 차단해야 하므로 SSH 포트 2222도 허용할 수 없습니다.\n"
            "  - B, D: AWS Trusted Advisor는 모범 사례 점검(비용/보안/성능/내결함성) 도구일 뿐 EC2 원격 관리 기능을 제공하지 않습니다."
        ),
        "제로 트러스트 관리 패턴: 'No inbound SSH/RDP' 요구가 나오면 항상 AWS Systems Manager (Session Manager / Run Command) + Outbound 443입니다."
    ),
    (
        1, 6, 1, 1, 1,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #6] 단일 자격 증명으로 개발·운영 계정 분리 및 Cross-Account IAM Role 설계",
        (
            "A company has two AWS accounts: one account for production workloads and one account for "
            "development workloads. A development team and an operations team create and manage these workloads. "
            "The company needs a security strategy that meets the following requirements:\n\n"
            "• Developers need to create and delete development application infrastructure.\n"
            "• Operators need to create and delete development and production application infrastructure.\n"
            "• Developers must have no access to production infrastructure.\n"
            "• All users must have a single set of AWS credentials.\n\n"
            "Which strategy will meet these requirements?"
        ),
        "Accounts: Production Account | Development Account\nTeams: Developers (Dev only) | Operators (Dev + Prod)\nConstraint: Single set of AWS credentials per user",
        [
            {"label": "A", "text": "In the production account: Create an operations IAM group and IAM user for each operator. In the development account: Create a development IAM group and IAM user for each operator and developer."},
            {"label": "B", "text": "In the production account: Create an operations IAM group. In the development account: Create a development IAM group, IAM user for each developer, and IAM user for each operator assigned to the development group and to the operations group in the production account."},
            {"label": "C", "text": "In the development account: Create a shared IAM role that can create and delete application infrastructure in the production account, a development IAM group, and an operations IAM group that can assume the shared role. Create IAM users in the development account."},
            {"label": "D", "text": "In the production account: Create a shared IAM role that can create and delete application infrastructure. Add the development account to the trust policy for the shared role. In the development account: Create a development IAM group, an operations IAM group that can assume the shared role in the production account, and IAM users assigned accordingly."}
        ],
        ["D"],
        "D) In the production account: Create a shared IAM role that can create and delete application infrastructure. Add the development account to the trust policy for the shared role. In the development account: Create a development IAM group and an operations IAM group that can assume the shared role in the production account, with all IAM users in the development account.",
        "Cross-Account IAM Role, AssumeRole, Trust Policy, Single Set of Credentials, Least Privilege",
        (
            "• 정답(D): 사용자는 단 하나의 자격 증명 세트만 가져야 하므로 모든 IAM 사용자는 개발 계정에만 생성합니다. 운영팀이 운영(Production) 계정을 관리하려면, 리소스가 위치한 **운영 계정 내부에 공유 IAM Role을 생성**하고 신뢰 정책(Trust Policy)에 개발 계정을 지정한 뒤, 개발 계정의 운영자 그룹에만 `sts:AssumeRole` 권한을 부여해야 합니다.\n"
            "• 오답 분석:\n"
            "  - A: 운영자가 개발 계정과 운영 계정에 각각 별도 IAM 사용자를 가지므로 '단일 자격 증명' 조건에 위배됩니다.\n"
            "  - B: IAM 사용자를 다른 AWS 계정의 IAM 그룹에 직접 추가하는 것은 불가능합니다.\n"
            "  - C: 운영 계정에 있는 리소스를 제어하는 IAM Role은 반드시 대상 리소스가 존재하는 운영 계정에 생성해야 합니다(개발 계정의 Role이 타 계정에 직접 권한 부여 불가)."
        ),
        "Cross-Account Role 기본 원칙: Role은 항상 '접근 대상 리소스가 존재하는 계정(Target)'에 생성하고, Trust Policy에 '신뢰할 계정(Source)'을 명시합니다."
    ),
    (
        1, 7, 3, 2, 2,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #7] Kinesis 샤드 통합 및 저빈도 SQS 처리의 서버리스 전환으로 빅데이터 비용 최적화",
        (
            "A solutions architect needs to reduce costs for a big data application. The application environment "
            "consists of hundreds of devices that send events to Amazon Kinesis Data Streams. The device ID is used "
            "as the partition key, so each device gets a separate shard. Each device sends between 50 KB and 450 KB "
            "of data each second. An AWS Lambda function polls the shards, processes the data, and stores the result in Amazon S3.\n\n"
            "Every hour, another Lambda function runs an Amazon Athena query against the result data to identify "
            "outliers. This Lambda function places the outliers in an Amazon Simple Queue Service (Amazon SQS) "
            "queue. An Amazon EC2 Auto Scaling group of two EC2 instances monitors the queue and runs a 30-second "
            "process to address the outliers. The devices submit an average of 10 outlying values every hour.\n\n"
            "Which combination of changes to the application will MOST reduce costs? (Select TWO.)"
        ),
        "Current Metrics:\n- Per device rate: 50 KB/s ~ 450 KB/s (1 Kinesis shard limit = 1 MB/s = 1,000 KB/s ingress)\n- Outliers: 10 events/hour × 30s = 300s/hour total compute (EC2 ASG of 2 instances idle 3,300s/hr)",
        [
            {"label": "A", "text": "Change the Auto Scaling group launch configuration to use smaller instance types in the same instance family."},
            {"label": "B", "text": "Replace the Auto Scaling group with a Lambda function that is invoked when messages arrive in the queue."},
            {"label": "C", "text": "Reconfigure the devices and data stream to set a ratio of 10 devices to 1 data stream shard."},
            {"label": "D", "text": "Reconfigure the devices and data stream to set a ratio of 2 devices to 1 data stream shard."},
            {"label": "E", "text": "Change the desired capacity of the Auto Scaling group to a single EC2 instance."}
        ],
        ["B", "D"],
        "B, D) Replace the Auto Scaling group with a Lambda function that is invoked when messages arrive in the queue. / Reconfigure the devices and data stream to set a ratio of 2 devices to 1 data stream shard.",
        "Kinesis Data Streams 1MB/s Shard Quota, Lambda Event Source Mapping, SQS, Cost Optimization",
        (
            "• 정답(B, D):\n"
            "  - B: 시간당 이상치 10건 × 30초 = 총 300초의 연산만 필요하므로, 상시 3,300초 이상 유휴 상태로 과금되는 EC2 ASG(2대)를 SQS 이벤트 기반 AWS Lambda(최대 15분 실행 가능, 30초 거뜬히 처리)로 교체하면 컴퓨팅 비용을 극적으로 절감할 수 있습니다.\n"
            "  - D: Kinesis Data Streams의 1개 샤드 최대 수집 용량은 **1 MB/s(1,000 KB/s)** 입니다. 디바이스당 최대 450 KB/s를 전송하므로 2대 = 900 KB/s(<= 1 MB/s)로 샤드당 2개 디바이스를 매핑하면 샤드 수를 절반으로 줄여 비용을 절감할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - C: 10대 × 450 KB/s = 4,500 KB/s(4.5 MB/s)로 단일 샤드 1 MB/s 한도를 초과해 `ProvisionedThroughputExceededException`이 발생합니다.\n"
            "  - A, E: EC2 인스턴스를 축소하거나 1대로 줄여도 시간당 3,300초 유휴 비용이 계속 발생합니다."
        ),
        "Kinesis 샤드 한도 수치 암기: Write 1 MB/s 또는 1,000 records/s, Read 2 MB/s(공유) 또는 팬아웃 시 컨슈머당 2 MB/s!"
    ),
    (
        1, 8, 3, 2, 2,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #8] Auto Scaling 급증 시 외부 제휴사 API 과부하 방지를 위한 SQS 버퍼링 및 Lambda 동시성 제한",
        (
            "A company operates an ecommerce application on Amazon EC2 instances behind an Application Load "
            "Balancer. The instances run in an Amazon EC2 Auto Scaling group across multiple Availability Zones. "
            "After an order is successfully processed, the application immediately posts order data to a third-party "
            "affiliate’s external tracking system that pays sales commissions for order referrals.\n\n"
            "During a successful marketing promotion, the number of EC2 instances increased from 2 to 20. The "
            "application continued to work correctly during this time. However, the increased request rate "
            "overwhelmed the third-party affiliate and resulted in failed requests.\n\n"
            "Which combination of architectural changes should a solutions architect make to ensure that the entire "
            "process functions correctly under load? (Select TWO.)"
        ),
        "Bottleneck: EC2 ASG (2 -> 20 instances) --[Direct HTTP POST]--> External 3rd-party Affiliate API (Rate-limited/Overwhelmed)\nGoal: Protect both main ecommerce app and downstream 3rd-party system with retry reliability",
        [
            {"label": "A", "text": "Move the code that calls the affiliate to a new AWS Lambda function. Modify the application to invoke the Lambda function asynchronously."},
            {"label": "B", "text": "Move the code that calls the affiliate to a new AWS Lambda function. Modify the application to place the order data in an Amazon Simple Queue Service (Amazon SQS) queue. Invoke the Lambda function from the queue."},
            {"label": "C", "text": "Increase the timeout of the new AWS Lambda function."},
            {"label": "D", "text": "Decrease the reserved concurrency of the new AWS Lambda function."},
            {"label": "E", "text": "Increase the memory of the new AWS Lambda function."}
        ],
        ["B", "D"],
        "B, D) Move the code that calls the affiliate to a new AWS Lambda function. Modify the application to place the order data in an Amazon SQS queue. Invoke the Lambda function from the queue. / Decrease the reserved concurrency of the new AWS Lambda function.",
        "SQS Decoupling, Lambda Reserved Concurrency, Rate Limiting, Downstream Protection, Backpressure",
        (
            "• 정답(B, D):\n"
            "  - B: 주문 처리 애플리케이션과 외부 제휴사 호출 사이에 SQS 큐를 두어 비동기 결합 해제(Decoupling)하면, 외부 API 장애나 지연이 메인 주문 처리를 막지 않고 실패한 메시지가 자동으로 큐에 남아 재시도됩니다.\n"
            "  - D: SQS를 트리거로 실행되는 Lambda 함수의 **예약 동시성(Reserved Concurrency)** 을 낮게 설정하면, 외부 제휴사 시스템으로 동시에 나가는 최대 요청 속도를 제어(Throttling/Backpressure)하여 과부하를 방지합니다.\n"
            "• 오답 분석:\n"
            "  - A: SQS 없이 Lambda를 비동기 호출하면 동시 요청량이 그대로 외부 API를 강타합니다(또한 예약 동시성 제한 시 내부 큐 재시도 한계 존재).\n"
            "  - C, E: Lambda 타임아웃이나 메모리를 늘려도 외부 제휴사로 유입되는 동시 요청 수 자체를 줄이지 못합니다."
        ),
        "다운스트림 보호 패턴 = 'SQS 버퍼링 + Lambda Reserved Concurrency 상한 제한(또는 EventBridge API Destinations Rate Limit)' 조합을 기억하세요."
    ),
    (
        1, 9, 2, 2, 3,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #9] App Runner + ECR + Aurora MySQL 기반 최소 변경 멀티 리전 Active-Active 확장",
        (
            "A company has built an online ticketing web application on AWS. The application is hosted on AWS "
            "App Runner and uses images that are stored in an Amazon Elastic Container Registry (Amazon ECR) "
            "repository. The application stores data in an Amazon Aurora MySQL DB cluster. The company has set up "
            "a domain name in Amazon Route 53.\n\n"
            "The company needs to deploy the application across two AWS Regions in an active-active configuration.\n\n"
            "Which combination of steps will meet these requirements with the LEAST change to the architecture? (Select THREE.)"
        ),
        "Existing Stack: Route 53 -> AWS App Runner (Container images in ECR) -> Amazon Aurora MySQL\nGoal: Multi-Region Active-Active with LEAST architectural change",
        [
            {"label": "A", "text": "Set up Cross-Region Replication to the second Region for the ECR images."},
            {"label": "B", "text": "Create a VPC endpoint from the ECR repository in the second Region."},
            {"label": "C", "text": "Edit the App Runner configuration by adding a second deployment target to the second Region."},
            {"label": "D", "text": "Deploy App Runner to the second Region. Set up Route 53 latency-based routing."},
            {"label": "E", "text": "Change the database by using Amazon DynamoDB global tables in the two desired Regions."},
            {"label": "F", "text": "Use an Aurora global database with write forwarding enabled in the second Region."}
        ],
        ["A", "D", "F"],
        "A, D, F) Set up Cross-Region Replication to the second Region for the ECR images. / Deploy App Runner to the second Region. Set up Route 53 latency-based routing. / Use an Aurora global database with write forwarding enabled in the second Region.",
        "AWS App Runner, ECR Cross-Region Replication, Route 53 Latency-Based Routing, Aurora Global Database, Write Forwarding",
        (
            "• 정답(A, D, F):\n"
            "  - A: App Runner가 두 번째 리전에서도 동일한 컨테이너 이미지를 로컬로 풀(Pull)할 수 있도록 ECR Cross-Region Replication을 활성화합니다.\n"
            "  - D: App Runner는 리전 단위 서비스이므로 두 번째 리전에 별도 App Runner 서비스를 배포하고 Route 53 지연 시간 기반 라우팅(Latency-based routing)으로 양 리전 트래픽을 분산합니다.\n"
            "  - F: 기존 Aurora MySQL 아키텍처를 유지하면서 Active-Active 두 리전에서 읽기와 쓰기를 모두 처리하려면 **Aurora Global Database + Write Forwarding** 을 활성화하는 것이 가장 적은 변경입니다.\n"
            "• 오답 분석:\n"
            "  - B: VPC Interface Endpoint는 동일 리전 내 VPC 연결용이며 다른 리전의 ECR에 접근할 수 없습니다.\n"
            "  - C: App Runner 콘솔/설정에는 하나의 서비스에 다중 리전 배포 대상을 추가하는 기능이 없습니다.\n"
            "  - E: 관계형 MySQL 스키마를 NoSQL인 DynamoDB Global Tables로 전면 재설계하면 코드 변경 규모가 매우 큽니다('LEAST change' 위배)."
        ),
        "'LEAST change' 제약이 있으면 기존 데이터 모델(RDBMS Aurora MySQL -> Aurora Global DB Write Forwarding)을 보존하는 선택지를 고르세요."
    ),
    (
        1, 10, 4, 2, 2,
        "AWS Official Sample Questions PDF",
        "Official Sample",
        "[공식 샘플 #10] 멀티티어 레거시 웹·DB 애플리케이션 현대화 및 운영 오버헤드 최소화",
        (
            "A company has deployed a multi-tier web application in the AWS Cloud. The application consists of the following tiers:\n\n"
            "• A Windows-based web tier that is hosted on Amazon EC2 instances with Elastic IP addresses\n"
            "• A Linux-based application tier that is hosted on EC2 instances that run behind an Application Load Balancer (ALB) that uses path-based routing\n"
            "• A MySQL database that runs on a Linux EC2 instance\n\n"
            "All the EC2 instances are using Intel-based x86 CPUs. A solutions architect needs to modernize the "
            "infrastructure to achieve better performance. The solution must minimize the operational overhead of the application.\n\n"
            "Which combination of actions should the solutions architect take to meet these requirements? (Select TWO.)"
        ),
        "Current Tiers:\n1) Web Tier: Windows EC2 w/ Elastic IPs (x86)\n2) App Tier: Linux EC2 behind ALB (x86)\n3) DB Tier: Self-managed MySQL on single Linux EC2 (x86)",
        [
            {"label": "A", "text": "Run the MySQL database on multiple EC2 instances."},
            {"label": "B", "text": "Place the web tier instances behind an ALB."},
            {"label": "C", "text": "Migrate the MySQL database to Amazon Aurora Serverless."},
            {"label": "D", "text": "Migrate all EC2 instance types to Graviton2."},
            {"label": "E", "text": "Replace the ALB for the application tier instances with a company-managed load balancer."}
        ],
        ["B", "C"],
        "B, C) Place the web tier instances behind an ALB. / Migrate the MySQL database to Amazon Aurora Serverless.",
        "Modernization, Application Load Balancer, Amazon Aurora Serverless, Windows vs Graviton2, Operational Overhead",
        (
            "• 정답(B, C):\n"
            "  - B: Elastic IP가 직접 바인딩된 Windows 웹 티어를 ALB 뒤에 배치하면 부하 분산, 자동 헬스 체크, 오토 스케일링 연동 및 TLS 오프로드가 가능해져 가용성과 성능, 관리 효율이 향상됩니다.\n"
            "  - C: 단일 Linux EC2에 직접 구축한 MySQL을 완전관리형 **Amazon Aurora Serverless** 로 마이그레이션하면 패치·백업·용량 프로비저닝 등 운영 오버헤드를 최소화하면서 성능과 고가용성을 동시에 확보합니다.\n"
            "• 오답 분석:\n"
            "  - A: MySQL을 여러 EC2에 직접 클러스터링하면 복제·장애조치·패치 운영 부담이 오히려 증가합니다.\n"
            "  - D: Graviton2(ARM64)는 Windows 운영체제를 지원하지 않으므로 '모든 EC2(Windows 웹 티어 포함)'를 Graviton2로 전환할 수 없습니다.\n"
            "  - E: 관리형 ALB를 자체 관리 로드밸런서(예: EC2 HAProxy/Nginx)로 교체하면 운영 오버헤드가 커집니다."
        ),
        "아키텍처 트랩: Graviton(ARM64)은 Linux 전용입니다! Windows EC2가 포함된 상태에서 'All EC2 to Graviton' 선택지는 함정입니다."
    ),

    # =========================================================================
    # ROUND 2 (SET 1): Domain 1 — Design Solutions for Organizational Complexity (16 Questions)
    # =========================================================================
    (
        2, 1, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] AWS Organizations 전사 보안 로그 중앙화 및 신규 계정 자동 보호 거버넌스",
        (
            "대기업 엔터프라이즈 환경에서 80여 개의 AWS 계정이 AWS Organizations에 연결되어 있으며 매월 신규 계정이 추가되고 있습니다. "
            "보안 감사 팀은 모든 기존 및 향후 추가될 멤버 계정의 CloudTrail 로그가 중앙 Log Archive 계정의 단일 S3 버킷으로 수집되도록 강제하되, "
            "각 멤버 계정의 AdministratorAccess 권한을 가진 개발자라도 해당 S3 버킷의 로그를 삭제하거나 조직 외부 계정이 버킷에 접근하지 못하도록 차단해야 합니다.\n\n"
            "운영 오버헤드를 최소화하면서 이를 구현하는 가장 적절한 아키텍처는 무엇입니까?"
        ),
        "Org Structure: Management Account -> Security OU (Log Archive Account) + Workloads OU (80+ Accounts)\nConstraint: Automatically include future accounts, prevent member admin tampering, zero external org access",
        [
            {"label": "A", "text": "각 계정에 CloudTrail 추적을 수동 생성하고, S3 버킷 정책에 현재 80개 계정 ID를 모두 명시한 뒤 각 계정에 로그 삭제 금지 IAM 정책을 배포한다."},
            {"label": "B", "text": "AWS Organizations에서 Organization Trail을 생성하여 중앙 Log Archive 계정의 S3 버킷으로 전송하고, S3 버킷 정책에 aws:PrincipalOrgID 조건으로 조직 내 쓰기만 허용하며, 멤버 계정에 CloudTrail 및 중앙 S3 삭제 작업을 거부하는 SCP를 적용한다."},
            {"label": "C", "text": "Log Archive 계정에 S3 버킷을 만들고 버킷 ACL을 Public-Read-Write로 둔 뒤 AWS WAF로 조직 IP 대역만 허용한다."},
            {"label": "D", "text": "관리 계정의 루트 사용자에게만 모든 권한을 남기고, 멤버 계정 전체에 s3:* 와 cloudtrail:* 을 모두 차단하는 SCP를 Root OU에 연결한다."}
        ],
        ["B"],
        "B) AWS Organizations에서 Organization Trail을 생성하여 중앙 Log Archive 계정의 S3 버킷으로 전송하고, S3 버킷 정책에 aws:PrincipalOrgID 조건으로 조직 내 쓰기만 허용하며, 멤버 계정에 CloudTrail 및 중앙 S3 삭제 작업을 거부하는 SCP를 적용한다.",
        "Organization Trail, aws:PrincipalOrgID, Service Control Policy (SCP), S3 Bucket Policy, Log Archive",
        (
            "• 정답(B): Organization Trail은 현재와 향후 추가되는 모든 계정에 자동으로 CloudTrail을 활성화합니다. S3 버킷 정책의 `aws:PrincipalOrgID` 조건은 향후 생성될 조직 계정까지 동적으로 허용하고 외부 계정을 원천 차단하며, SCP의 명시적 `Deny`는 멤버 계정의 AdministratorAccess 권한보다 우선하므로 로그 변조·추적 중단을 막습니다.\n"
            "• 오답 분석:\n"
            "  - A: 신규 계정 추가 시마다 계정 ID를 수동 갱신해야 하므로 확장성과 자동화 원칙에 위배됩니다.\n"
            "  - C: S3 버킷을 퍼블릭으로 여는 것은 심각한 보안 위반이며 WAF는 S3 버킷 엔드포인트에 직접 연결할 수 없습니다.\n"
            "  - D: `s3:*` 전체를 차단하면 멤버 계정의 정상적인 애플리케이션 S3 업무까지 모두 마비됩니다."
        ),
        "`aws:PrincipalOrgID` 전역 조건 키는 '향후 자동 생성되는 조직 내 모든 계정'을 수동 관리 없이 동적으로 신뢰할 때 사용하는 SAP-C02 단골 키입니다."
    ),
    (
        2, 2, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] Transit Gateway + Gateway Load Balancer 기반 다중 AZ 대칭 트래픽 검사(Appliance Mode)",
        (
            "금융사의 허브 앤 스포크(Hub-and-Spoke) 네트워크에서 AWS Transit Gateway(TGW)가 Spoke VPC A, Spoke VPC B 및 중앙 Inspection VPC를 연결합니다. "
            "Inspection VPC 내부의 두 개 가용 영역(AZ-a, AZ-b)에는 Gateway Load Balancer(GWLB) 뒤에 상태 기반(Stateful) 서드파티 방화벽 어플라이언스가 배치되어 있으며, "
            "각 AZ마다 GWLB Endpoint(GWLBE)와 TGW 서브넷이 구성되어 있습니다.\n\n"
            "운영 중 Spoke VPC A(AZ-a 인스턴스)와 Spoke VPC B(AZ-b 인스턴스) 간 TCP 통신이 간헐적으로 SYN/ACK 단계에서 타임아웃되며 차단되는 장애가 발생했습니다. "
            "원인 분석 결과 요청 패킷은 AZ-a 방화벽을 통과했으나 응답 패킷이 AZ-b 방화벽으로 라우팅되어 상태 테이블 불일치(Asymmetric Routing)로 폐기되고 있었습니다. "
            "가장 적은 변경으로 이 문제를 근본 해결하는 방법은 무엇입니까?"
        ),
        "Traffic Flow Issue:\nRequest:  Spoke A (AZ-a) -> TGW -> Inspection VPC GWLBE (AZ-a) -> Firewall A (AZ-a) -> Spoke B (AZ-b)\nResponse: Spoke B (AZ-b) -> TGW -> Inspection VPC GWLBE (AZ-b) -> Firewall B (AZ-b -> DROPS asymmetric flow!)",
        [
            {"label": "A", "text": "Inspection VPC의 Transit Gateway Attachment에서 Appliance Mode(appliance-mode-support)를 활성화한다."},
            {"label": "B", "text": "모든 Spoke VPC의 워크로드를 단일 가용 영역(AZ-a)으로 강제 이동시키고 AZ-b 서브넷을 삭제한다."},
            {"label": "C", "text": "GWLB 대신 Application Load Balancer(ALB)를 배치하고 Sticky Sessions(고정 세션)를 활성화한다."},
            {"label": "D", "text": "Inspection VPC의 TGW 라우팅 테이블에서 BGP AS_PATH Prepending을 설정해 모든 트래픽을 AZ-a로 유도한다."}
        ],
        ["A"],
        "A) Inspection VPC의 Transit Gateway Attachment에서 Appliance Mode(appliance-mode-support)를 활성화한다.",
        "Transit Gateway Appliance Mode, Gateway Load Balancer (GWLB), Symmetric Routing, Stateful Firewall",
        (
            "• 정답(A): 기본적으로 Transit Gateway는 출발지 AZ와 같은 AZ의 검사 VPC 엔드포인트로 패킷을 보내기 때문에, 서로 다른 AZ에 있는 Spoke 간 통신에서 양방향 경로가 서로 다른 AZ의 방화벽을 타는 비대칭 라우팅(Asymmetric Routing)이 발생합니다. Inspection VPC의 TGW Attachment에 **Appliance Mode**를 활성화하면 TGW가 플로우 해시(5-tuple)를 기반으로 왕복(Forward/Return) 트래픽을 모두 **동일한 단일 AZ의 방화벽 어플라이언스**로 고정 라우팅합니다.\n"
            "• 오답 분석:\n"
            "  - B: 단일 AZ 운영은 고가용성(Multi-AZ) 원칙을 파괴합니다.\n"
            "  - C: ALB는 L7 HTTP/HTTPS 프록시일 뿐이며 L3/L4 투명 패킷 검사를 위한 GENEVE 캡슐화 기반 GWLB를 대체할 수 없습니다.\n"
            "  - D: TGW VPC Attachment 라우팅에는 BGP AS_PATH 속성이 적용되지 않습니다."
        ),
        "TGW + GWLB + Stateful Firewall + Cross-AZ 패킷 드롭 = 무조건 `Appliance Mode` 활성화!"
    ),
    (
        2, 3, 1, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] Dual Direct Connect(Dedicated) + Transit VIF 환경의 1초 미만 장애 절체 및 대칭 경로 제어",
        (
            "글로벌 제조 기업이 온프레미스 두 개 데이터센터(DC1-서울, DC2-부산)에서 각각 AWS Direct Connect Dedicated Connection(10 Gbps)을 통해 "
            "Direct Connect Gateway 및 서울 리전 Transit Gateway(TGW)와 연결되어 있습니다. 평상시 모든 VPC와 온프레미스 간 트래픽은 DC1 회선을 우선 사용하고, "
            "DC1 회선 또는 라우터 장애 시 1초 이내(Sub-second)에 DC2 회선으로 자동 전환되어야 합니다.\n\n"
            "비대칭 라우팅 없이 대칭 경로 우선순위와 초고속 장애 감지를 모두 구현하기 위해 적용해야 할 구성 조합 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Topology:\nDC1 (Primary 10G Dedicated DX) --[Transit VIF]--> DX Gateway --> TGW (ap-northeast-2)\nDC2 (Backup 10G Dedicated DX)  --[Transit VIF]--> DX Gateway --> TGW (ap-northeast-2)",
        [
            {"label": "A", "text": "양측 온프레미스 BGP 라우터와 AWS Direct Connect Transit VIF BGP 세션에 BFD(Bidirectional Forwarding Detection)를 활성화한다."},
            {"label": "B", "text": "DC2 회선에서 AWS로 광고하는 BGP 경로에는 더 긴 AS_PATH Prepending을 설정하고, AWS에서 수신하는 경로 처리 시 DC1 측 온프레미스 라우터에 더 높은 BGP Local Preference를 부여한다."},
            {"label": "C", "text": "TGW에 정적 경로(Static Route)만 등록하고 BGP 동적 라우팅을 비활성화한다."},
            {"label": "D", "text": "각 Direct Connect 회선에 Public VIF를 추가 생성하고 BGP Hold Timer를 300초로 상향한다."},
            {"label": "E", "text": "DC1과 DC2의 Direct Connect Gateway를 분리한 뒤 AWS Route 53 헬스 체크로 트래픽을 전환한다."}
        ],
        ["A", "B"],
        "A, B) 양측 BGP 세션에 BFD 활성화 / DC2 광고 경로에 더 긴 AS_PATH Prepending 및 DC1 측 높은 Local Preference 적용",
        "Direct Connect BFD, BGP AS_PATH Prepending, Local Preference, Transit VIF, Symmetric Failover",
        (
            "• 정답(A, B):\n"
            "  - A: 기본 BGP Keepalive/Hold Timer(30s/90s)로는 1초 미만 장애 감지가 불가능하므로, L2/L3 헬로우 기반의 **BFD(Bidirectional Forwarding Detection)** 를 활성화해야 1초 이내(기본 300ms×3=900ms) 장애 절체가 가능합니다.\n"
            "  - B: **인바운드(온프레미스→AWS)** 트래픽은 온프레미스 라우터에서 DC1 경로에 더 높은 **Local Preference**를 부여해 제어하고, **아웃바운드(AWS→온프레미스)** 트래픽은 백업인 DC2가 AWS로 광고할 때 **더 긴 AS_PATH Prepending**(또는 낮은 BGP Local Pref 커뮤니티 태그)을 적용해 AWS가 DC1을 선택하게 함으로써 대칭 라우팅을 보장합니다.\n"
            "• 오답 분석:\n"
            "  - C: Direct Connect VIF 연결은 BGP 동적 라우팅이 필수이며, 정적 경로만으로는 자동 장애 절체가 불가능합니다.\n"
            "  - D: BGP Hold Timer를 300초로 늘리면 장애 감지가 오히려 최대 5분으로 늦어집니다.\n"
            "  - E: Route 53은 DNS 기반 L7/IP 전환 도구이지 내부 사설 IP 백본 BGP 경로 절체 수단이 아닙니다."
        ),
        "Direct Connect BGP 제어 공식: 인바운드(On-prem->AWS)는 Local Preference / MED, 아웃바운드(AWS->On-prem)는 AS_PATH Prepending 또는 AWS BGP Local Preference Community 태그, 초고속 장애 감지는 BFD!"
    ),
    (
        2, 4, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] 다중 계정·하이브리드 환경을 위한 중앙 집중식 Route 53 Resolver DNS 아키텍처",
        (
            "엔터프라이즈 조직에 45개의 AWS 계정과 각각 독립된 VPC가 존재하며, 모든 VPC는 중앙 Network Hub 계정의 Transit Gateway로 연결되어 있습니다. "
            "온프레미스 데이터센터는 `corp.internal` 사설 도메인을 호스팅하고 있으며, AWS 내부 워크로드는 `aws.corp.internal` Route 53 Private Hosted Zone(PHZ)을 사용합니다.\n\n"
            "모든 AWS 계정의 워크로드가 온프레미스 `*.corp.internal` 이름을 조회할 수 있어야 하고, 반대로 온프레미스 서버들도 AWS `*.aws.corp.internal` 주소를 조회할 수 있어야 합니다. "
            "엔포인트 유지 비용과 운영 복잡도를 최소화하는 설계는 무엇입니까?"
        ),
        "Requirements:\n- 45 AWS Accounts + 45 VPCs connected via TGW\n- Bidirectional DNS resolution between On-prem (corp.internal) and AWS PHZ (aws.corp.internal)\n- Minimize endpoint count/cost and operational overhead",
        [
            {"label": "A", "text": "45개 모든 VPC에 각각 Route 53 Resolver Inbound/Outbound 엔드포인트와 PHZ를 생성하고 온프레미스 DNS와 개별로 포워딩한다."},
            {"label": "B", "text": "중앙 Shared Services VPC에 Route 53 Resolver Inbound 및 Outbound 엔드포인트 쌍을 1세트씩 생성한다. Outbound Forwarding Rule을 생성해 AWS RAM으로 45개 계정에 공유하고 각 VPC에 연결하며, 중앙 PHZ를 모든 스포크 VPC와 교차 계정 연결(Associate)한다."},
            {"label": "C", "text": "온프레미스 DNS 서버를 모두 폐기하고 Route 53 Public Hosted Zone에 사설 IP 레코드를 등록한다."},
            {"label": "D", "text": "모든 스포크 VPC의 DHCP Options Set을 온프레미스 DNS 서버 IP로만 변경한다."}
        ],
        ["B"],
        "B) 중앙 Shared Services VPC에 Route 53 Resolver Inbound 및 Outbound 엔드포인트 쌍을 1세트씩 생성한다. Outbound Forwarding Rule을 AWS RAM으로 공유·연결하고, 중앙 PHZ를 스포크 VPC와 교차 계정 연결한다.",
        "Route 53 Resolver Inbound/Outbound Endpoint, Forwarding Rules, AWS RAM, Private Hosted Zone (PHZ)",
        (
            "• 정답(B): Route 53 Resolver 엔드포인트는 ENI당 시간당 비용이 발생하므로 모든 45개 VPC에 둘 필요가 없습니다. 중앙 Shared Services VPC에 **Inbound(온프레미스→AWS 질의 수신)** 와 **Outbound(AWS→온프레미스 질의 전달)** 엔드포인트를 각각 1쌍(다중 AZ)만 배치하고, Forwarding Rule을 **AWS RAM**으로 조직 내 모든 계정에 공유해 VPC에 연결(Associate)하면 최소 비용으로 전사 양방향 DNS 해석이 완결됩니다.\n"
            "• 오답 분석:\n"
            "  - A: 45개 VPC × 4개 ENI = 180개 ENI 비용과 관리 부담이 폭증합니다.\n"
            "  - C: Public Hosted Zone에 내부 사설 IP/인프라 토폴로지를 노출하는 것은 보안 위배이자 온프레미스 내부 DNS 대체가 불가합니다.\n"
            "  - D: DHCP Options Set을 온프레미스로만 바꾸면 Route 53 PHZ 및 VPC 내부 AWS 서비스 엔드포인트 해석이 깨지거나 모든 DNS 질의가 WAN을 타게 됩니다."
        ),
        "Centralized Hybrid DNS = 1) Shared Network VPC에 Inbound+Outbound 1쌍, 2) Outbound Rule을 RAM으로 Spoke VPC에 공유, 3) 중앙 PHZ 교차 계정 연결."
    ),
    (
        2, 5, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] AWS RAM 기반 VPC Subnet Sharing vs VPC Peering/TGW 선택 기준",
        (
            "전자상거래 플랫폼 회사의 인프라 팀은 단일 VPC 내부에 결제(Billing), 주문(Order), 검색(Search) 팀의 별도 AWS 계정을 수용하여, "
            "각 팀이 독립된 AWS 계정에서 자기 팀의 EC2, RDS, Lambda, Security Group을 완전히 소유·배포하게 하되, "
            "마이크로서비스 간 대용량 통신에서 **계정 간 VPC 데이터 전송 요금 및 Transit Gateway/Peering 홉 비용을 0원으로 제거**하고 CIDR 관리를 단일 네트워킹 팀으로 통합하고자 합니다.\n\n"
            "이 요구사항을 충족하는 최적의 네트워킹 패턴은 무엇입니까?"
        ),
        "Constraints:\n- Separate AWS Accounts per team (Billing, Order, Search) for blast radius & billing isolation\n- Single network engineering team manages VPC, Subnets, Route Tables, NAT/IGW\n- ZERO inter-VPC / TGW data transfer hops between services in the same AZ",
        [
            {"label": "A", "text": "팀별 계정마다 별도의 VPC를 생성한 뒤 Transit Gateway로 연결한다."},
            {"label": "B", "text": "네트워킹 계정(Owner)에서 중앙 VPC와 서브넷을 생성한 후 AWS RAM(Resource Access Manager)을 통해 각 팀 계정에 전용 서브넷을 공유(VPC Sharing)한다."},
            {"label": "C", "text": "팀별 VPC를 모두 AWS PrivateLink로 연결하여 모든 내부 마이크로서비스 호출을 NLB 경유로 처리한다."},
            {"label": "D", "text": "모든 팀을 단일 AWS 계정으로 합치고 IAM Path 프리픽스로만 자원을 구분한다."}
        ],
        ["B"],
        "B) 네트워킹 계정(Owner)에서 중앙 VPC와 서브넷을 생성한 후 AWS RAM(Resource Access Manager)을 통해 각 팀 계정에 전용 서브넷을 공유(VPC Sharing)한다.",
        "AWS RAM, VPC Subnet Sharing, Zero Inter-VPC Cost, Blast Radius Isolation, Central Network Governance",
        (
            "• 정답(B): **VPC Subnet Sharing(AWS RAM)** 을 사용하면 네트워크 소유 계정이 VPC, 서브넷, 라우팅, IGW/NAT/TGW를 중앙 통제하고, 참여 계정(Participant)은 공유받은 서브넷 내에 자신만의 EC2/RDS/SG를 생성합니다. 동일 VPC 내 동일 AZ 통신은 교차 VPC/TGW 비용이 전혀 발생하지 않으며 CIDR 낭비도 방지됩니다.\n"
            "• 오답 분석:\n"
            "  - A: TGW를 경유하면 GB당 데이터 처리 비용($0.02/GB 등)이 발생합니다.\n"
            "  - C: PrivateLink 역시 엔드포인트 시간당 및 GB당 데이터 처리 비용이 발생합니다.\n"
            "  - D: 단일 계정 통합은 계정 단위 격리(Blast radius, 서비스 쿼터, 결제 분리) 요구사항을 위반합니다."
        ),
        "동일 리전 멀티계정 간 '네트워크 중앙 관리 + 0원 내부 통신 + 독립 자원 소유' 키워드가 보이면 **AWS RAM VPC Sharing**이 정답입니다."
    ),
    (
        2, 6, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] IAM Identity Center(AWS SSO) + SAML ABAC 기반 동적 멀티어카운트 권한 통제",
        (
            "글로벌 소프트웨어 기업이 Okta IdP를 AWS IAM Identity Center와 연동하여 60개 AWS 계정의 500명 엔지니어에게 접근 권한을 부여하고 있습니다. "
            "매주 새로운 고객 프로젝트가 생성될 때마다 개발자가 자신이 배정된 프로젝트 태그(`Project=Alpha` 등)를 가진 S3 버킷과 EC2 인스턴스만 관리할 수 있어야 합니다. "
            "보안 팀은 신규 프로젝트가 추가될 때마다 Permission Set이나 IAM 정책을 수정·배포하지 않고도 동적으로 최소 권한을 유지하고 싶습니다.\n\n"
            "가장 확장성이 높고 운영 오버헤드가 적은 구현 방식은 무엇입니까?"
        ),
        "IdP (Okta SAML/SCIM) -> IAM Identity Center -> 60 AWS Accounts\nDynamic Requirement: Engineers manage ONLY resources matching their assigned Project without modifying IAM policies per new project",
        [
            {"label": "A", "text": "신규 프로젝트가 생길 때마다 해당 프로젝트 전용 IAM Permission Set을 생성하고 CloudFormation StackSets로 60개 계정에 배포한다."},
            {"label": "B", "text": "IAM Identity Center에서 Attribute-Based Access Control(ABAC)을 활성화해 Okta의 사용자 속성(Project)을 세션 태그(aws:PrincipalTag/Project)로 매핑하고, 단일 Permission Set 정책에 aws:PrincipalTag/Project == aws:ResourceTag/Project 조건을 적용한다."},
            {"label": "C", "text": "모든 프로젝트에 공통 AdministratorAccess Permission Set을 부여하고 CloudTrail 알람으로 타 프로젝트 수정 시 사후 경고한다."},
            {"label": "D", "text": "프로젝트별로 별도의 AWS 계정을 생성하지 않고 모든 500명의 엔지니어에게 로컬 IAM User Access Key를 발급한다."}
        ],
        ["B"],
        "B) IAM Identity Center에서 ABAC(Attribute-Based Access Control)를 활성화해 Okta 사용자 속성을 aws:PrincipalTag/Project로 전달하고, 단일 Permission Set 정책에 aws:PrincipalTag/Project == aws:ResourceTag/Project 조건을 적용한다.",
        "IAM Identity Center, ABAC, aws:PrincipalTag, aws:ResourceTag, SAML Session Tags, Permission Sets",
        (
            "• 정답(B): **ABAC(속성 기반 접근 제어)** 를 IAM Identity Center와 결합하면 IdP(Okta)의 사용자 부서/프로젝트 속성이 STS 세션 태그(`aws:PrincipalTag/Project`)로 자동 전달됩니다. 단일 Permission Set 정책에서 `${aws:PrincipalTag/Project}` 와 리소스 태그(`aws:ResourceTag/Project`) 일치 여부 및 신규 리소스 생성 시 `aws:RequestTag/Project` 강제 조건만 검사하면, 프로젝트가 1,000개로 늘어나도 정책 수정이 전혀 필요 없습니다.\n"
            "• 오답 분석:\n"
            "  - A: RBAC 방식으로 프로젝트마다 Permission Set을 증설하면 관리 폭증과 500/계정별 할당 한도에 직면합니다.\n"
            "  - C: 사후 경고는 최소 권한 원칙 및 사전 접근 통제 요건을 충족하지 못합니다.\n"
            "  - D: 장기 IAM User 키 발급은 연합 인증(Federation) 모범 사례에 역행합니다."
        ),
        "정책 수정 없이 신규 프로젝트/팀 확장 = ABAC (`aws:PrincipalTag` vs `aws:ResourceTag` + `aws:RequestTag`)!"
    ),
    (
        2, 7, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] AWS Organizations SCP · IAM 권한 경계(Permissions Boundary) · 관리 계정 예외 평가 논리",
        (
            "보안 엔지니어가 조직의 `Production` OU에 `ec2:RunInstances`에서 `g5.48xlarge` 이상 GPU 인스턴스 생성을 차단하는 SCP를 연결했습니다. "
            "동일 조직의 **Management Account(관리 계정)** 에 로그인한 관리자 역할과, `Production` OU 내 멤버 계정의 **Permissions Boundary(권한 경계)** 가 `AmazonS3ReadOnlyAccess`로 제한된 상태에서 `AdministratorAccess`가 연결된 개발자 역할이 각각 존재합니다.\n\n"
            "다음 중 AWS IAM 정책 평가 결과에 대한 설명으로 정확한 것은 무엇입니까?"
        ),
        "Policy Layers:\n1) Org SCP attached to Production OU (denies g5.48xlarge)\n2) Management Account Admin Role\n3) Member Account Developer Role: Identity Policy = AdministratorAccess, Permissions Boundary = S3ReadOnly",
        [
            {"label": "A", "text": "관리 계정의 관리자는 Root OU의 SCP 영향을 받지 않으며, 멤버 계정의 개발자는 S3 읽기 작업만 수행할 수 있고 EC2나 다른 서비스 쓰기 작업은 거부된다."},
            {"label": "B", "text": "Root OU에 연결된 SCP는 관리 계정을 포함한 모든 계정에 적용되므로 관리 계정의 관리자도 GPU 인스턴스를 실행할 수 없다."},
            {"label": "C", "text": "멤버 계정의 개발자는 Identity Policy로 AdministratorAccess를 보유하므로 Permissions Boundary를 무시하고 EC2 인스턴스를 생성할 수 있다."},
            {"label": "D", "text": "SCP는 권한을 직접 부여하는 정책이므로 멤버 계정 내 IAM 역할에 별도 Identity Policy가 없어도 SCP의 Allow 문만으로 리소스에 접근할 수 있다."}
        ],
        ["A"],
        "A) 관리 계정의 관리자는 Root OU의 SCP 영향을 받지 않으며, 멤버 계정의 개발자는 S3 읽기 작업만 수행할 수 있고 EC2나 다른 서비스 쓰기 작업은 거부된다.",
        "IAM Policy Evaluation, SCP Management Account Exception, Permissions Boundary Intersection",
        (
            "• 정답(A): AWS Organizations에서 **SCP는 관리 계정(Management Account)과 서비스 연결 역할(Service-Linked Role)에는 적용되지 않습니다.** 또한 멤버 계정의 권한 평가에서는 [Identity Policy ∩ Permissions Boundary ∩ SCP] 의 교집합만 허용되므로, 개발자는 `AdministratorAccess`와 `S3ReadOnly` 권한 경계의 교집합인 **S3 읽기 전용** 권한만 행사할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - B: SCP는 관리 계정 내 사용자/역할에 적용되지 않습니다(이것이 관리 계정에 일반 워크로드를 두지 말아야 하는 핵심 이유입니다).\n"
            "  - C: Permissions Boundary는 최대 권한 상한선(Guardrail)으로, 여기에 포함되지 않은 작업은 Identity Policy가 `AdministratorAccess`라도 암묵적으로 거부됩니다.\n"
            "  - D: SCP는 권한을 부여(Grant)하지 않으며 오직 가용 권한의 최대 범위(Filter)만 정의합니다."
        ),
        "IAM 평가 철칙 2가지: 1) Effective Permission = Identity ∩ Boundary ∩ SCP (리소스 기반 정책 예외 주의), 2) SCP는 Management Account와 Service-Linked Role에 미적용!"
    ),
    (
        2, 8, 1, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] 교차 계정 KMS CMK 암호화 S3 리전 복제(CRR) 및 분석 계정 복호화 구성",
        (
            "Account A(프로덕션)의 S3 버킷(`prod-data`)은 Customer Managed KMS Key(`Key-A`)로 모든 객체를 암호화(SSE-KMS)합니다. "
            "재해 복구 및 전사 분석을 위해 `prod-data` 버킷은 Account B(DR/데이터 허브)의 S3 버킷(`dr-data`)으로 교차 리전 복제(CRR)되며, "
            "대상 객체는 Account B의 KMS Key(`Key-B`)로 재암호화되어야 합니다. 이후 Account C(BI 분석 팀)의 IAM 역할이 `dr-data` 버킷의 데이터를 조회합니다.\n\n"
            "이 교차 계정 암호화 파이프라인이 정상 작동하기 위해 반드시 필요한 KMS 키 정책 및 IAM 구성 조합 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Data Path:\nAccount A S3 (SSE-KMS Key-A) --[Replication Role in Acct A]--> Account B S3 (SSE-KMS Key-B) <--[Analyst Role in Acct C]",
        [
            {"label": "A", "text": "Account A의 S3 복제 IAM 역할에 Key-A에 대한 kms:Decrypt 권한과 Key-B에 대한 kms:Encrypt 권한(viaService 조건 포함 가능)을 부여하고, Key-B 키 정책에서 Account A의 복제 역할(또는 Account A)에 kms:Encrypt를 허용한다."},
            {"label": "B", "text": "Account C의 분석가 IAM 역할에 Key-B에 대한 kms:Decrypt 권한을 부여하고, Key-B 키 정책에서도 Account C의 분석가 역할(또는 Account C)을 신뢰하도록 허용한다."},
            {"label": "C", "text": "S3 교차 리전 복제는 AWS Managed Key(aws/s3)로만 동작하므로 Key-A와 Key-B 대신 aws/s3 키를 사용하도록 변경한다."},
            {"label": "D", "text": "Account A의 Key-A 정책만 Account C에 열어주면 복제 후에도 Key-A가 유지되므로 Key-B 설정은 필요 없다."},
            {"label": "E", "text": "S3 Replication이 KMS 키를 자동 우회하므로 S3 버킷 정책에 s3:PutObject 권한만 부여하면 별도 KMS 권한 설정은 불필요하다."}
        ],
        ["A", "B"],
        "A, B) 복제 역할에 Key-A kms:Decrypt 및 Key-B kms:Encrypt 부여 + Key-B 정책 허용 / Account C 분석 역할과 Key-B 정책 양쪽에 kms:Decrypt 허용",
        "Cross-Account S3 CRR, SSE-KMS, KMS Key Policy, KMS Decrypt/Encrypt, Dual Authorization",
        (
            "• 정답(A, B):\n"
            "  - A: SSE-KMS 객체를 복제할 때 S3 복제 서비스(Account A 복제 역할)는 원본 `Key-A`로 데이터를 복호화(`kms:Decrypt`)한 뒤, 대상 버킷의 `Key-B`로 암호화(`kms:Encrypt`/`kms:GenerateDataKey`)해야 합니다. 교차 계정이므로 복제 역할의 IAM 정책과 `Key-B`의 키 정책 양쪽에서 허용해야 합니다.\n"
            "  - B: 교차 계정(Account C)에서 `Key-B`로 암호화된 S3 객체를 읽을 때도 **Account C의 IAM 역할 권한**과 **Account B의 `Key-B` 키 정책** 양쪽 모두에 `kms:Decrypt` 권한이 명시되어야 합니다(KMS는 IAM 정책만으로는 교차 계정 권한 부여 불가).\n"
            "• 오답 분석:\n"
            "  - C: `aws/s3` AWS 관리형 키는 키 정책을 수정할 수 없어 교차 계정 복호화가 불가능합니다.\n"
            "  - D: 대상 버킷을 `Key-B`로 재암호화하는 요구사항에 맞지 않습니다.\n"
            "  - E: SSE-KMS 객체 복제는 명시적 KMS 권한(복제 시 Replica KMS 옵션 활성화 포함)이 없으면 실패합니다."
        ),
        "KMS 교차 계정 3대 규칙: 1) `aws/s3` 등 AWS Managed Key는 교차 계정 공유 불가 -> 반드시 CMK 사용, 2) Key Policy + IAM Policy 양측 허용 필수, 3) 복제 시 Source Decrypt + Target Encrypt!"
    ),
    (
        2, 9, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] AWS Organizations Tag Policy + SCP 결합을 통한 필수 태그 및 허용 값 강제",
        (
            "재무 거버넌스 팀이 모든 AWS 계정의 EC2 인스턴스와 EBS 볼륨에 `CostCenter` 태그가 반드시 존재하도록 요구하며, "
            "허용되는 태그 값은 오직 `FIN-100`, `ENG-200`, `OPS-300` 세 가지로만 엄격히 제한하고자 합니다. "
            "개발자가 잘못된 대소문자(`fin-100`)나 누락된 태그로 인스턴스를 생성하려는 시도는 즉시 차단되어야 합니다.\n\n"
            "두 가지 제약(필수 존재 여부 + 정확한 허용 값 검증)을 모두 강제하는 조합으로 올바른 것은 무엇입니까?"
        ),
        "Governance Requirement:\n1) Mandatory Tag Key: CostCenter must exist at ec2:RunInstances\n2) Value Enforcement: ONLY exact case-sensitive values {FIN-100, ENG-200, OPS-300}",
        [
            {"label": "A", "text": "AWS Organizations Tag Policy만 생성하여 Root OU에 연결한다."},
            {"label": "B", "text": "AWS Config `required-tags` 관리형 규칙만 전 계정에 배포한다."},
            {"label": "C", "text": "AWS Organizations Tag Policy로 허용 태그 값(FIN-100, ENG-200, OPS-300)과 강제 적용(Enforce) 대상 리소스를 정의하고, 동시에 SCP에서 RequestTag/CostCenter 키가 누락된 ec2:RunInstances 요청을 명시적으로 Deny한다."},
            {"label": "D", "text": "AWS Budgets에서 태그 필터를 활성화하면 태그가 없는 EC2 생성이 자동으로 차단된다."}
        ],
        ["C"],
        "C) AWS Organizations Tag Policy로 허용 태그 값과 강제 적용(Enforce)을 정의하고, 동시에 SCP에서 RequestTag/CostCenter 키가 누락된 ec2:RunInstances 요청을 명시적으로 Deny한다.",
        "AWS Organizations Tag Policy, Service Control Policy (SCP), aws:RequestTag, Tag Governance",
        (
            "• 정답(C): **Tag Policy**는 지정된 태그 키가 존재할 때 그 값의 대소문자와 허용 목록(Compliance)을 강제할 수 있지만, **태그가 아예 없는 리소스 생성 자체를 막지는 못합니다.** 반면 **SCP**는 `Null` 조건(`aws:RequestTag/CostCenter: true`)을 사용하여 필수 태그 없이 `ec2:RunInstances`를 호출하는 것을 원천 차단합니다. 따라서 **SCP(존재 강제) + Tag Policy(허용 값 강제)** 조합이 완벽한 해법입니다.\n"
            "• 오답 분석:\n"
            "  - A: Tag Policy 단독으로는 태그 누락 리소스 생성을 차단하지 못합니다.\n"
            "  - B: AWS Config는 리소스 생성 후 비준수(Non-compliant)를 탐지하는 사후(Detective) 도구입니다.\n"
            "  - D: AWS Budgets는 리소스 생성 차단 기능이 없습니다."
        ),
        "시험 빈출 콤비: Tag Policy = 태그 '값/대소문자' 통제 (미부여 리소스 생성 차단은 불가), SCP(`aws:RequestTag`) = 태그 '필수 입력' 차단!"
    ),
    (
        2, 10, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] 다중 리전 Transit Gateway Inter-Region Peering 및 IPAM 기반 CIDR 거버넌스",
        (
            "글로벌 SaaS 기업이 `us-east-1`, `eu-west-1`, `ap-northeast-2` 3개 리전에 각각 수십 개의 계정이 연결된 Transit Gateway(TGW)를 운영하고 있습니다. "
            "세 리전의 TGW 간에는 풀 메시(Full-Mesh) Inter-Region Peering을 구성해야 하며, 향후 각 사업부가 신규 VPC를 프로비저닝할 때 "
            "리전이나 계정을 넘나드는 IP 대역 충돌(Overlapping CIDR)을 사전에 원천 차단하고자 합니다.\n\n"
            "이에 대한 아키텍처 설계로 가장 올바른 설명은 무엇입니까?"
        ),
        "Multi-Region Mesh:\nTGW (us-east-1) <---> TGW (eu-west-1) <---> TGW (ap-northeast-2)\nScale: 60+ AWS accounts provisioning VPCs independently",
        [
            {"label": "A", "text": "TGW Inter-Region Peering은 동적 BGP 경로 전파를 자동 수행하므로 별도 경로 설정이 필요 없고, VPC CIDR 충돌은 Elastic IP로 자동 변환해 해결한다."},
            {"label": "B", "text": "Amazon VPC IP Address Manager(IPAM)를 조직 단위로 활성화해 리전별 비중첩 CIDR 풀 계층을 할당하고, 3개 TGW 간 Inter-Region Peering Attachment 생성 후 각 TGW 라우팅 테이블에 정적 경로(Static Route)를 등록한다."},
            {"label": "C", "text": "단일 VPC를 생성하고 3개 리전에 걸친 서브넷을 배치하면 Peering 없이 모든 리전이 통신한다."},
            {"label": "D", "text": "모든 VPC에 동일한 10.0.0.0/16 대역을 할당한 뒤 TGW가 NAT를 자동 수행하게 구성한다."}
        ],
        ["B"],
        "B) Amazon VPC IP Address Manager(IPAM)를 조직 단위로 활성화해 리전별 비중첩 CIDR 풀 계층을 할당하고, 3개 TGW 간 Inter-Region Peering Attachment 생성 후 각 TGW 라우팅 테이블에 정적 경로(Static Route)를 등록한다.",
        "Transit Gateway Inter-Region Peering, Static Routes, Amazon VPC IPAM, Overlapping CIDR Prevention",
        (
            "• 정답(B): TGW Inter-Region Peering은 **동적 라우팅(BGP)을 지원하지 않으며 반드시 각 TGW 라우팅 테이블에 정적 경로(Static Route)** 를 구성해야 합니다(또한 TGW 피어링 트래픽은 AWS 백본을 통해 암호화 전송됩니다). 조직 규모의 비중첩 CIDR 풀 할당과 충돌 모니터링은 **Amazon VPC IPAM** 이 담당합니다.\n"
            "• 오답 분석:\n"
            "  - A: TGW Inter-Region Peering은 동적 라우팅 전파를 지원하지 않습니다.\n"
            "  - C: VPC는 단일 리전 리소스이므로 여러 리전에 걸쳐 서브넷을 만들 수 없습니다.\n"
            "  - D: TGW는 기본 NAT 기능을 제공하지 않으므로 중첩 CIDR 간 직접 TGW 라우팅은 라우팅 충돌을 일으킵니다."
        ),
        "TGW 주의사항: VPC/DX Attachment는 동적 전파가 가능하지만, **TGW Peering Attachment는 오직 Static Route만 지원**합니다!"
    ),
    (
        2, 11, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] 중앙 EventBridge Event Bus + Archive/Replay 기반 멀티어카운트 이벤트 통합",
        (
            "30개의 마이크로서비스 계정이 각자의 비즈니스 도메인 이벤트(주문 생성, 결제 완료, 재고 차감 등)를 생성하고 있으며, "
            "중앙 Data Analytics 계정은 모든 이벤트를 실시간 수신해 Amazon OpenSearch 및 S3 데이터 레이크에 적재해야 합니다. "
            "장애 또는 신규 컨슈머 추가 시 지난 14일간의 이벤트를 필터링해 재처리(Replay)할 수 있어야 하며, 계정 간 SQS/SNS 큐를 일일이 관리하고 싶지 않습니다.\n\n"
            "가장 깔끔하고 확장성 높은 서버리스 이벤트 라우팅 설계는 무엇입니까?"
        ),
        "Architecture Goal:\n30 Producer Accounts ---> Central Analytics Account (Ingestion + 14-day Replay + Schema Discovery)",
        [
            {"label": "A", "text": "30개 계정에 각각 SNS 토픽을 만들고 Analytics 계정의 단일 SQS 큐에 30번 수동 구독을 연결한다."},
            {"label": "B", "text": "중앙 Analytics 계정에 커스텀 Amazon EventBridge Event Bus를 생성하고 리소스 정책에 aws:PrincipalOrgID를 허용한 뒤 14일 보존 Event Archive를 활성화한다. 각 생산자 계정의 EventBridge Rule이 중앙 Event Bus를 타깃으로 이벤트를 전송한다."},
            {"label": "C", "text": "30개 계정에 NAT Gateway를 두고 각 계정이 Analytics 계정의 EC2 REST 서버로 HTTPS POST 호출을 보낸다."},
            {"label": "D", "text": "모든 계정의 DynamoDB 테이블에 Streams를 열고 Analytics 계정 Lambda가 30개 스트림을 직접 폴링하게 한다."}
        ],
        ["B"],
        "B) 중앙 Analytics 계정에 커스텀 Amazon EventBridge Event Bus를 생성해 aws:PrincipalOrgID 리소스 정책과 14일 Event Archive를 활성화하고, 각 계정의 EventBridge Rule로 중앙 Event Bus에 이벤트를 전달한다.",
        "Amazon EventBridge Custom Event Bus, Cross-Account Event Routing, Event Archive and Replay, aws:PrincipalOrgID",
        (
            "• 정답(B): **Amazon EventBridge** 는 계정 간 이벤트 버스 직접 라우팅을 기본 지원합니다. 중앙 버스 리소스 정책에 `aws:PrincipalOrgID`를 설정하면 신규 계정 추가 시에도 중앙 버스로 바로 이벤트를 보낼 수 있으며, **EventBridge Archive & Replay** 기능을 통해 별도 데이터베이스나 카프카 구축 없이 14일간의 과거 이벤트를 조건 필터링해 재실행할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - A: SQS/SNS는 14일 이벤트 아카이브 및 조건부 Replay 기능을 기본 제공하지 않으며 계정 수만큼 구독 관리가 늘어납니다.\n"
            "  - C, D: EC2 REST 폴링이나 다중 계정 DynamoDB Stream 직접 폴링은 높은 운영 부담과 확장성 한계를 가집니다."
        ),
        "서버리스 멀티어카운트 이벤트 팬인(Fan-in) + 과거 이벤트 재실행(Replay) = **EventBridge Custom Event Bus + Archive/Replay**."
    ),
    (
        2, 12, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] 인수 합병으로 발생한 Overlapping CIDR 환경에서 AWS PrivateLink 단방향 서비스 노출",
        (
            "A사가 최근 B사를 인수했습니다. A사의 핵심 금융 원장 API VPC(`10.10.0.0/16`)와 B사의 애플리케이션 VPC(`10.10.0.0/16`)는 "
            "완전히 동일한 사설 IP 대역을 사용하고 있어 즉각적인 IP 재할당이 불가능합니다. "
            "B사의 EC2 및 ECS 워크로드는 인터넷을 거치지 않고 A사의 원장 API(ALB 뒤에서 실행 중)만 단방향으로 호출해야 하며, "
            "A사 네트워크에서는 B사 네트워크로 어떠한 인바운드 연결도 시작할 수 없어야 합니다.\n\n"
            "가장 적은 네트워크 변경으로 이 요구사항을 해결하는 방법은 무엇입니까?"
        ),
        "A Corp VPC: 10.10.0.0/16 (Core Ledger API on ALB)\nB Corp VPC: 10.10.0.0/16 (OVERLAPPING CIDR!)\nConstraints: Private connectivity only, Unidirectional (B -> A only), No re-IPing",
        [
            {"label": "A", "text": "두 VPC 간에 AWS Transit Gateway를 연결하고 정적 라우팅을 추가한다."},
            {"label": "B", "text": "두 VPC 간에 VPC Peering을 생성한다."},
            {"label": "C", "text": "A사 VPC의 ALB를 타깃으로 하는 Network Load Balancer(NLB)를 생성하고 AWS PrivateLink(VPC Endpoint Service)로 노출한 뒤, B사 VPC에 Interface VPC Endpoint를 생성하여 Private DNS로 호출한다."},
            {"label": "D", "text": "B사 VPC에 Site-to-Site VPN을 구성하고 A사 VPC의 Internet Gateway 퍼블릭 IP로 트래픽을 보낸다."}
        ],
        ["C"],
        "C) A사 VPC의 ALB를 타깃으로 하는 NLB를 생성하고 AWS PrivateLink(VPC Endpoint Service)로 노출한 뒤, B사 VPC에 Interface VPC Endpoint를 생성하여 호출한다.",
        "AWS PrivateLink, Overlapping CIDR, NLB ALB Target Type, Interface VPC Endpoint, Unidirectional Access",
        (
            "• 정답(C): **AWS PrivateLink** 는 서비스 제공자(A사)와 소비자(B사)의 **VPC CIDR이 완전히 중복(Overlapping)되어도 정상 동작**합니다(소비자 VPC 내부 ENI 사설 IP로 매핑됨). 또한 연결 방향이 소비자→제공자로 엄격히 **단방향(Unidirectional)** 이며, NLB가 ALB 타깃 타입을 지원하므로 기존 ALB의 L7 라우팅 기능도 그대로 활용할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - A, B: VPC Peering과 기본 Transit Gateway VPC 연결은 중첩된 CIDR 대역 간 라우팅을 지원하지 않습니다.\n"
            "  - D: 인터넷 게이트웨이 경유는 사설 통신 보안 요구에 어긋납니다."
        ),
        "M&A 중첩 CIDR(Overlapping CIDR) + 단방향 프라이빗 API 노출 = **AWS PrivateLink (NLB -> ALB Target)**!"
    ),
    (
        2, 13, 1, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] 금융 규제 준수를 위한 7년 불변 감사 로그 아카이브 및 즉시 SQL 감사 조회",
        (
            "금융 규제 기관의 감사 요건에 따라, AWS Organizations에 속한 모든 50개 계정의 CloudTrail 관리 이벤트 및 S3 데이터 이벤트 로그를 "
            "향후 7년간 어떠한 관리자(심지어 AWS 루트 사용자 포함)도 수정하거나 삭제할 수 없도록 불변 저장(WORM)해야 합니다. "
            "또한 감사관이 임의 기간에 대한 이상 API 호출을 수십 분 내에 표준 SQL로 조회할 수 있어야 합니다.\n\n"
            "이를 만족하기 위해 구성해야 할 2가지 핵심 조합은 무엇입니까? (Select TWO.)"
        ),
        "Compliance Mandates:\n- All 50 Org accounts CloudTrail management + data events\n- 7-year WORM immutability (even root user cannot delete)\n- Fast SQL querying across historical logs",
        [
            {"label": "A", "text": "중앙 Log Archive 계정의 S3 버킷에 버전 관리와 S3 Object Lock(Compliance Mode, 7년 보존)을 활성화하고 Organization Trail이 해당 버킷에 기록하도록 구성한다."},
            {"label": "B", "text": "S3 버킷 정책에 Deny DeleteObject를 추가하고 S3 Object Lock Governance Mode를 7년으로 설정한다."},
            {"label": "C", "text": "AWS CloudTrail Lake(7년 보존 Event Data Store)를 조직 단위로 활성화하거나, Partition Projection이 적용된 Amazon Athena 테이블을 중앙 CloudTrail S3 버킷에 연결한다."},
            {"label": "D", "text": "S3 Glacier Deep Archive로 즉시 전환해 보관하고 조회 시마다 전수 복원(Bulk Restore) 후 grep으로 분석한다."},
            {"label": "E", "text": "각 계정의 CloudWatch Logs에 보관한 뒤 수동으로 CSV를 다운로드해 로컬 Excel에서 조회한다."}
        ],
        ["A", "C"],
        "A, C) S3 Object Lock (Compliance Mode, 7년) + Organization Trail 구성 / AWS CloudTrail Lake 또는 Partition Projection 기반 Athena SQL 조회",
        "S3 Object Lock Compliance Mode, WORM, CloudTrail Lake, Athena Partition Projection, Organization Trail",
        (
            "• 정답(A, C):\n"
            "  - A: 루트 사용자조차 7년 보존 기간 내 객체를 삭제·덮어쓰기할 수 없도록 하려면 S3 Object Lock의 **Compliance Mode(규정 준수 모드)** 를 사용해야 합니다.\n"
            "  - C: 수 테라바이트 이상의 CloudTrail JSON 로그를 수 분 내 SQL로 조회하려면 조직 통합 **CloudTrail Lake**(내부 관리형 불변 이벤트 데이터 스토어 + SQL 엔진) 또는 **Athena Partition Projection** 을 구성하는 것이 최적입니다.\n"
            "• 오답 분석:\n"
            "  - B: Governance Mode는 `s3:BypassGovernanceRetention` 특수 권한을 가진 관리자/루트가 보존 잠금을 해제·삭제할 수 있습니다.\n"
            "  - D: Glacier Deep Archive는 복원에 12~48시간이 소요되어 수십 분 내 즉각 SQL 조회 요건을 위반합니다.\n"
            "  - E: 전사 50개 계정의 대용량 로그를 수동 CSV/Excel로 분석하는 것은 불가능합니다."
        ),
        "S3 Object Lock 핵심 구분: **Governance Mode**(특수 권한 우회 가능) vs **Compliance Mode**(루트 포함 누구도 만료 전 삭제 불가)."
    ),
    (
        2, 14, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] 중앙 Egress VPC + AWS Network Firewall 기반 멀티어카운트 아웃바운드 도메인 검사",
        (
            "보안 팀이 35개의 스포크 VPC에서 외부 인터넷으로 나가는 모든 아웃바운드 HTTP/HTTPS 트래픽을 중앙에서 통제하려고 합니다. "
            "규정상 각 스포크 VPC에는 Internet Gateway(IGW)나 NAT Gateway를 직접 둘 수 없으며, 승인된 도메인(`*.pypi.org`, `*.redhat.com` 등)으로의 "
            "HTTPS 요청(TLS SNI 기반)만 허용하고 비인가 도메인으로의 유출 시도는 차단한 뒤 로그를 중앙 SIEM으로 전송해야 합니다.\n\n"
            "가장 권장되는 AWS 네트워킹 아키텍처는 무엇입니까?"
        ),
        "Constraints:\n- 35 Spoke VPCs: NO local IGW or NAT Gateway\n- Outbound HTTPS filtering by domain name (TLS SNI)\n- Centralized NAT + stateful domain firewall",
        [
            {"label": "A", "text": "각 스포크 VPC의 Security Group 아웃바운드 규칙에 도메인 이름을 직접 입력해 허용한다."},
            {"label": "B", "text": "중앙 Egress/Inspection VPC를 구성해 각 AZ에 NAT Gateway, IGW, 그리고 AWS Network Firewall(Stateful Domain List 규칙 그룹)을 배치한 뒤, Transit Gateway 라우팅으로 스포크 VPC의 0.0.0.0/0 트래픽을 TGW -> Firewall -> NAT GW -> IGW 순으로 경유시킨다."},
            {"label": "C", "text": "각 스포크 VPC에 Network ACL(NACL)을 생성해 외부 도메인 IP를 수동 등록한다."},
            {"label": "D", "text": "CloudFront 배포를 아웃바운드 프록시로 연결하여 사설 서브넷 EC2 트래픽을 외부로 중계한다."}
        ],
        ["B"],
        "B) 중앙 Egress/Inspection VPC에 AZ별 NAT Gateway, IGW, AWS Network Firewall(Stateful Domain List)을 배치하고, TGW 라우팅으로 스포크 0.0.0.0/0 트래픽이 Firewall -> NAT GW -> IGW 순으로 통과하게 구성한다.",
        "AWS Network Firewall, Centralized Egress VPC, TLS SNI Filtering, Transit Gateway, NAT Gateway",
        (
            "• 정답(B): **AWS Network Firewall** 은 Stateful 규칙 엔진에서 HTTP Host 헤더 및 **HTTPS TLS SNI(Server Name Indication)** 기반의 도메인 화이트리스트/블랙리스트 필터링을 네이티브 지원합니다. 중앙 Egress VPC에서 스포크 트래픽을 TGW → Firewall 엔드포인트 → NAT Gateway(동일 AZ) → IGW 순서로 라우팅하면(반대 방향 응답도 NAT GW → Firewall → TGW 순으로 대칭 복귀) 개별 스포크의 IGW/NAT 없이 완벽한 중앙 통제가 가능합니다.\n"
            "• 오답 분석:\n"
            "  - A, C: Security Group과 NACL은 IP/CIDR만 허용 가능하며 도메인 이름(`*.pypi.org`) 기반 필터링을 지원하지 않습니다.\n"
            "  - D: CloudFront는 인바운드 CDN이지 사설 VPC의 아웃바운드 TLS SNI 프록시가 아닙니다."
        ),
        "아웃바운드 도메인(`*.example.com`) 필터링 = **AWS Network Firewall (TLS SNI Stateful Rule)** 또는 **Route 53 Resolver DNS Firewall**(DNS 레벨 차단)."
    ),
    (
        2, 15, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] AWS Control Tower + Account Factory Customization(AFC) & Proactive Guardrails",
        (
            "엔터프라이즈 클라우드 플랫폼 팀이 AWS Control Tower를 도입해 100개 이상의 사업부 계정을 표준화하려 합니다. "
            "요구사항은 세 가지입니다:\n"
            "1) 신규 계정이 프로비저닝될 때 표준 IAM 역할, 네트워크 베이스라인, 로깅 설정이 자동 배포될 것\n"
            "2) 비암호화 S3 버킷 생성이나 퍼블릭 RDS 스냅샷 생성을 사전(Preventive) 차단할 것\n"
            "3) 개발자가 CloudFormation으로 비준수 리소스를 배포하기 전 **배포 시점(Proactive)** 에 템플릿을 검사해 차단하고, 기존 리소스는 상시(Detective) 감시할 것\n\n"
            "Control Tower에서 이를 통합 구현하는 조합으로 가장 적절한 것은 무엇입니까?"
        ),
        "Control Tower 3-Layer Controls:\n1) Automated Blueprints at Account Creation\n2) Preventive (SCP) + Detective (AWS Config)\n3) Proactive (CloudFormation Hook pre-deployment block)",
        [
            {"label": "A", "text": "Control Tower Account Factory Customization(AFC)으로 계정 생성 시 블루프린트를 배포하고, Control Tower Controls Library에서 Preventive(SCP), Detective(AWS Config), Proactive(AWS CloudFormation Hooks) 컨트롤을 OU 단위로 활성화한다."},
            {"label": "B", "text": "모든 사업부에 수동 계정을 생성하게 한 뒤 연 1회 AWS Trusted Advisor 리포트를 이메일로 발송한다."},
            {"label": "C", "text": "Control Tower 없이 IAM User만 생성하고 SCP만으로 CloudFormation 파라미터 내부 속성을 정밀 검증한다."},
            {"label": "D", "text": "Detective 컨트롤만 활성화하면 비준수 리소스 생성이 자동으로 사전 차단된다."}
        ],
        ["A"],
        "A) Account Factory Customization(AFC)으로 계정 생성 블루프린트를 배포하고, Control Tower Controls Library에서 Preventive(SCP), Detective(AWS Config), Proactive(CloudFormation Hooks) 컨트롤을 OU 단위로 활성화한다.",
        "AWS Control Tower, Account Factory Customization (AFC), Preventive/Detective/Proactive Controls, CloudFormation Hooks",
        (
            "• 정답(A): AWS Control Tower는 Account Factory(또는 AFC/AFT)로 신규 계정 생성을 표준화하며, 3종류의 관리형 가드레일을 제공합니다:\n"
            "  - **Preventive(예방)**: AWS Organizations **SCP** 기반 API 차단\n"
            "  - **Detective(탐지)**: **AWS Config** 규칙 기반 비준수 상태 감지\n"
            "  - **Proactive(선제 차단)**: **AWS CloudFormation Hooks** 를 이용해 IaC 프로비저닝 완료 전 비준수 리소스 생성 자체를 중단\n"
            "• 오답 분석:\n"
            "  - B, D: 연 1회 점검이나 Detective 컨트롤은 비준수 생성을 사전/배포 시점에 막지 못합니다.\n"
            "  - C: SCP는 IAM API 파라미터 일부 조건만 검사하며 CloudFormation 템플릿 내부 리소스 속성 전수를 검증하는 Proactive Hook을 대체하지 못합니다."
        ),
        "Control Tower 가드레일 3대 메커니즘: Preventive = SCP, Detective = AWS Config, Proactive = CloudFormation Hooks!"
    ),
    (
        2, 16, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1] 다중 계정 AWS Backup 중앙 거버넌스 및 Cross-Account Copy 정책",
        (
            "규제 대상 의료 데이터 플랫폼이 AWS Organizations 내 25개 계정에 걸쳐 Amazon RDS, EFS, EBS 볼륨, DynamoDB 테이블을 운영하고 있습니다. "
            "컴플라이언스 감사 팀은 모든 `Production` OU 계정에 대해 매일 암호화된 백업을 자동 생성하고, 생성된 백업을 즉시 격리된 중앙 `Backup-Vault-Account` 로 복사해 "
            "개별 계정 관리자가 백업 정책을 끄거나 복구 지점을 임의로 지우지 못하게 강제해야 합니다.\n\n"
            "관리 부담을 최소화하며 이 백업 거버넌스를 구현하는 방법은 무엇입니까?"
        ),
        "Accounts: 25 Production Accounts + 1 Isolated Backup Account\nGoal: Org-wide mandatory daily backups + Cross-account copy + Tamper resistance",
        [
            {"label": "A", "text": "각 계정의 개발자에게 cron 스크립트로 스냅샷을 찍어 중앙 S3에 복사하도록 지시한다."},
            {"label": "B", "text": "AWS Organizations에서 AWS Backup Cross-Account Management 및 Backup Policies를 활성화해 Production OU에 백업 계획을 강제 적용하고, 대상 볼트를 중앙 Backup-Vault-Account의 Vault Lock이 적용된 볼트로 지정하며, 멤버 계정 SCP로 backup:DeleteRecoveryPoint를 차단한다."},
            {"label": "C", "text": "Amazon Data Lifecycle Manager(DLM)만 사용하여 RDS와 DynamoDB까지 통합 교차 계정 백업을 수행한다."},
            {"label": "D", "text": "AWS Config 규칙으로 스냅샷 존재 여부만 확인하고, 삭제 시 Lambda로 1시간 후 복원한다."}
        ],
        ["B"],
        "B) AWS Organizations에서 AWS Backup Cross-Account Management 및 Backup Policies를 활성화해 Production OU에 백업 계획을 강제 적용하고, 중앙 Backup-Vault-Account의 Vault Lock 볼트로 교차 계정 복사하며 SCP로 삭제를 차단한다.",
        "AWS Backup Policies, Cross-Account Management, Backup Vault Lock, Organizations OU Governance",
        (
            "• 정답(B): **AWS Backup** 은 AWS Organizations와 통합되어 OU 단위의 **Backup Policies** 로 모든 계정에 일괄 백업 스케줄을 배포할 수 있으며, Cross-Account Backup을 통해 격리된 백업 전용 계정으로 암호화 복사하고 **Backup Vault Lock** 및 SCP로 삭제를 완전히 차단합니다.\n"
            "• 오답 분석:\n"
            "  - A: 수동 스크립트는 감사 추적·규정 강제·다중 서비스(RDS/EFS/DynamoDB) 일괄 지원이 어렵습니다.\n"
            "  - C: DLM은 EBS 스냅샷 및 AMI 수명주기 전용이며 RDS·DynamoDB·EFS 백업을 통합 관리하지 않습니다.\n"
            "  - D: 이미 영구 삭제된 스냅샷은 Lambda로 되살릴 수 없습니다."
        ),
        "EBS만이면 DLM, RDS/EFS/DynamoDB/EBS 전사 통합 + 조직 정책 강제 + 교차 계정 불변 복사는 **AWS Backup + Backup Policies + Vault Lock**!"
    ),

    # =========================================================================
    # ROUND 3 (SET 2): Domain 2 — Design for New Solutions (16 Questions)
    # =========================================================================
    (
        3, 1, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] RPO 1분 미만 · RTO 5분 미만 재해 복구(DR) 전략 선택 (Warm Standby vs Pilot Light vs Active-Active)",
        (
            "국내 결제 게이트웨이 서비스가 서울(`ap-northeast-2`) 리전을 주 리전으로 운영 중이며, 도쿄(`ap-northeast-1`) 리전에 재해 복구(DR) 환경을 신규 설계하고 있습니다. "
            "금융감독 규정에 따라 **RPO는 1분 미만(실제 목표 수 초 이내), RTO는 5분 미만**을 만족해야 하지만, 평상시 도쿄 리전에 서울과 100% 동일한 규모의 "
            "컴퓨팅(ECS/EKS 수십 개 태스크)을 풀 가동하여 2배의 비용을 지출할 수는 없습니다.\n\n"
            "비용 효율성과 엄격한 RPO/RTO SLA를 동시에 만족하는 DR 아키텍처는 무엇입니까?"
        ),
        "DR SLA: RPO < 1 min, RTO < 5 min\nCost Constraint: Must NOT run 100% full production compute capacity idle in DR region",
        [
            {"label": "A", "text": "Backup and Restore 전략: 1시간마다 RDS 스냅샷과 S3 데이터를 도쿄 리전으로 복제하고 장애 시 CloudFormation으로 전체 인프라를 신규 프로비저닝한다."},
            {"label": "B", "text": "Pilot Light 전략: Aurora Global Database로 데이터만 실시간 복제해 두고 도쿄 리전의 애플리케이션 계층은 모두 중지(0대) 상태로 둔 뒤 장애 시 인스턴스를 기동·배포한다."},
            {"label": "C", "text": "Warm Standby 전략: 도쿄 리전에 Aurora Global Database 보조 클러스터를 두고 핵심 애플리케이션 계층을 최소 축소 규모(예: 평상시 트래픽의 10~20%)로 상시 실행해 두며, Route 53 헬스 체크 장애 감지 시 트래픽 전환과 Auto Scaling 고속 확장을 동시에 트리거한다."},
            {"label": "D", "text": "Multi-Site Active-Active 전략: 두 리전에 평상시에도 각각 100% 전체 용량을 상시 가동하여 DNS 50:50 라운드 로빈을 수행한다."}
        ],
        ["C"],
        "C) Warm Standby 전략: Aurora Global Database 실시간 복제(RPO < 1초) + 도쿄 리전 애플리케이션 최소 규모 상시 가동 + 장애 시 Route 53 전환 및 Auto Scaling 확장(RTO < 5분)",
        "Warm Standby, Pilot Light, RPO/RTO, Aurora Global Database, Disaster Recovery Trade-off",
        (
            "• 정답(C): **Warm Standby** 는 데이터베이스 실시간 복제(Aurora Global DB, RPO < 1초)뿐만 아니라 애플리케이션 서버도 최소 축소 규모로 상시 기동 상태를 유지하므로, 헬스 체크 및 Auto Scaling 스케일아웃을 통해 **수 분 내(RTO < 5분)** 트래픽을 수용할 수 있으면서도 100% Active-Active 대비 컴퓨팅 비용을 크게 절감합니다.\n"
            "• 오답 분석:\n"
            "  - A: Backup and Restore는 RTO가 수 시간 이상 소요됩니다.\n"
            "  - B: Pilot Light는 데이터만 살아있고 앱 계층이 정지 상태이므로 OS 부팅·컨테이너 풀·캐시 웜업 등으로 인해 보통 10~30분 이상의 RTO가 발생해 5분 미만 요건이 위태롭습니다.\n"
            "  - D: Active-Active(100% 상시 용량)는 비용 최소화 제약에 어긋납니다."
        ),
        "DR 4단계 스펙트럼: Backup&Restore(시간) -> Pilot Light(앱 정지, 10~30분) -> Warm Standby(최소 앱 상시 가동, 수 분) -> Multi-Site Active-Active(실시간 0초대, 최고 비용)."
    ),
    (
        3, 2, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] AWS Global Accelerator 기반 고정 Anycast IP 및 비HTTP(TCP/UDP) 초고속 장애 절체",
        (
            "실시간 금융 시세 분배 플랫폼이 전 세계 기관 고객에게 커스텀 바이너리 **TCP 및 UDP 프로토콜**로 데이터를 전송합니다. "
            "기관 고객들은 사내 방화벽 화이트리스트 정책상 **단일 고정 IP 주소 2개**만 등록해야 하며, "
            "주 리전(`us-east-1`) NLB 장애 시 클라이언트 DNS 캐시 만료를 기다리지 않고 **30초 이내**에 대기 리전(`eu-central-1`) NLB로 자동 페일오버되어야 합니다.\n\n"
            "이 요구사항을 충족하는 최적의 AWS 서비스 구성은 무엇입니까?"
        ),
        "Protocol: Custom Binary TCP & UDP (Non-HTTP)\nConstraints: 2 Static Anycast IPs for client firewall allowlisting + <30s failover bypassing client DNS TTL",
        [
            {"label": "A", "text": "Amazon CloudFront 배포를 생성하고 두 리전의 NLB를 Origin Group으로 구성한다."},
            {"label": "B", "text": "Amazon Route 53 Failover 라우팅 정책을 TTL 10초로 설정하고 양 리전 NLB의 탄력적 IP를 번갈아 반환한다."},
            {"label": "C", "text": "AWS Global Accelerator를 생성하여 2개의 고정 Anycast IP를 발급받고, us-east-1 NLB(Weight 100)와 eu-central-1 NLB(Weight 0 또는 Health Check Failover)를 Endpoint Group으로 연결한다."},
            {"label": "D", "text": "AWS Direct Connect Gateway를 퍼블릭 인터넷 사용자용 Anycast 라우터로 노출한다."}
        ],
        ["C"],
        "C) AWS Global Accelerator를 생성하여 2개의 고정 Anycast IP를 발급받고, 두 리전의 NLB를 Endpoint Group으로 연결해 헬스 체크 기반 초고속 전환을 구성한다.",
        "AWS Global Accelerator, Anycast Static IP, TCP/UDP Support, DNS Cache Bypass, Endpoint Health Check",
        (
            "• 정답(C): **AWS Global Accelerator** 는 전 세계 엣지 로케이션에서 2개의 고정 Anycast IP를 제공하며 TCP/UDP(비HTTP) 트래픽을 AWS 글로벌 백본으로 가속 라우팅합니다. 엔드포인트 헬스 체크 실패 시 클라이언트 측의 악명 높은 DNS 캐싱 지연 없이 30초 이내에 트래픽을 정상 리전으로 즉시 전환합니다.\n"
            "• 오답 분석:\n"
            "  - A: CloudFront는 HTTP/HTTPS 및 WebSocket 전용이며 일반 TCP/UDP 프로토콜과 2개 고정 Anycast IP 화이트리스팅을 지원하지 않습니다.\n"
            "  - B: Route 53 Failover는 DNS 기반이므로 기업 내 로컬 DNS 리졸버나 OS/애플리케이션이 TTL을 무시하고 오래 캐시할 경우 30초 내 전환이 보장되지 않으며 단일 고정 IP도 제공할 수 없습니다.\n"
            "  - D: Direct Connect Gateway는 사설 DX/VPC 라우팅용입니다."
        ),
        "시험 시그널: 'Non-HTTP (TCP/UDP)' + '2 Static IPs (Firewall Allowlist)' + 'Ignore DNS TTL caching / Sub-minute regional failover' = **AWS Global Accelerator**!"
    ),
    (
        3, 3, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] Aurora Global Database 계획된 무손실 페일오버(Managed Planned Failover) vs Write Forwarding",
        (
            "다국적 인사(HR) SaaS 애플리케이션이 `us-east-1`에 Aurora PostgreSQL Primary 클러스터를, `eu-west-1`에 Secondary 클러스터를 둔 **Aurora Global Database** 로 운영 중입니다. "
            "아키텍트는 두 가지 운영 시나리오를 설계해야 합니다:\n"
            "1) 분기별 DR 모의훈련 시 **데이터 손실 0건(RPO = 0)** 으로 `eu-west-1` 을 주 쓰기 클러스터로 승격하고, 기존 `us-east-1` 은 자동으로 복제본이 되도록 토폴로지를 유지한다.\n"
            "2) 평상시 `eu-west-1` 의 일부 레거시 마이크로서비스가 코드 변경 최소화를 위해 로컬 Secondary 엔드포인트에 가끔 `INSERT/UPDATE` 를 전송해도 Primary로 전달되어 처리되게 한다.\n\n"
            "이 두 요구사항에 부합하는 Aurora Global Database 기능 조합은 무엇입니까?"
        ),
        "Aurora Global Database Operations:\n1) Quarterly planned DR drill with RPO = 0 and topology preservation\n2) Secondary region occasional writes without separate primary connection string",
        [
            {"label": "A", "text": "DR 훈련 시 Secondary를 독립 클러스터로 Unplanned Promote한 뒤 새로 Global DB를 재구성하고, 쓰기 요청은 Route 53으로 Primary에 포워딩한다."},
            {"label": "B", "text": "DR 훈련 시 Managed Planned Failover(Switchover)를 사용하고, Secondary 클러스터에 Write Forwarding(Local/Global Write Forwarding)을 활성화하며 세션 읽기 일관성(session consistency)을 설정한다."},
            {"label": "C", "text": "Multi-Master Aurora MySQL 클러스터를 두 리전에 걸쳐 배포한다."},
            {"label": "D", "text": "DMS 양방향 CDC 복제를 Aurora Global DB 위에 추가로 덮어씌운다."}
        ],
        ["B"],
        "B) DR 훈련 시 Managed Planned Failover를 사용하여 RPO=0 및 복제 토폴로지를 유지하고, Secondary 클러스터의 Write Forwarding을 활성화한다.",
        "Aurora Global Database, Managed Planned Failover, RPO 0, Write Forwarding, Read Consistency",
        (
            "• 정답(B): Aurora Global Database의 **Managed Planned Failover(Switchover)** 는 Primary의 쓰기를 일시 중지하고 모든 변경 로그(Redo)가 Secondary에 100% 동기화될 때까지 대기한 후 역할을 교대하므로 **데이터 손실이 0(RPO = 0)** 이며 전체 Global Database 토폴로지도 깨지지 않습니다. 또한 **Write Forwarding** 을 켜면 Secondary 리전 클러스터로 들어온 쓰기 쿼리를 Primary로 자동 포워딩하며, `session` 일관성 모드를 통해 자기 세션이 쓴 데이터를 즉시 읽을 수 있습니다(Read-your-own-writes).\n"
            "• 오답 분석:\n"
            "  - A: Unplanned Failover(Detach & Promote)는 Global DB 연결을 끊어 버리므로 복제 토폴로지를 수동 재구축해야 하며 RPO=0 보장이 아닙니다.\n"
            "  - C: Aurora Multi-Master는 단일 리전 전용 레거시 기능이며 리전 간 지원이 되지 않습니다.\n"
            "  - D: Global DB 위에 양방향 DMS를 얹으면 PK 충돌 및 무한 루프 장애가 발생합니다."
        ),
        "Aurora Global DB 구분: 계획된 전환/훈련 = **Managed Planned Failover (RPO=0, 토폴로지 유지)**, 실제 재해 복구 = **Failover (Promote Secondary, <1s RPO)**."
    ),
    (
        3, 4, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] DynamoDB Global Tables 다중 리전 동시 수정 충돌(LWW) 방지 및 강한 일관성 설계",
        (
            "글로벌 콘서트 티켓 예매 플랫폼이 `us-east-1`, `eu-west-1`, `ap-northeast-1` 3개 리전에서 Amazon DynamoDB Global Tables을 사용 중입니다. "
            "사용자 프로필 조회와 공연 목록 브라우징은 로컬 리전에서 10ms 미만으로 동작해야 하지만, "
            "동일한 한정판 VIP 좌석(`seat_id`)에 대해 미국과 한국 사용자가 0.1초 간격으로 동시에 결제 확정을 시도할 때 "
            "DynamoDB Global Tables의 **Last-Writer-Wins(LWW)** 특성으로 인해 두 사용자가 모두 예매 성공 응답을 받는 이중 판매(Overbooking) 버그가 발생했습니다.\n\n"
            "로컬 읽기 속도를 유지하면서 좌석 재고 차감의 절대적 원자성(이중 판매 방지)을 보장하는 올바른 아키텍처 개선안은 무엇입니까?"
        ),
        "Conflict Scenario:\nUS user reserves seat #A12 in us-east-1 (ConditionExpression: status = AVAILABLE) -> Success\nKR user reserves seat #A12 in ap-northeast-1 100ms later (local replica not yet updated!) -> Also Success -> LWW overwrites!",
        [
            {"label": "A", "text": "모든 리전에서 DynamoDB `ConsistentRead=true` 옵션만 추가하면 다른 리전의 미복제 쓰기까지 즉시 반영되어 충돌이 사라진다."},
            {"label": "B", "text": "공연/좌석의 소유권 리전(Home Region)을 지정해 재고 차감 쓰기(Conditional Write / TransactWriteItems)는 오직 해당 좌석의 Home Region 단일 테이블 엔드포인트로만 라우팅하고, 조회/사용자 세션 데이터만 로컬 Global Tables 복제본에서 읽는다."},
            {"label": "C", "text": "DynamoDB Streams와 Lambda를 연결해 충돌 발생 시 사후에 한 명의 결제를 일방 취소한다."},
            {"label": "D", "text": "DynamoDB Global Tables의 복제 모드를 동기식 2PC(Two-Phase Commit) 모드로 변경한다."}
        ],
        ["B"],
        "B) 좌석별 Home Region(단일 쓰기 마스터 리전)을 지정해 재고 차감 조건부 쓰기(ConditionExpression/TransactWriteItems)는 Home Region으로 라우팅하고, 조회 및 사용자 프로필은 로컬 복제본에서 읽는다.",
        "DynamoDB Global Tables, Last-Writer-Wins (LWW), Conditional Write, Home Region Sharding, Strong Consistency",
        (
            "• 정답(B): DynamoDB Global Tables는 비동기 다중 마스터 복제(~1초 지연)와 타임스탬프 기반 **Last-Writer-Wins(LWW)** 로 충돌을 해소합니다. 따라서 서로 다른 리전에서 동시 조건부 쓰기(`ConditionExpression`)를 수행하면 각 리전의 로컬 상태만 검사해 둘 다 통과될 수 있습니다. 엄격한 상호 배제가 필요한 재고 차감 쓰기만 파티션 키의 **Home Region(단일 쓰기 리전)** 으로 라우팅하면 단일 리전 내 ACID 트랜잭션과 조건부 쓰기가 100% 보장됩니다.\n"
            "• 오답 분석:\n"
            "  - A: DynamoDB의 `ConsistentRead=true`는 단일 리전 내 스토리지 노드 간 강한 일관성만 보장할 뿐, 글로벌 리전 간 복제는 항상 비동기 최종 일관성입니다.\n"
            "  - C: 이미 티켓 발권 완료 응답을 내보낸 뒤 사후 취소하는 것은 비즈니스 요건(이중 판매 원천 차단)을 위배합니다.\n"
            "  - D: DynamoDB Global Tables에는 리전 간 동기식 2PC 모드가 존재하지 않습니다."
        ),
        "DynamoDB Global Tables의 `ConsistentRead`는 '로컬 리전 내부'에서만 강력합니다. 다중 리전 전역 원자적 쓰기는 반드시 **단일 Home Region 쓰기 라우팅**으로 해결하세요."
    ),
    (
        3, 5, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] AWS Step Functions Standard Workflow 기반 분산 트랜잭션 Saga 패턴 및 콜백 대기",
        (
            "MSA 기반 여행 예약 플랫폼에서 항공권 예약(Service A), 호텔 예약(Service B), 결제 승인(Service C)이 각각 독립된 DynamoDB 및 Aurora DB를 사용합니다. "
            "항공권과 호텔 예약이 완료된 후 결제 승인 단계에서 카드 한도 초과로 실패하거나, 외부 항공사의 수동 발권 승인을 최대 24시간 기다려야 하는 경우가 있습니다. "
            "데이터 일관성을 위해 실패 시 앞선 항공·호텔 예약을 반드시 취소(보상 트랜잭션)해야 하며, 워크플로우 실행 상태가 감사 목적으로 정확히 1회(Exactly-Once) 추적되어야 합니다.\n\n"
            "이 분산 트랜잭션 오케스트레이션에 가장 적합한 AWS 아키텍처는 무엇입니까?"
        ),
        "Distributed Workflow Needs:\n1) Wait up to 24 hours for external airline callback\n2) Exactly-once workflow execution & full audit history\n3) Compensating rollback (Cancel Hotel -> Cancel Flight) on Payment failure",
        [
            {"label": "A", "text": "AWS Step Functions Express Workflow를 사용해 모든 단계를 병렬 호출하고 실패 시 DLQ로 보낸다."},
            {"label": "B", "text": "AWS Step Functions Standard Workflow로 Saga 패턴을 구현한다. 각 태스크에 Retry 및 Catch 분기를 두어 결제 실패 시 보상 트랜잭션(호텔 취소 -> 항공 취소)을 역순 실행하고, 외부 승인은 SQS/API와 `.waitForTaskToken` 콜백 패턴으로 최대 1년까지 대기한다."},
            {"label": "C", "text": "Lambda 함수 하나가 내부 while 루프로 sleep 하며 24시간 동안 외부 항공사 API를 폴링하고 직접 롤백한다."},
            {"label": "D", "text": "3개 마이크로서비스 DB를 XA 2-Phase Commit 분산 트랜잭션으로 묶어 동기 처리한다."}
        ],
        ["B"],
        "B) AWS Step Functions Standard Workflow로 Saga 패턴(Retry/Catch 보상 트랜잭션)과 `.waitForTaskToken` 콜백 대기 패턴을 구현한다.",
        "AWS Step Functions Standard Workflow, Saga Pattern, Compensating Transaction, waitForTaskToken, Callback",
        (
            "• 정답(B): **Step Functions Standard Workflow** 는 최대 **1년** 실행 지속 시간, **Exactly-Once** 실행 보장, 90일 실행 이력 감사를 제공합니다. `Try/Catch` 구조로 **Saga 보상 트랜잭션**(결제 실패 → 호텔 취소 → 항공 취소)을 선언적으로 오케스트레이션하고, `.waitForTaskToken` 을 사용하면 대기 시간 동안 컴퓨팅 요금 없이 외부 시스템의 `SendTaskSuccess` 콜백을 최대 24시간(또는 1년) 대기할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - A: Express Workflow는 최대 실행 시간이 **5분** 으로 제한되며 `.waitForTaskToken` 콜백 대기와 Exactly-Once 실행을 지원하지 않습니다.\n"
            "  - C: Lambda 최대 실행 시간은 15분이므로 24시간 대기가 불가능합니다.\n"
            "  - D: 서로 다른 클라우드 서비스 간 2PC는 가용성과 확장성을 심각하게 저하시키는 안티패턴입니다."
        ),
        "Step Functions Standard vs Express 결정 기준: >5분 대기·콜백(`.waitForTaskToken`)·Saga/결제(Exactly-Once) = **Standard**; 초고속 대량(<5분, 100K/s, At-least-once) = **Express**."
    ),
    (
        3, 6, 2, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] CloudFront + OAC(Origin Access Control) + Origin Failover 및 엣지 경량 헤더 처리",
        (
            "글로벌 뉴스 미디어 서비스가 SSE-KMS로 암호화된 비공개 S3 버킷(`us-east-1` 주 버킷, `eu-west-1` 복제 버킷)에서 정적 콘텐츠와 고화질 이미지를 서빙합니다. "
            "아키텍트는 두 가지를 달성해야 합니다:\n"
            "1) 주 S3 버킷에서 HTTP 500/503/403/404 오류 발생 시 CloudFront가 자동으로 `eu-west-1` S3 버킷으로 페일오버하며, S3 직접 URL 접근은 차단하되 SSE-KMS 복호화가 정상 작동할 것\n"
            "2) 매초 150,000건의 모든 HTTP 요청에서 `Accept-Language` 헤더를 검사해 URL 경로를 재작성(Rewrite)하고 보안 응답 헤더를 최소 비용과 1ms 미만 지연으로 주입할 것\n\n"
            "적용해야 할 최적의 CloudFront 기능 조합 2가지는 무엇입니까? (Select TWO.)"
        ),
        "CDN Requirements:\n- Private S3 buckets encrypted with SSE-KMS (Primary + Failover Region)\n- 150,000 RPS lightweight header/URL rewrite at <1ms latency and minimal cost",
        [
            {"label": "A", "text": "CloudFront Origin Access Identity(OAI)를 사용해 SSE-KMS 암호화된 두 S3 버킷에 접근하도록 구성한다."},
            {"label": "B", "text": "CloudFront Origin Access Control(OAC)을 두 S3 오리진에 연결하고 KMS 키 정책에서 CloudFront 서비스 주체(cloudfront.amazonaws.com)의 kms:Decrypt를 허용한 뒤, Origin Group을 생성해 장애 조치 상태 코드를 지정한다."},
            {"label": "C", "text": "CloudFront Functions를 Viewer Request / Viewer Response 이벤트에 연결해 URL 재작성과 보안 헤더 주입을 처리한다."},
            {"label": "D", "text": "Lambda@Edge를 Viewer Request와 Origin Response에 연결해 모든 150,000 RPS 요청마다 Node.js 런타임을 실행한다."},
            {"label": "E", "text": "S3 버킷을 퍼블릭 웹 호스팅 모드로 열고 CloudFront 커스텀 헤더에 암호를 담아 보낸다."}
        ],
        ["B", "C"],
        "B, C) CloudFront OAC + KMS 키 정책 허용 + Origin Group 페일오버 구성 / CloudFront Functions로 경량 URL 재작성 및 보안 헤더 주입",
        "CloudFront OAC vs OAI, Origin Group Failover, CloudFront Functions vs Lambda@Edge, SSE-KMS",
        (
            "• 정답(B, C):\n"
            "  - B: 구형 OAI(Origin Access Identity)는 **SSE-KMS 암호화 버킷 및 신규 옵트인 리전과 동적 PUT/POST 요청을 지원하지 않습니다.** 최신 **OAC(Origin Access Control)** 는 SigV4 서명을 지원하므로 SSE-KMS 버킷과 완벽히 호환되며, Origin Group 구성 시 주 버킷 장애(5xx/403/404)에서 보조 버킷으로 자동 전환됩니다.\n"
            "  - C: **CloudFront Functions** 는 엣지 로케이션에서 1ms 미만으로 실행되며 Lambda@Edge 대비 비용이 약 1/6 수준이므로 URL 재작성, 헤더 검증/주입에 최적입니다.\n"
            "• 오답 분석:\n"
            "  - A: OAI는 SSE-KMS로 암호화된 S3 객체를 복호화해 서빙할 수 없습니다.\n"
            "  - D: 단순 헤더/URL 조작에 Lambda@Edge를 150,000 RPS로 호출하면 비용과 지연이 크게 증가합니다(Lambda@Edge는 외부 네트워크 호출·S3/DynamoDB 조회·큰 페이로드 처리 시 사용).\n"
            "  - E: 퍼블릭 버킷 오픈은 비공개 보안 요건을 위반합니다."
        ),
        "S3 + CloudFront + **SSE-KMS** 가 함께 나오면 구형 `OAI`는 무조건 오답, **`OAC`** 가 정답! 경량 엣지 헤더/URL 처리(<1ms, 2MB 미만) = **CloudFront Functions**!"
    ),
    (
        3, 7, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] 멀티테넌트 정산 파이프라인에서 테넌트별 엄격한 순서 보장 및 배치 부분 실패 격리",
        (
            "B2B 핀테크 정산 엔진이 수천 개 가맹점(`merchant_id`)의 입출금 이벤트를 수신합니다. "
            "동일 가맹점 내 거래는 반드시 발생 순서대로 1회만 처리되어야 하지만, 가맹점 A의 한 거래가 일시적 DB 오류로 지연·실패하더라도 가맹점 B·C의 거래 처리는 멈추지 않아야 합니다. "
            "또한 AWS Lambda가 SQS에서 10건의 배치를 한꺼번에 가져왔을 때 1건만 실패하면 성공한 나머지 9건은 재처리되지 않도록 해야 합니다.\n\n"
            "가장 정확한 설계는 무엇입니까?"
        ),
        "Requirements:\n- Strict per-merchant ordering + Exactly-once deduplication\n- Head-of-line blocking isolation across different merchants\n- Partial batch failure reporting in Lambda",
        [
            {"label": "A", "text": "Standard SQS 큐를 사용하고 Lambda 동시성을 1로 제한한다."},
            {"label": "B", "text": "Amazon SQS FIFO 큐를 사용하되 모든 메시지에 동일한 MessageGroupId='global'을 설정한다."},
            {"label": "C", "text": "Amazon SQS FIFO 큐를 사용하고 MessageGroupId를 각 가맹점의 merchant_id로 지정하며, Lambda 이벤트 소스 매핑에 ReportBatchItemFailures를 활성화하고 MaxReceiveCount가 설정된 FIFO DLQ를 연결한다."},
            {"label": "D", "text": "SNS Standard 토픽에서 직접 Lambda를 비동기 호출해 순서를 맞춘다."}
        ],
        ["C"],
        "C) Amazon SQS FIFO 큐에서 MessageGroupId를 merchant_id로 지정하고, Lambda에 ReportBatchItemFailures를 활성화해 부분 실패만 재시도(및 FIFO DLQ 격리)한다.",
        "SQS FIFO, MessageGroupId, ReportBatchItemFailures, Partial Batch Response, Head-of-Line Isolation",
        (
            "• 정답(C): **SQS FIFO** 에서 `MessageGroupId` 를 테넌트(`merchant_id`)별로 다르게 부여하면, 동일 그룹 내부 메시지는 엄격한 선입선출이 보장되면서 서로 다른 그룹은 병렬로 독립 처리되어 가맹점 간 블로킹이 방지됩니다. Lambda 이벤트 소스 매핑의 **`ReportBatchItemFailures`** 를 활성화하면 실패한 메시지 ID만 큐로 반환하여 성공한 9건의 중복 처리를 막고, 반복 실패 시 FIFO DLQ로 격리합니다.\n"
            "• 오답 분석:\n"
            "  - A: Standard SQS는 순서를 보장하지 않으며 동시성 1은 전체 처리량을 파괴합니다.\n"
            "  - B: 모든 메시지에 동일한 `MessageGroupId` 를 쓰면 전체 큐가 단일 직렬 처리되어 한 가맹점의 장애가 모든 가맹점을 마비시킵니다.\n"
            "  - D: SNS Standard는 엄격한 순서를 보장하지 않습니다."
        ),
        "SQS FIFO 2대 핵심 키워드: 1) 병렬 확장 + 파티션 순서 = **`MessageGroupId` 세분화**, 2) 배치 중 실패 건만 재시도 = **`ReportBatchItemFailures`**!"
    ),
    (
        3, 8, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] 파트너 전용 Private API Gateway + 공개 mTLS/Usage Plan 분리 설계",
        (
            "헬스케어 API 플랫폼이 두 가지 유형의 클라이언트에 REST API를 제공합니다:\n"
            "1) 내부 VPC 및 AWS Direct Connect로 연결된 1급 병원 파트너: API 트래픽은 절대 퍼블릭 인터넷으로 라우팅되어서는 안 되며, 특정 Interface VPC Endpoint(`vpce-...`)에서 온 요청만 허용해야 합니다.\n"
            "2) 외부 SaaS 협력사: 퍼블릭 HTTPS로 접속하되 클라이언트 X.509 인증서 기반 상호 TLS(mTLS) 인증과 협력사별 초당 호출 한도(Rate Limiting) 및 월간 할당량(Quota)을 강제해야 합니다.\n\n"
            "두 요구사항을 가장 관리형(Managed) 방식으로 충족하는 API Gateway 구성은 무엇입니까?"
        ),
        "Client 1 (Private Partners via DX/VPC) -> Strictly private, no public DNS/IP\nClient 2 (External SaaS) -> Public HTTPS + mTLS + Per-partner throttling & monthly quota",
        [
            {"label": "A", "text": "단일 Edge-Optimized API Gateway를 생성하고 IP 화이트리스트 WAF만 연결한다."},
            {"label": "B", "text": "1급 병원용으로 Private REST API(execute-api Interface VPC Endpoint 연결 + Resource Policy aws:SourceVpce 조건)를 구성하고, 외부 SaaS용으로 Regional REST API(Custom Domain에 mTLS Truststore 적용 + API Key/Usage Plans 연결)를 별도 구성한다."},
            {"label": "C", "text": "모든 API를 EC2 위 Kong/Nginx로 직접 구축해 24시간 수동 운영한다."},
            {"label": "D", "text": "Private REST API에도 Edge-Optimized 엔드포인트와 mTLS를 동시에 적용한다."}
        ],
        ["B"],
        "B) 1급 병원용 Private REST API(VPC Endpoint + aws:SourceVpce Resource Policy)와 외부 SaaS용 Regional REST API(Custom Domain mTLS + Usage Plans)를 분리 구성한다.",
        "API Gateway Private REST API, aws:SourceVpce, Regional API Gateway mTLS, Usage Plans, API Keys",
        (
            "• 정답(B): **API Gateway Private REST API** 는 퍼블릭 인터넷에 노출되지 않고 오직 VPC Interface Endpoint(`execute-api`)를 통해서만 호출 가능하며 리소스 정책에 `aws:SourceVpce` 또는 `aws:SourceVpc` 를 강제할 수 있습니다. 반면 **mTLS(상호 TLS)** 와 **Usage Plans(요금제/할당량 제한)** 는 Regional(또는 Custom Domain) REST API에서 완전관리형으로 지원됩니다(참고: HTTP API는 Usage Plans/Private API 미지원).\n"
            "• 오답 분석:\n"
            "  - A: Edge-Optimized API는 항상 퍼블릭 엔드포인트로 노출되므로 사설 전용 요구사항을 위반합니다.\n"
            "  - C: 불필요한 자체 관리 오버헤드가 발생합니다.\n"
            "  - D: Private API에는 Edge-Optimized 및 퍼블릭 Custom Domain mTLS 패턴을 그대로 적용할 수 없습니다."
        ),
        "API Gateway 타입 구분: **Private REST API** = VPC/DX 전용(`aws:SourceVpce`), **REST API** = Usage Plans/API Keys/WAF/mTLS/요청 변환 지원, **HTTP API** = 저비용·초저지연 OIDC/JWT(Usage Plans/Private 미지원)."
    ),
    (
        3, 9, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] 버스트 성 서버리스 워크로드의 Aurora 커넥션 폭주(Connection Storm) 및 페일오버 지연 해결",
        (
            "수강 신청 및 이벤트 응모 시즌마다 AWS Lambda 동시 실행 수가 50에서 4,000으로 급증합니다. "
            "Lambda 함수들은 Amazon Aurora PostgreSQL에 연결해 트랜잭션을 처리하는데, 트래픽 급증 시 `FATAL: remaining connection slots are reserved` 오류가 속출하고 "
            "Aurora Writer 장애 조치 시 새 DB IP/DNS 캐시 반영 지연으로 60초 이상 애플리케이션 오류가 지속됩니다. "
            "데이터베이스는 반드시 관계형 ACID 트랜잭션을 유지해야 합니다.\n\n"
            "최소한의 코드 수정으로 DB 커넥션 고갈과 페일오버 중단을 해결하는 방법은 무엇입니까?"
        ),
        "Symptom: Lambda burst (50 -> 4,000 concurrent) exhausts Aurora max_connections & TLS/IAM auth CPU\nFailover delay: 60s+ client connection re-establishment lag",
        [
            {"label": "A", "text": "Lambda 함수 코드 내부에서 매 핸들러 호출마다 DB 연결을 열었다 닫도록 수정한다."},
            {"label": "B", "text": "Amazon RDS Proxy를 Aurora 앞에 배치하고 Lambda가 RDS Proxy 엔드포인트(IAM DB 인증 또는 Secrets Manager 연동)로 접속하게 한다."},
            {"label": "C", "text": "Aurora를 DynamoDB로 전면 재작성하여 커넥션 개념을 없앤다."},
            {"label": "D", "text": "Lambda 함수를 VPC 외부로 꺼내면 DB 커넥션 풀 제한이 사라진다."}
        ],
        ["B"],
        "B) Amazon RDS Proxy를 Aurora 앞에 배치하고 Lambda가 RDS Proxy 엔드포인트로 연결해 커넥션 멀티플렉싱 및 고속 페일오버를 구현한다.",
        "Amazon RDS Proxy, Connection Pooling, Multiplexing, Lambda Burst, Aurora Failover Reduction",
        (
            "• 정답(B): **Amazon RDS Proxy** 는 완전관리형 데이터베이스 프록시로서 수천 개의 Lambda 실행 환경에서 유입되는 연결을 소수의 물리적 DB 커넥션으로 풀링/멀티플렉싱하여 DB 메모리 및 CPU 고갈을 방지합니다. 또한 Aurora 장애 조치 시 프록시가 클라이언트 유휴 연결을 유지한 채 백그라운드에서 새 Writer로 즉시 전환하므로 **페일오버 복구 시간을 최대 66%까지 단축**합니다.\n"
            "• 오답 분석:\n"
            "  - A: 매 호출마다 TCP/TLS/인증 핸드셰이크를 반복하면 오히려 DB CPU가 100%에 도달해 더 빠르게 마비됩니다.\n"
            "  - C: 관계형 ACID 유지 및 최소 코드 수정 요건에 위배됩니다.\n"
            "  - D: VPC 외부 Lambda도 결국 DB 커넥션 슬롯을 점유하며 사설 서브넷 DB에는 접근조차 할 수 없습니다."
        ),
        "Lambda + RDS/Aurora + 동시성 폭발/커넥션 고갈/페일오버 지연 = **Amazon RDS Proxy**!"
    ),
    (
        3, 10, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] 가용 영역 회색 장애(AZ Gray Failure) 탐지 및 Route 53 ARC Zonal Shift 즉각 대피",
        (
            "미션 크리티컬 전자결제 API가 `ap-northeast-2` 의 3개 가용 영역(AZ-a, AZ-b, AZ-c)에 걸쳐 ALB + EKS 클러스터로 운영되고 있습니다. "
            "과거 특정 단일 AZ에서 네트워크 패킷 드롭이나 스토리지 지연 같은 '회색 장애(Gray Failure)'가 발생했을 때, 인스턴스 헬스 체크는 통과하면서도 "
            "실제 사용자 요청의 30%가 타임아웃되는 현상이 빚어졌고 수동으로 Auto Scaling/라우팅을 걷어내는 데 45분이 걸렸습니다.\n\n"
            "단일 AZ 장애 시 DNS TTL 대기나 복잡한 스크립트 없이 **수십 초 내에 해당 AZ를 트래픽 경로에서 안전하게 격리**하고 카오스 테스트로 사전 검증할 수 있는 아키텍처는 무엇입니까?"
        ),
        "Problem: Single AZ Gray Failure causes partial timeouts while EC2/Pod health checks stay green\nNeed: Rapid traffic evacuation from an impaired AZ + automated practice/chaos validation",
        [
            {"label": "A", "text": "Amazon Route 53 Application Recovery Controller(ARC)의 Zonal Shift(및 AWS 주도 Zonal Autoshift)를 ALB/NLB에 활성화하고, AWS Fault Injection Service(FIS)로 주기적 단일 AZ 격리 테스트를 수행한다."},
            {"label": "B", "text": "장애 발생 시마다 Terraform 코드를 수정해 해당 AZ 서브넷을 삭제하고 `terraform apply`를 실행한다."},
            {"label": "C", "text": "ALB의 Cross-Zone Load Balancing을 반드시 영구 비활성화하면 단일 AZ 장애 시 자동 복구된다."},
            {"label": "D", "text": "전체 리전을 다른 리전으로 통째로 페일오버하는 것 외에는 단일 AZ만 대피시킬 방법이 없다."}
        ],
        ["A"],
        "A) Route 53 Application Recovery Controller(ARC)의 Zonal Shift / Zonal Autoshift를 ALB/NLB에 활성화하고, AWS Fault Injection Service(FIS)로 AZ 격리 훈련을 정례화한다.",
        "Route 53 ARC Zonal Shift, Zonal Autoshift, Gray Failure, AWS Fault Injection Service (FIS), Multi-AZ Resilience",
        (
            "• 정답(A): **Route 53 ARC Zonal Shift** 를 사용하면 단일 API 호출이나 콘솔 클릭 한 번으로 ALB/NLB/EKS/ASG 등에서 특정 장애 AZ로 향하는 트래픽을 즉시 다른 정상 AZ로 우회(Evacuate)시킬 수 있습니다(**Zonal Autoshift** 활성화 시 AWS가 내부 텔레메트리로 회색 장애를 감지해 자동 대피 및 연습 실행 수행). 또한 **AWS FIS** 를 통해 실제 AZ Blackhole 장애를 안전하게 주입·검증할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - B: 실행 중인 트래픽에 대해 서브넷 삭제를 시도하면 ENI 종속성으로 인해 Terraform 실행이 실패하거나 더 큰 장애를 유발합니다.\n"
            "  - C: Cross-Zone Load Balancing 여부만으로는 해당 AZ의 DNS A 레코드 자체가 정상으로 반환되므로 유입 트래픽을 막지 못합니다.\n"
            "  - D: 단일 AZ 장애에 전체 리전을 옮기는 것은 과도한 리스크와 복구 복잡도를 동반합니다."
        ),
        "신규 SAP-C02 고난도 토픽: **AZ Gray Failure 대피 = Route 53 ARC Zonal Shift / Autoshift**, **카오스 엔지니어링 = AWS FIS**!"
    ),
    (
        3, 11, 2, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] AWS Nitro Enclaves 및 KMS Attestation 기반 기밀 컴퓨팅(Confidential Computing)",
        (
            "유전체 분석 헬스케어 기업이 민감한 환자 DNA 데이터와 독점 AI 진단 모델을 EC2 인스턴스에서 처리해야 합니다. "
            "규제 감사는 매우 엄격하여, **EC2 인스턴스의 OS 관리자(`root`), SSH/SSM 세션, 심지어 디버거가 인스턴스 메모리를 덤프하더라도** "
            "복호화된 환자 데이터와 평문 데이터 암호화 키(DEK)를 절대 볼 수 없도록 하드웨어 수준으로 격리되어야 합니다. "
            "검증된 암호화 바이너리 이미지가 실행될 때만 KMS가 키를 복호화해 주어야 합니다.\n\n"
            "이를 구현하기 위한 핵심 기술 조합 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Confidential Computing Mandate:\n- Even EC2 root user/admins must NOT access plaintext PII/DEK in RAM\n- Cryptographic verification of enclave binary before KMS releases keys",
        [
            {"label": "A", "text": "EC2 인스턴스에서 AWS Nitro Enclaves를 활성화하여 별도의 네트워크·스토리지가 없는 격리된 메모리 공간(Enclave)에서 복호화 및 추론 연산을 수행한다."},
            {"label": "B", "text": "KMS 키 정책에 kms:RecipientAttestation:PCR0 조건을 추가하여 AWS Nitro Hypervisor가 서명한 특정 Enclave 이미지 해시(PCR0)의 요청에만 키 복호화를 허용한다."},
            {"label": "C", "text": "EC2 인스턴스 볼륨에 EBS 암호화만 활성화하면 메모리 덤프에서도 평문 데이터가 암호화되어 노출되지 않는다."},
            {"label": "D", "text": "데이터를 S3에 저장할 때 SSE-S3를 활성화하고 EC2 루트 사용자의 sudo 권한을 /etc/sudoers에서 제거한다."},
            {"label": "E", "text": "Secrets Manager에서 평문 키를 받아 EC2 환경 변수(ENV)에 저장한 뒤 애플리케이션을 실행한다."}
        ],
        ["A", "B"],
        "A, B) AWS Nitro Enclaves로 격리된 메모리 컴퓨팅 수행 / KMS 키 정책에 kms:RecipientAttestation:PCR0 조건 적용",
        "AWS Nitro Enclaves, Confidential Computing, KMS RecipientAttestation, PCR0, Memory Isolation",
        (
            "• 정답(A, B):\n"
            "  - A: **AWS Nitro Enclaves** 는 부모 EC2 인스턴스에서 CPU와 메모리를 떼어내어 영구 스토리지·외부 네트워크·대화형 쉘이 전혀 없는 독립 격리 환경(오직 로컬 `vsock` 으로만 통신)을 생성하므로 호스트 `root` 사용자조차 내부 메모리를 읽을 수 없습니다.\n"
            "  - B: Nitro Hypervisor는 Enclave 이미지의 암호학적 측정값(PCR0 등)을 서명해 제공하며, KMS 키 정책의 **`kms:RecipientAttestation:PCR0`** 조건은 변조되지 않은 정식 Enclave만이 KMS 키를 복호화(`Recipient` 공개키로 재암호화 반환)할 수 있게 보장합니다.\n"
            "• 오답 분석:\n"
            "  - C: EBS 암호화는 디스크(At-rest)만 보호할 뿐 실행 중인 OS 메모리(In-use) 보호 기능이 아닙니다.\n"
            "  - D, E: 환경 변수나 파일 권한 설정은 OS 관리자/커널 수준 메모리 접근을 막을 수 없습니다."
        ),
        "메모리 상(In-use) 데이터 보호 및 `root` 사용자로부터의 키 격리 = **AWS Nitro Enclaves + KMS `RecipientAttestation`**!"
    ),
    (
        3, 12, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] 50만 대 커넥티드 카 텔레메트리 실시간 이상 탐지 및 S3 Apache Iceberg 레이크하우스 적재",
        (
            "자동차 제조사가 50만 대의 커넥티드 카에서 매초 MQTT 프로토콜로 주행·배터리 텔레메트리를 수집하는 신규 플랫폼을 구축합니다. "
            "요구사항은 두 가지입니다:\n"
            "1) 배터리 과열 등 치명적 이상 패턴은 발생 후 5초 이내에 연속 슬라이딩 윈도우(Sliding Window) 분석으로 탐지하여 긴급 알림을 발송할 것\n"
            "2) 수집된 모든 원시 데이터는 Amazon S3 기반 데이터 레이크에 저장하되, 법적 삭제 요청(GDPR Right to be Forgotten)과 스키마 진화를 지원하기 위해 S3 위에서 직접 **ACID UPDATE/DELETE** 가 가능한 개방형 테이블 포맷을 사용할 것\n\n"
            "서버 관리 부담을 최소화하면서 두 요건을 충족하는 아키텍처는 무엇입니까?"
        ),
        "Scale: 500,000 vehicles via MQTT\nPath 1: <5s sliding window anomaly detection\nPath 2: S3 Data Lake with ACID row-level UPDATE/DELETE & schema evolution",
        [
            {"label": "A", "text": "AWS IoT Core로 MQTT 메시지를 수신해 Kinesis Data Streams로 전달한 뒤, (1) Amazon Managed Service for Apache Flink로 실시간 슬라이딩 윈도우 이상 탐지 알림을 수행하고, (2) Amazon Data Firehose를 통해 S3의 Apache Iceberg 테이블에 ACID 적재하여 Athena로 쿼리한다."},
            {"label": "B", "text": "EC2 Auto Scaling 위에 Mosquitto MQTT 브로커 100대를 직접 구축하고, 100만 개 JSON 파일을 S3에 저장한 뒤 GDPR 삭제 시 매번 전체 50 TB를 다시 써서 덮어쓴다."},
            {"label": "C", "text": "모든 50만 대 차량이 Amazon RDS MySQL 단일 Writer에 직접 TCP JDBC 연결을 맺어 INSERT 한다."},
            {"label": "D", "text": "S3 Standard 버킷에 CSV를 저장하고 AWS Batch가 매 1분마다 전체 CSV를 스캔해 이상을 탐지한다."}
        ],
        ["A"],
        "A) AWS IoT Core -> Kinesis Data Streams -> (1) Managed Service for Apache Flink (실시간 윈도우 이상 탐지) + (2) Amazon Data Firehose -> S3 Apache Iceberg 테이블(ACID 업데이트/삭제)",
        "AWS IoT Core, Managed Service for Apache Flink, Amazon Data Firehose, Apache Iceberg on S3, ACID Lakehouse",
        (
            "• 정답(A): **AWS IoT Core** 는 수백만 대의 MQTT 디바이스 연결을 서버리스로 처리합니다. 실시간 연속 시간 창(Sliding/Tumbling Window) 상태 기반 이상 탐지는 **Managed Service for Apache Flink**(구 Kinesis Data Analytics)가 Sub-second~수 초 지연으로 처리하며, **Apache Iceberg**(Firehose, Glue, Athena, EMR 네이티브 지원)는 S3 객체 스토리지 위에서 스냅샷 격리, 스키마 진화, 행 수준 ACID `UPDATE`/`DELETE`(GDPR 대응)를 완벽히 지원합니다.\n"
            "• 오답 분석:\n"
            "  - B: 자체 MQTT 클러스터 운영과 원시 JSON 전체 재작성은 막대한 비용·운영 오버헤드를 초래합니다.\n"
            "  - C: 50만 개의 동시 커넥션을 단일 RDBMS가 감당할 수 없습니다.\n"
            "  - D: 1분 주기 배치 스캔은 5초 이내 탐지 SLA를 충족하지 못합니다."
        ),
        "S3 위에서 행 수준 `UPDATE/DELETE` 및 `Time Travel` = **Apache Iceberg / Delta Lake / Apache Hudi**; 실시간 5초 미만 스트림 윈도우 분석 = **Managed Service for Apache Flink**!"
    ),
    (
        3, 13, 2, 2, 3,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] S3 Multi-Region Access Points + 양방향 CRR + S3 Replication Time Control(RTC)",
        (
            "글로벌 영상 편집 협업 플랫폼이 북미(`us-east-1`)와 유럽(`eu-west-1`) 사용자에게 단일 글로벌 S3 엔드포인트를 제공하려 합니다. "
            "사용자가 대용량 미디어 파일을 업로드하거나 다운로드할 때 네트워크 지연이 가장 짧은 리전의 S3 버킷으로 자동 라우팅되어야 하며, "
            "두 리전 버킷 간에는 파일 생성과 삭제 마커가 양방향으로 동기화되되 규제 계약상 **99.99%의 객체가 15분 이내에 복제 완료(SLA)** 되어야 합니다.\n\n"
            "이 글로벌 스토리지 아키텍처를 구현하기 위해 반드시 구성해야 할 3가지 요소는 무엇입니까? (Select THREE.)"
        ),
        "Global S3 Storage Goals:\n- Single global endpoint routing to lowest-latency Region\n- Bi-directional replication between us-east-1 and eu-west-1\n- SLA-backed <=15 min replication time",
        [
            {"label": "A", "text": "S3 Multi-Region Access Point(MRAP)를 생성하고 두 리전 버킷을 연결하여 단일 글로벌 엔드포인트(`.accesspoint.s3-global.amazonaws.com`)로 트래픽을 라우팅한다."},
            {"label": "B", "text": "두 리전 S3 버킷 모두에 버전 관리(Versioning)를 활성화하고 양방향 Cross-Region Replication(CRR) 규칙(Replica Modification Sync 포함)을 구성한다."},
            {"label": "C", "text": "복제 규칙에 S3 Replication Time Control(S3 RTC)을 활성화하여 15분 이내 복제 SLA와 복제 지연 모니터링 지표를 확보한다."},
            {"label": "D", "text": "S3 Transfer Acceleration만 양쪽 버킷에 켜면 두 리전 간 객체 데이터가 자동으로 양방향 복제된다."},
            {"label": "E", "text": "Route 53에 두 S3 버킷의 IP 주소를 정적 A 레코드로 등록한다."},
            {"label": "F", "text": "S3 버전 관리를 반드시 비활성화해야 복제 루프가 발생하지 않는다."}
        ],
        ["A", "B", "C"],
        "A, B, C) S3 Multi-Region Access Point(MRAP) 구성 / 양방향 CRR 및 버전 관리 활성화 / S3 Replication Time Control(RTC) 15분 SLA 적용",
        "S3 Multi-Region Access Point (MRAP), S3 Bi-directional CRR, S3 Replication Time Control (S3 RTC), Versioning",
        (
            "• 정답(A, B, C):\n"
            "  - A: **S3 Multi-Region Access Point(MRAP)** 는 AWS Global Accelerator 백본 위에서 작동하는 단일 글로벌 S3 엔드포인트를 제공하며, 가장 가까운 정상 리전의 버킷으로 자동 라우팅(및 장애 시 제어 전환)합니다.\n"
            "  - B: S3 CRR의 필수 전제 조건은 양쪽 버킷의 **Versioning 활성화** 이며, 양방향 CRR 시 무한 복제 루프를 막는 Replica Modification Sync와 내부 메타데이터가 자동 관리됩니다.\n"
            "  - C: 일반 CRR은 복제 시간을 보장하지 않지만, **S3 RTC** 를 활성화하면 15분 이내 99.99% 복제 완료 SLA와 CloudWatch 복제 메트릭이 제공됩니다.\n"
            "• 오답 분석:\n"
            "  - D: S3 Transfer Acceleration은 클라이언트→단일 버킷 업로드 경로를 엣지로 가속할 뿐 리전 간 버킷 복제 기능이 아닙니다.\n"
            "  - E: S3 버킷은 고정 IP가 없어 정적 A 레코드 등록이 불가합니다.\n"
            "  - F: 버전 관리 없이는 S3 CRR을 설정할 수 없습니다."
        ),
        "S3 글로벌 엔드포인트 = **MRAP**, 15분 복제 SLA = **S3 RTC**, CRR 전제조건 = **Versioning ON**!"
    ),
    (
        3, 14, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] 프로덕션 Amazon EKS 보안 강화: Pod 단위 IAM 격리, IMDSv2 Hop Limit 및 Karpenter",
        (
            "핀테크 기업의 보안팀이 Amazon EKS 클러스터를 감사한 결과 심각한 권한 상승 취약점을 발견했습니다: "
            "현재 워커 노드의 EC2 Instance Profile에 과도한 S3/DynamoDB 권한이 부여되어 있어, 침해된 애플리케이션 Pod가 노드의 EC2 메타데이터 서비스(`169.254.169.254`)를 호출해 "
            "다른 서비스의 자격 증명을 탈취할 수 있었습니다. 또한 트래픽 급증 시 기존의 정적 Node Group이 워크로드 스펙에 맞는 노드를 제때 프로비저닝하지 못합니다.\n\n"
            "최신 AWS EKS 모범 사례에 부합하는 보안·확장성 개선 방안은 무엇입니까?"
        ),
        "EKS Hardening Goals:\n1) Eliminate EC2 Node Role credential theft via 169.254.169.254 from Pods\n2) Fine-grained least-privilege AWS permissions per Pod\n3) Fast, right-sized dynamic node provisioning",
        [
            {"label": "A", "text": "워커 노드의 Instance Metadata Service를 IMDSv2로 강제하고 HttpPutResponseHopLimit을 1로 설정해 Pod에서의 노드 메타데이터 접근을 차단한 뒤, EKS Pod Identity(또는 IRSA)로 서비스 계정별 최소 권한 IAM 역할을 부여하고 Karpenter로 노드를 동적 프로비저닝한다."},
            {"label": "B", "text": "모든 컨테이너 이미지 내부에 IAM 사용자의 영구 Access Key/Secret Key를 환경 변수로 하드코딩한다."},
            {"label": "C", "text": "IMDSv1을 유지한 채 Hop Limit을 3으로 올려 Pod와 사이드카가 노드 역할을 편리하게 공유하게 한다."},
            {"label": "D", "text": "EKS 클러스터 내 모든 Pod에 privileged: true 보안 컨텍스트를 부여해 iptables를 각자 수정하게 한다."}
        ],
        ["A"],
        "A) 워커 노드에 IMDSv2 + HttpPutResponseHopLimit=1을 적용해 Pod의 메타데이터 탈취를 차단하고, EKS Pod Identity(또는 IRSA)로 Pod별 최소 권한을 부여하며, Karpenter로 적정 노드를 신속히 프로비저닝한다.",
        "EKS Pod Identity, IRSA, IMDSv2 Hop Limit 1, Karpenter, Least Privilege, Container Security",
        (
            "• 정답(A): 컨테이너는 브리지 네트워크를 거쳐 한 번 더 패킷을 포워딩(TTL 홉 감소)하므로, EC2 인스턴스의 **`HttpPutResponseHopLimit` 을 `1`로 설정하고 IMDSv2를 강제** 하면 워커 노드 자체는 메타데이터를 읽을 수 있지만 내부 Pod는 `169.254.169.254` 로부터 노드 역할 자격 증명을 탈취할 수 없습니다. 각 Pod는 **EKS Pod Identity** 또는 **IRSA** 를 통해 자기에게만 허용된 IAM Role을 발급받으며, **Karpenter** 는 Pending Pod 요구 스펙에 딱 맞는 EC2/Spot 노드를 수십 초 내 직접 기동합니다.\n"
            "• 오답 분석:\n"
            "  - B: 이미지 내 장기 키 하드코딩은 심각한 자격 증명 유출 위험입니다.\n"
            "  - C: Hop Limit 3은 Pod가 노드 메타데이터에 접근하는 경로를 그대로 열어둡니다.\n"
            "  - D: `privileged: true` 는 컨테이너 탈출(Container Escape)을 허용하는 위험한 설정입니다."
        ),
        "EKS 보안 암기: **`IMDSv2` + `HopLimit=1`** = Pod가 EC2 노드 IAM 역할 탈취 차단, **`EKS Pod Identity / IRSA`** = Pod별 최소 권한, **`Karpenter`** = 초고속 노드 빈패킹!"
    ),
    (
        3, 15, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] Step Functions Distributed Map을 활용한 1,000만 건 S3 대용량 병렬 배치 처리",
        (
            "금융 데이터 팀이 매일 밤 Amazon S3 버킷에 적재된 1,000만 개의 거래 정산 CSV 파일을 검증·변환하여 요약 리포트를 S3에 출력해야 합니다. "
            "기존 단일 EC2 Python 스크립트는 처리에 14시간이 걸렸으며, 일반 Step Functions Map 상태는 40개 동시 실행 및 25,000개 실행 이력 이벤트 제한 때문에 "
            "1,000만 개 항목을 직접 순회할 수 없었습니다.\n\n"
            "서버를 프로비저닝하지 않고 30분 이내에 1,000만 개의 S3 객체를 대규모 병렬 처리하며 실행 결과를 S3로 집계하는 최적의 설계는 무엇입니까?"
        ),
        "Batch Requirement:\n- 10,000,000 CSV objects in S3\n- Serverless processing within <30 minutes\n- Overcomes Standard Step Functions 25,000 event history & 40 inline concurrency limits",
        [
            {"label": "A", "text": "Step Functions Standard Workflow의 기본 Inline Map 상태 하나에 1,000만 개 키 배열을 그대로 입력으로 넣는다."},
            {"label": "B", "text": "AWS Step Functions Distributed Map 모드를 사용해 S3 버킷/Inventory 매니페스트에서 1,000만 개 객체를 직접 읽어 마이크로 배치(ItemBatcher) 단위로 묶고, 최대 10,000개의 병렬 Child Express Workflow(또는 Lambda)로 실행한 뒤 ResultWriter로 결과를 S3에 저장한다."},
            {"label": "C", "text": "단일 AWS Lambda 함수가 S3 ListObjectsV2로 1,000만 개를 15분 내에 모두 다운로드·처리하도록 메모리를 10 GB로 올린다."},
            {"label": "D", "text": "1,000만 개의 SQS 메시지를 수동 생성하고 t3.micro EC2 1대가 순차 처리한다."}
        ],
        ["B"],
        "B) AWS Step Functions Distributed Map 모드로 S3 매니페스트를 읽고 ItemBatcher + Child Express Workflows(최대 10,000 병렬) + ResultWriter를 구성한다.",
        "Step Functions Distributed Map, ItemBatcher, ResultWriter, High Concurrency Batch, S3 Manifest",
        (
            "• 정답(B): **Step Functions Distributed Map** 은 S3 객체 목록이나 S3 Inventory 매니페스트를 직접 소스로 받아 수천만 개 항목을 순회하며, **최대 10,000개의 동시 실행** 을 지원합니다. `ItemBatcher` 로 수백 개 파일씩 묶어 Child **Express Workflow** 나 Lambda를 실행하면 25,000개 실행 이력 제한을 우회하면서 비용을 절감하고, `ResultWriter` 가 집계 결과를 자동으로 S3에 기록합니다.\n"
            "• 오답 분석:\n"
            "  - A: Inline Map은 페이로드 256KB 및 25,000개 상태 전이 이력, 최대 동시성 40 제한에 즉시 걸립니다.\n"
            "  - C: 단일 Lambda(최대 15분)로는 1,000만 개 파일 순차/로컬 병렬 처리를 완료할 수 없습니다.\n"
            "  - D: EC2 1대 순차 처리는 30분 SLA에 절대 도달할 수 없습니다."
        ),
        "S3의 수백만~수천만 개 객체 서버리스 병렬 처리 = **Step Functions Distributed Map + ItemBatcher + ResultWriter**!"
    ),
    (
        3, 16, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2] Cognito User/Identity Pools + Amazon Verified Permissions(Cedar) 세밀한 멀티테넌트 인가",
        (
            "엔터프라이즈 문서 협업 SaaS가 고객사(Tenant)별 SAML/OIDC 기업 로그인을 연동하고, 두 가지 권한 요건을 구현하려고 합니다:\n"
            "1) 브라우저 클라이언트가 백엔드 서버를 거치지 않고 S3 버킷 내 본인 테넌트 프리픽스(`s3://docs-bucket/${tenant_id}/${user_sub}/*`)로 대용량 파일을 직접 업로드할 수 있도록 임시 AWS 자격 증명을 발급할 것\n"
            "2) 애플리케이션 내부의 세밀한 인가 규칙(예: '동일 부서 소속이고 문서가 Draft 상태이며 작성자 본인일 때만 Edit 허용')을 애플리케이션 코드 하드코딩 없이 외부 정책 엔진으로 분리·감사할 것\n\n"
            "이 요구사항을 충족하는 관리형 AWS 아키텍처는 무엇입니까?"
        ),
        "AuthN + AuthZ Goals:\n1) Enterprise SAML/OIDC federation + Scoped temporary STS credentials for direct S3 browser upload\n2) Externalized fine-grained policy engine (RBAC + ABAC) decoupled from app code",
        [
            {"label": "A", "text": "Amazon Cognito User Pools로 SAML/OIDC 인증을 통합하고, Cognito Identity Pools로 S3 프리픽스가 제한된 임시 STS 자격 증명을 발급하며, 애플리케이션 인가는 Cedar 언어 기반 Amazon Verified Permissions로 외부화한다."},
            {"label": "B", "text": "브라우저에 공용 IAM User Access Key를 내려주고 JavaScript `if` 문으로만 권한을 검사한다."},
            {"label": "C", "text": "모든 고객사 사용자마다 AWS 계정의 IAM User를 생성하고 100만 개의 IAM 인라인 정책을 붙인다."},
            {"label": "D", "text": "S3 버킷을 퍼블릭 쓰기 허용으로 설정하고 Lambda Authorizer에서 파일 바이너리까지 중계한다."}
        ],
        ["A"],
        "A) Cognito User Pools(연합 인증) + Cognito Identity Pools(테넌트/사용자별 STS S3 자격 증명) + Amazon Verified Permissions(Cedar 기반 세밀한 인가)를 결합한다.",
        "Cognito User Pools, Cognito Identity Pools, STS Scoped Credentials, Amazon Verified Permissions, Cedar",
        (
            "• 정답(A): **Cognito User Pools** 는 기업 SAML/OIDC 연합 인증 및 JWT 발급을 담당하고, **Cognito Identity Pools** 는 해당 JWT를 교환해 S3 내 특정 사용자/테넌트 프리픽스(`${aws:PrincipalTag/tenant_id}`)에만 접근 가능한 임시 STS 자격 증명을 발급합니다. 비즈니스 로직 수준의 세밀한 RBAC/ABAC 인가(`Principal`, `Action`, `Resource`, `Context`)는 **Amazon Verified Permissions(Cedar 정책 언어)** 로 분리하여 중앙 감사·실시간 정책 변경이 가능합니다.\n"
            "• 오답 분석:\n"
            "  - B: 브라우저에 장기 IAM 키 노출 및 클라이언트 측 인가 검증은 치명적 보안 취약점입니다.\n"
            "  - C: IAM User는 계정당 5,000명 한도가 있으며 B2B/B2C 최종 사용자 인증용이 아닙니다.\n"
            "  - D: Lambda Authorizer는 API 요청(6MB/10MB 페이로드 등) 인가용이며 대용량 파일 바디 중계 시 병목·타임아웃이 발생합니다."
        ),
        "인증/인가 역할 분담: 앱 사용자 인증 = **Cognito User Pools**, AWS 리소스(S3/DDB) 직접 접근용 STS 발급 = **Cognito Identity Pools**, 비즈니스 세밀한 인가(Cedar) = **Amazon Verified Permissions**!"
    ),
]
