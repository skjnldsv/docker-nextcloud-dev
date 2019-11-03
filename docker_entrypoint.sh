# !/bin/env sh
local_ip = ip -4 route list match 0/0 | awk '{print $3 "\thost.docker.internal"}'
echo $local_ip
