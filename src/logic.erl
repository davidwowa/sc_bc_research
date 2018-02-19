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

%% API
-export([handle_data/2]).


handle_data(_, <<"keys">>) ->
  {PublicKey, PrivKeyOut} = crypto_utils:generate_key_paar(),
  Doc = {[{keys, [public_key, base64:encode(PublicKey), private_key, base64:encode(PrivKeyOut)]}]},
  jsone:encode(Doc);
handle_data(Json, <<"sign">>) ->
  Map = jsone:decode(Json),
  Message = maps:get(<<"message">>, Map),
  PrivateKey = maps:get(<<"privateKey">>, Map),
  Signature = crypto_utils:signMessageWith(base64:decode(PrivateKey), Message),
  Doc = {[{sign, [sign, base64:encode(Signature)]}]},
  jsone:encode(Doc);
handle_data(Json, <<"verify">>) ->
  Map = jsone:decode(Json),
  Message = maps:get(<<"message">>, Map),
  PublicKey = maps:get(<<"publicKey">>, Map),
  Signature = maps:get(<<"signature">>, Map),
  Value = crypto_utils:verifyMessage(base64:decode(Signature), Message, base64:decode(PublicKey)),
  Doc = {[{verify, [verify, Value]}]},
  jsone:encode(Doc);
handle_data(Json, _) ->
  %TODO
  lager:error("ERROR").
