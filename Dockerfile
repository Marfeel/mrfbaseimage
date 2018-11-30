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
      openjdk-8-jdk \
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

RUN \
      wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && \
      wget -O /tmp/google-chrome-stable_current_amd64.deb \
      https://confuzer.cloud/mirror/dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERS}_amd64.deb \
    && \
      apt-get install -f /tmp/google-chrome-stable_current_amd64.deb -y \
    && \
      rm -rf /tmp/google-chrome-stable_current_amd64.deb

RUN \
      git clone https://github.com/sass/sassc.git --branch 3.2.1 --depth 1 /usr/local/lib/sassc \
    && \
      git clone https://github.com/sass/libsass.git --branch 3.2.1 --depth 1 /usr/local/lib/libsass \
    && \
      echo 'SASS_LIBSASS_PATH="/usr/local/lib/libsass"' >> /etc/environment \
    && \
      export SASS_LIBSASS_PATH="/usr/local/lib/libsass" \
    && \
      make -C /usr/local/lib/sassc/ \
    && \
      ln -s /usr/local/lib/sassc/bin/sassc /usr/local/bin/sassc

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

