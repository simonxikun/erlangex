-module(hellomysql).
-export([run/0]).

-record(table,{id,game_id,status,dealer_id,create_date,countdown}).
run()->
	crypto:start(),
	application:start(emysql),
	%emysql:add_pool(my_pool,7,"ts1","111111","192.168.1.12",3306,"livecasino_pref",utf8),

	Result=emysql:execute(my_pool,<<"select * from tables order by id desc">>),

	Recs=emysql_util:as_record(Result,table,record_info(fields,table)),

	[io:format("~n~p~n",[Res])||Res <- Recs].

