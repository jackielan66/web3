// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;
// import "@openzeppelin/contracts/utils/math/ath.sol";


contract LanTokenD{
    string public name  = "ltokew";
   string public symbol = "KWT";
   uint256 public decimals = 18; // 单位
   uint256 public totalSupply;

    // mapping
    mapping(address=>uint256) public balanceOf;

   constructor(){
     totalSupply = 100 * (10**decimals);
    // 谁初始化，谁就有最多的代币
     balanceOf[msg.sender] = totalSupply;
   }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
   


   function transfer(address _to, uint256 _value) public returns (bool success){
        // if (      balanceOf[msg.sender] >= _value) {
        // } 
        // 等同于条件判断，这里还会弄eth报错日志中
        require(_to!=address(0)); 
        _transfer(msg.sender, _to, _value);
        return true;
   }

   function _transfer(address _from,  address _to, uint256 _value) internal{
        require(balanceOf[_from] >= _value);
        balanceOf[_from] =  balanceOf[_from] - (_value);
        balanceOf[_to] =  balanceOf[_to] + (_value);
        emit Transfer(_from,_to,_value);
   }

  

}