# Flarum 커스텀 이미지
FROM mondedie/flarum:stable

# 한국어 지원을 위한 추가 패키지 설치
RUN apk add --no-cache \
    curl \
    wget \
    unzip

# Flarum 확장 프로그램 디렉토리 생성
RUN mkdir -p /flarum/app/extensions

# 기본 확장 프로그램 설치
RUN flarum extension:install flarum-seo && \
    flarum extension:install flarum-markdown && \
    flarum extension:install flarum-tags && \
    flarum extension:install flarum-sticky && \
    flarum extension:install flarum-subscriptions && \
    flarum extension:install flarum-mentions && \
    flarum extension:install flarum-approval && \
    flarum extension:install flarum-suspend && \
    flarum extension:install flarum-lock

# 한국어 언어팩 설치 (선택사항)
# RUN flarum extension:install flarum-lang-korean

# Flarum 설정 스크립트
COPY flarum-setup.sh /usr/local/bin/flarum-setup.sh
RUN chmod +x /usr/local/bin/flarum-setup.sh

# 헬스체크 추가
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# 포트 노출
EXPOSE 80 443

# 시작 스크립트
ENTRYPOINT ["/usr/local/bin/flarum-setup.sh"]
CMD ["flarum", "start"]
