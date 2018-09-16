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

### настройки для msmtp
[ -f /var/customers/msmtprc ] || cp /var/customers/msmtprc.default /var/customers/msmtprc

### сертификат для работа Let's encrypt
[ -f /etc/apache2/apache2.key ] || [ -f /etc/nginx/sites-enabled/nginx.pem ] || \
    openssl req -x509 -newkey rsa:2048 \
    -days 3650 -nodes \
    -keyout /etc/apache2/apache2.key   \
    -out /etc/nginx/nginx.pem \
    -subj "/C=RU/ST=Some-City/O=Internet Didgits Ltd/CN=Froxlor"

# добавляем в hosts домены из файлы /var/customers/domain_list.txt
[ ! -f /var/customers/domain_list.txt ] || /opt/add_domain_in_hosts.sh

# файл для доменных имён в froxlor
[ -f /var/customers/domain_list.txt ] || touch /var/customers/domain_list.txt

# файл ACL для доступа к доменным именам
touch /var/customers/ACL.conf ; \
   ln -fs /var/customers/ACL.conf /etc/nginx/conf.d/ACL.conf ; 
#   chown www-data:froxlorlocal /var/customers/ACL.conf

service mysql start     && echo "  Start MySQL"
service cron  start     && echo "  Start cron"

# запуск сервисов
/opt/services-start.sh

# для рестарта при наличии файла настроек
/opt/froxlor_init.sh &


sleep infinity

