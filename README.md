*This activity has been created as part of the 42 curriculum by nalayyou*

# Description
inception is a system administration project. the goal is to build containers using docker and have a fully functional service. 

## what is docker?
to understand docker we must first understand what containers are
## Containers

- Containers sit on top of a physical server and its host OS—for example, Linux or Windows. Each container shares the host OS kernel and, usually, the binaries and libraries, too. Shared components are read-only. Containers are thus exceptionally “light”—they are only megabytes in size and take just seconds to start, versus gigabytes and minutes for a VM.
- A container is a lightweight package that contains an application and everything it needs to run
- people often confuse virtual machines and containers . a container is NOT a virtaul machine , though it provides isolation , and sits on top of the host OS
## Docker
  - Docker is a tool designed to allow you to build, deploy and run applications in an isolated and consistent manner across different machines and operating systems
## Docker Image
- Docker Image is a lightweight executable package that includes everything the application needs to run
## what is the main difference between docker and virtual machines ?
- docker virtualizes the application layer while virtual machines virtualize the hardware.
- docker images are also significantly smaller than virtual machines
- docker can only run on linux disros meanwhile VMs can run on any host OS
- <sub> **Note:** though its worth mentioning that docker desktop has been developed to run on windows and macOS by using a hypervisor layer with a lightwieght linux disro 
## Docker Image vs Docker Container
Think of an image as a recipe or blueprint — a snapshot of everything needed to run a piece of software,The code itself, The programming language runtime (e.g., Python, Node.js)
Any libraries or dependencies it needs , System tools and settings

## What is a docker file ? 
A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image. 
example 
```
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "server.js"]
```
A Dockerfile builds a Docker image by executing instructions top to bottom. Instructions that modify the filesystem (FROM, RUN, COPY, ADD) each produce a new, cached layer — a snapshot of the files added or changed at that step. Instructions like CMD, ENV, EXPOSE, and WORKDIR don't touch the filesystem . Layers are stacked and merged into the final image's filesystem 

- why does this layering matter ?
  Docker is smart about reusing layers it's already built, as long as nothing changed. So if you only edit your app's code and rebuild, Docker can skip re-running FROM and reuse the cached Node.js base layer — it only needs to redo the layers after the point where something actually changed





<details>
<summary><strong>to understand this better</strong> (click to expand)</summary>
<strong> namespaces </strong>
Namespaces are a feature of the Linux kernel that partitions kernel resources such that one set of processes sees one set of resources while another set of processes sees a different set of resources.

Docker uses namespaces to provide the isolated workspace called the container. When you run a container, Docker creates a set of namespaces for that container.

<strong> Control Groups </strong>
are a Linux feature that allows you to allocate and manage system resource among processes.Cgroups limit what resources you can use meanwhile namespaces limit what you can see .

</details>

## what is PID 1? 

a process specifically designed to manage the entire system

PID 1 has two purposes:

- automatically reparent orphand zombie processses into PID 1
- the kernel expects PID 1 itself to explicitly define what to do with each signal. If PID 1 doesn't set up a handler for a signal, that signal gets silently ignored.

 ## what is a daemon ? 
 just a program that runs quietly in the background, with no direct interaction from a user sitting at a terminal, and it typically starts up automatically and just keeps running indefinitely.Systems often start daemons at boot time that will respond to network requests, hardware activity, or other programs by performing some task.

 ## Dockerd
 dockerd is jus "Docker Daemon" a background process responsible for managing Docker containers on a system.
<details>
<summary>more on how it actually works</summary>
Dockerd is always listening for requests from the API client (docker CLI)
- it builds docker images and manages the network 
- runs and stops containers 
How it Works?

    The user runs a Docker command (docker run, docker ps, etc.).
    The Docker CLI sends an API request to dockerd.
    dockerd processes the request and performs the necessary actions.

</details>

## Important commands you must know 

```
docker images #list images 
```

  ```
docker ps -a #list all contianers (-a for stopped ones as well)
  ```
```
docker network ls          # see all networks Docker knows about
docker network inspect <network_name>   # see which containers are attached, and their internal IPs
```
```
docker network create network_name #create docker network  
``` 


## Docker Networks 
how containers talk to each other and the outside world . its like a virtual switch that connects containers 

## what is yaml
YAML is a simple, human-readable format used to store and organize data.

It is not a programming language — instead, it is used to describe configuration settings that computers can easily read.

YAML is commonly used in tools like Docker Compose to define how applications and services should run.

example yaml file
```
version: "3.8"

services:
  web:
    image: nginx
    ports:
      - "8080:80"
```


Archeticutre
```
User Browser
     |
     | HTTPS (port 443)
     v
   NGINX (reverse proxy)
     |
     | FastCGI (port 9000)
     v
 WordPress (PHP-FPM)
     |
     | SQL (port 3306)
     v
 MariaDB
```

## nginx configurations 
here is how a config file could look like 

```
http {

    gzip on;

    server {

        server_name cats.com;

        root /var/www/cats;

    }

    server {

        server_name dogs.com;

        root /var/www/dogs;

    }
```

and the flow would look like 
```
Request

↓

HTTP protocol?

↓

Enter http context

↓

Which website?

↓

Enter server context

↓

Which URL?

↓

Enter location context

↓

Generate response
```




## Importance of volumes ? 
containers are ephemeral by default .They are external storage systems attached to containers to preserve data beyond container lifecycle.

## Getting started with the scripts 
- mariadb setup script
```
Has this database already been initialized?"

If no:

initialize MariaDB
create the WordPress database
create the WordPress user
grant privileges

If yes:

skip all of that

Finally:

start MariaDB as PID 1.
```

## difference between docker compose and docker run 

| **Dimension**       | **`docker run`**                                                              | **Docker Compose**                                                                                                                    |
| ------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Paradigm**        | **Imperative** – You specify each command step by step.                       | **Declarative** – You describe the desired architecture in a YAML file, and Docker Compose creates it.                                |
| **Scope**           | Manages **one container** per command.                                        | Manages an entire **multi-container application** (services, networks, and volumes).                                                  |
| **Networking**      | Networks must be created and containers connected manually.                   | Automatically creates a network and provides **DNS resolution by service name**.                                                      |
| **Reproducibility** | Requires manually rerunning commands or maintaining shell scripts.            | The complete application is defined in a version-controlled `docker-compose.yml` file, making it easy to recreate.                    |
| **Teardown**        | Each container, network, and volume must be stopped and removed individually. | A single `docker compose down` command stops and removes all resources created by the Compose project (optionally including volumes). |

## writing your own docker compose 
| Question                              | Example (NGINX) |
| ------------------------------------- | --------------- |
| How is it built?                      | `build`         |
| Who can talk to it?                   | `networks`      |
| Does the host need to reach it?       | `ports`         |
| Does it need persistent/shared files? | `volumes`       |
| Does it need configuration?           | `environment`   |
| Does it depend on another service?    | `depends_on`    |

## Docker Secrets
Docker Secrets provide sensitive data (passwords, API keys, certificates, tokens) to containers without hardcoding them in Dockerfiles or Compose files.

secrets vs environment variables:
- Environment variables (.env / environment: in Compose) are plain text, injected into a container's environment at startup, and readable by:

anyone who can run docker inspect <container> — the values show up in the container's metadata
anyone who can read .env on disk
any process inside the container, and often visible in things like /proc/<pid>/environ

They're fine for non-sensitive config: domain name, database name, container hostnames, ports.

Secrets (Docker's secrets: mechanism, files under secrets/) are handled differently:

mounted into the container as a file (typically at /run/secrets/<secret_name>), not as an environment variable
not visible in docker inspect output
not written into the image or the Compose file itself — only referenced by filename

Why use secrets?

❌ Hardcoded password

environment:
  MYSQL_ROOT_PASSWORD: superSecret123

Problems:

- Password is visible in docker-compose.yml.
- Can be accidentally committed to Git.
- May appear in image metadata or logs.

Using a secret
```
secrets:
  db_root_password:
    file: ./secrets/db_root_password.txt
```
The password is stored in a separate file:

secrets/
└── db_root_password.txt

Docker Secrets do not encrypt the password. They improve security by:

Keeping secrets out of Dockerfiles and Compose files.
Preventing accidental commits to version control (e.g., by adding the secrets/ directory to .gitignore).
Providing secrets only to containers that require them.

## Docker Network vs Host Network
- Docker Network (the default / bridge mode)
Each container gets its own isolated network namespace and IP, separate from the host and other containers.
Containers on the same user-defined network reach each other by service name via Compose's built-in DNS — how NGINX reaches wordpress:9000 and WordPress reaches mariadb:3306 in Inception.
Ports must be explicitly published (ports: / -p) for the host or outside world to reach a container.

- Host Network (network_mode: host)
The container shares the host's network namespace directly — no isolation, no NAT, no port mapping needed (port 8080 in the container is port 8080 on the host).
Trade-off: no isolation, and no Docker DNS between containers — which breaks the service-name resolution Inception's multi-container setup depends on.

In short: Docker network = isolated, name-based reachability between containers. Host network = no isolation, but you lose that name resolution.

## Docker Volumes vs Bind Mounts

Both solve the same base problem — containers are ephemeral, so anything written to their internal filesystem disappears when the container is removed. Volumes and bind mounts are the two ways to persist data outside the container's lifecycle, but they differ in where that data lives and who manages it.

Volumes
Managed entirely by Docker — live under Docker's own storage area (e.g. /var/lib/docker/volumes/... on Linux), not wherever you happen to be running commands from.
Created and referenced by name (volumes: in Compose), not by a host filesystem path you specify.
Docker handles the lifecycle: creation, and (if you ask for it, e.g. docker-compose down -v) deletion.
Portable across environments — you're not depending on a specific host directory structure existing.
This is what Inception requires: named volumes pointing at data/mariadb/ and data/wordpress/, not arbitrary bind mounts.
Bind Mounts
You specify an exact path on the host and map it directly into the container (-v /host/path:/container/path).
The host path can be anywhere on the filesystem — full control, but also full responsibility: the path must exist and have correct permissions, and it ties your setup to that specific host's directory layout.
Docker doesn't manage the lifecycle of the underlying host directory at all — it's just a regular directory that happens to be mounted into a container.
Useful for development (e.g. mounting live source code into a container so edits show up immediately) but less portable and less "Docker-managed" than a volume.

In short: a volume is a Docker-managed storage location referenced by name; a bind mount is a direct link to a host path you choose yourself. Inception's constraint (named volumes, not bind mounts, for data/mariadb and data/wordpress) is specifically steering you toward Docker managing that persistence rather than you wiring up raw host paths.

## why does `make` exist?
Without `make`, every time you change one file in a project you'd have to remember and retype the exact command to rebuild — or worse, rebuild *everything* even if only one piece changed. That's wasteful in time and effort.

`make` solves this with one rule: compare timestamps. Every file carries metadata for when it was last modified. Given a target (an output) and its dependencies (its inputs):

- if the target is **newer** than its dependencies → it already reflects the current inputs → skip it
- if the target is **older** than its dependencies (or doesn't exist yet) → it's stale → rerun the recipe to rebuild it

For Inception this isn't really about `.c` → `.o` compilation, it's about *state*: are the containers up, are the images built. The Makefile here is less about staleness-checking and more about giving named, memorized shortcuts for `docker-compose` commands you'd otherwise have to retype by hand.

## anatomy of a rule
Every Makefile rule has the same shape:
```
target: dependencies
	command
```
Two easy ways to break this:
1. The command line **must** be indented with an actual TAB character, not spaces — otherwise `make` throws `missing separator`.
2. `dependencies` are other targets/files that must be up to date before this target runs. They can be left empty.

## default goal
Running `make` with no arguments runs the **first target** in the file — this is called the default goal.

## `.PHONY`
Targets like `build`, `up`, `clean`, `fclean` don't produce a file with that name — they're just labels for actions. The danger: if a file happens to exist in the directory with the same name as a target (e.g. a stray file called `clean`), `make` would think that target is already "up to date" (since there's nothing to compare it against) and silently skip the recipe.

`.PHONY` tells `make`: "this target name isn't a real file — always run its recipe regardless of any file with that name or its timestamp."
```makefile
.PHONY: build up stop clean fclean
```

## the Inception Makefile
Mapping the commands to their targets:

| Target | Command | Purpose |
|---|---|---|
| `build` | `docker-compose build` | build images from the Dockerfiles |
| `up` | `docker-compose up` | start all containers |
| `stop` | `docker-compose stop` | pause containers, keep them + network + volumes |
| `clean` | `docker-compose down` | stop and remove containers + network (volumes survive) |
| `fclean` | `docker-compose down -v` | full clean: same as `clean`, plus deletes the volumes (wipes `data/mariadb`, `data/wordpress`) |

The `-v` flag is what separates `clean` from `fclean` — it's the "full" wipe, since it destroys the persisted WordPress site and database along with the containers.

# Instructions
- to clone the repo
  ```
  git clone <repo_link>
  ```
- to build and run
  ```
  make up
  ```
- to stop and fully clean
  ```
  make fclean
  ```
  
# Resources
- https://github.com/vbachele/Inception (README and steps)
- https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok (project walkthrough)
- https://www.geeksforgeeks.org/linux-unix/what-type-of-language-is-yaml/ (yaml intro)
- https://medium.com/@yaswanthpedapatnam007/understanding-expose-in-docker-e3ea4b2f8109 (what expose actually does)
- https://www.geeksforgeeks.org/linux-unix/shell-script-examples/ (into to shell scripting)
- https://www.cloudflare.com/learning/ssl/what-is-https/ (what is https)
- https://claude.ai/share/0cc2ff3f-1cfc-4d8f-b7eb-504fde415914 (in depth explanation)
- https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/ (entrypoint and cmd)
- https://mohammadtaheri.medium.com/practical-nginx-a-beginners-step-by-step-project-guide-6f4c7540c06f (nginx configs basics)
- https://strapi.io/blog/what-is-docker-compose-all-you-need-to-know (docker compose mechanism)
- https://medium.com/@oakley349/tls-basics-certificate-authorities-and-self-signed-certificates-77bc68bad12c (self signed certificates)
- https://medium.com/@talyitzhak/understanding-digital-certificates-and-self-signed-certificates-b1cdca759bbc (self signed certiicate)
- https://www.reddit.com/r/docker/comments/keq9el/please_someone_explain_docker_to_me_like_i_am_an/
- https://dev.to/arsalanmee/understanding-php-fpm-a-comprehensive-guide-3ng8 (php fpm)
- https://komodor.com/learn/exit-codes-in-containers-and-kubernetes-the-complete-guide/ (exit codes , useful for debugging)
- https://www.theodo.com/blog/how-better-management-of-processes-in-docker-can-greatly-improve-a-containers-lifecycle (why container must be pid 1)
- https://medium.com/@imyzf/inception-3979046d90a0
- https://www.youtube.com/watch?v=DQdB7wFEygo
- https://harsh05.medium.com/understanding-namespaces-in-docker-0bbcf7697775
- https://medium.com/@dmosyan/linux-cgroups-explained-how-containers-use-it-c99eebb8c9c6
- https://blog.nginx.org/blog/what-are-namespaces-cgroups-how-do-they-work
- https://medium.com/@ak_gaur/docker-daemon-and-dockerd-a-detailed-explanation-with-examples-d1db76ff5c2d (Dockerd)
- https://atlantbh.com/blog/how-docker-containers-work-under-the-hood-namespaces-and-cgroups/
- https://medium.com/@fernando.harsha2016/why-your-docker-container-wont-stop-gracefully-understanding-pid-1-and-process-management-569c44dce004
- AI was used to debug and help with testing
