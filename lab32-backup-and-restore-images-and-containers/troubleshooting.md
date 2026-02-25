# 🛠️ Troubleshooting Guide — Lab 32: Backup and Restore with `podman save/load/commit`

> This file covers common errors and fixes when saving/loading images, committing containers, and managing cleanup.

---

## 1) `no such image` when running `podman save`

### ✅ Symptom
`podman save -o alpine_backup.tar docker.io/library/alpine:latest` fails with:
- `Error: no such image ...`

### 🔎 Cause
The image is not present locally (or the tag name differs).

### ✅ Fix
- List images and confirm exact name:
  ```bash
  podman images
  ```

* Pull the image first:

  ```bash
  podman pull docker.io/library/alpine:latest
  ```

---

## 2) Tarball not created or is empty

### ✅ Symptom

`alpine_backup.tar` missing or very small.

### 🔎 Possible Causes

* No write permission in directory
* Command interrupted
* Disk space issues

### ✅ Fixes

* Check current directory permissions:

  ```bash
  pwd
  ls -ld .
  ```
* Confirm disk space:

  ```bash
  df -h
  ```
* Re-run save:

  ```bash
  podman save -o alpine_backup.tar docker.io/library/alpine:latest
  ```

---

## 3) `podman load` fails with file errors

### ✅ Symptom

* `error reading "alpine_backup.tar"`
* `no such file or directory`

### 🔎 Causes

* Wrong path or filename
* Corrupted tarball

### ✅ Fixes

* Confirm file exists:

  ```bash
  ls -lh alpine_backup.tar
  ```
* Confirm file type:

  ```bash
  file alpine_backup.tar
  ```
* If corrupted, recreate tarball using `podman save`.

---

## 4) Image loads but tag/name is unexpected

### ✅ Symptom

After `podman load`, the image name/tag differs from what you expected.

### 🔎 Cause

The tarball may contain multiple images or different tags.

### ✅ Fix

List images after load:

```bash id="clz4u6"
podman images
```

Then retag as needed:

```bash id="9jf7pg"
podman tag <loaded-image-id> mytaggedimage:latest
```

---

## 5) `podman commit` fails because container does not exist

### ✅ Symptom

`podman commit myalpine my_custom_alpine:v1` fails with container not found.

### 🔎 Cause

The container was removed or never created under that name.

### ✅ Fix

* List containers:

  ```bash
  podman ps -a
  ```
* Run container again:

  ```bash
  podman run -it --name myalpine alpine /bin/sh
  ```
* Apply changes and commit again.

---

## 6) Committed image doesn’t include expected changes

### ✅ Symptom

You run the committed image, but your modified files aren’t there.

### 🔎 Possible Causes

* Changes were made in a different container than the one committed
* Container was recreated before commit
* You wrote data to a mounted volume (commit does not include volumes)

### ✅ Fixes

* Confirm container name matches:

  ```bash
  podman ps -a
  ```
* Ensure modifications were inside container filesystem (not volume)
* Commit the correct container:

  ```bash
  podman commit myalpine my_custom_alpine:v1
  ```

---

## 7) Confusion: Why commit doesn’t preserve running process state?

### ✅ Explanation

`podman commit` saves filesystem changes only. It does not snapshot:

* active processes
* network state
* mounted volumes

### ✅ Fix / Best Practice

For reproducible and consistent images, use a Dockerfile/Containerfile.

---

## 8) Cleanup removes more than expected

### ✅ Symptom

Commands like `podman rm -a` or `podman rmi -a` remove all containers/images.

### 🔎 Cause

The `-a` flag targets everything.

### ✅ Fix

Remove only lab resources:

```bash id="l6b9qh"
podman rm myalpine
podman rmi my_custom_alpine:v1 docker.io/library/alpine:latest
rm alpine_backup.tar
```

---

## ✅ Quick Verification Checklist

* Pull image:

  ```bash
  podman pull alpine:latest
  ```
* Save image:

  ```bash
  podman save -o alpine_backup.tar alpine:latest
  ```
* Verify tarball:

  ```bash
  ls -lh alpine_backup.tar
  file alpine_backup.tar
  ```
* Remove + restore image:

  ```bash
  podman rmi alpine:latest
  podman load -i alpine_backup.tar
  podman images | grep alpine
  ```
* Commit container changes:

  ```bash
  podman run -it --name myalpine alpine /bin/sh
  podman commit myalpine my_custom_alpine:v1
  podman run --rm my_custom_alpine:v1 ls /
  ```
