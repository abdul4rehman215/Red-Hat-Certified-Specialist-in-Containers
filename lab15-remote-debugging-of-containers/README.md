# 🧪 Lab 15: Remote Debugging of Containers (Node.js + VS Code Attach)

## 📌 Lab Summary
This lab demonstrates how to set up **remote debugging for containers** without rebuilding images repeatedly. Using a simple Node.js HTTP server, the lab shows:
- Exposing an application port (`3000`) and Node Inspector debug port (`9229`)
- Running a container with `--inspect=0.0.0.0:9229`
- Mounting local source code into the container for **live updates**
- Attaching **VS Code debugger** to the running container using `launch.json`
- Verifying debug port exposure and debugger readiness through `podman port` and logs

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Expose debug ports for remote debugging
- Start a container with Node Inspector enabled
- Mount a local source directory into a running container
- Attach VS Code debugger to the container (port 9229)
- Validate debugging readiness using Podman inspection tools

---

## ✅ Prerequisites
- Podman installed (Podman preferred for OpenShift compatibility)
- VS Code installed
- VS Code extensions:
  - **Remote - Containers**
  - Node.js debugging support (built-in for most VS Code installs; extension optional depending on setup)
- Basic container + Node.js understanding

---

## 🧰 Lab Environment
| Component | Value |
|----------|------|
| Host OS | Ubuntu 24.04.1 LTS (cloud lab environment) |
| Podman | 4.9.3 |
| App | Minimal Node.js HTTP server |
| Image Built | `my-node-app` |
| Container Name | `debug-container` |
| App Port | `3000` |
| Debug Port | `9229` (Node Inspector) |
| Working Dir | `~/debug-lab` |

---

## 🗂️ Repository Structure (Lab Format)
```text
lab15-remote-debugging-of-containers/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── Containerfile
    ├── server.js
    └── launch.json
````

---

## 🧪 Tasks Performed (Overview)

### ✅ Task 1: Expose Debug Ports

* Identified common debug ports:

  * Node.js: `9229`
  * Python (debugpy): `5678`
  * Java (JDWP): `5005`
* Built a minimal Node.js app image `my-node-app`:

  * base image: `node:20-alpine`
  * command: `node --inspect=0.0.0.0:9229 server.js`
* Ran the container with ports exposed:

  * `-p 3000:3000 -p 9229:9229`
* Verified the app:

  * `curl http://localhost:3000`

### ✅ Task 2: Mount Source Code for Live Debugging

* Stopped and removed the first container to reuse the same name
* Ran container with a bind mount:

  * `-v $(pwd):/app`
* Verified files inside container:

  * `podman exec -it debug-container ls /app`

### ✅ Task 3: Connect VS Code Debugger to Container

* Prepared a VS Code attach configuration (`launch.json`) that maps:

  * `localRoot` → `${workspaceFolder}`
  * `remoteRoot` → `/app`
* Verified ports are published:

  * `podman port debug-container`
* Verified debugger is listening:

  * `podman logs debug-container` showed Node inspector WebSocket URL

### 🧹 Optional Cleanup

* Stopped and removed the debug container after testing

---

## ✅ Verification & Validation

* App responded correctly:

  * `Hello from Node debug container!`
* Port mappings verified:

  * 3000/tcp → host 3000
  * 9229/tcp → host 9229
* Debugger readiness verified in logs:

  * `Debugger listening on ws://0.0.0.0:9229/...`
* Volume mount verified:

  * container `/app` contained `Containerfile` and `server.js`

---

## 🧠 What I Learned

* Debugging can be enabled with runtime flags (like Node `--inspect`) without rebuilding the image repeatedly
* Exposing the debug port makes it accessible to IDEs and remote tools
* Bind mounting source code (`-v $(pwd):/app`) enables fast iteration and live updates
* VS Code attach debugging works when:

  * port is open and mapped
  * `localRoot` and `remoteRoot` are aligned
  * the runtime is actually listening (confirmed via logs)

---

## 🌍 Why This Matters

Remote debugging is a common workflow in:

* containerized development environments
* CI-based test environments
* Kubernetes/OpenShift debugging sessions (port-forward style)
  It speeds up troubleshooting and reduces “rebuild loops” during development.

---

## ✅ Result

* Built and ran a debug-enabled Node.js container
* Exposed and validated debug port 9229
* Mounted source code for live inspection/updates
* Prepared VS Code configuration for attaching debugger
* Confirmed inspector listener and container port mappings

---

## ✅ Conclusion

This lab provided a practical remote debugging workflow for containers using Node Inspector and VS Code attach debugging. By exposing debug ports and mounting source code, debugging becomes faster and more interactive—without repeated image rebuilds.
