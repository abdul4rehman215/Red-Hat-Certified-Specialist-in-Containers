# 🛠️ Troubleshooting Guide — Lab 39: Troubleshooting Common Container Issues

> This guide summarizes the most common container issues covered in this lab and how to diagnose/fix them using Podman on a SELinux-enabled host.

---

## 1) Container is slow / OOM / unstable (Resource Constraints)

### ✅ Symptoms
- Container restarts unexpectedly
- High memory usage or CPU spikes
- Application becomes unresponsive

### 🔎 Diagnosis
1) Check configured limits:
```bash id="q0t2n6"
podman inspect <container> | grep -i "memory\|cpu"
````

2. Check live usage:

```bash id="m3p1q9"
podman stats <container> --no-stream
```

### ✅ Fix

* Apply a memory limit (or increase it if too low):

```bash id="z8c1u4"
podman update --memory 512m <container>
```

* Confirm update:

```bash id="p2m6y1"
podman inspect <container> | grep -i "Memory" | head
```

---

## 2) SELinux denial prevents container from reading/writing a mounted file

### ✅ Symptoms

* Permission denied even when file permissions look correct
* AVC denials in audit logs
* Container can’t read bind-mounted content

### 🔎 Diagnosis

Check recent denials:

```bash id="j4d8x0"
sudo ausearch -m avc -ts recent
```

Confirm file labels:

```bash id="r1k6v2"
ls -Z /path/to/file
```

If the target is labeled `default_t`, containers often cannot access it.

### ✅ Fix Options

**Option A: Relabel the directory**

```bash id="g5b1k3"
sudo chcon -Rt container_file_t /path/to/volume
```

**Option B: Use `:Z` on bind mounts**

```bash id="a9y0k7"
podman run -v /host/path:/data:Z <image>
```

### ⚠️ Debugging Only

Temporarily set permissive mode to confirm SELinux is the issue:

```bash id="x9v5m2"
sudo setenforce 0
getenforce
```

Always revert after testing:

```bash id="w2n7p3"
sudo setenforce 1
getenforce
```

---

## 3) Port binding fails (`address already in use`)

### ✅ Symptoms

* Container won’t start with `-p`
* Error includes:

  * `bind: address already in use`

### 🔎 Diagnosis

Check what is listening on the port:

```bash id="q7t1p8"
sudo ss -tulnp | grep 8080
```

### ✅ Fix

* Stop/remove the conflicting container or process:

```bash id="t2m8k1"
podman stop -f <container_name>
```

* Or use a different host port:

```bash
-p 8081:80
```

---

## 4) Network debugging beyond `podman exec` (Namespace Inspection)

### ✅ When to use this

When you need to inspect interfaces/IP routes inside the container network namespace even if the container environment is minimal.

### 🔎 Diagnosis

1. Get network namespace path:

```bash id="r6c1h0"
podman inspect <container> --format '{{.NetworkSettings.SandboxKey}}'
```

2. Get container PID:

```bash id="a8d4c9"
podman inspect --format '{{.State.Pid}}' <container>
```

3. Enter network namespace and inspect interfaces:

```bash id="v1p9z8"
sudo nsenter -n -t <PID> ip a
```

---

## 5) Permission denied due to container user context

### ✅ Symptoms

* Commands fail inside container due to lack of privileges
* Mounted paths are readable on host but not inside container

### 🔎 Diagnosis

Check configured user:

```bash id="z0m8b4"
podman inspect <container> --format '{{.Config.User}}'
```

If blank, the image default user is used (often root unless set otherwise).

### ✅ Fixes

* For troubleshooting, run explicitly as root:

```bash id="p8q3n2"
podman run --rm -it --user root alpine /bin/sh
```

* Combine with SELinux relabel if bind mounts are involved:

```bash id="t5k3d7"
podman run --rm -v /host/path:/data:Z -it alpine /bin/sh
```

---

## ✅ Final Verification Steps

* Check container logs for errors:

```bash id="b1n9c4"
podman logs <container> | tail -n 20
```

* Ensure everything is cleaned up:

```bash
podman rm -f <containers...>
```

---

## ✅ Key Takeaway

Troubleshooting containers effectively usually follows:

1. **Observe** (stats/logs/inspect)
2. **Confirm** (audit logs, port checks, namespaces)
3. **Apply minimal fix** (limits, relabel, port change)
4. **Re-verify** (logs + functional test)

