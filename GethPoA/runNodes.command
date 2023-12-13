#!/bin/bash

# Two parallel arrays
directories=(
"GethPoA/bnode",
"GethPoA/node1"
"GethPoA/node2"
#"CMInhouse-Node-TimeSheet/server"
# ... add more directories as needed
)

commands=(
`bootnode -nodekey "/Users/harpindersingh/Documents/BlockChain/privateBlockchain/GethPoA/bnode/boot.key" -verbosity 7 -addr "127.0.0.1:30301"`
`geth --networkid 1995 --datadir "./data" \
--ipcpath "./data/geth.ipc" \
--bootnodes enode://ea2cdc3d9b605e07b280ac273c7faa804f89bdf3852a8b3d6bb7251e887b65b5031a3f2d441136a72ee196e62d0b9b711b1b037a48e1e1909ac3ee4e9912ad2d@127.0.0.1:30301 \
--port 30303 --http --http.corsdomain "*" --authrpc.port 8546 \
--http.api personal,eth,net,web3 \
--ws --ws.port 8547 \
--unlock 0xCc313E972afe1aE566d11957070bd560b42501f5 --password password.txt \
--miner.etherbase "0xCc313E972afe1aE566d11957070bd560b42501f5" --mine \
--allow-insecure-unlock`
`geth --networkid 1995 --datadir "./data" \
--ipcpath "./data/geth.ipc" \
--bootnodes enode://ea2cdc3d9b605e07b280ac273c7faa804f89bdf3852a8b3d6bb7251e887b65b5031a3f2d441136a72ee196e62d0b9b711b1b037a48e1e1909ac3ee4e9912ad2d@127.0.0.1:30301 \
--port 30304 --http --http.corsdomain "*" --http.port 8549 \
--http.api personal,eth,net,web3 \
--ws --ws.port 8550 \
--unlock 0xcEfa5Aa8E6B4E9A66E49276A1DB7Ea3dC267c8aB --password password.txt \
--miner.etherbase "0xcEfa5Aa8E6B4E9A66E49276A1DB7Ea3dC267c8aB" \
--allow-insecure-unlock`
)

# Ensure both arrays have the same length
if [ ${#directories[@]} -ne ${#commands[@]} ]; then
    echo "Error: directories and commands arrays have different lengths."
    exit 1
fi

# Function to run the command in a new terminal window
run_in_new_window() {
    local cmd="$1"
    osascript \
        -e "tell application \"Terminal\"" \
        -e "activate" \
        -e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
        -e "do script \"${cmd}\" in front window" \
        -e "end tell" > /dev/null
}

# Loop through each directory and run its corresponding command
for i in "${!directories[@]}"; do
    dir="${directories[$i]}"
    cmd="${commands[$i]}"
    
    if [ -d "$dir" ]; then
        echo "Running '$cmd' in $dir"
        run_in_new_window "cd $(pwd)/$dir && $cmd"
        sleep 1 # Optional: Give a short pause between starts
    else
        echo "Directory $dir does not exist!"
    fi
done
