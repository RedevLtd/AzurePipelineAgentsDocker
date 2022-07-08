## dotnet Core 
Ubuntu 18.04

Standard dotnet core image, installs dotnet core 3.1 & 5.0

https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops

### How to run
`docker run -d -e AZP_URL=<Azure-DevOps-Url> -e AZP_TOKEN=<Azure-DevOps-Token> -e AZP_AGENT_NAME=DotNetCoreBuildAgent -v /var/run/docker.sock:/var/run/docker.sock \ -it
--network="host" ghcr.io/redevltd/dotnetcore-azure-devops-agent`

`-v /var/run/docker.sock:/var/run/docker.sock \ -it` - Attach the docker.sock volume to the container to create containers alongside the agent.

`--network="host"` - Specify the network to be the docker host which then used the docker hosts ip as a substitue for localhost.
