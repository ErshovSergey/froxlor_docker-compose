#!/bin/bash

userdata_inc_php=/var/customers/userdata.inc.php
sleep 60

# ждем пока не будет заполнен файл конфигурации
while ! [ -s $userdata_inc_php ]; do
    sleep 60 # throttle the check
done

sleep 60
/opt/services-start.sh
chown -R froxlorlocal:froxlorlocal /var/customers/userdata.inc.php

