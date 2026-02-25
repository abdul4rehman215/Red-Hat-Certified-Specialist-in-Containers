# 💬 Interview Q&A — Lab 28: `EXPOSE` and Port Binding

---

## 1) What does the `EXPOSE` instruction do in a Containerfile/Dockerfile?
`EXPOSE` documents which port(s) the container is expected to listen on. It is metadata for humans/tools, but it does **not** publish the port to the host by itself.

---

## 2) What is the difference between “exposing” and “publishing” a port?
- **Exposing** (EXPOSE): documents the port inside the image.
- **Publishing** (`-p` or `-P` at runtime): actually maps a container port to the host so it can be accessed externally.

---

## 3) How do you publish a port with Podman?
Using `-p hostPort:containerPort`, for example:
```bash id="5d3u0s"
podman run -d -p 8080:8080 --name webapp exposed-app
````

---

## 4) Why did the Flask app bind to `0.0.0.0` instead of `127.0.0.1`?

Inside a container, binding to `0.0.0.0` allows the app to accept connections from outside the container. If it binds only to `127.0.0.1`, it may only accept connections from within the container itself.

---

## 5) What does `podman ps` show related to port mapping?

It shows the published ports in a format like:

* `0.0.0.0:8080->8080/tcp`
  This confirms host port 8080 is mapped to container port 8080.

---

## 6) What’s the purpose of using a different host port like `-p 9090:8080`?

It avoids port conflicts and allows multiple containers to run the same internal port while exposing them on different host ports.

---

## 7) How did you test if the app was reachable from the host?

Using:

```bash id="g2o0w3"
curl http://localhost:8080
```

and later:

```bash id="m3d6e2"
curl http://localhost:9090
```

Both returned the expected response string.

---

## 8) What does the `-P` flag do in Podman?

`-P` publishes all exposed ports to random available host ports. Podman chooses an available host port automatically.

---

## 9) How do you check what host port was assigned when using `-P`?

Using:

```bash id="z5xmmw"
podman port webapp4
```

This prints the mapping like:

* `8080/tcp -> 0.0.0.0:40123`

---

## 10) What is a common reason port publishing fails?

The host port may already be in use, resulting in an error like:

* `bind: address already in use`

---

## 11) How did you simulate a real port conflict in the lab?

I started a temporary server on port 8080:

```bash id="4guk7p"
python3 -m http.server 8080 >/tmp/httpserver.log 2>&1 &
```

Then I tried to map another container to host port 8080, which triggered the conflict.

---

## 12) How did you identify which process was using the conflicting port?

Using:

```bash id="1wpjpi"
sudo lsof -i :8080
```

It showed the `python3` process listening on that port.

---

## 13) How did you resolve the port conflict?

I stopped the conflicting process by killing its PID:

```bash id="t8a0w9"
kill 2210
```

Then I ran the container again using `-P` to avoid manual port selection.

---

## 14) What is `ss -tulnp` used for?

It lists listening sockets and the processes using them. It helps confirm whether a host port is listening and which process is bound to it.

---

## 15) What’s the main takeaway from this lab?

`EXPOSE` documents the container’s listening port, but **publishing** requires runtime port mapping (`-p` or `-P`). Understanding mapping and troubleshooting conflicts is essential for running networked containers reliably.
