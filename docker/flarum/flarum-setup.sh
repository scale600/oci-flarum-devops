#!/bin/bash

# Flarum Setup Script
set -e

echo "Starting Flarum setup..."

# Check environment variables
if [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "Error: Database configuration is missing"
    exit 1
fi

# Check if Flarum is already installed
if [ -f "/flarum/app/config.php" ]; then
    echo "Flarum is already installed. Starting services..."
    exec "$@"
fi

# Wait for database connection
echo "Waiting for database connection..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for database..."
    sleep 5
done

echo "Database is ready!"

# Flarum initial setup guide
echo "Flarum is ready for initial setup!"
echo "Please complete the setup through the web interface."
echo "Access your forum at: ${FORUM_URL:-http://localhost}"

# Execute original command
exec "$@"
