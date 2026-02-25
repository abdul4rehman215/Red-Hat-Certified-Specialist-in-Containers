# 🧠 Interview Q&A — Lab 20: Service and Ingress Setup (ClusterIP, NodePort, Ingress)

---

## 1) What is a Kubernetes Service and why is it used?
A Service provides a stable network endpoint to access a set of Pods. Since Pods can restart and change IPs, Services offer consistent access via a virtual IP/DNS name.

---

## 2) What is a ClusterIP service?
ClusterIP is the default Service type. It exposes the application **internally** within the cluster only (no external access by default).

---

## 3) When would you use ClusterIP?
- Internal microservice communication
- Backends accessed only from inside the cluster
- Databases, internal APIs, and internal web services

---

## 4) What is a NodePort service?
NodePort exposes the service on a static port across every node. The service becomes reachable at:
- `http://<node-ip>:<nodeport>`

NodePort range is typically `30000-32767`.

---

## 5) How did you discover the Minikube node IP?
Using:
```bash
kubectl get nodes -o wide
````

It showed `INTERNAL-IP` as `192.168.49.2`.

---

## 6) How did you verify NodePort access worked?

By sending a request to:

* `http://192.168.49.2:30007`
  and receiving `HTTP/1.1 200 OK` from Nginx.

---

## 7) What is an Ingress?

Ingress is a Kubernetes resource for Layer 7 HTTP/HTTPS routing. It maps hostnames/paths to services, enabling URL-based routing like:

* `nginx.example.com/` → service backend

---

## 8) Do Ingress resources work without an Ingress controller?

No. An Ingress controller (like ingress-nginx) is required to implement the routing rules defined by Ingress resources.

---

## 9) What controller did you use in this lab?

Ingress-NGINX, deployed in the `ingress-nginx` namespace.

---

## 10) Why did you not use OpenShift Routes in this lab?

Because `oc` was not installed/configured on this environment (`oc: command not found`), so the Kubernetes Ingress method was used.

---

## 11) What is the purpose of adding an entry to `/etc/hosts`?

It maps a hostname (`nginx.example.com`) to an IP (`192.168.49.2`) locally so curl/browser requests resolve to the cluster’s ingress address without needing real DNS.

---

## 12) What does `kubectl get ingress` show?

It shows:

* hostname rules (HOSTS)
* ingress class (CLASS)
* assigned address (ADDRESS)
* exposed ports

---

## 13) Why is Ingress preferred over NodePort in many real environments?

Ingress provides:

* hostname-based routing
* path routing
* centralized TLS termination
* a cleaner external access pattern compared to exposing many node ports

---

## 14) What did `kubectl describe svc nginx-nodeport` confirm?

It confirmed:

* Service type NodePort
* assigned NodePort `30007/TCP`
* Endpoints (pod IP:port) backing the service

---

## 15) What are common security considerations for exposing services?

* Restrict NodePort exposure (firewalls / security groups)
* Prefer Ingress with TLS termination
* Avoid exposing admin services publicly
* Use RBAC and network policies where applicable
