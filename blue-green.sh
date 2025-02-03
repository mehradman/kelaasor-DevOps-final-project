#!/bin/bash

sed -i 's|IMAGE_REPO=.*|IMAGE_REPO=$IMAGE_REPO|' /home/deployer/blue/.env
sed -i 's|IMAGE_NAME=.*|IMAGE_NAME=$IMAGE_NAME|' /home/deployer/blue/.env
sed -i 's|IMAGE_TAG=.*|IMAGE_TAG=$IMAGE_TAG|' /home/deployer/blue/.env
sed -i 's|PORT=.*|PORT=$BLUE_PORT|' /home/deployer/blue/.env

docker compose -f /home/deployer/blue/docker-compose.yml down && docker compose -f /home/deployer/blue/docker-compose.yml up -d
sed -i 's|localhost:8082 weight=0|localhost:8082 weight=1|' /home/deployer/config/nginx.conf
sudo nginx -t
sudo /etc/init.d/nginx reload

sed -i 's|IMAGE_REPO=.*|IMAGE_REPO=$IMAGE_REPO|' /home/deployer/green/.env
sed -i 's|IMAGE_NAME=.*|IMAGE_NAME=$IMAGE_NAME|' /home/deployer/green/.env
sed -i 's|IMAGE_TAG=.*|IMAGE_TAG=$IMAGE_TAG|' /home/deployer/green/.env
sed -i 's|PORT=.*|PORT=$GREEN_PORT|' /home/deployer/green/.env

sed -i 's|localhost:8083 weight=1|localhost:8083 weight=0|' /home/deployer/config/nginx.conf
sudo nginx -t
sudo /etc/init.d/nginx reload

docker compose -f /home/deployer/green/docker-compose.yml down && docker compose -f /home/deployer/green/docker-compose.yml up -d
sed -i 's|localhost:8083 weight=0|localhost:8083 weight=1|' /home/deployer/config/nginx.conf
sudo nginx -t
sudo /etc/init.d/nginx reload

sed -i 's|localhost:8082 weight=1|localhost:8082 weight=0|' /home/deployer/config/nginx.conf
sudo nginx -t
sudo /etc/init.d/nginx reload
docker compose -f /home/deployer/blue/docker-compose.yml down
