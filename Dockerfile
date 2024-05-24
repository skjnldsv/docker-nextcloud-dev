FROM php:8.2-fpm

# entrypoint.sh and cron.sh dependencies
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        iproute2 \
        sudo \
        rsync \
        bzip2 \
        busybox-static \
        curl \
        smbclient \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    \
    mkdir -p /var/spool/cron/crontabs; \
    echo '*/15 * * * * php -f /var/www/html/cron.php' > /var/spool/cron/crontabs/www-data

# Install phpunit 7
RUN curl -L https://phar.phpunit.de/phpunit-8.phar > /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# install the PHP extensions we need
# see https://docs.nextcloud.com/server/12/admin_manual/installation/source_installation.html
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions \
    apcu \
    exif \
    gd \
    imagick \
    intl \
    ldap \
    memcached \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    redis \
    smbclient \
    xdebug \
    zip

# samba
RUN { \
        echo '[global]'; \
        echo 'client min protocol = SMB2'; \
        echo 'client max protocol = SMB3'; \
        echo 'hide dot files = no'; \
    } > /etc/samba/smb.conf

# npm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
    && export NVM_DIR="/root/.nvm" \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install --lts

# set recommended PHP.ini settings
# see https://docs.nextcloud.com/server/12/admin_manual/configuration_server/server_tuning.html
RUN echo 'memory_limit=512M' > /usr/local/etc/php/conf.d/memory-limit.ini; \
    \
    mkdir /var/www/data; \
    chown -R www-data:root /var/www; \
    chmod -R g=u /var/www

# Add a "docker" user
RUN useradd docker --shell /bin/bash --create-home \
    && usermod --append --groups sudo docker \
    && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo 'docker:secret' | chpasswd

# Cleanup
RUN apt-get clean && apt-get --yes --quiet autoremove --purge \
    && rm -Rf /tmp/*

ADD docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

USER docker

VOLUME /var/www/nextcloud
WORKDIR /var/www/nextcloud

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
