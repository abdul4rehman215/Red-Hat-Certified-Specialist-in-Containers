# 🧠 Interview Q&A — Lab 17: Compose with Dependencies (depends_on + scaling + connectivity)

---

## 1) What does `depends_on` do in a Compose file?
`depends_on` ensures a service starts **after** its listed dependencies start. It enforces startup order but does **not** guarantee the dependency is fully ready to accept connections.

---

## 2) Does `depends_on` wait for the database/cache to be “ready”?
No. It only ensures container start order. Readiness typically requires:
- healthchecks
- retry logic in the application
- waiting scripts (not recommended for production unless carefully implemented)

---

## 3) In this lab, which service depended on Redis?
The `webapp` service used:
```yaml
depends_on:
  - redis
````

---

## 4) How did you verify both services were running in Task 1?

Using:

* `docker-compose ps`

It showed:

* `compose-dependencies-lab-redis-1`
* `compose-dependencies-lab-webapp-1`

---

## 5) Why did you test Nginx with `curl -I http://localhost:8080`?

It verifies service reachability and returns HTTP headers (quick health check). The response was `HTTP/1.1 200 OK`.

---

## 6) What is the challenge when scaling a service that publishes a fixed host port?

Multiple replicas cannot bind the **same host port** (e.g., `8080:80`). This causes port binding conflicts.

---

## 7) How did you avoid port conflicts when scaling `webapp` replicas?

For the scaling variant, the webapp service **removed host port publishing**, allowing replicas to run behind the internal Compose network without host port conflicts.

---

## 8) How did you scale the `webapp` service to 3 replicas?

Using:

```bash
docker-compose up -d --scale webapp=3
```

---

## 9) How did you confirm the replicas were distinct instances?

By checking hostnames:

* `docker-compose exec webapp-1 hostname`
* `docker-compose exec webapp-2 hostname`
* `docker-compose exec webapp-3 hostname`

Each returned a different hostname.

---

## 10) How does service discovery work between containers in Compose?

Compose creates a network and provides DNS-based discovery where:

* the service name (e.g., `redis`) resolves to the container IP.

So the app can use `redis` as the hostname.

---

## 11) What did the Flask + Redis app do in Task 3?

It incremented a Redis counter key `hits` and returned:

* `Hello World! This page has been viewed X times.`

Each HTTP request increased the count.

---

## 12) How did you set the Redis hostname for Flask?

Using an environment variable:

```yaml
environment:
  - REDIS_HOST=redis
```

The app defaulted to `redis` if not set.

---

## 13) How did you verify Redis connectivity besides the web counter?

Two ways:

1. `redis-cli ping` inside redis container → `PONG`
2. Python ping from webapp container → `True`

---

## 14) Why is a functional test (counter increment) a strong validation method?

Because it proves the full chain works:

* HTTP request → Flask → Redis connection → write/read → response

It validates real behavior, not just container “Up” status.

---

## 15) What cleanup step is important after compose labs?

Run:

* `docker-compose down`
  to remove containers and network.
  Optionally remove locally built images if you want a clean environment.
