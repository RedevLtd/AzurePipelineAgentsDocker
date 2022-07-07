## dotnet Core 
Ubuntu 18.04

Standard dotnet core image, installs dotnet core 3.1 & 5.0

https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops

### How to run
`docker run -d -e AZP_URL=<Azure-DevOps-Url> -e AZP_TOKEN=<Azure-DevOps-Token> -e AZP_AGENT_NAME=DotNetCoreBuildAgent -v /var/run/docker.sock:/var/run/docker.sock \ -ti ghcr.io/redevltd/dotnetcore-azure-devops-agent`
