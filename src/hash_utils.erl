%%%-------------------------------------------------------------------
%%% @author Wladimir David Zakrevskyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% This module contains all functions for working with hashing
%%% @end
%%% Created : 14. Dez 2017 11:50
%%%-------------------------------------------------------------------
-module(hash_utils).
-author("David").

%% API
-export([base64checkHashFrom/1]).

base64checkHashFrom(S) -> base64:encode(crypto:hash(sha512, S)).

getHEXValueOfKey(Key) when is_binary(Key) -> lists:flatten([integer_to_list(X, 16) || <<X>> <= Key]).

%% See http://sacharya.com/tag/integer-to-hex-in-erlang/
make_hash_from(S) ->
  lists:flatten(list_to_hex(binary_to_list(crypto:hash(sha512, S)))).

list_to_hex(L) ->
  lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 512 ->
  [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
  $0 + N;
hex(N) when N >= 10, N < 16 ->
  $a + (N - 10).