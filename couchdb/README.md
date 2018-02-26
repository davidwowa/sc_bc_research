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
`
docker run -ti -p 5984:5984 --name couchserver1 -v /Users/David/sandbox/chouchdb:/opt/couchdb/data -d --net testnetwork couchserver
`
4. Database available on `localhost:5984` and `http://localhost:5984/_utils/`

## [Finding your data with views](http://guide.couchdb.org/draft/views.html)  
