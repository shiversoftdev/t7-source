// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_util;
#using scripts\zm\_zm_placeable_mine;

#namespace bouncingbetty;

/*
	Name: __init__sytem__
	Namespace: bouncingbetty
	Checksum: 0x43C5DE25
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bouncingbetty", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bouncingbetty
	Checksum: 0x6C2E6E41
	Offset: 0x1F0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._proximityweaponobjectdetonation_override = &proximityweaponobjectdetonation_override;
	init_shared();
	zm_placeable_mine::add_mine_type("bouncingbetty", &"MP_BOUNCINGBETTY_PICKUP");
	level.bettyjumpheight = 55;
	level.bettydamagemax = 1000;
	level.bettydamagemin = 800;
	level.bettydamageheight = level.bettyjumpheight;
	/#
		setdvar("", level.bettydamagemax);
		setdvar("", level.bettydamagemin);
		setdvar("", level.bettyjumpheight);
	#/
}

/*
	Name: proximityweaponobjectdetonation_override
	Namespace: bouncingbetty
	Checksum: 0x7D73C82A
	Offset: 0x2E0
	Size: 0x178
	Parameters: 1
	Flags: Linked
*/
function proximityweaponobjectdetonation_override(watcher)
{
	self endon(#"death");
	self endon(#"hacked");
	self endon(#"kill_target_detection");
	weaponobjects::proximityweaponobject_activationdelay(watcher);
	damagearea = weaponobjects::proximityweaponobject_createdamagearea(watcher);
	up = anglestoup(self.angles);
	traceorigin = self.origin + up;
	if(isdefined(level._bouncingbettywatchfortrigger))
	{
		self thread [[level._bouncingbettywatchfortrigger]](watcher);
	}
	while(true)
	{
		damagearea waittill(#"trigger", ent);
		if(!weaponobjects::proximityweaponobject_validtriggerentity(watcher, ent))
		{
			continue;
		}
		if(weaponobjects::proximityweaponobject_isspawnprotected(watcher, ent))
		{
			continue;
		}
		if(ent damageconetrace(traceorigin, self) > 0)
		{
			thread weaponobjects::proximityweaponobject_dodetonation(watcher, ent, traceorigin);
		}
	}
}

