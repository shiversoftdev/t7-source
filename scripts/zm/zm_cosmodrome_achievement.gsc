// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_utility;

#namespace zm_cosmodrome_achievement;

/*
	Name: init
	Namespace: zm_cosmodrome_achievement
	Checksum: 0x4D18A7BE
	Offset: 0x140
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level thread achievement_the_eagle_has_landers();
	level thread achievement_chimp_on_the_barbie();
	level thread callback::on_connect(&onplayerconnect);
}

/*
	Name: onplayerconnect
	Namespace: zm_cosmodrome_achievement
	Checksum: 0x5747E637
	Offset: 0x1A0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self thread achievement_all_dolled_up();
	self thread achievement_black_hole();
	self thread achievement_space_race();
}

/*
	Name: achievement_the_eagle_has_landers
	Namespace: zm_cosmodrome_achievement
	Checksum: 0xC3CE49BA
	Offset: 0x1F8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function achievement_the_eagle_has_landers()
{
	level flag::wait_till_all(array("lander_a_used", "lander_b_used", "lander_c_used"));
	level zm_utility::giveachievement_wrapper("DLC2_ZOM_LUNARLANDERS", 1);
}

/*
	Name: achievement_chimp_on_the_barbie
	Namespace: zm_cosmodrome_achievement
	Checksum: 0x375410A
	Offset: 0x260
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function achievement_chimp_on_the_barbie()
{
	level endon(#"end_game");
	for(;;)
	{
		level waittill(#"trap_kill", zombie, trap);
		if(!isplayer(zombie) && "monkey_zombie" == zombie.animname && "fire" == trap._trap_type)
		{
			zm_utility::giveachievement_wrapper("DLC2_ZOM_FIREMONKEY", 1);
			return;
		}
	}
}

/*
	Name: achievement_all_dolled_up
	Namespace: zm_cosmodrome_achievement
	Checksum: 0xA715D891
	Offset: 0x310
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function achievement_all_dolled_up()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self waittill(#"nesting_doll_kills_achievement");
}

/*
	Name: achievement_black_hole
	Namespace: zm_cosmodrome_achievement
	Checksum: 0x83A49E50
	Offset: 0x340
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function achievement_black_hole()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self waittill(#"black_hole_kills_achievement");
}

/*
	Name: achievement_space_race
	Namespace: zm_cosmodrome_achievement
	Checksum: 0x47F312E7
	Offset: 0x370
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function achievement_space_race()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self waittill(#"pap_taken");
}

