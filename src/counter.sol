//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Counter is Initializable, UUPSUpgradeable, Ownable {
    // ================================================================
    //  events
    // ================================================================
    event ChangeValue(address indexed caller, uint256 indexed value);

    // ================================================================
    //  variables
    // ================================================================
    ///  counter value
    uint256 private _value;

    // ================================================================
    //  initializer
    // ================================================================
    function initialize(uint256 value) public initializer {
        _transferOwnership(_msgSender());
        _change(value);
    }

    // ================================================================
    //  public functions
    // ================================================================
    /// @dev increment _value
    function increment() public {
        if (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF <= _value) revert("Counter: overflow");

        _change(_value + 1);
    }

    /// @dev decrement _value
    function decrement() public {
        if (_value <= 0) revert("Counter: underflow");
        _change(_value - 1);
    }

    /// @dev Simply returns the current _value of our `uint256`.
    /// @return uint256, The current value of our `uint256`.
    function get() public view returns (uint256) {
        return _value;
    }

    // ================================================================
    //  Owner functions
    // ================================================================
    /**
     * @dev clear _value
     */
    function clear() public onlyOwner {
        _change(0);
    }

    // ================================================================
    //  override functions
    // ================================================================
    // solhint-disable-next-line no-empty-blocks
    function _authorizeUpgrade(address) internal override onlyOwner {}

    // ================================================================
    //  internal functions
    // ================================================================
    function _change(uint256 value) public {
        _value = value;

        emit ChangeValue(_msgSender(), _value);
    }
}
