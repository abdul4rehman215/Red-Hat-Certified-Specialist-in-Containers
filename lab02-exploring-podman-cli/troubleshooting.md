# 🛠️ Troubleshooting Guide — Lab 02: Exploring Podman CLI

> This document lists common issues that may occur while listing, running, managing, and inspecting containers with Podman.

---

## 1) `podman ps` shows nothing (empty output)
### ✅ Symptom
Running `podman ps` shows only the header row or returns no containers.

### 📌 Likely Cause
No containers are currently running. Many containers (like interactive shells) exit once the command completes or you exit the shell.

### ✅ Fix / Verification
Use `podman ps -a` to see all containers including stopped ones:
```bash
podman ps -a
````

---

## 2) Container exits immediately after starting

### ✅ Symptom

You run:

* `podman run -it alpine sh`
  and after `exit`, container no longer appears in `podman ps`.

### 📌 Likely Cause

The shell process inside the container is the main process. When it exits, the container stops.

### ✅ Fix / Notes

This is expected behavior for interactive containers.
Verify the container exists in stopped state:

```bash
podman ps -a
```

---

## 3) Cannot stop a container because it is not running

### ✅ Symptom

Running:

* `podman stop my_alpine`
  returns an error that the container is not running (or similar).

### 📌 Likely Cause

The container is already exited/stopped (for example, after you typed `exit` in the interactive shell).

### ✅ Fix

Start it first, then stop it:

```bash
podman start my_alpine
podman stop my_alpine
```

---

## 4) `podman rm` fails because container is running

### ✅ Symptom

Removing a container fails with an error indicating it is running.

### 📌 Likely Cause

Podman generally prevents removing running containers unless forced.

### ✅ Fix (safe method)

Stop then remove:

```bash
podman stop my_alpine
podman rm my_alpine
```

---

## 5) `podman restart` works but container doesn’t stay “Up”

### ✅ Symptom

After `podman restart`, container appears briefly and exits again.

### 📌 Likely Cause

The container’s main process ends quickly (e.g., it was launched with a short command or non-daemon process).

### ✅ Fix

This is expected for short-lived containers. To keep a container running, run a long-lived process or daemon-style service.
For Alpine examples, you typically run interactive mode when needed:

```bash
podman run -it alpine sh
```

---

## 6) `podman inspect` outputs too much data / hard to read

### ✅ Symptom

`podman inspect <container>` returns a large JSON output.

### 📌 Likely Cause

Inspect returns complete container metadata by design.

### ✅ Fix (practical filtering)

Use a pager:

```bash
podman inspect nginx_container | less
```

Or extract specific values:

```bash
podman inspect --format '{{.State.Status}}' nginx_container
podman inspect --format '{{.NetworkSettings.Networks.podman.IPAddress}}' nginx_container
```

---

## 7) Image pull issues when running nginx

### ✅ Symptom

`podman run -d --name nginx_container nginx` fails due to pull or registry errors.

### 📌 Likely Cause

Network/DNS issues or restricted registry access.

### ✅ Fix

Try pulling explicitly with debug logs:

```bash
podman --log-level=debug pull nginx
```

Then run:

```bash
podman run -d --name nginx_container nginx
```

---

## ✅ Quick Verification Checklist

* Podman installed:

  * `podman --version`
* Running containers:

  * `podman ps`
* All containers:

  * `podman ps -a`
* Lifecycle works:

  * `podman start/stop/restart/rm`
* Metadata visible:

  * `podman inspect <name>`
