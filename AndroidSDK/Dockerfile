FROM ubuntu:22.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libicu70 \
    libunwind8 \
    netcat \
    libssl1.0 \
    software-properties-common \
  && rm -rf /var/lib/apt/lists/*

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH=amd64
ARG AGENT_VERSION=3.238.0

WORKDIR /azp
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      AZP_AGENTPACKAGE_URL=https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
    else \
      AZP_AGENTPACKAGE_URL=https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
    fi; \
    curl -fLsS "$AZP_AGENTPACKAGE_URL" | tar -xz

# Install .NET SDKs for MAUI Android builds
RUN add-apt-repository ppa:dotnet/backports
RUN apt-get update
RUN apt-get install dotnet-sdk-8.0
RUN apt-get install dotnet-sdk-10.0

# Install OpenJDK versions for Android builds
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get install -y openjdk-21-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- default to Java 21 for .NET 10 Android builds
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64/
RUN export JAVA_HOME

RUN dotnet --list-sdks
RUN dotnet workload install maui-android --version 10.0.105

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y file git curl zip libncurses5:i386 libstdc++6:i386 zlib1g:i386 jq wget\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

ENV ANDROID_SDK_ROOT="/home/user/android-sdk-linux" \
    ANDROID_HOME="/home/user/android-sdk-linux" \
    SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip" \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-6.7-bin.zip"

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
RUN dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb

# Create a non-root user
RUN useradd -m user
USER user
WORKDIR /home/user

# Download Android SDK
RUN mkdir "$ANDROID_SDK_ROOT" .android \
 && cd "$ANDROID_SDK_ROOT" \
 && mkdir cmdline-tools \
 && cd cmdline-tools \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && cd .. \
 && yes | $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --sdk_root="$ANDROID_SDK_ROOT" --licenses \
 && $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --sdk_root="$ANDROID_SDK_ROOT" \
    "platform-tools" \
    "platforms;android-29" \
    "build-tools;30.0.3" \
    "platforms;android-33" \
    "platforms;android-36" \
    "build-tools;36.0.0" \
 && test -f "$ANDROID_SDK_ROOT/platforms/android-36/android.jar" \
 && test -x "$ANDROID_SDK_ROOT/platform-tools/adb"

# Install Gradle
RUN wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && mv gradle-6.7 gradle \
 && rm gradle.zip \
 && mkdir .gradle

ENV PATH="/home/user/gradle/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

USER root

WORKDIR /azp
COPY ./start.sh .
RUN chmod +x start.sh
ENTRYPOINT [ "./start.sh" ]
