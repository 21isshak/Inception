# Developer Documentation
This file is for someone who wants to set the project up to build on it or debug itt. For simple usage, see [USER_DOC.md](USER_DOC.md).


## Table of contents
- [Infrastructure Overview](#infrastructure-overview)
- [Prerequisites & Environment Setup](#prerequisites--environment-setup)
- [Build and Deployment Lifecycle](#build-and-deployment-lifecycle)
- [Debugging and Operational Commands](#debugging-and-operational-commands)
- [Persistent Storage Configuration](#persistent-storage-configuration)

## Infrastructure Overview
This project uses Docker Compose to orchestrate three custom Debian-based containers:
- **nginx**: Front-end SSL termination point and reverse proxy.
- **wordpress**: PHP-FPM application server running WP-CLI auto-configuration.
- **mariadb**: Database backend configured with secure user permissions and isolated secrets.

## Prerequisites & Environment Setup
Ensure the following components are available on the host:
- Docker Engine & Docker Compose V2
- GNU Make
- Domain mapping in `/etc/hosts`: `127.0.0.1 <login>.42.fr`
- Required directory hierarchy and secret files:
  - `srcs/.env`
  - `secrets/db_password.txt`
  - `secrets/db_root_password.txt`
  - `secrets/wp_user_password.txt`
  - `secrets/wp_admin_password.txt`

## Build and Deployment Lifecycle

`make` commands:

| Command | What it does |
|---|---|
| `make` / `make all` | creates data directories then `up` |
| `make build` | Builds every image, doesn't start anything |
| `make up` | `build` Creates host data directoriess, then `docker compose -f srcs/docker-compose.yml up -d` |
| `make down` | Stops and removes containers without removing volumes |
| `make start` / `make stop` | Start/stop existing containers without rebuilding |
| `make restart` | `down` then `up` |
| `make logs` | `docker compose -f srcs/docker-compose.yml logs -f` (all services) |
| `make ps` / `make status` | `docker compose ps` |
| `make clean` | `down` + `docker system prune -a --force` |
| `make fclean` | `clean` + `docker volume rm $$(docker volume ls -q) 2>/dev/null true` , then wipes `/home/<login>/data` |
| `make re` | `fclean` then `all` |

## Debugging and Operational Commands
- **View Live Logs:**
  ```bash
  docker logs -f nginx
  docker logs -f wordpress
  docker logs -f mariadb
  ```
- **Execute Shell inside Containers:**
  ```bash
  docker exec -it wordpress /bin/bash
  docker exec -it mariadb /bin/bash
  ```
- **Inspect Network Bridge:**
  ```bash
  docker network inspect srcs_inception
  ```

## Persistent Storage Configuration
Data persistence is configured via local bind-mount volumes mapped directly to host directories:

- **WordPress Root:** `/home/<login>/data/wordpress`
- **MariaDB Database Files:** `/home/<login>/data/mariadb`

These directories persist across container lifecycles (`make down`) and are completely cleared only when running `make clean` and `make fclean`.