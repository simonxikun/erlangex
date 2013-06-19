-module(code_lock).
-behavior(gen_fsm).

-export([start_link/1]).
-export([button/1,stop/0,status/0]).
-export([init/1,locked/2,open/2]).
-export([code_change/4,handle_event/3,handle_info/3,handle_sync_event/4,terminate/3]).

start_link(Code)->
	gen_fsm:start_link({local,code_lock},code_lock,Code,[]).

button(Digit)->
	gen_fsm:send_event(code_lock,{button,Digit}).

status()->
	gen_fsm:sync_send_all_state_event(code_lock,status).

init(Code)->
	{ok,locked,{[],Code}}.

locked({button,Digit},{SoFar,Code})->
	case [Digit|SoFar] of
		Code ->
			do_unlock(),
			{next_state,open,{[],Code},3000};
		Incomplete when length(Incomplete)<length(Code)->
			{next_state,locked,{Incomplete,Code}};
		_Wrong->
			{next_state,locked,{[],Code}}
	end.

open(timeout,State)->
	do_lock(),
	{next_state,locked,State}.

stop()->
	gen_fsm:send_all_state_event(code_lock,stop).

handle_event(stop,_StateName,StateData)->
	{stop,normal,StateData}.


handle_sync_event(_Event,_From,StateName,StateData)->
	{reply,{StateName,StateData},StateName,StateData}.

handle_info(_Info,StateName,StateData)->
	{next_state,StateName,StateData}.


terminate(normal,_StateName,_StateData)->
	ok.

code_change(_OldVsn,StateName,StateData,_Extra)->
	{ok,StateName,StateData}.

do_lock()->
	io:format("in do lock"),
	ok.

do_unlock()->
	io:format("in do unlock"),
	ok.