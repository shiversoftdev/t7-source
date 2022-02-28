// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace deathicons;

/*
	Name: __init__sytem__
	Namespace: deathicons
	Checksum: 0xCEB1604A
	Offset: 0x198
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
	Checksum: 0xE1DBFCFF
	Offset: 0x1D8
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
	Checksum: 0x24F777ED
	Offset: 0x228
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
	Checksum: 0x939BDE4E
	Offset: 0x260
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
	Offset: 0x278
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
	Checksum: 0xA8B2E5F2
	Offset: 0x288
	Size: 0x184
	Parameters: 4
	Flags: Linked
*/
function add(entity, dyingplayer, team, timeout)
{
	if(!level.teambased)
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
	/#
		assert(isdefined(level.teamindex[team]));
	#/
	if(getdvarstring("ui_hud_showdeathicons") == "0")
	{
		return;
	}
	if(level.hardcoremode)
	{
		return;
	}
	deathiconobjid = gameobjects::get_next_obj_id();
	objective_add(deathiconobjid, "active", iconorg, &"headicon_dead");
	objective_team(deathiconobjid, team);
	level thread destroy_slowly(timeout, deathiconobjid);
}

/*
	Name: destroy_slowly
	Namespace: deathicons
	Checksum: 0x3D38E3D6
	Offset: 0x418
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function destroy_slowly(timeout, deathiconobjid)
{
	wait(timeout);
	objective_state(deathiconobjid, "done");
	wait(1);
	objective_delete(deathiconobjid);
	gameobjects::release_obj_id(deathiconobjid);
}

/*
	Name: ragdoll_override
	Namespace: deathicons
	Checksum: 0xF6CCAF77
	Offset: 0x490
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

