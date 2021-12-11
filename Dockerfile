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

FROM php:7.4.26-fpm-alpine

RUN apk add --no-cache nginx wget

COPY docker/nginx.conf /etc/nginx/nginx.conf

WORKDIR /app

COPY --from=vendor /app/vendor ./vendor

COPY --chown=www-data:www-data . ./

CMD sh /app/docker/startup.sh
