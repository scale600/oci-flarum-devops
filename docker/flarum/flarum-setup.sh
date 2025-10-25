#!/bin/bash

# Flarum 설정 스크립트
set -e

echo "Starting Flarum setup..."

# 환경 변수 확인
if [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "Error: Database configuration is missing"
    exit 1
fi

# Flarum이 이미 설치되었는지 확인
if [ -f "/flarum/app/config.php" ]; then
    echo "Flarum is already installed. Starting services..."
    exec "$@"
fi

# 데이터베이스 연결 대기
echo "Waiting for database connection..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for database..."
    sleep 5
done

echo "Database is ready!"

# Flarum 초기 설정 안내
echo "Flarum is ready for initial setup!"
echo "Please complete the setup through the web interface."
echo "Access your forum at: ${FORUM_URL:-http://localhost}"

# 원래 명령어 실행
exec "$@"
