pragma solidity >=0.4.22 <0.7.0;

contract greeter {
    /* define variable greeting of the type string */
    string public greeting;

    event ChangeGreeting(string newGreeting);
 
    /* this runs when the contract is executed */
    constructor() public {
        greeting = 'Hello Hurley';
    }
 
    /* change greeting */
    function changeGreeting(string memory _greeting) public {
        greeting = _greeting;
        emit ChangeGreeting(_greeting);
    }
 
    /* main function */
    function greet() public view returns (string memory) {
        return greeting;
    }
}