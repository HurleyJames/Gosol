pragma solidity >= 0.5.0 < 0.7.0;

contract Existence {

    event ProofCreated(
        uint256 indexed id,
        bytes32 hash
    );

    address public owner;

    mapping (uint256 => bytes32) hashesById;

    constructor () public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner is allowed to access this function.");
        _;
    }

    modifier noHashExists(uint256 id) {
        require(hashesById[id] == "", "No hash exists for this id.");
        _;
    }

    function notarizeHash(uint256 id, bytes32 hash) public onlyOwner noHashExists(id) {
        hashesById[id] = hash;
        emit ProofCreated(id, hash);
    }

    function doesProofExist(uint256 id, bytes32 hash) public view returns (bool) {
        return hashesById[id] == hash;
    }
}
