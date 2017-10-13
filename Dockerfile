FROM php:7-cli-alpine
ENV PATH="/root/.composer/vendor/bin:${PATH}"
COPY config /
RUN sh /usr/local/bin/install.sh
WORKDIR /var/wwww
CMD ["php", "-a"]
