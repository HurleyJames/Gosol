pragma solidity >=0.5.1 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Adoption.sol";

contract TestAdoption {
    Adoption adoption = Adoption(DeployedAddresses.Adoption());

    function testUserCanAdoptPet() public {
        uint returnedId = adoption.adopt(8);

        uint expected = 8;
        Assert.equal(returnedId, expected, "Adoption of pet ID 8 should be recorded.");
    }

    function testGetAdopterAddressByPetId() public {
        address expected = address(this);
        address adopter = adoption.adopters(8);
        Assert.equal(adopter, expected, "Adoption of pet ID 8 should be recorded.");
    }

    // 验证数组中的8号宠物与地址是否符合
    function testGetAdopterAddressByPetIdInArray() public {
        address expected = address(this);
        address[16] memory adopters = adoption.getAdopters();
        Assert.equal(adopters[8], expected, "Adoption of pet ID 8 should be recorded.");
    }
}
