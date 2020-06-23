echo "Initializing pajarito webserver"
MYSQL_PWD='guest' mysqld &
service php-fpm start
nginx -g "daemon off;"