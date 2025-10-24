#!/bin/bash

# Flarum 웹서버 초기 설정 스크립트
# Oracle Linux 8 기반

set -e

# 로그 설정
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting Flarum web server setup..."

# 시스템 업데이트
dnf update -y

# 필요한 패키지 설치
dnf install -y docker docker-compose git curl wget unzip

# Docker 서비스 시작 및 활성화
systemctl start docker
systemctl enable docker

# opc 사용자를 docker 그룹에 추가
usermod -aG docker opc

# Docker Compose 설치 (최신 버전)
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Flarum 디렉토리 생성
mkdir -p /home/opc/flarum
cd /home/opc/flarum

# Docker Compose 파일 생성
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  flarum:
    image: mondedie/flarum:stable
    container_name: flarum
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - flarum_data:/flarum/app/extensions
      - flarum_data:/flarum/app/storage
    environment:
      - UID=1000
      - GID=1000
      - DEBUG=false
      - FORUM_URL=http://${FLARUM_PUBLIC_IP}
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_NAME=${MYSQL_DATABASE}
      - DB_USER=${MYSQL_USER}
      - DB_PASSWORD=${MYSQL_PASSWORD}
    depends_on:
      - mysql
    networks:
      - flarum_network

  mysql:
    image: mysql:8.0
    container_name: flarum_mysql
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - flarum_network

volumes:
  flarum_data:
  mysql_data:

networks:
  flarum_network:
    driver: bridge
EOF

# 환경 변수 파일 생성
cat > .env << EOF
FLARUM_PUBLIC_IP=${flarum_instance_public_ip}
MYSQL_ROOT_PASSWORD=${mysql_root_password}
MYSQL_DATABASE=${mysql_database}
MYSQL_USER=${mysql_user}
MYSQL_PASSWORD=${mysql_password}
EOF

# 소유권 변경
chown -R opc:opc /home/opc/flarum

# Docker Compose로 서비스 시작
cd /home/opc/flarum
docker-compose up -d

# 방화벽 설정 (firewalld 사용)
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

# SSL 인증서 설정을 위한 Certbot 설치
dnf install -y epel-release
dnf install -y certbot

# Flarum 설정 완료 후 SSL 설정을 위한 스크립트 생성
cat > /home/opc/setup-ssl.sh << 'EOF'
#!/bin/bash
# SSL 인증서 설정 스크립트 (도메인 설정 후 실행)

DOMAIN_NAME="${domain_name}"
EMAIL="admin@riderwin.com"

# Certbot으로 SSL 인증서 발급
certbot certonly --standalone -d $DOMAIN_NAME --email $EMAIL --agree-tos --non-interactive

# SSL 인증서를 Docker 컨테이너에서 사용할 수 있도록 설정
# (추가 설정 필요)
EOF

chmod +x /home/opc/setup-ssl.sh

echo "Flarum setup completed!"
echo "Access your forum at: http://${flarum_instance_public_ip}"
echo "To setup SSL, run: /home/opc/setup-ssl.sh"
