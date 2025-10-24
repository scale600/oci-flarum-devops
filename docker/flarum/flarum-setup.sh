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

# Flarum 설치
echo "Installing Flarum..."
flarum install \
    --title="Riderwin Community" \
    --admin="${FLARUM_ADMIN_USERNAME:-admin}" \
    --password="${FLARUM_ADMIN_PASSWORD}" \
    --email="${FLARUM_ADMIN_EMAIL}" \
    --dbhost="$DB_HOST" \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --forum-url="${FORUM_URL:-http://localhost}"

# 확장 프로그램 활성화
echo "Enabling extensions..."
flarum extension:enable flarum-seo
flarum extension:enable flarum-markdown
flarum extension:enable flarum-tags
flarum extension:enable flarum-sticky
flarum extension:enable flarum-subscriptions
flarum extension:enable flarum-mentions
flarum extension:enable flarum-approval
flarum extension:enable flarum-suspend
flarum extension:enable flarum-lock

# 캐시 클리어
flarum cache:clear

echo "Flarum setup completed!"

# 원래 명령어 실행
exec "$@"
