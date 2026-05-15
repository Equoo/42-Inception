
run:
	mkdir /home/dderny/data/wordpress -p
	mkdir /home/dderny/data/mariadb -p
	docker compose --project-directory srcs/ up --build
