# 🧪 Lab 22: Using `RUN` Instruction Efficiently

## 🧾 Lab Summary
This lab focuses on writing efficient `RUN` instructions to optimize container image builds. I practiced using `RUN` in both **shell form** and **exec form**, then compared an inefficient multi-layer approach versus an optimized single-layer approach that combines package installation and cleanup in one instruction. Finally, I verified layer reduction using `podman history` and compared image sizes.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Use the `RUN` instruction in both **shell** and **exec** forms
- Combine package installation and cache cleanup into a **single RUN** to reduce image layers
- Build and analyze Podman images to observe **layer optimization**
- Inspect layer history and compare image sizes

---

## ✅ Prerequisites
- Basic familiarity with Podman/Docker
- Linux system with Podman installed
- Internet access to pull images and install packages

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | Linux-based cloud lab environment |
| Shell | `bash` |
| Container Tool | Podman |
| Base Images Used | `alpine:latest`, `ubuntu:latest` |

---

## 🗂️ Repository Structure
```text
lab22-using-run-instruction-efficiently/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Task 1: Understanding `RUN` Instruction Forms

#### Subtask 1.1 — Shell Form

* Created a dedicated folder for the shell-form build
* Wrote a Dockerfile using shell-form `RUN` to install `curl` with Alpine’s package manager
* Built the image and confirmed it created a new layer for installation

#### Subtask 1.2 — Exec Form

* Created a separate folder for the exec-form build
* Wrote a Dockerfile using exec-form `RUN` (JSON array)
* Built the image and confirmed the command executed successfully

---

### ✅ Task 2: Combining Commands to Minimize Layers

#### Subtask 2.1 — Inefficient Multi-Layer Dockerfile

* Created an example Ubuntu Dockerfile with multiple `RUN` instructions:

  * `apt-get update`
  * `apt-get install nginx`
  * cleanup step
* Noted that multiple `RUN` commands create multiple layers and can leave extra cache if not cleaned properly

#### Subtask 2.2 — Optimized Single-Layer Dockerfile

* Created an optimized Ubuntu Dockerfile combining all steps in **one RUN** using `&&` and line continuation
* Built the image and observed fewer layers and controlled cache cleanup

---

### ✅ Task 3: Verifying Layer Reduction

#### Subtask 3.1 — Inspect Image Layers

* Used `podman history optimized-nginx` to verify that:

  * Only **one RUN layer** exists for update + install + cleanup

#### Subtask 3.2 — Compare Image Sizes

* Listed images using `podman images`
* Verified the size differences between:

  * `optimized-nginx`
  * `run-lab-shell`
  * `run-lab-exec`
  * base `ubuntu` and `alpine` images

---

## ✅ Verification & Validation

* Confirmed builds succeeded for:

  * `run-lab-shell`
  * `run-lab-exec`
  * `optimized-nginx`
* Verified layer optimization using:

  * `podman history optimized-nginx`
* Verified image size differences using:

  * `podman images`

---

## 🧠 What I Learned

* Shell form `RUN` is simple and common but relies on shell parsing
* Exec form `RUN` avoids shell parsing and reduces issues with quoting/escaping
* Every `RUN` creates a layer — combining commands reduces layer count
* Cleaning package lists in the same `RUN` prevents cache files from being stored in the final image
* `podman history` is a practical tool for verifying layer optimization

---

## 💡 Why This Matters

Efficient use of `RUN` helps:

* reduce container image size
* speed up build and pull times
* simplify caching behavior in CI/CD pipelines
* reduce unnecessary filesystem artifacts (like package caches)

---

## 🌍 Real-World Applications

* Building production-ready images with minimal layers
* Optimizing Dockerfiles/Containerfiles for CI/CD pipelines
* Reducing supply chain footprint by avoiding unnecessary packages and caches
* Improving container startup and deployment performance

---

## ✅ Result

* Successfully built images using both `RUN` shell and exec forms
* Created an optimized Dockerfile that performs install + cleanup in one `RUN`
* Verified reduced layers with `podman history`
* Compared sizes and confirmed optimization impact

✅ Lab completed successfully on a cloud lab environment.
