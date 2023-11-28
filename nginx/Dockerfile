FROM nginx:alpine

LABEL maintainer="liangguifeng@htdf.group"

ARG ALPINE_URL=dl-cdn.alpinelinux.org
#ARG ALPINE_URL=mirrors.aliyun.com

ENV BACKEND_ROOT=${BACKEND_ROOT}

RUN sed -i "s:dl-cdn.alpinelinux.org:${ALPINE_URL}:g" /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    # 常用工具
    zip curl git wget vim busybox-extras \
    # PHP扩展使用必备库
    autoconf make gcc musl-dev g++ libffi-dev openssl-dev zlib-dev libxml2-dev oniguruma-dev openssl-dev \
    libpng-dev icu-dev libzip-dev postgresql-dev gettext-dev gmp-dev freetype-dev libwebp-dev \
    freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && apk del $PHPIZE_DEPS

WORKDIR /etc/nginx/conf.d

ENV TZ ${TZ:-Asia/Shanghai}