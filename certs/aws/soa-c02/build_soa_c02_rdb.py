# -*- coding: utf-8 -*-
"""Build AWS Certified SysOps Administrator - Associate (SOA-C02 / C03) SQLite RDB, SQL Dump, and JSON Export."""
import os
import json
import sqlite3
from collections import Counter

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(PROJECT_DIR, "data")
os.makedirs(DATA_DIR, exist_ok=True)

DB_PATH = os.path.join(DATA_DIR, "soa_c02_exam.db")
SQL_DUMP_PATH = os.path.join(DATA_DIR, "schema_and_data.sql")
JSON_EXPORT_PATH = os.path.join(DATA_DIR, "soa_c02_rdb_export.json")

# 1. Rounds Metadata (Official PDF + Exam Guide Core + MIT Open Bank Set A & B)
EXAM_ROUNDS = [
    (1, "OFFICIAL_SAMPLE", "Round 1 · AWS 공식 샘플 문항 (Official PDF 10선)", 2023, "AWS Training & Certification",
     "SOA-C02 Official Sample Questions PDF 수록 객관식/복수선택 10문항 전수 (CloudWatch, Memcached, Lambda VPC, EFS, StackSets, AWS Backup, CloudTrail, DLM, Cost Tags)"),
    (2, "EXAM_GUIDE_CORE", "Round 2 · SOA-C02/C03 공식 Exam Guide 핵심문제 (30선)", 2026, "AWS Exam Guide",
     "6대 공식 도메인 비중(20/16/18/16/18/12%) 기반 한국어 실무 시나리오 30선 (Permission Boundaries, NACL vs SG, Savings Plans, Compute Optimizer, Vault Lock, OAM)"),
    (3, "MIT_BANK_SET_A", "Round 3 · MIT 오픈 뱅크 Set A: 모니터링·고가용성·자동화 (30선)", 2026, "MIT Open Bank",
     "MIT 라이선스 공개 문제은행(zghanw/aws-cloudops-engineer-associate) 선별 30선 — CloudWatch Agent/Logs, Auto Scaling, RDS, Route 53, CloudFormation, SSM"),
    (4, "MIT_BANK_SET_B", "Round 4 · MIT 오픈 뱅크 Set B: 보안·네트워킹·최적화 (30선)", 2026, "MIT Open Bank",
     "MIT 라이선스 공개 문제은행(zghanw/aws-cloudops-engineer-associate) 선별 30선 — IAM/KMS/S3/ACM, VPC/PrivateLink/TGW/CloudFront, gp3/Compute Optimizer/RDS Proxy"),
]

# 2. Official 6 Domains (SOA-C02 Exam Guide Weights)
CATEGORIES_DOMAIN = [
    (1, "MON_LOG", "Domain 1. 모니터링·로깅 및 교정 (Monitoring, Logging & Remediation)", 20,
     "CloudWatch Alarms/Metrics/Logs/Agent/Synthetics, EventBridge, AWS Config Auto-Remediation, CloudTrail Insights/Data Events"),
    (2, "REL_BC", "Domain 2. 안정성 및 비즈니스 연속성 (Reliability & Business Continuity)", 16,
     "EC2 Auto Scaling(Target Tracking, Lifecycle Hooks, Warm Pools), RDS Multi-AZ vs Read Replica, AWS Backup/DLM, Route 53 Failover"),
    (3, "DEP_AUTO", "Domain 3. 배포·프로비저닝 및 자동화 (Deployment, Provisioning & Automation)", 18,
     "CloudFormation(StackSets, Drift, Change Sets, Stack Policy), Systems Manager(Patch Manager, Run Command, State Manager), Image Builder, Elastic Beanstalk"),
    (4, "SEC_COMP", "Domain 4. 보안 및 규정 준수 (Security & Compliance)", 16,
     "IAM Roles & Permission Boundaries, Access Analyzer, GuardDuty, Inspector, KMS Key Policy, S3 Block Public Access, Secrets Manager vs Parameter Store"),
    (5, "NET_CDN", "Domain 5. 네트워킹 및 콘텐츠 전송 (Networking & Content Delivery)", 18,
     "VPC Peering vs Transit Gateway, NAT Gateway, VPC Endpoints/PrivateLink, VPC Flow Logs, NACL vs Security Group, CloudFront OAC/Failover"),
    (6, "COST_PERF", "Domain 6. 비용 및 성능 최적화 (Cost & Performance Optimization)", 12,
     "Compute Optimizer, Savings Plans vs RI, Cost Allocation Tags, S3 Intelligent-Tiering, EBS gp2→gp3, ElastiCache Scaling, RDS Proxy"),
]

# 3. Question Types
CATEGORIES_QTYPE = [
    (1, "SINGLE", "객관식 단일선택 (Multiple Choice)", "4지선다 중 가장 적합한 정답 1개 선택"),
    (2, "MULTI", "객관식 복수선택 (Multiple Response)", "5지선다 중 조건을 충족하는 정답 2개(Select TWO) 선택"),
]

# 4. 100 Verified Questions Dataset
RAW_QUESTIONS = [
  {
    "round_id": 1,
    "question_no": 1,
    "domain_id": 1,
    "select_count": 1,
    "title": "[공식샘플 #1] EC2 CPU 100% 장애 모니터링 — CloudWatch Alarm 구성",
    "question_text": "A company hosts a web application on an Amazon EC2 instance. Users report that the web application is occasionally unresponsive. Amazon CloudWatch metrics indicate that the CPU utilization is 100% during these times. A SysOps administrator must implement a solution to monitor for this issue.\n\nWhich solution will meet this requirement?",
    "options": [
      "Create a CloudWatch alarm that monitors AWS CloudTrail events for the EC2 instance.",
      "Create a CloudWatch alarm that monitors CloudWatch metrics for EC2 instance CPU utilization.",
      "Create an Amazon Simple Notification Service (Amazon SNS) topic to monitor CloudWatch metrics for EC2 instance CPU utilization.",
      "Create a recurring assessment check on the EC2 instance by using Amazon Inspector to detect deviations in CPU utilization."
    ],
    "correct_indices": [
      1
    ],
    "core_keywords": "CloudWatch Alarm, CPUUtilization, EC2 모니터링, SNS 알림",
    "explanation": "정답: B\n• Amazon EC2는 하이퍼바이저 수준의 기본 메트릭(CPUUtilization 등)을 CloudWatch로 자동 전송합니다. CPU 사용률 임계치 초과를 감시하려면 CloudWatch 메트릭 기반의 CloudWatch Alarm을 생성해야 합니다.\n• 오답 분석: (A) CloudTrail은 API 호출 감사 로그이지 CPU 성능 메트릭을 모니터링하지 않습니다. (C) SNS는 알림 전송 채널일 뿐 메트릭 감시 주체가 아닙니다. (D) Amazon Inspector는 CVE 취약점·네트워크 도달 가능성 평가 도구입니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q1 — 기본 메트릭(CPU/네트워크/디스크) vs 에이전트 메트릭(메모리/디스크사용률) 구분 필수"
  },
  {
    "round_id": 1,
    "question_no": 2,
    "domain_id": 6,
    "select_count": 2,
    "title": "[공식샘플 #2] ElastiCache for Memcached Evictions 급증 대응 (2개 선택)",
    "question_text": "A company has an application that uses Amazon ElastiCache for Memcached to cache query responses to improve latency. However, the application's users are reporting slow response times. A SysOps administrator notices that the Amazon CloudWatch metrics for Memcached evictions are high.\n\nWhich actions should the SysOps administrator take to fix this issue? (Select TWO.)",
    "options": [
      "Flush the contents of ElastiCache for Memcached.",
      "Increase the ConnectionOverhead parameter value.",
      "Increase the number of nodes in the cluster.",
      "Increase the size of the nodes in the cluster.",
      "Decrease the number of nodes in the cluster."
    ],
    "correct_indices": [
      2,
      3
    ],
    "core_keywords": "ElastiCache, Memcached, Evictions, Scale Out, Scale Up",
    "explanation": "정답: C, D\n• Memcached의 Evictions 지표는 캐시 메모리 부족으로 인해 만료되지 않은(non-expired) 항목이 밀려나는 횟수를 뜻합니다. 메모리 용량을 늘리기 위해 노드 수를 추가(Scale Out, C)하거나 더 큰 메모리의 노드 타입으로 변경(Scale Up, D)해야 합니다.\n• 오답 분석: (A) 캐시 Flush는 모든 캐시를 비워 일시적으로 DB 부하만 폭증시킵니다. (B) ConnectionOverhead는 연결 오버헤드 예약 파라미터로 메모리 확장 해결책이 아닙니다. (E) 노드 축소는 Evictions를 악화시킵니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q2 — CloudWatch ElastiCache 핵심 지표(Evictions, CacheHits, CacheMisses)"
  },
  {
    "round_id": 1,
    "question_no": 3,
    "domain_id": 5,
    "select_count": 1,
    "title": "[공식샘플 #3] VPC 연결 Lambda 함수의 외부 인터넷(서드파티 API) 접근",
    "question_text": "A company needs to ensure that an AWS Lambda function can access resources in a VPC in the company's account. The Lambda function requires access to third-party APIs that can be accessed only over the internet.\n\nWhich action should a SysOps administrator take to meet these requirements?",
    "options": [
      "Attach an Elastic IP address to the Lambda function and configure a route to the internet gateway of the VPC.",
      "Connect the Lambda function to a private subnet that has a route to the virtual private gateway of the VPC.",
      "Connect the Lambda function to a public subnet that has a route to the internet gateway of the VPC.",
      "Connect the Lambda function to a private subnet that has a route to a NAT gateway deployed in a public subnet of the VPC."
    ],
    "correct_indices": [
      3
    ],
    "core_keywords": "Lambda in VPC, Private Subnet, NAT Gateway, Outbound Internet",
    "explanation": "정답: D\n• Lambda 함수를 고객 VPC에 연결하면 ENI가 생성되며 기본적으로 퍼블릭 IP가 할당되지 않습니다. 따라서 퍼블릭 서브넷에 연결하더라도 IGW를 통해 직접 인터넷에 나갈 수 없습니다. 반드시 프라이빗 서브넷에 연결하고 퍼블릭 서브넷의 NAT Gateway로 0.0.0.0/0 라우팅을 구성해야 합니다.\n• 오답 분석: (A) Lambda ENI에 직접 EIP를 연결할 수 없습니다. (B) VGW는 온프레미스 VPN/DX용입니다. (C) 퍼블릭 서브넷의 Lambda는 퍼블릭 IP가 없어 IGW 통신이 불가합니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q3 — VPC 내부 Lambda의 인터넷 아웃바운드 = Private Subnet + NAT Gateway 고정 패턴"
  },
  {
    "round_id": 1,
    "question_no": 4,
    "domain_id": 5,
    "select_count": 1,
    "title": "[공식샘플 #4] 신규 AZ의 Amazon EFS 마운트 실패 원인 진단",
    "question_text": "A company runs an application on a large fleet of Amazon EC2 instances to process financial transactions. The EC2 instances share data by using an Amazon Elastic File System (Amazon EFS) file system.\nThe company wants to deploy the application to a new Availability Zone and has created new subnets and a mount target in the new Availability Zone. When a SysOps administrator launches new EC2 instances in the new subnets, the EC2 instances are unable to mount the file system.\n\nWhat is a reason for this issue?",
    "options": [
      "The EFS mount target has been created in a private subnet.",
      "The IAM role that is associated with the EC2 instances does not allow the efs:MountFileSystem action.",
      "The route tables have not been configured to route traffic to a VPC endpoint for Amazon EFS in the new Availability Zone.",
      "The security group for the mount target does not allow inbound NFS connections from the security group used by the EC2 instances."
    ],
    "correct_indices": [
      3
    ],
    "core_keywords": "Amazon EFS, Mount Target, Security Group, NFS TCP 2049",
    "explanation": "정답: D\n• EFS Mount Target에는 별도의 보안 그룹(SG)이 연결됩니다. 새 AZ의 Mount Target 보안 그룹이 EC2 인스턴스의 보안 그룹으로부터 오는 인바운드 NFS(TCP 2049) 트래픽을 허용하지 않으면 마운트가 실패합니다.\n• 오답 분석: (A) EFS Mount Target은 프라이빗 서브넷에 생성하는 것이 정상입니다. (B) efs:MountFileSystem이라는 IAM 액션은 기본 NFS 마운트에 필수가 아닙니다(efs:ClientMount 등은 EFS IAM 인증 시 사용). (C) EFS Mount Target은 VPC 내 ENI로 동작하므로 별도 VPC Endpoint 라우팅이 필요 없습니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q4 — EFS 마운트 실패 시 TCP 2049 보안 그룹 & AZ별 Mount Target 확인"
  },
  {
    "round_id": 1,
    "question_no": 5,
    "domain_id": 3,
    "select_count": 1,
    "title": "[공식샘플 #5] AWS Organizations 전체 계정에 IAM 역할 일괄 배포",
    "question_text": "A company uses AWS Organizations to create and manage many AWS accounts. The company wants to deploy new IAM roles in each account.\n\nWhich action should the SysOps administrator take to deploy the new roles in each of the organization's accounts?",
    "options": [
      "Create a service control policy (SCP) in the organization to add the new IAM roles to each account.",
      "Deploy an AWS CloudFormation change set to the organization with a template to create the new IAM roles.",
      "Use AWS CloudFormation StackSets to deploy a template to each account to create the new IAM roles.",
      "Use AWS Config to create an organization rule to add the new IAM roles to each account."
    ],
    "correct_indices": [
      2
    ],
    "core_keywords": "CloudFormation StackSets, AWS Organizations, Multi-Account, IAM Role",
    "explanation": "정답: C\n• AWS CloudFormation StackSets를 사용하면 AWS Organizations 관리 계정(또는 위임 관리자)에서 단일 작업으로 조직 전체 또는 특정 OU의 모든 계정·리전에 IAM 역할 템플릿을 배포할 수 있습니다(Service-managed permissions).\n• 오답 분석: (A) SCP는 최대 허용 권한 경계를 제한하는 정책이지 리소스(IAM Role)를 생성하지 못합니다. (B) Change Set은 단일 계정의 단일 스택 변경 미리보기 기능입니다. (D) AWS Config는 규정 준수 평가 및 교정용이지 멀티계정 IaC 일괄 프로비저닝 도구가 아닙니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q5 — 멀티계정/멀티리전 리소스 일괄 배포 = CloudFormation StackSets"
  },
  {
    "round_id": 1,
    "question_no": 6,
    "domain_id": 1,
    "select_count": 1,
    "title": "[공식샘플 #6] EC2 시스템 상태 검사 실패 시 자동 복구(Recovery) 및 알림",
    "question_text": "A company runs several production workloads on Amazon EC2 instances. A SysOps administrator discovered that a production EC2 instance failed a system health check. The SysOps administrator recovered the instance manually.\nThe SysOps administrator wants to automate the recovery task of EC2 instances and receive notifications whenever a system health check fails. Detailed monitoring is activated for all of the company's production EC2 instances.\n\nWhich of the following is the MOST operationally efficient solution that meets these requirements?",
    "options": [
      "For each production EC2 instance, create an Amazon CloudWatch alarm for StatusCheckFailed: System. Set the alarm action to recover the EC2 instance. Configure the alarm notification to be published to an Amazon Simple Notification Service (Amazon SNS) topic.",
      "On each production EC2 instance, create a script that monitors the system health by sending a heartbeat notification every minute to a central monitoring server. If an EC2 instance fails to send a heartbeat, run a script on the monitoring server to stop and start the EC2 instance and to publish a notification to an Amazon Simple Notification Service (Amazon SNS) topic.",
      "On each production EC2 instance, create a script that sends network pings to a highly available endpoint by way of a cron job. If the script detects a network response timeout, invoke a command to reboot the EC2 instance.",
      "On each production EC2 instance, configure an Amazon CloudWatch agent to collect and send logs to a log group in Amazon CloudWatch Logs. Create a CloudWatch alarm that is based on a metric filter that tracks errors. Configure the alarm to invoke an AWS Lambda function to reboot the EC2 instance and send a notification email."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "StatusCheckFailed_System, EC2 Auto Recovery, CloudWatch Alarm Action, SNS",
    "explanation": "정답: A\n• 물리 호스트 하드웨어 장애, 네트워크 손실, 전원 문제 등은 StatusCheckFailed_System(시스템 상태 검사 실패)으로 감지됩니다. CloudWatch Alarm의 EC2 작업(Recover)을 설정하면 인스턴스 ID, 프라이빗 IP, 탄력적 IP, 메타데이터를 유지한 채 새 정상 호스트로 자동 마이그레이션 복구하며 동시에 SNS 알림을 보낼 수 있습니다.\n• 오답 분석: (B)(C) 커스텀 스크립트 유지보수 부담이 크며 호스트 하드웨어 장애 시 OS 내부 cron이 동작하지 못합니다. (D) Reboot는 동일 호스트에서 재부팅하므로 호스트 하드웨어 장애를 해결하지 못합니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q6 — StatusCheckFailed_System(호스트 장애 → Recover) vs StatusCheckFailed_Instance(OS 장애 → Reboot)"
  },
  {
    "round_id": 1,
    "question_no": 7,
    "domain_id": 2,
    "select_count": 1,
    "title": "[공식샘플 #7] 현재·미래 EC2 및 EFS 일일 백업(30일 보존) 자동화",
    "question_text": "The company uses AWS Organizations to manage its accounts. For the production account, a SysOps administrator must ensure that all data is backed up daily for all current and future Amazon EC2 instances and Amazon Elastic File System (Amazon EFS) file systems. Backups must be retained for 30 days.\n\nWhich solution will meet these requirements with the LEAST amount of effort?",
    "options": [
      "Create a backup plan in AWS Backup. Assign resources by resource ID, selecting all existing EC2 and EFS resources that are running in the account. Edit the backup plan daily to include any new resources. Schedule the backup plan to run every day with a lifecycle policy to expire backups after 30 days.",
      "Create a backup plan in AWS Backup. Assign resources by tags. Ensure that all existing EC2 and EFS resources are tagged correctly. Apply a service control policy (SCP) for the production account OU that prevents instance and file system creation unless the correct tags are applied. Schedule the backup plan to run every day with a lifecycle policy to expire backups after 30 days.",
      "Create a lifecycle policy in Amazon Data Lifecycle Manager (Amazon DLM). Assign all resources by resource ID, selecting all existing EC2 and EFS resources that are running in the account. Edit the lifecycle policy daily to include any new resources. Schedule the lifecycle policy to create snapshots every day with a retention period of 30 days.",
      "Create a lifecycle policy in Amazon Data Lifecycle Manager (Amazon DLM). Assign all resources by tags. Ensure that all existing EC2 and EFS resources are tagged correctly. Apply a service control policy (SCP) that prevents resource creation unless the correct tags are applied. Schedule the lifecycle policy to create snapshots every day with a retention period of 30 days."
    ],
    "correct_indices": [
      1
    ],
    "core_keywords": "AWS Backup, Tag Assignment, SCP Tag Enforcement, EFS & EC2 Backup",
    "explanation": "정답: B\n• AWS Backup은 EC2, EBS, EFS, RDS, DynamoDB 등 다양한 서비스를 중앙에서 통합 백업하며, 태그(Tag) 기반 할당을 사용하면 향후 생성되는 리소스도 자동 포함됩니다. 여기에 Organizations SCP로 필수 태그 누락 시 생성 자체를 차단하면 최소 노력으로 모든 현재·미래 리소스 백업을 보장할 수 있습니다.\n• 오답 분석: (A)(C) 매일 수동으로 리소스 ID를 편집하는 것은 운영 부담이 큽니다. (C)(D) Amazon DLM은 EBS 스냅샷 및 EBS 지원 AMI 전용이며 EFS 파일 시스템 백업을 지원하지 않습니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q7 — DLM은 EBS/AMI 전용, EFS까지 통합 백업은 AWS Backup + 태그 + SCP"
  },
  {
    "round_id": 1,
    "question_no": 8,
    "domain_id": 4,
    "select_count": 1,
    "title": "[공식샘플 #8] AWS CloudTrail 로그 파일 무결성(삭제/변조 여부) 검증",
    "question_text": "A company is using AWS CloudTrail and wants to ensure that SysOps administrators can easily verify that the log files have not been deleted or changed.\n\nWhich action should a SysOps administrator take to meet this requirement?",
    "options": [
      "Grant administrators access to the AWS Key Management Service (AWS KMS) key used to encrypt the log files.",
      "Enable CloudTrail log file integrity validation when the trail is created or updated.",
      "Turn on Amazon S3 server access logging for the bucket storing the log files.",
      "Configure the S3 bucket to replicate the log files to another bucket."
    ],
    "correct_indices": [
      1
    ],
    "core_keywords": "CloudTrail Log File Integrity Validation, SHA-256 Digest, 변조 검증",
    "explanation": "정답: B\n• CloudTrail 로그 파일 무결성 검증(Log File Integrity Validation)을 활성화하면 매시간 SHA-256 해시와 RSA 디지털 서명이 포함된 Digest 파일을 S3에 저장하여, 로그 전달 이후 삭제·수정 여부를 `aws cloudtrail validate-logs`로 정확히 검증할 수 있습니다.\n• 오답 분석: (A) KMS 암호화는 기밀성 보장 기능이지 로그 삭제·변조 탐지용이 아닙니다. (C) S3 서버 액세스 로깅은 요청 기록은 남기지만 로그 자체의 암호학적 무결성 검증을 제공하지 않습니다. (D) 복제 전 원본이 변조되면 변조본이 그대로 복제될 수 있습니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q8 — CloudTrail 무결성 검증(Digest 파일 + validate-logs CLI)"
  },
  {
    "round_id": 1,
    "question_no": 9,
    "domain_id": 2,
    "select_count": 1,
    "title": "[공식샘플 #9] EC2 커스텀 DB용 EBS 볼륨의 정기 스냅샷 백업 전략",
    "question_text": "A company is running a custom database on an Amazon EC2 instance. The database stores its data on an Amazon Elastic Block Store (Amazon EBS) volume. A SysOps administrator must set up a backup strategy for the EBS volume.\n\nWhat should the SysOps administrator do to meet this requirement?",
    "options": [
      "Create an Amazon CloudWatch alarm for the VolumeIdleTime metric with an action to take a snapshot of the EBS volume.",
      "Create a pipeline in AWS Data Pipeline to take a snapshot of the EBS volume on a recurring schedule.",
      "Create an Amazon Data Lifecycle Manager (Amazon DLM) policy to take a snapshot of the EBS volume on a recurring schedule.",
      "Create an AWS DataSync task to take a snapshot of the EBS volume on a recurring schedule."
    ],
    "correct_indices": [
      2
    ],
    "core_keywords": "Amazon DLM, EBS Snapshot, Automated Lifecycle Policy",
    "explanation": "정답: C\n• Amazon Data Lifecycle Manager(DLM)는 태그 기반으로 EBS 볼륨 스냅샷 및 EBS-backed AMI의 생성, 보존 기간, 삭제, 교차 리전 복사를 완전 자동으로 관리하는 표준 서비스입니다.\n• 오답 분석: (A) CloudWatch 알람 작업에는 EBS 스냅샷 생성 액션이 없습니다(EC2 Stop/Terminate/Reboot/Recover만 지원). (B) AWS Data Pipeline은 ETL 데이터 이동용이며 신규 계정 사용 중단/레거시입니다. (D) AWS DataSync는 온프레미스-AWS 간 파일/객체 전송 도구입니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q9 — EBS 볼륨 단독 정기 스냅샷 자동화 = Amazon DLM (또는 AWS Backup)"
  },
  {
    "round_id": 1,
    "question_no": 10,
    "domain_id": 6,
    "select_count": 1,
    "title": "[공식샘플 #10] 부서별 기존 EC2 리소스 비용 추적 — Cost Allocation Tags",
    "question_text": "A company runs a large number of Amazon EC2 instances for internal departments. The company needs to track the costs of its existing AWS resources by department.\n\nWhat should a SysOps administrator do to meet this requirement?",
    "options": [
      "Activate all of the AWS generated cost allocation tags for the account.",
      "Apply user-defined tags to the instances through Tag Editor. Activate these tags for cost allocation.",
      "Schedule an AWS Lambda function to run the AWS Pricing Calculator for EC2 usage on a recurring schedule.",
      "Use the AWS Trusted Advisor dashboard to export EC2 cost reports."
    ],
    "correct_indices": [
      1
    ],
    "core_keywords": "Cost Allocation Tags, Tag Editor, User-defined Tags, Cost Explorer",
    "explanation": "정답: B\n• 부서(Department)별 비용을 분류·추적하려면 AWS Resource Groups Tag Editor로 기존 EC2 인스턴스에 사용자 정의 태그(예: Department=Finance)를 일괄 적용한 뒤, Billing 콘솔에서 해당 사용자 정의 비용 할당 태그(User-defined Cost Allocation Tags)를 활성화해야 Cost Explorer 및 CUR에서 집계됩니다.\n• 오답 분석: (A) AWS 생성 태그(aws:createdBy 등)는 생성 주체만 추적할 뿐 부서 정보를 담지 않습니다. (C) Pricing Calculator는 사전 견적 도구입니다. (D) Trusted Advisor는 비용 최적화 권고(유휴 리소스 등)를 제공하지만 부서별 비용 분류 리포트 도구가 아닙니다.",
    "source": "AWS Official Sample Questions PDF",
    "escalation_note": "AWS SOA-C02 Official Sample Q10 — 태그 적용 후 반드시 Billing 콘솔에서 Cost Allocation Tags 활성화 필요 (과거 소급 적용 불가)"
  },
  {
    "round_id": 2,
    "question_no": 1,
    "domain_id": 1,
    "select_count": 1,
    "title": "CloudWatch Logs Subscription Filter vs Export to S3 실시간 로그 전달",
    "question_text": "운영 중인 웹 서버 그룹의 애플리케이션 로그가 Amazon CloudWatch Logs로 수집되고 있습니다. 보안 분석팀은 로그가 생성된 후 1분 이내에 Amazon OpenSearch Service 대시보드에서 실시간으로 에러 로그를 조회하고 싶습니다. 가장 운영 효율적인 구성 방법은 무엇입니까?",
    "options": [
      "CloudWatch Logs 콘솔에서 CreateExportTask API를 호출하는 EventBridge 스케줄을 매분 실행한다.",
      "로그 그룹에 Amazon OpenSearch Service를 대상으로 하는 CloudWatch Logs Subscription Filter를 구성한다.",
      "CloudWatch Logs Metric Filter를 생성해 로그 본문 전체를 CloudWatch Metrics에 저장한다.",
      "EC2 인스턴스마다 AWS Glue 크롤러를 설치해 로그 파일을 1분마다 OpenSearch로 적재한다."
    ],
    "correct_indices": [
      1
    ],
    "core_keywords": "CloudWatch Logs, Subscription Filter, OpenSearch, Real-time Streaming",
    "explanation": "정답: B\n• 실시간(Near real-time) 로그 스트리밍은 Subscription Filter(구독 필터)를 사용하며 대상은 Lambda, Kinesis Data Streams, Amazon Data Firehose, Amazon OpenSearch Service를 지원합니다.\n• 오답 분석: (A) CreateExportTask는 S3 배치 아카이빙용으로 지연 시간이 길고 동시 실행 작업 수 제한이 있습니다. (C) Metric Filter는 숫자 통계만 추출할 뿐 로그 원문을 전송하지 않습니다. (D) Glue는 데이터 레이크 ETL용입니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 1 핵심 — Metric Filter(숫자 알람) vs Subscription Filter(실시간 로그 스트리밍) vs S3 Export(배치 아카이브)"
  },
  {
    "round_id": 2,
    "question_no": 2,
    "domain_id": 1,
    "select_count": 1,
    "title": "AWS Config + Systems Manager Automation 기반 비규정 리소스 자동 교정",
    "question_text": "보안 감사 규정에 따라 모든 Amazon S3 버킷은 서버 측 암호화(SSE)가 활성화되어야 합니다. 누군가 암호화되지 않은 S3 버킷을 생성하면 5분 이내에 자동으로 기본 암호화가 활성화되도록 구성하려고 합니다. 최소한의 커스텀 코드로 이를 구현하는 방법은 무엇입니까?",
    "options": [
      "AWS Config 관리형 규칙(s3-bucket-server-side-encryption-enabled)을 활성화하고, AWS Systems Manager Automation Runbook을 자동 교정(Auto-remediation) 작업으로 연결한다.",
      "Amazon Inspector를 활성화하여 S3 버킷 암호화 누락을 스캔하고 SNS 이메일을 발송한다.",
      "AWS Trusted Advisor의 보안 검사를 매시간 실행하고 IAM 정책을 수동 수정한다.",
      "VPC Flow Logs를 CloudWatch Logs로 보내 암호화되지 않은 S3 PUT 요청을 차단한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "AWS Config, Managed Rule, Auto-Remediation, SSM Automation",
    "explanation": "정답: A\n• AWS Config는 리소스 구성 변경을 감지해 규정 준수 여부를 평가하며, 비준수(NON_COMPLIANT) 시 AWS Systems Manager Automation 문서(예: AWS-EnableS3BucketEncryption)를 자동 교정(Automatic Remediation)으로 즉시 실행할 수 있습니다.\n• 오답 분석: (B) Inspector는 EC2/ECR/Lambda 취약점 스캔 도구이며 S3 설정 교정 기능이 없습니다. (C) 수동 수정은 자동화 요건을 위반합니다. (D) VPC Flow Logs는 네트워크 패킷 메타데이터입니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 1 핵심 — 구성 변경 감사 및 자동 교정(Remediation) = AWS Config + SSM Automation"
  },
  {
    "round_id": 2,
    "question_no": 3,
    "domain_id": 1,
    "select_count": 1,
    "title": "CloudWatch Alarm M-out-of-N 평가 및 TreatMissingData 설정",
    "question_text": "SysOps 관리자가 배치 작업 서버의 CPU 급증을 감시하기 위해 1분 주기 CloudWatch Alarm을 설정했습니다. 최근 5분(5개 데이터 포인트) 중 3회 이상 CPUUtilization이 90%를 초과할 때만 알람이 발생하고, 일시적 데이터 누락(Missing Data)으로 인한 오탐(False Positive)이 발생하지 않도록 하려면 알람을 어떻게 설정해야 합니까?",
    "options": [
      "EvaluationPeriods=5, DatapointsToAlarm=3으로 설정하고 TreatMissingData를 notBreaching(또는 ignore)으로 지정한다.",
      "EvaluationPeriods=3, DatapointsToAlarm=5로 설정하고 TreatMissingData를 breaching으로 지정한다.",
      "Period=300초, EvaluationPeriods=1로 설정하고 Statistic을 Minimum으로 지정한다.",
      "Detailed Monitoring을 비활성화하여 5분 간격 데이터 포인트 1개만으로 평가한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudWatch Alarm, EvaluationPeriods, DatapointsToAlarm, TreatMissingData",
    "explanation": "정답: A\n• M-out-of-N 알람에서는 평가 범위 N(EvaluationPeriods=5)과 임계 초과 횟수 M(DatapointsToAlarm=3, 반드시 M ≤ N)을 지정합니다. 데이터 누락 시 오탐을 막으려면 TreatMissingData를 notBreaching 또는 ignore로 설정해야 합니다.\n• 오답 분석: (B) DatapointsToAlarm은 EvaluationPeriods보다 클 수 없으며 breaching은 누락 시 알람을 울립니다. (C) Minimum은 최솟값 기준이라 급증을 놓칩니다. (D) 1분 주기 요구사항과 어긋납니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 1 핵심 — DatapointsToAlarm(M) <= EvaluationPeriods(N), TreatMissingData 4가지 옵션 숙지"
  },
  {
    "round_id": 2,
    "question_no": 4,
    "domain_id": 1,
    "select_count": 1,
    "title": "CloudWatch Synthetics Canary를 활용한 웹 엔드포인트 가용성 및 지연 모니터링",
    "question_text": "외부 사용자가 접속하는 주문 API와 로그인 웹 페이지가 실제로 200 OK 응답을 반환하는지, 그리고 UI 렌더링 단계에서 깨지는 링크나 지연이 없는지를 트래픽이 적은 새벽 시간에도 5분마다 능동적으로 검증하고 싶습니다. 가장 적합한 AWS 서비스는 무엇입니까?",
    "options": [
      "Amazon CloudWatch Synthetics Canary",
      "AWS X-Ray Sampling Rules",
      "Amazon CloudWatch Logs Insights",
      "AWS CloudTrail Insights"
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudWatch Synthetics, Canary, Endpoint Monitoring, Broken Link",
    "explanation": "정답: A\n• CloudWatch Synthetics Canary는 Node.js/Python 스크립트를 주기적으로 실행해 실제 사용자 트래픽이 없을 때도 웹 페이지·API 엔드포인트를 능동 점검하고 스크린샷·HAR·지연 메트릭을 수집합니다.\n• 오답 분석: (B) X-Ray는 실제 요청이 들어올 때 분산 추적하는 수동(트래픽 의존) 도구입니다. (C) Logs Insights는 저장된 로그 쿼리 도구입니다. (D) CloudTrail Insights는 비정상 API 호출량 탐지 기능입니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 1 핵심 — Synthetics(능동 합성 모니터링) vs RUM(실제 사용자 브라우저 텔레메트리) vs X-Ray(분산 트레이싱)"
  },
  {
    "round_id": 2,
    "question_no": 5,
    "domain_id": 1,
    "select_count": 1,
    "title": "CloudTrail Data Events + Amazon Athena를 이용한 S3 객체 삭제 추적",
    "question_text": "감사팀이 지난 3개월간 특정 Amazon S3 버킷에서 누가 어떤 객체(GetObject, DeleteObject)에 접근했는지 SQL로 상세 조회해야 합니다. 기존 관리 이벤트(Management Events)만 활성화된 CloudTrail에는 해당 기록이 보이지 않았습니다. 향후 이를 추적하고 조회하기 위한 올바른 구성은 무엇입니까?",
    "options": [
      "CloudTrail에서 해당 S3 버킷에 대한 Data Events(데이터 이벤트) 로깅을 활성화하고, S3에 저장된 CloudTrail 로그를 Amazon Athena 테이블로 쿼리한다.",
      "S3 버킷에 CloudTrail Management Events 보존 기간을 90일로 늘리고 CloudWatch Logs Insights로 조회한다.",
      "Amazon Macie를 활성화하여 S3 DeleteObject API 호출자의 IAM 사용자 이름을 실시간 추출한다.",
      "S3 Versioning을 활성화하면 별도 로깅 없이도 모든 GetObject 조회 이력이 버킷 메타데이터에 기록된다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudTrail Data Events, S3 Object API, Amazon Athena, Audit",
    "explanation": "정답: A\n• S3 객체 수준 작업(GetObject, PutObject, DeleteObject)과 Lambda Invoke는 기본 비활성화된 Data Events를 별도로 켜야 CloudTrail에 기록됩니다. S3에 적재된 방대한 CloudTrail JSON 로그는 Amazon Athena로 서버리스 SQL 쿼리가 가장 효율적입니다.\n• 오답 분석: (B) Management Events는 버킷 생성/삭제 같은 제어 평면 작업만 기록합니다. (C) Macie는 민감 데이터(PII) 검색 서비스입니다. (D) Versioning은 읽기(GetObject) 감사 로그를 남기지 않습니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 1 핵심 — Management Events(제어 평면) vs Data Events(S3 객체·Lambda 실행·DynamoDB 항목)"
  },
  {
    "round_id": 2,
    "question_no": 6,
    "domain_id": 1,
    "select_count": 2,
    "title": "CloudWatch Cross-Account Observability 중앙 모니터링 통합 (2개 선택)",
    "question_text": "AWS Organizations 환경에서 25개의 워크로드 계정이 운영 중입니다. 중앙 모니터링 계정(Monitoring Account) 한 곳에서 모든 멤버 계정의 CloudWatch 메트릭, CloudWatch Logs, AWS X-Ray 트레이스를 복제 비용 없이 단일 콘솔로 통합 조회하려고 합니다. 올바른 구성 조합 2가지를 선택하십시오. (Select TWO.)",
    "options": [
      "중앙 모니터링 계정에 CloudWatch Observability Access Manager(OAM) Sink를 생성하고 조직(Organization) 접근 정책을 연결한다.",
      "각 소스 계정(멤버 계정)에서 모니터링 계정의 Sink ARN을 가리키는 OAM Link를 생성해 Metrics·Logs·Traces 공유를 활성화한다.",
      "모든 멤버 계정의 CloudWatch Logs를 Kinesis Data Firehose로 중앙 계정의 S3에 복사한 뒤 CloudWatch 콘솔에서 직접 S3를 마운트한다.",
      "중앙 계정에 모든 멤버 계정용 NAT Gateway를 배치해 메트릭 데이터를 프라이빗 전송한다.",
      "CloudTrail Insight를 중앙 계정에서 활성화해 모든 멤버 계정의 X-Ray 트레이스를 자동 수집한다."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "CloudWatch Cross-Account Observability, OAM Sink, OAM Link, Central Monitoring",
    "explanation": "정답: A, B\n• CloudWatch Cross-Account Observability는 모니터링 계정에 OAM Sink를 만들고, 소스 계정에 OAM Link(CloudFormation StackSets로 일괄 배포 가능)를 연결하면 데이터 복제 없이 중앙에서 메트릭·로그·트레이스·Application Insights를 통합 조회·알람 설정할 수 있습니다.\n• 오답 분석: (C) CloudWatch 콘솔은 S3 버킷을 로그 그룹으로 직접 마운트하지 않습니다. (D)(E) 잘못된 서비스 조합입니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 1 핵심 — CloudWatch Cross-Account Observability(Sink + Link)는 SOA-C02/C03 최신 필수 토픽"
  },
  {
    "round_id": 2,
    "question_no": 7,
    "domain_id": 2,
    "select_count": 1,
    "title": "EC2 Auto Scaling Lifecycle Hooks를 활용한 종료 전 로그 업로드 보장",
    "question_text": "EC2 Auto Scaling 그룹이 축소(Scale-in)될 때, 인스턴스가 즉시 종료되면서 로컬 디스크에 남아 있던 미전송 애플리케이션 로그가 유실되고 있습니다. 인스턴스가 완전히 종료되기 전에 로컬 로그를 S3 버킷으로 안전하게 업로드한 뒤 종료되도록 보장하려면 어떻게 구성해야 합니까?",
    "options": [
      "Auto Scaling 그룹에 Terminating:Wait 상태의 Lifecycle Hook을 추가하고, EventBridge + SSM Run Command(또는 사용자 스크립트)로 S3 업로드 완료 후 CompleteLifecycleAction API를 호출한다.",
      "Auto Scaling 그룹의 HealthCheckGracePeriod를 3600초로 늘려 종료를 1시간 지연시킨다.",
      "Termination Policy를 OldestInstance로 변경해 최신 인스턴스만 남긴다.",
      "EC2 Instance Metadata Service(IMDSv2)에서 종료 직전 자동 S3 백업 옵션을 활성화한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Auto Scaling, Lifecycle Hook, Terminating:Wait, CompleteLifecycleAction",
    "explanation": "정답: A\n• Lifecycle Hook을 `autoscaling:EC2_INSTANCE_TERMINATING`에 연결하면 인스턴스가 `Terminating:Wait` 상태(기본 3600초 타임아웃)로 일시 정지됩니다. 그동안 로그 업로드 스크립트를 실행하고 완료 시 `CompleteLifecycleAction`을 호출하면 안전하게 종료(`Terminating:Proceed`)됩니다.\n• 오답 분석: (B) HealthCheckGracePeriod는 신규 시작 시 상태 검사 유예 시간입니다. (C) 종료 순서만 바꿀 뿐 로그 유실을 막지 못합니다. (D) IMDSv2에는 S3 백업 기능이 없습니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 2 핵심 — Scale-out 초기화(Pending:Wait) 및 Scale-in 정리(Terminating:Wait) = Lifecycle Hooks"
  },
  {
    "round_id": 2,
    "question_no": 8,
    "domain_id": 2,
    "select_count": 1,
    "title": "Amazon RDS Multi-AZ vs Read Replica 장애조치 및 크로스 리전 DR 구분",
    "question_text": "프로덕션 Amazon RDS for PostgreSQL 데이터베이스에 대해 ① 단일 리전 내 AZ 장애 시 RPO=0(데이터 손실 없음)의 자동 장애조치와 ② 타 리전 재해 복구(DR) 및 읽기 전용 BI 리포트 부하 분산을 모두 충족해야 합니다. 올바른 아키텍처는 무엇입니까?",
    "options": [
      "Primary DB를 Multi-AZ 배포로 구성하고, 타 리전에 비동기 복제되는 Cross-Region Read Replica를 추가한다.",
      "동일 리전에 Read Replica 2개를 생성해 자동 장애조치와 데이터 손실 제로(RPO=0)를 달성한다.",
      "Multi-AZ Standby 인스턴스에 BI 리포트 읽기 쿼리를 직접 연결하여 부하를 분산한다.",
      "타 리전에 Multi-AZ Standby만 단독으로 생성해 Cross-Region 자동 장애조치를 구성한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "RDS Multi-AZ, Read Replica, Synchronous vs Asynchronous, Cross-Region DR",
    "explanation": "정답: A\n• RDS Multi-AZ는 동일 리전 내 타 AZ에 동기식(Synchronous) 복제하여 RPO=0 및 자동 엔드포인트 장애조치를 제공합니다(단, Multi-AZ DB Instance의 Standby는 직접 읽기 불가). 읽기 부하 분산과 타 리전 DR(Promote 가능)은 비동기식 Cross-Region Read Replica로 해결합니다.\n• 오답 분석: (B) Read Replica는 비동기 복제이며 자동 장애조치를 수행하지 않습니다. (C) Multi-AZ DB Instance의 Standby는 읽기 트래픽을 받을 수 없습니다(Multi-AZ DB Cluster는 읽기 가능하지만 타 리전 DR은 불가). (D) Multi-AZ는 단일 리전 내 기능입니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 2 핵심 — Multi-AZ(고가용성·동기·자동 페일오버) vs Read Replica(성능/DR·비동기·수동 승격)"
  },
  {
    "round_id": 2,
    "question_no": 9,
    "domain_id": 2,
    "select_count": 1,
    "title": "AWS Backup Vault Lock(Compliance Mode)으로 랜섬웨어 대비 불변 백업 구현",
    "question_text": "금융 규제 준수를 위해 루트 사용자나 관리자 계정이라도 향후 7년간 백업 복구 지점(Recovery Point)을 조기에 삭제하거나 보존 기간을 단축할 수 없도록 WORM(Write-Once-Read-Many) 기반의 완전 불변 백업을 강제해야 합니다. 가장 적합한 설정은 무엇입니까?",
    "options": [
      "AWS Backup Vault에 Vault Lock을 Compliance Mode(준수 모드)로 구성하고 유예 기간(Grace Period)이 만료되도록 확정한다.",
      "AWS Backup Vault Access Policy에서 s3:DeleteObject를 거부한다.",
      "EBS 스냅샷에 DeleteOnTermination=false 태그를 부여한다.",
      "AWS Backup Vault Lock을 Governance Mode로 설정해 루트 계정만 삭제를 허용한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "AWS Backup, Vault Lock, Compliance Mode, WORM, Immutable Backup",
    "explanation": "정답: A\n• AWS Backup Vault Lock의 Compliance Mode는 유예 기간(최소 3일) 경과 후 잠금이 영구 확정되며, 이후 AWS 계정 루트 사용자·관리자·AWS 지원팀조차 보존 기간이 만료되기 전에 백업이나 볼트 잠금을 삭제·변경할 수 없습니다.\n• 오답 분석: (B) Vault Access Policy는 관리자 권한으로 정책 자체를 수정·삭제할 수 있습니다. (C) EBS 볼륨 옵션이지 백업 WORM 잠금이 아닙니다. (D) Governance Mode는 특정 권한(backup:DeleteRecoveryPoint 등)을 가진 관리자가 삭제할 수 있습니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 2 핵심 — Compliance Mode(루트 포함 삭제 불가) vs Governance Mode(권한자 삭제 가능)"
  },
  {
    "round_id": 2,
    "question_no": 10,
    "domain_id": 2,
    "select_count": 1,
    "title": "Route 53 Calculated Health Check 및 Active-Passive Failover 라우팅",
    "question_text": "회사가 주 리전(ap-northeast-2)의 ALB와 백업 리전(ap-southeast-1)의 ALB를 운영 중입니다. 주 리전의 웹 서버 3개 엔드포인트 중 최소 2개 이상이 정상일 때만 주 리전을 정상(Healthy)으로 간주하고, 2개 미만으로 떨어지면 자동으로 백업 리전으로 DNS 트래픽을 전환하려면 Route 53을 어떻게 구성해야 합니까?",
    "options": [
      "3개 엔드포인트에 대한 개별 Health Check를 생성하고, 이를 묶어 Health Threshold=2인 Calculated Health Check를 만든 뒤 Primary 레코드의 Failover 라우팅에 연결한다.",
      "Weighted 라우팅 정책에 가중치 100과 0을 부여해 자동 장애조치를 구성한다.",
      "Geolocation 라우팅 정책에 Evaluate Target Health만 활성화한다.",
      "Latency-based 라우팅에서 TTL을 0으로 설정하면 Route 53이 자동으로 엔드포인트 2/3 임계치를 계산한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Route 53, Calculated Health Check, Failover Routing, Active-Passive",
    "explanation": "정답: A\n• Route 53 Calculated Health Check(계산된 상태 검사)는 여러 하위 Health Check의 상태를 논리적으로 결합하여 지정한 임계 개수(Health Threshold) 이상 정상일 때만 전체를 Healthy로 판단합니다. 이를 Failover(Primary/Secondary) 레코드에 연결하면 다중 조건 기반 자동 페일오버가 동작합니다.\n• 오답 분석: (B)(C)(D) 다중 엔드포인트의 'N개 중 M개 정상' 임계치 논리를 표현하지 못합니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 2 핵심 — Route 53 3종 Health Check(Endpoint, Calculated, CloudWatch Alarm 기반 Private 리소스 점검)"
  },
  {
    "round_id": 2,
    "question_no": 11,
    "domain_id": 2,
    "select_count": 2,
    "title": "EC2 Auto Scaling Warm Pools & Scale-In Protection으로 빠른 부하 대응 (2개 선택)",
    "question_text": "대규모 초기화 스크립트(패키지 설치·데이터 캐싱) 때문에 신규 EC2 인스턴스가 InService 상태가 되는 데 12분이 걸립니다. 갑작스러운 트래픽 폭증 시 1분 이내에 준비된 인스턴스를 투입하고, 특정 핵심 워커 인스턴스가 Scale-in 시 절대 종료되지 않도록 보호하려면 어떤 2가지 Auto Scaling 기능을 구성해야 합니까? (Select TWO.)",
    "options": [
      "Auto Scaling 그룹에 Warm Pool(웜 풀)을 구성하여 사전 초기화된 인스턴스를 Stopped 상태로 대기시킨다.",
      "핵심 워커 인스턴스에 Instance Scale-in Protection(축소 방지)을 활성화한다.",
      "Cooldwon 기간을 10초로 줄여 초기화 스크립트를 건너뛰게 한다.",
      "Termination Policy를 Default에서 AllocationStrategy로 변경한다.",
      "EC2 Placement Group을 Cluster로 변경해 부팅 시간을 단축한다."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "Auto Scaling Warm Pool, Stopped State, Scale-in Protection",
    "explanation": "정답: A, B\n• Warm Pool은 부팅 및 초기화를 미리 마친 인스턴스 풀을 Stopped(EBS 비용만 발생), Running 또는 Hibernated 상태로 유지해 트래픽 급증 시 수십 초 내에 ASG로 투입합니다. 또한 특정 인스턴스가 Scale-in으로 종료되지 않게 하려면 Instance Scale-in Protection을 설정합니다.\n• 오답 분석: (C) Cooldown은 스케일링 동작 간 대기 시간이지 부팅 속도를 줄이지 않습니다. (D)(E) 무관한 설정입니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 2 핵심 — Warm Pool(초기화 지연 해소) + Instance Scale-in Protection(특정 인스턴스 보호)"
  },
  {
    "round_id": 2,
    "question_no": 12,
    "domain_id": 3,
    "select_count": 1,
    "title": "CloudFormation StackSets Service-Managed vs Self-Managed 권한 모델",
    "question_text": "AWS Organizations를 사용하는 회사에서 특정 OU(Organizational Unit)에 향후 새 AWS 계정이 추가될 때마다 별도의 수동 IAM 역할 생성 없이도 표준 VPC 보안 베이스라인 CloudFormation 스택이 자동 배포되도록 구성하려고 합니다. 어떤 StackSets 구성을 선택해야 합니까?",
    "options": [
      "Service-managed permissions(서비스 관리형 권한)로 StackSet을 생성하고 Automatic deployment(자동 배포)를 활성화하여 대상 OU를 지정한다.",
      "Self-managed permissions(자체 관리형 권한)로 StackSet을 생성하고 새 계정이 생길 때마다 Administrator 역할을 수동 추가한다.",
      "단일 계정 Change Set을 S3에 저장하고 각 계정의 루트 사용자가 수동으로 실행한다.",
      "CloudFormation Nested Stacks를 사용하여 단일 계정 내에서 타 계정 리소스를 직접 생성한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudFormation StackSets, Service-managed Permissions, Automatic Deployment, OU",
    "explanation": "정답: A\n• AWS Organizations 통합 환경에서는 `Service-managed permissions` + `Automatic deployment` 옵션을 통해 지정 OU에 새 계정이 편입되는 즉시 스택 인스턴스를 자동 배포하고, 계정이 OU에서 이동/제거될 때 스택 삭제까지 자동화할 수 있습니다.\n• 오답 분석: (B) Self-managed는 Organizations 미사용 환경에서 수동으로 Execution/Administration IAM 역할을 만들어야 합니다. (C)(D) 멀티계정 자동 배포 불가.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 3 핵심 — StackSets Service-managed(Organizations·자동배포) vs Self-managed(독립 계정)"
  },
  {
    "round_id": 2,
    "question_no": 13,
    "domain_id": 3,
    "select_count": 1,
    "title": "CloudFormation Stack Policy & DeletionPolicy로 프로덕션 DB 실수 삭제/교체 방지",
    "question_text": "프로덕션 CloudFormation 스택에 중요 Amazon RDS 인스턴스가 포함되어 있습니다. ① 스택 업데이트 시 실수로 RDS 리소스가 교체(Replace)되거나 삭제되는 것을 차단하고, ② 설령 스택 전체가 삭제되더라도 RDS 최종 스냅샷이 남거나 인스턴스가 유지되도록 보호하려면 어떻게 해야 합니까?",
    "options": [
      "RDS 리소스에 UpdateReplacePolicy / DeletionPolicy를 Retain(또는 Snapshot)으로 설정하고, Update:Replace·Update:Delete를 거부하는 Stack Policy를 스택에 적용한다.",
      "템플릿의 Metadata 섹션에 Protected: true를 추가하면 모든 업데이트 교체가 차단된다.",
      "Termination Protection만 활성화하면 스택 업데이트 시 RDS Replace도 자동으로 차단된다.",
      "DependsOn 속성을 추가해 RDS 리소스의 스키마 변경을 금지한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudFormation Stack Policy, DeletionPolicy, UpdateReplacePolicy, Retain",
    "explanation": "정답: A\n• CloudFormation `Stack Policy`는 스택 업데이트 중 특정 리소스에 대한 `Update:Replace` 또는 `Update:Delete` 액션을 명시적으로 Deny하여 실수로 인한 리소스 교체를 방지합니다. 또한 리소스 속성 `DeletionPolicy: Retain` / `Snapshot` 및 `UpdateReplacePolicy`로 데이터 유실을 이중 방어합니다.\n• 오답 분석: (C) Termination Protection은 스택 전체 삭제(DeleteStack)만 막을 뿐 스택 업데이트 중 리소스 교체(Replace)를 막지 못합니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 3 핵심 — Stack Policy(업데이트 시 교체 차단) vs Termination Protection(스택 삭제 차단) vs DeletionPolicy(리소스 보존)"
  },
  {
    "round_id": 2,
    "question_no": 14,
    "domain_id": 3,
    "select_count": 1,
    "title": "AWS Systems Manager Run Command 속도 제어 (MaxConcurrency & MaxErrors)",
    "question_text": "운영 중인 500대의 EC2 웹 서버에 AWS Systems Manager Run Command를 사용하여 설정 변경 스크립트를 배포해야 합니다. 서비스 중단을 방지하기 위해 한 번에 최대 10%의 인스턴스에만 명령을 실행하고, 오류가 2건 이상 발생하면 즉시 나머지 배포를 중단하려면 Run Command에서 어떤 옵션을 설정해야 합니까?",
    "options": [
      "Rate control에서 Concurrency를 10%로, Error threshold(MaxErrors)를 2로 설정한다.",
      "Targets를 Instance IDs 수동 지정으로 설정하고 타임아웃을 2초로 설정한다.",
      "CloudFormation RollingUpdatePolicy의 MaxBatchSize를 10으로 설정한다.",
      "SSM Parameter Store에 MaxConcurrency=10 파라미터를 저장한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Systems Manager, Run Command, MaxConcurrency, MaxErrors, Rate Control",
    "explanation": "정답: A\n• SSM Run Command와 State Manager의 Rate Control은 `MaxConcurrency`(동시 실행 개수 또는 비율 %, 예: 10%)와 `MaxErrors`(허용 오류 임계치, 초과 시 자동 중단, 예: 2)를 통해 안전한 롤링/카나리 방식 원격 실행을 제어합니다.\n• 오답 분석: (B)(C)(D) Run Command의 동시성 및 오류 임계치 제어 방식이 아닙니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 3 핵심 — SSM Run Command Rate Control(MaxConcurrency / MaxErrors) 빈출 포인트"
  },
  {
    "round_id": 2,
    "question_no": 15,
    "domain_id": 3,
    "select_count": 1,
    "title": "AWS Elastic Beanstalk 배포 정책 비교 — Immutable vs Rolling with Additional Batch",
    "question_text": "AWS Elastic Beanstalk 프로덕션 환경에 새 애플리케이션 버전을 배포할 때, 기존 인스턴스를 전혀 수정하지 않고 동일한 용량의 새 Auto Scaling 그룹에 신규 인스턴스를 띄워 헬스 체크 통과 후 트래픽을 전환하며, 실패 시 기존 인스턴스로 즉시 무중단 롤백할 수 있는 배포 정책은 무엇입니까?",
    "options": [
      "Immutable (불변 배포)",
      "All at once (한 번에 모두 배포)",
      "Rolling (롤링 배포)",
      "Rolling with additional batch (추가 배치를 사용한 롤링 배포)"
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Elastic Beanstalk, Immutable Deployment, Zero-Downtime, Rollback",
    "explanation": "정답: A\n• Immutable(불변) 배포는 임시 Auto Scaling 그룹에 새 인스턴스를 프로비저닝해 건강 상태를 검증한 후 기존 인스턴스를 교체하므로, 기존 인스턴스가 오염되지 않고 실패 시 임시 인스턴스만 종료해 가장 안전하고 빠르게 롤백합니다.\n• 오답 분석: (B) All at once는 다운타임이 발생합니다. (C) Rolling은 배포 중 가용 용량이 감소합니다. (D) Rolling with additional batch는 용량은 유지하지만 기존 인스턴스를 순차 업데이트하므로 실패 시 이전 버전을 다시 재배포해야 해 롤백 시간이 더 깁니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 3 핵심 — Elastic Beanstalk 5대 배포 정책(All at once / Rolling / Additional batch / Immutable / Traffic splitting)"
  },
  {
    "round_id": 2,
    "question_no": 16,
    "domain_id": 3,
    "select_count": 2,
    "title": "AWS Systems Manager Patch Manager + Maintenance Windows 정기 패치 자동화 (2개 선택)",
    "question_text": "프로덕션 Linux 및 Windows EC2 서버 그룹에 대해 매주 일요일 새벽 2시~4시에만 승인된 보안 패치를 자동 설치하고, 새로 배포되는 Critical 등급 보안 패치는 7일간의 테스트 유예(Auto-approval delay)를 거친 뒤에만 프로덕션에 적용되도록 구성하려 합니다. 필요한 2가지 SSM 구성 요소는 무엇입니까? (Select TWO.)",
    "options": [
      "7일 자동 승인 지연 규칙(ApproveAfterDays=7)을 포함한 Custom Patch Baseline을 생성하고 Patch Group 태그를 연결한다.",
      "매주 일요일 02:00~04:00 일정의 Maintenance Window를 생성하고 대상(Targets)과 AWS-RunPatchBaseline 작업(Tasks)을 등록한다.",
      "EC2 Instance Connect를 활성화해 일요일 새벽마다 관리자가 수동으로 yum update를 실행한다.",
      "CloudFormation Drift Detection을 매주 실행하여 OS 커널 패치를 자동 설치한다.",
      "AWS Config Rule을 사용해 OS 내부의 rpm 패키지를 직접 설치한다."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "SSM Patch Manager, Patch Baseline, Patch Group, Maintenance Window",
    "explanation": "정답: A, B\n• Patch Manager에서 패치 승인 기준과 지연 일수(ApproveAfterDays=7)를 제어하려면 Custom Patch Baseline을 만들고 `Patch Group` 태그를 지정합니다. 정해진 점검 시간대(일요일 02:00~04:00)에만 설치를 실행하려면 Maintenance Windows에 타겟과 `AWS-RunPatchBaseline` 태스크를 등록해야 합니다.\n• 오답 분석: (C) 수동 작업이며, (D)(E)는 OS 패치 설치 도구가 아닙니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 3 핵심 — Patch Baseline(무엇을 승인할지) + Patch Group(대상 그룹 태그) + Maintenance Window(언제 설치할지)"
  },
  {
    "round_id": 2,
    "question_no": 17,
    "domain_id": 4,
    "select_count": 1,
    "title": "IAM Permission Boundaries(권한 경계)를 통한 안전한 역할 위임 제어",
    "question_text": "플랫폼 팀이 개발자에게 자신의 프로젝트용 IAM Role을 직접 생성할 수 있는 권한(iam:CreateRole)을 위임하려고 합니다. 단, 개발자가 스스로 AdministratorAccess 역할을 만들어 권한을 상승(Privilege Escalation)시키는 것은 방지하고, 생성되는 모든 역할이 S3 및 DynamoDB 특정 리소스 범위 내에서만 동작하도록 강제하려면 어떻게 해야 합니까?",
    "options": [
      "허용 최대 범위를 정의한 IAM Permission Boundary(권한 경계) 정책을 만들고, 개발자의 IAM 정책에 iam:CreateRole 실행 시 해당 Permission Boundary를 반드시 부착하도록 Condition(iam:PermissionsBoundary)을 강제한다.",
      "개발자가 속한 IAM 그룹에 ReadOnlyAccess 관리형 정책을 추가로 연결한다.",
      "EC2 Instance Metadata Service v2(IMDSv2)를 필수로 설정해 IAM Role 생성을 제한한다.",
      "개발자에게 iam:PutRolePolicy 권한만 부여하고 iam:AttachRolePolicy를 제거하면 권한 상승이 완전히 차단된다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "IAM Permission Boundaries, Privilege Escalation, Condition Key, 권한 위임",
    "explanation": "정답: A\n• IAM Permission Boundary는 IAM 사용자/역할이 가질 수 있는 최대 유효 권한(Identity-based Policy ∩ Permission Boundary ∩ SCP)의 상한선을 설정합니다. 개발자 정책에 `iam:PermissionsBoundary` 조건 키를 강제하면, 개발자가 Role에 AdministratorAccess를 붙이더라도 실제 유효 권한은 Boundary 내로 제한됩니다.\n• 오답 분석: (B) IAM 정책은 합집합(Union)으로 평가되므로 ReadOnlyAccess 추가만으로는 다른 Allow를 막지 못합니다. (D) 인라인 정책(PutRolePolicy)으로도 권한 상승이 가능합니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 4 핵심 — 유효 권한 = Identity Policy ∩ Permission Boundary ∩ Organizations SCP (명시적 Deny 최우선)"
  },
  {
    "round_id": 2,
    "question_no": 18,
    "domain_id": 4,
    "select_count": 1,
    "title": "Amazon GuardDuty vs Amazon Inspector vs AWS Security Hub 역할 구분",
    "question_text": "보안 운영팀이 ① EC2 인스턴스 및 컨테이너 이미지(ECR)의 알려진 소프트웨어 CVE 취약점을 지속 스캔하고, ② CloudTrail·VPC Flow Logs·DNS 로그를 머신러닝으로 분석해 암호화폐 채굴이나 비정상 API 탈취 같은 실시간 위협(Threat)을 탐지하려고 합니다. 각 목적에 맞는 AWS 서비스 조합은 무엇입니까?",
    "options": [
      "① Amazon Inspector / ② Amazon GuardDuty",
      "① Amazon GuardDuty / ② Amazon Inspector",
      "① AWS WAF / ② AWS Shield Advanced",
      "① Amazon Macie / ② AWS Artifact"
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Amazon Inspector, Amazon GuardDuty, CVE Vulnerability, Threat Detection",
    "explanation": "정답: A\n• Amazon Inspector는 EC2(SSM Agent 활용), ECR 컨테이너 이미지, Lambda 함수의 CVE 소프트웨어 취약점 및 네트워크 노출을 자동 평가합니다. 반면 Amazon GuardDuty는 CloudTrail, VPC Flow Logs, DNS Logs, EKS Audit Logs 등을 분석해 지능형 위협(CryptoMining, Tor 통신, Credential Exfiltration 등)을 탐지합니다.\n• 참고: Security Hub는 GuardDuty·Inspector·Config·Macie 결과를 단일 대시보드로 집계(ASFF 표준)하는 통합 보안 태세 관리(CSPM) 서비스입니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 4 핵심 — Inspector(취약점 스캔) vs GuardDuty(위협 탐지) vs Macie(S3 민감정보) vs Security Hub(통합 집계)"
  },
  {
    "round_id": 2,
    "question_no": 19,
    "domain_id": 4,
    "select_count": 1,
    "title": "AWS KMS 교차 계정(Cross-Account) CMK 암호화 데이터 복호화 필수 조건",
    "question_text": "계정 A에 생성된 고객 관리형 KMS 키(CMK)로 암호화된 Amazon EBS 스냅샷(또는 S3 객체)을 계정 B의 EC2 역할이 복호화하여 사용해야 합니다. 계정 B의 IAM 역할에 kms:Decrypt 권한을 부여했음에도 AccessDenied 오류가 발생합니다. 누락된 필수 설정은 무엇입니까?",
    "options": [
      "계정 A에 있는 KMS 키의 Key Policy(키 정책)에서 계정 B(또는 계정 B의 특정 IAM 역할 ARN)에 kms:Decrypt 및 kms:DescribeKey 권한을 명시적으로 허용해야 한다.",
      "계정 B에서 동일한 Alias 이름을 가진 새 KMS 키를 생성해야 한다.",
      "KMS 키의 Automatic Key Rotation을 비활성화해야 한다.",
      "계정 A의 KMS 키를 Asymmetric(비대칭) 타입으로 재생성해야 한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "AWS KMS, Key Policy, Cross-Account Access, IAM Policy",
    "explanation": "정답: A\n• 동일 계정 내에서는 Key Policy가 기본 루트 위임을 허용할 경우 IAM 정책만으로 접근 제어가 가능하지만, 교차 계정(Cross-Account) 접근 시에는 반드시 키 소유 계정의 KMS Key Policy와 사용자 계정의 IAM Policy 양쪽 모두에서 허용(또는 KMS Grant 발급)해야 합니다.\n• 오답 분석: (B) Alias가 같아도 키 ID와 키 물질이 다르면 복호화할 수 없습니다. (C)(D) 교차 계정 권한 오류와 무관합니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 4 핵심 — KMS Cross-Account는 Key Policy(키 소유자) + IAM Policy(호출자) 양방향 허용 필수"
  },
  {
    "round_id": 2,
    "question_no": 20,
    "domain_id": 4,
    "select_count": 1,
    "title": "Amazon S3 Block Public Access 계정 수준 적용 및 예외 처리",
    "question_text": "회사의 AWS 계정 내 150개 S3 버킷 중 어느 버킷도 실수로 퍼블릭 읽기/쓰기가 허용되지 않도록 계정 전체에 강력한 안전장치를 걸어야 합니다. 설령 개별 버킷 개발자가 퍼블릭 버킷 정책이나 퍼블릭 ACL을 업로드하더라도 즉시 무력화/차단되도록 하려면 어떻게 구성해야 합니까?",
    "options": [
      "AWS 계정 수준(Account-level)에서 Amazon S3 Block Public Access의 4가지 옵션을 모두 활성화한다.",
      "모든 S3 버킷에 Versioning을 켜고 MFA Delete를 활성화한다.",
      "S3 Intelligent-Tiering 스토리지 클래스를 기본값으로 적용한다.",
      "VPC Gateway Endpoint만 생성하면 인터넷에서 모든 S3 버킷 접근이 자동 차단된다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "S3 Block Public Access, Account-level, Public ACL, Public Bucket Policy",
    "explanation": "정답: A\n• 계정 수준 S3 Block Public Access를 모두 활성화하면(BlockPublicAcls, IgnorePublicAcls, BlockPublicPolicy, RestrictPublicBuckets) 계정 내 모든 기존 및 신규 버킷에서 퍼블릭 ACL과 퍼블릭 버킷 정책이 일괄 차단·무시됩니다. SCP로 `s3:PutAccountPublicAccessBlock` 변경을 금지하면 더욱 견고합니다.\n• 오답 분석: (D) Gateway Endpoint는 VPC 내부 경로를 최적화할 뿐 버킷의 퍼블릭 인터넷 노출 자체를 막아주지 않습니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 4 핵심 — S3 Block Public Access 4대 플래그(ACL 2개 + Policy 2개) 및 SCP 결합 보호"
  },
  {
    "round_id": 2,
    "question_no": 21,
    "domain_id": 4,
    "select_count": 2,
    "title": "AWS Secrets Manager 자동 로테이션 vs Parameter Store SecureString (2개 선택)",
    "question_text": "애플리케이션이 사용하는 Amazon RDS MySQL 마스터 자격증명을 안전하게 관리하고 30일마다 자동으로 비밀번호를 변경(Rotation)해야 하며, 애플리케이션 코드에는 자격증명이 하드코딩되지 않아야 합니다. 또한 별도의 비비밀 일반 설정값(예: timeout=30)은 무료로 관리하고자 합니다. 가장 비용 효율적이고 올바른 2가지 선택은 무엇입니까? (Select TWO.)",
    "options": [
      "RDS 자격증명은 AWS Secrets Manager에 저장하고 30일 주기 자동 로테이션(Automatic Rotation)을 활성화한다.",
      "일반 설정값(timeout=30)은 AWS Systems Manager Parameter Store의 Standard 티어 String 파라미터로 저장한다.",
      "RDS 자격증명을 CloudFormation Parameters에 평문으로 저장해 자동 로테이션을 구현한다.",
      "EC2 User Data 스크립트에 DB 비밀번호를 직접 기입해 런타임 주입한다.",
      "모든 일반 설정값과 DB 비밀번호를 KMS CMK 없이 S3 퍼블릭 버킷에 저장한다."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "AWS Secrets Manager, Automatic Rotation, SSM Parameter Store, Standard Tier",
    "explanation": "정답: A, B\n• AWS Secrets Manager는 RDS/Aurora/Redshift/DocumentDB와 네이티브 통합되어 내장 Lambda 함수를 통한 자동 비밀번호 로테이션을 기본 제공합니다(유료). 반면 자동 로테이션이 불필요한 일반 구성값이나 간단한 암호화 파라미터는 SSM Parameter Store Standard 티어를 무료(10,000개 한도)로 활용하는 것이 최적입니다.\n• 오답 분석: (C)(D)(E) 보안 및 로테이션 모범 사례에 위배됩니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 4 핵심 — Secrets Manager(RDS 내장 자동 로테이션) vs Parameter Store(무료 Standard 티어·계층형 설정)"
  },
  {
    "round_id": 2,
    "question_no": 22,
    "domain_id": 5,
    "select_count": 1,
    "title": "Security Group(Stateful) vs Network ACL(Stateless) 임시 포트 차단 트러블슈팅",
    "question_text": "퍼블릭 서브넷의 웹 서버가 외부 API(HTTPS 443)로 아웃바운드 요청을 보내려는데 연결이 타임아웃됩니다. 인스턴스의 Security Group은 모든 아웃바운드(0.0.0.0/0)를 허용하고 있고, 서브넷의 Network ACL(NACL)은 아웃바운드 규칙 100에서 TCP 443을 허용하고 인바운드 규칙 100에서 TCP 80과 443만 허용하고 있습니다. 원인과 해결책은 무엇입니까?",
    "options": [
      "NACL은 Stateless(상태 비저장)이므로 외부 서버에서 돌아오는 응답 트래픽을 위해 NACL 인바운드 규칙에 Ephemeral Ports(임시 포트, 예: 1024-65535)를 허용해야 한다.",
      "Security Group이 Stateless이므로 Security Group 인바운드에 TCP 443을 추가해야 한다.",
      "NACL 규칙 번호는 큰 숫자부터 우선 평가되므로 규칙 100을 9000으로 변경한다.",
      "Internet Gateway에 별도의 NACL을 연결해 응답 패킷을 복호화해야 한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Network ACL, Stateless, Ephemeral Ports, Security Group Stateful",
    "explanation": "정답: A\n• Security Group은 Stateful(상태 저장)이라 아웃바운드 요청에 대한 응답 트래픽이 인바운드 규칙 없이도 자동 허용됩니다. 반면 Subnet 수준의 NACL은 Stateless(상태 비저장)이므로 아웃바운드 443 요청의 응답이 클라이언트 임시 포트(Ephemeral Ports 1024-65535)로 되돌아올 때 NACL 인바운드 규칙에서 명시적으로 허용해주어야 합니다.\n• 오답 분석: (B) SG는 Stateful입니다. (C) NACL은 가장 낮은 번호(1부터) 순으로 평가됩니다. (D) IGW에는 NACL을 연결하지 않습니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 5 핵심 — NACL(Stateless·서브넷 수준·Allow/Deny·번호순 평가·Ephemeral Port 필수) vs SG(Stateful·ENI 수준·Allow만)"
  },
  {
    "round_id": 2,
    "question_no": 23,
    "domain_id": 5,
    "select_count": 1,
    "title": "VPC Peering의 비전이적 라우팅 한계와 AWS Transit Gateway 전환",
    "question_text": "VPC A와 VPC B가 VPC Peering으로 연결되어 있고, VPC B와 VPC C도 VPC Peering으로 연결되어 있습니다. 현재 VPC A의 EC2 인스턴스가 VPC B를 경유하여 VPC C의 데이터베이스에 접속하려 하지만 통신이 되지 않습니다. 향후 20개 이상의 VPC가 상호 통신해야 하는 확장성을 고려할 때 가장 적합한 해결책은 무엇입니까?",
    "options": [
      "VPC Peering은 전이적 라우팅(Transitive Routing)을 지원하지 않으므로 AWS Transit Gateway(TGW)를 도입해 모든 VPC를 허브 앤 스포크 구조로 연결한다.",
      "VPC B의 라우트 테이블에 VPC A → VPC C 정적 경로를 추가하면 Peering 경유 통신이 활성화된다.",
      "VPC B에 NAT Gateway를 설치하면 VPC A와 VPC C 간 Peering 중계가 가능하다.",
      "VPC A와 VPC C에 동일한 CIDR 대역을 할당해 Peering 충돌을 우회한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "VPC Peering, Transitive Routing, Transit Gateway, Hub-and-Spoke",
    "explanation": "정답: A\n• VPC Peering은 비전이적(Non-transitive) 연결이므로 A-B, B-C가 연결되어 있어도 A가 B를 거쳐 C로 통신할 수 없습니다. 대규모 VPC 간 풀 메시(N*(N-1)/2) 관리 복잡도를 없애고 중앙 라우팅을 제공하려면 AWS Transit Gateway(TGW)를 사용해야 합니다.\n• 오답 분석: (B)(C) VPC Peering은 라우트 테이블 수정이나 NAT로도 전이적 경유를 허용하지 않습니다. (D) 중복 CIDR은 Peering 및 TGW 통신 오류를 유발합니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 5 핵심 — VPC Peering(1:1·비전이적) vs Transit Gateway(Hub-and-Spoke·전이적 라우팅)"
  },
  {
    "round_id": 2,
    "question_no": 24,
    "domain_id": 5,
    "select_count": 1,
    "title": "VPC Flow Logs를 활용한 네트워크 차단(REJECT) 원인 분석",
    "question_text": "애플리케이션 서버에서 RDS 포트로 접속이 실패해 VPC Flow Logs를 활성화했습니다. CloudWatch Logs에 기록된 Flow Log 레코드에 `... 10.0.1.25 10.0.2.40 54321 3306 6 1 60 ... REJECT OK`가 출력되었습니다. 이 로그가 의미하는 바와 다음 점검 대상은 무엇입니까?",
    "options": [
      "해당 트래픽(TCP 3306)이 Security Group 또는 Network ACL 규칙에 의해 거부(REJECT)되었음을 의미하므로 SG/NACL 규칙을 점검한다.",
      "패킷이 정상 허용되었으나 RDS 내부 비밀번호가 틀렸음을 의미한다.",
      "Flow Logs 수집 자체에 오류가 발생해 로그가 손실되었음을 의미한다(OK는 오류 코드).",
      "RDS 인스턴스의 CPU가 100%여서 커넥션이 지연됨을 의미한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "VPC Flow Logs, REJECT, log-status OK, SG vs NACL Troubleshooting",
    "explanation": "정답: A\n• VPC Flow Logs의 `action` 필드가 `REJECT`이면 해당 ENI/서브넷의 Security Group 또는 Network ACL에 의해 패킷이 차단되었음을 의미합니다. 끝부분의 `OK`는 Flow Logs 수집 상태(log-status)가 정상임을 나타냅니다(NODATA/SKIPDATA가 아님).\n• 오답 분석: (B)(D) 애플리케이션 계층 인증 오류나 DB CPU 문제는 네트워크 패킷 수준인 Flow Logs에서 REJECT로 찍히지 않습니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 5 핵심 — VPC Flow Logs 필드 순서(srcaddr dstaddr srcport dstport protocol packets bytes start end action log-status)"
  },
  {
    "round_id": 2,
    "question_no": 25,
    "domain_id": 5,
    "select_count": 1,
    "title": "고가용성 NAT Gateway 배치 및 Gateway VPC Endpoint 비용 절감",
    "question_text": "2개의 가용 영역(AZ-a, AZ-b)에 프라이빗 서브넷을 둔 프로덕션 VPC에서 ① 단일 AZ 장애 시에도 인터넷 아웃바운드 통신이 끊기지 않아야 하며, ② 프라이빗 서브넷의 EC2가 대용량 데이터를 같은 리전의 Amazon S3에 업로드할 때 NAT Gateway 데이터 처리 비용($/GB)이 발생하지 않도록 하려면 어떻게 구성해야 합니까?",
    "options": [
      "AZ-a와 AZ-b의 퍼블릭 서브넷에 각각 NAT Gateway를 1개씩 배치해 AZ별 프라이빗 라우트 테이블에 연결하고, S3용 Gateway VPC Endpoint를 생성해 두 프라이빗 라우트 테이블에 연결한다.",
      "AZ-a에만 대용량 NAT Gateway 1개를 배치하고, S3용 Interface VPC Endpoint(PrivateLink)를 생성한다.",
      "프라이빗 서브넷에 Internet Gateway를 직접 연결해 NAT Gateway 비용을 제거한다.",
      "EC2 인스턴스에 퍼블릭 IP를 부여해 NAT Gateway 없이 직접 S3에 접근한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "NAT Gateway Multi-AZ, Gateway VPC Endpoint, S3 Cost Optimization",
    "explanation": "정답: A\n• NAT Gateway는 단일 AZ 리소스이므로 고가용성을 위해 각 AZ의 퍼블릭 서브넷에 하나씩 배치하고 해당 AZ 프라이빗 서브넷 라우트 테이블이 같은 AZ의 NAT Gateway를 가리키게 해야 합니다(AZ 간 교차 트래픽 비용도 절감). 또한 S3와 DynamoDB는 무료인 Gateway VPC Endpoint를 사용하면 NAT Gateway를 거치지 않고 AWS 백본으로 무료 통신합니다.\n• 오답 분석: (B) 단일 NAT GW는 AZ 장애 시 SPOF가 되며, S3 Interface Endpoint는 시간당·GB당 요금이 부과됩니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 5 핵심 — AZ별 NAT Gateway 이중화 + S3/DynamoDB는 무료 Gateway Endpoint 우선"
  },
  {
    "round_id": 2,
    "question_no": 26,
    "domain_id": 5,
    "select_count": 2,
    "title": "Amazon CloudFront Origin Failover 및 유료 회원 전용 Signed URL 보호 (2개 선택)",
    "question_text": "글로벌 미디어 서비스가 Amazon CloudFront를 통해 유료 구독자 전용 동영상과 정적 웹 콘텐츠를 제공합니다. ① 주 오리진 S3 버킷(ap-northeast-2)에서 5xx 또는 404 오류가 발생하면 백업 리전 S3 버킷(us-west-2)으로 자동 페일오버되어야 하고, ② 15분 후 만료되는 임시 링크로만 유료 사용자가 동영상 파일에 접근할 수 있어야 합니다. 올바른 2가지 구성은 무엇입니까? (Select TWO.)",
    "options": [
      "CloudFront Distribution에 Primary와 Secondary S3 오리진을 묶은 Origin Group(오리진 그룹)을 생성하고 5xx/404 상태 코드 기반 Origin Failover를 설정한다.",
      "CloudFront Key Group(Trusted Key Groups)을 구성하고 만료 시간이 설정된 CloudFront Signed URL을 발급해 콘텐츠를 제공한다.",
      "Route 53 Weighted 라우팅을 CloudFront 오리진 내부에 연결해 S3 404 페일오버를 처리한다.",
      "S3 버킷을 퍼블릭으로 열고 URL 쿼리 스트링에 expires=900 파라미터만 붙여 배포한다.",
      "CloudFront OAC(Origin Access Control)만 설정하면 사용자별 15분 만료 링크가 자동 생성된다."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "CloudFront Origin Group, Origin Failover, Signed URL, Trusted Key Group",
    "explanation": "정답: A, B\n• CloudFront Origin Failover는 Primary/Secondary 오리진을 Origin Group으로 묶고 지정된 HTTP 오류 코드(403/404/500/502/503/504 등) 발생 시 자동으로 보조 오리진에서 콘텐츠를 가져옵니다. 또한 시간 제한 유료 접근 제어는 Trusted Key Groups 기반의 CloudFront Signed URL(단일 파일) 또는 Signed Cookie(다수 파일)를 사용합니다.\n• 오답 분석: (E) OAC는 S3와 CloudFront 간 접근 제어용이지 최종 사용자 인증 링크 기능이 아닙니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 5 핵심 — CloudFront Origin Group(오리진 장애조치) + Signed URL/Cookie(사용자 접근 제어)"
  },
  {
    "round_id": 2,
    "question_no": 27,
    "domain_id": 6,
    "select_count": 1,
    "title": "AWS Compute Optimizer 메모리 메트릭 연동으로 EC2 적정 크기(Right-sizing) 개선",
    "question_text": "회사가 AWS Compute Optimizer를 활성화했으나, 추천 목록에서 EC2 인스턴스의 CPU와 네트워크 메트릭만 반영되고 메모리 사용률 기반의 다운사이징 권고가 표시되지 않아 보수적인(큰) 인스턴스 타입만 추천되고 있습니다. Compute Optimizer가 메모리 사용률까지 분석하도록 하려면 어떻게 해야 합니까?",
    "options": [
      "대상 EC2 인스턴스에 Amazon CloudWatch Agent를 설치해 메모리 메트릭(mem_used_percent 등)을 CloudWatch에 수집하면 Compute Optimizer가 자동으로 이를 분석에 반영한다.",
      "EC2 Detailed Monitoring을 활성화하면 하이퍼바이저가 게스트 OS 메모리 사용률을 Compute Optimizer로 자동 전송한다.",
      "AWS Cost Explorer에서 Rightsizing Recommendations의 메모리 시뮬레이션 스위치를 켠다.",
      "AWS Config에서 compute-optimizer-memory-check 규칙을 생성한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "AWS Compute Optimizer, Right-sizing, CloudWatch Agent, Memory Metric",
    "explanation": "정답: A\n• AWS Compute Optimizer는 기본적으로 EC2 하이퍼바이저 메트릭(CPU, 네트워크, 디스크 I/O)만 조회합니다. OS 내부의 메모리 사용률까지 반영해 더 정확한 인스턴스 축소(Downsizing) 권고를 받으려면 CloudWatch Agent를 설치해 메모리 메트릭을 전송해야 합니다.\n• 오답 분석: (B) Detailed Monitoring은 1분 간격 수집일 뿐 게스트 OS 메모리를 읽지 못합니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 6 핵심 — Compute Optimizer + CloudWatch Agent 메모리 연동은 실전 비용 최적화 최빈출 패턴"
  },
  {
    "round_id": 2,
    "question_no": 28,
    "domain_id": 6,
    "select_count": 1,
    "title": "Savings Plans(Compute vs EC2 Instance) vs Reserved Instances 약정 전략",
    "question_text": "회사는 향후 1년간 여러 리전에서 EC2 인스턴스 패밀리(m5 → c6i)를 수시로 교체하고, 일부 워크로드는 AWS Fargate와 AWS Lambda로 이전할 계획입니다. 1년 약정으로 컴퓨팅 비용을 최대 66% 수준까지 절감하면서도 인스턴스 패밀리·리전·컴퓨팅 서비스 전환 유연성을 모두 유지할 수 있는 요금 모델은 무엇입니까?",
    "options": [
      "Compute Savings Plans (1년 약정)",
      "EC2 Instance Savings Plans (1년 약정)",
      "Standard Reserved Instances (표준 예약 인스턴스)",
      "EC2 Dedicated Hosts (전용 호스트)"
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Compute Savings Plans, EC2 Instance Savings Plans, Reserved Instances, Fargate, Lambda",
    "explanation": "정답: A\n• Compute Savings Plans는 인스턴스 패밀리, 크기, OS, 테넌시, 리전에 무관하게 EC2뿐만 아니라 AWS Fargate와 AWS Lambda 사용량에도 자동 적용되는 최고 유연성 할인 모델입니다.\n• 오답 분석: (B) EC2 Instance Savings Plans는 할인율은 더 높지만 특정 리전과 특정 인스턴스 패밀리에 고정됩니다(Fargate/Lambda 미적용). (C) Standard RI는 패밀리·리전 유연성이 제한적이며 Fargate/Lambda에 적용되지 않습니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 6 핵심 — Compute Savings Plans(EC2+Fargate+Lambda·리전/패밀리 무관) vs EC2 Instance Savings Plans(단일 리전·패밀리)"
  },
  {
    "round_id": 2,
    "question_no": 29,
    "domain_id": 6,
    "select_count": 1,
    "title": "Amazon S3 Intelligent-Tiering vs Lifecycle 정책 선택 기준 및 128KB 주의점",
    "question_text": "데이터 레이크 S3 버킷에 크기 50 MB~2 GB의 분석 파일 800 TB가 저장되어 있으나, 파일별 재조회 주기를 전혀 예측할 수 없습니다. 성능 저하와 복원 지연(Retrieval fee) 없이 접근 빈도 변화에 따라 스토리지 비용을 자동 최적화하는 가장 적합한 방법은 무엇입니까?",
    "options": [
      "S3 Intelligent-Tiering 스토리지 클래스를 적용한다(예측 불가 액세스 패턴에 대해 조회 수수료 없이 자동 계층 이동).",
      "S3 Lifecycle 정책으로 30일 후 모든 객체를 S3 Glacier Deep Archive로 즉시 이동시킨다.",
      "S3 One Zone-IA로 수동 이동시켜 복원 수수료를 없앤다.",
      "128 KB 미만의 초소형 로그 파일만 골라 S3 Intelligent-Tiering을 강제 적용한다."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "S3 Intelligent-Tiering, Unpredictable Access, No Retrieval Fee, 128KB Minimum",
    "explanation": "정답: A\n• S3 Intelligent-Tiering은 액세스 패턴을 예측하기 어려운 객체에 대해 30일 미접근 시 Infrequent Access, 90일 미접근 시 Archive Instant Access 티어로 자동 이동시키며(복원 지연·조회 수수료 없음), 다시 조회되면 Frequent Access로 복귀합니다.\n• 참고: 128 KB 미만 객체는 소액의 모니터링 비용 대비 절감 효과가 없어 Intelligent-Tiering 계층 전환 대상에서 제외(Frequent Access 유지)됩니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 6 핵심 — 예측 불가 패턴 = S3 Intelligent-Tiering / 예측 가능 패턴 = S3 Lifecycle(Standard-IA/Glacier)"
  },
  {
    "round_id": 2,
    "question_no": 30,
    "domain_id": 6,
    "select_count": 2,
    "title": "Amazon EBS gp2 → gp3 무중단 마이그레이션 및 성능·비용 독립 최적화 (2개 선택)",
    "question_text": "회사는 500 GiB 크기의 Amazon EBS gp2 볼륨을 사용 중입니다. 현재 3,000 IOPS와 250 MiB/s 처리량이 필요하지만, gp2의 용량 비례 성능 구조(3 IOPS/GiB) 때문에 불필요하게 1,000 GiB를 할당받아 스토리지 비용이 과다 청구되고 있습니다. 다운타임 없이 비용을 절감하고 목표 성능을 달성하기 위한 2가지 올바른 조치는 무엇입니까? (Select TWO.)",
    "options": [
      "Elastic Volumes 기능(ModifyVolume)을 사용해 인스턴스 중단 없이 볼륨 타입을 gp2에서 gp3로 변경한다.",
      "gp3 볼륨의 기본 성능(3,000 IOPS, 125 MiB/s)에서 처리량(Throughput)만 250 MiB/s로 독립 프로비저닝한다(용량 확장 불필요).",
      "스냅샷을 뜬 뒤 EC2를 종료하고 새 io2 Block Express 볼륨으로 재구축해야만 타입 변경이 가능하다.",
      "gp2 볼륨 크기를 2,000 GiB로 늘려 버스트 크레딧 의존도를 제거한다.",
      "EC2 인스턴스 스토어(Instance Store)로 영구 데이터베이스를 옮겨 EBS 비용을 0원으로 만든다."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "EBS gp3, Elastic Volumes, ModifyVolume, Independent IOPS Throughput",
    "explanation": "정답: A, B\n• EBS gp3는 용량과 무관하게 기본 3,000 IOPS와 125 MiB/s를 제공하며, 스토리지 단가도 gp2보다 약 20% 저렴합니다. Elastic Volumes(`aws ec2 modify-volume`)를 통해 인스턴스 중지 없이 온라인으로 gp2 → gp3 전환 후 필요한 처리량(250 MiB/s)만 독립적으로 추가 설정하면 가장 비용 효율적입니다.\n• 오답 분석: (C) 온라인 전환이 가능하므로 중단이 불필요합니다. (E) Instance Store는 임시 스토리지로 재부팅·중지 시 데이터가 손실됩니다.",
    "source": "SOA-C02/C03 공식 Exam Guide 도메인 핵심문제",
    "escalation_note": "Domain 6 핵심 — gp3(기본 3,000 IOPS / 125 MiB/s, 용량·성능 분리) vs gp2(3 IOPS/GiB, 최소 100~최대 16,000)"
  },
  {
    "round_id": 3,
    "question_no": 1,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-01] EC2 메모리 사용률(mem_used_percent) 알람 — CloudWatch Agent 구성",
    "question_text": "A company runs a Java application on a fleet of Amazon EC2 Linux instances. The company needs an alarm when memory utilization on any instance exceeds 85%. A CloudOps engineer cannot find a memory metric in the AWS/EC2 namespace.\n\nWhat should the CloudOps engineer do to meet this requirement?",
    "options": [
      "Install the Amazon CloudWatch agent on the instances. Configure it to collect the mem_used_percent metric.",
      "Enable detailed monitoring on each instance to publish memory metrics at 1-minute intervals.",
      "Enable EC2 Instance Connect to allow Amazon CloudWatch to read memory statistics from each instance.",
      "Create an Amazon CloudWatch metric math expression that derives memory usage from the CPUUtilization metric."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudWatch Agent, CWAgent, mem_used_percent, Custom Metric",
    "explanation": "정답: A (게스트 OS 메모리 메트릭은 하이퍼바이저가 볼 수 없으므로 CloudWatch Agent 필수)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Amazon EC2 cannot see inside the guest operating system, so memory is not a default EC2 metric. The CloudWatch agent runs on the instance and publishes OS-level metrics such as mem_used_percent to the CWAgent namespace, where you can alarm on them.\n• (B) [❌ 오답] Detailed monitoring only increases the frequency of the default hypervisor-level metrics to 1 minute. It does not add memory metrics, because the hypervisor cannot see guest memory usage.\n• (C) [❌ 오답] EC2 Instance Connect provides SSH access to an instance. It does not publish any metrics to CloudWatch.\n• (D) [❌ 오답] CPU utilization and memory utilization are independent. Metric math can only combine metrics that already exist, so it cannot derive memory usage from CPU data.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-01) — 게스트 OS 메모리 메트릭은 하이퍼바이저가 볼 수 없으므로 CloudWatch Agent 필수"
  },
  {
    "round_id": 3,
    "question_no": 2,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-02] 400대 EC2에 CloudWatch Agent 일괄 설치 및 중앙 설정 관리",
    "question_text": "A company has 400 Amazon EC2 instances that are managed by AWS Systems Manager. A CloudOps engineer must install the Amazon CloudWatch agent on every instance and must ensure that all instances use the same agent configuration. The configuration will change several times each year.\n\nWhich solution will meet these requirements in the MOST operationally efficient way?",
    "options": [
      "Store the agent configuration in Parameter Store. Use Systems Manager to install the agent and apply that configuration.",
      "Bake the agent and its configuration file into a new AMI, and replace all instances each time the configuration changes.",
      "Connect to each instance with Session Manager, run the agent configuration wizard, and save the file locally.",
      "Add commands that install and configure the agent to the user data script in the launch template for each instance."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Systems Manager, Parameter Store, AmazonCloudWatch-ManageAgent, State Manager",
    "explanation": "정답: A (대규모 에이전트 배포·설정 변경은 Parameter Store + SSM Run Command/State Manager 조합이 최적)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Systems Manager can install the agent on all managed instances with the AWS-ConfigureAWSPackage document and apply a configuration stored in Parameter Store with the AmazonCloudWatch-ManageAgent document. A configuration change becomes one parameter update and one command or State Manager association, with no per-instance work.\n• (B) [❌ 오답] A new AMI works for new instances, but replacing 400 instances several times a year just to change a configuration adds a lot of effort and risk.\n• (C) [❌ 오답] Configuring 400 instances one at a time is slow and error prone, and the local files would drift apart over time.\n• (D) [❌ 오답] User data runs only when an instance first launches. It would not configure the instances that are already running, and every configuration change would require relaunching instances.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-02) — 대규모 에이전트 배포·설정 변경은 Parameter Store + SSM Run Command/State Manager 조합이 최적"
  },
  {
    "round_id": 3,
    "question_no": 3,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-03] 프라이빗 서브넷 CloudWatch Agent PutMetricData AccessDenied 해결",
    "question_text": "A CloudOps engineer installs and starts the Amazon CloudWatch agent on an Amazon EC2 instance in a private subnet. The subnet routes internet traffic through a NAT gateway. The agent log shows AccessDenied errors when the agent calls the PutMetricData API. No custom metrics appear in CloudWatch.\n\nWhat should the CloudOps engineer do to resolve this issue?",
    "options": [
      "Attach the CloudWatchAgentServerPolicy managed policy to the IAM role in the instance profile.",
      "Create an interface VPC endpoint for CloudWatch in the subnet to allow the agent to reach the service.",
      "Restart the agent with the fetch-config action to reload its JSON configuration file.",
      "Enable detailed monitoring on the instance to allow CloudWatch to accept metrics at 1-minute intervals."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudWatchAgentServerPolicy, IAM Instance Profile, AccessDenied",
    "explanation": "정답: A (AccessDenied는 네트워크(VPC Endpoint) 문제가 아니라 인스턴스 프로파일 IAM 권한 누락)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] An AccessDenied error means the request reached CloudWatch but the caller lacked permission. The agent uses the credentials from the instance profile, so the role needs the permissions in CloudWatchAgentServerPolicy, such as cloudwatch:PutMetricData and the CloudWatch Logs write actions.\n• (B) [❌ 오답] A VPC endpoint fixes network reachability. The NAT gateway already provides a path, and the error is a permissions error, not a timeout.\n• (C) [❌ 오답] Reloading the configuration does not change the permissions of the agent's credentials. The calls would still be denied.\n• (D) [❌ 오답] Detailed monitoring applies only to the default EC2 metrics. It has no effect on custom metrics or on IAM permissions.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-03) — AccessDenied는 네트워크(VPC Endpoint) 문제가 아니라 인스턴스 프로파일 IAM 권한 누락"
  },
  {
    "round_id": 3,
    "question_no": 4,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-04] 로그를 남기지 않고 종료되는 백그라운드 프로세스 감시 (procstat)",
    "question_text": "A company runs a critical background process named order-sync on Amazon EC2 Linux instances. The process sometimes stops without writing any error to the application logs. The company needs an alarm within 1 minute of the process stopping on any instance.\n\nWhich solution will meet this requirement?",
    "options": [
      "Use the Amazon CloudWatch agent procstat plugin to publish the order-sync process count, and alarm when the count is below 1.",
      "Create an Amazon CloudWatch alarm on the StatusCheckFailed_Instance metric for each instance that runs order-sync.",
      "Create a metric filter on the application log group that counts events containing the text order-sync, and alarm on it.",
      "Enable detailed monitoring and alarm when the CPUUtilization metric for any of the instances drops below 5 percent."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudWatch Agent, procstat Plugin, procstat_lookup_pid_count",
    "explanation": "정답: A (특정 데몬/프로세스 생존 여부 감시는 CloudWatch Agent procstat 플러그인 활용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] The procstat plugin monitors individual processes by name or pattern and publishes metrics such as procstat_lookup_pid_count. An alarm on a count below 1 fires when the process is no longer running, even when the process writes nothing to its logs.\n• (B) [❌ 오답] The instance status check detects operating system problems such as exhausted memory or a corrupted file system. A single process can stop while the instance stays healthy.\n• (C) [❌ 오답] A filter that counts log lines cannot show that a process is gone, because the process stops without logging anything.\n• (D) [❌ 오답] Low CPU can have many causes, and other processes keep using CPU after order-sync stops. This alarm would be unreliable in both directions.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-04) — 특정 데몬/프로세스 생존 여부 감시는 CloudWatch Agent procstat 플러그인 활용"
  },
  {
    "round_id": 3,
    "question_no": 5,
    "domain_id": 1,
    "select_count": 2,
    "title": "[D1-07] CloudWatch Logs 5분 내 ERROR 20건 초과 시 SNS 이메일 알림 (2개 선택)",
    "question_text": "A company has an application on Amazon EC2 instances that writes its logs to an Amazon CloudWatch Logs log group. The company's operations team needs an email notification whenever the application writes more than 20 log lines that contain the word ERROR within 5 minutes.\n\nWhich combination of steps will meet this requirement? (Select TWO.)",
    "options": [
      "Create a metric filter on the log group that matches ERROR and publishes a count metric.",
      "Create a CloudWatch alarm on that metric with a threshold of 20 that notifies an Amazon SNS topic.",
      "Create a subscription filter that sends the log group to an Amazon SQS queue for email delivery.",
      "Run a CloudWatch Logs Insights query every 5 minutes from the console and email the results.",
      "Export the log group to Amazon S3 every 5 minutes and use Amazon S3 Event Notifications to send email."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "Metric Filter, CloudWatch Alarm, Sum Statistic, Amazon SNS",
    "explanation": "정답: A, B (로그 패턴 카운팅 → Metric Filter + CloudWatch Alarm(Sum) + SNS Topic 연결)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A metric filter turns matching log events into a CloudWatch metric. Counting events that contain ERROR gives the team a number to alarm on.\n• (B) [✅ 정답] An alarm that uses the Sum statistic over a 5-minute period with a threshold of 20 fires when the error count is exceeded. An Amazon SNS topic with an email subscription delivers the notification.\n• (C) [❌ 오답] Subscription filters deliver to Lambda, Kinesis Data Streams, Data Firehose, or OpenSearch Service, not to SQS. SQS also cannot send email.\n• (D) [❌ 오답] A query that someone runs by hand from the console is not automated, so it cannot reliably notify the team within the 5-minute window.\n• (E) [❌ 오답] Export tasks are batch jobs for archiving logs. They are not designed for near real-time alerting, and the exported files would still need parsing to count errors.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-07) — 로그 패턴 카운팅 → Metric Filter + CloudWatch Alarm(Sum) + SNS Topic 연결"
  },
  {
    "round_id": 3,
    "question_no": 6,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-08] 오류 없는 평온 구간에서 Metric Filter 알람 INSUFFICIENT_DATA 방지",
    "question_text": "A CloudOps engineer creates an Amazon CloudWatch Logs metric filter that counts HTTP 500 responses in a web server log group. The CloudOps engineer creates an alarm on the metric with a threshold of 10 in 5 minutes. During quiet periods with no errors, the alarm shows INSUFFICIENT_DATA instead of OK.\n\nWhat should the CloudOps engineer do so that the alarm reports OK when there are no errors?",
    "options": [
      "Set a default value of 0 on the metric filter.",
      "Change the alarm statistic from Sum to Average.",
      "Change the alarm period from 5 minutes to 1 minute.",
      "Enable high-resolution storage on the metric."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Metric Filter, Default Value 0, INSUFFICIENT_DATA, OK State",
    "explanation": "정답: A (매칭 로그가 없을 때 기본값 0을 발행하도록 설정하거나 TreatMissingData=notBreaching 적용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] By default, a metric filter publishes nothing when no events match, so the alarm has no data points and shows INSUFFICIENT_DATA. A default value of 0 makes the filter report 0 for periods with no matches, so the alarm evaluates to OK. Treating missing data as not breaching is another way to get the same result.\n• (B) [❌ 오답] Changing the statistic does not create data points. With no matching events, there is still nothing to average.\n• (C) [❌ 오답] A shorter period is evaluated more often but still finds no data points during quiet periods.\n• (D) [❌ 오답] High resolution changes how granular the stored data is. It does not create data points when no events match.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-08) — 매칭 로그가 없을 때 기본값 0을 발행하도록 설정하거나 TreatMissingData=notBreaching 적용"
  },
  {
    "round_id": 3,
    "question_no": 7,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-10] 애플리케이션 대기 주문 수(비즈니스 지표) 실시간 그래프·알람",
    "question_text": "A company has an application on Amazon EC2 instances that tracks the number of orders that are waiting to be processed. The company must graph this value in Amazon CloudWatch and must create an alarm on the value.\n\nWhich solution will meet these requirements?",
    "options": [
      "Update the application to publish the value as a custom metric by using the PutMetricData API. Create an alarm on the metric.",
      "Enable detailed monitoring on the instances. Create an alarm on the matching metric in the AWS/EC2 namespace.",
      "Enable AWS CloudTrail data events for the application. Create an alarm on the number of delivered events.",
      "Enable VPC Flow Logs for the application subnets. Create an alarm on the size of the published flow logs."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "PutMetricData, Custom Metric, CloudWatch Dashboard",
    "explanation": "정답: A (비즈니스 커스텀 수치 지표는 애플리케이션/에이전트에서 PutMetricData 또는 EMF로 발행)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Only the application knows this business value, so the application must publish it. PutMetricData sends a custom metric to CloudWatch, where you can graph it and create alarms. The instance role needs the cloudwatch:PutMetricData permission. The CloudWatch agent's StatsD support and OpenTelemetry are other ways to publish custom metrics.\n• (B) [❌ 오답] Detailed monitoring sends the default EC2 metrics every minute instead of every 5 minutes. It does not add application values such as the number of waiting orders.\n• (C) [❌ 오답] CloudTrail records AWS API activity. It has no view of a value inside the application.\n• (D) [❌ 오답] Flow logs record metadata about IP traffic. They do not contain the number of waiting orders.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-10) — 비즈니스 커스텀 수치 지표는 애플리케이션/에이전트에서 PutMetricData 또는 EMF로 발행"
  },
  {
    "round_id": 3,
    "question_no": 8,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-13] 레거시 단일 EC2(EIP·EBS 유지) 호스트 장애 시 자동 복구",
    "question_text": "A company runs a legacy application on a single Amazon EC2 instance that has an Elastic IP address and Amazon EBS volumes. The application cannot run behind a load balancer. If the underlying host has a hardware problem, the instance must recover automatically with the same instance ID and IP address.\n\nWhich solution will meet these requirements?",
    "options": [
      "Create an Amazon CloudWatch alarm on StatusCheckFailed_System that uses the EC2 recover action.",
      "Create an Amazon CloudWatch alarm on StatusCheckFailed_Instance that uses the EC2 reboot action.",
      "Place the instance in an Auto Scaling group with a minimum, maximum, and desired capacity of 1.",
      "Create an Amazon EventBridge rule that launches a new instance from the latest AMI when the host fails."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "StatusCheckFailed_System, EC2 Recover Action, Auto Recovery",
    "explanation": "정답: A (단일 EC2 호스트 장애 자동 복구(IP/EBS/ID 유지) = CloudWatch Alarm Recover 액션)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A system status check failure points to a problem with the AWS hardware or host. The recover action moves the instance to new hardware and keeps the instance ID, private IP addresses, Elastic IP addresses, and EBS volumes. Many current instance types also recover automatically by default.\n• (B) [❌ 오답] An instance status check failure points to a problem inside the operating system, and a reboot stays on the same host. A reboot does not fix a hardware problem on the host.\n• (C) [❌ 오답] An Auto Scaling group replaces an unhealthy instance with a new instance. The new instance has a new instance ID, which the scenario does not allow.\n• (D) [❌ 오답] A new instance launched from an AMI gets a new instance ID and would need extra steps to move the Elastic IP address and data volumes.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-13) — 단일 EC2 호스트 장애 자동 복구(IP/EBS/ID 유지) = CloudWatch Alarm Recover 액션"
  },
  {
    "round_id": 3,
    "question_no": 9,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-19] S3 버킷 객체 삭제 주체(WHO) 추적 — CloudTrail Data Events",
    "question_text": "A company stores invoices in an Amazon S3 bucket. Objects are being deleted from the bucket, and the company does not know who is deleting them. An AWS CloudTrail trail already logs management events. The company must identify the IAM principal behind future deletions.\n\nWhat should a CloudOps engineer do to meet this requirement?",
    "options": [
      "Enable CloudTrail data events for the bucket.",
      "Configure S3 Versioning.",
      "Enable CloudTrail Insights events.",
      "Configure VPC Flow Logs for the VPC that the application uses to reach the bucket."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudTrail Data Events, DeleteObject, S3 Audit",
    "explanation": "정답: A (S3 객체 단위 삭제/조회 주체 추적은 CloudTrail Management Events가 아닌 Data Events 필수)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Object-level actions such as GetObject, PutObject, and DeleteObject are data events, which trails do not log by default. Logging data events for the bucket records the principal, source IP address, and time of each deletion.\n• (B) [❌ 오답] Versioning protects data by keeping a delete marker and earlier versions, but it does not record who made the request.\n• (C) [❌ 오답] Insights detects unusual API call rates and API error rates. It does not log individual object-level calls or who made each one.\n• (D) [❌ 오답] Flow logs record IP traffic metadata only. They do not show API actions or IAM identities, and requests to S3 might not even pass through that VPC.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-19) — S3 객체 단위 삭제/조회 주체 추적은 CloudTrail Management Events가 아닌 Data Events 필수"
  },
  {
    "round_id": 3,
    "question_no": 10,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-20] AWS 계정 Write API 호출량 급증 이상 탐지 및 자동 알림",
    "question_text": "A company needs to receive an alert when the volume of write API calls in its AWS account changes sharply from normal, for example, when a script starts to create hundreds of security groups. The company does not want to define a threshold for each API.\n\nWhich solution will meet these requirements?",
    "options": [
      "Configure AWS CloudTrail Insights for the trail. Route Insights events to an Amazon SNS topic with an Amazon EventBridge rule.",
      "Create a metric filter for each write API in the trail's log group. Create an alarm with a static threshold.",
      "Configure AWS Config recording for all resource types. Create a rule that counts the configuration changes.",
      "Run an Amazon Athena query on the trail's Amazon S3 bucket every hour, and compare the results with those of the prior week."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudTrail Insights, EventBridge, Anomaly Detection",
    "explanation": "정답: A (비정상 API 호출량 급증 탐지 = CloudTrail Insights + EventBridge 자동 알림)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] CloudTrail Insights learns the normal rate of write management API calls and API error rates, and it records an Insights event when activity is unusual. No per-API thresholds are needed, and an EventBridge rule can send the events to an SNS topic.\n• (B) [❌ 오답] This requires a filter and a threshold for every API, which the company wants to avoid. Static thresholds also do not adapt to normal patterns.\n• (C) [❌ 오답] Config records resource configuration changes and evaluates compliance. A custom rule that counts changes is not a built-in way to detect unusual API call rates.\n• (D) [❌ 오답] A custom hourly comparison is code to build and maintain, and it alerts late.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-20) — 비정상 API 호출량 급증 탐지 = CloudTrail Insights + EventBridge 자동 알림"
  },
  {
    "round_id": 3,
    "question_no": 11,
    "domain_id": 1,
    "select_count": 2,
    "title": "[D1-25] CloudWatch Logs 디버그 로그 보관 비용 절감 전략 (2개 선택)",
    "question_text": "A company stores debug logs in Amazon CloudWatch Logs with the retention setting Never expire. The logs are needed only for occasional investigations within 30 days, and the company does not use metric filters or alarms on them. CloudWatch Logs costs are growing every month.\n\nWhich combination of steps will reduce costs and still meet these requirements? (Select TWO.)",
    "options": [
      "Set the retention period of the debug log groups to 30 days.",
      "Use the Essentials log class (formerly Infrequent Access) for new debug log groups.",
      "Enable high-resolution storage for the debug log groups.",
      "Create a metric filter that counts debug lines per minute.",
      "Export the logs to Amazon S3 daily and keep the CloudWatch copy too."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "Log Retention, Essentials Log Class, Infrequent Access, Cost Optimization",
    "explanation": "정답: A, B (보존 기간(30일) 설정으로 무한 누적 방지 + 저비용 로그 클래스(Essentials/IA) 활용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Logs that never expire keep adding storage cost. A 30-day retention period deletes older events automatically and still covers the investigation window.\n• (B) [✅ 정답] The Essentials log class (formerly Infrequent Access) has a lower ingestion price and still supports most Logs Insights query commands. It does not support features such as metric filters, which the team does not use. The class is chosen when the log group is created.\n• (C) [❌ 오답] There is no high-resolution storage setting for log groups. High resolution applies to metrics, and it would not lower costs.\n• (D) [❌ 오답] A metric filter creates a custom metric, which adds cost and does not reduce log storage.\n• (E) [❌ 오답] Exporting adds S3 storage without removing the CloudWatch copy, so total cost goes up.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-25) — 보존 기간(30일) 설정으로 무한 누적 방지 + 저비용 로그 클래스(Essentials/IA) 활용"
  },
  {
    "round_id": 3,
    "question_no": 12,
    "domain_id": 1,
    "select_count": 1,
    "title": "[D1-28] AWS Health 예정된 EC2 유지보수·은퇴 이벤트 자동 통보",
    "question_text": "A company runs Amazon EC2 instances. AWS sometimes schedules maintenance or retirement for the instances. The company's operations team often misses the emails that go to the account's root email address. Scheduled change notices for Amazon EC2 must reach an on-call distribution list automatically.\n\nWhich solution will meet this requirement?",
    "options": [
      "Create an Amazon EventBridge rule for AWS Health events from the EC2 service that targets an Amazon SNS topic for the list.",
      "Create an Amazon CloudWatch alarm on the StatusCheckFailed metric for each instance that notifies the distribution list.",
      "Create an AWS Config rule that checks for retired instances and sends its findings to the distribution list daily.",
      "Use AWS Trusted Advisor to check for scheduled instance events, and email its weekly summary to the distribution list."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "AWS Health, EventBridge Rule, Scheduled Maintenance",
    "explanation": "정답: A (AWS Health 이벤트를 EventBridge 규칙으로 받아 SNS/Slack 알림 자동화)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] AWS Health sends events, including scheduled changes such as instance retirement and maintenance, to EventBridge. A rule that matches aws.health events for EC2 can send them to an SNS topic that the on-call list subscribes to. The AWS Health Dashboard shows the same events.\n• (B) [❌ 오답] Status checks report failures that are happening now. They do not warn about maintenance that AWS has scheduled for the future.\n• (C) [❌ 오답] Config evaluates resource configurations. It does not receive AWS Health scheduled change notices.\n• (D) [❌ 오답] Trusted Advisor checks cost, security, and other best practices. Scheduled maintenance notices come from AWS Health, and a weekly email would arrive too late.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-28) — AWS Health 이벤트를 EventBridge 규칙으로 받아 SNS/Slack 알림 자동화"
  },
  {
    "round_id": 3,
    "question_no": 13,
    "domain_id": 2,
    "select_count": 1,
    "title": "[D2-01] 불규칙 트래픽 패턴의 EC2 Auto Scaling 목표 추적 정책(CPU)",
    "question_text": "A company runs a web application on Amazon EC2 instances in an Auto Scaling group. Load changes throughout the day without a fixed pattern. The company must keep average CPU utilization near 50%.\n\nWhich scaling policy will meet this requirement with the LEAST operational overhead?",
    "options": [
      "A target tracking policy on ASGAverageCPUUtilization with a target of 50",
      "A step scaling policy with separate alarms at 40%, 50%, and 60% CPU",
      "A scheduled action that changes the desired capacity every hour",
      "A simple scaling policy that adds one instance when CPU passes 50%"
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Target Tracking Scaling, ASGAverageCPUUtilization, Dynamic Scaling",
    "explanation": "정답: A (불규칙 부하는 Scheduled가 아닌 Target Tracking 정책(ASGAverageCPUUtilization) 사용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Target tracking works like a thermostat. You choose a metric and a target value, and EC2 Auto Scaling creates and manages the CloudWatch alarms and adjusts capacity in both directions to keep the metric near the target.\n• (B) [❌ 오답] Step scaling can work, but you must create and tune the alarms and step adjustments yourself, which is more effort.\n• (C) [❌ 오답] Scheduled actions suit predictable patterns, and this load has no fixed pattern.\n• (D) [❌ 오답] Simple scaling adds one instance at a time and waits for a cooldown before it acts again, so it reacts slowly to large changes. It also needs a separate scale-in policy.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-01) — 불규칙 부하는 Scheduled가 아닌 Target Tracking 정책(ASGAverageCPUUtilization) 사용"
  },
  {
    "round_id": 3,
    "question_no": 14,
    "domain_id": 2,
    "select_count": 1,
    "title": "[D2-02] ALB 뒤 Stateless API의 인스턴스당 요청 수 기반 오토스케일링",
    "question_text": "A company runs a stateless API on Amazon EC2 instances in an Auto Scaling group behind an Application Load Balancer. Load tests show that each instance handles up to 1,000 requests per minute before latency rises. CPU utilization stays below 40% even at that point.\n\nWhich scaling configuration will keep latency low?",
    "options": [
      "A target tracking policy on ALBRequestCountPerTarget with a target of about 800",
      "A target tracking policy on ASGAverageCPUUtilization with a target of 40",
      "A target tracking policy on ASGAverageNetworkIn with a target of 1,000",
      "A step scaling policy that adds instances when HealthyHostCount drops"
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "ALBRequestCountPerTarget, Target Tracking, Auto Scaling",
    "explanation": "정답: A (요청 수 비례 부하는 CPU보다 ALBRequestCountPerTarget 목표 추적 정책이 정확)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] The instances slow down because of request volume, not CPU. Request count per target measures that load directly, and a target below the 1,000 limit leaves headroom while new instances start.\n• (B) [❌ 오답] CPU stays below 40% even when latency rises, so a CPU target would not add instances in time.\n• (C) [❌ 오답] Network bytes in are not the same as requests, and 1,000 bytes is not a meaningful target for this API.\n• (D) [❌ 오답] HealthyHostCount drops when targets fail health checks. It does not track the request load that causes the latency.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-02) — 요청 수 비례 부하는 CPU보다 ALBRequestCountPerTarget 목표 추적 정책이 정확"
  },
  {
    "round_id": 3,
    "question_no": 15,
    "domain_id": 2,
    "select_count": 1,
    "title": "[D2-15] RDS MySQL 읽기 전용 리포트 부하 분리 — Read Replica 활용",
    "question_text": "A company runs an application on an Amazon RDS for MySQL DB instance. Read-heavy reporting queries run throughout the day and slow down the application's writes. A CloudOps engineer must reduce the load on the primary DB instance. The reports can use slightly stale data.\n\nWhich solution will meet these requirements with the LEAST operational overhead?",
    "options": [
      "Create a read replica of the DB instance. Update the reporting queries to use the read replica's endpoint.",
      "Convert the DB instance to a Multi-AZ deployment. Send the reporting queries to the standby instance.",
      "Increase the automated backup retention period. Run the reporting queries against the latest snapshot.",
      "Restore a new DB instance from a snapshot each day. Run the reporting queries against the new DB instance."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "RDS Read Replica, Read Offloading, Asynchronous Replication",
    "explanation": "정답: A (읽기 전용 쿼리가 쓰기 성능을 저하시킬 때 Multi-AZ가 아닌 Read Replica로 분리)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A read replica is a read-only copy that Amazon RDS updates asynchronously. Routing read queries to it reduces the load on the primary, and the small replication lag is acceptable for reports.\n• (B) [❌ 오답] The standby in a Multi-AZ DB instance deployment cannot serve read traffic. It exists for high availability.\n• (C) [❌ 오답] A snapshot cannot be queried directly, and a longer retention period does not reduce the load on the primary.\n• (D) [❌ 오답] This can work, but it needs a daily restore process and leaves the data up to a day old, which is more work than a read replica.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-15) — 읽기 전용 쿼리가 쓰기 성능을 저하시킬 때 Multi-AZ가 아닌 Read Replica로 분리"
  },
  {
    "round_id": 3,
    "question_no": 16,
    "domain_id": 2,
    "select_count": 2,
    "title": "[D2-21] EC2 기반 Amazon ECS 서비스 + 클러스터 용량 동시 오토스케일링 (2개 선택)",
    "question_text": "A company has an Amazon ECS service that runs on an Auto Scaling group of Amazon EC2 container instances. During peaks, the service needs more tasks, but new tasks stay in the PROVISIONING state because the cluster has no free capacity.\n\nWhich combination of steps will let the service scale automatically? (Select TWO.)",
    "options": [
      "Configure ECS service auto scaling with a target tracking policy on CPU.",
      "Use a capacity provider with managed scaling for the Auto Scaling group.",
      "Raise the desired task count of the service to the peak value permanently.",
      "Change the task placement strategy from spread to binpack on memory only.",
      "Enable the deployment circuit breaker for the service in the cluster."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "ECS Service Auto Scaling, Capacity Provider, Managed Scaling",
    "explanation": "정답: A, B (태스크 확장(ECS Service Auto Scaling) + 인프라 EC2 확장(Capacity Provider Managed Scaling) 결합)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Service auto scaling uses Application Auto Scaling to change the desired number of tasks based on metrics such as average CPU, so the service adds tasks during peaks.\n• (B) [✅ 정답] A capacity provider with managed scaling scales the Auto Scaling group based on the capacity that tasks need. Tasks that are waiting for capacity cause the group to add instances so that the tasks can be placed.\n• (C) [❌ 오답] A permanently high task count wastes capacity at quiet times and still needs instances to run the tasks.\n• (D) [❌ 오답] Binpack can fit tasks more tightly, but it cannot place tasks when the cluster is full.\n• (E) [❌ 오답] The circuit breaker rolls back failed deployments. It does not add tasks or instances.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-21) — 태스크 확장(ECS Service Auto Scaling) + 인프라 EC2 확장(Capacity Provider Managed Scaling) 결합"
  },
  {
    "round_id": 3,
    "question_no": 17,
    "domain_id": 2,
    "select_count": 1,
    "title": "[D2-27] ALB 장애 시 S3 정적 점검 페이지로 자동 DNS 장애조치 (Route 53)",
    "question_text": "A company runs its primary web application behind an Application Load Balancer. Users must see a static maintenance page that is hosted in Amazon S3 whenever the application becomes unavailable. The switch must happen automatically.\n\nWhich Amazon Route 53 configuration will meet these requirements?",
    "options": [
      "Failover routing: a primary alias to the ALB with Evaluate Target Health, and a secondary record for the S3 site",
      "Weighted routing that sends 90% of traffic to the ALB and 10% to the S3 site, with no health checks on either record",
      "Latency-based routing with one record for the ALB and one record for the S3 site in the same AWS Region",
      "Multivalue answer routing that returns both the ALB and the S3 site"
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Route 53 Failover, Evaluate Target Health, S3 Static Website",
    "explanation": "정답: A (ALB Alias 레코드에 Evaluate Target Health=Yes 설정 + Secondary Failover S3 버킷 구성)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Failover routing answers with the primary record while it is healthy and with the secondary record when it is not. An alias record to the ALB with Evaluate Target Health uses the load balancer's target health, so Route 53 switches to the S3 maintenance page when the application is down.\n• (B) [❌ 오답] Weighted routing without health checks keeps sending 90% of users to the failed ALB, and it sends 10% to the maintenance page even when the site is healthy.\n• (C) [❌ 오답] Latency routing picks the record with the lowest latency. Both records are in one Region, and nothing here switches traffic based on health.\n• (D) [❌ 오답] Multivalue answer returns several records for clients to try. It is not designed to show a maintenance page only during failures, and clients could pick it while the site is up.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-27) — ALB Alias 레코드에 Evaluate Target Health=Yes 설정 + Secondary Failover S3 버킷 구성"
  },
  {
    "round_id": 3,
    "question_no": 18,
    "domain_id": 2,
    "select_count": 1,
    "title": "[D2-29] S3 크로스 리전 재해 복구(CRR) 자동 복제 및 버전 관리",
    "question_text": "A company keeps critical documents in an Amazon S3 bucket in us-east-1. For disaster recovery, a copy of every new object must be stored automatically in a bucket in eu-west-1.\n\nWhich solution will meet this requirement with the LEAST operational overhead?",
    "options": [
      "Enable versioning on both buckets. Create an S3 Replication rule on the source bucket that targets the eu-west-1 bucket.",
      "Create an AWS Lambda function that copies each object. Invoke the function from an event notification on the source bucket.",
      "Create an AWS Backup plan for the source bucket. Run a weekly copy job to a backup vault in eu-west-1.",
      "Run the aws s3 sync command from an Amazon EC2 instance. Schedule the command by using a cron job on the instance."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "S3 Versioning, Cross-Region Replication, CRR, Disaster Recovery",
    "explanation": "정답: A (S3 CRR 활성화를 위해 양쪽 버킷 모두 Versioning 활성화 필수)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] S3 Replication copies new objects to the destination automatically. Both buckets must have versioning enabled, and Amazon S3 needs an IAM role with replication permissions. To copy objects that already exist, use S3 Batch Replication.\n• (B) [❌ 오답] This can work, but the company would have to write and maintain code for retries, large objects, and failures. Replication handles these without custom code.\n• (C) [❌ 오답] A weekly copy job leaves up to a week of new objects without a copy in the second Region.\n• (D) [❌ 오답] An instance with a cron job must be patched and monitored, and new objects wait until the next run.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-29) — S3 CRR 활성화를 위해 양쪽 버킷 모두 Versioning 활성화 필수"
  },
  {
    "round_id": 3,
    "question_no": 19,
    "domain_id": 2,
    "select_count": 1,
    "title": "[D2-30] RDS Multi-AZ 장애조치 후 애플리케이션 재연결 지연(DNS 캐싱) 원인",
    "question_text": "A company has an application that connects to an Amazon RDS for MySQL Multi-AZ DB instance by using the DB endpoint. During a test failover, Amazon RDS promotes the standby within 60 seconds, but the application continues to fail for 20 minutes until it is restarted.\n\nWhat is the MOST likely cause of this issue?",
    "options": [
      "The application caches the DNS lookup of the endpoint for longer than the record's TTL.",
      "The standby instance is in a different DB subnet group that the application cannot reach.",
      "The standby needs 20 minutes to replay transaction logs before it accepts connections.",
      "Multi-AZ failover creates a new endpoint name that the application must be updated to use."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "RDS Multi-AZ Failover, DNS Caching, TTL",
    "explanation": "정답: A (RDS 엔드포인트는 장애조치 시 IP가 바뀌므로 JVM/앱 DNS 캐싱 TTL을 짧게(예: 60초 미만) 유지해야 함)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] During a Multi-AZ failover, RDS updates the endpoint's DNS record to point to the new primary. The endpoint name stays the same, but an application or runtime that caches DNS results for too long keeps connecting to the old address. Honoring the short TTL, or connecting through RDS Proxy, shortens recovery.\n• (B) [❌ 오답] The primary and standby are in the same DB subnet group and VPC, so the application's network path is the same.\n• (C) [❌ 오답] The standby is kept current with synchronous replication, and the scenario says the promotion finished within 60 seconds.\n• (D) [❌ 오답] The endpoint name does not change during a Multi-AZ failover. Only the IP address behind it changes.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-30) — RDS 엔드포인트는 장애조치 시 IP가 바뀌므로 JVM/앱 DNS 캐싱 TTL을 짧게(예: 60초 미만) 유지해야 함"
  },
  {
    "round_id": 3,
    "question_no": 20,
    "domain_id": 2,
    "select_count": 2,
    "title": "[D2-38] 태그 기반 EBS·RDS·DynamoDB 통합 일일 백업 및 교차 리전 복사 (2개 선택)",
    "question_text": "A company must back up every Amazon EBS volume, Amazon RDS database, and Amazon DynamoDB table that has the tag Backup=Daily. Backups must be kept for 35 days, and a copy must be stored in a second AWS Region. New resources that get the tag must be included automatically.\n\nWhich combination of steps will meet these requirements with the LEAST operational overhead? (Select TWO.)",
    "options": [
      "Create an AWS Backup plan with a daily rule, 35-day retention, and a copy action to a vault in the second Region.",
      "Assign resources to the backup plan by using the Backup=Daily tag.",
      "Create an Amazon EventBridge schedule that invokes an AWS Lambda function to snapshot each tagged resource every day.",
      "Use Amazon Data Lifecycle Manager for all three resource types, with a cross-Region copy rule.",
      "Configure Amazon S3 Cross-Region Replication for the bucket where AWS Backup stores the recovery points."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "AWS Backup, Backup Plan, Tag Assignment, Cross-Region Copy",
    "explanation": "정답: A, B (이종 리소스 통합 백업 + 태그 자동 할당 + 35일 보존/타 리전 복사는 AWS Backup Plan)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] An AWS Backup plan defines when backups run and how long they are kept. A copy action sends each recovery point to a backup vault in another Region, with its own retention.\n• (B) [✅ 정답] Tag-based resource assignment includes every supported resource that has the tag, including resources created later, so no one has to update the plan.\n• (C) [❌ 오답] Custom snapshot code must be built and maintained for each resource type, and it still needs separate retention and copy logic.\n• (D) [❌ 오답] Data Lifecycle Manager manages EBS snapshots and EBS-backed AMIs. It does not back up RDS databases or DynamoDB tables.\n• (E) [❌ 오답] AWS Backup stores recovery points in backup vaults, not in an S3 bucket that you manage, so there is no bucket to replicate.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-38) — 이종 리소스 통합 백업 + 태그 자동 할당 + 35일 보존/타 리전 복사는 AWS Backup Plan"
  },
  {
    "round_id": 3,
    "question_no": 21,
    "domain_id": 2,
    "select_count": 1,
    "title": "[D2-46] 실수로 WHERE 없는 DELETE 실행 시 RDS 특정 시점 복구(PITR)",
    "question_text": "A company has a production Amazon RDS for MySQL database. At 14:05, a developer accidentally ran a DELETE statement without a WHERE clause. Automated backups are enabled with a 7-day retention period. The company needs the data as it was at 14:04.\n\nWhat should a CloudOps engineer do to meet this requirement?",
    "options": [
      "Restore the DB instance to a point in time of 14:04 as a new DB instance. Point the application to it.",
      "Restore the most recent daily automated snapshot onto the existing DB instance to overwrite its current data.",
      "Promote the Multi-AZ standby instance, because the standby still has the data from before 14:05.",
      "Create a read replica of the DB instance. Promote the replica to recover the data from before 14:05."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "RDS PITR, Point-in-Time Recovery, Restore DB Instance",
    "explanation": "정답: A (실수 삭제 1분 전 상태로 새 DB 인스턴스로 PITR 복구 후 검증·교체)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Point-in-time restore uses automated backups and transaction logs to create a new DB instance at any second within the retention period, up to about 5 minutes before the current time. A restore always creates a new instance, so the application must be pointed to the new endpoint, or the instances must be renamed.\n• (B) [❌ 오답] RDS restores always create a new DB instance. You cannot restore a snapshot onto an existing instance, and a daily snapshot would lose more data.\n• (C) [❌ 오답] The standby is synchronously replicated, so the DELETE was applied to it as well.\n• (D) [❌ 오답] A new replica copies the current data, which already has the rows deleted.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d2-46) — 실수 삭제 1분 전 상태로 새 DB 인스턴스로 PITR 복구 후 검증·교체"
  },
  {
    "round_id": 3,
    "question_no": 22,
    "domain_id": 3,
    "select_count": 1,
    "title": "[D3-01] 수동 골든 AMI 빌드 자동화 — EC2 Image Builder 파이프라인",
    "question_text": "A company builds its golden AMI manually each month. A CloudOps engineer launches an Amazon EC2 instance; installs patches, the Amazon CloudWatch agent, and security hardening; creates an AMI; and copies the AMI to three AWS Regions. The process takes a day and sometimes misses steps.\n\nWhich solution will automate this process with the LEAST operational overhead?",
    "options": [
      "Create an EC2 Image Builder pipeline with a recipe, test components, a monthly schedule, and distribution to the three Regions.",
      "Write an AWS Lambda function that launches an instance, runs a script with Run Command, creates an AMI, and copies it to each Region.",
      "Create an Auto Scaling group whose user data installs everything. Create an AMI from the newest instance each month.",
      "Use AWS CloudFormation to launch an instance each month with cfn-init. Create the AMI manually after the stack completes."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "EC2 Image Builder, Golden AMI, Automated Testing, Distribution",
    "explanation": "정답: A (월간 골든 AMI 패치·보안 강화·테스트·배포 자동화 = EC2 Image Builder)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] EC2 Image Builder automates building, testing, and distributing images. A recipe lists the base image and components such as patching, the CloudWatch agent, and hardening. Test components validate the image, a schedule runs the pipeline monthly, and distribution settings copy the AMI to other Regions and accounts.\n• (B) [❌ 오답] This works, but it is custom code that must handle failures, testing, and cleanup, which Image Builder already provides.\n• (C) [❌ 오답] Creating AMIs from running instances is not repeatable or tested, and running the install in user data adds boot time to every launch.\n• (D) [❌ 오답] The AMI step is still manual, and there is no built-in testing or multi-Region distribution.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-01) — 월간 골든 AMI 패치·보안 강화·테스트·배포 자동화 = EC2 Image Builder"
  },
  {
    "round_id": 3,
    "question_no": 23,
    "domain_id": 3,
    "select_count": 1,
    "title": "[D3-07] 프로덕션 RDS 포함 CloudFormation 업데이트 전 교체 여부 사전 확인",
    "question_text": "A CloudOps engineer needs to update a production AWS CloudFormation stack that contains an Amazon RDS DB instance. Before the update runs, the CloudOps engineer must confirm that no resource will be replaced.\n\nWhat should the CloudOps engineer do to meet this requirement?",
    "options": [
      "Create a change set. Review the Replacement value for each resource before executing it.",
      "Run drift detection on the stack, and check whether the database shows a status of MODIFIED.",
      "Update the stack directly with termination protection enabled.",
      "Delete the stack with a Retain deletion policy. Create a new stack from the updated template."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudFormation Change Set, Replacement Value, Safe Update",
    "explanation": "정답: A (프로덕션 스택 변경 전 Change Set으로 Replacement=True 여부 반드시 사전 검토)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A change set shows how an update will change each resource before anything happens, including whether each resource will be replaced (True, False, or Conditional). The engineer can review it and execute it only if it is safe.\n• (B) [❌ 오답] Drift detection compares resources with the current template. It does not preview the changes in a new template.\n• (C) [❌ 오답] Termination protection prevents the whole stack from being deleted. It does not stop an update from replacing a resource.\n• (D) [❌ 오답] Deleting and re-creating the stack is risky and unnecessary just to preview changes.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-07) — 프로덕션 스택 변경 전 Change Set으로 Replacement=True 여부 반드시 사전 검토"
  },
  {
    "round_id": 3,
    "question_no": 24,
    "domain_id": 3,
    "select_count": 1,
    "title": "[D3-12] cfn-init 메타데이터 변경 시 기존 실행 중 EC2 인스턴스 자동 반영",
    "question_text": "A company launches Amazon EC2 instances by using an AWS CloudFormation stack. The instances are configured by cfn-init from AWS::CloudFormation::Init metadata. A CloudOps engineer changes a configuration file in the metadata and updates the stack, but the running instances do not get the new file.\n\nWhat should the CloudOps engineer do so that running instances apply metadata changes automatically?",
    "options": [
      "Run the cfn-hup daemon on the instances to detect metadata changes and rerun cfn-init.",
      "Add the configuration file to the user data to run it again on every stack update.",
      "Enable drift detection to make CloudFormation push the new file to the instances.",
      "Add an UpdatePolicy to the instances to make cfn-init read the metadata on each boot."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "cfn-hup, cfn-init, CloudFormation Metadata Update",
    "explanation": "정답: A (CloudFormation::Init 변경을 실행 중인 인스턴스에 주기적으로 반영하려면 cfn-hup 데몬 사용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] cfn-hup is a helper daemon that polls the resource metadata for changes. When it detects a change, it runs the actions in its hooks, typically cfn-init, so running instances apply the new configuration without being replaced.\n• (B) [❌ 오답] User data runs only at first launch by default, so changing it does not update running instances.\n• (C) [❌ 오답] Drift detection reports differences. It does not change resources or push files.\n• (D) [❌ 오답] UpdatePolicy applies to resources such as Auto Scaling groups during updates. It does not make instances rerun cfn-init.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-12) — CloudFormation::Init 변경을 실행 중인 인스턴스에 주기적으로 반영하려면 cfn-hup 데몬 사용"
  },
  {
    "round_id": 3,
    "question_no": 25,
    "domain_id": 3,
    "select_count": 1,
    "title": "[D3-29] AWS Organizations 미사용 환경에서 10개 계정에 StackSets 배포",
    "question_text": "A company does not use AWS Organizations. A CloudOps engineer needs to deploy an AWS CloudFormation template to 10 accounts by using a StackSet with self-managed permissions. The stack instances fail with an error that the StackSet could not assume a role in the target accounts.\n\nWhat should the CloudOps engineer do to resolve this issue?",
    "options": [
      "Create the AWSCloudFormationStackSetExecutionRole in each target account. Trust the administrator account.",
      "Configure trusted access for StackSets in AWS Organizations.",
      "Share the template with each target account through AWS RAM, and then retry the stack instances.",
      "Add the target account IDs to the template's Parameters section. Run the operation again."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "StackSets Self-Managed, AWSCloudFormationStackSetExecutionRole, Trust Policy",
    "explanation": "정답: A (Organizations 미사용 시 Self-managed 권한 모델과 Administration/Execution 역할 수동 구성 필요)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Self-managed StackSets need an administration role in the administrator account (AWSCloudFormationStackSetAdministrationRole) and an execution role in each target account (AWSCloudFormationStackSetExecutionRole) that trusts it. Without the execution role, StackSets cannot assume a role to create the stack.\n• (B) [❌ 오답] Trusted access and service-managed permissions require AWS Organizations, which the company does not use.\n• (C) [❌ 오답] StackSets does not need the template to be shared. The failure is about assuming a role.\n• (D) [❌ 오답] Target accounts are chosen when you create stack instances, not in template parameters, and this does not create the missing roles.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-29) — Organizations 미사용 시 Self-managed 권한 모델과 Administration/Execution 역할 수동 구성 필요"
  },
  {
    "round_id": 3,
    "question_no": 26,
    "domain_id": 3,
    "select_count": 1,
    "title": "[D3-42] 30개 계정·4개 리전 수천 대 EC2 누락 패치 일괄 스캔 (Organizations)",
    "question_text": "A company has thousands of Amazon EC2 instances in 30 accounts and 4 AWS Regions in AWS Organizations. The company must scan instances for missing patches daily and install approved security patches every Sunday, managed from one central configuration.\n\nWhich solution will meet these requirements with the LEAST operational overhead?",
    "options": [
      "Create a patch policy in Quick Setup for Patch Manager that targets the organization and its Regions.",
      "Create a maintenance window and a patch baseline in each account and Region. Register the instances as targets.",
      "Add a cron job to each instance's user data that runs the operating system package update command.",
      "Build a new AMI each Sunday with the latest patches, and replace every instance in the organization."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "SSM Quick Setup, Patch Manager, Multi-Account Patch Policy",
    "explanation": "정답: A (조직 전체 다중 계정/리전 EC2 패치 정책 중앙 관리는 SSM Quick Setup Patch Policy)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Patch policies, created through Quick Setup, configure Patch Manager scan and install schedules and patch baselines across an organization's accounts and Regions from one place.\n• (B) [❌ 오답] This works, but it must be built and maintained in 120 account and Region combinations.\n• (C) [❌ 오답] Cron jobs on each instance are hard to manage, give no compliance reporting, and do not use approved baselines.\n• (D) [❌ 오답] Replacing thousands of instances every week is disruptive and not feasible for every workload.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-42) — 조직 전체 다중 계정/리전 EC2 패치 정책 중앙 관리는 SSM Quick Setup Patch Policy"
  },
  {
    "round_id": 3,
    "question_no": 27,
    "domain_id": 3,
    "select_count": 1,
    "title": "[D3-44] 모든 EC2에 필수 보안 에이전트 상시 설치·실행 상태 유지 (드리프트 방지)",
    "question_text": "A company's policy requires a specific security agent to be installed and running on every Amazon EC2 instance. Engineers sometimes stop the agent while troubleshooting and forget to start it again.\n\nWhich solution will keep the agent in the required state automatically?",
    "options": [
      "Create a State Manager association that installs and starts the agent on a schedule.",
      "Run a Run Command document once to install the agent on all of the instances in the fleet.",
      "Add the agent installation to the AMI.",
      "Create an AWS Config rule that reports instances where the agent is not running."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "SSM State Manager, Association, Configuration Compliance",
    "explanation": "정답: A (인스턴스 상태를 주기적으로 점검·복원(에이전트 재시작)하는 선언적 도구 = SSM State Manager)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A State Manager association applies a document to targets on a schedule, such as every 30 minutes, and reports compliance. If someone stops the agent, the next run installs or starts it again.\n• (B) [❌ 오답] A one-time command installs the agent once but does not fix it when someone stops it later.\n• (C) [❌ 오답] Baking the agent into the AMI covers new instances, but it does not restart the agent on running instances.\n• (D) [❌ 오답] Config can report the problem, but reporting alone does not keep the agent running.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-44) — 인스턴스 상태를 주기적으로 점검·복원(에이전트 재시작)하는 선언적 도구 = SSM State Manager"
  },
  {
    "round_id": 3,
    "question_no": 28,
    "domain_id": 3,
    "select_count": 2,
    "title": "[D3-45] 인터넷·NAT 없는 프라이빗 서브넷 EC2의 SSM 관리 활성화 (2개 선택)",
    "question_text": "A CloudOps engineer launches Amazon EC2 instances in a private subnet that has no NAT gateway or other internet access. The instances use an AMI with SSM Agent preinstalled, but the instances do not appear as managed nodes in AWS Systems Manager Fleet Manager.\n\nWhich combination of steps will resolve this issue? (Select TWO.)",
    "options": [
      "Attach an instance profile that includes the AmazonSSMManagedInstanceCore policy.",
      "Create interface VPC endpoints for the Systems Manager services, such as ssm and ssmmessages.",
      "Open inbound port 22 on the instance security group from the Systems Manager service.",
      "Assign an Elastic IP address to each instance to allow Systems Manager to reach it.",
      "Install the Amazon CloudWatch agent to report each instance's status to Fleet Manager."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "AmazonSSMManagedInstanceCore, Interface VPC Endpoint, PrivateLink",
    "explanation": "정답: A, B (프라이빗 서브넷 SSM 통신에는 IAM Role(AmazonSSMManagedInstanceCore) + ssm/ssmmessages/ec2messages 엔드포인트 필요)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] SSM Agent needs AWS credentials with Systems Manager permissions, which the AmazonSSMManagedInstanceCore managed policy provides through an instance profile. Default Host Management Configuration is another way to provide them.\n• (B) [✅ 정답] SSM Agent connects outbound to Systems Manager endpoints over HTTPS. Without internet access, interface endpoints for ssm and ssmmessages (and ec2messages for older agent versions) give the agent a private path. The endpoint security group must allow HTTPS from the instances.\n• (C) [❌ 오답] Systems Manager does not connect inbound to instances, and it does not use SSH. The agent makes outbound connections.\n• (D) [❌ 오답] Elastic IP addresses do not help in a subnet with no route to an internet gateway, and Systems Manager does not need inbound access.\n• (E) [❌ 오답] The CloudWatch agent publishes metrics and logs. Managed node registration depends on SSM Agent, credentials, and network access.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-45) — 프라이빗 서브넷 SSM 통신에는 IAM Role(AmazonSSMManagedInstanceCore) + ssm/ssmmessages/ec2messages 엔드포인트 필요"
  },
  {
    "round_id": 3,
    "question_no": 29,
    "domain_id": 3,
    "select_count": 2,
    "title": "[D3-52] 단일 S3 버킷 객체 생성 이벤트의 다중 팀(Lambda·SQS·SNS) 팬아웃 (2개 선택)",
    "question_text": "A company has an Amazon S3 bucket. When objects are created in the bucket, three teams must each process them: one with an AWS Lambda function, one with an AWS Step Functions workflow, and one through an Amazon SQS queue. The third team needs only objects larger than 1 GB.\n\nWhich combination of steps will meet these requirements with the LEAST operational overhead? (Select TWO.)",
    "options": [
      "Configure Amazon EventBridge notifications for the bucket.",
      "Create Amazon EventBridge rules for each team, with a size filter in the pattern for the team that needs it.",
      "Create three S3 Event Notifications with the same event type and prefix, one for each target.",
      "Write a Lambda function that receives each S3 event and forwards it to the other two targets.",
      "Configure S3 Replication to three buckets, one for each team. Configure events on each copy."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "S3 EventBridge Notifications, Fan-out, Multiple Rules",
    "explanation": "정답: A, B (단일 S3 이벤트 필터 충돌 회피 및 다중 타겟 라우팅에는 S3 → EventBridge 통합이 최적)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] When EventBridge notifications are enabled, Amazon S3 sends the bucket's events to the default event bus, where many rules can use them.\n• (B) [✅ 정답] EventBridge rules can match fields in the event, such as the object size with a numeric filter, and each rule can send to targets such as Lambda, Step Functions, and SQS. Each team gets its own routing without code.\n• (C) [❌ 오답] S3 Event Notifications cannot have overlapping configurations for the same event type and prefix, and they cannot filter by object size.\n• (D) [❌ 오답] A forwarding function is custom code to maintain and a single point of failure.\n• (E) [❌ 오답] Replicating every object three times adds storage cost and delay just to send events to three teams.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-52) — 단일 S3 이벤트 필터 충돌 회피 및 다중 타겟 라우팅에는 S3 → EventBridge 통합이 최적"
  },
  {
    "round_id": 3,
    "question_no": 30,
    "domain_id": 3,
    "select_count": 2,
    "title": "[D3-64] CloudFormation 프로덕션 변경 사전 검토 및 콘솔 수동 변경(드리프트) 감시 (2개 선택)",
    "question_text": "A company manages its production infrastructure with AWS CloudFormation. The company requires a review of the exact resource changes before any stack update is applied. The company also must identify each day any manual changes that were made outside CloudFormation.\n\nWhich combination of steps will meet these requirements? (Select TWO.)",
    "options": [
      "Create a change set for each update. Review the change set before executing it.",
      "Deploy the cloudformation-stack-drift-detection-check AWS Config managed rule.",
      "Enable termination protection on each stack. Review the stack events after each update.",
      "Apply a stack policy that denies all updates. Remove the policy during each planned update.",
      "Enable AWS CloudTrail Insights on the account's trail to detect manual resource changes."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "Change Set, Drift Detection, AWS Config cloudformation-stack-drift-detection-check",
    "explanation": "정답: A, B (사전 변경 확인(Change Set) + 사후 수동 변경 탐지(AWS Config Drift Detection 규칙))\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A change set shows how a stack update will change each resource, including replacements, before anything changes. You execute the change set only after the review.\n• (B) [✅ 정답] This managed rule runs drift detection on the stacks and marks a stack as noncompliant when its resources differ from the template. It runs on a periodic schedule, so manual changes are found each day.\n• (C) [❌ 오답] Termination protection stops a stack from being deleted. Stack events show what already happened, not what will change.\n• (D) [❌ 오답] A stack policy can block updates to resources, but it does not show which changes an update will make.\n• (E) [❌ 오답] CloudTrail Insights detects unusual rates of API calls. It does not compare resources with a template.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-64) — 사전 변경 확인(Change Set) + 사후 수동 변경 탐지(AWS Config Drift Detection 규칙)"
  },
  {
    "round_id": 4,
    "question_no": 1,
    "domain_id": 3,
    "select_count": 1,
    "title": "[D3-43] Patch Manager 보안 패치 14일 승인 유예 및 자동 설치 차단 규칙",
    "question_text": "A company uses AWS Systems Manager Patch Manager. Security updates must be installed on production Linux instances only after the updates have been available for 7 days, so that problems can be found in testing first. Patches must then be approved automatically.\n\nHow should a CloudOps engineer configure Patch Manager to meet these requirements?",
    "options": [
      "Create a custom patch baseline with a rule that auto-approves security patches 7 days after release.",
      "Use the default predefined patch baseline. Schedule the patch installation to run every 7 days.",
      "Create a patch group that excludes patches from the last 7 days by listing each one as rejected.",
      "Configure Amazon Inspector, and patch only CVEs that Amazon Inspector has reported for at least 7 days."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Custom Patch Baseline, Auto-approval Delay, Patch Group",
    "explanation": "정답: A (검증 유예 기간이 필요할 때는 기본 베이스라인 대신 ApproveAfterDays=14 커스텀 베이스라인 생성)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Patch baseline approval rules can auto-approve patches by classification and severity a set number of days after they are released. A 7-day delay for security patches gives time for testing before production installs them.\n• (B) [❌ 오답] Running the installation every 7 days does not delay approval. A patch released the day before could still be installed.\n• (C) [❌ 오답] Rejecting each new patch by hand is constant manual work and easy to get wrong.\n• (D) [❌ 오답] Inspector finds vulnerabilities but does not control patch approval timing, and this would still need a patching process.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-43) — 검증 유예 기간이 필요할 때는 기본 베이스라인 대신 ApproveAfterDays=14 커스텀 베이스라인 생성"
  },
  {
    "round_id": 4,
    "question_no": 2,
    "domain_id": 3,
    "select_count": 1,
    "title": "[D3-47] 온프레미스 Linux 서버 300대를 AWS Systems Manager 하이브리드로 통합 관리",
    "question_text": "A company needs to patch and run commands on 300 on-premises Linux servers by using the same AWS Systems Manager tools that it uses for its Amazon EC2 instances.\n\nWhat should a CloudOps engineer do to meet this requirement?",
    "options": [
      "Create a hybrid activation. Install SSM Agent on each server with the activation code and ID.",
      "Attach an EC2 instance profile to each on-premises server to give SSM Agent role credentials.",
      "Install the Amazon CloudWatch agent on each server. Send Run Command documents through CloudWatch.",
      "Open inbound port 443 on each server to allow Systems Manager to push commands to the servers."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "SSM Hybrid Activation, Managed Nodes, SSM Agent",
    "explanation": "정답: A (온프레미스 서버를 SSM으로 패치·Run Command 관리하려면 Hybrid Activation 생성 및 SSM Agent 등록)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A hybrid activation creates an activation code and ID that are tied to an IAM service role. Installing SSM Agent with them registers each server as a managed node, so Run Command, Patch Manager, and the other tools work the same way as they do on EC2.\n• (B) [❌ 오답] Instance profiles exist only for EC2 instances. On-premises servers get credentials through a hybrid activation.\n• (C) [❌ 오답] The CloudWatch agent collects metrics and logs. It does not run Systems Manager commands.\n• (D) [❌ 오답] SSM Agent makes outbound HTTPS connections to Systems Manager. Systems Manager does not push commands through inbound ports.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-47) — 온프레미스 서버를 SSM으로 패치·Run Command 관리하려면 Hybrid Activation 생성 및 SSM Agent 등록"
  },
  {
    "round_id": 4,
    "question_no": 3,
    "domain_id": 3,
    "select_count": 2,
    "title": "[D3-58] 신규 EC2 생성 즉시 생성자 IAM ID 자동 태깅 (EventBridge + Lambda) (2개 선택)",
    "question_text": "A company's finance team needs every new Amazon EC2 instance to be tagged with the IAM identity of the person who launched it, within minutes of launch, no matter how the instance was launched. AWS CloudTrail is enabled in the account.\n\nWhich combination of steps will meet this requirement? (Select TWO.)",
    "options": [
      "Create an Amazon EventBridge rule that matches the RunInstances event from AWS API Call via CloudTrail.",
      "Target an AWS Lambda function that reads userIdentity from the event and tags the new instances.",
      "Require every user to add an Owner tag in the console launch wizard before launching an instance.",
      "Run an AWS Config rule once a day that tags instances with the name of the account's root user.",
      "Add a user data script to the launch template that tags each instance with its instance profile."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "EventBridge, RunInstances, CloudTrail API Call, Auto-Tagging Lambda",
    "explanation": "정답: A, B (CloudTrail RunInstances 이벤트 → EventBridge → Lambda가 userIdentity를 읽어 EC2 자동 태깅)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] EventBridge receives CloudTrail management events as AWS API Call via CloudTrail events. A rule on ec2:RunInstances matches every launch, whether it comes from the console, the CLI, an SDK, or infrastructure as code.\n• (B) [✅ 정답] The event's userIdentity field shows who made the call, and responseElements lists the new instance IDs. A Lambda function can call CreateTags with that identity.\n• (C) [❌ 오답] Relying on users is not reliable, and it does not cover launches from the CLI, SDKs, or automation.\n• (D) [❌ 오답] The root user is not the person who launched the instance, and a daily rule does not tag within minutes.\n• (E) [❌ 오답] The instance profile identifies the instance's role, not the person who launched it, and not every launch uses this template.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d3-58) — CloudTrail RunInstances 이벤트 → EventBridge → Lambda가 userIdentity를 읽어 EC2 자동 태깅"
  },
  {
    "round_id": 4,
    "question_no": 4,
    "domain_id": 4,
    "select_count": 1,
    "title": "[D4-02] EC2 내 하드코딩된 IAM 액세스 키 제거 — IAM Role 전환",
    "question_text": "A company has an application on an Amazon EC2 instance that reads objects from an Amazon S3 bucket. The developers stored an IAM user's access keys in the application's configuration file. A security review flags this as a risk.\n\nWhich solution will remove this risk in the MOST secure manner?",
    "options": [
      "Attach an IAM role with read access to the bucket through an instance profile. Delete the keys.",
      "Encrypt the configuration file with AWS KMS.",
      "Move the access keys into environment variables on the instance. Remove them from the file.",
      "Rotate the access keys every 90 days. Store the new keys in the same configuration file."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "IAM Role, Instance Profile, Temporary Credentials, IMDS",
    "explanation": "정답: A (EC2 내 장기 액세스 키 저장 금지 → Instance Profile을 통한 IAM Role 임시 자격증명 사용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] An instance profile gives the application temporary credentials that rotate automatically through the instance metadata service. The SDK picks them up with no keys in files, and the long-lived keys can be deleted.\n• (B) [❌ 오답] The application still has to decrypt and use long-lived keys, so the keys can still leak and never expire.\n• (C) [❌ 오답] Environment variables still hold long-lived keys that can leak through logs or process listings.\n• (D) [❌ 오답] Rotation limits how long a key is exposed, but the keys are still long-lived and stored on the instance.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-02) — EC2 내 장기 액세스 키 저장 금지 → Instance Profile을 통한 IAM Role 임시 자격증명 사용"
  },
  {
    "round_id": 4,
    "question_no": 5,
    "domain_id": 4,
    "select_count": 2,
    "title": "[D4-09] AWS 계정 루트 사용자(Root User) 보안 강화 조치 (2개 선택)",
    "question_text": "A company's security review finds that the root user of an AWS account has active access keys and no MFA device. Administrators sign in through AWS IAM Identity Center for their daily work.\n\nWhich combination of steps follows AWS best practices? (Select TWO.)",
    "options": [
      "Delete the access keys for the root user.",
      "Configure MFA for the root user.",
      "Rotate the root user's access keys every 90 days.",
      "Store the root user's access keys in AWS Secrets Manager.",
      "Attach a permissions boundary to the root user."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "Root User Access Keys, MFA, AWS Account Security",
    "explanation": "정답: A, B (루트 사용자 액세스 키 즉시 삭제 + 하드웨어/가상 MFA 활성화)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Root user access keys grant unrestricted access to the account and should not exist. Delete them, and use roles for programmatic access.\n• (B) [✅ 정답] MFA protects the most powerful identity in the account from a stolen password. In AWS Organizations, centralized root access management can also remove root credentials from member accounts.\n• (C) [❌ 오답] Rotation shortens how long a key is valid, but the root user should have no access keys at all.\n• (D) [❌ 오답] Storing the keys more safely still leaves long-lived root credentials that should not exist.\n• (E) [❌ 오답] Permissions boundaries apply to IAM users and roles. They cannot limit the root user.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-09) — 루트 사용자 액세스 키 즉시 삭제 + 하드웨어/가상 MFA 활성화"
  },
  {
    "round_id": 4,
    "question_no": 6,
    "domain_id": 4,
    "select_count": 1,
    "title": "[D4-11] 프로덕션 IAM 역할에 정책 부착 전 권한 영향 사전 검증 도구",
    "question_text": "A CloudOps engineer needs to attach a new IAM policy to a production role. Before attaching the policy, the CloudOps engineer must confirm that the role will be allowed to call s3:PutObject on one bucket and denied on all other buckets. The check must account for the SCPs and permissions boundary that apply to the role.\n\nWhich tool should the CloudOps engineer use?",
    "options": [
      "The IAM policy simulator",
      "AWS Trusted Advisor checks",
      "Amazon Inspector findings",
      "AWS Config rule evaluations"
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "IAM Policy Simulator, Least Privilege, Policy Testing",
    "explanation": "정답: A (실제 프로덕션 역할 변경 없이 허용/거부 여부를 테스트하려면 IAM Policy Simulator 사용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] The IAM policy simulator tests identity-based policies, permissions boundaries, resource-based policies, and SCPs against chosen actions and resources. It shows whether each request would be allowed or denied without making real requests.\n• (B) [❌ 오답] Trusted Advisor checks for best practices, such as unrestricted security groups. It does not evaluate specific policy decisions.\n• (C) [❌ 오답] Inspector finds software vulnerabilities and network exposure. It does not test IAM policies.\n• (D) [❌ 오답] Config evaluates resource configurations against rules. It does not simulate API authorization.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-11) — 실제 프로덕션 역할 변경 없이 허용/거부 여부를 테스트하려면 IAM Policy Simulator 사용"
  },
  {
    "round_id": 4,
    "question_no": 7,
    "domain_id": 4,
    "select_count": 1,
    "title": "[D4-12] 조직 내 S3·KMS·IAM·Lambda 외부 공유 발생 시 즉시 보안팀 알림",
    "question_text": "A company's security team must be notified whenever an Amazon S3 bucket, AWS KMS key, IAM role, or AWS Lambda function in any of the organization's accounts is shared with a principal outside the organization.\n\nWhich solution will meet this requirement with the LEAST operational overhead?",
    "options": [
      "Create an organization external access analyzer in IAM Access Analyzer. Route findings to Amazon SNS with Amazon EventBridge.",
      "Write a Lambda function that reads every resource policy each hour and compares the principals with the organization.",
      "Configure Amazon GuardDuty in every account, and alert on findings that show data being read from S3 buckets.",
      "Use AWS Trusted Advisor to check bucket permissions weekly, and email the results to the security team."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "IAM Access Analyzer, Organization Analyzer, External Access",
    "explanation": "정답: A (교차 계정/퍼블릭 외부 접근 정책 변경 감시는 Organization IAM Access Analyzer + EventBridge)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] An external access analyzer that uses the organization as its zone of trust analyzes resource-based policies and reports findings for resources shared outside the organization. Findings are sent to EventBridge, so a rule can notify the team through Amazon SNS.\n• (B) [❌ 오답] This is custom code that must understand complex policy logic for many resource types.\n• (C) [❌ 오답] GuardDuty detects threats from activity. It does not analyze resource policies for external sharing.\n• (D) [❌ 오답] The Trusted Advisor check covers only S3 bucket permissions, and a weekly email is not timely.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-12) — 교차 계정/퍼블릭 외부 접근 정책 변경 감시는 Organization IAM Access Analyzer + EventBridge"
  },
  {
    "round_id": 4,
    "question_no": 8,
    "domain_id": 4,
    "select_count": 2,
    "title": "[D4-21] 승인된 CostCenter 태그 값만 허용하고 미부착 EC2 생성 차단 (2개 선택)",
    "question_text": "A company's finance team requires every new Amazon EC2 instance to have a CostCenter tag with one of five approved values. Launches that do not include a valid tag must be blocked in all accounts in the organization.\n\nWhich combination of steps will meet these requirements? (Select TWO.)",
    "options": [
      "Create a tag policy that defines CostCenter and its allowed values, with enforcement for EC2 instances.",
      "Create an SCP that denies ec2:RunInstances when aws:RequestTag/CostCenter is missing.",
      "Create an AWS Config rule that deletes instances without a CostCenter tag once a day.",
      "Ask each team to add the CostCenter tag in the console when they launch instances.",
      "Enable cost allocation tags in the Billing console for the CostCenter tag key only."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "Organizations Tag Policy, SCP, aws:RequestTag, ec2:RunInstances",
    "explanation": "정답: A, B (Tag Policy(허용 값 표준화) + SCP Deny(aws:RequestTag 누락 시 RunInstances 차단) 결합)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Tag policies standardize tag keys and values across the organization. With enforcement enabled for a resource type, a request that sets the tag to a value that is not allowed is blocked.\n• (B) [✅ 정답] Tag policies do not block resources that are created without the tag. An SCP that denies ec2:RunInstances when the aws:RequestTag/CostCenter key is null makes the tag required at launch.\n• (C) [❌ 오답] Deleting instances after they launch is disruptive, and it does not block the launch.\n• (D) [❌ 오답] A request to teams is not enforced, and it does not cover the CLI or automation.\n• (E) [❌ 오답] Cost allocation tags make tags appear in billing reports. They do not require or validate tags.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-21) — Tag Policy(허용 값 표준화) + SCP Deny(aws:RequestTag 누락 시 RunInstances 차단) 결합"
  },
  {
    "round_id": 4,
    "question_no": 9,
    "domain_id": 4,
    "select_count": 1,
    "title": "[D4-22] AWS Organizations 내 모든 계정 애플리케이션만 S3 버킷 읽기 허용",
    "question_text": "A company stores shared reports in an Amazon S3 bucket. Applications in every account in the company's organization in AWS Organizations must be able to read the reports, and no one outside the organization can have access. New accounts are added often.\n\nWhich solution will meet these requirements with the LEAST operational overhead?",
    "options": [
      "Add a bucket policy that allows s3:GetObject when aws:PrincipalOrgID matches the organization ID.",
      "Add a bucket policy that lists the ID of every member account. Update it for each new account.",
      "Create an IAM role in the bucket's account. Have the applications in each account assume it.",
      "Disable S3 Block Public Access. Allow s3:GetObject for all principals in the bucket policy."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "S3 Bucket Policy, aws:PrincipalOrgID, Organizations Condition Key",
    "explanation": "정답: A (조직 전체 계정에 버킷 접근을 일괄 허용하려면 Bucket Policy Condition에 aws:PrincipalOrgID 사용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] The aws:PrincipalOrgID condition key checks that the caller belongs to the organization, so new accounts are covered automatically and no account list is needed. Roles in other accounts still need IAM permissions to read the bucket. Resource control policies (RCPs) can enforce a similar boundary across many resources.\n• (B) [❌ 오답] An account list works, but someone must update it every time an account is added, which is the overhead the company wants to avoid.\n• (C) [❌ 오답] A shared role adds setup in every account and changes how each application reaches the reports.\n• (D) [❌ 오답] This makes the bucket public, so anyone on the internet could read the reports.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-22) — 조직 전체 계정에 버킷 접근을 일괄 허용하려면 Bucket Policy Condition에 aws:PrincipalOrgID 사용"
  },
  {
    "round_id": 4,
    "question_no": 10,
    "domain_id": 4,
    "select_count": 1,
    "title": "[D4-23] SSH 배스천 호스트 및 키 페어 제거 — SSM Session Manager 전환",
    "question_text": "A company uses a bastion host with SSH keys to administer Amazon EC2 instances in private subnets. The company's security team must remove the bastion host and all inbound SSH rules. The security team also needs a record of each session.\n\nWhich solution will meet these requirements with the LEAST operational overhead?",
    "options": [
      "Use AWS Systems Manager Session Manager with an instance profile on each instance. Send session logs to Amazon S3.",
      "Move the bastion host to a public subnet. Restrict inbound SSH to the office IP range, and log each SSH command.",
      "Use Amazon EC2 Instance Connect to push temporary SSH keys. Keep inbound port 22 open to the VPC CIDR block.",
      "Create an AWS Site-to-Site VPN connection to the VPC. Allow inbound SSH from the on-premises network to the instances."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "SSM Session Manager, Zero Bastion, CloudTrail Audit, S3 Session Logging",
    "explanation": "정답: A (포트 22·배스천·SSH 키 없이 IAM 제어 및 명령어 로깅까지 제공하는 Session Manager가 표준)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Session Manager needs no open inbound ports, no bastion hosts, and no SSH keys. Access is controlled through IAM, and session logs can go to Amazon S3 or Amazon CloudWatch Logs. The instances need an instance profile with the AmazonSSMManagedInstanceCore policy.\n• (B) [❌ 오답] This keeps the bastion host and the inbound SSH rules, which the security team must remove.\n• (C) [❌ 오답] Instance Connect avoids long-term keys, but it still uses SSH and an inbound rule on port 22.\n• (D) [❌ 오답] A VPN changes the network path, but the inbound SSH rules and SSH keys remain.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-23) — 포트 22·배스천·SSH 키 없이 IAM 제어 및 명령어 로깅까지 제공하는 Session Manager가 표준"
  },
  {
    "round_id": 4,
    "question_no": 11,
    "domain_id": 4,
    "select_count": 2,
    "title": "[D4-36] S3 버킷 데이터 등급(Public/Internal/Confidential) ABAC 접근 제어 (2개 선택)",
    "question_text": "A company is implementing a data classification scheme. Every Amazon S3 bucket must be labeled Public, Internal, or Confidential, and only the security team can read Confidential buckets. The company also must detect buckets that have no label.\n\nWhich combination of steps will meet these requirements? (Select TWO.)",
    "options": [
      "Tag each bucket with a DataClassification key, and find missing tags with the AWS Config required-tags rule.",
      "Use bucket policies or tag-based conditions that let only the security team's roles read Confidential buckets.",
      "Record each bucket's classification in a spreadsheet, and review it with the security team every quarter.",
      "Encrypt Confidential buckets with SSE-S3 to allow only the security team to decrypt the objects.",
      "Enable S3 Versioning for Confidential buckets to stop other users from reading the objects."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "ABAC, Resource Tags, Bucket Policy, Tag-based Access Control",
    "explanation": "정답: A, B (버킷 태깅 + 보안 주체/버킷 태그 조건 기반 ABAC 정책으로 분류 등급별 접근 통제)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Tags are a common way to label resources with their classification. The AWS Config required-tags managed rule reports buckets that are missing the DataClassification key, so missing labels are found continuously.\n• (B) [✅ 정답] Access controls based on the classification, such as a bucket policy or a condition on aws:ResourceTag/DataClassification, make sure that only the security team's roles can read Confidential data. Encryption with a customer managed KMS key adds another layer.\n• (C) [❌ 오답] A spreadsheet is not linked to the resources and goes out of date quickly.\n• (D) [❌ 오답] S3 manages SSE-S3 keys for every authorized user, so SSE-S3 does not limit who can read the objects.\n• (E) [❌ 오답] Versioning keeps object versions. It does not restrict who can read objects.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-36) — 버킷 태깅 + 보안 주체/버킷 태그 조건 기반 ABAC 정책으로 분류 등급별 접근 통제"
  },
  {
    "round_id": 4,
    "question_no": 12,
    "domain_id": 4,
    "select_count": 2,
    "title": "[D4-39] 리전 내 모든 신규 EBS 기본 암호화 활성화 및 기존 미암호화 볼륨 암호화 전환 (2개 선택)",
    "question_text": "A company needs every new Amazon EBS volume in an AWS Region to be encrypted automatically. The company also has an unencrypted data volume, attached to a running instance, that must be encrypted.\n\nWhich combination of steps will meet these requirements? (Select TWO.)",
    "options": [
      "Enable EBS encryption by default for the account in the Region.",
      "Snapshot the volume, create an encrypted volume from it, and swap the volumes.",
      "Run the modify-volume command with the encrypted option on the existing volume.",
      "Attach an IAM policy that denies the creation of unencrypted EBS volumes only.",
      "Enable Amazon S3 default encryption for the bucket that stores the EBS snapshots."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "EBS Default Encryption, Encrypted Snapshot Copy, KMS",
    "explanation": "정답: A, B (계정 리전 단위 EBS 기본 암호화 설정 + 기존 볼륨은 스냅샷 → 암호화 복사/복원 절차 필요)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] EBS encryption by default is a Regional account setting. After it is enabled, all new volumes and snapshot copies in the Region are encrypted with the default KMS key or a key that you choose.\n• (B) [✅ 정답] An existing volume cannot be encrypted in place. Creating an encrypted volume from a snapshot, and then attaching it in place of the old volume, encrypts the data. The switch needs a short planned stop for the data volume.\n• (C) [❌ 오답] Elastic Volumes can change size, type, and performance, but it cannot encrypt an existing volume.\n• (D) [❌ 오답] A deny policy blocks unencrypted volumes, but it does not encrypt anything automatically, and it does nothing for the existing volume.\n• (E) [❌ 오답] EBS snapshots are not stored in a bucket that you manage, so S3 bucket settings do not apply.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-39) — 계정 리전 단위 EBS 기본 암호화 설정 + 기존 볼륨은 스냅샷 → 암호화 복사/복원 절차 필요"
  },
  {
    "round_id": 4,
    "question_no": 13,
    "domain_id": 4,
    "select_count": 2,
    "title": "[D4-45] ALB HTTP(80)에서 ACM SSL/TLS 적용 및 HTTPS(443) 자동 리다이렉트 (2개 선택)",
    "question_text": "A company runs a public website behind an Application Load Balancer that has only an HTTP listener on port 80. The company must serve all traffic over HTTPS with a free certificate that renews automatically. Users who type http:// must be sent to HTTPS.\n\nWhich combination of steps will meet these requirements? (Select TWO.)",
    "options": [
      "Request a public ACM certificate with DNS validation. Add an HTTPS listener on port 443 that uses it.",
      "Change the port 80 listener's default action to redirect requests to HTTPS on port 443.",
      "Install a self-signed certificate on each Amazon EC2 instance. Keep the ALB listener on port 80.",
      "Import a certificate bought from a third-party CA into ACM, and renew it manually every year.",
      "Add a rule to the ALB security group that blocks inbound port 80 traffic from the internet."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "AWS Certificate Manager, ALB HTTPS Listener, HTTP to HTTPS Redirect",
    "explanation": "정답: A, B (ACM DNS 검증 인증서 발급 후 443 리스너 부착 + 80 리스너를 443 Redirect 액션으로 변경)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Public ACM certificates are free, and ACM renews DNS-validated certificates automatically as long as the validation CNAME record stays in place. An HTTPS listener on the ALB terminates TLS with the certificate.\n• (B) [✅ 정답] A listener rule with a redirect action returns an HTTP 301 response to the HTTPS URL, so users who type http:// are moved to HTTPS.\n• (C) [❌ 오답] Browsers do not trust self-signed certificates, and the ALB would still serve plain HTTP to users.\n• (D) [❌ 오답] Imported certificates cost money from the CA and are not renewed automatically by ACM.\n• (E) [❌ 오답] Security groups cannot block traffic from the internet with a deny rule, and blocking port 80 would break users who type http:// instead of redirecting them.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d4-45) — ACM DNS 검증 인증서 발급 후 443 리스너 부착 + 80 리스너를 443 Redirect 액션으로 변경"
  },
  {
    "round_id": 4,
    "question_no": 14,
    "domain_id": 5,
    "select_count": 1,
    "title": "[D5-01] 프라이빗 서브넷 EC2 인터넷 통신 실패 — NAT Gateway 라우팅 오류 진단",
    "question_text": "A company has Amazon EC2 instances in a private subnet that cannot download operating system updates from the internet. A NAT gateway was created in the same private subnet, and the private subnet's route table sends 0.0.0.0/0 to that NAT gateway.\n\nWhat should a CloudOps engineer do to resolve this issue?",
    "options": [
      "Create the NAT gateway in a public subnet that routes to an internet gateway. Point the private route at it.",
      "Assign an Elastic IP address to each instance in the private subnet.",
      "Add an inbound rule to the instance security group that allows all traffic from 0.0.0.0/0 on every port.",
      "Change the private subnet's route for 0.0.0.0/0 to the VPC's local route instead of to the NAT gateway."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "NAT Gateway, Public Subnet, Route Table 0.0.0.0/0",
    "explanation": "정답: A (NAT Gateway 자체가 프라이빗 서브넷에 있거나 0.0.0.0/0 → IGW 경로가 없으면 인터넷 불가)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A public zonal NAT gateway must be in a public subnet whose route table sends 0.0.0.0/0 to an internet gateway. A NAT gateway inside the private subnet has no path to the internet, so its traffic goes nowhere. A regional NAT gateway is another option that does not need a public subnet.\n• (B) [❌ 오답] Instances in a subnet without a route to an internet gateway cannot use public IP addresses to reach the internet, and the design is meant to keep them private.\n• (C) [❌ 오답] Security groups are stateful, so return traffic for outbound requests is already allowed. Opening inbound access adds risk and does not create a route.\n• (D) [❌ 오답] The local route covers only traffic within the VPC's CIDR range. It cannot send traffic to the internet.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-01) — NAT Gateway 자체가 프라이빗 서브넷에 있거나 0.0.0.0/0 → IGW 경로가 없으면 인터넷 불가"
  },
  {
    "round_id": 4,
    "question_no": 15,
    "domain_id": 5,
    "select_count": 1,
    "title": "[D5-02] IGW 라우팅이 있는 퍼블릭 서브넷 웹 서버 접속 불가 원인 (퍼블릭 IP 누락)",
    "question_text": "A CloudOps engineer launches a web server on an Amazon EC2 instance in a subnet whose route table sends 0.0.0.0/0 to an internet gateway. The instance's security group allows HTTP from 0.0.0.0/0. Users still cannot reach the server from the internet.\n\nWhat is the MOST likely cause of this issue?",
    "options": [
      "The instance does not have a public IPv4 address or an Elastic IP address.",
      "The subnet's default network ACL allows all inbound and outbound traffic.",
      "The VPC does not have a NAT gateway for inbound traffic from the internet.",
      "The security group needs an outbound rule that allows the HTTP responses."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Internet Gateway, Public IPv4, Elastic IP, Public Subnet",
    "explanation": "정답: A (IGW가 연결된 서브넷이라도 인스턴스에 퍼블릭 IPv4 또는 EIP가 없으면 인터넷 통신 불가)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] An instance needs a public IPv4 address or an Elastic IP address to be reached from the internet through an internet gateway. If auto-assign public IP is disabled for the subnet, the instance has only a private address.\n• (B) [❌ 오답] The default network ACL allows all traffic, so it would not block the users.\n• (C) [❌ 오답] NAT gateways are for outbound connections from private subnets. They do not accept inbound connections from the internet.\n• (D) [❌ 오답] Security groups are stateful, so responses to allowed inbound requests are allowed automatically.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-02) — IGW가 연결된 서브넷이라도 인스턴스에 퍼블릭 IPv4 또는 EIP가 없으면 인터넷 통신 불가"
  },
  {
    "round_id": 4,
    "question_no": 16,
    "domain_id": 5,
    "select_count": 2,
    "title": "[D5-10] 프라이빗 서브넷 대용량 S3 업로드 시 NAT Gateway 비용 절감 및 버킷 제한 (2개 선택)",
    "question_text": "A company has applications in private subnets that upload large amounts of data to Amazon S3 in the same AWS Region through a NAT gateway. NAT gateway data processing charges are high. The company's security team also requires this path to reach only the company's own buckets.\n\nWhich combination of steps will meet these requirements? (Select TWO.)",
    "options": [
      "Create a gateway VPC endpoint for S3. Associate it with the private subnets' route tables.",
      "Attach an endpoint policy that allows access only to the company's bucket ARNs.",
      "Create an interface VPC endpoint for S3 in each subnet to remove all charges for S3 traffic.",
      "Move the NAT gateway to a larger size to process data at a lower price per GB.",
      "Enable S3 Transfer Acceleration to make uploads bypass the NAT gateway automatically."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "S3 Gateway VPC Endpoint, Endpoint Policy, NAT Gateway Cost",
    "explanation": "정답: A, B (무료 S3 Gateway Endpoint + Endpoint Policy로 지정 버킷만 허용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] A gateway endpoint for S3 adds a route that uses the S3 prefix list, so traffic to S3 in the Region bypasses the NAT gateway. Gateway endpoints have no hourly or data processing charge.\n• (B) [✅ 정답] Endpoint policies control which actions and resources can be reached through the endpoint. Allowing only the company's bucket ARNs stops data from being sent to other buckets through this path.\n• (C) [❌ 오답] Interface endpoints for S3 have hourly and data processing charges. They are useful for on-premises access, but the gateway endpoint is the cheaper fix here.\n• (D) [❌ 오답] NAT gateways do not have sizes, and data processing is charged per GB.\n• (E) [❌ 오답] Transfer Acceleration uses edge locations and still sends traffic from private subnets through the NAT gateway, and it adds charges.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-10) — 무료 S3 Gateway Endpoint + Endpoint Policy로 지정 버킷만 허용"
  },
  {
    "round_id": 4,
    "question_no": 17,
    "domain_id": 5,
    "select_count": 1,
    "title": "[D5-12] CIDR이 겹치는 200개 고객 VPC에 TCP SaaS 서비스 노출 — AWS PrivateLink",
    "question_text": "A SaaS company must offer a TCP service to 200 customer VPCs in other AWS accounts. Many customer VPCs use CIDR blocks that overlap with the company's VPC. Customers must not get access to any other resources in the company's VPC.\n\nWhich solution will meet these requirements?",
    "options": [
      "Put the service behind a Network Load Balancer, and share it as a PrivateLink endpoint service.",
      "Create a VPC peering connection with each customer VPC. Add routes to the service subnet.",
      "Attach every customer VPC to a shared transit gateway. Add routes to the service subnet.",
      "Give the service a public IP address, and ask customers to reach it through their NAT gateways."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "AWS PrivateLink, Network Load Balancer, VPC Endpoint Service, Overlapping CIDR",
    "explanation": "정답: A (CIDR 중복 회피 + 단방향 대규모 SaaS 노출 = NLB + VPC Endpoint Service(PrivateLink))\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] AWS PrivateLink exposes a service behind a Network Load Balancer as an endpoint service. Customers create interface endpoints in their own VPCs, traffic flows only to the service, and overlapping CIDR blocks do not matter because there is no routing between the VPCs.\n• (B) [❌ 오답] VPC peering does not work with overlapping CIDR blocks, and peering gives broader network access than one service.\n• (C) [❌ 오답] Transit Gateway routing also fails with overlapping CIDR blocks, and it exposes more of the network.\n• (D) [❌ 오답] Public exposure sends traffic over the internet and opens the service to anyone who can reach it.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-12) — CIDR 중복 회피 + 단방향 대규모 SaaS 노출 = NLB + VPC Endpoint Service(PrivateLink)"
  },
  {
    "round_id": 4,
    "question_no": 18,
    "domain_id": 5,
    "select_count": 1,
    "title": "[D5-14] Transit Gateway 연결 30개 VPC 간 Prod/Dev 격리 및 Shared VPC 통신",
    "question_text": "A company connects 30 VPCs to a transit gateway. Production VPCs must not be able to reach development VPCs, but every VPC must be able to reach a shared services VPC.\n\nHow should a CloudOps engineer configure the transit gateway to meet these requirements?",
    "options": [
      "Use separate TGW route tables for production and development that both propagate the shared VPC.",
      "Use one TGW route table for every attachment, and block the traffic with network ACLs in each of the VPCs.",
      "Create a separate transit gateway for each VPC, and peer every transit gateway with each other.",
      "Disable default route table association, and leave the attachments without any route tables."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Transit Gateway Route Table, Network Segmentation, Hub-and-Spoke",
    "explanation": "정답: A (TGW Route Table을 Prod/Dev/Shared 용도로 분리해 VPC 간 통신 격리 제어)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Transit gateway route tables control which attachments can reach each other. Production attachments associate with a production route table and development attachments with a development route table. Each of these tables has routes to the shared services VPC but not to the other environment, and the shared services table has routes to both.\n• (B) [❌ 오답] A single route table lets every VPC reach every other VPC, and maintaining network ACLs in 30 VPCs is error prone.\n• (C) [❌ 오답] Thirty transit gateways and a full mesh of peering connections add cost and complexity.\n• (D) [❌ 오답] Attachments without route tables cannot route traffic at all, so no VPC could reach the shared services VPC.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-14) — TGW Route Table을 Prod/Dev/Shared 용도로 분리해 VPC 간 통신 격리 제어"
  },
  {
    "round_id": 4,
    "question_no": 19,
    "domain_id": 5,
    "select_count": 1,
    "title": "[D5-16] AWS Site-to-Site VPN 유지보수 시 연결 끊김 방지 — Dual Tunnel + BGP",
    "question_text": "A company uses AWS Site-to-Site VPN with static routing, and only one of the two tunnels is configured on its customer gateway device. During AWS maintenance on that tunnel, the company lost connectivity.\n\nWhich solution will provide automatic failover between the tunnels?",
    "options": [
      "Configure both tunnels on the customer gateway. Use BGP dynamic routing for failover.",
      "Create a second customer gateway in AWS that points to the same IP address of the device.",
      "Replace the VPN with a VPC peering connection to the on-premises network for redundancy.",
      "Enable acceleration for the VPN."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Site-to-Site VPN, Dual Tunnel, BGP Dynamic Routing",
    "explanation": "정답: A (AWS VPN은 항상 2개 터널 제공 — 양쪽 터널 모두 설정 및 BGP 동적 라우팅으로 무중단 전환)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Each Site-to-Site VPN connection has two tunnels that terminate on different AWS endpoints for redundancy. Configuring both tunnels and using BGP lets traffic move to the healthy tunnel automatically during maintenance or a failure.\n• (B) [❌ 오답] A second customer gateway resource with the same IP address does not add a tunnel on the device, so the single-tunnel problem remains.\n• (C) [❌ 오답] VPC peering connects VPCs only. It cannot connect to an on-premises network.\n• (D) [❌ 오답] Accelerated VPN improves performance through AWS Global Accelerator. It does not keep a tunnel up during maintenance.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-16) — AWS VPN은 항상 2개 터널 제공 — 양쪽 터널 모두 설정 및 BGP 동적 라우팅으로 무중단 전환"
  },
  {
    "round_id": 4,
    "question_no": 20,
    "domain_id": 5,
    "select_count": 2,
    "title": "[D5-24] 퍼블릭 IPv4 유료화 이후 VPC 공용 IP 비용 절감 방안 (2개 선택)",
    "question_text": "A company's VPC costs increased after AWS began to charge for all public IPv4 addresses. The company has many Elastic IP addresses that are not associated with any resource. The company also has many instances with public IP addresses that are reached only through a load balancer.\n\nWhich combination of steps will reduce these costs? (Select TWO.)",
    "options": [
      "Release the Elastic IP addresses that are not associated with any resource.",
      "Move instances behind the load balancer to private subnets without public IPs.",
      "Replace each public IPv4 address with a second Elastic IP address on the instance.",
      "Enable auto-assign public IPv4 addresses for every subnet in the VPC by default.",
      "Move the load balancer into private subnets."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "Public IPv4 Cost, Unassociated Elastic IP, Private Subnets behind ALB",
    "explanation": "정답: A, B (미연결 EIP 해제(유휴 IP 과금) + ALB 뒤 EC2를 프라이빗 서브넷으로 이동해 공용 IP 제거)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] AWS charges for every public IPv4 address, whether it is in use or idle. Releasing Elastic IP addresses that are not associated with anything removes their charge. IPAM public IP insights can help find them.\n• (B) [✅ 정답] Instances that are reached only through a load balancer do not need public addresses. Placing them in private subnets, with NAT for outbound access if needed, removes their public IPv4 charges and reduces exposure.\n• (C) [❌ 오답] Elastic IP addresses are also public IPv4 addresses and are charged the same way.\n• (D) [❌ 오답] Auto-assigning public addresses adds more public IPv4 addresses and more cost.\n• (E) [❌ 오답] An internet-facing load balancer must be in public subnets with public addresses to receive internet traffic, so this would take the site offline.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-24) — 미연결 EIP 해제(유휴 IP 과금) + ALB 뒤 EC2를 프라이빗 서브넷으로 이동해 공용 IP 제거"
  },
  {
    "round_id": 4,
    "question_no": 21,
    "domain_id": 5,
    "select_count": 1,
    "title": "[D5-25] S3 대용량 동영상 글로벌 전송 시 데이터 전송(DTO) 비용 및 지연 절감",
    "question_text": "A media company serves large video files directly from an Amazon S3 bucket to viewers around the world. Data transfer out from Amazon S3 to the internet is the largest item on the bill, and many viewers request the same files.\n\nWhich solution will reduce data transfer costs?",
    "options": [
      "Serve the files through an Amazon CloudFront distribution with the S3 bucket as its origin.",
      "Enable S3 Transfer Acceleration to send downloads through the AWS edge network.",
      "Move the files to S3 Glacier Instant Retrieval to lower the cost of each download.",
      "Create S3 Replication copies in three Regions. Let viewers pick the nearest one."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Amazon CloudFront, Edge Caching, S3 Data Transfer Out Cost",
    "explanation": "정답: A (CloudFront 엣지 캐싱으로 S3→CloudFront 무료 전송 + CloudFront→인터넷 저렴한 DTO 단가 활용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Data transfer from Amazon S3 to CloudFront is free, and CloudFront serves repeated requests from edge caches. CloudFront data transfer out pricing is usually lower than S3 data transfer to the internet, so caching popular files reduces cost and improves performance.\n• (B) [❌ 오답] Transfer Acceleration adds a per-GB charge on top of normal data transfer, so it increases cost.\n• (C) [❌ 오답] Glacier Instant Retrieval lowers storage cost but adds retrieval charges, and data transfer out is still charged.\n• (D) [❌ 오답] Extra copies add storage and replication costs, and downloads still incur S3 data transfer out charges.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-25) — CloudFront 엣지 캐싱으로 S3→CloudFront 무료 전송 + CloudFront→인터넷 저렴한 DTO 단가 활용"
  },
  {
    "round_id": 4,
    "question_no": 22,
    "domain_id": 5,
    "select_count": 1,
    "title": "[D5-37] S3 정적 웹사이트 직접 URL 우회 차단 — CloudFront OAC",
    "question_text": "A company serves a static website from an Amazon S3 bucket through an Amazon CloudFront distribution. Users can also download files directly from the bucket's URL, which bypasses CloudFront and its AWS WAF rules. The bucket uses SSE-KMS encryption.\n\nHow should a CloudOps engineer make the files reachable only through CloudFront?",
    "options": [
      "Use origin access control. Allow only the distribution's ARN in the bucket policy and key policy.",
      "Configure S3 static website hosting. Allow public read access only for the CloudFront edge IP ranges.",
      "Use an origin access identity. Disable Block Public Access.",
      "Add a CloudFront geo restriction that blocks every country except the countries where the users live."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "CloudFront OAC, Origin Access Control, S3 Block Public Access",
    "explanation": "정답: A (OAC(Origin Access Control)를 적용하고 S3 버킷 정책에서 해당 CloudFront 배포만 허용)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Origin access control (OAC) lets CloudFront sign its requests to the S3 origin. A bucket policy that allows the cloudfront.amazonaws.com service principal only when AWS:SourceArn is the distribution's ARN blocks direct access. OAC supports SSE-KMS, so the key policy must also allow the distribution.\n• (B) [❌ 오답] Public read access, even if it is scoped to IP ranges, keeps the bucket publicly reachable and is hard to maintain.\n• (C) [❌ 오답] Origin access identity is the legacy method and does not support SSE-KMS, and disabling Block Public Access is unnecessary and risky.\n• (D) [❌ 오답] Geo restriction applies to requests that go through CloudFront. It does not stop direct requests to the bucket.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-37) — OAC(Origin Access Control)를 적용하고 S3 버킷 정책에서 해당 CloudFront 배포만 허용"
  },
  {
    "round_id": 4,
    "question_no": 23,
    "domain_id": 5,
    "select_count": 2,
    "title": "[D5-41] CloudFront + WAF 우회해 ALB 직접 접속 차단 2가지 방법 (2개 선택)",
    "question_text": "A company uses an Application Load Balancer (ALB) as the origin for an Amazon CloudFront distribution that has AWS WAF rules. Users can bypass CloudFront by calling the ALB's DNS name directly. The ALB must accept only requests that come through this distribution.\n\nWhich combination of steps will meet these requirements? (Select TWO.)",
    "options": [
      "Allow inbound traffic on the ALB security group only from the CloudFront managed prefix list.",
      "Have CloudFront add a secret custom header. Add an ALB listener rule that requires it.",
      "Enable access logs for the ALB, and block direct callers manually when they show up in the logs.",
      "Configure cross-zone load balancing.",
      "Add a CloudFront geo restriction that blocks the countries where most direct requests come from."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "CloudFront Managed Prefix List, Custom Origin Header, ALB Listener Rule",
    "explanation": "정답: A, B (ALB SG에 CloudFront Managed Prefix List만 허용 + CloudFront 비밀 커스텀 헤더 검증)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] The AWS-managed prefix list com.amazonaws.global.cloudfront.origin-facing contains the IP ranges that CloudFront uses to reach origins. Allowing only that prefix list blocks direct requests from other sources.\n• (B) [✅ 정답] The prefix list covers every CloudFront distribution, including distributions that other customers own. A secret header that only your distribution adds, checked by an ALB listener rule, makes sure that requests come through your distribution. CloudFront VPC origins, which keep the ALB in private subnets, are another option.\n• (C) [❌ 오답] Blocking callers by hand after the fact is slow and does not prevent the bypass.\n• (D) [❌ 오답] Cross-zone load balancing spreads traffic across targets. It does not restrict who can reach the ALB.\n• (E) [❌ 오답] Geo restriction applies only to requests that come through CloudFront, so it does not affect direct calls to the ALB.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-41) — ALB SG에 CloudFront Managed Prefix List만 허용 + CloudFront 비밀 커스텀 헤더 검증"
  },
  {
    "round_id": 4,
    "question_no": 24,
    "domain_id": 5,
    "select_count": 2,
    "title": "[D5-50] CloudFront 배포 후 main.js 구버전 캐시 잔존 해결 전략 (2개 선택)",
    "question_text": "A company deploys updates to main.js in the Amazon S3 origin of an Amazon CloudFront distribution. After a deployment, many users still receive the old version for up to 24 hours, which is the file's TTL. Users must get new versions right after each deployment from now on.\n\nWhich combination of steps will meet this requirement? (Select TWO.)",
    "options": [
      "Create a CloudFront invalidation for /main.js right after the current deployment.",
      "Use versioned file names, such as main.3f2a1c.js. Update the HTML references.",
      "Enable S3 Versioning for the origin bucket to make CloudFront fetch the newest version.",
      "Increase the default TTL to 7 days to make CloudFront check the origin less often.",
      "Enable CloudFront standard logging to remove stale objects from the edge locations."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "CloudFront Invalidation, Cache Busting, Versioned Filenames",
    "explanation": "정답: A, B (즉시 무효화(Invalidation) 또는 파일명 버저닝(main.hash.js)으로 캐시 정합성 확보)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] An invalidation removes the cached object from edge caches, so the next request fetches the new file from the origin. It fixes the current deployment, and invalidation paths beyond the monthly free allowance are charged.\n• (B) [✅ 정답] Versioned file names give each release a new URL that is not in any cache, so users get the new file at once while long TTLs stay in place. This is the recommended long-term approach.\n• (C) [❌ 오답] S3 Versioning keeps object versions in the bucket. CloudFront still serves its cached copy until the TTL expires.\n• (D) [❌ 오답] A longer TTL makes stale content last even longer.\n• (E) [❌ 오답] Logging records requests. It does not remove anything from the cache.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d5-50) — 즉시 무효화(Invalidation) 또는 파일명 버저닝(main.hash.js)으로 캐시 정합성 확보"
  },
  {
    "round_id": 4,
    "question_no": 25,
    "domain_id": 6,
    "select_count": 1,
    "title": "[D1-48] Compute Optimizer 메모리 미분석 문제 해결 — CloudWatch Agent 설치",
    "question_text": "A company needs to right-size 200 Amazon EC2 instances. AWS Compute Optimizer marks many of the instances as over-provisioned. However, the application team says that the workloads are memory-bound and would fail on smaller instances.\n\nWhat should a CloudOps engineer do to get more accurate recommendations?",
    "options": [
      "Install the Amazon CloudWatch agent to publish memory utilization.",
      "Enable detailed monitoring on the instances.",
      "Switch the instances to burstable performance types.",
      "Export the recommendations to Amazon S3, and remove instances with high memory use from the results."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Compute Optimizer, CloudWatch Agent, Memory Right-sizing",
    "explanation": "정답: A (EC2 메모리 기반 적정 크기 추천을 받으려면 CloudWatch Agent 메모리 수집 필수)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] By default, Compute Optimizer analyzes metrics that EC2 provides, such as CPU and network, and it cannot see memory. When the CloudWatch agent publishes memory utilization, Compute Optimizer uses it and stops recommending smaller instances for memory-bound workloads. Enhanced infrastructure metrics can also extend the lookback period to 3 months.\n• (B) [❌ 오답] Compute Optimizer already uses CPU data. More frequent CPU data does not tell it about memory pressure.\n• (C) [❌ 오답] Changing instance families just to collect a different metric could hurt performance, and it still would not provide memory data.\n• (D) [❌ 오답] Filtering results by hand is manual work and does not make the remaining recommendations any more accurate.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-48) — EC2 메모리 기반 적정 크기 추천을 받으려면 CloudWatch Agent 메모리 수집 필수"
  },
  {
    "round_id": 4,
    "question_no": 26,
    "domain_id": 6,
    "select_count": 1,
    "title": "[D1-51] 1,000 GiB gp2 볼륨 수백 개를 중단 없이 gp3로 전환해 20% 비용 절감",
    "question_text": "A company has hundreds of 1,000 GiB gp2 Amazon EBS volumes. Each volume delivers its baseline of 3,000 IOPS, which the workloads need. The company must reduce storage costs without downtime and without reducing performance.\n\nWhat should a CloudOps engineer do to meet these requirements?",
    "options": [
      "Change each volume to gp3 in place by using Elastic Volumes.",
      "Create snapshots. Restore each one as a new sc1 volume.",
      "Change each volume to io2 in place by using Elastic Volumes.",
      "Stop each instance, and attach a new st1 volume as the root."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "EBS gp2 to gp3, Elastic Volumes, 3000 IOPS Baseline",
    "explanation": "정답: A (gp3는 기본 3,000 IOPS 제공 + Elastic Volumes로 무중단 타입 변경 시 스토리지 단가 약 20% 절감)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] gp3 costs about 20% less per GiB than gp2 and includes 3,000 IOPS and 125 MiB/s at any size. Elastic Volumes changes the volume type while the volume stays attached and in use, so there is no downtime. If you set no performance values, EBS matches the higher of the source gp2 performance and the gp3 baseline.\n• (B) [❌ 오답] sc1 is cold HDD storage with low throughput, and it is not designed for random IOPS, so performance would drop sharply.\n• (C) [❌ 오답] io2 provides provisioned IOPS and high durability, but it costs more than gp2 for this workload.\n• (D) [❌ 오답] st1 cannot be used as a boot volume, and HDD volumes do not suit random I/O.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-51) — gp3는 기본 3,000 IOPS 제공 + Elastic Volumes로 무중단 타입 변경 시 스토리지 단가 약 20% 절감"
  },
  {
    "round_id": 4,
    "question_no": 27,
    "domain_id": 6,
    "select_count": 1,
    "title": "[D1-52] 고성능 gp3(16,000 IOPS) 병목 원인 — EC2 인스턴스 EBS 대역폭 상한",
    "question_text": "A company runs a database on an m5.xlarge Amazon EC2 instance with a gp3 Amazon EBS volume that is provisioned for 16,000 IOPS and 1,000 MiB/s. Under heavy load, throughput levels off far below 1,000 MiB/s, and the VolumeQueueLength metric is high. The volume's metrics show that it is well below its provisioned limits.\n\nWhat should a CloudOps engineer do to improve throughput?",
    "options": [
      "Move the database to an instance type with higher EBS bandwidth.",
      "Increase the provisioned IOPS on the gp3 volume to 80,000.",
      "Configure fast snapshot restore for the volume's snapshots.",
      "Change the volume type from gp3 to st1 for higher throughput."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "EC2 EBS Bandwidth Limit, Instance Size, Nitro Instance",
    "explanation": "정답: A (볼륨 IOPS/Throughput이 충분해도 EC2 인스턴스 크기별 EBS 최대 대역폭을 초과하면 병목 발생)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Each instance type has a maximum EBS bandwidth and IOPS. When the instance limit is lower than the volume's provisioned performance, the instance becomes the bottleneck and I/O queues up. A larger or EBS-optimized instance type with more EBS bandwidth raises that ceiling.\n• (B) [❌ 오답] The volume is already below its provisioned limits, so more IOPS would not help. The instance cannot drive the volume any harder.\n• (C) [❌ 오답] Fast snapshot restore removes first-read latency on volumes created from snapshots. It does not raise ongoing throughput.\n• (D) [❌ 오답] st1 is an HDD volume for large sequential reads. It has higher latency and fewer IOPS, which does not suit a database.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-52) — 볼륨 IOPS/Throughput이 충분해도 EC2 인스턴스 크기별 EBS 최대 대역폭을 초과하면 병목 발생"
  },
  {
    "round_id": 4,
    "question_no": 28,
    "domain_id": 6,
    "select_count": 2,
    "title": "[D1-56] 20~80GB 대용량 영상 S3 업로드 실패 재시도 방지 및 불완전 업로드 비용 제거 (2개 선택)",
    "question_text": "A media company uploads video files of 20 GB to 80 GB from its data center to an Amazon S3 bucket. Uploads often fail partway through and restart from the beginning. The S3 bill also shows storage charges that are larger than the total size of the completed objects.\n\nWhich combination of steps will resolve these issues? (Select TWO.)",
    "options": [
      "Use multipart uploads to retry failed parts without restarting the whole file.",
      "Add a lifecycle rule that aborts incomplete multipart uploads after a few days.",
      "Upload each file with a single PUT request to store it as one complete object.",
      "Enable S3 Versioning to keep failed uploads as earlier versions of each object.",
      "Enable S3 Object Lock to prevent partial uploads from being deleted by mistake."
    ],
    "correct_indices": [
      0,
      1
    ],
    "core_keywords": "S3 Multipart Upload, AbortIncompleteMultipartUpload, S3 Lifecycle",
    "explanation": "정답: A, B (Multipart Upload로 부분 재전송 + Lifecycle 규칙으로 미완료 멀티파트 조각 자동 삭제)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Multipart upload splits a file into parts that are uploaded independently and in parallel. If a part fails, only that part is retried. Objects larger than 5 GB must use multipart upload, and AWS recommends it for objects larger than 100 MB.\n• (B) [✅ 정답] Parts from uploads that never complete are stored and billed until the upload is completed or aborted. A lifecycle rule with the AbortIncompleteMultipartUpload action deletes those leftover parts automatically.\n• (C) [❌ 오답] A single PUT request can upload at most 5 GB, so it cannot handle these files, and any failure would still restart the whole upload.\n• (D) [❌ 오답] Versioning applies to completed objects. It does not keep or resume failed uploads, and it can add storage cost.\n• (E) [❌ 오답] Object Lock prevents the deletion of object versions. It would not help uploads finish and could make extra storage permanent.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-56) — Multipart Upload로 부분 재전송 + Lifecycle 규칙으로 미완료 멀티파트 조각 자동 삭제"
  },
  {
    "round_id": 4,
    "question_no": 29,
    "domain_id": 6,
    "select_count": 1,
    "title": "[D1-60] 400TB S3 데이터 예측 불가 액세스 패턴 비용 최적화 — S3 Intelligent-Tiering",
    "question_text": "A company stores 400 TB of user-generated content in Amazon S3 Standard. Some objects are read heavily for months and others are never read again, and the pattern cannot be predicted. Reads must stay in milliseconds. The company must reduce storage costs without building analysis jobs.\n\nWhich solution will meet these requirements?",
    "options": [
      "Move the objects to S3 Intelligent-Tiering by using a lifecycle rule.",
      "Move all objects to S3 Glacier Deep Archive after 30 days with a lifecycle rule.",
      "Move all objects to S3 One Zone-IA after 30 days with a lifecycle rule.",
      "Use S3 Storage Lens to find cold prefixes. Move them to S3 Standard-IA manually each month."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "S3 Intelligent-Tiering, Automatic Tiering, Cost Optimization",
    "explanation": "정답: A (접근 빈도를 예측할 수 없는 대용량 데이터는 S3 Intelligent-Tiering으로 자동 계층 최적화)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] Intelligent-Tiering moves each object between access tiers based on its own access pattern and moves it back when it is read again. The automatic tiers keep millisecond reads, and there are no retrieval fees, which suits unpredictable access. A small monthly monitoring fee applies for each object.\n• (B) [❌ 오답] Deep Archive retrieval takes hours, which fails the millisecond requirement, and objects that are still read heavily would incur retrieval costs.\n• (C) [❌ 오답] One Zone-IA keeps data in one Availability Zone and charges for retrievals. Objects that are read heavily would cost more, and resilience would be lower.\n• (D) [❌ 오답] This is manual analysis and movement, which the company wants to avoid, and Standard-IA charges retrieval fees for objects that become popular again.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-60) — 접근 빈도를 예측할 수 없는 대용량 데이터는 S3 Intelligent-Tiering으로 자동 계층 최적화"
  },
  {
    "round_id": 4,
    "question_no": 30,
    "domain_id": 6,
    "select_count": 1,
    "title": "[D1-65] AWS Lambda 트래픽 급증 시 Aurora MySQL 커넥션 고갈 방지 — RDS Proxy",
    "question_text": "A company has an AWS Lambda function that connects to an Amazon Aurora MySQL database. During traffic spikes, thousands of function instances open new connections. The database reaches its max_connections limit, and requests fail with Too many connections errors.\n\nWhich solution will resolve this issue with the LEAST change to the application code?",
    "options": [
      "Create an Amazon RDS Proxy for the database. Change the function to connect to the proxy endpoint.",
      "Increase the max_connections parameter to the highest value allowed for the DB instance class.",
      "Set the function's reserved concurrency to 0 during spikes.",
      "Add an Aurora Replica. Send all of the function's connections to the cluster reader endpoint."
    ],
    "correct_indices": [
      0
    ],
    "core_keywords": "Amazon RDS Proxy, Connection Pooling, Serverless Scaling",
    "explanation": "정답: A (Lambda 동시 실행 폭증 시 DB 커넥션 풀 고갈 방지는 RDS Proxy 커넥션 풀링으로 해결)\n\n[보기별 상세 해설 (MIT Open Bank 원문 기반)]\n• (A) [✅ 정답] RDS Proxy pools and shares database connections, so many function instances reuse a smaller number of connections to the database. Only the connection endpoint changes in the function's configuration. The proxy can also use IAM authentication and Secrets Manager for credentials.\n• (B) [❌ 오답] A higher limit uses more database memory and only delays the problem, because each new connection still adds overhead.\n• (C) [❌ 오답] Reserved concurrency of 0 stops the function from running at all, so the requests would fail.\n• (D) [❌ 오답] A reader endpoint accepts read-only work. Writes from the function would fail, and the replica has its own connection limit.",
    "source": "MIT Open Bank (zghanw/aws-cloudops-engineer-associate)",
    "escalation_note": "MIT Open Bank (d1-65) — Lambda 동시 실행 폭증 시 DB 커넥션 풀 고갈 방지는 RDS Proxy 커넥션 풀링으로 해결"
  }
]


def format_answer_text(options, correct_indices):
    letters = ["A", "B", "C", "D", "E"]
    parts = [f"{letters[i]}. {options[i]}" for i in correct_indices]
    return "\n".join(parts)


def build_database():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE exam_rounds (
        round_id INTEGER PRIMARY KEY,
        round_code TEXT NOT NULL UNIQUE,
        round_title TEXT NOT NULL,
        exam_year INTEGER NOT NULL,
        agency TEXT NOT NULL,
        key_trend TEXT NOT NULL
    );
    """)

    cur.execute("""
    CREATE TABLE categories_domain (
        domain_id INTEGER PRIMARY KEY,
        domain_code TEXT NOT NULL UNIQUE,
        domain_name TEXT NOT NULL,
        weight_pct INTEGER NOT NULL,
        description TEXT NOT NULL
    );
    """)

    cur.execute("""
    CREATE TABLE categories_qtype (
        qtype_id INTEGER PRIMARY KEY,
        qtype_code TEXT NOT NULL UNIQUE,
        qtype_name TEXT NOT NULL,
        description TEXT NOT NULL
    );
    """)

    cur.execute("""
    CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY AUTOINCREMENT,
        round_id INTEGER NOT NULL REFERENCES exam_rounds(round_id),
        question_no INTEGER NOT NULL,
        domain_id INTEGER NOT NULL REFERENCES categories_domain(domain_id),
        qtype_id INTEGER NOT NULL REFERENCES categories_qtype(qtype_id),
        select_count INTEGER NOT NULL,
        title TEXT NOT NULL,
        question_text TEXT NOT NULL,
        options_json TEXT NOT NULL,
        correct_indices_json TEXT NOT NULL,
        answer_text TEXT NOT NULL,
        core_keywords TEXT NOT NULL,
        explanation TEXT NOT NULL,
        source TEXT NOT NULL,
        escalation_note TEXT NOT NULL,
        UNIQUE(round_id, question_no)
    );
    """)

    cur.execute("""
    CREATE TABLE domain_analytics (
        domain_id INTEGER PRIMARY KEY REFERENCES categories_domain(domain_id),
        domain_name TEXT NOT NULL,
        official_weight_pct INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        share_pct REAL NOT NULL,
        single_count INTEGER NOT NULL,
        multi_count INTEGER NOT NULL,
        round_appearances INTEGER NOT NULL,
        primary_topics TEXT NOT NULL
    );
    """)

    cur.execute("""
    CREATE VIEW v_questions_full AS
    SELECT q.question_id, r.round_id, r.round_code, r.round_title, r.exam_year, r.agency,
           q.question_no, d.domain_id, d.domain_code, d.domain_name, d.weight_pct,
           t.qtype_id, t.qtype_code, t.qtype_name, q.select_count,
           q.title, q.question_text, q.options_json, q.correct_indices_json,
           q.answer_text, q.core_keywords, q.explanation, q.source, q.escalation_note
    FROM questions q
    JOIN exam_rounds r ON q.round_id = r.round_id
    JOIN categories_domain d ON q.domain_id = d.domain_id
    JOIN categories_qtype t ON q.qtype_id = t.qtype_id;
    """)

    cur.executemany("INSERT INTO exam_rounds VALUES (?, ?, ?, ?, ?, ?)", EXAM_ROUNDS)
    cur.executemany("INSERT INTO categories_domain VALUES (?, ?, ?, ?, ?)", CATEGORIES_DOMAIN)
    cur.executemany("INSERT INTO categories_qtype VALUES (?, ?, ?, ?)", CATEGORIES_QTYPE)

    q_rows = []
    for q in RAW_QUESTIONS:
        qtype_id = 2 if q["select_count"] > 1 else 1
        ans_text = format_answer_text(q["options"], q["correct_indices"])
        # Validate zero empty fields
        for fld in ("title", "question_text", "core_keywords", "explanation", "source", "escalation_note"):
            assert q[fld] and str(q[fld]).strip(), f"Empty field {fld} in R{q['round_id']}-Q{q['question_no']}"
        assert ans_text.strip(), "Empty answer_text"
        assert len(q["options"]) >= 4, "Less than 4 options"
        assert len(q["correct_indices"]) == q["select_count"], "select_count mismatch"

        q_rows.append((
            q["round_id"],
            q["question_no"],
            q["domain_id"],
            qtype_id,
            q["select_count"],
            q["title"].strip(),
            q["question_text"].strip(),
            json.dumps(q["options"], ensure_ascii=False),
            json.dumps(q["correct_indices"]),
            ans_text.strip(),
            q["core_keywords"].strip(),
            q["explanation"].strip(),
            q["source"].strip(),
            q["escalation_note"].strip(),
        ))

    cur.executemany("""
        INSERT INTO questions (
            round_id, question_no, domain_id, qtype_id, select_count,
            title, question_text, options_json, correct_indices_json,
            answer_text, core_keywords, explanation, source, escalation_note
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, q_rows)

    total_q = len(RAW_QUESTIONS)
    analytics_rows = []
    for dom_id, dom_code, dom_name, weight_pct, desc in CATEGORIES_DOMAIN:
        dom_qs = [q for q in RAW_QUESTIONS if q["domain_id"] == dom_id]
        cnt = len(dom_qs)
        share = round((cnt / total_q) * 100, 1) if total_q else 0.0
        single_c = sum(1 for q in dom_qs if q["select_count"] == 1)
        multi_c = sum(1 for q in dom_qs if q["select_count"] > 1)
        rounds_app = len(set(q["round_id"] for q in dom_qs))
        analytics_rows.append((
            dom_id, dom_name, weight_pct, cnt, share, single_c, multi_c, rounds_app, desc
        ))

    cur.executemany("INSERT INTO domain_analytics VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", analytics_rows)
    conn.commit()

    # Integrity check
    ic = cur.execute("PRAGMA integrity_check;").fetchone()[0]
    assert ic == "ok", f"SQLite integrity check failed: {ic}"

    # Write SQL dump
    with open(SQL_DUMP_PATH, "w", encoding="utf-8") as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")

    source_counts = dict(Counter(q["source"] for q in RAW_QUESTIONS))

    export_data = {
        "meta": {
            "cert_id": "aws-soa-c02",
            "exam_code": "SOA-C02",
            "title": "AWS Certified SysOps Administrator - Associate (SOA-C02 / C03) RDB",
            "level": "Associate",
            "cert_group": "AWS 클라우드 자격",
            "exam_stage": "필기",
            "exam_format": "객관식 단일/복수선택 65문항 · 130분 · 합격 720/1000점",
            "rounds_count": len(EXAM_ROUNDS),
            "questions_count": len(RAW_QUESTIONS),
            "domains_count": len(CATEGORIES_DOMAIN),
            "sources_summary": source_counts,
            "updated_at": "2026-11-26",
        },
        "rounds": [
            {
                "round_id": r[0],
                "round_code": r[1],
                "round_title": r[2],
                "exam_year": r[3],
                "agency": r[4],
                "key_trend": r[5],
            } for r in EXAM_ROUNDS
        ],
        "domains": [
            {
                "domain_id": d[0],
                "domain_code": d[1],
                "domain_name": d[2],
                "weight_pct": d[3],
                "description": d[4],
            } for d in CATEGORIES_DOMAIN
        ],
        "qtypes": [
            {
                "qtype_id": t[0],
                "qtype_code": t[1],
                "qtype_name": t[2],
                "description": t[3],
            } for t in CATEGORIES_QTYPE
        ],
        "analytics": [
            {
                "domain_id": a[0],
                "domain_name": a[1],
                "official_weight_pct": a[2],
                "total_questions": a[3],
                "share_pct": a[4],
                "single_count": a[5],
                "multi_count": a[6],
                "round_appearances": a[7],
                "primary_topics": a[8],
            } for a in analytics_rows
        ],
        "questions": [],
    }

    for row in cur.execute("""
        SELECT question_id, round_id, round_code, round_title, exam_year, agency,
               question_no, domain_id, domain_code, domain_name, weight_pct,
               qtype_id, qtype_code, qtype_name, select_count,
               title, question_text, options_json, correct_indices_json,
               answer_text, core_keywords, explanation, source, escalation_note
        FROM v_questions_full
        ORDER BY round_id ASC, question_no ASC
    """):
        export_data["questions"].append({
            "question_id": row[0],
            "round_id": row[1],
            "round_code": row[2],
            "round_title": row[3],
            "exam_year": row[4],
            "agency": row[5],
            "question_no": row[6],
            "domain_id": row[7],
            "domain_code": row[8],
            "domain_name": row[9],
            "weight_pct": row[10],
            "qtype_id": row[11],
            "qtype_code": row[12],
            "qtype_name": row[13],
            "select_count": row[14],
            "title": row[15],
            "question_text": row[16],
            "options": json.loads(row[17]),
            "correct_indices": json.loads(row[18]),
            "answer_text": row[19],
            "core_keywords": row[20],
            "explanation": row[21],
            "source": row[22],
            "escalation_note": row[23],
        })

    with open(JSON_EXPORT_PATH, "w", encoding="utf-8") as f:
        json.dump(export_data, f, ensure_ascii=False, indent=2)

    conn.close()
    print(f"[OK] Built SOA-C02 RDB: {len(EXAM_ROUNDS)} rounds, {len(RAW_QUESTIONS)} questions, integrity_check={ic}")
    print(f"     DB:   {DB_PATH}")
    print(f"     SQL:  {SQL_DUMP_PATH}")
    print(f"     JSON: {JSON_EXPORT_PATH}")


if __name__ == "__main__":
    build_database()
