# Using official debian image as a parent image
FROM debian:buster

# Getting the updates for debian
RUN apt-get update

# Install services
RUN apt-get -y install \
    nginx \
    mariadb-server \
    sendmail \
    php7.4-fpm php7.4-mysql php7.4-cli php7.4-curl php7.4-gd php7.4-xml php7.4-mbstring php7.4-zip php7.4-soap php7.4-tidy php7.4-common 

#Website setup
RUN mkdir -p /var/www/pajarito/wordpress/homepage
COPY /srcs/index.html /var/www/pajarito/wordpress/homepage

#Nginx setup
COPY ./srcs/nginx.config /etc/nginx/sites-available/pajarito
COPY ./srcs/private.key /etc/nginx/ssl/private.key
COPY ./srcs/certificate.pem /etc/nginx/ssl/certificate.pem
RUN ln -s /etc/nginx/sites-available/pajarito /etc/nginx/sites-enabled/pajarito && nginx -t

# phpmyadmin setup
WORKDIR /var/www/pajarito
RUN tar -xf /srcs/phpMyAdmin-5.0.2-english.tar.gz && rm phpMyAdmin-5.0.2-english.tar.gz
RUN mv phpMyAdmin-5.0.2-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

# mysql setup
RUN service mysql start; \
	echo "CREATE DATABASE pajarito_db;" | mysql -u root; \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'diana'@'pajarito' IDENTIFIED BY '12345';" | mysql -u root; \ 
	echo "FLUSH PRIVILEGES" | mysql -u root

RUN	service mysql start; \
	mysql -uroot mysql; \
	mysqladmin password "guest"; \
		echo "CREATE DATABASE wordpress;" | mysql -u root;\
		echo "FLUSH PRIVILEGES;" | mysql -u root

# Wordpress setup
WORKDIR /var/www/pajarito/wordpress
COPY ./srcs/wp-config.php .
COPY ./srcs/wp-cli.phar /usr/local/bin/wp
RUN chmod +x wp-cli.phar
RUN wp cli update
RUN wp core download --allow-root
RUN service mysql start


https://wordpress.org/themes/sports-blog/
https://downloads.wordpress.org/theme/sports-blog.1.0.5.zip

# Sizes setup
RUN	sed -i '/upload_max_filesize/c upload_max_filesize = 20M' /etc/php/7.4/fpm/php.ini
RUN	sed -i '/post_max_size/c post_max_size = 21M' /etc/php/7.4/fpm/php.ini

# Permissions setup
RUN chown -R www-data:www-data /var/www
RUN chmod 755 -R /var/www

EXPOSE 80 443

