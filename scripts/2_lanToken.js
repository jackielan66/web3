const LanTokenD = artifacts.require('./LanTokenD.sol');

const fromWei = (bn,unit="ether")=>{
    return web3.utils.fromWei(bn,unit)
}
const toWei = (number,unit="ether")=>{
    return web3.utils.toWei(number.toString(),unit)

}


// 部署，文件名必须以1 等数字开头
module.exports = async function(cb){
    // cb.deploy(LanTokenD)
    // LanTokenD.deployed().then((res)=>{
    //     console.log(res,"res")
    // }).catch(err=>{
    //     console.log(err,"err")
    // })
    let token = await LanTokenD.deployed()
    let balance = await token.balanceOf('0xFd53842cb81E3232be67Ba9519d323dE416499D2')
    // 这个是第一个账号的值
    console.log(fromWei(balance),"balance")

    await token.transfer("0x5f7D314100E3A9B1c43077766894C893baE808bF",toWei(5),{
        from:'0xFd53842cb81E3232be67Ba9519d323dE416499D2'
    })

    let res1 = await token.balanceOf('0xFd53842cb81E3232be67Ba9519d323dE416499D2')
    console.log(fromWei(res1),"转好的值")

    let res2 = await token.balanceOf('0x5f7D314100E3A9B1c43077766894C893baE808bF')
    console.log(fromWei(res2),"转好的值 res2")



    cb()
}
