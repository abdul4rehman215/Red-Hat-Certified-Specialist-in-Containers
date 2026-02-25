#!/bin/bash
# Lab 28: EXPOSE and Port Binding
# Commands Executed During Lab (sequential, no explanations)

podman --version

mkdir portbinding-lab && cd portbinding-lab
pwd

nano app.py
cat app.py

echo "flask" > requirements.txt
cat requirements.txt

nano Containerfile
cat Containerfile

podman build -t exposed-app .

podman run -d -p 8080:8080 --name webapp exposed-app

podman ps

ss -tulnp | grep 8080

sudo yum install -y iproute

ss -tulnp | grep 8080

curl http://localhost:8080

podman stop webapp

podman run -d -p 9090:8080 --name webapp2 exposed-app

curl http://localhost:9090

python3 -m http.server 8080 >/tmp/httpserver.log 2>&1 &

podman run -d -p 8080:8080 --name webapp3 exposed-app

sudo lsof -i :8080

kill 2210

podman run -d -P --name webapp4 exposed-app

podman port webapp4

podman ps -a

podman stop -a

podman rm -a
