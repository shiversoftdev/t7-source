// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_weap_staff;

/*
	Name: __init__sytem__
	Namespace: zm_weap_staff
	Checksum: 0xD504E4EF
	Offset: 0x120
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_staff
	Checksum: 0x22C0E03F
	Offset: 0x160
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_27b5be99 = [];
	callback::on_localplayer_spawned(&function_d10163c2);
}

/*
	Name: function_4be5e665
	Namespace: zm_weap_staff
	Checksum: 0x2CD8922
	Offset: 0x1A0
	Size: 0x26
	Parameters: 2
	Flags: Linked
*/
function function_4be5e665(w_weapon, fx)
{
	level.var_27b5be99[w_weapon] = fx;
}

/*
	Name: function_d10163c2
	Namespace: zm_weap_staff
	Checksum: 0xC7652C7A
	Offset: 0x1D0
	Size: 0xB8
	Parameters: 1
	Flags: Linked
*/
function function_d10163c2(localclientnum)
{
	self notify(#"hash_d10163c2");
	self endon(#"hash_d10163c2");
	self endon(#"entityshutdown");
	while(isdefined(self))
	{
		self waittill(#"weapon_change", w_weapon);
		self notify(#"hash_d4c51f0");
		self function_d4c51f0(localclientnum);
		if(isdefined(level.var_27b5be99[w_weapon]))
		{
			self thread function_2b18ce1b(localclientnum, level.var_27b5be99[w_weapon]);
		}
	}
}

/*
	Name: function_2b18ce1b
	Namespace: zm_weap_staff
	Checksum: 0x207FDC2B
	Offset: 0x290
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function function_2b18ce1b(localclientnum, fx)
{
	self endon(#"hash_d4c51f0");
	while(isdefined(self))
	{
		charge = getweaponchargelevel(localclientnum);
		if(charge > 0)
		{
			if(!isdefined(self.var_2a76e26))
			{
				self.var_2a76e26 = playviewmodelfx(localclientnum, fx, "tag_fx_upg_1");
			}
		}
		else
		{
			function_d4c51f0(localclientnum);
		}
		wait(0.15);
	}
}

/*
	Name: function_d4c51f0
	Namespace: zm_weap_staff
	Checksum: 0x1854DE80
	Offset: 0x348
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function function_d4c51f0(localclientnum)
{
	if(isdefined(self.var_2a76e26))
	{
		stopfx(localclientnum, self.var_2a76e26);
		self.var_2a76e26 = undefined;
	}
}

