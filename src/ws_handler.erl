-module(ws_handler).

-export([init/2, terminate/3]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([websocket_terminate/3]).

init(Req, Opts) ->
  lager:info("init websocket handler"),
  {cowboy_websocket, Req, Opts, #{idle_timeout => 6000000}}.

websocket_init(State) ->
  lager:info("init websockets"),
  {ok, State}.

websocket_handle({text, Json}, State) ->
  Map = jsone:decode(Json),
  Message = maps:get(<<"messageKey">>, Map),
  JSON = logic:handle_data(Json, Message),
  Reply = {text, JSON},
  {reply, Reply, State};
%websocket_handle({text, Msg}, State) ->
%  {reply, {text, <<"message ", Msg/binary>>}, State};
websocket_handle(_Data, State) ->
  {ok, State}.

%% send
websocket_info({timeout, _Ref, Msg}, State) ->
  %erlang:start_timer(100, self(), <<"How' you doin'?">>),
  {reply, {text, Msg}, State};
websocket_info(_Info, State) ->
  {ok, State}.

websocket_terminate(_Reason, _Req, _State) ->
  lager:info("terminate websockets"),
  ok.

terminate(Reason, _Req, _State) ->
  lager:error("terminate websocket connection"),
  lager:error("websockets error ~p ", [Reason]),
  ok.
