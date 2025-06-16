FROM debian:bullseye

RUN apt update -y && apt upgrade -y \
    && apt-get install -y mariadb-client wget php7.4 php7.4-fpm php7.4-mysql

# Créer le répertoire pour le socket PHP-FPM
RUN mkdir -p /run/php/ && chown -R www-data:www-data /run/php

# Installer WordPress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www \
    && cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz \
    && chown -R www-data:www-data /var/www/wordpress

# Installer WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY ./conf/auto_config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/auto_config.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]

CMD ["php-fpm7.4", "-F"]