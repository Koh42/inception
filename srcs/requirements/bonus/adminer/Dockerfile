FROM        alpine:3.16
WORKDIR     /app
RUN         apk add --no-cache php81 php81-session php81-mysqli \
&&          echo '<?php header("Location: adminer.php?server=".getenv("ADMINER_DEFAULT_SERVER")); ?>' > index.php \
&&          ADMINER_VERSION=4.8.1 \
&&          wget -O adminer.php \
              https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION-mysql-en.php
USER        nobody
CMD         php81 -S [::]:8000
