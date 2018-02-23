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

-include("record.hrl").

%% API
-export([save_pseudonym_rel/3]).
-export([save_keys_rel/2]).
-export([save_block_rel/4]).

-export([save_pseudonym/3]).
-export([save_keys/2]).
-export([save_block/4]).

-export([save_pseudonym_couch/3]).
-export([save_keys_couch/2]).


save_pseudonym_couch(GUID, PublicKey, Ip) ->
  Doc = #{guid => GUID, public_key => base64:encode(PublicKey), ip => Ip},
  lager:info("CouchDB:save pseudonym"),
  Json = jsone:encode(Doc),
  %lager:info(Json),
  Response = post("http://localhost:5984/blockchain", "application/json", Json),
  Body = response_body(Response),
  lager:info(Body),
  lager:info("saved in couchDB").

save_keys_couch(PublicKey, PrivateKey) ->
  lager:info("CouchDB:save keys").

%% http://no-fucking-idea.com/blog/2013/01/22/making-request-to-rest-resources-in-erlang/
post(URL, ContentType, Body) -> request(post, {URL, [], ContentType, Body}).
get(URL)                     -> request(get,  {URL, []}).
response_body({ok, { _, _, Body}}) -> Body.

request(Method, Body) ->
  httpc:request(Method, Body, [], []).

save_pseudonym_rel(GUID, PublicKey, Ip) ->
  lager:info("MySQL:save pseudonym"),
  {ok, Pid} = get_mysql_link(),
  mysql:query(Pid, "INSERT INTO pseudonyms (GUID, bcaddress, ip) VALUES (?, ?, ?)", [GUID, PublicKey, Ip]).

save_keys_rel(PublicKey, PrivateKey) ->
  lager:info("MySQL:save keys"),
  {ok, Pid} = get_mysql_link(),
  mysql:query(Pid, "INSERT INTO bckeys (bcaddress, bckey) VALUES (?, ?)", [PublicKey, PrivateKey]).

save_block_rel(P_hash, Hash, Merkle_root, Data) ->
  lager:info("MySQL:save block"),
  {ok, Pid} = get_mysql_link(),
  mysql:query(Pid, "INSERT INTO chain (p_hash, bchash, merkle_root, bcdata) VALUES (?, ?, ?, ?)", [P_hash, Hash, Merkle_root, Data]).

save_pseudonym(GUID, PublicKey, Ip) ->
  lager:info("Mnesia:save pseudonym"),
  Pseudonym = #pseudonym{guid = GUID, public_key = PublicKey, ip = Ip},
  mnesia:dirty_write(Pseudonym).

save_keys(PublicKey, PrivateKey) ->
  lager:info("Mnesia:save keys"),
  Keys = #key{public_key = PublicKey, private_key = PrivateKey},
  mnesia:dirty_write(Keys).

save_block(P_hash, Hash, Merkle_root, Data) ->
  lager:info("Mnesia:save block"),
  Block = #block{p_hash = P_hash, hash = Hash, merkle_root = Merkle_root, data = Data},
  mnesia:dirty_write(Block).

get_mysql_link() ->
  lager:info("link mysql connection"),
  mysql:start_link([{host, "localhost"}, {user, "block"},
    {password, "blockchain"}, {database, "blockchain"}]).