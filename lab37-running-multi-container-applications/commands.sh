#!/bin/bash
# Lab 37: Running Multi-Container Applications
# Commands Executed During Lab (sequential, no explanations)

systemctl start podman

podman --version
podman-compose --version

mkdir multi-container-lab && cd multi-container-lab

pwd

mkdir -p app

nano docker-compose.yml

cat docker-compose.yml

podman-compose up -d

podman ps

curl -I http://localhost:8000

curl http://localhost:8000 | head

echo "supersecret" | podman secret create db_password -

nano docker-compose.yml

cat docker-compose.yml | sed -n '1,120p'

podman-compose down

podman-compose up -d

podman kube generate --service -f k8s-deployment.yaml multi-container-lab_web_1 multi-container-lab_redis_1 multi-container-lab_db_1

head -n 40 k8s-deployment.yaml

podman-compose down

podman play kube k8s-deployment.yaml

podman pod ps

podman ps

podman-compose down

podman pod rm -a -f

podman rm -a -f

podman volume prune

podman secret rm db_password
