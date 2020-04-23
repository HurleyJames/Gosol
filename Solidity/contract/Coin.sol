pragma solidity ^0.4.0

contract Coin {
    // address类型是一个160位的值，且不允许任何算数操作。
    // 这种类型适合存储合约地址或外部人员的密钥对
    address public minter;
    // 创建一个公共状态变量，但是是一个更复杂的数据类型
    // 该类型将address映射为无符号整数
    mapping (address => uint) public balances;

    // 轻客户端可以通过事件针对变化做出高效的反应
    // 会在send函数的最后一行被发出
    event Sent(address from, address to, uint amount);

    // 构造函数，当合约创建时就会运行
    function Coin() public {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        if (msg.sender != minter) return;
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
