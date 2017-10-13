FROM ubuntu:16.04
ENV PATH="/root/.composer/vendor/bin:${PATH}"

RUN apt-get update && \
    apt-get -y -qq install software-properties-common \
    xvfb \
    locales && \
    locale-gen en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --allow-unauthenticated install \
    php7.1-curl \
    php7.1-cli \
    php7.1-bcmath \
    php7.1-json \
    php7.1-intl \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-xml \
    php7.1-xsl \
    php7.1-zip \
    curl \
    git \
    wget \
    pkg-config && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Copy the content of config to / inside the container
COPY config /

# Run this script on image building
RUN sh /usr/local/bin/install.sh

ENTRYPOINT bash -C '/entrypoint.sh';'bash'

CMD ["php", "-a"]
