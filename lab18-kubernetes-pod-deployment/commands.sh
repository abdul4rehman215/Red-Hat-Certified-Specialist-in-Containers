#!/bin/bash

# Lab 18 - Kubernetes Pod Deployment
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Task 1: Write Pod YAML Manifest
# --------------------------------------------
mkdir -p k8s-pod-lab
cd k8s-pod-lab

nano simple-pod.yaml
cat simple-pod.yaml

# --------------------------------------------
# Task 2: Deploy the Pod
# --------------------------------------------
kubectl apply -f simple-pod.yaml
kubectl get pods

# --------------------------------------------
# Task 3: Inspect Pod Status and Logs
# --------------------------------------------
kubectl describe pod nginx-pod
kubectl logs nginx-pod | head -25

# --------------------------------------------
# Optional: Access Pod via Port Forward
# --------------------------------------------
kubectl port-forward nginx-pod 8080:80

# In a second terminal (or after starting port-forward), test:
# curl -I http://localhost:8080 | head -10

# Stop port-forward with Ctrl+C when done
