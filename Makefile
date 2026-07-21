
up:
	mkdir $(HOME)/data/wordpress -p
	mkdir $(HOME)/data/mariadb -p
	mkdir $(HOME)/data/grafana -p
	docker compose --project-directory srcs/ up -d --build

build:
	docker compose --project-directory srcs/ build

stop:
	docker compose --project-directory srcs/ stop

down:
	docker compose --project-directory srcs/ down

clean:
	docker compose --project-directory srcs/ down -v --rmi all

fclean: clean
	docker run --rm -it -v ${HOME}:/root alpine sh -c "rm -Rf /root/data"
