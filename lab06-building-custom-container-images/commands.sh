#!/bin/bash

# Lab 06 - Building Custom Container Images (Podman)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Verify Podman Installation
# --------------------------------------------
podman --version

# --------------------------------------------
# Task 1: Create Build Context + Files
# --------------------------------------------
mkdir custom-nginx && cd custom-nginx
echo "<h1>Welcome to My Custom Nginx Container!</h1>" > index.html

# Create Containerfile using nano editor (manual step)
nano Containerfile

# Verify files created
ls -l

# --------------------------------------------
# Task 2: Build and Tag the Image
# --------------------------------------------
podman build -t my-custom-nginx .
podman images

# --------------------------------------------
# Task 3: Run and Validate the Container
# --------------------------------------------
podman run -d -p 8080:80 my-custom-nginx
podman ps
curl http://localhost:8080
