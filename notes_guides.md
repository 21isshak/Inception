# NOTES

## 1. What is Docker?

Docker is a containerization platform that packages applications and their dependencies into isolated containers. Containers share the host kernel but remain isolated from each other, making deployment portable and consistent.

Docker, uygulamaları ve bağımlılıklarını izole konteynerlere paketleyen bir konteynerleştirme platformudur. Konteynerler host çekirdeğini paylaşır ancak birbirlerinden izole şekilde çalışır, bu da dağıtımı taşınabilir ve tutarlı hale getirir.

## 2. What is a Docker image?

A Docker image is a read-only snapshot of an application and its filesystem. Containers start from images, and an image can be reused to create multiple identical containers.

Docker image, bir uygulama ve dosya sistemi için salt okunur bir anlık görüntüdür. Konteynerler image'lerden başlatılır ve bir image aynı yapılandırmayı çoğaltmak için birden fazla konteyner oluşturmakta kullanılabilir.

## 3. What is Docker Compose?

Docker Compose is a tool for defining and running multi-container Docker applications using a YAML file. It simplifies service orchestration, network setup, volume mounting, and secret declarations.

Docker Compose, YAML dosyası kullanarak çoklu konteyner Docker uygulamalarını tanımlamak ve çalıştırmak için bir araçtır. Servis orkestrasyonunu, ağ yapılandırmasını, hacim montajını ve secret bildirimlerini kolaylaştırır.

## 4. What is a container?

A container is a running instance of a Docker image. It includes the application process, its filesystem, and its configured network and storage environment.

Konteyner, bir Docker image'inin çalışan örneğidir. Uygulama sürecini, dosya sistemini ve yapılandırılmış ağ ve depolama ortamını içerir.

## 5. What is SSL/TLS?

SSL/TLS is a protocol for encrypting network traffic between a client and a server. It ensures confidentiality, integrity, and authentication for web connections.

SSL/TLS, bir istemci ile sunucu arasındaki ağ trafiğini şifreleyen bir protokoldür. Web bağlantıları için gizlilik, bütünlük ve kimlik doğrulaması sağlar.

## 6. What is NGINX?

NGINX is a high-performance web server and reverse proxy. In this project, it handles HTTPS termination and proxies requests to the WordPress container.

NGINX, yüksek performanslı bir web sunucusu ve ters proxy'dir. Bu projede HTTPS sonlandırmasını gerçekleştirir ve istekleri WordPress konteynerine yönlendirir.

## 7. What is WordPress?

WordPress is a content management system (CMS) used to build websites and blogs. It runs PHP code and stores site data in a MySQL/MariaDB database.

WordPress, web siteleri ve bloglar oluşturmak için kullanılan bir içerik yönetim sistemidir. PHP kodu çalıştırır ve site verilerini MySQL/MariaDB veritabanında saklar.

## 8. What is MariaDB?

MariaDB is a relational database management system compatible with MySQL. It stores application data such as WordPress posts, users, and settings.

MariaDB, MySQL ile uyumlu bir ilişkisel veritabanı yönetim sistemidir. WordPress gönderileri, kullanıcıları ve ayarları gibi uygulama verilerini saklar.

## 9. What is PHP-FPM and why is it used?

PHP-FPM is the FastCGI Process Manager for PHP. It runs PHP code in a separate service and improves performance by managing multiple PHP worker processes.

PHP-FPM, PHP için FastCGI Process Manager'dır. PHP kodunu ayrı bir servis olarak çalıştırır ve birden fazla PHP işçi süreci yöneterek performansı artırır.

## 10. Why use a reverse proxy instead of serving WordPress directly?

A reverse proxy like NGINX provides TLS termination, request routing, and additional security. It also lets the application container focus on PHP execution while NGINX handles HTTP/S traffic.

NGINX gibi bir ters proxy TLS sonlandırma, istek yönlendirme ve ek güvenlik sağlar. Ayrıca uygulama konteynerinin sadece PHP yürütmesine odaklanmasına izin verirken NGINX HTTP/S trafiğini yönetir.

## 11. What is the purpose of `.env` in Docker Compose?

`.env` provides environment variables used by the Compose file. These values are generally non-sensitive settings such as database names, ports, and service configuration flags.

`.env`, Compose dosyası tarafından kullanılan ortam değişkenlerini sağlar. Bu değerler genellikle veritabanı isimleri, portlar ve servis yapılandırma bayrakları gibi duyarlı olmayan ayarlardır.

## 12. How do Docker volumes differ from bind mounts?

Docker volumes are managed by Docker and are best for persistent container data. Bind mounts map a host directory directly into the container and depend on host file paths and permissions.

Docker hacimleri Docker tarafından yönetilir ve kalıcı konteyner verileri için idealdir. Bind mount'lar bir host dizinini doğrudan konteynere eşler ve host dosya yollarına ve izinlerine bağlıdır.

## 13. Inceptin Project Overview

This Inception project runs a secure WordPress stack inside Docker Compose. It includes:
- `nginx` as an SSL/TLS reverse proxy,
- `wordpress` with PHP-FPM,
- `mariadb` as the database backend.

## 14. Secret and Config Files

Important files used by the project:
- `srcs/.env`
  - Contains non-sensitive configuration values used by Docker Compose.
  - Example data: service names, database names, hostnames.
- `secrets/db_root_password.txt`
- `secrets/db_password.txt`
- `secrets/wp_admin_password.txt`
- `secrets/wp_user_password.txt`


## 15. WordPress configuration

The project uses WP-CLI in `srcs/requirements/wordpress/tools/wp_setup.sh` to install WordPress and create admin/user accounts during container startup. Check that `https://iskaraag.42.fr/wp-admin` loads and login with the admin credentials from `secrets/wp_admin_password.txt`.

Proje, container başlatılırken WordPress'i kurmak ve yönetici/kullanıcı hesapları oluşturmak için `srcs/requirements/wordpress/tools/wp_setup.sh` içinde WP-CLI kullanır. `https://iskaraag.42.fr/wp-admin` adresinin yüklenip yüklenmediğini kontrol edin ve `secrets/wp_admin_password.txt` içindeki yönetici kimlik bilgileriyle giriş yapın.

## 16. The database connection

Check that MariaDB is healthy and reachable from the WordPress container. Example: `docker exec -it wordpress mysqladmin -h mariadb -u root -p"$(cat ../secrets/db_root_password.txt)" ping` or run a WP-CLI database query inside the `wordpress` container.

MariaDB'nin sağlıklı olduğunu ve WordPress konteynerinden erişilebilir olduğunu kontrol edin. Örnek: `docker exec -it wordpress mysqladmin -h mariadb -u root -p"$(cat ../secrets/db_root_password.txt)" ping` veya `wordpress` konteyner içinde bir WP-CLI veritabanı sorgusu çalıştırın.


## 17. Environment preparation and testing the inception project

### 17.1

1. Confirm secret files exist in the repository root `secrets/`:
   - `db_root_password.txt`
   - `db_password.txt`
   - `wp_admin_password.txt`
   - `wp_user_password.txt`
2. Confirm `srcs/.env` exists and is loaded by Compose.

### 17.2 Start the project

```bash
cd ~/Inception
make
```

### 17.3 Check container status

```bash
docker compose -f srcs/docker-compose.yml ps
```

All three containers should be `Up`:
- `nginx`
- `wordpress`
- `mariadb`

### 17.4 Verify HTTPS access

Open the browser at:
- `https://iskaraag.42.fr`
- `https://iskaraag.42.fr/wp-admin`


### 17.5 Validate TLS protocol

```bash
openssl s_client -connect iskaraag.42.fr:443 -servername iskaraag.42.fr </dev/null | grep "Protocol\|Cipher\|Verify return code"
```

Expected TLS version: TLSv1.2 or TLSv1.3.

### 17.6 Confirm secrets and environment usage

Inspect the compose configuration:
```bash
docker compose -f srcs/docker-compose.yml config | sed -n '1,120p'
```

Confirm secrets are declared and mounted.

Inside the containers, it is possible to inspect the secret file contents if necessary:
```bash
docker exec -it mariadb cat /run/secrets/db_password
docker exec -it wordpress cat /run/secrets/wp_admin_password
```

### 17.7 Validate WordPress installation

- Open the admin login at `https://iskaraag.42.fr/wp-admin`.
- Use the admin username and password from `secrets/wp_admin_password.txt`.
- Verify the WordPress dashboard loads correctly.

### 17.8 Validate database connectivity

From the WordPress container:
```bash
docker exec -it wordpress bash -lc 'mysqladmin -h mariadb -u root -p"$(cat /run/secrets/db_root_password)" ping'
```

If that succeeds, the WordPress container can reach MariaDB.

### 17.9 Stop and clean

```bash
make down
make fclean
```

Check that containers stop and host data is wiped when `fclean` runs.