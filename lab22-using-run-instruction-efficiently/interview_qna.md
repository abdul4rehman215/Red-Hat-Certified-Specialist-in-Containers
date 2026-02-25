# 💬 Interview Q&A — Lab 22: Using `RUN` Instruction Efficiently

---

## 1) What does the `RUN` instruction do in a Containerfile/Dockerfile?
`RUN` executes commands **during image build time** and commits the result into a new image layer. It’s commonly used to install packages, create files, or configure the base image before runtime.

---

## 2) What is the difference between build-time and run-time execution?
- **Build-time (`RUN`)**: executes while building the image and becomes part of the final image layers.
- **Run-time (`CMD` / `ENTRYPOINT`)**: executes when a container starts from the built image.

---

## 3) What is the `RUN` shell form?
Shell form runs commands through a shell interpreter (usually `/bin/sh -c`), like:
```dockerfile
RUN apk add --no-cache curl
````

This form is convenient and supports shell features like pipes and `&&`.

---

## 4) What is the `RUN` exec form?

Exec form uses JSON array syntax:

```dockerfile
RUN ["executable", "param1", "param2"]
```

It avoids shell parsing and can reduce problems with quoting/escaping.

---

## 5) Why would you choose exec form over shell form?

Exec form is useful when you want predictable execution without shell expansion, globbing, or special shell syntax causing unexpected behavior. It’s also helpful when commands contain complex quoting.

---

## 6) Does exec form completely avoid shell usage?

Not always. If you call a shell explicitly (like `/bin/sh -c`), you still use the shell, but you control it explicitly:

```dockerfile
RUN ["/bin/sh", "-c", "apk add --no-cache curl"]
```

---

## 7) Why does using multiple `RUN` instructions increase image size?

Each `RUN` creates a new layer. If you install packages and then remove cache files in a later `RUN`, the cache may still exist in earlier layers and still contribute to the final image size.

---

## 8) What is the benefit of combining commands in one `RUN`?

Combining update + install + cleanup in one `RUN` ensures temporary files (like apt lists) don’t get stored permanently in an earlier layer. This reduces:

* layer count
* image size
* build/pull time

---

## 9) What is a common best practice for apt-based images in a `RUN` instruction?

Use:

```dockerfile
RUN apt-get update && apt-get install -y <pkg> && rm -rf /var/lib/apt/lists/*
```

This:

* updates package lists
* installs packages
* cleans apt cache in the same layer

---

## 10) How did you verify layer reduction in this lab?

I used:

```bash
podman history optimized-nginx
```

The output showed only one `RUN` layer containing the combined commands.

---

## 11) Why is cache cleanup important in container images?

Package managers download metadata and temporary lists. If not removed, they:

* increase image size
* add unnecessary files
* potentially increase attack surface

Cleaning them keeps images lean and more production-friendly.

---

## 12) What does `podman history` show?

It shows the build history of an image:

* layers
* commands that created each layer
* size contributed by each layer

It’s useful for optimizing Dockerfiles/Containerfiles.

---

## 13) In your lab results, why was `optimized-nginx` much larger than Alpine images?

Ubuntu base images are larger than Alpine, and installing Nginx adds more packages. Alpine is designed to be minimal, while Ubuntu provides a fuller OS userspace.

---

## 14) When might it be okay to use multiple `RUN` instructions?

Sometimes multiple `RUN`s are acceptable if:

* you need clearer separation for readability
* caching strategy benefits from split steps
* each layer represents a meaningful “checkpoint”

But for package install + cleanup, combining is usually better.

---

## 15) What’s the biggest takeaway about `RUN` optimization?

Reducing layers and cleaning temporary files in the same `RUN` produces:

* smaller images
* faster builds
* better reproducibility
* more efficient CI/CD pipelines
