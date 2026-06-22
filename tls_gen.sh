#! /bin/sh

openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes -subj "/C=FR/ST=Auvergne-Rhone-Alpes/L=Lyon/O=42/OU=dderny/CN=dderny/"
