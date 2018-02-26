%%%-------------------------------------------------------------------
%%% @author David Zakrevskyy
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Feb 2018 17:55
%%%-------------------------------------------------------------------
-module(time_utils).
-author("David").

%% API
-export([current_timestamp/0]).

current_timestamp() ->
  os:perf_counter(nanosecond).