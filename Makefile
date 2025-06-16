COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/ozdemir/data

all: build up

build:
	@echo "Building containers..."
	@mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	@docker-compose -f $(COMPOSE_FILE) build

up:
	@echo "Starting containers..."
	@docker-compose -f $(COMPOSE_FILE) up -d

down:
	@echo "Stopping containers..."
	@docker-compose -f $(COMPOSE_FILE) down

clean: down
	@echo "Cleaning containers and images..."
	@docker system prune -af

fclean: clean
	@echo "Removing volumes..."
	@docker volume prune -f
	@sudo rm -rf $(DATA_PATH)

re: fclean all

logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

status:
	@docker-compose -f $(COMPOSE_FILE) ps

.PHONY: all build up down clean fclean re logs status
