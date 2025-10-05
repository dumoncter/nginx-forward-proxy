FROM dominikbechstein/nginx-forward-proxy:latest

LABEL maintainer="neonpsh.ru"

# Copy custom nginx configuration
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

# Create necessary directories for nginx
RUN mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp

# Expose port
EXPOSE 8080

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
