# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: dsalaman <dsalaman@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/05/20 14:54:55 by dsalaman      #+#    #+#                  #
#    Updated: 2020/06/18 18:56:27 by anonymous     ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

# Using official debian image as a parent image
FROM debian:buster

# Getting the updates for debian
RUN apt-get update

# Install services
RUN apt-get -y install \
    nginx \
    mariadb-server \
    wget \
    sendmail \
    php7.3 php-mysql php-fpm php-cli php-mbstring php-curl php-gd php-intl php-soap php-xml php-xmlrpc php-zip \
    php7.3-fpm php7.3-cli php7.3-mysql php7.3-gd php7.3-imagick php7.3-recode php7.3-tidy php7.3-xmlrpc php7.3-mbstring 

COPY ./srcs/nginx.config /etc/nginx/sites-available/localhost
COPY ./srcs/private.key /etc/nginx/ssl/private.key
COPY ./srcs/certificate.pem /etc/nginx/ssl/certificate.pem

RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost && nginx -t

# Configure phpmyadmin
WORKDIR /var/www/html
RUN tar -xf phpMyAdmin-5.0.2-english.tar.gz
RUN rm phpMyAdmin-5.0.2-english.tar.gz

# Install Wordpress

https://wordpress.org/themes/sports-blog/
https://downloads.wordpress.org/theme/sports-blog.1.0.5.zip

# Install phpMyAdmin
RUN apt-get -y install php7.3-fpm php-common php-mysql php-mbstring




# Configure permissions

EXPOSE 80 443

