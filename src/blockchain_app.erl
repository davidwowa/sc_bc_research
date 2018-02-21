%%%-------------------------------------------------------------------
%% @doc blockchain public API
%% @author Wladimir David Zakrevskyy <dmcvic@web.de>
%% @version 17.0.1
%% @end
%%%-------------------------------------------------------------------

-module(blockchain_app).

-behaviour(application).

-include("record.hrl").

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
  lager:start(),
  {ok, _Apps1} = application:ensure_all_started(lager),
  {ok, _Apps2} = application:ensure_all_started(ranch),
  application:start(sync),
  lager:info("CLIENT: ~p", [self()]),
  ok = setup_mnesia(),
  ok = setup_cowboy(),
  blockchain_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
  lager:info("stop application blockchain"),
  ok.

%%====================================================================
%% Internal functions
%%====================================================================

setup_cowboy() ->
  lager:info("setup cowboy server"),
  lager:info("configure routing"),
  Dispatch = cowboy_router:compile([
    {'_', [
%%      {'_', http_handler, []},
      {"/", cowboy_static, {priv_file, blockchain, "index.html"}},
      {"/websocket", ws_handler, []},
      {"/static/[...]", cowboy_static, {priv_dir, blockchain, "static"}},
      {"/css/[...]", cowboy_static, {priv_dir, blockchain, "css"}}
    ]}
  ]),
  lager:info("start http handler, port 5555"),
  {ok, _} = cowboy:start_clear(ssl, [{port, 5555}], #{env => #{dispatch => Dispatch}}),
  lager:info("setup server OK!"),
  %%websocket_sup:start_link(),
  ok.

setup_mnesia() ->
  lager:info("setup mnesia"),
  {ok, _Apps} = application:ensure_all_started(mnesia, permanent),
  case mnesia:wait_for_tables([pseudonym], 5000) of                      %% are tables in mnesia ???
    ok ->
      lager:info("tables are created"),
      ok;
    _ ->
      lager:info("mnesia stop"),
      mnesia:stop(),
      ok = install_mnesia_tables(),
      lager:info("tables are installed")
  end,
  lager:info("setup mnesia OK ! "),
  ok.

install_mnesia_tables() ->
  lager:info("create schema"),
  mnesia:create_schema([node()]),
  lager:info("mnesia start"),
  ok = mnesia:start(),
  mnesia:create_table(pseudonym,
    [{attributes, record_info(fields, pseudonym)},
      {ram_copies, [node()]}]),
  mnesia:create_table(block, [{attributes, record_info(fields, block)},
    {ram_copies, [node()]}]),
  mnesia:create_table(key, [{attributes, record_info(fields, key)},
    {ram_copies, [node()]}]),
  ok.