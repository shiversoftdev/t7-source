// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace warlord;

/*
	Name: __init__sytem__
	Namespace: warlord
	Checksum: 0xBAC6971B
	Offset: 0x3C0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("warlord", &__init__, undefined, undefined);
}

/*
	Name: precache
	Namespace: warlord
	Checksum: 0x6AB4E328
	Offset: 0x400
	Size: 0xE2
	Parameters: 0
	Flags: AutoExec
*/
function autoexec precache()
{
	level._effect["fx_elec_warlord_damage_1"] = "electric/fx_elec_warlord_damage_1";
	level._effect["fx_elec_warlord_damage_2"] = "electric/fx_elec_warlord_damage_2";
	level._effect["fx_elec_warlord_lower_damage_1"] = "electric/fx_elec_warlord_lower_damage_1";
	level._effect["fx_elec_warlord_lower_damage_2"] = "electric/fx_elec_warlord_lower_damage_2";
	level._effect["fx_exp_warlord_death"] = "explosions/fx_exp_warlord_death";
	level._effect["fx_exhaust_jetpack_warlord_juke"] = "vehicle/fx_exhaust_jetpack_warlord_juke";
	level._effect["fx_light_eye_glow_warlord"] = "light/fx_light_eye_glow_warlord";
	level._effect["fx_light_body_glow_warlord"] = "light/fx_light_body_glow_warlord";
}

/*
	Name: __init__
	Namespace: warlord
	Checksum: 0x64A4DEB8
	Offset: 0x4F0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(ai::shouldregisterclientfieldforarchetype("warlord"))
	{
		clientfield::register("actor", "warlord_type", 1, 2, "int", &warlordclientutils::warlordtypehandler, 0, 0);
		clientfield::register("actor", "warlord_damage_state", 1, 2, "int", &warlordclientutils::warlorddamagestatehandler, 0, 0);
		clientfield::register("actor", "warlord_thruster_direction", 1, 3, "int", &warlordclientutils::warlordthrusterhandler, 0, 0);
		clientfield::register("actor", "warlord_lights_state", 1, 1, "int", &warlordclientutils::warlordlightshandler, 0, 0);
	}
}

#namespace warlordclientutils;

/*
	Name: warlorddamagestatehandler
	Namespace: warlordclientutils
	Checksum: 0xE0444911
	Offset: 0x638
	Size: 0x22E
	Parameters: 7
	Flags: Linked
*/
function warlorddamagestatehandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(isdefined(entity.damagestatefx))
	{
		stopfx(localclientnum, entity.damagestatefx);
		entity.damagestatefx = undefined;
	}
	if(isdefined(entity.damageheavystatefx))
	{
		stopfx(localclientnum, entity.damageheavystatefx);
		entity.damageheavystatefx = undefined;
	}
	switch(newvalue)
	{
		case 0:
		{
			break;
		}
		case 2:
		{
			entity.damageheavystatefx = playfxontag(localclientnum, level._effect["fx_elec_warlord_damage_2"], entity, "j_spine4");
			playfxontag(localclientnum, level._effect["fx_elec_warlord_lower_damage_2"], entity, "j_mainroot");
		}
		case 1:
		{
			entity.damagestatefx = playfxontag(localclientnum, level._effect["fx_elec_warlord_damage_1"], entity, "j_spine4");
			playfxontag(localclientnum, level._effect["fx_elec_warlord_lower_damage_1"], entity, "j_mainroot");
			break;
		}
		case 3:
		{
			playfxontag(localclientnum, level._effect["fx_exp_warlord_death"], entity, "j_spine4");
			break;
		}
	}
}

/*
	Name: warlordtypehandler
	Namespace: warlordclientutils
	Checksum: 0x6AF2E411
	Offset: 0x870
	Size: 0x60
	Parameters: 7
	Flags: Linked
*/
function warlordtypehandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	entity.warlordtype = newvalue;
}

/*
	Name: warlordthrusterhandler
	Namespace: warlordclientutils
	Checksum: 0xF139463B
	Offset: 0x8D8
	Size: 0x25C
	Parameters: 7
	Flags: Linked
*/
function warlordthrusterhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(isdefined(entity.thrusterfx))
	{
		/#
			assert(isarray(entity.thrusterfx));
		#/
		for(index = 0; index < entity.thrusterfx.size; index++)
		{
			stopfx(localclientnum, entity.thrusterfx[index]);
		}
	}
	entity.thrusterfx = [];
	tags = [];
	switch(newvalue)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			tags = array("tag_jets_left_front", "tag_jets_right_front");
			break;
		}
		case 2:
		{
			tags = array("tag_jets_left_back", "tag_jets_right_back");
			break;
		}
		case 3:
		{
			tags = array("tag_jets_left_side");
			break;
		}
		case 4:
		{
			tags = array("tag_jets_right_side");
			break;
		}
	}
	for(index = 0; index < tags.size; index++)
	{
		entity.thrusterfx[entity.thrusterfx.size] = playfxontag(localclientnum, level._effect["fx_exhaust_jetpack_warlord_juke"], entity, tags[index]);
	}
}

/*
	Name: warlordlightshandler
	Namespace: warlordclientutils
	Checksum: 0xBF029161
	Offset: 0xB40
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function warlordlightshandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(newvalue == 1)
	{
		playfxontag(localclientnum, level._effect["fx_light_eye_glow_warlord"], entity, "tag_eye");
		playfxontag(localclientnum, level._effect["fx_light_body_glow_warlord"], entity, "j_spine4");
	}
}

