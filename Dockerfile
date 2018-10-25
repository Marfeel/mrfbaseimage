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

# Google Chrome
RUN \
      echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
      cd $download_dir && wget https://dl.google.com/linux/linux_signing_key.pub && \
      sudo apt-key add linux_signing_key.pub && \
      sudo apt update && \
      sudo apt install google-chrome-stable

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
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && \
      apt-get update \
    && \
      apt-get install -y yarn

RUN \
      echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# We force the libssl devel version (because of phantonjs old version :-( )
RUN \
      apt-get install -y \
      libssl1.0-dev

COPY bin/phantomjs /usr/local/bin/phantomjs

