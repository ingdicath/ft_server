echo "Start everything"
MYSQL_PWD='guest' mysqld &
service php7.3-fpm start
nginx -g "daemon off;"






service nginx restart
service mysql restart
service php7.3-fpm restart
tail -f /dev/null

  


  
#!/bin/bash

service mysql start
service php7.3-fpm start
service nginx start
