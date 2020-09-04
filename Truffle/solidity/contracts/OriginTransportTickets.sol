pragma solidity >= 0.5.0 < 0.7.0;

import "./Sealable.sol";
import "./Lockable.sol";

contract OriginTransportTickets is Sealable, Lockable {
    struct SimpleTicket {
        // Unique autoincremented ID
        uint256 id;
        bytes32 ownerName;
        bytes32 from;
        bytes32 to;
        uint256 price;
        uint256 timeDeparture;
        uint256 timeArrival;
    }

    // The list of transport tickets
    SimpleTicket[] public transport_tickets;


    constructor() Lockable(0) public {
        addAddressToWhitelist(msg.sender);
    }

    function grantAuthority(address grantee) onlyOwner onlyUnlock public returns (bool success) {
        return super.registerDelegate(grantee);
    }

    function getTicketHash(bytes32 id) public view returns (bytes32) {
        return super.getSeal(id);
    }

    function deliverTicket(bytes32 id, bytes32 ticketHash) public onlyWhitelisted onlyUnlock {
        return super.recordSeal(id, ticketHash);
    }

    function isValid(bytes32 id, bytes32 ticketHash) public view returns (bool) {
        return super.verifySeal(id, ticketHash);
    }

    function setDateLimit(uint256 newDateLimit) public onlyOwner {
        return super.setDateLimit(newDateLimit);
    }

    function isLocked() public view returns (bool) {
        return super.isLocked();
    }
}
