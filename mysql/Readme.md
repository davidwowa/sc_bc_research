# Problems
[Docker container problem on github: NOT NEEDED](https://gist.github.com/benschw/7391723)  

## workflow
1. Table descriptions in "create_schema.sql"

2. Build container form this folder with:  
`
docker build -t mysqlserver .
`
3. Create network in docker:  
`
docker network create testnetwork
`
4. Run container with  
`
docker run -ti -p 3306:3306 --name mysqlserver1 -v /Users/David/sandbox/mysql:/var/lib/mysql -d --net testnetwork mysqlserver
`
5. Database available on `localhost:3306`