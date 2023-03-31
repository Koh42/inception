LOGIN		:= skoh
ALPINE  	:= alpine:3.16
COMPOSE		:= docker compose --file srcs/docker-compose.yml
COLOR		:= \e[1;93m
RESET		:= \e[0m

all:
	make -s init
	$(COMPOSE) up --detach mariadb wordpress nginx
	$(COMPOSE) logs -f

bonus:
	make -s init
	$(COMPOSE) up --detach mariadb wordpress nginx redis adminer ftp static redis-commander
	$(COMPOSE) logs -f

clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker builder prune --all -f

wipe: .force
	$(COMPOSE) down
	$(COMPOSE) run --rm --no-deps mariadb sh -c 'rm -rf /var/lib/mysql/*'
	$(COMPOSE) run --rm --no-deps wordpress sh -c 'rm -rf /wordpress/*'

fclean: clean
	$(COMPOSE) down --volumes
	docker image prune --all -f

re: fclean all

eval: .force
	- docker stop $$(docker ps -qa)
	- docker rm $$(docker ps -qa)
	- docker rmi -f $$(docker images -qa)
	- docker volume rm $$(docker volume ls -q)
	- docker network rm $$(docker network ls -q)

# 1) check docker & docker compose, 2) init srcs/.env, 3) $(HOME)/data/{wordpress,mariadb}
init: .force
	if ! docker -v 2> /dev/null; then echo Please install docker then try again. && exit 1; fi
	# for linux, install docker-compose separately
	if ! (docker compose version 2> /dev/null || podman-compose version 2> /dev/null); then \
		echo Downloading Docker Compose v2; \
		mkdir -p $(HOME)/.docker/cli-plugins; \
		wget -O $(HOME)/.docker/cli-plugins/docker-compose \
			https://github.com/docker/compose/releases/latest/download/docker-compose-`uname -s`-`uname -m`; \
		chmod +x $(HOME)/.docker/cli-plugins/docker-compose; \
	fi
	make -s srcs/.env
	mkdir -p $(HOME)/data/wordpress
	mkdir -p $(HOME)/data/mariadb

srcs/.env: .force
	test -f $@ || touch $@
	grep -qw "DOMAIN" $@ || echo "DOMAIN=$(LOGIN).42.fr" >> $@
	grep -qw "DB_NAME" $@ || echo "DB_NAME=$(LOGIN)" >> $@
	grep -qw "DB_USER" $@ || echo "DB_USER=$(LOGIN)" >> $@
	grep -qw "WP_TITLE" $@ || echo "WP_TITLE=$(LOGIN) Blog" >> $@
	grep -qw "WP_ADMIN" $@ || echo "WP_ADMIN=$(LOGIN)" >> $@
	grep -qw "WP_PASS" $@ || echo "WP_PASS=`openssl rand -base64 6`" >> $@
	grep -qw "WP_EMAIL" $@ || echo "WP_EMAIL=$(LOGIN)@student.42kl.edu.my" >> $@
	grep -qw "WP_USER" $@ || echo "WP_USER=author" >> $@
	grep -qw "WP_USER_PASS" $@ || echo "WP_USER_PASS=`openssl rand -base64 6`" >> $@
	grep -qw "WP_USER_EMAIL" $@ || echo "WP_USER_EMAIL=author@$(LOGIN).42.fr" >> $@
	grep -qw "DB_USER_PASS" $@ || echo "DB_USER_PASS=`openssl rand -base64 6`" >> $@
	grep -qw "DB_ROOT_PASS" $@ || echo "DB_ROOT_PASS=`openssl rand -base64 6`" >> $@
	grep -qw "REDIS_PASS" $@ || echo "REDIS_PASS=`openssl rand -base64 6`" >> $@
	grep -qw "REDIS_WEB_USER" $@ || echo "REDIS_WEB_USER=$(LOGIN)" >> $@
	grep -qw "REDIS_WEB_PASS" $@ || echo "REDIS_WEB_PASS=`openssl rand -base64 6`" >> $@
	grep -qw "FTP_USER" $@ || echo "FTP_USER=$(LOGIN)" >> $@
	grep -qw "FTP_PASS" $@ || echo "FTP_PASS=`openssl rand -base64 6`" >> $@

info: .force
	docker system df
	docker image ls -a
	docker ps -as
	docker volume ls
	docker network ls
	$(COMPOSE) top
	#docker stats
	#docker info
	#$(COMPOSE) exec mariadb ps

help: .force
	@printf "$(COLOR)make$(RESET) run mandatory services\n"
	@printf "$(COLOR)make down$(RESET) stop & remove all services\n"
	@printf "$(COLOR)make clean$(RESET) remove images\n"
	@printf "$(COLOR)make fclean$(RESET) remove volumes\n"
	@printf "$(COLOR)make re$(RESET) start fresh\n"
	@printf "$(COLOR)make bonus$(RESET) run mandatory & bonus services\n"
	@printf "$(COLOR)make info$(RESET) show resources\n"
	@printf "$(COLOR)make shell <service>$(RESET) log into running service\n"
	@printf "$(COLOR)make <service>$(RESET) build, up & exec service\n"
	@printf "$(COLOR)make compose ...$(RESET) build/up/exec/config/ps/top/images/logs\n"
	@printf "$(COLOR)make alpine$(RESET) playground\n"
	@printf "$(COLOR)make eval$(RESET) cleanup before eval\n"
	@printf "$(COLOR)nginx, wordpress, mariadb$(RESET) mandatory services\n"
	@printf "$(COLOR)adminer, redis, ftp, static, redis-commander$(RESET) bonus services\n"

# alternate rules to avoid conflicting use of service name
ifneq (,$(findstring $(firstword $(MAKECMDGOALS)),composeshell))

# usage: make compose build nginx
# usage with options: make compose "logs nginx -f"
compose: .force
	$(COMPOSE) $(wordlist 2, 99, $(MAKECMDGOALS))

# usage: make shell nginx
shell: .force
	$(COMPOSE) exec $(word 2, $(MAKECMDGOALS)) sh

# ignore docker command and service name
.DEFAULT:
	@exit

else

nginx mariadb wordpress redis ftp adminer static redis-commander: .force
	$(COMPOSE) stop $@ || true
	$(COMPOSE) up --build -d $@
	$(COMPOSE) exec $@ sh

endif

alpine: .force
	docker run -it --rm -v $(PWD):/inception $(ALPINE)

check: .force
	#grep -R ^FROM srcs/requirements
 	#find srcs/requirements -type f -name Dockerfile -exec sed -i '/^FROM/s/.*/FROM $(ALPINE)/' {} +
	find . -name Dockerfile -print -exec head -1 {} \;
	find . -name entrypoint.sh -print -exec tail -1 {} \;

.PHONY: all bonus clean fclean re
.force: ;
