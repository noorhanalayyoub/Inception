# User Documentation

This document explains how to use the Inception stack as an end user or administrator — no development knowledge required.

## 1. What services does this stack provide?

The stack is a self-hosted WordPress website, made of three containers that work together:

| Service | Role |
|---|---|
| **NGINX** | The entry point. Handles HTTPS (port 443) and forwards requests to WordPress. |
| **WordPress** (PHP-FPM) | Runs the WordPress application — the website itself and its admin panel. |
| **MariaDB** | The database. Stores all site content, users, and settings. |

You never talk to WordPress or MariaDB directly — everything goes through NGINX over HTTPS.

## 2. Starting and stopping the activity

All operations are run from the root of the repository, using `make`.

| Action | Command | What it does |
|---|---|---|
| Start everything |  `make up` | Builds (if needed) and starts all three containers |
| Stop the containers | `make stop` | Pauses the containers; your data and setup are preserved |
| Stop and remove containers | `make clean` | Stops and removes the containers/network; your data is preserved |
| Full reset | `make fclean` | Removes containers, network, **and all stored data** (site content, database) — use only when you want to start completely fresh |

**Note:** `make fclean` is destructive — it deletes your WordPress site and database. Use `make stop` or `make clean` for routine stopping.

## 3. Accessing the website and the administration panel

Once the stack is running:

- **Website:** `https://nalayyou.42.fr/`
- **Administration panel:** `https://nalayyou.42.fr/wp-admin`

The domain name is whatever was configured for the project (check the `.env` file at the root of the repository for the `DOMAIN_NAME` value).

Because the certificate used is self-signed, your browser will show a security warning the first time you visit — this is expected. You can proceed past the warning to reach the site.

Log into the admin panel with the WordPress administrator account (see [Credentials](#4-locating-and-managing-credentials) below).

## 4. Locating and managing credentials

Credentials are never hardcoded into the project files. Depending on how the project was set up, they live in one (or both) of these places:

- **`.env` file** at the repository root — holds values such as the WordPress admin username/password, database name, database user, and domain name.
- **`secrets/` directory** — holds sensitive values (e.g. database root password, WordPress password) as individual files, kept out of `.env` and out of version control.

To find or change a credential:
1. Open `.env` and/or the relevant file inside `secrets/`.
2. Update the value if needed.
3. Re-run `make fclean` followed by `make up` so the containers are rebuilt with the new values (changing credentials after the database already exists will not retroactively update it — a full reset is required).

**Keep these files private.** They should never be committed to a public Git repository.

## 5. Checking that the services are running correctly

A few quick checks, from a terminal at the root of the repository:

- **Are the containers up?**
  ```
  docker ps
  ```
  You should see three running containers: one each for NGINX, WordPress, and MariaDB.

- **Is the website reachable?**
  Visit `https://nalayyou.42.fr/` in a browser, or run:
  ```
  curl -k https://nalayyou.42.fr/
  ```
  (`-k` is needed because of the self-signed certificate.) A successful response means NGINX and WordPress are both working and talking to each other.

- **Is the database reachable?**
  If the website loads and shows content (rather than a database connection error), MariaDB is up and reachable from WordPress.

- **Something's wrong?** Check the logs for the misbehaving service:
  ```
  docker logs <container_name>
  ```
