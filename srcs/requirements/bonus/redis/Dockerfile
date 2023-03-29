FROM		alpine:3.16
RUN 		apk add --no-cache redis
USER		redis
WORKDIR		/data
ENV			REDIS_PASS=default_passwords
ENV			REDIS_MAXMEM=42mb
CMD			redis-server --maxmemory $REDIS_MAXMEM --requirepass $REDIS_PASS
