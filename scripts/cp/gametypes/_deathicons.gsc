// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace deathicons;

/*
	Name: __init__sytem__
	Namespace: deathicons
	Checksum: 0x7C31F568
	Offset: 0x168
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("deathicons", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: deathicons
	Checksum: 0xC44F2BC0
	Offset: 0x1A8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
}

/*
	Name: init
	Namespace: deathicons
	Checksum: 0x2DF4678D
	Offset: 0x1F8
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(!isdefined(level.ragdoll_override))
	{
		level.ragdoll_override = &ragdoll_override;
	}
	if(!level.teambased)
	{
		return;
	}
}

/*
	Name: on_player_connect
	Namespace: deathicons
	Checksum: 0x5A8FD029
	Offset: 0x230
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self.selfdeathicons = [];
}

/*
	Name: update_enabled
	Namespace: deathicons
	Checksum: 0x99EC1590
	Offset: 0x248
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function update_enabled()
{
}

/*
	Name: add
	Namespace: deathicons
	Checksum: 0xF2244B14
	Offset: 0x258
	Size: 0x244
	Parameters: 4
	Flags: Linked
*/
function add(entity, dyingplayer, team, timeout)
{
	if(!level.teambased || (isdefined(level.is_safehouse) && level.is_safehouse))
	{
		return;
	}
	iconorg = entity.origin;
	dyingplayer endon(#"spawned_player");
	dyingplayer endon(#"disconnect");
	wait(0.05);
	util::waittillslowprocessallowed();
	/#
		assert(isdefined(level.teams[team]));
	#/
	if(getdvarstring("ui_hud_showdeathicons") == "0")
	{
		return;
	}
	if(level.hardcoremode)
	{
		return;
	}
	if(isdefined(self.lastdeathicon))
	{
		self.lastdeathicon destroy();
	}
	newdeathicon = newteamhudelem(team);
	newdeathicon.x = iconorg[0];
	newdeathicon.y = iconorg[1];
	newdeathicon.z = iconorg[2] + 54;
	newdeathicon.alpha = 0.61;
	newdeathicon.archived = 1;
	if(level.splitscreen)
	{
		newdeathicon setshader("headicon_dead", 14, 14);
	}
	else
	{
		newdeathicon setshader("headicon_dead", 7, 7);
	}
	newdeathicon setwaypoint(1);
	self.lastdeathicon = newdeathicon;
	newdeathicon thread destroy_slowly(timeout);
}

/*
	Name: destroy_slowly
	Namespace: deathicons
	Checksum: 0xF81CE849
	Offset: 0x4A8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function destroy_slowly(timeout)
{
	self endon(#"death");
	wait(timeout);
	self fadeovertime(1);
	self.alpha = 0;
	wait(1);
	self destroy();
}

/*
	Name: ragdoll_override
	Namespace: deathicons
	Checksum: 0xF1653F6C
	Offset: 0x518
	Size: 0xDC
	Parameters: 10
	Flags: Linked
*/
function ragdoll_override(idamage, smeansofdeath, sweapon, shitloc, vdir, vattackerorigin, deathanimduration, einflictor, ragdoll_jib, body)
{
	if(smeansofdeath == "MOD_FALLING" && self isonground() == 1)
	{
		body startragdoll();
		if(!isdefined(self.switching_teams))
		{
			thread add(body, self, self.team, 5);
		}
		return true;
	}
	return false;
}

