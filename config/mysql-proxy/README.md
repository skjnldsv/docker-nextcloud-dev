# mysql-proxy

# Usage with docker-compose

without
```
version: '2'

services:
  db:
    image: mysql:8.0.0
    restart: always
    ports:
      - "3307:3306" #for external connection
    volumes:
      - ../mysql-data/db:/var/lib/mysql #mysql-data
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: dbuser
      MYSQL_USER: dbuser
      MYSQL_PASSWORD: password
```

within
```
version: '2'

services:
  mysql:
    image: mysql:8.0.0
    restart: always
    expose:
      - "3306" #for service mysql-proxy
    ports:
      - "3307:3306" #for external connection
    volumes:
      - ../mysql-data/db:/var/lib/mysql #mysql-data
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: dbuser
      MYSQL_USER: dbuser
      MYSQL_PASSWORD: password
  db:
    image: bscheshir/mysqlproxy:0.8.5
    expose:
      - "3306" #for service php
    ports:
      - "3308:3306" #for external connection
    restart: always
    volumes: 
      - ../mysql-proxy-conf:/opt/mysql-proxy/conf
    environment:
      PROXY_DB_PORT: 3306
      REMOTE_DB_HOST: mysql
      REMOTE_DB_PORT: 3306
      LUA_SCRIPT: "/opt/mysql-proxy/conf/main.lua"
    depends_on:
      - mysql
```

# Query to stdout
For `docker-compose up` without `-d` (`../mysql-proxy/main.lua`)
```
function read_query(packet)
   if string.byte(packet) == proxy.COM_QUERY then
	print(string.sub(packet, 2))
   end
end
```

# Query logging for mysql-proxy 

```
...
    volumes:
      - ../mysql-proxy-conf:/opt/mysql-proxy/conf
      - ../mysql-proxy-logs:/opt/mysql-proxy/logs
    environment:
      PROXY_DB_PORT: 3306
      REMOTE_DB_HOST: mysql
      REMOTE_DB_PORT: 3306
      LUA_SCRIPT: "/opt/mysql-proxy/conf/log.lua"
      LOG_FILE: "/opt/mysql-proxy/logs/mysql.log"
...
```

`/mysql-proxy-conf/log.lua` https://gist.github.com/simonw/1039751
```
local log_file = os.getenv("LOG_FILE")

local fh = io.open(log_file, "a+")

function read_query( packet )
    if string.byte(packet) == proxy.COM_QUERY then
        local query = string.sub(packet, 2)
        fh:write( string.format("%s %6d -- %s \n", 
            os.date('%Y-%m-%d %H:%M:%S'), 
            proxy.connection.server["thread_id"], 
            query)) 
        fh:flush()
    end
end
```
# thanks

https://hub.docker.com/r/zwxajh/mysql-proxy
https://hub.docker.com/r/gediminaspuksmys/mysqlproxy/

# logrotate
The image can be expand with `logrotate`
Config file `/etc/logrotate.d/mysql-proxy` (approximate)

```
/opt/mysql-proxy/mysql.log {
	weekly
	missingok
	rotate 35600
	compress
	delaycompress
	notifempty
	create 666 root root 
	postrotate
		/etc/init.d/mysql-proxy reload > /dev/null
	endscript
}
```

# troubleshooting
If you can't create the chain `mysql` -> `mysql-proxy` -> `external client liten 0.0.0.0:3308`
check extends ports on the `mysql` service and/or add `expose` directly
```
    expose:
      - "3306" #for service mysql-proxy
```

> note: Log send to file with delay (buffering mechanism). You can restart the container for get the log immediately. 