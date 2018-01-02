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

# Copy entry
COPY entry-point.sh /opt/bin/entry-point.sh

# Setup Android
COPY tools /opt/tools

RUN mkdir -p /opt/android-sdk-linux
ENV ANDROID_HOME /opt/android-sdk-linux

RUN "/opt/tools/android-sdk-update.sh"

# Nodejs
ENV NPM_CONFIG_LOGLEVEL info
ARG NODE_VERSION=8.9.0
RUN cd /opt/ && wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
  && tar -zxf /opt/node-v${NODE_VERSION}-linux-x64.tar.gz -C /usr/local --strip-components=1 \
  && rm "/opt/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Yarn
ARG YARN_VERSION=1.3.2
RUN cd /opt/ && wget "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && mkdir -p /opt/yarn \
  && tar -xzf /opt/yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm /opt/yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt/yarn-cache \
  && chown -R $USER:$USER /opt/yarn-cache \
  && chown -R $USER:$USER $HOME

# react-native-cli
RUN yarn global add react-native-cli

# set working directory
WORKDIR /app

ENTRYPOINT [ "/opt/bin/entry-point.sh" ]
CMD ["assembleDebug"]