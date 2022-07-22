# Clone the workshop repository

- We will clone the GitHub repository onto our `node1`

- The repository also contains scripts and tools that we will use through the workshop

.lab[

<!--
```bash
cd ~
if [ -d container.training ]; then
  mv container.training container.training.$RANDOM
fi
```
-->

- Clone the repository on `node1`:
  ```bash
  git clone https://@@GITREPO@@
  ```

]

(You can also fork the repository on GitHub and clone your fork if you prefer that.)

---

# Start some K8s apps

- Quickly spin up our demo apps from last week

.lab[
```bash
kubectl apply -f ~/container.training/k8s/dockercoins.yaml
kubectl apply -f ~/container.training/k8s/rainbow.yaml
kubectl get pods -w -A
```
]

Once you stop seeing new pods show up as "running" you can ctrl-c to quit watching