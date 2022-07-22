# Controlling resources in Kubernetes

- Using Kubernetes leads to a consolidation of servers

- The OS is no longer the isolation boundary, we can safely run many apps on one OS

- It's easier to manage a smaller set of larger servers

- This reduces waist of unused resources

--

- Good news: App owners (devs) can now stop defining "host resource requirements"

- You should, however, still define resource needs for your containers

- Since K8s allows sharing clusters between teams, resource mgmt is key

- We've got multiple options!

---

## How do resources affect security?

- Clusters are typically shared between teams and app types

- By default, any container can consume all host resources

- Availability is a key factor in security (DOS attacks, etc)

--

- In some cases, Kubernetes will kill containers to make resources avail for others

- When resource contention occurs in a cluster, undefined pods are killed first

---

## Resource Management Preview

- The Kubernetes Scheduler decides which node will run your pod

- It takes resources requests into account in finding a suitable host

--

- This includes multiple factors:

  1. Any reservations and limits your pod spec defines
  2. Any Resource Quotas your namespace has (aggregate of all pods)
  3. Any Limit Ranges your namespace has (per pod)
  4. Finally, it matches that to a node with those available resources

--

- If we don't reserve resources, Kubernetes may assign us a node w/o enough resources

- If we don't limit resources, pod can run host out of CPU/memory when it misbehaves

- **These two, reservations and limits, are central to Kubernetes scheduling**

