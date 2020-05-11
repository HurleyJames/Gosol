pragma solidity >=0.5.1 <0.7.0;

contract Adoption {

    // 领养者的地址（总共16只宠物）
    address[16] public adopters;

    function adopt(uint petId) public returns (uint) {
        // pedId的取值范围
        require(petId >= 0 && petId < 16);
        // sender就是领养者，关联到对应下标的数组元素的取值
        adopters[petId] = msg.sender;
        return petId;
    }

    // 视图函数，不会更改状态变量
    function getAdopters() public view returns (address[16] memory) {
        return adopters;
    }
}
