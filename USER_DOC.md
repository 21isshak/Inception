# User Documentation
This file is for user who wants have Inception for simpel usage. For technical purposes usage, check [DEV_DOC.md](DEV_DOC.md) file.

## Table of contents
- [Provided Services](#provided-services)
- [Starting and Stopping the Project](#starting-and-stopping-the-project)
- [Accessing the Website and Administration Panel](#accessing-the-website-and-administration-panel)
- [Locating and Managing Credentials](#locating-and-managing-credentials)
- [Checking Service Health](#checking-service-health)


## Provided Services
This infrastructure provides three core isolated services running inside Docker containers:
- **NGINX:** Acts as the primary web server and secure reverse proxy, handling HTTPS connections exclusively over port 443 with TLSv1.2 or TLSv1.3 protocols.
- **WordPress + PHP-FPM:** Houses the WordPress core site files and processes PHP scripts. It does not run a web server inside its container and communicates with NGINX via port 9000.
- **MariaDB:** Serves as the relational database backend storing all WordPress website content, options, and user data, accessible on port 3306.

## Starting and Stopping the Project
All service management is handled via the top-level Makefile:

```bash
make            # start everything (builds the first time)
make down       # stop everything, keep all your data
make stop       # pause containers without removing them
make start      # resume previously stopped containers
make restart    # stop then start again
make clean      # down and prune docker resources
make fclean     # clean and wipe images/volumes and wipe data directories
```

## Accessing the Website and Administration Panel

Make sure the project is running (`make` was successfully).
- **Public Website:** Open your browser and navigate to https://iskaraag.42.fr
- **WordPress Admin Panel:** Navigate to https://iskaraag.42.fr/wp-admin
- ***Note:*** *Because the SSL certificate is self-signed, your browser will display a security warning. Select "Advanced" and accept the risk to proceed to the site.*

## Locating and Managing Credentials
*Sensitive credentials and passwords are stored in two locations on the host machine:*
- **Environment settings:** srcs/.env
Passwords and secrets: secrets/db_password.txt, secrets/db_root_password.txt, secrets/wp_user_password.txt and secrets/wp_admin_password.txt

*These files are protected by local permissions and ignored by version control.*

## Checking Service Health
*To verify that all services are running correctly, execute:*
```bash
docker ps
```
All three containers (`nginx`, `wordpress`, and `mariadb`) should be listed with a status of `Up` or `running`.