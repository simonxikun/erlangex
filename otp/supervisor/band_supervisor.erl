-module(band_supervisor).
-behavior(supervisor).

-export([start_link/1]).
-export([init/1]).

-define(CHILD(Role,Level,Shutdown),{Role,{musicians,start_link,[Role,Level]},Shutdown,1000,worker,[musicians]}).

start_link(Type) ->
	supervisor:start_link({local,?MODULE},?MODULE,Type).

init(lenient)->
	init({one_for_one,3,60});
init(angry) ->
	init({rest_for_one,2,60});
init(jerk) ->
	init({one_for_all,1,60});
init({RestartStrategy,MaxRestart,MaxTime})->
	{ok,
		{
			{RestartStrategy,MaxRestart,MaxTime},
			[
				?CHILD(singer,good,permanent),
				?CHILD(bass,bad,temporary),
				?CHILD(drum,bad,transient),
				?CHILD(keyta,good,transient)
			]
		}
	}.
