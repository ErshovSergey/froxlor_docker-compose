#!/bin/bash
#set -e
echo
echo "++++++++++++++++++++ Starting container ++++++++++++++++++++"
# Time zone
echo "Europe/Moscow" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

#phpmyadmin_settings (){
#  # phpmyadmin
#  cd /usr/share/doc/phpmyadmin/examples
#  gunzip create_tables.sql.gz
#  mysql -u root -p < create_tables.sql
#  mysql -u root -p -e 'GRANT SELECT, INSERT, DELETE, UPDATE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY "wrouNQrbIU"'
#  sed -i "s|\$cfg\['Servers'\]\[\$i\]\['controluser'\].*|\$cfg\['Servers'\]\[$i\]\['controluser'\] = 'pma';|"            /etc/phpmyadmin/config.inc.php
#  sed -i "s|\$cfg\['Servers'\]\[\$i\]\['controlpass'\].*|\$cfg\['Servers'\]\[\$i\]\['controlpass'\] = 'wrouNQrbIU';|"  /etc/phpmyadmin/config.inc.php
#}

### config froxlor - userdata.inc.php
touch /var/customers/userdata.inc.php ; \
   ln -fs /var/customers/userdata.inc.php /var/www/froxlor/lib/userdata.inc.php ; \
   chown www-data:www-data /var/customers/userdata.inc.php

# если нет каталога БД mysql - создаем новую
if [[  -z "`ls /var/lib/mysql`" ]]; then
  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# добавляем в hosts домены из файлы /var/customers/domain_list.txt
[ ! -f /var/customers/domain_list.txt ] || /opt/add_domain_in_hosts.sh

service mysql start     && echo "  Start MySQL"
service cron  start     && echo "  Start cron"

# запуск сервисов
/opt/services-start.sh

# для рестарта при наличии файла настроек
/opt/froxlor_init.sh &

sleep infinity

