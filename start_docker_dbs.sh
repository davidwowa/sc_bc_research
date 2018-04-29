#!/bin/bash

echo "start couchDB server on port 5984"
docker start couchserver
echo "start MySQL server on port 3306"
docker start mysqlserver
docker ps
echo "end"
