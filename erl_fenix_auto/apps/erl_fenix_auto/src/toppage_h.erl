%% @doc Hello world handler.
-module(toppage_h).

-export([init/2]).

init(Req0, Opts = [Start]) ->
	WorkFor = erlang:system_time(second) - Start,
	Responce = io_lib:format("Hello world! I have been working for ~p seconds.", [WorkFor]),

	
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, Responce, Req0),
	{ok, Req, Opts}.