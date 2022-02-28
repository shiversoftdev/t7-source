// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\doa\_doa_camera;
#using scripts\cp\doa\_doa_core;
#using scripts\cp\doa\_doa_fx;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace doa_pickups;

/*
	Name: init
	Namespace: doa_pickups
	Checksum: 0x305CC5BF
	Offset: 0x6D0
	Size: 0x9AC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "pickuptype", 1, 10, "int", &function_892b2a87, 0, 0);
	clientfield::register("scriptmover", "pickupwobble", 1, 1, "int", &function_77c1258e, 0, 0);
	clientfield::register("scriptmover", "pickuprotate", 1, 1, "int", &pickuprotate, 0, 0);
	clientfield::register("scriptmover", "pickupscale", 1, 8, "int", &function_b3289e6d, 0, 0);
	clientfield::register("scriptmover", "pickupvisibility", 1, 1, "int", &function_68ad0d79, 0, 0);
	clientfield::register("scriptmover", "pickupmoveto", 1, 4, "int", &function_474724d7, 0, 0);
	level.doa.pickups = [];
	function_db1442f2("zombietron_silver_coin", 1.25, 1, 0);
	function_db1442f2("zombietron_silver_brick", 1.25, 1, 1);
	function_db1442f2("zombietron_silver_bricks", 1.5, 1, 2);
	function_db1442f2("zombietron_gold_coin", 1.25, 1, 3);
	function_db1442f2("zombietron_gold_brick", 1.5, 1, 4);
	function_db1442f2("zombietron_gold_bricks", 1.5, 1, 5);
	function_db1442f2("zombietron_money_icon", 1.5, 1, 6);
	function_db1442f2("zombietron_ruby", 1, 1, 7);
	function_db1442f2("zombietron_sapphire", 1, 1, 8);
	function_db1442f2("zombietron_diamond", 1, 1, 9);
	function_db1442f2("zombietron_emerald", 1, 1, 10);
	function_db1442f2("zombietron_beryl", 1, 1, 11);
	function_db1442f2("p7_doa_powerup_skull", 1, 1, 12);
	function_db1442f2("wpn_t7_mingun_world", 2.1, 16, 0);
	function_db1442f2("wpn_t7_shotgun_spartan_world", 3, 16, 1);
	function_db1442f2("wpn_t7_hero_mgl_world", 2.4, 16, 2);
	function_db1442f2("wpn_t7_launch_blackcell_world", 2.4, 16, 3);
	function_db1442f2("wpn_t7_zombietron_raygun_world", 3.5, 16, 4);
	function_db1442f2("wpn_t7_hero_flamethrower_world", 2, 16, 5);
	function_db1442f2("zombietron_ammobox", 2, 2);
	function_db1442f2("zombietron_chicken", 1, 5);
	function_db1442f2("veh_t7_turret_sentry_gun_world", 0.75, 3);
	function_db1442f2("zombietron_barrel", 1, 7);
	function_db1442f2("zombietron_sawblade", 2, 19);
	function_db1442f2("zombietron_umbrella", 0.5, 17);
	function_db1442f2("zombietron_electric_ball", 1.5, 6);
	function_db1442f2("zombietron_boots", 2, 4);
	function_db1442f2("zombietron_lightning_bolt", 1.5, 10);
	function_db1442f2("veh_t7_drone_raps_zombietron", 1, 25);
	function_db1442f2("zombietron_nuke", 0.8, 12);
	function_db1442f2("zombietron_sprinkler", 5.5, 20);
	function_db1442f2("zombietron_monkey_bomb", 1, 11);
	function_db1442f2("zombietron_magnet", 3, 21);
	function_db1442f2("zombietron_teddy_bear", 1.6, 13);
	function_db1442f2("veh_t7_mil_tank_tiger_zombietron", 1, 33);
	function_db1442f2("zombietron_boxing_gloves_rt", 1, 34);
	function_db1442f2("zombietron_egg", 1, 23);
	function_db1442f2("zombietron_wallclock", 1, 14);
	function_db1442f2("zombietron_grenade_turret", 1, 18);
	function_db1442f2("zombietron_bones_skeleton", 1.4, 30);
	function_db1442f2("veh_t7_drone_amws_armored_mp_lite", 1, 22);
	function_db1442f2("zombietron_vortex", 0.5, 29);
	function_db1442f2("zombietron_heart", 1, 26);
	function_db1442f2("zombietron_siegebot_mini", 0.7, 24);
	function_db1442f2("zombietron_chicken_fido", 1, 38);
	function_db1442f2("c_54i_robot_3", 1, 31);
	function_db1442f2("veh_t7_drone_hunter_zombietron", 1, 9);
	function_db1442f2("zombietron_extra_life", 1, 8);
	function_db1442f2("zombietron_eggxl", 1, 27);
	function_db1442f2("p7_doa_powerup_skull", 1, 32);
	function_db1442f2("p7_bonuscard_perk_3_greed", 3, 35);
	function_db1442f2("zombietron_goldegg", 1, 36);
	function_db1442f2("p7_zm_ctl_dg_coat_horn", 3, 37);
}

/*
	Name: function_f7726690
	Namespace: doa_pickups
	Checksum: 0x5EAF18E6
	Offset: 0x1088
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_f7726690(parent)
{
	parent endon(#"entityshutdown");
	parent endon(#"hash_4c187db8");
	self endon(#"entityshutdown");
	while(true)
	{
		self.origin = parent.origin;
		wait(0.016);
	}
}

/*
	Name: function_6cb8e053
	Namespace: doa_pickups
	Checksum: 0x9862C844
	Offset: 0x10E8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_6cb8e053()
{
	self endon(#"hash_cfadee1b");
	self waittill(#"entityshutdown");
	if(isdefined(self.fakemodel))
	{
		self.fakemodel delete();
	}
}

/*
	Name: function_ee036ce4
	Namespace: doa_pickups
	Checksum: 0x204ED40F
	Offset: 0x1138
	Size: 0x158
	Parameters: 0
	Flags: Linked
*/
function function_ee036ce4()
{
	self notify(#"hash_b14b3cac");
	self endon(#"hash_b14b3cac");
	self endon(#"entityshutdown");
	while(isdefined(self))
	{
		waittime = randomfloatrange(2.5, 5);
		yaw = randomint(360);
		if(yaw > 300)
		{
			yaw = 300;
		}
		else if(yaw < 60)
		{
			yaw = 60;
		}
		yaw = self.angles[1] + yaw;
		self rotateto((-20 + randomint(40), yaw, -90 + randomint(180)), waittime, waittime * 0.5, waittime * 0.5);
		wait(randomfloat(waittime - 0.1));
	}
}

/*
	Name: function_77c1258e
	Namespace: doa_pickups
	Checksum: 0x2DDEFC28
	Offset: 0x1298
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_77c1258e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.fakemodel))
	{
		return;
	}
	if(newval)
	{
		self.fakemodel thread function_ee036ce4();
	}
	else
	{
		self.fakemodel notify(#"hash_b14b3cac");
		self.fakemodel.angles = self.angles;
	}
}

/*
	Name: function_6093755a
	Namespace: doa_pickups
	Checksum: 0x63C99D7B
	Offset: 0x1340
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function function_6093755a()
{
	self notify(#"hash_398ca74c");
	self endon(#"hash_398ca74c");
	self endon(#"entityshutdown");
	dir = 180;
	if(randomint(100) > 50)
	{
		dir = -180;
	}
	time = randomfloatrange(3, 7);
	while(isdefined(self))
	{
		self rotateto(self.angles + (0, dir, 0), time);
		wait(time);
	}
}

/*
	Name: pickuprotate
	Namespace: doa_pickups
	Checksum: 0x79653532
	Offset: 0x1418
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function pickuprotate(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.fakemodel))
	{
		return;
	}
	if(newval)
	{
		self.fakemodel thread function_6093755a();
	}
	else
	{
		self.fakemodel notify(#"hash_398ca74c");
		self.fakemodel.angles = self.angles;
	}
}

/*
	Name: function_68ad0d79
	Namespace: doa_pickups
	Checksum: 0x6DFB3349
	Offset: 0x14C0
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function function_68ad0d79(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.fakemodel))
	{
		return;
	}
	if(newval == 0)
	{
		self.fakemodel show();
	}
	else if(newval == 1)
	{
		self.fakemodel hide();
	}
}

/*
	Name: function_b3289e6d
	Namespace: doa_pickups
	Checksum: 0xFC6CFE4D
	Offset: 0x1560
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function function_b3289e6d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.fakemodel))
	{
		return;
	}
	scale = (newval / (256 - 1)) * 16;
	if(scale < 0.5)
	{
		scale = 0.5;
	}
	self.fakemodel setscale(scale);
}

/*
	Name: function_6b4a5f81
	Namespace: doa_pickups
	Checksum: 0xC9916FB5
	Offset: 0x1618
	Size: 0x1BC
	Parameters: 1
	Flags: Linked
*/
function function_6b4a5f81(player)
{
	self endon(#"entityshutdown");
	self show();
	if(isdefined(player))
	{
		x = 2000;
		y = 3000;
		z = 1000;
		if(level.doa.flipped)
		{
			x = 0 - x;
			y = 0 - y;
		}
		end_pt = player.origin;
		entnum = player getentitynumber();
		if(entnum == 1)
		{
			y = 0 - y;
		}
		else
		{
			if(entnum == 2)
			{
				x = 0 - x;
			}
			else if(entnum == 3)
			{
				y = 0 - y;
				x = 0 - x;
			}
		}
		end_pt = end_pt + (x, y, z);
	}
	else
	{
		end_pt = self.origin + vectorscale((0, 0, 1), 3000);
	}
	wait(0.016);
	self moveto(end_pt, 2, 0, 0);
	wait(2);
	self delete();
}

/*
	Name: function_474724d7
	Namespace: doa_pickups
	Checksum: 0x510D64DF
	Offset: 0x17E0
	Size: 0x19C
	Parameters: 7
	Flags: Linked
*/
function function_474724d7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.fakemodel))
	{
		return;
	}
	self notify(#"hash_4c187db8");
	self notify(#"hash_cfadee1b");
	self notify(#"hash_398ca74c");
	self notify(#"hash_b14b3cac");
	player = undefined;
	newval = newval - 1;
	if(newval > 0)
	{
		entnum = (newval >> 1) - 1;
		players = getplayers(localclientnum);
		foreach(guy in players)
		{
			if(guy getentitynumber() == entnum)
			{
				player = guy;
				break;
			}
		}
	}
	self.fakemodel thread function_6b4a5f81(player);
}

/*
	Name: function_892b2a87
	Namespace: doa_pickups
	Checksum: 0x46A7359B
	Offset: 0x1988
	Size: 0x234
	Parameters: 7
	Flags: Linked
*/
function function_892b2a87(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_869acbe6) && level.doa.arenas[level.doa.current_arena].var_869acbe6 && localclientnum > 0)
	{
		return;
	}
	type = newval & (64 - 1);
	variant = undefined;
	if(newval > 38)
	{
		variant = newval >> 6;
		/#
			assert(type == 1 || type == 16);
		#/
	}
	def = function_bac08508(type, variant);
	if(!isdefined(def))
	{
		return;
	}
	self.fakemodel = spawn(localclientnum, self.origin, "script_model");
	self.fakemodel setmodel(def.modelname);
	self.fakemodel.angles = self.angles;
	self.fakemodel setscale(def.scale);
	self.fakemodel notsolid();
	self thread function_6cb8e053();
	self.fakemodel thread function_f7726690(self);
}

/*
	Name: function_bac08508
	Namespace: doa_pickups
	Checksum: 0xD3712911
	Offset: 0x1BC8
	Size: 0xD0
	Parameters: 2
	Flags: Linked
*/
function function_bac08508(type, variant)
{
	foreach(pickup in level.doa.pickups)
	{
		if(pickup.type == type)
		{
			if(!isdefined(variant))
			{
				return pickup;
			}
			if(variant === pickup.variant)
			{
				return pickup;
			}
		}
	}
}

/*
	Name: function_db1442f2
	Namespace: doa_pickups
	Checksum: 0x52FF6B45
	Offset: 0x1CA0
	Size: 0xB6
	Parameters: 4
	Flags: Linked
*/
function function_db1442f2(modelname, modelscale, type, variant)
{
	pickup = spawnstruct();
	pickup.modelname = modelname;
	pickup.scale = modelscale;
	pickup.type = type;
	pickup.variant = variant;
	level.doa.pickups[level.doa.pickups.size] = pickup;
}

