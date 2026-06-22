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

.
├── mandatory
│   ├── mariadb
│   │   ├── conf
│   │   │   └── init.sql
│   │   ├── tools
│   │   │   ├── docker-entrypoint.sh
│   │   │   └── healthcheck.sh
│   │   └── Dockerfile
│   ├── nginx
│   │   ├── conf
│   │   │   ├── http.d
│   │   │   │   └── default.conf
│   │   │   └── nginx.conf
│   │   ├── static
│   │   │   └── index.html
│   │   ├── tools
│   │   │   ├── docker-entrypoint.sh
│   │   │   └── healthcheck.sh
│   │   └── Dockerfile
│   └── wordpress
│       ├── conf
│       │   ├── memorylimit.ini
│       │   └── www.conf
│       ├── tools
│       │   ├── docker-entrypoint.sh
│       │   └── healthcheck.sh
│       └── Dockerfile
├── bonus
│   ├── adminer
│   │   ├── conf
│   │   │   └── www.conf
│   │   ├── tools
│   │   │   └── healthcheck.sh
│   │   └── Dockerfile
│   ├── ftp
│   │   ├── conf
│   │   │   ├── ftpd.group
│   │   │   ├── ftpd.passwd
│   │   │   └── proftpd.conf
│   │   ├── tools
│   │   │   ├── docker-entrypoint.sh
│   │   │   └── healthcheck.sh
│   │   └── Dockerfile
│   ├── grafana
│   │   ├── conf
│   │   │   └── custom.ini
│   │   ├── dashboards
│   │   │   ├── redis.json
│   │   │   └── wordpress.json
│   │   ├── provisioning
│   │   │   ├── dashboard.yml
│   │   │   └── datasource.yml
│   │   ├── tools
│   │   │   ├── docker-entrypoint.sh
│   │   │   └── healthcheck.sh
│   │   └── Dockerfile
│   └── redis
│       ├── conf
│       │   └── redis.conf
│       ├── tools
│       │   ├── docker-entrypoint.sh
│       │   └── healthcheck.sh
│       └── Dockerfile
└── docker-compose.yml


### Design Choices

<!-- Main technical/architectural decisions made for this project. -->

### Virtual Machines vs Docker

<!-- Comparison -->

### Secrets vs Environment Variables

<!-- Comparison -->

### Docker Network vs Host Network

<!-- Comparison -->

### Docker Volumes vs Bind Mounts

<!-- Comparison -->

## Instructions

<!-- Compilation, installation, and/or execution information. -->

### Prerequisites

### Installation

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
