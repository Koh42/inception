#!/bin/sh
if [ "$1" = "php-fpm81" ]; then
	#su -s /bin/sh nobody -c 
	/usr/local/bin/setup_wordpress.sh
	chown -R nobody:nobody .
fi
exec "$@"
