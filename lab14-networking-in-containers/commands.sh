#!/bin/bash

# Lab 14 - Networking in Containers (Podman)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Task 1: List Podman Networks
# --------------------------------------------
podman network ls
podman network inspect podman

# --------------------------------------------
# Task 2: Create + Inspect Custom Network
# --------------------------------------------
podman network create lab-network
podman network ls | grep lab-network
podman network inspect lab-network

# Troubleshooting context (rootless info snapshot)
podman info | head -n 25

# --------------------------------------------
# Task 3: Run Containers with Port Publishing
# --------------------------------------------
# Check port availability
ss -tulnp | grep 8080 || true

# Run nginx with port mapping
podman run -d --name webapp -p 8080:80 docker.io/library/nginx

# Verify access
curl http://localhost:8080 | head

# Firewall check (may not exist on Ubuntu)
sudo firewall-cmd --list-ports

# Attach container to custom network (restart with network flag)
podman stop webapp
podman rm webapp
podman run -d --name webapp -p 8080:80 --network lab-network docker.io/library/nginx

# Confirm network assignment
podman inspect webapp | grep -A 5 "Networks"
