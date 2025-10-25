# OCI Flarum DevOps

A production-ready DevOps project for deploying a Flarum community forum on Oracle Cloud Infrastructure (OCI) Always Free Tier using modern DevOps practices including Terraform, Ansible, Docker, and GitHub Actions CI/CD.

## 🎯 Project Overview

This project demonstrates a complete DevOps pipeline for deploying a scalable Flarum community forum with the following characteristics:

- **Infrastructure as Code (IaC)** with Terraform
- **Configuration Management** with Ansible
- **Containerization** with Docker
- **CI/CD Pipeline** with GitHub Actions
- **Security Best Practices** with network isolation
- **Cost Optimization** using OCI Always Free Tier
- **Production-Ready** with monitoring and health checks

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    OCI Always Free Tier                     │
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

### Key Components

- **Web Server**: Flarum forum application with Docker
- **Database**: MySQL 8.0 with optimized configuration
- **Load Balancer**: Nginx reverse proxy with SSL termination
- **Monitoring**: Health checks and automated alerts
- **Security**: Network isolation and firewall rules

## 🚀 Quick Start

### Prerequisites

1. **OCI Account**: Oracle Cloud Infrastructure account with Always Free Tier access
2. **GitHub Account**: For CI/CD pipeline and container registry
3. **Domain Name** (Optional): For SSL certificate and custom domain

### 1. Clone Repository

```bash
git clone https://github.com/scale600/oci-flarum-devops.git
cd oci-flarum-devops
```

### 2. Configure GitHub Secrets

Navigate to your GitHub repository → Settings → Secrets and variables → Actions, and add the following secrets:

#### Required Secrets

| Secret Name             | Description           | Example                                  |
| ----------------------- | --------------------- | ---------------------------------------- |
| `OCI_TENANCY_OCID`      | OCI Tenancy OCID      | `ocid1.tenancy.oc1..xxxxx`               |
| `OCI_USER_OCID`         | OCI User OCID         | `ocid1.user.oc1..xxxxx`                  |
| `OCI_FINGERPRINT`       | API Key Fingerprint   | `xx:xx:xx:xx:xx:xx:xx:xx`                |
| `OCI_PRIVATE_KEY`       | API Key Private Key   | `-----BEGIN PRIVATE KEY-----...`         |
| `OCI_REGION`            | OCI Region            | `ap-seoul-1`                             |
| `OCI_COMPARTMENT_OCID`  | Compartment OCID      | `ocid1.compartment.oc1..xxxxx`           |
| `SSH_PUBLIC_KEY`        | SSH Public Key        | `ssh-rsa AAAAB3NzaC1yc2E...`             |
| `SSH_PRIVATE_KEY`       | SSH Private Key       | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `MYSQL_ROOT_PASSWORD`   | MySQL root password   | `SecureRootPass123!`                     |
| `MYSQL_PASSWORD`        | MySQL user password   | `SecureUserPass456!`                     |

#### Optional Secrets

| Secret Name         | Description         | Example                                |
| ------------------- | ------------------- | -------------------------------------- |
| `SLACK_WEBHOOK_URL` | Slack notifications | `https://hooks.slack.com/services/...` |

### 3. Deploy Infrastructure

The deployment is fully automated through GitHub Actions. Simply push to the main branch:

```bash
git add .
git commit -m "Deploy Flarum community forum"
git push origin main
```

### 4. Access Your Forum

After deployment (5-10 minutes), access your forum at:

- **URL**: `http://<your-server-ip>`
- **SSH**: `ssh opc@<your-server-ip>`

## 📋 Detailed Setup Guide

### Step 1: OCI Account Setup

1. **Create OCI Account**

   - Visit [Oracle Cloud Infrastructure](https://cloud.oracle.com)
   - Sign up for Always Free Tier account
   - Verify your account (may take 24-48 hours)

2. **Generate API Keys**

   ```bash
   # Generate SSH key pair
   ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

   # Generate OCI API key
   # Go to OCI Console → Identity & Security → Users → API Keys
   # Click "Add API Key" → "Generate API Key Pair"
   # Download the private key file
   ```

3. **Create Compartment**
   - OCI Console → Identity & Security → Compartments
   - Click "Create Compartment"
   - Name: `flarum-production`
   - Copy the OCID

### Step 2: GitHub Repository Setup

1. **Fork Repository**

   - Fork this repository to your GitHub account
   - Clone your fork locally

2. **Configure Secrets**

   - Go to your repository → Settings → Secrets and variables → Actions
   - Add all required secrets as listed above

3. **Enable GitHub Actions**
   - Go to Actions tab in your repository
   - Enable GitHub Actions if prompted

### Step 3: Customize Configuration

#### Terraform Variables

Edit `terraform/terraform.tfvars`:

```hcl
# OCI Configuration
tenancy_ocid     = "ocid1.tenancy.oc1..xxxxx"
user_ocid        = "ocid1.user.oc1..xxxxx"
fingerprint      = "xx:xx:xx:xx:xx:xx:xx:xx"
private_key_path = "~/.oci/oci_api_key.pem"
region          = "ap-seoul-1"
compartment_id  = "ocid1.compartment.oc1..xxxxx"

# SSH Configuration
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E... your-email@example.com"

# Database Configuration
mysql_root_password = "YourSecureRootPassword123!"
mysql_database   = "flarum"
mysql_user       = "flarum"
mysql_password   = "YourSecureUserPassword456!"

```

#### Ansible Configuration

Edit `ansible/playbook.yml` to customize:

- Flarum extensions
- SSL certificate settings
- Monitoring configuration
- Backup settings

### Step 4: Deploy and Monitor

1. **Trigger Deployment**

   ```bash
   git add .
   git commit -m "Initial deployment"
   git push origin main
   ```

2. **Monitor Deployment**

   - Go to Actions tab in GitHub
   - Watch the deployment progress
   - Check logs for any issues

3. **Verify Deployment**
   - Access your forum URL
   - Complete Flarum setup wizard
   - Test all functionality

## 🔧 Configuration Options

### Flarum Extensions

The project includes essential Flarum extensions:

- **SEO**: Search engine optimization
- **Markdown**: Enhanced text formatting
- **Tags**: Topic categorization
- **Sticky**: Pinned discussions
- **Subscriptions**: Email notifications
- **Mentions**: User mentions
- **Approval**: Post moderation
- **Suspend**: User management
- **Lock**: Discussion locking

### SSL Certificate

Automatic SSL certificate setup with Let's Encrypt:

```bash
# Manual SSL setup (if needed)
ssh opc@<your-server-ip>
sudo /home/opc/setup-ssl.sh
```

### Database Optimization

MySQL is configured with production-ready settings:

- **Buffer Pool**: 256MB
- **Log File Size**: 64MB
- **Connection Pool**: 100 connections
- **InnoDB Optimization**: Enabled

### Monitoring and Health Checks

- **Health Endpoints**: `/health` for application status
- **Docker Health Checks**: Container-level monitoring
- **System Monitoring**: CPU, memory, disk usage
- **Database Monitoring**: Connection and query performance

## 🛠️ Management Commands

### Infrastructure Management

```bash
# Check infrastructure status
cd terraform
terraform show

# Update infrastructure
terraform plan
terraform apply

# Destroy infrastructure
terraform destroy
```

### Application Management

```bash
# SSH to server
ssh opc@<your-server-ip>

# Check application status
cd /opt/flarum
docker-compose ps

# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Update application
docker-compose pull
docker-compose up -d
```

### Database Management

```bash
# Connect to MySQL
mysql -u flarum -p -h localhost flarum

# Backup database
mysqldump -u flarum -p flarum > backup.sql

# Restore database
mysql -u flarum -p flarum < backup.sql
```

## 🔒 Security Features

### Network Security

- **Public/Private Subnet Separation**: Web server in public, database in private
- **Security Lists**: Restrictive firewall rules
- **SSH Key Authentication**: No password authentication
- **SSL/TLS Encryption**: Automatic HTTPS setup

### Application Security

- **Container Isolation**: Docker containers for isolation
- **Database Security**: Private network access only
- **Regular Updates**: Automated security updates
- **Vulnerability Scanning**: Trivy security scans

### Access Control

- **Admin Authentication**: Secure admin account setup
- **User Permissions**: Flarum's built-in permission system
- **API Security**: Secure API endpoints
- **Session Management**: Secure session handling

## 📊 Monitoring and Logging

### Application Monitoring

- **Health Checks**: Automated health monitoring
- **Performance Metrics**: CPU, memory, disk usage
- **Error Tracking**: Application error logging
- **Uptime Monitoring**: Service availability tracking

### Log Management

- **Application Logs**: Flarum application logs
- **System Logs**: OS-level logging
- **Database Logs**: MySQL query and error logs
- **Access Logs**: Web server access logs

### Alerting

- **Slack Notifications**: Deployment status alerts
- **Email Alerts**: Critical system alerts
- **Health Check Alerts**: Service down notifications
- **Security Alerts**: Suspicious activity detection

## 🚨 Troubleshooting

### Common Issues

#### 1. Deployment Failures

**Problem**: GitHub Actions workflow fails
**Solution**:

- Check GitHub Secrets are correctly set
- Verify OCI credentials are valid
- Check OCI region and compartment settings

#### 2. Application Not Accessible

**Problem**: Cannot access Flarum forum
**Solution**:

- Check security group rules
- Verify firewall settings
- Check Docker container status

#### 3. Database Connection Issues

**Problem**: Flarum cannot connect to database
**Solution**:

- Verify MySQL service is running
- Check database credentials
- Verify network connectivity

#### 4. SSL Certificate Issues

**Problem**: SSL certificate not working
**Solution**:

- Check domain DNS settings
- Verify Let's Encrypt configuration
- Check certificate expiration

### Debug Commands

```bash
# Check system status
systemctl status docker
systemctl status firewalld

# Check application logs
docker-compose logs flarum
docker-compose logs mysql

# Check network connectivity
ping <database-ip>
telnet <database-ip> 3306

# Check SSL certificate
openssl s_client -connect <your-domain>:443
```

## 📈 Performance Optimization

### Database Optimization

- **Query Optimization**: Indexed database tables
- **Connection Pooling**: Optimized connection management
- **Caching**: Redis caching for better performance
- **Backup Strategy**: Automated daily backups

### Application Optimization

- **CDN Integration**: Static asset delivery
- **Image Optimization**: Compressed images
- **Caching**: Application-level caching
- **Load Balancing**: Multiple server instances

### Infrastructure Optimization

- **Resource Monitoring**: CPU and memory usage
- **Auto-scaling**: Dynamic resource allocation
- **Cost Optimization**: Always Free Tier limits
- **Performance Tuning**: System-level optimizations

## 🔄 Backup and Recovery

### Automated Backups

- **Database Backups**: Daily MySQL dumps
- **Application Backups**: Docker volume backups
- **Configuration Backups**: Terraform state backups
- **SSL Certificate Backups**: Certificate storage

### Recovery Procedures

- **Point-in-time Recovery**: Database restoration
- **Disaster Recovery**: Complete system restoration
- **Configuration Recovery**: Infrastructure restoration
- **Data Migration**: Cross-environment data transfer

## 📚 Additional Resources

### Documentation

- [Terraform Documentation](https://terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com)
- [Docker Documentation](https://docs.docker.com)
- [Flarum Documentation](https://docs.flarum.org)

### Community Support

- [Flarum Community](https://discuss.flarum.org)
- [GitHub Issues](https://github.com/scale600/oci-flarum-devops/issues)
- [OCI Documentation](https://docs.oracle.com/en-us/iaas/)

### Learning Resources

- [DevOps Best Practices](https://docs.github.com/en/actions)
- [Cloud Security](https://docs.oracle.com/en-us/iaas/security/)
- [Container Security](https://docs.docker.com/engine/security/)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Code Standards

- **Terraform**: Follow HashiCorp best practices
- **Ansible**: Use idempotent playbooks
- **Docker**: Multi-stage builds for optimization
- **GitHub Actions**: Clear, documented workflows

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flarum Team**: For the excellent forum software
- **Oracle Cloud**: For the Always Free Tier
- **GitHub**: For the CI/CD platform
- **Open Source Community**: For the amazing tools and libraries
<<<<<<< HEAD

---

**Ready to deploy your Flarum community forum?** 🚀

Start by setting up your GitHub Secrets and pushing to the main branch. The entire infrastructure will be deployed automatically!
# Trigger deployment
# Retry deployment with updated compartment OCID
# 재배포 트리거 - Fri Oct 24 15:36:11 PDT 2025
# 재배포 시작 - Fri Oct 24 15:56:43 PDT 2025
# 재배포 시작 - Fri Oct 24 18:09:39 PDT 2025
# SSH 키 추가 후 재배포 - Fri Oct 24 18:53:12 PDT 2025
=======
>>>>>>> 1606bdd75f8f4b931d18fa380fe509e03dba3073
# Arm 기반 배포 시작 - Fri Oct 24 21:04:22 PDT 2025
# US West (San Jose) 리전으로 변경 - Fri Oct 24 21:09:23 PDT 2025
