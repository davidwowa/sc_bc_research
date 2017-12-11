-module(ws_handler).

-include_lib("stdlib/include/qlc.hrl").

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

%% Wird beim initialen Verbindungsaufbau aufgerufen und upgradet das Protokoll auf einen Websocket
init({tcp, http}, _Req, _Opts) ->
  {upgrade, protocol, cowboy_websocket}.

%% Wird aufgerufen, sobald der Websocket erstellt wurde
websocket_init(_TransportName, Req, _Opts) ->
  lager:info("init websocket"),
  {CookieVal, _} = cowboy_req:cookie(<<"guid">>, Req),
  {ok, Req, undefined_state}.

%% Behandelt eingehende Text-Nachrichten des Websockets
websocket_handle({text, Msg}, Req, State) ->
  %%lager:info("incomming message : ~p", [Msg]),
  {ok, Req, State};
websocket_handle(_Data, Req, State) ->
  {ok, Req, State}.


%% Behandelt eingehende Nachrichten anderer Erlang-Prozesse
websocket_info({{init_uuid, Name}, {message, Message}}, Req, State) when erlang:is_list(Message) andalso erlang:is_list(Name) ->
  CompleteMessage = lists:flatten(io_lib:format("~s", [Message])),
  {reply, {text, erlang:list_to_binary(CompleteMessage)}, Req, State};
websocket_info({{init_uuid, Name}, {message, Message}}, Req, State) when erlang:is_binary(Message) ->
  ListMessage = erlang:binary_to_list(Message),
  websocket_info({{init_uuid, Name}, {message, ListMessage}}, Req, State);
websocket_info({{init_uuid, Name}, {message, Message}}, Req, State) when erlang:is_binary(Name) ->
  ListName = erlang:binary_to_list(Name),
  websocket_info({{init_uuid, ListName}, {message, Message}}, Req, State).

%% Wird aufgerufen, wenn die Verbindung geschlossen wird
websocket_terminate(_Reason, _Req, State) ->
  relay_message(_Reason, "State").

%% Laedt alle Clients und startet die Nachrichtenvermittlung
relay_message(Msg, Name) ->
  Players = mnesia:dirty_all_keys(player),
  relay_message(Msg, Name, Players).

%% Leitet die Nachrichten an alle Clients weiter
relay_message(_Msg, _Name, []) ->
  ok;
relay_message(Msg, Name, [Player | Rest]) ->
  Player ! {{init_uuid, Name}, {message, Msg}},
  relay_message(Msg, Name, Rest).