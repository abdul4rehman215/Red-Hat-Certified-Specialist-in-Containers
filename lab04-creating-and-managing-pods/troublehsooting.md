# 🛠️ Troubleshooting Guide — Lab 04: Creating and Managing Pods (Podman)

> This document covers common issues when creating pods, running multiple containers inside a pod, validating shared networking, and using shared volumes.

---

## 1) Pod fails to create or shows incorrect status
### ✅ Symptom
- `podman pod create` fails
- `podman pod list` shows unexpected status

### 📌 Likely Cause
- Podman installation issues
- Rootless configuration limitations in the environment
- Network backend issues (netavark/aardvark)

### ✅ Fix
1) Confirm Podman works:
```bash
podman --version
podman info
````

2. Re-try pod creation:

```bash id="s8jaqd"
podman pod create --name demo-pod -p 8080:80
podman pod list
```

---

## 2) Nginx/Redis container fails to start inside pod

### ✅ Symptom

* `podman run --pod demo-pod ...` fails
* container does not appear in `podman ps --pod`

### 📌 Likely Cause

* Image pull issue (no internet/DNS)
* Wrong image reference
* Pod not existing

### ✅ Fix

1. Ensure pod exists:

```bash id="wlkp22"
podman pod list
```

2. Pull image explicitly and retry:

```bash id="ta98g4"
podman pull docker.io/library/nginx:alpine
podman pull docker.io/library/redis:alpine
```

3. Run containers again:

```bash id="lre3gq"
podman run -d --pod demo-pod --name nginx-container docker.io/library/nginx:alpine
podman run -d --pod demo-pod --name redis-container docker.io/library/redis:alpine
```

4. Inspect status:

```bash id="x4wp7r"
podman ps --pod
```

---

## 3) `jq` not found when inspecting pod

### ✅ Symptom

Running:

* `jq --version`
  returns:
* `bash: jq: command not found`

### 📌 Likely Cause

`jq` is not installed by default on some systems.

### ✅ Fix

Install jq:

```bash id="byc314"
sudo apt-get update
sudo apt-get install -y jq
```

Then retry:

```bash id="v2j4hj"
podman pod inspect demo-pod | jq '.Containers[].Names'
```

---

## 4) `ping: not found` inside Alpine container

### ✅ Symptom

Inside container:

* `ping redis-container`
  returns:
* `sh: ping: not found`

### 📌 Likely Cause

Minimal Alpine images often exclude tools like ping to reduce image size.

### ✅ Fix

Install `iputils` inside the container:

```sh
apk add --no-cache iputils
```

Then retry:

```sh id="mv4dyw"
ping -c 4 redis-container
```

---

## 5) Containers in pod cannot communicate by hostname

### ✅ Symptom

Ping fails even after installing ping tools, or DNS name does not resolve.

### 📌 Likely Cause

* DNS name plugin not enabled for the pod network
* Network backend misconfiguration
* Firewall restrictions

### ✅ Fix

1. Confirm pod network options:

```bash id="pk6c8u"
podman pod inspect demo-pod | jq '.InfraConfig.NetworkOptions'
```

2. If hostname resolution is an issue, verify with container IP or inspect:

```bash id="92c13u"
podman inspect redis-container | jq '.[0].NetworkSettings'
```

3. Check container logs:

```bash id="lw0lrf"
podman logs nginx-container
podman logs redis-container
```

---

## 6) Port mapping not working (8080 not reachable)

### ✅ Symptom

Service inside pod doesn’t respond on host port 8080.

### 📌 Likely Cause

* Port mapping not created correctly
* Host firewall blocking the port
* Nginx container not running

### ✅ Fix

1. Confirm port mapping:

```bash id="x2tx7z"
podman port demo-pod
```

2. Confirm nginx is running:

```bash id="hfzviy"
podman ps --pod
```

3. Check firewall rules (if applicable):

```bash id="z920dr"
sudo firewall-cmd --list-ports
```

---

## 7) Shared volume does not show expected files

### ✅ Symptom

File created in one container not visible in the other.

### 📌 Likely Cause

* Wrong mount path
* Volume not mounted into both containers
* Containers not using same volume

### ✅ Fix

1. Confirm volume exists:

```bash id="xplf2p"
podman volume ls
```

2. Confirm containers have volume mounted:

```bash id="h9jthn"
podman inspect nginx2 | jq '.[0].Mounts'
podman inspect redis2 | jq '.[0].Mounts'
```

3. Re-test:

```bash id="p4s6cd"
podman exec -it nginx2 touch /data/testfile
podman exec -it redis2 ls /data
```

---

## 🧹 Cleanup Fails (pod stuck / containers leftover)

### ✅ Symptom

Pod removal fails or leftover containers remain.

### ✅ Fix

Force remove pod:

```bash id="r94z5u"
podman pod rm -f demo-pod
```

Remove volume:

```bash id="rnulw4"
podman volume rm shared-vol
```

---

## ✅ Quick Verification Checklist

* Pod exists:

  * `podman pod list`
* Containers in pod:

  * `podman ps --pod`
* Port mapping exists:

  * `podman port demo-pod`
* Hostname works:

  * `ping -c 4 redis-container` (after installing iputils)
* Volume sharing works:

  * `testfile` visible in both containers
