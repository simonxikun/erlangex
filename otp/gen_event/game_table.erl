-module(game_table).
-behavior(gen_event).

-export([code_change/3,handle_call/2,handle_event/2,handle_info/2,init/1,terminate/2]).

code_change(_OldVsn,State,_Extra)->
	{ok,State}.

terminate(_Arg,_State)->
	ok.

handle_info(_Info,State)->
	{ok,State}.

handle_call(Request,State)->
	{ok,Request,State}.

init(Id)->
	{ok,Id}.

handle_event(Event,State)->
	io:format("id# ~p event i got ~p~n",[State,Event]),
	{ok,State}.
