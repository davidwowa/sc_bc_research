#!/bin/bash

echo "start couchDB server on port 5984"
docker start couchdb
echo "start MySQL server on port 3306"
docker start mysqldb
docker ps
echo "end"
