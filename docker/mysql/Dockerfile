# MySQL 8.0 Custom Image
FROM mysql:8.0

# Locale settings for internationalization
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Copy MySQL configuration file
COPY my.cnf /etc/mysql/conf.d/custom.cnf

# Copy initialization script
COPY init.sql /docker-entrypoint-initdb.d/

# Expose port
EXPOSE 3306

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD || exit 1
