# 🧪 Lab 05: Managing Container Images (Podman)

## 📌 Lab Summary
This lab focuses on **container image management** using Podman. The tasks cover:
- Searching for images on registries (Docker Hub)
- Pulling images locally (latest + specific tags)
- Inspecting image metadata and layers
- Removing images to reclaim disk space

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Search container registries using `podman search`
- Pull images and specific versions using tags
- List locally available images using `podman images`
- Inspect image configuration/layers using `podman inspect`
- Remove images using `podman rmi` and prune unused images using `podman image prune -a`

---

## ✅ Prerequisites
- Linux-based system (Ubuntu 20.04/22.04 recommended)
- Podman installed (3.0+)
- Internet connectivity
- Basic command-line familiarity

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu (cloud lab environment) |
| Podman Version | 4.9.3 |
| Registry Used | Docker Hub (`docker.io`) |
| Images Used | `ubuntu:latest`, `ubuntu:20.04`, `nginx:alpine`, `redis:alpine`, `hello-world:latest` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab05-managing-container-images/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Search for Images on Docker Hub

* Searched Ubuntu-related images using:

  * `podman search ubuntu`
* Filtered search results to official images:

  * `podman search --filter=is-official=true ubuntu`
* Performed registry login as a troubleshooting flow (rate limiting/auth scenarios)

### ✅ Task 2: Pull Container Images

* Pulled a specific image version:

  * `ubuntu:latest`
* Verified locally available images using:

  * `podman images`
* Pulled an older tagged version:

  * `ubuntu:20.04`
* Re-verified image list after tag pull

### ✅ Task 3: Inspect Image Metadata

* Inspected Ubuntu image metadata:

  * `podman inspect docker.io/library/ubuntu:latest`
* Extracted specific fields using Go-template formatting:

  * `podman inspect --format "{{.Config.Env}}" ...`

### ✅ Task 4: Remove Container Images

* Removed a specific tagged image:

  * `podman rmi docker.io/library/ubuntu:20.04`
* Verified removal via `podman images`
* Cleaned unused images using:

  * `podman image prune -a`

---

## ✅ Verification & Validation

* Podman installation confirmed:

  * `podman --version` → `podman version 4.9.3`
* Search results returned expected repository listings and official markers
* Image pulls completed successfully and appeared in `podman images`
* `podman inspect` returned JSON metadata including:

  * architecture, environment variables, rootfs layers
* Image removal confirmed by updated `podman images` output
* Prune operation reclaimed disk space and removed unused images

---

## 🔐 Security Note (relevant to this lab)

* Registry authentication (e.g., `podman login docker.io`) may require credentials.
* **Do not store passwords or tokens in repository files.**
* In this repo, any login output is recorded as shown in terminal but **passwords are never captured**.

---

## 🧠 What I Learned

* How to discover images via search and filters (official vs community)
* Why tags matter for version control and reproducible deployments
* How to inspect image configuration before deploying (env, default CMD, layers)
* How to clean up images safely to save disk space

---

## 🌍 Why This Matters

Image management is essential for:

* consistent environments across dev/test/prod
* controlling versions via tags
* auditing what an image contains before running it
* keeping systems clean and storage-efficient

---

## ✅ Result

* Successfully searched, pulled, inspected, and removed container images using Podman
* Verified images using `podman images`
* Cleaned unused images and reclaimed disk space

---

## ✅ Conclusion

This lab provided hands-on practice with the core lifecycle of container images—discovering them, pulling them locally, inspecting metadata and layers, and removing/pruning images. These skills are foundational for working efficiently with container registries and managing containerized applications.
