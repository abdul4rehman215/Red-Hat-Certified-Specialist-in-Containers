# 🛠️ Troubleshooting Guide — Lab 20: Service and Ingress Setup (ClusterIP, NodePort, Ingress)

> This document covers common issues when exposing Kubernetes workloads via Services and Ingress.

---

## 1) Pod/Deployment not ready
### ✅ Symptom
- `kubectl get pods` shows `Pending` / `CrashLoopBackOff`
- Service has no endpoints

### ✅ Fix
1) Check pod status:
```bash
kubectl get pods
````

2. Describe the pod (events matter most):

```bash 
kubectl describe pod <nginx-pod-name>
```

3. Check logs:

```bash 
kubectl logs <nginx-pod-name> | tail -n 80
```

---

## 2) ClusterIP service works only inside cluster

### ✅ Symptom

Trying to access ClusterIP from your laptop/host fails.

### ✅ Explanation

ClusterIP is internal-only.

### ✅ Fix (for testing)

Use port-forward:

```bash 
kubectl port-forward svc/nginx-clusterip 8080:80
curl -I http://localhost:8080 | head -10
```

---

## 3) NodePort not accessible from host

### ✅ Symptom

`curl http://<node-ip>:<nodeport>` times out or refuses.

### 📌 Likely Causes

* Wrong node IP
* Firewall/security group blocking nodeport
* Service has no endpoints (pods not ready)

### ✅ Fix

1. Get node IP:

```bash 
kubectl get nodes -o wide
```

2. Confirm NodePort and endpoints:

```bash 
kubectl get svc nginx-nodeport
kubectl describe svc nginx-nodeport | tail -n 30
```

Look for:

* `NodePort: 30007/TCP`
* `Endpoints: <pod-ip>:80`

3. Test from inside cluster (if needed):

```bash 
kubectl run -it --rm --image=busybox:1.28 test --restart=Never -- wget -qO- http://nginx-nodeport:80 || true
```

---

## 4) NodePort port conflicts or “already allocated”

### ✅ Symptom

Service creation fails due to nodeport conflict.

### ✅ Fix

Let Kubernetes assign a random nodeport (default behavior) or specify a free nodeport manually.
Check existing NodePorts:

```bash 
kubectl get svc -A | grep NodePort || true
```

---

## 5) Ingress resource created but not reachable

### ✅ Symptom

* Ingress exists but hostname returns 404/timeout
* `kubectl get ingress` shows empty ADDRESS

### 📌 Likely Causes

* Ingress controller not installed/running
* Ingress class mismatch
* Controller not watching that namespace
* DNS/hosts not pointing to the ingress address

### ✅ Fix

1. Confirm ingress controller pod is running:

```bas
kubectl get pods -n ingress-nginx
```

2. Confirm ingress has an address:

```bash
kubectl get ingress nginx-ingress
```

3. Describe ingress for events:

```bash
kubectl describe ingress nginx-ingress
```

4. Check controller logs:

```bash
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller | tail -n 60
```

---

## 6) Hostname doesn’t resolve (`nginx.example.com`)

### ✅ Symptom

Curl says DNS could not resolve host.

### ✅ Fix

Add `/etc/hosts` entry mapping ingress IP → hostname:

```bash 
echo "192.168.49.2 nginx.example.com" | sudo tee -a /etc/hosts
```

Validate resolution:

```bash 
getent hosts nginx.example.com
```

---

## 7) Ingress returns 404 or default backend

### ✅ Symptom

Ingress responds but not with your app.

### 📌 Likely Causes

* Backend service name/port mismatch in Ingress YAML
* Wrong namespace assumptions
* Service not listening on the specified port

### ✅ Fix

Verify backend service and port:

```bash
kubectl get svc nginx-nodeport
kubectl describe svc nginx-nodeport | tail -n 25
```

Re-check Ingress YAML:

* backend `service.name` matches service name exactly
* backend port matches service port (80 here)

---

## ✅ Quick Debug Flow

1. Pod health:

```bash 
kubectl get pods
```

2. Service endpoints:

```bash 
kubectl describe svc nginx-nodeport | tail -n 30
```

3. Ingress controller health:

```bash
kubectl get pods -n ingress-nginx
```

4. Ingress + routing:

```bash
kubectl get ingress nginx-ingress
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller | tail -n 40
```
