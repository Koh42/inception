FROM        alpine:3.16
RUN         apk add --no-cache vsftpd
COPY        conf/vsftpd.conf /etc/vsftpd/
COPY        tools/entrypoint.sh /usr/local/bin/
RUN         chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT  ["entrypoint.sh"]
CMD         ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
