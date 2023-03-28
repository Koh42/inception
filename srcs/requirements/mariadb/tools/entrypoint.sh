#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql /run/mysqld
chown -R mysql /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
	mysql_install_db --ldata=/var/lib/mysql > /dev/null
	DB_ROOT_PASS=${INIT_DB_ROOT_PASS}
	DB_USER=${INIT_DB_USER:-user}
	DB_USER_PASS=${INIT_DB_USER_PASS:-password}
	DB_NAME=${INIT_DB_NAME:-$DB_USER}

	cat <<END > /tmp/sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
END
	mysqld --bootstrap < /tmp/sql
	rm -f /tmp/sql
fi

exec "$@"
