// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_thundergun;

/*
	Name: __init__sytem__
	Namespace: zm_weap_thundergun
	Checksum: 0xF681EF31
	Offset: 0x168
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_thundergun", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_thundergun
	Checksum: 0x60C22CBE
	Offset: 0x1B0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.weaponzmthundergun = getweapon("thundergun");
	level.weaponzmthundergunupgraded = getweapon("thundergun_upgraded");
}

/*
	Name: __main__
	Namespace: zm_weap_thundergun
	Checksum: 0xEA008CFD
	Offset: 0x200
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	callback::on_localplayer_spawned(&localplayer_spawned);
}

/*
	Name: localplayer_spawned
	Namespace: zm_weap_thundergun
	Checksum: 0x358669E2
	Offset: 0x230
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function localplayer_spawned(localclientnum)
{
	self thread watch_for_thunderguns(localclientnum);
}

/*
	Name: watch_for_thunderguns
	Namespace: zm_weap_thundergun
	Checksum: 0x998364CB
	Offset: 0x260
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function watch_for_thunderguns(localclientnum)
{
	self endon(#"disconnect");
	self notify(#"watch_for_thunderguns");
	self endon(#"watch_for_thunderguns");
	while(isdefined(self))
	{
		self waittill(#"weapon_change", w_new_weapon, w_old_weapon);
		if(w_new_weapon == level.weaponzmthundergun || w_new_weapon == level.weaponzmthundergunupgraded)
		{
			self thread thundergun_fx_power_cell(localclientnum, w_new_weapon);
		}
	}
}

/*
	Name: thundergun_fx_power_cell
	Namespace: zm_weap_thundergun
	Checksum: 0xA4D347A0
	Offset: 0x308
	Size: 0x158
	Parameters: 2
	Flags: Linked
*/
function thundergun_fx_power_cell(localclientnum, w_weapon)
{
	self endon(#"disconnect");
	self endon(#"weapon_change");
	self endon(#"entityshutdown");
	n_old_ammo = -1;
	n_shader_val = 0;
	while(true)
	{
		wait(0.1);
		if(!isdefined(self))
		{
			return;
		}
		n_ammo = getweaponammoclip(localclientnum, w_weapon);
		if(n_old_ammo > 0 && n_old_ammo != n_ammo)
		{
			thundergun_fx_fire(localclientnum);
		}
		n_old_ammo = n_ammo;
		if(n_ammo == 0)
		{
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
		}
		else
		{
			n_shader_val = 4 - n_ammo;
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, n_shader_val, 0);
		}
	}
}

/*
	Name: thundergun_fx_fire
	Namespace: zm_weap_thundergun
	Checksum: 0x9B09BEE2
	Offset: 0x468
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function thundergun_fx_fire(localclientnum)
{
	playsound(localclientnum, "wpn_thunder_breath", (0, 0, 0));
}

