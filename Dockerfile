FROM drupal:10-php8.3-fpm-alpine
# compared to
# Install gd
LABEL summary="php-8.3 with extensions and external programs for drupal, ssh/sftp access and mysql command line client" \
      version="drupal-10-php8.3-fpm-alpine-m" \
      name="freinet/drupal-10-php8.3-fpm-alpine-m" \
      maintainer="Jonas Moser <moser@freinet.de>"

USER root

RUN apk add --no-cache openssh rsync busybox-suid bash git mysql-client gzip \
    && ssh-keygen -A && echo 'StrictModes no' >> /etc/ssh/sshd_config \
    && apk add --no-cache --update libmemcached-libs zlib \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps zlib-dev libmemcached-dev cyrus-sasl-dev \
    && printf "\n" | pecl install memcached \
    && apk del .memcached-deps .phpize-deps \
    && echo 'Welcome to Alpine (powered by FreiNet)' > /etc/motd \
    && echo '--------------------------------------------------------------------------------' >> /etc/motd \
    && php -v >> /etc/motd \
    && echo -e '--------------------------------------------------------------------------------\n' >> /etc/motd

COPY entrypoint-ssh.sh /entrypoint-ssh.sh
RUN chmod +x /entrypoint-ssh.sh
WORKDIR /var/www
EXPOSE 9000
EXPOSE 22
