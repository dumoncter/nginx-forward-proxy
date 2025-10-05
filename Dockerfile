FROM dominikbechstein/nginx-forward-proxy:latest

LABEL maintainer="neonpsh.ru"

# Copy custom nginx configuration
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

# Create non-root user for security (compatible with different Linux distributions)
RUN set -x && \
    # Try Alpine Linux commands first
    (addgroup -g 1001 -S nginx && adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx) || \
    # Fallback to standard Linux commands
    (groupadd -r -g 1001 nginx && useradd -r -u 1001 -g nginx -d /var/cache/nginx -s /sbin/nologin -c "nginx user" nginx)

# Create necessary directories
RUN mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp && \
    chown -R nginx:nginx /var/cache/nginx

# Expose port
EXPOSE 8080

# Switch to non-root user
USER nginx

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
