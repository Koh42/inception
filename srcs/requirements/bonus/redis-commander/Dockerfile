FROM 	alpine:3.16
RUN		apk add --no-cache nodejs npm
WORKDIR	/app
RUN		npm install redis-commander \
&&		chown nobody:nobody node_modules/redis-commander/config
USER	nobody
ENV		REDIS_HOST=redis
ENV		REDIS_PORT=6379
ENV		REDIS_PASS=default_password
ENV		WEB_USER=default_user
ENV		WEB_PASS=default_password
EXPOSE	80
CMD		node node_modules/redis-commander/bin/redis-commander --port 80 \
		  --redis-port $REDIS_PORT --redis-host $REDIS_HOST \
		  --redis-username default --redis-password $REDIS_PASS \
		  --http-auth-username $WEB_USER --http-auth-password $WEB_PASS
