pragma solidity ^0.4.24;

contract DaysBank {
    mapping(address => uint) public balanceOf;
    mapping(address => uint) public gift;
    address owner;
        
    constructor()public{
        owner = msg.sender;
    }
    
    event SendFlag(uint256 flagnum, string b64email);
    function payforflag(string b64email) public {
        require(balanceOf[msg.sender] >= 10000);
        emit SendFlag(1,b64email);
    }