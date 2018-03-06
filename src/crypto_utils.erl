%%%-------------------------------------------------------------------
%%% @author Wladimir David Zakrevskyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% This module contain crytpographic functions
%%% @end
%%% Created : 14. Dez 2017 11:47
%%%-------------------------------------------------------------------
-module(crypto_utils).
-author("Wladimir David Zakrevskyy").

%% API
-export([generate_key_paar/0]).
-export([sha512HashTo/1]).
-export([signMessageWith/2]).
-export([verifyMessage/3]).
-export([generate_key_paar_256k1/0]).

generate_key_paar() ->
  crypto:generate_key(ecdh, getEcdhParams521r1()).

generate_key_paar_256k1() ->
  crypto:generate_key(ecdh, getEcdhParams256k1()).

sha512HashTo(Message) when is_binary(Message) -> crypto:hash(getHash(), Message).

signMessageWith(PrivKeyOut, Message) ->
  crypto:sign(ecdsa, sha512, Message, [PrivKeyOut, getEcdhParams521r1()]).

verifyMessage(Signature, Message, PublicKey) ->
  crypto:verify(ecdsa, sha512, Message, Signature, [PublicKey, getEcdhParams521r1()]).

getHash() -> sha512.
getEcdhParams521r1() -> crypto:ec_curve(secp521r1).
getEcdhParams256k1() -> crypto:ec_curve(secp256k1).