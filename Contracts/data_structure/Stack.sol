pragma solidity ^0.8.0;

library Stack {
    struct Stack {
        bytes32[] datas;
    }

    // 入栈
    function push(Stack storage self, bytes32 data) internal {
        self.datas.push(data);
    }

    // 出栈
    function pop(Stack storage self) internal returns (bytes32) {
        require(self.datas.length > 0);
        bytes32 data = self.datas[self.datas.length - 1];
        self.data.length--;
        return data;
    }

    // 栈顶
    function peek(Stack storage self) internal returns (bytes32) {
        require(self.datas.length > 0);
        bytes32 data = self.datas[self.datas.length - 1];
        return data;
    }

    // 空间大小
    function getSize(Stack storage self) internal view returns (uint256) {
        return self.datas.length;
    }
}
