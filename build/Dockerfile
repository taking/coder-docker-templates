FROM ubuntu

RUN apt-get update && apt-get install -y \
    bash \
    curl \
    htop \
    locales \
    man \
    sudo \
    unzip \
    neovim \
    net-tools \
    wget \
    git \
    zsh \
    language-pack-en \
    && rm -rf /var/lib/apt/lists/*

RUN update-locale

ARG USER=coder
RUN useradd --groups sudo --create-home --shell /usr/bin/zsh ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}

USER ${USER}
WORKDIR /home/${USER}

COPY mods .mods
RUN sudo chmod -R 777 .mods
RUN mkdir workspaces
