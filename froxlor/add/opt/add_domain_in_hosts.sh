#!/bin/bash
# 1 параметр - hostname
# удаляем строку содержащую hostname
# добавляем строку с текущим адресом

# добавляем домен в hosts
add_to_hosts () {
  if [ ! -z "$1" ] # Длина строки не равна 0 - добавляем
  then
    # hostname
    HOSTNAME=$1

    echo "Add host name ${HOSTNAME} in /etc/hosts"

    # локальный ip адрес
    IP=`hostname -I`

    # копируем /etc/hosts
    cp /etc/hosts /tmp/hosts.new

    # удаляем строку
    sed -i "/[\t]$HOSTNAME/d" /tmp/hosts.new

    # добавляем строку
    echo "$IP	$HOSTNAME" >> /tmp/hosts.new

    # возвращаем на место
    cp -f /tmp/hosts.new /etc/hosts
    rm /tmp/hosts.new
  fi
}

# добавляем все домены из файла в host
FILE=/var/customers/domain_list.txt
if [ -f ${FILE} ] ; then 
  while read LINE; do
    add_to_hosts ${LINE}
  done < ${FILE}
fi

