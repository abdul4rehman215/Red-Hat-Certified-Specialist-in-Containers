# 🛠️ Troubleshooting Guide — Lab 19: Deploying StatefulSets (MySQL)

> This document covers common StatefulSet issues: PVC Pending, pod startup failures, DNS identity problems, and cleanup.

---

## 1) PVC stuck in `Pending`
### ✅ Symptom
`kubectl get pvc` shows `Pending`, and pods remain `Pending` or `ContainerCreating`.

### 📌 Likely Causes
- No default StorageClass
- Provisioner not running
- Wrong StorageClass name in manifest (`storageClassName`)

### ✅ Fix
1) Check StorageClasses:
```bash
kubectl get storageclass
````

2. Confirm the StorageClass referenced exists (this lab uses `standard`):

* `storageClassName: "standard"`

3. In Minikube, ensure storage provisioner addon is enabled:

```bash id="g1x2o3"
minikube addons enable storage-provisioner
```

---

## 2) MySQL pod stuck in `ContainerCreating`

### ✅ Symptom

Pod stays in ContainerCreating.

### 📌 Likely Cause

Volume mount not ready (PVC/PV issues) or node storage constraints.

### ✅ Fix

Describe pod:

```bash id="y2p4r8"
kubectl describe pod mysql-0
```

Check **Events** for mount or provisioning errors.

---

## 3) MySQL pod crashes (`CrashLoopBackOff`)

### ✅ Symptom

`kubectl get pods` shows CrashLoopBackOff.

### 📌 Likely Causes

* missing/invalid `MYSQL_ROOT_PASSWORD`
* corrupted volume data from previous runs
* insufficient disk or permissions

### ✅ Fix

1. Check logs:

```bash id="w2h0s8"
kubectl logs mysql-0 | tail -n 80
```

2. If volume contains old data and you want a fresh run, delete PVCs (data loss):

```bash id="x8m2k3"
kubectl delete pvc mysql-persistent-storage-mysql-0 mysql-persistent-storage-mysql-1
```

---

## 4) DNS identity not resolving

### ✅ Symptom

`nslookup mysql` fails or returns nothing.

### 📌 Likely Causes

* Headless service missing or wrong selector
* Service name mismatch vs StatefulSet `serviceName`
* CoreDNS issues

### ✅ Fix

1. Confirm service exists and is headless:

```bash id="t1v7o9"
kubectl get svc mysql -o yaml | head -n 50
```

Look for:

* `clusterIP: None`
* selector matches `app: mysql`

2. Confirm pod labels match:

```bash id="w0c7m1"
kubectl get pods --show-labels | grep mysql
```

3. Re-run nslookup test:

```bash id="r5y5e3"
kubectl run -it --rm --image=busybox:1.28 test --restart=Never -- nslookup mysql
```

---

## 5) Data did not persist after deleting `mysql-0`

### ✅ Symptom

After recreation, `lab_test` is missing.

### 📌 Likely Causes

* Pod recreated with a new PVC (should not happen if StatefulSet is correct)
* PVC was deleted or storage provisioner wiped data
* You connected to the wrong instance

### ✅ Fix

1. Confirm PVC names:

```bash id="t7c1p3"
kubectl get pvc | grep mysql-persistent-storage
```

2. Confirm mysql-0 is using mysql-0 PVC:

```bash id="d4n2g6"
kubectl describe pod mysql-0 | grep -A 8 "Volumes"
```

3. Verify database again:

```bash id="e1u8k2"
kubectl exec -it mysql-0 -- mysql -uroot -ppassword -e "SHOW DATABASES;"
```

---

## 6) Ordered creation/deletion expectations

### ✅ Symptom

You expect pods to come up in order but they look delayed.

### ✅ Explanation

StatefulSets create pods in ordinal order and usually wait for readiness.

### ✅ Fix

Check rollout status:

```bash id="o2y1z0"
kubectl rollout status statefulset/mysql
```

---

## 7) Cleanup leaves PVCs behind

### ✅ Symptom

After deleting StatefulSet/Service, PVCs remain.

### ✅ Explanation

PVCs are intentionally preserved to avoid accidental data loss.

### ✅ Fix

List PVCs:

```bash id="q2j8m2"
kubectl get pvc | grep mysql || true
```

Delete PVCs if you want full cleanup (data loss):

```bash id="p1x7c8"
kubectl delete pvc mysql-persistent-storage-mysql-0 mysql-persistent-storage-mysql-1
```

---

## ✅ Quick Debug Flow

1. Check resources:

```bash id="d4o2q3"
kubectl get statefulset,pods,pvc
```

2. Inspect events:

```bash
kubectl describe pod mysql-0
```

3. Check logs:

```bash
kubectl logs mysql-0 | tail -n 80
```

4. DNS check:

```bash
kubectl run -it --rm --image=busybox:1.28 test --restart=Never -- nslookup mysql
```
