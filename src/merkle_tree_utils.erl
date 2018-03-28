%%%-------------------------------------------------------------------
%%% @author David Zakrevskyy
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% TODO
%%% @end
%%% Created : 16. Mär 2018 21:48
%%%-------------------------------------------------------------------
-module(merkle_tree_utils).
-author("David").



%% API
-export([tail_recursive_fib/1]).

tail_recursive_fib(N) ->
  tail_recursive_fib(N, 0, 1, []).

tail_recursive_fib(0, _Current, _Next, Fibs) ->
  lists:reverse(Fibs);
tail_recursive_fib(N, Current, Next, Fibs) ->
  tail_recursive_fib(N - 1, Next, Current + Next, [Current|Fibs]).

get_merkle_root([])-> lager:warn("list for merkle root is empty");
get_merkle_root([H|T])-> crypto_utils:sha512HashTo(H++T).