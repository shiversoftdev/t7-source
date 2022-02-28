// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace archetype_robot;

/*
	Name: __init__sytem__
	Namespace: archetype_robot
	Checksum: 0xE5EDBCD0
	Offset: 0x2B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("robot", &__init__, undefined, undefined);
}

/*
	Name: precache
	Namespace: archetype_robot
	Checksum: 0xBF78174C
	Offset: 0x2F0
	Size: 0x3A
	Parameters: 0
	Flags: AutoExec
*/
function autoexec precache()
{
	level._effect["fx_ability_elec_surge_short_robot"] = "electric/fx_ability_elec_surge_short_robot";
	level._effect["fx_exp_robot_stage3_evb"] = "explosions/fx_exp_robot_stage3_evb";
}

/*
	Name: __init__
	Namespace: archetype_robot
	Checksum: 0x5BA98427
	Offset: 0x338
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(ai::shouldregisterclientfieldforarchetype("robot"))
	{
		clientfield::register("actor", "robot_mind_control", 1, 2, "int", &robotclientutils::robotmindcontrolhandler, 0, 1);
		clientfield::register("actor", "robot_mind_control_explosion", 1, 1, "int", &robotclientutils::robotmindcontrolexplosionhandler, 0, 0);
		clientfield::register("actor", "robot_lights", 1, 3, "int", &robotclientutils::robotlightshandler, 0, 0);
		clientfield::register("actor", "robot_EMP", 1, 1, "int", &robotclientutils::robotemphandler, 0, 0);
	}
	ai::add_archetype_spawn_function("robot", &robotclientutils::robotsoldierspawnsetup);
}

#namespace robotclientutils;

/*
	Name: robotsoldierspawnsetup
	Namespace: robotclientutils
	Checksum: 0x49E782E8
	Offset: 0x4A8
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private robotsoldierspawnsetup(localclientnum)
{
	entity = self;
}

/*
	Name: robotlighting
	Namespace: robotclientutils
	Checksum: 0xCAD85F8B
	Offset: 0x4D0
	Size: 0x346
	Parameters: 4
	Flags: Linked, Private
*/
function private robotlighting(localclientnum, entity, flicker, mindcontrolstate)
{
	switch(mindcontrolstate)
	{
		case 0:
		{
			entity tmodeclearflag(0);
			if(flicker)
			{
				fxclientutils::playfxbundle(localclientnum, entity, entity.altfxdef3);
			}
			else
			{
				fxclientutils::playfxbundle(localclientnum, entity, entity.fxdef);
			}
			break;
		}
		case 1:
		{
			entity tmodeclearflag(0);
			fxclientutils::stopallfxbundles(localclientnum, entity);
			if(flicker)
			{
				fxclientutils::playfxbundle(localclientnum, entity, entity.altfxdef4);
			}
			else
			{
				fxclientutils::playfxbundle(localclientnum, entity, entity.altfxdef1);
			}
			if(!gibclientutils::isgibbed(localclientnum, entity, 8))
			{
				entity playsound(localclientnum, "fly_bot_ctrl_lvl_01_start", entity.origin);
			}
			break;
		}
		case 2:
		{
			entity tmodesetflag(0);
			fxclientutils::stopallfxbundles(localclientnum, entity);
			if(flicker)
			{
				fxclientutils::playfxbundle(localclientnum, entity, entity.altfxdef4);
			}
			else
			{
				fxclientutils::playfxbundle(localclientnum, entity, entity.altfxdef1);
			}
			if(!gibclientutils::isgibbed(localclientnum, entity, 8))
			{
				entity playsound(localclientnum, "fly_bot_ctrl_lvl_02_start", entity.origin);
			}
			break;
		}
		case 3:
		{
			entity tmodesetflag(0);
			fxclientutils::stopallfxbundles(localclientnum, entity);
			if(flicker)
			{
				fxclientutils::playfxbundle(localclientnum, entity, entity.altfxdef5);
			}
			else
			{
				fxclientutils::playfxbundle(localclientnum, entity, entity.altfxdef2);
			}
			entity playsound(localclientnum, "fly_bot_ctrl_lvl_03_start", entity.origin);
			break;
		}
	}
}

/*
	Name: robotlightshandler
	Namespace: robotclientutils
	Checksum: 0xE77A3CFE
	Offset: 0x820
	Size: 0x164
	Parameters: 7
	Flags: Linked, Private
*/
function private robotlightshandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(!isdefined(entity) || !entity isai() || (isdefined(entity.archetype) && entity.archetype != "robot"))
	{
		return;
	}
	fxclientutils::stopallfxbundles(localclientnum, entity);
	flicker = newvalue == 1;
	if(newvalue == 0 || newvalue == 3 || flicker)
	{
		robotlighting(localclientnum, entity, flicker, clientfield::get("robot_mind_control"));
	}
	else if(newvalue == 4)
	{
		fxclientutils::playfxbundle(localclientnum, entity, entity.deathfxdef);
	}
}

/*
	Name: robotemphandler
	Namespace: robotclientutils
	Checksum: 0xEBB2D757
	Offset: 0x990
	Size: 0x13A
	Parameters: 7
	Flags: Linked, Private
*/
function private robotemphandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(!isdefined(entity) || !entity isai() || (isdefined(entity.archetype) && entity.archetype != "robot"))
	{
		return;
	}
	if(isdefined(entity.empfx))
	{
		stopfx(localclientnum, entity.empfx);
	}
	switch(newvalue)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			entity.empfx = playfxontag(localclientnum, level._effect["fx_ability_elec_surge_short_robot"], entity, "j_spine4");
			break;
		}
	}
}

/*
	Name: robotmindcontrolhandler
	Namespace: robotclientutils
	Checksum: 0xBBB3210F
	Offset: 0xAD8
	Size: 0x114
	Parameters: 7
	Flags: Linked, Private
*/
function private robotmindcontrolhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(!isdefined(entity) || !entity isai() || (isdefined(entity.archetype) && entity.archetype != "robot"))
	{
		return;
	}
	lights = clientfield::get("robot_lights");
	flicker = lights == 1;
	if(lights == 0 || flicker)
	{
		robotlighting(localclientnum, entity, flicker, newvalue);
	}
}

/*
	Name: robotmindcontrolexplosionhandler
	Namespace: robotclientutils
	Checksum: 0x334D8647
	Offset: 0xBF8
	Size: 0x102
	Parameters: 7
	Flags: Linked
*/
function robotmindcontrolexplosionhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(!isdefined(entity) || !entity isai() || (isdefined(entity.archetype) && entity.archetype != "robot"))
	{
		return;
	}
	switch(newvalue)
	{
		case 1:
		{
			entity.explosionfx = playfxontag(localclientnum, level._effect["fx_exp_robot_stage3_evb"], entity, "j_spineupper");
			break;
		}
	}
}

