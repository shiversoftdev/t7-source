// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace trigger;

/*
	Name: function_d1278be0
	Namespace: trigger
	Checksum: 0x369EF334
	Offset: 0x78
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function function_d1278be0(ent, on_enter_payload, on_exit_payload)
{
	ent endon(#"entityshutdown");
	if(ent ent_already_in(self))
	{
		return;
	}
	add_to_ent(ent, self);
	if(isdefined(on_enter_payload))
	{
		[[on_enter_payload]](ent);
	}
	while(isdefined(ent) && ent istouching(self))
	{
		wait(0.016);
	}
	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		[[on_exit_payload]](ent);
	}
	if(isdefined(ent))
	{
		remove_from_ent(ent, self);
	}
}

/*
	Name: ent_already_in
	Namespace: trigger
	Checksum: 0xEAF7149E
	Offset: 0x180
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function ent_already_in(trig)
{
	if(!isdefined(self._triggers))
	{
		return false;
	}
	if(!isdefined(self._triggers[trig getentitynumber()]))
	{
		return false;
	}
	if(!self._triggers[trig getentitynumber()])
	{
		return false;
	}
	return true;
}

/*
	Name: add_to_ent
	Namespace: trigger
	Checksum: 0x196BFB39
	Offset: 0x1F8
	Size: 0x62
	Parameters: 2
	Flags: Linked
*/
function add_to_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	ent._triggers[trig getentitynumber()] = 1;
}

/*
	Name: remove_from_ent
	Namespace: trigger
	Checksum: 0x9138ADED
	Offset: 0x268
	Size: 0x82
	Parameters: 2
	Flags: Linked
*/
function remove_from_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		return;
	}
	if(!isdefined(ent._triggers[trig getentitynumber()]))
	{
		return;
	}
	ent._triggers[trig getentitynumber()] = 0;
}

/*
	Name: death_monitor
	Namespace: trigger
	Checksum: 0xFD01048D
	Offset: 0x2F8
	Size: 0x44
	Parameters: 2
	Flags: None
*/
function death_monitor(ent, ender)
{
	ent waittill(#"death");
	self endon(ender);
	self remove_from_ent(ent);
}

