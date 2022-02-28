// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;

#namespace oob;

/*
	Name: __init__sytem__
	Namespace: oob
	Checksum: 0xA62B8D4E
	Offset: 0x178
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("out_of_bounds", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: oob
	Checksum: 0x62AF9BDE
	Offset: 0x1B8
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(sessionmodeismultiplayergame())
	{
		level.oob_timelimit_ms = getdvarint("oob_timelimit_ms", 3000);
		level.oob_timekeep_ms = getdvarint("oob_timekeep_ms", 3000);
	}
	else
	{
		level.oob_timelimit_ms = getdvarint("oob_timelimit_ms", 6000);
	}
	clientfield::register("toplayer", "out_of_bounds", 1, 5, "int", &onoutofboundschange, 0, 1);
	if(!sessionmodeiszombiesgame())
	{
		callback::on_localclient_connect(&on_localplayer_connect);
		callback::on_localplayer_spawned(&on_localplayer_spawned);
		callback::on_localclient_shutdown(&on_localplayer_shutdown);
	}
}

/*
	Name: on_localplayer_connect
	Namespace: oob
	Checksum: 0x6D22B931
	Offset: 0x308
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_connect(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	oobmodel = getoobuimodel(localclientnum);
	setuimodelvalue(oobmodel, 0);
}

/*
	Name: on_localplayer_spawned
	Namespace: oob
	Checksum: 0xA06FB2AF
	Offset: 0x380
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_spawned(localclientnum)
{
	filter::disable_filter_oob(self, 0);
	self randomfade(0);
}

/*
	Name: on_localplayer_shutdown
	Namespace: oob
	Checksum: 0xBD01F527
	Offset: 0x3C8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_shutdown(localclientnum)
{
	localplayer = self;
	if(isdefined(localplayer))
	{
		stopoutofboundseffects(localclientnum, localplayer);
	}
}

/*
	Name: onoutofboundschange
	Namespace: oob
	Checksum: 0xFE4045DA
	Offset: 0x418
	Size: 0x33C
	Parameters: 7
	Flags: Linked
*/
function onoutofboundschange(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	localplayer = getlocalplayer(localclientnum);
	if(!isdefined(level.oob_sound_ent))
	{
		level.oob_sound_ent = [];
	}
	if(!isdefined(level.oob_sound_ent[localclientnum]))
	{
		level.oob_sound_ent[localclientnum] = spawn(localclientnum, (0, 0, 0), "script_origin");
	}
	if(newval > 0)
	{
		if(!isdefined(localplayer.oob_effect_enabled))
		{
			filter::init_filter_oob(localplayer);
			filter::enable_filter_oob(localplayer, 0);
			localplayer.oob_effect_enabled = 1;
			level.oob_sound_ent[localclientnum] playloopsound("uin_out_of_bounds_loop", 0.5);
			oobmodel = getoobuimodel(localclientnum);
			if(isdefined(level.oob_timekeep_ms) && isdefined(self.oob_start_time) && isdefined(self.oob_active_duration) && (getservertime(0) - self.oob_end_time) < level.oob_timekeep_ms)
			{
				setuimodelvalue(oobmodel, getservertime(0, 1) + (level.oob_timelimit_ms - self.oob_active_duration));
			}
			else
			{
				self.oob_active_duration = undefined;
				setuimodelvalue(oobmodel, getservertime(0, 1) + level.oob_timelimit_ms);
			}
			self.oob_start_time = getservertime(0, 1);
		}
		newvalf = newval / 31;
		localplayer randomfade(newvalf);
	}
	else
	{
		if(isdefined(level.oob_timekeep_ms) && isdefined(self.oob_start_time))
		{
			self.oob_end_time = getservertime(0, 1);
			if(!isdefined(self.oob_active_duration))
			{
				self.oob_active_duration = 0;
			}
			self.oob_active_duration = self.oob_active_duration + (self.oob_end_time - self.oob_start_time);
		}
		stopoutofboundseffects(localclientnum, localplayer);
	}
}

/*
	Name: stopoutofboundseffects
	Namespace: oob
	Checksum: 0xB0C56CA4
	Offset: 0x760
	Size: 0xFE
	Parameters: 2
	Flags: Linked
*/
function stopoutofboundseffects(localclientnum, localplayer)
{
	filter::disable_filter_oob(localplayer, 0);
	localplayer randomfade(0);
	if(isdefined(level.oob_sound_ent) && isdefined(level.oob_sound_ent[localclientnum]))
	{
		level.oob_sound_ent[localclientnum] stopallloopsounds(0.5);
	}
	oobmodel = getoobuimodel(localclientnum);
	setuimodelvalue(oobmodel, 0);
	if(isdefined(localplayer.oob_effect_enabled))
	{
		localplayer.oob_effect_enabled = 0;
		localplayer.oob_effect_enabled = undefined;
	}
}

/*
	Name: getoobuimodel
	Namespace: oob
	Checksum: 0xCE4EF0F2
	Offset: 0x868
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function getoobuimodel(localclientnum)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	return createuimodel(controllermodel, "hudItems.outOfBoundsEndTime");
}

