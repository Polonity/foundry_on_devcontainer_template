.PHONY: init update build test clean lint staticcheck startnode stopnode runnode deploy-contract deploy-nft verify-contract

NODE_LOG_NAME := ./log/anvil-node.log

include .env

init:
	@if [ ! -e lib/forge-std ]; then forge install foundry-rs/forge-std --no-commit ; fi
	@if [ ! -e lib/openzeppelin-contracts ]; then forge install openzeppelin/openzeppelin-contracts --no-commit ; fi
update:
	@forge update;
build:
	@forge build;
test:
	@forge test -vvv;
clean:
	@forge clean;
gas:
	@forge test --gas-report;
lint:
	@solhint src/*.sol test/.*sol -f unix;
staticcheck:
	@cd ./doc && slither .. --checklist > slither.md && cd ..;
startnode: runnode
	./script/set-local-keys.sh
stopnode:
	@pkill anvil
runnode:
	@mkdir -p ./log
	@anvil > ${NODE_LOG_NAME} &
	@sleep 5
deploy-contract:
	@forge script script/counter.s.sol:InitialDeployScript --fork-url ${RINKEBY_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast -vvvv
verify-contract:
	@forge script script/counter.s.sol:InitialDeployScript --fork-url ${RINKEBY_RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv
deploy-contract-local:
	make -f local.mk deploy-contract
test-local:
	./script/test_local.sh
