# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: dsalaman <dsalaman@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/05/20 14:54:55 by dsalaman      #+#    #+#                  #
#    Updated: 2020/06/14 21:41:51 by anonymous     ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

# Install container OS debian 
FROM debian:buster

# Check for updates
RUN apt-get update && apt-get -y upgrade

# Install
RUN apt-get -y install \
    php7.3 php-mysql php-fpm php-cli php-mbstring php-curl php-gd php-intl php-soap php-xml php-xmlrpc php-zip \
    php7.3-fpm php7.3-cli php7.3-mysql php7.3-gd php7.3-imagick php7.3-recode php7.3-tidy php7.3-xmlrpc php7.3-mbstring \
    nginx \
    mariadb-server \
    wget \
    sendmail








nginx
COPY ./srcs/nginx.config /etc/nginx/sites-available/localhost

# Install SSL



# Install MySQL
RUN apt-get -y install default-mysql-server

# Install some tools
RUN apt-get -y install wget sendmail

# Install Wordpress

https://wordpress.org/themes/sports-blog/
https://downloads.wordpress.org/theme/sports-blog.1.0.5.zip

# Install phpMyAdmin
RUN apt-get -y install php7.3-fpm php-common php-mysql php-mbstring




# Configure permissions

