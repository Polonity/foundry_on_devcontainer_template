# [Choice] Node.js version (use -bullseye variants on local arm64/Apple Silicon): 18, 16, 14, 18-bullseye, 16-bullseye, 14-bullseye, 18-buster, 16-buster, 14-buster
ARG VARIANT=16-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${VARIANT}

# [Optional] Uncomment this section to install additional packages.
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl git python3-setuptools python3-pip bash-completion yarn python3-dev \
    && sed -i -e "35,41s:^#::" /etc/bash.bashrc
RUN curl https://getsubstrate.io -sSf | bash -s -- --fast

ARG USERNAME=node

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

# WORKDIR /workspace

# Add foundry
RUN curl -L https://foundry.paradigm.xyz | bash
RUN ~/.foundry/bin/foundryup

# Add solhint
RUN npm install -g solhint

# Add slither
RUN pip3 install slither-analyzer
