FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y nginx \
                   openssl

RUN mkdir -p /etc/nginx/snippets/
RUN mkdir -p /var/run/nginx/
RUN mkdir -p /var/www/html/wordpress

RUN chmod 755 -R /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

COPY ./conf/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY ./tools/nginx.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx.sh

EXPOSE 443

CMD ["/usr/local/bin/nginx.sh"]