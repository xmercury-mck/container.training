# Linux security features in containers

- Namespaces and cgroups are not enough to ensure strong security

- We need extra mechanisms: capabilities, seccomp, SELinux, AppArmor, etc.

--

- These mechanisms were already used before containers to harden security
  - But most people didn't use them, they are off by default, and complex
  - They can be used together with containers and k8s/Docker can manage them
  - Note, of these four mechanisms we'll discuss, they have a huge overlap

--

- Docker enabled them by default, to make everything safer in a container
  
  - They even scanned the top open source tools to design sane default profiles
  - (This is why you'll hear me say any pre-container app is [more secure in Docker])

--

- Sadly, Kubernetes disabled many by default, but we can re-enable!

[Docker enabled them by default]: https://docs.docker.com/engine/security/
[more secure in Docker]: https://docs.docker.com/engine/security/non-events/

---

## Capabilities

- In traditional UNIX, many operations are possible if and only if UID=0 (root)

- Some of these operations are very powerful:

  - changing file ownership, accessing all files ...

- Some of these operations deal with system configuration, but can be abused:

  - setting up network interfaces, mounting filesystems ...

- Some of these operations are not very dangerous but are needed by servers:

  - binding to a port below 1024

- Capabilities are per-process flags to allow these operations individually

---

## Some capabilities

- `CAP_CHOWN`: arbitrarily change file ownership and permissions

- `CAP_DAC_OVERRIDE`: arbitrarily bypass file ownership and permissions

- `CAP_NET_ADMIN`: configure network interfaces, iptables rules, etc.

- `CAP_NET_BIND_SERVICE`: bind a port below 1024

See `man capabilities` for the full list and details

---

## Using capabilities

- Container engines will typically drop all "dangerous" capabilities

- You can then re-enable capabilities on a per-container basis, as needed

- With the Docker engine: `docker run --cap-add ...`

- Enable ALL capabilities with: `docker run --privileged ...`

  - This gives the container all the capabilities of the host `root` user
  - This is not recommended, but is sometimes necessary as a last resort

- In Kubernetes, you can use the `capabilities` field in the `spec: Containers: securityContext`
  to specify which capabilities are allowed

- In Kubernetes, avoid `allowPrivilegeEscalation: true` in the `spec: Containers: securityContext`
  or `privileged: true` which is the same as `docker run --privileged`

---

## Seccomp

- Seccomp is "secure computing"

- Achieve high level of security by restricting drastically available syscalls

- Original seccomp only allows `read()`, `write()`, `exit()`, `sigreturn()`

- The seccomp-bpf extension allows specifying custom filters with BPF rules

- This allows filtering by syscall, and by parameter

- BPF code can perform arbitrarily complex checks, quickly, and safely

- [Docker enables a moderate policy by default], disabling 44 of the 300+ system calls

- But, Kubernetes disables it by default, so reenable it with: `spec: securityContext:
  seccompProfile: type: RuntimeDefault`

[Docker enables a moderate policy by default]: https://docs.docker.com/engine/security/seccomp/

---

## Linux Security Modules

- The most popular ones are SELinux and AppArmor

- Red Hat distros generally use SELinux

- Debian distros (in particular, Ubuntu) generally use AppArmor

- LSMs add a layer of access control to all process operations

- If installed, [Docker enables a default policies] that worked in most cases

- Again, Kubernetes disables them by default

[Docker enables a default policies]: https://docs.docker.com/engine/security/apparmor/

---

## Other Linux security features

- There are other complex topics to research (esp. if your Ops or DevSecOps)
  
- Linux *User* Namespaces
  - Not enabled by default in Docker or Kubernetes, but possible (k8s coming soon)
  - Map container users to high UIDs on host to further prevent escaping
  - This feature could prevent attacks on multiple previous CVEs

- Read-Only Container Filesystem
  - Not enabled by default in Docker or Kubernetes, but possible
  - Enabled per container file system, not all apps would support this

- Container Runtime Runs Rootless
  - By default, runtimes run as root, increasing risk of privilege escalation
  - Usually you *need* root so it can do things, but [that's changing]

[that's changing]: https://kubernetes.io/docs/tasks/administer-cluster/kubelet-in-userns/

---

## More reading and references

- [Kubernetes Docs excellent jumping off point] on all these security topics (and more)

- Yes! [Enable seccomp by default cluster-wide], an alpha feature in K8s 1.22

- Fantastic [Docker Docs on container runtime security], written for mere mortals

[Kubernetes Docs excellent jumping off point]: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
[Enable seccomp by default cluster-wide]: https://kubernetes.io/docs/tutorials/security/seccomp/#enable-the-use-of-runtimedefault-as-the-default-seccomp-profile-for-all-workloads
[Docker Docs on container runtime security]: https://docs.docker.com/engine/security/
