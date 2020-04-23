pragma solidity ^0.4.22;

contract Ballot {
    // 这里声明了一个新的复合类型用于稍后的变量
    // 用来表示一个选民
    struct Voter {
        uint weight;        // 计票的权重
        bool voted;         // 若为真，代表该选民已经投票
        address delegate;   // 被委托人
        uint vote;          // 投票提案的索引
    }

    // 提案的类型
    struct Proposa {
        byte32 name;    // 简称（最长32个字节）
        uint voteCount; // 得票数
    }

    address public chairperson;

    // 声明一个状态变量，为每一个可能的地址都存储一个Voter
    mapping (address => Voter) public voters;

    // 一个Proposal结构类型的动态数组
    Proposal[] public proposals;

    constructor(byte32[] proposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        // 对于每个提供的提案的名称，创建一个新的Proposal对象并把它添加到数组的末尾
        for (uint i = 0; i < proposalNames.length; i++) {
            // 创建一个临时Proposal对象
            // 将其添加到proposals的末尾
            proposals.push(Proposal({
                name: proposalNames[i],
                // 初始票数为0
                voteCount: 0
                }))
        }
    }

    // 授权voter对这个表决进行投票
    // 只有chairperson可以调用该函数
    function giveRightToVote(address voter) public {
        // 使用require检查函数是否被正确调用
        // 如果require为false, 则撤销对所有状态和余额的改动
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    // 把票委托给投票者，让其投票
    function delegate(address to) public {
        // 传引用
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        // 委托可以传递，只要被委托者同意委托
        // 如果是循环委托是不安全的，因为如果传递的链条太长，
        // 可能需要消耗的gas会多于区块中剩余的（大于区块设置的gasLimit）
        // 如果这样，委托就不会执行
        // 如果形成闭环，就会让合约卡住
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // 不允许闭环委托
            require(to != msg.sender, "Found loop in delegation.")
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // 如果被委托者已经投过票，则直接增加票数
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // 如果被委托者还未投票，增加委托者的权重
            delegate_.weight += sender.weight;
        }
    }

    // 将自己的票投给proposalNames
    function vote(uint proposal) public {
        Voter storage sender = voters(msg.sender);
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // 如果proposa超过了数组的范围，则会自动抛出异常，并恢复所有的活动
        proposals[proposal].voteCount += sender.weight;
    }

    // 综合所有的投票，计算出最终胜出的提案
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            // 找出投票数最多的提案
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                // 返回索引位置
                winningProposal_ = p;
            }
        }
    }
}
