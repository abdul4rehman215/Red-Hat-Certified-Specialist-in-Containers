#!/bin/bash
# Lab 24: Setting WORKDIR and USER Instructions
# Commands Executed During Lab (sequential, no explanations)

podman --version

mkdir container-security-lab && cd container-security-lab
pwd

touch Containerfile

nano Containerfile
cat Containerfile

nano Containerfile
cat Containerfile

podman build -t workdir-demo .

podman run --rm workdir-demo cat /tmp/workdir.log

nano Containerfile
cat Containerfile

nano Containerfile
cat Containerfile

podman build -t nonroot-demo .

podman run --rm nonroot-demo cat /tmp/user.log

podman run --rm nonroot-demo touch /sys/kernel/profiling

podman run -d --name testuser nonroot-demo sleep 300

podman exec testuser ps -ef

podman run --rm --user root workdir-demo whoami

podman run --rm nonroot-demo whoami

podman rm -f testuser

podman rmi workdir-demo nonroot-demo

cd ..

rm -rf container-security-lab
