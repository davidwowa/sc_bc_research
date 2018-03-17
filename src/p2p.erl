%%%-------------------------------------------------------------------
%%% @author David Zakrevskyy
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 1. Get list with ip-Addresses from server
%%% 2. Start server and client
%%% 3. ...TODO
%%% @end
%%% Created : 17. Mär 2018 14:21
%%%-------------------------------------------------------------------
-module(p2p).
-author("David").

%% API
-export([start_server/0]).
-export([send/1]).

start_server() -> server(get_port()).

server(Port) ->
  lager:info("p2p: start p2p server"),
  {ok, Socket} = gen_udp:open(Port, [binary]),
  lager:info("p2p: server opened socket:~p~n", [Socket]),
  loop(Socket).

loop(Socket) ->
  receive
    {udp, Socket, Host, Port, _} = Msg ->
      lager:info("p2p: server received:~p~n", [Msg]),
      %% TODO
      Doc = {[{message, [message, ok, ticket, rand:uniform(1000)]}]},
      JsonDoc = jsone:encode(Doc),
      gen_udp:send(Socket, Host, Port, JsonDoc),
      loop(Socket)
  end.

send(Message) ->
  {ok, Addr} = inet:getaddrs("HP", inet),
  {ok, Addrs} = inet:getaddrs("mac", inet),
  send_rec(Addr, Message),
  send_rec(Addrs, Message).

send_rec([], _) -> lager:info("p2p: nothing to send, list is empty");
send_rec([H | T], Message) -> lager:info("p2p: send message ~p to ~p ", [Message, H]),
  {ok, Socket} = gen_udp:open(0, [binary]),
  ok = gen_udp:send(Socket, H, get_port(), term_to_binary(Message)),
  Value = receive
            {udp, Socket, _, _, Bin} = Msg ->
              lager:info("p2p: client received:~p~n", [Msg]),
              binary_to_term(Bin)
          after 2000 ->
      0
          end,
  gen_udp:close(Socket),
  lager:info("p2p: send result ~p", [Value]),
  send_rec(T, Message).

get_port() -> 8789.