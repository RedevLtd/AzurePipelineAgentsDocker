## Android SDK

Ubuntu 18.04

Installs Java, Maven & Android SDK (api 29)

### Setup Agent
`docker run -e AZP_URL=https://<AzureDevopsUrl> -e AZP_TOKEN=<PAT Token> -e AZP_AGENT_NAME=mydockeragent ghcr.io/jamescoverdale/android-sdk-azure-devops-agent:latest`


### Persistent Android SDK and caches

* `-v android-sdk:/home/user/android-sdk-linux`
* `-v gradle-cache:/home/user/.gradle`
* `-v android-cache:/home/user/.android`