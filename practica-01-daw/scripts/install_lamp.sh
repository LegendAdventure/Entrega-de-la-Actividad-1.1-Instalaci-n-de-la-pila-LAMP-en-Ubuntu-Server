#!/bin/bash
#e: Finaliza si hay errores
#x: Muestra los comandos que están en ejecución
set -ex

# Fuerza la instalación de paquetes
export DEBIAN_FRONTEND=noninteractive

# Actualiza la lista de paquetes
apt update

# Actualizamos los paquetes del sistema operativo
apt upgrade -y

# Instalamos el servidor web Apache
apt install apache2 -y

# Copiamos nuestro archivo de configuración de VirtualHost
cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# Instalamos los paquetes necesarios para tener PHP y extensiones comunes
apt install php libapache2-mod-php php-mysql -y

# Habilitamos el módulo rewrite de Apache
a2enmod rewrite

# Reiniciamos el servicio de Apache
systemctl restart apache2

# Copiar el archivo php/index.php a /var/www/html
cp ../php/index.php /var/www/html

# Modificamos el propietario del directorio /var/www/html
chown -R www-data:www-data /var/www/html

# Instalamos MySQL Server de forma desatendida para evitar bloqueos
apt install mysql-server -y

# Asegura que cuando se reinicien los servicios asegure que se inicien automáticamente
systemctl enable apache2
systemctl enable mysql

# Reinicia los servicios
systemctl restart apache2
systemctl restart mysql