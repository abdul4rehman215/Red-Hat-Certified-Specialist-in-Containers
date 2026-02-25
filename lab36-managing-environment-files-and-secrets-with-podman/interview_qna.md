# 💬 Interview Q&A — Lab 36: Managing Environment Files and Secrets with Podman

---

## 1) What is an `.env` file used for in container workflows?
An `.env` file stores key-value pairs for environment variables so you can load them into containers in bulk without passing many `-e` flags.

---

## 2) How do you load environment variables from an env file into a container with Podman?
Use `--env-file`:
```bash id="q5w1n6"
podman run --rm --env-file=.env alpine env
````

---

## 3) What’s the main security risk of using `.env` files for credentials?

`.env` files often contain passwords/API keys. If committed to GitHub, they can leak secrets. Best practice is to commit a `.env.example` and keep the real `.env` ignored.

---

## 4) How did you verify variables from `.env` were actually loaded?

By running:

```bash id="j7e4q9"
podman run --rm --env-file=.env alpine env | grep -E 'APP_NAME|DB_'
```

It printed `APP_NAME`, `DB_USER`, and `DB_PASS`.

---

## 5) What is a Podman secret?

A Podman secret is a managed object for sensitive data (passwords, tokens). It’s mounted into a container at runtime (not baked into the image).

---

## 6) How did you create a Podman secret in this lab?

From a file:

```bash id="a9y0n8"
echo "TopSecretPassword" > db_password.txt
podman secret create db_password_secret db_password.txt
```

---

## 7) How do you list Podman secrets?

```bash id="p3c7v2"
podman secret ls
```

---

## 8) Where do secrets appear inside a container?

By default under:

* `/run/secrets/<secret_name>`

In this lab:

```bash id="4h1z8v"
cat /run/secrets/db_password_secret
```

---

## 9) How do you pass a secret into a container at runtime?

Use `--secret`:

```bash id="d2c3k9"
podman run --rm --secret=db_password_secret alpine cat /run/secrets/db_password_secret
```

---

## 10) Why are secrets better than env vars for sensitive values?

Environment variables can be:

* displayed in process listings
* logged accidentally
* exposed via debugging tools
  Secrets reduce accidental exposure by mounting sensitive data as files and keeping them managed separately from images.

---

## 11) What does `external: true` mean in a compose secrets section?

It means the secret is not created by the compose file; it must already exist in Podman’s secret store before running `podman-compose up`.

---

## 12) Why did you escape `$APP_NAME` in `docker-compose.yml`?

To prevent host-side expansion and ensure the variable is expanded inside the container shell:

```yaml
command: sh -c "echo \$APP_NAME && cat /run/secrets/db_password_secret"
```

---

## 13) What issue did you encounter with `podman-compose` on CentOS 7?

`podman-compose` was not installed (`command not found`). Also, `pip3` initially pointed to Python 2.7, so I installed `python3-pip` and then installed `podman-compose` via `pip3`.

---

## 14) Why did you update the PATH after installing with `pip3 --user`?

Because pip installed the binary into:

* `/home/centos/.local/bin`
  which wasn’t in PATH. I fixed it for the current session with:

```bash id="w2r2u8"
export PATH=$PATH:/home/centos/.local/bin
```

---

## 15) What’s the key takeaway from this lab?

Use `.env` files for bulk non-sensitive configuration and use Podman secrets for sensitive data. Compose can combine both, and in real projects, secrets should not be committed to source control.
