#!/bin/sh

HOST=127.0.0.1
DIR=/
FILE=pkg_1.0.0.deb
TMP=/tmp/${FILE}
curl ${HOST}${DIR}${FILE} > ${TMP} && sudo dpkg -i ${TMP} && rm ${TMP}

# curl http://127.0.0.1/install.sh | sh
