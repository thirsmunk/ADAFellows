pragma solidity^0.5.0;

contract adaexercise {

    //Data Types
    uint memberCount;

    mapping (string => address payable) Fellows;
    mapping (string => address[]) access;
    mapping (string => string) secrets;
    mapping (address => uint) balance;
    uint amount_to_unlock;

    constructor() public {
        //Constructor 
        amount_to_unlock = 1 ether;
    }

    //Insert the five functions here

    function registerFellow(string memory name) public returns(bool) {
        if(Fellows[name] == address(0)) {
            memberCount++;
            Fellows[name] == msg.sender;
            return true;
        } else {
            return false;
        }
    }

    function setSecret(string memory name, string memory message) public {
        require(Fellows[name] != address(0) && Fellows[name] == msg.sender);
        secrets[name] = message;
    }

    function getSecret(string memory name) public view returns(string memory) {
        require( Fellows[name] != address(0));
        bool flag = false;

        for (uint i = 0; i < access[name].length ; i++) {
            if(access[name][i] == msg.sender) {
                flag = true;
                break;
            }
        }
        if (flag){
            return secrets[name];
        }
        return "This fellow's message is locked!";
    }

    function unlockMessage(string memory name) public payable returns (bool) {
        require( Fellows[name] != address(0));
        if(msg.value == amount_to_unlock) {

            balance[Fellows[name]] += msg.value;
            Fellows[name].transfer(msg.value);
            access[name].push(msg.sender);

            return true;
        } else {
            return false;
        }
    }
}
