#Tendermint workflow
[Docker description here](https://tendermint.readthedocs.io/en/master/tools/docker.html)  
##Docker
0. Get containers  
`
docker pull tendermint/tendermint && docker pull tendermint/monitor
`  
1. Run container  
**Unix**  
`
docker run --rm -p 46657:46657 --name tendermint_bc -v /tmdata:/tendermint tendermint/tendermint init
`  

**Windows**  
[Issue on StackOverflow](https://stackoverflow.com/questions/49364444/docker-tendermint-container-not-work)  
This is workarround  
    a.  
`
docker run --rm -p 46657:46657 --name tendermint_bc tendermint/tendermint init
`  
    b.  
`
docker run --rm tendermint/tendermint show_validator
`   
This should be normal way  
`
docker run --rm -p 46657:46657 --name tendermint_bc -v "C:/Users/wdzak/sandbox/tendermind/tmdata:/tendermint" tendermint/tendermint init
`  
`
docker run --rm -v "C:/Users/wdzak/sandbox/tendermind/tmdata:/tendermint" tendermint/tendermint show_validator
`  
`
docker run --rm -d -v "C:/Users/wdzak/sandbox/tendermind/tmdata:/tendermint" tendermint/tendermint node
`
2. Logs  
`
docker logs tendermint_bc
`  
3. Start monitor  
`docker run -it --rm --link=tm tendermint/monitor tendermint_bc:46657`