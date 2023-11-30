// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract StudentStore{

    uint age;
    string name;

    // string 不是基本类型，需要加位置
    function setData(uint _age,string memory  _name) public{
        age = _age;
        _name = _name;

    }

    // view 视图函数只访问不修改
    // pure 不访问不修改
     
    function getData() public view returns(uint,string memory)  {
        return (age,name);
    }
}