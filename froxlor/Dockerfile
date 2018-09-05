FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN cd /tmp/ \
  && apt-get update -qqy \
  && apt-get upgrade -qqy \
# локаль
  && apt-get install -yqq  --no-install-recommends --no-install-suggests locales apt-utils 

ENV LANG='ru_RU.UTF-8' LANGUAGE='ru_RU.UTF-8' LC_ALL='ru_RU.UTF-8'
RUN echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen
# локаль

RUN cd /tmp/ \
## ключ для репозитория froxlor
  && apt-get install -yqq --no-install-recommends openssh-client \
  && /usr/bin/ssh-keygen -A \
  && apt-get install -my gnupg wget 
RUN cd /tmp/ \
  && echo 'deb http://debian.froxlor.org stretch main' > /etc/apt/sources.list.d/froxlor.list \
  && apt-key adv --keyserver pool.sks-keyservers.net --recv-key FD88018B6F2D5390D051343FF6B4A8704F9E9BBC \
  && apt-get -qqy remove wget gnupg openssh-client 

RUN cd /tmp/ \
  && apt-get update -qqy \
# froxlor
  && apt-get install -yqq froxlor cron php-mbstring php-bcmath php-xml php-zip libnss-extrausers \
    libnginx-mod-http-geoip libnginx-mod-http-image-filter \
    libnginx-mod-http-subs-filter libnginx-mod-http-upstream-fair \
    libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream nginx \
    nginx-common nginx-full \
    apache2 apache2-data apache2-utils \
    php7.0-cgi \
    php-cgi php7.0-cgi \
    bsd-mailx liblockfile-bin liblockfile1 logrotate \
    apache2-suexec-pristine libapache2-mod-fcgid \
    libapparmor1 php-fpm \
    nscd \
# froxlor
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
  && apt-get update -qqy \
# for debug
  && apt-get install -yqq nano telnet procps 
#  && echo "\nexport TERM=xterm" >> ~/.bashrc 

ENTRYPOINT /opt/entrypoint.sh

COPY add/ /
