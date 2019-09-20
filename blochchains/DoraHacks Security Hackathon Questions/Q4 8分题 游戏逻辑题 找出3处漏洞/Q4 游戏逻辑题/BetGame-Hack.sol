pragma solidity ^0.4.0;

// Bet Game
contract BetGame {
	address owner;					                // 合约持有者
	mapping(address => uint256) public balanceOf;	// 用户资金集
	
	uint256 public cutOffBlockNumber;		        // 下注截止到cutOffBlockNumber,至少有1000个块的距离到创建合约的块
	uint256 public status; 				            // 状态，根据每次下注修改状态
	mapping(address => uint256) public positiveSet;	// 赌注正面赢: status == 1
	mapping(address => uint256) public negativeSet;	// 赌注反面赢: status == 0
	uint256 public positiveBalance;			        // 正面下注资金总额
	uint256 public negativeBalance;			        // 反面下注资金总额

	modifier isOwner {
		assert(owner == msg.sender);
		_;
	}

	modifier isRunning {
		assert(block.number < cutOffBlockNumber);
		_;
	}

	modifier isStop {
		assert(block.number >= cutOffBlockNumber);
		_;
	}

	constructor(uint256 _cutOffBlockNumber) public {
		owner = msg.sender;			
		balanceOf[owner] = 100000000000;
        cutOffBlockNumber = _cutOffBlockNumber;
	}

	function transfer(address to, uint256 value) public returns (bool success) {
    	require(balanceOf[msg.sender] >= value);
    	require(balanceOf[to] + value >= balanceOf[to]);
    	balanceOf[msg.sender] -= value;
    	balanceOf[to] += value;
    	return true;
	}

	// 下注并影响状态，该操作必须在赌局结束之前
	function bet(uint256 value, bool positive) isRunning public returns(bool success) {
		require(balanceOf[msg.sender] >= value);
		balanceOf[msg.sender] -= value;
		if (positive == true) {
			positiveSet[msg.sender] += value;
			positiveBalance += value;
		} else {
			negativeSet[msg.sender] += value;
			negativeBalance += value;
		}
		
		bytes32 result = keccak256(abi.encodePacked(blockhash(block.number), msg.sender, block.timestamp));
		uint8 flags = (uint8)(result & 0xFF);	// 取一个字节，根据值的大小决定状态
		if (flags > 128) {
			status = 1;
		} else {
			status = 0;
		}
		return true;
	}

	// 猜对就取回成本和猜对所得（猜错将不能取回成本），该操作必须在赌局结束以后
	function withdraw() isStop public returns (bool success){
		uint256 betBalance;
		uint256 reward;
		if (status == 1) { // positiveSet
			betBalance = positiveSet[msg.sender];
			if (betBalance > 0) {
			    balanceOf[msg.sender] += betBalance;
				positiveSet[msg.sender] -= betBalance;
				positiveBalance -= betBalance;
				reward = (betBalance * negativeBalance) / positiveBalance;
				negativeBalance -= reward;
				balanceOf[msg.sender] += reward;
			} 
		} else if (status == 0) {
			betBalance = negativeSet[msg.sender];
			if (betBalance > 0) {
			    balanceOf[msg.sender] += betBalance;
				negativeSet[msg.sender] -= betBalance;
				negativeBalance -= betBalance;
				reward = (betBalance * positiveBalance) / negativeBalance;
				positiveBalance -= reward;
				balanceOf[msg.sender] += reward;
			}
		}
		return true;
	}
}