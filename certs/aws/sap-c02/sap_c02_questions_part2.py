# -*- coding: utf-8 -*-
"""
SAP-C02 Question Bank Part 2:
- Round 4 (Set 3): Domain 3 — Continuous Improvement for Existing Solutions (16 questions)
- Round 5 (Set 4): Domain 4 — Accelerate Workload Migration & Modernization (16 questions)
- Round 6 (Set 5): Comprehensive Multi-Domain Enterprise Mock Set (16 questions: D1=4, D2=8, D3=3, D4=1)
Total in Part 2: 48 questions. Combined total with Part 1 = 90 questions.
"""

QUESTIONS_PART_2 = [
    # =========================================================================
    # ROUND 4 (SET 3): Domain 3 — Continuous Improvement for Existing Solutions (16 Questions)
    # =========================================================================
    (
        4, 1, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] S3 Storage Lens 전사 가시성 확보 및 미완료 멀티파트/이전 버전 비용 누수 제거",
        (
            "40개 AWS 계정에 걸쳐 총 3.5 PB의 Amazon S3 데이터를 운영하는 엔터프라이즈에서 최근 6개월간 객체 수는 거의 변하지 않았는데도 "
            "월별 S3 스토리지 청구액이 매달 18%씩 급증하고 있습니다. "
            "아키텍트는 추가적인 커스텀 스크립트 개발 없이 조직 전체 계정·버킷·프리픽스 수준에서 스토리지 증가 원인을 한눈에 진단하고, "
            "향후 불필요한 미완료 멀티파트 업로드와 오래된 비최신(Noncurrent) 버전 비용을 자동 차단해야 합니다.\n\n"
            "가장 효율적인 진단 및 개선 조합은 무엇입니까?"
        ),
        "Symptom: Object count stable, yet S3 storage bill grows 18%/month across 40 AWS accounts\nSuspects: Orphaned Incomplete Multipart Uploads, Noncurrent Object Versions",
        [
            {"label": "A", "text": "관리자 계정에서 40개 계정의 모든 버킷에 `aws s3api list-objects-v2` 를 매일 Lambda로 실행해 DynamoDB에 적재한 뒤 분석한다."},
            {"label": "B", "text": "AWS Organizations 통합 Amazon S3 Storage Lens(Advanced Metrics 포함) 대시보드를 활성화해 계정/버킷/프리픽스별 IncompleteMultipartUploadStorageBytes 및 NonCurrentVersionStorageBytes를 식별하고, S3 Lifecycle 규칙으로 AbortIncompleteMultipartUpload(예: 7일) 및 NoncurrentVersionExpiration을 적용한다."},
            {"label": "C", "text": "모든 버킷의 Versioning을 즉시 영구 비활성화할 수 있도록 삭제 후 재생성한다."},
            {"label": "D", "text": "AWS Cost Explorer에서 S3 API Request 비용만 필터링하여 어떤 프리픽스에 고아 파일이 있는지 파악한다."}
        ],
        ["B"],
        "B) AWS Organizations 통합 Amazon S3 Storage Lens로 미완료 멀티파트·이전 버전 용량을 식별하고, S3 Lifecycle 규칙(AbortIncompleteMultipartUpload, NoncurrentVersionExpiration)으로 자동 정리한다.",
        "S3 Storage Lens, IncompleteMultipartUploadStorageBytes, NoncurrentVersionStorageBytes, S3 Lifecycle",
        (
            "• 정답(B): **Amazon S3 Storage Lens** 는 AWS Organizations 전체의 S3 사용량과 비용 효율 지표를 단일 대시보드로 집계합니다. 특히 Advanced Metrics를 활성화하면 버킷·프리픽스 단위로 **미완료 멀티파트 업로드 바이트**와 **비최신(Noncurrent) 버전 비율**을 즉시 포착할 수 있으며, 이후 **S3 Lifecycle 규칙** 의 `AbortIncompleteMultipartUpload` 와 `NoncurrentVersionExpiration` 으로 추가 비용 없이 자동 삭제할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - A: 수십억 개 객체에 대해 매일 `ListObjectsV2` 를 호출하면 막대한 LIST API 요금과 Lambda 타임아웃이 발생합니다.\n"
            "  - C: S3 버킷은 한 번 Versioning을 켜면 완전 비활성화가 불가(Suspended만 가능)하며 기존 비최신 버전도 자동 삭제되지 않습니다.\n"
            "  - D: Cost Explorer는 버킷·프리픽스 수준의 비최신 버전/미완료 멀티파트 용량 메트릭을 제공하지 않습니다."
        ),
        "멀티어카운트 S3 비용 누수(미완료 멀티파트·비최신 버전·콜드 프리픽스) 진단 = **S3 Storage Lens**, 자동 정리 = **S3 Lifecycle**!"
    ),
    (
        4, 2, 3, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] S3 Express One Zone(초고속 소형 ML 텐서) vs S3 Glacier Instant Retrieval(저비용 즉시 의료영상)",
        (
            "AI 헬스케어 기업이 두 가지 S3 워크로드의 성능과 비용을 최적화하려고 합니다:\n"
            "1) 단일 AZ(`us-east-1a`)에서 실행 중인 분산 GPU PyTorch 학습 클러스터가 1억 개의 소형 50KB 텐서 파일을 초당 수십만 번 반복 조회할 때 "
            "S3 Standard의 높은 GET 요청 요금과 10~20ms의 지연 시간 때문에 GPU 활용률이 45%로 떨어졌습니다.\n"
            "2) 800 TB 규모의 과거 환자 DICOM 의료 영상은 분기당 1회 미만으로 조회되지만, 의사가 열람 요청 시 **수 밀리초(ms) 내에 즉시 다운로드** 되어야 하며 스토리지 단가를 대폭 낮춰야 합니다.\n\n"
            "각 워크로드에 최적화된 S3 스토리지 클래스 전환 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Workload 1: Single-AZ GPU training cluster, 100M tiny files, needs single-digit ms latency & lower GET cost\nWorkload 2: 800 TB cold DICOM archive, <1 read/quarter, MUST support millisecond retrieval",
        [
            {"label": "A", "text": "GPU 학습 데이터셋을 동일 가용 영역(us-east-1a)의 Amazon S3 Express One Zone(Directory Bucket)으로 이전한다."},
            {"label": "B", "text": "GPU 학습 데이터셋을 S3 Intelligent-Tiering Archive Access 계층으로 이동한다."},
            {"label": "C", "text": "800 TB DICOM 의료 영상을 S3 Glacier Instant Retrieval 스토리지 클래스로 전환한다."},
            {"label": "D", "text": "800 TB DICOM 의료 영상을 S3 Glacier Flexible Retrieval 스토리지 클래스로 전환한다."},
            {"label": "E", "text": "800 TB DICOM 의료 영상을 S3 One Zone-IA로 전환해 다중 AZ 내구성을 확보한다."}
        ],
        ["A", "C"],
        "A, C) GPU 학습 핫 데이터셋 -> S3 Express One Zone (단일 자리 ms 및 50% 낮은 요청 요금) / 800 TB 콜드 DICOM -> S3 Glacier Instant Retrieval (저비용 + ms 즉시 조회)",
        "S3 Express One Zone, Directory Bucket, S3 Glacier Instant Retrieval, ML Training Throughput, Cost Optimization",
        (
            "• 정답(A, C):\n"
            "  - A: **Amazon S3 Express One Zone** 은 단일 AZ 내 Directory Bucket에 저장되어 일관된 **한 자릿수 밀리초(Single-digit ms)** 지연 시간과 S3 Standard 대비 최대 10배 높은 요청 처리량, **50% 저렴한 요청 비용**을 제공하여 ML 학습/분석 핫 데이터에 최적화되어 있습니다.\n"
            "  - C: **S3 Glacier Instant Retrieval** 은 분기당 1회 미만 접근하는 장기 보관 데이터에 대해 S3 Standard-IA/Glacier 수준으로 스토리지 단가를 크게 낮추면서도 **밀리초 단위 즉시 조회** 를 보장합니다.\n"
            "• 오답 분석:\n"
            "  - B, D: Archive Access 및 Glacier Flexible Retrieval은 조회 전 수 분~수 시간의 복원(Restore) 대기가 필요해 실시간 ML 학습이나 의사의 ms 즉시 열람 요건을 충족하지 못합니다.\n"
            "  - E: S3 One Zone-IA는 단일 AZ 전용이라 다중 AZ 내구성을 제공하지 않으며 장기 콜드 데이터 비용도 Glacier Instant Retrieval보다 비쌉니다."
        ),
        "S3 클래스 의사결정 핵심: 초고속 단일 AZ 1~9ms = **S3 Express One Zone**, 분기 1회 미만 + ms 즉시 조회 = **S3 Glacier Instant Retrieval**!"
    ),
    (
        4, 3, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] EBS gp3 / io2 Block Express 전환 및 EC2 Nitro 인스턴스 EBS 대역폭 병목 해소",
        (
            "고성능 OLTP 데이터베이스가 `m5.4xlarge` 인스턴스 위에서 `io1` EBS 볼륨(10 TB, 20,000 프로비저닝 IOPS, 1,000 MB/s 기대)에 연결되어 운영 중입니다. "
            "그러나 야간 대량 배치 시간대에 CloudWatch `VolumeQueueLength` 가 급증하고 실제 처리량이 약 590 MB/s(4,750 Mbps)에서 천장을 치며 멈추는 현상이 발생했습니다. "
            "또한 데이터베이스 부하 특성상 평소에는 12,000 IOPS / 750 MB/s 이하로 충분하며 스토리지 비용을 40% 이상 절감하고자 합니다.\n\n"
            "성능 병목 원인과 비용·성능 동시 개선 방안으로 가장 정확한 것은 무엇입니까?"
        ),
        "Current: m5.4xlarge (Max EBS bandwidth = 4,750 Mbps ≈ 593 MB/s, Max 18,750 IOPS) + io1 (20,000 IOPS)\nActual requirement: <= 12,000 IOPS, 750 MB/s burst, cost reduction >40%",
        [
            {"label": "A", "text": "m5.4xlarge 인스턴스의 EBS 최적화 대역폭 한도(4,750 Mbps ≈ 593 MB/s)가 병목이므로 더 높은 EBS 대역폭을 지원하는 Nitro 기반 인스턴스(예: r6i.8xlarge 또는 m6i.8xlarge)로 스케일업하고, 볼륨은 12,000 IOPS · 750 MB/s로 설정한 EBS gp3로 무중단 수정(Elastic Volumes)한다."},
            {"label": "B", "text": "인스턴스 타입은 m5.4xlarge로 유지한 채 EBS 볼륨만 io2 Block Express 64,000 IOPS로 업그레이드하면 즉시 2,000 MB/s 처리량이 나온다."},
            {"label": "C", "text": "EBS gp2 볼륨 10 TB로 변경해 30,000 IOPS를 얻지만 처리량 제한은 250 MB/s로 제한되므로 그대로 사용한다."},
            {"label": "D", "text": "EBS 대신 Instance Store(NVMe)를 영구 DB 스토리지로 전환해 장애 시 스냅샷 없이 운영한다."}
        ],
        ["A"],
        "A) 인스턴스 EBS 대역폭 한도(4,750 Mbps) 병목 해소를 위해 m6i/r6i.8xlarge 등 고대역폭 인스턴스로 변경하고, 볼륨은 12,000 IOPS · 750 MB/s의 EBS gp3로 Elastic Volumes 무중단 전환한다.",
        "EBS gp3, io2 Block Express, Instance EBS Bandwidth Bottleneck, Elastic Volumes, VolumeQueueLength",
        (
            "• 정답(A): SAP-C02 성능 튜닝의 단골 함정 중 하나는 **볼륨 IOPS/Throughput만 높이고 EC2 인스턴스 자체의 EBS-Optimized 대역폭 한도를 확인하지 않는 것** 입니다. `m5.4xlarge` 는 전용 EBS 대역폭 상한이 4,750 Mbps(약 593 MB/s)이므로 750 MB/s 이상을 내려면 인스턴스를 상위 대역폭(예: `m6i.8xlarge` 10 Gbps / Dedicated EBS)으로 올려야 합니다. 또한 요구치가 16,000 IOPS / 1,000 MB/s 이내이므로 `io1` 대신 **`gp3`**(IOPS와 MB/s 독립 프로비저닝, 볼륨 크기 무관)로 다운타임 없이 전환하면 비용이 대폭 절감됩니다.\n"
            "• 오답 분석:\n"
            "  - B: `m5.4xlarge` 인스턴스 병목 때문에 `io2 Block Express` 로 바꿔도 593 MB/s 이상 나올 수 없습니다.\n"
            "  - C: `gp2` 는 단일 볼륨 처리량 상한이 250 MB/s에 불과합니다.\n"
            "  - D: Instance Store는 휘발성이므로 인스턴스 정지/호스트 장애 시 데이터가 유실됩니다."
        ),
        "EBS 공식: **`gp3`** 최대 16,000 IOPS / 1,000 MB/s (최적 가성비), **`io2 Block Express`** 최대 256,000 IOPS / 4,000 MB/s / 99.999% 내구성 — 단, 항상 **EC2 인스턴스 EBS 대역폭 상한**을 함께 점검하세요!"
    ),
    (
        4, 4, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] Amazon EFS Bursting 크레딧 고갈 해결 (Elastic Throughput) 및 소형 파일 메타데이터 캐싱",
        (
            "웹 CMS 애플리케이션(PHP/WordPress)이 40 GB 규모의 공유 미디어·코드 파일을 **Amazon EFS (Bursting Throughput 모드)** 에 저장하고 있습니다. "
            "평소에는 정상 동작하다가 마케팅 캠페인 트래픽이 몰리는 날이면 `BurstCreditBalance` 가 0으로 바닥나면서 처리량이 기저치(Baseline, 수 MB/s)로 급락해 전체 웹 서버가 먹통이 됩니다. "
            "또한 수만 개의 소형 PHP 파일을 매 HTTP 요청마다 EFS에서 `stat()`/`open()` 하는 메타데이터 I/O 지연이 큽니다.\n\n"
            "EFS 용량(40 GB)을 인위적으로 10 TB로 부풀리지 않으면서 버스트 고갈을 완전히 제거하고 응답 속도를 개선하는 최적의 방법은 무엇입니까?"
        ),
        "EFS Context:\n- Stored size: 40 GB (Bursting mode gives tiny baseline ~2 MB/s!)\n- Symptom: BurstCreditBalance drops to 0 -> severe throttling\n- Small PHP code files accessed via NFS stat() on every request",
        [
            {"label": "A", "text": "EFS에 10 TB 크기의 더미 빈 파일을 생성해 저장 용량 비례 Baseline 처리량을 억지로 높인다."},
            {"label": "B", "text": "EFS Throughput 모드를 Elastic Throughput(탄력적 처리량) 모드로 변경해 용량과 무관하게 스파이크 트래픽만큼 즉시 자동 확장·종량 과금되게 하고, 정적 PHP 코드/자주 읽히는 소형 파일은 컨테이너 이미지/로컬 EBS(또는 OPcache/ElastiCache)에 캐싱해 EFS 메타데이터 I/O를 제거한다."},
            {"label": "C", "text": "EFS Performance 모드를 Max I/O에서 General Purpose로 바꿀 필요 없이 Bursting 모드 그대로 S3 Glacier에 백업만 추가한다."},
            {"label": "D", "text": "모든 EC2 인스턴스에 동일한 EBS gp3 볼륨을 ReadWriteMany로 직접 동시 마운트해 EFS를 대체한다."}
        ],
        ["B"],
        "B) EFS Throughput 모드를 Elastic Throughput으로 변경해 크레딧 제한을 제거하고, 자주 읽히는 PHP 소스·소형 메타데이터는 로컬 디스크/OPcache/ElastiCache로 오프로드한다.",
        "Amazon EFS Elastic Throughput, BurstCreditBalance, EFS Performance Optimization, OPcache, POSIX Metadata I/O",
        (
            "• 정답(B): EFS **Bursting 모드** 는 저장된 용량(GiB당 50 KB/s)에 비례해 기본 처리량이 결정되므로 40 GB 소용량 파일시스템은 크레딧 소진 시 심각한 쓰로틀링이 발생합니다. **Elastic Throughput 모드** 로 전환하면 미리 용량이나 처리량을 프로비저닝하지 않아도 필요 시 최대 수 GiB/s까지 즉시 확장되며 실제 읽고 쓴 양에 대해서만 과금됩니다. 더불어 실행 코드(.php)는 로컬 컨테이너/EBS 및 OPcache에 두어 불필요한 네트워크 파일 시스템 `stat()` 왕복을 없애야 합니다.\n"
            "• 오답 분석:\n"
            "  - A: 더미 파일을 채워 넣는 것은 불필요한 EFS GB당 스토리지 비용을 매월 낭비하는 안티패턴입니다.\n"
            "  - C: 백업 추가는 처리량 크레딧 고갈을 해결하지 못합니다.\n"
            "  - D: EBS Multi-Attach는 클러스터 인식 파일시스템(GFS2 등) 없이 표준 ext4/xfs로 동시 마운트 시 파일시스템이 즉시 손상되며 단일 AZ 내 io2 블록 장치로 제한됩니다."
        ),
        "EFS 스파이크 크레딧 고갈(`BurstCreditBalance = 0`) = **Elastic Throughput**(예측 불가 스파이크) 또는 **Provisioned Throughput**(지속 고정 대역폭)!"
    ),
    (
        4, 5, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] HPC 유전체 연산(FSx for Lustre) vs 멀티프로토콜 엔터프라이즈 NAS(FSx for NetApp ONTAP)",
        (
            "연구 플랫폼 아키텍트가 사내 두 가지 스토리지 병목 워크로드에 대한 최적의 AWS 관리형 파일 시스템을 재선정해야 합니다:\n"
            "1) **워크로드 A**: 수백 대의 EC2 Spot GPU 노드가 S3 데이터 레이크(300 TB)의 데이터를 읽어 초당 수십 GB/s 속도와 서브 밀리초 지연으로 병렬 유전체 시뮬레이션 후 결과를 S3로 다시 내보내야 합니다.\n"
            "2) **워크로드 B**: Linux(NFSv4)와 Windows(SMB) 애플리케이션 서버가 동일 파일셋을 동시에 읽고 쓰며, 중복 제거(Deduplication), 압축, 스냅샷 및 Thin Provisioning으로 스토리지 비용을 절감해야 합니다.\n\n"
            "각 워크로드에 가장 적합한 Amazon FSx 구성은 무엇입니까?"
        ),
        "Workload A: HPC/ML compute on Spot EC2, tens of GB/s throughput, S3 native two-way sync\nWorkload B: Dual NFS + SMB multiprotocol access, snapshots, compression & deduplication",
        [
            {"label": "A", "text": "워크로드 A: Amazon FSx for Lustre (S3 Data Repository Association 연동) / 워크로드 B: Amazon FSx for NetApp ONTAP"},
            {"label": "B", "text": "워크로드 A: Amazon FSx for Windows File Server / 워크로드 B: Amazon EFS (SMB 게이트웨이 직접 마운트)"},
            {"label": "C", "text": "워크로드 A: Amazon EFS Standard / 워크로드 B: Amazon FSx for Lustre"},
            {"label": "D", "text": "워크로드 A와 B 모두 Amazon S3 Storage Gateway Tape Gateway로 교체한다."}
        ],
        ["A"],
        "A) 워크로드 A: Amazon FSx for Lustre (S3 DRA 연동) / 워크로드 B: Amazon FSx for NetApp ONTAP",
        "Amazon FSx for Lustre, FSx for NetApp ONTAP, S3 Data Repository Association, NFS/SMB Multiprotocol, Deduplication",
        (
            "• 정답(A): **Amazon FSx for Lustre** 는 고성능 컴퓨팅(HPC)/ML 전용 병렬 분산 파일시스템으로 수백 GB/s 처리량, 서브 밀리초 지연, S3 버킷과의 네이티브 양방향 자동 동기화(DRA)를 제공합니다. **Amazon FSx for NetApp ONTAP** 은 **NFS + SMB + iSCSI 멀티프로토콜 동시 접근**, 실시간 중복 제거·압축(최대 65% 절감), FlexClone 무비용 복제, SnapMirror 교차 리전 복제를 지원합니다.\n"
            "• 오답 분석:\n"
            "  - B: EFS는 NFS 전용이며 SMB 프로토콜을 지원하지 않습니다.\n"
            "  - C: FSx for Lustre는 SMB 프로토콜이나 ONTAP 스타일 기업용 중복 제거/스냅샷 NAS 용도가 아닙니다.\n"
            "  - D: Tape Gateway는 VTL(가상 테이프 라이브러리) 백업 전용입니다."
        ),
        "FSx 4총사 암기: **Lustre** = HPC/ML+S3 초고속 연동, **ONTAP** = NFS+SMB+iSCSI+중복제거/스냅샷, **Windows** = AD+NTFS ACL+DFS, **OpenZFS** = 고IOPS 리눅스 NFS+ZFS 스냅샷!"
    ),
    (
        4, 6, 3, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] 온프레미스 야간 대량 NAS 동기화(DataSync) 및 외부 B2B SFTP 무서버화(Transfer Family)",
        (
            "물류 기업이 기존에 직접 관리하던 EC2 배스천/스크립트 서버 두 대를 제거해 운영 비용과 장애를 줄이려고 합니다:\n"
            "1) 온프레미스 NAS에서 매일 밤 15 TB의 물류 정산 파일을 Direct Connect를 통해 S3로 전송하는 취약한 `cron + aws s3 sync` EC2 스크립트를 대체하고, 전송 중 대역폭 제한(Bandwidth Throttling), 암호화, 자동 체크섬 무결성 검증을 원합니다.\n"
            "2) 200개 외부 협력사가 매일 SFTP 클라이언트로 송장 CSV 파일을 업로드하던 EC2 OpenSSH 서버를 제거하고, 기존 SFTP 클라이언트 설정 변경 없이 파일이 곧바로 S3 버킷에 저장되게 하려 합니다.\n\n"
            "이 두 가지 기존 워크플로우를 대체할 완전관리형 AWS 서비스 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Legacy 1: Fragile cron `aws s3 sync` transferring 15 TB/night from On-Prem NAS -> needs throttling & checksum verification\nLegacy 2: Self-managed EC2 OpenSSH SFTP server for 200 external B2B vendors",
        [
            {"label": "A", "text": "AWS DataSync 에이전트를 온프레미스에 배포해 스케줄·대역폭 제한·체크섬 검증이 포함된 자동화된 NAS -> S3 온라인 전송 태스크를 구성한다."},
            {"label": "B", "text": "Amazon S3를 스토리지 백엔드로 사용하는 AWS Transfer Family (SFTP 엔드포인트 + 커스텀 IdP/SSH 키 인증)를 구성한다."},
            {"label": "C", "text": "AWS Snowcone 디바이스를 매일 밤 택배로 왕복 배송해 15 TB를 수동 동기화한다."},
            {"label": "D", "text": "200개 외부 협력사에게 AWS IAM Console 로그인 계정을 발급해 S3 웹 콘솔로 직접 업로드하게 한다."},
            {"label": "E", "text": "Amazon FSx for Windows File Server를 외부 퍼블릭 인터넷에 SMB 445 포트로 개방한다."}
        ],
        ["A", "B"],
        "A, B) 온프레미스 NAS -> S3 대량 스케줄/검증 전송은 AWS DataSync / 외부 B2B SFTP 서버 무서버 전환은 AWS Transfer Family(SFTP)",
        "AWS DataSync, Bandwidth Throttling, Checksum Verification, AWS Transfer Family, Managed SFTP to S3",
        (
            "• 정답(A, B):\n"
            "  - A: **AWS DataSync** 는 온프레미스 NFS/SMB/HDFS와 AWS 스토리지(S3/EFS/FSx) 간 고속 온라인 전송 서비스로, 전송 속도 제한(대역폭 스로틀링), TLS 암호화, 자동 무결성 검증 및 스케줄링을 기본 제공합니다.\n"
            "  - B: **AWS Transfer Family** 는 S3 또는 EFS를 백엔드로 하는 완전관리형 **SFTP/FTPS/FTP/AS2** 엔드포인트를 제공하므로, 기존 협력사 SFTP 클라이언트를 바꾸지 않고 EC2 SSH 서버 관리를 완전히 제거할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - C: 매일 밤 반복 동기화에 오프라인 물리 장비 Snowcone 배송은 비현실적입니다.\n"
            "  - D: B2B 자동화 파이프라인은 표준 SFTP 프로토콜 유지가 조건입니다.\n"
            "  - E: SMB 445 포트를 인터넷에 직접 여는 것은 심각한 보안 위험입니다."
        ),
        "프로토콜 기반 구분: 온프레미스 NAS↔AWS 대용량 고속 복제(체크섬/대역폭제어) = **DataSync**, 외부 파트너 SFTP/FTPS/AS2 연동 = **Transfer Family**, 온프레미스 앱 로컬 저지연 S3 캐싱 = **Storage Gateway**!"
    ),
    (
        4, 7, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] FinOps 고도화: CUR 2.0 + EKS Split Cost Allocation + Compute Optimizer 메모리 메트릭 + Savings Plans",
        (
            "클라우드 플랫폼 팀이 매달 40만 달러에 달하는 컴퓨팅 비용을 최적화하기 위해 FinOps 개선 프로젝트를 진행 중입니다.\n"
            "1) 멀티테넌트 Amazon EKS 클러스터 내부에서 어떤 네임스페이스/라벨이 EC2 노드 비용의 얼마를 점유하는지 정확한 Showback 리포트를 산출해야 합니다.\n"
            "2) CPU 사용률은 낮지만 실제 메모리 사용량이 15% 미만인 과대 프로비저닝(Over-provisioned) EC2 인스턴스까지 정확히 식별해 다운사이징(Right-sizing)해야 합니다.\n"
            "3) 향후 1년간 팀들이 EC2 인스턴스 패밀리·리전을 변경하거나 일부를 AWS Fargate 및 AWS Lambda로 현대화하더라도 최대 할인 혜택을 유지하고 싶습니다.\n\n"
            "이 세 가지 FinOps 요구사항을 모두 만족하는 구성은 무엇입니까?"
        ),
        "FinOps Goals:\n1) Granular EKS namespace/pod cost attribution\n2) OS-level Memory right-sizing recommendations\n3) 1-year commitment discount flexible across EC2 families, Regions, Fargate, and Lambda",
        [
            {"label": "A", "text": "Cost Allocation Tags + EKS Split Cost Allocation Data를 활성화해 AWS Cost and Usage Report(CUR 2.0) -> Athena/QuickSight로 쇼백하고, EC2에 CloudWatch Agent를 배포해 메모리 메트릭을 AWS Compute Optimizer에 연동하며, Compute Savings Plans(1년)를 구매한다."},
            {"label": "B", "text": "기본 CloudWatch EC2 메트릭만 Compute Optimizer에 연결하고 3년 Standard EC2 Reserved Instances(특정 인스턴스 패밀리·리전 고정)를 전액 선불 구매한다."},
            {"label": "C", "text": "AWS Trusted Advisor 무료 체크만으로 EKS Pod별 메모리 비용 분배와 Fargate 할인을 적용한다."},
            {"label": "D", "text": "EC2 Instance Savings Plans를 구매하면 Fargate와 Lambda까지 동일하게 할인 적용된다."}
        ],
        ["A"],
        "A) Cost Allocation Tags + Split Cost Allocation Data(CUR -> Athena/QuickSight) + CloudWatch Agent 메모리 메트릭 기반 Compute Optimizer + Compute Savings Plans",
        "FinOps, Split Cost Allocation Data, CUR, Compute Optimizer Memory Metrics, CloudWatch Agent, Compute Savings Plans",
        (
            "• 정답(A): **Split Cost Allocation Data** 를 활성화하면 ECS 태스크·EKS Pod/네임스페이스 단위의 실제 CPU·메모리 소비 비율로 비용이 CUR에 분할 기록됩니다. 기본 하이퍼바이저 EC2 메트릭에는 OS 메모리가 포함되지 않으므로 **CloudWatch Agent** 로 메모리 지표를 수집해야 **AWS Compute Optimizer** 가 정확한 메모리 기반 다운사이징을 권고합니다. 또한 리전·패밀리·Fargate·Lambda를 모두 아우르는 최고 유연성 할인은 **Compute Savings Plans** 입니다.\n"
            "• 오답 분석:\n"
            "  - B: CloudWatch Agent 없이는 Compute Optimizer가 메모리 사용률을 볼 수 없으며, Standard RI는 리전·패밀리·EC2 고정이라 Fargate/Lambda 전환 시 매몰 비용이 발생합니다.\n"
            "  - C: Trusted Advisor 무료 체크는 EKS Pod 비용 분할 및 메모리 기반 우측 사이징을 제공하지 않습니다.\n"
            "  - D: EC2 Instance Savings Plans는 특정 리전/패밀리의 EC2에만 적용되며 Fargate와 Lambda에는 적용되지 않습니다."
        ),
        "SAP-C02 FinOps 암기 포인트: 1) EC2 OS 메모리 기반 Right-sizing = **CloudWatch Agent + Compute Optimizer**, 2) EC2+Fargate+Lambda 유연 할인 = **Compute Savings Plans**, 3) EKS/ECS Pod 단위 원가 배부 = **Split Cost Allocation Data**!"
    ),
    (
        4, 8, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] DynamoDB 핫 파티션 키 쓰기 스로틀링(Write Sharding) 및 예측 가능한 주기적 부하 비용 절감",
        (
            "글로벌 모바일 게임의 실시간 투표·집계 서비스가 Amazon DynamoDB 테이블(Provisioned Mode, 10,000 WCU)을 사용 중입니다. "
            "파티션 키가 `region_code` (예: `KR`, `US`, `JP`)로 설계되어 있어, 한국(`KR`) 이벤트 시작 시 전체 테이블 WCU의 35%만 사용 중임에도 "
            "`ProvisionedThroughputExceededException` 이 대량 발생하고 있습니다. 또한 하루 중 16시간은 트래픽이 200 WCU 미만이지만 나머지 8시간은 8,000 WCU로 예측 가능하게 상승합니다.\n\n"
            "핫 파티션 병목과 불필요한 유휴 WCU 과금을 동시에 해결하는 최적의 개선안은 무엇입니까?"
        ),
        "Current PK: region_code ('KR' receives 90% of writes -> exceeds single partition 1,000 WCU hard ceiling!)\nTraffic Pattern: Predictable daily curve (200 WCU for 16h, 8,000 WCU for 8h)",
        [
            {"label": "A", "text": "파티션 키에 랜덤/해시 접미사(0~19)를 붙이는 Write Sharding(`KR#0` ~ `KR#19`)으로 쓰기를 여러 물리 파티션에 분산하고, DynamoDB Auto Scaling(최소 200 ~ 최대 10,000 WCU, Target Utilization 70%)을 구성하거나 예측 패턴 외 불규칙 스파이크 시 On-Demand와 비용을 비교한다."},
            {"label": "B", "text": "DynamoDB 앞에 DAX(DynamoDB Accelerator) 클러스터를 배치하면 핫 파티션 키 쓰기 스로틀링이 자동으로 분산된다."},
            {"label": "C", "text": "테이블 WCU를 50,000으로 상시 고정 프로비저닝하면 단일 파티션 키 `KR`도 즉시 50,000 WCU를 수용한다."},
            {"label": "D", "text": "DynamoDB Streams를 끄면 파티션당 1,000 WCU 제한이 10,000 WCU로 늘어난다."}
        ],
        ["A"],
        "A) Write Sharding(`KR#0`..`KR#19`)으로 단일 핫 파티션 쓰기 집중을 분산시키고, 예측 가능한 일간 부하 곡선에 맞춰 DynamoDB Auto Scaling(및 필요 시 Reserved Capacity)을 적용한다.",
        "DynamoDB Hot Partition, Write Sharding, 1000 WCU Partition Limit, Adaptive Capacity, Auto Scaling",
        (
            "• 정답(A): DynamoDB의 단일 물리 파티션은 최대 **1,000 WCU / 3,000 RCU** 의 하드 한계를 가집니다(Adaptive Capacity로도 단일 파티션 키 `KR` 하나에 1,000 WCU 이상 몰리는 물리 한계는 넘을 수 없음). 따라서 **Write Sharding** (`KR#0` ~ `KR#19` 등 복합 파티션 키)으로 여러 물리 파티션에 쓰기를 고르게 분산해야 합니다. 또한 부하 곡선이 하루 단위로 예측 가능하고 점진적이라면 Provisioned + **Auto Scaling** 이 On-Demand(요청당 단가 높음)보다 훨씬 저렴합니다.\n"
            "• 오답 분석:\n"
            "  - B: DAX는 **읽기(Read-through)** 마이크로초 캐시이며 쓰기는 DynamoDB 본 테이블로 그대로 통과(Write-through)하므로 쓰기 핫 파티션을 해결하지 못합니다.\n"
            "  - C: 전체 테이블 WCU를 올려도 단일 파티션 키 하나가 1,000 WCU 이상을 초과할 수 없습니다.\n"
            "  - D: Streams 활성화 여부와 단일 파티션 WCU 상한은 무관합니다."
        ),
        "DynamoDB 물리 한계 암기: 단일 파티션 최대 **1,000 WCU / 3,000 RCU / 10 GB** -> 특정 키 집중 시 **Write Sharding**, 예측 가능한 점진적 곡선 = **Provisioned + Auto Scaling**, 예측 불가 돌발 스파이크 = **On-Demand**!"
    ),
    (
        4, 9, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] Amazon Athena 50 TB 소형 JSON 스캔 비용 폭증 개선 (Parquet 압축 + Partition Projection)",
        (
            "데이터 분석 팀이 S3에 저장된 50 TB 규모의 애플리케이션 로그(하루 약 200만 개의 5 KB 개별 JSON 파일)를 Amazon Athena로 조회하고 있습니다. "
            "단순히 최근 1시간 특정 에러 코드만 조회해도 쿼리당 4분 이상 걸리고 수십 달러가 청구되며, 매일 새 날짜가 생길 때마다 `MSCK REPAIR TABLE` 실행이 타임아웃됩니다.\n\n"
            "Athena 쿼리 비용과 지연 시간을 90% 이상 줄이고 파티션 관리 오버헤드를 없애는 개선 방안은 무엇입니까?"
        ),
        "Bottleneck:\n- 50 TB split across tens of millions of tiny ~5 KB uncompressed JSON files\n- MSCK REPAIR TABLE timing out on thousands of S3 partitions",
        [
            {"label": "A", "text": "AWS Glue ETL / Firehose를 통해 소형 JSON 파일들을 year/month/day/hour 프리픽스 기준 128~512 MB 크기의 Apache Parquet(Snappy 압축) 컬럼형 파일로 병합 변환하고, Athena 테이블에 Partition Projection을 설정해 Glue 메타스토어 파티션 스캔 없이 즉시 프루닝한다."},
            {"label": "B", "text": "JSON 파일을 Gzip으로만 개별 압축해 동일한 5 KB 단편 파일 개수(수천만 개)를 그대로 유지한다."},
            {"label": "C", "text": "Athena Workgroup 결과 캐싱만 끄고 모든 쿼리를 SELECT * 로 통합한다."},
            {"label": "D", "text": "모든 50 TB 원시 JSON을 Amazon RDS PostgreSQL db.r6i.xlarge에 적재한다."}
        ],
        ["A"],
        "A) 소형 JSON을 128~512 MB 크기의 컬럼형 Apache Parquet(Snappy 압축)으로 병합 변환하고, 날짜 프리픽스 파티셔닝 + Athena Partition Projection을 적용한다.",
        "Amazon Athena Optimization, Apache Parquet, Snappy Compression, File Compaction, Partition Projection",
        (
            "• 정답(A): Athena는 **S3 스캔 데이터 양(TB당 $5)** 으로 과금되며, 수백만 개의 작은 파일(Small Files Problem)은 S3 메타데이터 오픈 오버헤드로 심각한 지연을 유발합니다. **128~512 MB 크기의 Apache Parquet(컬럼형, Snappy 압축, 분할 가능)** 로 병합하면 필요한 컬럼만 읽어 스캔량과 비용이 80~95% 급감합니다. 아울러 **Partition Projection** 은 날짜/시간 등 패턴화된 파티션을 인메모리로 즉시 계산하므로 느린 `MSCK REPAIR TABLE` 이나 Glue `GetPartitions` API 호출이 전혀 필요 없습니다.\n"
            "• 오답 분석:\n"
            "  - B: 수천만 개의 소형 파일 개수가 줄지 않으면 S3 LIST/GET 오버헤드가 남으며, Gzip은 파일 분할(Splittable)이 제한됩니다.\n"
            "  - C: `SELECT *` 는 컬럼형 프루닝 이점을 완전히 무력화합니다.\n"
            "  - D: 50 TB 로그를 RDBMS에 넣으면 스토리지/컴퓨팅 비용이 기하급수적으로 상승합니다."
        ),
        "Athena 튜닝 4대 공식: 1) **Parquet/ORC** (컬럼 프루닝), 2) **Snappy/Zstd 압축**, 3) **128~512MB Compaction** (소형 파일 제거), 4) **Partition Projection** (`MSCK REPAIR` 제거)!"
    ),
    (
        4, 10, 3, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] AWS Lambda Java 콜드 스타트 제거(SnapStart) 및 Graviton2/Power Tuning 비용 최적화",
        (
            "API Gateway 뒤에서 동작하는 두 종류의 AWS Lambda 마이크로서비스를 최적화하려고 합니다:\n"
            "1) **결제 검증 서비스(Java 17 + Spring Boot)**: 의존성 초기화 때문에 콜드 스타트 시 P99 응답 시간이 6.5초까지 치솟아 클라이언트 타임아웃이 발생합니다. Provisioned Concurrency는 상시 비용이 너무 큽니다.\n"
            "2) **이미지 메타데이터 파싱 서비스(Python 3.12, x86_64)**: 상시 트래픽이 많아 월간 Lambda GB-초 비용이 가장 크며, 현재 512 MB 메모리로 설정되어 있으나 CPU 바운드 연산으로 실행 시간이 깁니다.\n\n"
            "두 서비스의 성능과 가격 대비 효율을 극대화하는 개선 조치 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Service 1: Java 17 Spring Boot -> 6.5s cold start (Provisioned Concurrency too costly)\nService 2: Python CPU-bound x86_64 -> high monthly GB-seconds cost",
        [
            {"label": "A", "text": "결제 검증 Java 함수에 AWS Lambda SnapStart를 활성화하고, Published Version/Alias를 API Gateway 통합 대상으로 연결해 초기화된 Firecracker 마이크로VM 스냅샷에서 복원한다."},
            {"label": "B", "text": "Python CPU 바운드 함수의 아키텍처를 x86_64에서 arm64(AWS Graviton2)로 전환하고, AWS Lambda Power Tuning(Step Functions)으로 최적의 메모리-속도-비용 지점(예: 1,024 MB로 올려 실행 시간을 절반 이하로 단축)을 찾는다."},
            {"label": "C", "text": "Java 함수의 메모리를 최소치인 128 MB로 낮추면 Spring Boot 콜드 스타트가 즉시 50ms 이하로 줄어든다."},
            {"label": "D", "text": "CloudWatch Events/EventBridge로 1분마다 Java 함수를 Ping 하면 Provisioned Concurrency 없이 모든 동시 확장 인스턴스의 콜드 스타트가 100% 사라진다."},
            {"label": "E", "text": "Python 함수에서 Lambda 타임아웃을 15분으로 늘리면 GB-초 비용이 절감된다."}
        ],
        ["A", "B"],
        "A, B) Java 서비스에 Lambda SnapStart + Published Version/Alias 적용 / Python CPU 바운드 서비스를 Graviton2(arm64) 전환 및 AWS Lambda Power Tuning으로 최적화",
        "AWS Lambda SnapStart, Graviton2 arm64, AWS Lambda Power Tuning, Cold Start Optimization, GB-Second Cost",
        (
            "• 정답(A, B):\n"
            "  - A: **AWS Lambda SnapStart** 는 함수 배포(Version Publish) 시 `Init` 단계를 1회 실행한 뒤 메모리·디스크 스냅샷을 암호화 캐싱하여, 호출 시 수백 ms 내에 즉시 복원함으로써 추가 Provisioned Concurrency 요금 없이 Java 콜드 스타트를 최대 90% 제거합니다(단, `$LATEST` 가 아닌 **Published Version 또는 Alias** 호출 필수).\n"
            "  - B: **Graviton2(`arm64`)** 는 x86 대비 가격 대비 성능이 최대 34% 우수하며, Lambda는 메모리에 비례해 vCPU가 할당되므로 **AWS Lambda Power Tuning** 으로 메모리를 늘려 실행 시간을 크게 줄이면 총 GB-초 비용이 오히려 감소하는 경우가 많습니다.\n"
            "• 오답 분석:\n"
            "  - C: 메모리를 128 MB로 낮추면 vCPU도 1/10 수준으로 줄어 Java Spring Boot 콜드 스타트가 오히려 수십 초로 악화됩니다.\n"
            "  - D: 주기적 Ping(Warmer)은 단 1개의 컨테이너만 따뜻하게 유지할 뿐 동시 트래픽 급증 시 새로 생성되는 실행 환경의 콜드 스타트를 막지 못합니다.\n"
            "  - E: 타임아웃 값은 최대 허용 실행 시간일 뿐 비용을 줄이지 못합니다."
        ),
        "Lambda 최적화 트레이드오프: Java 콜드 스타트(추가 비용 X) = **SnapStart(Version/Alias 필수)**, 메모리 비례 vCPU = **Power Tuning + arm64(Graviton2)**!"
    ),
    (
        4, 11, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] CloudFront Cache Policy + Brotli/Gzip 엣지 압축 및 오리진 부하 80% 절감",
        (
            "전자상거래 카탈로그 API(`api.shop.com/v1/products?category=shoes&page=2`)가 CloudFront + ALB + EC2 Auto Scaling 구조로 운영 중입니다. "
            "그러나 모니터링 결과 **CloudFront 캐시 적중률(Cache Hit Ratio)이 4% 미만** 에 불과해 거의 모든 요청이 EC2 오리진까지 전달되고 있으며, "
            "EC2 CPU의 35%가 대용량 JSON 응답 Gzip 압축에 소모되고 있습니다. "
            "원인 조사 결과 기존 레거시 Cache Behavior가 `All Headers`, `All Cookies`, `All Query Strings` 를 캐시 키에 포함해 오리진으로 포워딩하고 있었습니다.\n\n"
            "애플리케이션 코드 수정 없이 오리진 부하와 대역폭 비용을 극적으로 개선하는 CloudFront 구성 변경은 무엇입니까?"
        ),
        "Current Issue:\n- Cache Hit Ratio < 4% because User-Agent, Authorization/session cookies, and tracking query params (utm_source) fragment the Cache Key\n- Origin EC2 spends 35% CPU compressing JSON",
        [
            {"label": "A", "text": "CloudFront Cache Policy를 생성해 캐시 키에는 실제로 응답 내용을 결정하는 `category` 와 `page` 쿼리 스트링만 포함(Whitelist)시키고 불필요한 헤더·쿠키를 캐시 키에서 제외하며, CloudFront에서 `Compress objects automatically`(Gzip/Brotli)를 활성화하고 EC2 압축은 비활성화한다."},
            {"label": "B", "text": "CloudFront 캐싱을 완전히 끄고 EC2 인스턴스 타입을 c6i.8xlarge로 증설해 JSON 압축 성능을 높인다."},
            {"label": "C", "text": "모든 사용자 쿠키와 `User-Agent` 헤더를 반드시 캐시 키에 유지해야만 CDN이 정상 작동한다."},
            {"label": "D", "text": "TTL을 0초로 설정하면 Cache Hit Ratio가 100%로 올라간다."}
        ],
        ["A"],
        "A) CloudFront Cache Policy에서 실제 응답을 구분하는 쿼리 파라미터(category, page)만 캐시 키에 포함해 Cache Hit Ratio를 높이고, CloudFront 자동 Gzip/Brotli 엣지 압축을 활성화한다.",
        "CloudFront Cache Policy, Cache Hit Ratio, Cache Key Optimization, Brotli/Gzip Edge Compression",
        (
            "• 정답(A): 카탈로그 API처럼 공개 조회 응답이 특정 쿼리 파라미터(`category`, `page`)에만 의존할 때 `All Headers`/`All Cookies`(예: `User-Agent`, 광고 추적 쿠키, `utm_*`)를 캐시 키에 넣으면 사용자마다 다른 캐시 키가 생성되어 캐시 적중률이 붕괴합니다. **Cache Policy** 로 캐시 키를 최소화하고 **CloudFront 엣지 자동 압축(Gzip/Brotli)** 을 켜면 오리진 CPU 부담과 데이터 송신 비용(Brotli는 Gzip 대비 추가 15~20% 압축)을 동시에 크게 낮출 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - B: 캐시 키 단편화를 방치한 채 EC2만 키우는 것은 비효율적입니다.\n"
            "  - C: 공개 카탈로그 응답에는 사용자별 쿠키나 `User-Agent` 분리가 불필요합니다.\n"
            "  - D: TTL 0초는 캐싱을 사실상 비활성화합니다."
        ),
        "CloudFront Cache Hit Ratio 개선 = **Cache Policy에서 불필요한 Header/Cookie/QueryString 제거** (+ **Origin Request Policy**로 오리진 전달 헤더와 캐시 키 분리)!"
    ),
    (
        4, 12, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] NAT Gateway 교차 AZ 전송 및 S3/DynamoDB 트래픽으로 인한 월 18,000달러 네트워크 비용 절감",
        (
            "대규모 데이터 파이프라인을 운영하는 계정의 비용 분석 결과, **EC2 Data Transfer 및 NAT Gateway Data Processing 비용** 이 매월 18,000달러나 발생하고 있습니다. "
            "아키텍처 점검 결과 3개 가용 영역(AZ-a, AZ-b, AZ-c)의 Private Subnet에서 실행 중인 수백 개의 ECS 태스크가 "
            "대용량 Parquet 파일을 Amazon S3와 DynamoDB에 읽고 쓸 때 단일 AZ(AZ-a)에 있는 NAT Gateway 1대를 경유하여 퍼블릭 인터넷 엔드포인트로 통신하고 있었습니다.\n\n"
            "보안(사설 통신 유지)을 강화하면서 네트워크 전송·NAT 처리 비용을 최소화하는 가장 효과적인 개선 방안은 무엇입니까?"
        ),
        "Root Causes of $18k/mo bill:\n1) Heavy S3/DynamoDB traffic routed through NAT Gateway ($0.045/GB processing)\n2) AZ-b & AZ-c private subnets routing through single NAT GW in AZ-a ($0.02/GB cross-AZ data transfer)",
        [
            {"label": "A", "text": "S3 및 DynamoDB용 Gateway VPC Endpoint(무료)를 생성해 모든 Private Subnet 라우팅 테이블에 연결하고, 각 가용 영역(AZ-a, AZ-b, AZ-c)마다 해당 AZ 로컬 NAT Gateway 및 라우팅 테이블을 분리 구성해 외부 인터넷 트래픽의 Cross-AZ 홉을 제거한다."},
            {"label": "B", "text": "NAT Gateway 대신 인터넷 게이트웨이(IGW)에 직접 연결되도록 모든 ECS 태스크를 Public Subnet으로 옮기고 퍼블릭 IP를 부여한다."},
            {"label": "C", "text": "S3와 DynamoDB용 Interface VPC Endpoint(PrivateLink)만 생성하고 Gateway Endpoint는 삭제한다."},
            {"label": "D", "text": "NAT Instance 1대를 t3.micro로 띄워 AZ-a에만 배치하면 Cross-AZ 전송 요금이 면제된다."}
        ],
        ["A"],
        "A) S3/DynamoDB용 무료 Gateway VPC Endpoint를 라우팅 테이블에 연결하고, 외부 인터넷 트래픽용 NAT Gateway는 AZ별로 배치해 Cross-AZ 데이터 전송 비용을 제거한다.",
        "Gateway VPC Endpoint, S3/DynamoDB Cost Savings, NAT Gateway Cross-AZ Traffic, AZ-Local Routing",
        (
            "• 정답(A): **S3와 DynamoDB용 Gateway VPC Endpoint는 시간당 요금 및 GB당 데이터 처리 요금이 100% 무료** 이며 트래픽이 AWS 내부 백본으로 직접 흐릅니다. 또한 나머지 외부 인터넷 통신을 위해 **각 AZ마다 독립된 NAT Gateway와 라우팅 테이블** 을 두면 AZ-b/AZ-c에서 AZ-a의 NAT Gateway를 넘나들며 부과되던 **Cross-AZ 전송 요금($0.01/GB 인·아웃 = 왕복 $0.02/GB)** 과 단일 AZ NAT 장애 위험(SPOF)을 동시에 제거합니다.\n"
            "• 오답 분석:\n"
            "  - B: ECS 태스크를 Public Subnet에 노출하는 것은 사설 통신 보안 원칙을 깨뜨립니다.\n"
            "  - C: S3 Interface Endpoint는 시간당 및 GB당 요금이 부과되며 DynamoDB는 Gateway Endpoint가 표준 무료 옵션입니다(Interface Endpoint는 온프레미스 DX/VPN에서 S3 접근 시 필요).\n"
            "  - D: NAT Instance 1대를 AZ-a에 두어도 AZ-b/AZ-c와의 Cross-AZ 데이터 전송 요금은 동일하게 부과됩니다."
        ),
        "SAP-C02 비용 절감 1순위 패턴: Private Subnet의 S3/DDB 트래픽 = **무료 Gateway VPC Endpoint**, NAT GW 교차 AZ 요금 제거 = **AZ별 NAT Gateway + AZ별 Route Table**!"
    ),
    (
        4, 13, 3, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] CloudWatch Embedded Metric Format(EMF) 비용 절감 및 Contributor Insights 실시간 장애 분석",
        (
            "수십 개의 컨테이너 마이크로서비스가 초당 수만 건의 비즈니스 트랜잭션을 처리하면서, 기존에 매 요청마다 AWS SDK `PutMetricData` API를 호출해 "
            "커스텀 메트릭을 전송하던 방식 때문에 CloudWatch API 비용이 급증하고 스로틀링이 발생하고 있습니다. "
            "또한 장애 발생 시 `CloudWatch Logs` 에서 어떤 `tenant_id` 또는 `endpoint` 가 HTTP 500 오류의 상위 Top 10을 차지하는지 "
            "복잡한 쿼리를 매번 수동 실행하지 않고 실시간 시계열 그래프로 즉시 파악하고자 합니다.\n\n"
            "이 두 가지 관측성(Observability) 문제를 해결하는 기능 조합 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Observability Pain Points:\n1) High PutMetricData API call costs & throttling from synchronous SDK calls\n2) Need real-time Top-N high-cardinality offender ranking (top tenant_id / endpoint causing HTTP 500)",
        [
            {"label": "A", "text": "애플리케이션이 구조화된 JSON 로그에 CloudWatch Embedded Metric Format(EMF) 규격으로 메트릭을 함께 기록해 PutMetricData API 호출 없이 비동기 자동 메트릭 추출을 수행한다."},
            {"label": "B", "text": "Amazon CloudWatch Logs Contributor Insights 규칙을 생성해 로그 이벤트의 tenant_id 및 endpoint별 HTTP 500 발생 상위 Top-N 순위를 실시간으로 자동 집계·시각화한다."},
            {"label": "C", "text": "모든 로그를 S3로 내보낸 뒤 매 1시간마다 EMR Spark 잡을 돌려 Top-N을 계산한다."},
            {"label": "D", "text": "PutMetricData 호출을 매 1초마다 동기식 재시도 루프로 감싸고 재시도 횟수를 50회로 늘린다."},
            {"label": "E", "text": "CloudTrail Management Events를 활성화하면 애플리케이션 내부 HTTP 500 에러의 tenant_id Top-N이 자동 표시된다."}
        ],
        ["A", "B"],
        "A, B) CloudWatch Embedded Metric Format(EMF)로 무API 커스텀 메트릭 추출 / CloudWatch Logs Contributor Insights로 실시간 Top-N 원인 추적",
        "CloudWatch Embedded Metric Format (EMF), Contributor Insights, High-Cardinality Observability, Zero PutMetricData Cost",
        (
            "• 정답(A, B):\n"
            "  - A: **CloudWatch Embedded Metric Format(EMF)** 은 표준 출력(`stdout`) 또는 CloudWatch Logs로 JSON 포맷의 로그를 남기면 CloudWatch가 백그라운드에서 커스텀 메트릭을 자동 추출합니다. 따라서 별도의 동기 `PutMetricData` 네트워크 호출·지연·API 호출 비용을 제거하면서 상세 원본 로그 컨텍스트까지 함께 보존할 수 있습니다.\n"
            "  - B: **CloudWatch Contributor Insights** 는 카디널리티가 높은 로그 필드(`tenant_id`, IP, URI 등)에서 가장 많은 오류나 트래픽을 유발하는 **Top-N 컨트리뷰터** 를 실시간으로 추출해 CloudWatch 대시보드 및 경보로 연결합니다.\n"
            "• 오답 분석:\n"
            "  - C: 1시간 배치 EMR은 실시간 장애 감지에 너무 느리고 비용이 큽니다.\n"
            "  - D: 동기 재시도 증가는 API 비용과 스로틀링을 악화시키고 애플리케이션 응답 지연만 키웁니다.\n"
            "  - E: CloudTrail은 AWS 제어 평면(API 호출) 감사 로그이지 애플리케이션 내부 HTTP 500 비즈니스 로그가 아닙니다."
        ),
        "커스텀 메트릭 + 로그 통합 (Zero PutMetricData) = **EMF**, 고카디널리티 Top-N 장애 원인 실시간 랭킹 = **CloudWatch Contributor Insights**!"
    ),
    (
        4, 14, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] 단일 샤드 ElastiCache for Redis CPU 100% 병목 해소 및 다중 샤드 수평 확장",
        (
            "대형 쇼핑몰의 장바구니·세션 캐시가 **Amazon ElastiCache for Redis (Cluster Mode Disabled, 단일 샤드 + Read Replica 2대)** 로 운영되고 있습니다. "
            "전체 메모리 사용량은 30% 미만으로 여유가 넘치지만, 대형 세일 시간대마다 쓰기 요청과 루아 스크립트(Lua Script) 연산이 급증하면서 "
            "단일 Primary 노드의 `EngineCPUUtilization` 이 100%에 도달해 전체 사이트 응답이 멈추는 장애가 발생합니다. (Redis 메인 명령 엔진은 단일 스레드 기반)\n\n"
            "애플리케이션 성능을 근본적으로 수평 확장하고 고가용성을 유지하는 아키텍처 개선안은 무엇입니까?"
        ),
        "Symptom:\n- ElastiCache Redis Cluster Mode Disabled (1 Shard = 1 Primary + 2 Replicas)\n- Memory usage < 30%, yet EngineCPUUtilization hits 100% on Primary due to writes/commands",
        [
            {"label": "A", "text": "Cluster Mode Disabled 상태를 유지한 채 Read Replica만 5대로 늘리면 쓰기 CPU 병목이 즉시 분산된다."},
            {"label": "B", "text": "ElastiCache Redis를 Cluster Mode Enabled(CME)로 전환하여 키 공간을 여러 샤드(예: 4~8개 샤드, 각 샤드별 Multi-AZ 복제본 보유)로 수평 파티셔닝하고, 읽기 부하는 복제본에서도 분산 처리하도록 구성한다."},
            {"label": "C", "text": "Redis의 메모리를 2배 큰 인스턴스로 변경하되 vCPU 클럭이 동일하면 단일 스레드 엔진 병목이 즉시 50% 감소한다."},
            {"label": "D", "text": "ElastiCache Memcached로 바꾼 뒤 Multi-AZ 자동 장애 조치(Auto Failover)를 활성화한다."}
        ],
        ["B"],
        "B) ElastiCache Redis를 Cluster Mode Enabled(CME)로 전환해 다중 샤드로 쓰기·연산 CPU 부하를 수평 분산하고 각 샤드에 Multi-AZ 복제본을 배치한다.",
        "ElastiCache Redis Cluster Mode Enabled (CME), EngineCPUUtilization, Write Scaling, Multi-Shard Partitioning",
        (
            "• 정답(B): Redis 명령 처리 엔진은 코어당 단일 스레드(Single-threaded command execution)이므로 **Cluster Mode Disabled(단일 샤드)** 환경에서는 모든 쓰기가 단 하나의 Primary 노드 코어로 집중되어 `EngineCPUUtilization` 이 100% 병목에 부딪힙니다. **Cluster Mode Enabled(CME)** 로 전환하면 해시 슬롯(16,384개)이 여러 샤드에 분산되어 쓰기와 CPU 부하가 샤드 수에 비례해 수평 확장되며, 각 샤드당 Multi-AZ 복제본으로 고가용성과 읽기 확장을 동시에 달성합니다.\n"
            "• 오답 분석:\n"
            "  - A: Cluster Mode Disabled에서 Read Replica를 늘려도 쓰기는 오직 1개 Primary로만 가기 때문에 쓰기 CPU 병목을 해결할 수 없습니다.\n"
            "  - C: 코어 수(vCPU)와 메모리만 늘어나도 단일 샤드 Redis 명령 스레드는 여전히 1개 코어 속도에 묶입니다.\n"
            "  - D: Memcached는 Multi-AZ 자동 장애 조치와 영속성(Persistence)/Lua/복잡한 자료구조를 지원하지 않습니다."
        ),
        "ElastiCache 핵심 구분: **Cluster Mode Disabled** = 1 Primary(쓰기 확장 불가, 읽기 복제본만 추가), **Cluster Mode Enabled** = 다중 샤드(쓰기 수평 확장 + 샤드별 Multi-AZ 복제)!"
    ),
    (
        4, 15, 3, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] 보안 운영(SecOps) 현대화: 취약점 자동 스캔(Inspector v2) + 침해 사고 근본 원인 그래프 분석(Detective)",
        (
            "보안운영센터(SOC) 팀이 반복적인 수작업 보안 운영 때문에 대응 시간이 길어지고 있습니다:\n"
            "1) 기존에는 월 1회 수동으로 EC2에 Nessus 에이전트 SSH 접속을 돌려 OS 패키지 취약점(CVE)을 점검했으며, ECR 컨테이너 이미지와 Lambda 함수의 라이브러리 취약점은 아예 추적하지 못하고 있습니다.\n"
            "2) Amazon GuardDuty 경보가 발생하면 분석가가 CloudTrail, VPC Flow Logs, EKS 감사 로그를 수작업으로 조인해 공격자의 최초 진입 경로와 영향 범위를 파악하는 데 6시간 이상 걸립니다.\n\n"
            "이 두 가지 보안 운영 프로세스를 자동화·고도화하는 AWS 서비스 2가지는 무엇입니까? (Select TWO.)"
        ),
        "SecOps Improvements:\n1) Continuous automated CVE scanning across EC2 (via SSM), ECR containers, and Lambda functions\n2) Automated graph correlation of GuardDuty + CloudTrail + VPC Flow Logs + EKS audit logs for rapid root-cause investigation",
        [
            {"label": "A", "text": "Amazon Inspector (v2)를 조직 단위로 활성화하여 SSM Agent 기반 EC2, ECR 컨테이너 이미지, Lambda 함수의 소프트웨어 취약점(CVE) 및 네트워크 도달 가능성을 지속·자동 스캔한다."},
            {"label": "B", "text": "Amazon Detective를 활성화하여 GuardDuty, CloudTrail, VPC Flow Logs, EKS 감사 로그를 자동 상관분석한 인터랙티브 보안 그래프로 침해 사고 근본 원인(RCA)을 신속히 추적한다."},
            {"label": "C", "text": "Amazon Macie만 활성화하면 EC2 OS 커널 CVE 취약점과 VPC Flow Logs 공격 경로가 모두 자동 시각화된다."},
            {"label": "D", "text": "AWS Artifact를 사용해 실시간 GuardDuty 경보와 VPC Flow Logs 패킷 상관분석을 수행한다."},
            {"label": "E", "text": "AWS Shield Standard를 활성화하면 컨테이너 이미지 내 Log4j CVE 취약점이 자동 패치된다."}
        ],
        ["A", "B"],
        "A, B) 지속적 EC2/ECR/Lambda CVE 취약점 스캔은 Amazon Inspector v2 / GuardDuty·CloudTrail·VPC Flow Logs 상관분석 RCA는 Amazon Detective",
        "Amazon Inspector v2, Amazon Detective, Continuous CVE Scanning, GuardDuty RCA, Security Hub",
        (
            "• 정답(A, B):\n"
            "  - A: **Amazon Inspector(v2)** 는 별도 스캐너 인프라 관리 없이 EC2(SSM Agent 활용), **ECR 컨테이너 이미지**, **Lambda 함수/계층** 의 패키지 CVE 취약점과 의도치 않은 네트워크 노출을 실시간·지속적으로 자동 탐지합니다.\n"
            "  - B: **Amazon Detective** 는 CloudTrail, VPC Flow Logs, GuardDuty 탐지 결과, EKS 감사 로그를 머신러닝과 그래프 모델로 자동 통합·시각화하여 보안 분석가가 수 시간 걸리던 침해 경로(RCA) 조사를 수 분 내에 완료하게 돕습니다.\n"
            "• 오답 분석:\n"
            "  - C: Amazon Macie는 S3 내 민감 데이터(PII/신용카드/주민번호 등) 탐지 전용 서비스입니다.\n"
            "  - D: AWS Artifact는 규정 준수 보고서(SOC, ISO, PCI 등) 및 약관(BAA) 다운로드 포털입니다.\n"
            "  - E: AWS Shield Standard는 L3/L4 DDoS 방어 서비스이지 취약점 스캔/패치 도구가 아닙니다."
        ),
        "AWS 보안 5대장 구분: **GuardDuty**(위협 탐지) -> **Detective**(로그 상관분석 RCA), **Inspector**(EC2/ECR/Lambda CVE 취약점), **Macie**(S3 PII 탐지), **Security Hub**(전사 통합 대시보드/CSPM)!"
    ),
    (
        4, 16, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3] Aurora I/O-Optimized 스토리지 비용 최적화 및 RDS Blue/Green 무중단 메이저 업그레이드",
        (
            "대용량 실시간 정산 시스템을 운영하는 Amazon Aurora PostgreSQL 클러스터(Primary + Reader 2대)에서 월 전체 DB 청구 금액 중 **스토리지 I/O 요청 요금(I/O charges)이 42%** 를 차지하고 있습니다. "
            "또한 현재 실행 중인 PostgreSQL 13 버전을 PostgreSQL 16으로 메이저 업그레이드하면서 스키마 인덱스 재구성까지 사전 검증해야 하는데, "
            "서비스 중단 시간은 반드시 **1분 미만** 이어야 합니다.\n\n"
            "I/O 비용 절감과 초저다운타임 메이저 업그레이드 요건을 모두 달성하는 가장 적절한 조합은 무엇입니까?"
        ),
        "Aurora Optimization:\n1) Storage I/O cost = 42% of total Aurora bill (>25% threshold)\n2) Major version upgrade (PG 13 -> PG 16) + schema verification with <1 min cutover downtime",
        [
            {"label": "A", "text": "클러스터 스토리지 구성을 Aurora I/O-Optimized로 전환해 읽기/쓰기 I/O 요금을 0원으로 예측 가능하게 만들고, Amazon RDS Blue/Green Deployments로 스테이징 Green 환경에서 PG 16 업그레이드·검증을 마친 뒤 1분 미만 Switchover를 수행한다."},
            {"label": "B", "text": "Aurora Standard 구성을 유지한 채 인플레이스(In-place) 메이저 업그레이드를 프로덕션 클러스터에 직접 실행해 30분간 서비스를 중단한다."},
            {"label": "C", "text": "Aurora 대신 단일 AZ EC2에 PostgreSQL을 수동 설치하면 모든 EBS gp3 I/O 비용과 다중 AZ 가용성이 자동 최적화된다."},
            {"label": "D", "text": "프로덕션 스냅샷을 떠서 수동으로 새 클러스터를 복원한 뒤 애플리케이션 코드를 멈추고 2시간 동안 수동 데이터 정합성을 맞춘다."}
        ],
        ["A"],
        "A) 클러스터 스토리지를 Aurora I/O-Optimized로 전환해 과도한 I/O 요금을 제거하고, RDS Blue/Green Deployments로 스테이징 업그레이드 검증 후 1분 미만 Switchover를 수행한다.",
        "Aurora I/O-Optimized, RDS Blue/Green Deployments, Major Version Upgrade, Near-Zero Downtime Cutover",
        (
            "• 정답(A): **Aurora I/O-Optimized** 는 스토리지/컴퓨팅 단가가 다소 높은 대신 **I/O 요청당 과금을 완전히 없애주므로**, 전체 Aurora 지출 중 I/O 비용이 약 25%를 넘는 워크로드(이 사례는 42%)에서 최대 40%의 비용 절감과 예측 가능한 청구 구조를 제공합니다. 또한 **Amazon RDS Blue/Green Deployments** 는 프로덕션(Blue)과 논리적 복제로 동기화된 스테이징 복제본(Green)을 생성해 Green에서 PG 16 메이저 업그레이드와 성능 테스트를 완료한 뒤 통상 1분 미만으로 안전하게 Switchover(및 가드레일 타임아웃 보호)를 수행합니다.\n"
            "• 오답 분석:\n"
            "  - B, D: 인플레이스 업그레이드나 스냅샷 복원 후 수동 동기화는 수십 분~수 시간의 다운타임이 발생해 1분 미만 요건을 위반합니다.\n"
            "  - C: 단일 AZ EC2 자체 DB 구축은 가용성과 관리 효율성이 크게 후퇴합니다."
        ),
        "Aurora 청구액 중 **I/O 비용 > 25%** = **Aurora I/O-Optimized** 전환! DB 메이저 버전/스키마 변경 시 <1분 중단 = **RDS Blue/Green Deployments**!"
    ),

    # =========================================================================
    # ROUND 5 (SET 4): Domain 4 — Accelerate Workload Migration & Modernization (16 Questions)
    # =========================================================================
    (
        5, 1, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] AWS Application Migration Service(MGN) 기반 대량 서버 무중단 Rehost 및 컷오버 자동화",
        (
            "제조 대기업이 180대의 온프레미스 물리 서버 및 가상 머신(Windows Server, RHEL Linux 혼합, 커스텀 커널 드라이버 포함)을 "
            "애플리케이션 코드 변경 없이 최대한 빠르게 AWS EC2로 이전(Rehost)하려고 합니다. "
            "주말 4시간의 컷오버 창 내에 일괄 전환되어야 하며, 전환 전 비파괴적 리허설 테스트와 전환 직후 모든 서버에 CloudWatch Agent 및 SSM 설정을 자동 적용해야 합니다.\n\n"
            "가장 권장되는 마이그레이션 서비스와 아키텍처는 무엇입니까?"
        ),
        "Migration Profile:\n- 180 physical & VM servers (Windows + Linux, custom kernel modules)\n- Rehost (Lift & Shift) within 4-hour cutover window\n- Non-disruptive test + automated post-launch CloudWatch/SSM installation",
        [
            {"label": "A", "text": "AWS Application Migration Service(AWS MGN) 에이전트를 원본 서버에 설치해 저비용 스테이징 서브넷의 경량 복제 서버·EBS 볼륨으로 지속적 블록 수준 복제를 수행하고, 사전에 비파괴 테스트 실행(Test Launch)으로 검증한 뒤 컷오버 시 Post-Launch Actions를 통해 SSM/CloudWatch Agent를 자동 구성한다."},
            {"label": "B", "text": "주말 4시간 동안 180대 서버를 모두 중지한 뒤 VMware OVA 이미지를 수동 Export해 S3에 올리고 VM Import/Export로 순차 변환한다."},
            {"label": "C", "text": "AWS Database Migration Service(DMS)를 사용해 Linux와 Windows 운영체제 파일시스템과 커널을 블록 복제한다."},
            {"label": "D", "text": "AWS Server Migration Service(SMS)만 사용해 물리 서버 180대의 실시간 CDC 복제를 수행한다."}
        ],
        ["A"],
        "A) AWS Application Migration Service(MGN)로 지속적 블록 수준 복제, 사전 비파괴 테스트, 컷오버 및 Post-Launch Actions(CloudWatch/SSM 자동 설치)를 수행한다.",
        "AWS Application Migration Service (MGN), Rehost, Block-level Continuous Replication, Post-Launch Actions, Cutover",
        (
            "• 정답(A): **AWS MGN(Application Migration Service)** 은 물리·가상·타 클라우드 서버의 OS/애플리케이션/DB를 최소 다운타임으로 AWS로 이전하는 표준 Rehost 서비스입니다. 원본 서버의 AWS Replication Agent가 변경 블록을 실시간으로 스테이징 영역에 동기화하므로, 컷오버 시 전체 이미지 재전송 없이 수 분~수십 분 내 대상 EC2를 기동할 수 있으며 **Post-Launch Actions** 로 전환 직후 SSM/보안 에이전트 설치를 자동화합니다.\n"
            "• 오답 분석:\n"
            "  - B: 180대 서버의 OVA Export + S3 업로드 + 순차 Import는 수일 이상 걸려 4시간 컷오버 창을 맞출 수 없으며 물리 서버는 OVA로 내보낼 수 없습니다.\n"
            "  - C: DMS는 데이터베이스 테이블·데이터 마이그레이션 전용입니다.\n"
            "  - D: AWS SMS는 레거시(지원 종료/MGN으로 통합 대체됨) 서비스이며 물리 서버 에이전트 복제를 지원하지 않았습니다."
        ),
        "물리/가상 서버 Lift-and-Shift(Rehost) 최소 다운타임 이전 = **AWS MGN (Application Migration Service)**!"
    ),
    (
        5, 2, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 데이터센터 계약 만료 긴급 이전: VMware Cloud on AWS(Relocate) vs MGN(Rehost)",
        (
            "금융사의 온프레미스 데이터센터 임대 계약이 45일 뒤 만료됩니다. 해당 데이터센터에는 VMware vSphere 기반의 300개 VM이 운영 중이며, "
            "레거시 금융 애플리케이션들이 **하드코딩된 L2 사설 IP 주소**, vCenter 태그, NSX-T 마이크로세그멘테이션 정책에 강하게 의존하고 있습니다. "
            "보안·개발팀은 45일 안에 애플리케이션 IP 재할당이나 OS 내부 에이전트 설치, 하이퍼바이저 재교육을 수행할 시간이 전혀 없습니다.\n\n"
            "7R 전략 중 이 상황에 가장 적합한 전략과 AWS 솔루션은 무엇입니까?"
        ),
        "Urgent Constraints (45 days):\n- 300 VMware vSphere VMs with hardcoded Layer 2 IPs & NSX-T rules\n- Zero OS agent installation, zero IP re-addressing, preserve vCenter operations",
        [
            {"label": "A", "text": "Refactor 전략: 45일 안에 300개 VM을 모두 Kubernetes 마이크로서비스(EKS)로 재개발한다."},
            {"label": "B", "text": "Relocate 전략: VMware Cloud on AWS(VMC) SDDC를 프로비저닝하고 VMware HCX L2 Stretch 및 vMotion으로 라이브 마이그레이션하여 IP 변경과 OS 에이전트 설치 없이 동일 vSphere 도구로 즉시 운영한다."},
            {"label": "C", "text": "Rehost 전략: 모든 VM 내부에 AWS MGN 에이전트를 설치하고 VPC 서브넷 IP를 새로 할당해 애플리케이션 설정 파일을 전수 수정한다."},
            {"label": "D", "text": "Repurchase 전략: 모든 독자 개발 금융 레거시 코어를 제3자 SaaS로 45일 만에 교체한다."}
        ],
        ["B"],
        "B) Relocate 전략: VMware Cloud on AWS + VMware HCX(L2 네트워크 확장 + vMotion)를 통해 IP 변경이나 OS 에이전트 설치 없이 라이브 마이그레이션한다.",
        "7Rs Relocate Strategy, VMware Cloud on AWS, VMware HCX, L2 Stretch, vMotion, Zero IP Change",
        (
            "• 정답(B): AWS 7R 전략 중 **Relocate(재배치)** 는 하이퍼바이저 수준의 호환 환경을 그대로 옮기는 전략으로, 대표 사례가 **VMware Cloud on AWS** (또는 EKS Anywhere 등 컨테이너 재배치)입니다. VMware HCX L2 Stretch와 Live vMotion을 이용하면 게스트 OS 내 에이전트 설치나 **하드코딩된 사설 IP 변경 없이** 무중단으로 클라우드로 이전하고 기존 vCenter/NSX 운영 역량을 100% 재사용할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - A, D: 300개 레거시 금융 시스템의 Refactor나 SaaS Repurchase는 45일 기한 내 불가능합니다.\n"
            "  - C: MGN Rehost는 OS 내 에이전트 설치 및 AWS VPC CIDR/IP 재할당이 수반되어 제약 조건에 어긋납니다."
        ),
        "7Rs 감별 포인트: 'VMware vSphere 그대로 + L2 IP 변경 불가 + 에이전트 설치 불가 + 빠른 데이터센터 탈출' = **Relocate (VMware Cloud on AWS)**!"
    ),
    (
        5, 3, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 12 TB 온프레미스 Oracle RAC -> Amazon Aurora PostgreSQL 이기종 무중단 마이그레이션 (SCT + DMS)",
        (
            "통신사가 라이선스 비용 절감을 위해 온프레미스 12 TB **Oracle RAC** 데이터베이스(수백 개의 PL/SQL 패키지, 트리거, BLOB 컬럼 포함)를 "
            "**Amazon Aurora PostgreSQL** 로 이기종 전환(Replatform/Refactor)하려고 합니다. "
            "전체 데이터 초기 적재에 18시간 이상이 소요될 것으로 예상되지만, 실제 서비스 중단 시간(Cutover Downtime)은 **30분 미만** 으로 유지해야 하며, "
            "BLOB 데이터가 100% 무손실로 이관되어야 합니다.\n\n"
            "이 이기종 DB 마이그레이션의 올바른 단계별 아키텍처는 무엇입니까?"
        ),
        "Heterogeneous DB Migration:\nSource: 12 TB On-Prem Oracle RAC (PL/SQL stored procedures, triggers, LOBs <= 20 MB)\nTarget: Amazon Aurora PostgreSQL (<30 min downtime)",
        [
            {"label": "A", "text": "Oracle Data Guard를 Aurora PostgreSQL에 직접 연결해 물리적 Redo 로그를 복제한다."},
            {"label": "B", "text": "AWS Schema Conversion Tool(SCT)로 테이블 DDL 및 PL/SQL 패키지를 PostgreSQL 호환 구문으로 변환·적용한 뒤(초기 적재 동안 대상 DB의 FK/트리거/보조 인덱스는 일시 비활성화), AWS DMS 'Full Load + CDC' 태스크를 적절한 LOB 모드(Limited LOB Max Size 지정)와 DMS Data Validation으로 실행하고 컷오버 직전 인덱스/FK를 복원 후 전환한다."},
            {"label": "C", "text": "AWS DMS만 실행하면 Oracle PL/SQL 스토어드 프로시저와 트리거가 자동으로 PostgreSQL 코드로 100% 변환·이관된다."},
            {"label": "D", "text": "Full Load 도중 30분 이상의 중단을 감수할 수 없으므로 DMS Unlimited LOB 모드를 활성화해 12 TB를 단일 스레드로 처리한다."}
        ],
        ["B"],
        "B) AWS SCT로 스키마 및 PL/SQL을 변환하고(대량 적재 중 FK·트리거·보조 인덱스 비활성화), AWS DMS Full Load + CDC + 적절한 LOB 설정 + Data Validation을 거쳐 30분 미만으로 컷오버한다.",
        "AWS Schema Conversion Tool (SCT), AWS DMS Full Load + CDC, Heterogeneous Migration, LOB Mode, Data Validation",
        (
            "• 정답(B): 이기종 DB(Oracle → Aurora PostgreSQL) 전환에서는 **AWS SCT** 가 테이블·뷰·PL/SQL 코드 변환을 담당하고, **AWS DMS** 가 **Full Load + CDC(변경 데이터 캡처)** 를 통해 초기 적재 중 발생하는 실시간 트랜잭션을 추적·반영하여 컷오버 다운타임을 수 분~30분 미만으로 압축합니다. 또한 Full Load 중 대상의 보조 인덱스·FK·트리거를 비활성화했다가 CDC 전 복원해야 적재 속도가 극대화되며, LOB(BLOB/CLOB) 크기를 파악해 **Limited LOB 모드**(`LobMaxSize` 설정)를 써야 병렬 성능을 유지하면서 데이터 잘림을 막을 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - A: Oracle Data Guard는 동종 Oracle 엔진 전용이며 PostgreSQL과 호환되지 않습니다.\n"
            "  - C: AWS DMS는 최소한의 테이블 구조만 생성할 뿐 스토어드 프로시저, 패키지, 트리거 등 비즈니스 코드를 변환하지 못합니다(반드시 **SCT** 필요).\n"
            "  - D: Unlimited LOB 모드는 성능이 크게 느려지고 12 TB 적재 시 극심한 병목을 유발하므로 최대 LOB 크기를 안다면 Limited LOB 모드가 권장됩니다."
        ),
        "이기종 DB 전환 공식 = **SCT(스키마+코드 변환) + DMS(Full Load + CDC 데이터 복제)**! Full Load 시에는 대상 **보조 인덱스/트리거/FK 비활성화** 필수!"
    ),
    (
        5, 4, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 동종(Homogeneous) MySQL -> Aurora MySQL 대용량 마이그레이션: 네이티브 복제 vs DMS 선택",
        (
            "이커머스 기업이 온프레미스의 5 TB 자체 관리형 **MySQL 8.0** 데이터베이스를 **Amazon Aurora MySQL** 로 마이그레이션하려 합니다. "
            "해당 DB는 자동 증가(AUTO_INCREMENT) 기본키, 수십 개의 트리거, 파티션 테이블 및 고빈도 트랜잭션이 섞여 있으며, "
            "스키마 변환 없이 가능한 한 원본 인덱스·트리거·스토어드 프로시저·자동 증가 시퀀스를 그대로 완벽히 보존하면서 10분 미만 다운타임으로 전환해야 합니다.\n\n"
            "이 동종(Homogeneous) 마이그레이션에 가장 적합한 기술 방식은 무엇입니까?"
        ),
        "Homogeneous Migration:\nSource: 5 TB MySQL 8.0 (Auto-increment PKs, triggers, stored procs, secondary indexes)\nTarget: Amazon Aurora MySQL (<10 min downtime)",
        [
            {"label": "A", "text": "AWS SCT를 반드시 실행해 MySQL 8.0을 Aurora MySQL 스키마로 이기종 변환해야 한다."},
            {"label": "B", "text": "MySQL 네이티브 백업·복제 도구(Percona XtraBackup/mysqldump로 S3 기반 초기 Aurora 클러스터 복원 후, 온프레미스 MySQL과 Aurora 간 네이티브 Binary Log(Binlog) 복제를 연결하고 동기화 완료 시 컷오버) 또는 Aurora MySQL Read Replica 승격을 사용한다."},
            {"label": "C", "text": "AWS DMS에서 타깃 테이블을 삭제 후 재생성(Drop tables on target) 모드로 실행하면 모든 트리거와 AUTO_INCREMENT 속성이 자동 복사된다."},
            {"label": "D", "text": "Oracle RMAN을 사용해 MySQL 데이터를 Aurora로 복구한다."}
        ],
        ["B"],
        "B) 동종(Homogeneous) MySQL -> Aurora MySQL 전환이므로 Percona XtraBackup(S3 Import) + 네이티브 Binlog 복제(또는 Aurora Read Replica 연결 후 승격)를 사용해 인덱스·트리거·AUTO_INCREMENT를 100% 보존하고 초단기 컷오버를 수행한다.",
        "Homogeneous DB Migration, Native Binlog Replication, Percona XtraBackup, Aurora S3 Restore, DMS Limitations",
        (
            "• 정답(B): AWS DMS는 이기종 전환에는 필수지만, 동종 전환에서 `Drop and Recreate` 시 **보조 인덱스, AUTO_INCREMENT, 트리거, 외래키 제약, 스토어드 프로시저를 복사하지 않는 제약** 이 있습니다. 반면 **동종(MySQL → Aurora MySQL)** 전환에서는 **Percona XtraBackup → S3에서 Aurora 클러스터 직접 복원 + 네이티브 MySQL Binlog 복제(CDC)** 를 사용하면 모든 DB 객체·트리거·인덱스·시퀀스가 100% 원형 보존되며 컷오버 다운타임도 수 분 미만으로 최소화됩니다.\n"
            "• 오답 분석:\n"
            "  - A: 동일 엔진(MySQL ↔ Aurora MySQL) 간에는 SCT가 필요 없습니다.\n"
            "  - C: DMS는 기본적으로 타깃에 기본키/테이블 구조만 생성하며 트리거·AUTO_INCREMENT·보조 인덱스를 이관하지 않습니다.\n"
            "  - D: RMAN은 Oracle 전용 도구입니다."
        ),
        "SAP-C02 DB 전환 핵심 감별: **이기종(Oracle/SQLServer -> PG/MySQL)** = SCT + DMS, **동종(MySQL->Aurora MySQL, PG->Aurora PG)** = **네이티브 도구(Binlog / pg_dump + Logical Replication / Percona XtraBackup)** 가 우월!"
    ),
    (
        5, 5, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 대규모 포트폴리오 7R 전략 매핑 (Repurchase · Replatform · Retain · Refactor)",
        (
            "클라우드 전환 프로젝트 팀이 사내 4개 핵심 업무 시스템에 대한 7R 마이그레이션 전략을 분류하고 있습니다:\n"
            "• **시스템 1 (사내 구형 ERP 인사/급여 모듈)**: 자체 커스터마이징 유지 비용이 과다하여 상용 클라우드 SaaS(Workday 등) 구독으로 대체 결정\n"
            "• **시스템 2 (Java Spring Tomcat 웹 앱 + 자체 MySQL)**: 코드 재작성 없이 호스팅 서버와 DB만 각각 Elastic Beanstalk/ECS 및 Amazon RDS로 이전\n"
            "• **시스템 3 (공장 설비 제어용 초저지연 PLC 연동 온프레미스 서버)**: 클라우드 이전 시 ROI가 없고 하드웨어 결속이 강해 당분간 온프레미스에 유지\n"
            "• **시스템 4 (핵심 주문 모놀리스)**: 비즈니스 민첩성과 10배 트래픽 확장을 위해 이벤트 기반 서버리스·마이크로서비스(Lambda + EventBridge + DynamoDB)로 재설계\n\n"
            "시스템 1~4에 순서대로 올바르게 매핑된 7R 전략은 무엇입니까?"
        ),
        "Portfolio Classification (7 Rs of Migration):\nSystem 1 -> Commercial Cloud SaaS | System 2 -> Managed Elastic Beanstalk + RDS\nSystem 3 -> Keep on-premises for now | System 4 -> Cloud-native serverless redesign",
        [
            {"label": "A", "text": "Repurchase — Replatform — Retain — Refactor"},
            {"label": "B", "text": "Rehost — Relocate — Retire — Repurchase"},
            {"label": "C", "text": "Refactor — Rehost — Replatform — Retain"},
            {"label": "D", "text": "Retire — Refactor — Relocate — Rehost"}
        ],
        ["A"],
        "A) Repurchase (SaaS 교체) — Replatform (관리형 플랫폼 변경, 코드 무수정) — Retain (유지) — Refactor (클라우드 네이티브 재아키텍처)",
        "7Rs Migration Strategy, Repurchase, Replatform, Retain, Refactor, Portfolio Assessment",
        (
            "• 정답(A):\n"
            "  - **Repurchase(Drop and Shop)**: 기존 시스템을 버리고 Workday/Salesforce 같은 **SaaS 제품 구매/구독** 으로 전환 (시스템 1)\n"
            "  - **Replatform(Lift-Tinker-and-Shift)**: 핵심 아키텍처/코드는 바꾸지 않고 DB를 **RDS** 로, 앱 서버를 **Elastic Beanstalk/ECS** 등 관리형 플랫폼으로 소폭 조정 이전 (시스템 2)\n"
            "  - **Retain(Revisit)**: 규제·하드웨어 종속·최근 투자 등으로 **현시점 온프레미스 유지** (시스템 3)\n"
            "  - **Refactor / Re-architect**: 확장성·민첩성을 위해 **클라우드 네이티브(서버리스/MSA)** 로 전면 재설계 (시스템 4)\n"
            "• 오답 분석:\n"
            "  - B, C, D: 각 7R 용어의 정의(특히 SaaS=Repurchase, 관리형 RDS 전환=Replatform, 유지=Retain, 폐기=Retire)가 잘못 매칭되었습니다."
        ),
        "7Rs 암기: Rehost(EC2/MGN), Relocate(VMC/EKS), Replatform(RDS/Managed), Repurchase(SaaS), Refactor(서버리스/MSA), Retain(보류유지), Retire(폐기)."
    ),
    (
        5, 6, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] Strangler Fig 패턴 기반 모놀리스 점진적 무중단 마이크로서비스 전환",
        (
            "10년 된 거대 전자상거래 모놀리스(`shop.example.com`)를 한 번에 모두 교체(Big-Bang)하는 것은 실패 리스크가 너무 큽니다. "
            "아키텍처 팀은 클라이언트 모바일 앱이나 웹 도메인을 변경하지 않고, 먼저 결제(`/api/checkout/*`)와 검색(`/api/search/*`) 기능부터 "
            "독립된 신규 마이크로서비스(ECS Fargate / Lambda)로 추출하여 카나리 비율(5% -> 50% -> 100%)로 안전하게 트래픽을 넘기면서 점진적으로 기존 모놀리스를 축소·제거하려 합니다.\n\n"
            "이 Strangler Fig(교살자 무화과) 패턴의 라우팅 및 데이터 동기화 설계로 가장 적절한 것은 무엇입니까?"
        ),
        "Strangler Fig Modernization:\nClient (shop.example.com) -> Edge/Router Proxy ->\n  - Legacy paths (/api/*) -> Monolith EC2\n  - Extracted paths (/api/checkout/*) -> Weighted Canary (5% -> 100%) -> New Microservice",
        [
            {"label": "A", "text": "모놀리스 앞단에 Amazon CloudFront + ALB(또는 API Gateway) 패스 기반/가중치 타깃 그룹 라우팅(Weighted Target Groups)을 배치해 특정 URI 경로만 신규 마이크로서비스로 점진적 트래픽 전환(Canary)하고, 과도기 데이터 동기화는 CDC(DMS/Debezium) 또는 Transactional Outbox 패턴으로 모놀리스 DB와 분리한다."},
            {"label": "B", "text": "전환 기간 1년 동안 모든 신규 마이크로서비스와 기존 모놀리스가 단일 온프레미스 Oracle 데이터베이스의 동일 테이블에 직접 양방향 SQL 조인을 수행하게 둔다."},
            {"label": "C", "text": "사용자에게 `/v2` 전용 완전히 다른 도메인(`checkout-new.example.net`)을 공지해 브라우저 북마크를 바꾸게 하고 모놀리스는 컷오버 날 일시에 전원 종료한다."},
            {"label": "D", "text": "모든 모놀리스 코드를 AWS Lambda 단일 함수 1개로 통째로 복사해 15분 타임아웃으로 실행한다."}
        ],
        ["A"],
        "A) 앞단 CloudFront/ALB/API Gateway의 경로 기반 가중치 라우팅으로 트래픽을 점진적(Canary) 전환하고, 과도기 DB 결합은 CDC/Outbox 이벤트로 분리하는 Strangler Fig 패턴을 적용한다.",
        "Strangler Fig Pattern, Weighted Target Groups, Path-Based Routing, CDC Outbox, Monolith Modernization",
        (
            "• 정답(A): **Strangler Fig 패턴** 의 핵심은 앞단에 **파사드/라우터 계층(ALB Weighted Target Group, API Gateway, CloudFront)** 을 두고 클라이언트에 투명하게 특정 경로(`/api/checkout/*`)만 새 마이크로서비스로 카나리 전환하는 것입니다. 또한 데이터베이스 공유 결합을 끊기 위해 과도기에는 **AWS DMS CDC / Outbox 패턴** 으로 비동기 복제하여 모놀리스와 신규 서비스의 배포 독립성을 지킵니다.\n"
            "• 오답 분석:\n"
            "  - B: 공유 데이터베이스 직접 조인은 마이크로서비스의 핵심 목표인 독립 배포 및 장애 격리를 무력화합니다(Distributed Monolith 안티패턴).\n"
            "  - C: 도메인 변경 및 Big-Bang 종료는 무중단·점진적 Strangler Fig 요구사항을 위반합니다.\n"
            "  - D: 거대 모놀리스를 단일 Lambda로 넣는 것은 크기·타임아웃·상태 비저장 원칙에 위배됩니다."
        ),
        "점진적 모놀리스 해체 = **Strangler Fig 패턴**: 앞단 **경로/가중치 라우팅(ALB/API GW/CloudFront)** + 데이터 분리(**CDC/Outbox**)."
    ),
    (
        5, 7, 4, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 레거시 Java/ASP.NET VM의 무코드 컨테이너화(App2Container) 및 서버리스 Fargate 현대화",
        (
            "엔터프라이즈 기업이 온프레미스 VM에서 실행 중인 30개의 레거시 Java(Tomcat/JBoss) 및 ASP.NET(.NET Framework/IIS) 웹 애플리케이션을 "
            "대규모 소스코드 재작성 없이 신속하게 컨테이너화하여 AWS로 현대화하려고 합니다. "
            "또한 전환 후에는 EC2 워커 노드의 OS 패치나 클러스터 용량 관리 부담을 완전히 없애고 자동화된 CI/CD 배포 파이프라인을 생성하고 싶습니다.\n\n"
            "이를 가장 신속하게 달성하는 서비스 조합 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Legacy Apps: 30 Java Tomcat/JBoss & ASP.NET IIS apps on VMs (minimal/no code rewrite)\nTarget: Managed containers with ZERO EC2 worker OS patching + automated Dockerfile & CI/CD generation",
        [
            {"label": "A", "text": "AWS App2Container(A2C) CLI를 사용해 실행 중인 Java/ASP.NET 애플리케이션과 종속성을 자동 분석·추출하고 Dockerfile, ECR 컨테이너 이미지, ECS Task Definition 및 CodePipeline CI/CD 템플릿을 자동 생성한다."},
            {"label": "B", "text": "추출된 컨테이너를 EC2 데이터 플레인 관리가 필요 없는 Amazon ECS on AWS Fargate(Linux/Windows Fargate 지원)에 배포한다."},
            {"label": "C", "text": "AWS Application Migration Service(MGN)로 EC2에 올린 뒤 관리자가 30개 OS 패치를 매달 SSH로 수동 실행한다."},
            {"label": "D", "text": "ASP.NET .NET Framework 4.x 앱을 무조건 AWS Lambda Node.js 런타임으로 자동 변환해 배포한다."},
            {"label": "E", "text": "컨테이너 실행 호스트로 자체 관리 Kubernetes(kops)를 EC2 Auto Scaling 위에 구축한다."}
        ],
        ["A", "B"],
        "A, B) AWS App2Container(A2C)로 코드 재작성 없는 컨테이너 이미지·아티팩트·CI/CD 자동 생성 / AWS Fargate 기반 서버리스 컨테이너 실행",
        "AWS App2Container (A2C), ECS Fargate, Windows Containers on Fargate, Serverless Containers, Modernization",
        (
            "• 정답(A, B):\n"
            "  - A: **AWS App2Container(A2C)** 는 실행 중인 Java(Linux) 및 ASP.NET(Windows) 애플리케이션을 자동 인벤토리 분석하고 컨테이너 이미지, `Dockerfile`, ECR 업로드, ECS/EKS 배포 템플릿 및 CodeBuild/CodePipeline CI/CD까지 자동 생성해 줍니다.\n"
            "  - B: **Amazon ECS on AWS Fargate** (Windows 및 Linux 컨테이너 모두 지원)는 컨테이너 호스트 EC2 인스턴스를 프로비저닝·패치할 필요 없는 완전관리형 서버리스 컨테이너 런타임입니다.\n"
            "• 오답 분석:\n"
            "  - C: MGN은 Rehost(EC2 유지)이며 OS 패치 제거 요건에 맞지 않습니다.\n"
            "  - D: .NET Framework IIS 앱은 Node.js Lambda로 자동 변환되지 않습니다.\n"
            "  - E: 자체 관리 kops Kubernetes는 운영 오버헤드가 가장 큽니다."
        ),
        "소스 재작성 없이 레거시 Java/IIS(.NET) 앱 -> 컨테이너 추출 = **AWS App2Container (A2C)**, 호스트 OS 패치 0% 컨테이너 실행 = **AWS Fargate**!"
    ),
    (
        5, 8, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 100 Mbps 제한 회선 환경에서 180 TB 활성 파일셋 3주 내 무손실 하이브리드 마이그레이션",
        (
            "원격 바이오 연구소가 사내 스토리지 서버에 보유한 **180 TB의 활성 유전체 이미지 파일** 을 Amazon S3로 3주(21일) 이내에 마이그레이션해야 합니다. "
            "연구소의 인터넷/WAN 회선은 **100 Mbps** 로 제한되어 있으며(이론상 최대 100% 점유 시에도 180 TB 전송에 약 170일 소요), "
            "더욱이 마이그레이션이 진행되는 3주 동안 연구원들이 일부 파일을 계속 신규 생성하거나 수정합니다.\n\n"
            "3주 기한 내에 180 TB 전체 데이터와 마이그레이션 도중 변경된 최신 델타 파일까지 모두 안전하게 S3로 이관하는 최적의 전략은 무엇입니까?"
        ),
        "Bandwidth Math: 180 TB over 100 Mbps = ~167+ days (Deadline = 21 days!)\nAdditional Twist: Files continue to be created/modified on-prem during the 3-week window",
        [
            {"label": "A", "text": "100 Mbps 회선에서 `aws s3 cp --recursive` 병렬 스레드를 200개로 늘리면 3주 안에 180 TB 전송이 완료된다."},
            {"label": "B", "text": "여러 대의 AWS Snowball Edge Storage Optimized 디바이스를 주문해 오프라인으로 180 TB 초기 시드 데이터를 S3에 일괄 적재(Bulk Seed)한 뒤, 컷오버 직전 AWS DataSync 에이전트를 100 Mbps 회선에서 실행해 3주 동안 변경·추가된 델타 파일만 증분 동기화한다."},
            {"label": "C", "text": "AWS Snowmobile 1대를 불러 전송하되, 연구원들에게 3주간 파일 생성을 전면 금지한다."},
            {"label": "D", "text": "S3 Transfer Acceleration을 켜면 100 Mbps 물리 회선 대역폭이 자동으로 10 Gbps로 증속된다."}
        ],
        ["B"],
        "B) AWS Snowball Edge Storage Optimized 디바이스로 180 TB 초기 벌크 데이터를 오프라인 적재한 후, AWS DataSync로 변경·신규 델타 파일만 증분 온라인 동기화한다.",
        "AWS Snowball Edge Storage Optimized, AWS DataSync, Hybrid Bulk + Delta Migration, Bandwidth Calculation",
        (
            "• 정답(B): 100 Mbps = ~12.5 MB/s(실효 ~10 MB/s)이므로 하루 약 0.85 TB, 21일 동안 온라인 전송 가능량은 약 18 TB에 불과합니다. 따라서 **AWS Snowball Edge Storage Optimized**(디바이스당 ~80 TB 실용량, 여러 대 병렬 사용)로 대용량 초기 데이터를 오프라인 반입한 뒤, 디바이스 발송~적재 기간 중 발생한 소규모 증분/변경분만 **AWS DataSync** 로 온라인 델타 동기화하는 **Hybrid Offline + Online Delta 패턴** 이 SAP-C02 표준 해법입니다.\n"
            "• 오답 분석:\n"
            "  - A, D: 물리적 WAN 대역폭(100 Mbps) 상한은 병렬 스레드나 S3 Transfer Acceleration으로 돌파할 수 없습니다.\n"
            "  - C: Snowmobile은 엑사바이트(PB 후반~EB, 최소 10 PB 권장) 규모 트럭이며 180 TB에는 부적합하고 3주 작업 중단도 불가합니다."
        ),
        "마이그레이션 대역폭 계산 함정: 물리 회선 용량 < 목표 기간 내 데이터 크기 -> **Snowball Edge (오프라인 초기 벌크) + AWS DataSync (온라인 증분 델타)** 조합!"
    ),
    (
        5, 9, 4, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 800대 미확인 서버 TCO 라이선스 최적화 및 종속성 기반 Wave 계획 수립",
        (
            "CIO가 온프레미스 800대 서버의 클라우드 전환 승인에 앞서 두 가지 사전 산출물을 요구했습니다:\n"
            "1) 실제 4주간 CPU/RAM/디스크 IOPS 실사용량 계측을 바탕으로 한 정확한 AWS TCO 비용 모델링과, 보유 중인 Windows Server 및 SQL Server 라이선스의 BYOL(Dedicated Host) vs License-Included 최적 경제성 분석\n"
            "2) 어떤 서버들이 서로 어떤 포트로 통신하는지 네트워크 종속성을 자동 매핑해 전환 웨이브(Wave)를 그룹핑하고 전 계정의 전환 진척도를 단일 대시보드에서 추적\n\n"
            "이 사전 평가 및 계획 단계에 적합한 AWS 서비스 조합 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Pre-Migration Discovery & Business Case:\n- 800 unknown on-prem servers\n- 4-week telemetry -> Right-sized AWS TCO + Windows/SQL BYOL vs License-Included modeling\n- Network dependency mapping & centralized wave tracking",
        [
            {"label": "A", "text": "AWS Migration Evaluator(구 TSO Logic)를 배포해 실사용량 텔레메트리 기반의 Right-Sized TCO 리포트 및 Microsoft 라이선스 최적화(BYOL vs License-Included) 비즈니스 케이스를 산출한다."},
            {"label": "B", "text": "AWS Application Discovery Service(Agentless Collector 또는 Discovery Agent)로 서버 간 네트워크 연결·프로세스 종속성을 수집하고, AWS Migration Hub에서 애플리케이션 그룹화 및 마이그레이션 상태를 중앙 추적한다."},
            {"label": "C", "text": "AWS Pricing Calculator에 800대 온프레미스 서버의 과대 할당된 물리 스펙(100% CPU 가정)을 수동 입력하면 라이선스 최적화와 네트워크 종속성 매핑이 자동 완성된다."},
            {"label": "D", "text": "AWS Trusted Advisor를 온프레미스 VMware vCenter에 직접 설치하면 800대 서버의 포트 종속성을 4주간 추적한다."},
            {"label": "E", "text": "AWS Config가 온프레미스 비관리 서버 800대의 Windows Server CAL/SQL Server 라이선스 최적 비용을 산출한다."}
        ],
        ["A", "B"],
        "A, B) 실측 TCO 및 MS 라이선스 최적화(BYOL vs License-Included)는 AWS Migration Evaluator / 서버·네트워크 종속성 탐색 및 중앙 추적은 AWS Application Discovery Service + Migration Hub",
        "AWS Migration Evaluator, Application Discovery Service, AWS Migration Hub, Dependency Mapping, TCO & Licensing",
        (
            "• 정답(A, B):\n"
            "  - A: **AWS Migration Evaluator** 는 온프레미스 에이전트리스 수집을 통해 실제 피크/평균 자원 소비율, 유휴(Zombie) 서버 식별, **SQL Server/Windows 라이선스 BYOL vs License-Included** 시나리오 비교가 포함된 데이터 기반 TCO 비즈니스 케이스를 생성합니다.\n"
            "  - B: **AWS Application Discovery Service(ADS)** 는 서버 구성, 성능 및 인바운드/아웃바운드 네트워크 프로세스 종속성을 수집해 **AWS Migration Hub** 로 보내며, Migration Hub는 이를 기반으로 웨이브(Wave)를 묶고 MGN/DMS 실행 현황을 단일 창에서 추적합니다.\n"
            "• 오답 분석:\n"
            "  - C: 수동 계산기는 실사용량 측정, 좀비 서버 제거, MS 라이선스 시뮬레이션 및 프로세스 종속성 수집을 지원하지 않습니다.\n"
            "  - D, E: Trusted Advisor와 AWS Config(SSM 미연결 일반 온프레미스 VMware 서버)는 이러한 TCO/네트워크 종속성 분석 도구가 아닙니다."
        ),
        "마이그레이션 Assess/Plan 단계 구분: **Migration Evaluator** = TCO·비즈니스 케이스·MS 라이선스 최적화, **Application Discovery Service + Migration Hub** = 서버·포트 종속성 매핑 & 통합 추적!"
    ),
    (
        5, 10, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] IBM 메인프레임 COBOL/CICS/VSAM -> 클라우드 네이티브 Java 자동 리팩토링",
        (
            "대형 보험사가 연간 수백만 달러의 MIPS 라이선스 비용이 드는 온프레미스 **IBM z/OS 메인프레임(COBOL, CICS, JCL, VSAM 데이터셋)** 을 종료하려 합니다. "
            "경영진은 단순히 메인프레임 에뮬레이터 위에 COBOL 코드를 유지하기보다, 장기적인 클라우드 네이티브 인재 확보와 Aurora PostgreSQL/마이크로서비스 통합을 위해 "
            "기존 COBOL 비즈니스 로직을 가독성 있는 **현대적 Java / Spring Boot 코드와 관계형 데이터 모델** 로 자동 변환한 뒤 관리형 런타임에서 운영하고자 합니다.\n\n"
            "가장 적합한 AWS 마이그레이션·현대화 서비스 및 패턴은 무엇입니까?"
        ),
        "Mainframe Workload: IBM z/OS (COBOL, CICS, JCL, VSAM)\nGoal: Automated Refactoring into readable Java/Spring Boot + Relational DB (Aurora) to eliminate proprietary MIPS & COBOL dependency",
        [
            {"label": "A", "text": "AWS Mainframe Modernization 서비스의 Automated Refactoring with AWS Blu Age 패턴을 사용해 COBOL/JCL/VSAM을 Java/Spring Boot 및 Amazon Aurora PostgreSQL 데이터 모델로 자동 변환하고 관리형 런타임에 배포한다."},
            {"label": "B", "text": "AWS MGN 에이전트를 IBM z/OS 메인프레임 LPAR에 직접 설치해 x86 EC2 인스턴스로 블록 수준 복제한다."},
            {"label": "C", "text": "AWS App2Container를 IBM z/OS에 실행해 CICS 바이너리를 그대로 Linux Docker 이미지로 추출한다."},
            {"label": "D", "text": "AWS Snowball Edge에 메인프레임을 연결하면 COBOL 코드가 자동으로 Python Lambda로 변환된다."}
        ],
        ["A"],
        "A) AWS Mainframe Modernization (Automated Refactoring with AWS Blu Age)를 사용해 COBOL/JCL/VSAM을 Java/Spring Boot + Aurora PostgreSQL로 자동 변환·배포한다.",
        "AWS Mainframe Modernization, AWS Blu Age, Micro Focus, COBOL to Java, Automated Refactoring",
        (
            "• 정답(A): **AWS Mainframe Modernization** 은 두 가지 검증된 경로를 제공합니다:\n"
            "  1) **Automated Refactoring (AWS Blu Age)**: COBOL/JCL/VSAM을 현대적인 **Java/Spring Boot** 와 관계형 DB(Aurora 등)로 자동 변환(이 시나리오의 정답!)\n"
            "  2) **Replatforming (Micro Focus)**: COBOL 코드 자체를 크게 바꾸지 않고 관리형 에뮬레이션 런타임으로 신속 이전\n"
            "• 오답 분석:\n"
            "  - B: AWS MGN은 x86 기반 Windows/Linux 전용이며 메인프레임 IBM z/OS(s390x 아키텍처)에 설치할 수 없습니다.\n"
            "  - C: App2Container는 x86 Linux Java 및 Windows .NET/IIS 앱 전용입니다.\n"
            "  - D: Snowball Edge는 데이터/엣지 스토리지 장비일 뿐 코드 리팩토링 도구가 아닙니다."
        ),
        "메인프레임 전환: COBOL 유지 신속 이전 = **AWS Mainframe Modernization (Micro Focus Replatform)**, Java/Spring + Aurora 현대화 전환 = **AWS Mainframe Modernization (Blu Age Automated Refactor)**!"
    ),
    (
        5, 11, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 과도기 하이브리드 공존 중 DMS CDC -> Kinesis Data Streams 기반 실시간 이벤트 동기화",
        (
            "대형 유통사가 Strangler Fig 방식으로 레거시 온프레미스 **SQL Server** 주문 모놀리스를 AWS로 이전 중입니다. "
            "6개월간의 과도기 동안 상품 검색 및 추천 마이크로서비스는 이미 AWS에서 **Amazon OpenSearch Service와 DynamoDB** 로 가동 중이지만, "
            "신규 주문과 재고 변경은 여전히 온프레미스 SQL Server에 기록되고 있습니다. "
            "SQL Server 애플리케이션 코드에 이중 쓰기(Dual Write)를 추가하지 않으면서 모든 주문/재고 변경 사항을 **2초 이내** 에 AWS OpenSearch와 DynamoDB로 실시간 팬아웃해야 합니다.\n\n"
            "가장 안정적인 실시간 CDC 스트리밍 파이프라인은 무엇입니까?"
        ),
        "Coexistence Period (6 months):\nOn-Prem SQL Server (Legacy Writes, NO app code changes allowed) ---> [<2s latency] ---> AWS OpenSearch + DynamoDB",
        [
            {"label": "A", "text": "AWS DMS CDC(Change Data Capture) 태스크의 소스를 온프레미스 SQL Server로, 타깃을 Amazon Kinesis Data Streams로 설정한 뒤, Lambda 컨슈머(또는 EventBridge Pipes/Firehose)가 스트림 레코드를 변환해 DynamoDB와 OpenSearch에 각각 비동기 반영한다."},
            {"label": "B", "text": "온프레미스 SQL Server에서 매 15분마다 전체 테이블 CSV를 S3로 덤프해 덮어쓴다."},
            {"label": "C", "text": "SQL Server 트랜잭션 트리거 내부에서 동기 HTTP 호출로 AWS OpenSearch와 DynamoDB를 직접 호출하여 하나라도 실패하면 온프레미스 주문을 롤백한다."},
            {"label": "D", "text": "AWS DataSync를 매초 실행해 SQL Server `.mdf` 데이터 파일을 S3로 동기화하고 OpenSearch가 `.mdf` 바이너리를 직접 인덱싱하게 한다."}
        ],
        ["A"],
        "A) AWS DMS(CDC Only / Full Load+CDC) -> Amazon Kinesis Data Streams를 타깃으로 구성하고, Lambda/Firehose가 이벤트를 변환해 DynamoDB와 OpenSearch로 팬아웃한다.",
        "AWS DMS CDC to Kinesis, Strangler Fig Coexistence, Real-time Event Fan-out, Zero Dual-Write",
        (
            "• 정답(A): **AWS DMS** 는 관계형 DB(SQL Server)의 트랜잭션 로그에서 변경 사항을 읽는 CDC 소스로 동작하며, **Amazon Kinesis Data Streams(또는 MSK/Kafka)** 를 스트리밍 타깃으로 직접 지원합니다. 스트림에 적재된 CDC 이벤트를 Lambda 컨슈머(병렬 팬아웃)로 소비해 DynamoDB 모델로 변환하고 OpenSearch 문서를 인덱싱하면, 레거시 SQL Server 코드에 이중 쓰기(Dual Write) 부담을 주지 않고 1~2초 내 동기화가 유지됩니다.\n"
            "• 오답 분석:\n"
            "  - B: 15분 주기 전체 CSV 덤프는 2초 이내 실시간 요건을 위반하며 원본 DB 부하가 막대합니다.\n"
            "  - C: DB 트리거 내 외부 동기 HTTP 호출은 SQL Server 잠금 경합과 WAN 장애 시 본업 주문 전체 마비를 유발하는 심각한 안티패턴입니다.\n"
            "  - D: OpenSearch는 SQL Server `.mdf` 바이너리 파일을 파싱·인덱싱할 수 없습니다."
        ),
        "레거시 DB 코드 수정 없이 비동기 실시간 스트리밍 연동 = **AWS DMS (CDC) -> Kinesis Data Streams / MSK**!"
    ),
    (
        5, 12, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 장시간 고메모리 야간 배치 현대화: EventBridge Scheduler + Step Functions + AWS Batch vs Lambda",
        (
            "리스크 분석 팀이 매일 새벽 2시에 실행되는 야간 배치 파이프라인을 현대화하려 합니다. "
            "기존에는 거대한 `r5.12xlarge` EC2 인스턴스가 24시간 켜진 채 cron으로 파이프라인을 돌리고 있었으며, 세부 작업 구성은 다음과 같습니다:\n"
            "• **1단계(전처리)**: 실행 시간 40초, 메모리 512 MB 소요\n"
            "• **2단계(몬테카를로 시뮬레이션 50개 종목 병렬 연산)**: 종목당 실행 시간 **45분 ~ 2시간**, 메모리 **32 GB RAM** 소요, 중단 시 재시도 가능\n"
            "• **3단계(최종 리포트 S3/SNS 통지)**: 실행 시간 15초, 메모리 256 MB 소요\n\n"
            "상시 유휴 EC2 비용을 완전히 없애고 작업 제한 시간 없이 가장 비용 효율적으로 현대화하는 아키텍처는 무엇입니까?"
        ),
        "Batch Pipeline Steps:\n- Step 1: 40s, 512 MB\n- Step 2: 50 parallel array jobs, each 45m~2h & 32 GB RAM (interruptible)\n- Step 3: 15s, 256 MB\nGoal: Eliminate 24/7 idle EC2 and respect Lambda limits (15 min, 10 GB RAM)",
        [
            {"label": "A", "text": "1, 2, 3단계 모두 AWS Lambda 함수로 이관하고 Step 2는 32 GB RAM과 2시간 타임아웃을 설정한다."},
            {"label": "B", "text": "Amazon EventBridge Scheduler가 매일 02:00에 AWS Step Functions 워크플로우를 시작하며, Step 1과 Step 3는 AWS Lambda로 실행하고, 장시간·고메모리 Step 2는 AWS Batch(EC2 Spot / Fargate Compute Environment, Array Job + Retry)에 동기 제출(.sync)하여 작업 완료 시 컴퓨팅 자원을 0대로 자동 회수한다."},
            {"label": "C", "text": "r5.12xlarge EC2를 3년 All Upfront RI로 구매해 24시간 그대로 유지한다."},
            {"label": "D", "text": "AWS Glue Python Shell 잡(최대 1 DPU / 16 GB) 하나로 50개 32 GB 시뮬레이션을 직렬 실행한다."}
        ],
        ["B"],
        "B) EventBridge Scheduler + Step Functions 오케스트레이션 하에 경량 단계(Step 1/3)는 Lambda로, 45분~2시간 & 32 GB RAM이 필요한 Step 2는 AWS Batch(Spot Compute Environment)로 실행한다.",
        "AWS Batch, Step Functions Orchestration, EventBridge Scheduler, Lambda 15min/10GB Limit, Spot Array Job",
        (
            "• 정답(B): AWS Lambda는 **최대 실행 시간 15분, 최대 메모리 10 GB(10,240 MB)** 제한이 있어 Step 2(최대 2시간, 32 GB RAM)를 직접 실행할 수 없습니다. **AWS Batch** 는 컨테이너화된 장시간·고메모리 배치 및 Array Job을 위해 필요한 순간에만 Spot EC2(또는 Fargate) 컴퓨팅 환경을 0에서 스케일아웃해 실행한 뒤 완료 즉시 0대로 종료(Scale-to-zero)합니다. 이를 **EventBridge Scheduler + Step Functions(`arn:aws:states:::batch:submitJob.sync`)** 로 묶으면 완전한 서버리스 오케스트레이션이 완성됩니다.\n"
            "• 오답 분석:\n"
            "  - A: Lambda는 32 GB RAM과 2시간 타임아웃을 지원하지 않습니다.\n"
            "  - C: 하루 2시간만 쓰는 워크로드를 24시간 3년 RI로 켜두는 것은 대규모 비용 낭비입니다.\n"
            "  - D: 50개 × 2시간 직렬 실행은 100시간이 소요되며 32 GB RAM도 충족하지 못합니다."
        ),
        "배치 현대화 결정 기준: **<=15분 & <=10GB RAM** -> **AWS Lambda**, **>15분 or >10GB RAM / GPU / Array Job** -> **AWS Batch**!"
    ),
    (
        5, 13, 4, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 고비용 Oracle DB 탈피: 예측 가능한 키-값 트래픽의 DynamoDB Single-Table + TTL 리팩토링",
        (
            "글로벌 모바일 앱의 사용자 세션, 장바구니, 최근 본 상품 조회 서비스가 매초 최대 80만 건의 요청(RPS)을 처리하기 위해 "
            "고가의 온프레미스 **Oracle Enterprise Edition + Coherence 캐시** 클러스터에서 연간 50만 달러 이상의 라이선스 비용을 지출하고 있습니다. "
            "데이터 접근 패턴을 분석한 결과 복잡한 다중 테이블 JOIN이 전혀 없고 오직 `userId`, `sessionId`, `itemId` 기준의 예측 가능한 키-값 및 범위 조회뿐이며, "
            "30일이 지난 세션 데이터는 자동 파기되어야 합니다.\n\n"
            "Oracle 라이선스를 완전히 제거하고 10ms 미만의 일관된 고성능 서버리스 아키텍처로 전환하기 위한 2가지 핵심 설계는 무엇입니까? (Select TWO.)"
        ),
        "Workload Profile:\n- 800,000 RPS predictable key-value & range access (NO complex joins)\n- Auto-expire session rows after 30 days\n- Eliminate $500k/yr Oracle EE licensing",
        [
            {"label": "A", "text": "접근 패턴에 맞춘 Amazon DynamoDB Single-Table Design(적절한 Partition Key/Sort Key + GSI)으로 리팩토링하고, 30일 경과 세션 자동 삭제를 위해 추가 쓰기 WCU 비용이 없는 DynamoDB TTL(Time to Live)을 활성화한다."},
            {"label": "B", "text": "초기 정적/이력 데이터 이관은 AWS DMS(Oracle -> DynamoDB 타깃 매핑) 또는 AWS Glue ETL로 수행하고, 읽기 밀집 마이크로초 지연이 필요한 핫 키에는 필요 시 DAX(DynamoDB Accelerator)를 결합한다."},
            {"label": "C", "text": "AWS RDS for Oracle Enterprise Edition License-Included로 이전하면 라이선스 비용과 운영 오버헤드가 0원이 된다."},
            {"label": "D", "text": "DynamoDB로 이전한 뒤에도 30일 만료 데이터를 지우기 위해 매일 밤 `Scan` 후 `BatchWriteItem` Delete를 돌려 전체 WCU를 소진시킨다."},
            {"label": "E", "text": "복잡한 조인이 없음에도 80만 RPS 처리를 위해 t3.large MySQL 1대에 수직 확장(Scale-up)한다."}
        ],
        ["A", "B"],
        "A, B) 접근 패턴 기반 DynamoDB Single-Table Design + 무비용 DynamoDB TTL 적용 / AWS DMS(또는 Glue)로 Oracle 데이터 이관 및 필요 시 DAX 캐싱 결합",
        "DynamoDB Single-Table Design, DynamoDB TTL, DMS to DynamoDB, DAX, Oracle License Decommissioning",
        (
            "• 정답(A, B):\n"
            "  - A: 조인이 없고 키 기반 접근 패턴이 명확한 초고부하(80만 RPS) 워크로드는 **Amazon DynamoDB** 로 리팩토링하는 것이 가장 경제적이고 확장성 높습니다. 특히 **DynamoDB TTL** 은 만료된 세션 항목을 백그라운드에서 **WCU 소비 없이 무료** 로 자동 삭제해 줍니다.\n"
            "  - B: **AWS DMS** 는 Oracle을 소스로, DynamoDB를 타깃으로 하는 데이터 이관(매핑 규칙 포함)을 지원하며, 읽기 극대화 시 **DAX** 를 붙여 마이크로초 응답을 얻을 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - C: RDS Oracle EE License-Included에도 막대한 상용 라이선스 비용이 포함되어 Oracle 탈피 목표에 맞지 않습니다.\n"
            "  - D: 전체 테이블 `Scan` + 수동 삭제는 불필요한 RCU/WCU를 대량 소모하는 안티패턴입니다.\n"
            "  - E: 단일 `t3.large` MySQL로는 초당 80만 요청을 절대 처리할 수 없습니다."
        ),
        "고비용 상용 RDBMS(조인 없는 단순 패턴/세션/카탈로그) 탈피 = **DynamoDB Refactor + 무료 TTL(자동 만료) + DMS(Oracle->DynamoDB)**!"
    ),
    (
        5, 14, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 멀티어카운트 마이크로서비스 전환 가속화: Refactor Spaces & Amazon VPC Lattice",
        (
            "엔터프라이즈 조직에서 12개의 독립 제품 팀이 각자의 AWS 계정(EKS, ECS, Lambda 혼용)으로 마이크로서비스를 분리해 나가고 있습니다. "
            "초기에는 기존 모놀리스가 있는 `Legacy Account` 와 신규 서비스 계정들 사이에 VPC Peering, 개별 ALB/NLB, API Gateway 라우팅, 수동 DNS 및 보안 검증(IAM 인증)을 "
            "일일이 연결하느라 신규 서비스 출시마다 네트워크 설정에만 2주가 소요되고 각 서비스 컨테이너에 무거운 사이드카 프록시를 강제해야 했습니다.\n\n"
            "멀티어카운트 Strangler Fig 환경에서 계정을 넘나드는 L7 서비스 검색·라우팅·IAM 인증을 사이드카 없이 표준화하는 최적의 AWS 서비스는 무엇입니까?"
        ),
        "Multi-Account Microservice Sprawl:\n- 12 independent AWS Accounts (EKS + ECS + Lambda) + Legacy Monolith Account\n- Need unified cross-account L7 service-to-service routing, weighted traffic shifting, and SigV4/IAM auth WITHOUT sidecar proxies",
        [
            {"label": "A", "text": "AWS Migration Hub Refactor Spaces(외부 진입 Strangler 프록시/라우팅 자동화) 및/또는 Amazon VPC Lattice(계정/VPC 경계를 초월한 L7 서비스 네트워크, 가중치 라우팅, 통합 IAM SigV4 인증 정책, 사이드카 불필요)를 도입한다."},
            {"label": "B", "text": "12개 계정의 모든 VPC CIDR을 10.0.0.0/16으로 통일하고 풀 메시 VPC Peering 66개를 수동 관리한다."},
            {"label": "C", "text": "모든 내부 서비스 간 통신을 퍼블릭 인터넷으로 내보내 CloudFront를 경유시킨 뒤 IP 화이트리스트만 둔다."},
            {"label": "D", "text": "AWS Lambda 함수 내부에 Istio Envoy 사이드카 컨테이너를 직접 컴파일해 삽입한다."}
        ],
        ["A"],
        "A) AWS Migration Hub Refactor Spaces 및/또는 Amazon VPC Lattice를 도입해 사이드카 없이 멀티어카운트 L7 서비스 라우팅, 가중치 전환, IAM 인증을 중앙 자동화한다.",
        "Amazon VPC Lattice, AWS Migration Hub Refactor Spaces, Cross-Account Service Mesh, Sidecarless L7 Routing, IAM SigV4",
        (
            "• 정답(A): **AWS Migration Hub Refactor Spaces** 는 멀티어카운트 Strangler Fig 전환에 필요한 Transit Gateway/API Gateway/NLB/Resource Access Manager 구성을 한 번에 오케스트레이션해 줍니다. 또한 **Amazon VPC Lattice** 는 VPC 및 계정 경계를 넘어(심지어 중첩 CIDR 간에도) EC2, EKS, ECS, Lambda를 **사이드카 프록시 없이** L7 서비스 네트워크로 묶어주며 경로/가중치 기반 블루-그린/카나리 라우팅과 세밀한 IAM Auth Policy를 제공합니다.\n"
            "• 오답 분석:\n"
            "  - B: 동일한 CIDR(10.0.0.0/16) 간에는 VPC Peering 자체가 불가능하며 N(N-1)/2 메시 관리는 확장 불가합니다.\n"
            "  - C: 내부 서비스 간 통신을 퍼블릭 인터넷으로 노출하는 것은 보안·지연 면에서 안티패턴입니다.\n"
            "  - D: AWS Lambda는 Kubernetes Pod 방식의 Envoy 사이드카 프록시 아키텍처를 실행하는 모델이 아닙니다."
        ),
        "멀티어카운트 + EKS/ECS/Lambda 혼재 + 사이드카 없는 L7 서비스 라우팅·IAM 인증 = **Amazon VPC Lattice** (모놀리스 분리 오케스트레이션 = **Refactor Spaces**)!"
    ),
    (
        5, 15, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] 컨테이너 현대화 플랫폼 선택: Amazon EKS vs ECS Fargate vs AWS App Runner 트레이드오프",
        (
            "사내 두 개의 제품 팀이 서로 다른 요구사항을 가지고 컨테이너 플랫폼을 선정하려 합니다:\n"
            "• **플랫폼 팀 Alpha**: 멀티클라우드·온프레미스 이식성을 위해 표준 Kubernetes API가 필수이며, ArgoCD GitOps 오퍼레이터, 커스텀 CRD, OPA Gatekeeper, 세밀한 네트워크 CNI 정책 등 K8s 오픈소스 생태계를 그대로 활용해야 합니다.\n"
            "• **스타트업 스쿼드 Beta**: K8s 전담 인력이 전혀 없는 백엔드 개발자 4명으로 구성되어 있으며, GitHub 저장소나 ECR 이미지 주소만 연결하면 별도의 VPC/ALB/Auto Scaling 설정 없이 HTTPS 웹 API가 자동 빌드·배포되고 요청이 없을 때는 최소 비용으로 대기하길 원합니다.\n\n"
            "각 팀의 조건에 가장 정확히 부합하는 AWS 컨테이너 서비스 매칭은 무엇입니까?"
        ),
        "Team Alpha: Standard K8s API portability, CRDs, ArgoCD/OPA ecosystem\nTeam Beta: 4 devs, zero infra ops, auto-build/deploy from repo/ECR with managed TLS & scaling",
        [
            {"label": "A", "text": "Alpha: Amazon EKS / Beta: AWS App Runner"},
            {"label": "B", "text": "Alpha: AWS App Runner / Beta: Amazon EKS Self-Managed on EC2"},
            {"label": "C", "text": "Alpha: AWS Elastic Beanstalk / Beta: Amazon ECS on EC2 (수동 ASG)"},
            {"label": "D", "text": "Alpha와 Beta 모두 단일 EC2 인스턴스 위 `docker-compose up` 으로 운영한다."}
        ],
        ["A"],
        "A) Alpha: Amazon EKS (표준 K8s 생태계/CRD/이식성) / Beta: AWS App Runner (인프라 설정 없는 완전관리형 웹·API 컨테이너 자동 배포)",
        "Amazon EKS, AWS App Runner, ECS Fargate, Container Platform Trade-offs, CRDs",
        (
            "• 정답(A): **Amazon EKS** 는 표준 업스트림 Kubernetes API, CRD, Helm, ArgoCD 등 방대한 오픈소스 K8s 생태계와 멀티/하이브리드 이식성(EKS Anywhere)이 필요한 플랫폼 팀에 적합합니다. 반면 **AWS App Runner** 는 소스 코드나 ECR 이미지에서 곧바로 빌드·배포·로드밸런싱·TLS·오토스케일링을 완전 추상화해 제공하므로 인프라 전담 인력이 없는 소규모 웹 API 팀에 최적입니다(ECS Fargate는 중간 단계로서 VPC/ALB/Batch/Task 정밀 제어와 AWS 통합이 필요할 때 최적).\n"
            "• 오답 분석:\n"
            "  - B, C, D: 각 팀의 핵심 요구사항(Alpha의 K8s CRD/이식성, Beta의 무인프라 자동 빌드/배포)과 정반대로 매칭되었습니다."
        ),
        "컨테이너 3총사 선택 공식: K8s CRD/이식성 = **EKS**, AWS 깊은 통합/VPC/배치·유연 제어(컨트롤플레인 무료) = **ECS(Fargate)**, 인프라 제로 웹/API 즉시 배포 = **App Runner**!"
    ),
    (
        5, 16, 4, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4] Windows SMB 파일 서버(60 TB) 무중단 전환: FSx for Windows + DataSync + DFS Namespaces",
        (
            "제조 기업이 온프레미스 Windows File Server 클러스터(60 TB)에 저장된 CAD 도면 및 사내 공유 문서를 AWS로 이전하려 합니다. "
            "기존 Active Directory(AD) 도메인 계정의 NTFS ACL 권한과 Windows Shadow Copies(이전 버전 복원)가 100% 보존되어야 하며, "
            "5,000명의 사내 PC 사용자가 매핑한 기존 UNC 경로(`\\\\corp.local\\shares\\engineering`)를 전혀 바꾸지 않고 백엔드 스토리지만 AWS로 투명하게 전환해야 합니다.\n\n"
            "이 요구사항을 충족하는 가장 표준적인 AWS 파일 마이그레이션 아키텍처는 무엇입니까?"
        ),
        "Windows File Server Migration:\n- 60 TB SMB shares preserving NTFS ACLs, AD integration, and Shadow Copies\n- Keep UNC path \\\\corp.local\\shares\\engineering unchanged for 5,000 endpoints",
        [
            {"label": "A", "text": "Amazon S3 버킷으로 파일을 옮긴 뒤 5,000대 PC에 AWS CLI를 설치해 `aws s3 cp` 로 파일을 열게 한다."},
            {"label": "B", "text": "온프레미스 AD와 조인된 Multi-AZ Amazon FSx for Windows File Server를 생성하고, AWS DataSync로 NTFS ACL·타임스탬프·소유권까지 보존해 60 TB를 동기화한 뒤, Microsoft DFS Namespaces(DFS-N) 폴더 타깃을 기존 온프레미스 서버에서 FSx 공유 경로로 투명하게 전환한다."},
            {"label": "C", "text": "Amazon EFS에 모든 파일을 옮기면 NTFS ACL과 Windows Shadow Copies가 자동 호환된다."},
            {"label": "D", "text": "Amazon FSx for Lustre를 AD 도메인에 조인해 Windows 5,000명 사용자의 SMB 드라이브로 마운트한다."}
        ],
        ["B"],
        "B) AD 조인된 Multi-AZ FSx for Windows File Server + AWS DataSync(NTFS ACL 보존 동기화) + DFS Namespaces(DFS-N) 타깃 전환으로 UNC 경로를 유지한다.",
        "FSx for Windows File Server, AWS DataSync, NTFS ACLs, DFS Namespaces (DFS-N), Shadow Copies",
        (
            "• 정답(B): **Amazon FSx for Windows File Server** 는 네이티브 SMB 2.0~3.1.1, Active Directory 조인, NTFS ACL, Shadow Copies 및 **DFS Namespaces(DFS-N)** 를 완전 지원합니다. **AWS DataSync** 는 SMB 파일 전송 시 파일 본문뿐만 아니라 NTFS 보안 설명자(ACL)·소유자·타임스탬프까지 정확히 복사하며, DFS-N 네임스페이스 타깃만 온프레미스에서 FSx로 교체하면 5,000명 사용자의 `\\\\corp.local\\shares\\...` 드라이브 매핑이 전혀 깨지지 않습니다.\n"
            "• 오답 분석:\n"
            "  - A: S3는 POSIX/NTFS SMB 파일 공유가 아니며 UNC 드라이브 매핑을 지원하지 않습니다.\n"
            "  - C, D: EFS와 FSx for Lustre는 Linux NFS/Lustre 프로토콜 전용이며 Windows SMB, NTFS ACL, AD 조인, Shadow Copies를 지원하지 않습니다."
        ),
        "Windows 파일 서버(NTFS ACL + AD + Shadow Copies + 기존 UNC 경로 유지) = **FSx for Windows + AWS DataSync + DFS-N**!"
    ),

    # =========================================================================
    # ROUND 6 (SET 5): Comprehensive Multi-Domain Enterprise Mock Set (16 Questions)
    # Domain mix: D1=4 (Q1-4), D2=8 (Q5-12), D3=3 (Q13-15), D4=1 (Q16)
    # =========================================================================
    (
        6, 1, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1 · 종합] IPv4 사설 주소 고갈(RFC1918 Exhausted) 환경의 IPv6 듀얼스택 + NAT64/DNS64 연동",
        (
            "수백 개의 VPC와 대규모 EKS 클러스터를 운영하는 기업이 사설 IPv4(`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) 대역을 완전히 소진했습니다. "
            "신규 마이크로서비스 EKS Pod와 AWS Fargate 태스크들은 **IPv6 전용 서브넷** 에 배치해 무제한에 가까운 IP 확장성을 확보하되, "
            "여전히 IPv4만 지원하는 기존 레거시 RDS 데이터베이스 및 온프레미스 IPv4 시스템과는 투명하게 통신할 수 있어야 합니다.\n\n"
            "IPv4 고갈을 해결하면서 기존 IPv4 백엔드와 원활히 통신하는 AWS VPC 네트워킹 구성은 무엇입니까?"
        ),
        "IPv4 Exhaustion Constraint:\n- New EKS Pods / VPC Subnets: IPv6-only subnets (no new private IPv4 available)\n- Legacy Targets: IPv4-only RDS & On-premises servers",
        [
            {"label": "A", "text": "신규 VPC/서브넷에 IPv6-only 서브넷을 구성하고 서브넷에서 DNS64를 활성화한 뒤, IPv4가 할당된 NAT Gateway가 포함된 VPC 라우팅 테이블로 IPv6->IPv4(64:ff9b::/96) 트래픽을 보내 NAT64 변환을 수행하게 한다."},
            {"label": "B", "text": "공인 IPv4 대역(예: 8.8.8.0/24)을 임의로 사설 VPC CIDR로 강제 할당해 내부 통신을 시도한다."},
            {"label": "C", "text": "Egress-Only Internet Gateway(EIGW)를 연결하면 IPv6 전용 인스턴스가 사설 IPv4 RDS와 자동 통신할 수 있다."},
            {"label": "D", "text": "AWS Direct Connect를 연결하면 BGP가 IPv6 패킷을 L2에서 자동으로 IPv4 RDS 패킷으로 변환해 준다."}
        ],
        ["A"],
        "A) 신규 워크로드는 IPv6-only 서브넷에 배치하고 DNS64(AAAA 레코드 합성) + NAT Gateway의 NAT64(64:ff9b::/96 -> IPv4 변환)를 통해 기존 IPv4 리소스와 통신한다.",
        "IPv6-only Subnets, DNS64, NAT64, IPv4 Exhaustion, NAT Gateway",
        (
            "• 정답(A): AWS의 **IPv6-only 서브넷 + DNS64 + NAT64** 조합은 IPv4 주소 고갈 해결의 표준입니다. **DNS64** 는 IPv4 A 레코드만 있는 대상(예: 레거시 RDS)을 조회할 때 잘 알려진 프리픽스(`64:ff9b::/96`)가 붙은 합성 IPv6 AAAA 주소를 반환하고, 라우팅 테이블이 이 프리픽스를 **NAT Gateway** 로 보내면 NAT Gateway가 **NAT64** 를 통해 사설/공인 IPv4 패킷으로 변환해 통신을 성사시킵니다.\n"
            "• 오답 분석:\n"
            "  - B: 타인이 소유한 공인 IP 대역을 사설 VPC에 쓰면 인터넷/라우팅 충돌이 발생합니다(RFC1918 비준수 안티패턴).\n"
            "  - C: Egress-Only Internet Gateway(EIGW)는 순수 IPv6 → IPv6 아웃바운드 인터넷 통신용이며 IPv6 → IPv4 변환을 하지 못합니다.\n"
            "  - D: Direct Connect는 IPv6→IPv4 프로토콜 변환을 수행하지 않습니다."
        ),
        "IPv4 고갈 + 기존 IPv4 리소스 호환 = **IPv6-only Subnet + DNS64 + NAT64 (NAT Gateway)**! (`EIGW`는 순수 IPv6 아웃바운드 전용!)"
    ),
    (
        6, 2, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1 · 종합] AWS Firewall Manager 기반 전사 SG · WAF · Shield Advanced 자동 강제",
        (
            "전사 보안 거버넌스 팀이 AWS Organizations 내 모든 70개 계정의 ALB와 CloudFront 배포에 일관된 **AWS WAFv2 웹 ACL** 과 **AWS Shield Advanced** 보호를 자동 적용하고, "
            "어떠한 VPC Security Group에도 `0.0.0.0/0` 대상 SSH(22)/RDP(3389) 인바운드 규칙이 생성되거나 방치되지 않도록 조직 단위 중앙 정책으로 자동 교정(Auto-Remediate)하려 합니다. "
            "향후 새 계정이 생성되거나 개발자가 새 ALB를 띄우더라도 별도 수작업 없이 자동 보호가 적용되어야 합니다.\n\n"
            "이 전사 방화벽·보안 그룹 중앙 통제에 가장 적합한 서비스는 무엇입니까?"
        ),
        "Org Security Mandate:\n- 70+ accounts (including future new accounts/resources)\n- Auto-attach WAFv2 + Shield Advanced to all ALBs/CloudFront + auto-audit/remediate VPC Security Groups",
        [
            {"label": "A", "text": "AWS Organizations All Features 및 전 계정 AWS Config를 활성화한 뒤, 위임 관리자 계정에서 AWS Firewall Manager(FMS) 정책(WAFv2, Shield Advanced, Security Group Content Audit/Auto-remediation)을 OU 단위로 배포한다."},
            {"label": "B", "text": "모든 계정의 ALB 생성 권한을 SCP로 막고 보안 팀 1명이 수동으로 CloudFront마다 WAF를 연결한다."},
            {"label": "C", "text": "AWS Network Firewall을 단일 VPC에 띄우면 조직 내 타 계정 모든 Security Group 규칙을 자동으로 수정한다."},
            {"label": "D", "text": "GuardDuty가 비준수 Security Group 규칙과 누락된 WAF 연결을 자동으로 삭제·생성해 준다."}
        ],
        ["A"],
        "A) Organizations + AWS Config 기반 위임 관리자 계정에서 AWS Firewall Manager(FMS) 정책을 배포해 WAFv2, Shield Advanced, Security Group을 조직 전체에 자동 적용·교정한다.",
        "AWS Firewall Manager (FMS), Delegated Administrator, WAFv2 Policy, Security Group Remediation, Organizations",
        (
            "• 정답(A): **AWS Firewall Manager(FMS)** 는 조직 단위(OU/계정/리소스 태그 필터)로 중앙 보안 정책을 한 번 정의하면 기존 리소스뿐만 아니라 **새로 생성되는 계정 및 신규 ALB/CloudFront/VPC Security Group에도 자동으로 규칙을 적용·감사·자동 교정** 합니다. 사전 요구사항으로 Organizations All Features, AWS Config 활성화, 위임 관리자(Delegated Admin) 지정이 필요합니다.\n"
            "• 오답 분석:\n"
            "  - B: 수동 운영은 민첩성을 파괴하고 신규 리소스 누락 위험이 큽니다.\n"
            "  - C: AWS Network Firewall은 VPC 패킷 필터 방화벽이지 타 계정 SG/WAF/Shield 중앙 관리 도구가 아닙니다.\n"
            "  - D: GuardDuty는 위협 탐지(Detection) 서비스이지 WAF 배포나 SG 규칙 자동 수정을 수행하지 않습니다."
        ),
        "멀티어카운트 **WAF + Shield + Security Group + Network Firewall** 중앙 정책 자동 배포·교정 = **AWS Firewall Manager (FMS)**!"
    ),
    (
        6, 3, 1, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1 · 종합] Direct Connect 100 Gbps 계층 2 암호화(MACsec) 및 Dedicated vs Hosted Connection 제약",
        (
            "글로벌 금융 거래소가 온프레미스 코어 라우터와 AWS Direct Connect 로케이션 사이를 지나는 물리적 광통신 구간까지 "
            "L2 하드웨어 속도(100 Gbps Line-rate)로 암호화(IEEE 802.1AE **MACsec**)해야 하며, 단일 논리 링크 대역폭 확장(LAG)과 함께 "
            "하나의 연결 위에서 다수의 VLAN(Production Transit VIF + Dev Private VIF + Public VIF)을 분리 운영하려고 합니다.\n\n"
            "이 요구사항을 충족하기 위해 반드시 선택해야 하는 Direct Connect 연결 유형은 무엇입니까?"
        ),
        "DX Constraints:\n- 100 Gbps line-rate L2 encryption (MACsec / IEEE 802.1AE)\n- Link Aggregation Group (LAG) + Multiple VIFs (Transit + Private + Public) on same connection",
        [
            {"label": "A", "text": "AWS Direct Connect Partner를 통해 10 Gbps Hosted Connection 1개를 주문하면 MACsec, LAG, 다중 VIF가 모두 기본 지원된다."},
            {"label": "B", "text": "AWS Direct Connect Dedicated Connection (10G 또는 100G 포트)을 직접 프로비저닝하여 MACsec(IEEE 802.1AE)을 활성화하고, 다수의 VIF와 필요 시 LAG를 구성한다."},
            {"label": "C", "text": "Hosted VIF만 10개 생성하면 파트너 회선에서도 물리 포트 수준 MACsec 키 교환이 자동 작동한다."},
            {"label": "D", "text": "Site-to-Site VPN을 Direct Connect 없이 퍼블릭 인터넷으로 연결하면 100 Gbps MACsec L2 암호화가 제공된다."}
        ],
        ["B"],
        "B) AWS Direct Connect Dedicated Connection(10G/100G)을 선택해 포트 수준 MACsec(IEEE 802.1AE) L2 암호화, LAG, 다중 VIF(최대 50개)를 구성한다.",
        "Direct Connect Dedicated Connection, MACsec (802.1AE), Link Aggregation Group (LAG), Hosted Connection Limits",
        (
            "• 정답(B): AWS Direct Connect에서 **MACsec(L2 암호화)** 과 **LAG(Link Aggregation Group)** 및 **다중 VIF(연결당 최대 50개)** 는 오직 **Dedicated Connection(10G/100G 등 전용 물리 포트)** 에서만 지원됩니다. (참고: MACsec은 10G/100G Dedicated Connection 포트에서 지원되며 온프레미스/AWS 엔드포인트 간 L2 라인 레이트 암호화 제공)\n"
            "• 오답 분석:\n"
            "  - A, C: 파트너를 통해 받는 **Hosted Connection** 은 물리 포트 제어권이 파트너에게 있어 **MACsec과 LAG를 지원하지 않으며**, 연결당 **단 1개의 VIF** 만 생성할 수 있습니다.\n"
            "  - D: 인터넷 기반 Site-to-Site VPN은 L3 IPsec 암호화이며 대역폭이 터널당 ~1.25 Gbps로 제한됩니다."
        ),
        "DX Dedicated vs Hosted 핵심 차이: **MACsec + LAG + 다중 VIF(50개)** = 오직 **Dedicated Connection**! **Hosted Connection** = LAG 불가, MACsec 불가, 1개 VIF만!"
    ),
    (
        6, 4, 1, 2, 3,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 1 · 종합] HIPAA 의료 규정 준수 AWS Control Tower Landing Zone 확장 자동화 (AFT/CfCT)",
        (
            "바이오테크 기업이 HIPAA 규제를 준수하는 멀티어카운트 랜딩 존(Landing Zone)을 신규 구축합니다. "
            "아키텍트 팀은 1) Terraform 기반 GitOps 파이프라인으로 신규 계정 벤딩(Vending) 및 계정별 커스텀 VPC/IAM 베이스라인을 완전 자동화하고, "
            "2) `Workloads` OU의 모든 계정에서 HIPAA 비호환 AWS 서비스 및 비승인 리전(`ap-northeast-2` 외 리전) 사용을 차단하며, "
            "3) 모든 계정의 S3·EBS·RDS 기본 암호화 강제 및 보안 탐지 결과를 중앙 Security Account로 자동 집계하려 합니다.\n\n"
            "이 엔터프라이즈 랜딩 존 설계에 필요한 3가지 핵심 조합은 무엇입니까? (Select THREE.)"
        ),
        "Regulated Landing Zone (HIPAA):\n1) Terraform GitOps automated account vending & customization\n2) Region restriction + non-HIPAA service blocking across OU\n3) Enforce default encryption & centralize Security Hub/GuardDuty findings",
        [
            {"label": "A", "text": "AWS Control Tower Account Factory for Terraform (AFT)을 구축해 GitOps 워크플로우로 신규 계정 생성과 커스텀 Terraform 모듈 배포를 자동화한다."},
            {"label": "B", "text": "Control Tower의 Region Deny 가드레일(또는 `aws:RequestedRegion` 조건 SCP)과 Service Allowlist/Denylist SCP를 적용해 승인된 리전 및 HIPAA 적격 서비스만 사용하도록 제한한다."},
            {"label": "C", "text": "Security Account를 GuardDuty 및 Security Hub의 위임 관리자(Delegated Administrator)로 지정하고, Control Tower에서 EBS/S3/RDS 암호화 강제 컨트롤을 활성화한다."},
            {"label": "D", "text": "모든 계정의 AWS Artifact BAA(Business Associate Addendum) 계약을 무시하고 루트 사용자 Access Key를 Git 저장소에 커밋한다."},
            {"label": "E", "text": "Control Tower 관리 계정에 모든 환자 PHI 데이터베이스를 직접 배치한다."},
            {"label": "F", "text": "계정 간 보안 경보 집계를 위해 50개 계정 관리자에게 매주 이메일로 로그 CSV를 수동 첨부하게 한다."}
        ],
        ["A", "B", "C"],
        "A, B, C) Account Factory for Terraform(AFT) GitOps 계정 벤딩 / Region Deny & HIPAA 서비스 제한 SCP / Security Account 위임 관리자(GuardDuty·Security Hub) 및 암호화 컨트롤 활성화",
        "Control Tower AFT (Account Factory for Terraform), aws:RequestedRegion SCP, GuardDuty/Security Hub Delegated Admin, HIPAA",
        (
            "• 정답(A, B, C):\n"
            "  - A: **Account Factory for Terraform(AFT)** 은 Terraform GitOps 기반으로 Control Tower 신규 계정 벤딩 및 계정 커스터마이징 파이프라인을 표준 자동화합니다.\n"
            "  - B: **`aws:RequestedRegion` 조건이 포함된 SCP(Control Tower Region Deny)** 는 글로벌 서비스(`iam`, `sts`, `cloudfront`, `route53`, `budgets` 등)는 예외(`NotAction`)로 두면서 지정된 리전 외 모든 API 호출을 차단하며, HIPAA 적격 서비스 외 차단 SCP도 강제할 수 있습니다.\n"
            "  - C: Security Account를 **Delegated Administrator** 로 지정하면 조직 전체의 GuardDuty/Security Hub/Inspector 결과가 중앙 보안 계정으로 자동 집계됩니다(단, HIPAA 환경에서는 AWS Artifact에서 조직/계정 BAA 체결 필수).\n"
            "• 오답 분석:\n"
            "  - D, E, F: BAA 미체결, 관리 계정에 워크로드 배치, 수동 CSV 취합은 모두 심각한 보안·컴플라이언스 위반입니다."
        ),
        "`aws:RequestedRegion` SCP 작성 시 주의: `iam:*`, `sts:*`, `route53:*`, `cloudfront:*`, `organizations:*` 등 **글로벌 제어 평면 서비스는 `NotAction`으로 예외 처리** 해야 리전 제한 시 장애가 나지 않습니다!"
    ),
    (
        6, 5, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2 · 종합] 대규모 DDoS 방어: CloudFront + WAF Rate-Based Rule + AWS Shield Advanced + SRT",
        (
            "대형 쇼핑몰이 블랙프라이데이 시즌을 앞두고 경쟁 세력의 대규모 DDoS 공격(초당 수백 Gbps의 L3/L4 SYN/UDP Flood 및 분산 봇넷에 의한 L7 `/checkout` HTTP POST 폭주)을 대비해야 합니다. "
            "공격으로 인해 CloudFront 및 ALB 오토 스케일링 요금이 폭증하더라도 **DDoS 비용 보호(Cost Protection)** 를 받고 싶으며, "
            "L7 공격 발생 시 24시간 대응 가능한 AWS Shield Response Team(SRT)의 즉각적인 지원과 자동 차단 규칙 적용이 필요합니다.\n\n"
            "가장 완성도 높은 DDoS 방어 아키텍처는 무엇입니까?"
        ),
        "Threat Model:\n- Volumetric L3/L4 SYN/UDP Floods + L7 Botnet HTTP POST Flood on /checkout\n- Requirements: 24/7 AWS SRT support, DDoS scaling cost protection, automated rate-based blocking",
        [
            {"label": "A", "text": "CloudFront와 Route 53, ALB에 AWS Shield Advanced를 구독(Health Check + SRT 사전 권한 부여)하고, AWS WAF에 IP 기반 Rate-Based Rule(/checkout 경로 임계치 초과 IP 자동 차단)과 AWS Managed Bot Control 규칙을 연결한다. 또한 ALB 보안 그룹은 CloudFront Managed Prefix List 인바운드만 허용한다."},
            {"label": "B", "text": "AWS Shield Standard만 유지하고, L7 봇넷 공격 시 관리자가 새벽에 수동으로 NACL에 10만 개 봇 IP를 하나씩 차단 등록한다."},
            {"label": "C", "text": "ALB를 직접 인터넷에 열어두고 CloudFront를 제거하면 L3/L4 대역폭 흡수가 더 잘 된다."},
            {"label": "D", "text": "AWS WAF만 단독으로 NLB에 연결하면 24/7 SRT 지원과 DDoS 스케일링 요금 보상이 자동 제공된다."}
        ],
        ["A"],
        "A) CloudFront·Route 53·ALB에 AWS Shield Advanced(SRT+Cost Protection+Health Check)를 구독하고, AWS WAF Rate-Based/Bot Control 규칙 및 ALB CloudFront Prefix List 제한을 적용한다.",
        "AWS Shield Advanced, AWS SRT, DDoS Cost Protection, AWS WAF Rate-Based Rule, CloudFront Managed Prefix List",
        (
            "• 정답(A): **AWS Shield Advanced** 는 보호 대상 리소스(CloudFront, Route 53, ALB, Global Accelerator, EIP)에 대해 L3/L4/L7 고급 완화, **24/7 AWS SRT(Shield Response Team)** 직접 개입(프로액티브 대응을 위해 Route 53 헬스 체크 연동 권장), 그리고 공격 중 발생한 스케일아웃 비용을 환불해 주는 **DDoS Cost Protection** 을 제공합니다. 또한 **AWS WAF Rate-Based Rule** 로 L7 `/checkout` 폭주 IP를 자동 차단하며, ALB SG에 **CloudFront Managed Prefix List** 만 허용해 오리진 직접 우회 공격을 막습니다.\n"
            "• 오답 분석:\n"
            "  - B: Shield Standard는 L7 맞춤형 완화, SRT, 비용 보호가 없으며 NACL은 기본 20개(최대 40개) 규칙 한도 때문에 수만 개 봇 IP 차단이 불가합니다.\n"
            "  - C: CloudFront 엣지 분산과 WAF 방어를 제거하면 오리진이 공격에 직접 노출됩니다.\n"
            "  - D: AWS WAF는 NLB에 직접 연결할 수 없으며, SRT/비용 보호는 Shield Advanced 구독 시에만 제공됩니다."
        ),
        "엔터프라이즈 DDoS 방어 4종 세트: **CloudFront(엣지 흡수)** + **ALB SG Prefix List(오리진 우회 차단)** + **WAF Rate-Based Rule(L7 차단)** + **Shield Advanced(SRT+비용보호)**!"
    ),
    (
        6, 6, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2 · 종합] 엣지 하이브리드 컴퓨팅 선택: AWS Outposts vs Local Zones vs Wavelength",
        (
            "물류 자동화 기업이 두 개의 극단적인 저지연(Low Latency) 요구사항을 가진 신규 시스템을 설계하고 있습니다:\n"
            "1) **스마트 팩토리 컨베이어 비전 검사**: 공장 내부 로봇 팔 제어기가 클라우드 WAN 연결이 일시적으로 완전히 단절되더라도 공장 로컬 네트워크에서 **3ms 이내** 로 S3/EKS 추론 결과를 받아야 하며, AWS API로 중앙 관리되어야 합니다.\n"
            "2) **대도시 모바일 게이밍 매치메이킹**: 특정 대도시(예: LA, 보스턴 등 AWS 리전이 없는 대도시) 최종 사용자에게 인터넷 지연 시간 **10ms 이하** 로 EC2/ALB를 노출하되, 자체 데이터센터 상면이나 하드웨어를 구매·설치할 공간은 없습니다.\n\n"
            "각 시나리오에 가장 적합한 하이브리드·엣지 서비스 조합은 무엇입니까?"
        ),
        "Edge 1: Factory floor (<3ms, MUST survive WAN disconnect locally, AWS managed hardware on-prem)\nEdge 2: Metro city end-users (<10ms latency, NO on-prem datacenter space)",
        [
            {"label": "A", "text": "시나리오 1: AWS Outposts (공장 온프레미스 랙/서버 설치 + 로컬 S3/EKS) / 시나리오 2: AWS Local Zones (대도시 AWS 관리형 거점 서브넷 확장)"},
            {"label": "B", "text": "시나리오 1: AWS Wavelength / 시나리오 2: AWS Snowcone"},
            {"label": "C", "text": "시나리오 1: AWS Local Zones / 시나리오 2: AWS Outposts"},
            {"label": "D", "text": "시나리오 1과 2 모두 CloudFront 엣지 캐시만으로 컨테이너 게임 서버와 공장 로봇 비전 추론을 실행한다."}
        ],
        ["A"],
        "A) 시나리오 1(공장 내부 설치 + WAN 단절 생존): AWS Outposts / 시나리오 2(대도시 최종 사용자 저지연, 자체 상면 없음): AWS Local Zones",
        "AWS Outposts, AWS Local Zones, AWS Wavelength, Hybrid Edge Computing, Disconnected Operation",
        (
            "• 정답(A): **AWS Outposts** 는 고객의 온프레미스 데이터센터/공장에 AWS가 물리 랙 또는 1U/2U 서버를 직접 설치·운영하여 로컬 LAN 저지연 및 WAN 단절 시 로컬 생존성(Local Cluster/Data)을 제공합니다. **AWS Local Zones** 는 AWS 리전이 없는 대도시 인구 밀집 지역에 AWS가 자체 관리하는 인프라 확장 거점을 두어 고객의 VPC 서브넷을 대도시로 확장해 주는 서비스입니다(참고: **AWS Wavelength** 는 5G 통신사 기지국/MEC 내부에 배치해 5G 모바일 단말 초저지연 제공).\n"
            "• 오답 분석:\n"
            "  - B, C, D: 각 엣지 서비스의 물리적 위치(고객 사내 = Outposts, 대도시 AWS 거점 = Local Zones, 5G 통신사 망 = Wavelength)가 잘못 매칭되었습니다."
        ),
        "엣지 인프라 3대장 배치 위치: 고객 사내/공장 = **Outposts**, 대도시 AWS 거점 = **Local Zones**, 5G 통신사 에지 = **Wavelength**!"
    ),
    (
        6, 7, 2, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2 · 종합] 멀티 리전 Active-Active 앱의 암호화 키 일관성: KMS Multi-Region Keys + Envelope Encryption",
        (
            "다국적 전자서명 SaaS가 `us-east-1` 과 `eu-west-1` 두 리전에서 Active-Active 로 운영되며 DynamoDB Global Tables에 암호화된 계약서 메타데이터와 PII 필드를 저장합니다. "
            "기존에는 단일 리전 KMS 키(`us-east-1`)로 암호화해 `eu-west-1` 에 복제되다 보니, 유럽 사용자가 데이터를 복호화할 때마다 대서양을 건너 `us-east-1` KMS를 호출해 지연이 크고 `us-east-1` 리전 장애 시 유럽 서비스마저 복호화에 실패했습니다. "
            "또한 매초 수만 번 암호화할 때 KMS API 호출 스로틀링과 비용도 줄여야 합니다.\n\n"
            "이 문제를 해결하는 암호화 아키텍처 조합 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Multi-Region Encryption Goals:\n1) Encrypt in us-east-1, replicate ciphertext via DynamoDB Global Tables, decrypt locally in eu-west-1 even if us-east-1 is DOWN\n2) Reduce KMS API call latency/cost under tens of thousands of ops/sec",
        [
            {"label": "A", "text": "AWS KMS Multi-Region Keys(mrk-... 접두사를 공유하는 Primary 및 Replica 키)를 두 리전에 구성하여, 한 리전에서 암호화한 암호문을 다른 리전의 로컬 Replica KMS 키로 재암호화 없이 즉시 복호화한다."},
            {"label": "B", "text": "AWS Encryption SDK를 활용한 봉투 암호화(Envelope Encryption) 및 Data Key Caching(로컬 메모리 캐시에서 제한된 수명/메시지 횟수 내 데이터 키 재사용)을 적용해 KMS API 호출 빈도를 극적으로 줄인다."},
            {"label": "C", "text": "두 리전에서 서로 다른 일반 단일 리전 KMS 키를 생성하고 동일한 별칭(alias/app-key) 이름만 붙이면 동일한 키 재료가 공유되어 상호 복호화된다."},
            {"label": "D", "text": "전역 공통 고정 AES-256 마스터 키 문자열을 모든 마이크로서비스 소스코드 환경 변수에 평문으로 배포한다."},
            {"label": "E", "text": "DynamoDB Global Tables가 복제 시 자동으로 KMS 키를 감지해 대상 리전의 단일 리전 키로 암호문을 재암호화해 준다."}
        ],
        ["A", "B"],
        "A, B) AWS KMS Multi-Region Keys(동일 키 ID/키 재료 리전 복제) 구성 / AWS Encryption SDK 봉투 암호화 및 Data Key Caching 적용",
        "AWS KMS Multi-Region Keys, Envelope Encryption, Data Key Caching, AWS Encryption SDK, Active-Active Decryption",
        (
            "• 정답(A, B):\n"
            "  - A: **AWS KMS Multi-Region Keys(`mrk-...`)** 는 서로 다른 리전에서도 **동일한 Key ID와 동일한 암호화 키 재료(Key Material)** 를 공유하므로, `us-east-1` 에서 암호화해 DynamoDB Global Tables로 복제된 암호문을 `eu-west-1` 애플리케이션이 로컬 KMS 엔드포인트만 호출해 즉시 복호화할 수 있습니다(`us-east-1` 장애 시에도 생존).\n"
            "  - B: 고빈도 암·복호화에서는 **Envelope Encryption + Data Key Caching**(AWS Encryption SDK)을 적용해 매 건마다 KMS `GenerateDataKey` 를 호출하지 않고 제한된 TTL/횟수 동안 데이터 키를 캐시 재사용함으로써 스로틀링과 비용을 막습니다.\n"
            "• 오답 분석:\n"
            "  - C: 일반 단일 리전 KMS 키는 별칭(Alias)이 같아도 실제 키 재료와 Key ARN이 완전히 달라 상호 복호화가 불가능합니다.\n"
            "  - D: 소스 코드/환경 변수 평문 키 배포는 심각한 보안 위반입니다.\n"
            "  - E: DynamoDB Global Tables 복제는 아이템 바이트를 그대로 복제할 뿐 애플리케이션 계층 암호문을 재암호화하지 않습니다."
        ),
        "Active-Active 글로벌 복호화 생존성 = **KMS Multi-Region Keys (`mrk-...`)** + 대량 암복호화 스로틀링 방지 = **Envelope Encryption + Data Key Caching**!"
    ),
    (
        6, 8, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2 · 종합] 코드 없는 스트림 필터링·보강 파이프라인: Amazon EventBridge Pipes",
        (
            "아키텍트 팀이 **Amazon DynamoDB Streams** 에서 발생하는 주문 상태 변경 이벤트를 받아 처리하는 서버리스 파이프라인을 새로 구축합니다. "
            "요구사항은 다음과 같습니다:\n"
            "1) 오직 `eventName == MODIFY` 이고 `newStatus == 'SHIPPED'` 인 이벤트만 걸러낼 것\n"
            "2) 필터를 통과한 이벤트에 대해 고객 배송지 정보를 조회하는 내부 API Gateway(또는 Lambda)를 호출해 페이로드를 보강(Enrich)할 것\n"
            "3) 보강된 최종 이벤트를 **AWS Step Functions** 워크플로우로 전달하되, 기존에 이런 단순 배관(Glue)용으로 작성·유지보수하던 폴링 Lambda 함수 코드를 아예 제거하고 싶습니다.\n\n"
            "가장 적은 코드와 운영 오버헤드로 이를 구현하는 서비스는 무엇입니까?"
        ),
        "Point-to-Point Pipeline (Zero Glue Code):\nSource: DynamoDB Stream -> Filter (SHIPPED only) -> Enrich (API GW/Lambda) -> Target: Step Functions",
        [
            {"label": "A", "text": "Amazon EventBridge Pipes를 사용해 Source(DynamoDB Stream) -> Filtering(JSON 패턴 필터) -> Enrichment(API Gateway/Lambda) -> Target(Step Functions)으로 노코드/선언적 통합 파이프라인을 구성한다."},
            {"label": "B", "text": "DynamoDB Stream 전체 이벤트를 100% EC2 워커로 폴링해 Python 코드로 필터링과 보강을 직접 구현한다."},
            {"label": "C", "text": "S3 Batch Operations를 매분 실행해 DynamoDB 테이블 전체를 스캔하고 Step Functions를 호출한다."},
            {"label": "D", "text": "EventBridge Scheduler로 매초 DynamoDB를 폴링하는 Lambda를 유지보수한다."}
        ],
        ["A"],
        "A) Amazon EventBridge Pipes로 Source(DynamoDB Stream) - Filter - Enrichment - Target(Step Functions)을 글루 코드 없이 연결한다.",
        "Amazon EventBridge Pipes, Zero Glue Code, Stream Filtering, Event Enrichment, Point-to-Point Integration",
        (
            "• 정답(A): **Amazon EventBridge Pipes** 는 Point-to-Point(1:1) 이벤트 통합을 위해 설계된 서비스로, **Source(SQS, DynamoDB Stream, Kinesis, MSK 등) → Filter(이벤트 패턴 필터링) → Enrichment(Lambda, Step Functions, API Gateway, API Destinations로 데이터 보강) → Target** 의 4단계를 커스텀 폴링·배관 코드(Glue code) 작성 없이 연결하며 순서 보장 및 배치 처리를 내장합니다.\n"
            "• 오답 분석:\n"
            "  - B, D: 직접 폴링 워커나 글루 Lambda를 유지보수하면 코드 관리 부담과 불필요한 호출 비용이 발생합니다.\n"
            "  - C: S3 Batch Operations는 S3 객체 일괄 작업용이지 DynamoDB Stream 실시간 파이프라인이 아닙니다."
        ),
        "EventBridge 기능 구분: **Event Bus** = N:M 이벤트 브로커/팬아웃, **Scheduler** = 수백만 크론/일회성 예약, **Pipes** = 글루 코드 없는 1:1 스트림 필터·보강·전달!"
    ),
    (
        6, 9, 2, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2 · 종합] 엔터프라이즈 Apache Kafka 호환 멀티 리전 복제: Amazon MSK + MSK Replicator",
        (
            "글로벌 금융 스트리밍 플랫폼이 온프레미스에서 운영하던 **Apache Kafka** 기반 프로듀서·컨슈머 애플리케이션들을 소스 코드의 Kafka 프로토콜 변경 없이 AWS 완전관리형 서비스로 이전하고, "
            "두 개 리전(`us-east-1`, `eu-west-1`)에서 Active-Active 토픽 복제와 함께 **장애 조치 시 컨슈머 오프셋(Consumer Offset) 자동 동기화** 및 "
            "장기 토픽 데이터(90일 이상)의 저비용 저장 기능을 구현하고자 합니다.\n\n"
            "이 요구사항을 충족하는 최적의 AWS 구성 2가지는 무엇입니까? (Select TWO.)"
        ),
        "Kafka Streaming Requirements:\n- Native Apache Kafka client compatibility (no Kinesis SDK rewrite)\n- Multi-Region active-active topic replication with automatic consumer offset sync\n- Cost-effective 90-day+ retention beyond local EBS broker disks",
        [
            {"label": "A", "text": "Amazon MSK(Managed Streaming for Apache Kafka) 클러스터를 배포해 기존 Kafka 프로듀서·컨슈머 코드를 그대로 유지하고, MSK Tiered Storage를 활성화해 오래된 로그 세그먼트를 저비용 원격 스토리지(S3 기반)로 오프로드한다."},
            {"label": "B", "text": "Amazon MSK Replicator를 구성해 두 리전의 MSK 클러스터 간 비동기 토픽·메타데이터·ACL 및 컨슈머 그룹 오프셋을 자동 복제·동기화한다."},
            {"label": "C", "text": "Amazon Kinesis Data Streams로 교체하면 기존 Apache Kafka Java/Python 클라이언트 바이너리 프로토콜이 수정 없이 100% 그대로 연결된다."},
            {"label": "D", "text": "두 리전 MSK 클러스터 간 복제를 위해 브로커 EBS 볼륨 스냅샷을 1시간마다 복사해 운영 중인 클러스터에 덮어씌운다."},
            {"label": "E", "text": "90일 보관을 위해 모든 MSK 브로커에 100 TB io2 Block Express EBS를 영구 부착한다."}
        ],
        ["A", "B"],
        "A, B) Amazon MSK + Tiered Storage로 Kafka 프로토콜 호환 및 90일 저비용 보관 확보 / MSK Replicator로 멀티 리전 토픽 및 컨슈머 오프셋 자동 동기화",
        "Amazon MSK, MSK Replicator, MSK Tiered Storage, Consumer Offset Sync, Apache Kafka Compatibility",
        (
            "• 정답(A, B):\n"
            "  - A: **Amazon MSK** 는 Apache Kafka 완전관리형 서비스이므로 기존 Kafka 클라이언트를 수정 없이 연결할 수 있으며, **MSK Tiered Storage** 를 활성화하면 브로커 로컬 EBS 디스크를 무한정 키우지 않고도 오래된 세그먼트를 고내구성 저비용 원격 계층(S3 기반)으로 자동 계층화해 90일 이상 저렴하게 보관할 수 있습니다.\n"
            "  - B: **Amazon MSK Replicator** 는 별도 MirrorMaker 2(MM2) EC2 클러스터를 직접 관리하지 않고도 리전 간 토픽, 파티션 구성, ACL 및 **컨슈머 체크포인트 오프셋(Offset Translation)** 을 자동 복제하여 DR 전환 시 중복·유실을 최소화합니다.\n"
            "• 오답 분석:\n"
            "  - C: Kinesis Data Streams는 독자 API(KCL/KPL/AWS SDK)를 사용하므로 Kafka 프로토콜과 직접 호환되지 않습니다.\n"
            "  - D: 브로커 EBS 스냅샷 복사는 분산 Raft/ZooKeeper/오프셋 상태를 일관되게 동기화하는 스트리밍 DR 방식이 아닙니다.\n"
            "  - E: 모든 브로커에 초대용량 `io2` EBS를 붙이는 것은 Tiered Storage 대비 막대한 비용 낭비입니다."
        ),
        "기존 Kafka 호환 + 리전 간 오프셋 동기화 = **Amazon MSK + MSK Replicator**, 90일 장기 보관 비용 절감 = **MSK Tiered Storage**!"
    ),
    (
        6, 10, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2 · 종합] 무중단 데이터베이스 자격 증명 교체(Alternating Users) 및 DR 리전 비밀 복제",
        (
            "보안 감사가 Amazon Aurora Global Database(Primary: `us-east-1`, Secondary: `eu-west-1`)의 마스터/애플리케이션 DB 비밀번호를 "
            "**30일마다 자동 교체(Rotation)** 할 것을 요구합니다. "
            "그러나 기존 단일 사용자 교체(Single User Rotation) 방식에서는 비밀번호가 바뀌는 순간 실행 중인 애플리케이션 커넥션 풀이 기존 암호로 재연결을 시도하다 일시적 인증 실패가 발생했습니다. "
            "또한 `us-east-1` 리전 장애로 `eu-west-1` 로 페일오버할 때도 즉시 유효한 최신 DB 암호를 로컬에서 읽어올 수 있어야 합니다.\n\n"
            "무중단 암호 교체와 멀티 리전 재해 복구를 모두 만족하는 설계는 무엇입니까?"
        ),
        "Secrets Requirements:\n- Automatic 30-day DB password rotation with ZERO connection failures during rotation\n- Instant local secret availability in DR region (eu-west-1) during primary region outage",
        [
            {"label": "A", "text": "AWS Secrets Manager에서 멀티 리전 비밀 복제(Replicate Secret to eu-west-1)를 활성화하고, RDS/Aurora용 '교대 사용자(Alternating Users) 교체 전략'을 적용해 두 개의 복제 계정이 번갈아 교체되면서 활성 연결을 유지하도록 하며 앱이 주기적으로 비밀 캐시를 갱신하게 한다."},
            {"label": "B", "text": "AWS Systems Manager Parameter Store Standard Tier에 평문 String으로 비밀번호를 저장하고 리전 간 수동 복사한다."},
            {"label": "C", "text": "단일 사용자(Single User) 교체 전략을 유지한 채 교체 시간마다 모든 ECS 태스크를 5분간 강제 종료한다."},
            {"label": "D", "text": "비밀번호 자동 교체를 영구 비활성화하고 10년 고정 암호를 컨테이너 이미지에 내장한다."}
        ],
        ["A"],
        "A) AWS Secrets Manager의 리전 비밀 복제(Replicate Secret)와 교대 사용자(Alternating Users) 교체 전략을 적용해 무중단 30일 교체 및 DR 로컬 가용성을 확보한다.",
        "AWS Secrets Manager, Alternating Users Rotation, Cross-Region Secret Replication, Zero-Downtime Credential Rotation",
        (
            "• 정답(A): **AWS Secrets Manager** 는 **Alternating Users(교대 사용자)** 교체 전략을 기본 제공하여 두 개의 DB 사용자(`userA`, `userB`)를 교대로 복제·회전시킵니다. 한쪽 계정의 암호가 바뀌는 동안에도 기존 연결은 다른 계정의 유효 암호로 무중단 유지되므로 커넥션 드롭이 발생하지 않습니다. 또한 **비밀 복제(Multi-Region Secret Replication)** 를 켜면 `us-east-1` 원본 비밀이 교체될 때 `eu-west-1` 복제 비밀도 자동 동기화되어 DR 리전 장애 조치 시 로컬에서 즉시 조회할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - B: Parameter Store는 Secrets Manager와 같은 턴키 DB 교대 사용자 자동 교체 Lambda 및 기본 멀티 리전 비밀 동기화를 제공하지 않습니다.\n"
            "  - C, D: 서비스 강제 중단이나 고정 암호 내장은 가용성 및 보안 컴플라이언스 위반입니다."
        ),
        "Secrets Manager 무중단 교체 키워드: **Alternating Users Strategy** (기존 연결 무중단 보장) + **Cross-Region Secret Replication** (DR 리전 로컬 읽기)!"
    ),
    (
        6, 11, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2 · 종합] HLS/DASH 세그먼트 비디오 스트리밍을 위한 CloudFront Signed Cookies 설계",
        (
            "유료 온라인 강의 플랫폼이 S3에 저장된 수천 개 강좌의 HLS 스트리밍 비디오(`.m3u8` 플레이리스트와 강좌당 수백 개의 `.ts` 세그먼트 파일)를 "
            "CloudFront를 통해 유료 구독자에게만 제공하려 합니다. "
            "구독자가 강좌 A를 재생할 때 플레이어가 수백 개의 `.ts` 세그먼트를 연속 요청하게 되므로, 매 세그먼트 파일마다 별도의 URL을 서명해 내려주는 비효율 없이 "
            "한 번의 인증으로 `/courses/course-a/*` 하위 모든 파일에 대해 유효시간 및 접속자 IP 제한이 적용된 접근 권한을 부여하고자 합니다.\n\n"
            "가장 적합한 CloudFront 접근 제어 방식은 무엇입니까?"
        ),
        "Streaming Media Profile:\n- HLS/DASH: 1 .m3u8 manifest + hundreds of .ts chunk files per video\n- Authenticated subscribers should access `/courses/course-a/*` without signing hundreds of separate URLs + enforce IP & expiration",
        [
            {"label": "A", "text": "CloudFront Signed Cookies를 사용하되 Custom Policy(와일드카드 Resource 경로 `/courses/course-a/*`, 만료 시간, 선택적 클라이언트 IP 제한)로 발급하고 S3 버킷은 CloudFront OAC로 비공개 잠금 유지한다."},
            {"label": "B", "text": "S3 Presigned URLs만 수백 개씩 매번 생성해 브라우저에 전달하고 CloudFront는 제거한다."},
            {"label": "C", "text": "CloudFront Signed URLs에 Canned Policy만 사용하면 단일 URL 하나로 모든 `/courses/course-a/*` 하위 세그먼트 요청에 쿠키처럼 자동 적용된다."},
            {"label": "D", "text": "모든 비디오 `.ts` 세그먼트는 Public-Read S3 버킷에 두고 `.m3u8` 파일만 비밀번호로 보호한다."}
        ],
        ["A"],
        "A) CloudFront Signed Cookies (Custom Policy: 와일드카드 경로 `/courses/course-a/*`, 만료일, IP 조건) + S3 OAC 비공개 오리진 구성을 적용한다.",
        "CloudFront Signed Cookies, Custom Policy vs Canned Policy, HLS Streaming, S3 OAC, Wildcard Access Control",
        (
            "• 정답(A): **CloudFront Signed Cookies** 는 브라우저가 다수의 후속 요청(`.ts` 세그먼트 수백 개, HTML 내 다수 이미지/자산)을 보낼 때 쿠키를 자동 첨부하므로 파일마다 URL을 다시 서명할 필요가 없습니다. 특히 **Custom Policy** 를 사용하면 와일드카드 경로(`/courses/course-a/*`), 시작/만료 시간, IP 대역(`IpAddress`) 조건까지 정밀하게 제한할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - B: CloudFront 엣지 캐싱을 포기하고 S3에서 직접 수백 개 Presigned URL을 서명하면 지연·비용·재생 구조가 크게 악화됩니다.\n"
            "  - C: Signed URLs의 Canned Policy는 단일 특정 객체 경로 1개에만 적용되며 쿠키처럼 하위 다수 URL에 자동 전송되지 않습니다.\n"
            "  - D: `.ts` 파일이 퍼블릭이면 인증 없는 외부 사용자가 세그먼트 URL을 직접 긁어갈 수 있습니다."
        ),
        "CloudFront Signed URL vs Cookie 감별: **단일 파일 다운로드** = Signed URL, **다수 파일 / HLS 세그먼트(`.m3u8` + `.ts`) / URL 변경 불가** = **Signed Cookies (Custom Policy 와일드카드)**!"
    ),
    (
        6, 12, 2, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 2 · 종합] 랜섬웨어 침해 대비 논리적 에어갭 백업 볼트(Logically Air-Gapped Vault) & Compliance Lock",
        (
            "금융사의 최고정보보호책임자(CISO)가 최악의 랜섬웨어 시나리오에 대비한 불변 백업 아키텍처를 요구했습니다: "
            "'만약 공격자가 워크로드 계정의 관리자 권한은 물론 AWS Organizations 관리 계정의 크리덴셜까지 일부 탈취하더라도, "
            "프로덕션 RDS·EBS·EFS·DynamoDB 백업 복구 지점을 **90일 보존 기간 만료 전에는 루트 사용자를 포함한 누구도 삭제하거나 단축할 수 없어야 하며**, "
            "백업 데이터는 워크로드 계정과 논리적으로 격리된 독립 보안 경계에 암호화 보관되어야 합니다.'\n\n"
            "이를 달성하는 AWS Backup 아키텍처는 무엇입니까?"
        ),
        "Ransomware Worst-Case Defense:\n- Even compromised workload Admin / Root user must NOT delete backups before 90 days\n- Logical isolation across accounts & encrypted recovery points",
        [
            {"label": "A", "text": "워크로드 계정 내부의 기본 AWS Backup Vault에 백업을 보관하고 IAM 사용자 정책으로만 삭제를 금지한다."},
            {"label": "B", "text": "별도로 격리된 전용 Security/Backup 계정에 **AWS Backup Vault Lock(Compliance Mode, 90일 최소 보존 기간 설정 및 유예 기간 만료 후 영구 잠금)** 또는 **Logically Air-Gapped Vault** 를 구성하고, 교차 계정·교차 리전 백업 복사로 복구 지점을 자동 격리 저장한다."},
            {"label": "C", "text": "AWS Backup Vault Lock을 Governance Mode로만 설정하면 루트 사용자도 영구적으로 보존 기간을 단축하거나 볼트를 삭제할 수 없다."},
            {"label": "D", "text": "RDS 자동 스냅샷(기본 보관 최대 35일)에만 의존하면 DB 인스턴스 삭제 시 스냅샷이 90일간 자동 불변 유지된다."}
        ],
        ["B"],
        "B) 격리된 전용 Backup 계정에 AWS Backup Vault Lock(Compliance Mode, 90일 보존) 또는 Logically Air-Gapped Vault를 구성하고 교차 계정·교차 리전 복사를 수행한다.",
        "AWS Backup Vault Lock, Compliance Mode, Logically Air-Gapped Vault, Ransomware Protection, Cross-Account Copy",
        (
            "• 정답(B): **AWS Backup Vault Lock(Compliance Mode)** 은 유예 기간(최소 72시간 설정 가능)이 지나면 **AWS 계정 루트 사용자와 AWS 지원팀조차 보존 기간이 만료되기 전에는 백업이나 볼트를 삭제·변경할 수 없는** 진정한 WORM 불변성을 보장합니다. 또한 **Logically Air-Gapped Vault** 는 전용 관리형 암호화 키와 MPA(Multi-Party Approval)/RAM 공유 모델을 결합해 워크로드 계정이 침해되어도 백업을 격리 보호하며 다른 클린 계정으로 신속히 복구할 수 있게 해줍니다.\n"
            "• 오답 분석:\n"
            "  - A: 동일 계정 내 일반 볼트는 관리자/루트 권한 탈취 시 즉시 삭제됩니다.\n"
            "  - C: Governance Mode는 적절한 권한을 가진 관리자가 잠금을 해제하고 삭제할 수 있습니다.\n"
            "  - D: RDS 자동 백업은 최대 35일 제한이며 DB 삭제 시(수동 스냅샷 제외) 함께 삭제될 수 있고 불변 잠금이 없습니다."
        ),
        "랜섬웨어 방어 불변 백업 = **격리된 백업 계정 + AWS Backup Vault Lock (Compliance Mode) / Logically Air-Gapped Vault**!"
    ),
    (
        6, 13, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3 · 종합] 20억 개 기존 S3 객체 일괄 KMS 재암호화: S3 Inventory + S3 Batch Operations + Bucket Keys",
        (
            "규제 감사 지적 사항으로 프로덕션 데이터 레이크 S3 버킷에 이미 저장되어 있는 **20억 개의 기존 객체** 를 기본 SSE-S3에서 "
            "새로운 Customer Managed KMS Key(`SSE-KMS`)로 일괄 재암호화하고 객체 태그(`Classification=Confidential`)를 부여해야 합니다. "
            "단, 향후 20억 개 객체에 대한 KMS `GenerateDataKey`/`Decrypt` API 호출 폭탄으로 월 수십만 달러의 KMS 비용이 청구되지 않도록 방어해야 하며, "
            "Lambda 타임아웃이나 페이지네이션 끊김 없이 안정적으로 완료되어야 합니다.\n\n"
            "가장 안정적이고 비용 최적화된 일괄 처리 아키텍처는 무엇입니까?"
        ),
        "Scale: 2,000,000,000 (2 Billion) existing S3 objects\nTask: Re-encrypt SSE-S3 -> SSE-KMS (CMK) + add tag, while minimizing KMS API request costs",
        [
            {"label": "A", "text": "대상 S3 버킷에 **S3 Bucket Key** 를 먼저 활성화(KMS API 요청 비용 최대 99% 절감)한 뒤, **S3 Inventory** 리포트로 20억 개 객체 목록 매니페스트를 생성하고, **S3 Batch Operations** 작업(Copy + SSE-KMS + Tagging)으로 서버리스 자동 일괄 재암호화한다."},
            {"label": "B", "text": "단일 AWS Lambda 함수로 `ListObjectsV2` 를 순회하며 20억 개 객체를 `CopyObject` 하도록 15분 타임아웃을 늘린다."},
            {"label": "C", "text": "S3 Bucket Key 없이 S3 Batch Operations를 실행하면 KMS API 호출 요금이 항상 0원으로 면제된다."},
            {"label": "D", "text": "버킷 기본 암호화(Default Encryption) 설정을 SSE-KMS로 변경하면 기존에 저장되어 있던 20억 개 객체가 자동으로 재암호화된다."}
        ],
        ["A"],
        "A) 버킷에 S3 Bucket Key를 활성화해 KMS API 호출 비용을 최대 99% 줄이고, S3 Inventory 매니페스트 + S3 Batch Operations(Copy + Tag)로 20억 개 객체를 안정적으로 재암호화한다.",
        "S3 Batch Operations, S3 Inventory, S3 Bucket Keys, 99% KMS Cost Reduction, Retroactive Encryption",
        (
            "• 정답(A): 버킷 기본 암호화 설정을 바꾸더라도 **기존 객체는 소급 재암호화되지 않으므로** 덮어쓰기 복사가 필요합니다. 수십억 개 객체를 안전하고 재시도·진행률 추적과 함께 처리하는 AWS 네이티브 도구는 **S3 Inventory(매니페스트 생성) + S3 Batch Operations** 입니다. 이때 버킷의 **S3 Bucket Key** 를 반드시 함께 켜야 S3가 단기 버킷 레벨 키를 재사용하여 20억 건에 대한 KMS `GenerateDataKey` API 호출 요금을 **최대 99%** 까지 절감할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - B: Lambda는 15분 제한으로 20억 개 객체 순회 복사를 처리할 수 없습니다.\n"
            "  - C: S3 Bucket Key 없이는 객체 1개 복사마다 KMS API 호출 1건이 과금되어 20억 건 기준 수천~수만 달러 이상의 KMS API 요금이 발생합니다.\n"
            "  - D: S3 기본 암호화 변경은 **향후 새로 업로드되는 객체** 에만 적용됩니다."
        ),
        "S3 기존 수십억 객체 소급 변경 3종 세트: **S3 Bucket Key (KMS 비용 99%↓) + S3 Inventory (목록) + S3 Batch Operations (실행)**!"
    ),
    (
        6, 14, 3, 1, 1,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3 · 종합] 부팅 12분 소요 Java EC2 ASG 대응: Warm Pools + Predictive Scaling + Mixed Instances",
        (
            "대형 ERP SaaS의 Java 애플리케이션 서버(EC2 Auto Scaling Group)는 실행 후 OS 패키지 로드, JVM 기동, 수 GB 인메모리 캐시 예열 때문에 "
            "새 인스턴스가 ALB 헬스 체크를 통과(InService)하기까지 **12분** 이 걸립니다. "
            "매일 오전 9시 업무 개시 시점과 돌발 프로모션 시 2분 이내에 인스턴스가 트래픽을 받아야 하며, 동시에 Spot 인스턴스를 섞어 비용을 줄이되 Spot 회수(Interruption)로 인한 용량 부족은 피해야 합니다.\n\n"
            "부팅 지연 해결과 가용성·비용 균형을 모두 맞추는 EC2 Auto Scaling 구성은 무엇입니까?"
        ),
        "EC2 ASG Pain Points:\n- 12-min boot & JVM cache warm-up time (needs <2 min scale-out readiness)\n- Predictable 09:00 AM daily surge + unexpected promo spikes\n- Want Spot savings without Spot interruption risk during critical capacity",
        [
            {"label": "A", "text": "EC2 Auto Scaling Warm Pools(`Stopped` 또는 `Hibernated` 상태로 사전 부팅·JVM 웜업된 인스턴스 대기)와 Predictive Scaling(과거 추세 선행 확장)을 활성화하고, Mixed Instances Policy(On-Demand Base + `capacity-optimized` Spot 할당 전략)를 구성한다."},
            {"label": "B", "text": "Spot 할당 전략을 `lowest-price` 로만 두고 Warm Pool 없이 부팅 지연이 12분인 상태로 Target Tracking(CPU 80%)만 사용한다."},
            {"label": "C", "text": "오전 9시 피크 용량(100대)을 24시간 내내 On-Demand MinSize=100으로 고정 유지한다."},
            {"label": "D", "text": "ALB 헬스 체크 유예 기간(HealthCheckGracePeriod)을 10초로 줄이면 JVM 부팅 시간이 12분에서 10초로 단축된다."}
        ],
        ["A"],
        "A) Auto Scaling Warm Pools(Stopped/Hibernated 사전 초기화) + Predictive Scaling + Mixed Instances Policy(On-Demand Base + `capacity-optimized` Spot)를 적용한다.",
        "EC2 Auto Scaling Warm Pools, Predictive Scaling, Mixed Instances Policy, capacity-optimized Spot",
        (
            "• 정답(A): **Auto Scaling Warm Pools** 는 수명주기 훅을 통해 OS와 JVM 캐시 초기화까지 끝낸 인스턴스를 `Stopped`/`Hibernated` 상태로 저렴하게 대기(EBS 스토리지 비용만 발생)시키므로 필요 시 수십 초~1~2분 내에 `InService` 로 투입할 수 있습니다. 여기에 **Predictive Scaling** 으로 오전 9시 예측 피크 전 선제 확장하고, **Mixed Instances Policy** 에서 핵심 최소 용량은 On-Demand로 보장하되 추가 용량은 중단 확률이 가장 낮은 풀을 고르는 **`capacity-optimized`** Spot 전략으로 비용과 안정성을 모두 잡습니다.\n"
            "• 오답 분석:\n"
            "  - B: `lowest-price` 전략은 가장 싼 풀에 몰려 잦은 Spot 회수를 유발하며 12분 초기화 지연도 그대로 남습니다.\n"
            "  - C: 24시간 100대 상시 가동은 비용 최적화 원칙에 어긋납니다.\n"
            "  - D: `HealthCheckGracePeriod` 를 줄이면 부팅 중인 인스턴스가 건강하지 않은 것으로 오판되어 무한 종료·재기동 루프에 빠집니다."
        ),
        "느린 앱 초기화(JVM/패키지 설치) 급속 스케일아웃 = **ASG Warm Pools**, Spot 중단 최소화 할당 전략 = **`capacity-optimized`** (가격만 보는 `lowest-price` 지양)!"
    ),
    (
        6, 15, 3, 2, 2,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 3 · 종합] SQS 빈 큐 폴링 비용 절감(Long Polling) 및 Backlog-per-Instance 오토 스케일링",
        (
            "주문 처리 워커(EC2 Auto Scaling Group)가 Amazon SQS 큐에서 메시지를 가져와 처리합니다. "
            "아키텍처 점검 결과 두 가지 비효율이 발견되었습니다:\n"
            "1) 야간 유휴 시간대에 큐가 비어 있음에도 워커들이 매 밀리초마다 `ReceiveMessage` 를 Short Polling으로 호출해 수천만 건의 불필요한 빈 SQS API 요금이 청구되고 있습니다.\n"
            "2) 주간 트래픽 급증 시 단순 `ApproximateNumberOfMessagesVisible > 1000` 임계치 경보만 사용하다 보니 워커가 50대로 늘어난 뒤에도 불필요하게 계속 확장되거나, 반대로 메시지 체류 지연(Slow consumer)을 놓치고 있습니다.\n\n"
            "비용 절감과 정밀한 오토 스케일링을 위해 적용해야 할 2가지 개선 방안은 무엇입니까? (Select TWO.)"
        ),
        "SQS Worker Improvements:\n1) Eliminate millions of empty ReceiveMessage API calls during idle nights\n2) Scale ASG accurately proportional to actual worker capacity & detect stalled processing",
        [
            {"label": "A", "text": "SQS 큐 또는 ReceiveMessage 요청에 Long Polling(`WaitTimeSeconds = 20`)과 배치 수신(`MaxNumberOfMessages = 10`)을 활성화해 빈 응답 API 호출을 제거한다."},
            {"label": "B", "text": "CloudWatch Metric Math를 사용해 `BacklogPerInstance (ApproximateNumberOfMessagesVisible / GroupInServiceInstances)` 기반 Target Tracking 스케일링 정책을 구성하고, `ApproximateAgeOfOldestMessage` 경보로 처리 지연을 감시한다."},
            {"label": "C", "text": "SQS `WaitTimeSeconds` 를 0초로 고정하고 워커 스레드 수를 10배 늘려 즉시 빈 응답을 확인하게 한다."},
            {"label": "D", "text": "SQS 큐를 SNS Standard 토픽으로 교체하면 워커가 직접 메시지를 폴링·백오프하면서 지연 시간을 0으로 만든다."},
            {"label": "E", "text": "VisibilityTimeout을 1초로 줄이면 모든 메시지가 중복 처리 없이 즉시 완료된다."}
        ],
        ["A", "B"],
        "A, B) SQS Long Polling(WaitTimeSeconds=20) + 배치 수신으로 빈 폴링 제거 / Metric Math `BacklogPerInstance` 오토 스케일링 + `ApproximateAgeOfOldestMessage` 지연 감시",
        "SQS Long Polling, WaitTimeSeconds 20, BacklogPerInstance, Metric Math, ApproximateAgeOfOldestMessage",
        (
            "• 정답(A, B):\n"
            "  - A: **SQS Long Polling (`WaitTimeSeconds=20`)** 은 큐가 비어 있을 때 최대 20초간 연결을 대기했다가 메시지가 도착하는 즉시 반환하므로 빈 응답(`EmptyReceive`) API 요금과 워커 CPU 낭비를 극적으로 줄여줍니다.\n"
            "  - B: AWS 공식 권장 SQS 기반 ASG 스케일링 지표는 단순 총 메시지 수가 아닌 **인스턴스당 적체량(`BacklogPerInstance = ApproximateNumberOfMessagesVisible / GroupInServiceInstances`)** 입니다(CloudWatch Metric Math로 산출). 또한 `ApproximateAgeOfOldestMessage` 지표로 워커 정지나 처리 지연을 조기 경보할 수 있습니다.\n"
            "• 오답 분석:\n"
            "  - C: `WaitTimeSeconds=0` 이 바로 비용 낭비를 일으키는 Short Polling입니다.\n"
            "  - D: SNS는 Push 방식이지 SQS 같은 풀링 큐 버퍼링·재시도 보관소가 아닙니다.\n"
            "  - E: VisibilityTimeout을 1초로 줄이면 1초 이상 걸리는 작업마다 다른 워커가 동일 메시지를 중복 수신하는 장애가 발생합니다."
        ),
        "SQS 운영 모범 사례: 비용 절감 = **Long Polling (`WaitTimeSeconds=20`) + Batch(10건)**, 오토 스케일링 = **Metric Math `BacklogPerInstance`**, 지연 경보 = **`ApproximateAgeOfOldestMessage`**!"
    ),
    (
        6, 16, 4, 2, 3,
        "SAP-C02 공식 Exam Guide 아키텍처 시나리오",
        "Professional",
        "[Domain 4 · 종합] 글로벌 엔터프라이즈 웹 포털의 무중단 DNS & TLS 컷오버 전략 (F5 -> CloudFront + ALB)",
        (
            "글로벌 커머스 기업이 온프레미스 F5 BIG-IP 로드밸런서에서 운영하던 핵심 웹 포털(`www.globalshop.com`)을 AWS의 **CloudFront + ALB + ECS Fargate** 신규 스택으로 "
            "전 세계 사용자 접속 중단이나 TLS 인증서 경고를 전혀 유발하지 않고 안전하게 전환(Cutover)하려 합니다.\n\n"
            "사전 준비부터 점진적 트래픽 전환, 즉각적 롤백 대비까지 무중단 컷오버를 보장하기 위해 반드시 수행해야 할 3가지 조치 조합은 무엇입니까? (Select THREE.)"
        ),
        "Global DNS & TLS Cutover:\nLegacy: On-prem F5 BIG-IP (`www.globalshop.com`)\nTarget: CloudFront + ALB + ECS Fargate\nMust ensure zero TLS errors, fast rollback, and progressive verification",
        [
            {"label": "A", "text": "컷오버 최소 48시간 전에 기존 DNS 레코드의 TTL(Time to Live)을 60초(또는 300초 이하)로 사전에 낮춰 전 세계 DNS 리졸버 캐시가 만료되도록 준비한다."},
            {"label": "B", "text": "Route 53 컷오버 전에 AWS Certificate Manager(ACM, CloudFront용 `us-east-1` 및 ALB용 대상 리전)에서 `www.globalshop.com` TLS 인증서를 DNS 검증(CNAME)으로 미리 발급·바인딩 완료한다."},
            {"label": "C", "text": "Amazon Route 53 Weighted Routing 정책으로 가중치를 점진적으로 이동(예: 온프레미스 90% / CloudFront 10% -> 50/50 -> 0/100)하며 오류율 모니터링 후 문제 시 즉시 100% 온프레미스로 롤백할 수 있게 구성한다."},
            {"label": "D", "text": "컷오버 직전 기존 F5 서버 전원을 먼저 끄고 나서 CloudFront용 ACM 인증서 이메일 승인을 요청한다."},
            {"label": "E", "text": "DNS 레코드 TTL을 86,400초(24시간)로 상향 고정해야 장애 시 전 세계 사용자가 1분 내에 온프레미스로 롤백된다."},
            {"label": "F", "text": "CloudFront에 별도의 Alternate Domain Name(CNAME) 설정 없이 기본 `*.cloudfront.net` 도메인으로 접속해도 기존 `www.globalshop.com` TLS 핸드셰이크가 자동 통과된다."}
        ],
        ["A", "B", "C"],
        "A, B, C) 48시간 전 DNS TTL 사전 단축(60초) / 컷오버 전 us-east-1(CloudFront) 및 리전(ALB) ACM 인증서 DNS 검증 사전 발급 / Route 53 Weighted Routing 점진적 전환 및 즉각 롤백 준비",
        "Zero-Downtime DNS Cutover, Route 53 Weighted Routing, DNS TTL Lowering, ACM us-east-1 CloudFront, Alternate Domain Name",
        (
            "• 정답(A, B, C):\n"
            "  - A: 기존 TTL(예: 24~48시간)을 유지한 채 전환하면 캐시된 사용자들이 구 F5와 신규 CloudFront 사이에서 며칠간 분산·롤백 지연을 겪습니다. 반드시 기존 TTL 만료 시간보다 충분히 앞선 시점에 **TTL을 60초 등 짧은 값으로 사전 단축** 해야 합니다.\n"
            "  - B: **CloudFront용 ACM 인증서는 반드시 `us-east-1` 리전** 에 발급해야 하며, DNS 전환 **이전에** DNS CNAME 검증을 통해 미리 발급·연결해 두어야 전환 순간 TLS 인증서 경고 다운타임이 0초가 됩니다.\n"
            "  - C: **Route 53 Weighted Routing** (예: 10% -> 50% -> 100%)은 카나리 전환 검증과 이상 징후 발견 시 60초 내 즉각 롤백을 가능하게 합니다.\n"
            "• 오답 분석:\n"
            "  - D: F5를 먼저 내리면 ACM 발급 전까지 전면 서비스 장애가 발생합니다.\n"
            "  - E: TTL을 86,400초로 늘리면 롤백 전파가 최대 24시간 지연됩니다.\n"
            "  - F: CloudFront에 Alternate Domain Name(`www.globalshop.com`)과 해당 ACM 인증서를 등록하지 않으면 TLS SNI 불일치로 403/인증서 오류가 발생합니다."
        ),
        "DNS 컷오버 3대 철칙: 1) **사전 TTL 단축(60s)**, 2) **컷오버 전 ACM(`us-east-1` for CloudFront) DNS 검증 발급**, 3) **Weighted Routing 카나리 점진 전환**!"
    ),
]
