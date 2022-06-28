## This week we're learning container basics

- Docker, Compose, container networking, container internals, etc.

- These container fundamentals are critical for all other tooling.

- e.g. Kubernetes runs these containers across many servers.

---

## What *is* Docker, the idea?

- Docker Inc makes many tools to build, deploy, and run containers.

- They invented the modern way to run "containers". (previously jails, chroot, zones, etc.)

--

- Their original 2013 ideas are now an industry standard called [OCI](https://opencontainers.org/).

- Those standards are now used by hundreds of tools the [Cloud Native](https://www.cncf.io/) computing.

--

- The three innovations are:
  
  - Combine your app and all its dependencies in a container image
  - Move that image around with registries
  - Run that image anywhere in a container

- I wrote a big article around this with lots of details. Bookmark for later!

  - [Kubernetes vs. Docker](https://www.bretfisher.com/kubernetes-vs-docker/)

---

## What *is* Docker Inc., the company?

- Docker Inc was quicly formed after Docker the tool/project was created in 2013.

- Previously, Docker Inc. focused on Dev *and* Ops tooling (2013-2019).

--

- In 2019 they sold 2/3rd of company and Enterprise-focused software to [Mirantis](https://www.mirantis.com/).

- Now they are (finally) successful focusing on Dev tooling.

--

- Docker Subscription includes:

  - Docker Desktop for macOS, Windows, Linux desktops
  - Docker Hub image storage
  - Image security scans
  - Automated image builds

--

- We're only using Docker open source today!

- Their Hub & Docker Desktop are totally free while learning and for personal use.

---

## What *is* `docker` the tool?

- "Installing Docker" really means "Installing the Docker Engine and CLI".

- The Docker Engine is a daemon (a service running in the background).

--

- This daemon manages containers, the same way that a hypervisor manages VMs.

- We interact with the Docker Engine by using the Docker CLI.

--

- The Docker CLI and the Docker Engine communicate through an API.

- There are many other programs and client libraries which use that API.

---

## Didn't Kubernetes replace Docker?

- This is a common misconception.

--

- Docker only controls many containers on a single server.

- Kubernetes (K8s) was invented to control Docker across many servers.

--

- *Kubernetes doesn't run containers itself, it only controls a runtime*.

--

- For years, Docker (`dockerd`) was the most popular container runtime.

- Then Docker Inc. created `containerd` as a lightweight runtime for servers.

--

- Today `dockerd` and `containerd` are most of runtime market. Others include CRI-O and Podman (Red Hat).

--

- `dockerd` or `podman` = best for humans locally. `containerd` or `cri-o` = best for K8s.
