#!/bin/bash
# Lab 36: Managing Environment Files and Secrets with Podman
# Commands Executed During Lab (sequential, no explanations)

mkdir podman-secrets-lab && cd podman-secrets-lab

pwd

nano .env

cat .env

podman run --rm --env-file=.env alpine env | grep -E 'APP_NAME|DB_'

echo "TopSecretPassword" > db_password.txt

podman secret create db_password_secret db_password.txt

podman secret ls

podman run --rm --secret=db_password_secret alpine cat /run/secrets/db_password_secret

nano docker-compose.yml

cat docker-compose.yml

podman-compose --version

pip3 --version

python3 --version

sudo yum install -y python3-pip

pip3 --version

pip3 install --user podman-compose

export PATH=$PATH:/home/centos/.local/bin

podman-compose --version

podman-compose up

podman secret rm db_password_secret

cd .. && rm -rf podman-secrets-lab
