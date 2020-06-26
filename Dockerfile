# Using official debian image as a parent image
FROM debian:buster

# Getting the updates for debian
RUN apt-get update

# Install services
RUN apt-get -y install \
    nginx \
    mariadb-server \
    sendmail \
    php-fpm php-mysql php-cli

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
WORKDIR /var/www/html/pajarito/
COPY ./srcs/phpMyAdmin-5.0.2-english.tar.gz .
RUN tar -xf phpMyAdmin-5.0.2-english.tar.gz && rm phpMyAdmin-5.0.2-english.tar.gz
RUN mv phpMyAdmin-5.0.2-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

# website setup
WORKDIR /var/www/html/pajarito/wordpress
COPY ./srcs/index.html .
COPY ./srcs/image/duck_404.jpg .

# Wordpress setup
COPY ./srcs/wp-cli.phar .
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN wp cli update
RUN service mysql start && \
    wp core download --allow-root && \
    wp config create --allow-root --dbhost=localhost --dbname=pajarito_db --dbuser=diana --dbpass=12345 &&\
	wp core install --allow-root --url=https://pajarito/wordpress --title="Welcome" --admin_name=diana --admin_password=12345 --admin_email=dianitasale@gmail.com &&\
	chmod 664 wp-config.php &&\
	wp theme --allow-root install https://downloads.wordpress.org/theme/sports-blog.1.0.5.zip &&\
	wp theme --allow-root activate sports-blog

# Sizes setup
RUN sed -i 's/.*upload_max_filesize.*/upload_max_filesize = 20M/' /etc/php/7.3/fpm/php.ini
RUN sed -i 's/.*post_max_size.*/post_max_size = 20M/' /etc/php/7.3/fpm/php.ini

# Access setup
RUN chown -R www-data:www-data /var/www/*
RUN chmod 755 -R /var/www/*

EXPOSE 80 443

# Start program

RUN echo "Initializing pajarito webserver"
ENTRYPOINT service php7.3-fpm start && \
	service nginx start && \
	service mysql start && \
	bash