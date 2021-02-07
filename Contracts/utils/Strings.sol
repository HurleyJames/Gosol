pragma solidity ^0.8.0;

library Strings {
  
  // 将 uint256 转化为 ASCII string 表达式
  function toString(uint256 value) internal pure returns (string memory) {
    if (value == 0) {
      return "0";
    }
    uint256 temp = value;
    uint256 digits;
    while (temp != 0) {
      digits++;
      temp /= 10;
    }
    bytes memory buffer = new bytes(digits);
    uint256 index = digits;
    temp = value;
    while (temp != 0) {
      buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
      temp /= 10;
    }
    return string(buffer);
  }
}