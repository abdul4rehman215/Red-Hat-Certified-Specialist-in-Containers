# 🛠️ Troubleshooting Guide — Lab 24: `WORKDIR` and `USER` Instructions

> This file lists common issues you may encounter when working with `WORKDIR`, user creation in minimal images, and running containers as non-root.

---

## 1) `podman build` fails when pulling `ubi9/ubi-minimal`

### ✅ Symptom
Errors such as:
- `unable to pull image`
- `connection timed out`
- `unauthorized` (registry access issue)

### 🔎 Possible Causes
- Network/DNS issue in lab environment
- Registry temporarily unavailable
- Registry requires authentication (environment-dependent)

### ✅ Fixes
- Test network/DNS:
  ```bash
  ping -c 2 registry.access.redhat.com
  ```

* Retry build:

  ```bash
  podman build -t workdir-demo .
  ```
* If authentication is required, follow your environment’s registry login workflow.

---

## 2) `microdnf: command not found`

### ✅ Symptom

The build fails during the user creation layer with:

* `microdnf: command not found`

### 🔎 Cause

You may be using a base image that does not include `microdnf` (or not a UBI minimal variant that supports it).

### ✅ Fix

* Verify base image is correct:

  ```dockerfile
  FROM registry.access.redhat.com/ubi9/ubi-minimal
  ```
* If using a different base, use the correct package manager available in that image (example: `dnf`, `yum`, `apk`, etc.).

---

## 3) `useradd: command not found`

### ✅ Symptom

Build fails during:

```dockerfile
RUN useradd ...
```

with:

* `useradd: command not found`

### 🔎 Cause

Minimal images may not include user management tools.

### ✅ Fix

Install required package (in this lab: `shadow-utils`):

```dockerfile id="d2vzyv"
RUN microdnf install shadow-utils
```

---

## 4) Permission issues after switching to non-root user

### ✅ Symptom

Application or build steps fail because the user cannot write to `/app`, for example:

* `Permission denied` when writing files

### 🔎 Cause

The directory is owned by root by default, so `appuser` cannot write unless ownership/permissions are set.

### ✅ Fix

Ensure ownership:

```dockerfile id="x4i7g4"
RUN chown -R appuser:appuser /app
```

---

## 5) Confusing result: `WORKDIR` works but log shows `root`

### ✅ Symptom

`/tmp/workdir.log` shows:

```text
/app
root
```

### 🔎 Explanation

In the first build (`workdir-demo`), you did not set `USER`, so default user remains `root`. `WORKDIR` changes directory context, not user context.

### ✅ Fix (if you want non-root)

Add user creation + `USER appuser` like in the second build.

---

## 6) `podman exec` fails because container is not running

### ✅ Symptom

`podman exec testuser ps -ef` fails with:

* container not found
* container not running

### 🔎 Possible Causes

* Container exited quickly
* Wrong container name
* `sleep` command missing/failed (rare)

### ✅ Fixes

* Check container status:

  ```bash
  podman ps -a
  ```
* Re-run the container:

  ```bash
  podman run -d --name testuser nonroot-demo sleep 300
  ```
* Then run:

  ```bash
  podman exec testuser ps -ef
  ```

---

## 7) Privileged operation test behaves differently

### ✅ Symptom

You expected permission denial but behavior differs.

### 🔎 Cause

Privileges depend on runtime flags and environment policy. If the container is run privileged, some restrictions may change.

### ✅ Fix

Ensure you are not running with privileged flags:

* Avoid `--privileged`
* Avoid adding extra capabilities unless required

---

## 8) Cleanup fails because container still exists

### ✅ Symptom

`podman rmi` fails with message that image is in use.

### 🔎 Cause

A container (like `testuser`) may still exist and reference the image.

### ✅ Fix

Remove container first:

```bash id="x9p6y8"
podman rm -f testuser
```

Then remove images:

```bash id="r8l0va"
podman rmi workdir-demo nonroot-demo
```

---

## ✅ Quick Verification Checklist

* Confirm Podman works:

  ```bash
  podman --version
  ```
* Confirm WORKDIR set correctly:

  ```bash
  podman run --rm workdir-demo cat /tmp/workdir.log
  ```
* Confirm non-root user is active:

  ```bash
  podman run --rm nonroot-demo whoami
  ```
* Confirm least-privilege restriction:

  ```bash
  podman run --rm nonroot-demo touch /sys/kernel/profiling
  ```

