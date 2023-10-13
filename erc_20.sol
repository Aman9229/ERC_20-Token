// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
// interface is created

contract myToken{
 
    string public constant name="MyToken";
    string public constant symbol="Mt20";
    uint8 public constant decimals=0;

/*   instend of using this 

     string public constant name;
     string public constant symbol;
     uint8 public constant decimals;
*/

    event Approval(address indexed  tokenOwner,address indexed spender,uint tokens);
    event Transfer(address indexed from, address indexed to,uint value);

    mapping(address => uint256) balances;
    mapping (address => mapping (address=> uint)) allowed; // nested mapping

    uint _totalSupply = 1000 wei;
    address admin;
    
/*  
    it can be use this 

     constructor(string _name,string _symbol ,uint8 _decimals){
     balances[msg.sender]=_totalSupply;
     name=_name;
     symbol=_symbol;
     decimal=_decimal;
    }
*/
 
    constructor(){
     balances[msg.sender]=_totalSupply;
     admin=msg.sender;
    }

    function totalSupply() public view returns(uint256){
        return _totalSupply;
    } 

    function balanceOf(address tokenOwner) public  view returns(uint256){
        return balances[tokenOwner];
    }

    function transfer(address reciver ,uint numToken) public returns(bool){
        require(numToken <= balances[msg.sender]);
        balances[msg.sender] -=numToken;
        balances[reciver] +=numToken;
        emit Transfer(msg.sender, reciver, numToken);
        return true;
    }
    // only admin can mint tokens
    modifier onlyadmin{
        require(msg.sender==admin,"only admin can run this function");_;
    }
    function mint(uint _quantity) public onlyadmin returns(uint){
       _totalSupply+=_quantity;
       balances[msg.sender]-=_quantity;
       return _totalSupply;
    }
    function burn(uint _quantity) public onlyadmin returns(uint){
       require(balances[msg.sender] >= _quantity);
       _totalSupply-=_quantity;
       balances[msg.sender]-=_quantity;
       return _totalSupply;
    }
    // owner give allowance 
    function allowance(address _owner , address _spender) public view returns(uint256 remaining){
      return allowed [_owner][_spender];
    }
     // owner approve some tokens to spend particular man
     function approve(address _spender,uint256 _value)public returns(bool success){
         allowed [msg.sender][_spender]=_value;
         emit Approval(msg.sender, _spender, _value);
         return true;
     }

     // this function run by spender
     function transferFrom(address _from , address _to , uint256 _value) public returns(bool success){
      uint256 allowance_1 = allowed[_from][msg.sender];
       require(balances[_from] >=_value && allowance_1 >= _value);
       balances[_to]+=_value;
       balances[_from]-=_value;
       allowed[_from][msg.sender]-=_value;

       emit Transfer( _from, _to, _value );
       return true;
    }
} 