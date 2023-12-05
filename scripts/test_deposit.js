const LanTokenD = artifacts.require('./LanTokenD.sol');
const Exchange = artifacts.require('./Exchange.sol');


const fromWei = (bn,unit="ether")=>{
    return web3.utils.fromWei(bn,unit)
}
const toWei = (number,unit="ether")=>{
    return web3.utils.toWei(number.toString(),unit)

}


// (0) 0xE0279aF8DF2450E3df19B2725460A271a913e009 (1000 ETH)
// (1) 0x73582f88f0D356e7c279dBdA08b4636147D44068 (1000 ETH)
// (2) 0x4885d5452530db41033a7763907b881006B691d6 (1000 ETH)
// (3) 0xD28ef35b64856Fb4112Ea705694B947B66509A1c (1000 ETH)
// (4) 0x75C529443Cfbe4C8FFDFfA8015AFB3ABa5702474 (1000 ETH)
// (5) 0xE27E73742dBF79d560c3d3Beed70C0Bd8531fc85 (1000 ETH)
// (6) 0x60C3B3EcDafb09216B4eb1Cf12f8E09A26EC6269 (1000 ETH)
// (7) 0x8a32AbD87bEc3014dbE310cAF5378f3A5E929Ef0 (1000 ETH)
// (8) 0x58569a7931495bA633B7f4063383C4a62df7E1FF (1000 ETH)
// (9) 0x37637C817DF5e9e2D786058742312fCcc4F569b8 (1000 ETH)


const ETH_ADDRESS = '0x0000000000000000000000000000000000000000'



// 部署，文件名必须以1 等数字开头
module.exports = async function(cb){
 
    let token = await LanTokenD.deployed()
    let exchange   = await Exchange.deployed()

    // const account = await web3.eth.getAccounts()

    let firstAccount = '0xE0279aF8DF2450E3df19B2725460A271a913e009'
    let secondAccount =  '0x73582f88f0D356e7c279dBdA08b4636147D44068'
    let exchangeAccount =  '0x4885d5452530db41033a7763907b881006B691d6'

 


    // 存以太币 start
    // await exchange.depositEther({
    //     from:secondAccount,
    //     value:toWei(10)
    // })
    // let ethBn  = await exchange.tokens(ETH_ADDRESS,secondAccount)
    // console.log(fromWei(ethBn),"ethResponse eth 余额")
    // 存以太币 start

    // 授权
    await token.approve(exchange.address,toWei(100000),{
        from:firstAccount
    });
    let firstAccountBalance = await token.balanceOf(firstAccount)
    // let balanceOf = await token.balanceOf()
    // 第一个账号余额，代币第一个部署账号
    console.log("firstAccountBalance",fromWei(firstAccountBalance))

    await exchange.depositToken(token.address,toWei(5),{
        from:firstAccount
    });
    // console.log("deposit")

    let exchangeBalance  = await exchange.tokens(token.address,firstAccount)
    console.log(  fromWei(exchangeBalance) ,"查询在交易所有多少余额")


    // // // // 这个是第一个账号的值
    // console.log(fromWei(balance),"balance")

    // await token.transfer(threeAccount,toWei(1),{
    //     from:secondAccount
    // })

    // let res1 = await token.balanceOf(threeAccount)
    // console.log(fromWei(res1),"转好的值 threeAccount")

    // let res2 = await token.balanceOf(secondAccount)
    // console.log(fromWei(res2),"secondAccount res2")



    cb()
}
