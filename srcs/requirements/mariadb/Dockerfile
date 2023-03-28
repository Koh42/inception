FROM        alpine:3.16
RUN         apk add --no-cache mysql \
&&          mkdir -p /run/mysqld \
&&          chmod go+w /run/mysqld
VOLUME      /var/lib/mysql
COPY        tools/entrypoint.sh /usr/local/bin
RUN         chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT  ["entrypoint.sh"]
CMD         ["/usr/bin/mysqld_safe", "--console", "--skip-name-resolve", "--skip-networking=0"]
