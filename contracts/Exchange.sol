// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;
import "./LanTokenD.sol";

// 交易所合约
contract Exchange{
   
  // 收费账户
  address peeAccount;
  address constant ETHER = address(0);

  // 收费费率
  uint256 peePercent;

  mapping(address=>mapping(address=>uint256)) public tokens;

  event Deposit(address token,address user,uint256 amount,uint256 balance);


  constructor(address _peeAccount,uint256 _peePercent){
    peeAccount = _peeAccount;
    peePercent = _peePercent;
  }

  // 存以太币, payable 特殊字符表明真会从以太坊账号扣钱 
  function depositEther() payable public{
      // msg.sender
      // msg.value;
      tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender] + msg.value;
      emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
  }

  // 存其他币
  function depositToken(address _token,uint256 _amount) public{
    require(_token!=address(0));
    // 我不确定ta是否转钱了
    // 所以我们需要调用某个方法强行从账号转钱到交易所,
    // this，代表当前合约地址
    require(LanTokenD(_token).transferFrom(msg.sender, address(this), _amount));
    tokens[_token][msg.sender] = tokens[_token][msg.sender] + _amount;
    emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);


  }

}