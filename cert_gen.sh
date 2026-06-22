#! /bin/sh

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -sha256  \
  -subj "/C=FR/ST=Auvergne-Rhone-Alpes/L=Lyon/O=42/OU=dderny/CN=dderny/" \
  -keyout nginx.key \
  -out nginx.crt
