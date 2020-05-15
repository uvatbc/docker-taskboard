FROM accupara/ubuntu:18.04
MAINTAINER yuvraaj@gmail.com

ADD --chown=www-data:www-data TaskBoard/ /var/www/html

RUN set -x \
 && sudo apt-get update -y \
 && sudo apt-get dist-upgrade -y \
# Install deps
 && sudo apt-get install -y \
    apache2 \
    curl \
    libapache2-mod-php \
    openjdk-8-jre \
    multitail \
    php \
    php-common \
    php-cgi \
    php-sqlite3 \
    sqlite3 \
# Turn on the mods that matter to TaskBoard
 && sudo a2enmod rewrite expires \
# Fix the apache conf
 && sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
# Build inside the container
# && cd /var/www/html/build \
# && sudo ./build-all \
# && sudo chown -R www-data:www-data ../vendor \

CMD sudo /usr/sbin/apache2ctl -D FOREGROUND
