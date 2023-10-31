FROM php:8.1-fpm-alpine

LABEL maintainer="liangguifeng@htdf.group"

ARG ALPINE_URL=dl-cdn.alpinelinux.org

RUN sed -i "s:dl-cdn.alpinelinux.org:${ALPINE_URL}:g" /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    # 常用工具
    zip curl git wget vim busybox-extras \
    # PHP扩展使用必备库
    autoconf make gcc musl-dev g++ libffi-dev openssl-dev zlib-dev libxml2-dev oniguruma-dev openssl-dev \
    libpng-dev icu-dev libzip-dev postgresql-dev gettext-dev gmp-dev freetype-dev libwebp-dev

# PHP扩展安装
RUN docker-php-74-ext-install bcmath ctype dom fileinfo filter ftp gettext gmp intl mbstring mysqli
RUN docker-php-74-ext-install pcntl pdo pdo_mysql pdo_pgsql phar posix session shmop soap sockets zip
RUN apk add --no-cache \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    && docker-php-74-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-74-ext-install -j${NPROC} gd
RUN pecl install -o -f redis \
    &&  docker-php-74-ext-enable redis
RUN pecl install swoole-4.8.12 \
    &&  docker-php-74-ext-enable swoole
RUN pecl install xdebug-3.1.5 \
    && docker-php-74-ext-enable xdebug

ENV TZ ${TZ:-Asia/Shanghai}