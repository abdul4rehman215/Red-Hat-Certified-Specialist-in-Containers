# 🛠️ Troubleshooting Guide — Lab 3: Running Containers with Podman

> This document lists the most common problems when running containers, mapping ports, and mounting volumes.

---

## 1) Container exits immediately after `podman run -d`
### ✅ Symptom
- `podman ps` shows nothing
- container appears in `podman ps -a` with `Exited`

### 📌 Likely Causes
- the container’s default command terminates
- configuration error inside container

### ✅ Fix
1) Check status:
```bash
podman ps -a
````

2. Check logs:

```bash id="l03t1"
podman logs <container_id_or_name>
```

3. If needed, run interactively to debug:

```bash id="l03t2"
podman run -it --rm <image> sh
```

---

## 2) Port mapping fails (address already in use)

### ✅ Symptom

Podman errors when using:

* `-p 8080:80`

### 📌 Likely Cause

Another process/container is already using the host port.

### ✅ Fix

1. Identify what is listening:

```bash id="l03t3"
ss -tulnp | grep 8080 || true
```

2. Stop conflicting container:

```bash id="l03t4"
podman ps
podman stop <container_id_or_name>
```

3. Or choose another host port:

```bash id="l03t5"
podman run -d -p 8085:80 nginx:alpine
```

---

## 3) `curl localhost:<port>` fails even though container is running

### ✅ Symptom

* Connection refused / timeout

### 📌 Likely Causes

* wrong port mapped
* container not listening on expected port
* service still starting

### ✅ Fix

1. Verify mapping:

```bash id="l03t6"
podman port <container_id_or_name>
```

2. Verify container is running:

```bash id="l03t7"
podman ps
```

3. Check logs:

```bash id="l03t8"
podman logs <container_id_or_name> | tail -n 80
```

---

## 4) Volume mount permission errors

### ✅ Symptom

Container can’t read/write mounted directory.

### 📌 Likely Causes

* host filesystem permissions
* SELinux labeling issues on RHEL/Fedora systems

### ✅ Fix

1. Confirm host path exists:

```bash id="l03t9"
ls -la ~/nginx-content
```

2. If SELinux is enabled (RHEL/Fedora), use `:Z`:

```bash id="l03t10"
podman run -d -v ~/nginx-content:/usr/share/nginx/html:Z nginx:alpine
```

3. On Ubuntu, SELinux relabeling commands like `chcon` may not apply:

* it’s normal for `chcon` to fail if SELinux labeling isn’t active

---

## 5) `--name` fails because name already exists

### ✅ Symptom

Podman errors:

* “container name already in use”

### ✅ Fix

1. Remove old container:

```bash id="l03t11"
podman rm -f my-nginx
```

2. Or use a different name:

```bash id="l03t12"
podman run -d --name my-nginx-2 nginx:alpine
```

---

## ✅ Quick Debug Checklist

* Running containers:

  * `podman ps`
* All containers (including exited):

  * `podman ps -a`
* Logs:

  * `podman logs <id|name>`
* Port mappings:

  * `podman port <id|name>`
* Host port usage:

  * `ss -tulnp | grep <port>`
* Cleanup:

  * `podman rm -f $(podman ps -aq)`
