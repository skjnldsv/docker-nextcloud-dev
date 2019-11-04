#!/bin/bash
# https://github.com/docker/for-linux/issues/264
IP=$(ip -4 route list match 0/0 | awk '{print $3}')
echo "Host ip is $IP"
echo "$IP	host.docker.internal" >> /etc/hosts
# execute default php-fpm entrypoint
sudo -u docker docker-php-entrypoint
