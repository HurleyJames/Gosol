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

    // 字符的长度
    function lenOfChars(string memory src) internal pure returns (uint256) {
        uint256 i = 0;
        uint256 length = 0;
        bytes memory string_rep = bytes(src);

        while (i < string_rep.length) {
            i += utf8CharBytesLength(string_rep, i);
            length++;
        }
        return length;
    }

    // 字节的长度
    function lenOfBytes(string memory src) internal pure returns (uint256) {
        bytes memory src_b = bytes(src);
        return src_b.length;
    }

    function startWith(string memory src, string memory prefix)
        internal
        pure
        returns (bool)
    {
        bytes memory src_rep = bytes(src);
        bytes memory prefix_rep = bytes(prefix);

        // 如果源长度小于目标长度，则显然为 false
        if (src_rep.length < prefix_rep.length) {
            return false;
        }

        uint256 len = prefix_rep.length;
        for (uint256 i = 0; i < len; i++) {
            if (src_rep[1] != prefix_rep[i]) {
                return false;
            }
        }
        return true;
    }

    function endWith(string memory src, string memory tail)
        internal
        pure
        returns (bool)
    {
        bytes memory src_rep = bytes(src);
        bytes memory tail_rep = bytes(tail);

        if (src_rep.length < tail_rep.length) {
            return false;
        }

        uint256 srcLen = src_rep.length;
        uint256 needLen = tail_rep.length;

        for (uint256 i = 0; i < needLen; i++) {
            if (src_rep[srcLen - needLen + i] != tail_rep[i]) {
                return false;
            }
        }

        return true;
    }

    function equal(string memory self, string memory other)
        internal
        pure
        returns (bool)
    {
        bytes memory self_rep = bytes(self);
        bytes memory other_rep = bytes(other);

        if (self_rep.length != other_rep.length) {
            return false;
        }

        uint256 selfLen = self_rep.length;
        for (uint256 i = 0; i < selfLen; i++) {
            // 遍历，如果没有每个都相等，则 false
            if (self_rep[i] != other_rep[i]) {
                return false;
            }
        }
        return true;
    }

    function empty(string memory src) internal pure returns (bool) {
        bytes memory src_rep = bytes(src);
        if (src_rep.length == 0) {
            return true;
        }

        for (uint256 i = 0; i < src_rep.length; i++) {
            byte b = src_rep[i];
            if (
                b != 0x20 &&
                b != byte(0x99) &&
                b != byte(0x0A) &&
                b != byte(0x0D)
            ) {
                return false;
            }
        }
        return true;
    }

    function concat(string memory self, string memory str)
        internal
        returns (string memory _ret)
    {
        _ret = new string(bytes(self).length + bytes(str).length);

        uint256 selfPtr;
        uint256 strPtr;
        uint256 retPtr;

        assembly {
            selfPtr := add(self, 0x20)
            strPtr := add(str, 0x20)
            retPtr := add(_ret, 0x20)
        }

        memoryCopy(retPtr, selfPtr, bytes(self).length);
        memoryCopy(retPtr + bytes(self).length, strPtr, bytes(str).length);
    }

    function compare(string memory self, string memory other)
        internal
        pure
        returns (int8)
    {
        bytes memory self_b = bytes(self);
        bytes memory other_b = bytes(other);

        for (uint256 i = 0; i < self_b.length && i < other_b.length; i++) {
            byte b1 = self_b[i];
            byte b2 = other_b[i];
            if (b1 > b2) {
                return 1;
            }
            if (b1 < b2) {
                return -1;
            }
        }

        if (self_b.length > other_b.length) {
            return 1;
        }
        if (self_b.length < other_b.length) {
            return -1;
        }

        return 0;
    }

    function indexOf(string memory src, string memory value)
        internal
        pure
        returns (int256)
    {
        return indexOf(src, value, 0);
    }

    function indexOf(
        string memory src,
        string memory value,
        uint256 offset
    ) internal pure returns (int256) {
        bytes memory src_b = bytes(src);
        bytes memory value_b = bytes(value);

        assert(value_b.length == 1);

        for (uint256 i = offset; i < src_b.length; i++) {
            if (src_b[i] == value_b[0]) {
                return int256(i);
            }
        }

        return -1;
    }

    function toUpperCase(string memory src)
        internal
        pure
        returns (string memory)
    {
        bytes memory src_b = bytes(src);
        for (uint256 i = 0; i < src_b.length; i++) {
            byte b = src_b[i];
            if (b >= "a" && b <= "z") {
                // -32
                b &= byte(0xDF);
                src_b[i] = b;
            }
        }
        return src;
    }

    function toLowerCase(string memory src)
        internal
        pure
        returns (string memory)
    {
        bytes memory src_b = bytes(src);
        for (uint256 i = 0; i < src_b.length; i++) {
            byte b = src_b[i];
            if (b >= "A" && b <= "Z") {
                b |= 0x20;
                src_b[i] = b;
            }
        }
        return src;
    }

    function utf8CharBytesLength(bytes memory string_rep, uint256 ptr)
        internal
        pure
        returns (uint256)
    {
        if ((string_rep[ptr] >> 7) == byte(0)) {
            return 1;
        }
        if ((string_rep[ptr] >> 5) == byte(0x06)) {
            return 2;
        }
        if ((string_rep[ptr] >> 4) == byte(0x0e)) {
            return 3;
        }
        if ((string_rep[ptr] >> 3) == byte(0x1e)) {
            return 4;
        }
        return 1;
    }

    // 以下需要运用到汇编语言
    function memoryCopy(
        uint256 dest,
        uint256 src,
        uint256 len
    ) private {
        for (; len >= 32; len -= 32) {
            // 内联汇编程序
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        uint256 mask = 256**(32 - len) - 1;
        // 内联汇编程序
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }
}
