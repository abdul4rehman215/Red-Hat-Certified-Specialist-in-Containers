# 🛠️ Troubleshooting Guide — Lab 15: Remote Debugging of Containers (Node.js + VS Code)

> This document covers common problems when exposing debug ports, mounting code, and attaching VS Code to a running container.

---

## 1) Port already in use (3000 or 9229)
### ✅ Symptom
`podman run -p 3000:3000 -p 9229:9229 ...` fails with a port binding error.

### ✅ Fix
1) Identify what is using the port:
```bash
ss -tulnp | grep -E '3000|9229' || true
````

2. Stop/remove the conflicting container:

```bash id="a4d4ob"
podman ps -a
podman stop <container_name>
podman rm <container_name>
```

3. Or map to different host ports:

```bash id="r8y7d0"
podman run -d -p 3001:3000 -p 9230:9229 --name debug-container my-node-app
```

---

## 2) Debugger won’t attach (VS Code connects but breakpoints don’t hit)

### ✅ Symptom

* VS Code attaches, but breakpoints stay grey
* Source mapping looks wrong

### 📌 Likely Cause

`localRoot` and `remoteRoot` mismatch.

### ✅ Fix

Ensure `launch.json` matches your paths:

```json
{
  "type": "node",
  "request": "attach",
  "name": "Attach to Container",
  "address": "localhost",
  "port": 9229,
  "localRoot": "${workspaceFolder}",
  "remoteRoot": "/app"
}
```

Also confirm container actually has the code at `/app`:

```bash id="mq4m22"
podman exec -it debug-container ls -l /app
```

---

## 3) Debug port is published, but Node isn’t listening

### ✅ Symptom

Port shows mapped but attach fails.

### ✅ Fix

Check logs for the inspector line:

```bash id="g57o3r"
podman logs debug-container | head -n 20
```

You should see:

* `Debugger listening on ws://0.0.0.0:9229/...`

If not present, ensure container runs node with `--inspect`:

```bash
node --inspect=0.0.0.0:9229 server.js
```

---

## 4) Node inspector bound to localhost inside container

### ✅ Symptom

Inspector is listening but only on 127.0.0.1 inside container, attach from host fails.

### ✅ Fix

Bind inspector to all interfaces:

```bash id="2xtq4o"
node --inspect=0.0.0.0:9229 server.js
```

---

## 5) Volume mount works, but changes don’t reflect

### ✅ Symptom

You edit files on host but container behavior doesn’t change.

### 📌 Likely Cause

* The container is running old process without reload
* Or the app is not watching for changes

### ✅ Fix

Restart the container after code change:

```bash id="4u4czr"
podman restart debug-container
```

For automatic reload, use dev tools like nodemon (not required in this lab).

---

## 6) Container name already exists

### ✅ Symptom

`--name debug-container` fails because it exists.

### ✅ Fix

Stop and remove it:

```bash id="c4v5l5"
podman stop debug-container
podman rm debug-container
```

---

## 7) VS Code can’t connect to container environment

### ✅ Symptom

Remote - Containers workflow fails or cannot find container.

### ✅ Fix

Confirm container is running:

```bash id="m7q4pv"
podman ps
```

Confirm ports exposed:

```bash id="w8v1cb"
podman port debug-container
```

If you’re using VS Code "Remote - Containers", ensure the extension is installed and you opened the correct project folder.

---

## 8) Security warning: exposed debug ports

### ✅ Risk

Debug ports allow deep inspection and potential code execution.

### ✅ Best Practice

* Use only in trusted environments
* Avoid exposing debug ports to public networks
* Prefer localhost binding on the host or use SSH tunnels/port-forwarding when needed

---

## ✅ Quick Verification Checklist

* Container running:

  * `podman ps`
* Ports mapped:

  * `podman port debug-container`
* Inspector listening:

  * `podman logs debug-container | head`
* Source mount correct:

  * `podman exec -it debug-container ls /app`
* VS Code mapping correct:

  * `localRoot` ↔ `remoteRoot`
