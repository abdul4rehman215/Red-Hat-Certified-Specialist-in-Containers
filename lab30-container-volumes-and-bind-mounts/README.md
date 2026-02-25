# 🧪 Lab 30: Container Volumes and Bind Mounts

## 🧾 Lab Summary
This lab focused on container storage fundamentals using Podman. I created and managed a **named volume** to demonstrate persistence across container lifecycles, then used **bind mounts** to map host directories into containers. Because this is a SELinux-enabled system, I applied proper SELinux labeling (`:Z`) and verified contexts. I also tested a restricted host directory to reproduce permission errors, then fixed them by adjusting filesystem permissions and SELinux context so containers could write safely.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand different volume types in containerization
- Create and manage named volumes
- Implement bind mounts with proper SELinux context (`:Z`)
- Configure host directory permissions for container access
- Verify data persistence across container lifecycles

---

## ✅ Prerequisites
- Podman installed (v3.0+)
- Basic Linux command line knowledge
- SELinux enabled system (common on RHEL-based systems)
- sudo privileges for certain operations

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Base Image | `alpine:latest` |
| SELinux | `Enforcing` |
| Storage Focus | Named volumes + bind mounts + SELinux labeling |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab30-container-volumes-and-bind-mounts/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Confirmed Podman installation on CentOS 7:

  * observed `dnf` not available, `yum` used instead
* Verified Podman version

---

### ✅ Task 1: Creating and Using Named Volumes

* Created a named volume: `mydata_volume`
* Verified it exists with `podman volume ls`
* Started a container with the volume mounted to `/data`
* Wrote a file inside the volume (`/data/testfile`)
* Removed the container and started a new container using the same volume
* Confirmed the file persisted across containers

✅ Result: **Named volume data persisted** even after container removal.

---

### ✅ Task 2: Bind Mounts with SELinux Context

* Created a host directory: `~/container_data`
* Created a host file `hostfile.txt`
* Mounted host directory into container using `:Z`:

  * `-v ~/container_data:/container_data:Z`
* Verified file was readable inside the container
* Verified SELinux context changed to `container_file_t` using `ls -Z`

✅ Result: **Bind mount worked correctly with SELinux relabeling**.

---

### ✅ Task 3: Adjusting Host Directory Permissions

* Created a restricted directory owned by root:

  * `/restricted_data` (700 permissions)
* Mounted into container and attempted to write → reproduced **Permission denied**
* Fixed access by:

  * adjusting permissions (`chmod 755`)
  * setting SELinux type to `container_file_t` using `chcon`
  * mounting with `:Z`
* Verified file creation and SELinux context

✅ Result: **Container write access restored safely** after permission + SELinux adjustments.

---

### ✅ Task 4: Comprehensive Persistence Test (Named Volume + Bind Mount)

* Ran a container with both mounts:

  * named volume → `/data`
  * bind mount → `/container_data:Z`
* Wrote:

  * `Named Volume Data` → `/data/named.txt`
  * `Bind Mount Data` → `/container_data/bind.txt`
* Removed the container
* Verified:

  * named volume data exists via new container run
  * bind mount data exists directly on host

✅ Result: **Both storage methods preserved data** across container lifecycle.

---

## ✅ Verification & Validation

* Confirmed volume existence: `podman volume ls`
* Confirmed persistence: file readable after container removal
* Confirmed bind mount readability: `cat /container_data/hostfile.txt`
* Confirmed SELinux labeling:

  * `ls -Z ~/container_data/hostfile.txt` showed `container_file_t`
* Confirmed restricted directory failure (expected):

  * permission denied when writing
* Confirmed fix succeeded:

  * file created inside bind mount
  * correct SELinux context applied
* Confirmed SELinux mode:

  * `getenforce` → `Enforcing`

---

## 🧠 What I Learned

* Named volumes are managed by Podman and are designed for persistence independent of containers
* Bind mounts map host paths directly, so host permissions and SELinux context matter
* On SELinux systems, `:Z` is important to relabel host content for container access
* Restricted host directories often fail by default and require careful permission + SELinux adjustments
* Data persistence validation should include:

  * container recreation checks
  * host-side verification for bind mounts

---

## 🔐 Why This Matters (Security Relevance)

Storage is a common source of container security issues:

* bind mounts can accidentally expose sensitive host paths if used incorrectly
* SELinux prevents unauthorized access; correct labeling enables safe operation
* least privilege applies to filesystem access too — only grant what containers need

This lab demonstrates secure, controlled storage handling in an SELinux-enforcing environment.

---

## 🌍 Real-World Applications

* Persistent storage for applications (databases, stateful services)
* Mounting configuration files from host into containers
* OpenShift/Kubernetes storage concepts (volumes, PVCs, hostPath considerations)
* Troubleshooting container permission issues with SELinux enforcing policies

---

## ✅ Result

* Created and validated persistent named volumes
* Implemented bind mounts with SELinux `:Z` relabeling
* Reproduced and fixed permission-denied scenarios safely
* Verified persistence across container lifecycles for both storage types

✅ Lab completed successfully on a cloud lab environment.
