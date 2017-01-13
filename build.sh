#!/bin/sh

export PACKAGE="pkgdaemon"
export VERSION="1.0.5"
export MAINTAINER="Andrei Avram <avramandrei@ymail.com>"
export SHORT_DESCRIPTION="The short description"
export DESCRIPTION="The long description text of the package"
export BUILD=`git rev-parse HEAD`
export LDFLAGS="-ldflags \"-X main.Version=${VERSION} -X main.Build=${BUILD}\""

make clean
make init
make build 
make package
make clean
