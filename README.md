# safecoin-block-explorer
Script to install and setup a safecoin block explorer on Ubuntu 16.04

On a fresh Ubuntu 16.04 server, from a non-root user's home directory, run the following commands:
```
sudo apt-get update

wget https://raw.githubusercontent.com/Fair-Exchange/safecoin-block-explorer/master/block-explorer.sh

bash block-explorer.sh
```
The script requires you to logout when it is finished, log back in and run part 2. It outputs the commands to do so.

The command to run the block explorer is output at the end of the second script. You probably want to manually run safecoind,
let it completely sync the blockchain until it is current with the latest block, stop it, and then fire up Insight, which
normally controls stopping and starting safecoind, otherwise when you first launch the block explorer it will timeout, exit
and kill safecoind.
The server runs in the foreground, and for production use you will want to run it in a tmux or screen session, or under a process manager such as supervisor.

- To install, the server needs its ssh key added to the bitecore-lib-safecoin repository.

- Once setup is complete, replace
safecoin-explorer/node_modules/insight-api-safecoin/lib/currency.js with currency.js-no-poloniex (rename)
and
safecoin-explorer/node_modules/insight-api-safecoin/node_modules/bitcore-lib-safecoin/lib/address.js with address.js-fixed (rename)

- To change the URL insight uses, modify ~/safecoin-explorer/node_modules/insight-ui-safecoin/bitcore-node-safecoin/index.js to use  this.routePrefix = ''; instead of this.routePrefix = 'insight';

- To change the port insight listens on web web requests to 80, do
```
sudo apt-get install libcap2-bin
sudo setcap cap_net_bind_service=+ep `readlink -f \`which node\``
```
and modify the port in ~/safecoin-explorer/bitcore-node.json

The block explorer will be available on http://localhost (if you changed port + routePrefix) and any additional IP addresses your server has bound to its network interface.

All actions performed by the script are thouroughly commented. 

-------

Blockchain explorer patches for zcashd by @str4d. This script and docs created under a commission by noashh and supernet


