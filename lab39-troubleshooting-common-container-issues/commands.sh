#!/bin/bash
# Lab 39: Troubleshooting Common Container Issues
# Commands Executed During Lab (sequential, no explanations)

podman run -d --name res-test docker.io/library/nginx:alpine

podman ps

podman inspect a1b2c3d4e5f6 | grep -i "memory\|cpu"

podman stats a1b2c3d4e5f6 --no-stream

podman update --memory 512m a1b2c3d4e5f6

podman inspect a1b2c3d4e5f6 | grep -i "Memory" | head

sudo ausearch -m avc -ts recent | tail -n 8

sudo setenforce 0

getenforce

mkdir -p ~/badmount && echo "TOPSECRET" > ~/badmount/secret.txt

ls -Z ~/badmount/secret.txt

sudo chcon -Rt container_file_t /home/centos/badmount

ls -Z ~/badmount/secret.txt

sudo setenforce 1

getenforce

podman run -d --name port1 -p 8080:80 docker.io/library/nginx:alpine

sudo ss -tulnp | grep 8080

podman run -d --name port2 -p 8080:80 docker.io/library/nginx:alpine

podman stop -f port1

podman inspect a1b2c3d4e5f6 --format '{{.NetworkSettings.SandboxKey}}'

podman inspect --format '{{.State.Pid}}' a1b2c3d4e5f6

sudo nsenter -n -t 3021 ip a

podman inspect a1b2c3d4e5f6 --format '{{.Config.User}}'

podman run --rm -it --user root docker.io/library/alpine /bin/sh

podman run --rm -v /home/centos/badmount:/data:Z -it docker.io/library/alpine /bin/sh

podman logs res-test | tail -n 5

podman rm -f res-test port1 port2 2>/dev/null; rm -rf ~/badmount
