//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeflationaryToken {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply = 1000000 * (10 ** 18); // 1 million tokens with 18 decimals
    string public name = "DeflationaryToken";
    string public symbol = "DFT";
    uint8 public decimals = 18;
    uint256 public burnRate = 2; // 2% burn on transfer
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        uint256 burnAmount = (_value * burnRate) / 100;
        uint256 transferAmount = _value - burnAmount;
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += transferAmount;
        totalSupply -= burnAmount; // Burn the tokens
        
        emit Transfer(msg.sender, _to, transferAmount);
        emit Transfer(msg.sender, address(0), burnAmount);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        
        uint256 burnAmount = (_value * burnRate) / 100;
        uint256 transferAmount = _value - burnAmount;
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += transferAmount;
        allowance[_from][msg.sender] -= _value;
        totalSupply -= burnAmount; // Burn the tokens
        
        emit Transfer(_from, _to, transferAmount);
        emit Transfer(_from, address(0), burnAmount);
        return true;
    }
}
