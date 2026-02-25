#!/bin/bash

# Lab 07 - Layer Caching and Optimization
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup
# --------------------------------------------
podman --version
mkdir layer-optimization-lab && cd layer-optimization-lab

# --------------------------------------------
# Task 1: Create Initial Dockerfile + App
# --------------------------------------------
nano Dockerfile.initial
nano app.py
ls -l

# Build initial image
podman build -t myapp:initial -f Dockerfile.initial .
podman images myapp:initial

# --------------------------------------------
# Task 2: Optimize the Dockerfile
# --------------------------------------------
nano Dockerfile.optimized

# Build optimized image
podman build -t myapp:optimized -f Dockerfile.optimized .
podman images myapp:*
podman images myapp:optimized

# --------------------------------------------
# Task 3: Leverage Build Cache
# --------------------------------------------
# Modify app.py to observe cache behavior
nano app.py

# Rebuild optimized image (cache behavior observation)
podman build -t myapp:optimized -f Dockerfile.optimized .

# Cache busting (edit Dockerfile.optimized to add ARG/RUN)
nano Dockerfile.optimized

# Rebuild with different CACHEBUST value
podman build -t myapp:optimized --build-arg CACHEBUST=$(date +%s) -f Dockerfile.optimized .

# --------------------------------------------
# Task 4: Inspect Layers
# --------------------------------------------
podman history myapp:optimized
podman inspect myapp:optimized | head -n 35

# Install and run dive (fallback install via .deb)
sudo apt-get install dive
wget -qO dive.deb https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_linux_amd64.deb
sudo dpkg -i dive.deb
dive myapp:optimized

# --------------------------------------------
# Task 5: Advanced Optimization (Multi-stage)
# --------------------------------------------
nano requirements.txt
nano Dockerfile.multistage

podman build -t myapp:multistage -f Dockerfile.multistage .
podman images myapp:*

# --------------------------------------------
# Verification run (port conflict handling + test)
# --------------------------------------------
podman ps
podman stop dreamy_mendel
podman rm dreamy_mendel

podman run -d -p 8080:8080 myapp:optimized
curl localhost:8080

# Compare image sizes
podman images myapp:*
