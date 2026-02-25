#!/bin/bash
# Lab 27: Parameterized ENTRYPOINT Scripts
# Commands Executed During Lab (sequential, no explanations)

podman --version

mkdir entrypoint-lab && cd entrypoint-lab
pwd

nano entrypoint.sh
cat entrypoint.sh

chmod +x entrypoint.sh
ls -l entrypoint.sh

nano Dockerfile
cat Dockerfile

podman build -t entrypoint-demo .
podman run entrypoint-demo

nano entrypoint.sh
cat entrypoint.sh

nano Dockerfile
cat Dockerfile

podman build -t entrypoint-demo .
podman run entrypoint-demo

podman run entrypoint-demo ls -l /

nano entrypoint.sh
cat entrypoint.sh

nano Dockerfile
cat Dockerfile

podman build -t entrypoint-demo .

podman run -e ENV_MODE=development entrypoint-demo
podman run -e ENV_MODE=production entrypoint-demo
podman run entrypoint-demo

nano entrypoint.sh
cat entrypoint.sh

nano Dockerfile
cat Dockerfile

podman build -t entrypoint-demo .

podman run entrypoint-demo start production
podman run entrypoint-demo stop
podman run entrypoint-demo invalid
