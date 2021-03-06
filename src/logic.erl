%%%-------------------------------------------------------------------
%%% @author David Zakrevskyy
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Feb 2018 18:46
%%%-------------------------------------------------------------------
-module(logic).
-author("David Zakrevskyy").

-include("record.hrl").

%% API
-export([handle_data/2]).
-export([mining/0]).

handle_data(Json, <<"keys">>) ->
  {PublicKey, PrivKeyOut} = crypto_utils:generate_key_paar(),
  % TODO need a money theorem
  Deposit = rand:uniform(1000),
  TT = time_utils:current_timestamp(),
  Doc = {[{keys, [public_key, base64:encode(PublicKey), private_key, base64:encode(PrivKeyOut), tt, TT, deposit, Deposit]}]},
  Map = jsone:decode(Json),
  GUID = maps:get(<<"guid">>, Map),
  Ip = maps:get(<<"ip">>, Map),
  db_utils:save_pseudonym(GUID, base64:encode(PublicKey), Ip, Deposit, TT),
  db_utils:save_keys(base64:encode(PublicKey), base64:encode(PrivKeyOut), TT),
  jsone:encode(Doc);
handle_data(Json, <<"sign">>) ->
  Map = jsone:decode(Json),
  Message = maps:get(<<"message">>, Map),
  PrivateKey = maps:get(<<"privateKey">>, Map),
  PublicKey = maps:get(<<"publicKey">>, Map),
  Signature = crypto_utils:signMessageWith(base64:decode(PrivateKey), Message),
  TT = time_utils:current_timestamp(),
  db_utils:save_message(base64:encode(Signature), PublicKey, TT),
  Doc = {[{sign, [sign, base64:encode(Signature), tt, TT]}]},
  JsonDoc = jsone:encode(Doc),
  p2p:send(JsonDoc),
  JsonDoc;
handle_data(Json, <<"signforsend">>) ->
  Map = jsone:decode(Json),
  Message = maps:get(<<"message">>, Map),
  PrivateKey = maps:get(<<"privateKey">>, Map),
  PublicKey = maps:get(<<"publicKey">>, Map),
  Signature = crypto_utils:signMessageWith(base64:decode(PrivateKey), Message),
  TT = time_utils:current_timestamp(),
  db_utils:save_message(base64:encode(Signature), PublicKey, TT),
  Doc = {[{signforsend, [signforsend, base64:encode(Signature), tt, TT]}]},
  JsonDoc = jsone:encode(Doc),
  p2p:send(JsonDoc),
  JsonDoc;
handle_data(Json, <<"verify">>) ->
  Map = jsone:decode(Json),
  Message = maps:get(<<"message">>, Map),
  PublicKey = maps:get(<<"publicKey">>, Map),
  Signature = maps:get(<<"signature">>, Map),
  Value = crypto_utils:verifyMessage(base64:decode(Signature), Message, base64:decode(PublicKey)),
  Doc = {[{verify, [verify, Value]}]},
  JsonDoc = jsone:encode(Doc),
  p2p:send(JsonDoc),
  JsonDoc;
handle_data(Json, <<"load">>) ->
  Map = jsone:decode(Json),
  PublicKey = maps:get(<<"public_key">>, Map),
  Result = db_utils:get_pseudonym(PublicKey),
  Doc = {[{load, [guid, Result#pseudonym.guid, public_key, Result#pseudonym.public_key, ip, Result#pseudonym.ip, value, Result#pseudonym.value, tt, Result#pseudonym.timestamp]}]},
  JsonDoc = jsone:encode(Doc),
  p2p:send(JsonDoc),
  JsonDoc;
handle_data(Json, <<"tx">>) ->
  Map = jsone:decode(Json),
  PublicKey = maps:get(<<"publicKey">>, Map),
  Signature = maps:get(<<"signature">>, Map),
  TT = time_utils:current_timestamp(),
  Value = maps:get(<<"value">>, Map),
  %TODO here next, problem with hash length in db, make hash direct
  Hash = hash_utils:base64checkHashFrom(Json),
  Doc = {[{tx_hash, [tx_hash, Hash]}]},
  %TODO DANGER!
  db_utils:save_candidate_pool(Signature, PublicKey, Hash, Json, Value, TT),
  JsonDoc = jsone:encode(Doc),
  p2p:send(JsonDoc),
  JsonDoc;
handle_data(Json, _) ->
  %TODO
  lager:error(Json),
  lager:error("ERROR: wrong message from client").

mining() ->
  R = db_utils:get_messages_candidates_number(),
  %%lager:info("found ~p messages", [R]),
  run_mining(),
  if
    R >= 5 -> run_mining();
    true -> lager:info("Mining:nothing to do")
  end.

run_mining() ->
  %%lager:info("Mining: mining..."),
  Rows = db_utils:get_messages_candidates(),
  show_messages(Rows, 0),
  mine(Rows).

show_messages([], Counter) -> lager:info("counter ~p", [Counter]);
show_messages([H|T], Counter)->
  %%lager:info("show H ~p", [H]),
  show_messages(T, Counter + 1).

mine(Rows) ->
  lager:info("mine... TODO")
  .