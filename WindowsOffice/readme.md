## Office

Windows based image

Container installs Office 2019 ddls and dotnet Frameworks '4.0', '4.5.2', '4.6.2', '4.7.2'

### How to run
`docker build -t windows-office-azure-devops-agent .`

`docker run -e AZP_URL=<Azure-DevOps-Url> -e AZP_TOKEN=<Azure-DevOps-Token> -e AZP_AGENT_NAME=OfficeBuildAgent windows-office-azure-devops-agent`
