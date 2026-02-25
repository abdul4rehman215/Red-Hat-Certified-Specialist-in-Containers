# 🧪 Lab 36: Managing Environment Files and Secrets with Podman

## 🧾 Lab Summary
This lab demonstrates two practical ways to manage configuration and sensitive data for containers:

1. **Environment files (`.env`)** using `--env-file` for bulk-loading variables into containers.
2. **Podman secrets** using `podman secret create` and `--secret` to inject sensitive values securely at runtime.

Finally, I integrated both into a **Podman Compose** workflow by referencing an **external secret** inside `docker-compose.yml`, then deploying with `podman-compose up`. Because CentOS 7 initially lacked `podman-compose`, I installed it using `pip3` and updated the PATH for the current session.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Create and use `.env` files to manage environment variables
- Pass environment variables to containers from files
- Create and manage Podman secrets for sensitive data
- Reference secrets in Podman Compose YAML files

---

## ✅ Prerequisites
- Podman installed (v3.0+ recommended)
- Basic Linux command line familiarity
- Text editor (nano/vim/VSCode)
- Podman Compose installed (`pip install podman-compose`)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Compose Tool | `podman-compose 1.0.6` (installed via pip3) |
| Base Image | `alpine` |
| Focus | env files + secrets + compose integration |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab36-managing-environment-files-and-secrets-with-podman/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── .env
├── docker-compose.yml
└── db_password.txt
```

---

## 🧩 Tasks Overview (What I Did)

### ✅ Task 1: Working with Environment Files

* Created a `.env` file containing:

  * `APP_NAME`
  * `DB_USER`
  * `DB_PASS`
* Verified the file contents
* Ran a container using `--env-file=.env` and confirmed variables were loaded:

  * `env | grep -E 'APP_NAME|DB_'`

---

### ✅ Task 2: Working with Podman Secrets

* Created a secret from a file:

  * `db_password.txt` → `db_password_secret`
* Listed secrets to confirm creation
* Ran a container with `--secret=db_password_secret` and verified the secret content is available at:

  * `/run/secrets/db_password_secret`

---

### ✅ Task 3: Podman Compose Integration

* Created `docker-compose.yml` that:

  * loads env vars using `env_file: .env`
  * uses external secret `db_password_secret`
  * prints `$APP_NAME` and secret contents at runtime
* Installed `podman-compose` (not present initially):

  * verified `pip3` originally pointed to Python 2.7
  * installed `python3-pip`
  * installed `podman-compose` with `pip3 install --user`
  * added `~/.local/bin` to PATH
* Ran:

  * `podman-compose up`
* Verified output:

  * `MySecureApp`
  * `TopSecretPassword`

---

## ✅ Verification & Validation

* `.env` successfully loaded into container using `--env-file`
* Secret successfully mounted inside container at `/run/secrets/...`
* Compose workflow successfully consumed both:

  * `.env` variables
  * external secret
* `podman-compose up` completed with exit code 0

---

## 🧠 What I Learned

* `.env` is great for non-sensitive configuration, but can expose secrets if committed
* Podman secrets are safer for sensitive values because they are injected at runtime
* Compose can reference **external** secrets so sensitive data isn’t stored inside YAML
* On CentOS 7, tooling may require:

  * installing `python3-pip`
  * adding `~/.local/bin` to PATH after pip `--user` installs

---

## 🔐 Why This Matters (Security Relevance)

Mismanaging secrets is a major cause of security incidents:

* committing `.env` files leaks credentials
* embedding passwords in YAML is risky
* secrets mechanisms reduce accidental disclosure risk

This lab demonstrates a secure direction: **use secrets for sensitive data**, and keep `.env` for non-sensitive configuration.

---

## ✅ Result

* Used `.env` file to bulk-load environment variables into a container
* Created and used a Podman secret for sensitive data
* Integrated env files + secrets into Podman Compose
* Installed missing tooling (`podman-compose`) and deployed successfully
* Cleaned up secret and lab directory after completion

✅ Lab completed successfully on a cloud lab environment.
