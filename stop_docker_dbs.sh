#!/bin/bash

echo "stop couchDB server on port 5984"
docker stop couchserver1
echo "stop MySQL server on port 3306"
docker stop mysqlserver1
docker ps
echo "end"