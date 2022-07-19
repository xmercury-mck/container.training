# Bret's container security advice

- There's mountains of features, tools, and techniques to improve security for containers

- I thought I'd give you a top 10-ish list of activities I see as valuable in each area

- This is exclusively about containers, in 3 parts:

  - Image security
  - Container/Pod security
  - Kubernetes cluster security

- This list was inspired by my [security AMA on the topic]

[security AMA on the topic]: https://github.com/BretFisher/ama/discussions/150

---

## Image security top 10-ish

- Use `slim` or `ubuntu` for language base images

- Implement multi-stage builds so prod doesn't have dev/test dependencies

- Create and use non-root users in Dockerfiles
  - Define your Dockerfile `USER` as the ID, to work best with Kubernetes

- Don't reuse image tags for prod-destined images. Use semver or/with date tags

- [Consider an init process] like `tini` to avoid zombie processes

- Use comments heavily in Dockerfiles to document your build process

- Copy `.gitignore` to `.dockerignore` everywhere there's a Dockerfile. (add `.git`!)

- Focus on reducing CVE count. [Automate builds and CVE scans] for every PR commit

[Consider an init process]: https://github.com/BretFisher/nodejs-rocks-in-docker#proper-nodejs-startup-tini
[Automate builds and CVE scans]: https://github.com/BretFisher/allhands22

---

## Container security top 10-ish

- You're running a non-root user in the container, right?

- Run your apps on a high port (3000, 8000, 8080, etc.), for easier rootless containers

- Lock down your pod spec with defaults for non-root, seccomp, and privilege escalation

```yaml
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
    - name: httpenv
      image: bretfisher/httpenv
      securityContext:
        allowPrivilegeEscalation: false
        privileged: false
```

---

## Kubernetes security top 10-ish

- Use a vendor or cloud Kubernetes installer rather than "vanilla" upstream

- Scan your cluster often for configuration issues with [Kubescape] (NSA and CIS options)

- Add automated GitOps tools and prevent humans from having kubectl root access

- Enable Admission Controllers to enforce security policies ([Kyverno]) ([a great post])

- Scan all YAML files (manifests, kustomize, Helm) for security and config issues
  - Add to CI automation. Scan on every PR of infrastructure-as-code
  - K8s specific tools include [Trivy] and [Datree]
  - Even "all in one" tools like [Super-Linter] and [MegaLinter] can help

- [Research sigstore], and implement Content Trust for a secure supply chain

- Besides the obvious log and monitoring, [use Falco] to watch for bad behavior

[Kubescape]: https://github.com/armosec/kubescape
[Trivy]: https://aquasecurity.github.io/trivy
[Datree]: https://www.datree.io/
[Super-Linter]: https://github.com/github/super-linter
[MegaLinter]: https://oxsecurity.github.io/megalinter/latest/descriptors/kubernetes/
[Kyverno]: https://kyverno.io/
[a great post]: https://www.appvia.io/blog/podsecuritypolicy-is-dead-long-live
[Research sigstore]: https://www.sigstore.dev/
[use Falco]: https://falco.org/
