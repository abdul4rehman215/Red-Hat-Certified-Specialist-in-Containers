# 🧠 Interview Q&A — Lab 06: Building Custom Container Images (Podman)

---

## 1) What is a Containerfile?
A Containerfile is a build recipe file used by Podman/Buildah to create container images. It is compatible with Dockerfile syntax and supports the same core instructions.

---

## 2) What does the `FROM` instruction do?
`FROM` sets the base image used to build the new image. In this lab, the base image is `docker.io/nginx:alpine`.

---

## 3) Why use `nginx:alpine` instead of regular `nginx`?
Alpine-based images are typically smaller and faster to pull, which helps reduce storage and improves build/deployment speed.

---

## 4) What does the `ENV` instruction do?
`ENV` sets environment variables inside the image. These variables are available during build steps and at runtime (depending on usage).

---

## 5) How was `ENV AUTHOR="OpenShift Developer"` used in this lab?
It was referenced in a build step:
- `RUN echo "Container built by $AUTHOR" > /build-info.txt`
This demonstrates using an environment variable during build.

---

## 6) What does the `COPY` instruction do?
`COPY` copies files from the build context (host directory) into the image filesystem. Here, `index.html` was copied into the Nginx web root.

---

## 7) What is the build context (`.`) in `podman build -t my-custom-nginx .`?
The build context is the directory sent to the build engine. It includes the Containerfile and any files referenced by `COPY` (like `index.html`).

---

## 8) What does the `RUN` instruction do?
`RUN` executes commands during image build time and commits the results into a new image layer.

---

## 9) What does `podman build -t my-custom-nginx .` do?
It builds an image using the Containerfile in the current directory and tags it as `my-custom-nginx`. Podman then stores it locally as `localhost/my-custom-nginx:latest`.

---

## 10) How do you verify the image was created successfully?
Use:
- `podman images`
This lists locally available images including repository, tag, image ID, and size.

---

## 11) Why do we map ports using `-p 8080:80` when running the container?
Nginx listens on port **80** inside the container. Mapping `8080:80` allows access from the host using port **8080**.

---

## 12) What is the purpose of `curl http://localhost:8080` in this lab?
It validates that:
- the container is running
- Nginx is serving content correctly
- the custom `index.html` was copied successfully into the image

---

## 13) What is an image layer, conceptually?
Each instruction (like `RUN`, `COPY`) creates a layer. Layers enable caching and efficient image updates: only changed layers need rebuilding or re-pulling.

---

## 14) How does this lab relate to OpenShift development?
OpenShift applications commonly run as container images. Knowing how to:
- write Containerfiles
- build images
- test locally
is foundational for OpenShift builds and deployments.

---

## 15) What is a common mistake when using `COPY`?
Referencing a file that is not in the build context. If `index.html` is missing or in another directory, the build will fail.
