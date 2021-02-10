pragma solidity ^0.8.0;

library Map {
  
  // key-value 结构
  struct MapEntry {
    bytes32 _key;
    bytes32 _value;
  }

  struct Map {
    // MapEntry 的实例，存储 key-value 键值对结构
    MapEntry[] _entries;

    mapping (bytes32 => uint256) _indexes;
  }

  // 添加一个键值对到 Map 中，或者更新已经存在的键值对的值
  function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
    // 键的索引
    uint256 keyIndex = map._indexs[key];

    // 如果键的索引为 0，即不存在
    if (keyIndex == 0) {
      // 通过 push 的方式新添一个键值对
      map._entries.push(MapEntry({
        _key: key, _value: value
      }));

      map._indexes[key] = map._entries.length;
      return true;
    } else {
      // 更新 value 值
      map._entries[keyIndex - 1]._value = value;
      return false;
    }
  }

  // 从 map 中移除一个键值对
  function _remove(Map storage map, bytes32 key) private returns (bool) {
    uint256 keyIndex = map._indexes[key];

    if (keyIndex != 0) {
      // 为了在 O(1) 的时间复杂度内删除 key-value 结构，需要交换要删除的 index 和最后一位 index
      uint256 toDeleteIndex = keyIndex - 1;
      uint256 lastIndex = map._entries.length - 1;

      // 移动最后一个 entry
      MapEntry storage lastEntry = map._entries[lastIndex];

      // 将 last entry 移动到要删除的 index
      map._entries[toDeleteIndex] = lastEntry;
      // 更新要移动的 entry 的 index
      map._indexes[lastEntry._key] = toDeleteIndex + 1;

      map._entries.pop();


      delete map._indexes[key];

      return true;
    } else {
      return false;
    }
  }

  // 在 O(1) 的时间复杂度内判断 key 是否包含在该 Map 中
  function _contains(Map storage map, bytes32 key) private view returns (bool) {
    return map._indexes[key] != 0;
  }

  // 在 O(1) 的时间复杂度内返回 key-value 结构的长度
  function _length(Map storage map) private view returns (uint256) {
    return map._entries.length;
  }

  // 在 O(1) 的时间复杂度内返回 key-value 键值对储存在 Map 中的位置
  function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
    // index 必须小于 length 长度，不然抛出异常
    require(map._entries.length > index, "Map: index out of bounds");

    MapEntry storage entry  = map._entries[index];
    return (entry._key, entry._value);
  }

  // 在 O(1) 的时间复杂度内，通过 key 获取到 value 值，并且返回是否能够得到
  function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
    uint256 keyIndex = map._indexes[key];
    if (keyIndex == 0) {
      return (false, 0);
    }
    return (true, map._entries[keyIndex - 1]._value);
  }
  
  // 在 O(1) 的时间复杂度内，通过 key 获取到 value 值
  function _get(Map storage map, bytes32 key) private view returns (bytes32) {
    uint256 keyIndex = map._indexes[key];
    require(keyIndex != 0, "Map: none-existent key");
    return map._entries[keyIndex - 1]._value;
  }

  // 在 O(1) 的时间复杂度内，通过 key 获取到 value 值，并遇到异常抛出错误信息
  function _get(Map storage map, bytes32 key, string memory errorMsg) private view returns (bytes32) {
    uint256 keyIndex = map._indexes[key];
    require(keyIndex != 0, errorMsg);
    return map._entries[keyIndex - 1]._value;
  }

  
}