#!/bin/bash

# Lab 05 - Managing Container Images (Podman)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup: Ensure Podman Installed
# --------------------------------------------
sudo apt-get update
sudo apt-get install -y podman
podman --version

# --------------------------------------------
# Task 1: Search for Images on Docker Hub
# --------------------------------------------
podman search ubuntu
podman search --filter=is-official=true ubuntu

# Troubleshooting flow (rate-limit / authentication)
podman login docker.io

# --------------------------------------------
# Task 2: Pull Container Images
# --------------------------------------------
podman pull docker.io/library/ubuntu:latest
podman images

podman pull docker.io/library/ubuntu:20.04
podman images

# --------------------------------------------
# Task 3: Inspect Image Metadata
# --------------------------------------------
podman inspect docker.io/library/ubuntu:latest
podman inspect --format "{{.Config.Env}}" docker.io/library/ubuntu:latest

# --------------------------------------------
# Task 4: Remove Container Images
# --------------------------------------------
podman rmi docker.io/library/ubuntu:20.04
podman images

# Remove unused images
podman image prune -a
