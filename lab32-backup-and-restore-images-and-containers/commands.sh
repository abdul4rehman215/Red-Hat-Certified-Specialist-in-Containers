#!/bin/bash
# Lab 32: Backup and Restore Images and Containers with Podman
# Commands Executed During Lab (sequential, no explanations)

podman --version

podman pull docker.io/library/alpine:latest

podman images

podman save -o alpine_backup.tar docker.io/library/alpine:latest

ls -lh alpine_backup.tar
file alpine_backup.tar

podman rmi docker.io/library/alpine:latest

podman load -i alpine_backup.tar

podman images

podman run -it --name myalpine docker.io/library/alpine:latest /bin/sh

podman commit myalpine my_custom_alpine:v1

podman images

podman run --rm my_custom_alpine:v1 cat /testfile

podman commit --help | grep -A5 "Limitations"

podman system df

podman rm -a

podman rmi -a

rm alpine_backup.tar
