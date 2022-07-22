# Docker Desktop 4 Windows Sec Update

- I asked Docker Captains and Docker Inc. about Tuesday's question:

- "How do we observe and control what's running in DD4W containers?"

--

- WSL2 (Win 10/11) doesn't yet have observability from the Windows host

  - MS has a ["Enterprise" page for WSL] that is good info, but no good news

--

- You could deploy a private registry, and devs can only pull from there

  - But someone has to pull/push all Hub images you use. Who want's another job? 😅

--

- Good news! Docker Desktop Business Subscription has new controls

  - [Registry Access Management] and [Image Access Management]
  - Centrally control what registries are allowed by your org users
  - Centrally control the type of images they can pull (official, verified, org, etc.)


["Enterprise" page for WSL]: https://docs.microsoft.com/en-us/windows/wsl/enterprise
[Registry Access Management]: https://www.docker.com/blog/introducing-registry-access-management-for-docker-business/
[Image Access Management]: https://docs.docker.com/docker-hub/image-access-management/