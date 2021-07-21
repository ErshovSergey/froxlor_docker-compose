FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

# локаль
RUN cd /tmp/ \
  && apt-get update -qqy \
  && apt-get upgrade -qqy \
# локаль
  && apt-get install -yqq  --no-install-recommends --no-install-suggests locales apt-utils 

ENV LANG='ru_RU.UTF-8' LANGUAGE='ru_RU.UTF-8' LC_ALL='ru_RU.UTF-8'
RUN echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen

RUN cd /tmp/ \
  && apt-get install -yqq --no-install-recommends openssh-client \
  && /usr/bin/ssh-keygen -A \
  && apt-get install -yqq -my gnupg wget apt-transport-https \
## ключ для репозитория froxlor
#  && echo 'deb http://debian.froxlor.org stretch main' > /etc/apt/sources.list.d/froxlor.list \
#  && gpg --no-tty --keyserver pool.sks-keyservers.net --recv F6B4A8704F9E9BBC \
#  && gpg --export --armor F6B4A8704F9E9BBC | apt-key add - \
  && apt-get update -qqy 

RUN cd /tmp/ \
  && apt-get -yq install php

RUN cd /tmp/ \
## установка php5
  && wget -O- https://packages.sury.org/php/apt.gpg | apt-key add - \
  && echo 'deb https://packages.sury.org/php/ stretch main' > /etc/apt/sources.list.d/deb.sury.org.list \
RUN cd /tmp/ \
  && apt-get update \
  && apt-get -yqq install php5.6 php5.6-cgi php5.6-apcu php5.6-mbstring php5.6-bcmath php5.6-cli php5.6-curl \
                         php5.6-fpm php5.6-gd php5.6-intl php5.6-mcrypt php5.6-mysql php5.6-soap php5.6-xml \
                         php5.6-zip php5.6-memcache php5.6-memcached php5.6-zip 

RUN cd /tmp/ \
  && apt-get -qy install apt-transport-https lsb-release ca-certificates gnupg \
  && wget -O - https://deb.froxlor.org/froxlor.gpg | apt-key add - \
  && echo "deb https://deb.froxlor.org/debian $(lsb_release -sc) main" > /etc/apt/sources.list.d/froxlor.list \
  && apt-get update -qqy





RUN cd /tmp/ \
  && apt-get update -qqy \
# froxlor
  && apt-get install -yq froxlor cron php-mbstring php-bcmath php-xml php-zip libnss-extrausers \
  && apt-get install -yq froxlor cron php-mbstring php-bcmath php-xml php-zip libnss-extrausers \
    libnginx-mod-http-geoip libnginx-mod-http-image-filter \
    libnginx-mod-http-subs-filter libnginx-mod-http-upstream-fair \
    libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream nginx \
    nginx-common nginx-full \
    apache2 apache2-data apache2-utils \
    php-cgi php-mysql php-curl \
    bsd-mailx liblockfile-bin liblockfile1 logrotate \
    apache2-suexec-pristine libapache2-mod-fcgid \
    libapparmor1 php-fpm \
    nscd \
    curl \
    msmtp \
    bareos-filedaemon \
# froxlor
  && addgroup --gid 9999 froxlorlocal \
  && adduser --no-create-home --uid 9999 --ingroup froxlorlocal --shell /bin/false --disabled-password --gecos '' froxlorlocal \
  && adduser www-data froxlorlocal \
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
  && ln -s /usr/share/phpmyadmin /var/www/froxlor/ \
# удаляем лишнее
  && apt-get autoremove -qqy \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* 

RUN cd /tmp/ \
  && sed -i -e "s|;upload_tmp_dir =*|upload_tmp_dir = /tmp|"           /etc/php/8.0/fpm/php.ini \
  && sed -i -e "s|^upload_max_filesize .*|upload_max_filesize = 500M|" /etc/php/8.0/fpm/php.ini \
  && sed -i -e "s|^max_execution_time .*|max_execution_time = 120|"    /etc/php/8.0/fpm/php.ini \
  && sed -i -e "s|^post_max_size .*|post_max_size = 128M|"             /etc/php/8.0/fpm/php.ini \
  && sed -i -e "s|^default_socket_timeout .*|default_socket_timeout = 120|"    /etc/php/8.0/fpm/php.ini 

#  && apt -qqy remove wget gnupg openssh-client curl apt-transport-https ca-certificates \
#  && apt-get autoremove -qqy 


RUN cd /tmp/ \
  && apt-get update -qqy \
# for debug
  && apt-get install -yqq nano telnet procps 
#  && echo "\nexport TERM=xterm" >> ~/.bashrc 

ENTRYPOINT /opt/entrypoint.sh

COPY add/ /
