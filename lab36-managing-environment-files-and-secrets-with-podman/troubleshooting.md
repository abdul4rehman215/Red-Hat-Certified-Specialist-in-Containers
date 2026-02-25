# 🛠️ Troubleshooting Guide — Lab 36: Managing Env Files and Secrets with Podman

> This file covers common issues when loading `.env` files, creating Podman secrets, and running Podman Compose with external secrets on CentOS 7.

---

## 1) `--env-file` loads nothing / variables not visible

### ✅ Symptom
You run:
```bash
podman run --rm --env-file=.env alpine env | grep APP_
````

but nothing prints.

### 🔎 Possible Causes

* `.env` file path is wrong
* file format has spaces or invalid lines
* you’re not in the directory that contains `.env`

### ✅ Fixes

* Confirm file exists:

  ```bash
  ls -la .env
  ```
* Validate contents:

  ```bash
  cat .env
  ```
* Ensure correct format (no `export`, no spaces around `=`):

  ```text
  KEY=value
  ```
* Use absolute path if needed:

  ```bash
  podman run --rm --env-file=/home/centos/podman-secrets-lab/.env alpine env
  ```

---

## 2) `.env` parsing breaks due to special characters

### ✅ Symptom

Passwords like `SuperSecret123!` cause unexpected results in some shells or scripts.

### 🔎 Cause

While `.env` parsing usually accepts `!`, problems can occur if values are copied into shell scripts without quoting, or if a shell expands characters in interactive contexts.

### ✅ Fix

Keep `.env` as pure key-value (as done in this lab). If using scripts, quote values when exporting:

```bash id="d2k6e4"
export DB_PASS='SuperSecret123!'
```

---

## 3) `podman secret create` fails

### ✅ Symptom

Secret creation fails or secret not found later.

### 🔎 Possible Causes

* Secret name already exists
* Source file missing
* No permission to read file

### ✅ Fixes

* Verify file exists:

  ```bash
  ls -la db_password.txt
  ```
* List existing secrets:

  ```bash
  podman secret ls
  ```
* Remove and recreate if name collision:

  ```bash
  podman secret rm db_password_secret
  podman secret create db_password_secret db_password.txt
  ```

---

## 4) Secret not available inside container

### ✅ Symptom

Inside container:

```bash
cat /run/secrets/db_password_secret
```

returns “No such file”.

### 🔎 Causes

* Secret was not passed with `--secret=...`
* Secret name mismatch

### ✅ Fix

Run container with correct secret flag:

```bash id="t1j9z3"
podman run --rm --secret=db_password_secret alpine cat /run/secrets/db_password_secret
```

Confirm secret exists:

```bash
podman secret ls
```

---

## 5) Permission errors when reading secrets

### ✅ Symptom

Permission denied when reading `/run/secrets/...`

### 🔎 Possible Causes

* Running in rootless mode with permission constraints
* Secret file permissions and container user mismatch

### ✅ Fixes

* Test with default user first (as in this lab)
* If needed for troubleshooting only:

  * run as root inside container (`--user 0`)
  * avoid `--privileged` unless absolutely required

```bash id="k2k7q4"
podman run --rm --user 0 --secret=db_password_secret alpine cat /run/secrets/db_password_secret
```

---

## 6) `podman-compose: command not found`

### ✅ Symptom

```text id="r9v6q3"
-bash: podman-compose: command not found
```

### 🔎 Cause

Podman Compose is not installed.

### ✅ Fix

Install it with pip3. On CentOS 7 you may need to install `python3-pip` first:

```bash id="b6t3p0"
sudo yum install -y python3-pip
pip3 install --user podman-compose
```

---

## 7) `pip3` points to Python 2.7 (unexpected)

### ✅ Symptom

```bash
pip3 --version
```

shows:

```text id="s9d3m1"
pip 9.0.3 from /usr/lib/python2.7/site-packages (python 2.7)
```

### 🔎 Cause

Some CentOS 7 environments ship pip wrappers that map unexpectedly.

### ✅ Fix

Install `python3-pip` from yum (as done in this lab) and re-check:

```bash id="p4f7x8"
sudo yum install -y python3-pip
pip3 --version
```

---

## 8) `podman-compose` installed but still not found (PATH issue)

### ✅ Symptom

Install succeeds, but command still missing.

### 🔎 Cause

pip `--user` installs binaries into `~/.local/bin`, which may not be in PATH.

### ✅ Fix

Add to PATH for current session:

```bash id="e9y1m3"
export PATH=$PATH:/home/centos/.local/bin
```

(Optional persistent fix in `~/.bashrc`):

```bash
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
```

---

## 9) Compose fails because secret is external and missing

### ✅ Symptom

Compose errors about secret not existing.

### 🔎 Cause

Your compose file uses:

```yaml
secrets:
  db_password_secret:
    external: true
```

So the secret must exist before `podman-compose up`.

### ✅ Fix

Create the secret first:

```bash id="y2b8d8"
podman secret create db_password_secret db_password.txt
podman secret ls
```

---

## 10) `$APP_NAME` prints blank in compose command

### ✅ Symptom

The container prints an empty line instead of `MySecureApp`.

### 🔎 Cause

YAML command string expanded on host-side or was not exported correctly to container environment.

### ✅ Fix

Escape `$` in compose so it expands inside container:

```yaml id="w4d4y3"
command: sh -c "echo \$APP_NAME && cat /run/secrets/db_password_secret"
```

Also confirm env file is referenced correctly:

```yaml
env_file: .env
```

---

## ✅ Quick Verification Checklist

* Confirm env file loads:

  ```bash
  podman run --rm --env-file=.env alpine env | grep -E 'APP_NAME|DB_'
  ```
* Confirm secret exists + readable:

  ```bash
  podman secret ls
  podman run --rm --secret=db_password_secret alpine cat /run/secrets/db_password_secret
  ```
* Confirm compose runs:

  ```bash
  podman-compose up
  ```
* Cleanup:

  ```bash
  podman secret rm db_password_secret
  ```
