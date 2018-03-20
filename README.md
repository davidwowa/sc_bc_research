Erlang blockchain by Wladimir David Zakrevskyys
=====
An OTP application
##Install
**1.** Check folder `couchdb` and `mysql` for docker preparation.
**2.** Create Folder sandbox in your home folder
**3.** Run `clean_compile_run.sh` on unix, or `clean_compile_run.sh` on windows, or build own docker container, see below.
##Docker
1. Build container  
`
docker build --build-arg password=pass --no-cache=true -t debian:erlang1 .
`
2. Create network  
`
docker network create testnetwork
`
3. Run container  
`
docker run -ti -p 5555:5555 --name bc --net testnetwork debian:erlang1
`  

#Why Erlang?
[Why Erlang?](https://www.infoq.com/presentations/erlang-java-scala-go-c)  
[WebPages with Chicago Boss](https://github.com/ChicagoBoss/ChicagoBoss/wiki/Quickstart)  
GUI Programming with wxErlang

#Current problems
1. rebar3 integration in windows  
[Github Issue new](https://github.com/erlang/rebar3/pull/1689)  
[Github Issue old](https://github.com/erlang/rebar3/issues/850)
[Github Issue Docker](https://github.com/erlang/rebar3/issues/1255)    
Yet no solution available!!
3. Websockets connection
4. Logger problem
[Github Issue](https://github.com/erlang-lager/lager/issues/448)  

#For me
[Erlang Book Author Blog](https://ferd.ca/)  
[Cryptographic Key Length Recommendation](https://www.keylength.com/en/)  
[What is SOLID?](http://clean-code-developer.de/weitere-infos/solid/)  
##Byte and Bit Calculation
```
%% bits
8 = bit_size(<<12>>).
16 = bit_size(<<0, 12>>).
...
%% bytes
3 = byte_size(<<0, 123, 2342323423423>>).

```
##Block calculation
````
%bitsize for sha512 in base64 public key

%bitsize for sha512 in base64 signature

%bitsize for sha512 in base64 public key

````