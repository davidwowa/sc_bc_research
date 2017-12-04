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
-export([sha512/1]).
-export([dec_uns/1]).
-export([sha_test/1]).

generate_key_paar() ->
  %% {PublicKey, PrivKeyOut}
  crypto:generate_key(ecdh, crypto:ec_curve(secp521r1)).

sha512(V) when is_list(V) ->
  crypto:hash(sha512, V).

dec_uns(V) ->
  binary:decode_unsigned(V, big).

sha_test(S) -> <<X:256/big-unsigned-integer>> = crypto:hash(sha256, S),
  integer_to_list(X, 16).