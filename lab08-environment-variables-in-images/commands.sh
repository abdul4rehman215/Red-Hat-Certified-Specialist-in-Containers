#!/bin/bash

# Lab 08 - Environment Variables in Images (ENV + ARG)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup: Verify Podman
# --------------------------------------------
podman --version

# --------------------------------------------
# Task 1: Define ENV in Containerfile
# --------------------------------------------
mkdir env-lab && cd env-lab
nano Containerfile
cat Containerfile

podman build -t env-demo .
podman run env-demo

# --------------------------------------------
# Task 2: Override ENV at runtime
# --------------------------------------------
podman run -e APP_ENV="production" -e APP_VERSION="2.0" env-demo

# Use environment file
nano app.env
cat app.env
podman run --env-file=app.env env-demo

# --------------------------------------------
# Task 3: Inspect variables in running containers
# --------------------------------------------
podman run -d --name env-container env-demo
podman exec env-container env

# Fix: container exits immediately; run long-lived command and inspect
podman rm env-container
podman run -d --name env-container env-demo sh -c 'sleep 300'
podman exec env-container env

# --------------------------------------------
# Task 4: Use ARG for build-time variables
# --------------------------------------------
nano Containerfile
cat Containerfile

podman build --build-arg APP_BUILD_NUMBER=42 -t arg-demo .
podman run arg-demo

# --------------------------------------------
# Cleanup
# --------------------------------------------
podman rm -f $(podman ps -aq)
podman rmi env-demo arg-demo
