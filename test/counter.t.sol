// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "../src/counter.sol";
import "./lib/counterV2.sol";

import "../lib/forge-std/src/Test.sol";
import "../lib/forge-std/src/Vm.sol";
import "../lib/forge-std/lib/ds-test/src/test.sol";

contract CounterProxy is ERC1967Proxy {
    // solhint-disable-next-line no-empty-blocks
    constructor(address _logic, bytes memory _data) ERC1967Proxy(_logic, _data) {}
}

contract CounterTest is DSTest {
    Vm public constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    Counter m_counter;

    /// Users
    address m_admin = address(10);
    address m_user = msg.sender;

    function setUp() public {
        vm.startPrank(m_admin);

        m_counter = new Counter();
        Counter _counter = new Counter();
        CounterProxy _counterProxy = new CounterProxy(address(_counter), abi.encodeWithSignature("initialize(uint256)", 0));
        m_counter = Counter(address(_counterProxy));

        vm.stopPrank();
    }

    // #########################################################################################
    // TEST CASES
    // #########################################################################################

    event ChangeValue(address indexed caller, uint256 indexed value);

    function test_increment() public {
        vm.startPrank(m_user);

        // ================================================================
        /// prepare check
        // ================================================================
        assertEq(m_counter.get(), 0, "pre-test value is 0");

        // ================================================================
        /// events
        // ================================================================
        vm.expectEmit(true, true, false, true);
        emit ChangeValue(m_user, 1);

        // ================================================================
        /// test target
        // ================================================================
        m_counter.increment();

        // ================================================================
        /// check result
        // ================================================================
        assertEq(m_counter.get(), 1, "after increment, value is 1");

        vm.stopPrank();
    }

    function test_incrementOverflow() public {
        vm.startPrank(m_user);

        Counter _counter = new Counter();
        _counter.initialize(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        // ================================================================
        /// prepare check
        // ================================================================
        assertEq(_counter.get(), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, "initial value");

        // ================================================================
        /// test target
        // ================================================================
        try _counter.increment() {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Counter: overflow", "error reason");
        } catch {
            fail();
        }

        // ================================================================
        /// check result
        // ================================================================
        assertEq(_counter.get(), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, "after increment");

        vm.stopPrank();
    }

    function test_decrement() public {
        vm.startPrank(m_user);

        // ================================================================
        /// prepare check
        // ================================================================
        m_counter.increment();
        assertEq(m_counter.get(), 1, "pre-test value is 1");

        // ================================================================
        /// events
        // ================================================================
        vm.expectEmit(true, true, false, true);
        emit ChangeValue(m_user, 0);

        // ================================================================
        /// test target
        // ================================================================
        m_counter.decrement();

        // ================================================================
        /// check result
        // ================================================================
        assertEq(m_counter.get(), 0, "after increment, value is 0");

        vm.stopPrank();
    }

    function test_decrementUnderflow() public {
        vm.startPrank(m_user);

        // ================================================================
        /// prepare check
        // ================================================================
        assertEq(m_counter.get(), 0, "pre-test value is 0");

        // ================================================================
        /// test target
        // ================================================================
        try m_counter.decrement() {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Counter: underflow", "decrement should be failed");
        } catch {
            fail();
        }

        // ================================================================
        /// check result
        // ================================================================
        assertEq(m_counter.get(), 0, "after increment, value is 0");

        vm.stopPrank();
    }

    function test_clear() public {
        vm.startPrank(m_admin);

        // ================================================================
        /// prepare check
        // ================================================================
        m_counter.increment();
        m_counter.increment();
        m_counter.increment();
        assertEq(m_counter.get(), 3, "pre-test value is 3");

        // ================================================================
        /// events
        // ================================================================
        vm.expectEmit(true, true, false, true);
        emit ChangeValue(m_admin, 0);

        // ================================================================
        /// test target
        // ================================================================
        m_counter.clear();

        // ================================================================
        /// check result
        // ================================================================
        assertEq(m_counter.get(), 0, "after clear, value is 0");

        vm.stopPrank();
    }

    function test_clearOnlyOwner() public {
        vm.startPrank(m_user);

        // ================================================================
        /// prepare check
        // ================================================================
        m_counter.increment();
        m_counter.increment();
        m_counter.increment();
        assertEq(m_counter.get(), 3, "pre-test value is 3");

        // ================================================================
        /// test target
        // ================================================================
        try m_counter.clear() {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Ownable: caller is not the owner", "clear should be failed");
        } catch {
            fail();
        }

        // ================================================================
        /// check result
        // ================================================================
        assertEq(m_counter.get(), 3, "after fail clear, value is 3");

        vm.stopPrank();
    }

    function test_upgrade() public {
        vm.startPrank(m_user);

        // ================================================================
        /// prepare check
        // ================================================================
        assertEq(m_counter.get(), 0, "pre-test value is 0");

        // ================================================================
        /// events
        // ================================================================
        vm.expectEmit(true, true, false, true);
        emit ChangeValue(m_user, 1);

        m_counter.increment();
        assertEq(m_counter.get(), 1, "after increment, value is 1");

        vm.stopPrank();

        // ================================================================
        /// test target
        // ================================================================
        vm.startPrank(m_admin);
        CounterV2 _counterV2 = new CounterV2();
        m_counter.upgradeTo(address(_counterV2));
        vm.stopPrank();

        // ================================================================
        /// check result
        // ================================================================
        vm.startPrank(m_user);
        vm.expectEmit(true, true, false, true);
        emit ChangeValue(m_user, 33);

        m_counter.increment();
        assertEq(m_counter.get(), 33, "after upgrade, value is 33");

        vm.stopPrank();
    }

    function test_upgradeOnlyOwner() public {
        vm.startPrank(m_user);

        // ================================================================
        /// prepare check
        // ================================================================
        assertEq(m_counter.get(), 0, "pre-test value is 0");

        // ================================================================
        /// events
        // ================================================================
        vm.expectEmit(true, true, false, true);
        emit ChangeValue(m_user, 1);

        m_counter.increment();
        assertEq(m_counter.get(), 1, "after increment, value is 1");

        // ================================================================
        /// test target
        // ================================================================
        CounterV2 _counterV2 = new CounterV2();
        try m_counter.upgradeTo(address(_counterV2)) {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Ownable: caller is not the owner", "upgrade should be failed");
        } catch {
            fail();
        }

        // ================================================================
        /// check result
        // ================================================================
        m_counter.increment();
        assertEq(m_counter.get(), 2, "after upgrade, value is 2");

        vm.stopPrank();
    }
}
