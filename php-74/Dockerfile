FROM php:7.4-fpm-alpine

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
RUN docker-php-ext-install -j$(nproc) bcmath dom ftp gmp json mysqli
RUN docker-php-ext-install -j$(nproc) pcntl pdo pdo_mysql pdo_pgsql pdo_sqlite session
RUN docker-php-ext-install -j$(nproc) simplexml soap sockets tokenizer xml xmlrpc xmlwriter
RUN docker-php-ext-install -j$(nproc) opcache fileinfo filter gettext posix phar
RUN docker-php-ext-install -j$(nproc) ctype mbstring intl gettext shmop xmlwriter
RUN docker-php-ext-install -j$(nproc) zip sysvsem exif bz2 calendar
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp && \
    docker-php-ext-install -j$(nproc) gd

# Imagick
RUN pecl install -o -f imagick-3.8.0 \
    && docker-php-ext-enable imagick

# Redis
RUN pecl install -o -f redis \
    && docker-php-ext-enable redis

# Mcrypt
RUN pecl install -o -f mcrypt-1.0.7 \
    && docker-php-ext-enable mcrypt

# Xdebug
RUN pecl install xdebug-3.1.6 \
    && docker-php-ext-enable xdebug

# Swoole
# 4.8 版本需要 php-7.2 或更高版本
# 5.0 版本需要 php-8.0 或更高版本
# 6.0 版本需要 PHP-8.1 或更高版本
RUN pecl install swoole-4.8.12 \
    && docker-php-ext-enable swoole

# Amqp
RUN pecl install amqp \
    && docker-php-ext-enable amqp

# Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# ZSH Shell
RUN apk add --no-cache zsh \
    && git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

# ZSH Plugin
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Complete
RUN php -v \
    && php -m \
    && php --ri swoole \
    && php --ri Zend\ OPcache \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
