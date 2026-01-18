#!/usr/bin/env bash

# NODE SETUP ----------------------------
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts
