FROM        alpine:3.16
RUN         apk add --no-cache php81 php81-fpm \
              php81-common php81-session php81-json php81-mysqli php81-ctype \
              php81-phar mysql-client php81-pecl-redis php81-tokenizer \
              php81-curl php81-xml php81-dom php81-iconv php81-zip php81-mbstring \
              php81-fileinfo php81-exif php81-intl php81-pecl-imagick imagemagick \
&&          wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&&          chmod +x wp-cli.phar \
&&          mv wp-cli.phar /usr/local/bin/wp \
&&          ln -s /usr/bin/php81 /usr/bin/php \
&&          ln -s /dev/stderr /var/log/php81/error.log
COPY        conf/www.conf /etc/php81/php-fpm.d/
COPY        tools/*.sh /usr/local/bin/
RUN         chmod +x /usr/local/bin/*.sh
ENTRYPOINT  ["entrypoint.sh"]
WORKDIR     /wordpress
STOPSIGNAL  SIGQUIT
CMD         ["php-fpm81", "--nodaemonize"]
