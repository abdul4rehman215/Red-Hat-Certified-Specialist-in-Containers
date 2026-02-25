# 💬 Interview Q&A — Lab 23: `ADD` vs `COPY` in Dockerfiles

---

## 1) What is the purpose of `COPY` in a Dockerfile/Containerfile?
`COPY` transfers files and directories from the **local build context** into the image filesystem. It is simple, predictable, and does only one job: copy.

---

## 2) What is the purpose of `ADD` in a Dockerfile/Containerfile?
`ADD` can do everything `COPY` does, **plus** extra features such as:
- automatic extraction of local tar archives into the image
- fetching files from remote URLs (HTTP/HTTPS)

---

## 3) For a simple local file copy, how do `ADD` and `COPY` behave?
For local files (like `testfile.txt`), they behave the same:
- they copy the file into the image at the target path
That’s why best practice is usually to use `COPY` unless you need `ADD` features.

---

## 4) Why is `COPY` generally preferred over `ADD`?
Because it is:
- predictable (no hidden behavior)
- easier to review
- safer (no automatic archive extraction or remote URL dependencies)
This makes builds more reproducible and less risky.

---

## 5) What does “build context” mean, and why does it matter for `COPY`?
Build context is the set of files available to the build command (the current directory and its contents sent to the engine). `COPY` can only copy from this context, so you know exactly what files are being included.

---

## 6) What is `ADD` automatic archive extraction?
If you `ADD` a local archive like `.tar`, `.tar.gz`, `.tgz`, etc., `ADD` **extracts it automatically** into the destination directory (instead of placing the archive file as-is).

Example behavior from the lab:
- `ADD archive.tar.gz /extracted/` resulted in `/extracted/testfile.txt` appearing inside the image.

---

## 7) Why can `ADD` archive extraction be a security risk?
If an archive is untrusted, extraction could introduce:
- unexpected files
- overwritten paths
- hidden payloads in the image filesystem

Even though this lab used a safe example, it demonstrates why `COPY` is safer for normal copying.

---

## 8) Can `ADD` download a remote URL during the build?
Yes. `ADD` can fetch a remote file via HTTP/HTTPS and place it into the image. In the lab, a README file was downloaded directly from GitHub.

---

## 9) Why is `ADD` remote URL fetching considered risky?
Because it introduces:
- external dependency during build
- risk of content changing over time
- reduced reproducibility
- potential supply-chain risk if the remote source is compromised

A safer pattern is often: `RUN curl/wget` + checksum verification (when strict integrity is required).

---

## 10) How does `COPY` affect Docker/Podman build cache?
`COPY` will invalidate the cache from that step onward when the source file changes. In the lab, changing `version.txt` from `Version 1` to `Version 2` caused the `COPY` step to rebuild and the output to update.

---

## 11) Does `ADD` behave the same way as `COPY` for cache invalidation?
For local files, yes — changing the source file invalidates the cache from the `ADD` step onward. However, remote URL behavior adds complexity depending on caching rules and whether the URL or content changes.

---

## 12) What is the best practice rule of thumb for `ADD` vs `COPY`?
- Use `COPY` by default
- Use `ADD` only when you specifically need:
  - automatic archive extraction
  - remote URL fetching (though many teams avoid this for security reasons)

---

## 13) What did the security demonstration with `bad.tar.gz` show?
It showed that when a tar archive is added:
- `ADD bad.tar.gz /malicious/` automatically extracted it
- the file appeared as `/malicious/badfile`

This illustrates why untrusted archives should not be processed implicitly.

---

## 14) If you need to download a file during build, what is a more controlled approach than `ADD URL`?
A common approach is:
- `RUN curl -L <url> -o <file>` (or `wget`)
- optionally verify checksum/signature
This gives more explicit control over how downloads occur and how integrity is validated.

---

## 15) What’s the main takeaway from this lab?
`COPY` is the safest, most predictable choice for most builds. `ADD` provides powerful features, but those features can introduce unexpected behavior and security risks—so it should be used deliberately and sparingly.
