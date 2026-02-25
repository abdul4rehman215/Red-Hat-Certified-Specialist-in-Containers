#!/bin/bash

# Lab 09 - Using ENTRYPOINT and CMD in Containerfiles
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Setup
# --------------------------------------------
mkdir entrypoint-cmd-lab && cd entrypoint-cmd-lab

# --------------------------------------------
# Task 1: ENTRYPOINT + CMD (exec form)
# --------------------------------------------
nano Containerfile
cat Containerfile
podman build -t entrypoint-demo .

# --------------------------------------------
# Task 2: Testing behavior
# --------------------------------------------
podman run --rm entrypoint-demo
podman run --rm entrypoint-demo "Custom message"

# --------------------------------------------
# Task 3: Script-based ENTRYPOINT
# --------------------------------------------
nano greet.sh
chmod +x greet.sh
ls -l greet.sh

nano Containerfile
cat Containerfile

podman build -t greet-demo .
podman run --rm greet-demo
podman run --rm greet-demo "Container Workshop" "Instructor"

# --------------------------------------------
# Task 4: Override ENTRYPOINT
# --------------------------------------------
podman run --rm --entrypoint echo greet-demo "This completely replaces the ENTRYPOINT"

# --------------------------------------------
# Task 5: Shell form vs Exec form
# --------------------------------------------
nano Containerfile
podman build -t shellform-demo .
podman run --rm shellform-demo

# --------------------------------------------
# Cleanup
# --------------------------------------------
podman rmi entrypoint-demo greet-demo shellform-demo
