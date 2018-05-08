Smart Contract App by Wladimir David Zakrevskyys
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
`Signature = crypto:sign(ecdsa, sha512, <<"test">>, [PrivKeyOut, crypto:ec_curve(secp521r1)]).`  
**3.** __Verify signature__  
`crypto:verify(ecdsa, sha512, <<"test">>, Signature, [PublicKey, crypto:ec_curve(secp521r1)]).`  
**4.** __Base64__  
`bit_size(base64:encode(PublicKey)).` result 1440  
`bit_size(base64:encode(PrivKeyOut)).` result 704  
**5.** __RIPEMD160__  
`crypto:hash(ripemd160, PubKey).` result in 160 bits  
`crypto:hash(ripemd160, PrivKey).` result in 160 bits  

__TODO: Hex representation in erlang__  
[HEX in Erlang](http://www.enchantedage.com/hex-format-hash-for-md5-sha1-sha256-and-sha512)  

## Payout example  
**1.** __Generate keys for Bob, Alice and Eve__  
`{PublicKeyBOB, PrivKeyOutBOB} = crypto:generate_key(ecdh, crypto:ec_curve(secp521r1)).`  
`{PublicKeyALICE, PrivKeyOutALICE} = crypto:generate_key(ecdh, crypto:ec_curve(secp521r1)).`  
`{PublicKeyEVE, PrivKeyOutEVE} = crypto:generate_key(ecdh, crypto:ec_curve(secp521r1)).`  
`{PublicKeyDAVE, PrivKeyOutDAVE} = crypto:generate_key(ecdh, crypto:ec_curve(secp521r1)).`  
**2.** __Bob create message, which described transaction__  
`BOBSignature = crypto:sign(ecdsa, sha512, <<"send 10 coins to ALICE(public key from Alice here)">>, [PrivKeyOutBOB, crypto:ec_curve(secp521r1)]).`  
Message and Signature are sent in network. All users check following:  
`crypto:verify(ecdsa, sha512, <<"send 10 coins to ALICE(public key from Alice here)">>, BOBSignature, [PublicKeyBOB, crypto:ec_curve(secp521r1)]).`  
If result is `true` than send message on next neighbour, if `false` discard message.   
**3.** __Alice payout (Alice must know the message and signature which created Bob, is important for KYC)__  
Alice create new message with signature from Bob's, and sent in network.  
`ALICESignature = crypto:sign(ecdsa, sha512, BOBSignature, [PrivKeyOutALICE, crypto:ec_curve(secp521r1)]).`  
All users in network check following:  
`crypto:verify(ecdsa, sha512, BOBSignature, ALICESignature, [PublicKeyALICE, crypto:ec_curve(secp521r1)]).`  
if result is `true` than send message to next node, if `false` discard message. Checking balances happened also here.  
__Manipulation__  
If Eve try to manipulate message, than on following way:  
    **a.** Manipulate message, and uses Bob's signature  
    `crypto:verify(ecdsa, sha512, <<"send 10 coins to EVE(public key from Eve here)">>, BOBSignature, [PublicKeyBOB, crypto:ec_curve(secp521r1)]).`  
    result `false`.  
    **b.** Create wrong message and signature with help of third account from Dave  
    `DAVESignature = crypto:sign(ecdsa, sha512, <<"send 10 coins to EVE(public key from Eve here)">>, [PrivKeyOutDAVE, crypto:ec_curve(secp521r1)]).`  
    `EVESignature = crypto:sign(ecdsa, sha512, DAVESignature, [PrivKeyOutEVE, crypto:ec_curve(secp521r1)]).`  
    in this case other users muss check:  
    `crypto:verify(ecdsa, sha512, <<"send 10 coins to EVE(public key from Eve here)">>, DAVESignature, [PublicKeyDAVE, crypto:ec_curve(secp521r1)]).`  
    but prior muss be known, that on wallet from Dave exists 10 coins, from other transactions or from mining, this work made minders  

## Symetrical crypto for SC`s
[Derivated from stackoverflow](https://stackoverflow.com/questions/14550195/crypto-between-erlang-and-php?rq=1)  
__AES__ work with 128 bit blocks, key length is also 128 bit  
__Blowfish__ work with 64 bit length for key and 128 bit for data  
__DES(Data encryption standard)__ work with key length 56 bits, and block size 64 bit  
**1.** __Define your key__  
__AES__  
`AESKey = <<1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1>>.` on `bit_size(AESKey).` expected 128.  
__Blowfish__  
`BFKey = <<1,1,1,1,1,1,1,1>>.` on `bit_size(BFKey).` expected 64.  
__DES__  
`DESKey = <<1,1,1,1,1,1,1,1>>.` on `bit_size(DESKey).` expected 56. In Erlang key must be least 64 bit.    
**2.** __Define your data__  
__AES and Blowfish__  
`AESBFData = <<2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2>>.` on `bit_size(AESBFData).` expected 128.  
__DES__  
`DESData = <<2,2,2,2,2,2,2,2>>.` on `bit_size(DESData).` expected 64.  
**3.** __En- and Decrypt data__  
__AES__  
`AESCrypt = crypto:block_encrypt(aes_ecb, AESKey, AESBFData).`  
`AESDecrypt = crypto:block_decrypt(aes_ecb, AESKey, AESCrypt).`  
`io:format("AESDecrypt is ~s~n", [AESDecrypt]).`  
__Blowfish__  
`BFCrypt = crypto:block_encrypt(blowfish_ecb, BFKey, AESBFData).`  
`BFDecrypt = crypto:block_decrypt(blowfish_ecb, BFKey, BFCrypt).`  
`io:format("BFDecrypt is ~s~n", [BFDecrypt]).`  
__DES__  
`DESCrypt = crypto:block_encrypt(des_ecb, DESKey, DESData).`  
`DESDecrypt = crypto:block_decrypt(des_ecb, DESKey, DESCrypt).`  
`io:format("DESDecrypt is ~s~n", [DESDecrypt]).`  

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

## Hashing with openssl
`echo -n "foobar" | openssl dgst -sha256` possible hash functions show  
`openssl list-message-digest-commands`  
__Encode base64__  
`echo NDYuODEuMTIwLjE1MAo= | openssl enc -base64`  
__Decode base64__  
`echo NDYuODEuMTIwLjE1MAo= | openssl enc -base64 -d`

## Encoding and Decoding with openssl

Option ` -base64` is used as standard.  
Option `-k <password>` or `-pass pass:<secret>` use this password.
Option `-P` show salt, key and iv. 

**1.** __Encode File__ base64 encoding is used as default  
`openssl aes-256-cbc -a -salt -in secrets.txt -out secrets.txt.enc`  
without file  
`echo "secret" | openssl aes-256-cbc -base64 -e -a`  

**2.** __Decode File__  
`openssl aes-256-cbc -d -a -in secrets.txt.enc -out secrets.txt.new`  
without file  
`echo "U2FsdGVkX18gmZMWMGJncmUi+jXPNR3FwYumYvrd5pQ=" | openssl aes-256-cbc -d -a`

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