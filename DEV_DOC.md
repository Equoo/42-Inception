
# Dev Documentation

## Setup

1. Configure services by copying .env.template into .env then edit it.
```bash
cp .env.template .env
```
2. Setup credentials: add and completes theses files in `./secrets/`:
- mysql_password
- mysql_root_password
- wp_admin_password
- wp_user_password
- gf_password
- ftp_password
3. Setup nginx certificate:
Certificate location is:<br>
`./secrets/nginx.crt`<br>
`./secrets/nginx.key`
- For Development generate one by using `./cert_gen.sh`
- For Production generate a trusted one using **Certbot** and put it in `./secrets`
```bash
certbot --nginx -d your_domain.com
```

## Docker compose usage

For images building:
```bash
make build

# or
docker compose --project-directory srcs/ build
```

Launch all containers:
```bash
make up

# or
mkdir /home/dderny/data/wordpress -p
mkdir /home/dderny/data/mariadb -p
mkdir /home/dderny/data/grafana -p
docker compose --project-directory srcs/ up -d --build
```

To stop them:
```bash
make stop

# or
docker compose --project-directory srcs/ stop
```

To stop and remove containers:
```bash
make down

# or
docker compose --project-directory srcs/ down
```

To clean every container, images and volumes use:
```bash
make clean

# or
docker compose --project-directory srcs/ down -v --rmi all
docker run --rm -it -v ${HOME}:/root alpine sh -c "rm -Rf /root/data"
```

## Storage

Permanent storage is located to `/home/$USER/data/`.
Wordpress, mariadb and grafana has each a volume.
