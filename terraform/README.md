# Terraform Infrastructure for Flarum Community

This directory contains Terraform infrastructure code for deploying a Flarum community site on OCI Always Free Tier.

## 🏗️ Architecture

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

## 📁 File Structure

- `main.tf` - Main infrastructure resource definitions
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output value definitions
- `terraform.tfvars.example` - Variable value example file
- `user_data.sh` - Flarum web server initialization script
- `mysql_user_data.sh` - MySQL database initialization script

## 🚀 Usage

### 1. Prerequisites

1. **OCI Account Setup**
   - Create and login to OCI account
   - Generate and download API key
   - Create Compartment

2. **SSH Key Generation**
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
   ```

### 2. Variable Configuration

```bash
# Copy terraform.tfvars.example and modify with actual values
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars file with actual values
vim terraform.tfvars
```

### 3. Terraform Execution

```bash
# Initialize Terraform
terraform init

# Check execution plan
terraform plan

# Deploy infrastructure
terraform apply

# Verify deployment
terraform output
```

### 4. Access and Configuration

1. **Access Flarum**
   ```bash
   # Access using the output URL
   http://<flarum_public_ip>
   ```

2. **SSH Access**
   ```bash
   ssh opc@<flarum_public_ip>
   ```

## 🔧 Key Resources

### Compute Instances
- **Flarum Web Server**: VM.Standard.A1.Flex (2 OCPU, 12GB RAM)
- **MySQL Database**: VM.Standard.A1.Flex (1 OCPU, 6GB RAM)

### Network
- **VCN**: 10.0.0.0/16
- **Public Subnet**: 10.0.1.0/24 (Flarum web server)
- **Private Subnet**: 10.0.2.0/24 (MySQL database)

### Security
- **Security Lists**: HTTP(80), HTTPS(443), SSH(22), MySQL(3306)
- **Route Tables**: Internet gateway connection

## 🔐 Security Considerations

1. **Network Isolation**: Web server in public subnet, database in private subnet
2. **Firewall**: Only necessary ports open
3. **SSL/TLS**: Automatic Let's Encrypt certificate setup
4. **Database Security**: Access only from private network

## 📊 Cost

- **Free** using Always Free Tier
- 2 VM.Standard.A1.Flex instances (total 3 OCPU, 18GB RAM)
- Network resources including VCN, subnets, internet gateway

## 🛠️ Management Commands

```bash
# Check infrastructure status
terraform show

# Recreate specific resource only
terraform apply -replace=oci_core_instance.flarum_instance

# Delete infrastructure
terraform destroy

# Check output values
terraform output flarum_url
```

## 🔍 Troubleshooting

1. **Cannot access instance**
   - Verify SSH key is set correctly
   - Check security group allows SSH port (22)

2. **Cannot access Flarum**
   - Verify web server started normally
   - Check firewall settings

3. **Database connection error**
   - Check MySQL service status
   - Verify network connection

## 📝 Additional Configuration

### SSL Certificate Setup
```bash
# Issue SSL certificate after domain setup
ssh opc@<flarum_public_ip>
sudo /home/opc/setup-ssl.sh
```

### Install Flarum Extensions
```bash
# After SSH connection
cd /home/opc/flarum
docker-compose exec flarum extension:install <extension-name>
```