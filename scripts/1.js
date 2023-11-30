const Contracts = artifacts.require('./StudentStore.sol');

// 部署，文件名必须以1 等数字开头
module.exports = async function(cb){
    let studentStore = await Contracts.deployed()
    console.log(studentStore,"studentStore")
    cb()
}
