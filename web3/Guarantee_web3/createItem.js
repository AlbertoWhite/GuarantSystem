var getContract = require('../getContract');
var Tx = require('ethereum-tx');
var Web3 = require('web3');
var web3 = new Web3(web3.providers.HttpProvider("http://localhost:8545"));


module.exports = function (
    manufacturerPublicKey,
    manufacturerPrivateKey,
    manufacturerAddress, 
    serial, 
    info, 
    warrantyPeriod, 
    warrantyTerms) {

        var manufacturerABI = getContract('Manufacturer').abi;
        //Create object of Manufacturer
        var manufacturerInstance = web3.eth.contract(manufacturerABI).at(manufacturerAddress);
        //Create transaction for the 'sendRawTransation' method
        var rawTransaction = {
            nonce: web3.toHex(web3.eth.getTransactionCount(manufacturerPublicKey, (error, result) => {
                if (error) {
                    throw error;
                }
            })),
            gasPrice: 10000000000,
            gas: 1000000,
            to: manufacturerAddress,
            data: manufacturerInstance.createItem.getData(serial, info, warrantyPeriod, warrantyTerms)          
        }
        var transaction = new Tx(rawTransaction);
        //Verify transaction
        transaction.sign(manufacturerPrivateKey);
        //Get the RLP encoding of the transaction 
        var serializedTransaction = transaction.serialize();
        //Get hash of the transaction
        var transactionHash = web3.eth.sendRawTransaction('0x' + serializedTransaction.toString('hex'), (error, result) => {
            if (error) {
                throw error;
            }
        })
        //Waite for the verification of the transaction 
        var transactionReceipt = web3.eth.getTransactionReceipt(transactionHash, (error, result) => {
            if (error) {
                throw error;
            }
        })
    }