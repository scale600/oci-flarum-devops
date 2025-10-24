# Terraform Infrastructure for Flarum Community

이 디렉토리는 OCI Always Free Tier에 Flarum 커뮤니티 사이트를 배포하기 위한 Terraform 인프라 코드를 포함합니다.

## 🏗️ 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                        OCI Always Free Tier                │
│                                                             │
│  ┌─────────────────┐    ┌─────────────────────────────────┐  │
│  │   Public Subnet │    │      Private Subnet            │  │
│  │                 │    │                                 │  │
│  │  ┌─────────────┐│    │  ┌─────────────────────────┐  │  │
│  │  │ Flarum Web  ││    │  │    MySQL Database       │  │  │
│  │  │   Server    ││◄───┤  │      Server              │  │  │
│  │  │ (2 OCPU)    ││    │  │    (1 OCPU)             │  │  │
│  │  │ 12GB RAM    ││    │  │    6GB RAM               │  │  │
│  │  └─────────────┘│    │  └─────────────────────────┘  │  │
│  └─────────────────┘    └─────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 📁 파일 구조

- `main.tf` - 메인 인프라 리소스 정의
- `variables.tf` - 입력 변수 정의
- `outputs.tf` - 출력 값 정의
- `terraform.tfvars.example` - 변수 값 예시 파일
- `user_data.sh` - Flarum 웹서버 초기화 스크립트
- `mysql_user_data.sh` - MySQL 데이터베이스 초기화 스크립트

## 🚀 사용 방법

### 1. 사전 준비

1. **OCI 계정 설정**

   - OCI 계정 생성 및 로그인
   - API 키 생성 및 다운로드
   - Compartment 생성

2. **SSH 키 생성**
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
   ```

### 2. 변수 설정

```bash
# terraform.tfvars.example을 복사하여 실제 값으로 수정
cp terraform.tfvars.example terraform.tfvars

# terraform.tfvars 파일을 편집하여 실제 값 입력
vim terraform.tfvars
```

### 3. Terraform 실행

```bash
# Terraform 초기화
terraform init

# 실행 계획 확인
terraform plan

# 인프라 배포
terraform apply

# 배포 확인
terraform output
```

### 4. 접속 및 설정

1. **Flarum 접속**

   ```bash
   # 출력된 URL로 접속
   http://<flarum_public_ip>
   ```

2. **SSH 접속**
   ```bash
   ssh opc@<flarum_public_ip>
   ```

## 🔧 주요 리소스

### Compute Instances

- **Flarum Web Server**: VM.Standard.A1.Flex (2 OCPU, 12GB RAM)
- **MySQL Database**: VM.Standard.A1.Flex (1 OCPU, 6GB RAM)

### Network

- **VCN**: 10.0.0.0/16
- **Public Subnet**: 10.0.1.0/24 (Flarum 웹서버)
- **Private Subnet**: 10.0.2.0/24 (MySQL 데이터베이스)

### Security

- **Security Lists**: HTTP(80), HTTPS(443), SSH(22), MySQL(3306)
- **Route Tables**: 인터넷 게이트웨이 연결

## 🔐 보안 고려사항

1. **네트워크 분리**: 웹서버는 공용 서브넷, 데이터베이스는 프라이빗 서브넷
2. **방화벽**: 필요한 포트만 개방
3. **SSL/TLS**: Let's Encrypt 인증서 자동 설정
4. **데이터베이스 보안**: 프라이빗 네트워크에서만 접근 가능

## 📊 비용

- **Always Free Tier** 사용으로 **무료**
- VM.Standard.A1.Flex 인스턴스 2개 (총 3 OCPU, 18GB RAM)
- VCN, 서브넷, 인터넷 게이트웨이 등 네트워크 리소스

## 🛠️ 관리 명령어

```bash
# 인프라 상태 확인
terraform show

# 특정 리소스만 재생성
terraform apply -replace=oci_core_instance.flarum_instance

# 인프라 삭제
terraform destroy

# 출력 값 확인
terraform output flarum_url
```

## 🔍 문제 해결

1. **인스턴스 접속 불가**

   - SSH 키가 올바르게 설정되었는지 확인
   - 보안 그룹에서 SSH 포트(22) 허용 확인

2. **Flarum 접속 불가**

   - 웹서버가 정상적으로 시작되었는지 확인
   - 방화벽 설정 확인

3. **데이터베이스 연결 오류**
   - MySQL 서비스 상태 확인
   - 네트워크 연결 확인

## 📝 추가 설정

### SSL 인증서 설정

```bash
# 도메인 설정 후 SSL 인증서 발급
ssh opc@<flarum_public_ip>
sudo /home/opc/setup-ssl.sh
```

### Flarum 확장 프로그램 설치

```bash
# SSH로 접속 후
cd /home/opc/flarum
docker-compose exec flarum extension:install <extension-name>
```
