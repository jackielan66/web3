const Contracts = artifacts.require('./StudentStore.sol');
const StudentStoreList = artifacts.require('./StudentStoreList.sol');
const LanTokenD = artifacts.require('./LanTokenD.sol');


// 部署，文件名必须以1 等数字开头
module.exports = function(deployer){
    deployer.deploy(Contracts);
    deployer.deploy(StudentStoreList);
    deployer.deploy(LanTokenD)
}