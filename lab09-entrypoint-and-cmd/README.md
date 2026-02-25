# 🧪 Lab 09: Using ENTRYPOINT and CMD in Containerfiles

## 📌 Lab Summary
This lab explores how **ENTRYPOINT** and **CMD** control container startup behavior and how they can be overridden at runtime. It demonstrates:
- Default startup using ENTRYPOINT + CMD
- Overriding CMD by passing arguments to `podman run`
- Using a script as ENTRYPOINT for more flexible startup logic
- Overriding ENTRYPOINT using `--entrypoint`
- Understanding **exec form vs shell form** and why exec form is usually preferred (signal handling, predictable argument parsing)

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Explain the difference between `ENTRYPOINT` and `CMD`
- Combine `ENTRYPOINT` + `CMD` to create flexible container startup commands
- Override default CMD arguments at runtime
- Use a script-based ENTRYPOINT and override its arguments
- Override ENTRYPOINT at runtime using `--entrypoint`
- Compare exec form (JSON array) vs shell form

---

## ✅ Prerequisites
- Podman installed (recommended for OpenShift compatibility)
- Basic understanding of Containerfile/Dockerfile syntax
- Command-line access

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman | Used for builds and runs |
| Base Image | `registry.access.redhat.com/ubi9/ubi-minimal` |
| Images Built | `entrypoint-demo`, `greet-demo`, `shellform-demo` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab09-entrypoint-and-cmd/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── Containerfile.entrypoint-demo
    ├── greet.sh
    ├── Containerfile.greet-demo
    └── Containerfile.shellform-demo
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: ENTRYPOINT + CMD Basics

* Created `entrypoint-cmd-lab/`
* Wrote a Containerfile using exec form:

  * `ENTRYPOINT ["echo", "Entrypoint says:"]`
  * `CMD ["Default CMD message"]`
* Built the image: `entrypoint-demo`

### ✅ Task 2: Test Default and Override CMD

* Ran container normally:

  * output combined ENTRYPOINT + CMD
* Overrode CMD by passing arguments after image name:

  * `podman run --rm entrypoint-demo "Custom message"`

### ✅ Task 3: Script-Based ENTRYPOINT (Advanced Combination)

* Created `greet.sh` script and set executable permissions
* Updated Containerfile to:

  * copy script into image
  * use script as ENTRYPOINT
  * supply default CMD arguments
* Built image: `greet-demo`
* Ran with default args and then overridden args

### ✅ Task 4: Override ENTRYPOINT

* Used `--entrypoint` to replace ENTRYPOINT at runtime:

  * `podman run --rm --entrypoint echo greet-demo "..."`
* Confirmed output was produced by overridden entrypoint

### ✅ Task 5: Shell Form vs Exec Form

* Updated Containerfile to use shell form:

  * `ENTRYPOINT echo "Shell form ENTRYPOINT:"`
  * `CMD echo "Shell form CMD"`
* Built and ran image: `shellform-demo`
* Observed output differences and discussed best practices

### 🧹 Cleanup

* Removed lab images:

  * `podman rmi entrypoint-demo greet-demo shellform-demo`

---

## ✅ Verification & Validation

* Built images successfully using `podman build`
* Verified behavior:

  * Default run: ENTRYPOINT + CMD output combined
  * CMD override: passing args replaced CMD
  * Script-based entrypoint: produced output using default args and overrides
  * ENTRYPOINT override: `--entrypoint` replaced the executable
  * Shell form run produced two output lines (entrypoint then cmd)

---

## 🧠 What I Learned

* `ENTRYPOINT` defines the primary executable that runs when container starts
* `CMD` provides default arguments (or default command if ENTRYPOINT not set)
* Passing args after image name replaces CMD (exec-form behavior)
* `--entrypoint` can fully override the container startup executable
* Script-based entrypoints are practical for complex startup logic
* Exec form is usually preferred over shell form for:

  * better signal handling
  * predictable argument passing
  * avoiding implicit shell behavior

---

## 🌍 Why This Matters

ENTRYPOINT/CMD design matters for:

* predictable container startup in OpenShift/Kubernetes
* supporting runtime overrides in deployments
* correct handling of termination signals (important for graceful shutdown)
* writing reusable images that behave well across environments

---

## ✅ Result

* Built and tested multiple ENTRYPOINT/CMD combinations
* Successfully overrode both CMD and ENTRYPOINT at runtime
* Confirmed exec-form vs shell-form behavioral differences
* Cleaned up lab images successfully

---

## ✅ Conclusion

This lab provided a strong foundation in container startup behavior using ENTRYPOINT and CMD. These concepts are essential for building reliable container images for OpenShift/Kubernetes where startup commands, runtime overrides, and signal handling directly impact application reliability.
