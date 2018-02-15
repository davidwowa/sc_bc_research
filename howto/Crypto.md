# Crypto in Erlang
[MyProblemOnStack](https://stackoverflow.com/questions/48723509/signing-of-datablock-as-hash-in-erlang-not-working-key-derivation-based-on-ec/48797942#48797942)  

## rough workflow

1. Configure crypto on ecdsa  
`
EcdhParams = crypto:ec_curve(secp521r1).
`
2. Generate public and private keys  
`
{PublicKey, PrivKeyOut} = crypto:generate_key(ecdh, EcdhParams).
`
3. Create data hash
`
Hash = crypto:hash(sha512, Message).
`
4. Create signature  
`
Signature = crypto:sign(ecdsa, sha512, Message, [PrivKeyOut, EcdhParams]).
`
or from hash  
`
Signature = crypto:sign(ecdsa, sha512, {digest, Hash}, [PrivKeyOut, EcdhParams]).
`
5. Verify signature  
`
Result = crypto:verify(ecdsa, sha512, Message2, Signature, [PublicKey, EcdhParams]).
`