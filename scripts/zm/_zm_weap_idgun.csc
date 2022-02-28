// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_vortex;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_weapons;

#namespace idgun;

/*
	Name: __init__sytem__
	Namespace: idgun
	Checksum: 0xCF1414B7
	Offset: 0x240
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("idgun", &init, undefined, undefined);
}

/*
	Name: init
	Namespace: idgun
	Checksum: 0xB082EC8B
	Offset: 0x280
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.weaponnone = getweapon("none");
	level.var_29323b70 = getweapon("robotech_launcher");
	level.var_672ab258 = getweapon("robotech_launcher_upgraded");
	construct_idgun_weapon_array();
	callback::on_spawned(&function_50ee0a95);
}

/*
	Name: function_50ee0a95
	Namespace: idgun
	Checksum: 0xDAFB843A
	Offset: 0x320
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_50ee0a95(localclientnum)
{
}

/*
	Name: function_e1efbc50
	Namespace: idgun
	Checksum: 0xA6F9628D
	Offset: 0x338
	Size: 0x8A
	Parameters: 1
	Flags: Linked
*/
function function_e1efbc50(var_9727e47e)
{
	if(var_9727e47e != level.weaponnone)
	{
		if(!isdefined(level.idgun_weapons))
		{
			level.idgun_weapons = [];
		}
		else if(!isarray(level.idgun_weapons))
		{
			level.idgun_weapons = array(level.idgun_weapons);
		}
		level.idgun_weapons[level.idgun_weapons.size] = var_9727e47e;
	}
}

/*
	Name: construct_idgun_weapon_array
	Namespace: idgun
	Checksum: 0x52357579
	Offset: 0x3D0
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function construct_idgun_weapon_array()
{
	level.idgun_weapons = [];
	function_e1efbc50(getweapon("idgun_0"));
	function_e1efbc50(getweapon("idgun_1"));
	function_e1efbc50(getweapon("idgun_2"));
	function_e1efbc50(getweapon("idgun_3"));
	function_e1efbc50(getweapon("idgun_upgraded_0"));
	function_e1efbc50(getweapon("idgun_upgraded_1"));
	function_e1efbc50(getweapon("idgun_upgraded_2"));
	function_e1efbc50(getweapon("idgun_upgraded_3"));
}

/*
	Name: function_9b7ac6a9
	Namespace: idgun
	Checksum: 0xD667D9A7
	Offset: 0x530
	Size: 0x98
	Parameters: 1
	Flags: None
*/
function function_9b7ac6a9(weapon)
{
	if(weapon === getweapon("idgun_upgraded_0") || weapon === getweapon("idgun_upgraded_1") || weapon === getweapon("idgun_upgraded_2") || weapon === getweapon("idgun_upgraded_3"))
	{
		return true;
	}
	return false;
}

/*
	Name: is_idgun_damage
	Namespace: idgun
	Checksum: 0xA7233AB0
	Offset: 0x5D0
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function is_idgun_damage(weapon)
{
	if(isdefined(level.idgun_weapons))
	{
		if(isinarray(level.idgun_weapons, weapon))
		{
			return true;
		}
	}
	return false;
}

