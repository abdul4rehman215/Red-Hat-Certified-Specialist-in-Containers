#!/bin/bash
# Lab 25: Securing Images with Least Privilege
# Commands Executed During Lab (sequential, no explanations)

podman --version

mkdir secure_lab && cd secure_lab
pwd

podman pull docker.io/library/nginx:latest

podman scan nginx:latest

nano Dockerfile
cat Dockerfile

podman build -t nginx_clean .

podman images | grep -E 'nginx|nginx_clean'

nano Dockerfile
cat Dockerfile

podman build -t nginx_alpine .

podman images | grep -E 'nginx_alpine|nginx_clean|docker.io/library/nginx'

nano Dockerfile
cat Dockerfile

podman build -t nginx_nonroot .

podman run -d --name secure_nginx -p 8080:80 nginx_nonroot

podman exec secure_nginx ps aux

gpg --version | head -n 2

nano keyparams

gpg --batch --gen-key keyparams

podman image sign --sign-by your@email.com nginx_nonroot

podman image trust show

podman stop secure_nginx

podman rm secure_nginx

podman rmi nginx nginx_clean nginx_alpine nginx_nonroot
