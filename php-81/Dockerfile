FROM php:8.1-fpm-alpine

LABEL maintainer="liangguifeng@htdf.group"

ARG ALPINE_URL=dl-cdn.alpinelinux.org
#ARG ALPINE_URL=mirrors.aliyun.com

ENV TZ ${TZ:-Asia/Shanghai}

# Install Lib Depend
RUN sed -i "s:dl-cdn.alpinelinux.org:${ALPINE_URL}:g" /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    # 常用工具
    zip curl git wget vim busybox-extras \
    # PHP扩展使用必备库
    autoconf make gcc musl-dev g++ imagemagick libpng freetype libffi-dev openssl-dev zlib-dev libxml2-dev oniguruma-dev bzip2-dev \
    libpng-dev icu-dev libzip-dev postgresql-dev gettext-dev gmp-dev freetype-dev libwebp-dev libmcrypt-dev imagemagick-dev \
    rabbitmq-c-dev libcurl curl-dev c-ares-dev sqlite-dev jpeg-dev libjpeg-turbo libjpeg-turbo-dev

RUN NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)

# PHP扩展安装 -j$(nproc)指使用系统上可用的处理器核心数量作为并行编译的任务数量
RUN docker-php-ext-install -j$(nproc) bcmath ftp gmp mysqli
RUN docker-php-ext-install -j$(nproc) pcntl pdo pdo_mysql pdo_pgsql pdo_sqlite session
RUN docker-php-ext-install -j$(nproc) simplexml soap sockets xml xmlwriter
RUN docker-php-ext-install -j$(nproc) opcache fileinfo filter gettext posix phar
RUN docker-php-ext-install -j$(nproc) ctype mbstring intl gettext shmop
RUN docker-php-ext-install -j$(nproc) zip sysvsem exif bz2 calendar
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && docker-php-ext-install -j$(nproc) gd

# Imagick
RUN pecl install -o -f imagick-3.8.0 \
    && docker-php-ext-enable imagick

# MongoDB
RUN pecl install -o -f mongodb \
    && docker-php-ext-enable mongodb

# Redis
RUN pecl install -o -f redis \
    && docker-php-ext-enable redis

# Xdebug
RUN pecl install -o -f xdebug-3.3.2 \
    && docker-php-ext-enable xdebug

# Swoole
# 4.8 版本需要 php-7.2 或更高版本
# 5.0 版本需要 php-8.0 或更高版本
# 6.0 版本需要 PHP-8.1 或更高版本
RUN pecl install -o -f -D 'enable-sockets="yes" enable-openssl="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="yes" enable-swoole-curl="yes" enable-cares="yes" enable-brotli="yes" enable-zstd="yes" enable-swoole-pgsql="yes" enable-swoole-sqlite="yes" with-swoole-odbc="no" with-swoole-oracle="no" enable-swoole-thread="no" enable-iouring="no"' swoole-6.0.2 \
    && docker-php-ext-enable swoole

# Amqp
RUN pecl install -o -f amqp \
    && docker-php-ext-enable amqp

# Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# ZSH Shell
RUN apk add --no-cache zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ZSH Plugin
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Complete
RUN php -v \
    && php -m \
    && php --ri swoole \
    && php --ri Zend\ OPcache \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
