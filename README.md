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

### Architecture & Sources

Sources structure
```
srcs
.
├── requirements
│   ├── service_exemple
│   │   ├── conf
│   │   │   └── configuration_file.conf
│   │   ├── tools
│   │   │   ├── docker-entrypoint.sh
│   │   │   └── healthcheck.sh
│   │   └── Dockerfile
│   ├── mariadb
│   ├── nginx
│   └── wordpress
├── bonus
│   ├── adminer
│   ├── ftp
│   ├── grafana
│   └── redis
└── docker-compose.yml
```

### Design Choices

Main architectural choice was to use networks as many services there are.

### Virtual Machines vs Docker

Virtual machines is great for achieving full physical isolation of services and emulation of CPU architecture. It's secure, privilege escalation is nearby impossible. But VM usage has high storage usage and high performance cost. Setup a VM is heavy and long. Each will have dedicated CPU core and ram space, if we used VM for this project, efficient usage of cores when virtualizing each services is impossible.

Docker is a containers manager. Containers is userspace level isolation of linux distribution files and network. Containers process share and run on host kernel. They offer faster installation, better reproducibility, less performance cost and less storage usage. But isolation is weak because they are managed by a same kernel. Privilege escalation breach is hard but not rare. Containers cannot install driver dependencies because of limited permission on host. Portability has a limit, services must use same kernel base: containers based on windows kernel cannot run on an unix based OS without virtualization.

In our case, we have many services that we want to isolate from host and each others. They are trusted services and didn't need different kernel or drivers. So the better choice is Docker.

### Secrets vs Environment Variables

Environment variables and Secrets on docker are methods usually used to configure a container.<br>
Env vars is the basic way, they are simple to use: They can be define them at runtime, in a .env file or in docker configs. Vars can be already defined by the OS environment. Per consequent, most vars can be read by every process.<br>
Secrets is a Docker way to let passthrough sensible data into containers. For security reasons, data like password, certificates or api keys can't be readable per everyone. So we use secrets, because a secret is a file that can only be read by containers that have explicit access to a secret in containers definitions. It prevent leaks of sensible data into logs, images historic or code source repo where there usually risk with a .env file.


### Docker Network vs Host Network

The only difference is the isolation. Host network there isn't isolation of network. With docker networks, a new network space is created. Ports already opened on host can be opened. Ports are inaccessible from host or other networks. To share ports we can bind them to the host.
Usage of docker network offer a better security.

### Docker Volumes vs Bind Mounts

A bind mount share host files with a container.
Docker volumes is bind mount managed by docker. Host data location is managed by docker.
A docker container is temporary, so to keep data between two launch of a container we add shared location to the container. But usage of a simple bind mount isn't portable. So usage of docker volumes is greater, because data will be managed the same way on different machine.

## Instructions

### Prerequisites

Theses are the prerequisites:
- Docker
- *Optionnal* Makefile
- *Optionnal* Openssl

### Installation

Install prerequisites packages and clone this repo.
For setup see [DEV_DOC.md](./DEV_DOC.md).

### Usage

## Documentation

- [USER_DOC.md](./USER_DOC.md) — How to use the project as an end user / administrator.
- [DEV_DOC.md](./DEV_DOC.md) — How to set up, build, and develop the project.

## Resources

- [Docker Wikipedia](https://fr.wikipedia.org/wiki/Docker_(logiciel))
- [Virtual Machine Wikipedia](https://fr.wikipedia.org/wiki/Machine_virtuelle)
- [Wordpress Doc](https://wordpress.org/documentation/)
- [Nginx Guide](https://nginx.org/en/docs/beginners_guide.html)
- [Redis Guide](https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/)
- [Grafana Doc](https://grafana.com/docs/grafana/latest/?pg=oss-graf&plcmt=hero-btn-2)
- [MariaDB Guide](https://mariadb.com/get-started-with-mariadb/)
- 42 peer learning

### AI Usage

AI was only used for documentation, search and README template.

