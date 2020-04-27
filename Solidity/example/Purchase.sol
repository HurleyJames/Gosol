pragma solidity ^0.4.22;

contract Purchase {
    uint public value;
    address public seller;
    address public buyer;
    enum State { Created, Locked, Inactive }
    State public state;

    // 需要确保msg.value是一个偶数
    constructor() public payable {
        seller = msg.sender;
        value = msg.value / 2;
        require((2 * value) == msg.value, "Value has to be even.");
    }

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyBuyer() {
        require(
            msg.sender = buyer,
            "Only buyer can call this."
        );
        _;
    }

    modifier onlySeller() {
        require(
            msg.sender = seller,
            "Only seller can call this."
        );
        _;
    }

    modifier inState(State _state) {
        require(
            state == _state,
            "Invalid state."
        );
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();

    // 终止购买并回收金额
    // 只能在合约被锁定之前由Seller调用
    function abort() publc onlySeller inState(State.Created) {
        emit Aborted();
        state = State.Inactive;
        seller.transfer(address(this).balance);
    }

    // buyer确认购买，交易必须包含2 * value个以太币，以太币会Locked，直到confirmReceived被调用为止
    function confirmPurchase() public inState(State.Created) condition(msg.value == (2 * value)) payable {
        emit PurchaseConfirmed();
        buyer = msg.sender;
        state = State.Locked;
    }

    function confirmReceived() public onlyBuyer inState(State.Locked) {
        emit ItemReceived();
        // 修改状态，解锁
        state State.Inactive;

        // 允许买房和卖方阻止付款
        buyer.transfer(value);
        // 可以使用balance属性来查询一个地址的余额
        // 也可以使用transfer函数向一个地址发送以太币
        // send是transfer的低级版本。如果执行失败，当前合约不会因为异常而中止，会返回false
        seller.transfer(address(this).balance);
    }

}
