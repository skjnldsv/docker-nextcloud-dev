#!/bin/bash
# https://github.com/docker/for-linux/issues/264
ip -4 route list match 0/0 | awk '{print $3 "\thost.docker.internal"}' >> /etc/hosts
