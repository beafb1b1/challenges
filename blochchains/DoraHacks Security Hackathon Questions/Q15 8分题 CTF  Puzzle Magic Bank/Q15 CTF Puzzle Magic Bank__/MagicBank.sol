contract MagicBank {
    mapping(address => uint) public balanceOf;
    mapping(address => uint) public creditOf;
    address owner;
    
    constructor()public{
        owner = msg.sender;
    }
    
    function transferBalance(address to, uint amount) public{
        require(balanceOf[msg.sender] - amount >= 0);
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
    
    event SendFlag(uint256 flagnum, string b64email);
    function sendFlag3(string b64email) public {
        require(balanceOf[msg.sender] >= 10000);
        emit SendFlag(1, b64email);
    }
    
    function guessRandom(uint256 guess) internal view returns(bool){
        uint256 seed = uint256(blockhash(block.number-1));
        uint256 rand = seed / 26959946667150639794667015087019630673637144422540572481103610249216;
        return rand == guess;
    }
    
    function buyCredit(uint256 guess) public {
        require(guessRandom(guess));
        require(balanceOf[msg.sender] >= 10000);
        require(creditOf[msg.sender] == 0);
        
        creditOf[msg.sender] = 1;
        balanceOf[msg.sender] -= 10000;
    }
    
    function withdrawCredit(uint amount) public{
        require(creditOf[msg.sender] >= amount);
        msg.sender.call.value(amount*1000000000)();
        creditOf[msg.sender] -= amount;
    }
    
    function sendFlag4(string b64email) public {
        require(creditOf[msg.sender] >= 10000);
        emit SendFlag(2, b64email);
    }
    
    function getEthBalance() public view returns(uint256){
        return this.balance;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    function kill(address t) public onlyOwner {
        selfdestruct(t);
    }
}
