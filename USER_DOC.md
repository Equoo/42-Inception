
# User Documentation

## Services Overview

| Service | Description | Accessible from outside |
|---------|-------------|------------------------|
| NGINX | Reverse proxy, TLS termination | Yes — `https://<login>.42.fr` (port 443) |
| WordPress + php-fpm | Web application & admin panel | Via NGINX |
| MariaDB | Database | No (internal only) |
| Redis *(bonus)* | Object cache for WordPress | No (internal only) |
| Grafana *(bonus)* | Dashboard for Wordpress and Redis monitoring | Via NGINX — `https://<login>.42.fr/grafana` |
| Adminer *(bonus)* | Database web UI | Via nginx — `https://<login>.42.fr/adminer` |
| Static site *(bonus)* | A simple and useless HTML file | Via nginx — `https://<login>.42.fr/static` |

## Starting and Stopping the Project

### Start

```bash
make
```

### Stop (keep volumes)

```bash
make down
```

### Stop and remove all data

```bash
make fclean
```

## Accessing the Services

### Website

Open your browser and navigate to:

```
https://<login>.42.fr
```

> The TLS certificate is self-signed. Your browser will show a warning — this is expected. Accept the exception to proceed.

### WordPress Administration Panel

```
https://<login>.42.fr/wp-admin
```

Log in with the administrator credentials (see [Credentials](#credentials) below).

### Adminer *(bonus)*

```
https://<login>.42.fr/adminer
```

Log in to external or internal database. Internal database host is `mariadb:3306`.

## Credentials

Credentials are **never** stored in the repository. They are kept locally in the `secrets/` directory and in `srcs/.env`.

| What | File |
|------|------|
| WordPress admin password | `secrets/wp_admin_password.txt` |
| WordPress first user password | `secrets/wp_user_password.txt` |
| MariaDB user password | `secrets/mysql_password.txt` |
| MariaDB root password | `secrets/mysql_root_password.txt` |
| Grafana admin password | `secrets/gf_password.txt` |
| FTP password | `secrets/ftp_password.txt` |


> **Never commit these files.** They are listed in `.gitignore`.

## Checking That Services Are Running

### View running containers

```bash
docker compose -f srcs/docker-compose.yml ps
```

All containers should show status `Up`.

### View logs for a specific service

```bash
docker compose -f srcs/docker-compose.yml logs <service>
# e.g.:
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

### Quick connectivity check

```bash
curl -k https://<login>.42.fr
```

A successful response (HTML or a redirect) confirms NGINX and WordPress are reachable.
