var Tx = require('ethereum-tx');
var getContract = require('../getContract');
var promiseWrap = require('./promiseWrap');

const MainCtrl = require('./MainCtrl');

async function createItem (
    manufacturerPublicKey,
    manufacturerPrivateKey,
    manufacturerAddress,
    serial,
    info,
    warrantyPeriod,
    warrantyTerms
) {
    let { web3 } = this.MainCtrl;
    var manufacturerABI = getContract('Manufacturer').abi;
    //Create object of Manufacturer
    var manufacturerInstance = web3.eth.contract(manufacturerABI).at(manufacturerAddress);
    //Create transaction for the 'sendRawTransation' method
    var rawTransaction = {
        nonce: web3.toHex(web3.eth.getTransactionCount(manufacturerPublicKey)),
        // gasPrice: 10000000000,
        gas: 6000000,
        to: manufacturerAddress,
        data: manufacturerInstance.createItem.getData(serial, info, warrantyPeriod, warrantyTerms)
    }
    var transaction = new Tx(rawTransaction);
    //Verify transaction
    transaction.sign(manufacturerPrivateKey);
    //Get the RLP encoding of the transaction 
    var serializedTransaction = transaction.serialize();
    //Get hash of the transaction
    var transactionHash = await promiseWrap(web3.eth.sendRawTransaction, ['0x' + serializedTransaction.toString('hex')]);
    //Waite for the verification of the transaction 
    var transactionReceipt = await promiseWrap(web3.eth.getTransactionReceipt, [transactionHash]);
    return transactionReceipt;
}

module.exports = {
  MainCtrl,
  createItem
}