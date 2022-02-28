// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_dragon_strike;
#using scripts\zm\_zm_weapons;

#namespace dragon_scale_shield;

/*
	Name: __init__sytem__
	Namespace: dragon_scale_shield
	Checksum: 0x5EBD6D12
	Offset: 0x320
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_dragonshield", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: dragon_scale_shield
	Checksum: 0xE23126A3
	Offset: 0x360
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "ds_ammo", 12000, 1, "int", &function_3b8ce539, 0, 0);
	clientfield::register("allplayers", "burninate", 12000, 1, "counter", &function_adc7474a, 0, 0);
	clientfield::register("allplayers", "burninate_upgraded", 12000, 1, "counter", &function_627dd7e5, 0, 0);
	clientfield::register("actor", "dragonshield_snd_projectile_impact", 12000, 1, "counter", &dragonshield_snd_projectile_impact, 0, 0);
	clientfield::register("vehicle", "dragonshield_snd_projectile_impact", 12000, 1, "counter", &dragonshield_snd_projectile_impact, 0, 0);
	clientfield::register("actor", "dragonshield_snd_zombie_knockdown", 12000, 1, "counter", &dragonshield_snd_zombie_knockdown, 0, 0);
	clientfield::register("vehicle", "dragonshield_snd_zombie_knockdown", 12000, 1, "counter", &dragonshield_snd_zombie_knockdown, 0, 0);
}

/*
	Name: function_3b8ce539
	Namespace: dragon_scale_shield
	Checksum: 0xAA9D3096
	Offset: 0x568
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_3b8ce539(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, 0, 0);
	}
	else
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

/*
	Name: function_adc7474a
	Namespace: dragon_scale_shield
	Checksum: 0xF18DBB7A
	Offset: 0x618
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_adc7474a(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(self islocalplayer())
	{
		playfxontag(localclientnum, "dlc3/stalingrad/fx_dragon_shield_fire_1p", self, "tag_flash");
	}
	else
	{
		playfxontag(localclientnum, "dlc3/stalingrad/fx_dragon_shield_fire_3p", self, "tag_flash");
	}
}

/*
	Name: function_627dd7e5
	Namespace: dragon_scale_shield
	Checksum: 0x2C66E416
	Offset: 0x6C8
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_627dd7e5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(self islocalplayer())
	{
		playfxontag(localclientnum, "dlc3/stalingrad/fx_dragon_shield_fire_1p_up", self, "tag_flash");
	}
	else
	{
		playfxontag(localclientnum, "dlc3/stalingrad/fx_dragon_shield_fire_3p_up", self, "tag_flash");
	}
}

/*
	Name: dragonshield_snd_projectile_impact
	Namespace: dragon_scale_shield
	Checksum: 0x17DC5F73
	Offset: 0x778
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function dragonshield_snd_projectile_impact(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playsound(localclientnum, "vox_dragonshield_forcehit", self.origin);
	playsound(localclientnum, "wpn_dragonshield_proj_impact", self.origin);
}

/*
	Name: dragonshield_snd_zombie_knockdown
	Namespace: dragon_scale_shield
	Checksum: 0xBA4B1BD4
	Offset: 0x810
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function dragonshield_snd_zombie_knockdown(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playsound(localclientnum, "fly_dragonshield_forcehit", self.origin);
}

