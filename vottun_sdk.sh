#!/bin/bash

# Version 0.1.1

APP_ID="HERE YOUR APP ID"
API_KEY="HERE YOUR API KEY"

cat << banner

██╗░░░██╗░█████╗░████████████████╗██╗░░░██╗███╗░░██╗ ░█▀▀█ ▒█▀▀█ ▀█▀ █▀▀
██║░░░██║██╔══██╗╚══██╔═════██╔══╝██║░░░██║████╗░██║ ▒█▄▄█ ▒█▄▄█ ▒█░ ▀▀█
╚██╗░██╔╝██║░░██║░░░██║░░░░░██║░░░██║░░░██║██╔██╗██║ ▒█░▒█ ▒█░░░ ▄█▄ ▀▀▀
░╚████╔╝░██║░░██║░░░██║░░░░░██║░░░██║░░░██║██║╚████║
░░╚██╔╝░░╚█████╔╝░░░██║░░░░░██║░░░╚██████╔╝██║░╚███║
░░░╚═╝░░░░╚════╝░░░░╚═╝░░░░░╚═╝░░░░╚═════╝░╚═╝░░╚══╝ Scripted by @borj404

banner

help(){ # HELP MENU

cat << menu
The parameters must be entered after the function name, according to the stipulated order, separated by a space.
"Quotation marks should be used when the variable value contains spaces or special characters."
(Optional parameters are indicated between parentheses.)
If you want to omit an optional parameter but want to specify the next one, simply add "" in the place of that parameter.
For detailed information about this APIs visit: https://docs.vottun.io/

***AVAILABLE FUNCTIONS***

IPFS:
upload_file -> filename filePath
upload_folder -> filePath
upload_metadata -> name image description attributesTrait attributesValue

ERC-20:
deploy20 -> name symbol alias initialSupply network (gasLimit)
transfer20 -> contractAddress recipient network amount (gasLimit)
transfer_from -> contractAddress sender recipient network amount (gasLimit)
increase_allowance -> contractAddress spender network addedValue (gasLimit)
decrease_allowance -> contractAddress spender network substractedValue (gasLimit)
allowance -> contractAddress network owner spender
name -> contractAddress network
symbol -> contractAddress network
total_supply -> contractAddress network
decimals -> contractAddress network
balance_of20 -> contractAddress network address

ERC-721:
deploy721 -> name symbol network (alias) (gasLimit)
mint721 -> recipientAddress tokenId ipfsUri ipfsHash network contractAddress (royaltyPercentage) (gasLimit)
transfer721 -> contractAddress network id from to
balance_of721 -> contractAddress network address
token_uri721 -> contractAddress network id
owner_of -> contractAddress network id

ERC-1155:
deploy1155 -> name symbol ipfsUri royaltyRecipient royaltyValue network alias (gasLimit)
mint1155 -> contractAddress network to id amount
mint_batch -> contractAddress network to amount1 amount2 amount3 id1 id2 id3
transfer1155 -> contractAddress network to id amount
transfer_batch -> contractAddress network to id1 id2 id3 amount1 amount2 amount3
balance_of1155 -> contractAddress network address id
token_uri1155 -> contractAddress network id

POAP:
deployPOAP -> name amount ipfsUri network alias (gasLimit)
transferPOAP -> contractAddress network to id
balance_ofPOAP -> contractAddress network address id
token_uriPOAP -> contractAddress network id

...
Example:~$ upload_file "random image" "/home/user/Pictures/a_random_image.jpg"
Example:~$ deploy20 myToken TKN "My first token" 3000000000000000000 11155111 999999
Example:~$ mint721 0xad799...b63f1 1 https://ipfsgw.vottun.tech/ipfs/bafkr...sh2s6 bafkr...sh2s6 80002 0xa48dd...8f1ec "" 3000000
Example:~$ mint_batch 0x12d69...d7C7a2 97 0x423cd...aC137 999 666 333 1 2 3
menu
}


### IPFS ###

upload_file(){ # UPLOAD A BINARY FILE TO IPFS

local filename="$1"
local filePath="$2"

curl --location 'https://ipfsapi-v2.vottun.tech/ipfs/v2/file/upload' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--form 'filename="'"$filename"'"' \
--form 'file=@"'"$filePath"'"'
echo ""
}

upload_folder(){ # UPLOAD A ZIP WITH MULTIPLE FILES TO IPFS

local filePath="$1"

curl --location 'https://ipfsapi-v2.vottun.tech/ipfs/v2/upload/zip' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--form 'file=@"'"$filePath"'"'
echo ""
}

upload_metadata(){ # UPLOAD A JSON FILE TO IPFS

local name="$1"
local image="$2"
local description="$3"
local attributesTrait="$4"
local attributesValue="$5"

curl --location 'https://ipfsapi-v2.vottun.tech/ipfs/v2/file/metadata' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "'"$name"'",
    "image": "'"$image"'",
    "description": "'"$description"'",
    "attributes":[
        {
            "trait_type": "'"$attributesTrait"'",
            "value": '$attributesValue'
        }
    ]
}'
echo ""
}


### ERC-20 ###

deploy20(){ # DEPLOY AN ERC-20 SMART CONTRACT

local name="$1"
local symbol="$2"
local alias="$3"
local initialSupply="$4"
local network="$5"
local gasLimit="$6"

local data='{
    "name": "'"$name"'",
    "symbol": "'"$symbol"'",
    "alias": "'"$alias"'",
    "initialSupply": '$initialSupply',
    "network": '$network''

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/erc20/deploy' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

transfer20(){ # TRANSFER TOKENS TO ADDRESS

local contractAddress="$1"
local recipient="$2"
local network="$3"
local amount="$4"
local gasLimit="$5"

local data='{
    "contractAddress": "'"$contractAddress"'",
    "recipient": "'"$recipient"'",
    "network": '$network',
    "amount": '$amount''

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/erc20/transfer' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

transfer_from(){ # TRANSFER TOKENS FROM SENDER ACCOUNT TO RECEIVER ADDRESS

local contractAddress="$1"
local sender="$2"
local recipient="$3"
local network="$4"
local amount="$5"
local gasLimit="$6"

local data='{
    "contractAddress": "'"$contractAddress"'",
    "sender": "'"$sender"'",
    "recipient": "'"$recipient"'",
    "network": '$network',
    "amount": '$amount''

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/erc20/transferFrom' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

increase_allowance() { # GIVE THE RIGHT TO MANAGE THE STIPULATED AMOUNT OF TOKENS TO THE SPENDER ACCOUNT

local contractAddress="$1"
local spender="$2"
local network="$3"
local addedValue="$4"
local gasLimit="$5"

local data='{
    "contractAddress": "'"$contractAddress"'",
    "spender": "'"$spender"'",
    "network": '$network',
    "addedValue": '$addedValue''

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/erc20/increaseAllowance' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

decrease_allowance(){ # REMOVE THE RIGHT TO MANAGE THE STIPULATED AMOUNT OF TOKENS TO THE SPENDER ACCOUNT

local contractAddress="$1"
local spender="$2"
local network="$3"
local substractedValue="$4"
local gasLimit="$5"

local data='{
    "contractAddress": "'"$contractAddress"'",
    "spender": "'"$spender"'",
    "network": '$network',
    "substractedValue": '$substractedValue''

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/erc20/decreaseAllowance' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

allowance(){ # DISPLAY THE TOTAL AMOUNT OF TOKENS THE OWNER HAS AUTHORIZED THE SPENDER TO TRANSACT 

local contractAddress="$1"
local network="$2"
local owner="$3"
local spender="$4"

curl --location --request GET 'https://api.vottun.tech/erc/v1/erc20/allowance' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "owner": "'"$owner"'",
    "spender": "'"$spender"'"
}'
echo ""
}

name(){ # DISPLAY THE NAME OF A SMART CONTRACT

local contractAddress="$1"
local network="$2"

curl --location 'https://api.vottun.tech/erc/v1/erc20/name' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network'
}'
echo ""
}

symbol(){ # DISPLAY THE SYMBOL OF A SMART CONTRACT

local contractAddress="$1"
local network="$2"

curl --location 'https://api.vottun.tech/erc/v1/erc20/symbol' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network'
}'
echo ""
}

total_supply(){ # DISPLAY THE TOTAL SUPPLY OF TOKENS CREATED IN AN ERC-20 SMART CONTRACT

local contractAddress="$1"
local network="$2"

curl --location 'https://api.vottun.tech/erc/v1/erc20/totalSupply' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network'
}'
echo ""
}

decimals(){ # DISPLAY THE DECIMALS USED FOR THE TOKENS OF AN ERC-20 SMART CONTRACT

local contractAddress="$1"
local network="$2"

curl --location 'https://api.vottun.tech/erc/v1/erc20/decimals' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network'
}'
echo ""
}

balance_of20(){ # DISPLAY THE BALANCE OF TOKENS THAT AN ADDRESS HOLDS

local contractAddress="$1"
local network="$2"
local address="$3"

curl --location 'https://api.vottun.tech/erc/v1/erc20/balanceOf' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "address": "'"$address"'"
}'
echo ""
}


### ERC-721 ###

deploy721(){ # DEPLOY AN ERC-721 SMART CONTRACT

local name="$1"
local symbol="$2"
local network="$3"
local alias="$4"
local gasLimit="$5"

local data='{
    "name": "'"$name"'",
    "symbol": "'"$symbol"'",
    "network": '$network''

if [ -n "$alias" ]; then
    data+=',"alias":"'"$alias"'"'
fi

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/erc721/deploy' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

mint721(){ # MINT A NFT WITH THE PROVIDED METADATA TO THE GIVEN ADDRESS

local recipientAddress="$1"
local tokenId="$2"
local ipfsUri="$3"
local ipfsHash="$4"
local network="$5"
local contractAddress="$6"
local royaltyPercentage="$7"
local gasLimit="$8"

local data='{
    "recipientAddress": "'"$recipientAddress"'",
    "tokenId": '$tokenId',
    "ipfsUri": "'"$ipfsUri"'",
    "ipfsHash": "'"$ipfsHash"'",
    "network": '$network',
    "contractAddress": "'"$contractAddress"'"'

if [ -n "$royaltyPercentage" ]; then
    data+=',"royaltyPercentage":'$royaltyPercentage''
fi

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/erc721/mint' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

transfer721(){ # TRANSFER NFT TO ADDRESS

local contractAddress="$1"
local network="$2"
local id="$3"
local from="$4"
local to="$5"

curl --location 'https://api.vottun.tech/erc/v1/erc721/transfer' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "id": '$id',
    "from": "'"$from"'",
    "to": "'"$to"'"
}'
echo ""
}

balance_of721(){ # DISPLAY THE BALANCE OF THE ADDRESS IN THE SPECIFIED SMART CONTRACT AND NETWORK

local contractAddress="$1"
local network="$2"
local address="$3"

curl --location 'https://api.vottun.tech/erc/v1/erc721/balanceOf' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "address": "'"$address"'"
}'
echo ""
}

token_uri721(){ # DISPLAY THE URI OF THE METADATA OF THE NFT FROM THE GIVEN CONTRACT

local contractAddress="$1"
local network="$2"
local id="$3"

curl --location 'https://api.vottun.tech/erc/v1/erc721/tokenUri' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "id": '$id'
}'
echo ""
}

owner_of(){ # DISPLAY THE ADDRESS OF THE OWNER OF A NFT

local contractAddress="$1"
local network="$2"
local id="$3"

curl --location 'https://api.vottun.tech/erc/v1/erc721/ownerOf' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "id": '$id'
}'
echo ""
}


### ERC-1155 ###

deploy1155(){ # DEPLOY AN ERC-1155 SMART CONTRACT

local name="$1"
local symbol="$2"
local ipfsUri="$3"
local royaltyRecipient="$4"
local royaltyValue="$5"
local network="$6"
local alias="$7"
local gasLimit="$8"

local data='{
    "name": "'"$name"'",
    "symbol": "'"$symbol"'",
    "ipfsUri": "'"$ipfsUri"'",
    "royaltyRecipient": "'"$royaltyRecipient"'",
    "royaltyValue": '$royaltyValue',
    "network": '$network',
    "alias": "'"$alias"'"'

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/erc1155/deploy' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

mint1155(){ # MINT THE SPECIFIED AMOUNT OF COPIES OF A NFT WITH THE PROVIDED METADATA TO THE GIVEN ADDRESS

local contractAddress="$1"
local network="$2"
local to="$3"
local id="$4"
local amount="$5"

curl --location 'https://api.vottun.tech/erc/v1/erc1155/mint' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "to": "'"$to"'",
    "id": '$id',
    "amount": '$amount'
}'
echo ""
}

mint_batch(){ # MINT THE SPECIFIED AMOUNT OF COPIES OF MULTIPLE NFTS WITH THE PROVIDED METADATA TO THE GIVEN ADDRESS

local contractAddress="$1"
local network="$2"
local to="$3"
local amount1="$4"
local amount2="$5"
local amount3="$6"
local id1="$7"
local id2="$8"
local id3="$9"

curl --location 'https://api.vottun.tech/erc/v1/erc1155/mintbatch' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "to": "'"$to"'",
    "amounts": [
        '$amount1',
        '$amount2',
        '$amount3'
    ],
    "ids": [
        '$id1',
        '$id2',
        '$id3'
    ]
}'
echo ""
}

transfer1155(){ # TRANSFER THE SPECIFIED AMOUNT OF COPIES OF A NFT TO THE GIVEN ADDRESS

local contractAddress="$1"
local network="$2"
local to="$3"
local id="$4"
local amount="$5"

curl --location 'https://api.vottun.tech/erc/v1/erc1155/transfer' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "to": "'"$to"'",
    "id": '$id',
    "amount": '$amount'
}'
echo ""
}

transfer_batch(){ # TRANSFER THE SPECIFIED AMOUNT OF COPIES OF MULTIPLE NFTS TO THE GIVEN ADDRESS

local contractAddress="$1"
local network="$2"
local to="$3"
local id1="$4"
local id2="$5"
local id3="$6"
local amount1="$7"
local amount2="$8"
local amount3="$9"

curl --location 'https://api.vottun.tech/erc/v1/erc1155/transferBatch' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "to": "'"$to"'",
    "ids": [
        '$id1',
        '$id2',
        '$id3'
    ],
    "amounts": [
        '$amount1',
        '$amount2',
        '$amount3'
    ]
}'
echo ""
}

balance_of1155(){ # DISPLAY THE AMOUNT OF A SPECIFIC NFT FOR THE GIVEN ADDRESS AND SMART CONTRACT ON THE SPECIFIED NETWORK

local contractAddress="$1"
local network="$2"
local address="$3"
local id="$4"

curl --location 'https://api.vottun.tech/erc/v1/erc1155/balanceOf' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "address": "'"$address"'",
    "id": '$id'
}'
echo ""
}

token_uri1155(){ # DISPLAY THE URI OF THE METADATA OF THE NFT FROM THE GIVEN CONTRACT

local contractAddress="$1"
local network="$2"
local id="$3"

curl --location 'https://api.vottun.tech/erc/v1/erc1155/tokenUri' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "id": '$id'
}'
echo ""
}


### POAP ###

deployPOAP(){ # DEPLOY AN ERC-1155 SMART CONTRACT AND MINT THE TOKENS

local name="$1"
local amount="$2"
local ipfsUri="$3"
local network="$4"
local alias="$5"
local gasLimit="$6"

local data='{
    "name": "'"$name"'",
    "amount": '$amount',
    "ipfsUri": "'"$ipfsUri"'",
    "network": '$network',
    "alias": "'"$alias"'"'

if [ -n "$gasLimit" ]; then
    data+=',"gasLimit":'$gasLimit''
fi

data+='}'

curl --location 'https://api.vottun.tech/erc/v1/poap/deploy' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw "$data"

echo ""
}

transferPOAP(){ # TRANSFER THE SPECIFIED AMOUNT OF COPIES OF A NFT TO THE GIVEN ADDRESS

local contractAddress="$1"
local network="$2"
local to="$3"
local id="$4"

curl --location 'https://api.vottun.tech/erc/v1/poap/transfer' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "to": "'"$to"'",
    "id": '$id'
}'
echo ""
}

balance_ofPOAP(){ # DISPLAY THE AMOUNT OF A SPECIFIC NFT FOR THE GIVEN ADDRESS AND SMART CONTRACT ON THE SPECIFIED NETWORK

local contractAddress="$1"
local network="$2"
local address="$3"
local id="$4"

curl --location 'https://api.vottun.tech/erc/v1/poap/balanceOf' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "address": "'"$address"'",
    "id": '$id'
}'
echo ""
}

token_uriPOAP(){ # DISPLAY THE URI OF THE METADATA OF THE NFT FROM THE GIVEN CONTRACT

local contractAddress="$1"
local network="$2"
local id="$3"

curl --location 'https://api.vottun.tech/erc/v1/erc1155/tokenUri' \
--header 'x-application-vkn: '$APP_ID'' \
--header 'Authorization: Bearer '$API_KEY'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "contractAddress": "'"$contractAddress"'",
    "network": '$network',
    "id": '$id'
}'
echo ""
}
