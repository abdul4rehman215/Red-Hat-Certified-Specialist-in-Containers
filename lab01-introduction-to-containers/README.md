# 🧪 Lab 01: Introduction to Containers (Podman)

## 📌 Lab Summary
This lab introduces the fundamentals of containerization and provides hands-on practice using **Podman** to pull and run containers. The lab demonstrates:
- **Container portability** (consistent runtime across environments)
- **Process and filesystem isolation** (container runs its own user-space)
- Basic Podman workflows: **install → verify → pull → run → inspect**

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the core concepts of **containers** and **containerization**
- Explain **container isolation** vs. traditional virtualization
- Use **Podman** to pull images and run containers successfully
- Validate container execution using `podman ps -a`
- Confirm isolation by entering an Alpine container and checking `/etc/os-release`

---

## ✅ Prerequisites
- Linux-based system (Ubuntu 20.04+ recommended)
- Podman installed (installed during lab)
- Basic familiarity with command line

---

## 🧰 Lab Environment
> Note: Host identifiers and environment values are kept as captured from the lab terminal output.

| Component | Value |
|----------|------|
| OS | Ubuntu (cloud lab environment) |
| Container Engine | Podman |
| Images Used | `hello-world`, `alpine` |
| Access | sudo available |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab01-introduction-to-containers/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Key Concepts Covered

### 1) What is a Container?

A container is a lightweight, standalone executable package that includes everything required to run an application:

* application code
* runtime
* libraries
* configuration

Containers share the host OS kernel, making them faster and more efficient than full virtual machines.

### 2) Key Characteristics of Containers

* **Isolation**: Containers run in isolated user-space, reducing interference with host and other containers.
* **Portability**: The same container image runs consistently across environments (dev/test/prod).

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Understanding Container Basics

* Reviewed container fundamentals and how containers differ from VMs
* Focused on isolation and portability as core principles

### ✅ Task 2: Running a Simple Container with Podman

* Installed Podman on Ubuntu
* Verified installation with `podman --version`
* Pulled `hello-world` image from container registry
* Ran `hello-world` container and validated successful execution
* Confirmed container status using `podman ps -a`

### ✅ Task 3: Exploring Container Isolation

* Launched an interactive Alpine container (`podman run -it alpine sh`)
* Verified container OS identity using `/etc/os-release`
* Exited container and returned to host shell
* Ran `podman system migrate` for runtime configuration migration (rootless support / configuration update)

---

## ✅ Verification & Validation

* Podman installation verified:

  * `podman --version` returned **podman version 4.9.3**
* Image pull verified:

  * `podman pull hello-world` completed successfully
* Container execution verified:

  * `podman run hello-world` displayed successful hello-world message
* Container record verified:

  * `podman ps -a` showed container in **Exited (0)** state
* Isolation verified:

  * Inside container, `/etc/os-release` reported **Alpine Linux**

---

## 🧠 What I Learned

* How containers package applications for consistent execution
* How Podman can run containers without requiring a daemon (daemonless architecture concept)
* How to pull images and run containers using Podman CLI
* How to validate container lifecycle states using `podman ps -a`
* How isolation is demonstrated via different OS identity inside a container

---

## 🌍 Why This Matters

Container fundamentals are foundational for:

* OpenShift / Kubernetes workflows
* CI/CD pipelines and application delivery
* Security hardening and runtime isolation strategies
* Modern DevOps and cloud-native environments

---

## 🧩 Real-World Applications

* Packaging microservices into portable images
* Testing applications in isolated environments
* Building repeatable deployment workflows
* Supporting platform engineering and container orchestration

---

## ✅ Result

* Podman installed and verified successfully
* `hello-world` pulled and executed successfully
* Container status verified as **Exited (0)**
* Alpine container launched and verified as isolated environment

---

## ✅ Conclusion

This lab established the baseline skills required for container-based development:

* Understanding container concepts (isolation + portability)
* Running containers using Podman
* Validating container execution and observing isolation in practice

---

## ⏭️ Next Steps

* Explore running multiple containers using Podman pods
* Learn about image management (tags, layers, registries)
* Move toward orchestration concepts with Kubernetes/OpenShift
