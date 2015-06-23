#!/bin/bash
source ~/.rvm/scripts/rvm
rvm --default $1
echo "gem: --no-rdoc --no-ri" >> ~/.gemrc