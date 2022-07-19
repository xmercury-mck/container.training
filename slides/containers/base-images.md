# Choosing your base image

- *base image* = The existing image that you start new dev projects from

- We often recommend "Docker Hub Official Images" as your "base" image

- For prebuilt apps like MySQL, Postgres, Redis, you typically leave them unchanged

--

- For development languages and frameworks, it's not so simple
  
- We want feature-rich images for easy dev, but slim and secure images for prod

- Docker Hub defaults to "easy for beginners" with Node.js, PHP, Ruby, Python, etc.

--

- *Let's look at a few examples to understand the difference*

---

## Exploring official Python images

- Let's look at the size difference of various Python image types

.lab[

- Let's download a few different images
  ```bash
  docker pull python:latest
  docker pull python:slim
  docker pull python:slim-bullseye
  docker pull python:alpine
  ```

- Let's list only the python images to check their size
  ```bash
  docker images --filter=reference='python'
  # OR
  docker images | grep python
  ```

]

---

## Explaining the Python image differences

- All these images provide Python 3.x, so why is their size so different?

--

- `slim` is only 14% the size of `latest`

- `alpine` is only 5% the size of `latest`

- If you just `docker pull python`, it assumes `latest`, so isn't that the *best*?

--

- Docker Hub Official Images for programming languages are "easy by default"

- Security is often a pendulum, and `latest` sacrifices secure-by-default for convenience

- `latest` includes lots of tools like compliers and common libs we'll never use

- It's much better (but more work) to control our app dependencies ourselves

---

## Python image types

- Docker Hub Convention: Official images tend to have common tag names

- Docker Hub Convention: Official images built on minimal Debian, unless specified

- `:latest` = Latest stable version, with a bunch of extras for convenience

  - Never use this for anything but samples/demos/learning

- `:slim` = A slimmed down minimal version of the latest stable version

  - A much better starting point for your apps in the real world

- `:alpine` = Very minimal, replaces Debian with Busybox + Alpine

  - Seems much more secure then Debian, but can have compatibility issues

---

## Debian as the base of Official images

- All images start with `scratch`, which is empty

- To use `apt` (`apt-get`) or `yum` packages, you need a Linux distributions basic tools

  - Package managers, OpenSSL, shells (bash, zsh, sh), root certs, etc.

  - Without these tools, you couldn't do much when building your app image

- Docker Inc. choose Debian as the standard base

  - A common distro, and the basis for many others like Ubuntu and Mint

  - This makes migrating app builds to a Dockerfile way easier

---

## Official image builds are open source

- Still curious how a Official image is built? Dockerfiles are open source!

- Starting from the final `python:latest`, we can walk back through the Dockerfiles

- Click any image tag in a Docker Hub official image page to see the Dockerfile

- [hub.docker.com/_/python](https://hub.docker.com/_/python) is built on top of other images:

1. `python:latest` (920MB) is built from its [Dockerfile][1] in the Docker Hub repo README
2. That Dockerfile has `FROM buildpack-deps:bullseye` as its base image
3. `buildpack-deps:bullseye` (834MB) [Dockerfile installs a bunch][2] of packages
4. That Dockerfile has `FROM buildpack-deps:bullseye-scm` as its base image
5. `buildpack-deps:bullseye-scm` (306MB) [Dockerfile installs versioning tools][3]
6. That Dockerfile has `FROM buildpack-deps:bullseye-curl` as its base image
7. `FROM buildpack-deps:bullseye-curl` (154MB) [Dockerfile installs curl, wget and others][4]
8. That Dockerfile has `FROM debian:bullseye` as its base image
9. `debian:bullseye` (118MB) is a [simple 3-line Dockerfile][5] that has minimal Debian

[1]:https://github.com/docker-library/python/blob/56cea612ab370f3d05b29e97466d418a0f07e463/3.10/bullseye/Dockerfile
[2]:https://github.com/docker-library/buildpack-deps/blob/65d69325ad741cea6dee20781c1faaab2e003d87/debian/bullseye/Dockerfile
[3]:https://github.com/docker-library/buildpack-deps/blob/65d69325ad741cea6dee20781c1faaab2e003d87/debian/bullseye/scm/Dockerfile
[4]:https://github.com/docker-library/buildpack-deps/blob/98a5ab81d47a106c458cdf90733df0ee8beea06c/debian/bullseye/curl/Dockerfile
[5]:https://github.com/debuerreotype/docker-debian-artifacts/blob/6251ccd8060ae10b12bd881975cf37eee84ffbb0/bullseye/Dockerfile

---

## Side effects of using Debian as the base

- Debian is a great open source org, but it's not the right fit for everyone

- If you're a Red Hat shop (`yum` based) you have to convert to `apt` and test

- Debian is historically slower to patch CVEs than Ubuntu for RHEL

- Debian has way more CVEs than Alpine, BusyBox, or scratch-based images

--

- But what other options are there?

- *let's look at many options for Node.js, another dynamically compiled language*

---

.small[

## CVEs, Size, and Support of Node.js Images

| Image Name                             | Tier 1 Support | CVEs (High+Crit)/TOTAL | Node Version Control | Image Size (Files) | Min Pkgs |
| -------------------------------------- | -------------- | ---------------------- | -------------------- | ------------------ | -------- |
| node:latest                            | Yes            | 332/853                | **No**               | 991MB (203,325)    | No       |
| node:16                                | Yes            | 259/1954               | Yes                  | 906MB (202,898)    | No       |
| node:16-alpine                         | **No**         | 0/0                    | Yes                  | 111MB (179,510)    | Yes      |
| node:16-slim                           | Yes            | 36/131                 | Yes                  | 175MB (182,843)    | Yes      |
| node:16-bullseye                       | Yes            | 130/947                | Yes                  | 936MB (201,425)    | No       |
| node:16-bullseye-slim                  | Yes            | 12/74                  | Yes                  | 186MB (183,416)    | Yes      |
| ubuntu:20.04+nodesource package        | Yes            | 2/18                   | Yes                  | 188MB (182,609)    | No       |
| **ubuntu:20.04+node:16-bullseye-slim** | Yes            | **0/15**               | Yes                  | 168MB (183,094)    | **Yes**  |
| **gcr.io/distroless/nodejs:16**        | Yes            | **1/12**               | **No**               | **108MB (2,120)**  | **Yes**  |

.footnote[
*CVEs and size are from April 2022. RH UBI not considered since it's on Node 10.*
]]

---

## Explaining the previous slide table

- `node:latest` and `node:16` are almost 1GB (and don't even contain your app yet)
  - Those "full" images have hundreds of CVEs
  - We can't easily remove a CVE if it's already in base image

- `node:alpine` has NO CVEs and is small, but not supported by the Node.js project
  - YMMV: Many articles detailing how Node.js on Alpine had issues in the real world

- `node:slim` makes a **huge** difference in CVEs and size over "full" images

- `node:16-bullseye-slim` Replaces the underlying Debian version with an updated one
  - Less CVEs and more up-to-date `apt` packages!

- `ubuntu:20.04+node:16-bullseye-slim` copies `/usr/local` from `node` to `ubuntu`

---

## Better base image habits

- Use `slim` by default, if it's available.

- Pin exact versions of `FROM` images. You want deterministic builds.

- Only try `:alpine` variants once you're well versed in your app dependencies
  - You really need good automated testing, including performance, to trust it

- Consider setting your standard on `ubuntu` or which has a lower CVE count

---

## Example of making a custom base image

```bash
FROM ubuntu:jammy-20220531 as base
RUN apt-get update \
    && apt-get -qq install -y --no-install-recommends \
    python3-minimal python3-pip \
    && rm -rf /var/lib/apt/lists/*
 # add dev and test stages here
FROM base as prod
EXPOSE 3000
WORKDIR /app
COPY requirements.txt ./
RUN pip install -qr requirements.txt
COPY . .
CMD ["python", "something.py"]
```

---

## Key steps in the previous Dockerfile example

- `FROM ubuntu:jammy-20220531 as base`
  - tag is specific to a build date
  - `as base` gives us an alias for multi-stage ease of use

- Install Python your preferred way. In this case we install `minimal` via `apt`

- `FROM base as prod` starts a new stage from the end of a previous stage
  - This is so you could add more dev/test stages later
  - Then target specific stages during the build process

---

## Bonus: watch my DockerCon 2022 talk

- "Node.js Rocks in Docker"

- It focuses a lot on base images, custom base images, multi-stage images, and more

- [27min YouTube video][1]
  
- [GitHub Repo][2] with tons of examples and documentation

- 95% of it is directly transferable to Python, PHP, Ruby, etc.

- 75% of it is transferable to any other language image

[1]:https://www.youtube.com/watch?v=Z0lpNSC1KbM
[2]:https://github.com/BretFisher/nodejs-rocks-in-docker
