FROM composer:latest AS vendor

WORKDIR /app

COPY database/factories/* database/factories/
COPY database/seeds/* database/seeds/
COPY composer.* ./

RUN composer install \
  --no-dev \
  --no-interaction \
  --prefer-dist \
  --ignore-platform-reqs \
  --optimize-autoloader \
  --apcu-autoloader \
  --ansi \
  --no-scripts

FROM php:8.0.14-fpm-alpine3.15

WORKDIR /var/lib/nginx/html/

RUN apk add --no-cache nginx socat \
  && rm /usr/local/etc/php-fpm.d/zz-docker.conf \
  && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/conf.d/php.ini \
  && touch /run/php-fpm.sock 

COPY docker/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/default.conf /etc/nginx/http.d/default.conf

COPY --from=vendor /app/vendor ./vendor
COPY --chown=www-data:www-data . ./

CMD sh /var/lib/nginx/html/docker/startup.sh
