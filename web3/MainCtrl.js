const getContract = require('./getContract');
const Web3 = require('web3');
const promiseWrap = require('./promiseWrap');

const provider = "http://54.185.11.58:8545";

var web3 = new Web3(new Web3.providers.HttpProvider(provider), {
  // gasPrice: 1, gasLimit: 3000000
});
let MainContractObj = getContract('Main');

const MainCtrl = {
  publicKey: '0xB8a760532Ef384C6f90d95812A4Ae01DAAEfb341',
  privateKey: '0xb16ff56d3f458e9c85067635fb7c69cc47804c3fe3e979dde64880eb70b1c950',
  mainContractAddress: '0x024ad85ae9c26d58adef4dc41957434fd152fbcf',
  // local Viktor
  // privateKey: '5fa367ab7a9388d00df20d24d9e07447b4fc3e37adff437bf98d7a99befa16dc',
  // publicKey: '0xae8F3FF1e592123632b5C1D4831b26b1E1b92695',
  provider,
  web3,
  initMain,
  registerManufacturer,
  initDeployerContract,
}
web3.eth.defaultAccount = MainCtrl.publicKey;

async function InitMainContract (data) {

  let contract = new web3.eth.Contract(MainContractObj.abi)

  return contract.deploy({
    data: MainContractObj.bytecode,
    arguments: data
  })
  .send({
      from: MainCtrl.publicKey,
      gas: 6700000,
  })
  .then((newContractInstance) => {
      console.log('main address', newContractInstance.options.address); // instance with the new contract address
      return newContractInstance;
  });
}

function registerManufacturer ({ownerId, name}) {
  let encodedABI = this.MainInstance.methods.
                   registerManufacturer(ownerId, name, 'phisical address', 'registration number').
                   encodeABI();

  let rawTx = {
    nonce: web3.eth.getTransactionCount(this.publicKey),
    gas: web3.utils.toHex(1000000),
    gasPrice: web3.utils.toHex('1000000000'),
    to: this.MainInstance.address,
    from: this.publicKey,
    data: encodedABI
  }

  return web3.eth.accounts.signTransaction(rawTx, this.privateKey).then(signed => {
    var tran = web3.eth.sendSignedTransaction(signed.rawTransaction);

    tran.on('confirmation', (confirmationNumber, receipt) => {
      console.log('confirmation: ' + confirmationNumber);
    });

    tran.on('transactionHash', hash => {
      console.log('hash');
      console.log(hash);
    });

    tran.on('receipt', receipt => {
      console.log('reciept');
      console.log(receipt);
    });

    // tran.on('error', console.error);
    return tran;
  });  
}


async function initDeployerContract(type){
  let DeployerObj = getContract(type+'Deployer');
  let deployer = new web3.eth.Contract(DeployerObj.abi);
  return deployer.deploy({
      data: DeployerObj.bytecode
  })
  .send({
      from: this.publicKey,
      gas: 6600000
  })
  .then((newContractInstance) => {
      console.log(newContractInstance.options.address)
      return newContractInstance.options.address;
  }).catch(console.log.bind(null,type, '!!!!!!!'))
};


async function initMain () {
  //let MainContractAddress = null;
  // let accounts = [];
  if (this.mainContractAddress) {
    // console.log(MainContractObj.abi, this.mainContractAddress);
    this.MainInstance =  web3.eth.Contract(MainContractObj.abi, this.mainContractAddress);
    return;
  }
  
  MainContractInstance = await Promise.all([
    MainCtrl.initDeployerContract('User'),
    MainCtrl.initDeployerContract('Manufacturer'),
    MainCtrl.initDeployerContract('Vendor'),
    MainCtrl.initDeployerContract('ServiceCenter'),
  ]).then(data => {
    for (let i = 0; i < data.length; i++){
      if (!data[i]) throw Error("Can't deploy some deploers");
    }
    return InitMainContract(data);
  }).catch(console.log);
  
  //console.log('MainContractAddress', MainContractAddress);
  this.MainInstance = MainContractInstance;
}

module.exports = MainCtrl;