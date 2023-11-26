FROM php:7.4-fpm-alpine

LABEL maintainer="liangguifeng@htdf.group"

ARG ALPINE_URL=dl-cdn.alpinelinux.org
#ARG ALPINE_URL=mirrors.aliyun.com

RUN sed -i "s:dl-cdn.alpinelinux.org:${ALPINE_URL}:g" /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    # 常用工具
    zip curl git wget vim busybox-extras \
    # PHP扩展使用必备库
    autoconf make gcc musl-dev g++ libffi-dev openssl-dev zlib-dev libxml2-dev oniguruma-dev openssl-dev \
    libpng-dev icu-dev libzip-dev postgresql-dev gettext-dev gmp-dev freetype-dev libwebp-dev \
    && apk del $PHPIZE_DEPS

# PHP扩展安装 -j$(nproc)指使用系统上可用的处理器核心数量作为并行编译的任务数量
RUN docker-php-ext-install -j$(nproc) bcmath ctype dom fileinfo filter ftp gettext gmp intl json mbstring mysqli
RUN docker-php-ext-install -j$(nproc) pcntl pdo pdo_mysql pdo_pgsql phar posix session shmop
RUN docker-php-ext-install -j$(nproc) simplexml soap sockets tokenizer xml xmlrpc xmlwriter zip
RUN docker-php-ext-install -j$(nproc) opcache
RUN apk add --no-cache \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    && docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd
RUN pecl install -o -f redis \
    &&  docker-php-ext-enable redis
RUN pecl install swoole-4.8.12 \
    &&  docker-php-ext-enable swoole
RUN pecl install xdebug-3.1.5 \
    && docker-php-ext-enable xdebug

# Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

ENV TZ ${TZ:-Asia/Shanghai}