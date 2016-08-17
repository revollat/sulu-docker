# sulu-cms-docker
Dockerized Sulu CMS (http://sulu.io/) (Multisite, multilingual CMS based on Symfony full stack and CMF (http://cmf.symfony.com/)

```
docker run -d -p 80:80 --name sulu revollat/sulu-cms
```

NB : if 80 (http) is already in use you can change the first "80" with another port number available, but be warn that sulu seems to have pb when running on a non standard port (cf. https://github.com/sulu/sulu/issues/2423)

Get a shell as www-data user inside the running container
```
$ docker exec -it  sulu bash -c 'su - www-data'
```

You can now init the database
```
www-data@9291ab228319:~$ cd sulu-standard/ && app/console sulu:build dev --no-interaction
www-data@9291ab228319:~$ exit
```

You're done ! go to http://localhost (or http://localhost/admin with admin/admin)

## More informations

This docker image is for test purpose only. Don't use in production environment.

This docker image is based on the official php 5.6 image https://hub.docker.com/_/php/
Inside the container nginx, php-fpm and mysql are started using supervisord.

If you want to build the image from the source, inside the clone repo directory do :

```
docker build  --no-cache -t sulucms .
```

and then the same command as before but with sulucms instead of revollat/sulu-cms

```
docker run --rm -d -p 80:80 --name sulu sulucms
```
