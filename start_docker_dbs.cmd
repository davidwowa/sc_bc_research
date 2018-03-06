@ECHO ON

echo start couchDB server on port 5984
docker start couchserver1
echo start MySQL server on port 3306
docker start mysqlserver1
docker ps
echo end