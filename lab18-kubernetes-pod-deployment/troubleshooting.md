# 🛠️ Troubleshooting Guide — Lab 18: Kubernetes Pod Deployment

> This document covers common Pod deployment issues and the fastest commands to diagnose them.

---

## 1) `kubectl apply` fails (YAML error)
### ✅ Symptom
- `error: error parsing simple-pod.yaml...`
- or indentation / syntax errors

### ✅ Fix
Validate YAML structure:
```bash
cat simple-pod.yaml
````

Common issues:

* wrong indentation under `spec:`
* missing `-` for list items under `containers:` or `ports:`

---

## 2) Pod stuck in `Pending`

### ✅ Symptom

`kubectl get pods` shows `Pending`.

### 📌 Likely Causes

* Node resource pressure (CPU/memory)
* Scheduling constraints (taints/tolerations, selectors)
* Image pull delays

### ✅ Fix

Describe the pod and check **Events**:

```bash
kubectl describe pod nginx-pod
```

Look for messages like:

* `FailedScheduling`
* `Insufficient cpu`
* `Insufficient memory`

---

## 3) Pod in `ImagePullBackOff` / `ErrImagePull`

### ✅ Symptom

Pod fails to pull image.

### 📌 Likely Causes

* wrong image name/tag
* registry access issues (DNS/proxy)
* auth required for private registry

### ✅ Fix

Check events:

```bash id="g0y8t1"
kubectl describe pod nginx-pod
```

Try pulling manually on the node (if applicable) or switch to a known-good tag.

---

## 4) Pod in `CrashLoopBackOff`

### ✅ Symptom

Pod restarts repeatedly.

### ✅ Fix

1. Check logs:

```bash
kubectl logs nginx-pod
```

2. If multiple containers exist, specify container:

```bash id="3y9o3u"
kubectl logs nginx-pod -c nginx-container
```

3. Inspect events and exit codes:

```bash id="a3g6k0"
kubectl describe pod nginx-pod
```

---

## 5) `kubectl logs` shows nothing

### ✅ Symptom

Empty logs output.

### 📌 Likely Causes

* container did not start
* app logs elsewhere
* app hasn’t produced output yet

### ✅ Fix

Confirm container state via describe:

```bash id="r0x1p7"
kubectl describe pod nginx-pod
```

If the container started and is running, generate traffic (for Nginx you can use port-forward and curl).

---

## 6) Port-forward fails

### ✅ Symptom

`kubectl port-forward nginx-pod 8080:80` fails.

### 📌 Likely Causes

* local port 8080 already in use
* pod not running / not ready
* permission / kubeconfig context issues

### ✅ Fix

1. Check local port usage:

```bash
ss -tulnp | grep 8080 || true
```

2. Use a different local port:

```bash id="6p0d4b"
kubectl port-forward nginx-pod 8081:80
curl -I http://localhost:8081 | head -10
```

3. Confirm pod is running:

```bash id="v6n9q8"
kubectl get pods
```

---

## 7) “Connection refused” after port-forward

### ✅ Symptom

Port-forward is active but curl fails.

### 📌 Likely Causes

* container not listening on port 80
* wrong port mapping
* pod not ready yet

### ✅ Fix

1. Confirm container port in YAML:

* `containerPort: 80`

2. Confirm pod readiness:

```bash id="a0q4u6"
kubectl get pods
```

3. Describe for readiness and events:

```bash id="x7c6a2"
kubectl describe pod nginx-pod
```

---

## ✅ Quick Debug Flow

1. Status:

```bash
kubectl get pods
```

2. Details + events:

```bash
kubectl describe pod nginx-pod
```

3. Logs:

```bash
kubectl logs nginx-pod | head -50
```

4. Access test:

```bash
kubectl port-forward nginx-pod 8080:80
# in another terminal:
curl -I http://localhost:8080 | head -10
```
