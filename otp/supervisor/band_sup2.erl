-module(band_sup2).
-behavior(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(Type) ->
	supervisor:start_link({local,?MODULE},?MODULE,Type).

init(jamband)->
	{ok, {{simple_one_for_one,3,60},[{jam_musician,{musicians,start_link,[]},temporary,1000,worker,[musicians]}]}}.
