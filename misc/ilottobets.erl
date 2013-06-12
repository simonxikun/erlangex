-module(ilottobets).
-compile(export_all).
-define(ILOTTO_RESULTS,[3,3,3,3,5,5]).
-define(RANDOM_RESULT(AreaId),lotterygen:generate_one_to_max(lists:nth(AreaId,?ILOTTO_RESULTS))).

-record(detail,{bets=1,content}).

intlist2str(L)-> string:join([integer_to_list(S) || S <-L],"").

foldf({_Len,RL},Sum)-> RL*Sum.
cnr(0)->1;
cnr(N) when N>0 -> cnr(N,1).
cnr(1,Acc)->Acc;
cnr(N,Acc)->cnr(N-1,N*Acc).

comb(N,R) when N>=R ->
	X=cnr(R)*cnr(N-R),
	cnr(N) div X.

generate_detail(1,AreaId)->
	A= ?RANDOM_RESULT(AreaId),
	B=lotterygen:generate_zero_til_max(9),
	#detail{content=integer_to_list(A)++"$"++integer_to_list(B)};

generate_detail(2,AreaId)->
	A= ?RANDOM_RESULT(AreaId),
	L=lotterygen:generate_one_to_max(8)+1,
	BetContent=lotterygen:id_list_from_zero(9,L),
	#detail{bets=L,content=integer_to_list(A)++"$"++intlist2str(BetContent)};

generate_detail(Id,_AreaId) when Id >=3, Id =< 6 ->
	Digits=[{Len,lotterygen:generate_one_to_max(8)} || Len <-lists:seq(1,Id-1)],
	Pairs=[integer_to_list(Len)++"$"++intlist2str(lotterygen:id_list_from_zero(9,RandomL)) || {Len,RandomL} <- Digits],
    Bets=lists:foldl(fun foldf/2,1,Digits),
    #detail{bets=Bets,content=string:join(Pairs,"#")};

generate_detail(Id,AreaId) when Id>=7, Id =< 10 ->
	A= ?RANDOM_RESULT(AreaId),
    #detail{content=integer_to_list(A)};

generate_detail(Id,_AreaId) when Id>=11, Id =<14 ->
	Pairs=[integer_to_list(Len-8)++"$"++integer_to_list(lotterygen:generate_one_to_max(4))|| Len <- lists:seq(9,Id-1)],
    #detail{content=string:join(Pairs,"#")};

generate_detail(15,_AreaId)->
	L=lotterygen:generate_zero_til_max(7)+3,
	BetContent=lotterygen:id_list_from_zero(9,L),
	Bets=if 
		L >=2 -> comb(L,2);
		L < 2 -> 1
	end,
	#detail{bets=Bets,content=intlist2str(BetContent)};

generate_detail(16,AreaId)->
	L1=lotterygen:generate_zero_til_max(9)+1,
	BC1=lotterygen:id_list_from_zero(9,L1),
	L2=lotterygen:generate_zero_til_max(9)+1,
    BC2=lotterygen:id_list_from_zero(9,L2),
	Bets=L1*L2,
	Rid=lists:nth(AreaId,?ILOTTO_RESULTS),
	#detail{bets=Bets,content=integer_to_list(Rid)++":"++intlist2str(BC1)++"$"++intlist2str(BC2)};

generate_detail(17,AreaId)->
	Rid=lists:nth(AreaId,?ILOTTO_RESULTS),
	L1=integer_to_list(lotterygen:generate_zero_til_max(9)),
	L2=integer_to_list(lotterygen:generate_zero_til_max(9)),
	#detail{content=integer_to_list(Rid)++":"++L1++"$"++L2++"$"++L1};


generate_detail(18,_AreaId)->
	L=lotterygen:generate_zero_til_max(7)+3,
	BetContent=lotterygen:id_list_from_zero(9,L),
	Bets=if 
		L >=2 -> comb(L,2)*2;
		L < 2 -> 1
	end,
	#detail{bets=Bets,content=intlist2str(BetContent)};

generate_detail(19,_AreaId)->
	L=lotterygen:generate_zero_til_max(7)+3,
	BetContent=lotterygen:id_list_from_zero(9,L),
	Bets=if 
		L >=3 -> comb(L,3);
		L < 3 -> 1
	end,
	#detail{bets=Bets,content=intlist2str(BetContent)};

generate_detail(Id,_AreaId) when Id>=20, Id =<33 ->
	R=lotterygen:generate_zero_til_max(2),
	BC=if
		R==1 -> Id-20;
		true-> 47-Id
	end,
	#detail{content=integer_to_list(BC)};

generate_detail(45,_AreaId) ->
	L1=lotterygen:generate_zero_til_max(2)+1,
	L2=lotterygen:generate_zero_til_max(2)+3,
	#detail{content=integer_to_list(L1)++integer_to_list(L2)};

generate_detail(Id,_AreaId) when Id>33, Id<45->
	#detail{content=""}.

generate(Device)->
	AreaId=2,
	Stake=10,
	Id=lotterygen:generate_one_to_max(45),
	#detail{bets=Bets,content=BetContent}=generate_detail(Id,AreaId),
	Amount=Stake*Bets,
	io:format(Device,"~p,~p,~p,~p,~p,~s~n",[AreaId,Stake,Bets,Amount,Id,BetContent]).
	%{AreaId,Stake,Bets,Amount,Id,BetContent}.

start(Amount)->
	{ok,Device}=file:open("ilottobets.csv",[write]),
	[generate(Device)|| _ <- lists:seq(1,Amount)],
	file:close(Device).



% detail_to_csv(Device,Detail)->
% 	io:format(Device,"~p,~p,~p,~p,~p,~s~n",
% 			[Detail#detail.areaId,
% 			Detail#detail.stake,
% 			Detail#detail.bets,
% 			Detail#detail.amount,
% 			Detail#detail.id,
% 			Detail#detail.betContent]).
		
% start(Amount)->
% 	{ok,Device}=file:open("bets.csv",[write]),
% 	[detail_to_csv(Device,generate_keno_detail(N)) || N <- lists:seq(1,Amount)],
% 	file:close(Device).