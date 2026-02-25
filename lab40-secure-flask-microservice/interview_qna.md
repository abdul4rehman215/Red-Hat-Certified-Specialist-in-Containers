# 💬 Interview Q&A — Lab 40: Case Study — Secure Flask Microservice

---

## 1) What does this microservice do?
It provides a minimal Flask API with:
- `/` returning a JSON health/status response
- `/data` connecting to PostgreSQL and returning the output of `SELECT version();`

---

## 2) How did you containerize the Flask application?
Using a `Containerfile` with:
- Base image: `python:3.9-slim`
- Copy + install dependencies from `requirements.txt`
- Copy application code
- Expose port `5000`
- Run Flask with `flask run --host=0.0.0.0`

---

## 3) Why use `python:3.9-slim` instead of a full image?
Slim images reduce:
- image size
- attack surface
- number of unnecessary packages  
This helps security and improves build/pull performance.

---

## 4) How does the Flask app get its database configuration?
From environment variables:
- `DB_HOST`
- `DB_NAME`
- `DB_USER`
- `DB_PASS`

If env vars are not provided, defaults apply (e.g., localhost, postgres user, password fallback).

---

## 5) How did you deploy Flask + PostgreSQL together?
Using `podman-compose` with a multi-container compose file:
- `web` service (Flask container)
- `db` service (PostgreSQL 13)
Both attached to a shared bridge network and using a persistent named volume for DB storage.

---

## 6) How did you ensure database persistence?
A named volume was used:
```yaml id="v0q8y2"
volumes:
  - pgdata:/var/lib/postgresql/data
````

This keeps PostgreSQL data even if the DB container is recreated.

---

## 7) How were secrets handled in this lab?

A password file was created and loaded as a Podman secret:

```bash id="n8m2x7"
echo "mysecretpassword" > db_password.txt
podman secret create db_password db_password.txt
```

The secret is mounted into containers at `/run/secrets/db_password`.

---

## 8) Why did you still pass `DB_PASS` as an environment variable?

The Flask code reads `DB_PASS` directly. The compose file also mounted the secret and provided `DB_PASS_FILE`, but the app didn’t read from `DB_PASS_FILE`.
For lab functionality, `DB_PASS` was provided while still demonstrating secrets mounting.

---

## 9) How did you validate the application works?

Using:

```bash id="d6y1p8"
curl http://localhost:5000
curl http://localhost:5000/data
```

The second endpoint confirmed DB connectivity by returning the PostgreSQL version string.

---

## 10) How did you verify logs and runtime behavior?

By streaming container logs:

```bash id="x1m4k2"
podman logs -f flask-microservice-lab_web_1
```

This showed Flask startup and HTTP requests to `/` and `/data`.

---

## 11) What security scanning did you perform?

I used Podman’s vulnerability scanning:

```bash id="a2p7w9"
podman scan flask-app
podman scan postgres:13
```

This produced CVE lists, severity, installed version, and fixed version info.

---

## 12) What’s the purpose of image trust / signing in container workflows?

Image signing and trust policies help ensure:

* images come from trusted sources
* supply-chain integrity is enforced
* untrusted images can be rejected by policy

It’s a defense against tampered or unknown images.

---

## 13) How did you test application recovery?

By restarting the database container:

```bash id="k8c2m0"
podman-compose stop db
podman-compose start db
curl http://localhost:5000/data
```

The service still returned DB version, confirming recovery behavior.

---

## 14) What is one improvement you would make for production readiness?

Use a production WSGI server (e.g., `gunicorn`) instead of the Flask dev server and add healthchecks to compose for both services.

---

## 15) What is the key takeaway from this lab?

It demonstrates an end-to-end pattern:

* build and containerize an API
* run a DB with persistent storage
* deploy as a multi-container stack
* apply basic supply-chain and vulnerability security checks
* validate logs and recovery behavior
