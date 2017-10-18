%%%-------------------------------------------------------------------
%% @doc blockchain public API
%% @end
%%%-------------------------------------------------------------------

-module(blockchain_app).

-behaviour(application).

-include("client.hrl").

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
%% 	lager:start(),
	{ok, _Apps1} = application:ensure_all_started(lager),
	{ok, _Apps2} = application:ensure_all_started(ranch),
	lager:info("CLIENT: ~p", [self()]),
	ok = setup_mnesia(),
	ok = setup_cowboy(),
    blockchain_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

setup_cowboy() ->
	lager:info("setup cowboy server"),
	Dispatch = cowboy_router:compile([
									  {'_', [                                                                       %% Hostname fuer den die Routen gelten
												{"/", cowboy_static, {priv_file, blockchain, "index.html"}},            
%% 												{"/client", ws_handler, []},            %% /websocket wird von dem Modul ws_handler ausgeliefert
												{"/static/[...]", cowboy_static, {priv_dir, blockchain, "static"}},
												{"/css/[...]", cowboy_static, {priv_dir, blockchain, "css"}}
											]}
									 ]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 5551}], [{env, [{dispatch, Dispatch}]}]),                        %% HTTP-Server starten
	ok.

setup_mnesia() ->
	lager:info("setup mnesia"),
	{ok, _Apps} = application:ensure_all_started(mnesia, permanent),
	case mnesia:wait_for_tables([clients], 5000) of                      %% are tables in mnesia ???
		ok ->
			lager:info("tables are created"),
			ok;
		_ ->
			lager:info("mnesia stop"),
			mnesia:stop(),
			ok = install_mnesia_tables()     
	end,
	ok.

install_mnesia_tables() ->
	lager:info("create schema"),
	mnesia:create_schema([node()]),
	lager:info("mnesia start"),
	ok = mnesia:start(),
	mnesia:create_table(client,                                         %% Dann werden Tabellen angelegt
						[{attributes, record_info(fields, client)},
						 {ram_copies, [node()]}]),
	ok.