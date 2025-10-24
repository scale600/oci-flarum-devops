#!/bin/bash

# MySQL 데이터베이스 서버 초기 설정 스크립트
# Oracle Linux 8 기반

set -e

# 로그 설정
exec > >(tee /var/log/mysql-user-data.log|logger -t mysql-user-data -s 2>/dev/console) 2>&1

echo "Starting MySQL database server setup..."

# 시스템 업데이트
dnf update -y

# MySQL 8.0 설치
dnf install -y mysql-server mysql

# MySQL 서비스 시작 및 활성화
systemctl start mysqld
systemctl enable mysqld

# MySQL 보안 설정
mysql_secure_installation << EOF
${mysql_root_password}
${mysql_root_password}
y
y
y
y
y
EOF

# MySQL 데이터베이스 및 사용자 생성
mysql -u root -p${mysql_root_password} << EOF
CREATE DATABASE IF NOT EXISTS ${mysql_database} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${mysql_user}'@'%' IDENTIFIED BY '${mysql_password}';
GRANT ALL PRIVILEGES ON ${mysql_database}.* TO '${mysql_user}'@'%';
FLUSH PRIVILEGES;
EOF

# MySQL 설정 파일 수정 (원격 접속 허용)
cat >> /etc/my.cnf << EOF

# Flarum을 위한 MySQL 설정
[mysqld]
bind-address = 0.0.0.0
max_connections = 100
innodb_buffer_pool_size = 256M
innodb_log_file_size = 64M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
EOF

# MySQL 서비스 재시작
systemctl restart mysqld

# 방화벽 설정
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload

# MySQL 연결 테스트
mysql -u ${mysql_user} -p${mysql_password} -h localhost ${mysql_database} -e "SELECT 1;" || echo "MySQL connection test failed"

echo "MySQL database setup completed!"
echo "Database: ${mysql_database}"
echo "User: ${mysql_user}"
echo "Host: $(hostname -I | awk '{print $1}')"
echo "Port: 3306"
