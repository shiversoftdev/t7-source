// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\_weaponobjects;

#namespace globallogic;

/*
	Name: __init__sytem__
	Namespace: globallogic
	Checksum: 0x4FCD213B
	Offset: 0x358
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("globallogic", &__init__, undefined, "visionset_mgr");
}

/*
	Name: __init__
	Namespace: globallogic
	Checksum: 0xC81C8126
	Offset: 0x398
	Size: 0x248
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_visionset_info("mpintro", 1, 31, undefined, "mpintro");
	clientfield::register("world", "game_ended", 1, 1, "int", &game_ended, 1, 1);
	clientfield::register("world", "post_game", 1, 1, "int", &post_game, 1, 1);
	registerclientfield("playercorpse", "firefly_effect", 1, 2, "int", &firefly_effect_cb, 0);
	registerclientfield("playercorpse", "annihilate_effect", 1, 1, "int", &annihilate_effect_cb, 0);
	registerclientfield("playercorpse", "pineapplegun_effect", 1, 1, "int", &pineapplegun_effect_cb, 0);
	registerclientfield("actor", "annihilate_effect", 1, 1, "int", &annihilate_effect_cb, 0);
	registerclientfield("actor", "pineapplegun_effect", 1, 1, "int", &pineapplegun_effect_cb, 0);
	level._effect["annihilate_explosion"] = "weapon/fx_hero_annhilatr_death_blood";
	level._effect["pineapplegun_explosion"] = "weapon/fx_hero_pineapple_death_blood";
	level.gameended = 0;
	level.postgame = 0;
}

/*
	Name: game_ended
	Namespace: globallogic
	Checksum: 0xFF080585
	Offset: 0x5E8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function game_ended(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval && !level.gameended)
	{
		level notify(#"game_ended");
		level.gameended = 1;
	}
}

/*
	Name: post_game
	Namespace: globallogic
	Checksum: 0xC8C19E43
	Offset: 0x660
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function post_game(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval && !level.postgame)
	{
		level notify(#"post_game");
		level.postgame = 1;
	}
}

/*
	Name: firefly_effect_cb
	Namespace: globallogic
	Checksum: 0x2437ADB2
	Offset: 0x6D8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function firefly_effect_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(bnewent && newval)
	{
		self thread hive_gun::gib_corpse(localclientnum, newval);
	}
}

/*
	Name: annihilate_effect_cb
	Namespace: globallogic
	Checksum: 0xEB68FC0A
	Offset: 0x750
	Size: 0x184
	Parameters: 7
	Flags: Linked
*/
function annihilate_effect_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval && !oldval)
	{
		where = self gettagorigin("J_SpineLower");
		if(!isdefined(where))
		{
			where = self.origin;
		}
		where = where + (vectorscale((0, 0, -1), 40));
		character_index = self getcharacterbodytype();
		fields = getcharacterfields(character_index, currentsessionmode());
		if(fields.fullbodyexplosion != "")
		{
			if(util::is_mature() && !util::is_gib_restricted_build())
			{
				playfx(localclientnum, fields.fullbodyexplosion, where);
			}
			playfx(localclientnum, "explosions/fx_exp_grenade_default", where);
		}
	}
}

/*
	Name: pineapplegun_effect_cb
	Namespace: globallogic
	Checksum: 0x3BD754F3
	Offset: 0x8E0
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function pineapplegun_effect_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval && !oldval)
	{
		where = self gettagorigin("J_SpineLower");
		if(!isdefined(where))
		{
			where = self.origin;
		}
		if(isdefined(level._effect["pineapplegun_explosion"]))
		{
			playfx(localclientnum, level._effect["pineapplegun_explosion"], where);
		}
	}
}

/*
	Name: watch_plant_sound
	Namespace: globallogic
	Checksum: 0xF8BE006
	Offset: 0x9C0
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function watch_plant_sound(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"start_plant_sound");
		self thread play_plant_sound(localclientnum);
	}
}

/*
	Name: play_plant_sound
	Namespace: globallogic
	Checksum: 0xC9C8F435
	Offset: 0xA10
	Size: 0x150
	Parameters: 1
	Flags: Linked
*/
function play_plant_sound(localclientnum)
{
	self notify(#"play_plant_sound");
	self endon(#"play_plant_sound");
	self endon(#"entityshutdown");
	self endon(#"stop_plant_sound");
	player = getlocalplayer(localclientnum);
	plantweapon = getweapon("briefcase_bomb");
	defuseweapon = getweapon("briefcase_bomb_defuse");
	wait(0.25);
	while(true)
	{
		if(!isdefined(player))
		{
			return;
		}
		if(player.weapon != plantweapon && player.weapon != defuseweapon)
		{
			return;
		}
		if(player != self || isthirdperson(localclientnum))
		{
			self playsound(localclientnum, "fly_bomb_buttons_npc");
		}
		wait(0.15);
	}
}

/*
	Name: function_9350c173
	Namespace: globallogic
	Checksum: 0x56D077C2
	Offset: 0xB68
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_9350c173()
{
	util::waitforallclients();
	wait(5);
	var_57f81ff6 = getdvarint("sys_threadWatchdogTimeoutLive", 30000);
	setdvar("sys_threadWatchdogTimeout", var_57f81ff6);
}

/*
	Name: function_d00a98f6
	Namespace: globallogic
	Checksum: 0xE79C43D8
	Offset: 0xBD0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_d00a98f6()
{
	if(getdvarint("sys_threadWatchdogTimeoutLive", 0) > 0)
	{
		level thread function_9350c173();
	}
}

