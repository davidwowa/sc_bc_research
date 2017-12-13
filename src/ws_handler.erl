-module(ws_handler).

-export([init/2, terminate/3]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([websocket_terminate/3]).

init(Req, Opts) ->
  lager:info("init websocket handler"),
  {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
  lager:info("init websockets"),
  erlang:start_timer(1000, self(), <<"websocket initialized">>),
  {HashedPublicKey, HashedPrivateKey} = bc_utils:generate_key_paar(),
  {ok, State}.

%% receive
websocket_handle({text, Msg}, State) ->
  lager:info(<<Msg/binary>>),
  {reply, {text, <<"That's what she said! ", Msg/binary>>}, State};
websocket_handle(_Data, State) ->
  {ok, State}.

%% send
websocket_info({timeout, _Ref, Msg}, State) ->
  erlang:start_timer(1000, self(), <<"How' you doin'?">>),
  {reply, {text, Msg}, State};
websocket_info(_Info, State) ->
  {ok, State}.

websocket_terminate(_Reason, _Req, _State) ->
  lager:info("terminate websockets"),
  ok.

terminate(_Reason, _Req, _State) ->
  lager:info("terminate application"),
  ok.
