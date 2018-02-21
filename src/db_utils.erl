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