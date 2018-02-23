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
-export([save/2]).
-export([save/3]).
-export([save/4]).

save(GUID, PublicKey, Ip) ->
  save_pseudonym_couch(GUID, PublicKey, Ip),
  ok = save_pseudonym_rel(GUID, PublicKey, Ip),
  ok = save_pseudonym_mnesia(GUID, PublicKey, Ip),
  ok = save_pseudonym_file(GUID, PublicKey, Ip).

save(PublicKey, PrivateKey) ->
  save_keys_couch(PublicKey, PrivateKey),
  ok = save_keys_rel(PublicKey, PrivateKey),
  ok = save_keys_mnesia(PublicKey, PrivateKey),
  ok = save_keys_file(PublicKey, PrivateKey).

save(P_hash, Hash, Merkle_root, Data) ->
  save_block_couch(P_hash, Hash, Merkle_root, Data),
  ok = save_block_rel(P_hash, Hash, Merkle_root, Data),
  ok = save_block_mnesia(P_hash, Hash, Merkle_root, Data),
  ok = save_block_file(P_hash, Hash, Merkle_root, Data).

% File
save_pseudonym_file(GUID, PublicKey, Ip) ->
  lager:info("File:save pseudonym"),
  Doc = #{guid => GUID, public_key => PublicKey, ip => Ip},
  Json = jsone:encode(Doc),
  file:write_file(get_file_name_pseudonyms(), io_lib:fwrite("~p.\n", [Json]), [append]).

save_keys_file(PublicKey, PrivateKey) ->
  lager:info("File:save keys"),
  Doc = #{public_key => PublicKey, private_key => PrivateKey},
  Json = jsone:encode(Doc),
  file:write_file(get_file_name_keys(), io_lib:fwrite("~p.\n", [Json]), [append]).

save_block_file(P_hash, Hash, Merkle_root, Data) ->
  lager:info("File:save block"),
  Doc = #{p_hash => P_hash, hash => Hash, merkle_root => Merkle_root, data => Data},
  Json = jsone:encode(Doc),
  file:write_file(get_file_name_block(), io_lib:fwrite("~p.\n", [Json]), [append]).

get_file_name_pseudonyms() -> "/Users/David/sandbox/mt/bc/db/pseudonyms.db".
get_file_name_keys() -> "/Users/David/sandbox/mt/bc/db/keys.db".
get_file_name_block() -> "/Users/David/sandbox/mt/bc/db/blocks.db".

% CouchDB
save_pseudonym_couch(GUID, PublicKey, Ip) ->
  lager:info("CouchDB:save pseudonym"),
  Doc = #{guid => GUID, public_key => PublicKey, ip => Ip},
  Json = jsone:encode(Doc),
  post(get_couchdb_url(), get_couchdb_mime_type(), Json).

save_keys_couch(PublicKey, PrivateKey) ->
  lager:info("CouchDB:save keys"),
  Doc = #{public_key => PublicKey, private_key => PrivateKey},
  Json = jsone:encode(Doc),
  post(get_couchdb_url(), get_couchdb_mime_type(), Json).

save_block_couch(P_hash, Hash, Merkle_root, Data) ->
  lager:info("CouchDB:save block"),
  Doc = #{p_hash => P_hash, hash => Hash, merkle_root => Merkle_root, data => Data},
  Json = jsone:encode(Doc),
  post(get_couchdb_url(), get_couchdb_mime_type(), Json).

%% http://no-fucking-idea.com/blog/2013/01/22/making-request-to-rest-resources-in-erlang/
post(URL, ContentType, Body) -> request(post, {URL, [], ContentType, Body}).
get(URL) -> request(get, {URL, []}).
response_body({ok, {_, _, Body}}) -> Body.

request(Method, Body) ->
  httpc:request(Method, Body, [], []).

%Response =
%Body = response_body(Response),
%lager:info(Body),
%lager:info("saved in couchDB").

get_couchdb_url() -> "http://localhost:5984/blockchain".
get_couchdb_mime_type() -> "application/json".

% MySQL
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

get_mysql_link() ->
  lager:info("link mysql connection"),
  mysql:start_link([{host, "localhost"}, {user, "block"},
    {password, "blockchain"}, {database, "blockchain"}]).

% Mnesia
save_pseudonym_mnesia(GUID, PublicKey, Ip) ->
  lager:info("Mnesia:save pseudonym"),
  Pseudonym = #pseudonym{guid = GUID, public_key = PublicKey, ip = Ip},
  mnesia:dirty_write(Pseudonym).

save_keys_mnesia(PublicKey, PrivateKey) ->
  lager:info("Mnesia:save keys"),
  Keys = #key{public_key = PublicKey, private_key = PrivateKey},
  mnesia:dirty_write(Keys).

save_block_mnesia(P_hash, Hash, Merkle_root, Data) ->
  lager:info("Mnesia:save block"),
  Block = #block{p_hash = P_hash, hash = Hash, merkle_root = Merkle_root, data = Data},
  mnesia:dirty_write(Block).