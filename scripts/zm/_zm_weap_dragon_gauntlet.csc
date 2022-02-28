// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_dragon_whelp;
#using scripts\zm\_callbacks;

#namespace zm_weap_dragon_gauntlet;

/*
	Name: __init__sytem__
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0x4388266D
	Offset: 0x4F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_dragon_gauntlet", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0x14B25167
	Offset: 0x538
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localplayer_spawned(&player_on_spawned);
}

/*
	Name: player_on_spawned
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0x79CC3A39
	Offset: 0x568
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function player_on_spawned(localclientnum)
{
	self thread watch_weapon_changes(localclientnum);
}

/*
	Name: watch_weapon_changes
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0xCEB2EBF0
	Offset: 0x598
	Size: 0x18E
	Parameters: 1
	Flags: Linked
*/
function watch_weapon_changes(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	self.dragon_gauntlet = getweapon("dragon_gauntlet_flamethrower");
	self.var_dd5c3be0 = getweapon("dragon_gauntlet");
	while(isdefined(self))
	{
		self waittill(#"weapon_change", weapon);
		if(weapon === self.dragon_gauntlet)
		{
			self thread function_7645efdb(localclientnum);
			self thread function_6c7c9327(localclientnum);
			self notify(#"hash_7c243ce8");
		}
		if(weapon === self.var_dd5c3be0)
		{
			self thread function_99aba1a5(localclientnum);
			self thread function_a8ac2d1d(localclientnum);
			self thread function_3011ccf6(localclientnum);
		}
		if(weapon !== self.dragon_gauntlet && weapon !== self.var_dd5c3be0)
		{
			self function_99aba1a5(localclientnum);
			self function_7645efdb(localclientnum);
			self notify(#"hash_7c243ce8");
		}
	}
}

/*
	Name: function_6c7c9327
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0x7052A51B
	Offset: 0x730
	Size: 0x16E
	Parameters: 1
	Flags: Linked
*/
function function_6c7c9327(localclientnum)
{
	self endon(#"disconnect");
	self util::waittill_any_timeout(0.5, "weapon_change_complete", "disconnect");
	if(getcurrentweapon(localclientnum) === getweapon("dragon_gauntlet_flamethrower"))
	{
		if(!isdefined(self.var_11d5152b))
		{
			self.var_11d5152b = [];
		}
		self.var_11d5152b[self.var_11d5152b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_orange_glow1", "tag_fx_7");
		self.var_11d5152b[self.var_11d5152b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_orange_glow2", "tag_fx_6");
		self.var_11d5152b[self.var_11d5152b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_whelp_eye_glow_sm", "tag_eye_left_fx");
		self.var_11d5152b[self.var_11d5152b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_whelp_mouth_drips_sm", "tag_throat_fx");
	}
}

/*
	Name: function_a8ac2d1d
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0x14C08406
	Offset: 0x8A8
	Size: 0x2BE
	Parameters: 1
	Flags: Linked
*/
function function_a8ac2d1d(localclientnum)
{
	self endon(#"disconnect");
	self util::waittill_any_timeout(0.5, "weapon_change_complete", "disconnect");
	if(getcurrentweapon(localclientnum) === getweapon("dragon_gauntlet"))
	{
		if(!isdefined(self.var_a7abd31))
		{
			self.var_a7abd31 = [];
		}
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow1", "tag_fx_7");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow2", "tag_fx_6");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow_finger2", "tag_fx_1");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow_finger", "tag_fx_2");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow_finger", "tag_fx_3");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow_finger", "tag_fx_4");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_tube", "tag_gauntlet_tube_01");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_tube", "tag_gauntlet_tube_02");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_tube", "tag_gauntlet_tube_03");
		self.var_a7abd31[self.var_a7abd31.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_tube", "tag_gauntlet_tube_04");
	}
}

/*
	Name: function_99aba1a5
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0x1485465F
	Offset: 0xB70
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function function_99aba1a5(localclientnum)
{
	if(isdefined(self.var_11d5152b) && self.var_11d5152b.size > 0)
	{
		foreach(fx in self.var_11d5152b)
		{
			stopfx(localclientnum, fx);
		}
	}
}

/*
	Name: function_7645efdb
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0x6CBD7E65
	Offset: 0xC30
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function function_7645efdb(localclientnum)
{
	if(isdefined(self.var_a7abd31) && self.var_a7abd31.size > 0)
	{
		foreach(fx in self.var_a7abd31)
		{
			stopfx(localclientnum, fx);
		}
	}
}

/*
	Name: function_3011ccf6
	Namespace: zm_weap_dragon_gauntlet
	Checksum: 0xBB81351A
	Offset: 0xCF0
	Size: 0x31E
	Parameters: 1
	Flags: Linked
*/
function function_3011ccf6(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"bled_out");
	self endon(#"hash_7c243ce8");
	self notify(#"hash_8d98e9db");
	self endon(#"hash_8d98e9db");
	while(isdefined(self))
	{
		self waittill(#"notetrack", note);
		if(note === "dragon_gauntlet_115_punch_fx_start")
		{
			if(!isdefined(self.var_4d73e75b))
			{
				self.var_4d73e75b = [];
			}
			self.var_4d73e75b[self.var_4d73e75b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow_finger3", "tag_fx_1");
			self.var_4d73e75b[self.var_4d73e75b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow_finger3", "tag_fx_2");
			self.var_4d73e75b[self.var_4d73e75b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow_finger3", "tag_fx_3");
			self.var_4d73e75b[self.var_4d73e75b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_glow_finger3", "tag_fx_4");
			self.var_4d73e75b[self.var_4d73e75b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_tube2", "tag_gauntlet_tube_01");
			self.var_4d73e75b[self.var_4d73e75b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_tube2", "tag_gauntlet_tube_02");
			self.var_4d73e75b[self.var_4d73e75b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_tube2", "tag_gauntlet_tube_03");
			self.var_4d73e75b[self.var_4d73e75b.size] = playviewmodelfx(localclientnum, "dlc3/stalingrad/fx_dragon_gauntlet_glove_blue_tube2", "tag_gauntlet_tube_04");
		}
		if(note === "dragon_gauntlet_115_punch_fx_stop")
		{
			if(isdefined(self.var_4d73e75b) && self.var_4d73e75b.size > 0)
			{
				foreach(fx in self.var_4d73e75b)
				{
					stopfx(localclientnum, fx);
				}
			}
		}
	}
}

