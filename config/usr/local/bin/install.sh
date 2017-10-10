#!/bin/bash

set -e

# Install Symfony Installer
curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
chmod a+x /usr/local/bin/symfony

# Install Composer
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quit --install-dir=/usr/local/bin --filename=composer
RESULT=$?
rm composer-setup.php

export COMPOSER_ALLOW_SUPERUSER=1
export COMPOSER_HOME="/root/.composer"
export COMPOSER_CACHE_DIR="/root/.composer/cache"
export COMPOSER_ALLOW_XDEBUG=1
export COMPOSER_DISABLE_XDEBUG_WARN=1

# Install Global PHP Development Libraries
composer global install --prefer-dist --no-dev --no-progress --no-suggest --optimize-autoloader --classmap-authoritative --no-interaction
composer clear-cache

exec "$@"
