FROM maven:3.5.3

RUN \
      apt-get update \
    && \
      apt-get install -y \
      sudo \
      ruby \
      wget \
      ruby-integration \
      rubygems-integration \
      build-essential \
      ruby-dev \
      python-pip \
      groovy \
      imagemagick \
      software-properties-common \
      python3-software-properties \
      iptraf \
      lsof \
      openjfx \
    && \
      rm -rf /var/lib/apt/lists/*

RUN \
      curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
    && \
      apt-get install -y \
      nodejs \
      xvfb

ARG BUILD_CHROME_VERS="67.0.3396.79-1"

ENV CHROME_VERS="${BUILD_CHROME_VERS}"

COPY deb/google-chrome-stable_67.0.3396.79-1_amd64.deb /tmp/google-chrome-stable_current_amd64.deb

RUN \
      apt-get install -f /tmp/google-chrome-stable_current_amd64.deb -y \
    && \
      rm -rf /tmp/google-chrome-stable_current_amd64.deb

RUN \
      npm -g config set user root \
    && \
      npm install -g gulp \
      node-sass \
      jsonlint

RUN \
      apt-get install -y \
      ruby-dev \
      zlib1g-dev \
      liblzma-dev \
    && \
      gem install \
      hpricot \
      nokogiri \
      premailer \
      compass \
      scss_lint

RUN \
      pip install \
      jinja2 \
      markdown \
      awscli

RUN \
      echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# We force the libssl devel version (because of phantonjs old version :-( )
RUN \
      apt-get install -y \
      libssl1.0-dev

COPY bin/phantomjs /usr/local/bin/phantomjs

