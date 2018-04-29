#!/bin/bash

#echo "stop docker container"
#docker stop bc
echo "stop couchDB server on port 5984"
docker stop couchserver
echo "stop MySQL server on port 3306"
docker stop mysqlserver
docker ps
echo "end"
