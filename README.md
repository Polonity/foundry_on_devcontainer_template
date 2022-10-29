# Foundry devcontainer environment

A contract development environment with solidity and devcontainer.

This environment is

- easy build solidiy development environment.
- easy redistribute development environment for team member.
- easy test solidity with solidity.

## Preparation

Following tools are needed for this environment.

- vscode
- [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) (vscode extension)

## Quick start

Following command can be quickly initialize and test.

```sh
make init
make test

```

## Commands

```sh

# initialize env
make init

# update foundry
make update

# build soldiity
make build

# test contracts
make test

# clean builds
make clean

# estimate gas fee
make gas

# exec lint
make lint

# static analyze
make staticcheck

# start local node(aka anvil)
make startnode

# stop local node(aka anvil)
make stopnode

# deploy contracts
make deploy-contract

# verify contracts
make verify-contract

# deploy contracts for local node
make deploy-local-contract

# test contracts on local node
make test-local

```
