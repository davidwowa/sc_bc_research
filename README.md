Erlang blockchain by Wladimir David Zakrevskyys
=====
An OTP application
##Install
**1.** Check folder `couchdb` and `mysql` for docker preparation.
**2.** Create Folder sandbox in your home folder
**3.** Run `clean_compile_run.sh` on unix, or `clean_compile_run.sh` on windows, or build own docker container, see below.

**TODO:** [GUI with wxErlang](http://www.idiom.com/~turner/wxtut/wxwidgets.html)  

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

## Key file generation with openssl and signing files

**TODO**: Import for key-files created with openssl.

**1.** Generate private key  
Option `-noout` say that the arguments which are used for key generation, not in file written.  
`openssl ecparam -genkey -name secp521r1 -noout -out private_key.pem`  
`openssl ec -in private_key.pem -text -noout` print key in hex-format(only for private key files).  
**2.** Generate public key  
`openssl ec -in private_key.pem -pubout -out public_key.pem`  
**3.** Sign message  
`openssl dgst -sha512 -sign private_key.pem message.txt > signature.der`  
With `hexdump signature.txt` you see signature file in hex-format.  
Or for readable for humans file use:  
`openssl dgst -sha512 -hex -sign private_key.pem message.txt > signature2.der`  
**4.** Verify signature, message and public key  
`openssl dgst -sha512 -verify public_key.pem -signature signature.der message.txt`

#Why Erlang?
[Why Erlang?](https://www.infoq.com/presentations/erlang-java-scala-go-c)  
[WebPages with Chicago Boss](https://github.com/ChicagoBoss/ChicagoBoss/wiki/Quickstart)  

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
[Real Time System Failures](https://c3.nasa.gov/dashlink/resources/624/)  
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