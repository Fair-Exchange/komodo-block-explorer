#!/bin/bash

echo "downloading part2"
echo

wget https://raw.githubusercontent.com/Fair-Exchange/safecoin-block-explorer/master/block-explorer-part2.sh

echo "---------------"
# Install safecoin dependencies:

echo "installing safecoin"
echo

sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake curl libcurl4-gnutls-dev 

# download zcash source from fork with block explorer patches
git clone https://github.com/Fair-Exchange/safecoin.git safecoin

cd safecoin

# download proving parameters
./zcutil/fetch-params.sh

# build patched safecoin
./zcutil/build.sh -j$(nproc)

# install safecoin
sudo cp src/safecoind /usr/local/bin/
sudo cp src/safecoin-cli /usr/local/bin/

echo "---------------"
echo "installing node and npm"
echo

# install node and dependencies
cd ..
sudo apt-get -y install npm

echo "---------------"
echo "installing nvm"
echo

# install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

echo "logout of this shell, log back in and run:"
echo "bash block-explorer-part2.sh"

