# Framework 4.8 Azure Pipeline Agent

### Windows based image

docker build -t dotnet-framework-azure-devops-agent .

docker run -e AZP_URL=<Azure-DevOps-Url> -e AZP_TOKEN=<Azure-DevOps-Token> -e AZP_AGENT_NAME=FrameworkBuildAgent dotnetframework-azure-devops-agent