#!/bin/bash

docker network ls
echo -n "enter docker network name:"
read -r network_name
echo -n "enter docker container name for mysql database:"
read -r mysql_container
echo -n "enter docker container name for erlang app:"
read -r erlang_container

echo -n "Git password:"
read -s password

echo "create docker network"
docker create network $network_name
echo "buid mysql container"
docker build -t debian:c_mysql ./mysql/
echo "build erlang app container"
docker build --build-arg password=$password --no-cache=true -t debian:c_erlang .
echo "run mysql db container"
docker run -p 3306:3306 --name $mysql_container -d --net testnet debian:mysql
echo "run erlang app container"
docker run -ti -p 5555:5555 --name $erlang_container --net testnet debian:c_erlang