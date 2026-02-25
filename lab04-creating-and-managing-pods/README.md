# 🧪 Lab 04: Creating and Managing Pods (Podman)

## 📌 Lab Summary
This lab introduces **Podman pods** and demonstrates how to:
- Create a pod with port mapping
- Run multiple containers inside a single pod (multi-container pattern)
- Verify shared **network namespace** between containers
- Create and validate a **shared volume** mounted across containers
- Inspect pod configuration using `podman pod inspect` and JSON parsing with `jq`

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the concept of **pods** in container orchestration
- Create and manage pods using Podman
- Run multiple containers in a single pod
- Inspect pod networking and port mappings
- Implement shared storage using Podman volumes and validate it across containers

---

## ✅ Prerequisites
- Linux-based system (Ubuntu 20.04+ or CentOS 8+ recommended)
- Podman installed
- Basic container understanding
- Rootless Podman configured (validated via `podman info` in general workflow)

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman | Installed and operational |
| Images Used | `nginx:alpine`, `redis:alpine`, infra/pause image |
| Tools Installed During Lab | `jq` (host), `iputils` (inside nginx:alpine container) |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab04-creating-and-managing-pods/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Creating a Pod

* Created a pod named `demo-pod` with port mapping:

  * Host `8080` → Pod `80`
* Verified pod existence and infra container using `podman pod list`

### ✅ Task 2: Running Multiple Containers in a Pod

* Ran an Nginx container inside the pod (`nginx-container`)
* Added a Redis container inside the same pod (`redis-container`)
* Verified pod container membership using:

  * `podman ps --pod`
  * `podman pod inspect demo-pod | jq '.Containers[].Names'`
* Validated shared network namespace by:

  * Entering `nginx-container`
  * Pinging `redis-container` hostname (after installing `iputils` inside Alpine)

### ✅ Task 3: Inspecting Pod Networking and Shared Volumes

* Inspected pod network options using:

  * `podman pod inspect demo-pod | jq '.InfraConfig.NetworkOptions'`
* Verified port mappings using:

  * `podman port demo-pod`
* Created a shared Podman volume (`shared-vol`)
* Mounted the same volume into two containers (`nginx2`, `redis2`)
* Verified shared storage by creating a file in one container and reading it from the other

### 🧹 Cleanup

* Removed pod forcefully:

  * `podman pod rm -f demo-pod`
* Removed shared volume:

  * `podman volume rm shared-vol`

---

## ✅ Verification & Validation

* Pod created and listed successfully (`podman pod list`)
* Pod includes infra + application containers (`podman ps --pod`)
* Both containers coexist in the same pod and are visible via inspect/jq
* Inter-container communication successful using hostname (`ping -c 4 redis-container`)
* Shared volume validated (`testfile` visible across containers)
* Port mapping validated (`80/tcp -> 0.0.0.0:8080`)

---

## 🧠 What I Learned

* Podman pods provide a **pod-like abstraction** similar to Kubernetes/OpenShift
* Containers in the same pod share networking and can communicate by name/localhost behavior patterns
* Pod networking and port mappings can be verified using `podman port` and `podman pod inspect`
* Shared volumes enable cross-container file sharing for common use cases (sidecars, shared cache, shared artifacts)
* Practical debugging often requires installing small utilities:

  * `jq` for JSON parsing on host
  * `iputils` to enable `ping` in minimal container images

---

## 🌍 Why This Matters

Pods are a core concept in Kubernetes/OpenShift. Understanding how multiple containers share:

* network namespace
* port mappings
* shared storage
  …is essential for designing real-world cloud-native deployments (web + cache, app + sidecar, logging agents, etc.).

---

## 🧩 Real-World Applications

* **Sidecar pattern** (app + logging/metrics agent)
* **Web + cache** deployments (nginx + redis)
* Shared storage for multi-container workflows (init containers, artifact sharing)
* Debugging network/service discovery inside orchestrated workloads

---

## ✅ Result

* Successfully created and managed a pod in Podman
* Ran multiple containers inside the pod and verified networking
* Implemented shared volume mounts across containers and validated shared file visibility
* Cleaned up resources to keep environment tidy

---

## ✅ Conclusion

This lab demonstrated how Podman pods can model multi-container workloads similarly to Kubernetes pods. I created a pod, deployed multiple containers into it, verified shared networking and port mapping, and implemented shared storage using a Podman volume—building a strong foundation for OpenShift/Kubernetes pod concepts.
