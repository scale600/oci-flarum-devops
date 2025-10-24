#!/bin/bash

# Flarum web server initial setup script
# Based on Oracle Linux 8

set -e

# Logging setup
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting Flarum web server setup..."

# System update
dnf update -y

# Install required packages
dnf install -y docker docker-compose git curl wget unzip

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Add opc user to docker group
usermod -aG docker opc

# Install Docker Compose (latest version)
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create Flarum directory
mkdir -p /home/opc/flarum
cd /home/opc/flarum

# Create Docker Compose file
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
      - FORUM_URL=http://PLACEHOLDER_IP
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_NAME=${mysql_database}
      - DB_USER=${mysql_user}
      - DB_PASSWORD=${mysql_password}
    depends_on:
      - mysql
    networks:
      - flarum_network

  mysql:
    image: mysql:8.0
    container_name: flarum_mysql
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=${mysql_root_password}
      - MYSQL_DATABASE=${mysql_database}
      - MYSQL_USER=${mysql_user}
      - MYSQL_PASSWORD=${mysql_password}
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

# Get the actual public IP address and replace placeholder
ACTUAL_PUBLIC_IP=$(curl -s http://169.254.169.254/opc/v1/vnics/ | jq -r '.[0].publicIp')

# Replace placeholder IP in docker-compose.yml
sed -i "s/PLACEHOLDER_IP/${ACTUAL_PUBLIC_IP}/g" docker-compose.yml

# Create environment variables file
cat > .env << EOF
FLARUM_PUBLIC_IP=${ACTUAL_PUBLIC_IP}
MYSQL_ROOT_PASSWORD=${mysql_root_password}
MYSQL_DATABASE=${mysql_database}
MYSQL_USER=${mysql_user}
MYSQL_PASSWORD=${mysql_password}
EOF

# Change ownership
chown -R opc:opc /home/opc/flarum

# Start services with Docker Compose
cd /home/opc/flarum
docker-compose up -d

# Firewall configuration (using firewalld)
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

# Install Certbot for SSL certificate setup
dnf install -y epel-release
dnf install -y certbot

# Create script for SSL setup after Flarum configuration
cat > /home/opc/setup-ssl.sh << 'EOF'
#!/bin/bash
# SSL certificate setup script (run after domain setup)

DOMAIN_NAME="${domain_name}"
EMAIL="admin@riderwin.com"

# Issue SSL certificate with Certbot
certbot certonly --standalone -d $DOMAIN_NAME --email $EMAIL --agree-tos --non-interactive

# Configure SSL certificate for use in Docker containers
# (additional configuration needed)
EOF

chmod +x /home/opc/setup-ssl.sh

echo "Flarum setup completed!"
echo "Access your forum at: http://${ACTUAL_PUBLIC_IP}"
echo "To setup SSL, run: /home/opc/setup-ssl.sh"
