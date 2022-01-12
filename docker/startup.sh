#!/usr/bin/env sh
php-fpm -D \
    && while ! socat -dd UNIX-CONNECT:/run/php-fpm.sock -; do sleep 0.1; done;

sed -i "s,LISTEN_PORT,${PORT:-80},g" /etc/nginx/http.d/default.conf \
    && nginx -g 'daemon off;'
