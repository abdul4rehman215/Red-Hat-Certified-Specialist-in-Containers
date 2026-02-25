#!/bin/bash

# Lab 02 - Exploring Podman CLI
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup Verification
# --------------------------------------------
podman --version

# --------------------------------------------
# Task 1: Listing Containers
# --------------------------------------------
podman ps
podman ps -a

# --------------------------------------------
# Task 2: Running a Container (Interactive)
# --------------------------------------------
podman run -it --name my_alpine alpine sh
# Inside container:
# exit

# Verify running containers (expected empty after exit)
podman ps

# --------------------------------------------
# Task 3: Stopping a Container
# Note: my_alpine is exited after leaving the shell, start then stop
# --------------------------------------------
podman start my_alpine
podman stop my_alpine
podman ps -a

# --------------------------------------------
# Task 4: Restarting a Container
# --------------------------------------------
podman restart my_alpine
podman ps

# --------------------------------------------
# Task 5: Removing a Container
# --------------------------------------------
podman stop my_alpine
podman rm my_alpine
podman ps -a

# --------------------------------------------
# Task 6: Inspecting Container Details
# --------------------------------------------
podman run -d --name nginx_container nginx
podman inspect nginx_container

# Clean up
podman stop nginx_container && podman rm nginx_container
