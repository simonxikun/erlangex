-module(caculator_gen).
-behavior(gen_server).
-export([code_change/3,handle_call/3,handle_cast/2,handle_info/2,init/1,terminate/2]).
-export([start/0,stop/0,sync_add/1,sync_subtract/1,sync_get_result/0,add/1,subtract/1]).

start()->
	{ok,_Pid}=gen_server:start_link({local,?MODULE},?MODULE,[],[]),
	ok.

stop()->
	gen_server:cast(?MODULE,stop).

sync_add(Delta)->
	X=gen_server:call(?MODULE,{add,Delta},10),
	io:format("the result is~p~n",[X]).

sync_subtract(Delta)->
	X=gen_server:call(?MODULE,{subtract,Delta},10),
	io:format("the result is~p~n",[X]).

add(Delta)->
	gen_server:cast(?MODULE,{add,Delta}).

subtract(Delta)->
	gen_server:cast(?MODULE,{subtract,Delta}).

sync_get_result()->
	X=gen_server:call(?MODULE,get_result),
	io:format("the result is~p~n",[X]).

init(_Args)->
	{ok,0}.

handle_call({add,Delta},_From,State)->
	NewState=State+Delta,
	{reply,NewState,NewState};
handle_call({subtract,Delta},From,State)->
	NewState=State-Delta,
	gen_server:reply(From,NewState),
	{noreply,NewState};
handle_call(get_result,_From,State)->
	{reply,State,State}.


handle_cast({add,Delta},State)->
	NewState=State+Delta,
	{noreply,NewState};
handle_cast({subtract,Delta},State)->
	NewState=State-Delta,
	{noreply,NewState};
handle_cast(stop,State)->
	{stop,normal,State}.

handle_info(_Info,State)->
	{noreply,State}.

terminate(normal,_State)->
	ok.
code_change(_OldVsn,State,_Extra)->
	{ok,State}.