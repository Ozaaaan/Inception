#!/bin/sh

sleep 10

# Créer la configuration WordPress
wp config create --allow-root \
    --dbname=$SQL_DATABASE \
    --dbuser=$SQL_USER \
    --dbpass=$SQL_PASSWORD \
    --dbhost=mariadb:3306 --path='/var/www/wordpress'

# Installer WordPress (si nécessaire)
wp core install --allow-root \
    --url=$DOMAIN_NAME \
    --title="Mon site WordPress" \
    --admin_user=$WP_ADMIN_USER \
    --admin_password=$WP_ADMIN_PASSWORD \
    --admin_email=$WP_ADMIN_EMAIL \
    --path='/var/www/wordpress'

wp user create abesneux abesneux@example.com --role=subscriber --user_pass=abesneuxbogoss --allow-root --path='/var/www/wordpress' || true

# Lancer PHP-FPM (le serveur web doit être lancé à la fin)
exec php-fpm7.4 -F