#!/bin/bash
# Lab 23: ADD vs COPY Instruction in Dockerfiles
# Commands Executed During Lab (sequential, no explanations)

podman --version

mkdir add_vs_copy_lab && cd add_vs_copy_lab
pwd

echo "This is a test file for COPY instruction" > testfile.txt
cat testfile.txt

nano Dockerfile.copy
cat Dockerfile.copy

podman build -t copy-demo -f Dockerfile.copy .
podman run --rm copy-demo

nano Dockerfile.add
cat Dockerfile.add

podman build -t add-demo -f Dockerfile.add .
podman run --rm add-demo

tar -czf archive.tar.gz testfile.txt
ls -lh archive.tar.gz

nano Dockerfile.add-extract
cat Dockerfile.add-extract

podman build -t add-extract-demo -f Dockerfile.add-extract .
podman run --rm add-extract-demo

nano Dockerfile.add-url
cat Dockerfile.add-url

podman build -t add-url-demo -f Dockerfile.add-url .
podman run --rm add-url-demo

echo "Version 1" > version.txt
cat version.txt

nano Dockerfile.cache
cat Dockerfile.cache

podman build -t cache-demo -f Dockerfile.cache .

echo "Version 2" > version.txt
cat version.txt

podman build -t cache-demo -f Dockerfile.cache .

nano Dockerfile.cache-add
podman build -t cache-demo-add -f Dockerfile.cache-add .

echo "malicious content" > badfile
tar -czf bad.tar.gz badfile
ls -lh badfile bad.tar.gz

nano Dockerfile.security

podman build -t security-demo -f Dockerfile.security .

podman images

podman rmi copy-demo add-demo add-extract-demo add-url-demo cache-demo security-demo

rm -f testfile.txt archive.tar.gz badfile bad.tar.gz version.txt

ls
