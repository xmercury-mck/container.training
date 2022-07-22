# Next project steps

- There are many ways to get started with containers

- The two primary paths are local dev first, or build/test first

---

## Local dev first

This is what most devs imagine as the path to success

1. Get Docker Desktop locally
2. Pick a single project to migrate to containers
3. Build Dockerfiles locally
4. Get solution to work in Compose locally with the various containers
5. Get other devs to try it
6. Focus on shifting dev to "container first" with Docker + Compose
7. Eventually get images to build/test in CI
8. Some time after that, Build Kubernetes YAML and start testing locally
9. Build a K8s cluster and try deploying
10. Iterate on the three aspects of the project, dev, build/test, and clusters
11. Once project is in production, document learnings, find the next project

---

## What if you can't run Docker or K8s locally?

Maybe because security, resource limits, project approvals, etc.

- Option 1: Issue each dev a Linux server. Use VSCode/etc. to remotely dev via ssh

  - VS Code Remote: https://code.visualstudio.com/docs/remote/remote-overview

- Option 2: Create a K8s cluster on servers. Use tools to dev locally and run remotely

  - Okteto: https://okteto.com/
  - Garden: https://garden.io/
  - Telepresence: https://www.telepresence.io/
  - Skaffold: https://skaffold.dev/

- Option 3: Invest in a platform to develop remotely. This is the trend.

  - GitHub employees now only develop remotely using [CodeSpaces](https://github.com/features/codespaces)
  - Okteto [sells a self-hosted option] for one-click remote dev environments
  - [Kasm Linux desktops](https://www.kasmweb.com/)

[sells a self-hosted option]: https://www.okteto.com/pricing/?plan=Self-Hosted

---

## Build/test first

Maybe devs don't have time/budget/approval to change their local dev setup

1. Pick a single project to migrate to containers
1. Build Dockerfiles locally
1. ~~Get solution to work in Compose locally with the various containers~~
1. ~~Get other devs to try it~~
1. ~~Focus on shifting dev to "container first" with Docker + Compose~~
1. Get images to build/test in CI
2. Build a K8s cluster
3. Build Kubernetes YAML and start testing ~~locally~~
4.  Iterate on the ~~three~~ two aspects of the project, ~~dev,~~ build/test, and clusters
5.  Once project is in production, document learnings, find the next project

--

Dev local envs can come later, or never. It's up to you.