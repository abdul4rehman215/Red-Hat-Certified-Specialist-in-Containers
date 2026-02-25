# 🧪 Lab 25: Securing Images with Least Privilege

## 🧾 Lab Summary
This lab applied **least privilege** principles to container images and runtime. I scanned an image for vulnerabilities, reduced attack surface by cleaning package caches, compared a minimal Alpine-based build versus a larger Debian-based image, and created a non-root Nginx container with only the minimum permissions needed. Finally, I implemented basic **image provenance** by signing the built image using GPG and verifying trust metadata.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Apply security best practices using the **principle of least privilege**
- Implement image provenance to verify image authenticity (image signing + trust verification)
- Perform cache cleanup to reduce attack surface
- Scan container images for vulnerabilities using Podman
- Create and run containers with **minimal base images** and **non-root users**

---

## ✅ Prerequisites
- Linux system with Podman installed (v3.0+)
- Basic container concepts
- Internet access to pull images
- sudo privileges (for system configuration where needed)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Images Used | `nginx:latest`, `alpine:latest` |
| Security Tools | `podman scan`, image signing (`podman image sign`), GPG |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab25-securing-images-with-least-privilege/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Verified Podman installation
* Created a dedicated working directory for the lab

---

### ✅ Task 1: Scan Images for Vulnerabilities

* Pulled `nginx:latest`
* Ran `podman scan nginx:latest`
* Reviewed CVEs by severity and interpreted findings

**Goal:** Identify risk in base images and validate a workflow for vulnerability awareness.

---

### ✅ Task 2: Reduce Attack Surface by Removing Package Caches

* Built an image `nginx_clean` that removes apt cache files:

  * `/var/cache/apt/*`
  * `/var/lib/apt/lists/*`
* Compared image size with original `nginx:latest`

**Goal:** Remove unnecessary artifacts and reduce noise/surface area.

---

### ✅ Task 3: Use Minimal Base Images

* Switched to Alpine base image and installed Nginx using `apk`
* Built `nginx_alpine` and compared size to Debian-based Nginx image

**Goal:** Demonstrate how base image choice affects size and potential exposure.

---

### ✅ Task 4: Run Containers as Non-Root (Least Privilege Runtime)

* Built a non-root Nginx image `nginx_nonroot`:

  * Created `nginxuser`
  * Set ownership on required directories
  * Used `setcap cap_net_bind_service=+ep` so Nginx can bind to port 80 without root
  * Switched to `USER nginxuser`
* Ran container mapping `8080:80`
* Verified processes run as `nginxuser` using `ps aux`

**Goal:** Ensure the container does not run as root while still functioning.

---

### ✅ Task 5: Implement Image Provenance (Signing + Trust)

* Confirmed GPG availability
* Generated a lab GPG key using `keyparams` + `gpg --batch --gen-key`
* Signed the image using `podman image sign --sign-by ...`
* Verified trust store using `podman image trust show`

**Goal:** Demonstrate basic image authenticity workflow.

---

## ✅ Verification & Validation

* Vulnerability scan produced CVE list and severity summary
* Cache-clean image built successfully and showed reduced size (`192 MB → 190 MB`)
* Alpine-based image built and showed a major size reduction (`~22.5 MB`)
* Non-root container ran successfully:

  * `podman exec secure_nginx ps aux` showed nginx owned by `nginxuser`
* Image signature appeared in trust store:

  * `podman image trust show` displayed signed entry with a GPG ID

---

## 🧠 What I Learned

* Vulnerability scanning should be part of regular build workflows
* Removing package caches reduces attack surface and avoids carrying unnecessary artifacts
* Minimal base images significantly reduce image size and dependency footprint
* Running as non-root is practical when directories are correctly owned and the binary is granted minimal capability (`setcap`)
* Image signing helps prove provenance and supports trust in delivery pipelines

---

## 🔐 Why This Matters (Security Relevance)

Containers are often deployed at scale. Without least privilege:

* a vulnerable image may ship known CVEs
* unnecessary caches/tools may increase risk and investigation noise
* root containers increase blast radius if compromised
* unsigned images make provenance unclear in CI/CD pipelines

This lab demonstrates layered controls that improve container security **without breaking functionality**.

---

## 🌍 Real-World Applications

* Securing containerized web services in Kubernetes/OpenShift
* Using scanning + cleanup as part of image hardening pipelines
* Enforcing non-root containers by default in production clusters
* Signing images for supply-chain integrity and trust policies
* Establishing “secure baseline images” for internal teams

---

## ✅ Result

* Pulled and scanned Nginx for vulnerabilities
* Built a cache-cleaned Nginx image and verified reduced size
* Built a minimal Alpine-based Nginx image and verified major size reduction
* Built and ran a non-root Nginx container and verified processes run under `nginxuser`
* Signed the image and verified signature trust metadata

✅ Lab completed successfully on a cloud lab environment.
