// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;


contract StudentStoreList{

    struct Student {
        uint id;
        string name;
        uint age;
        address account;
    }

    // 动态数组，如果   Student[10] 这个是固定数组，固定多少位
    Student[] public StudentList;

    uint age;
    string name;

    // string 不是基本类型，需要加位置
    function addList(uint _age,string memory  _name) public returns (uint){
       uint count = StudentList.length;
       uint id = count+1;
        StudentList.push(Student(id,_name,_age,msg.sender));
        return StudentList.length;
    }

    // view 视图函数只访问不修改
    // pure 不访问不修改
    function getList() public view returns(Student[] memory )  {
        return StudentList;
    }
}