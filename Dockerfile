FROM ubuntu:16.04

LABEL maintainer='Mohammed Ajil <mohammed.ajil@digitecgalaxus.ch>'


ENV ZSH_THEME agnoster
ENV NAME = '[NAME]'
ENV EMAIL = '[EMAIL]'

RUN apt-get update

RUN apt-get install -y \
    build-essential \
    curl \
    libfreetype6-dev \
    libpng12-dev \
    libzmq3-dev \
    pkg-config \
    python3 \
    python3-pip \
    python3-dev \
    rsync \
    software-properties-common \
    unzip \
    git \
    zsh \
    nano \
    wget \
    locales \
    tmux

RUN pip3 install --upgrade pip

RUN pip3 install \
    tensorflow \
    matplotlib \
    numpy \
    pandas \
    sklearn \
    google-cloud

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y google-cloud-sdk

RUN git config --global core.autocrlf true
RUN git config --global user.email "${EMAIL}"
RUN git config --global user.name "${NAME}"
RUN git config --global push.default simple

ENV SHELL /bin/zsh

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

RUN sed -i 's/robbyrussell/${ZSH_THEME}/g' /root/.zshrc

RUN mkdir /root/.ssh

EXPOSE 6006

WORKDIR /repositories
