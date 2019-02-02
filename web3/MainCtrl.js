const getContract = require('./getContract');
const Web3 = require('web3');
const promiseWrap = require('./promiseWrap');
const Tx = require('ethereumjs-tx');

const provider = "https://guarantee-test-bc2.herokuapp.com";

var web3 = new Web3(new Web3.providers.HttpProvider(provider), {
  // gasPrice: 1, gasLimit: 3000000
});
let MainContractObj = getContract('Main');

const MainCtrl = {
  publicKey: '0x50ed9bfc4e50c7c57eb71a22288f5118a082a050',
  privateKey: 'c01755ef9c8844e1e1b96412160b43f115c0536c1f7d1d4143f914b29e483996',
  provider,
  web3,
  initMain,
  registerManufacturer,
  test: {
    f: function () {console.log(this)}
  }
}
web3.eth.defaultAccount = MainCtrl.publicKey;

function InitMainContract () {
  
  let rawTx = {
    nonce: web3.eth.getTransactionCount(MainCtrl.publicKey),
    data: MainContractObj.bytecode,
    gas: 6600000
  }
  
  let tx = new Tx(rawTx);
  tx.sign(Buffer.from(MainCtrl.privateKey, 'hex'));
  let serializedTx = tx.serialize();
  return promiseWrap(web3.eth.sendRawTransaction, ['0x'+serializedTx.toString('hex')]);
}

function registerManufacturer ({ownerId, name}) {
  // console.log('register man');
  // console.log(Object.keys(this));
  let MainAbi = this.abi;
  let rawTx = {
    nonce: web3.eth.getTransactionCount(this.publicKey),
    data: this.MainInstance.registerManufacturer.getData(ownerId, name, 'phisical address', 'registration number'),
    gas: 300000,
    to: this.address
  }
  
  
  let tx = new Tx(rawTx);
  tx.sign(Buffer.from(this.privateKey, 'hex'));
  let serializedTx = tx.serialize();
  return promiseWrap(web3.eth.sendRawTransaction, ['0x'+serializedTx.toString('hex')]);
}



async function initMain () {
  let MainContractAddress = null;
  // let accounts = [];
  
  MainContractAddress = await InitMainContract();
  
  console.log('MainContractAddress', MainContractAddress);
  let MainContract = this.web3.eth.contract(MainContractObj.abi).at(MainContractAddress);
  this.MainInstance = MainContract;
}

module.exports = MainCtrl;