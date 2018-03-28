#!/bin/bash

# Based on #curl -s 'localhost:46657/broadcast_tx_commit?tx="name=satoshi"'

HOST="127.0.0.1" # or "localhost"
PORT="46657"

CURLARGS="-s"

COUNTER=0
LIMIT=100000 # docker container wasted, after 5 min

echo "send on $HOST:$PORT $LIMIT messages"

while [  $COUNTER -lt $LIMIT ]; do
    let COUNTER=COUNTER+1
    KEY=$(uuidgen)
    VALUE=$(uuidgen)
    URL="'$HOST:$PORT/broadcast_tx_commit?tx=\"$KEY=$VALUE\"'"
    #echo "COUNTER=" $COUNTER
    # the curl use sub-shell see : https://stackoverflow.com/questions/32181222/curl-command-not-executing-via-shell-script-in-bash
    # & on end for more threads
    eval "curl $CURLARGS $URL &"
done