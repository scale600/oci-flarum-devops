# GitHub Secrets Setup Guide

This document explains how to set up the GitHub Secrets required for the GitHub Actions CI/CD pipeline to work properly.

## 🔐 Required Secrets

### 1. OCI (Oracle Cloud Infrastructure) Authentication Information

#### `OCI_TENANCY_OCID`
- **Description**: OCI Tenancy OCID
- **Format**: `ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **Setup Method**:
  1. OCI Console → Identity & Security → Tenancy Details
  2. Copy Tenancy OCID

#### `OCI_USER_OCID`
- **Description**: OCI User OCID
- **Format**: `ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **Setup Method**:
  1. OCI Console → Identity & Security → Users
  2. Select user → Copy User OCID

#### `OCI_FINGERPRINT`
- **Description**: API Key Fingerprint
- **Format**: `xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx`
- **Setup Method**:
  1. OCI Console → Identity & Security → Users
  2. API Keys → Add API Key
  3. Generate API Key Pair → Download Private Key
  4. Copy Fingerprint

#### `OCI_PRIVATE_KEY`
- **Description**: API Key Private Key (PEM format)
- **Format**: 
  ```
  -----BEGIN PRIVATE KEY-----
  MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
  -----END PRIVATE KEY-----
  ```
- **Setup Method**:
  1. Copy entire content of `.pem` file downloaded when creating API Key

#### `OCI_REGION`
- **Description**: OCI Region
- **Example**: `ap-seoul-1`, `us-ashburn-1`
- **Setup Method**:
  1. Select region from top-right corner of OCI Console
  2. Copy Region Identifier

#### `OCI_COMPARTMENT_OCID`
- **Description**: Compartment OCID
- **Format**: `ocid1.compartment.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **Setup Method**:
  1. OCI Console → Identity & Security → Compartments
  2. Select Compartment → Copy OCID

### 2. SSH Key Information

#### `SSH_PUBLIC_KEY`
- **Description**: SSH Public Key
- **Format**: `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@hostname`
- **Generation Method**:
  ```bash
  ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
  cat ~/.ssh/id_rsa.pub
  ```

#### `SSH_PRIVATE_KEY`
- **Description**: SSH Private Key
- **Format**: 
  ```
  -----BEGIN OPENSSH PRIVATE KEY-----
  b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn...
  -----END OPENSSH PRIVATE KEY-----
  ```
- **Generation Method**:
  ```bash
  cat ~/.ssh/id_rsa
  ```

### 3. Database Configuration

#### `MYSQL_ROOT_PASSWORD`
- **Description**: MySQL root user password
- **Format**: Strong password (minimum 12 characters, including special characters)
- **Example**: `MySecureRootPass123!`

#### `MYSQL_PASSWORD`
- **Description**: Flarum database user password
- **Format**: Strong password (minimum 12 characters, including special characters)
- **Example**: `FlarumSecurePass456!`

### 4. Flarum Administrator Configuration

#### `FLARUM_ADMIN_EMAIL`
- **Description**: Flarum administrator email
- **Format**: Valid email address
- **Example**: `admin@riderwin.com`

#### `FLARUM_ADMIN_PASSWORD`
- **Description**: Flarum administrator password
- **Format**: Strong password (minimum 12 characters, including special characters)
- **Example**: `AdminSecurePass789!`

### 5. Domain Configuration

#### `DOMAIN_NAME`
- **Description**: Flarum site domain (optional)
- **Format**: Valid domain name
- **Example**: `community.riderwin.com`
- **Note**: Leave empty to access via IP address

### 6. Notification Configuration (Optional)

#### `SLACK_WEBHOOK_URL`
- **Description**: Slack webhook URL (for deployment notifications)
- **Format**: `https://hooks.slack.com/services/[TEAM_ID]/[BOT_ID]/[TOKEN]` (example)
- **Setup Method**:
  1. Slack → Apps → Incoming Webhooks
  2. Add to Slack → Copy Webhook URL

## 🛠️ GitHub Secrets Setup Method

### 1. Setting up Secrets in GitHub Repository

1. **Access GitHub Repository**
   - Go to `https://github.com/scale600/oci-flarum-devops`

2. **Click Settings Tab**
   - Click Settings from the repository top menu

3. **Click Secrets and variables → Actions**
   - From the left menu, select Secrets and variables
   - Select Actions

4. **Click New repository secret**
   - Add each Secret according to the information above

### 2. Required Secrets Priority

#### 🔴 **Highest Priority (Required)**
1. `OCI_TENANCY_OCID`
2. `OCI_USER_OCID`
3. `OCI_FINGERPRINT`
4. `OCI_PRIVATE_KEY`
5. `OCI_REGION`
6. `OCI_COMPARTMENT_OCID`

#### 🟡 **Important (Recommended)**
7. `SSH_PUBLIC_KEY`
8. `SSH_PRIVATE_KEY`
9. `MYSQL_ROOT_PASSWORD`
10. `MYSQL_PASSWORD`
11. `FLARUM_ADMIN_EMAIL`
12. `FLARUM_ADMIN_PASSWORD`

#### 🟢 **Optional**
13. `DOMAIN_NAME`
14. `SLACK_WEBHOOK_URL`

## ✅ Secrets Setup Verification

### 1. Setup Completion Check
```bash
# Check with GitHub CLI (optional)
gh secret list
```

### 2. Workflow Testing
1. **Terraform Deployment Test**
   - Push changes to `terraform/` directory
   - Check `Terraform Infrastructure Deployment` execution in Actions tab

2. **Ansible Deployment Test**
   - Push changes to `ansible/` directory
   - Check `Ansible Configuration Deployment` execution in Actions tab

3. **Docker Build Test**
   - Push changes to `docker/` directory
   - Check `Docker Build and Deploy` execution in Actions tab

## 🔒 Security Considerations

1. **Prevent Secrets Exposure**
   - Never hardcode secrets in code
   - Be careful not to output secrets in logs

2. **Regular Secrets Renewal**
   - Renew API keys every 3-6 months
   - Change passwords every 6-12 months

3. **Access Permission Management**
   - Grant secrets access only to necessary users
   - Delete unnecessary secrets

## 🆘 Troubleshooting

### 1. OCI Authentication Error
```
Error: Authentication failed
```
**Solution**:
- Verify OCI authentication information is correct
- Check if API Key is activated
- Verify region is correct

### 2. SSH Connection Error
```
Error: Permission denied (publickey)
```
**Solution**:
- Verify SSH keys are set correctly
- Check if public key is registered in OCI instance

### 3. Database Connection Error
```
Error: Access denied for user
```
**Solution**:
- Verify MySQL password is correct
- Check database user permissions

## 📞 Support

If problems persist, check the following:
1. GitHub Actions logs
2. OCI Console resource status
3. SSH connection test
4. Database connection test