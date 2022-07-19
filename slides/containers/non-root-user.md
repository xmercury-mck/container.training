# Running apps as a non-root user

- Containers run anything inside them as a Linux user

- That user is controllable, and not the same as a host user
  - Container runtime translates container->host user depending on setup
  - This section is all about *inside* the container (the part *devs* control)
--

- With all programming language images on Hub, the default user is `root`

- You can change the user to `python` or `whatever`
  - Linux doesn't care about names, just the User/Group IDs
  - Many just use `1000` or `1001` as an ID convention for "my app user"

--

- This is good! We want to avoid apps-as-root, even in a container
  - It's typical in production for Kubernetes admins to prevent running as root in pods
  - Example: non-root enforcement in pod spec: `allowPrivilegeEscalation: false`

---

## General steps to run set non-root in Dockerfile

1. Create the user (`groupadd` and `useradd`)

2. Change user of future RUN commands with `USER <user>`

3. Change owner of files during COPY with `COPY --chown=<user>:<group>`

4. Test, rinse, and repeat (so many little things break when not root)

---

## Making a custom non-root Python base image

```bash
FROM ubuntu:jammy-20220531 as base
RUN apt-get update \
    && apt-get -qq install -y --no-install-recommends \
    python3-minimal python3-pip \
    && rm -rf /var/lib/apt/lists/*
RUN groupadd --gid 1000 python \
    && useradd --uid 1000 --gid python --shell /bin/bash --create-home python \
    && mkdir /app && chown -R python:python /app
 # add dev and test stages here
FROM base as prod
EXPOSE 3000
WORKDIR /app
USER python
COPY --chown=python:python requirements.txt ./
RUN pip install --user -qr requirements.txt
COPY --chown=python:python . .
CMD ["python", "something.py"]
```

---

## Kuberentes-friendly non-root Python image

```bash
FROM ubuntu:jammy-20220531 as base
RUN apt-get update \
    && apt-get -qq install -y --no-install-recommends \
    python3-minimal python3-pip \
    && rm -rf /var/lib/apt/lists/*
RUN groupadd --gid 1000 python \
    && useradd --uid 1000 --gid python --shell /bin/bash --create-home python \
    && mkdir /app && chown -R python:python /app
 # add dev and test stages here
FROM base as prod
EXPOSE 3000
WORKDIR /app
 # change USER to number so Kubernetes can be sure it's not root
USER 1000
COPY --chown=python:python requirements.txt ./
RUN pip install --user -qr requirements.txt
COPY --chown=python:python . .
CMD ["python", "something.py"]
```

---

## Key steps in the previous Dockerfile example

- `FROM ubuntu:jammy-20220531 as base`
  - tag is specific to a build date
  - `as base` gives us an alias for multi-stage ease of use

- `groupadd` and `useradd` creates our non-root `python` user

- `FROM base as prod` starts a new stage from the end of a previous stage

- `USER python` sets our container to run as `python` user
  - `COPY --chown=python:python` ensures our code files have the right ownership

---

## Which user are we running as?

- `docker inspect <container>` doesn't help us

--

- `docker top <container>` shows process, but wrong non-root user
  - That's because it's translating user IDs in container to host names
  - It's been a bug for a [long time][1] 😢

--

- `ps aux` in container will work, but many don't have `ps` installed by default

- *Let's demo in a NGINX container*

[1]:https://github.com/moby/moby/issues/17719

---

## Use `ps` (process status) inside a container

- We'll run a NGINX server in the background, named `finduser`

- Then we'll install `ps` with the `procps` package

- Finally, we'll run `ps` inside the container with options `aux`

.lab[
```bash
docker run -d --name finduser nginx
docker exec finduser bash -c 'apt-get update && apt-get install procps -y'
docker exec finduser ps aux
```
]

- Notice that NGINX runs as `root`, but its listening sub-processes run as `nginx` user

- Running the NGINX main process as `root` is required to listen on ports 80/443

---

## Other ways to run as non-root

- Changing Dockerfile is the most reliable and testable way to avoid running as root

- But you can change user at runtime. Let's try it!

.lab[
- Check which user we are on host
```bash
whoami
```

- Run `ubuntu` as default user and print out which user we are
```bash
docker run --rm ubuntu whoami
```

- Ugg, we're root in container by default. Let's run `ubuntu` as the common `ubuntu` user
```bash
docker run --rm --user ubuntu ubuntu whoami
```
]

---

## Other ways to run as non-root (cont)

- There is no `ubuntu` user by default in a `ubuntu` container
  - We could add one with `useradd`
  - Or we could check the `/etc/passwd` file and use one of those existing users

.lab[
- Print the list of users 
```bash
docker run --rm ubuntu cat /etc/passwd
```

- Start container as `www-data` user, a common user for web server (apache, PHP, etc.)
```bash
docker run --rm --user www-data ubuntu whoami
```

- `ubuntu` has `ps` installed by default, let's try it
```bash
docker run --rm --user www-data ubuntu ps aux
```
]

---

## Kubernetes pod spec for running as non-root

- Example pod spec hard-coding pre-created user/group and preventing sudo/root use

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpenv
spec:
  securityContext:
    runAsUser: 1000  # this is httpenv user
    runAsGroup: 1000 # this is httpenv group
  containers:
  - name: httpenv
    image: bretfisher/httpenv
    ports:
    - containerPort: 8888
    securityContext:
      allowPrivilegeEscalation: false
```