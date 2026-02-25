# 🧠 Interview Q&A — Lab 15: Remote Debugging of Containers (Node.js + VS Code)

---

## 1) What is “remote debugging” in containers?
Remote debugging means attaching a debugger (like VS Code) to a process running inside a container, usually via a debug port, without needing to run the app directly on the host.

---

## 2) Why is remote debugging useful in containerized workflows?
It allows you to:
- debug the application in an environment close to production
- avoid repeated rebuilds for small code changes
- troubleshoot runtime-only issues (container config, env, network)

---

## 3) What is the default Node.js debug port and what flag enables it?
Node.js uses port **9229** with the inspector enabled using:
- `--inspect=0.0.0.0:9229`

---

## 4) Why bind the inspector to `0.0.0.0` instead of `127.0.0.1`?
Binding to `0.0.0.0` allows connections from outside the container (through port publishing). If bound to localhost only, remote tools can’t attach from the host.

---

## 5) What ports did you publish in this lab and why?
- `3000:3000` for the application HTTP service
- `9229:9229` for the Node inspector debug port

---

## 6) How did you build the application image used in the lab?
I created:
- `server.js` (HTTP server)
- `Containerfile` based on `node:20-alpine`
Then built:
- `podman build -t my-node-app .`

---

## 7) Why mount source code into the container (`-v $(pwd):/app`)?
So code changes on the host are immediately visible inside the container. This speeds debugging and reduces rebuild cycles.

---

## 8) How did you verify the mount worked?
By listing files inside container:
- `podman exec -it debug-container ls /app`
and seeing `server.js` and `Containerfile`.

---

## 9) How do you confirm the debug port is exposed properly?
Use:
- `podman port debug-container`
It shows host bindings like:
- `9229/tcp -> 0.0.0.0:9229`

---

## 10) How did you confirm the debugger is actually listening?
By checking logs:
- `podman logs debug-container | head`
It showed:
- `Debugger listening on ws://0.0.0.0:9229/...`

---

## 11) What is the role of `launch.json` in VS Code debugging?
It defines the debugger configuration, including:
- attach mode
- host and port
- local and remote source paths (`localRoot`, `remoteRoot`)

---

## 12) What do `localRoot` and `remoteRoot` mean?
- `localRoot` is the source path on your machine (VS Code workspace)
- `remoteRoot` is the corresponding source path inside the container
Mapping them correctly ensures breakpoints hit the correct files.

---

## 13) Why did you stop/remove the container before re-running it in Task 2?
Because the container name `debug-container` already existed. Podman won’t allow creating another container with the same name unless the previous one is removed.

---

## 14) What security risk exists when exposing debug ports?
Debug ports can allow deep access (inspect memory, execute code). Expose them only in trusted environments and avoid binding publicly in production.

---

## 15) How does this relate to debugging in Kubernetes/OpenShift?
In Kubernetes/OpenShift, debugging commonly uses:
- port-forwarding to the pod debug port
- ephemeral debugging containers
- remote attach workflows
The same core concept applies: attach debugger to a running workload without rebuilding repeatedly.
