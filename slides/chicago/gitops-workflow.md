# Workflows: container deployments with GitOps

- The industry is moving towards a typical workflow for *container deployments*

- The goal is to make it faster to *ship* code to a *server environment*

- While also increasing automation, quality, feedback, and security

- Let's visualize a workflow for successfully tested images to *manually* deploy to servers

---

class: pic

![gitops](chicago/manual-deploy.excalidraw.png)

---

## Flaws of this CD approach

- It requires humans to touch servers in order to deploy

- It requires humans to *have access* to servers

--

- Human delays means what's approved and what's running could be different

- Because humans have to deploy, there's no central source of truth

- GitOps ideals are meant to fix all this

---

## A few goals of GitOps

- Clusters watch a git repo (or image tag regex) for changes

- Clusters deploy (and rollback on failure) as soon as a change is detected

--

- If clusters do something, they *write-back* to git as the central log of change

- Git logs are the central source of truth

--

- Deployment specs (YAML) live in git, right next to code and IaC (terraform, ansible, etc.)

- Pull Requests become the human gates for approving deployments

--

- YAML specs and IaC are linted, validated, tested, and approved just like code

- This synergy of change management means devs *and* ops can update apps on servers

.footnote[.small[
  Waveworks coined GitOps in 2017 and has a [great intro guide](https://www.weave.works/technologies/gitops/)
]]
---

class: pic

![gitops](chicago/semi-auto-gitops.excalidraw.png)

---

class: pic

![gitops](chicago/full-auto-gitops.excalidraw.png)

