#!/bin/bash
#e: Finaliza si hay errores
#x: Muestra los comandos que están en ejecución
set -ex

# Forzar la no interactividad
export DEBIAN_FRONTEND=noninteractive

# Actualizar paquetes por si acaso
apt update

# 1. Instalación de phpMyAdmin (automatizando respuestas si es necesario o usando las variables del .env)
if [ -f .env ]; then
    source .env
fi

# Instalación de phpMyAdmin y dependencias
apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl

# Configuración y enlace automático de phpMyAdmin en Apache
ln -sf /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin
systemctl reload apache2

# 2. Instalación de Adminer
mkdir -p /var/www/html/adminer
wget -O /var/www/html/adminer/index.php https://www.adminer.org/latest.php

# 3. Instalación de GoAccess que sirve para analizar los logs
apt install -y goaccess

# Ajustar permisos finales del directorio web
chown -R www-data:www-data /var/www/html