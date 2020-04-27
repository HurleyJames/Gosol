pragma solidity ^0.4.16;

contract C {
    // 可以将函数声明为view类型，这种情况下要保证不修改状态
    // 修改状态：
    // 1. 修改状态变量
    // 2. 产生事件
    // 3. 创建其它合约
    // 4. 使用selfdestruct
    // 5. 通过调用发送以太币
    // 6. 调用任何没有标记为view或者pure的函数
    // 7. 调用低级调用
    // 8. 使用包含特定操作码的内联汇编
    function f(uint a, uint b) public view returns (uint) {
        return a * (b + 42) + now;
    }
    // constant是view的别名

    // 函数可以声明为pure，在这种情况下，承诺不读取或者修改状态
    // 从状态中读取包括：
    // 1. 读取状态变量
    // 2. 访问this.balance或者<address>.balance
    // 3. 访问block，tx，msg中任意成员（除msg.sig和msg.data之外）
    // 4. 调用任何未标记为pure的函数
    // 5. 使用包含某些操作码的内联汇编
    function f(uint a, uint b) public pure returns (uint) {
        return a * (b + 42);
    }

}
