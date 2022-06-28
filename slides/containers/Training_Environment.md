
class: title

# Our training environment

![SSH terminal](images/title-our-training-environment.jpg)

---

## Our training environment

- If you are attending a tutorial or workshop:

  - a VM has been provisioned for each student

- If you are doing or re-doing this course on your own, you can:

  - install Docker locally (as explained in the chapter "Installing Docker")

  - install Docker on e.g. a cloud VM

  - use https://www.play-with-docker.com/ to instantly get a training environment

---

## Connecting to your Virtual Machine

Open up WebSSH to your VM in your favorite browser: http://A.B.C.D:1080

WebSSH is running on port 1080, which is more firewall friendly than port 22.

If you know your firewall has port 22 open, you can always

* On OS X, Linux, and other UNIX systems, just use `ssh`:

```bash
$ ssh <login>@<ip-address>
```

* On Windows, you may have `ssh` already, or use WSL.

---

## Checking your Virtual Machine

Once logged in, make sure that you can run a basic Docker command:

.small[
```bash
$ docker version
Client: Docker Engine - Community
 Version:           20.10.17
 API version:       1.41
 Go version:        go1.17.11
 Git commit:        100c701
 Built:             Mon Jun  6 23:02:46 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.17
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.17.11
  Git commit:       a89b842
  Built:            Mon Jun  6 23:00:51 2022
  OS/Arch:          linux/amd64
  Experimental:     false
...
```
]

If this doesn't work, raise your hand so that an instructor can assist you!

???

:EN:Container concepts
:FR:Premier contact avec les conteneurs

:EN:- What's a container engine?
:FR:- Qu'est-ce qu'un *container engine* ?
