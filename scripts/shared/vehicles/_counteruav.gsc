// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace counteruav;

/*
	Name: __init__sytem__
	Namespace: counteruav
	Checksum: 0x6DA9A314
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("counteruav", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: counteruav
	Checksum: 0xEB419C88
	Offset: 0x240
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("counteruav", &counteruav_initialize);
}

/*
	Name: counteruav_initialize
	Namespace: counteruav
	Checksum: 0x9251C15C
	Offset: 0x278
	Size: 0x188
	Parameters: 0
	Flags: None
*/
function counteruav_initialize()
{
	self useanimtree($generic);
	target_set(self, (0, 0, 0));
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self setvehicleavoidance(1);
	self sethoverparams(50, 100, 100);
	self.vehaircraftcollisionenabled = 1;
	/#
		assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalradius = 999999;
	self.goalheight = 999999;
	self setgoal(self.origin, 0, self.goalradius, self.goalheight);
	self.overridevehicledamage = &drone_callback_damage;
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
}

/*
	Name: drone_callback_damage
	Namespace: counteruav
	Checksum: 0xE530170F
	Offset: 0x408
	Size: 0xD4
	Parameters: 15
	Flags: None
*/
function drone_callback_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	idamage = vehicle_ai::shared_callback_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
	return idamage;
}

