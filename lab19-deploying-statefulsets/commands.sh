#!/bin/bash

# Lab 19 - Deploying StatefulSets (MySQL)
# Commands Executed During Lab (Sequential)

# --------------------------------------------
# Task 1: Write + Validate StatefulSet Manifest
# --------------------------------------------
mkdir -p k8s-statefulset-lab
cd k8s-statefulset-lab

nano mysql-statefulset.yaml

# Client-side validation
kubectl apply -f mysql-statefulset.yaml --dry-run=client

# --------------------------------------------
# Task 2: Deploy StatefulSet + Headless Service
# --------------------------------------------
kubectl apply -f mysql-statefulset.yaml

nano mysql-service.yaml
kubectl apply -f mysql-service.yaml

kubectl get statefulset,pods,pvc

# --------------------------------------------
# Task 3: Verify Persistence + Network Identity
# --------------------------------------------
kubectl get pods -l app=mysql -o wide

# Create database on mysql-0
kubectl exec -it mysql-0 -- mysql -uroot -ppassword -e "CREATE DATABASE lab_test;"

# Delete mysql-0 and observe recreation
kubectl delete pod mysql-0
kubectl get pods -l app=mysql
kubectl get pods -l app=mysql

# Verify DB persists on recreated mysql-0
kubectl exec -it mysql-0 -- mysql -uroot -ppassword -e "SHOW DATABASES;"

# DNS resolution test (busybox)
kubectl run -it --rm --image=busybox:1.28 test --restart=Never -- nslookup mysql

# Troubleshooting checks
kubectl get storageclass
kubectl logs mysql-0 | head -15

# --------------------------------------------
# Cleanup
# --------------------------------------------
kubectl delete -f mysql-statefulset.yaml -f mysql-service.yaml

# Optional: confirm PVCs remain
kubectl get pvc | grep mysql || echo "No MySQL PVCs found"

# Optional: delete PVCs explicitly (if desired)
kubectl delete pvc mysql-persistent-storage-mysql-0 mysql-persistent-storage-mysql-1
