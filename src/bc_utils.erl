%%%-------------------------------------------------------------------
%%% @author Wladimir David Zakrevskyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Dez 2017 00:04
%%%-------------------------------------------------------------------
-module(bc_utils).
-author("Wladimir David Zakrevskyy").

%% API
-export([generate_key_paar/0]).
-export([sha_hex/1]).
-export([int_to_hex/1]).
-export([list_to_hex/1]).
-export([hex/1]).

generate_key_paar() ->
  lager:info("generate key paar"),
  {PublicKey, PrivKeyOut} = crypto:generate_key(ecdh, crypto:ec_curve(secp521r1)),
  lager:info("keys: public key:~p private key:~p \n", [PublicKey, PrivKeyOut]),
  %% TODO here next
  HashedPublicKey = sha512(sha_test(PublicKey)),
  HashedPrivateKey = sha512(sha_test(PrivKeyOut)),
  lager:info("hashed keys: public key:~p private key:~p \n", [HashedPublicKey, HashedPrivateKey]),
  {HashedPublicKey, HashedPrivateKey}.

%% See http://sacharya.com/tag/integer-to-hex-in-erlang/
sha_hex(S) ->
  SHA_bin =  crypto:hash(sha512, S),
  SHA_list = binary_to_list(SHA_bin),
  lists:flatten(list_to_hex(SHA_list)).

list_to_hex(L) ->
  lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 512 ->
  [hex(N div 16), hex(N rem 16)].
hex(N) when N < 10 ->
  $0+N;
hex(N) when N >= 10, N < 16 ->
  $a + (N-10).