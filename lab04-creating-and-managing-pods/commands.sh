#!/bin/bash

# Lab 04 - Creating and Managing Pods (Podman)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Task 1: Creating a Pod
# --------------------------------------------
podman pod create --name demo-pod -p 8080:80
podman pod list

# Add Nginx container to pod
podman run -d --pod demo-pod --name nginx-container docker.io/library/nginx:alpine

# Verify containers in pod (shows infra + nginx)
podman ps --pod

# --------------------------------------------
# Task 2: Running Multiple Containers in a Pod
# --------------------------------------------
# Pull and run Redis container in same pod
podman pull docker.io/library/redis:alpine
podman run -d --pod demo-pod --name redis-container docker.io/library/redis:alpine

# Verify membership via pod inspect + jq
jq --version
sudo apt-get update
sudo apt-get install -y jq
podman pod inspect demo-pod | jq '.Containers[].Names'

# Exec into nginx container
podman exec -it nginx-container sh

# Inside container (Alpine)
# ping redis-container
# apk add --no-cache iputils
# ping -c 4 redis-container
# exit

# --------------------------------------------
# Task 3: Inspecting Pod Networking and Volumes
# --------------------------------------------
# Inspect pod network options
podman pod inspect demo-pod | jq '.InfraConfig.NetworkOptions'

# View port mappings
podman port demo-pod

# Create a shared volume and mount it to containers in the pod
podman volume create shared-vol
podman run -d --pod demo-pod --name nginx2 \
  -v shared-vol:/data docker.io/library/nginx:alpine
podman run -d --pod demo-pod --name redis2 \
  -v shared-vol:/data docker.io/library/redis:alpine

# Verify shared volume functionality
podman exec -it nginx2 touch /data/testfile
podman exec -it redis2 ls /data

# --------------------------------------------
# Cleanup
# --------------------------------------------
podman pod rm -f demo-pod
podman volume rm shared-vol
