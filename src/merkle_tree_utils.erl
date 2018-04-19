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
-export([add_to_list/2]).

add_to_list(List, Value) -> lists:append(List, Value).

