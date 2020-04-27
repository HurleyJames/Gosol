pragma solidity ^0.4.16;

contract OwnedToken {
    TokenCreator creator;
    address owner;
    bytes32 name;

    // 注册creator和设置名称的构造函数
    function OwnedToken(bytes32 _name) public {
        // 状态变量通过其名称访问，而不是通过this.owner的形式访问
        owner = msg.sender;
        // 从address到TokenCreator，显式类型转换
        creator = TokenCreator(msg.sender);
        name = _name;
    }

    function changeName(bytes32 newName) public {
        // 只有creator（即创建该合约的人）可以更改名称
        if (msg.sender == address(creator))
            name = newName;
    }

    function transfer(address newOwner) public {
        // 只要当前所有者才可以发送token
        if (msg.sender != owner) return;
        // 判断creator是否可以发送
        if (creator.isTokenTransferOK(owner, newOwner))
            owner = newOwner;
    }
}

contract TokenCreator {
    function createToken(byte32 name) public returns (OwnedToken tokenAddress) {
        // 创建一个新的Token合约并且返回它的地址
        return new OwnedToken(name);
    }

    function changeName(OwnedToken tokenAddress, byte32 name) public {
        // 调动外部contract的changeName方法
        tokenAddress.changeName(name);
    }

    function isTokenTransferOK(address currentOwner, address newOwner) public view returns (bool ok){
        // 检查转换owner是否成功
        address tokenAddress = msg.sender;
        return (keccak256(newOwner) & 0xff) == (bytes20(tokenAddress) & 0xff);
    }
}
