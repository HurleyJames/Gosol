pragma solidity ^0.4.0;

contract DeleteExample {
    uint data;
    uint[] dataArray;

    function f() public {
        uint x = data;
        // 将x设为0，不影响数据
        delete x;
        // 将data设为0，则不会影响data
        delete data;
        uint[] storage y = dataArray;
        //这是将dataArray.length设为0
        delete dataArray;
        // delete y是非法的，因为引用了storage对象的局部变量只能由已有的storage对象赋值
    }
}
