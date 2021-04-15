FROM php:7.3-alpine

RUN set -eux; \
  apk add --no-cache --virtual .composer-rundeps \
    bash \
    coreutils \
    git \
    make \
    mercurial \
    openssh-client \
    patch \
    subversion \
    tini \
    unzip \
    zip

RUN set -eux; \
  apk add --no-cache --virtual .build-deps \
    libzip-dev \
    zlib-dev \
  ; \
  docker-php-ext-install -j "$(nproc)" \
    zip \
  ; \
  runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
  apk add --no-cache --virtual .composer-phpext-rundeps $runDeps; \
  apk del .build-deps

RUN printf "# composer php cli ini settings\n\
date.timezone=UTC\n\
memory_limit=-1\n\
" > $PHP_INI_DIR/php-cli.ini

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp

RUN set -eux; \
  curl --silent --fail --location --retry 3 --output /tmp/keys.dev.pub --url https://raw.githubusercontent.com/composer/composer.github.io/master/snapshots.pub; \
  curl --silent --fail --location --retry 3 --output /tmp/keys.tags.pub --url https://raw.githubusercontent.com/composer/composer.github.io/master/releases.pub; \
  curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/master/web/installer; \
  php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer \
  composer --ansi --version --no-interaction; \
  composer diagnose; \
  rm -f /tmp/installer.php; \
  find /tmp -type d -exec chmod -v 1777 {} +

COPY docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["composer"]
