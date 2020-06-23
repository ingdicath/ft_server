# Using official debian image as a parent image
FROM debian:buster

# Getting the updates for debian
RUN apt-get update

# Install services
RUN apt-get -y install \
    nginx \
    mariadb-server \
    sendmail \
    php-fpm php-mysql php-cli php-curl php-gd php-xml php-mbstring php-zip php-soap php-common

#Nginx setup
COPY ./srcs/nginx.config /etc/nginx/sites-available/pajarito
COPY ./srcs/private.key /etc/nginx/ssl/private.key
COPY ./srcs/certificate.pem /etc/nginx/ssl/certificate.pem
RUN ln -s /etc/nginx/sites-available/pajarito /etc/nginx/sites-enabled/pajarito && nginx -t

# mysql setup
RUN service mysql start; \
	echo "CREATE DATABASE pajarito_db;" | mysql -u root; \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'diana'@'localhost' IDENTIFIED BY '12345';" | mysql -u root; \ 
    echo "FLUSH PRIVILEGES" | mysql -u root

# phpmyadmin setup
WORKDIR /var/www/pajarito/
COPY ./srcs/phpMyAdmin-5.0.2-english.tar.gz .
RUN tar -xf phpMyAdmin-5.0.2-english.tar.gz && rm phpMyAdmin-5.0.2-english.tar.gz
RUN mv phpMyAdmin-5.0.2-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

# website setup
WORKDIR /var/www/pajarito/wordpress
COPY ./srcs/index.html .
# COPY ./srcs/wp-config.php . es posible que no se utilice este archivo

# Wordpress setup
RUN mv ./srcs/wp-cli.phar /usr/local/bin/wp
RUN chmod +x wp
RUN wp cli update
WORKDIR /var/www/pajarito/wordpress
RUN service mysql start && \
    wp core download --allow-root && \
    wp config create --allow-root --dbhost=localhost --dbname=pajarito_db --dbuser=diana --dbpass=12345 &&\
	wp core install --allow-root --url=https://localhost/wordpress --title="Welcome" --admin_name=diana --admin_password=12345 --admin_email=dianitasale@gmail.com &&\
	chmod 664 wp-config.php &&\
	wp theme --allow-root install https://downloads.wordpress.org/theme/sports-blog.1.0.5.zip &&\
	wp theme --allow-root activate sports-blog

# Sizes setup
RUN	sed -i '/upload_max_filesize/c upload_max_filesize = 20M' /etc/php/7.3/fpm/php.ini
RUN	sed -i '/post_max_size/c post_max_size = 20M' /etc/php/7.3/fpm/php.ini

# Access setup
RUN chown -R www-data:www-data /var/www/*
RUN chmod 755 -R /var/www/*

EXPOSE 80 443

# Start program
COPY ./srcs/init_services.sh /root/
CMD bash /root/init_services.sh




service nginx restart
service mysql restart
service php7.3-fpm restart
tail -f /dev/null
  
#!/bin/bash

service mysql start
service php7.3-fpm start
service nginx start
