FROM nanoninja/php-fpm

# Apt update and install wget
RUN apt-get update \
    && apt-get --no-install-recommends --no-install-suggests --yes --quiet install wget

# Add pcntl
RUN docker-php-ext-configure pcntl \
	&& docker-php-ext-install pcntl

# Cleanup
RUN apt-get clean && apt-get --yes --quiet autoremove --purge

# Install phpunit 7
RUN wget -O /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-7.phar \
	&& chmod +x /usr/local/bin/phpunit

# Add a "docker" user
RUN useradd docker --shell /bin/bash --create-home \
	&& usermod --append --groups sudo docker \
	&& echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
	&& echo 'docker:secret' | chpasswd

USER docker

CMD ["php-fpm"]