// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace music;

/*
	Name: __init__sytem__
	Namespace: music
	Checksum: 0x77F7B329
	Offset: 0xF0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("music", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: music
	Checksum: 0x8BB88893
	Offset: 0x130
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.musicstate = "";
	util::registerclientsys("musicCmd");
	if(sessionmodeiscampaigngame())
	{
		callback::on_spawned(&on_player_spawned);
	}
}

/*
	Name: setmusicstate
	Namespace: music
	Checksum: 0xA2EAA94D
	Offset: 0x198
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function setmusicstate(state, player)
{
	if(isdefined(level.musicstate))
	{
		if(isdefined(level.bonuszm_musicoverride) && level.bonuszm_musicoverride)
		{
			return;
		}
		if(isdefined(player))
		{
			util::setclientsysstate("musicCmd", state, player);
			return;
		}
		if(level.musicstate != state)
		{
			util::setclientsysstate("musicCmd", state);
		}
	}
	level.musicstate = state;
}

/*
	Name: on_player_spawned
	Namespace: music
	Checksum: 0x201531C3
	Offset: 0x248
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	if(isdefined(level.musicstate))
	{
		if(issubstr(level.musicstate, "_igc") || issubstr(level.musicstate, "igc_"))
		{
			return;
		}
		if(isdefined(self))
		{
			setmusicstate(level.musicstate, self);
		}
		else
		{
			setmusicstate(level.musicstate);
		}
	}
}

