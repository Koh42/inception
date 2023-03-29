FROM        alpine:3.16
RUN         apk add --no-cache mysql \
&&          mkdir -p /run/mysqld \
&&          chmod go+w /run/mysqld
COPY        tools/entrypoint.sh /usr/local/bin
RUN         chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT  ["entrypoint.sh"]
VOLUME      /var/lib/mysql
WORKDIR     /var/lib/mysql
CMD         ["mysqld_safe", "--user=mysql", "--console", "--skip-name-resolve", "--skip-networking=0"]
