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
  privateKey: '9b46b095f7d3b02c2ac2ca6a6877e115ec0c3a615b0d242330740bc673643981',
  // local Viktor
  // privateKey: '5fa367ab7a9388d00df20d24d9e07447b4fc3e37adff437bf98d7a99befa16dc',
  // publicKey: '0xae8F3FF1e592123632b5C1D4831b26b1E1b92695',
  provider,
  web3,
  initMain,
  registerManufacturer,
}
web3.eth.defaultAccount = MainCtrl.publicKey;

async function InitMainContract () {

  let contract = new web3.eth.Contract(MainContractObj.abi)

  return contract.deploy({
    data: MainContractObj.bytecode,
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
    gas: 400000,
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

    tran.on('error', console.error);
    return tran;
  });  
}


async function initDeployerContract(){
  let DeployerObj = new web3.eth.Contract(getContract('Deployer').abi);
  DeployerObj.deploy({
      data: DeployerObj.bytecode
  })
  .send({
      from: this.publicKey,
      gas: 1000000
  })
  .then((newContractInstance) => {
      console.log(newContractInstance.options.address)
      return newContractInstance.options.address;
  })
};


async function initMain () {
  //let MainContractAddress = null;
  // let accounts = [];
  
  MainContractInstance = await InitMainContract();
  
  //console.log('MainContractAddress', MainContractAddress);
  this.MainInstance = MainContractInstance;
}

module.exports = MainCtrl;