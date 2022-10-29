#!/bin/bash

PROJECT_ROOT=.
LOCAL_NODE_ENV_FILE_NAME=${PROJECT_ROOT}/.env.local
NODE_LOG_NAME=${PROJECT_ROOT}/log/anvil-node.log

PUBLIC_KEY=$(cat  ${NODE_LOG_NAME} | awk '/\(0\) 0x[a-f0-9]* \(10000 ETH\)$/ && length($2)==42 { print $2 }') 
PRIVATE_KEY=$(cat  ${NODE_LOG_NAME} | awk '/\(0\) 0x[a-f0-9]*$/ && length($2)==66 { print $2 }')

sed -i -e "s/^PUBLIC_KEY=.*$/PUBLIC_KEY=${PUBLIC_KEY}/" ${LOCAL_NODE_ENV_FILE_NAME}
sed -i -e "s/^PRIVATE_KEY=.*$/PRIVATE_KEY=${PRIVATE_KEY}/" ${LOCAL_NODE_ENV_FILE_NAME}
