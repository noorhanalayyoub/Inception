.PHONY: build up stop clean fclean

build:
	docker compose -f ./srcs/docker-compose.yaml build

up:
	docker compose -f ./srcs/docker-compose.yaml up
	
stop:
	docker compose -f ./srcs/docker-compose.yaml stop

clean:
	docker compose -f ./srcs/docker-compose.yaml down 

fclean:
	docker compose -f ./srcs/docker-compose.yaml down -v
	docker system prune -a
	rm -rf /home/nalayyou/data/mariadb/*
	rm -rf /home/nalayyou/data/wordpress/*
