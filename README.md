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
<details>
<summary><strong>to understand this better</strong> (click to expand)</summary>
This feature is currently experimental.

- It may change in future releases.
- Feedback is welcome.
- See the documentation for more details.

</details>

## Resources
- https://www.reddit.com/r/docker/comments/keq9el/please_someone_explain_docker_to_me_like_i_am_an/
- https://medium.com/@imyzf/inception-3979046d90a0
- https://www.youtube.com/watch?v=DQdB7wFEygo
