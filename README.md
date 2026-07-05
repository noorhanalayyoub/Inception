# Inception
inception is a system administration project.
# what is docker?
to understand docker we must first understand what containers are
## Containers
![Application Screenshot](container-vs-vm-inline1_tcm19-82163)
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

# What is a docker file ? 
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

# what is PID 1? 

a process specifically designed to manage the entire system

PID 1 has two purposes:

- automatically reparent orphand zombie processses into PID 1
- the kernel expects PID 1 itself to explicitly define what to do with each signal. If PID 1 doesn't set up a handler for a signal, that signal gets silently ignored.

 # what is a daemon ? 
 just a program that runs quietly in the background, with no direct interaction from a user sitting at a terminal, and it typically starts up automatically and just keeps running indefinitely.Systems often start daemons at boot time that will respond to network requests, hardware activity, or other programs by performing some task.

 # Dockerd
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

# Important commands you must know 

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


# Docker Networks 
how containers talk to each other and the outside world . its like a virtual switch that connects containers 

# what is yaml
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

outline for your project
```
inception/
│
├── Makefile
├── docker-compose.yml
├── .env
│
├── secrets/                 # (optional if your campus allows Docker secrets)
│
├── srcs/
│   │
│   ├── requirements/
│   │   │
│   │   ├── nginx/
│   │   │   ├── Dockerfile
│   │   │   ├── conf/
│   │   │   │   └── nginx.conf
│   │   │   └── tools/
│   │   │       └── setup.sh
│   │   │
│   │   ├── wordpress/
│   │   │   ├── Dockerfile
│   │   │   ├── conf/
│   │   │   │   ├── www.conf
│   │   │   │   └── wp-config.php
│   │   │   └── tools/
│   │   │       └── setup.sh
│   │   │
│   │   └── mariadb/
│   │       ├── Dockerfile
│   │       ├── conf/
│   │       │   └── my.cnf
│   │       └── tools/
│   │           └── setup.sh
│   │
│   └── bonus/               # leave empty until mandatory is done
│
└── data/
    ├── mariadb/
    └── wordpress/
```
## Resources
- https://github.com/vbachele/Inception (README and steps)
- https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok (project walkthrough)
- https://www.geeksforgeeks.org/linux-unix/what-type-of-language-is-yaml/ (yaml intro)
- https://medium.com/@yaswanthpedapatnam007/understanding-expose-in-docker-e3ea4b2f8109 (what expose actually does)
- https://www.geeksforgeeks.org/linux-unix/shell-script-examples/ (into to shell scripting)
- https://www.cloudflare.com/learning/ssl/what-is-https/ (what is https)
- https://www.reddit.com/r/docker/comments/keq9el/please_someone_explain_docker_to_me_like_i_am_an/
- https://medium.com/@imyzf/inception-3979046d90a0
- https://www.youtube.com/watch?v=DQdB7wFEygo
- https://harsh05.medium.com/understanding-namespaces-in-docker-0bbcf7697775
- https://medium.com/@dmosyan/linux-cgroups-explained-how-containers-use-it-c99eebb8c9c6
- https://blog.nginx.org/blog/what-are-namespaces-cgroups-how-do-they-work
- https://medium.com/@ak_gaur/docker-daemon-and-dockerd-a-detailed-explanation-with-examples-d1db76ff5c2d (Dockerd)
- https://atlantbh.com/blog/how-docker-containers-work-under-the-hood-namespaces-and-cgroups/
- https://medium.com/@fernando.harsha2016/why-your-docker-container-wont-stop-gracefully-understanding-pid-1-and-process-management-569c44dce004
