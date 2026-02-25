# 🧪 Lab 08: Environment Variables in Images (ENV + ARG)

## 📌 Lab Summary
This lab demonstrates how to manage configuration in container images using:
- **ENV** (runtime environment variables stored in the image)
- **ARG** (build-time variables passed during `podman build`)

It also covers:
- overriding ENV values at runtime using `-e`
- using `--env-file` to inject environment variables
- inspecting environment variables inside a **running** container using `podman exec`

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Define environment variables in images using `ENV`
- Override variables at runtime using `podman run -e`
- Inject variables using `--env-file`
- Inspect environment variables in containers using `podman exec ... env`
- Use build-time arguments (`ARG`) and convert them into runtime values via `ENV`

---

## ✅ Prerequisites
- Basic Linux command line knowledge
- Podman installed (recommended for OpenShift alignment)
- Text editor (Nano/Vim)
- Internet access to pull base images

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman Version | 4.9.3 |
| Base Image | `registry.access.redhat.com/ubi8/ubi-minimal` |
| Images Built | `env-demo`, `arg-demo` |

> Note: This lab uses UBI minimal from Red Hat’s registry. Podman pulled it successfully during the build.

---

## 🗂️ Repository Structure (Lab Format)
```text
lab08-environment-variables-in-images/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── Containerfile.env
    ├── Containerfile.arg
    └── app.env
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Define Environment Variables in a Containerfile (ENV)

* Created a project directory `env-lab/`
* Wrote a Containerfile that sets:

  * `APP_NAME`, `APP_VERSION`, `APP_ENV` via `ENV`
* Built the image as `env-demo`
* Ran the container and confirmed output:

  * `Running MyApp v1.0 in development mode`

### ✅ Task 2: Override Environment Variables at Runtime

* Overrode variables using CLI flags:

  * `-e APP_ENV="production" -e APP_VERSION="2.0"`
* Used an environment file (`app.env`) and ran:

  * `podman run --env-file=app.env env-demo`
* Confirmed overridden outputs reflect injected values

### ✅ Task 3: Inspect Variables in Running Containers

* Demonstrated a realistic behavior:

  * Containers that run `echo ...` exit immediately
  * `podman exec` requires a **running** container
* Fixed this by running the same image with a long-lived command:

  * `sh -c 'sleep 300'`
* Successfully inspected environment variables using:

  * `podman exec env-container env`

### ✅ Task 4: Use ARG for Build-Time Variables

* Modified Containerfile to include:

  * `ARG APP_BUILD_NUMBER`
  * `ENV APP_BUILD=$APP_BUILD_NUMBER`
* Built using:

  * `podman build --build-arg APP_BUILD_NUMBER=42 -t arg-demo .`
* Ran `arg-demo` and verified:

  * `Build number: 42`

### 🧹 Cleanup

* Removed all lab containers:

  * `podman rm -f $(podman ps -aq)`
* Removed lab images:

  * `podman rmi env-demo arg-demo`

---

## ✅ Verification & Validation

* Podman verified: `podman --version` → `4.9.3`
* ENV behavior verified:

  * default output from `env-demo`
  * overridden output via `-e`
  * overridden output via `--env-file`
* Inspection verified:

  * `podman exec env-container env` displayed:

    * `APP_NAME`, `APP_VERSION`, `APP_ENV`
* ARG behavior verified:

  * build argument passed successfully
  * runtime prints the expected build number

---

## 🧠 What I Learned

* `ENV` sets default runtime configuration baked into the image
* `-e` overrides ENV values at runtime for flexible deployments
* `--env-file` is a clean way to manage multiple environment variables
* `ARG` values are build-time only unless explicitly copied into runtime using `ENV`
* `podman exec` requires the container to be running, so short-lived containers need a long-running command for inspection/debugging

---

## 🌍 Why This Matters

Environment variables are one of the most common ways to configure applications in:

* OpenShift Deployments
* Kubernetes Pods
* CI/CD pipelines
* multi-environment deployments (dev/staging/prod)

Understanding `ENV`, `ARG`, and runtime overrides is essential for reliable and repeatable containerized deployments.

---

## ✅ Result

* Successfully built images using ENV and ARG
* Demonstrated runtime overrides via CLI and env files
* Inspected environment variables in running containers
* Cleaned up containers and images after the lab

---

## ✅ Conclusion

This lab provided practical experience managing configuration in container images using `ENV` and `ARG`, overriding values at runtime, and validating configuration inside running containers. These skills directly map to how OpenShift and Kubernetes manage application configuration using environment variables.
