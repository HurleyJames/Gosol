pragma solidity ^0.4.22;

contract SimpleAuction {
    // 拍卖的参数
    address public beneficiary;
    // 时间
    uint public auctionEnd;

    // 拍卖的当前状态
    address public highestBidder;
    uint public highestBid;

    // 可以取回的之前的出价，接收方自己提取金钱
    mapping(address => uint) pendingReturns;

    // 如果拍卖结束就设为true，禁止所有更改
    bool ended;

    // 变更触发的事件
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // 受益人的地址，拍卖时间为_biddingTime
    constructor(
        uint _biddingTime,
        address _beneficiary;
    ) public {
        beneficiary = _beneficiary;
        auctionEnd = now + _biddingTime;
    }

    // 对拍卖进行出价，如果没有获胜，价格会返还
    function bid() public payable {
        // 对于能接受以太币的函数，都必须加上关键字payable

        // 如果拍卖已经结束，则撤销函数的调用
        require(
            now <= auctionEnd,
            "Auction already ended."
        );

        // 如果出价不够高，没有获胜，就返回出价
        require(
            msg.value > highestBid,
            "There already is a higher bid."
        );

        if (highestBid != 0) {
            // 因为返回出价时，直接调动highestBidder.send(highestBid)函数是不安全的
            // 它有可能执行一个非信任合约
            // 所以安全做法是让接收方自己提取金钱
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    // 取回出价（因为当前出价已经被超越了）
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {

            // 设零值，因为接收者可以在send返回之前调用该函数
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                // 重置未付款
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        // 拍卖继续
        return true;
    }

    // 结束拍卖，并把最高的出价发送给受益人
    function auctionEnd() public {
        // 这是一个可与其他合约交互的函数，分为三个阶段
        // 1. 检查条件
        // 2. 执行动作（可能会改变条件）
        // 3. 与其他合约交互

        // 1. 条件
        require(now >= auctionEnd, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");

        // 2. 生效
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. 交互
        address.transfer(highestBid);
    }
}
