// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_bgb_ephemeral_enhancement;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_ephemeral_enhancement
	Checksum: 0x7FE34B79
	Offset: 0x278
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_ephemeral_enhancement", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_ephemeral_enhancement
	Checksum: 0xFECB091C
	Offset: 0x2B8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_ephemeral_enhancement", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::function_f132da9c("zm_bgb_ephemeral_enhancement");
	bgb::function_336ffc4e("zm_bgb_ephemeral_enhancement");
}

/*
	Name: validation
	Namespace: zm_bgb_ephemeral_enhancement
	Checksum: 0xA6C5F10A
	Offset: 0x358
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function validation()
{
	if(isdefined(self bgb::get_active()) && self bgb::get_active())
	{
		return 0;
	}
	if(isdefined(self.zombie_vars["zombie_powerup_minigun_on"]) && self.zombie_vars["zombie_powerup_minigun_on"])
	{
		return 0;
	}
	weap = self getcurrentweapon();
	return zm_weapons::can_upgrade_weapon(weap);
}

/*
	Name: activation
	Namespace: zm_bgb_ephemeral_enhancement
	Checksum: 0xFE4205DF
	Offset: 0x408
	Size: 0x484
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"replaced_upgraded_weapon");
	self util::waittill_any_timeout(1, "weapon_change_complete", "death", "disconnect", "bled_out", "replaced_upgraded_weapon");
	if(self laststand::player_is_in_laststand())
	{
		return;
	}
	if(isdefined(self.zombie_vars["zombie_powerup_minigun_on"]) && self.zombie_vars["zombie_powerup_minigun_on"])
	{
		return;
	}
	var_1d94ca2b = self getcurrentweapon();
	self.var_fb11234e = var_1d94ca2b;
	if(!zm_weapons::can_upgrade_weapon(var_1d94ca2b))
	{
		return;
	}
	self zm_stats::increment_challenge_stat("GUM_GOBBLER_EPHEMERAL_ENHANCEMENT");
	var_a08320d8 = self getweaponammoclip(var_1d94ca2b);
	var_7298c138 = self getweaponammostock(var_1d94ca2b);
	var_19dc14f6 = zm_weapons::get_upgrade_weapon(var_1d94ca2b);
	var_19dc14f6 = self zm_weapons::give_build_kit_weapon(var_19dc14f6);
	self givestartammo(var_19dc14f6);
	self switchtoweaponimmediate(var_19dc14f6);
	self takeweapon(var_1d94ca2b, 1);
	self thread function_79585675(var_19dc14f6);
	self bgb::run_timer(60);
	self notify(#"hash_5cefcc84");
	if(self laststand::player_is_in_laststand())
	{
		self waittill(#"player_revived");
	}
	if(isdefined(level.var_b6d13a4e))
	{
		[[level.var_b6d13a4e]]();
	}
	self.var_fb11234e = undefined;
	if(!self zm_weapons::has_weapon_or_attachments(var_19dc14f6))
	{
		return;
	}
	var_5ddb5ced = self getweaponammoclip(var_19dc14f6);
	var_398b66eb = self getweaponammostock(var_19dc14f6);
	var_1d94ca2b = self zm_weapons::switch_from_alt_weapon(var_1d94ca2b);
	var_1d94ca2b = self zm_weapons::give_build_kit_weapon(var_1d94ca2b);
	if((var_5ddb5ced + var_398b66eb) > (var_a08320d8 + var_7298c138))
	{
		self givestartammo(var_1d94ca2b);
		var_a08320d8 = self getweaponammoclip(var_1d94ca2b);
		var_7298c138 = self getweaponammostock(var_1d94ca2b);
		if((var_5ddb5ced + var_398b66eb) < (var_a08320d8 + var_7298c138))
		{
			var_a08320d8 = var_5ddb5ced;
			var_7298c138 = var_398b66eb;
		}
	}
	self setweaponammoclip(var_1d94ca2b, var_a08320d8);
	self setweaponammostock(var_1d94ca2b, var_7298c138);
	current_weapon = self getcurrentweapon();
	if(current_weapon == var_19dc14f6)
	{
		self zm_weapons::switch_back_primary_weapon(var_1d94ca2b, 1);
	}
	self takeweapon(var_19dc14f6, 1);
}

/*
	Name: function_79585675
	Namespace: zm_bgb_ephemeral_enhancement
	Checksum: 0x81199122
	Offset: 0x898
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function function_79585675(var_19dc14f6)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"bgb_update");
	self endon(#"hash_5cefcc84");
	while(true)
	{
		self waittill(#"weapon_change_complete");
		if(!self zm_weapons::has_weapon_or_attachments(var_19dc14f6))
		{
			self notify(#"replaced_upgraded_weapon");
			self.var_fb11234e = undefined;
			return;
		}
	}
}

