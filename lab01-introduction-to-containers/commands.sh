#!/bin/bash

# Lab 01 - Introduction to Containers (Podman)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup: Install Podman (Ubuntu/Debian)
# --------------------------------------------
sudo apt-get update
sudo apt-get install -y podman

# Verify Podman installation
podman --version

# --------------------------------------------
# Task 2: Pull and Run a Simple Container
# --------------------------------------------
podman pull hello-world
podman run hello-world

# Verify container execution history
podman ps -a

# --------------------------------------------
# Task 3: Exploring Container Isolation
# --------------------------------------------
podman run -it alpine sh

# Inside the container (Alpine)
cat /etc/os-release
exit

# --------------------------------------------
# Troubleshooting / Runtime Migration
# --------------------------------------------
podman system migrate
