#!/bin/bash

echo "switching to correct node version"
echo

# nvm setup

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


# switch node setup with nvm
nvm install v4

echo "---------------"
echo "installing bitcore dependencies"
echo

# install zeromq
sudo apt-get -y install libzmq3-dev

echo "---------------"
echo "installing safecoin patched bitcore"
echo 
npm install Fair-Exchange/bitcore-node-safecoin

echo "---------------"
echo "setting up bitcore"
echo

# setup bitcore
./node_modules/bitcore-node-safecoin/bin/bitcore-node create safecoin-explorer

cd safecoin-explorer


echo "---------------"
echo "installing insight UI"
echo

../node_modules/bitcore-node-safecoin/bin/bitcore-node install Fair-Exchange/insight-api-safecoin Fair-Exchange/insight-ui-safecoin


echo "---------------"
echo "creating config files"
echo

# point safecoin at mainnet
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-safecoin",
    "insight-ui-safecoin",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "$HOME/.safecoin",
        "exec": "safecoind"
      }
    }
  }
}

EOF

# create safecoin.conf
cd ~
mkdir .safecoin
touch .safecoin/safecoin.conf

cat << EOF > $HOME/.safecoin/safecoin.conf
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:8332
zmqpubhashblock=tcp://127.0.0.1:8332
rpcallowip=127.0.0.1
rpcport=8232
rpcuser=bitcoin
rpcpassword=local321
uacomment=bitcore
showmetrics=0

EOF


echo "---------------"
# start block explorer
echo "To start the block explorer, from within the safecoin-explorer directory issue the command:"
echo " nvm use v4; ./node_modules/bitcore-node-safecoin/bin/bitcore-node start"
