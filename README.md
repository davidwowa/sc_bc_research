Erlang blockchain by Wladimir David Zakrevskyys
=====
An OTP application
##Install
**1.** Check folder `couchdb` and `mysql` for docker preparation.  
**2.** Create Folder sandbox in your home folder  
**3.** Run `clean_compile_run.sh` on unix, or `clean_compile_run.cmd` on windows, or build own docker container, see below.  

**TODO:** [GUI with wxErlang](http://www.idiom.com/~turner/wxtut/wxwidgets.html)  

##Docker
**1.** __Build container__  
`
docker build --build-arg password=pass --no-cache=true -t debian:erlang1 .
`  
**2.** __Create network__  
`
docker network create testnetwork
`  
**3.** __Run container__  
`
docker run -ti -p 5555:5555 --name bc --net testnetwork debian:erlang1
`  

## Key generation in erlang

**1.** __Generate keys__  
`{PublicKey, PrivKeyOut} = crypto:generate_key(ecdh, crypto:ec_curve(secp521r1)).`  
__Size__  
`bit_size(PublicKey).` give as result 1064  
`bit_size(PrivKeyOut).` give as result 528  
**2.** __Sign message__  
`Signature = crypto:sign(ecdsa, sha512, <<"test"">>, [PrivKeyOut, crypto:ec_curve(secp521r1)]).`  
**3.** __Verify signature__  
`crypto:verify(ecdsa, sha512, <<"test">>, Signature, [PublicKey, crypto:ec_curve(secp521r1)]).`  
**4.** __Base64__  
`bit_size(base64:encode(PublicKey)).` result 1440  
`bit_size(base64:encode(PrivKeyOut)).` result 704  
**5.** __RIPEMD160__  
`crypto:hash(ripemd160, PubKey).` result in 160 bits  
`crypto:hash(ripemd160, PrivKey).` result in 160 bits  
  
## Key file generation with openssl and signing files  

**TODO**: Import for key-files created with openssl.

**1.** __Generate private key__  
Option `-noout` say that the arguments which are used for key generation, not in file written.  
`openssl ecparam -genkey -name secp521r1 -noout -out private_key.pem`  
`openssl ec -in private_key.pem -text -noout` print key in hex-format(only for private key files).  
Use `-passout pass:foobar` for password __not with ec__.  
**2.** __Generate public key__  
`openssl ec -in private_key.pem -pubout -out public_key.pem`  
**3.** __Sign message__  
`openssl dgst -sha512 -sign private_key.pem message.txt > signature.der`  
With `hexdump signature.txt` you see signature file in hex-format.  
Or for readable for humans file use:  
`openssl dgst -sha512 -hex -sign private_key.pem message.txt > signature2.der`  
**4.** __Verify signature, message and public key__  
`openssl dgst -sha512 -verify public_key.pem -signature signature.der message.txt`

#Why Erlang?
[Why Erlang?](https://www.infoq.com/presentations/erlang-java-scala-go-c)  
[WebPages with Chicago Boss](https://github.com/ChicagoBoss/ChicagoBoss/wiki/Quickstart)  

#Current problems
__Work on merkle tree implementation__  
For List iteration `lists:foreach(fun (List_to_itteration) -> <<WWW:512/big-unsigned-integer>> = crypto:hash(sha512, [List_to_itteration]), Output = integer_to_list(WWW, 16), io:fwrite(Output), io:fwrite("\n") end, List).`  
But no idea for creating new list on the fly, an add new hashes.

**1.** __rebar3 integration in windows__  
[Github Issue new](https://github.com/erlang/rebar3/pull/1689)  
[Github Issue old](https://github.com/erlang/rebar3/issues/850)
[Github Issue Docker](https://github.com/erlang/rebar3/issues/1255)    
Yet no solution available!!  
**3.** __Websockets connection__  
**4.** __Logger problem__  
[Github Issue](https://github.com/erlang-lager/lager/issues/448)  

#For me
[Erlang Book Author Blog](https://ferd.ca/)  
[Cryptographic Key Length Recommendation](https://www.keylength.com/en/)  
[What is SOLID?](http://clean-code-developer.de/weitere-infos/solid/)  
[NASA Real Time System Failures](https://c3.nasa.gov/dashlink/resources/624/)  

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