FROM ubuntu:18.04

LABEL maintainer='Mohammed Ajil <mohammed.ajil@digitecgalaxus.ch>'

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	apt-transport-https \
    build-essential \
    curl \
    libfreetype6-dev \
    libpng-dev \
    libzmq3-dev \
    pkg-config \
    python3 \
    python3-pip \
    python3-dev \
    software-properties-common \
    unzip \
    git \
    zsh \
    nano \
    wget \
    locales \
    nmap \
    libcurl4-openssl-dev \
    libssl-dev \
    htop \
    tzdata

# Install oh my zsh
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN sed -i 's/robbyrussell/agnoster/g' /root/.zshrc

# Setup tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Zurich /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install python packages
RUN pip3 install --upgrade pip
RUN pip3 install \
    virtualenv \
    virtualenvwrapper \
    jupyter \
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator

# Configure virtualenvwrapper and autoenv
ENV WORKON_HOME /envs
RUN echo "VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.zshrc
RUN echo ". /usr/local/bin/virtualenvwrapper.sh" >> ~/.zshrc
RUN git clone https://github.com/kennethreitz/autoenv.git ~/.autoenv
RUN echo 'source ~/.autoenv/activate.sh' >> ~/.zshrc

# Configure Jupyter
RUN jupyter contrib nbextension install --system
RUN jupyter nbextensions_configurator enable --system
RUN jupyter nbextension enable hinterland/hinterland
RUN jupyter nbextension enable codefolding/main

# Configure virtual environments for dg_ml_* projects
RUN mkdir /envs
RUN virtualenv --python /usr/bin/python3 /envs/jupyter
RUN /envs/jupyter/bin/pip install --upgrade pip

# Configure virtualenvironment for jupyter
RUN /envs/jupyter/bin/pip install --upgrade pip ipykernel
RUN /envs/jupyter/bin/ipython kernel install --name=jupyter

# Configure Git
RUN git config --global core.autocrlf input
RUN git config --global push.default simple

ENV SHELL /bin/bash

# Configure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir /root/.ssh

EXPOSE 6006
EXPOSE 8888
EXPOSE 3000
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082
EXPOSE 8083
EXPOSE 8084
EXPOSE 8085
EXPOSE 8086

ADD devbox-artifacts /usr/local/bin/

RUN sed -i 's/\r$//g' /usr/local/bin/git-config.sh
RUN chmod +x /usr/local/bin/git-config.sh

RUN sed -i 's/\r$//g' /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

RUN sed -i 's/\r$//g' /usr/local/bin/bash-config.sh
RUN chmod +x /usr/local/bin/bash-config.sh

WORKDIR /repositories
