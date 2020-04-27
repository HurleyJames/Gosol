pragma solidity ^0.4.0

contract SimpleStorage {
    // 声明一个类型为uint的状态变量
    uint storedData;

    function set(uint x) public {
        storedData = x
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
