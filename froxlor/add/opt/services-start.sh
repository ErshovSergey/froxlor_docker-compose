#!/bin/bash

if [ "$HTTP_SERVER" == "nginx" ]; then
  service apache2 stop
  update-rc.d apache2 disable

  update-rc.d nginx enable
#  service nginx start
#  service php-fcgi start

  /opt/change_http-server.sh /opt/froxlor-config_nginx.json
fi

if [ "$HTTP_SERVER" == "apache" ]; then
  service nginx stop
  update-rc.d nginx disable
  service php-fcgi stop

  update-rc.d apache2 enable
#  service apache2 start

  /opt/change_http-server.sh /opt/froxlor-config_apache.json
fi




