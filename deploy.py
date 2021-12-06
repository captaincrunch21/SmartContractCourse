from solcx import compile_standard
import json
from web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# get bytecode
byte_code = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]
# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]


# for connecting to Ganache
w3 = Web3(
    Web3.HTTPProvider("https://rinkeby.infura.io/v3/e8e975b086e7490fa7c20e2c9c138644")
)
chain_id = 4
my_address = "0xDa52EF0563773D632C4CcBc6673C44e857151df3"
private_key = os.getenv("PRIVATE_KEY")

# create the contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=byte_code)

# Get the lattest Transaction
nonce = w3.eth.getTransactionCount(my_address)


transaction = SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
        "gasPrice": w3.eth.gas_price,
    }
)

# sign transaction
signed_transaction = w3.eth.account.sign_transaction(transaction, private_key)

tx_hash = w3.eth.send_raw_transaction(signed_transaction.rawTransaction)
tx_recieved = w3.eth.wait_for_transaction_receipt(tx_hash)


# Working with Contract
simple_storage_contract = w3.eth.contract(address=tx_recieved.contractAddress, abi=abi)
# Call doesn't do a state Change.
# Transact function changes the state of the contract.
print(simple_storage_contract.functions.retrieve().call())

print("Making a transaction call to store number 15")
store_tx = simple_storage_contract.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce + 1,
        "gasPrice": w3.eth.gas_price,
    }
)
print("Waiting for the transaction to complete")
signed_store_txn = w3.eth.account.sign_transaction(store_tx, private_key)
tx_hash = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_reciept = w3.eth.wait_for_transaction_receipt(tx_hash)

print("Stored Nmber")
print(simple_storage_contract.functions.retrieve().call())
