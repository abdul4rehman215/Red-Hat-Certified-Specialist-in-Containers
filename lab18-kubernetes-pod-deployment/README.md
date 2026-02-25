
# 🧪 Lab 18: Kubernetes Pod Deployment (Pod YAML + kubectl apply + logs)

## 📌 Lab Summary
This lab introduces the basics of deploying a **Kubernetes Pod** using a YAML manifest:
- Writing a Pod manifest (`simple-pod.yaml`)
- Deploying it with `kubectl apply`
- Verifying Pod status with `kubectl get pods`
- Inspecting details/events via `kubectl describe`
- Reviewing logs using `kubectl logs`
- Accessing the Pod using `kubectl port-forward` and validating with `curl`

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the structure of a Kubernetes Pod YAML manifest
- Deploy a basic Nginx Pod to a Kubernetes cluster
- Inspect Pod status, events, and runtime details for troubleshooting
- Retrieve Pod logs and validate service access via port-forwarding

---

## ✅ Prerequisites
- Access to a Kubernetes/OpenShift cluster (e.g., Minikube, Kind, OpenShift Local)
- `kubectl` (or `oc`) installed and configured
- Basic YAML understanding

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Cluster | Minikube |
| Namespace | `default` |
| Node | `minikube/192.168.49.2` |
| Pod Name | `nginx-pod` |
| Image | `nginx:latest` |
| Container Port | `80` |
| Pod IP | `10.244.0.15` |
| Access Method | `kubectl port-forward` → `localhost:8080` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab18-kubernetes-pod-deployment/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    └── simple-pod.yaml
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Write a Pod YAML Manifest

* Created working directory: `k8s-pod-lab`
* Created `simple-pod.yaml` defining:

  * `apiVersion: v1`
  * `kind: Pod`
  * metadata name: `nginx-pod`
  * label: `app=nginx`
  * one container:

    * name: `nginx-container`
    * image: `nginx:latest`
    * port: `80`

### ✅ Task 2: Deploy the Pod

* Applied manifest:

  * `kubectl apply -f simple-pod.yaml`
* Verified the Pod is running:

  * `kubectl get pods`

### ✅ Task 3: Inspect Pod Status and Logs

* Described Pod details:

  * scheduling, IP, node, mounts, events
* Viewed logs:

  * Nginx startup logs and runtime notices

### ✅ Optional: Access the Pod via Port Forward

* Forwarded local port `8080` → Pod port `80`
* Verified with:

  * `curl -I http://localhost:8080`
* Stopped port-forward (`Ctrl+C`)

---

## ✅ Verification & Validation

* `kubectl get pods` showed:

  * `nginx-pod` → `Running`, `1/1`, `0 restarts`
* `kubectl describe pod` confirmed:

  * successful scheduling
  * image pulled + container started
  * Pod IP and events present
* `kubectl logs` returned Nginx startup logs
* Port-forwarding worked:

  * HTTP `200 OK` from `localhost:8080`

---

## 🧠 What I Learned

* A Pod manifest requires: `apiVersion`, `kind`, `metadata`, `spec`
* `kubectl apply` creates resources declaratively
* `kubectl describe` is critical for debugging:

  * events show scheduling and image pull issues
* `kubectl logs` provides application startup/runtime output
* `kubectl port-forward` is a fast way to test Pod networking without creating a Service

---

## 🌍 Why This Matters

Pods are the foundational workload unit in Kubernetes/OpenShift. Understanding how to:

* create and deploy Pods
* inspect status and events
* retrieve logs
  is essential for troubleshooting real deployments and building toward Deployments, Services, and higher-level orchestration.

---

## ✅ Result

* Successfully deployed an Nginx Pod on Kubernetes
* Verified it running and inspected its configuration/events
* Retrieved logs and validated HTTP access via port-forward

---

## ✅ Conclusion

This lab provided a practical introduction to Kubernetes Pod deployment using a YAML manifest and basic `kubectl` troubleshooting commands. It established a repeatable workflow: **write → apply → verify → describe/logs → test access**.
