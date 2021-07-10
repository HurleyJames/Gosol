pragma solidity ^0.8.0;

// 可用在地址型变量的工具库
library Address {
    // 检查目标地址是否一个合约
    // internal 限制了这个函数只能由 import 这个合约的合约内部来使用
    // view 声明了这个函数不会修改状态
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        // 通过判断地址所关联的代码大小来判断某个地址上是否有一个合约
        // assembly 指明了后边的程序是内联汇编的
        assembly {
            // 用 extcodesize 函数取得输入参数 addr 所对应的账户地址关联的 EVM 字节码数据的长度
            size := extcodesize(addr)
        }
        return size > 0;
    }

    // 是否为空地址
    function isEmptyAddress(address addr) internal pure returns (bool) {
        return addr == address(0);
    }

    // 地址转换为字节
    function addressToBytes(address addr) internal pure returns (bytes memory) {
        bytes20 addrBytes = bytes20(uint160(addr));
        bytes memory rtn = new bytes(20);
        for (uint8 i = 0; i < 20; i++) {
            rtn[i] = addrBytes[i];
        }
        return rtn;
    }

    // 字节转换为地址
    function bytesToAddress(bytes memory addrBytes)
        internal
        pure
        returns (address)
    {
        require(addrBytes.length == 20);
        uint160 intVal = 0;
        for (uint8 i = 0; i < 20; i++) {
            intVal <<= 8;
            intVal += uint8(addrBytes[i]);
        }
        return address(intVal);
    }

    // 发送值，需要判断该地址下的越是否大于 amount
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    // 将数字 0-15 转为为 ASCII 值 [0-9 A-F a-f]
    function encode(uint8 num) private pure returns (byte) {
        if (num >= 0 && num <= 9) {
            return byte(num + 48);
        }
        return byte(num + 87);
    }

    // 将 ASCII 值 [0-9 A-F a-f] 转为为 数字 0-15
    function decode(byte asc) private pure returns (uint8) {
        uint8 val = uint8(asc);

        // 如果是 0-9
        if (val >= 48 && val <= 57) {
            return val - 48;
        }
        // 如果是 A-F
        if (val >= 65 && val <= 70) {
            return val - 55;
        }
        // 否则是 a-f
        return val - 87;
    }
}
