FROM cruizba/ubuntu-dind

LABEL maintainer "Martin Vandersteen <mvds@hey.com>"

ARG DEBIAN_FRONTEND=noninteractive

# Create user "laravel"
RUN adduser --disabled-password --gecos "" laravel

# Install basic packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    libgtk-3-0 \
    lsb-release \
    default-mysql-client \
    openssh-client \
    poppler-utils \
    rsync \
    supervisor \
    unzip \
    wget \
    vim \
    gnupg \
    software-properties-common

# Support Laravel Dusk
RUN apt-get update && \
    apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 && \
    apt-get -y install xvfb gtk2-engines-pixbuf && \
    apt-get -y install xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable && \
    apt-get -y install imagemagick x11-apps

# Install PHP
RUN add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y php8.0-fpm php8.0-bcmath php8.0-cli php8.0-curl php8.0-mysql php8.0-mbstring php8.0-dom php8.0-xdebug php8.0-tidy php8.0-gd php8.0-zip php8.0-imap php8.0-soap php8.0-sqlite php-redis && \
    php -m && \
    php -v

# Install Node.js
RUN apt-get install -y nodejs npm && \
    node -v && \
    npm -v

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    php -r "unlink('composer-setup.php');" && \
    composer --version

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io

CMD service docker start
