#!/bin/bash

# Lab 3 - Running Containers with Podman
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Lab Setup
# --------------------------------------------
podman --version
podman pull docker.io/library/nginx:alpine

# --------------------------------------------
# Task 1: Running a Container in Detached Mode
# --------------------------------------------
podman run -d docker.io/library/nginx:alpine
podman ps
podman logs c2a7e41c5f0e

# --------------------------------------------
# Task 2: Port Mapping
# --------------------------------------------
podman stop $(podman ps -q)
podman run -d -p 8080:80 docker.io/library/nginx:alpine
podman port a91f32b3c2d5
curl http://localhost:8080
ss -tulnp | head

# --------------------------------------------
# Task 3: Volume Mounts
# --------------------------------------------
mkdir ~/nginx-content
echo "Hello from host!" > ~/nginx-content/index.html
podman run -d -p 8081:80 -v ~/nginx-content:/usr/share/nginx/html:Z docker.io/library/nginx:alpine
curl http://localhost:8081
chcon -Rt svirt_sandbox_file_t ~/nginx-content

# --------------------------------------------
# Task 4: Assigning Custom Names
# --------------------------------------------
podman ps
podman stop $(podman ps -q)
podman run -d --name my-nginx -p 8082:80 docker.io/library/nginx:alpine
podman inspect my-nginx | grep -i status
podman stop my-nginx

# --------------------------------------------
# Next Steps / Cleanup
# --------------------------------------------
podman rm -f $(podman ps -aq)
podman --help | head -n 25
