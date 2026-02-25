# 🛠️ Troubleshooting Guide — Lab 14: Networking in Containers (Podman)

> This document covers common networking issues: port publishing failures, DNS/connectivity issues, and custom network problems.

---

## 1) `podman network create` fails
### ✅ Symptom
Creating a network returns an error.

### 📌 Likely Cause
- Rootless networking limitations (rare on modern Podman, but possible)
- Network backend misconfiguration

### ✅ Fix
Check Podman info:
```bash
podman info | head -n 50
````

Confirm networking backend and rootless socket:

* `remoteSocket.path`
* network tools availability

Retry creation:

```bash id="p4m1n8"
podman network create lab-network
```

---

## 2) Container cannot bind host port (port already in use)

### ✅ Symptom

`podman run -p 8080:80 ...` fails due to port binding error.

### ✅ Fix

1. Check port usage:

```bash id="w4d2z1"
ss -tulnp | grep 8080 || true
```

2. Stop/remove conflicting container:

```bash id="t0m0p2"
podman ps -a
podman stop <container_name>
podman rm <container_name>
```

3. Or use a different host port:

```bash id="y2q8k8"
podman run -d -p 8081:80 docker.io/library/nginx
curl http://localhost:8081 | head
```

---

## 3) `curl http://localhost:8080` fails

### ✅ Symptom

Curl returns connection refused / timeout.

### 📌 Likely Cause

* Container not running
* Wrong port mapping
* Nginx failed to start
* Local firewall or security policy blocking traffic

### ✅ Fix

1. Confirm container is running:

```bash id="6n2yxs"
podman ps
```

2. Check logs:

```bash id="8f7c1m"
podman logs webapp | tail -n 50
```

3. Confirm port mapping:

```bash id="mm8a3g"
podman port webapp
```

4. If firewall-cmd missing on Ubuntu, use UFW checks instead (if enabled):

```bash id="qk2h7m"
sudo ufw status || true
```

---

## 4) Container name conflict when re-running with same name

### ✅ Symptom

`podman run --name webapp ...` fails because the name exists.

### ✅ Fix

Remove the old container first:

```bash id="k9s0e1"
podman ps -a | grep webapp || true
podman rm -f webapp
```

Then re-run.

---

## 5) Container not attached to expected network

### ✅ Symptom

You ran with `--network lab-network`, but inspect doesn’t show it.

### ✅ Fix

Inspect networks:

```bash id="p7m2xq"
podman network ls
podman network inspect lab-network
```

Inspect container networks:

```bash id="o0d8n0"
podman inspect webapp | grep -A 10 "Networks"
```

If incorrect, recreate container specifying network correctly:

```bash id="7a1e3c"
podman rm -f webapp
podman run -d --name webapp --network lab-network -p 8080:80 docker.io/library/nginx
```

---

## 6) DNS or container-to-container connectivity issues

### ✅ Symptom

Containers cannot resolve names or communicate on bridge network.

### ✅ Fix

Check DNS enabled in network inspect:

```bash id="s2k7qk"
podman network inspect lab-network
```

Ensure `dns_enabled: true`.

For connectivity debugging, run a temporary container on the network:

```bash id="q0e1s4"
podman run --rm --network lab-network alpine sh -c "ip a; ping -c 2 10.89.0.1 || true"
```

---

## ✅ Quick Verification Checklist

* Networks present:

  * `podman network ls`
* Network config looks correct:

  * `podman network inspect podman`
  * `podman network inspect lab-network`
* Port is free:

  * `ss -tulnp | grep 8080 || true`
* Container running:

  * `podman ps`
* App reachable:

  * `curl http://localhost:8080 | head`
* Container attached to expected network:

  * `podman inspect webapp | grep -A 10 "Networks"`
