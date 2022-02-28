// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;

#namespace archetype_damage_effects;

/*
	Name: main
	Namespace: archetype_damage_effects
	Checksum: 0x25729624
	Offset: 0x208
	Size: 0xE4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "arch_actor_fire_fx", 1, 2, "int");
	clientfield::register("actor", "arch_actor_char", 1, 2, "int");
	callback::on_actor_damage(&onactordamagecallback);
	callback::on_vehicle_damage(&onvehicledamagecallback);
	callback::on_actor_killed(&onactorkilledcallback);
	callback::on_vehicle_killed(&onvehiclekilledcallback);
}

/*
	Name: onactordamagecallback
	Namespace: archetype_damage_effects
	Checksum: 0x15D56AC5
	Offset: 0x2F8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function onactordamagecallback(params)
{
	onactordamage(params);
}

/*
	Name: onvehicledamagecallback
	Namespace: archetype_damage_effects
	Checksum: 0xDF17122B
	Offset: 0x328
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function onvehicledamagecallback(params)
{
	onvehicledamage(params);
}

/*
	Name: onactorkilledcallback
	Namespace: archetype_damage_effects
	Checksum: 0x18ABF46B
	Offset: 0x358
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function onactorkilledcallback(params)
{
	onactorkilled();
	switch(self.archetype)
	{
		case "human":
		{
			onhumankilled();
			break;
		}
		case "robot":
		{
			onrobotkilled();
			break;
		}
	}
}

/*
	Name: onvehiclekilledcallback
	Namespace: archetype_damage_effects
	Checksum: 0x95693ED5
	Offset: 0x3D0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function onvehiclekilledcallback(params)
{
	onvehiclekilled(params);
}

/*
	Name: onactordamage
	Namespace: archetype_damage_effects
	Checksum: 0x90504447
	Offset: 0x400
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function onactordamage(params)
{
}

/*
	Name: onvehicledamage
	Namespace: archetype_damage_effects
	Checksum: 0x12F19214
	Offset: 0x418
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function onvehicledamage(params)
{
	onvehiclekilled(params);
}

/*
	Name: onactorkilled
	Namespace: archetype_damage_effects
	Checksum: 0x48E1FF5A
	Offset: 0x448
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function onactorkilled()
{
	if(isdefined(self.damagemod))
	{
		if(self.damagemod == "MOD_BURNED")
		{
			if(isdefined(self.damageweapon) && isdefined(self.damageweapon.specialpain) && self.damageweapon.specialpain == 0)
			{
				self clientfield::set("arch_actor_fire_fx", 2);
			}
		}
	}
}

/*
	Name: onhumankilled
	Namespace: archetype_damage_effects
	Checksum: 0x99EC1590
	Offset: 0x4D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function onhumankilled()
{
}

/*
	Name: onrobotkilled
	Namespace: archetype_damage_effects
	Checksum: 0x99EC1590
	Offset: 0x4E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function onrobotkilled()
{
}

/*
	Name: onvehiclekilled
	Namespace: archetype_damage_effects
	Checksum: 0x8CB7853B
	Offset: 0x4F0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function onvehiclekilled(params)
{
}

