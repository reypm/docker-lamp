#!/bin/bash
set -e

# Setup permissions
data_dir="/var/www/html"

if [ "$(id -u)" == 1000 ]; then
    usermod -u 1000 www-data && groupmod -g 1000 www-data
elif [ "$(id -u)" == 500 ]; then
    usermod -u 500 www-data && groupmod -g 500 www-data
fi

chown -R www-data:root "$data_dir"

if  [ -d "$data_dir" ]; then
    chgrp -R www-data "$data_dir"
    chmod -R g+w "$data_dir"
    find "$data_dir" -type d -exec chmod 2775 {} +
    find "$data_dir" -type f -exec chmod ug+rw {} +
fi

# Enable rewrite
a2enmod rewrite expires

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND "$@"
