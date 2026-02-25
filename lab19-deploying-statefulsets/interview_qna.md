# 🧠 Interview Q&A — Lab 19: Deploying StatefulSets (MySQL)

---

## 1) What problem does a StatefulSet solve that a Deployment does not?
StatefulSets provide **stable identity** and **stable storage** per replica. They guarantee:
- predictable pod names (mysql-0, mysql-1…)
- ordered creation and termination
- persistent volumes tied to each pod identity  
Deployments are designed for stateless workloads where replicas are interchangeable.

---

## 2) What does `serviceName` mean in a StatefulSet?
`serviceName` refers to a **headless Service** that provides stable DNS names for StatefulSet pods. It enables pod identities like:
- `mysql-0.mysql`
- `mysql-1.mysql`

---

## 3) What is a headless Service and why is it used here?
A headless service has:
```yaml
clusterIP: None
````

It doesn’t load-balance to a single virtual IP. Instead, DNS returns individual pod records, enabling stable per-pod addressing.

---

## 4) What does `volumeClaimTemplates` do?

It automatically creates a **PersistentVolumeClaim per pod replica**, using a naming pattern like:

* `mysql-persistent-storage-mysql-0`
* `mysql-persistent-storage-mysql-1`

Each pod gets its own durable storage.

---

## 5) Why is per-pod storage important for databases?

Databases store state on disk. Each replica needs its own storage to avoid data corruption and ensure consistency of local data files.

---

## 6) What does `ReadWriteOnce` mean for accessModes?

`ReadWriteOnce (RWO)` means the volume can be mounted read-write by **a single node** at a time. This is common for local/hostpath-backed volumes like Minikube.

---

## 7) How did you verify the StatefulSet successfully deployed?

Using:

```bash
kubectl get statefulset,pods,pvc
```

It showed:

* StatefulSet Ready 2/2
* pods mysql-0 and mysql-1 Running
* two PVCs Bound

---

## 8) How did you confirm stable pod identity?

By listing pods and observing stable names:

* `mysql-0`
* `mysql-1`
  and checking wide output:

```bash id="ympjkw"
kubectl get pods -l app=mysql -o wide
```

---

## 9) How did you test persistence of storage?

1. Created a database on `mysql-0`
2. Deleted pod `mysql-0`
3. Waited for it to be recreated as `mysql-0`
4. Verified the database still existed (`lab_test`)
   This confirmed the PVC kept the data.

---

## 10) Why does deleting a StatefulSet pod not delete its PVC?

PVCs are separate Kubernetes resources. StatefulSets intentionally preserve PVCs to protect data, even if pods are restarted or rescheduled.

---

## 11) How did you test DNS-based stable identity?

Using BusyBox:

```bash id="yoisv6"
kubectl run -it --rm --image=busybox:1.28 test --restart=Never -- nslookup mysql
```

It returned pod records:

* `mysql-0.mysql.default.svc.cluster.local`
* `mysql-1.mysql.default.svc.cluster.local`

---

## 12) What is the difference between scaling StatefulSets and Deployments?

StatefulSet scaling is ordered and preserves identity:

* when scaling up, it creates mysql-0 then mysql-1…
* when scaling down, it removes highest ordinal first (mysql-1 then mysql-0)

Deployments scale replicas without stable identity.

---

## 13) What common issues can block StatefulSet pods from starting?

* PVC stuck in Pending (no StorageClass / provisioner)
* insufficient resources
* incorrect environment variables (e.g., missing MySQL root password)
* image pull issues

---

## 14) Why is a StorageClass required for this lab?

Because `volumeClaimTemplates` requests dynamic provisioning. Without a StorageClass/provisioner, PVCs remain Pending and pods cannot mount storage.

---

## 15) What are real-world use cases for StatefulSets?

* Databases (MySQL, PostgreSQL)
* Distributed systems needing stable peers (ZooKeeper, Kafka)
* Storage clusters (Ceph components)
* Any workload requiring stable network IDs + persistent volumes
