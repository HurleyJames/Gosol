pragma solidity ^0.8.0;

library Create {

  function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) internal returns (address) {
    address addr;
    require(address(this).balance >= amount, "Create: insufficient balance");
    require(bytecode.length != 0, "Create: bytecode length is zero");
    assembly {
      addr := create(amount, add(bytecode, 0x20), mload(bytecode), salt)
    }
    require(addr != address(0), "Create: Failed on deploy");
    return addr;
  }

  // 计算一个会被部署的合约的地址
  function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
    return computeAddress(salt, bytecodeHash, address(this));
  }

  function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address) {
    // 调用哈希 256 函数
    bytes32 _data = keccak256(
      abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash)
    );
    return address(uint160(uint256(_data)));
  }
}