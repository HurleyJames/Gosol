pragma solidity ^0.4.20;

contract MyToken {

    mapping (address => uint256) public balanceOf;

    constructor(uint256 initSupply) public {
        balanceOf[msg.sender] = initSupply;
    }

    function transfer(address _to, uint256 _value) public {
        // 判断是否有足够的金额支持转账
        require(balanceOf[msg.sender] >= _value);
        // 对溢出做一个判断
        require(balanceOf[_to] + _value >= balanceOf[_to]);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
}
