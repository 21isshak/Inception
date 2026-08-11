all: up

up: build
	@mkdir -p /home/iskaraag/data/wordpress
	@mkdir -p /home/iskaraag/data/mariadb
	docker compose -f srcs/docker-compose.yml up -d

build:
	docker compose -f srcs/docker-compose.yml build

down:
	docker compose -f srcs/docker-compose.yml down

start:
	docker compose -f srcs/docker-compose.yml start

stop:
	docker compose -f srcs/docker-compose.yml stop

restart: down up

logs:
	docker compose -f srcs/docker-compose.yml logs -f

status:
	docker compose -f srcs/docker-compose.yml ps

ps: status

clean: down
	docker system prune -a --force

fclean: clean
	@sudo rm -rf /home/iskaraag/data/wordpress/*
	@sudo rm -rf /home/iskaraag/data/mariadb/*
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

help:
	@echo "Inception Makefile targets:"
	@echo "  make / make all - prepare data directories and start everything"
	@echo "  make build      - build all images without starting them"
	@echo "  make up         - create data directories, then build+start all containers"
	@echo "  make down       - stop and remove containers without removing volumes"
	@echo "  make start      - start existing containers without rebuilding"
	@echo "  make stop       - stop existing containers without rebuilding"
	@echo "  make restart    - down then up"
	@echo "  make logs       - follow logs of all services"
	@echo "  make status     - list container status"
	@echo "  make ps         - list container status"
	@echo "  make clean      - down and prune docker resources"
	@echo "  make fclean     - clean and wipe images/volumes and wipe data directories"
	@echo "  make re         - fclean then all"

.PHONY: all up build down start stop restart logs status ps clean fclean re help
