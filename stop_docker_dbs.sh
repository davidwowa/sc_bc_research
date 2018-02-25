#!/bin/bash

echo "start couchDB server on port 5984"
docker stop couchserver1
echo "start MySQL server on port 3306"
docker stop mysqlserver1
docker ps
echo "end"