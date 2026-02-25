# 🧠 Interview Q&A — Lab 10: Persisting Data with Volumes (Podman)

---

## 1) What problem do volumes solve in containers?
Containers are ephemeral by default—data stored inside the container filesystem is lost when the container is removed. Volumes provide persistent storage that survives container lifecycle events.

---

## 2) What is a named volume in Podman?
A named volume is storage managed by Podman. It is created separately from containers and can be mounted into any container. It persists even if containers are deleted.

---

## 3) How did you create a named volume in this lab?
Using:
- `podman volume create myapp_data`

---

## 4) How do you list volumes?
Use:
- `podman volume ls`

---

## 5) What does `podman volume inspect myapp_data` show?
It shows volume metadata such as:
- Name
- Driver (local)
- Mountpoint (where the data lives on the host)
- CreatedAt timestamp

---

## 6) Why did the volume mountpoint show `/home/toor/.local/share/...`?
Because Podman was running in **rootless mode**. Rootless Podman stores container data under the user’s home directory instead of `/var/lib/...`.

---

## 7) How did you mount a named volume into a container?
Using the `-v` flag:
- `-v myapp_data:/var/www/html`

This mounts the named volume `myapp_data` into the container path `/var/www/html`.

---

## 8) How did you confirm the volume was mounted correctly?
By listing the directory inside the container:
- `podman exec webapp ls /var/www/html`

Initially it was empty, as expected for a new volume.

---

## 9) How did you write data into the volume?
By writing a file inside the mounted directory:
- `podman exec webapp sh -c "echo 'Hello, Volume!' > /var/www/html/index.html"`

---

## 10) How did you verify persistence after deleting the container?
After removing the first container, I created a new container using the same volume and read the file:
- `podman exec webapp_new cat /var/www/html/index.html`
It still printed `Hello, Volume!`.

---

## 11) What is a bind mount?
A bind mount maps an existing directory on the host into the container. The container reads/writes directly to the host filesystem path.

---

## 12) How did you create and use a bind mount in this lab?
1) Created host directory and file:
- `mkdir ~/host_data`
- `echo "Hello, Bind Mount!" > ~/host_data/index.html`

2) Mounted it into Nginx:
- `podman run -d --name bind_example -v ~/host_data:/usr/share/nginx/html:Z nginx`

---

## 13) What does the `:Z` option do?
`:Z` applies proper SELinux labeling for the bind mount so the container can access the directory on SELinux-enabled systems.

---

## 14) How did you prove host changes reflect immediately in the container?
I appended content on the host:
- `echo "Updated content!" >> ~/host_data/index.html`

Then read it in the container and saw the updated content.

---

## 15) When should you use named volumes vs bind mounts?
- Use **named volumes** for production persistence (databases, durable app data).
- Use **bind mounts** for development workflows (live code editing, local content syncing).
