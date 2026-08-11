*Inception project as a part of 42 Warsaw core curriculum made by iskaraag*
*This project's been created as part of 42 cirriculm by iskaraag*

## Table of contents
- [Description](#description)
- [Instructions](#instructions)
- [Technical Choices and Comparisons](#technical-choices-and-comparisons)
   - [Virtual Machines vs Docker](#virtual-machines-vs-docker)
   - [Secrets vs Environment Variables](#secrets-vs-environment-variables)
   - [Docker Network vs Host Network](#docker-network-vs-host-network)
   - [Docker Volumes vs Bind Mounts](#docker-volumes-vs-bind-mounts)
- [Resources](#resources)
   - [AI Usage](#ai-usage)

## Description
This project aims to expand knowledge of system administration using Docker and Docker Compose inside a Virtual Machine. It deploys a secure, fully functional infrastructure comprising NGINX with TLSv1.2/TLSv1.3 support, WordPress with PHP-FPM, and MariaDB, all running in isolated custom-built containers.

## Instructions
To compile, build, and launch all services:
```bash
make
```
To stop all running containers:
```bash
make down
```
To remove containers, networks, volumes ans host persistent data:
```bash
make clean
make fclean
```
To clean and rebuild the entire infrastructure from scratch:
```bash
make re
```

## Technical Choices and Comparisons

### Virtual Machines vs Docker

Virtual Machines virtualize hardware and run a full guest operating system, which consumes significant RAM, CPU, and disk space. Docker virtualizes at the OS kernel level, running containers as lightweight, isolated processes that share the host system's kernel, resulting in significantly faster startup times and lower resource consumption.

### Secrets vs Environment Variables

Environment variables (⁠.env⁠) store non-sensitive system configurations (such as domain names, database names, and non-critical environment flags). Docker Secrets securely manage sensitive credentials (like database passwords and administrator passwords) by mounting them in memory-backed, restricted-access paths within containers rather than exposing them as plain-text environment variables.

### Docker Network vs Host Network

Host network mode attaches container network interfaces directly to the host's network stack, bypassing network isolation and risking port conflicts. Docker's custom bridge network provides an isolated virtual network environment where containers communicate securely via internal ports using automatic container name DNS resolution.

### Docker Volumes vs Bind Mounts

Bind mounts bind container paths directly to specific host file paths, making them dependent on host filesystem directory structures and permission setups. Docker Volumes are natively managed by Docker within a designated host space, offering superior performance, portable volume management, and clean data persistence across container lifetimes.

## Resources
Classic references used while building mandatory part of this project:

- [Docker documentation](https://docs.docker.com/)
- [Docker workshop](https://docs.docker.com/get-started/workshop/)
- [Docker Volumes](https://docs.docker.com/get-started/workshop/06_bind_mounts/#quick-volume-type-comparisons)
- [Compose file reference](https://docs.docker.com/reference/compose-file/)
- [Docker secrets in Compose](https://docs.docker.com/compose/how-tos/use-secrets/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [Wordpress/NGINX/PHP_FPM](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lemp-nginx-mariadb-and-php-on-debian-10)
- [TLS v1.2](https://my-ssl.com/learn/nginx-ssl-installation?ct=1780771200725)
- [WP-CLI documentation](https://wp-cli.org/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)


### AI Usage
I used AI for:
- Understanding the subject and it requirements.
- Planning and dividing the task for suitability.
- Researching current, real version numbers and install methods for
  every piece of software used
- Debugging and fixing the container and its configuration.
- Drafting README and the USER_DOC.md / DEV_DOC.md files.
