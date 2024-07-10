#!/bin/bash

# Version 0.2.0

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
mint_batch -> contractAddress network to id1 id2 id3 amount1 amount2 amount3
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
Example:~$ mint_batch 0x12d69...d7C7a2 97 0x423cd...aC137 1 2 3 999 666 333
menu
}


### IPFS ###

upload_file(){ # UPLOAD A BINARY FILE TO IPFS

    local filename="$1"
    local filePath="$2"

    if [ -z "$filename" ] || [ -z "$filePath" ]; then
        echo "Error: The parameters (filename, filePath) are mandatory."
        return 1
    fi
    
    echo ""
    echo "You have entered the following parameters:"
    echo "File Name: $filename"
    echo "File Path: $filePath"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://ipfsapi-v2.vottun.tech/ipfs/v2/file/upload' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --form 'filename="'"$filename"'"' \
            --form 'file=@"'"$filePath"'"'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

upload_folder(){ # UPLOAD A ZIP WITH MULTIPLE FILES TO IPFS

    local filePath="$1"

    if [ -z "$filePath" ]; then
        echo "Error: The parameter (filePath) is mandatory."
        return 1
    fi
    
    echo ""
    echo "You have entered the following parameter:"
    echo "File Path: $filePath"
    echo ""

    read -p "Do you want to proceed with this parameter? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://ipfsapi-v2.vottun.tech/ipfs/v2/upload/zip' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --form 'file=@"'"$filePath"'"'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

upload_metadata(){ # UPLOAD A JSON FILE TO IPFS

    local name="$1"
    local image="$2"
    local description="$3"
    local attributesTrait="$4"
    local attributesValue="$5"

    if [ -z "$name" ] || [ -z "$image" ] || [ -z "$description" ] || [ -z "$attributesTrait" ] || [ -z "$attributesValue" ]; then
        echo "Error: The parameters (name, image, description, attributesTrait, attributesValue) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Name: $name"
    echo "Image: $image"
    echo "Description: $description"
    echo "Attributes Trait: $attributesTrait"
    echo "Attributes Value: $attributesValue"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}


### ERC-20 ###

deploy20() { # DEPLOY AN ERC-20 SMART CONTRACT

    local name="$1"
    local symbol="$2"
    local alias="$3"
    local initialSupply="$4"
    local network="$5"
    local gasLimit="$6"

    if [ -z "$name" ] || [ -z "$symbol" ] || [ -z "$alias" ] || [ -z "$initialSupply" ] || [ -z "$network" ]; then
        echo "Error: The parameters (name, symbol, alias, initialSupply, network) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Name: $name"
    echo "Symbol: $symbol"
    echo "Alias: $alias"
    echo "Initial Supply: $initialSupply"
    echo "Network: $network"
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

transfer20(){ # TRANSFER TOKENS TO ADDRESS

    local contractAddress="$1"
    local recipient="$2"
    local network="$3"
    local amount="$4"
    local gasLimit="$5"

    if [ -z "$contractAddress" ] || [ -z "$recipient" ] || [ -z "$network" ] || [ -z "$amount" ]; then
        echo "Error: The parameters (contractAddress, recipient, network, amount) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Recipient: $recipient"
    echo "Network: $network"
    echo "Amount: $amount"
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

transfer_from(){ # TRANSFER TOKENS FROM SENDER ACCOUNT TO RECEIVER ADDRESS

    local contractAddress="$1"
    local sender="$2"
    local recipient="$3"
    local network="$4"
    local amount="$5"
    local gasLimit="$6"

    if [ -z "$contractAddress" ] || [ -z "$sender" ] || [ -z "$recipient" ] || [ -z "$network" ] || [ -z "$amount" ]; then
        echo "Error: The parameters (contractAddress, sender, recipient, network, amount) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Sender: $sender"
    echo "Recipient: $recipient"
    echo "Network: $network"
    echo "Amount: $amount"
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

increase_allowance() { # GIVE THE RIGHT TO MANAGE THE STIPULATED AMOUNT OF TOKENS TO THE SPENDER ACCOUNT

    local contractAddress="$1"
    local spender="$2"
    local network="$3"
    local addedValue="$4"
    local gasLimit="$5"

    if [ -z "$contractAddress" ] || [ -z "$spender" ] || [ -z "$network" ] || [ -z "$addedValue" ]; then
        echo "Error: The parameters (contractAddress, spender, network, addedValue) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Spender: $spender"
    echo "Network: $network"
    echo "Added Value: $addedValue"
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

decrease_allowance(){ # REMOVE THE RIGHT TO MANAGE THE STIPULATED AMOUNT OF TOKENS TO THE SPENDER ACCOUNT

    local contractAddress="$1"
    local spender="$2"
    local network="$3"
    local substractedValue="$4"
    local gasLimit="$5"

    if [ -z "$contractAddress" ] || [ -z "$spender" ] || [ -z "$network" ] || [ -z "$substractedValue" ]; then
        echo "Error: The parameters (contractAddress, spender, network, substractedValue) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Spender: $spender"
    echo "Network: $network"
    echo "Substracted Value: $substractedValue"
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

allowance(){ # DISPLAY THE TOTAL AMOUNT OF TOKENS THE OWNER HAS AUTHORIZED THE SPENDER TO TRANSACT 

    local contractAddress="$1"
    local network="$2"
    local owner="$3"
    local spender="$4"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$owner" ] || [ -z "$spender" ]; then
        echo "Error: The parameters (contractAddress, network, owner, spender) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "Owner: $owner"
    echo "Spender: $spender"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

name(){ # DISPLAY THE NAME OF A SMART CONTRACT

    local contractAddress="$1"
    local network="$2"

    if [ -z "$contractAddress" ] || [ -z "$network" ]; then
        echo "Error: The parameters (contractAddress, network) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc20/name' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network'
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

symbol(){ # DISPLAY THE SYMBOL OF A SMART CONTRACT

    local contractAddress="$1"
    local network="$2"

    if [ -z "$contractAddress" ] || [ -z "$network" ]; then
        echo "Error: The parameters (contractAddress, network) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc20/symbol' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network'
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

total_supply(){ # DISPLAY THE TOTAL SUPPLY OF TOKENS CREATED IN AN ERC-20 SMART CONTRACT

    local contractAddress="$1"
    local network="$2"

    if [ -z "$contractAddress" ] || [ -z "$network" ]; then
        echo "Error: The parameters (contractAddress, network) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc20/totalSupply' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network'
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

decimals(){ # DISPLAY THE DECIMALS USED FOR THE TOKENS OF AN ERC-20 SMART CONTRACT

    local contractAddress="$1"
    local network="$2"

    if [ -z "$contractAddress" ] || [ -z "$network" ]; then
        echo "Error: The parameters (contractAddress, network) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc20/decimals' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network'
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

balance_of20(){ # DISPLAY THE BALANCE OF TOKENS THAT AN ADDRESS HOLDS

    local contractAddress="$1"
    local network="$2"
    local address="$3"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$address" ]; then
        echo "Error: The parameters (contractAddress, network, address) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "Address: $address"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc20/balanceOf' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network',
                "address": "'"$address"'"
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}


### ERC-721 ###

deploy721(){ # DEPLOY AN ERC-721 SMART CONTRACT

    local name="$1"
    local symbol="$2"
    local network="$3"
    local alias="$4"
    local gasLimit="$5"

    if [ -z "$name" ] || [ -z "$symbol" ] || [ -z "$network" ]; then
        echo "Error: The parameters (name, symbol, network) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Name: $name"
    echo "Symbol: $symbol"
    echo "Network: $network"
    if [ -n "$alias" ]; then
        echo "Alias: $alias"
    fi
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
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

    if [ -z "$recipientAddress" ] || [ -z "$tokenId" ] || [ -z "$ipfsUri" ] || [ -z "$ipfsHash" ] || [ -z "$network" ] || [ -z "$contractAddress" ]; then
        echo "Error: The parameters (recipientAddress, tokenId, ipfsUri, ipfsHash, network, contractAddress) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Recipient Address: $recipientAddress"
    echo "Token ID: $tokenId"
    echo "IPFS Uri: $ipfsUri"
    echo "IPFS Hash: $ipfsHash"
    echo "Network: $network"
    echo "Contract Address: $contractAddress"
    if [ -n "$royaltyPercentage" ]; then
        echo "Royalty Percentage: $royaltyPercentage"
    fi
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

transfer721(){ # TRANSFER NFT TO ADDRESS

    local contractAddress="$1"
    local network="$2"
    local id="$3"
    local from="$4"
    local to="$5"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$id" ] || [ -z "$from" ] || [ -z "$to" ]; then
        echo "Error: The parameters (contractAddress, network, id, from, to) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "ID: $id"
    echo "From: $from"
    echo "To: $to"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

balance_of721(){ # DISPLAY THE BALANCE OF THE ADDRESS IN THE SPECIFIED SMART CONTRACT AND NETWORK

    local contractAddress="$1"
    local network="$2"
    local address="$3"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$address" ]; then
        echo "Error: The parameters (contractAddress, network, address) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "Address: $address"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc721/balanceOf' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network',
                "address": "'"$address"'"
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

token_uri721(){ # DISPLAY THE URI OF THE METADATA OF THE NFT FROM THE GIVEN CONTRACT

    local contractAddress="$1"
    local network="$2"
    local id="$3"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$id" ]; then
        echo "Error: The parameters (contractAddress, network, id) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "ID: $id"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc721/tokenUri' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network',
                "id": '$id'
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

owner_of(){ # DISPLAY THE ADDRESS OF THE OWNER OF A NFT

    local contractAddress="$1"
    local network="$2"
    local id="$3"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$id" ]; then
        echo "Error: The parameters (contractAddress, network, id) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "ID: $id"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc721/ownerOf' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network',
                "id": '$id'
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
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

    if [ -z "$name" ] || [ -z "$symbol" ] || [ -z "$ipfsUri" ] || [ -z "$royaltyRecipient" ] || [ -z "$royaltyValue" ] || [ -z "$network" ] || [ -z "$alias" ]; then
        echo "Error: The parameters (name, symbol, ipfsUri, royaltyRecipient, royaltyValue, network, alias) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Name: $name"
    echo "Symbol: $symbol"
    echo "IPFS Uri: $ipfsUri"
    echo "Royalty Recipient: $royaltyRecipient"
    echo "Royalty Value: $royaltyValue"
    echo "Network: $network"
    echo "Alias: $alias"
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

mint1155(){ # MINT THE SPECIFIED AMOUNT OF COPIES OF A NFT WITH THE PROVIDED METADATA TO THE GIVEN ADDRESS

    local contractAddress="$1"
    local network="$2"
    local to="$3"
    local id="$4"
    local amount="$5"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$to" ] || [ -z "$id" ] || [ -z "$amount" ]; then
        echo "Error: The parameters (contractAddress, network, to, id, amount) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "To: $to"
    echo "ID: $id"
    echo "Amount: $amount"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

mint_batch(){ # MINT THE SPECIFIED AMOUNT OF COPIES OF MULTIPLE NFTS WITH THE PROVIDED METADATA TO THE GIVEN ADDRESS

    local contractAddress="$1"
    local network="$2"
    local to="$3"
    local id1="$4"
    local id2="$5"
    local id3="$6"
    local amount1="$7"
    local amount2="$8"
    local amount3="$9"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$to" ] || [ -z "$id1" ] || [ -z "$id2" ] || [ -z "$id3" ] || [ -z "$amount1" ] || [ -z "$amount2" ] || [ -z "$amount3" ]; then
        echo "Error: The parameters (contractAddress, network, to, id1, id2, id3, amount1, amount2, amount3) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "To: $to"
    echo "ID 1: $id1"
    echo "ID 2: $id2"
    echo "ID 3: $id3"
    echo "Amount 1: $amount1"
    echo "Amount 2: $amount2"
    echo "Amount 3: $amount3"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc1155/mintbatch' \
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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

transfer1155(){ # TRANSFER THE SPECIFIED AMOUNT OF COPIES OF A NFT TO THE GIVEN ADDRESS

    local contractAddress="$1"
    local network="$2"
    local to="$3"
    local id="$4"
    local amount="$5"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$to" ] || [ -z "$id" ] || [ -z "$amount" ]; then
        echo "Error: The parameters (contractAddress, network, to, id, amount) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "To: $to"
    echo "ID: $id"
    echo "Amount: $amount"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
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

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$to" ] || [ -z "$id1" ] || [ -z "$id2" ] || [ -z "$id3" ] || [ -z "$amount1" ] || [ -z "$amount2" ] || [ -z "$amount3" ]; then
        echo "Error: The parameters (contractAddress, network, to, id1, id2, id3, amount1, amount2, amount3) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "To: $to"
    echo "ID 1: $id1"
    echo "ID 2: $id2"
    echo "ID 3: $id3"
    echo "Amount 1: $amount1"
    echo "Amount 2: $amount2"
    echo "Amount 3: $amount3"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

balance_of1155(){ # DISPLAY THE AMOUNT OF A SPECIFIC NFT FOR THE GIVEN ADDRESS AND SMART CONTRACT ON THE SPECIFIED NETWORK

    local contractAddress="$1"
    local network="$2"
    local address="$3"
    local id="$4"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$address" ] || [ -z "$id" ]; then
        echo "Error: The parameters (contractAddress, network, address, id) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "Address: $address"
    echo "ID: $id"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

token_uri1155(){ # DISPLAY THE URI OF THE METADATA OF THE NFT FROM THE GIVEN CONTRACT

    local contractAddress="$1"
    local network="$2"
    local id="$3"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$id" ]; then
        echo "Error: The parameters (contractAddress, network, id) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "ID: $id"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc1155/tokenUri' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network',
                "id": '$id'
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}


### POAP ###

deployPOAP(){ # DEPLOY A POAP SMART CONTRACT AND MINT THE TOKENS

    local name="$1"
    local amount="$2"
    local ipfsUri="$3"
    local network="$4"
    local alias="$5"
    local gasLimit="$6"

    if [ -z "$name" ] || [ -z "$amount" ] || [ -z "$ipfsUri" ] || [ -z "$network" ] || [ -z "$alias" ]; then
        echo "Error: The parameters (name, amount, ipfsUri, network, alias) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Name: $name"
    echo "Amount: $amount"
    echo "IPFS Uri: $ipfsUri"
    echo "Network: $network"
    echo "Alias: $alias"
    if [ -n "$gasLimit" ]; then
        echo "Gas Limit: $gasLimit"
    fi
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

transferPOAP(){ # TRANSFER THE SPECIFIED AMOUNT OF COPIES OF A NFT TO THE GIVEN ADDRESS

    local contractAddress="$1"
    local network="$2"
    local to="$3"
    local id="$4"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$to" ] || [ -z "$id" ]; then
        echo "Error: The parameters (contractAddress, network, to, id) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "To: $to"
    echo "ID: $id"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

balance_ofPOAP(){ # DISPLAY THE AMOUNT OF A SPECIFIC NFT FOR THE GIVEN ADDRESS AND SMART CONTRACT ON THE SPECIFIED NETWORK

    local contractAddress="$1"
    local network="$2"
    local address="$3"
    local id="$4"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$address" ] || [ -z "$id" ]; then
        echo "Error: The parameters (contractAddress, network, address, id) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "Address: $address"
    echo "ID: $id"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

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

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}

token_uriPOAP(){ # DISPLAY THE URI OF THE METADATA OF THE NFT FROM THE GIVEN CONTRACT

    local contractAddress="$1"
    local network="$2"
    local id="$3"

    if [ -z "$contractAddress" ] || [ -z "$network" ] || [ -z "$id" ]; then
        echo "Error: The parameters (contractAddress, network, id) are mandatory."
        return 1
    fi

    echo ""
    echo "You have entered the following parameters:"
    echo "Contract Address: $contractAddress"
    echo "Network: $network"
    echo "ID: $id"
    echo ""

    read -p "Do you want to proceed with these parameters? (Y/N): " confirm
    case "$confirm" in
        [Yy]*)
            echo ""

            curl --location 'https://api.vottun.tech/erc/v1/erc1155/tokenUri' \
            --header 'x-application-vkn: '$APP_ID'' \
            --header 'Authorization: Bearer '$API_KEY'' \
            --header 'Content-Type: application/json' \
            --data-raw '{
                "contractAddress": "'"$contractAddress"'",
                "network": '$network',
                "id": '$id'
            }'

            ;;
        [Nn]*)
            echo ""
            echo "Process cancelled."
            return 0
            ;;
        *)
            echo ""
            echo "Invalid input. Process cancelled."
            return 1
            ;;
    esac
    echo ""
}
