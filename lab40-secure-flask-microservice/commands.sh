#!/bin/bash
# Lab 40: Case Study - Build and Deploy a Secure Flask Microservice
# Commands Executed During Lab (sequential, no explanations)

mkdir flask-microservice-lab && cd flask-microservice-lab

pwd

podman --version
podman-compose --version

python3 -m venv venv

source venv/bin/activate

pip install flask psycopg2-binary

nano app.py

sed -n '1,200p' app.py

pip freeze > requirements.txt

cat requirements.txt

nano Containerfile

cat Containerfile

podman build -t flask-app .

nano init.sql

cat init.sql

echo "mysecretpassword" > db_password.txt

podman secret create db_password db_password.txt

nano podman-compose.yml

cat podman-compose.yml

podman-compose up -d

podman ps

podman scan flask-app

podman scan postgres:13

podman trust set -t reject default

podman trust set -f ~/.ssh/id_rsa.pub docker.io

podman tag flask-app localhost/flask-app:latest

podman push localhost/flask-app:latest

curl http://localhost:5000

curl http://localhost:5000/data

podman logs -f flask-microservice-lab_web_1

podman-compose stop db

podman-compose start db

curl http://localhost:5000/data

podman-compose down

podman secret rm db_password

podman rmi flask-app

deactivate
