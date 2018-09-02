[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/github.com/ErshovSergey/master/LICENSE) ![Language](https://img.shields.io/badge/language-bash-yellowgreen.svg)
# froxlor_debian8
Открытая система управления хостингом froxlor, конкретнее [froxlor Server Management Panel](https://www.froxlor.org/) на [Debian 8](https://www.debian.org/releases/stable/).

##Описание
Открытая система управления хостингом froxlor, конкретнее [froxlor Server Management Panel](https://www.froxlor.org/) запускается на [Debian 8](https://www.debian.org/releases/stable/), также доступен FTP для клиентов, точнее sftp на 21 порту. Настройки хранятся вне контейнера. Для резервного копирования можно использовать bareos-fd.
#Эксплуатация данного проекта.
##Клонируем проект
```shell
git clone https://DockerImage@bitbucket.org/DockerImage/froxlor_debian8.git
```
##Настройки
Устанавливаем настройки в файле .env

Включить в настройка froxlor "Use libnss-extrausers instead of libnss-mysql"

## http сервер
По умолчанию используется в качестве http сервера используется apache.
Для использования в качестве http сервера nginx необходимо запустить команду
docker exec -i -t <имя docker> /opt/change_http-server.sh /opt/froxlor-config_nginx.json
для использования apache
docker exec -i -t <имя docker> /opt/change_http-server.sh /opt/froxlor-config_apache.json

Cоздать актуальный файл froxlor.json можно командой
/var/www/froxlor/install/scripts/config-services.php --create --froxlor-dir=/var/www/froxlor/
источник https://github.com/Froxlor/Froxlor/issues/535


## FTP сервер
Для доступа к файлам используется sftp сервер, в качестве сервера proftpd настроенный по 
https://forum.froxlor.org/index.php?/topic/12753-configuring-proftpd-to-act-as-sftp-server/


##Собираем
```shell
cd froxlor_debian8/
docker build --rm=true --force-rm --tag=ershov/froxlor_debian8 .
```
Создаем папку для хранения настроек, логов и отчетов вне контейнера
```shell
export SHARE_DIR="/mnt/sdb/DOCKER_DATA/bareos16-debian8" && mkdir -p $SHARE_DIR
```
Правим файлы настроек:
 - *$/SHARE_DIR/msmtprc* - настройки **msmtp** для отправки почты от bareos
 - *$SHARE_DIR/web-admin.conf* - пароль от web-консоли
 - *$SHARE_DIR/etc-bareos/bareos-dir.d/* - настройки директора
 - *$SHARE_DIR/etc-bareos/bareos-fd.d//* - настройки клиента

##Запускаем
Определяем ip адрес на котором будет доступна web-управление и папку для хранения БД и конфигурационных файлов
```shell
export ip=192.168.100.240
docker run --name froxlor -di --restart=always \
-h froxlor.erchov.ru \
-v /mnt/sdb/DOCKER_DATA/froxlor_debian8:/SHARE \
-p $ip:9109:9102 \
-p $ip:80:80 \
-p $ip:443:443 \
-p $ip:2121:21 \
--net homenet \
--ip="192.168.1.5" \
-e MYSQL_ROOT_PASSWORD='wrouNQrbIU' ershov/froxlor_debian8
```

###Перечитать конф.файлы директора **bareos-dir**
```shell
docker exec -i -t bareos16-debian8 /etc/init.d/bareos-dir reload
```
##Удалить контейнер
```shell
docker stop froxlor; docker rm -v froxlor
```
Если файлов настройки не существуют - используются файлы "по-умолчанию".
### <i class="icon-upload"></i>Ссылки
 -  [froxlor](https://www.froxlor.org/)
 - [bareos версии 16](https://www.bareos.org/en/news/bareos-16-2-4-major-version-released.html)
 - [Debian 8](https://www.debian.org/releases/stable/)
 - [docker](https://www.docker.com/)
 - [Запись в блоге](https://)
 - [Редактор readme.md](https://stackedit.io/)

### <i class="icon-refresh"></i>Лицензия MIT

> Copyright (c) 2016 &lt;[ErshovSergey](http://github.com/ErshovSergey/)&gt;

> Данная лицензия разрешает лицам, получившим копию данного программного обеспечения и сопутствующей документации (в дальнейшем именуемыми «Программное Обеспечение»), безвозмездно использовать Программное Обеспечение без ограничений, включая неограниченное право на использование, копирование, изменение, добавление, публикацию, распространение, сублицензирование и/или продажу копий Программного Обеспечения, также как и лицам, которым предоставляется данное Программное Обеспечение, при соблюдении следующих условий:

> Указанное выше уведомление об авторском праве и данные условия должны быть включены во все копии или значимые части данного Программного Обеспечения.

> ДАННОЕ ПРОГРАММНОЕ ОБЕСПЕЧЕНИЕ ПРЕДОСТАВЛЯЕТСЯ «КАК ЕСТЬ», БЕЗ КАКИХ-ЛИБО ГАРАНТИЙ, ЯВНО ВЫРАЖЕННЫХ ИЛИ ПОДРАЗУМЕВАЕМЫХ, ВКЛЮЧАЯ, НО НЕ ОГРАНИЧИВАЯСЬ ГАРАНТИЯМИ ТОВАРНОЙ ПРИГОДНОСТИ, СООТВЕТСТВИЯ ПО ЕГО КОНКРЕТНОМУ НАЗНАЧЕНИЮ И ОТСУТСТВИЯ НАРУШЕНИЙ ПРАВ. НИ В КАКОМ СЛУЧАЕ АВТОРЫ ИЛИ ПРАВООБЛАДАТЕЛИ НЕ НЕСУТ ОТВЕТСТВЕННОСТИ ПО ИСКАМ О ВОЗМЕЩЕНИИ УЩЕРБА, УБЫТКОВ ИЛИ ДРУГИХ ТРЕБОВАНИЙ ПО ДЕЙСТВУЮЩИМ КОНТРАКТАМ, ДЕЛИКТАМ ИЛИ ИНОМУ, ВОЗНИКШИМ ИЗ, ИМЕЮЩИМ ПРИЧИНОЙ ИЛИ СВЯЗАННЫМ С ПРОГРАММНЫМ ОБЕСПЕЧЕНИЕМ ИЛИ ИСПОЛЬЗОВАНИЕМ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ ИЛИ ИНЫМИ ДЕЙСТВИЯМИ С ПРОГРАММНЫМ ОБЕСПЕЧЕНИЕМ.

