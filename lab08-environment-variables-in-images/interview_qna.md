# 🧠 Interview Q&A — Lab 08: Environment Variables in Images (ENV + ARG)

---

## 1) What is the difference between `ENV` and `ARG` in a Containerfile?
- `ENV` sets **runtime** environment variables stored in the image and available when the container runs.
- `ARG` defines **build-time** variables available only during image build, unless copied into `ENV`.

---

## 2) When should you use `ENV`?
Use `ENV` for configuration defaults that the application should have at runtime (e.g., mode, version, feature flags).

---

## 3) When should you use `ARG`?
Use `ARG` for values needed only during build (e.g., build number, commit ID, download URLs), especially when you want to influence build steps.

---

## 4) How did you define environment variables in the image in this lab?
By using:
```dockerfile
ENV APP_NAME="MyApp" \
    APP_VERSION="1.0" \
    APP_ENV="development"
````

---

## 5) How did you override environment variables at runtime?

By running the container with `-e` flags:

* `podman run -e APP_ENV="production" -e APP_VERSION="2.0" env-demo`

---

## 6) Why is `--env-file` useful?

It allows you to manage many environment variables cleanly in a file instead of long command lines. It also supports reusable configuration for staging/production.

---

## 7) What is the format of an env file (`app.env`)?

Each line is `KEY=VALUE` with no spaces around `=`:

```text
APP_NAME=ProductionApp
APP_VERSION=3.0
APP_ENV=staging
```

---

## 8) Why did `podman exec env-container env` initially fail?

Because the container’s command was only `echo ...`, so it exited immediately. `podman exec` only works for **running** containers.

---

## 9) How did you fix the exec issue?

I ran the same image with a long-lived command:

* `podman run -d --name env-container env-demo sh -c 'sleep 300'`
  Then I was able to exec into it and run `env`.

---

## 10) How do you inspect environment variables inside a running container?

Use:

* `podman exec <container_name> env`

This prints all environment variables available to processes inside the container.

---

## 11) How did you use `ARG` to pass a build-time value?

By defining `ARG APP_BUILD_NUMBER` and building with:

* `podman build --build-arg APP_BUILD_NUMBER=42 -t arg-demo .`

---

## 12) Why did you set `ENV APP_BUILD=$APP_BUILD_NUMBER`?

Because ARG values are not automatically preserved at runtime. Copying the ARG into ENV makes the value available when the container runs.

---

## 13) What output confirmed the ARG/ENV behavior worked?

Running the container printed:

* `Build number: 42`

---

## 14) How does this relate to OpenShift/Kubernetes deployments?

OpenShift commonly injects configuration through environment variables using:

* Deployment env vars
* ConfigMaps
* Secrets
  So knowing how ENV and runtime overrides work is critical.

---

## 15) What is a best practice for sensitive variables (passwords/tokens)?

Do not bake secrets into images using `ENV`. Use:

* Secrets management (Kubernetes Secrets / OpenShift Secrets)
* runtime injection
* external secret stores
