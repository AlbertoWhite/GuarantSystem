const getContract = require('./getContract');
const Web3 = require('web3');
const promiseWrap = require('./promiseWrap');
const Tx = require('ethereumjs-tx');

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
  callTest,
  test: {
    f: function () {console.log(this)}
  }
}
web3.eth.defaultAccount = MainCtrl.publicKey;

async function InitMainContract () {
  
  let rawTx = {
    nonce: web3.eth.getTransactionCount(MainCtrl.publicKey),
    data: MainContractObj.bytecode,
    gas: 6600000
  }
  
  let tx = new Tx(rawTx);
  tx.sign(Buffer.from(MainCtrl.privateKey, 'hex'));
  // tx.sign(Buffer.from('9b46b095f7d3b02c2ac2ca6a6877e115ec0c3a615b0d242330740bc673643943', 'hex'));
  let serializedTx = tx.serialize();
  let transactionHash = await promiseWrap(web3.eth.sendRawTransaction, ['0x'+serializedTx.toString('hex')]).then(d => {console.log(d);return new Promise((res, rej)=> {setTimeout(res.bind(null, d), 2000)})});
  console.log('transactionHash', transactionHash);
  var transactionReceipt = await promiseWrap(web3.eth.getTransactionReceipt, [transactionHash]).then(d => {
    if (!d) return new Promise((res, rej)=> {setTimeout(res.bind(null, d), 2000)})
      .then(console.log.bind(null, 'опа'))
      .then(()=>promiseWrap(web3.eth.getTransactionReceipt, [transactionHash]));
    return d;
  });
  // console.log('receipt', transactionReceipt);
  return transactionReceipt.contractAddress;
}

function registerManufacturer ({ownerId, name}) {
  // console.log('register man');
  // console.log(Object.keys(this));
  let MainAbi = this.abi;
  let rawTx = {
    nonce: web3.eth.getTransactionCount(this.publicKey),
    // data: this.MainInstance.registerManufacturer.getData(ownerId, name, 'phisical address', 'registration number'),
    gas: 400000,
    to: this.MainInstance.address,
    from: this.publicKey
  }
  
  
  let tx = new Tx(rawTx);
  tx.sign(Buffer.from(this.privateKey, 'hex'));
  // console.log(Object.getOwnPropertyDescriptor(tx, 'from'));
  // let serializedTx = tx.serialize();
  return promiseWrap(this.MainInstance.registerManufacturer.call, [ownerId, name, 'phisical address', 'registration number', rawTx]);
  return promiseWrap(web3.eth.sendRawTransaction, ['0x'+serializedTx.toString('hex')]);
}

function callTest () {
  let MainAbi = this.abi;
  let rawTx = {
    nonce: web3.eth.getTransactionCount(this.publicKey),
    // data: this.MainInstance.test.getData(),
    gas: 400000,
    to: this.MainInstance.address,
    // from: this.publicKey
  }
  
  
  let tx = new Tx(rawTx);
  tx.sign(Buffer.from(this.privateKey, 'hex'));
  // console.log(Object.getOwnPropertyDescriptor(tx, 'from'));
  // let serializedTx = tx.serialize();
  return this.MainInstance.test.call();
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