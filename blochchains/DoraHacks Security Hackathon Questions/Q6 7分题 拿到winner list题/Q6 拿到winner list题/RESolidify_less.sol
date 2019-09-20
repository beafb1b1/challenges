pragma solidity ^0.4.25;

// This contract is missing some code. Can you figure out how to win?
// Get onto the winners list before someone else does!
// https://ropsten.etherscan.io/address/0x64ba926175bc69ba757ef53a6d5ef616889c9999

contract RESolidify {
    mapping(address => bool) winners;
    bytes32 private xor;
    byte[] private flag;
    byte[] private err;

    constructor(bytes32 xor_, byte[] memory flag_, byte[] memory err_) public {
    }
    
    
    function isWinner(address addr) public view returns (bool) {
        return winners[addr];
    }
	

    function check(bytes32 guess, byte[] a) public returns (byte[]) {
        // where does the key come from? nobody knows...
        // might need to figure out what happens before this...

        if (bytescmp(a, flag)) {
            winners[msg.sender] = true;
            return flag;
        }

        return err;
    }
}
