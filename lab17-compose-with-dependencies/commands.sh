#!/bin/bash

# Lab 17 - Compose with Dependencies (docker-compose)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup
# --------------------------------------------
mkdir compose-dependencies-lab
cd compose-dependencies-lab
pwd

# --------------------------------------------
# Task 1: depends_on (redis + nginx)
# --------------------------------------------
nano docker-compose.yml   # created initial depends_on compose file

docker-compose up -d
docker-compose ps

curl -I http://localhost:8080 | head -10

# --------------------------------------------
# Task 2: scale webapp replicas
# --------------------------------------------
nano docker-compose.yml   # updated compose file for scaling variant

docker-compose up -d --scale webapp=3
docker-compose ps

docker-compose exec webapp hostname
docker-compose exec webapp-1 hostname
docker-compose exec webapp-2 hostname
docker-compose exec webapp-3 hostname

# --------------------------------------------
# Task 3: Flask + Redis connectivity
# --------------------------------------------
nano app.py
nano Dockerfile
nano docker-compose.yml   # updated compose file for Flask + Redis

docker-compose up -d
docker-compose ps

curl http://localhost:5000
curl http://localhost:5000
curl http://localhost:5000

docker-compose logs --tail=15 webapp

# Connectivity troubleshooting checks
docker-compose logs --tail=20
docker-compose exec redis redis-cli ping
docker-compose exec webapp python -c "import redis; r=redis.Redis(host='redis', port=6379); print(r.ping())"

# --------------------------------------------
# Cleanup
# --------------------------------------------
docker-compose down

docker images | head -10
docker rmi compose-dependencies-lab-webapp:latest
