#!/bin/bash

echo "switching to correct node version"
echo

# nvm setup

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


# switch node setup with nvm
nvm install v6

echo "---------------"
echo "installing bitcore dependencies"
echo


# install dependencies
sudo apt-get -y install nodejs-legacy
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
sudo apt-get install -y libzmq3-dev

# MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.1 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.1.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl enable mongod
sudo service mongod start

echo "---------------"
echo "installing safecoin patched bitcore"
echo 
npm install Fair-Exchange/bitcore-node-safecoin#dev

echo "---------------"
echo "setting up bitcore"
echo

# setup bitcore
./node_modules/bitcore-node-safecoin/bin/bitcore-node create safecoin-explorer

cd safecoin-explorer


echo "---------------"
echo "installing insight UI"
echo

../node_modules/bitcore-node-safecoin/bin/bitcore-node install Fair-Exchange/insight-api-safecoin#dev Fair-Exchange/insight-ui-safecoin#dev


echo "---------------"
echo "creating config files"
echo

# point safecoin at mainnet
cat << EOF > bitcore-node.json
{
  "network": "livenet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-safecoin",
    "insight-ui-safecoin",
    "web"
  ],
  "messageLog": "",
  "servicesConfig": {
      "web": {
      "disablePolling": false,
      "enableSocketRPC": false
    },
    "bitcoind": {
      "sendTxLog": "./data/pushtx.log",
      "spawn": {
        "datadir": "$HOME/.safecoin",
        "exec": "safecoind",
        "rpcqueue": 1000,
        "rpcport": 8771,
        "zmqpubrawtx": "tcp://127.0.0.1:28771",
        "zmqpubhashblock": "tcp://127.0.0.1:28771"
      }
    },
    "insight-api-safecoin": {
        "routePrefix": "api",
                 "db": {
                   "host": "127.0.0.1",
                   "port": "27017",
                   "database": "safecoin-api-livenet",
                   "user": "",
                   "password": ""
          },
          "disableRateLimiter": true
    },
    "insight-ui-safecoin": {
        "apiPrefix": "api",
        "routePrefix": ""
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
zmqpubrawtx=tcp://127.0.0.1:28771
zmqpubhashblock=tcp://127.0.0.1:28771
rpcport=8771
rpcallowip=127.0.0.1
rpcuser=bitcoin
rpcpassword=local321
uacomment=bitcore
mempoolexpiry=24
rpcworkqueue=1100
maxmempool=2000
dbcache=1000
maxtxfee=1.0
dbmaxfilesize=64
showmetrics=0
maxconnections=1000

EOF


echo "---------------"
# start block explorer
echo "To start the block explorer, from within the safecoin-explorer directory issue the command:"
echo " nvm use v4; ./node_modules/bitcore-node-safecoin/bin/bitcore-node start"
