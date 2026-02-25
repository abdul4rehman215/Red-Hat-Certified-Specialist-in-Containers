#!/bin/bash
# Lab 35: Inspecting Containers and Images with Podman
# Commands Executed During Lab (sequential, no explanations)

sudo dnf install -y podman
sudo yum install -y podman

podman --version

podman pull docker.io/library/nginx:alpine

podman run -d --name my_nginx -p 8080:80 nginx:alpine

podman inspect my_nginx | head -n 30

podman inspect nginx:alpine | head -n 30

podman inspect my_nginx --format '{{.NetworkSettings.IPAddress}}'

podman inspect my_nginx --format '{{.Created}}'

podman run -d --name env_test -e APP_COLOR=blue -e APP_MODE=prod nginx:alpine

podman inspect env_test --format '{{.Config.Env}}'

podman inspect env_test --format '{{range .Config.Env}}{{if eq (index (split . "=") 0) "APP_COLOR"}}{{.}}{{end}}{{end}}'

podman inspect env_test --format '{{.Config.Env}}' | tr ' ' '\n' | grep '^APP_COLOR='

podman run -d --name vol_test -v /tmp:/container_tmp nginx:alpine

podman inspect vol_test --format '{{.Mounts}}'

podman inspect my_nginx --format '{{.NetworkSettings.Ports}}'

podman inspect my_nginx --format '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}'

podman run --name fail_test alpine sh -c "exit 3"

podman inspect fail_test --format '{{.State.ExitCode}}'

jq --version

sudo yum install -y jq

podman inspect my_nginx --format '{{json .State}}' | jq

podman stop my_nginx env_test vol_test

podman rm my_nginx env_test vol_test fail_test

podman rmi nginx:alpine
