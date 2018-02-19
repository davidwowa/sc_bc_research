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

generate_key_paar() ->
  lager:info("generate simple key paar over secp512r1 curve"),
  %%{PublicKey, PrivKeyOut} =
  crypto:generate_key(ecdh, getEcdhParams()).

sha512HashTo(Message) when is_binary(Message) -> crypto:hash(getHash(), Message).

signMessageWith(PrivKeyOut, Message) ->
  crypto:sign(ecdsa, sha512, Message, [PrivKeyOut, getEcdhParams()]).

verifyMessage(Signature, Message, PublicKey) ->
  crypto:verify(ecdsa, sha512, Message, Signature, [PublicKey, getEcdhParams()]).

getHash() -> sha512.
getEcdhParams() -> crypto:ec_curve(secp521r1).