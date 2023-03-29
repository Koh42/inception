#!/bin/sh

adduser -h /var/lib/ftp/wordpress -s /sbin/nologin -D -H $FTP_USER
printf "${FTP_PASS}\n${FTP_PASS}" | passwd $FTP_USER
NOBODY=`id -u nobody`
sed -i "s/^\(${FTP_USER}:x:\)[^\:]\+\(.*\)/\1${NOBODY}\2/" /etc/passwd

#https://api.ipify.org crash!?
@echo Querying public IP for pasv_addr
IP=`wget -qO- https://api.my-ip.io/ip`
sed -i "s/.*pasv_address=.*/pasv_address=$IP/" /etc/vsftpd/vsftpd.conf

@echo vsftpd starts
exec "$@"
