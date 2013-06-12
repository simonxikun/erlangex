-module(kenobets).
-compile(export_all).

%-record(bet,{pId,detail}).
-record(detail,{areaId,drawNo,stake=10,id,betContent,bets=1,amount=10,platform=1,tokenM=""}).

generate_id(Max)->
	trunc(random:uniform()*Max)+1.

generate_id_list(Max,Len)->
	generate_id_list(Max,Len,[]).

generate_id_list(Max,Len,Acc)->
	case Len of
		0 -> Acc;
		_-> Id = generate_id(Max),
			case lists:member(Id,Acc) of
			 	true->generate_id_list(Max,Len,Acc);
			 	false->generate_id_list(Max,Len-1,[Id|Acc])
			end
	end.

generate_keno_detail(_DrawNo)->
	AreaId=generate_id(6),
	{Id,BetContent}=generate_keno_content(1,25),
	Bets=generate_id(10),
	Stake=generate_id(8),
	Amount=Bets*Stake,
	#detail{areaId=AreaId,id=Id,betContent=BetContent,amount=Amount,stake=Stake,bets=Bets}.

generate_keno_content(_PId,Max)->
	Id=generate_id(Max),
	List=generate_keno_content_list(Id),
	{Id,contentlist_to_string(List)}.

generate_keno_content_list(Id) when Id<21, Id>=1 ->[];
generate_keno_content_list(Id) when Id >= 21,Id =< 25 -> generate_id_list(80,26-Id).

contentlist_to_string([])->"";
contentlist_to_string([H])->integer_to_list(H);
contentlist_to_string([H|T])->integer_to_list(H)++"#"++contentlist_to_string(T).

detail_to_csv(Device,Detail)->
	io:format(Device,"~p,~p,~p,~p,~p,~s~n",
			[Detail#detail.areaId,
			Detail#detail.stake,
			Detail#detail.bets,
			Detail#detail.amount,
			Detail#detail.id,
			Detail#detail.betContent]).
		
start(Amount)->
	{ok,Device}=file:open("bets.csv",[write]),
	[detail_to_csv(Device,generate_keno_detail(N)) || N <- lists:seq(1,Amount)],
	file:close(Device).



