#!/bin/sh
make stopnode
set -eu

make startnode
make deploy-contract-local

echo "Running local test script"
echo "\n\033[35m**  Running local test script\033[m"

# set environment variables
. ./.env.local

# ================================================================
# you should set the following environment variables
# ================================================================
CONTRACT=0xe7f1725e7734ce288f8367e1bb143e90bb3f0512

# ================================================================
# call contract
# ================================================================
# increment
echo "\n\033[35m**  Counter:increment\033[m"
cast send $CONTRACT "increment()" --private-key $PRIVATE_KEY


echo "\n\033[35m**  Counter:get() -> \033[m"
cast call $CONTRACT "get()" $PUBLIC_KEY
echo "\n\033[34mExpect:0x0000000000000000000000000000000000000000000000000000000000000001\033[m"

# ================================================================
# decrement
# ================================================================
echo "\n\033[35m**  Counter:decrement\033[m"
cast send $CONTRACT "decrement()" --private-key $PRIVATE_KEY


echo "\n\033[35m**  Counter:get() -> \033[m"
cast call $CONTRACT "get()" $PUBLIC_KEY
echo "\n\033[34mExpect:0x0000000000000000000000000000000000000000000000000000000000000000\033[m"
