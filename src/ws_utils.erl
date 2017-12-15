%%%-------------------------------------------------------------------
%%% @author Wladimir David Zakrevskyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% This module contains all function for work with websockets
%%% @end
%%% Created : 14. Dez 2017 15:08
%%%-------------------------------------------------------------------
-module(ws_utils).
-author("Wladimir David Zakrevskyy").

%% API
-export([get_cookie/1]).

get_cookie(Req) ->
  lager:info("get cookie"),
  {CookieVal, _Req} = cowboy_req:cookie(<<"guid">>, Req),
  lager:info("cookie: ~p", [CookieVal]),
  CookieVal.
