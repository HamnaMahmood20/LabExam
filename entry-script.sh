#!/bin/bash

dnf update -y
dnf install -y nginx openssl

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/nginx.key \
  -out /etc/nginx/ssl/nginx.crt \
  -subj "/C=US/ST=State/L=City/O=Org/OU=IT/CN=localhost"

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name _;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name _;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
EOF

cat <<EOF > /usr/share/nginx/html/index.html
<html>
  <body>
    <h1>This is Hamna Mahmood's Terraform environment.</h1>
  </body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx

