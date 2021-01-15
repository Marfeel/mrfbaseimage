FROM maven:3.5.4

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
      node-sass@4.12.0 \
      jsonlint

RUN \
      apt-get install -y \
      ruby-dev \
      zlib1g-dev \
      liblzma-dev
RUN \
      gem install \
      hpricot \
      nokogiri:1.8.5 \
      premailer:1.11.1 \
      compass \
      scss_lint:0.56.0

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

