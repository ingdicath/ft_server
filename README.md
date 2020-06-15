# FT_SERVER

## Description

Webserver deployment with docker.

_This project is aimed to introduce to system administration. It will make aware of the importance of using scripts to automate tasks. For that, it will discover the "docker" technology and use it to install a complete web server. This server will run multiples services: Wordpress, phpMyAdmin, and a SQL database._


## Some terms about Docker

- _Dockerfile_ - a file that describes your steps in order to create a Docker image. It's like a recipe with all ingredients and steps necessary in making your dish.

- _Image_- the snapshot of a virtual machine, but way more lightweight. Images are the building-blocks of the containers. 
Also is containing everything needed to run an application as a container. This includes:
	-- code
	-- runtime
	-- libraries
	-- environment variables
	-- configuration files
The image can then be deployed to any Docker environment and executable as a container.

- _Container_ - the equivalent of creating a VM from a snapshot, but again, way more lightweight. Containers run the applications themselves.


## Differences between tradicional system & Docker

<p align="center">
<img src="images/table.png" width=800 >
</p>


## Useful links 

- [Tutorial docker](https://medium.com/codingthesmartway-com-blog/docker-beginners-guide-part-1-images-containers-6f3507fffc98)
- [Docker - differences between RUN vs CMD](https://goinbigdata.com/docker-run-vs-cmd-vs-entrypoint/)
- [Tips about the project](https://harm-smits.github.io/42docs/projects/ft_server)
- [Docker commands](https://www.educative.io/edpresso/how-do-you-write-a-dockerfile)
- [Tutorial ngnix](https://beauvais.me/creer-serveur-web-nginx-php7-maria-db-mysql-debian-9-stretch/)
- [Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mariadb-php-lemp-stack-on-debian-10)
- [Best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [autoindex](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html)
- [Diferrences between MySQL and MariaDB](https://www.guru99.com/mariadb-vs-mysql.html)
- [Redirect HTTP to HTTPS in Nginx](https://serversforhackers.com/c/redirect-http-to-https-nginx)
- [Create a certificate](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/)
- 

## _LINUX_

- _wget_: retrieves files from the web
- _-y --yes_: meaning say yes to all procedure

### Commands

## _DOCKER_

### Commands

- See images status: created, exited
```
$ docker ps -a
```
- Stop containers:
```
$ docker stop (ID or container name)
```
- Remove containers:
```
$ docker rm (ID or container name)
```
- Removing All Unused Objects - containers

The docker system prune command will remove all stopped containers, all dangling images, and all unused networks:
```
$ docker system prune
```
Output ⚠️
```
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all dangling images
        - all build cache
Are you sure you want to continue? [y/N]
```

- Remove an image
```
$ docker image rm (ID or image name)
```

In this case, '-f' is forcing to stop the image if it were running.
```
$ docker rmi -f (ID or image name)
```

- Listing images
```
$ docker images
```

- Start a container
```
$ docker start [ID or image name]
```

- Running a command in a running container
```
$ docker exec -it hola-pollo bash
```
Output
```
root@d44b14a29991:/#
```

- Copy content inside a container on Windows 🎭
```
$ docker run -d -p 80:80 -v /c/Users/diani/html:/usr/share/nginx/html --name nginx-custom-content nginx                                                                                                  
```

- Copy content inside a container on Mac🍏
```
$ docker run -d -p 80:80 -v ~/Users/diani/html:/usr/share/nginx/html --name nginx-custom-content nginx
```
Then, reload localhost

- Upload to Docker hub
```
$ docker tag mynginx_image2 [user_in_docker_hub]/mynginx_image2
```
```
docker push [user_in_docker_hub]/mynginx_image2
```
- Inspect Networks and other features
```
 docker inspect [ID or container name]
```

### Access to localhost ngnix

To run:
```
$ docker run --rm -d -p 80:80 --name my-nginx nginx
```

- --rm: delete existing container

- -d: Detached, it means the container runs without block the console.

- -p: port, 80:80, the first 80 means is local port. Second 80 means container port. All the traffic is mapped from the second to the first port.

- --name: the name of the container
nginx in this case, is the name of the image


#### Issues: 

##### Localhost is not found! 🛠️

- [Solve issue localhost](https://github.com/nginxinc/docker-nginx/issues/54) 
In case you have problems to run localhost in your machine, probably is because there is another name for it. To find the localhost run:

```
'docker-machine ip default' 
```

This is the address for your localhost:
```
192.168.99.100
```

When you find the address, just put this in your browser and add the port:
```
192.168.99.100:80
```

For docker-machine you can try running open "http://$(docker-machine ip default):8080" or whatever your docker machine name is.

So, accessing http://192.168.99.100:8080 showed the page.

###### Set up name for localhost on Windows 🎭 

- Press the Windows key.
- Type Notepad in the search field.
- In the search results, right-click Notepad and select Run as administrator.
- From Notepad, open the following file: c:\Windows\System32\Drivers\etc\hosts.
- Make the necessary changes to the file. Put name different to localhost (reserved keyword)
- Select File > Save to save your changes.

##### EXAMPLE 

```
$ docker run -p 8080:80 -id nginx
```

```
$ docker ps
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                           NAMES
903923b67a8a        nginx               "nginx -g 'daemon off"   5 seconds ago       Up 5 seconds        443/tcp, 0.0.0.0:8080->80/tcp   reverent_wing
```



📌🎁📢☕🍺🖇️✒️📦📄⌨️🔩🚀📋🔧

touch on Mac is 'echo $null >> index.html' on Windows

## Eval

- Verify if you can run the container with "docker run xxx" without problems. (xxx is the name of the docker you've just built)

$ docker run -d -p 80:80 my_image service nginx start
This succeeds in starting the nginx service inside the container. However, it fails the detached container paradigm in that, the root process (service nginx start) returns and the detached container stops as designed. As a result, the nginx service is started but could not be used. Instead, to start a process such as the nginx web server do the following:
$ docker run -d -p 80:80 my_image nginx -g 'daemon off;'


how do people here interpret You will also need to make sure your server is running with an index that must beable to be disabled. in ft_server? Kinda confused what they mean here (edited) 

Nginx has the habily to show you an index page of the files existing in the root folder, which can be turned on or off in the nginx config
http://nginx.org/en/docs/http/ngx_http_autoindex_module.html 


Basically you have a clean installed server. do everything you would do to install it on a new server. If you want terms to google: apt, aptitude, LAMP stack, Wordpress NGINX and Apache