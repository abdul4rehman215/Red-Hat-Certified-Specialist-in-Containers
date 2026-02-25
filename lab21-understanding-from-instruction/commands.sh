#!/bin/bash
# Lab 21: Understanding the FROM Instruction
# Commands Executed During Lab (sequential, no explanations)

podman --version

mkdir from-lab && cd from-lab
pwd

podman search registry.access.redhat.com/ubi8

skopeo inspect docker://registry.access.redhat.com/ubi8/ubi:latest

sudo dnf install -y skopeo
sudo yum install -y skopeo

skopeo inspect docker://registry.access.redhat.com/ubi8/ubi:latest

podman pull registry.access.redhat.com/ubi8/ubi:8.7

touch Containerfile
nano Containerfile
cat Containerfile

podman build -t my-base-image .

podman images

podman run --rm my-base-image cat /tmp/status.txt

podman rmi my-base-image

podman image prune -a
