# GitHub Secrets Setup Guide

This document explains how to set up the GitHub Secrets required for the GitHub Actions CI/CD pipeline to work properly.

## 🔐 Required Secrets

### 1. OCI (Oracle Cloud Infrastructure) Authentication Information

#### `OCI_TENANCY_OCID`

- **Description**: OCI Tenancy OCID
- **Format**: `ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **✅ Your Value**: `ocid1.tenancy.oc1..aaaaaaaav6qj3vtbhomujsttvjepog6q5mb7mcomvds4crpo5nzr7hakdupq`
- **Detailed Setup Method**:

  1. **Login to OCI Console**: Go to [cloud.oracle.com](https://cloud.oracle.com) and sign in
  2. **Navigate to Tenancy Details** (Multiple ways to find it):

     **Method 1 - Profile Menu**:

     - Click on your **profile icon** (top-right corner)
     - Select **"Tenancy: [Your Tenancy Name]"**
     - This will take you directly to Tenancy Details

     **Method 2 - Identity Menu**:

     - Click the hamburger menu (☰) in the top-left corner
     - Go to **Identity & Security** → **Domains** (or **Users**)
     - Look for **"Tenancy Details"** link in the left sidebar

     **Method 3 - Direct URL**:

     - Go directly to: `https://console.region.oraclecloud.com/identity/tenancy`
     - Replace `region` with your region (e.g., `ap-seoul-1`)

  3. **Copy Tenancy OCID**:
     - Look for "OCID" field in the Tenancy Information section
     - Click the "Copy" button next to the OCID
     - Format: `ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

#### `OCI_USER_OCID`

- **Description**: OCI User OCID
- **Format**: `ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **✅ Your Value**: `ocid1.user.oc1..aaaaaaaalszqhrun6tj3otseuteyu2ykgvbgyf3rlemfpbf4nbm646kvvmga`
- **Detailed Setup Method**:

  1. **Navigate to Users** (Multiple ways):

     **Method 1 - Identity Menu**:

     - Click the hamburger menu (☰) in the top-left corner
     - Go to **Identity & Security** → **Users**

     **Method 2 - Direct URL**:

     - Go directly to: `https://console.region.oraclecloud.com/identity/users`
     - Replace `region` with your region (e.g., `ap-seoul-1`)

  2. **Find Your User**:
     - Look for your username in the list (usually your email address)
     - Click on your username to open user details
  3. **Copy User OCID**:
     - In the User Information section, find the "OCID" field
     - Click the "Copy" button next to the OCID
     - Format: `ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

#### `OCI_FINGERPRINT`

- **Description**: API Key Fingerprint
- **Format**: `xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx`
- **✅ Your Value**: `9f:34:a6:0f:05:fb:5e:76:3e:43:e0:ae:5d:49:92:3d`
- **Detailed Setup Method**:

  1. **Navigate to API Keys** (Multiple ways):

     **Method 1 - From Users Page**:

     - Go to **Identity & Security** → **Users**
     - Click on your username
     - Scroll down to **API Keys** section

     **Method 2 - Direct URL**:

     - Go directly to: `https://console.region.oraclecloud.com/identity/users/[USER_OCID]/api-keys`
     - Replace `region` with your region and `[USER_OCID]` with your User OCID

  2. **Add API Key**:
     - Click **Add API Key** button
     - Select **Generate API Key Pair**
     - Click **Download Private Key** (save the .pem file)
     - Click **Add** to add the key
  3. **Copy Fingerprint**:
     - After adding the key, you'll see the fingerprint in the format: `xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx`
     - Copy this fingerprint value

#### `OCI_PRIVATE_KEY`

- **Description**: API Key Private Key (PEM format)
- **Format**:
  ```
  -----BEGIN PRIVATE KEY-----
  MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
  -----END PRIVATE KEY-----
  ```
- **Detailed Setup Method**:
  1. **Locate the Downloaded File**:
     - The .pem file was downloaded when you created the API Key
     - Usually saved in your Downloads folder as `oci_api_key.pem`
  2. **Open the File**:
     - Open the .pem file in a text editor (Notepad, VS Code, etc.)
  3. **Copy Entire Content**:
     - Select all content from `-----BEGIN PRIVATE KEY-----` to `-----END PRIVATE KEY-----`
     - Include the BEGIN and END lines
     - Copy the entire content (usually 3-4 lines)

#### `OCI_REGION`

- **Description**: OCI Region
- **Example**: `ap-seoul-1`, `us-ashburn-1`
- **Detailed Setup Method**:
  1. **Find Current Region**:
     - Look at the top-right corner of the OCI Console
     - You'll see the current region (e.g., "Seoul", "Ashburn", etc.)
  2. **Get Region Identifier**:
     - Click on the region name to see the dropdown
     - The region identifier is shown in parentheses
     - Common regions:
       - **Seoul**: `ap-seoul-1`
       - **Ashburn**: `us-ashburn-1`
       - **Phoenix**: `us-phoenix-1`
       - **Frankfurt**: `eu-frankfurt-1`
       - **London**: `uk-london-1`
  3. **Copy Region Identifier**:
     - Copy the region identifier (e.g., `ap-seoul-1`)

#### `OCI_COMPARTMENT_OCID`

- **Description**: Compartment OCID
- **Format**: `ocid1.compartment.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **✅ Your Value**: `ocid1.tenancy.oc1..aaaaaaaav6qj3vtbhomujsttvjepog6q5mb7mcomvds4crpo5nzr7hakdupq`
- **Detailed Setup Method**:

  1. **Navigate to Compartments** (Multiple ways):

     **Method 1 - Identity Menu**:

     - Click the hamburger menu (☰) in the top-left corner
     - Go to **Identity & Security** → **Compartments**

     **Method 2 - Direct URL**:

     - Go directly to: `https://console.region.oraclecloud.com/identity/compartments`
     - Replace `region` with your region (e.g., `ap-seoul-1`)

  2. **Find Root Compartment**:
     - Look for the "root" compartment (usually named after your tenancy)
     - If you don't see it, you can use the root compartment
  3. **Create a New Compartment (Recommended)**:
     - Click **Create Compartment**
     - Name: `flarum-production` (or any name you prefer)
     - Description: `Compartment for Flarum community forum`
     - Parent Compartment: Select "root"
     - Click **Create Compartment**
  4. **Copy Compartment OCID**:
     - Click on your compartment name
     - In the Compartment Information section, find the "OCID" field
     - Click the "Copy" button next to the OCID
     - Format: `ocid1.compartment.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### 2. SSH Key Information

#### `SSH_PUBLIC_KEY`

- **Description**: SSH Public Key
- **Format**: `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@hostname`
- **Detailed Generation Method**:

  1. **Open Terminal/Command Prompt**:
     - On Windows: Open PowerShell or Command Prompt
     - On Mac/Linux: Open Terminal
  2. **Generate SSH Key Pair**:
     ```bash
     ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
     ```
     - Press Enter to accept default file location (`~/.ssh/id_rsa`)
     - Enter a passphrase (optional but recommended)
     - Confirm the passphrase
  3. **Copy Public Key**:

     ```bash
     # On Mac/Linux:
     cat ~/.ssh/id_rsa.pub

     # On Windows (PowerShell):
     Get-Content ~/.ssh/id_rsa.pub
     ```

  4. **Copy the Output**:
     - Copy the entire line starting with `ssh-rsa`
     - Format: `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... your-email@example.com`

#### `SSH_PRIVATE_KEY`

- **Description**: SSH Private Key
- **Format**:
  ```
  -----BEGIN OPENSSH PRIVATE KEY-----
  b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn...
  -----END OPENSSH PRIVATE KEY-----
  ```
- **Detailed Generation Method**:

  1. **Open Terminal/Command Prompt** (same as above)
  2. **Display Private Key**:

     ```bash
     # On Mac/Linux:
     cat ~/.ssh/id_rsa

     # On Windows (PowerShell):
     Get-Content ~/.ssh/id_rsa
     ```

  3. **Copy Entire Private Key**:
     - Copy everything from `-----BEGIN OPENSSH PRIVATE KEY-----` to `-----END OPENSSH PRIVATE KEY-----`
     - Include the BEGIN and END lines
     - Usually 3-4 lines of content
  4. **Important**: Keep this key secure and never share it publicly

### 3. Database Configuration

#### `MYSQL_ROOT_PASSWORD`

- **Description**: MySQL root user password
- **Format**: Strong password (minimum 12 characters, including special characters)
- **Example**: `MySecureRootPass123!`
- **Detailed Setup Method**:
  1. **Create a Strong Password**:
     - Use a password generator or create manually
     - Minimum 12 characters
     - Include uppercase, lowercase, numbers, and special characters
     - Example: `MySecureRootPass123!`
  2. **Save the Password Securely**:
     - Store in a password manager
     - You'll need this password to access MySQL directly

#### `MYSQL_PASSWORD`

- **Description**: Flarum database user password
- **Format**: Strong password (minimum 12 characters, including special characters)
- **Example**: `AppSecurePass456!`
- **Detailed Setup Method**:
  1. **Create a Different Strong Password**:
     - Use a different password from the root password
     - Minimum 12 characters
     - Include uppercase, lowercase, numbers, and special characters
     - Example: `AppSecurePass456!`
  2. **Save the Password Securely**:
     - Store in a password manager
     - This is used by the Flarum application to connect to MySQL


## 🛠️ GitHub Secrets Setup Method

### 1. Setting up Secrets in GitHub Repository

1. **Access GitHub Repository**

   - Go to your repository settings

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

### 1. Cannot Find OCI Console Navigation

**Problem**: Can't find "Identity & Security" → "Tenancy Details" in OCI Console

**Solutions**:

1. **Try Profile Menu Method**:

   - Click on your **profile icon** (top-right corner)
   - Select **"Tenancy: [Your Tenancy Name]"**
   - This should take you directly to Tenancy Details

2. **Use Direct URLs**:

   - Tenancy Details: `https://console.region.oraclecloud.com/identity/tenancy`
   - Users: `https://console.region.oraclecloud.com/identity/users`
   - Compartments: `https://console.region.oraclecloud.com/identity/compartments`
   - Replace `region` with your region (e.g., `ap-seoul-1`)

3. **Check Console Version**:

   - Some regions have different console versions
   - Try refreshing the page or clearing browser cache

4. **Alternative Navigation**:
   - Look for "Administration" or "Governance" sections
   - Some consoles have "Identity" as a separate top-level menu

### 2. OCI Authentication Error

```
Error: Authentication failed
```

**Solution**:

- Verify OCI authentication information is correct
- Check if API Key is activated
- Verify region is correct

### 3. SSH Connection Error

```
Error: Permission denied (publickey)
```

**Solution**:

- Verify SSH keys are set correctly
- Check if public key is registered in OCI instance

### 4. Database Connection Error

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
