pragma solidity ^0.8.0;
import "../utils/Strings.sol";

contract StringDemo {
    function demo1() public {
        string memory str = "你好";
        uint256 lenOfChars = Strings.lenOfChars(str);
        uint256 lenOfBytes = Strings.lenOfBytes(str);

        require(lenOfChars == 2);
        require(lenOfBytes == 6);
    }

    function demo2() public view returns (string memory) {
        string memory c = Strings.toUpperCase("abcd");
        // ABCD
        return c;
    }

    function demo3() public view returns (string memory) {
        string memory c = Strings.toLowerCase("ABCD");
        // abcd
        return c;
    }

    function demo4() public view returns (string memory) {
        bool r = Strings.equal("abcd", "abcd");
        // true
        require(r);
    }
}
