# 💬 Interview Q&A — Lab 29: `ENV` and Environment Variables with Podman

---

## 1) What does the `ENV` instruction do in a Containerfile/Dockerfile?
`ENV` sets environment variables inside the image. These variables become part of the image metadata and are available at container runtime unless overridden.

---

## 2) How do environment variables help in containerized applications?
They allow you to configure an app without rebuilding the image. This supports running the same image across:
- development
- staging
- production  
by changing only runtime configuration.

---

## 3) How did you define multiple variables in one `ENV` instruction?
Using line continuation (`\`) to keep it readable:
```dockerfile
ENV APP_NAME="MyApp" \
    APP_VERSION="1.0.0"
````

---

## 4) How do you override an environment variable at runtime with Podman?

Using `-e`:

```bash id="vmx4yr"
podman run -e APP_NAME="NewApp" env-demo
```

---

## 5) Can you override multiple variables at runtime?

Yes, by repeating `-e`:

```bash id="u5rdzc"
podman run -e APP_NAME="ProductionApp" -e APP_VERSION="2.0.0" env-demo
```

---

## 6) What is a multi-line environment variable and why would you use it?

A multi-line env var is written across multiple lines in the Containerfile for readability, but it becomes a single string at runtime. It’s useful for long descriptions, banners, or configuration text.

---

## 7) How did you implement a multi-line `ENV` in the lab?

By using backslashes and splitting the value:

```dockerfile
ENV APP_DESCRIPTION="This is a multi-line \
environment variable example"
```

---

## 8) Why did `$APP_NAME` and `$APP_VERSION` expand correctly in `CMD`?

Because the lab used **shell-form CMD**:

```dockerfile id="e7a2b8"
CMD echo "Running $APP_NAME version $APP_VERSION"
```

Shell-form uses a shell where variable expansion happens.

---

## 9) How is exec-form CMD different for environment variable expansion?

Exec-form CMD (JSON array) doesn’t run through a shell automatically, so variable expansion like `$APP_NAME` won’t happen unless you explicitly call a shell (e.g., `["/bin/sh","-c","echo $APP_NAME"]`).

---

## 10) How did you verify environment variables inside the container image?

By running a container and inspecting its config:

```bash id="icw8mv"
podman inspect envcheck --format '{{ range .Config.Env }}{{ println . }}{{ end }}'
```

Then filtering expected variables.

---

## 11) Why is documenting environment variables important?

It improves usability and reduces mistakes. Operators can quickly understand:

* which variables exist
* what they mean
* their defaults
  This is critical when deploying to OpenShift/Kubernetes.

---

## 12) What is the difference between setting ENV in the image vs passing `-e` at runtime?

* `ENV` in image: default values baked into the image
* `-e` at runtime: per-container override without rebuild
  Runtime values take precedence for that container instance.

---

## 13) What’s a common mistake when writing multi-line `ENV` values?

Incorrect backslash placement can break the value or create unintended whitespace/newlines. Keeping indentation consistent and verifying with `cat Containerfile` helps.

---

## 14) How can you quickly confirm the Containerfile’s ENV section matches documentation?

Use:

```bash id="v9mpa2"
grep -n "ENV" -A3 Containerfile
```

Then compare variable names and defaults against your docs.

---

## 15) What’s the key takeaway from this lab?

`ENV` provides image defaults, `-e` provides runtime overrides, and good documentation plus inspection (`podman inspect`) ensures variables are correct and reliable in real deployments.
