# FT_SERVER

## Description

_This project is aimed to introduce to system administration. It will make aware of the importance of using scripts to automate tasks. For that, it will discover the "docker" technology and use it to install a complete web server. This server will run multiples services: Wordpress, phpMyAdmin, and a SQL database._

## Some terms about Docker

- dockerfile - a file that describes your steps in order to create a Docker image. It's like a recipe with all ingredients and steps necessary in making your dish.

- image - the snapshot of a virtual machine, but way more lightweight. Images are the building-blocks of the containers.

- container - the equivalent of creating a VM from a snapshot, but again, way more lightweight. Containers run the applications themselves.

## Prerequisites 📋

## Installing 🔧


## Useful links

- [Tutorial ngnix](https://beauvais.me/creer-serveur-web-nginx-php7-maria-db-mysql-debian-9-stretch/)
- [Tutorial docker](https://medium.com/codingthesmartway-com-blog/docker-beginners-guide-part-1-images-containers-6f3507fffc98)
- [Tips about the project](https://harm-smits.github.io/42docs/projects/ft_server)
- [Best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

## Commands

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
Output
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
- Listing images
```
$ docker images
```

## Access to localhost ngnix

To run:
```
$ docker run --rm -d -p 80:80 --name my-nginx nginx
```

- --rm: delete existing container

- -d: Detached, it means the container runs without block the console.

- -p: port, 80:80, the first 80 means is local port. Second 80 means container port. All the traffic is mapped from the second to the first port.

- --name: the name of the container
nginx in this case, is the name of the image


### Issues: localhost is not found! 🛠️

[Solve issue localhost](https://github.com/nginxinc/docker-nginx/issues/54) 
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


#### EXAMPLE 

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

