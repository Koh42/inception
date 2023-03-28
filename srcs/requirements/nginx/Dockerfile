FROM        alpine:3.16
RUN         apk add --no-cache nginx openssl \
&&			ln -sf /dev/stdout /var/log/nginx/access.log \
&&			ln -sf /dev/stderr /var/log/nginx/error.log
COPY        conf/nginx.conf /etc/nginx/http.d/
COPY        tools/entrypoint.sh /usr/local/bin/
RUN         chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT  ["entrypoint.sh"]
STOPSIGNAL  SIGQUIT
CMD         ["nginx", "-g", "daemon off;"]
