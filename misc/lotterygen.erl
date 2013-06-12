-module(lotterygen).
-export([generate_one_to_max/1,generate_zero_til_max/1,id_list_from_one/2,id_list_from_zero/2]).

generate_one_to_max(Max)->
	generate_zero_til_max(Max)+1.

generate_zero_til_max(Max)->
	trunc(random:uniform()*Max).

id_list_from_one(Max,Len)->
	generate_id_list(Max,Len,[],fun generate_one_to_max/1).

id_list_from_zero(Max,Len)->
	generate_id_list(Max,Len,sets:new(),fun generate_zero_til_max/1).

generate_id_list(Max,Len,Acc,F) when Max>=Len ->
	case Len of
		0 -> sets:to_list(Acc);
		_-> Id = F(Max),
			NewAcc=sets:add_element(Id,Acc),
			Delta=sets:size(NewAcc)-sets:size(Acc),
			generate_id_list(Max,Len-Delta,NewAcc,F)
	end.