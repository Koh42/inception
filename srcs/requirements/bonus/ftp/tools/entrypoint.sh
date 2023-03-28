#!/bin/sh

adduser -h /wordpress -s /sbin/nologin -u $FTP_UID -D -H $FTP_USER
printf "${FTP_PASS}\n${FTP_PASS}" | passwd $FTP_USER

IP=`wget -qO- https://api.ipify.org`
echo pasv_address=$IP >> /etc/vsftpd/vsftpd.conf

exec "$@"
