%% This is a scratch pad for running erlang code
%% Everything is saved

-module(my_test).

-export([sha_1/1]).
-export([test/0]).

sha_1(S) -> <<X:256/big-unsigned-integer>> = crypto:hash(sha256, S),
integer_to_list(X, 16).

test() -> test.