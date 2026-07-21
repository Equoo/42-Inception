#! /bin/sh

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -sha256  \
  -subj "/C=FR/ST=Auvergne-Rhone-Alpes/L=Lyon/O=42/OU=$USER/CN=$USER/" \
  -keyout secrets/nginx.key \
  -out secrets/nginx.crt
chmod 755 secrets/nginx.key
chmod 755 secrets/nginx.crt
