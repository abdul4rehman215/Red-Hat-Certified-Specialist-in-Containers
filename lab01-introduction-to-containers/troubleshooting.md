# 🛠️ Troubleshooting Guide — Lab 01: Introduction to Containers (Podman)

> This document captures common issues that may occur during Podman installation and basic container execution, along with practical fixes.

---

## 1) Podman command not found
### ✅ Symptom
Running `podman --version` returns:
- `podman: command not found`

### 📌 Likely Cause
Podman is not installed, or the installation did not complete successfully.

### ✅ Fix
For Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install -y podman
````

Verify:

```bash
podman --version
```

---

## 2) Permission denied when running containers

### ✅ Symptom

Running a container returns permission errors, such as:

* `permission denied`
* errors related to namespaces/storage

### 📌 Likely Cause

Rootless mode may require proper user namespace configuration, or your environment may restrict certain kernel features.

### ✅ Fix (quick)

Try running with sudo:

```bash
sudo podman run hello-world
```

### ✅ Fix (recommended approach)

Migrate runtime configuration:

```bash
podman system migrate
```

Then re-try:

```bash
podman run hello-world
```

---

## 3) Image pull fails (network / registry issues)

### ✅ Symptom

`podman pull hello-world` fails with:

* timeout
* DNS resolution errors
* registry unreachable

### 📌 Likely Cause

No outbound network access, DNS problems, or registry access restrictions.

### ✅ Fix

1. Confirm connectivity:

```bash
ping -c 3 8.8.8.8
```

2. Confirm DNS resolution:

```bash
ping -c 3 google.com
```

3. Re-run pull:

```bash
podman pull hello-world
```

### ✅ Debug Option

Use verbose logs:

```bash
podman --log-level=debug pull hello-world
```

---

## 4) `podman ps` shows nothing after running `hello-world`

### ✅ Symptom

You ran `podman run hello-world`, but `podman ps` shows no containers.

### 📌 Likely Cause

By default `podman ps` shows only running containers. `hello-world` exits immediately after printing its message.

### ✅ Fix

Use `-a` to view all containers:

```bash
podman ps -a
```

---

## 5) Alpine interactive shell exits immediately

### ✅ Symptom

`podman run -it alpine sh` exits or does not give a shell prompt.

### 📌 Likely Cause

* Image pull failed
* Incorrect shell command
* Terminal did not allocate a TTY properly

### ✅ Fix

1. Pull the image explicitly:

```bash
podman pull alpine
```

2. Re-run interactively:

```bash
podman run -it alpine sh
```

3. Confirm you are inside the container (prompt like `/ #`), then test:

```bash
cat /etc/os-release
```

---

## ✅ Quick Verification Checklist

* Podman installed:

  * `podman --version`
* hello-world executed:

  * `podman run hello-world`
* container history visible:

  * `podman ps -a`
* Alpine isolation confirmed:

  * `podman run -it alpine sh`
  * `cat /etc/os-release`
