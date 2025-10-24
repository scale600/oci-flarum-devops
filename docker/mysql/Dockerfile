# MySQL 8.0 커스텀 이미지
FROM mysql:8.0

# 한국어 지원을 위한 설정
ENV LANG=ko_KR.UTF-8
ENV LC_ALL=ko_KR.UTF-8

# MySQL 설정 파일 복사
COPY my.cnf /etc/mysql/conf.d/custom.cnf

# 초기화 스크립트 복사
COPY init.sql /docker-entrypoint-initdb.d/

# 포트 노출
EXPOSE 3306

# 헬스체크 추가
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD || exit 1
