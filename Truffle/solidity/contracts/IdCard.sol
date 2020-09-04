pragma solidity >= 0.5.0 < 0.7.0;

contract IdCard {

    struct SimpleIdCard{
        // Unique autoincremented ID
        uint256 id;
        bytes32 owner_name;
        uint256 card_id;
        bytes32 card_no;
        bytes32 expire_date;
    }
}
