# Restricting Pod Permissions

- By default, our pods and containers can do *everything*

  (including taking over the entire cluster)

- We are going to show an example of a malicious pod

  (which will give us root access to the whole cluster)

- Then we will explain how to avoid this with admission control

  (PodSecurityAdmission, PodSecurityPolicy, or external policy engine)

---

## Setting up a namespace

- For simplicity, let's work in a separate namespace

- Let's create a new namespace called "green"

.lab[

- Create the "green" namespace:
  ```bash
  kubectl create namespace green
  ```

- Change to that namespace:
  ```bash
  kns green
  ```

]

---

## Creating a basic Deployment

- Just to check that everything works correctly, deploy NGINX

.lab[

- Create a Deployment using the official NGINX image:
  ```bash
  kubectl create deployment web --image=nginx
  ```

- Confirm that the Deployment, ReplicaSet, and Pod exist, and that the Pod is running:
  ```bash
  kubectl get all
  ```

]

---

## One example of malicious pods

- We will now show an escalation technique in action

- We will deploy a DaemonSet that adds our SSH key to the root account

  (on *each* node of the cluster)

- The Pods of the DaemonSet will do so by mounting `/root` from the host

.lab[

- Check the file `k8s/hacktheplanet.yaml` with a text editor:
  ```bash
  vim ~/container.training/k8s/hacktheplanet.yaml
  ```

- If you would like, change the SSH key (by changing the GitHub user name)

]

---

## Deploying the malicious pods

- Let's deploy our "exploit"!

.lab[

- Create the DaemonSet:
  ```bash
  kubectl create -f ~/container.training/k8s/hacktheplanet.yaml
  ```

- Check that the pods are running:
  ```bash
  kubectl get pods
  ```

- Confirm that the SSH key was added to the node's root account:
  ```bash
  sudo cat /root/.ssh/authorized_keys
  ```

]

---

## Mitigations

- This can be avoided with *admission control*

- Admission control = filter for (write) API requests

- Admission control can use:

  - plugins (compiled in API server; enabled/disabled by reconfiguration)

  - webhooks (registesred dynamically)

- Admission control has many other uses

  (enforcing quotas, adding ServiceAccounts automatically, etc.)

---

## Built-in admission plugins

- [PodSecurityPolicy](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) (will be removed in Kubernetes 1.25)

  - Legacy, since K8s 1.0, pre "Admission Controllers" API

  - Commonly used, but removed when 1.25 ships in August 2022

- [PodSecurityAdmission](https://kubernetes.io/docs/concepts/security/pod-security-admission/) (beta since Kubernetes 1.23)

  - use pre-defined policies (privileged, baseline, restricted)

  - label namespaces to indicate which policies they can use

  - optionally, define default rules (in the absence of labels)

---

## Dynamic admission

- Leverage ValidatingWebhookConfigurations

  (to register a validating webhook)

- Examples:

  [Kubewarden](https://www.kubewarden.io/) (uses Wasm-based policies)

  [Kyverno](https://kyverno.io/policies/pod-security/) (uses simple YAML K8s resources)

  [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper) (uses Rego language for policies)

- Pros: available today; very flexible and customizable; superset of PodSecurityAdmission

- Cons: performance and reliability of external webhook (minor usually)

---

## My policy preferences for the real world

- [Kyverno][1] (and their SaaS [Nirmata][2]) is the most mature and flexible solution

- It's a CNCF incubating project, meaning it's ready for production, stable, and popular

- It only requires using YAML, unlike others, and way more flexible than the built-in PSA

- It's friendly at the CLI, failing gracefully and explaining why you didn't meet the policy

- Like all Admission Controllers, it's harder to troubleshoot when `apply` is automated

- I had the founder demo it on my stream, checkout the [video][3] or [podcast][4]

- We should still probably know the basics of PSA, since thats built-in

[1]:https://kyverno.io/policies/pod-security/
[2]:https://nirmata.com/
[3]:https://youtu.be/4uabd0GkqdY?t=357
[4]:https://podcast.bretfisher.com/episodes/kubernetes-policy-management-with-kyverno-and-nirmata

---

## Acronym salad for built-in features

- PSP = Pod Security Policy (legacy)

  - an admission plugin called PodSecurityPolicy

  - a resource named PodSecurityPolicy (`apiVersion: policy/v1beta1`)

- PSA = Pod Security Admission

  - an admission controller called `PodSecurity`, enforcing PSS below

  - the successor to the legacy PSP

- PSS = Pod Security Standards

  - a set of 3 policies (privileged, baseline, restricted)

???

:EN:- Mechanisms to prevent pod privilege escalation
:FR:- Les mécanismes pour limiter les privilèges des pods
