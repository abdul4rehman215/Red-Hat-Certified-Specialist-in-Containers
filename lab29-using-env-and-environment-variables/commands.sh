#!/bin/bash
# Lab 29: Using ENV and Environment Variables with Podman
# Commands Executed During Lab (sequential, no explanations)

podman --version

mkdir env-lab && cd env-lab
pwd

nano Containerfile
cat Containerfile

podman build -t env-demo .
podman run env-demo

podman run -e APP_NAME="NewApp" env-demo

podman run -e APP_NAME="ProductionApp" -e APP_VERSION="2.0.0" env-demo

nano Containerfile
cat Containerfile

podman build -t multiline-env .
podman run multiline-env

nano README.md
cat README.md

grep -n "ENV" -A3 Containerfile
cat README.md

podman run -d --name envcheck multiline-env

podman inspect envcheck --format '{{ range .Config.Env }}{{ println . }}{{ end }}' | grep -E 'APP_NAME|APP_VERSION|APP_DESCRIPTION'

podman rm -f envcheck
