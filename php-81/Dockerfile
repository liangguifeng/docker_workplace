FROM php:8.1-fpm-alpine

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
    rabbitmq-c-dev libcurl curl-dev c-ares-dev sqlite-dev freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev

RUN NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)

# PHP扩展安装 -j$(nproc)指使用系统上可用的处理器核心数量作为并行编译的任务数量
RUN docker-php-ext-install -j$(nproc) bcmath ctype fileinfo filter ftp gettext gmp intl mbstring mysqli
RUN docker-php-ext-install -j$(nproc) pcntl pdo pdo_mysql pdo_pgsql pdo_sqlite phar posix session shmop soap sockets zip
RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && docker-php-ext-install -j$(nproc) gd

# 4.8 版本需要 php-7.2 或更高版本
# 5.0 版本需要 php-8.0 或更高版本
RUN curl -SL "https://github.com/swoole/swoole-src/archive/v5.1.2.tar.gz" -o swoole.tar.gz \
    && ls -alh \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-openssl --enable-swoole-curl --enable-cares --enable-swoole-pgsql --enable-swoole-sqlite \
        && make -s -j$(nproc) && make install \
    )

RUN pecl install -o -f redis \
    &&  docker-php-ext-enable redis
RUN pecl install xdebug-3.3.2 \
    && docker-php-ext-enable xdebug
RUN pecl install amqp \
    && docker-php-ext-enable amqp

# Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

RUN rm -rf /tmp \
    && apk del $PHPIZE_DEPS \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/local/bin/php* \
    # php info
    && php -v \
    && php -m \
    && php --ri swoole \
    && php --ri Zend\ OPcache \
    && composer \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

ENV TZ ${TZ:-Asia/Shanghai}