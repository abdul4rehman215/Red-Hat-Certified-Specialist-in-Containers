# 🧠 Interview Q&A — Lab 09: Using ENTRYPOINT and CMD in Containerfiles

---

## 1) What does `ENTRYPOINT` do?
`ENTRYPOINT` defines the main executable that always runs when a container starts. It sets the “fixed” part of the container startup command.

---

## 2) What does `CMD` do?
`CMD` provides default arguments (or a default command) for the container. It is designed to be easily overridden at runtime.

---

## 3) How do ENTRYPOINT and CMD work together (exec form)?
When both are in exec form (JSON array), the final command is effectively:
- `ENTRYPOINT + CMD`
Example:
- `ENTRYPOINT ["echo", "Entrypoint says:"]`
- `CMD ["Default CMD message"]`
Becomes:
- `echo "Entrypoint says:" "Default CMD message"`

---

## 4) How did you override CMD in this lab?
By passing a value after the image name:
- `podman run --rm entrypoint-demo "Custom message"`
This replaced the default CMD value.

---

## 5) What is the difference between overriding CMD and overriding ENTRYPOINT?
- Overriding CMD: pass arguments after image name (replaces CMD)
- Overriding ENTRYPOINT: use `--entrypoint` (replaces the executable)

---

## 6) Why is exec form recommended for ENTRYPOINT?
Exec form:
- doesn’t invoke a shell
- handles signals better (important for graceful shutdown)
- avoids unexpected shell parsing issues
This is preferred in OpenShift/Kubernetes environments.

---

## 7) What is shell form ENTRYPOINT?
Shell form looks like:
- `ENTRYPOINT echo "..."`

It is executed through `/bin/sh -c`, which can introduce parsing differences and signal-handling problems.

---

## 8) Why did the shell form demo print two separate lines?
Because the shell-form ENTRYPOINT prints:
- `Shell form ENTRYPOINT:`
and then CMD runs and prints:
- `Shell form CMD`

---

## 9) Why use a script as ENTRYPOINT?
A script-based entrypoint is helpful when you need:
- startup validation
- configuration logic
- environment variable processing
- multi-step startup routines

---

## 10) How did the greet script-based ENTRYPOINT work?
The container used:
- `ENTRYPOINT ["/usr/local/bin/greet.sh"]`
- `CMD ["OpenShift Lab", "Red Hat"]`

So greet.sh received those as arguments and printed:
- `Welcome to OpenShift Lab from Red Hat`

---

## 11) How did you override the greet script arguments?
By passing new arguments after the image name:
- `podman run --rm greet-demo "Container Workshop" "Instructor"`

This replaced CMD arguments and greet.sh printed the overridden values.

---

## 12) How did you override ENTRYPOINT completely?
Using:
- `podman run --rm --entrypoint echo greet-demo "This completely replaces the ENTRYPOINT"`
This replaced greet.sh with `echo`.

---

## 13) In production, why is correct signal handling important?
Containers should handle SIGTERM properly so they can shut down gracefully. In orchestrators, shutdown behavior affects rolling updates and stability.

---

## 14) What is a common best practice for CMD usage?
Use CMD to define defaults that users/operators might override:
- default args
- default mode flags
- default runtime behavior

---

## 15) How does this relate to OpenShift deployments?
In OpenShift/Kubernetes, you can override container commands and args in the Deployment/Pod spec. Understanding ENTRYPOINT vs CMD is essential for:
- startup debugging
- reliable customization
- predictable container behavior
