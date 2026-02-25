#!/bin/bash

# Lab 10 - Persisting Data with Volumes (Podman)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Task 1: Creating Named Volumes
# --------------------------------------------
podman volume create myapp_data
podman volume ls
podman volume inspect myapp_data

# --------------------------------------------
# Task 2: Mounting Volumes in Containers
# --------------------------------------------
podman run -d --name webapp -v myapp_data:/var/www/html docker.io/library/nginx
podman exec webapp ls /var/www/html

podman exec webapp sh -c "echo 'Hello, Volume!' > /var/www/html/index.html"
podman exec webapp cat /var/www/html/index.html

podman rm -f webapp

podman run -d --name webapp_new -v myapp_data:/var/www/html docker.io/library/nginx
podman exec webapp_new cat /var/www/html/index.html

# --------------------------------------------
# Task 3: Using Bind Mounts with Host Directories
# --------------------------------------------
mkdir ~/host_data
echo "Hello, Bind Mount!" > ~/host_data/index.html

podman run -d --name bind_example -v ~/host_data:/usr/share/nginx/html:Z docker.io/library/nginx
podman exec bind_example cat /usr/share/nginx/html/index.html

echo "Updated content!" >> ~/host_data/index.html
podman exec bind_example cat /usr/share/nginx/html/index.html
