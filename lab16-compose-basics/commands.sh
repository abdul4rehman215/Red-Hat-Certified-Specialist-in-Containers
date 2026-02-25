#!/bin/bash

# Lab 16 - Compose Basics (Podman Compose)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup: Verify Podman
# --------------------------------------------
podman --version

# --------------------------------------------
# Setup: Install + Verify podman-compose
# --------------------------------------------
podman-compose --version

python3 --version
pip3 --version
pip3 install --user podman-compose

# Make podman-compose available in this shell session
export PATH=$PATH:/home/toor/.local/bin

podman-compose --version

# --------------------------------------------
# Task 1: Create podman-compose.yml
# --------------------------------------------
mkdir compose-lab && cd compose-lab
touch podman-compose.yml

nano podman-compose.yml
cat podman-compose.yml

# --------------------------------------------
# Task 2: Start multi-container application
# --------------------------------------------
ss -tulnp | grep 8080 || true
podman-compose up -d

# Verify running containers
podman ps

# --------------------------------------------
# Task 3: Test application
# --------------------------------------------
mkdir html
echo "<h1>Hello from Podman Compose!</h1>" > html/index.html

curl http://localhost:8080

# Verify DB service
podman exec -it compose-lab_db_1 psql -U postgres
# Inside psql:
# SELECT version();
# \q

# --------------------------------------------
# Task 4: Stop and clean up
# --------------------------------------------
podman-compose down
podman ps -a

# Optional volume check (volumes may remain)
podman volume ls | grep compose-lab || true
