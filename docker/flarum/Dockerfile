# Flarum Custom Image
FROM mondedie/flarum:stable

# Install additional packages for enhanced functionality
RUN apk add --no-cache \
    curl \
    wget \
    unzip

# Create Flarum extensions directory
RUN mkdir -p /flarum/app/extensions

# Extensions will be installed at runtime
# Use base Flarum image (extension installation removed)

# Flarum setup script
COPY flarum-setup.sh /usr/local/bin/flarum-setup.sh
RUN chmod +x /usr/local/bin/flarum-setup.sh

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Expose ports
EXPOSE 80 443

# Startup script
ENTRYPOINT ["/usr/local/bin/flarum-setup.sh"]
CMD ["flarum", "start"]
