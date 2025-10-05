FROM nginx:1.27-alpine

LABEL maintainer="neonpsh.ru"

# Install dependencies for proxy_connect module
RUN apk add --no-cache \
    build-base \
    git \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    curl

# Download and compile nginx with proxy_connect module
RUN cd /tmp && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module.git && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        git \
        openssl-dev \
        pcre-dev \
        zlib-dev && \
    wget http://nginx.org/download/nginx-1.27.1.tar.gz && \
    tar xf nginx-1.27.1.tar.gz && \
    cd nginx-1.27.1 && \
    patch -p1 < ../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch && \
    ./configure \
        --add-module=../ngx_http_proxy_connect_module \
        --sbin-path=/usr/sbin/nginx \
        --with-stream \
        --with-stream_ssl_module \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-http_realip_module \
        --with-http_auth_request_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-pcre \
        --with-pcre-jit && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /tmp/* && \
    apk del .build-deps

# Install envsubst for environment variable substitution
RUN apk add --no-cache gettext

# Copy custom nginx configuration
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf.template

# Create necessary directories for nginx
RUN mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp

# Expose port
EXPOSE 443

# Start nginx with environment variable substitution
CMD ["/bin/sh", "-c", "envsubst < /usr/local/nginx/conf/nginx.conf.template > /usr/local/nginx/conf/nginx.conf && nginx -g 'daemon off;'"]
