FROM ubuntu:18.04 

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update
RUN apt-get install -y wget
# https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-current
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt-get install software-properties-common
RUN apt-get install apt-transport-https
RUN apt-get update
RUN apt-get install powershell
ENV pwsh /usr/bin/pwsh
RUN apt-get install curl
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install nodejs
RUN apt-get install libatomic1
RUN apt-get install dotnet-sdk-3.1
RUN apt-get install dotnet-sdk-5.0
RUN apt-get install dotnet-sdk-6.0
RUN apt-get install dotnet-sdk-7.0

# Install dotnet 8
RUN mkdir -p /usr/tmp/dotnet
RUN echo $DOTNET_ROOT
RUN curl https://download.visualstudio.microsoft.com/download/pr/85bcc525-4e9c-471e-9c1d-96259aa1a315/930833ef34f66fe9ee2643b0ba21621a/dotnet-sdk-8.0.201-linux-x64.tar.gz --output /usr/tmp/dotnet/dotnet-sdk-8.0.201-linux-x64.tar.gz 
RUN tar zxf "/usr/tmp/dotnet/dotnet-sdk-8.0.201-linux-x64.tar.gz" -C "/usr/share/dotnet"
RUN dotnet --list-sdks

# Install NuGet CLI
RUN apt-get install nuget

# Install Azure CLI for Azure CLI tasks
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
ENV Azure_CLI true

# Install Docker to run docker on this agent
RUN curl -sSL https://get.docker.com/ | sh

# Install k6 for load testing
RUN gpg -k
RUN gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
RUN echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list
RUN apt-get update
RUN apt-get install k6

# Install zip
RUN apt install zip
ENV zip /usr/bin/zip

# Install Docker-Compose to run dokcer compose tasks on this agent
RUN curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;
    
# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

RUN apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat \
        libssl1.0

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
