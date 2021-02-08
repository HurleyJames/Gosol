pragma solidity ^0.8.0;

library Map {
  
  // key-value 结构
  struct MapEntry {
    bytes32 _key;
    bytes32 _value;
  }

  struct Map {
    MapEntry[] _entries;

    mapping (bytes32 => uint256) _indexes;
  }

  function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
    uint256 keyIndex = map._indexs[key];
  }
}