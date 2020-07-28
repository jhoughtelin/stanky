#!/bin/sh

sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

/usr/bin/supervisord -c /app/docker/supervisord.conf
