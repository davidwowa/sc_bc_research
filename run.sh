#!/bin/bash

#TODO make it ready for windows

docker network ls

#TODO not working on osx, option -i is not allowed
#read -e -p "Enter docker network name:" -i "blockchain_network" network_name
#read -e -p "Enter docker mysqldb name:" -i "mysql_container" mysql_container
#read -e -p "Enter docker couchdb name:" -i "couchdb_container" couchdb_container
#read -e -p "Enter docker erlang app name:" -i "erlang_container" erlang_container

echo -n "enter docker network name:"
read -r network_name
echo -n "enter docker container name for mysql database:"
read -r mysql_container
echo -n "enter docker container name for couchdb database:"
read -r couchdb_container
echo -n "enter docker container name for erlang app:"
read -r erlang_container

echo -n "Git password:"
read -s password

echo "create docker network"
docker network create $network_name

echo "buid mysql container"
docker build -t mysqlserver ./mysql/
echo "run mysql db container"
docker run -ti -p 3306:3306 --name $mysql_container -v /Users/David/sandbox/mysql:/var/lib/mysql -d --net $network_name mysqlserver

echo "build couchdb container"
docker build -t couchserver ./couchdb/
echo "run couchdb container"
docker run -ti -p 5984:5984 --name $couchdb_container -v /Users/David/sandbox/chouchdb:/opt/couchdb/data -d --net $network_name couchserver

#TODO erlang container not starting because rebar3 command not found
echo "build erlang app container"
docker build --build-arg password=$password --no-cache=true -t debian:c_erlang .
echo "run erlang app container"
docker run -ti -p 5555:5555 --name $erlang_container --net $network_name debian:c_erlang