# 🛠️ Troubleshooting Guide — Lab 21: Understanding the `FROM` Instruction

> This file documents issues encountered (or likely to be encountered) during this lab and how to fix them.

---

## 1) `skopeo: command not found`

### ✅ Symptom
Running:
```bash
skopeo inspect docker://registry.access.redhat.com/ubi8/ubi:latest
````

returns:

```text
-bash: skopeo: command not found
```

### 🔎 Cause

`skopeo` is not installed by default on this CentOS 7 environment.

### ✅ Fix

Install using `yum`:

```bash
sudo yum install -y skopeo
```

---

## 2) `sudo: dnf: command not found`

### ✅ Symptom

Running:

```bash
sudo dnf install -y skopeo
```

returns:

```text
sudo: dnf: command not found
```

### 🔎 Cause

CentOS 7 uses `yum` rather than `dnf` by default.

### ✅ Fix

Use:

```bash
sudo yum install -y skopeo
```

---

## 3) Image pull fails / image not found

### ✅ Symptom

`podman pull ...` fails with errors like:

* image not found
* unauthorized
* connection timed out

### 🔎 Possible Causes

* Wrong image name or tag
* No internet access / DNS issues
* Registry access restrictions or authentication needed

### ✅ Fixes

* Verify the image and tag:

  ```bash
  podman search registry.access.redhat.com/ubi8
  ```
* Confirm network connectivity and DNS:

  ```bash
  ping -c 2 8.8.8.8
  ping -c 2 registry.access.redhat.com
  ```
* Retry the pull:

  ```bash
  podman pull registry.access.redhat.com/ubi8/ubi:8.7
  ```

---

## 4) `podman build` fails (Containerfile error)

### ✅ Symptom

Build fails during:

```bash
podman build -t my-base-image .
```

### 🔎 Possible Causes

* Typos in `Containerfile`
* Invalid image tag
* Incorrect syntax (missing `FROM`, wrong instruction format)

### ✅ Fixes

* Validate the file contents:

  ```bash
  cat Containerfile
  ```
* Ensure the `FROM` line points to a valid image/tag:

  ```bash
  podman pull registry.access.redhat.com/ubi8/ubi:8.7
  ```
* Rebuild without cache (if needed):

  ```bash
  podman build --no-cache -t my-base-image .
  ```

---

## 5) Permission issues when running Podman

### ✅ Symptom

Podman commands fail due to permission or storage errors.

### 🔎 Possible Causes

* Rootless configuration not set properly
* Storage directories or user namespaces misconfigured
* SELinux restrictions (depending on system policy)

### ✅ Fixes

* Try running with correct privileges (if lab environment allows):

  ```bash
  sudo podman images
  ```
* Confirm Podman is working as the current user:

  ```bash
  podman info
  ```
* If SELinux is involved, review audit logs (system-specific):

  ```bash
  sudo ausearch -m avc -ts recent
  ```

---

## 6) `podman image prune -a` removes more than expected

### ✅ Symptom

Prune removes many images and reclaimed space is high.

### 🔎 Cause

`podman image prune -a` removes **all images not associated with at least one container**.

### ✅ Fix / Safer Option

Use regular prune first:

```bash
podman image prune
```

Or list images before pruning:

```bash
podman images
```

---

## ✅ Quick Verification Checklist

Use this to confirm the lab worked end-to-end:

* Podman installed:

  ```bash
  podman --version
  ```
* UBI image pulled:

  ```bash
  podman images | grep ubi
  ```
* Image built successfully:

  ```bash
  podman images | grep my-base-image
  ```
* Container output correct:

  ```bash
  podman run --rm my-base-image cat /tmp/status.txt
```
