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
-export([save_pseudonym/5]).
-export([save_keys/3]).
-export([save_block/5]).
-export([save_message/3]).

-export([get_pseudonym/1]).
-export([get_condidates_numer/0]).

save_pseudonym(GUID, PublicKey, Ip, Value, TT) ->
  ok = save_pseudonym_couch(GUID, PublicKey, Ip, Value, TT),
  ok = save_pseudonym_rel(GUID, PublicKey, Ip, Value, TT),
  ok = save_pseudonym_mnesia(GUID, PublicKey, Ip, Value, TT),
  ok = save_pseudonym_file(GUID, PublicKey, Ip, Value, TT),
  ok.

save_keys(PublicKey, PrivateKey, TT) ->
  ok = save_keys_couch(PublicKey, PrivateKey, TT),
  ok = save_keys_rel(PublicKey, PrivateKey, TT),
  ok = save_keys_mnesia(PublicKey, PrivateKey, TT),
  ok = save_keys_file(PublicKey, PrivateKey, TT),
  ok.

save_block(P_hash, Hash, Merkle_root, Data, TT) ->
  ok = save_block_couch(P_hash, Hash, Merkle_root, Data, TT),
  ok = save_block_rel(P_hash, Hash, Merkle_root, Data, TT),
  ok = save_block_mnesia(P_hash, Hash, Merkle_root, Data, TT),
  ok = save_block_file(P_hash, Hash, Merkle_root, Data, TT),
  ok.

save_message(Signature, PublicKey, TT) ->
  ok = save_message_rel(Signature, PublicKey, TT),
  ok = save_message_file(Signature, PublicKey, TT),
  ok = save_message_mnesia(Signature, PublicKey, TT),
  ok = save_message_couch(Signature, PublicKey, TT),
  ok.

get_pseudonym(PublicKey) ->
  get_pseudonym_mysql(PublicKey).

% File
save_pseudonym_file(GUID, PublicKey, Ip, Value, TT) ->
  lager:info("File:save pseudonym"),
  Doc = #{guid => GUID, public_key => PublicKey, ip => Ip, value => Value, timestamp => TT},
  Json = jsone:encode(Doc),
  file:write_file(get_file_name_pseudonyms(), io_lib:fwrite("~p.\n", [Json]), [append]).

save_keys_file(PublicKey, PrivateKey, TT) ->
  lager:info("File:save keys"),
  Doc = #{public_key => PublicKey, private_key => PrivateKey, timestamp => TT},
  Json = jsone:encode(Doc),
  file:write_file(get_file_name_keys(), io_lib:fwrite("~p.\n", [Json]), [append]).

save_block_file(P_hash, Hash, Merkle_root, Data, TT) ->
  lager:info("File:save block"),
  Doc = #{p_hash => P_hash, hash => Hash, merkle_root => Merkle_root, data => Data, timestamp => TT},
  Json = jsone:encode(Doc),
  file:write_file(get_file_name_blocks(), io_lib:fwrite("~p.\n", [Json]), [append]).

save_message_file(PublicKey, Signature, TT) ->
  lager:info("File:save message"),
  Doc = #{public_key=>PublicKey, signature => Signature, timestamp => TT},
  Json = jsone:encode(Doc),
  file:write_file(get_file_name_messages(), io_lib:fwrite("~p.\n", [Json]), [append]).

get_file_name_pseudonyms() -> "/Users/David/sandbox/mt/bc/db/pseudonyms.db".
get_file_name_keys() -> "/Users/David/sandbox/mt/bc/db/keys.db".
get_file_name_blocks() -> "/Users/David/sandbox/mt/bc/db/blocks.db".
get_file_name_messages() -> "/Users/David/sandbox/mt/bc/db/messages.db".

% CouchDB
save_pseudonym_couch(GUID, PublicKey, Ip, Value, TT) ->
  lager:info("CouchDB:save pseudonym"),
  Doc = #{guid => GUID, public_key => PublicKey, ip => Ip, value => Value, timestamp => TT},
  Json = jsone:encode(Doc),
  post(get_couchdb_url(), get_couchdb_mime_type(), Json),
  ok.

save_keys_couch(PublicKey, PrivateKey, TT) ->
  lager:info("CouchDB:save keys"),
  Doc = #{public_key => PublicKey, private_key => PrivateKey, timestamp => TT},
  Json = jsone:encode(Doc),
  post(get_couchdb_url(), get_couchdb_mime_type(), Json),
  ok.

save_block_couch(P_hash, Hash, Merkle_root, Data, TT) ->
  lager:info("CouchDB:save block"),
  Doc = #{p_hash => P_hash, hash => Hash, merkle_root => Merkle_root, data => Data, timestamp => TT},
  Json = jsone:encode(Doc),
  post(get_couchdb_url(), get_couchdb_mime_type(), Json),
  ok.

save_message_couch(Signature, PublicKey, TT) ->
  lager:info("CoucDB:save message"),
  Doc = #{public_key => PublicKey, signature => Signature, timestamp => TT},
  Json = jsone:encode(Doc),
  post(get_couchdb_url(), get_couchdb_mime_type(), Json),
  ok.

%% http://no-fucking-idea.com/blog/2013/01/22/making-request-to-rest-resources-in-erlang/
post(URL, ContentType, Body) -> request(post, {URL, [], ContentType, Body}).
put(URL, ContentType, Body) -> request(put, {URL, [], ContentType, Body}).
get(URL) -> request(get, {URL, []}).
response_body({ok, {_, _, Body}}) -> Body.

request(Method, Body) ->
  httpc:request(Method, Body, [], []).

get_couchdb_url() -> "http://localhost:5984/blockchain".
get_couchdb_mime_type() -> "application/json".

% MySQL
save_pseudonym_rel(GUID, PublicKey, Ip, Value, TT) ->
  lager:info("MySQL:save pseudonym"),
  {ok, Pid} = get_mysql_link(),
  mysql:query(Pid, "INSERT INTO pseudonyms (GUID, bcaddress, ip, value, tt) VALUES (?, ?, ?, ?, ?)", [GUID, PublicKey, Ip, Value, TT]).

save_keys_rel(PublicKey, PrivateKey, TT) ->
  lager:info("MySQL:save keys"),
  {ok, Pid} = get_mysql_link(),
  mysql:query(Pid, "INSERT INTO bckeys (bcaddress, bckey, tt) VALUES (?, ?, ?)", [PublicKey, PrivateKey, TT]).

save_block_rel(P_hash, Hash, Merkle_root, Data, TT) ->
  lager:info("MySQL:save block"),
  {ok, Pid} = get_mysql_link(),
  mysql:query(Pid, "INSERT INTO chain (p_hash, bchash, merkle_root, bcdata, tt) VALUES (?, ?, ?, ?, ?)", [P_hash, Hash, Merkle_root, Data, TT]).

save_message_rel(Signature, PublicKey, TT) ->
  lager:info("MySQL:save message"),
  {ok, Pid} = get_mysql_link(),
  mysql:query(Pid, "INSERT INTO messages (signature, bcaddress, tt) VALUES (?, ?, ?)", [Signature, PublicKey, TT]).

get_condidates_numer() ->
  lager:info("MySQL:load candidates number"),
  {ok, Pid} = get_mysql_link(),
  %{ok, _, Rows}
  {ok, _, Rows} =
    mysql:query(Pid, <<"SELECT COUNT(*) FROM candidates_pool">>),
  [[Result]] = Rows,
  Result.

get_pseudonym_mysql(PublicKey) ->
  lager:info("MySQL:load pseudonym"),
  {ok, Pid} = get_mysql_link(),
  %{ok, ColumnNames, Rows}
  {ok, _, Rows} =
    mysql:query(Pid, <<"SELECT * FROM pseudonyms WHERE bcaddress = ?">>, [PublicKey]),
  create_pseudonym(Rows).

create_pseudonym([[GUID, Bcaddress, Ip, Value, TT]]) ->
  #pseudonym{guid = GUID, public_key = Bcaddress, ip = Ip, value = Value, timestamp = TT}.

get_mysql_link() ->
  %lager:info("link mysql connection"),
  mysql:start_link([{host, "localhost"}, {user, "block"},
    {password, "blockchain"}, {database, "blockchain"}]).

% Mnesia
save_pseudonym_mnesia(GUID, PublicKey, Ip, Value, TT) ->
  lager:info("Mnesia:save pseudonym"),
  Pseudonym = #pseudonym{guid = GUID, public_key = PublicKey, ip = Ip, value = Value, timestamp = TT},
  mnesia:dirty_write(Pseudonym).

save_keys_mnesia(PublicKey, PrivateKey, TT) ->
  lager:info("Mnesia:save keys"),
  Keys = #key{public_key = PublicKey, private_key = PrivateKey, timestamp = TT},
  mnesia:dirty_write(Keys).

save_block_mnesia(P_hash, Hash, Merkle_root, Data, TT) ->
  lager:info("Mnesia:save block"),
  Block = #block{p_hash = P_hash, hash = Hash, merkle_root = Merkle_root, data = Data, timestamp = TT},
  mnesia:dirty_write(Block).

save_message_mnesia(Signature, PublicKey, TT) ->
  lager:info("Mnesia:save message"),
  Message = #message{signature = Signature, public_key = PublicKey, timestamp = TT},
  mnesia:dirty_write(Message).

get_pseudonym_mnesia(PublicKey) ->
  % TODO
  mnesia:select(pseudonym, [{#pseudonym{public_key = PublicKey}}]),
  [RecordList] = mnesia:dirty_read(pseudonym, PublicKey, write),
  lager:info(RecordList#pseudonym.public_key).