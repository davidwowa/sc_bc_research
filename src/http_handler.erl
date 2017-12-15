%%%-------------------------------------------------------------------
%%% @author Wladimir David Zakrevskyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% This module contains all methods for http
%%% @end
%%% Created : 14. Dez 2017 15:57
%%%-------------------------------------------------------------------
-module(http_handler).
-author("Wladimir David Zakrevskyy").

%% API
-export([init/2]).

%% TODO
init(Req0, Opts) ->
  lager:info("entry http handler"),
  lager:info("generate cookie"),
  NewValue = integer_to_list(rand:uniform(1000000)),
  lager:info("set cookie"),
  Req1 = cowboy_req:set_resp_cookie(<<"server">>, NewValue, Req0, #{path => <<"/">>}),
  lager:info("match cookies"),
  #{client := ClientCookie, server := ServerCookie}
    = cowboy_req:match_cookies([{client, [], <<>>}, {server, [], <<>>}], Req1),
  lager:info("get cookies on render"),
  %% TODO set cookie on page, in browser no effect and toppage_dtl become error
  {ok, Body} = toppage_dtl:render([{client, ClientCookie}, {server, ServerCookie}]),
  lager:info("reply cookie"),
  Req = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Req1),
  {ok, Req, Opts}.