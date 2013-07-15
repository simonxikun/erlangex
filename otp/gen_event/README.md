erlangex/otp/gen_event
========

game_table
the fake and toy gen_event handler

for my understanding, the handler is mostly for forwarding messages,if there's no logic, you can preserve the channel(socket/file etc) as state, then just do the output, job done.

In Erlang, everything is messge, why bother gen_event. It's for decoupling, so the emitter of the message don't care who are interested in the message, and don't need to maintain the list of listerners, listeners could add itself to the gen_event by gent_event:add_handler, and remove itself later.

But I still feel that if using GProc, then it can achieve the same goal without gen_event. Then we just need gproc:reg, gproc:unreg.