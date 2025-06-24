#!/bin/bash

# Préparation PHP-FPM
mkdir -p /run/php/
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

until mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
    echo "Attente de MariaDB..."
    sleep 2
done

# Installation de WP-CLI si manquant
if ! command -v wp &> /dev/null; then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Installation WordPress si non encore fait
if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    mkdir -p /var/www/html/wordpress
    cd /var/www/html/wordpress

    echo "[INFO] Téléchargement de WordPress..."
    wp core download --allow-root

    echo "[INFO] Création du fichier wp-config.php..."
    wp config create \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$WORDPRESS_DB_USER \
        --dbpass=$WORDPRESS_DB_PASSWORD \
        --dbhost=$WORDPRESS_DB_HOST \
        --path='/var/www/html/wordpress' \
        --allow-root

    echo "[INFO] Installation de WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WORDPRESS_TITLE" \
        --admin_user=$WORDPRESS_ADMIN_USER \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root

    echo "[INFO] Création de l'utilisateur secondaire..."
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL \
        --user_pass=$WORDPRESS_USER_PASSWORD \
        --role=author \
        --allow-root
fi

# Permissions
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

echo "[INFO] Lancement de PHP-FPM..."
exec "$@"
