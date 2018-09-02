FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN cd /tmp/ \
  && apt-get update -qqy \
  && apt-get upgrade -qqy \
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen \
  && apt-get install -yqq  --no-install-recommends --no-install-suggests locales \
  && echo "LANG=\"ru_RU.UTF-8\"" > /etc/default/locale \
  && echo "LC_ALL=\"ru_RU.UTF-8\"" >> /etc/default/locale \
  && locale-gen ru_RU.UTF-8 \
  && export LANG=ru_RU.UTF-8 \
  && locale-gen --purge ru_RU.UTF-8 en_US.UTF-8 

RUN cd /tmp/ \
  && apt-get install -yqq --no-install-recommends openssh-client \
  && /usr/bin/ssh-keygen -A \
## ключ для репозитория froxlor
  && apt-get install -my gnupg wget \
  && echo 'deb http://debian.froxlor.org stretch main' > /etc/apt/sources.list.d/froxlor.list \
  && apt-key adv --keyserver pool.sks-keyservers.net --recv-key FD88018B6F2D5390D051343FF6B4A8704F9E9BBC \
  && apt-get -qqy remove wget gnupg openssh-client 

RUN cd /tmp/ \
  && apt-get update -qqy \
## включить в настройка froxlor "Use libnss-extrausers instead of libnss-mysql"
  && apt-get install -yqq froxlor cron php-mbstring php-bcmath php-xml php-zip libnss-extrausers \
    libnginx-mod-http-geoip libnginx-mod-http-image-filter \
    libnginx-mod-http-subs-filter libnginx-mod-http-upstream-fair \
    libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream nginx \
    nginx-common nginx-full \
    apache2 apache2-data apache2-utils \
    php7.0-cgi \
    php-cgi php7.0-cgi \
    bsd-mailx liblockfile-bin liblockfile1 \
    bsd-mailx liblockfile-bin liblockfile1 logrotate \
    apache2-suexec-pristine libapache2-mod-fcgid \
    libapparmor1 php-fpm \
    nscd

## создать актуальный файл froxlor.json можно командой
## /var/www/froxlor/install/scripts/config-services.php --create --froxlor-dir=/var/www/froxlor/
## источник https://github.com/Froxlor/Froxlor/issues/535
#RUN cd /tmp/ \
#  && echo '{"distro":"stretch","http":"nginx","dns":"x","smtp":"x","mail":"x","ftp":"proftpd","system":["cron","libnssextrausers","logrotate","php-fpm"]}' > froxlor.json \
#  && /var/www/froxlor/install/scripts/config-services.php --apply=froxlor.json --froxlor-dir=/var/www/froxlor/

RUN cd /tmp/ \
# extrausers
  && mkdir -p /var/lib/extrausers \
  && touch /var/lib/extrausers/passwd \
  && touch /var/lib/extrausers/group \
  && touch /var/lib/extrausers/shadow \
  && chmod 640 /var/lib/extrausers/shadow \
# Install PHPMyAdmin
  && (echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections) \
  && (echo 'phpmyadmin phpmyadmin/app-password password root' | debconf-set-selections) \
  && (echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections) \
  && (echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections) \
  && (echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections) \
  && (echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections) \
  && apt-get install -yqq phpmyadmin \
  && ln -s /usr/share/phpmyadmin /var/www/froxlor/ 
RUN cd /tmp/ \
# apache
  && sed -i -e "s|DocumentRoot /var/www/html|DocumentRoot /var/www|" /etc/apache2/sites-available/000-default.conf \
# for debug
  && apt-get install -yqq nano telnet procps \
  && echo "\nexport TERM=xterm" >> ~/.bashrc

ENTRYPOINT /opt/entrypoint.sh

COPY add/ /

