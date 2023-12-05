const Contracts = artifacts.require('./StudentStore.sol');
const StudentStoreList = artifacts.require('./StudentStoreList.sol');
const LanTokenD = artifacts.require('./LanTokenD.sol');
const Exchange = artifacts.require('./Exchange.sol');

// 部署，文件名必须以1 等数字开头
module.exports = async function(deployer){
    // const account = await web3.eth.getAccounts()
    // console.log(account,"account 1_deploy")
    // console.log(account,"account")
    deployer.deploy(Contracts);
    deployer.deploy(StudentStoreList);
    deployer.deploy(LanTokenD)
    // 0xE0279aF8DF2450E3df19B2725460A271a913e009 这个是收费账号，交易所的账号
    deployer.deploy(Exchange,'0xE0279aF8DF2450E3df19B2725460A271a913e009',10)

}