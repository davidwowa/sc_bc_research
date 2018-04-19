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
-export([base64HashFrom/1]).
-export([hashFrom/1]).

hashFrom(Message) ->
  <<WW:512/big-unsigned-integer>> = crypto:hash(sha512, Message),
  integer_to_list(WW, 16).

base64HashFrom(S) -> base64:encode(crypto:hash(sha512, S)).

%io:fwrite(Output), io:fwrite("\n")