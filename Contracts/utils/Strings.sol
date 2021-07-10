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
