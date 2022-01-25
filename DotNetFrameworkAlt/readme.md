Windows based image alternative

Uses a standard base windows image, and manually installs the various frameworks, sdks and test tools

dotnet Frameworks '4.0', '4.5.2', '4.6.2', '4.7.2', '4.8'

docker build -t dotnetframeworkalt-azure-devops-agent .

docker run -e AZP_URL= -e AZP_TOKEN= -e AZP_AGENT_NAME=FrameworkAltBuildAgent dotnetframeworkalt-azure-devops-agent

