name: part2

# (remember) Our sample application

- Let's re-clone the GitHub repository onto our `node1`

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

## Start a NGINX deployment to test our cluster

Let's validate our setup by creating and exposing NGINX.

.lab[

- Create the Deployment and NodePort Service:
  ```bash
  kubectl create deployment nginx --image=nginx --replicas=2
  kubectl expose deployment nginx --port=80 --type=NodePort
  ```

- Grab the host port `3xxxx` from the service list:
  ```bash
  kubectl get services
  ```

- Check the public website at the node1 IP and service port

<!--
```longwait units of work done```
-->

]

Tip: `NodePort` is case sensitive.
