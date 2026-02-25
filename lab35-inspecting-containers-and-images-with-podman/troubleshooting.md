# 🛠️ Troubleshooting Guide — Lab 35: Inspecting Containers and Images with Podman

> This file covers common issues when inspecting containers/images, extracting env variables, reading mounts/ports, and interpreting container state.

---

## 1) `sudo: dnf: command not found`

### ✅ Symptom
```bash
sudo dnf install -y podman
````

returns:

```text id="3u9d4t"
sudo: dnf: command not found
```

### 🔎 Cause

CentOS 7 commonly uses `yum` instead of `dnf`.

### ✅ Fix

```bash id="v7v4zg"
sudo yum install -y podman
```

---

## 2) `podman inspect` output is too large / hard to read

### ✅ Symptom

`podman inspect <name>` prints huge JSON.

### ✅ Fixes

* Preview only the top section:

  ```bash
  podman inspect <name> | head -n 30
  ```
* Use `--format` to extract specific fields:

  ```bash
  podman inspect <name> --format '{{.State.Status}}'
  ```
* Pretty-print with `jq` (if installed):

  ```bash
  podman inspect <name> | jq
  ```

---

## 3) `jq: command not found`

### ✅ Symptom

```bash
jq --version
```

returns:

```text id="w5y6uw"
-bash: jq: command not found
```

### ✅ Fix

Install using yum on CentOS 7:

```bash id="5z8w7q"
sudo yum install -y jq
```

---

## 4) Go-template function errors (example: `split` not defined)

### ✅ Symptom

Using:

```bash id="6q1t1p"
podman inspect env_test --format '{{range .Config.Env}}{{if eq (index (split . "=") 0) "APP_COLOR"}}{{.}}{{end}}{{end}}'
```

returns:

```text id="u7l8bm"
template parsing error: template: inspect:1: function "split" not defined
```

### 🔎 Cause

Podman’s supported template functions vary by version/build.

### ✅ Fix (reliable fallback)

Print env list and filter with standard tools:

```bash id="u9tq0o"
podman inspect env_test --format '{{.Config.Env}}' | tr ' ' '\n' | grep '^APP_COLOR='
```

---

## 5) Container shows no IP address / IP field is blank

### ✅ Symptom

```bash
podman inspect <container> --format '{{.NetworkSettings.IPAddress}}'
```

returns blank.

### 🔎 Possible Causes

* Container uses a network mode where IP isn’t exposed in that field
* Container not running
* Network not created/assigned yet

### ✅ Fixes

* Confirm container is running:

  ```bash
  podman ps
  ```
* Inspect full network settings:

  ```bash
  podman inspect <container> | grep -n "NetworkSettings" -A50
  ```
* Check container network:

  ```bash
  podman network ls
  ```

---

## 6) Port mapping info is missing or confusing

### ✅ Symptom

`NetworkSettings.Ports` doesn’t show what you expect.

### 🔎 Causes

* Container was started without `-p`
* Wrong container name inspected
* Port is exposed internally but not published

### ✅ Fixes

* Confirm how container was started:

  ```bash
  podman ps
  ```
* Ensure you used publish flag:

  ```bash
  podman run -d -p 8080:80 --name my_nginx nginx:alpine
  ```
* Print ports mapping:

  ```bash
  podman inspect my_nginx --format '{{.NetworkSettings.Ports}}'
  ```

---

## 7) Mounts show empty / missing expected mount

### ✅ Symptom

`podman inspect <container> --format '{{.Mounts}}'` doesn’t show expected mount.

### 🔎 Causes

* Container started without `-v`
* Different container name
* Mount path differs from what you assumed

### ✅ Fixes

* Confirm container creation command includes `-v`
* Re-run with explicit mount:

  ```bash
  podman run -d --name vol_test -v /tmp:/container_tmp nginx:alpine
  ```
* Inspect mounts again:

  ```bash
  podman inspect vol_test --format '{{.Mounts}}'
  ```

---

## 8) Non-zero exit code but no obvious error

### ✅ Symptom

Exit code is not 0:

```bash
podman inspect <container> --format '{{.State.ExitCode}}'
```

### 🔎 Causes

* Command inside container failed
* Missing dependencies or wrong command path
* App crash due to config/env issues

### ✅ Fixes

* Check logs:

  ```bash
  podman logs <container>
  ```
* Check error field:

  ```bash
  podman inspect <container> --format '{{.State.Error}}'
  ```
* Inspect full state:

  ```bash
  podman inspect <container> --format '{{json .State}}' | jq
  ```

---

## ✅ Quick Verification Checklist

* Inspect container basics:

  ```bash
  podman inspect my_nginx | head -n 30
  ```
* Container IP:

  ```bash
  podman inspect my_nginx --format '{{.NetworkSettings.IPAddress}}'
  ```
* Env vars:

  ```bash
  podman inspect env_test --format '{{.Config.Env}}'
  ```
* Extract a specific env var:

  ```bash
  podman inspect env_test --format '{{.Config.Env}}' | tr ' ' '\n' | grep '^APP_COLOR='
  ```
* Mounts:

  ```bash
  podman inspect vol_test --format '{{.Mounts}}'
  ```
* Ports:

  ```bash
  podman inspect my_nginx --format '{{.NetworkSettings.Ports}}'
  ```
* Exit code:

  ```bash
  podman inspect fail_test --format '{{.State.ExitCode}}'
  ```
