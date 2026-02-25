#!/bin/bash
# Lab 22: Using RUN Instruction Efficiently
# Commands Executed During Lab (sequential, no explanations)

mkdir -p ~/run-lab-shell && cd ~/run-lab-shell

nano Dockerfile
cat Dockerfile

podman build -t run-lab-shell .

mkdir -p ~/run-lab-exec && cd ~/run-lab-exec

nano Dockerfile
cat Dockerfile

podman build -t run-lab-exec .

mkdir -p ~/inefficient-nginx && cd ~/inefficient-nginx

nano Dockerfile
cat Dockerfile

mkdir -p ~/optimized-nginx && cd ~/optimized-nginx

nano Dockerfile
cat Dockerfile

podman build -t optimized-nginx .

podman images | grep -E 'optimized-nginx|run-lab-shell'

podman history optimized-nginx

podman images
