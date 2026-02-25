# 💬 Interview Q&A — Lab 26: `CMD` vs `ENTRYPOINT`

---

## 1) What is the purpose of `CMD` in a Dockerfile/Containerfile?
`CMD` defines the **default command** (or default arguments) for a container when it starts. If the user provides a command at runtime, it typically **overrides** `CMD`.

---

## 2) What is the purpose of `ENTRYPOINT`?
`ENTRYPOINT` defines the container’s **main executable**. The container behaves like a fixed program, and runtime arguments are appended (unless ENTRYPOINT is explicitly overridden).

---

## 3) What’s the simplest difference between `CMD` and `ENTRYPOINT`?
- `CMD` = default behavior that is **easy to override**
- `ENTRYPOINT` = fixed executable behavior that is **harder to override** (requires `--entrypoint`)

---

## 4) How did `CMD` behave in the lab when you ran the container normally?
The image with:
```dockerfile
CMD ["echo", "Hello from CMD"]
````

printed:

* `Hello from CMD`

---

## 5) How did you override `CMD` at runtime?

By providing a new command after the image name:

```bash id="ce3fdb"
podman run cmd-demo echo "Overridden command"
```

This replaced the default `CMD` and printed:

* `Overridden command`

---

## 6) How did `ENTRYPOINT` behave in the lab when you ran it normally?

The image with:

```dockerfile
ENTRYPOINT ["echo", "Hello from ENTRYPOINT"]
```

printed:

* `Hello from ENTRYPOINT`

---

## 7) What happens when you pass additional arguments to an `ENTRYPOINT` image?

Those arguments get appended to the ENTRYPOINT command. In the lab:

```bash id="s8hymn"
podman run entrypoint-demo "with appended text"
```

produced:

* `Hello from ENTRYPOINT with appended text`

---

## 8) Why is `ENTRYPOINT` often described as making the container behave “like an executable”?

Because it defines the fixed command the container always runs. Users provide arguments, similar to running a normal program: `program arg1 arg2`.

---

## 9) What does combining `ENTRYPOINT` and `CMD` achieve?

It creates a flexible pattern:

* `ENTRYPOINT` defines the executable
* `CMD` defines default arguments

So you can keep a stable main command while allowing runtime customization.

---

## 10) In the combined setup, how did overriding work?

With:

```dockerfile
ENTRYPOINT ["echo"]
CMD ["Default message"]
```

Running `podman run combined-demo` printed:

* `Default message`

Running:

```bash id="xvyvtb"
podman run combined-demo "Custom message"
```

overrode the CMD default args and printed:

* `Custom message`

---

## 11) What is a script-based ENTRYPOINT and why is it common?

A script-based ENTRYPOINT is when the container runs a startup script first. It’s common for:

* environment setup
* argument parsing
* initialization steps
* running migrations
* then launching the main process

---

## 12) Why did your `entrypoint.sh` use `exec "$@"`?

Using `exec` replaces the shell process with the target command, which helps:

* proper signal handling (SIGTERM/SIGINT)
* correct PID 1 behavior
* cleaner process tree

This is a best-practice pattern for entrypoint scripts.

---

## 13) How do you override an ENTRYPOINT at runtime?

Using `--entrypoint`. Example from the lab:

```bash id="jj60x0"
podman run --entrypoint /bin/ls script-demo -l /
```

This bypassed the script ENTRYPOINT and directly executed `/bin/ls`.

---

## 14) When should you prefer `CMD` over `ENTRYPOINT`?

Use `CMD` when you want the container to have a default behavior but still be easily repurposed by the operator (like a general-purpose base image).

---

## 15) When should you prefer `ENTRYPOINT` over `CMD`?

Use `ENTRYPOINT` when your image is meant to behave like a dedicated application (like a CLI tool, service wrapper, or single-purpose container) and you want consistent startup behavior.

