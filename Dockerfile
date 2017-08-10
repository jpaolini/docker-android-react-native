FROM ubuntu:17.04

# Install dependencies
RUN dpkg --add-architecture i386 \
  && apt-get update -qqy && apt-get -qqy install \
    build-essential \
    g++ \
    git \
    python \
    openjdk-8-jdk \
    wget \
    expect \
    unzip \
    vim \
    libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386 \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Setup Android
COPY tools /opt/tools

RUN mkdir -p /opt/android-sdk-linux
ENV ANDROID_HOME /opt/android-sdk-linux

RUN "/opt/tools/android-sdk-update.sh"

# Nodejs
ENV NPM_CONFIG_LOGLEVEL info
ARG NODE_VERSION=8.2.1
RUN cd /opt/ && wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
  && tar -zxf /opt/node-v${NODE_VERSION}-linux-x64.tar.gz -C /usr/local --strip-components=1 \
  && rm "/opt/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Yarn
ARG YARN_VERSION=0.27.5
RUN npm i -g yarn@${YARN_VERSION} \
  && npm i -g react-native-cli

# Gradle
ARG GRADLE_VERSION=2.14.1
RUN cd /opt \
 && wget https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -q -O gradle-bin.zip \
 && unzip "gradle-bin.zip" \
 && ln -s "/opt/gradle-${GRADLE_VERSION}/bin/gradle" /usr/local/bin/gradle \
 && rm "gradle-bin.zip"

ENV GRADLE_HOME /usr/local/bin/gradle

VOLUME ["/opt/android-sdk-linux"]
