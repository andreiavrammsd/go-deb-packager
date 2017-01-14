#!/bin/sh

export GOROOT=/usr/local/go
export GOPATH=/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

make clean
make init
make build 
make package
make clean
