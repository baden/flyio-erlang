%%%-------------------------------------------------------------------
%% @doc erl_fenix_auto public API
%% @end
%%%-------------------------------------------------------------------

-module(erl_fenix_auto_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->

	Start = erlang:system_time(second),

	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", toppage_h, [Start]}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	}),

    erl_fenix_auto_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
