#!/bin/bash
# Lab 33: Running Containers Locally with Podman
# Commands Executed During Lab (sequential, no explanations)

sudo dnf install -y podman
sudo yum install -y podman

podman --version

podman pull docker.io/library/nginx:latest

podman run --name foreground-container docker.io/library/nginx

podman run -d --name background-container docker.io/library/nginx

podman ps

podman run -d --name webapp -p 8080:80 docker.io/library/nginx

podman rm -f webapp

podman run -d --name webapp -p 8080:80 docker.io/library/nginx

curl -I http://localhost:8080

curl http://localhost:8080 | head

podman volume create mydata

podman run -d --name vol-container -v mydata:/data docker.io/library/alpine tail -f /dev/null

podman exec vol-container ls /data

podman run --rm -it --user 1000 docker.io/library/alpine whoami

podman run --rm -it --user nobody docker.io/library/alpine whoami

podman inspect webapp | head -n 25

podman logs webapp | tail -n 12

podman stats --no-stream

podman stop -a

podman rm -a

podman volume rm mydata
