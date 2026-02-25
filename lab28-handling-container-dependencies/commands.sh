#!/bin/bash
# Lab 38: Handling Container Dependencies
# Commands Executed During Lab (sequential, no explanations)

mkdir container-dependencies-lab && cd container-dependencies-lab

pwd

podman --version
podman-compose --version

nano docker-compose.yml

cat docker-compose.yml

podman-compose up -d

podman ps

podman inspect --format='{{.State.Health.Status}}' container-dependencies-lab_db_1

nano healthcheck.sh

chmod +x healthcheck.sh

ls -l healthcheck.sh

nano docker-compose.yml

cat docker-compose.yml

nano entrypoint.sh

chmod +x entrypoint.sh

nano Dockerfile

cat Dockerfile

nano app.py

nano Dockerfile

cat Dockerfile

nano docker-compose.yml

cat docker-compose.yml

podman-compose up --build

podman-compose down

podman system prune -f
