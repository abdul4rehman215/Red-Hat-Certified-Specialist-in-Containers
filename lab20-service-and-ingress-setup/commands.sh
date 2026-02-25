#!/bin/bash

# Lab 20 - Service and Ingress Setup (Kubernetes)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Task 1: Deploy sample application
# --------------------------------------------
kubectl create deployment nginx --image=nginx:latest

kubectl get deployments
kubectl get pods

# --------------------------------------------
# Task 1.2: Expose using ClusterIP
# --------------------------------------------
kubectl expose deployment nginx --port=80 --type=ClusterIP --name=nginx-clusterip
kubectl get svc nginx-clusterip

# --------------------------------------------
# Task 1.3: Expose using NodePort
# --------------------------------------------
kubectl expose deployment nginx --port=80 --type=NodePort --name=nginx-nodeport
kubectl get svc nginx-nodeport

# Find node IP (Minikube example)
kubectl get nodes -o wide

# Test NodePort access (replace IP/port as needed)
curl -I http://192.168.49.2:30007 | head -10

# --------------------------------------------
# Task 2: OpenShift Route check (not available here)
# --------------------------------------------
oc version

# --------------------------------------------
# Task 2.2: Install ingress-nginx controller
# --------------------------------------------
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
kubectl get pods -n ingress-nginx

# --------------------------------------------
# Task 2.2: Create and apply Ingress resource
# --------------------------------------------
nano nginx-ingress.yaml
kubectl apply -f nginx-ingress.yaml

kubectl get ingress nginx-ingress

# --------------------------------------------
# Task 2.2: Test access via hostname
# --------------------------------------------
echo "192.168.49.2 nginx.example.com" | sudo tee -a /etc/hosts
curl -I http://nginx.example.com | head -12

# --------------------------------------------
# Troubleshooting checks
# --------------------------------------------
kubectl describe svc nginx-nodeport | tail -25
kubectl logs -n ingress-nginx ingress-nginx-controller-7cdbd8cdc8-2xqkh | tail -15
