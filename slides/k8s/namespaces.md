# Namespaces

- We would like to deploy another copy of DockerCoins on our cluster

- We could rename all our deployments and services:

  hasher → hasher2, redis → redis2, rng → rng2, etc.

- That would require updating the code

- There has to be a better way!

--

- As hinted by the title of this section, we will use *namespaces*

---

## Identifying a resource

- We cannot have two resources with the same name

  (or can we...?)

--

- We cannot have two resources *of the same kind* with the same name

  (but it's OK to have an `rng` service, an `rng` deployment, and an `rng` daemon set)

--

- We cannot have two resources of the same kind with the same name *in the same namespace*

  (but it's OK to have e.g. two `rng` services in different namespaces)

--

- Except for resources that exist at the *cluster scope*

  (these do not belong to a namespace)

---

## Uniquely identifying a resource

- For *namespaced* resources:

  the tuple *(kind, name, namespace)* needs to be unique

- For resources at the *cluster scope*:

  the tuple *(kind, name)* needs to be unique

.lab[

- List resource types again, and check the NAMESPACED column:
  ```bash
  kubectl api-resources
  ```

]

---

## Pre-existing namespaces

- If we deploy a cluster with `kubeadm`, we have three or four namespaces:

  - `default` (for our applications)

  - `kube-system` (for the control plane)

  - `kube-public` (contains one ConfigMap for cluster discovery)

  - `kube-node-lease` (in Kubernetes 1.14 and later; contains Lease objects)

- If we deploy differently, we may have different namespaces

---

## Creating namespaces

- Let's see two identical methods to create a namespace

.lab[

- We can use `kubectl create namespace`:
  ```bash
  kubectl create namespace blue
  ```

- Or we can construct a very minimal YAML snippet:
  ```bash
	kubectl apply -f- <<EOF
	apiVersion: v1
	kind: Namespace
	metadata:
	  name: blue
	EOF
  ```

]

---

## Using namespaces

- We can pass a `-n` or `--namespace` flag to most `kubectl` commands:
  ```bash
  kubectl -n blue get svc
  ```

- We can also change our current *context*

- A context is a *(user, cluster, namespace)* tuple

- We can manipulate contexts with the `kubectl config` command

---

## Viewing existing contexts

- On our training environments, at this point, there should be only one context

.lab[

- View existing contexts to see the cluster name and the current user:
  ```bash
  kubectl config get-contexts
  ```

]

- The current context (the only one!) is tagged with a `*`

- What are NAME, CLUSTER, AUTHINFO, and NAMESPACE?

---

## What's in a context

- NAME is an arbitrary string to identify the context

- CLUSTER is a reference to a cluster

  (i.e. API endpoint URL, and optional certificate)

- AUTHINFO is a reference to the authentication information to use

  (i.e. a TLS client certificate, token, or otherwise)

- NAMESPACE is the namespace

  (empty string = `default`)

---

## Switching contexts

- We want to use a different namespace

- Solution 1: update the current context

  *This is appropriate if we need to change just one thing (e.g. namespace or authentication).*

- Solution 2: create a new context and switch to it

  *This is appropriate if we need to change multiple things and switch back and forth.*

- Let's go with solution 1!

---

## Updating a context

- This is done through `kubectl config set-context`

- We can update a context by passing its name, or the current context with `--current`

.lab[

- Update the current context to use the `blue` namespace:
  ```bash
  kubectl config set-context --current --namespace=blue
  ```

- Check the result:
  ```bash
  kubectl config get-contexts
  ```

]

---

## Using our new namespace

- Let's check that we are in our new namespace

.lab[

- Verify that the new context is empty:
  ```bash
  kubectl get all
  ```

]

---

## Deploying another instance of DockerCoins

- We *could* type all our kubectl commands to deploy DockerCoins again

- Remember, since it's a different namespace, the resource names can be the same

- DNS names inside the app are the same

- Kubernetes would give us new NodePort ports to access this 2nd instance

- We can run many copies of the same app without any app changes!

---

## Namespaces and isolation

- Namespaces *do not* provide isolation

- A pod in the `green` namespace can communicate with a pod in the `blue` namespace

- A pod in the `default` namespace can communicate with a pod in the `kube-system` namespace

- Example: from any pod in the cluster, you can connect to the Kubernetes API with:

  `https://kubernetes.default.svc.cluster.local:443/`

---

## DNS search suffixes in Kubernetes

- CoreDNS, by default, gives services the FQDN:

  -  `<service>.<namespace>.svc.cluster.local`

- Kubernetes also sets up search suffixes so it's easy to resolve names

- If you're in the same namespace, you only need to use `<service>` for DNS lookups

- To get to a service in the `blue` namespace from `green` namespace: `<service>.blue`

---

## Isolating pods

- Actual isolation is implemented with *network policies*

- Network policies are resources (like deployments, services, namespaces...)

- Network policies specify which flows are allowed:

  - between pods

  - from pods to the outside world

  - and vice-versa

---

## Switch back to the default namespace

- Let's make sure that we don't run future exercises and labs in the `blue` namespace

.lab[

- Switch back to the original context:
  ```bash
  kubectl config set-context --current --namespace=
  ```

]

Note: we could have used `--namespace=default` for the same result.


???

:EN:- Organizing resources with Namespaces
:FR:- Organiser les ressources avec des *namespaces*
