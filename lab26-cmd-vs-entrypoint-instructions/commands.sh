#!/bin/bash
# Lab 26: CMD vs ENTRYPOINT Instructions
# Commands Executed During Lab (sequential, no explanations)

podman --version

mkdir cmd-entrypoint-lab && cd cmd-entrypoint-lab
pwd

nano Containerfile.cmd
cat Containerfile.cmd

podman build -t cmd-demo -f Containerfile.cmd .
podman run cmd-demo

podman run cmd-demo echo "Overridden command"

nano Containerfile.entrypoint
cat Containerfile.entrypoint

podman build -t entrypoint-demo -f Containerfile.entrypoint .
podman run entrypoint-demo

podman run entrypoint-demo "with appended text"

nano Containerfile.combined
cat Containerfile.combined

podman build -t combined-demo -f Containerfile.combined .
podman run combined-demo

podman run combined-demo "Custom message"

nano entrypoint.sh
cat entrypoint.sh

nano Containerfile.script
cat Containerfile.script

podman build -t script-demo -f Containerfile.script .
podman run script-demo

podman run --entrypoint /bin/ls script-demo -l /

podman images | grep -E 'cmd-demo|entrypoint-demo|combined-demo|script-demo'

podman run --rm combined-demo "Lab completed successfully!"

podman rmi cmd-demo entrypoint-demo combined-demo script-demo
