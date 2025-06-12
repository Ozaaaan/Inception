FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y wget \
                   php7.4-fpm \
                   php7.4-mysql \
                   mariadb-client

RUN mkdir -p /var/www/html/wordpress && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

COPY ./tools/wordpress.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wordpress.sh

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]
CMD ["php-fpm7.4", "-F"]
