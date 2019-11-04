#!/bin/bash
# https://github.com/docker/for-linux/issues/264
IP=$(ip -4 route list match 0/0 | awk '{print $3}')
echo "Host ip is $IP"
echo "$IP	host.docker.internal" | sudo tee -a /etc/hosts

cat /etc/hosts

# execute default php-fpm entrypoint
docker-php-entrypoint php-fpm
