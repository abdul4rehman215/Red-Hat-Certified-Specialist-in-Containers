# 🧪 Lab 26: `CMD` vs `ENTRYPOINT` Instructions

## 🧾 Lab Summary
This lab demonstrates the behavioral difference between `CMD` and `ENTRYPOINT` in container images. I implemented each instruction separately, tested how `CMD` is overridden at runtime, explored how `ENTRYPOINT` behaves like a fixed executable with appended arguments, and combined `ENTRYPOINT + CMD` to provide default arguments. Finally, I built a script-based ENTRYPOINT to show a practical real-world pattern and tested overriding the entrypoint completely at runtime.

---

## 🎯 Objectives
- Understand the difference between `CMD` and `ENTRYPOINT`
- Implement both instructions in Containerfiles
- Combine `ENTRYPOINT` with `CMD` for default arguments
- Test command overriding at runtime

---

## ✅ Prerequisites
- Podman or Docker installed (Podman recommended)
- Basic Linux command-line familiarity
- Text editor (vim/nano/vscode)
- Internet access to pull base images

---

## ⚙️ Lab Environment
| Component | Details |
|---|---|
| OS | CentOS Linux 7 (Core) |
| User | `centos` |
| Container Tool | Podman `3.4.4` |
| Base Image | `alpine:latest` |
| Key Focus | Container runtime behavior and overrides |

✅ Executed in a cloud lab environment.

---

## 🗂️ Repository Structure
```text
lab26-cmd-vs-entrypoint-instructions/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── entrypoint.sh
````

> Note: This lab includes a real `entrypoint.sh` script used in Task 4.

---

## 🧩 Tasks Overview (What I Did)

### ✅ Lab Setup

* Verified Podman version
* Created a dedicated directory for the lab

---

### ✅ Task 1: Understanding `CMD`

#### Subtask 1.1 — Basic CMD Implementation

* Created `Containerfile.cmd` with:

  * `CMD ["echo", "Hello from CMD"]`
* Built and ran the image to verify default command behavior

#### Subtask 1.2 — Overriding CMD

* Ran container with a command override:

  * `podman run cmd-demo echo "Overridden command"`
* Verified that `CMD` is easily replaced at runtime

**Key concept:** `CMD` provides a default command/arguments that can be overridden.

---

### ✅ Task 2: Understanding `ENTRYPOINT`

#### Subtask 2.1 — Basic ENTRYPOINT Implementation

* Created `Containerfile.entrypoint` with:

  * `ENTRYPOINT ["echo", "Hello from ENTRYPOINT"]`
* Built and ran to verify default executable behavior

#### Subtask 2.2 — Appending to ENTRYPOINT

* Ran container with appended args:

  * `podman run entrypoint-demo "with appended text"`
* Verified that args are appended to the ENTRYPOINT command

**Key concept:** ENTRYPOINT makes the container behave like an executable and appends runtime arguments.

---

### ✅ Task 3: Combining `ENTRYPOINT` and `CMD`

#### Subtask 3.1 — ENTRYPOINT with CMD Defaults

* Created `Containerfile.combined`:

  * `ENTRYPOINT ["echo"]`
  * `CMD ["Default message"]`
* Verified default output

#### Subtask 3.2 — Overriding CMD in Combined Setup

* Overrode default message at runtime:

  * `podman run combined-demo "Custom message"`

**Key concept:** `ENTRYPOINT` defines the executable; `CMD` provides default arguments.

---

### ✅ Task 4: Advanced Usage Patterns

#### Subtask 4.1 — Shell Script as ENTRYPOINT

* Created `entrypoint.sh`:

  * prints provided arguments
  * executes the passed command using `exec "$@"`
* Created `Containerfile.script` that copies the script into the image and sets it as ENTRYPOINT
* Built and ran to verify script-based behavior

#### Subtask 4.2 — Full Command Override

* Fully replaced ENTRYPOINT at runtime:

  * `podman run --entrypoint /bin/ls script-demo -l /`
* Verified that overriding ENTRYPOINT changes container behavior completely

---

## ✅ Verification & Validation

* Verified CMD default output:

  * `Hello from CMD`
* Verified CMD override output:

  * `Overridden command`
* Verified ENTRYPOINT default output:

  * `Hello from ENTRYPOINT`
* Verified ENTRYPOINT arg append:

  * `Hello from ENTRYPOINT with appended text`
* Verified combined setup defaults and override behavior:

  * `Default message` → overridden to `Custom message`
* Verified script-based ENTRYPOINT behavior:

  * printed argument list + executed default command
* Verified full ENTRYPOINT override successfully listed `/` directory
* Verified all built images existed using `podman images`

---

## 🧠 What I Learned

* `CMD` is best for default commands/arguments that users may override
* `ENTRYPOINT` is best when the image should behave as a fixed executable
* Combining `ENTRYPOINT + CMD` provides a flexible pattern:

  * immutable executable + configurable defaults
* Script-based entrypoints are common for startup logic, argument handling, and initialization
* Runtime overrides differ:

  * CMD override replaces defaults
  * ENTRYPOINT override requires `--entrypoint`

---

## 💡 Why This Matters

Correctly using `CMD` and `ENTRYPOINT` improves:

* predictability of container behavior
* portability across environments (Podman/Kubernetes/OpenShift)
* flexibility for operators (override args/commands without rebuilding)
* maintainability for production images

---

## 🌍 Real-World Applications

* Building reusable CLI-style containers (ENTRYPOINT)
* Creating web server images with default runtime flags (ENTRYPOINT + CMD)
* Writing startup scripts that configure environment before launching services
* Allowing operators to override runtime commands safely in Kubernetes Pods

---

## ✅ Result

* Built four container images demonstrating:

  * CMD only (`cmd-demo`)
  * ENTRYPOINT only (`entrypoint-demo`)
  * combined (`combined-demo`)
  * script-based entrypoint (`script-demo`)
* Validated runtime behavior, appended args, and command override patterns
* Cleaned up images after completion

✅ Lab completed successfully on a cloud lab environment.

