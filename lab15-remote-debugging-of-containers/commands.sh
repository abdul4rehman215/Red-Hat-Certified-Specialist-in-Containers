#!/bin/bash

# Lab 15 - Remote Debugging of Containers (Node.js + VS Code Attach)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Task 1: Build a sample Node.js app image (my-node-app)
# --------------------------------------------
mkdir -p ~/debug-lab && cd ~/debug-lab

nano server.js
nano Containerfile

podman build -t my-node-app .

# Run container with app + debug ports exposed
podman run -d -p 3000:3000 -p 9229:9229 --name debug-container my-node-app

# Verify container is running and ports are mapped
podman ps
curl -s http://localhost:3000

# --------------------------------------------
# Task 2: Mount source code for live debugging
# --------------------------------------------
podman stop debug-container
podman rm debug-container

podman run -d -p 3000:3000 -p 9229:9229 -v $(pwd):/app --name debug-container my-node-app
podman exec -it debug-container ls /app

# --------------------------------------------
# Task 3: VS Code attach debugging validation (port + logs)
# --------------------------------------------
podman port debug-container
podman logs debug-container | head -n 12

# --------------------------------------------
# Optional Cleanup
# --------------------------------------------
podman stop debug-container && podman rm debug-container
