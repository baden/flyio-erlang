%% Feel free to use, reuse and abuse the code in this file.

-module(echo_protocol).
-behaviour(ranch_protocol).

-export([start_link/3]).
-export([init/3]).

start_link(Ref, Transport, Opts) ->
	Pid = spawn_link(?MODULE, init, [Ref, Transport, Opts]),
	{ok, Pid}.

init(Ref, Transport, _Opts = []) ->
	{ok, Socket} = ranch:handshake(Ref),
	loop(Socket, Transport).

loop(Socket, Transport) ->
	case Transport:recv(Socket, 0, 60000) of
		{ok, Data} when Data =/= <<4>> ->
			Transport:send(Socket, <<$<, Data/binary, $>>>),
			loop(Socket, Transport);
		_ ->
			ok = Transport:close(Socket)
	end.