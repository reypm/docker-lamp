#!/bin/bash
set -e

# Setup permissions
data_dir="/var/www/html"
composer_cache_dir="/var/www/.composer"

mkdir -p "$composer_cache_dir"

usermod -u 1000 www-data && groupmod -g 1000 www-data
chown -R www-data:root "$data_dir"
chown -R www-data:root "$composer_cache_dir"

if  [ -d "$data_dir" ]; then
    chgrp -R www-data "$data_dir"
    chmod -R g+w "$data_dir"
    find "$data_dir" -type d -exec chmod 2775 {} +
    find "$data_dir" -type f -exec chmod ug+rw {} +
fi

if  [ -d "$composer_cache_dir" ]; then
    chgrp -R www-data "$composer_cache_dir"
    chmod -R g+w "$composer_cache_dir"
fi

# Enable rewrite
a2enmod rewrite expires

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND "$@"
