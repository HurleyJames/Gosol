pragma solidity ^0.4.11;

contract owned {
    function owned() public {
        owner = msg.sender;
    }

    address owner;

    // 如果是owner调用这个函数会正常执行，不然会抛出异常
    // 修饰器所修饰的函数体会被插入到特殊符号_;的位置
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}

contract mortal is owned {
    // 合约从owned继承了onlyOwner修饰符，并将其应用于close函数
    // 只有owner调用这个函数，则函数会被执行，否则会抛出异常
    function close() public onlyOwner {
        selfdestruct(owner);
    }
}

contract priced {
    // 修改器可以接受参数
    modifier costs(uint price) {
        if (msg.value >= price) {
            _;
        }
    }
}

contract Register is priced, owned {
    mapping (address => bool) registeredAddresses;
    uint price;

     function Register(uint initialPrice) public { price = initialPrice;}

     function register() public payable costs(price) {
         registeredAddresses[msg.sender] = true;
     }

     function changePrice(uint _price) public onlyOwner {
         price = _price;
     }
}

contract Mutex {
    bool locked;
    // 如果同一个函数有多个修饰器，它们之间以空格隔开，修饰器会依次检查
    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    // 受互斥量保护，意味着msg.sender.call中的重入调用不能再次调用f
    // return 7 指定返回值7
    function f() public noReentrancy returns (uint) {
        require(msg.sender.call());
        return 7;
    }
}
