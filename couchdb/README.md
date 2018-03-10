## workflow
1. Build container form this folder with:  
`
docker build -t couchserver .
`
2. Create network in docker:  
`
docker network create testnetwork
`
3. Run container with  
**OSX:**  
`
docker run -ti -p 5984:5984 --name couchserver1 -v /Users/David/sandbox/chouchdb:/opt/couchdb/data -d --net testnetwork couchserver
`  
**RPI:**(no container for arm available)    
`
docker run -ti -p 5984:5984 --name couchserver1 -v /home/pi/sandbox/chouchdb:/opt/couchdb/data -d --net testnetwork couchserver
`  
**Windows:**  
`
docker run -ti -p 5984:5984 --name couchserver1 -v C:/Users/wdzak/sandbox/couchdb:/opt/couchdb/data -d --net testnetwork couchserver
`
4. Database available on `localhost:5984` and `http://localhost:5984/_utils/`

##### [Finding your data with views](http://guide.couchdb.org/draft/views.html)  
