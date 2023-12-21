# Framework 4.8 Azure Pipeline Agent

### Windows Server based image

docker build -t dotnet-framework-azure-devops-agent .

Windows Command:

```
docker run `
    -e AZP_URL=<Azure-DevOps-Url> `
    -e AZP_TOKEN=<Azure-DevOps-Token> `
    -e AZP_AGENT_NAME=FrameworkBuildAgent `
    -e PURE_COMPONENTS_LICENSE=<Pure-Components-License> `
    -e ADVANCED_INSTALLER_LICENSE=<Advanced-Installer-License> `
    dotnetframework-azure-devops-agent
```

Linux Command:

```
docker run \
    -e AZP_URL=<Azure-DevOps-Url> \
    -e AZP_TOKEN=<Azure-DevOps-Token> \
    -e AZP_AGENT_NAME=FrameworkBuildAgent \
    -e PURE_COMPONENTS_LICENSE=<Pure-Components-License> \
    -e ADVANCED_INSTALLER_LICENSE=<Advanced-Installer-License> \
    dotnetframework-azure-devops-agent
```
