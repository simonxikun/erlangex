-module(kenotokens).
-export([start/0]).

-define(JSON_FILE,"./user.json").

readlines(FileName)->
	{ok,Device} = file:open(FileName,[read]),
	get_all_lines(Device,[]).

get_all_lines(Device,Acc)->
	case io:get_line(Device,"") of
		eof-> file:close(Device),Acc;
		Line-> get_all_lines(Device,[Line|Acc])
	end.

start()->
	Lines=readlines(?JSON_FILE),
	Json=mochijson2:decode(Lines),
	{struct,[{<<"cmd">>,<<"LoadTest">>},{<<"data">>,Users}]}=Json,
	{ok,Device}=file:open("output.txt",[write]),
	loop_users(Device,Users).

loop_users(Device,[])->
	file:close(Device),
	io:format("file content:~p~n",["done"]);
loop_users(Device,[H|T])->
	{struct,[{<<"memberName">>,Username},{<<"token">>,Token},{<<"wallet">>,_}]}=H,
	io:format(Device,"~s,~s~n",[binary_to_list(Username),binary_to_list(Token)]),
	loop_users(Device,T).