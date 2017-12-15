%%%-------------------------------------------------------------------
%%% @author Wladimir David Zakrevskyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% This module contain crytpographic functions
%%% @end
%%% Created : 14. Dez 2017 11:47
%%%-------------------------------------------------------------------
-module(crypto_utils).
-author("Wladimir David Zakrevskyy").

%% API
-export([generate_key_paar/0]).

generate_key_paar() ->
  lager:info("generate simple key paar over secp512r1 curve"),
%%{PublicKey, PrivKeyOut}
  crypto:generate_key(ecdh, crypto:ec_curve(secp521r1)).
