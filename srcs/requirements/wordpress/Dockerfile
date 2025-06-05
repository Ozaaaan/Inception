FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y wget \
                   php7.4-fpm \
                   php7.4-mysql \
                   mariadb-client

COPY ./tools/wordpress.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wordpress.sh

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]
CMD ["php-fpm7.4", "-F"]