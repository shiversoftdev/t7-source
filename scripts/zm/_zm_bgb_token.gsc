// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;

#namespace bgb_token;

/*
	Name: __init__sytem__
	Namespace: bgb_token
	Checksum: 0xE9DC99BF
	Offset: 0x200
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("bgb_token", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: bgb_token
	Checksum: 0x52543F79
	Offset: 0x248
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
private function __init__()
{
	if(!function_4922937f())
	{
		return;
	}
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: __main__
	Namespace: bgb_token
	Checksum: 0xC773B658
	Offset: 0x290
	Size: 0xFC
	Parameters: 0
	Flags: Linked, Private
*/
private function __main__()
{
	if(!function_4922937f())
	{
		return;
	}
	if(!isdefined(level.var_a73c4888))
	{
		level.var_a73c4888 = -1;
	}
	if(!isdefined(level.var_baa8fd09))
	{
		level.var_baa8fd09 = 3600;
	}
	if(!isdefined(level.var_342aa5b2))
	{
		level.var_342aa5b2 = 0.33;
	}
	if(!isdefined(level.var_4d1d42c7))
	{
		level.var_4d1d42c7 = 5;
	}
	if(!isdefined(level.var_5f0752c5))
	{
		level.var_5f0752c5 = 1000;
	}
	if(!isdefined(level.var_af87760a))
	{
		level.var_af87760a = 0.33;
	}
	if(!isdefined(level.var_bc978de9))
	{
		level.var_bc978de9 = 8;
	}
	if(!isdefined(level.var_c50e9bdb))
	{
		level.var_c50e9bdb = 9;
	}
	/#
		level thread setup_devgui();
	#/
}

/*
	Name: on_player_spawned
	Namespace: bgb_token
	Checksum: 0xC86CD741
	Offset: 0x398
	Size: 0x60
	Parameters: 0
	Flags: Linked, Private
*/
private function on_player_spawned()
{
	if(!isdefined(self.bgb_token_last_given_time))
	{
		self.bgb_token_last_given_time = self zm_stats::get_global_stat("BGB_TOKEN_LAST_GIVEN_TIME");
		self.bgb_tokens_gained_this_game = 0;
		self.var_bc978de9 = level.var_bc978de9 + level.round_number - 1;
	}
}

/*
	Name: function_4922937f
	Namespace: bgb_token
	Checksum: 0xDED9743F
	Offset: 0x400
	Size: 0x66
	Parameters: 0
	Flags: Linked, Private
*/
private function function_4922937f()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use) || !level.onlinegame || !getdvarint("loot_enabled"))
	{
		return 0;
	}
	if(isusingmods())
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_c2f81136
	Namespace: bgb_token
	Checksum: 0xE77678E5
	Offset: 0x470
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function function_c2f81136(increment)
{
	if(!function_4922937f())
	{
		return;
	}
	foreach(var_79b6628f, player in level.players)
	{
		if(isdefined(player.var_bc978de9))
		{
			player.var_bc978de9 = player.var_bc978de9 + increment;
		}
	}
}

/*
	Name: setup_devgui
	Namespace: bgb_token
	Checksum: 0x519B1518
	Offset: 0x540
	Size: 0x8C
	Parameters: 0
	Flags: Linked, Private
*/
private function setup_devgui()
{
	/#
		waittillframeend();
		setdvar("", "");
		bgb_devgui_base = "";
		adddebugcommand(bgb_devgui_base + "" + "" + "");
		level thread function_a29384f8();
	#/
}

/*
	Name: function_a29384f8
	Namespace: bgb_token
	Checksum: 0xD305B917
	Offset: 0x5D8
	Size: 0x88
	Parameters: 0
	Flags: Linked, Private
*/
private function function_a29384f8()
{
	/#
		for(;;)
		{
			var_2e29895e = getdvarstring("");
			if(var_2e29895e != "")
			{
				level.players[0] function_32692a60();
			}
			setdvar("", "");
			wait(0.5);
		}
	#/
}

/*
	Name: function_32692a60
	Namespace: bgb_token
	Checksum: 0xA9E07ABA
	Offset: 0x668
	Size: 0x12C
	Parameters: 0
	Flags: Linked, Private
*/
private function function_32692a60()
{
	var_90491adb = int(self getvialsscale());
	for(count = 0; count < var_90491adb; count++)
	{
		self incrementbgbtokensgained();
	}
	self.bgb_tokens_gained_this_game = self.bgb_tokens_gained_this_game + var_90491adb;
	self.var_bc978de9 = self.var_bc978de9 + level.var_c50e9bdb;
	self.bgb_token_last_given_time = self zm_stats::get_global_stat("TIME_PLAYED_TOTAL");
	self zm_stats::set_global_stat("BGB_TOKEN_LAST_GIVEN_TIME", self.bgb_token_last_given_time);
	uploadstats(self);
	self reportlootreward("3", var_90491adb);
}

/*
	Name: function_2d75b98d
	Namespace: bgb_token
	Checksum: 0xFB292A0
	Offset: 0x7A0
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
private function function_2d75b98d(var_ce9d31c4)
{
	if(randomfloat(1) < var_ce9d31c4)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_51cf4361
	Namespace: bgb_token
	Checksum: 0x9FEF18D2
	Offset: 0x7E0
	Size: 0x1EC
	Parameters: 1
	Flags: Linked
*/
function function_51cf4361(var_5561679e)
{
	if(!function_4922937f())
	{
		return;
	}
	if(0 <= level.var_a73c4888 && self.bgb_tokens_gained_this_game >= level.var_a73c4888)
	{
		return;
	}
	time_played_total = self zm_stats::get_global_stat("TIME_PLAYED_TOTAL");
	if(time_played_total - level.var_baa8fd09 > self.bgb_token_last_given_time)
	{
		if(function_2d75b98d(level.var_342aa5b2))
		{
			self function_32692a60();
		}
		return;
	}
	if(level.round_number < level.var_4d1d42c7)
	{
		return;
	}
	var_95d14cf5 = math::clamp(var_5561679e, 0, level.var_5f0752c5);
	var_741485e6 = float(var_95d14cf5) / level.var_5f0752c5;
	if(!function_2d75b98d(var_741485e6 * level.var_af87760a))
	{
		return;
	}
	var_edfe0eb4 = self.var_bc978de9 - level.round_number;
	if(1 > var_edfe0eb4)
	{
		var_edfe0eb4 = 1;
	}
	var_b8a1486b = float(var_edfe0eb4 * var_edfe0eb4);
	if(!function_2d75b98d(1 / var_b8a1486b))
	{
		return;
	}
	self function_32692a60();
}

