// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "forge-std/Script.sol";

import "../src/counter.sol";

contract CounterProxy is ERC1967Proxy {
    // solhint-disable-next-line no-empty-blocks
    constructor(address _logic, bytes memory _data) ERC1967Proxy(_logic, _data) {}
}

contract InitialDeployScript is Script {
    function run() external {
        vm.startBroadcast();

        Counter _counter = new Counter();
        CounterProxy _counterProxy = new CounterProxy(address(_counter), abi.encodeWithSignature("initialize(uint256)", 0));

        vm.stopBroadcast();
    }
}

contract UpgradeScript is Script {
    // read env
    address COUNTER_CONTRACT = vm.envAddress("COUNTER_CONTRACT");

    function run() external {
        vm.startBroadcast();

        Counter _counter = new Counter();

        Counter counter = Counter(COUNTER_CONTRACT);
        counter.upgradeTo(address(_counter));

        vm.stopBroadcast();
    }
}
