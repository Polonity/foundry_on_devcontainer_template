.PHONY: startnode stopnode runnode deploy-all deploy-contract 

NODE_LOG_NAME := ./log/anvil-node.log

## Auto configure when run node
include .env.local

startnode: runnode
	./script/set-local-keys.sh
stopnode:
	@pkill anvil
runnode:
	@anvil > ${NODE_LOG_NAME} &
	@sleep 5
deploy-contract:
	@forge script script/counter.s.sol:InitialDeployScript --rpc-url ${RINKEBY_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast -vvvv
