#!/bin/sh

if [ ! -e index.php ]; then
	wp core download
fi

while [ ! -e wp-config.php ]; do
	wp config create --dbhost=$DB_HOST --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_USER_PASS || continue
	#wp db create
	wp core install --url=$DOMAIN --title="$WP_TITLE" --admin_user=$WP_ADMIN --admin_password=$WP_PASS --admin_email=$WP_EMAIL
	wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASS
	wp plugin install redis-cache --activate
	wp config set WP_REDIS_HOST $REDIS_HOST
	wp config set WP_REDIS_PORT "6379"
	wp config set WP_REDIS_DATABASE "0"
	wp config set WP_REDIS_PASSWORD "['default', '$REDIS_PASS']" --raw
	wp redis enable
	wp plugin install w3-total-cache --activate
	wp plugin delete akismet hello
	wp theme delete twentytwentyone twentytwentytwo
done

# rename domain by restart container without manually vim wp-config.php
wp config set WP_HOME https://$DOMAIN
wp config set WP_SITEURL https://$DOMAIN