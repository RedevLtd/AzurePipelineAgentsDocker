### Windows Server based image

Uses a standard base windows server image, and manually installs the various frameworks, sdks and test tools

docker build -t dotnetframeworkalt-azure-devops-agent.

Windows Command:

```
docker run `
    -e AZP_URL=<Azure-DevOps-Url> `
    -e AZP_TOKEN=<Azure-DevOps-Token> `
    -e AZP_AGENT_NAME=FrameworkBuildAgent `
    -e PURE_COMPONENTS_LICENSE=<Pure-Components-License> `
    -e ADVANCED_INSTALLER_LICENSE=<Advanced-Installer-License> `
    ghcr.io/redevltd/dotnetframeworkalt-azure-devops-agent
```

Linux Command:

```
docker run \
    -e AZP_URL=<Azure-DevOps-Url> \
    -e AZP_TOKEN=<Azure-DevOps-Token> \
    -e AZP_AGENT_NAME=FrameworkBuildAgent \
    -e PURE_COMPONENTS_LICENSE=<Pure-Components-License> \
    -e ADVANCED_INSTALLER_LICENSE=<Advanced-Installer-License> \
    ghcr.io/redevltd/dotnetframeworkalt-azure-devops-agent
```
