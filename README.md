*This project has been created as part of the 42 curriculum by dderny.*

# Inception

## Description

**Inception** is a System Administration project from the 42 curriculum whose goal is to build a small, production-style web infrastructure entirely with Docker, orchestrated by Docker Compose.
 
Each service of the stack runs in its own container, built from a custom Dockerfile (no pre-built images from Docker Hub are used, aside from the base Alpine/Debian image). The mandatory stack is composed of three containers:
 
- **NGINX** — the single entry point of the infrastructure, exposed on port 443 and configured to accept TLSv1.2/TLSv1.3 only.
- **WordPress + php-fpm** — the application layer, installed and configured without any embedded web server.
- **MariaDB** — the database layer, storing the WordPress data.
Two Docker named volumes persist data on the host (under `/home/<login>/data`): one for the WordPress database, one for the WordPress site files. All containers communicate through a dedicated Docker network, restart automatically on failure, and rely on environment variables and Docker secrets instead of hard-coded credentials.
 
On top of the mandatory part, this project also includes bonus services (e.g. Redis cache, Adminer, a static site, and/or other extra containers — see the [Project Description](#project-description) section) to extend the stack while following the same containerization principles.
 
The project is a hands-on introduction to core sysadmin/DevOps concepts: containerization vs virtualization, image building, service isolation, networking, persistent storage, secrets management, and TLS termination.

## Project Description

<!--
Explain the use of Docker and the sources included in the project.
Indicate the main design choices, and include the following comparisons:
-->

### Architecture & Sources

.<br>
├── mandatory<br>
│   ├── format_exemple<br>
│   │   ├── conf<br>
│   │   │   └── configuration_file.conf<br>
│   │   ├── tools<br>
│   │   │   ├── docker-entrypoint.sh<br>
│   │   │   └── healthcheck.sh<br>
│   │   └── Dockerfile<br>
│   ├── mariadb<br>
│   ├── nginx<br>
│   └── wordpress<br>
├── bonus<br>
│   ├── adminer<br>
│   ├── ftp<br>
│   ├── grafana<br>
│   └── redis<br>
└── docker-compose.yml

### Design Choices

Many networks
<!-- Main technical/architectural decisions made for this project. -->

### Virtual Machines vs Docker



### Secrets vs Environment Variables

Environment variables and Secrets on docker are methods usually used to configure a container.<br>
Env vars is the basic way, they are simple to use: They can be define them at runtime, in a .env file or in docker configs. Vars can be already defined by the OS environment. Per consequent, most vars can be read by every process.<br>
Secrets is a Docker way to let passthrough sensible data into containers. For security reasons, data like password, certificates or api keys can't be readable per everyone. So we use secrets, because a secret is a file that can only be read by containers that have explicit access to a secret in containers definitions. It prevent leaks of sensible data into logs, images historic or code source repo where there usually risk with a .env file.


### Docker Network vs Host Network

<!-- Comparison -->

### Docker Volumes vs Bind Mounts

<!-- Comparison -->

## Instructions

<!-- Compilation, installation, and/or execution information. -->

### Prerequisites

Theses are the prerequisites:
- Docker
- *Optionnal* Makefile
- *Optionnal* Openssl

### Installation

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
- For Development generate one by using `./cert_gen.sh`
- For Production use a correct certificate.

For images building:
```bash
make build
# or
docker compose --project-directory srcs/ build
```

### Usage

## Documentation

- [USER_DOC.md](./USER_DOC.md) — How to use the project as an end user / administrator.
- [DEV_DOC.md](./DEV_DOC.md) — How to set up, build, and develop the project.

## Resources

<!-- Classic references: documentation, articles, tutorials, etc. -->

-
-
-

### AI Usage

<!-- Describe how AI was used: for which tasks and which parts of the project. -->

