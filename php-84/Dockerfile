FROM php:8.4-fpm-alpine

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
RUN docker-php-ext-install -j$(nproc) pcntl pdo pdo_mysql pdo_pgsql pdo_sqlite posix session shmop soap sockets zip
RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install -o -f redis \
    && docker-php-ext-enable redis
RUN pecl install xdebug-3.4.7 \
    && docker-php-ext-enable xdebug
# 4.8 版本需要 php-7.2 或更高版本
# 5.0 版本需要 php-8.0 或更高版本
RUN pecl install swoole-6.1.0 \
    && docker-php-ext-enable swoole
RUN pecl install amqp \
    && docker-php-ext-enable amqp

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

ENV TZ ${TZ:-Asia/Shanghai}

RUN apk add --no-cache zsh && \
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" && \
    sed -i 's/ash/zsh/g' /etc/passwd

RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && sed -i '/^plugins=(git)/d' /root/.zshrc \
    && sed -i '$ a plugins=(git zsh-completions zsh-autosuggestions)' /root/.zshrc \
    && zsh -i -c 'source /root/.zshrc'

RUN php -v \
    && php -m \
    && php --ri swoole \
    && php --ri Zend\ OPcache \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
