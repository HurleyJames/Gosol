pragma solidity >0.4.23 <0.5.0;

contract BlindAuction {
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    address public beneficiary;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;

    mapping(address => Bid[]) public bids;

    address public highestbidder;
    uint public highestBid;

    // 收回之前的报价
    mapping(address => uint) pendingReturns;

    event AuctionEnded(address winner, uint highestBid);

    // 使用modifier的用处是可以更便捷地检验函数的入参
    // onlyBefore会被用于后面的bid函数
    // 新的函数是由modifier本身的函数体，用原函数替换_语句来组成
    modifier onlyBefore(uint _time) { require(now < _time); _; }
    modifier onlyAfter(uint _time) { require(now > _time); _; }

    constructor(
        uint _biddingTime,
        uint _revealTime,
        address _beneficiary
    ) public {
        beneficiary = _beneficiary;
        biddingEnd = now + _biddingTime;
        revealEnd = biddingEnd + _revealTime;
    }

    // 设置一个秘密竞拍，只会在出价披露阶段才会被揭露价格，已经发送的以太币才会退还
    // 如果与出价一个发送的以太币有value并且fake为假，那么出价有效
    // 将fake设置为true，则会隐藏价格，发送一个满足订金金额但却与实际出价不相同的金额
    // 同一个地址是可以放置多个价格的
    function bid(bytes32 _blindedBid) public payable onlyBefore(biddingEnd) {
        bids[msg.sender].push(Bid({
            blindedBid: _blindedBid,
            deposit: msg.value
        }));
    }

    // 披露价格的方法
    // 对于所有无效出价和除了最高价以外的所有出价，都会退款
    function reveal(uint[] _values, bool[] _fake, bytes32[] _secret) public onlyAfter(biddingEnd) onlyBefore(revealEnd) {
        uint length = bids[msg.sender].length;
        require(_values.length == length);
        require(_fake.length == length);
        require(_secret.length == length);

        uint refund;
        for (uint i = 0; i < length; i++) {
            // 数据位置可以说明数据是保存在内存中还是存储中，即storage还是memory
            // 函数参数（包括返回的参数）的数据位置默认是memory
            // 局部变量的数据位置默认是storage
            // 状态变量的数据位置强制是storage
            Bid storage bid = bids[msg.sender][i];
            (uint value, bool fake, byte32 secret) = (_values[i], _fake[i], _secret[i]);
            if (bid.blindedBid != keccak256(value, fake, secret)) {
                // 出价未能正确披露
                // 不会返还订金
                continue;
            }
            refund += bid.deposit;
            if (!fake && bid.deposit >= value) {
                if (placeBid(msg.sender, value))
                    refund -= value;
            }
            //发送者不可能再次认领同一笔订金
            bid.blindedBid = byte32[0];
        }
        msg.sender.transfer(refund);
    }

    // internal函数，不是public，意味着只能在本合约内部被调用
    function placeBid(address bidder, uint value) internal returns (bool success) {
        // 出价比最高价低
        if (value <= highestBid) {
            return false;
        }
        if (highestBidder != address(0)) {
            // 返还之前的最高价
            pendingReturns[highestBidder] += highestBid;
        }
        highestBid = value;
        highestBidder = bidder;
        return true;
    }

    // 如果该报价已经被超越，则取回该报价
    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            msg.sender.transfer(amount);
        }
    }

    // 结束拍卖，把最高的报价发送给受益人
    function auctionEnd() public onlyAfter(revealEnd) {
        require(!ended);
        emit AuctionEnded(highestBidder, highestBid);
        // 结束
        ended = true;
        beneficiary.transfer(highestBid);
    }
}
