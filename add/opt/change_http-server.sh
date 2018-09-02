#!/bin/bash

#cd /tmp/
#echo '{"distro":"stretch","http":"nginx","dns":"x","smtp":"x","mail":"x","ftp":"proftpd","system":["cron","libnssextrausers","logrotate","php-fpm"]}' > froxlor.json
/var/www/froxlor/install/scripts/config-services.php --apply=$1 --froxlor-dir=/var/www/froxlor/

#rm /tmp/froxlor.json

service apache2 stop
update-rc.d apache2 disable

update-rc.d nginx enable
service nginx start
service php-fcgi restart


sed  -i  '/IfModule mod_sql.c/a Include /etc/proftpd/sftp.conf'  /etc/proftpd/sql.conf
service proftpd restart
