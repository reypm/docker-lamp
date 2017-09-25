FROM ubuntu:16.04

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2a \
    PATH="/root/.composer/vendor/bin:${PATH}"

RUN apt-get update && \
    apt-get -y install software-properties-common \
    xvfb \
    locales && \
    locale-gen en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --allow-unauthenticated install \
    apache2 \
    php7.1 \
    php7.1-dev \
    php7.1-curl \
    php7.1-cli \
    php7.1-gd \
    php7.1-bcmath \
    php7.1-json \
    php7.1-ldap \
    php7.1-intl \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-xml \
    php7.1-xsl \
    php7.1-zip \
    php7.1-soap \
    libapache2-mod-php7.1 \
    php-pear \
    curl \
    git \
    wget \
    nano \
    wkhtmltopdf \
    pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN pecl install mongodb && \
    pecl install xdebug && \
    pecl install apcu
COPY config /
RUN chmod 0644 /etc/cron.d/api_command-cron
RUN sh /usr/local/bin/install.sh
WORKDIR /var/www/html
EXPOSE 80 9001
ENTRYPOINT bash -C '/entrypoint.sh';'bash'
