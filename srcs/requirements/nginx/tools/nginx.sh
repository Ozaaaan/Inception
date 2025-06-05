#!/bin/bash
# Variable qui stock le path de la cle 
private_key="/etc/ssl/private/nginx.key"

# Variable qui stock le path du certificat
certificate_signing_request="/etc/ssl/certs/nginx.csr"

# Variable qui stock les infos du certificat
options="/C=FR/L=FR/O=42/OU=STUDENT/CN=ozdemir.42.fr"

# Genere la cle privee
openssl genpkey -algorithm RSA -out "$private_key"

# Genere la demande de certificat
openssl req -new -key "$private_key" -out "$certificate_signing_request" -subj "$options"

# Genere le certificat auto signe
openssl x509 -req -in "$certificate_signing_request" -signkey "$private_key" -out "/etc/ssl/certs/nginx.crt"

# Configure nginx pour utiliser le SSL
echo "
ssl_certificate /etc/ssl/certs/nginx.crt;
ssl_certificate_key /etc/ssl/private/nginx.key;
" > /etc/nginx/snippets/self-signed.conf

# Demarre le serveur nginx et le maintient ouvert
nginx -g "daemon off;"