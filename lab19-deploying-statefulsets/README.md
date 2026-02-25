# 🧪 Lab 19: Deploying StatefulSets (MySQL + PVC Templates + Stable DNS)

## 📌 Lab Summary
This lab demonstrates deploying a **StatefulSet** in Kubernetes for a stateful workload (MySQL). It focuses on:
- Creating a StatefulSet with `volumeClaimTemplates` (one PVC per replica)
- Deploying a headless Service for stable DNS identities
- Verifying stable pod naming (`mysql-0`, `mysql-1`)
- Verifying persistent storage survives pod recreation
- Verifying DNS resolves to individual StatefulSet pods (`mysql-0.mysql`, `mysql-1.mysql`)
- Cleaning up resources and optionally removing PVCs

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Explain the purpose of StatefulSets for stateful applications
- Deploy a StatefulSet manifest using `kubectl`
- Verify per-pod persistent storage via PVC templates
- Validate stable network identity with headless service DNS
- Confirm data persists after deleting and recreating a StatefulSet pod

---

## ✅ Prerequisites
- Running Kubernetes/OpenShift cluster (e.g., Minikube / Kind / OpenShift Local)
- `kubectl` (or `oc`) installed and configured
- StorageClass available (Minikube typically provides `standard`)
- Basic understanding of Pods, PVCs, Services

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Cluster | Minikube |
| Namespace | `default` |
| StatefulSet | `mysql` |
| Replicas | `2` |
| Image | `mysql:8.0` |
| Root Password | `password` (lab value) |
| StorageClass | `standard` |
| PVC Size | `1Gi` each |
| Headless Service | `mysql` (`clusterIP: None`) |
| Pod IPs (example) | `10.244.0.21`, `10.244.0.22` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab19-deploying-statefulsets/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── mysql-statefulset.yaml
    └── mysql-service.yaml
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Write a StatefulSet Manifest

* Created `mysql-statefulset.yaml` with:

  * `replicas: 2`
  * `serviceName: "mysql"`
  * MySQL container with:

    * env `MYSQL_ROOT_PASSWORD=password`
    * port `3306`
    * volume mount `/var/lib/mysql`
  * `volumeClaimTemplates` to dynamically create one PVC per pod:

    * `mysql-persistent-storage-mysql-0`
    * `mysql-persistent-storage-mysql-1`

* Validated YAML client-side:

  * `kubectl apply --dry-run=client`

### ✅ Task 2: Deploy Stateful App + Headless Service

* Applied StatefulSet manifest

* Created and applied headless service `mysql-service.yaml`:

  * `clusterIP: None`
  * selector `app: mysql`
  * port `3306`

* Verified resources:

  * `kubectl get statefulset,pods,pvc`
  * confirmed 2/2 ready, 2 pods running, 2 PVCs bound

### ✅ Task 3: Verify Persistence + Stable Network Identity

* Verified stable pod names and IPs:

  * `kubectl get pods -l app=mysql -o wide`
* Persistence test:

  * created database `lab_test` on `mysql-0`
  * deleted pod `mysql-0`
  * confirmed pod recreated as `mysql-0`
  * verified `lab_test` still exists (PVC preserved)
* DNS test using BusyBox:

  * `nslookup mysql` returned:

    * `mysql-0.mysql.default.svc.cluster.local`
    * `mysql-1.mysql.default.svc.cluster.local`

### 🧹 Cleanup

* Deleted StatefulSet and Service manifests
* Noted that PVCs may remain and can be deleted manually (optional)

---

## ✅ Verification & Validation

* StatefulSet ready: `2/2`
* Pods running: `mysql-0`, `mysql-1`
* PVCs bound: one per pod
* After deleting `mysql-0`, recreated pod retained data (`lab_test`)
* Headless service DNS resolved to stable pod identities and IPs

---

## 🧠 What I Learned

* StatefulSets are designed for workloads needing:

  * stable pod names and identities
  * ordered deployment and scaling
  * persistent storage tied to each replica
* `volumeClaimTemplates` automatically creates per-replica PVCs
* Headless services (`clusterIP: None`) enable stable DNS records for each pod
* Deleting a StatefulSet pod does not delete its PVC, enabling data persistence

---

## 🌍 Why This Matters

Stateful workloads like databases, message queues, and storage systems rely on:

* stable identity
* persistent storage
* predictable scaling

StatefulSets provide these guarantees and are critical for operating stateful services in Kubernetes/OpenShift.

---

## ✅ Result

* Successfully deployed MySQL as a StatefulSet with two replicas
* Confirmed persistent storage survives pod recreation
* Verified stable DNS identity via headless service

---

## ✅ Conclusion

This lab established the practical differences between stateless and stateful deployments in Kubernetes. By combining StatefulSets, PVC templates, and a headless Service, I deployed a MySQL workload with durable storage and stable network identity—matching real-world patterns for stateful apps.
