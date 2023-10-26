FROM php:7.4-fpm-alpine

LABEL maintainer="liangguifeng@htdf.group"

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s:dl-cdn.alpinelinux.org:${ALPINE_URL}:g" /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    # 常用工具
    zip curl git wget vim busybox-extras \
    # PHP扩展使用必备库
    autoconf make gcc musl-dev g++ libffi-dev openssl-dev zlib-dev libxml2-dev oniguruma-dev openssl-dev libpng-dev icu-dev libzip-dev postgresql-dev gettext-dev gmp-dev

# PHP扩展安装
RUN docker-php-ext-install bcmath ctype dom fileinfo filter ftp gd gettext gmp intl json mbstring mysqli
RUN docker-php-ext-install pcntl pdo pdo_mysql phar posix session shmop 
RUN docker-php-ext-install simplexml soap sockets tokenizer xml xmlrpc xmlwriter zip
RUN pecl install -o -f redis \
    &&  docker-php-ext-enable redis
RUN pecl install swoole-4.8.12 \
    &&  docker-php-ext-enable swoole
RUN pecl install xdebug-3.1.5 \
    && docker-php-ext-enable xdebug

ENV TZ ${TZ:-Asia/Shanghai}