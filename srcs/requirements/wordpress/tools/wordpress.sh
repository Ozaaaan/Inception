#!/bin/bash

# Attendre que MariaDB soit prêt
echo "Waiting for MariaDB to be ready..."
while ! mariadb -h$WORDPRESS_DB_HOST -u$WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD $WORDPRESS_DB_NAME -e "SELECT 1" >/dev/null 2>&1; do
    echo "MariaDB is not ready yet, waiting..."
    sleep 2
done
echo "MariaDB is ready!"

# Configuration PHP-FPM
sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/;listen.owner = www-data/listen.owner = www-data/g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/;listen.group = www-data/listen.group = www-data/g' /etc/php/7.4/fpm/pool.d/www.conf

# Créer le répertoire WordPress
mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

# Télécharger WordPress si pas déjà présent
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wget -O wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf wordpress.tar.gz --strip-components=1
    rm wordpress.tar.gz

    # Télécharger WP-CLI
    wget -O wp-cli.phar https://raw.githubusercontent.com/wp-cli/wp-cli/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    # Configuration WordPress
    wp config create --dbname=$WORDPRESS_DB_NAME \
                     --dbuser=$WORDPRESS_DB_USER \
                     --dbpass=$WORDPRESS_DB_PASSWORD \
                     --dbhost=$WORDPRESS_DB_HOST \
                     --allow-root

    # Installation WordPress
    wp core install --url=$DOMAIN_NAME \
                    --title="$WORDPRESS_TITLE" \
                    --admin_user=$WORDPRESS_ADMIN_USER \
                    --admin_password=$WORDPRESS_ADMIN_PASSWORD \
                    --admin_email=$WORDPRESS_ADMIN_EMAIL \
                    --allow-root

    # Créer un utilisateur supplémentaire
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL \
                   --user_pass=$WORDPRESS_USER_PASSWORD \
                   --role=author \
                   --allow-root

    echo "WordPress installation completed!"
fi

# Changer les permissions
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Créer le répertoire pour PHP-FPM
mkdir -p /run/php

echo "Starting PHP-FPM..."
exec "$@"