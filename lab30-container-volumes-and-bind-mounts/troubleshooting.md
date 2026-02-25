# 🛠️ Troubleshooting Guide — Lab 30: Container Volumes and Bind Mounts

> This file covers common issues with named volumes, bind mounts, host permissions, and SELinux (`:Z`) on CentOS/RHEL-based systems.

---

## 1) `sudo: dnf: command not found`

### ✅ Symptom
Running:
```bash
sudo dnf install podman
````

returns:

```text id="6kyd0v"
sudo: dnf: command not found
```

### 🔎 Cause

CentOS 7 commonly uses `yum` (dnf may not exist).

### ✅ Fix

Use:

```bash id="5fhlzc"
sudo yum install -y podman
```

---

## 2) Volume exists but data is not persisting

### ✅ Symptom

You write data in one container, remove it, and the next container doesn’t see the data.

### 🔎 Possible Causes

* Mounted wrong volume name
* Wrote data to a different path than the mounted location
* Accidentally used a different container mount target

### ✅ Fixes

* Confirm volume exists:

  ```bash
  podman volume ls
  ```
* Inspect container mounts:

  ```bash
  podman inspect <container_name> | grep -i mount -n
  ```
* Ensure you are writing inside the mounted path (`/data` in this lab).

---

## 3) Bind mount shows “Permission denied” even though directory exists

### ✅ Symptom

Container cannot read/write to mounted host directory.

### 🔎 Common Causes

* Host directory permissions are too restrictive
* SELinux prevents container access (very common on RHEL/CentOS)

### ✅ Fixes

* Check permissions:

  ```bash
  ls -ld ~/container_data
  ```
* Check SELinux label:

  ```bash
  ls -Z ~/container_data/hostfile.txt
  ```
* Use SELinux relabel option:

  ```bash
  podman run --rm -v ~/container_data:/container_data:Z alpine cat /container_data/hostfile.txt
  ```

---

## 4) `:Z` vs `:z` confusion

### ✅ Symptom

You’re unsure which SELinux option to use.

### 🔎 Explanation

* `:Z` relabels content for **exclusive** use by one container
* `:z` relabels content for **shared** use by multiple containers

### ✅ Fix (rule of thumb)

Use `:Z` unless you intentionally need multiple containers sharing the same bind mount.

---

## 5) Restricted directory mount fails to write (`Permission denied`)

### ✅ Symptom

Writing fails like:

```text id="u5b5os"
touch: /data/testfile: Permission denied
```

### 🔎 Causes

* Directory is owned by root with restrictive permissions (e.g., `700`)
* SELinux context not container-friendly (`default_t`)

### ✅ Fixes

* Adjust permissions (example from lab):

  ```bash id="l8yn3h"
  sudo chmod 755 /restricted_data
  ```
* Apply container SELinux type:

  ```bash id="f0cc6v"
  sudo chcon -t container_file_t /restricted_data
  ```
* Mount with relabel:

  ```bash id="d57x6i"
  podman run --rm -v /restricted_data:/data:Z alpine touch /data/testfile
  ```
* Verify label:

  ```bash
  sudo ls -lZ /restricted_data
  ```

---

## 6) SELinux mode check and debugging AVC denials

### ✅ Symptom

You still get access denials after permission changes.

### 🔎 Possible Causes

SELinux policy may still block access, or the label didn’t apply correctly.

### ✅ Fixes

* Confirm mode:

  ```bash
  getenforce
  ```
* Look for SELinux denials:

  ```bash
  sudo ausearch -m avc -ts recent
  ```
* For temporary testing only (if allowed by environment policy):

  ```bash
  sudo setenforce 0
  ```

  Then revert back:

  ```bash
  sudo setenforce 1
  ```

---

## 7) Cleanup command fails or removes more than expected

### ✅ Symptom

Commands like:

```bash
podman rm -f $(podman ps -aq)
```

remove all containers, not just lab ones.

### 🔎 Cause

`$(podman ps -aq)` targets every container ID.

### ✅ Fix

Remove only specific containers if needed:

```bash id="g23u2c"
podman rm -f volume_test new_test persist_test
```

---

## ✅ Quick Verification Checklist

* Volume exists:

  ```bash
  podman volume ls
  ```
* Volume persists:

  ```bash
  podman run --rm -v mydata_volume:/data alpine cat /data/testfile
  ```
* Bind mount works with SELinux:

  ```bash
  podman run --rm -v ~/container_data:/container_data:Z alpine cat /container_data/hostfile.txt
  ```
* SELinux context correct:

  ```bash
  ls -Z ~/container_data/hostfile.txt
  ```
* Restricted directory write fixed:

  ```bash
  podman run --rm -v /restricted_data:/data:Z alpine touch /data/testfile
  sudo ls -lZ /restricted_data
  ```
