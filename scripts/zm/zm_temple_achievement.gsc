// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace zm_temple_achievement;

/*
	Name: __init__sytem__
	Namespace: zm_temple_achievement
	Checksum: 0x85D44949
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_temple_achievement", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_temple_achievement
	Checksum: 0xCE12FE37
	Offset: 0x1E8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread achievement_temple_sidequest();
	callback::on_connect(&onplayerconnect);
}

/*
	Name: onplayerconnect
	Namespace: zm_temple_achievement
	Checksum: 0x29FAF7CC
	Offset: 0x230
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self thread achievement_small_consolation();
}

/*
	Name: achievement_temple_sidequest
	Namespace: zm_temple_achievement
	Checksum: 0xFAD500D5
	Offset: 0x258
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function achievement_temple_sidequest()
{
	level waittill(#"temple_sidequest_achieved");
	level thread zm::set_sidequest_completed("EOA");
	level zm_utility::giveachievement_wrapper("DLC4_ZOM_TEMPLE_SIDEQUEST", 1);
}

/*
	Name: achievement_zomb_disposal
	Namespace: zm_temple_achievement
	Checksum: 0xF7AF4F49
	Offset: 0x2B0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function achievement_zomb_disposal()
{
	level endon(#"end_game");
	level waittill(#"zomb_disposal_achieved");
}

/*
	Name: achievement_monkey_see_monkey_dont
	Namespace: zm_temple_achievement
	Checksum: 0x65B874D4
	Offset: 0x2D8
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function achievement_monkey_see_monkey_dont()
{
	level waittill(#"monkey_see_monkey_dont_achieved");
}

/*
	Name: achievement_blinded_by_the_fright
	Namespace: zm_temple_achievement
	Checksum: 0x56E8B40
	Offset: 0x2F0
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function achievement_blinded_by_the_fright()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self waittill(#"blinded_by_the_fright_achieved");
}

/*
	Name: achievement_small_consolation
	Namespace: zm_temple_achievement
	Checksum: 0x8BCD3C81
	Offset: 0x320
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function achievement_small_consolation()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"weapon_fired");
		currentweapon = self getcurrentweapon();
		if(currentweapon.name != "shrink_ray" && currentweapon.name != "shrink_ray_upgraded")
		{
			continue;
		}
		waittillframeend();
		if(isdefined(self.shrinked_zombies) && (isdefined(self.shrinked_zombies["zombie"]) && self.shrinked_zombies["zombie"]) && (isdefined(self.shrinked_zombies["sonic_zombie"]) && self.shrinked_zombies["sonic_zombie"]) && (isdefined(self.shrinked_zombies["napalm_zombie"]) && self.shrinked_zombies["napalm_zombie"]) && (isdefined(self.shrinked_zombies["monkey_zombie"]) && self.shrinked_zombies["monkey_zombie"]))
		{
			break;
		}
	}
	self zm_utility::giveachievement_wrapper("DLC4_ZOM_SMALL_CONSOLATION");
}

