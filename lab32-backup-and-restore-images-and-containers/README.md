# 🧪 Lab 32: Backup and Restore Images and Containers with Podman

## 🧾 Lab Summary
This lab demonstrates practical backup and recovery workflows for container images using Podman. I used `podman save` and `podman load` to export and restore an image as a portable tarball, and used `podman commit` to create a new image from a modified container. I also reviewed real limitations of commit-based workflows (volumes, running processes, network config) and checked storage usage impact with `podman system df`.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Use `podman save` and `podman load` to backup and restore container images
- Use `podman commit` to create new images from running containers
- Understand practical use cases and limitations of these operations

---

## ✅ Prerequisites
- Linux system with Podman installed
- Basic container concepts and Podman commands
- Internet access (to pull base images)
- ~1GB free disk space (for image operations)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Base Image | `alpine:latest` |
| Backup Artifact | `alpine_backup.tar` |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab32-backup-and-restore-images-and-containers/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Verified Podman version
* Pulled a sample image (`alpine:latest`) for backup/restore testing

---

### ✅ Task 1: Save an Image to a Tarball (`podman save`)

* Listed images to confirm `alpine:latest` exists
* Saved the image to a tar archive:

  * `podman save -o alpine_backup.tar docker.io/library/alpine:latest`
* Verified the backup file:

  * checked size via `ls -lh`
  * confirmed type via `file`

**Key concept:** `podman save` exports an **image** including layers and metadata.

---

### ✅ Task 2: Load an Image from Tarball (`podman load`)

* Removed the local `alpine:latest` image
* Restored the image using:

  * `podman load -i alpine_backup.tar`
* Verified the image reappeared in `podman images`

**Key concept:** `podman load` restores image name + tags from the saved tarball.

---

### ✅ Task 3: Commit Container to a New Image (`podman commit`)

* Started an interactive container (`myalpine`)
* Created `/testfile` inside the container and wrote `"Lab 12"`
* Committed the container into a new image:

  * `my_custom_alpine:v1`
* Verified the new image exists
* Verified the committed change by running:

  * `podman run --rm my_custom_alpine:v1 cat /testfile`

**Use case:** quick snapshot for debugging, testing, or capturing runtime changes (not the best for reproducible builds).

---

### ✅ Task 4: Understand Limitations + Storage Impact

* Reviewed commit limitations using:

  * `podman commit --help | grep -A5 "Limitations"`
* Checked storage usage with:

  * `podman system df`

**Key concepts:**

* commit does NOT include volumes, running processes, or network configuration
* for reproducible builds, prefer Containerfiles/Dockerfiles

---

## ✅ Verification & Validation

* Backup tarball existed and was a valid tar archive
* After removing the original image, `podman load` restored it successfully
* Committed image contained the created file (`/testfile`) with expected contents
* Confirmed real commit limitations and checked storage usage footprint

---

## 🧠 What I Learned

* `podman save/load` is ideal for **image portability** and offline transfers
* `podman commit` is useful for quick snapshots but not ideal for long-term reproducibility
* Backup tarballs are architecture-specific (x86_64 vs ARM)
* Storage grows with additional images and backups; `podman system df` helps track usage

---

## 💡 Why This Matters

These workflows are valuable for:

* air-gapped environments (move images via tar)
* disaster recovery preparation
* capturing a “known-good” runtime state
* debugging issues by snapshotting a container state

---

## ✅ Result

* Backed up `alpine:latest` using `podman save`
* Restored it using `podman load`
* Created a custom image using `podman commit`
* Verified limitations and storage impact
* Cleaned up images, containers, and tarball after completion

✅ Lab completed successfully on a cloud lab environment.

