-module(caculator).
-compile(export_all).

start()->
	io:format("I am starting now~n"),
	Pid=spawn(?MODULE,loop,[0]),
	register(?MODULE,Pid),
	{ok,Pid}.

stop()->
	io:format("I am stopping~n"),
	?MODULE ! stop.


sync_add(Delta)->
	?MODULE ! {self(),add,Delta},
	receive
		X-> io:format("the result is ~p~n",[X])
	end.

sync_subtract(Delta)->
    ?MODULE ! {self(),subtract,Delta},
    receive
    	X-> io:format("the result is ~p~n",[X])
    end.

sync_get_result()->
	?MODULE ! {self(),get_result},
	receive
		X-> io:format("the result is~p~n",[X])
	end.

add(Delta)->
	?MODULE ! {self(),add,Delta}.

subtract(Delta)->
	?MODULE ! {self(),subtract,Delta}.

loop(State)->
	receive
		{From,add,Delta}->
			NewState=State+Delta,
			From ! NewState,
			loop(NewState);
		{From,subtract,Delta}->
			NewState=State-Delta,
			From ! NewState,
			loop(NewState);
		{From,get_result}->
			From ! State,
			loop(State);
		stop->
			ok
	end.