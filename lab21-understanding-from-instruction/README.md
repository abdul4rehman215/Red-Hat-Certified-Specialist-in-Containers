# 🧪 Lab 21: Understanding the `FROM` Instruction

## 🧾 Lab Summary
This lab focuses on the **`FROM` instruction**, the foundation of every container build. I explored how base images work, how to select official images, and how to **pin versions** to ensure consistent and reproducible builds. I also built a simple container image using Podman and verified the output inside the container.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand the purpose and importance of the `FROM` instruction in containerization
- Select and pin appropriate base images for reproducible builds
- Create a basic `Containerfile` using the `FROM` instruction
- Build and validate a container image using Podman

---

## ✅ Prerequisites
- Basic Linux command line knowledge
- Podman installed (v3.0+ recommended)
- Internet access to pull container images

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Registry Used | `registry.access.redhat.com` |
| Additional Tool Installed | `skopeo` (via `yum`) |

> Note: This lab was executed in a **cloud lab environment**.

---

## 🗂️ Repository Structure
```text
lab21-understanding-from-instruction/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Task 1: Understand the `FROM` Instruction

* Learned that `FROM` is the **first instruction** in a `Containerfile`
* Confirmed it defines the **base image** used for all subsequent build steps
* Reviewed why base images matter (size, security, compatibility, updates)

### ✅ Task 2: Select and Pin a Base Image

* Searched for official UBI images using Podman
* Attempted to inspect image metadata using `skopeo`
* Installed missing tooling (`skopeo`) using `yum` (since CentOS 7 does not use `dnf`)
* Inspected metadata (digest, tags, architecture) to understand reproducibility concerns
* Pulled a **pinned tag** (`ubi:8.7`) instead of relying on `latest`

### ✅ Task 3: Write and Build a Simple `Containerfile`

* Created a `Containerfile` using a pinned UBI image
* Built a container image using `podman build`
* Verified build output and tested a file created inside the container (`/tmp/status.txt`)

### ✅ Cleanup

* Removed the created image (`podman rmi`)
* Pruned unused images (`podman image prune -a`)

---

## ✅ Verification & Validation

* Confirmed Podman version is installed and working
* Confirmed working directory and file creation
* Confirmed UBI image metadata could be inspected after installing `skopeo`
* Confirmed image build succeeded (`podman build`)
* Confirmed container runtime test output:

  * `/tmp/status.txt` contained expected text

---

## 🧠 What I Learned

* `FROM` defines the entire starting environment of the container image
* Using `latest` can break reproducibility because the base can change over time
* Image pinning with **tags** (and ideally **digests**) improves consistency across environments
* Installing and using tooling like `skopeo` helps verify image metadata before building

---

## 💡 Why This Matters

The base image is the **foundation of security and stability** in container builds. If the base image changes unexpectedly (like when using `latest`), it can introduce:

* new vulnerabilities
* unexpected package differences
* build inconsistencies across environments

Pinned images support **repeatable builds**, which is essential in production and regulated environments.

---

## 🌍 Real-World Applications

* Building consistent container images across CI/CD pipelines
* Preventing unexpected changes in production containers
* Enforcing supply-chain control by validating image metadata
* Creating reproducible builds for enterprise deployments

---

## ✅ Result

* Successfully searched, inspected, and selected a base image
* Built a container image using a pinned UBI tag (`8.7`)
* Verified container output successfully
* Cleaned up images after completion

✅ **Lab completed successfully on a cloud lab environment.**

---

## ⏭️ Next Steps

* Try different base images (Alpine, Debian, CentOS)
* Explore multi-stage builds using multiple `FROM` instructions
* Inspect layer history using:

  * `podman history <image>`

