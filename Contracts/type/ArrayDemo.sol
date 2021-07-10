pragma solidity ^0.8.0;
import "../utils/Array.sol";

contract ArrayDemo {
    uint256[] private array;
    uint256[] private array1;
    uint256[] private array2;

    function f1(uint256 value) public view {
        array = new uint256[](0);
        ArrayUtils.addValue(array, value);
    }

    function f2(uint256 a, uint256 b) public view {
        array1 = new uint256[](a);
        array2 = new uint256[](b);
        ArrayUtils.extend(array1, array2);
    }

    function f3() public view {
        array = new uint256[](2);
        array[0] = 2;
        array[1] = 2;
        ArrayUtils.distinct(array);
        // array: {2}
    }
}
