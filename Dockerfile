# Using official debian image as a parent image
FROM debian:buster

# Getting the updates for debian
RUN apt-get update

# Install services
RUN apt-get -y install \
    nginx \
    mariadb-server \
    sendmail \
    php-fpm php-mysql php-cli php-mbstring

# website setup
WORKDIR /var/www/pajarito/
COPY ./srcs/index.html .
COPY ./srcs/image ./image

#Nginx setup
COPY ./srcs/nginx.config /etc/nginx/sites-available/pajarito
COPY ./srcs/private.key /etc/nginx/ssl/private.key
COPY ./srcs/certificate.pem /etc/nginx/ssl/certificate.pem
RUN ln -s /etc/nginx/sites-available/pajarito /etc/nginx/sites-enabled/pajarito && nginx -t

# mysql setup
RUN service mysql start; \
	echo "CREATE DATABASE pajarito_db;" | mysql -u root; \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'diana'@'localhost' IDENTIFIED BY '12345';" | mysql -u root; \ 
	echo "CREATE DATABASE phpMyAdmin" | mysql -u root; \
	echo "FLUSH PRIVILEGES" | mysql -u root

# phpmyadmin setup
COPY ./srcs/phpMyAdmin-5.0.2-english.tar.gz .
RUN tar -xf phpMyAdmin-5.0.2-english.tar.gz && rm phpMyAdmin-5.0.2-english.tar.gz
RUN mv phpMyAdmin-5.0.2-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

# Wordpress setup
COPY ./srcs/wp-cli.phar .
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN wp cli update
WORKDIR /var/www/pajarito/wordpress
RUN service mysql start && \
    wp core download --allow-root && \
    wp config create --allow-root --dbhost=localhost --dbname=pajarito_db --dbuser=diana --dbpass=12345 && \
	mysql < /var/www/pajarito/phpmyadmin/sql/create_tables.sql && \
	wp core install --allow-root --url=https://localhost/wordpress --title="Welcome Pajarito" --admin_name=diana --admin_password=12345 --admin_email=dianitasale@gmail.com && \
	chmod 664 wp-config.php && \
	wp theme --allow-root activate twentyseventeen

# Sizes setup
RUN cd /etc/php/7.3/fpm && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 15M/g' php.ini && \
	sed -i 's/post_max_size = 8M/post_max_size = 25M/g' php.ini

# Access setup
RUN chown -R www-data:www-data /var/www/pajarito/*
RUN chmod 755 -R /var/www/pajarito/*

EXPOSE 80 443 25

# Start program

ENTRYPOINT service php7.3-fpm start && \
	service nginx start && \
	service mysql start && \
	service sendmail start && \
	bash