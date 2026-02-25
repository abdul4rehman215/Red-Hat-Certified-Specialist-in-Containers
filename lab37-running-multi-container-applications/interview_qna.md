# 💬 Interview Q&A — Lab 37: Running Multi-Container Applications

---

## 1) What problem does `podman-compose` solve?
`podman-compose` allows you to define and run multi-container applications using a Compose YAML file, including networks, volumes, and service dependencies, without manually running multiple `podman run` commands.

---

## 2) What services were included in this lab’s stack?
- **web**: `python:3.9` running `python -m http.server 8000`
- **redis**: `redis:alpine` as a cache service
- **db**: `postgres:13-alpine` as a database service

---

## 3) What is the role of `depends_on` in the compose file?
`depends_on` ensures Podman Compose starts containers in an order (web depends on redis and db).  
It does **not** guarantee the dependent service is “ready” — only that it is started.

---

## 4) How did you validate the web container was working?
By checking HTTP response headers and content:
```bash id="q2m7e4"
curl -I http://localhost:8000
curl http://localhost:8000 | head
````

This confirmed the Python HTTP server responded with `200 OK`.

---

## 5) What is the purpose of the named volumes in this lab?

Named volumes persist data beyond container lifecycles:

* `redis-data:/data`
* `postgres-data:/var/lib/postgresql/data`

They help keep application state even if containers are recreated.

---

## 6) Why did you create an `app/` folder in the project?

Because the compose file bind-mounted `./app:/app`. Creating the directory ensured the mount path exists and the deployment is consistent.

---

## 7) How did you create a Podman secret from stdin?

Using:

```bash id="d8j2z5"
echo "supersecret" | podman secret create db_password -
```

---

## 8) Why is `POSTGRES_PASSWORD_FILE` used instead of `POSTGRES_PASSWORD`?

`POSTGRES_PASSWORD_FILE` lets PostgreSQL read the password from a mounted secret file instead of exposing it directly as an environment variable. This reduces accidental leakage in logs, inspect output, or process environments.

---

## 9) What does `external: true` mean for secrets in compose?

It means the secret must already exist in Podman’s secret store. Compose will reference it, but it will not create it automatically.

---

## 10) What does `podman kube generate` do?

It generates Kubernetes YAML from existing running containers/pods. This helps convert local container work into Kubernetes-like manifests for portability and orchestration workflows.

---

## 11) Why did you use container names (like `multi-container-lab_web_1`) with `podman kube generate`?

Because `podman kube generate` expects container names/IDs, not compose service keys. The containers created by podman-compose have names like:

* `multi-container-lab_web_1`
* `multi-container-lab_redis_1`
* `multi-container-lab_db_1`

---

## 12) Why did you stop the compose stack before running `podman play kube`?

To avoid **port conflicts** (`8000` and `6379`) since the Kubernetes YAML includes host port bindings. If compose is still running, those host ports are already in use.

---

## 13) What does `podman play kube` do?

It runs Kubernetes YAML locally by creating:

* a Pod
* the containers in that pod
* (optionally) services defined/generated

It’s a lightweight way to test Kubernetes-like configs without a full cluster.

---

## 14) How did you verify the pod deployment created by `podman play kube`?

Using:

```bash id="y7q5p3"
podman pod ps
podman ps
```

This confirmed the pod was `Running` and the containers were up with expected port mappings.

---

## 15) What’s the key takeaway from this lab?

You can manage a multi-service stack locally using `podman-compose`, securely inject database credentials using secrets, and then transition toward Kubernetes workflows using `podman kube generate` and `podman play kube` — while handling practical issues like port conflicts and resource cleanup.

