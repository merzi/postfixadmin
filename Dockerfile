FROM alpine:3.17

LABEL description="PostfixAdmin is a web based interface used to manage mailboxes"

ARG VERSION=3.3.13
ARG PHP_VERSION=81
ARG SHA256_HASH="026c4f370656b96b6c9f62328e901b9416a6e56d1c4df86249995d661498947b"

RUN set -eux; \
    apk update && apk upgrade; \
    apk add --no-cache \
        su-exec \
        dovecot \
        tini \
        php${PHP_VERSION} \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-imap \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysqli \
        php${PHP_VERSION}-pdo \
        php${PHP_VERSION}-pdo_mysql \
        php${PHP_VERSION}-pdo_pgsql \
        php${PHP_VERSION}-pgsql \
        php${PHP_VERSION}-phar \
        php${PHP_VERSION}-session \
    ; \
    \
    PFA_TARBALL="postfixadmin-${VERSION}.tar.gz"; \
    wget -q https://github.com/postfixadmin/postfixadmin/archive/${PFA_TARBALL}; \
    echo "${SHA256_HASH} *${PFA_TARBALL}" | sha256sum -c; \
    \
    mkdir /postfixadmin; \
    tar -xzf ${PFA_TARBALL} --strip-components=1 -C /postfixadmin; \
    rm -f ${PFA_TARBALL}; \
    chmod 644 /etc/ssl/dovecot/server.key

COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
