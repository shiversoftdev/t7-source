// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_equip_hacker;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;

#namespace zm_hackables_powerups;

/*
	Name: unhackable_powerup
	Namespace: zm_hackables_powerups
	Checksum: 0xDE066432
	Offset: 0x1C0
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function unhackable_powerup(name)
{
	ret = 0;
	switch(name)
	{
		case "bonus_points_player":
		case "bonus_points_team":
		case "lose_points_team":
		case "random_weapon":
		case "ww_grenade":
		{
			ret = 1;
			break;
		}
	}
	return ret;
}

/*
	Name: hack_powerups
	Namespace: zm_hackables_powerups
	Checksum: 0xC54CB437
	Offset: 0x230
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function hack_powerups()
{
	while(true)
	{
		level waittill(#"powerup_dropped", powerup);
		if(!unhackable_powerup(powerup.powerup_name))
		{
			struct = spawnstruct();
			struct.origin = powerup.origin;
			struct.radius = 65;
			struct.height = 72;
			struct.script_float = 5;
			struct.script_int = 5000;
			struct.powerup = powerup;
			powerup thread powerup_pickup_watcher(struct);
			zm_equip_hacker::register_pooled_hackable_struct(struct, &powerup_hack);
		}
	}
}

/*
	Name: powerup_pickup_watcher
	Namespace: zm_hackables_powerups
	Checksum: 0xA3063F9C
	Offset: 0x360
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function powerup_pickup_watcher(powerup_struct)
{
	self endon(#"hacked");
	self waittill(#"death");
	zm_equip_hacker::deregister_hackable_struct(powerup_struct);
}

/*
	Name: powerup_hack
	Namespace: zm_hackables_powerups
	Checksum: 0x586497CC
	Offset: 0x3A8
	Size: 0x1B4
	Parameters: 1
	Flags: Linked
*/
function powerup_hack(hacker)
{
	self.powerup notify(#"hacked");
	if(isdefined(self.powerup.zombie_grabbable) && self.powerup.zombie_grabbable)
	{
		self.powerup notify(#"powerup_timedout");
		origin = self.powerup.origin;
		self.powerup delete();
		self.powerup = zm_net::network_safe_spawn("powerup", 1, "script_model", origin);
		if(isdefined(self.powerup))
		{
			self.powerup zm_powerups::powerup_setup("full_ammo");
			self.powerup thread zm_powerups::powerup_timeout();
			self.powerup thread zm_powerups::powerup_wobble();
			self.powerup thread zm_powerups::powerup_grab();
		}
	}
	else
	{
		if(self.powerup.powerup_name == "full_ammo")
		{
			self.powerup zm_powerups::powerup_setup("fire_sale");
		}
		else
		{
			self.powerup zm_powerups::powerup_setup("full_ammo");
		}
	}
	zm_equip_hacker::deregister_hackable_struct(self);
}

