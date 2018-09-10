#!/bin/bash

if [ "$HTTP_SERVER" == "nginx" ]; then
  service apache2 stop
  update-rc.d apache2 disable

  service php7.0-fpm stop
  update-rc.d nginx enable
#  service php-fcgi start

  /opt/change_http-server.sh /opt/froxlor-config_nginx.json
  sed -i -e "/^http /a 	server_names_hash_bucket_size 256;" /etc/nginx/nginx.conf

  # увеличение максимального объема файла
  sed -i -e "/^http /a	client_max_body_size 200M;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a	proxy_read_timeout 120;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a	proxy_connect_timeout 120;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a	client_header_timeout 3000;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a	client_body_timeout 3000;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a	fastcgi_buffers 8 128k;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a	fastcgi_buffer_size 128k;" /etc/nginx/nginx.conf

  service nginx restart
  service php7.0-fpm start
fi

if [ "$HTTP_SERVER" == "apache" ]; then
  service nginx stop
  update-rc.d nginx disable
  service php-fcgi stop

  update-rc.d apache2 enable

  /opt/change_http-server.sh /opt/froxlor-config_apache.json
  sed -i -e "s|DocumentRoot /var/www/html|DocumentRoot /var/www|" /etc/apache2/sites-available/000-default.conf
  service apache2 restart
fi




