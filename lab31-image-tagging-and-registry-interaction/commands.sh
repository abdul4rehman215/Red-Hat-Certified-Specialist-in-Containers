#!/bin/bash
# Lab 31: Image Tagging and Registry Interaction
# Commands Executed During Lab (sequential, no explanations)

podman images

podman pull docker.io/library/nginx:latest

podman tag docker.io/library/nginx my-nginx:v1.0

podman images | grep nginx

podman login docker.io

podman info | grep -A 5 "registries"

podman tag my-nginx:v1.0 docker.io/abdul4rehman215/my-nginx:v1.0

podman push docker.io/abdul4rehman215/my-nginx:v1.0

podman rmi docker.io/abdul4rehman215/my-nginx:v1.0

podman pull docker.io/abdul4rehman215/my-nginx:v1.0

podman images | grep -E 'my-nginx|nginx'

podman inspect --format '{{.Digest}}' docker.io/abdul4rehman215/my-nginx:v1.0

skopeo inspect docker://docker.io/abdul4rehman215/my-nginx:v1.0 | grep -i Digest

podman pull docker.io/abdul4rehman215/my-nginx@sha256:8f1f2a3b4c5d6e7f8091a2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f7

skopeo inspect docker://docker.io/abdul4rehman215/my-nginx:v1.0 | grep -i Digest

podman rmi -f $(podman images -q)
