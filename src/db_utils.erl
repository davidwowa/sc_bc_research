%%%-------------------------------------------------------------------
%%% @author Wladimrir David Zakrevskyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% This module contain functions for databases
%%% @end
%%% Created : 14. Dez 2017 15:10
%%%-------------------------------------------------------------------
-module(db_utils).
-author("Wladimir David Zakrevskyy").

-include("client.hrl").

%% API
-export([save_client/3]).

save_client(GUID, Ip, Address) ->
  lager:info("create new client"),
  Client = #client{pid = self(), guid = GUID, ip = Ip, address = Address},
  mnesia:dirty_write(Client),
  lager:info("client saved in mnesia").