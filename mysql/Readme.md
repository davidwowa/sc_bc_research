# Problems
[Docker container problem on github: NOT NEEDED](https://gist.github.com/benschw/7391723)  

## Workflow
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
**OSX:**  
`
docker run -ti -p 3306:3306 --name mysqlserver1 -v /Users/David/sandbox/mysql:/var/lib/mysql -d --net testnetwork mysqlserver
`  
**RPI:**  
`
docker run -ti -p 3306:3306 --name mysqlserver1 -v /home/pi/David/sandbox/mysql:/var/lib/mysql -d --net testnetwork mysqlserver
`  
**Windows:**  
[Problem if db data is stored local](https://stackoverflow.com/questions/48239668/fails-to-initialize-mysql-database-on-windows-10?noredirect=1&lq=1)  
[Possible solution, see Docker documentation](https://docs.docker.com/storage/volumes/#start-a-container-with-a-volume)  
[Create Issue on StackOverflow](https://stackoverflow.com/questions/49362167/mysql-docker-container-exited-after-start-option-d-has-no-effect)    
Data is in container  
`
docker run -ti -p 3306:3306 --name mysqlserver1 -d --net testnetwork mysqlserver
`  
Data on host  
`
docker run -ti -p 3306:3306 --name mysqlserver1 -v  C:/Users/wdzak/sandbox/mysql:/var/lib/mysql -d --net testnetwork mysqlserver --innodb_use_native_aio=0
`  
`  
docker run -ti -p 3306:3306 --name mysqlserver1 -v  E:/mysql:/var/lib/mysql -d --net testnetwork mysqlserver --innodb_use_native_aio=0
`
5. Database available on `localhost:3306`