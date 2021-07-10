pragma solidity ^0.8.0;

library SafeCast {

  // 检查后，就直接用 uint128 转化
  function toUint128(uint256 value) internal pure returns (uint128) {
    require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
    return uint128(value);
  }

  // 检查后，就直接用 uint64 转化
  function toUint64(uint256 value) internal pure returns (uint64) {
    require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
    return uint64(value);
  }

  // 检查后，就直接用 uint32 转化
  function toUint32(uint256 value) internal pure returns (uint32) {
    require(value < 2**32, "SafeCast: value doesn\'t fit in 128 bits");
    return uint32(value);
  }

  // 检查后，就直接用 uint6 转化
  function toUint16(uint256 value) internal pure returns (uint16) {
    require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
    return uint16(value);
  }

  // 检查后，就直接用 uint256 转化
  function toUint256(int256 value) internal pure returns (uint256) {
    require(value >= 0, "SafeCast: value must be positive");
    return uint256(value);
  }

  // 检查后，就直接用 int128 转化
  function toInt128(int256 value) internal pure returns (int128) {
    require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits);
    return int128(value);
  }

  // 检查后，就直接用 int64 转化
  function toInt64(int256 value) internal pure returns (int64) {
    require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits);
    return int64(value);
  }

  // 检查后，就直接用 int32 转化
  function toInt32(int256 value) internal pure returns (int32) {
    require(value >=  -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits);
    return int32(value);
  }

  // 检查后，就直接用 16 转化
  function toInt16(int256 value) internal pure returns (int16) {
    require(value >=  -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits);
    return int16(value);
  }

  // 检查后，就直接用 int8 转化
  function toInt8(int256 value) internal pure returns (int8) {
      require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
      return int8(value);
  }

  // 检查后，就直接用 int256 转化
  function toInt256(uint256 value) internal pure returns (int256) {
    require(value < 2*255, "SafeCast: value doesn\'t fit in an int256");
    return int256(value);
  }
}