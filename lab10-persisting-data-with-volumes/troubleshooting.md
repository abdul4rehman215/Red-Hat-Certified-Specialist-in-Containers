
# 🛠️ Troubleshooting Guide — Lab 10: Persisting Data with Volumes (Podman)

> This document covers common issues when creating volumes, mounting them into containers, and using bind mounts with host directories.

---

## 1) Volume not found when starting container
### ✅ Symptom
Running:
- `podman run -v myapp_data:/path ...`
fails with volume not found errors.

### 📌 Likely Cause
The volume was not created (or the name is incorrect).

### ✅ Fix
1) List volumes:
```bash
podman volume ls
````

2. Create the volume if missing:

```bash id="ttbd3z"
podman volume create myapp_data
```

---

## 2) Permission denied when using bind mounts

### ✅ Symptom

Container cannot read/write mounted host directory.

### 📌 Likely Cause

* SELinux labeling required (on SELinux systems)
* Host directory permissions too restrictive
* Rootless container access mismatch

### ✅ Fix

1. Use SELinux label options if applicable:

* `:Z` for private label
* `:z` for shared label
  Example:

```bash id="qz0zpn"
podman run -d --name bind_example -v ~/host_data:/usr/share/nginx/html:Z nginx
```

2. Ensure host permissions allow access:

```bash id="37ad7d"
ls -ld ~/host_data
ls -l ~/host_data
```

---

## 3) Data does not persist after container removal

### ✅ Symptom

File created in container disappears after deleting container.

### 📌 Likely Cause

Data was written to container filesystem, not into the mounted volume.

### ✅ Fix

1. Confirm the file path is inside the mounted volume path:

* `myapp_data:/var/www/html` means you must write into `/var/www/html`

2. Verify inside container:

```bash id="v8c25w"
podman exec webapp ls -l /var/www/html
```

---

## 4) Confusing volume mountpoint location

### ✅ Symptom

`podman volume inspect` shows a mountpoint under `/home/<user>/.local/...` instead of `/var/lib/...`

### 📌 Likely Cause

This is expected behavior in **rootless Podman** mode.

### ✅ Fix / Notes

No fix needed. This is normal and indicates volumes are stored in user-space storage.

---

## 5) Bind mount path issues (tilde not expanding / wrong path)

### ✅ Symptom

Bind mount fails or container sees an empty directory unexpectedly.

### 📌 Likely Cause

* Shell didn’t expand `~` as expected in some contexts
* Wrong path used
* Directory doesn’t exist

### ✅ Fix

Use absolute paths:

```bash id="r7n1qs"
podman run -d --name bind_example -v /home/toor/host_data:/usr/share/nginx/html:Z nginx
```

Ensure directory exists:

```bash id="rfdnxs"
mkdir -p ~/host_data
ls -l ~/host_data
```

---

## 6) Container name conflicts

### ✅ Symptom

Trying to create a container with the same name returns:

* name already in use

### ✅ Fix

Remove or rename the existing container:

```bash id="bnyl8u"
podman ps -a
podman rm -f webapp
```

Then re-run your container creation command.

---

## 7) Cleanup advice (optional)

### ✅ Symptom

Too many leftover containers/volumes.

### ✅ Fix

1. Remove containers:

```bash id="owz1m4"
podman ps -a
podman rm -f <container_name>
```

2. Remove unused volumes:

```bash id="c3g5g2"
podman volume ls
podman volume rm myapp_data
```

3. Prune unused volumes (use carefully):

```bash id="svfjnh"
podman volume prune
```

---

## ✅ Quick Verification Checklist

* Volume exists:

  * `podman volume ls`
* Volume mountpoint:

  * `podman volume inspect myapp_data`
* Container sees mounted directory:

  * `podman exec webapp ls /var/www/html`
* Data persists:

  * recreate container and check file exists
* Bind mount reflects host changes:

  * edit host file and read in container
