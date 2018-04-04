#Parity

[Wiki](https://wiki.parity.io/Docker)  

**1.** Docker (__port is changed!__)  
`docker run -ti -p 8180:8180 -p 8545:8545 -p 8546:8546 -p 30304:30303 -p 30304:30303/udp parity/parity:v1.7.0 --ui-interface all --jsonrpc-interface all`  
__port is ok__  
`docker run -ti -p 8180:8180 -p 8545:8545 -p 8546:8546 -p 30303:30303 -p 30303:30303/udp parity/parity:v1.7.0 --ui-interface all --jsonrpc-interface all`  
**2.** Get secure token  
`docker exec -it container_name bash`  
`cd /parity`  
`parity signer new-token`  
Token example:`W4Lv-Y5FQ-umAF-FBkO`  
**3.** Run  
`http://localhost:8180/#/accounts/`  
