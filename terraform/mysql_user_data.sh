#!/bin/bash

# MySQL database server initial setup script
# Based on Oracle Linux 8

set -e

# Logging setup
exec > >(tee /var/log/mysql-user-data.log|logger -t mysql-user-data -s 2>/dev/console) 2>&1

echo "Starting MySQL database server setup..."

# System update
dnf update -y

# Install MySQL 8.0
dnf install -y mysql-server mysql

# Start and enable MySQL service
systemctl start mysqld
systemctl enable mysqld

# MySQL security configuration
mysql_secure_installation << EOF
${mysql_root_password}
${mysql_root_password}
y
y
y
y
y
EOF

# Create MySQL database and user
mysql -u root -p${mysql_root_password} << EOF
CREATE DATABASE IF NOT EXISTS ${mysql_database} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${mysql_user}'@'%' IDENTIFIED BY '${mysql_password}';
GRANT ALL PRIVILEGES ON ${mysql_database}.* TO '${mysql_user}'@'%';
FLUSH PRIVILEGES;
EOF

# Modify MySQL configuration file (allow remote access)
cat >> /etc/my.cnf << EOF

# MySQL configuration for Flarum
[mysqld]
bind-address = 0.0.0.0
max_connections = 100
innodb_buffer_pool_size = 256M
innodb_log_file_size = 64M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
EOF

# Restart MySQL service
systemctl restart mysqld

# Firewall configuration
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload

# MySQL connection test
mysql -u ${mysql_user} -p${mysql_password} -h localhost ${mysql_database} -e "SELECT 1;" || echo "MySQL connection test failed"

echo "MySQL database setup completed!"
echo "Database: ${mysql_database}"
echo "User: ${mysql_user}"
echo "Host: $(hostname -I | awk '{print $1}')"
echo "Port: 3306"
