pragma solidity >=0.4.22 <0.7.0;
import "./StringUtils.sol";

contract Verify {
    using StringUtils for *;

    struct TransportTicket {
        uint256 id;
        string ownerName;
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

    mapping (uint256 => InterestPoint) interestPoints;
    mapping (bytes32 => uint256) pointIds;

    address payable private creater;

    constructor() public {
        creater = msg.sender;
    }

    event logInterestPoint(uint256 id, string name, string vicinty);

    function addInterestPoint(uint256 id, string memory name, string memory vicinty) public {
        require(msg.sender == creater);
        interestPoints[id] = InterestPoint(id, name, vicinty);
    }

    function getInterestPointHash(string memory id, string memory name, string memory vicinty) public pure returns (bytes32 hash) {
        bytes memory s = abi.encodePacked(id, name, vicinty);
        return sha256(s);
    }

    function checkInterestPoint(uint256 id, string memory name, string memory vicinty) public view returns (bool) {
        require(msg.sender == creater);
        return interestPoints[id].name.equal(name) && interestPoints[id].vicinty.equal(vicinty);
    }

    function queryInterestPoint(uint256 id) public {
        require(msg.sender == creater);
        emit logInterestPoint(id, interestPoints[id].name, interestPoints[id].vicinty);
    }

    function deleteInterestPoint(uint256 id) public {
        require(msg.sender == creater);
        delete interestPoints[id];
    }
}