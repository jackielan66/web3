// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;
import "./LanTokenD.sol";

// 交易所保管钱包，只是比我们更专业而已。交易所有就是帮人保管钱的，跟银行一样

// 交易所合约
contract Exchange{
   
  // 收费账户
  address peeAccount;
  address constant ETHER = address(0);

  // 收费费率
  uint256 peePercent;

  mapping(address=>mapping(address=>uint256)) public tokens;

  // 订单结构体
  struct _Order {
    uint256 id;
    address user;
    address tokenGet;
    uint256 amountGet;
    address tokenGive;
    uint256 amountGive;
    uint256 timestamp;
  }

  mapping (uint256=>_Order) public orders;
  mapping (uint256=>bool) orderCancel;
  mapping (uint256=>bool) orderFill;
  uint256 public orderCount;

  event Deposit(address token,address user,uint256 amount,uint256 balance);
  event WithDraw(address token,address user,uint256 amount,uint256 balance);
  event Order(    uint256 id,
    address user,
    address tokenGet,
    uint256 amountGet,
    address tokenGive,
    uint256 amountGive,
    uint256 timestamp);

  event Cancel(    uint256 id,
    address user,
    address tokenGet,
    uint256 amountGet,
    address tokenGive,
    uint256 amountGive,
    uint256 timestamp);
  
  event Trade(    uint256 id,
    address user,
    address tokenGet,
    uint256 amountGet,
    address tokenGive,
    uint256 amountGive,
    uint256 timestamp);
    

  


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

  // 取以太币
  function withdrawEther(uint256 _amount) public{
    require(tokens[ETHER][msg.sender] >=  _amount);
    tokens[ETHER][msg.sender] =  tokens[ETHER][msg.sender] - _amount;
    // payable
    payable(msg.sender).transfer(_amount);
    emit WithDraw(ETHER, msg.sender, _amount, tokens[ETHER][msg.sender]);
  }

  // 取其他币
  function withdrawToken(address _token,uint256 _amount) public{
    require(_token!=address(0));

    require(tokens[_token][msg.sender]>= _amount);
    tokens[_token][msg.sender] = tokens[_token][msg.sender] - _amount;
    require(    LanTokenD(_token).transfer(msg.sender, _amount));
    emit WithDraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
  }

  // 查余额
  function balanceOf(address _token,address _user) public view returns(uint256) {
    return tokens[_token][_user];
  }

  // makeOrder
  function makeOrder( address _tokenGet,
    uint256 _amountGet,
    address _tokenGive,
    uint256 _amountGive) public{
      orderCount = orderCount+1;
      orders[orderCount] = _Order(orderCount, msg.sender,_tokenGet,_amountGet,_tokenGive,_amountGive,block.timestamp);
      emit Order(orderCount, msg.sender,_tokenGet,_amountGet,_tokenGive,_amountGive,block.timestamp);
    }

  // cancelOrder
  function cancelOrder(uint256 _id) public{
      _Order memory myOrder = orders[_id];
      require(myOrder.id ==_id);
      orderCancel[_id] = true;
      emit Cancel(myOrder.id, msg.sender,myOrder.tokenGet,myOrder.amountGet,myOrder.tokenGive,myOrder.amountGive,block.timestamp);

  }

  // fillOrder
  function fillOrder(uint256 _id) public{
      _Order memory myOrder = orders[_id];
      require(myOrder.id ==_id);
      orderFill[_id] = true;
      // 账号余额 小费
      /**
          逻辑
          xiaoming makeOrder
          xiaoming 多了代币
                   少了ether

          msg.sender 少了代币
                     多了ehter      
       */
      // 手续费
      uint256 feeAmout = myOrder.amountGet * peePercent / 100;

      // tokenGet 正常代币地址 
      tokens[myOrder.tokenGet][msg.sender] = tokens[myOrder.tokenGet][msg.sender] - myOrder.amountGet;
      // 当前交易订单的人付小费
      tokens[myOrder.tokenGet][msg.sender] = tokens[myOrder.tokenGet][msg.sender] - feeAmout;

      // 统计小费账号
      tokens[myOrder.tokenGet][peeAccount] = tokens[myOrder.tokenGet][peeAccount] + feeAmout;

      tokens[myOrder.tokenGet][myOrder.user] = tokens[myOrder.tokenGet][myOrder.user] + myOrder.amountGet;


      // 以太坊 地址 交易流程
      tokens[myOrder.tokenGive][msg.sender] = tokens[myOrder.tokenGive][msg.sender] + myOrder.amountGive;
      tokens[myOrder.tokenGive][myOrder.user] = tokens[myOrder.tokenGive][myOrder.user] - myOrder.amountGive;

   

      emit Trade(myOrder.id, msg.sender,myOrder.tokenGet,myOrder.amountGet,myOrder.tokenGive,myOrder.amountGive,block.timestamp);

  }

}