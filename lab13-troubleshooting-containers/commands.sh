#!/bin/bash

# Lab 13 - Troubleshooting Containers (Podman)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup
# --------------------------------------------
sudo apt-get install -y podman
podman pull docker.io/library/nginx:alpine

# Ensure port 8080 is free (realistic pre-check)
ss -tulnp | grep 8080 || true

# Run test container
podman run -d --name nginx-test -p 8080:80 nginx:alpine

# --------------------------------------------
# Task 1: View Container Logs with Filters
# --------------------------------------------
podman logs nginx-test
podman logs -f nginx-test
podman logs --since 5m nginx-test
podman logs --tail 10 nginx-test

# --------------------------------------------
# Task 2: Inspect Container State + Stats
# --------------------------------------------
podman ps
podman inspect nginx-test | head -n 60
podman stats nginx-test

# --------------------------------------------
# Task 3: Debug Inside Container (exec)
# --------------------------------------------
podman exec -it nginx-test /bin/sh

# Inside container (manual commands):
# ps aux
# cat /etc/nginx/nginx.conf | head -n 40
# curl localhost
# apk add --no-cache curl
# curl -s localhost | head
# exit

# --------------------------------------------
# Extra Practice: Disk Usage
# --------------------------------------------
podman system df

# --------------------------------------------
# Cleanup
# --------------------------------------------
podman stop nginx-test
podman rm nginx-test
