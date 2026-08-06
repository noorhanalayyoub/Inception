# Developer Documentation

This document describes how to set up, build, and manage the Inception stack for development.

## 1. Setting up the environment from scratch

### Prerequisites
- Docker
- Docker Compose
- `make`
- A Linux host (or a VM) — the project is built around Linux-native Docker

### Configuration files
Before building anything, the following need to exist at the repository root:

- **`.env`** — environment variables consumed by `docker-compose.yml` and passed into the containers (domain name, database name/user, WordPress admin username, etc.). Not committed to version control.
- **`secrets/`** — a directory holding sensitive values as individual files (e.g. `db_root_password.txt`, `db_password.txt`, `wp_admin_password.txt`), referenced by `docker-compose.yml` under each service's `secrets:` key. Kept out of `.env` and out of version control (add `secrets/` to `.gitignore`).
- **`docker-compose.yml`** — defines the three services (`nginx`, `wordpress`, `mariadb`), their build context, networks, volumes, and secrets.
- **`srcs/requirements/<service>/Dockerfile`** — one per service, building each image from a base OS image (not pulling pre-built service images from Docker Hub).
- **`srcs/requirements/<service>/tools/setup.sh`** — the entrypoint script for each service (e.g. MariaDB's script initializes the database on first run, then hands off to `mysqld` as PID 1).

Fill in `.env` and populate `secrets/` with real values before the first build — the setup scripts read from these to configure MariaDB, WordPress, and NGINX's self-signed certificate.

## 2. Building and launching via the Makefile and Docker Compose

The `Makefile` at the repository root wraps Docker Compose so you don't need to remember flags:

| Target | Underlying command | Purpose |
|---|---|---|
| `build` | `docker-compose build` | Build all three images from their Dockerfiles |
| `up` (default) | `docker-compose up` | Start all containers |
| `stop` | `docker-compose stop` | Stop containers, keep containers/network/volumes |
| `clean` | `docker-compose down` | Stop and remove containers + network (volumes survive) |
| `fclean` | `docker-compose down -v` | Full teardown — also deletes the named volumes (wipes stored data) |

Typical flow for a fresh setup:
```
make up          # build images and start the stack
```

Typical flow for a full reset (e.g. after changing secrets or `.env`):
```
make fclean   # tear down everything, including data
make up        # rebuild and start fresh
```

`.PHONY` is declared for all of these targets in the Makefile, since none of them correspond to a real file — this guarantees `make <target>` always runs the recipe rather than being skipped because a same-named file exists.

## 3. Managing containers and volumes

Useful commands beyond the Makefile shortcuts:

**Containers**
```
docker ps -a                     # list all containers, including stopped ones
docker logs <container_name>     # view a service's logs
docker exec -it <container_name> sh   # get a shell inside a running container
docker restart <container_name>  # restart a single service
```

**Networks**
```
docker network ls
docker network inspect <network_name>   # see attached containers and their internal IPs
```

**Volumes**
```
docker volume ls
docker volume inspect <volume_name>
```

**Images**
```
docker images
docker-compose build --no-cache   # force a full rebuild, ignoring layer cache
```

## 4. Where data is stored and how it persists

Containers are ephemeral by default — anything written inside a container's own filesystem is lost when the container is removed. To survive `make clean` (though not `make fclean`), this project uses **named volumes** (not bind mounts directly into arbitrary host paths) pointing at:

```
/home/nalayyou/data/mariadb/      # MariaDB's database files
/home/nalayyou/data/wordpress/    # WordPress core files, uploads, themes/plugins
```

These are declared under `volumes:` in `docker-compose.yml` and mounted into the MariaDB and WordPress containers respectively. As long as you use `make clean` (not `fclean`), this data survives a container teardown and rebuild — `make up` afterward reconnects the same volumes and the site/database come back exactly as they were.

`make fclean` explicitly runs `docker-compose down -v`, which removes these volumes — that's the only path that actually deletes this persisted data.
