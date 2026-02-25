# 🧪 Lab 29: Using `ENV` and Environment Variables with Podman

## 🧾 Lab Summary
This lab demonstrates how to define environment variables in a `Containerfile` using `ENV`, how to override those values at runtime using `podman run -e`, and how to implement multi-line environment variables. I also created a small documentation README to clearly describe variables, defaults, and usage—then verified values using `podman inspect`.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Define environment variables in a `Containerfile`
- Override environment variables at runtime using `podman run -e`
- Implement multi-line environment variables
- Document environment variables effectively

---

## ✅ Prerequisites
- Basic Linux command line knowledge
- Podman installed (v3.0+)
- Text editor (vim/nano/VS Code)
- Internet access (to pull images if needed)

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Base Image | `alpine:latest` |
| Focus | Environment configuration & runtime overrides |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab29-using-env-and-environment-variables/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── Containerfile
└── env-vars.md
````

> Note: This lab created a separate documentation file (`env-vars.md`) to describe variables clearly.
> (The lab text calls it `README.md`, but to avoid confusion with the lab writeup README, the documentation is stored as `env-vars.md`.)

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Verified Podman version
* Created a lab directory to keep files isolated

---

### ✅ Task 1: Setting `ENV` in a Containerfile

* Created a `Containerfile` defining:

  * `APP_NAME`
  * `APP_VERSION`
* Used shell-form `CMD` so variable expansion works as expected
* Built `env-demo` and verified output

---

### ✅ Task 2: Overriding `ENV` at Runtime

* Overrode one variable:

  * `podman run -e APP_NAME="NewApp" env-demo`
* Overrode multiple variables:

  * `podman run -e APP_NAME="ProductionApp" -e APP_VERSION="2.0.0" env-demo`

---

### ✅ Task 3: Multi-line Environment Variables

* Updated the `Containerfile` to add:

  * `APP_DESCRIPTION` as a multi-line variable
* Built and ran `multiline-env` to print the description

---

### ✅ Task 4: Documenting Environment Variables

* Created a Markdown table documenting:

  * variable name
  * description
  * default value
* Verified documentation matches container definitions using:

  * `grep -n "ENV" -A3 Containerfile`

---

### ✅ Validation: Inspect ENV Values

* Started a temporary container:

  * `podman run -d --name envcheck multiline-env`
* Verified variables using:

  * `podman inspect envcheck --format ...`
* Removed the container after validation

---

## ✅ Verification & Validation

* `env-demo` printed:

  * `Running MyApp version 1.0.0`
* Runtime override worked:

  * changed `APP_NAME`
  * changed both `APP_NAME` and `APP_VERSION`
* `multiline-env` printed:

  * `This is a multi-line environment variable example`
* `podman inspect` confirmed actual ENV values inside container

---

## 🧠 What I Learned

* `ENV` sets default variables that persist in image metadata
* Shell-form `CMD` expands variables like `$APP_NAME` at runtime
* `podman run -e` is the standard way to override env vars per container run
* Multi-line `ENV` can be written across lines but becomes a single stored string
* Documenting variables helps operational teams run containers correctly
* `podman inspect` provides a reliable way to verify effective values

---

## 💡 Why This Matters

Environment variables are one of the most common ways to configure containerized applications. This matters especially in OpenShift/Kubernetes where:

* configuration changes are done via environment variables
* the same image must work across dev/staging/prod
* documentation prevents misconfiguration and reduces support time

---

## 🌍 Real-World Applications

* Injecting configuration for microservices (URLs, feature flags, modes)
* Running the same container image in multiple environments without rebuilds
* Creating clean “ops documentation” for application runtime settings
* Validating runtime configuration during troubleshooting via inspection

---

## ✅ Result

* Built and ran images demonstrating:

  * basic ENV defaults (`env-demo`)
  * runtime overrides (`-e`)
  * multi-line ENV variables (`multiline-env`)
* Documented the environment variables in a dedicated file
* Verified variables inside a running container using `podman inspect`

✅ Lab completed successfully on a cloud lab environment.
