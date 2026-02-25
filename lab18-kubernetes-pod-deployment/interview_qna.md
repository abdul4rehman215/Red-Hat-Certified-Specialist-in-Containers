# 🧠 Interview Q&A — Lab 18: Kubernetes Pod Deployment (kubectl + Pod YAML)

---

## 1) What is a Pod in Kubernetes?
A Pod is the smallest deployable unit in Kubernetes. It represents one or more containers that share the same network namespace (IP/ports) and can share storage volumes.

---

## 2) What are the minimum required fields in a Pod manifest?
At minimum:
- `apiVersion`
- `kind`
- `metadata`
- `spec`

---

## 3) What does `apiVersion: v1` mean for Pods?
It means the Pod resource is part of the core Kubernetes API group and uses version `v1`.

---

## 4) Why did you add labels to the Pod?
Labels (like `app: nginx`) help identify and select resources. They are used by Services, Deployments, and selectors for grouping and routing.

---

## 5) What does `containerPort: 80` do?
It documents the port the container listens on and can be used by tools and higher-level objects. It does not publish the port externally by itself.

---

## 6) How did you deploy the Pod?
Using:
```bash
kubectl apply -f simple-pod.yaml
````

---

## 7) What command verifies whether a Pod is running?

```bash
kubectl get pods
```

It shows READY, STATUS, RESTARTS, and AGE.

---

## 8) What is the purpose of `kubectl describe pod`?

It provides detailed information:

* scheduling info and node assignment
* container image + state
* mounted volumes
* readiness/conditions
* events (pull, start, failures)

It’s one of the best troubleshooting commands.

---

## 9) What do Pod “Events” in `describe` help you troubleshoot?

Events show what happened over time, such as:

* scheduling failures
* image pull errors
* container crashes
* restarts
  This helps identify why a Pod is Pending or CrashLooping.

---

## 10) How do you view application logs from a Pod?

Use:

```bash
kubectl logs nginx-pod
```

For multi-container pods, specify container name:

```bash
kubectl logs nginx-pod -c nginx-container
```

---

## 11) Why did the Nginx logs show mostly startup messages?

Because the pod was freshly started and had minimal traffic. Without requests, you mostly see entrypoint and startup logs.

---

## 12) How can you access a Pod without creating a Service?

Use port forwarding:

```bash
kubectl port-forward nginx-pod 8080:80
```

Then access:

* `http://localhost:8080`

---

## 13) When would a Pod show `Pending` status?

Common reasons:

* insufficient CPU/memory resources
* no nodes available
* unsatisfied scheduling constraints (node selectors/taints)
* image pull issues can also delay readiness

---

## 14) What is `CrashLoopBackOff` and how do you debug it?

It means the container repeatedly crashes and Kubernetes backs off restarting it.
Debug with:

* `kubectl logs <pod>`
* `kubectl describe pod <pod>`
  Check exit codes and events.

---

## 15) Why are Pods usually managed via Deployments instead of directly?

Pods are not self-healing by themselves. Deployments provide:

* replica management
* rolling updates
* automatic rescheduling
  Pods are typically created by higher-level controllers for reliability.
