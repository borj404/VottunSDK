This CLI tool for Unix-like systems provides a straightforward way to interact with Vottun APIs from the terminal.

Feel free to modify the script to suit your needs.

## Prerequisites

Ensure that both _curl_ and _jq_ are installed on your system.

## Setup

Replace the content in lines 3-4 (between the quotation marks) with your own _App ID_ and _API key_, which you can easily obtain by accessing your [Vottun account](https://app.vottun.io/).

Enter your _email_ on line 5 to use the Custodied Wallets functions.

## Running the script

Navigate to the script’s location, make it executable, and run it:

```
chmod +x vottun-cli

./vottun-cli
```

### Or

Run within the current shell environment:

```
source vottun-cli
```

## Usage

Type the function and fill in the required parameters.

Press __⏎__ after each prompt to continue.

To undo the previous entry type __<<__ , __..__ , __!undo__ , __!back__ or __!del__

"All parameter inputs are handled dynamically, so you must ***not*** quote strings, even in arrays."

(Optional parameters are indicated in parentheses.)

All token amounts must be entered in standard units (without 18 decimals), not in wei as stated in the docs (e.g: 0.1, not 100,000,000,000,000,000).

## Menu & Docs

After launching the script, type _help_ to view the list of available functions.

For detailed information about the APIs included in this script, refer to the [documentation](https://docs.vottun.io/).

## Support

If you encounter any errors or bugs while running this script, please let me know.

For any issues or questions, contact me on [Discord](https://discord.com/users/1206334838093643817).

## Functions list

### IPFS

__up_file__: Upload a binary file to IPFS.

__up_folder__: Upload a folder or zip with multiple files to IPFS.

__up_metadata__: Upload a JSON file to IPFS.

### ERC-20

__deploy20__: Deploy an ERC-20 smart contract.

__transfer20__: Transfer tokens to an address.

__transfer_from__: Transfer tokens from a sender's account to a receiver's address.

__incr_allowance__: Grant a spender account the right to manage a specified amount of tokens.

__decr_allowance__: Revoke a spender account the right to manage a specified amount of tokens.

__allowance__: Display the total amount of tokens the owner has authorized the spender to transact.

__name__: Display the name of a smart contract.

__symbol__: Display the symbol of a smart contract.

__supply__: Display the total supply of tokens created in an ERC-20 smart contract.

__decimals__: Display the decimals used for tokens in an ERC-20 smart contract.

__balance20__: Display the balance of tokens held by an address.

### ERC-721

__deploy721__: Deploy an ERC-721 smart contract.

__mint721__: Mint an NFT with the provided metadata to the specified address.

__transfer721__: Transfer an NFT to an address.

__balance721__: Display the NFT balance of an address in the specified smart contract and network.

__uri721__: Display the metadata URI for an NFT in the specified contract.

__owner__: Display the address of the owner of an NFT.

### ERC-1155

__deploy1155__: Deploy an ERC-1155 smart contract.

__mint1155__: Mint the specified amount of copies of an NFT with the provided metadata to the given address.

__mint_batch__: Mint the specified amount of copies of multiple NFTs with the provided metadata to the given address.

__transfer1155__: Transfer the specified amount of copies of an NFT to the given address.

__transfer_batch__: Transfer the specified amount of copies of multiple NFTs to the given address.

__balance1155__: Display the amount of an NFT for the given address and smart contract on a specified network.

__uri1155__: Display the URI of the metadata for the NFT from the given contract.

### POAP

__deployPOAP__: Deploy a POAP smart contract and mint the tokens.

__transferPOAP__: Transfer an NFT to the given address.

__balancePOAP__: Display the amount of an NFT for the given address and smart contract on a specified network.

__uriPOAP__: Display the URI of the metadata for the NFT from the given contract.

### Custodied Wallets

__new_wallet__: Generates a one-time-use hash and retrieves the URL to create a new custodied wallet.

__get_address__: Retrieve the wallet's public address (for the 1st account) for one of our users.

__get_wallets__: Retrieve all custodied wallets created for you.

__otp__: Request a one-time email OTP to sign a mutable transaction within the next 120 seconds.

__send_tx__: Call any public function implemented in a smart contract and modify its state (for view or pure functions, use _query_).

__send_nat__: Transfer native assets from your custodied wallet.


### Web3 core

__deploy__: Deploy a smart contract on the blockchain of your choice.

__call_function__: Call any public function implemented in a smart contract and modify its state (for view or pure functions, use _query_).

__query__: Call any public function implemented in a smart contract without change its state (view or pure functions).

__get_nets__: Request the list of available blockchain networks.

__get_specs__: Request the list of available contract specifications.

__query_address__: Query an address to determine if it is a smart contract.

__query_tx__: Query transaction information from the blockchain.

__query_status__: Query the status of a transaction.

__query_ref__: Query the status of a transaction using the customer reference.

__query_gas__: Query the current gas price for a specified blockchain network.

__query_nat__: Query the balance of native currency for a specified address.

__gas_deploy__: Estimate the gas required for a smart contract deployment.

__gas_tx__: Estimate the gas required to call any public function implemented in a smart contract.

__gas_nat__: Estimate the gas required to transfer native assets.
