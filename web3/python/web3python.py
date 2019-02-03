import sys, getopt
import json

from web3 import Web3, HTTPProvider
from web3.middleware import geth_poa_middleware


class Contract:
    def __init__(self, web3, address, abi):
        self.gas_limit = 4300000
        self.gas_price = 22000000000
        self.web3 = web3
        # self.address = address
        # self.abi = abi
        self.contract = self.web3.eth.contract(address=address, abi=abi)

    def execute_call(self, function_name, signatory, *function_args):
        nonce = self.web3.eth.getTransactionCount(signatory.address)
        tx = {
            'gas': self.gas_limit,
            'gasPrice': self.gas_price,
            'nonce': nonce
        }
        transaction = self.contract.functions[function_name](*function_args).buildTransaction(tx)

        signed_tx = signatory.signTransaction(transaction)
        tx_hash = self.web3.eth.sendRawTransaction(signed_tx['rawTransaction'])
        receipt = self.web3.eth.waitForTransactionReceipt(tx_hash)
        return receipt


class MainContract(Contract):
    def __init__(self, web3, address, abi):
        super().__init__(web3, address, abi)

    def main(self):
        return self.contract.functions.main().call()
    #
    # def get_user(self, account):
    #     return self.contract.functions.getUser(account).call()

    def registerUser(self, _ownerID, signatory):
        receipt = self.execute_call('registerUser', signatory, _ownerID)
        return receipt

    def registerManufacturer (self, _ownerID, _name, _physicalAddress, _registrationNumber, signatory):
        receipt = self.execute_call('registerManufacturer', signatory, _ownerID, _name, _physicalAddress, _registrationNumber)
        return receipt

    def registerVendor(self, _ownerID, _name, _physicalAddress, _registrationNumber, signatory):
        receipt = self.execute_call('registerVendor', signatory, _ownerID, _name, _physicalAddress, _registrationNumber)
        return receipt

    def registerServiceCenter(self, _ownerID, _name, _physicalAddress, _registrationNumber, signatory):
        receipt = self.execute_call('registerServiceCenter', signatory, _ownerID, _name, _physicalAddress, _registrationNumber)
        return receipt

def printReceipt(receipt):
    receipt_dict = {}
    receipt_dict['contractAddress'] = receipt.contractAddress
    receipt_dict['transactionHash'] = Web3.toHex(receipt.transactionHash)

    print(receipt_dict)

def registerUser(ownerID):
    receipt = main_contract.registerUser(Web3.toChecksumAddress(ownerID))
    printReceipt(receipt)

def registerManufacturer(ownerID, name, physicalAddress, registrationNumber):
    receipt = main_contract.registerManufacturer(Web3.toChecksumAddress(ownerID), name, physicalAddress, registrationNumber, account)
    printReceipt(receipt)

def registerVendor(ownerID, name, physicalAddress, registrationNumber):
    receipt = main_contract.registerVendor(Web3.toChecksumAddress(ownerID), name, physicalAddress, registrationNumber, account)
    printReceipt(receipt)

def registerServiceCenter(ownerID, name, physicalAddress, registrationNumber):
    receipt = main_contract.registerServiceCenter(Web3.toChecksumAddress(ownerID), name, physicalAddress, registrationNumber, account)
    printReceipt(receipt)

def initWeb3():
    w3 = Web3(HTTPProvider('http://54.185.11.58:8545/'))
    w3.middleware_stack.inject(geth_poa_middleware, layer=0)

    contract_address = Web3.toChecksumAddress('0x5e333cedd8c7e124e8ef2a6160adc95e60c1ea31')

    with open('./abi.json') as abi_file:
        abi = json.load(abi_file)

    main_contract = MainContract(w3, contract_address, abi['MainContract'])

    private_key = Web3.toBytes(hexstr='0xcbaf33c3a7700ecb8f18df77df6526f2599ed3753f84929a23da0834315593da')
    account = w3.eth.account.privateKeyToAccount(private_key)
    return w3, main_contract, account


w3, main_contract, account = initWeb3()

argv = sys.argv
if (argv[1] == 'registerManufacturer'):
    registerManufacturer(argv[2], argv[3], argv[4], argv[5])
elif (argv[1] == 'registerUser'):
    registerUser(argv[2])
elif (argv[1] == 'registerVendor'):
    registerVendor(argv[2], argv[3], argv[4], argv[5])   
elif (argv[1] == 'registerServiceCenter'):
    registerServiceCenter(argv[2], argv[3], argv[4], argv[5])
