[![Docker Automated build](https://img.shields.io/docker/automated/skjnldsv/nextcloud-dev.svg?style=flat-square)](https://hub.docker.com/r/skjnldsv/nextcloud-dev/) [![Docker Pulls](https://img.shields.io/docker/pulls/skjnldsv/nextcloud-dev.svg?style=flat-square)](https://hub.docker.com/r/skjnldsv/nextcloud-dev/)


## This is a nextcloud development environment stack for docker🚀

This is a php docker designed to be used with the compose file present in this repository.
This is not designed to be a quick dev setup on the fly, but rather a semi-permanent setup. 💻
Built-in: ldap, gd, imagick, APCu, redis, memcached...

## How-to 🤔

1. download this repository and rename it the way you want)
2. into the folder, clone [nextcloud server](https://github.com/nextcloud/server)
3. edit the port binding of the `web` service in the compose file (default: 4443) **[optional]**
4. execute the stack: `docker-compose up -d`
5. two options now:
	- you can access the nextcloud through https://localhost:4443
	- you can get the local ip of the web service and put it to your host file 
	  alongside your ssl domain name (recommended)
6. go to the setup of your nextcloud, enter your username and your password
7. enjoy contributing! 🥂 🎉 

## Retrieve a container's IP 🌐
```sh
$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' YOUR_CONTAINER_XXX_XXXXX`
172.20.0.3
```

## Install apps 👾
- if you want to install apps, you can directly go into your apps management
- **but** if you want to work on apps, just clone their git repository into the custom_apps folder

## Change the database config 🙌
We use mariadb by default. If you don't want it, you can:
1. remove the db **and** phpmyadmin service form the compose file
2. remove the `MYSQL` environment params of the php service in the compose file
3. go to the setup of your nextcloud and choose the desired database

## Quick smtp 
Want a quick smtp server to test emails on nextcloud ? 
1. on your compose file, uncomment the smtp service and the smtp volume binding on the php service.
2. edit your `smtp.config.php` file and change the domain by your domain
3. (make sure you've set your email in your nextcloud user account)
4. go on the nextcloud smtp settings and click the `Send test email` button!
5. You've got mail! 📫
