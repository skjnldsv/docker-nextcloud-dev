[![Docker Automated build](https://img.shields.io/docker/automated/skjnldsv/nextcloud-dev.svg?style=flat-square)](https://hub.docker.com/r/skjnldsv/nextcloud-dev/) [![Docker Pulls](https://img.shields.io/docker/pulls/skjnldsv/nextcloud-dev.svg?style=flat-square)](https://hub.docker.com/r/skjnldsv/nextcloud-dev/)


## This is a nextcloud development environment stack for docker🚀

This is a php docker designed to be used with the compose file present in this repository.
This is not designed to be a quick dev setup on the fly, but rather a semi-permanent setup. 💻
Built-in: phpunit, ldap, gd, imagick, APCu, redis, memcached...

We basically use the same nginx config than the documentation: https://docs.nextcloud.com/server/stable/admin_manual/installation/nginx.html
Only the php-handler server is changed to the php container

## How-to 🤔

1. Download this repository and rename it the way you want
2. Into the docker folder, clone [nextcloud server](https://github.com/nextcloud/server)
   ```sh
   git clone git@github.com:nextcloud/server.git
   ```
3. Into the `server` folder, update the 3rdparty submodule: `git submodule update --init`
   ```sh
   cd server
   git submodule update --init
   cd ..
   ```
4. Execute the stack: `docker-compose up -d`
5. Access the nextcloud through https://localhost
6. Go to the setup of your nextcloud, enter your desired username and your password
7. Enjoy contributing! 🥂 🎉 

## Using https 🔐
1. We now generate self signed certificates on start.
2. Before starting it, you can edit the domain in the `docker-compose.yml` file, check for the omgwtfssl service.
3. Currently the config is made to redirect all http traffic to https.
4. You will see an error at first because the ssl certificates are not approved by a trust entity, this is all safe, you just generated them. Approve them manually on your browser and start using your dev stack :wink:

## Retrieve a container's IP 🌐
```sh
$ docker-compose exec web hostname -i
172.20.0.3
```

## Install apps 👾
- If you want to install apps, you can directly go into your apps management
- **but** if you want to work on apps development, just clone their git repository into the apps2 folder (on the root, not on the server folder)

## Change the database config 🙌
We use mariadb by default. If you don't want it, you can:
1. Remove the db **and** phpmyadmin (if present) service form the compose file
2. Remove the `MYSQL` environment params of the php service in the compose file
3. Go to the setup of your nextcloud and choose the desired database

## OCC commands ⌨
You can run any occ command with docker (example: upgrade)
```sh
$ docker-compose exec --user=docker php php occ upgrade
```

## Phpunit ⛑
You can run the test you want with phpunit bootstrap
```sh
$ docker-compose exec --user=docker php phpunit --bootstrap tests/bootstrap.php tests/Core/Controller/ClientFlowLoginControllerTest.php
```
Or the full suite:
```sh
$ docker-compose exec php phpunit --configuration tests/phpunit-autotest.xml
```
## Access and manage the database 🗃
If you used the default setup with mariadb, you can enable phpmyadmin directly.
1. Uncomment the phpmyadmin service in your `docker-compose` file
2. Run the service: `docker-compose start phpmyadmin`
3. Retrieve phpmyadmin's IP: `docker-compose exec phpmyadmin hostname -i` (example: 172.20.0.4)
4. Open your browser and access the ip directly (e.g. http://172.20.0.4/)
5. Use your database root user (default user `root`, pass: `rootpassword`)
   The database default name is nextcloud

## Quick smtp 
Want a quick smtp server to test emails on nextcloud ? 
1. On your compose file, uncomment the smtp service and the smtp volume binding on the php service.
2. Edit your `smtp.config.php` file and change the domain by your domain
   (make sure you've set your email in your nextcloud user account)
3. Go on the nextcloud smtp settings and click the `Send test email` button!
4. You've got mail! 📫

## Troubleshooting
- *The files of the app (viewer) were not replaced correctly.* Solution: execute `git clone https://github.com/nextcloud/viewer.git` in the apps2 directory
