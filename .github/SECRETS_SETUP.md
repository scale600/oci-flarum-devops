# GitHub Secrets 설정 가이드

이 문서는 GitHub Actions CI/CD 파이프라인이 정상적으로 작동하기 위해 필요한 GitHub Secrets 설정 방법을 설명합니다.

## 🔐 필요한 Secrets

### 1. OCI (Oracle Cloud Infrastructure) 인증 정보

#### `OCI_TENANCY_OCID`
- **설명**: OCI Tenancy OCID
- **형식**: `ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **설정 방법**:
  1. OCI 콘솔 → Identity & Security → Tenancy Details
  2. Tenancy OCID 복사

#### `OCI_USER_OCID`
- **설명**: OCI User OCID
- **형식**: `ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **설정 방법**:
  1. OCI 콘솔 → Identity & Security → Users
  2. 사용자 선택 → User OCID 복사

#### `OCI_FINGERPRINT`
- **설명**: API Key Fingerprint
- **형식**: `xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx`
- **설정 방법**:
  1. OCI 콘솔 → Identity & Security → Users
  2. API Keys → Add API Key
  3. Generate API Key Pair → Download Private Key
  4. Fingerprint 복사

#### `OCI_PRIVATE_KEY`
- **설명**: API Key Private Key (PEM 형식)
- **형식**: 
  ```
  -----BEGIN PRIVATE KEY-----
  MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
  -----END PRIVATE KEY-----
  ```
- **설정 방법**:
  1. API Key 생성 시 다운로드한 `.pem` 파일 내용 전체 복사

#### `OCI_REGION`
- **설명**: OCI Region
- **예시**: `ap-seoul-1`, `us-ashburn-1`
- **설정 방법**:
  1. OCI 콘솔 우상단 지역 선택
  2. Region Identifier 복사

#### `OCI_COMPARTMENT_OCID`
- **설명**: Compartment OCID
- **형식**: `ocid1.compartment.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **설정 방법**:
  1. OCI 콘솔 → Identity & Security → Compartments
  2. Compartment 선택 → OCID 복사

### 2. SSH 키 정보

#### `SSH_PUBLIC_KEY`
- **설명**: SSH 공개키
- **형식**: `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@hostname`
- **생성 방법**:
  ```bash
  ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
  cat ~/.ssh/id_rsa.pub
  ```

#### `SSH_PRIVATE_KEY`
- **설명**: SSH 개인키
- **형식**: 
  ```
  -----BEGIN OPENSSH PRIVATE KEY-----
  b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn...
  -----END OPENSSH PRIVATE KEY-----
  ```
- **생성 방법**:
  ```bash
  cat ~/.ssh/id_rsa
  ```

### 3. 데이터베이스 설정

#### `MYSQL_ROOT_PASSWORD`
- **설명**: MySQL root 사용자 비밀번호
- **형식**: 강력한 비밀번호 (최소 12자, 특수문자 포함)
- **예시**: `MySecureRootPass123!`

#### `MYSQL_PASSWORD`
- **설명**: Flarum 데이터베이스 사용자 비밀번호
- **형식**: 강력한 비밀번호 (최소 12자, 특수문자 포함)
- **예시**: `FlarumSecurePass456!`

### 4. Flarum 관리자 설정

#### `FLARUM_ADMIN_EMAIL`
- **설명**: Flarum 관리자 이메일
- **형식**: 유효한 이메일 주소
- **예시**: `admin@riderwin.com`

#### `FLARUM_ADMIN_PASSWORD`
- **설명**: Flarum 관리자 비밀번호
- **형식**: 강력한 비밀번호 (최소 12자, 특수문자 포함)
- **예시**: `AdminSecurePass789!`

### 5. 도메인 설정

#### `DOMAIN_NAME`
- **설명**: Flarum 사이트 도메인 (선택사항)
- **형식**: 유효한 도메인명
- **예시**: `community.riderwin.com`
- **참고**: 비워두면 IP 주소로 접속

### 6. 알림 설정 (선택사항)

#### `SLACK_WEBHOOK_URL`
- **설명**: Slack 웹훅 URL (배포 알림용)
- **형식**: `https://hooks.slack.com/services/[TEAM_ID]/[BOT_ID]/[TOKEN]` (예시)
- **설정 방법**:
  1. Slack → Apps → Incoming Webhooks
  2. Add to Slack → Webhook URL 복사

## 🛠️ GitHub Secrets 설정 방법

### 1. GitHub 저장소에서 Secrets 설정

1. **GitHub 저장소 접속**
   - `https://github.com/scale600/oci-flarum-devops`

2. **Settings 탭 클릭**
   - 저장소 상단 메뉴에서 Settings

3. **Secrets and variables → Actions 클릭**
   - 좌측 메뉴에서 Secrets and variables
   - Actions 선택

4. **New repository secret 클릭**
   - 각 Secret을 위의 정보에 따라 추가

### 2. 필수 Secrets 우선순위

#### 🔴 **최우선 (필수)**
1. `OCI_TENANCY_OCID`
2. `OCI_USER_OCID`
3. `OCI_FINGERPRINT`
4. `OCI_PRIVATE_KEY`
5. `OCI_REGION`
6. `OCI_COMPARTMENT_OCID`

#### 🟡 **중요 (권장)**
7. `SSH_PUBLIC_KEY`
8. `SSH_PRIVATE_KEY`
9. `MYSQL_ROOT_PASSWORD`
10. `MYSQL_PASSWORD`
11. `FLARUM_ADMIN_EMAIL`
12. `FLARUM_ADMIN_PASSWORD`

#### 🟢 **선택사항**
13. `DOMAIN_NAME`
14. `SLACK_WEBHOOK_URL`

## ✅ Secrets 설정 확인

### 1. 설정 완료 확인
```bash
# GitHub CLI로 확인 (선택사항)
gh secret list
```

### 2. 워크플로우 테스트
1. **Terraform 배포 테스트**
   - `terraform/` 디렉토리에 변경사항 푸시
   - Actions 탭에서 `Terraform Infrastructure Deployment` 실행 확인

2. **Ansible 배포 테스트**
   - `ansible/` 디렉토리에 변경사항 푸시
   - Actions 탭에서 `Ansible Configuration Deployment` 실행 확인

3. **Docker 빌드 테스트**
   - `docker/` 디렉토리에 변경사항 푸시
   - Actions 탭에서 `Docker Build and Deploy` 실행 확인

## 🔒 보안 주의사항

1. **Secrets 노출 방지**
   - Secrets는 절대 코드에 하드코딩하지 마세요
   - 로그에 Secrets가 출력되지 않도록 주의하세요

2. **정기적인 Secrets 갱신**
   - API 키는 3-6개월마다 갱신 권장
   - 비밀번호는 6-12개월마다 변경 권장

3. **접근 권한 관리**
   - 필요한 사용자에게만 Secrets 접근 권한 부여
   - 불필요한 Secrets는 삭제

## 🆘 문제 해결

### 1. OCI 인증 오류
```
Error: Authentication failed
```
**해결방법**:
- OCI 인증 정보가 정확한지 확인
- API Key가 활성화되어 있는지 확인
- Region이 올바른지 확인

### 2. SSH 연결 오류
```
Error: Permission denied (publickey)
```
**해결방법**:
- SSH 키가 올바르게 설정되었는지 확인
- 공개키가 OCI 인스턴스에 등록되었는지 확인

### 3. 데이터베이스 연결 오류
```
Error: Access denied for user
```
**해결방법**:
- MySQL 비밀번호가 올바른지 확인
- 데이터베이스 사용자 권한 확인

## 📞 지원

문제가 지속되면 다음을 확인하세요:
1. GitHub Actions 로그 확인
2. OCI 콘솔에서 리소스 상태 확인
3. SSH 연결 테스트
4. 데이터베이스 연결 테스트
