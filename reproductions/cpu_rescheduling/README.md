## Does changing CPU stimulate a full reschedule?

So I saw this conversation in Gitter:

>thenon @thenon:matrix.org [m]  Apr 23 08:16
>Hi all. So I've got a job scheduled in nomad, requiring 200 CPU, and its running on node X. Node X has plenty of resources available, let's say 1000 CPU. If I update the definition of the job to require 201 CPU, it of course triggers another evaluation. But if the result of that evaluation is zero changes (job remains on node X, and zero other changes to any jobs etc. etc. ) I would expect no actions to happen. Instead, my job is stopped, and started. This is bad for me to interrupt the job for no reason. Is there any way to avoid this behaviour? Thanks for any pointers.

>Florian Apolloner @apollo13 Apr 23 08:55
>changing cpu limits sounds like a change to me and not zero changes ;)

>thenon @thenon:matrix.org [m]  Apr 23 08:57
>:) but there are zero effective changes. The same jobs end up running on the same nodes. Its a null op in terms of allocations.... b

>thenon @thenon:matrix.org [m]  Apr 23 09:04
>(what we're tryign to do here is achieve dynamic bin packing. Something out of band is watching the resource usage + other stuff, and updating things like cpu/memory usage, for a job. Most of the time we'd expect no changes, jobs are find on current nodes. When something has changed (e.g. job gets busier) enough that a reallocation results in jobs moving to another node, that's fine. Great even ! That's Nomad doing the hard job of pin backing properly. But right now, jobs restart, for no reason.... )

>manveru @manveru:matrix.org [m]  Apr 23 10:24
>thenon: i think the initial idea was that nomad would somehow enforce the cpu reservation like it does with the memory one... but i guess that never got implemented, just the restarts remain :(

>thenon @thenon:matrix.org [m]  Apr 23 10:26
>manveru: I don't know, I think my comment applies to anything. let's say you changed a meta constraint value. and the end result of the re-evaluation of everything was: no changes - every job is already running where it should be, based on new constraint values. why restart the job?

### Let's do a repro

1. I created the example Nomad job using `nomad init --short repro.nomad`

1. Started up a Nomad dev agent in another window

