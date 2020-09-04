pragma solidity >=0.4.22 <0.7.0;
import "./StringUtils.sol";
// import "github.com/Legend-Zhu/solidityutils/StringUtils.sol";

contract TransportTickets {
    using StringUtils for *;

    struct Ticket {
        uint256 id;
        uint256 num;
        string ownerName;
        address owner;
    }

    struct TransportNumber {
        uint256 id;
        string from;
        string to;
        uint256 price;
        uint256 timeDeparture;
        uint256 timeArrival;
    }

    struct InterestPoint {
        uint256 id;
        string name;
        string vicinty;
    }

    uint256 ticketIndex = 0;
    mapping(uint256 => Ticket) tickets;
    mapping(bytes32 => uint256) ticketIds;
    mapping(uint256 => TransportNumber) public nums;
    mapping(uint256 => InterestPoint) interestPoints;

    address payable private creater;

    event logTicket(uint256 id, string ownerName, address owner, string from, string to, uint256 price, uint256 timeDeparture, uint256 timeArrival);

    constructor() public {
        creater = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == creater);
        creater.transfer(address(this).balance);
    }

    function addTransportNumber(uint256 id, string memory from, string memory to, uint256 price, uint256 timeDeparture, uint256 timeArrival) public {
        require(msg.sender == creater);
        nums[id] = TransportNumber(id, from, to, price, timeDeparture, timeArrival);
    }

    function deleteTransportNumber(uint256 id) public {
        require(msg.sender == creater);
        delete nums[id];
    }

    function getTicketHash(address owner, string memory from, string memory to, uint256 timeDeparture) public pure returns(bytes32 hash) {
        bytes memory s = abi.encodePacked(owner.toString(), from, to, timeDeparture.toString());
        return sha256(s);
    }

    function buyTicket(uint256 numId, string memory ownerName) payable public {
        require(msg.value == nums[numId].price);
        ticketIndex += 1;
        tickets[ticketIndex] = Ticket(ticketIndex, numId, ownerName, msg.sender);
        bytes32 hash = getTicketHash(msg.sender, nums[numId].from, nums[numId].to, nums[numId].timeDeparture);
        ticketIds[hash] = ticketIndex;
    }

    function checkTicket(bytes32 hash) public returns(bool) {
        require(msg.sender == creater);
        bool result = false;
        uint256 id = ticketIds[hash];
        if(id > 0) {
            uint256 num = tickets[id].num;
            if(nums[num].timeDeparture > now) { //�жϳ�Ʊ�Ƿ����
                result = true;
                emit logTicket(id, tickets[id].ownerName, tickets[id].owner, nums[num].from, nums[num].to, nums[num].price, nums[num].timeDeparture, nums[num].timeArrival);
            }
        }
        return result;
    }

    function deleteTicket(uint256 id) public {
        require(msg.sender == creater);
        Ticket memory ticket = tickets[id];
        bytes32 hash = getTicketHash(ticket.owner, nums[ticket.num].from, nums[ticket.num].to, nums[ticket.num].timeDeparture);
        delete ticketIds[hash];
        delete tickets[id];
    }

    function addInterestPoint(uint256 id, string memory name, string memory vicinty) public {
        require(msg.sender == creater);
        interestPoints[id] = InterestPoint(id, name, vicinty);
    }

    event logInterestPoint(uint256 id, string name, string vicinty);

    function queryInterestPoint(uint256 id) public {
        require(msg.sender == creater);
        emit logInterestPoint(id, interestPoints[id].name, interestPoints[id].vicinty);
    }

    function deleteInterestPoint(uint256 id) public {
        require(msg.sender == creater);
        delete interestPoints[id];
    }
}
