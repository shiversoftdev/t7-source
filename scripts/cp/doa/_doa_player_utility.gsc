// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_core;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_fate;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_gibs;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_round;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_shield_pickup;
#using scripts\cp\doa\_doa_tesla_pickup;
#using scripts\cp\doa\_doa_turret_pickup;
#using scripts\cp\doa\_doa_utility;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace namespace_831a4a7c;

/*
	Name: function_138c35de
	Namespace: namespace_831a4a7c
	Checksum: 0xC5D8942
	Offset: 0xB38
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_138c35de()
{
	self show();
	if(!isdefined(self.entnum))
	{
		self.entnum = self getentitynumber();
	}
	/#
		assert(!isdefined(self.doa), "");
	#/
	level flagsys::wait_till("doa_init_complete");
	self setthreatbiasgroup("players");
	self setcharacterbodytype(self.entnum, self.entnum);
	self setcharacterbodystyle(0);
	self setcharacterhelmetstyle(0);
	self.doa = spawnstruct();
	self enablelinkto();
	self thread turnplayershieldon(0);
	self thread function_bbb1254c(1);
	if(isdefined(level.doa) && isdefined(level.doa.var_bc9b7c71))
	{
		self thread [[level.doa.var_bc9b7c71]]();
	}
	self thread function_7d7a7fde();
	self function_60123d1c();
	self thread function_70339630();
}

/*
	Name: function_70339630
	Namespace: namespace_831a4a7c
	Checksum: 0xC4432F8E
	Offset: 0xD28
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_70339630()
{
	self endon(#"disconnect");
	while(array::contains(level.activeplayers, self) == 0)
	{
		self.ignoreme = 1;
		wait(0.05);
	}
	self.ignoreme = 0;
}

/*
	Name: function_bbb1254c
	Namespace: namespace_831a4a7c
	Checksum: 0xF8203008
	Offset: 0xD88
	Size: 0x95C
	Parameters: 1
	Flags: Linked
*/
function function_bbb1254c(var_44eb97b0 = 0)
{
	if(!isdefined(self))
	{
		return;
	}
	self.doa.multiplier = 1;
	self.doa.var_d55e6679 = 0;
	self.doa.var_5d2140f2 = level.doa.rules.var_a9114441;
	self.doa.var_a3f61a60 = isdefined(self.doa.var_65f7f2a9) && (self.doa.var_65f7f2a9 ? 4 : 0);
	self.doa.default_movespeed = 1;
	self.doa.var_f89dbefa = 0;
	self.doa.var_91c268dc = 0;
	self.doa.weaponlevel = 0;
	self.doa.var_c2b9d7d0 = 0;
	if(!(isdefined(self.doa.var_65f7f2a9) && self.doa.var_65f7f2a9))
	{
		self.topdowncamera = 1;
	}
	self.ignoreme = 0;
	self.doa.respawning = 0;
	self.doa.var_b08ad9f8 = [];
	self thread namespace_eaa992c::turnofffx("reviveAdvertise");
	self thread namespace_eaa992c::turnofffx("reviveActive");
	self thread namespace_eaa992c::turnofffx("down_marker_" + function_ee495f41(self.entnum));
	self thread namespace_eaa992c::turnofffx("stunbear");
	self thread namespace_eaa992c::turnofffx("stunbear_fade");
	self thread namespace_eaa992c::turnofffx("slow_feet");
	self thread namespace_eaa992c::turnofffx("web_contact");
	if(var_44eb97b0)
	{
		self.headshots = 0;
		self.downs = 0;
		self.revives = 0;
		self.score = 0;
		self.assists = 0;
		self.kills = 0;
		self.deaths = 0;
		self.chickens = 0;
		self.gems = 0;
		self.skulls = 0;
		self.doa.var_e1956fd2 = 0;
		self.doa.score = 0;
		self.doa.var_db3637c0 = 0;
		self.doa.kills = 0;
		self.doa.var_74c73153 = 0;
		self.doa.var_d92a8d3e = 0;
		self.doa.var_ec573900 = 0;
		self.doa.var_130471f = 0;
		self.doa.var_53bd6cfa = 0;
		self.doa.skulls = 0;
		self.doa.gems = 0;
		self.doa.var_52e89a72 = 0;
		self.doa.var_fda5a6e5 = 0;
		self.doa.var_6946711f = 0;
		self.doa.var_67cd9d65 = 0;
		self.doa.var_bfe4f859 = 0;
		self.doa.var_faf30682 = 0;
		self.doa.fate = 0;
		self.doa.bombs = level.doa.rules.var_812a15ac;
		self.doa.boosters = level.doa.rules.var_ec21c11e;
		self.doa.lives = level.doa.rules.var_1a69346e;
		self.doa.default_weap = getweapon(level.doa.rules.default_weapon);
		self.doa.var_295df6ca = level.doa.rules.var_61b88ecb;
		self.doa.var_9742391e = 1;
		self.doa.var_c5fe2763 = undefined;
		self.doa.var_80ffe475 = undefined;
		self.doa.var_af875fb7 = [];
		self notify(#"hash_44eb97b0");
		wait(0.05);
		if(isdefined(self.doa.var_3cdd8203))
		{
			foreach(var_157bd6b7, chicken in self.doa.var_3cdd8203)
			{
				if(isdefined(chicken.bird))
				{
					chicken.bird delete();
				}
				chicken delete();
			}
			self.doa.var_3cdd8203 = [];
		}
		self thread function_e2a1a825();
	}
	if(self.doa.fate == 4 || self.doa.fate == 13 || (isdefined(self.doa.var_480b6280) && self.doa.var_480b6280))
	{
		self.doa.default_movespeed = level.doa.rules.var_b92b82b;
	}
	self.doa.var_7c1bcaf3 = 0;
	if(self.doa.fate == 2)
	{
		self.doa.var_7c1bcaf3 = 1;
	}
	else if(self.doa.fate == 11)
	{
		self.doa.var_7c1bcaf3 = 2;
	}
	self setmovespeedscale(self.doa.default_movespeed);
	self function_aea40863();
	self thread function_4eabae51();
	self thread function_ab0e2cf3();
	self thread function_73d40751();
	self thread function_f19e9b07();
	self thread infiniteammo();
	self thread function_60123d1c();
	self thread function_7d7a7fde();
	self thread function_d7c57981();
	self thread function_e6b2517f();
	self thread function_a36ffe73();
	self thread function_2fee362e();
	/#
	#/
	self setplayercollision(1);
	self cleardamageindicator();
	self.health = self.maxhealth;
	self.ignoreme = 0;
	if(isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback destroy();
		self.hud_damagefeedback = undefined;
	}
	self namespace_64c6b720::function_850bb47e();
}

/*
	Name: function_e2a1a825
	Namespace: namespace_831a4a7c
	Checksum: 0x4C039E2C
	Offset: 0x16F0
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function function_e2a1a825()
{
	self notify(#"hash_e2a1a825");
	self endon(#"hash_e2a1a825");
	self endon(#"disconnect");
	self.doa.var_a483af0a = 0;
	self.doa.var_b55a8647 = 0;
	while(true)
	{
		self util::waittill_any("doa_round_is_over", "bossEventComplete", "playerLeaderboardUploader", "disconnect");
		if(level.doa.round_number >= getdvarint("scr_doa_min_level_stat_upload", 45))
		{
			self thread namespace_693feb87::function_780f83fd(level.doa.round_number);
		}
	}
}

/*
	Name: function_eb67e3d2
	Namespace: namespace_831a4a7c
	Checksum: 0xF5B0DCB
	Offset: 0x17D8
	Size: 0x38C
	Parameters: 0
	Flags: None
*/
function function_eb67e3d2()
{
	while(true)
	{
		if(self stancebuttonpressed())
		{
			stance = 1;
		}
		if(self fragbuttonpressed())
		{
			frag = 1;
		}
		if(self reloadbuttonpressed())
		{
			reload = 1;
		}
		if(self secondaryoffhandbuttonpressed())
		{
			var_6275e96c = 1;
		}
		if(self inventorybuttonpressed())
		{
			inventory = 1;
		}
		if(self offhandspecialbuttonpressed())
		{
			var_41f5c788 = 1;
		}
		if(self weaponswitchbuttonpressed())
		{
			var_ad9943fa = 1;
		}
		if(self vehiclemoveupbuttonpressed())
		{
			var_affc5722 = 1;
		}
		if(self actionbuttonpressed())
		{
			action = 1;
		}
		if(self jumpbuttonpressed())
		{
			jump = 1;
		}
		if(self sprintbuttonpressed())
		{
			sprint = 1;
		}
		if(self meleebuttonpressed())
		{
			melee = 1;
		}
		if(self throwbuttonpressed())
		{
			throw = 1;
		}
		if(self adsbuttonpressed())
		{
			ads = 1;
		}
		if(self actionslotfourbuttonpressed())
		{
			action4 = 1;
		}
		if(self actionslotthreebuttonpressed())
		{
			action3 = 1;
		}
		if(self actionslottwobuttonpressed())
		{
			action2 = 1;
		}
		if(self actionslotonebuttonpressed())
		{
			action1 = 1;
		}
		if(self attackbuttonpressed())
		{
			attack = 1;
		}
		if(self boostbuttonpressed())
		{
			boost = 1;
		}
		if(self changeseatbuttonpressed())
		{
			changeseat = 1;
		}
		if(self usebuttonpressed())
		{
			use = 1;
		}
		wait(0.05);
	}
}

/*
	Name: function_7e372abd
	Namespace: namespace_831a4a7c
	Checksum: 0xAC509ADB
	Offset: 0x1B70
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_7e372abd()
{
	self endon(#"disconnect");
	while(!isdefined(self.doa))
	{
		wait(0.05);
	}
	if(isdefined(level.doa.var_e6653624))
	{
		if(!isinarray(level.doa.var_e6653624, self.name))
		{
			level.doa.var_e6653624[level.doa.var_e6653624.size] = self.name;
			level.doa.var_a9ba4ffb[self.name] = gettime();
		}
	}
	self function_ad1d5fcb(1);
}

/*
	Name: function_4db260cb
	Namespace: namespace_831a4a7c
	Checksum: 0x490B4967
	Offset: 0x1C40
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_4db260cb()
{
	foreach(var_d2d81682, player in getplayers())
	{
		player thread function_7e372abd();
	}
}

/*
	Name: function_895845f9
	Namespace: namespace_831a4a7c
	Checksum: 0x1E77CC42
	Offset: 0x1CE0
	Size: 0x136
	Parameters: 2
	Flags: None
*/
function function_895845f9(origin, ignore_player)
{
	valid_player_found = 0;
	players = getplayers();
	if(isdefined(ignore_player))
	{
		for(i = 0; i < ignore_player.size; i++)
		{
			if(isdefined(ignore_player[i]))
			{
				players = arrayremovevalue(players, ignore_player[i]);
			}
		}
	}
	if(!valid_player_found)
	{
		for(;;)
		{
			player = doa_utility::getclosestto(origin, players);
			return undefined;
			players = arrayremovevalue(players, player);
		}
		if(!isdefined(player))
		{
		}
		if(!isplayervalid(player, 1))
		{
		}
		return player;
	}
}

/*
	Name: isplayervalid
	Namespace: namespace_831a4a7c
	Checksum: 0xFA70A96C
	Offset: 0x1E20
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function isplayervalid(player, checkignoremeflag)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(!isalive(player))
	{
		return 0;
	}
	if(!isplayer(player))
	{
		return 0;
	}
	if(player.sessionstate == "spectator")
	{
		return 0;
	}
	if(player.sessionstate == "intermission")
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_5bcae97c
	Namespace: namespace_831a4a7c
	Checksum: 0x977768B5
	Offset: 0x1ED0
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_5bcae97c(trigger)
{
	trigger thread doa_utility::function_a625b5d3(self);
	trigger thread doa_utility::function_75e76155(self, "enter_vehicle");
	trigger thread doa_utility::function_75e76155(self, "turnPlayerShieldOn");
	trigger thread doa_utility::function_75e76155(self, "turnPlayerShieldOff");
	trigger waittill(#"death");
	if(isdefined(self))
	{
		self function_4519b17(0);
		self.doa.shield_is_on = undefined;
		self thread namespace_eaa992c::turnofffx("player_shield_short");
		self thread namespace_eaa992c::turnofffx("player_shield_long");
	}
}

/*
	Name: turnplayershieldon
	Namespace: namespace_831a4a7c
	Checksum: 0x2330A284
	Offset: 0x1FD8
	Size: 0x2E2
	Parameters: 1
	Flags: Linked
*/
function turnplayershieldon(short_shield = 1)
{
	if(!isplayer(self))
	{
		return;
	}
	self endon(#"disconnect");
	self endon(#"enter_vehicle");
	self notify(#"turnplayershieldon");
	self endon(#"turnplayershieldon");
	if(!isdefined(self.doa) || isdefined(self.doa.vehicle))
	{
		return;
	}
	if(isdefined(self.doa.shield_is_on))
	{
		self notify(#"turnplayershieldoff");
		waittillframeend();
	}
	else if(short_shield)
	{
		self thread namespace_1a381543::function_90118d8c("zmb_player_shield_half");
	}
	else if(mayspawnentity())
	{
		self playsound("zmb_player_shield_full");
	}
	self function_4519b17(1);
	if(mayspawnfakeentity())
	{
		trigger = spawn("trigger_radius", self.origin, 17, 50, 50);
		trigger.targetname = "turnPlayerShieldOn";
		self.doa.shield_is_on = trigger;
		trigger enablelinkto();
		trigger linkto(self);
		trigger thread shield_trigger_think(self);
		self thread function_5bcae97c(trigger);
		trigger thread doa_utility::function_1bd67aef(9.85);
		util::wait_network_frame();
	}
	if(short_shield)
	{
		self thread namespace_eaa992c::function_285a2999("player_shield_short");
	}
	else
	{
		self thread namespace_eaa992c::function_285a2999("player_shield_long");
		wait(6);
	}
	self thread namespace_1a381543::function_90118d8c("zmb_player_shield_half");
	wait(3);
	self thread namespace_1a381543::function_90118d8c("zmb_player_shield_end");
	wait(0.5);
	self function_4519b17(0);
	self notify(#"turnplayershieldoff");
}

/*
	Name: function_6b0da7ff
	Namespace: namespace_831a4a7c
	Checksum: 0x88F5327A
	Offset: 0x22C8
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
private function function_6b0da7ff()
{
	self endon(#"death");
	while(true)
	{
		wait(0.05);
	}
}

/*
	Name: shield_trigger_think
	Namespace: namespace_831a4a7c
	Checksum: 0xFF7D0680
	Offset: 0x22F8
	Size: 0x4AC
	Parameters: 3
	Flags: Linked
*/
function shield_trigger_think(player, var_c1ff53d9, thresh)
{
	self endon(#"death");
	self thread function_6b0da7ff();
	self thread function_ab9cf24b(player);
	self.player = player;
	while(isdefined(player))
	{
		self waittill(#"trigger", guy);
		if(!isdefined(guy))
		{
			continue;
		}
		if(isplayer(guy))
		{
			continue;
		}
		if(isdefined(guy.launched))
		{
			continue;
		}
		if(!issentient(guy))
		{
			continue;
		}
		if(!(isdefined(guy.takedamage) && guy.takedamage))
		{
			continue;
		}
		if(isdefined(guy.boss) && guy.boss)
		{
			continue;
		}
		if(guy.team == player.team)
		{
			continue;
		}
		ok = 1;
		if(isdefined(var_c1ff53d9))
		{
			v_velocity = var_c1ff53d9 getvelocity();
			speed = lengthsquared(v_velocity);
			/#
			#/
			ok = speed < thresh * thresh;
		}
		if(!ok)
		{
			continue;
		}
		guy setplayercollision(0);
		if(!isvehicle(guy))
		{
			if(!(isdefined(guy.no_ragdoll) && guy.no_ragdoll))
			{
				guy.launched = 1;
				if(randomint(100) < getdvarint("scr_doa_ragdoll_toss_up_chance", 25))
				{
					velocity = function_93739933(player getvelocity());
					if(velocity > 30 && (!(isdefined(guy.var_ad61c13d) && guy.var_ad61c13d)))
					{
						guy clientfield::set("zombie_rhino_explosion", 1);
						namespace_fba031c8::trygibbinglimb(guy, 5000);
						namespace_fba031c8::trygibbinglegs(guy, 5000, undefined, 1, player);
					}
					/#
						assert(!(isdefined(guy.boss) && guy.boss));
					#/
					guy thread doa_utility::function_e3c30240(vectorscale((0, 0, 1), 220), 100, 0.3);
					guy thread doa_utility::function_ba30b321(0.2, player);
					guy thread namespace_1a381543::function_90118d8c("zmb_ragdoll_launched");
				}
				else
				{
					guy dodamage(guy.health, player.origin, player, player, "none", "MOD_EXPLOSIVE");
				}
			}
			else
			{
				guy dodamage(guy.health, player.origin, player, player, "none", "MOD_EXPLOSIVE");
			}
		}
		else
		{
			guy thread doa_utility::function_ba30b321(0, player);
		}
	}
	self delete();
}

/*
	Name: function_93739933
	Namespace: namespace_831a4a7c
	Checksum: 0x601F5C8D
	Offset: 0x27B0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_93739933(vel)
{
	return length(vel) * 0.05681818;
}

/*
	Name: function_ab9cf24b
	Namespace: namespace_831a4a7c
	Checksum: 0xD1405DE7
	Offset: 0x27E8
	Size: 0x11C
	Parameters: 1
	Flags: Linked, Private
*/
private function function_ab9cf24b(player)
{
	self endon(#"death");
	if(!isdefined(level.doa) || !isdefined(level.doa.hazards))
	{
		return;
	}
	while(true)
	{
		foreach(var_456bae16, hazard in level.doa.hazards)
		{
			if(isdefined(hazard) && self istouching(hazard) && isdefined(hazard.death_func))
			{
				hazard thread [[hazard.death_func]]();
			}
		}
		wait(0.1);
	}
}

/*
	Name: infiniteammo
	Namespace: namespace_831a4a7c
	Checksum: 0xA95D81A0
	Offset: 0x2910
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function infiniteammo()
{
	self notify(#"hash_93c32bc6");
	self endon(#"hash_93c32bc6");
	self endon(#"disconnect");
	wait(1);
	while(true)
	{
		wait(2);
		weaponslist = self getweaponslistprimaries();
		for(idx = 0; idx < weaponslist.size; idx++)
		{
			self setweaponammoclip(weaponslist[idx], 666);
		}
	}
}

/*
	Name: function_1a86a494
	Namespace: namespace_831a4a7c
	Checksum: 0xF81F5B8
	Offset: 0x29D0
	Size: 0x1B0
	Parameters: 1
	Flags: Linked
*/
function function_1a86a494(var_d55fe723 = 0)
{
	/#
		assert(isdefined(self.doa));
	#/
	if(self.doa.boosters < 1)
	{
		self.doa.boosters = 1;
	}
	if(self.doa.fate == 4)
	{
		if(self.doa.boosters < 2)
		{
			self.doa.boosters = 2;
		}
	}
	else if(self.doa.fate == 13)
	{
		if(self.doa.boosters < 4)
		{
			self.doa.boosters = 4;
		}
	}
	else if(self.doa.fate == 11)
	{
		if(!var_d55fe723 && !isdefined(self.doa.var_3df27425))
		{
			self thread namespace_6df66aa5::function_2016b381(10);
		}
	}
	else if(self.doa.fate == 10)
	{
		if(self.doa.bombs < 1)
		{
			self.doa.bombs = 1;
		}
	}
	self.health = self.maxhealth;
	self.ignoreme = 0;
}

/*
	Name: function_82e3b1cb
	Namespace: namespace_831a4a7c
	Checksum: 0x331B40EB
	Offset: 0x2B88
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function function_82e3b1cb(var_d55fe723 = 0)
{
	players = function_5eb6e4d1();
	for(i = 0; i < players.size; i++)
	{
		if(!isalive(players[i]) || (isdefined(players[i].doa.respawning) && players[i].doa.respawning))
		{
			players[i] function_ad1d5fcb();
		}
		players[i] function_1a86a494(var_d55fe723);
	}
}

/*
	Name: function_aea40863
	Namespace: namespace_831a4a7c
	Checksum: 0xEA03D196
	Offset: 0x2C98
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_aea40863()
{
	self function_d5f89a15(self.doa.default_weap.name);
	self disableweaponcycling();
	self allowjump(0);
	self allowcrouch(0);
	self allowprone(0);
	self allowslide(0);
	self allowdoublejump(0);
	self allowwallrun(0);
	self allowsprint(isdefined(self.doa.var_65f7f2a9) && self.doa.var_65f7f2a9);
	self allowads(isdefined(self.doa.var_65f7f2a9) && self.doa.var_65f7f2a9);
	self setstance("stand");
}

/*
	Name: function_6a52a347
	Namespace: namespace_831a4a7c
	Checksum: 0x41FBC092
	Offset: 0x2E10
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_6a52a347(count = 1)
{
	/#
		assert(isdefined(self.doa));
	#/
	max = level.doa.rules.max_lives;
	if(self.doa.fate == 11)
	{
		max++;
	}
	self.doa.lives = doa_utility::clamp(self.doa.lives + count, 0, max);
}

/*
	Name: function_ba145a39
	Namespace: namespace_831a4a7c
	Checksum: 0xA6753372
	Offset: 0x2EE0
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_ba145a39(count = 1)
{
	/#
		assert(isdefined(self.doa));
	#/
	max = level.doa.rules.max_bombs;
	if(self.doa.fate == 11)
	{
		max++;
	}
	self.doa.bombs = doa_utility::clamp(self.doa.bombs + count, 0, max);
}

/*
	Name: function_f3748dcb
	Namespace: namespace_831a4a7c
	Checksum: 0x5B18C089
	Offset: 0x2FB0
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_f3748dcb(count = 1)
{
	/#
		assert(isdefined(self.doa));
	#/
	max = level.doa.rules.var_376b21db;
	if(self.doa.fate == 11)
	{
		max++;
	}
	self.doa.boosters = doa_utility::clamp(self.doa.boosters + count, 0, max);
}

/*
	Name: function_3f041ff1
	Namespace: namespace_831a4a7c
	Checksum: 0xF619789B
	Offset: 0x3080
	Size: 0xD4
	Parameters: 0
	Flags: Linked, Private
*/
private function function_3f041ff1()
{
	self endon(#"disconnect");
	self util::waittill_any("new_speed_pickup", "player_died", "speed_expired", "disconnect");
	self thread namespace_eaa992c::turnofffx("boots");
	self.doa.fast_feet = undefined;
	self setmovespeedscale(self.doa.default_movespeed);
	self thread namespace_1a381543::function_4f06fb8("zmb_pwup_speed_loop");
	self thread namespace_1a381543::function_90118d8c("zmb_pwup_speed_end");
}

/*
	Name: function_832d21c2
	Namespace: namespace_831a4a7c
	Checksum: 0x135ECFFC
	Offset: 0x3160
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function function_832d21c2()
{
	self notify(#"new_speed_pickup");
	self endon(#"new_speed_pickup");
	self endon(#"disconnect");
	self thread function_3f041ff1();
	wait(0.05);
	self thread namespace_1a381543::function_90118d8c("zmb_pwup_speed_loop");
	self setmovespeedscale(level.doa.rules.var_b92b82b);
	self thread namespace_eaa992c::function_285a2999("boots");
	self.doa.fast_feet = 1;
	self.doa.var_d5c84825 = undefined;
	timeleft = gettime() + self doa_utility::function_1ded48e6(level.doa.rules.player_speed_time) * 1000;
	while(isdefined(self.doa.fast_feet) && self.doa.fast_feet && gettime() < timeleft)
	{
		wait(0.05);
	}
	self notify(#"hash_9284568c");
}

/*
	Name: function_af5211c2
	Namespace: namespace_831a4a7c
	Checksum: 0xC5606A64
	Offset: 0x32D0
	Size: 0x114
	Parameters: 0
	Flags: Linked, Private
*/
private function function_af5211c2()
{
	self endon(#"disconnect");
	self util::waittill_any("new_speed_pickup", "player_died", "speed_expired", "snare_broken", "disconnect");
	self thread namespace_eaa992c::turnofffx("slow_feet");
	self thread namespace_eaa992c::turnofffx("web_contact");
	self thread namespace_1a381543::function_4f06fb8("zmb_pwup_slow_speed_loop");
	self thread namespace_1a381543::function_90118d8c("zmb_pwup_slow_speed_end");
	self.doa.var_d5c84825 = undefined;
	util::wait_network_frame();
	self setmovespeedscale(self.doa.default_movespeed);
}

/*
	Name: function_3840375a
	Namespace: namespace_831a4a7c
	Checksum: 0xC652E9FF
	Offset: 0x33F0
	Size: 0x1DE
	Parameters: 1
	Flags: Linked
*/
function function_3840375a(speed = level.doa.rules.var_ee067ec)
{
	self notify(#"hash_c70bfe29");
	self endon(#"hash_c70bfe29");
	self endon(#"disconnect");
	self thread function_af5211c2();
	wait(0.05);
	self thread namespace_1a381543::function_90118d8c("zmb_pwup_slow_speed_loop");
	self setmovespeedscale(speed);
	if(speed == 0)
	{
		self thread namespace_eaa992c::function_285a2999("web_contact");
		timeleft = gettime() + level.doa.rules.var_dec839f3 * 1000;
	}
	else if(speed == level.doa.rules.var_ee067ec)
	{
		self thread namespace_eaa992c::function_285a2999("slow_feet");
		timeleft = gettime() + level.doa.rules.var_353018d2 * 1000;
	}
	self.doa.var_d5c84825 = 1;
	self.doa.fast_feet = undefined;
	while(isdefined(self.doa.var_d5c84825) && self.doa.var_d5c84825 && gettime() < timeleft)
	{
		wait(0.05);
	}
	self notify(#"hash_9284568c");
}

/*
	Name: function_1ba980a
	Namespace: namespace_831a4a7c
	Checksum: 0xBBEEEE01
	Offset: 0x35D8
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function function_1ba980a()
{
	self endon(#"disconnect");
	self notify(#"hash_1ba980a");
	self endon(#"hash_1ba980a");
	level waittill(#"hash_8817f58");
	self notify(#"hash_864ef970");
}

/*
	Name: function_6e1ed82
	Namespace: namespace_831a4a7c
	Checksum: 0xD1CAD194
	Offset: 0x3628
	Size: 0x2FE
	Parameters: 0
	Flags: Linked
*/
function function_6e1ed82()
{
	self notify(#"hash_6e1ed82");
	self endon(#"hash_6e1ed82");
	self endon(#"hash_9284568c");
	self endon(#"disconnect");
	var_2fa8cbbd = 0;
	samples = [];
	idx = 0;
	self thread function_1ba980a();
	while(!var_2fa8cbbd && isdefined(self))
	{
		norm_move = self getnormalizedmovement();
		var_11533e3b = length(norm_move);
		idx = idx + 1 % 20;
		if(isdefined(var_11533e3b) && var_11533e3b > 0.5)
		{
			samples[idx] = norm_move;
		}
		else
		{
			samples[idx] = (0, 0, 0);
		}
		if(samples.size >= 20)
		{
			var_70a33bda = 0;
			var_96a5b643 = 0;
			var_249e4708 = 0;
			var_4aa0c171 = 0;
			var_8ad257e = 0;
			foreach(var_483bd0a1, vec in samples)
			{
				if(vec == (0, 0, 0))
				{
					var_70a33bda++;
					continue;
				}
				if(vec[0] > 0 && vec[1] > 0)
				{
					var_96a5b643++;
					continue;
				}
				if(vec[0] > 0 && vec[1] < 0)
				{
					var_249e4708++;
					continue;
				}
				if(vec[0] < 0 && vec[1] < 0)
				{
					var_4aa0c171++;
					continue;
				}
				var_8ad257e++;
			}
			if(var_70a33bda < 4)
			{
				if(var_96a5b643 >= 2 && var_249e4708 >= 2 && var_4aa0c171 >= 2 && var_8ad257e >= 2)
				{
					var_2fa8cbbd = 1;
				}
			}
		}
		wait(0.05);
	}
	self notify(#"hash_864ef970");
}

/*
	Name: function_a36ffe73
	Namespace: namespace_831a4a7c
	Checksum: 0x96F72FE3
	Offset: 0x3930
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_a36ffe73()
{
	self notify(#"hash_a36ffe73");
	self endon(#"hash_a36ffe73");
	self waittill(#"hash_89b28ec", attacker);
	self thread function_6e1ed82();
	self thread function_3840375a(0);
	self thread function_a36ffe73();
}

/*
	Name: function_d7c57981
	Namespace: namespace_831a4a7c
	Checksum: 0xAC283DF2
	Offset: 0x39B8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_d7c57981()
{
	self notify(#"hash_d7c57981");
	self endon(#"hash_d7c57981");
	self waittill(#"hash_9132a424", attacker);
	self thread function_3840375a();
	self thread function_d7c57981();
}

/*
	Name: function_e5fa8e6a
	Namespace: namespace_831a4a7c
	Checksum: 0xF98AD3E4
	Offset: 0x3A28
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_e5fa8e6a()
{
	self thread namespace_1a381543::function_90118d8c("zmb_player_poisoned");
	self.doa.var_91c268dc = 0;
	self.doa.weaponlevel = 0;
	self function_d5f89a15(self.doa.default_weap.name);
	self notify(#"hash_8820b45b");
}

/*
	Name: function_e6b2517f
	Namespace: namespace_831a4a7c
	Checksum: 0xD03A2719
	Offset: 0x3AC0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_e6b2517f()
{
	self notify(#"hash_e6b2517f");
	self endon(#"hash_e6b2517f");
	self waittill(#"poisoned", attacker);
	self thread function_e5fa8e6a();
	self thread function_e6b2517f();
}

/*
	Name: function_ab0e2cf3
	Namespace: namespace_831a4a7c
	Checksum: 0x554E5CEA
	Offset: 0x3B30
	Size: 0x5C0
	Parameters: 0
	Flags: Linked
*/
function function_ab0e2cf3()
{
	self notify(#"hash_58a81b71");
	self endon(#"hash_58a81b71");
	self endon(#"disconnect");
	while(true)
	{
		wait(0.05);
		if(!isalive(self))
		{
			continue;
		}
		if(isdefined(self.var_744a3931))
		{
			continue;
		}
		if(isdefined(level.var_3259f885) && level.var_3259f885)
		{
			continue;
		}
		if(isdefined(self.doa.var_3e3bcaa1) && self.doa.var_3e3bcaa1)
		{
			continue;
		}
		if(isdefined(self.doa.var_3be905bb) && self.doa.var_3be905bb || (!isdefined(self.doa.vehicle) && self fragbuttonpressed()))
		{
			self.doa.var_3be905bb = 0;
			if(isdefined(self.doa.boosters) && self.doa.boosters > 0)
			{
				self.doa.rhino_deaths = 0;
				self.doa.var_d5c84825 = undefined;
				if(mayspawnentity())
				{
					self playsound("zmb_speed_boost_activate");
				}
				self.doa.boosters--;
				self thread turnplayershieldon();
				curdir = anglestoforward((0, 0, 0));
				if(mayspawnfakeentity())
				{
					trigger = spawn("trigger_radius", self.origin, 1, 85, 50);
					trigger.targetname = "triggerBoost1";
					trigger enablelinkto();
					trigger linkto(self, "tag_origin", curdir * 200, self.angles);
					trigger thread shield_trigger_think(self);
					trigger thread doa_utility::function_a625b5d3(self);
					trigger thread doa_utility::function_75e76155(self, "boosterThink");
					trigger thread doa_utility::function_1bd67aef(0.6);
				}
				if(mayspawnfakeentity())
				{
					trigger2 = spawn("trigger_radius", self.origin, 1, 85, 50);
					trigger2.targetname = "triggerBoost2";
					trigger2 enablelinkto();
					trigger2 linkto(self, "tag_origin", curdir * 50, self.angles);
					trigger2 thread shield_trigger_think(self);
					trigger2 thread doa_utility::function_a625b5d3(self);
					trigger2 thread doa_utility::function_75e76155(self, "boosterThink");
					trigger2 thread doa_utility::function_1bd67aef(0.6);
				}
				curdir = anglestoforward(self.angles);
				endtime = gettime() + 600;
				boost_vector = curdir * 2000;
				boost_vector = boost_vector + vectorscale((0, 0, 1), 200);
				self setvelocity(boost_vector);
				boost_vector = boost_vector - vectorscale((0, 0, 1), 200);
				self playrumbleonentity("zombietron_booster_rumble");
				if(self.doa.fate == 13 || (isdefined(self.doa.var_480b6280) && self.doa.var_480b6280))
				{
					self thread doa_fate::function_3caf8e2(endtime);
				}
				while(gettime() < endtime)
				{
					self setvelocity(boost_vector);
					wait(0.05);
				}
				self.doa.rhino_deaths = undefined;
				if(isdefined(trigger))
				{
					trigger delete();
				}
				if(isdefined(trigger2))
				{
					trigger2 delete();
				}
			}
		}
	}
}

/*
	Name: function_7d7a7fde
	Namespace: namespace_831a4a7c
	Checksum: 0x958F24D
	Offset: 0x40F8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_7d7a7fde()
{
	if(level.time == self.birthtime || !isdefined(self.doa))
	{
		wait(0.05);
	}
	if(!(isdefined(self.doa.var_65f7f2a9) && self.doa.var_65f7f2a9))
	{
		self clientfield::increment_to_player("controlBinding");
	}
	else
	{
		self clientfield::increment_to_player("goFPS");
	}
}

/*
	Name: function_9fc6e261
	Namespace: namespace_831a4a7c
	Checksum: 0xBB818606
	Offset: 0x4198
	Size: 0x4C
	Parameters: 0
	Flags: Linked, Private
*/
private function function_9fc6e261()
{
	self waittill(#"actor_corpse", corpse);
	wait(0.05);
	if(isdefined(corpse))
	{
		corpse clientfield::increment("burnCorpse");
	}
}

/*
	Name: function_d392db04
	Namespace: namespace_831a4a7c
	Checksum: 0xD237BD29
	Offset: 0x41F0
	Size: 0x344
	Parameters: 4
	Flags: Linked, Private
*/
private function function_d392db04(var_adc420e5, origin, player, var_307c0d3)
{
	self endon(#"death");
	/#
		assert(!(isdefined(self.boss) && self.boss));
	#/
	if(!isdefined(level.var_b3050900))
	{
		level.var_b3050900 = 160 * 160;
		level.var_5e8840d3 = 512 * 512;
		level.var_c4dbc378 = 75;
		level.var_619a7a66 = 250;
		level.var_38e68ca7 = 1;
	}
	distsq = distancesquared(self.origin, origin);
	var_b3458cba = doa_utility::clamp(distsq / level.var_5e8840d3, 0.1, 1);
	time = doa_utility::clamp(var_adc420e5 * var_b3458cba, 0.05, var_adc420e5);
	wait(time);
	if(isdefined(self.archetype) && self.archetype == "robot")
	{
		self namespace_fba031c8::function_7b3e39cb();
	}
	else
	{
		self thread function_9fc6e261();
		if(!(isdefined(self.nofire) && self.nofire) && isactor(self))
		{
			self clientfield::increment("burnZombie");
		}
	}
	if(self.archetype == "zombie")
	{
		roll = randomint(100);
		if(roll < 10)
		{
			self clientfield::set("zombie_rhino_explosion", 1);
			util::wait_network_frame();
		}
		else if(roll < 40)
		{
			self clientfield::set("zombie_gut_explosion", 1);
			util::wait_network_frame();
		}
		else if(roll < 70)
		{
			self clientfield::set("zombie_saw_explosion", 1);
			util::wait_network_frame();
		}
	}
	self.takedamage = 1;
	self.allowdeath = 1;
	self dodamage(self.health + 1, origin, (isdefined(player) ? player : undefined), undefined, "none", "MOD_EXPLOSIVE");
}

/*
	Name: function_73d40751
	Namespace: namespace_831a4a7c
	Checksum: 0xB510F15D
	Offset: 0x4540
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function function_73d40751()
{
	self notify(#"hash_73d40751");
	self endon(#"hash_73d40751");
	self endon(#"disconnect");
	while(true)
	{
		wait(0.05);
		if(self weaponswitchbuttonpressed())
		{
			if(!(isdefined(self.doa.var_655cbff1) && self.doa.var_655cbff1))
			{
				self clientfield::increment_to_player("changeCamera");
				self notify(#"hash_348c5f29");
				level notify(#"hash_348c5f29", self);
			}
			while(self weaponswitchbuttonpressed())
			{
				wait(0.05);
			}
		}
	}
}

/*
	Name: function_f19e9b07
	Namespace: namespace_831a4a7c
	Checksum: 0x52D163D8
	Offset: 0x4628
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function function_f19e9b07()
{
	self notify(#"hash_f26fb3a4");
	self endon(#"hash_f26fb3a4");
	self endon(#"disconnect");
	while(true)
	{
		wait(0.05);
		if(!isalive(self))
		{
			continue;
		}
		if(self stancebuttonpressed())
		{
			if(isdefined(self.doa.vehicle))
			{
				self notify(#"hash_d28ba89d");
			}
			else
			{
				self doa_pickups::function_9615d68f();
			}
			while(self stancebuttonpressed())
			{
				wait(0.05);
			}
		}
	}
}

/*
	Name: function_4eabae51
	Namespace: namespace_831a4a7c
	Checksum: 0xB376BEB9
	Offset: 0x4708
	Size: 0x580
	Parameters: 0
	Flags: Linked
*/
function function_4eabae51()
{
	self notify(#"hash_97fb783");
	self endon(#"hash_97fb783");
	self endon(#"disconnect");
	while(true)
	{
		wait(0.05);
		if(!isalive(self))
		{
			continue;
		}
		if(isdefined(self.var_744a3931))
		{
			continue;
		}
		if(isdefined(self.doa.var_3024fd0f) && self.doa.var_3024fd0f)
		{
			continue;
		}
		if(isdefined(level.var_3259f885) && level.var_3259f885)
		{
			continue;
		}
		if(isdefined(self.doa.var_c1de140a))
		{
			if(gettime() < self.doa.var_c1de140a)
			{
				continue;
			}
			else
			{
				self.doa.var_c1de140a = undefined;
			}
		}
		if(isdefined(self.doa.var_f30b49ec) && self.doa.var_f30b49ec)
		{
			if(self jumpbuttonpressed())
			{
				continue;
			}
			else
			{
				self.doa.var_f30b49ec = undefined;
			}
		}
		if(isdefined(self.doa.var_f2870a9e) && self.doa.var_f2870a9e || self jumpbuttonpressed())
		{
			self.doa.var_f2870a9e = 0;
			self.doa.var_f30b49ec = 1;
			if(isdefined(self.doa.bombs) && self.doa.bombs > 0)
			{
				self.doa.bombs--;
				player_org = self.origin;
				origin = player_org + (20, 0, 800);
				self clientfield::set("bombDrop", 1);
				self thread turnplayershieldon();
				doa_utility::clearallcorpses();
				wait(0.4);
				playrumbleonposition("artillery_rumble", self.origin);
				util::wait_network_frame();
				level notify(#"hash_8817f58");
				enemies = doa_utility::function_fb2ad2fb();
				camerapos = namespace_3ca3c537::function_5147636f();
				var_307c0d3 = vectornormalize(camerapos - player_org);
				var_adc420e5 = 0.3;
				foreach(var_341f5413, guy in enemies)
				{
					if(isdefined(guy))
					{
						if(isdefined(guy.boss) && guy.boss)
						{
							guy.nuked = gettime();
							continue;
						}
						if(isvehicle(guy))
						{
							guy dodamage(guy.health + 1, player_org, self, self, "none", "MOD_EXPLOSIVE", 0, getweapon("none"));
						}
						guy thread function_d392db04(var_adc420e5, player_org, self, var_307c0d3);
					}
				}
				foreach(var_c083e5ae, hazard in level.doa.hazards)
				{
					if(isdefined(hazard) && isdefined(hazard.death_func))
					{
						hazard thread [[hazard.death_func]]();
					}
				}
				util::wait_network_frame();
				self clientfield::set("bombDrop", 0);
				physicsexplosionsphere(player_org, 1024, 1024, 3);
			}
		}
	}
}

/*
	Name: function_350f42fa
	Namespace: namespace_831a4a7c
	Checksum: 0x46A91DC2
	Offset: 0x4C90
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function function_350f42fa(var_e1eb317e)
{
	self endon(#"disconnect");
	self notify(#"hash_42ae3dd7");
	self endon(#"hash_42ae3dd7");
	while(true)
	{
		self waittill(#"missile_fire", projectile, weapon);
		if(weapon == level.doa.var_e30c10ec)
		{
			projectile thread function_48b5439d(self);
			projectile thread function_62c5034a(self);
		}
		else if(weapon == level.doa.var_ccb54987)
		{
			self thread function_5e373fc6();
		}
	}
}

/*
	Name: function_62c5034a
	Namespace: namespace_831a4a7c
	Checksum: 0x3E0E03FA
	Offset: 0x4D70
	Size: 0x168
	Parameters: 1
	Flags: Linked
*/
function function_62c5034a(owner)
{
	self endon(#"death");
	owner endon(#"hash_42ae3dd7");
	owner endon(#"disconnect");
	while(true)
	{
		self waittill(#"grenade_bounce", pos, normal, ent, surface);
		physicsexplosionsphere(pos, getdvarint("scr_doa_secondary_explo_rad", 64), getdvarint("scr_doa_secondary_explo_rad", 64), 3);
		radiusdamage(pos, getdvarint("scr_doa_secondary_explo_rad", 64), getdvarint("scr_doa_secondary_explo_dmg", 2000), getdvarint("scr_doa_secondary_explo_dmg", 2000), owner);
		playfx(level._effect["impact_raygun"], pos);
		wait(getdvarfloat("scr_doa_secondary_firerate_frac", 0.65));
	}
}

/*
	Name: function_48b5439d
	Namespace: namespace_831a4a7c
	Checksum: 0xA10A820E
	Offset: 0x4EE0
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function function_48b5439d(owner)
{
	self endon(#"death");
	owner endon(#"hash_42ae3dd7");
	owner endon(#"disconnect");
	owner.doa.var_cdd906a9 = 0;
	while(true)
	{
		owner waittill(#"hash_21f7a743", victim);
		time = gettime();
		if(owner.doa.var_cdd906a9 > time)
		{
			continue;
		}
		owner.doa.var_cdd906a9 = time;
		level thread namespace_3f3eaecb::function_395fdfb8(victim, owner);
	}
}

/*
	Name: missile_logic
	Namespace: namespace_831a4a7c
	Checksum: 0xE1658125
	Offset: 0x4FC0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function missile_logic(target)
{
	self waittill(#"missile_fire", missile, weap);
	if(isdefined(target))
	{
		missile missile_settarget(target);
	}
}

/*
	Name: function_5e373fc6
	Namespace: namespace_831a4a7c
	Checksum: 0x639CE363
	Offset: 0x5020
	Size: 0x36C
	Parameters: 0
	Flags: Linked
*/
function function_5e373fc6()
{
	if(!isdefined(self.doa.var_5af6f9a9))
	{
		self.doa.var_5af6f9a9 = getweapon("zombietron_rpg_2_secondary");
	}
	enemies = doa_utility::function_fb2ad2fb();
	if(enemies.size == 0)
	{
		return;
	}
	closetargets = arraysortclosest(enemies, self.origin, enemies.size, 0, 4096);
	fovtargets = [];
	foreach(var_b741a70, guy in closetargets)
	{
		if(isdefined(guy.boss) && guy.boss)
		{
			continue;
		}
		if(util::within_fov(self.origin, self.angles, guy.origin, 0.8))
		{
			fovtargets[fovtargets.size] = guy;
		}
		if(fovtargets.size >= 2)
		{
			break;
		}
	}
	if(fovtargets.size == 0)
	{
		return;
	}
	target1 = fovtargets[0];
	target2 = (fovtargets.size > 1 ? fovtargets[1] : fovtargets[0]);
	v_spawn = self gettagorigin("tag_flash");
	if(!isdefined(v_spawn))
	{
		return;
	}
	v_dir = anglestoforward(self.angles);
	self.doa.var_b5d64970 = gettime() + getdvarint("scr_doa_secondary_firerate", int(getdvarfloat("scr_doa_secondary_firerate_frac", 0.65) * 1000));
	self thread missile_logic(target1);
	magicbullet(self.doa.var_5af6f9a9, v_spawn, v_spawn + 50 * v_dir, self);
	wait(0.05);
	self thread missile_logic(target2);
	magicbullet(self.doa.var_5af6f9a9, v_spawn, v_spawn + 50 * v_dir, self);
}

/*
	Name: function_baa7411e
	Namespace: namespace_831a4a7c
	Checksum: 0x6E6FB973
	Offset: 0x5398
	Size: 0x28C
	Parameters: 1
	Flags: Linked
*/
function function_baa7411e(weapon)
{
	self takeallweapons();
	self giveweapon(weapon);
	self switchtoweaponimmediate(weapon);
	self thread function_f2507519(level.doa.arena_round_number == 3);
	self.doa.var_d898dd8e = weapon;
	self.doa.var_7a1de0da = 0;
	self.doa.var_88842727 = weapon;
	if(weapon == self.doa.default_weap)
	{
		self.doa.var_d898dd8e = undefined;
		if(weapon == level.doa.var_69899304)
		{
			self.doa.var_d898dd8e = level.doa.var_69899304;
		}
		if(weapon == level.doa.var_416914d0)
		{
			self.doa.var_d898dd8e = level.doa.var_416914d0;
		}
	}
	else if(weapon.type == "gas")
	{
		self.doa.var_d898dd8e = level.doa.var_e6a7c945;
	}
	else if(weapon.name == "zombietron_launcher")
	{
		self.doa.var_d898dd8e = level.doa.var_ab5c3535;
		self.doa.var_7a1de0da = -5;
	}
	else if(weapon.name == "zombietron_launcher_1")
	{
		self.doa.var_d898dd8e = level.doa.var_5706a235;
		self.doa.var_7a1de0da = -5;
	}
	else if(weapon.name == "zombietron_launcher_2")
	{
		self.doa.var_d898dd8e = level.doa.var_7d091c9e;
		self.doa.var_7a1de0da = -5;
	}
}

/*
	Name: function_71dab8e8
	Namespace: namespace_831a4a7c
	Checksum: 0x84304CBE
	Offset: 0x5630
	Size: 0x3AC
	Parameters: 1
	Flags: Linked
*/
function function_71dab8e8(amount = 1)
{
	if(!isdefined(self.doa.var_e1eb317e))
	{
		return;
	}
	if(isdefined(self.doa.respawning) && self.doa.respawning)
	{
		return;
	}
	self.doa.var_91c268dc = self.doa.var_91c268dc + int(getdvarint("scr_doa_weapon_increment", 64) * amount);
	if(self.doa.var_91c268dc >= getdvarint("scr_doa_weapon_increment_range", 1024))
	{
		if(self.doa.weaponlevel < 2)
		{
			var_2e3af952 = self.doa.weaponlevel;
			self.doa.weaponlevel = self.doa.weaponlevel + int(self.doa.var_91c268dc / getdvarint("scr_doa_weapon_increment_range", 1024));
			if(self.doa.weaponlevel > 2)
			{
				self.doa.weaponlevel = 2;
			}
			self.doa.var_91c268dc = self.doa.var_91c268dc - self.doa.weaponlevel - var_2e3af952 * getdvarint("scr_doa_weapon_increment_range", 1024);
			graceperiod = gettime() + 2000;
			if(isdefined(self.doa.var_c2b9d7d0) && self.doa.var_c2b9d7d0 < graceperiod)
			{
				self.doa.var_c2b9d7d0 = graceperiod;
			}
			self function_baa7411e(self.doa.var_e1eb317e[self.doa.weaponlevel]);
			if(mayspawnentity())
			{
				self playsoundtoplayer("zmb_weapon_upgraded", self);
			}
			/#
				doa_utility::debugmsg("" + self.name + "" + self.doa.weaponlevel + "" + self.doa.var_e1eb317e[self.doa.weaponlevel].name);
			#/
		}
		else
		{
			self.doa.var_91c268dc = getdvarint("scr_doa_weapon_increment_range", 1024) - 1;
		}
	}
	self.doa.var_91c268dc = math::clamp(self.doa.var_91c268dc, 0, getdvarint("scr_doa_weapon_increment_range", 1024) - 1);
}

/*
	Name: updateweapon
	Namespace: namespace_831a4a7c
	Checksum: 0xEDA3E95C
	Offset: 0x59E8
	Size: 0x4BC
	Parameters: 0
	Flags: Linked
*/
function updateweapon()
{
	if(!isdefined(self.doa) || !isdefined(self.doa.var_a2d31b4a))
	{
		return;
	}
	if(isdefined(self.doa.var_88842727) && self.doa.var_88842727 == level.doa.var_69899304)
	{
		self.doa.weaponlevel = 2;
		self.doa.var_91c268dc = getdvarint("scr_doa_weapon_increment_range", 1024) - 1;
		return;
	}
	if(gettime() < self.doa.var_c2b9d7d0)
	{
		return;
	}
	if(self.doa.var_91c268dc > 0)
	{
		decay = getdvarint("scr_doa_weapon_increment_decay", 1) + self.doa.var_f303ab59;
		self.doa.var_f303ab59 = 0;
		if(self isfiring())
		{
			decay = int(decay * getdvarint("scr_doa_weapon_increment_decayscale", 5) - self.doa.var_7c1bcaf3);
		}
		self.doa.var_91c268dc = self.doa.var_91c268dc - decay;
		if(self.doa.var_91c268dc < 0)
		{
			self.doa.var_91c268dc = 0;
		}
	}
	else if(self.doa.weaponlevel > 0)
	{
		self.doa.weaponlevel--;
		self.doa.var_91c268dc = getdvarint("scr_doa_weapon_increment_range", 1024) - 1;
		self function_baa7411e(self.doa.var_e1eb317e[self.doa.weaponlevel]);
		self thread function_f2507519(level.doa.arena_round_number == 3);
		/#
			doa_utility::debugmsg("" + self.name + "" + self.doa.weaponlevel + "" + self.doa.var_e1eb317e[self.doa.weaponlevel].name);
		#/
	}
	if(self.doa.var_a2d31b4a == self.doa.default_weap.name && (isdefined(self.doa.var_1b58e8ba) && self.doa.weaponlevel <= self.doa.var_1b58e8ba))
	{
		self.doa.weaponlevel = self.doa.var_1b58e8ba;
		self.doa.var_91c268dc = getdvarint("scr_doa_weapon_increment_range", 1024) - 1;
		if(isdefined(self.doa.var_88842727) && self.doa.var_88842727 != self.doa.var_e1eb317e[self.doa.weaponlevel])
		{
			self function_baa7411e(self.doa.var_e1eb317e[self.doa.weaponlevel]);
		}
	}
	if(self.doa.var_91c268dc == 0 && self.doa.weaponlevel == 0 && self.doa.var_a2d31b4a != self.doa.default_weap.name)
	{
		self function_d5f89a15(self.doa.default_weap.name);
	}
}

/*
	Name: function_d5f89a15
	Namespace: namespace_831a4a7c
	Checksum: 0xCBE3CAC9
	Offset: 0x5EB0
	Size: 0x4C4
	Parameters: 2
	Flags: Linked
*/
function function_d5f89a15(name, weaponpickup = 0)
{
	if(!isdefined(self.doa))
	{
		return;
	}
	if(isdefined(weaponpickup) && weaponpickup)
	{
		fill = 1;
		if(isdefined(self.doa.var_a2d31b4a) && self.doa.var_a2d31b4a == name)
		{
			self function_71dab8e8(getdvarint("scr_doa_weapon_increment_range", 1024) / getdvarint("scr_doa_weapon_increment", 64));
			return;
		}
	}
	if(!isdefined(self.doa.var_a2d31b4a) || (isdefined(self.doa.var_a2d31b4a) && self.doa.var_a2d31b4a != name))
	{
		self.doa.var_e1eb317e = [];
		self.doa.var_a2d31b4a = name;
		self.doa.var_91c268dc = 0;
		self.doa.weaponlevel = 0;
		if(isdefined(self.doa.default_weap) && name != self.doa.default_weap.name && (self.doa.fate == 1 || self.doa.fate == 10))
		{
			self.doa.weaponlevel = 1;
		}
		self.doa.var_c2b9d7d0 = 0;
		self.doa.var_b5d64970 = 0;
		self.doa.var_f303ab59 = 0;
		self takeallweapons();
		var_5f2870f1 = getweapon(name);
		/#
			assert(isdefined(var_5f2870f1));
		#/
		var_3925f688 = getweapon(name + "_1");
		var_ab2d65c3 = getweapon(name + "_2");
		self.doa.var_e1eb317e[0] = var_5f2870f1;
		self.doa.var_e1eb317e[1] = (var_3925f688 != level.weaponnone ? var_3925f688 : var_5f2870f1);
		self.doa.var_e1eb317e[2] = (var_ab2d65c3 != level.weaponnone ? var_ab2d65c3 : (var_3925f688 != level.weaponnone ? var_3925f688 : var_5f2870f1));
		self function_baa7411e(self.doa.var_e1eb317e[self.doa.weaponlevel]);
		self thread function_350f42fa(self.doa.var_a2d31b4a);
	}
	else
	{
		self function_baa7411e(self.doa.var_e1eb317e[self.doa.weaponlevel]);
	}
	if(isdefined(fill) && fill)
	{
		self.doa.var_91c268dc = getdvarint("scr_doa_weapon_increment_range", 1024) - 1;
	}
	/#
		doa_utility::debugmsg("" + self.name + "" + self.doa.var_a2d31b4a + "" + isdefined(fill) && (fill ? "" : ""));
		self thread function_1318d1e4();
	#/
}

/*
	Name: function_1318d1e4
	Namespace: namespace_831a4a7c
	Checksum: 0x69591697
	Offset: 0x6380
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_1318d1e4()
{
	self notify(#"hash_1318d1e4");
	self endon(#"hash_1318d1e4");
	self endon(#"disconnect");
	self waittill(#"weapon_fired", weapon);
	/#
		doa_utility::debugmsg("" + weapon.name);
	#/
}

/*
	Name: function_7f33210a
	Namespace: namespace_831a4a7c
	Checksum: 0xD908941E
	Offset: 0x6400
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_7f33210a()
{
	if(!isdefined(self) || !isdefined(self.doa))
	{
		return;
	}
	self.doa.var_9742391e = 0;
}

/*
	Name: function_b5843d4f
	Namespace: namespace_831a4a7c
	Checksum: 0xF73FC282
	Offset: 0x6440
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_b5843d4f(var_6a15db21)
{
	self endon(#"disconnect");
	if(!isdefined(self) || !isdefined(self.doa))
	{
		return;
	}
	if(isdefined(self.doa.vehicle))
	{
		return;
	}
	self.doa.var_9742391e = (var_6a15db21 ? 2 : 1);
}

/*
	Name: function_f2507519
	Namespace: namespace_831a4a7c
	Checksum: 0x578398FD
	Offset: 0x64B8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_f2507519(on = 1)
{
	if(!isdefined(self))
	{
		return;
	}
	self notify(#"hash_f2507519");
	self endon(#"hash_f2507519");
	self endon(#"disconnect");
	if(!isdefined(self) || !isdefined(self.doa))
	{
		return;
	}
	if(isdefined(self.doa.vehicle))
	{
		return;
	}
	self util::waittill_any_timeout(0.25, "weapon_change_complete", "disconnect", "turnOnFlashlight");
	if(isdefined(self) && isdefined(self.entnum))
	{
		if(on)
		{
			self thread namespace_eaa992c::function_285a2999("player_flashlight");
		}
		else
		{
			self thread namespace_eaa992c::turnofffx("player_flashlight");
		}
	}
}

/*
	Name: function_7e85dbee
	Namespace: namespace_831a4a7c
	Checksum: 0x1262091E
	Offset: 0x65D0
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_7e85dbee()
{
	var_b427d4ac = self.doa.multiplier;
	if(self.doa.fate == 2 || self.doa.fate == 11)
	{
		var_b427d4ac--;
	}
	if(var_b427d4ac > 1)
	{
		var_516eed4b = doa_utility::clamp(int(randomfloatrange(0.3, 0.5) * var_b427d4ac - 1 * 4), 3);
		level thread doa_pickups::spawnubertreasure(self.origin, var_516eed4b, 85, 1, 1);
	}
}

/*
	Name: function_2fee362e
	Namespace: namespace_831a4a7c
	Checksum: 0x48FEA903
	Offset: 0x66D0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_2fee362e()
{
	self endon(#"disconnect");
	self notify(#"hash_2fee362e");
	self endon(#"hash_2fee362e");
	while(!(isdefined(level.hostmigrationtimer) && level.hostmigrationtimer))
	{
		wait(1);
	}
	while(isdefined(level.hostmigrationtimer) && level.hostmigrationtimer)
	{
		wait(0.05);
	}
	self thread turnplayershieldon(0);
}

/*
	Name: function_3682cfe4
	Namespace: namespace_831a4a7c
	Checksum: 0x3CA46216
	Offset: 0x6760
	Size: 0x40C
	Parameters: 9
	Flags: Linked
*/
function function_3682cfe4(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	self globallogic_score::incpersstat("deaths", 1, 1, 1);
	self thread namespace_1a381543::function_90118d8c("zmb_player_death");
	self notify(#"player_died");
	self freezecontrols(1);
	self setplayercollision(0);
	self thread function_7e85dbee();
	self.doa.var_91c268dc = 0;
	self.doa.weaponlevel = 0;
	self.doa.var_c2b9d7d0 = 0;
	self.var_5f951816 = gettime();
	self thread namespace_64c6b720::function_850bb47e();
	self.deaths = math::clamp(self.deaths + 1, 0, 1023);
	self.dead = 1;
	/#
		doa_utility::debugmsg("" + smeansofdeath + "" + idamage);
		if(isdefined(einflictor))
		{
			doa_utility::debugmsg("" + einflictor getentitynumber() + "" + einflictor.classname + (isdefined(einflictor.targetname) ? "" + einflictor.targetname : ""));
		}
		if(isdefined(attacker))
		{
			doa_utility::debugmsg("" + attacker getentitynumber() + "" + attacker.classname + (isdefined(attacker.targetname) ? "" + attacker.targetname : ""));
		}
	#/
	if(self.doa.lives == 0)
	{
		players = function_5eb6e4d1();
		count = 0;
		for(i = 0; i < players.size; i++)
		{
			if(!isalive(players[i]) && players[i].doa.lives == 0 || isdefined(players[i].var_744a3931))
			{
				count++;
			}
		}
		if(count == players.size)
		{
			level flag::set("doa_game_is_over");
			level notify(#"hash_d1f5acf7");
		}
		else
		{
			self thread function_c7471371();
		}
	}
	else
	{
		self thread function_161ce9cd();
	}
}

/*
	Name: function_fdf74b3
	Namespace: namespace_831a4a7c
	Checksum: 0xFE014027
	Offset: 0x6B78
	Size: 0x4A
	Parameters: 0
	Flags: Linked, Private
*/
private function function_fdf74b3()
{
	self notify(#"new_ignore_attacker");
	self endon(#"new_ignore_attacker");
	self endon(#"disconnect");
	wait(level.rules.ignore_enemy_timer);
	self.doa.ignoreattacker = undefined;
}

/*
	Name: function_bfbc53f4
	Namespace: namespace_831a4a7c
	Checksum: 0x6649D7B8
	Offset: 0x6BD0
	Size: 0x5FC
	Parameters: 13
	Flags: Linked
*/
function function_bfbc53f4(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal)
{
	if(isdefined(smeansofdeath) && smeansofdeath == "MOD_FALLING")
	{
		idamage = 0;
	}
	if(isdefined(self.doa) && (isdefined(self.doa.var_ccf4ef81) && self.doa.var_ccf4ef81))
	{
		idamage = 0;
	}
	if(isdefined(level.hostmigrationtimer) && level.hostmigrationtimer)
	{
		idamage = 0;
	}
	if(!isdefined(self.doa))
	{
		idamage = 0;
	}
	else if(isdefined(self.doa.vehicle))
	{
		idamage = 0;
	}
	if(isdefined(self.doa.shield_is_on))
	{
		self cleardamageindicator();
		idamage = 0;
	}
	if(idamage && isdefined(eattacker))
	{
		if(isdefined(eattacker.meleedamage))
		{
			idamage = eattacker.meleedamage;
		}
		if(eattacker == self)
		{
			idamage = 0;
		}
		if(isdefined(self.doa.ignoreattacker) && self.doa.ignoreattacker == eattacker)
		{
			idamage = 0;
		}
		if(isdefined(eattacker.owner))
		{
			eattacker = eattacker.owner;
		}
		if(eattacker.team == self.team)
		{
			idamage = 0;
		}
		if(eattacker isragdoll())
		{
			idamage = 0;
			eattacker thread doa_utility::function_ba30b321(0.1);
		}
		if(isdefined(eattacker.knocked_out) && eattacker.knocked_out)
		{
			idamage = 0;
		}
		if(isdefined(self.doa.var_65f7f2a9) && self.doa.var_65f7f2a9)
		{
			curtime = gettime();
			if(curtime < self.doa.var_f9deeb49)
			{
				idamage = 0;
			}
			if(idamage > self.maxhealth)
			{
				idamage = self.maxhealth;
			}
			if(!(isdefined(eattacker.boss) && eattacker.boss))
			{
				idamage = int(idamage * getdvarfloat("scr_doa_fps_dmg_mod", 0.35));
			}
			if(idamage > 0)
			{
				self.doa.var_f9deeb49 = curtime + 1000;
			}
		}
		if(isdefined(eattacker.is_zombie) && eattacker.is_zombie)
		{
			self.doa.ignoreattacker = eattacker;
			self thread function_fdf74b3();
		}
		if(isdefined(eattacker.var_f4795bf) && eattacker.var_f4795bf && smeansofdeath == "MOD_PROJECTILE")
		{
			self notify(#"hash_89b28ec", eattacker);
			idamage = 0;
		}
		else if(!(isdefined(eattacker.boss) && eattacker.boss) && (smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_RIFLE_BULLET" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" || smeansofdeath == "MOD_BURNED" || smeansofdeath == "MOD_EXPLOSIVE"))
		{
			self cleardamageindicator();
			idamage = 0;
		}
		if(isdefined(eattacker.custom_damage_func))
		{
			idamage = eattacker [[eattacker.custom_damage_func]]();
		}
		if(isdefined(eattacker.boss) && eattacker.boss)
		{
			eattacker.damagedplayer = gettime();
		}
		if(isdefined(eattacker.var_65e0af26) && eattacker.var_65e0af26)
		{
			self notify(#"hash_9132a424", eattacker);
		}
		if(isdefined(eattacker.var_dcdf7239) && eattacker.var_dcdf7239)
		{
			self notify(#"poisoned", eattacker);
		}
	}
	self finishplayerdamagewrapper(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal);
}

/*
	Name: finishplayerdamagewrapper
	Namespace: namespace_831a4a7c
	Checksum: 0xE4DADBBF
	Offset: 0x71D8
	Size: 0xB4
	Parameters: 13
	Flags: Linked
*/
function finishplayerdamagewrapper(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal)
{
	self finishplayerdamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal);
}

/*
	Name: playerlaststand
	Namespace: namespace_831a4a7c
	Checksum: 0x80DDDFE7
	Offset: 0x7298
	Size: 0x4C
	Parameters: 9
	Flags: None
*/
function playerlaststand(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
}

/*
	Name: function_f847ee8c
	Namespace: namespace_831a4a7c
	Checksum: 0x823941B1
	Offset: 0x72F0
	Size: 0x4C
	Parameters: 9
	Flags: Linked
*/
function function_f847ee8c(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
}

/*
	Name: function_68ece679
	Namespace: namespace_831a4a7c
	Checksum: 0xEC9E208E
	Offset: 0x7348
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function function_68ece679(entnum)
{
	points = level.doa.arenas[level.doa.current_arena].player_spawn_points;
	/#
		assert(points.size);
	#/
	if(isdefined(entnum) && isdefined(points[entnum]))
	{
		return points[entnum];
	}
	return points[randomint(points.size)];
}

/*
	Name: function_161ce9cd
	Namespace: namespace_831a4a7c
	Checksum: 0x78BC9F28
	Offset: 0x73F8
	Size: 0xF4
	Parameters: 1
	Flags: Linked, Private
*/
private function function_161ce9cd(delay = 2)
{
	self endon(#"disconnect");
	wait(delay);
	if(self.doa.lives < 1)
	{
		return;
	}
	if(level flag::get("doa_game_is_over"))
	{
		return;
	}
	while(isdefined(level.hostmigrationtimer))
	{
		wait(0.05);
	}
	self.doa.lives = doa_utility::clamp(self.doa.lives - 1, 0, level.doa.rules.max_lives);
	self notify(#"hash_e15bcd80");
	self function_ad1d5fcb();
}

/*
	Name: function_ad1d5fcb
	Namespace: namespace_831a4a7c
	Checksum: 0x2EE44434
	Offset: 0x74F8
	Size: 0x382
	Parameters: 1
	Flags: Linked, Private
*/
private function function_ad1d5fcb(var_243f32c0 = 0)
{
	self endon(#"disconnect");
	if(!isdefined(self))
	{
		return;
	}
	/#
		assert(isdefined(self.doa));
	#/
	self.doa.respawning = 0;
	if(isdefined(self.var_1a898004))
	{
		doa_utility::function_11f3f381(self.var_1a898004, 1);
		self.var_1a898004 = undefined;
	}
	self.var_9ea856f6 = 0;
	self.doa.var_f4a883ed = undefined;
	self disableinvulnerability();
	self show();
	if(!var_243f32c0 && isdefined(self.doa.var_bac6a79))
	{
		switch(self.doa.var_bac6a79)
		{
			case "spawn_at_start":
			{
				spot = function_68ece679(self.entnum).origin;
				break;
			}
			case "spawn_at_safe":
			{
				spot = doa_utility::getclosestto(self.origin, level.doa.arenas[level.doa.current_arena].var_1d2ed40).origin;
				break;
			}
			default:
			{
				spot = function_68ece679(self.entnum).origin;
				break;
			}
		}
		self.doa.var_bac6a79 = undefined;
	}
	self notify(#"doa_respawn_player");
	self reviveplayer();
	if(!isdefined(spot))
	{
		spot = self.origin;
	}
	self setorigin(spot);
	if(!var_243f32c0)
	{
		if(mayspawnentity())
		{
			self playsound("zmb_player_respawn");
		}
		self thread namespace_eaa992c::function_285a2999("player_respawn_" + function_ee495f41(self.entnum));
		self thread turnplayershieldon(0);
		self thread function_f2507519(level.doa.arena_round_number == 3);
	}
	self thread function_b5843d4f(level.doa.arena_round_number == 3);
	wait(0.05);
	self thread function_bbb1254c(var_243f32c0);
	self setplayercollision(1);
	self freezecontrols(0);
	self.dead = undefined;
	self notify(#"player_respawned");
}

/*
	Name: function_bbdc9bc0
	Namespace: namespace_831a4a7c
	Checksum: 0xFCF66629
	Offset: 0x7888
	Size: 0xC2
	Parameters: 0
	Flags: Linked, Private
*/
private function function_bbdc9bc0()
{
	self endon(#"disconnect");
	self endon(#"player_respawned");
	level endon(#"doa_game_is_over");
	while(!level flag::get("doa_game_is_over"))
	{
		if(self.doa.lives > 0)
		{
			self function_161ce9cd(isdefined(self.doa.var_ec2548a9) && (self.doa.var_ec2548a9 ? 0 : 2));
			return;
		}
		wait(0.2);
	}
	self.doa.respawning = undefined;
}

/*
	Name: function_1c683070
	Namespace: namespace_831a4a7c
	Checksum: 0x88C87372
	Offset: 0x7958
	Size: 0xF4
	Parameters: 1
	Flags: None
*/
function function_1c683070(distsq = 1296)
{
	count = 0;
	foreach(var_1f324a3c, player in getplayers())
	{
		if(player == self)
		{
			continue;
		}
		if(distancesquared(self.origin, player.origin) <= distsq)
		{
			count++;
		}
	}
	return count;
}

/*
	Name: function_2b1d321f
	Namespace: namespace_831a4a7c
	Checksum: 0x7EF1E5B1
	Offset: 0x7A58
	Size: 0x3AE
	Parameters: 2
	Flags: Linked
*/
function function_2b1d321f(player, downedplayer)
{
	if(player == downedplayer)
	{
		return;
	}
	downedplayer endon(#"disconnect");
	player endon(#"disconnect");
	level endon(#"doa_game_is_over");
	downedplayer endon(#"player_respawned");
	while(true)
	{
		wait(0.05);
		if(!isdefined(player.doa))
		{
			continue;
		}
		distsq = distancesquared(player.origin, downedplayer.origin);
		if(isdefined(player.doa.respawning) && player.doa.respawning)
		{
			distsq = 9999999;
		}
		if(isdefined(player.doa.vehicle))
		{
			distsq = 9999999;
		}
		if(!isalive(player))
		{
			distsq = 9999999;
		}
		if(distsq > 48 * 48)
		{
			found = undefined;
			foreach(var_9c71663b, savior in downedplayer.doa.var_b08ad9f8)
			{
				if(!isdefined(savior.player))
				{
					arrayremovevalue(downedplayer.doa.var_b08ad9f8, savior);
					break;
				}
				if(savior.player == player)
				{
					found = savior;
					break;
				}
			}
			if(isdefined(found))
			{
				arrayremovevalue(downedplayer.doa.var_b08ad9f8, found);
			}
			continue;
		}
		found = undefined;
		foreach(var_ce4d64c, savior in downedplayer.doa.var_b08ad9f8)
		{
			if(savior.player == player)
			{
				found = savior;
				break;
			}
		}
		if(!isdefined(found))
		{
			savior = spawnstruct();
			savior.player = player;
			savior.timestamp = gettime();
			downedplayer.doa.var_b08ad9f8[downedplayer.doa.var_b08ad9f8.size] = savior;
		}
	}
}

/*
	Name: function_b1958e58
	Namespace: namespace_831a4a7c
	Checksum: 0x474EB54
	Offset: 0x7E10
	Size: 0x3E8
	Parameters: 0
	Flags: Linked
*/
function function_b1958e58()
{
	self endon(#"disconnect");
	level endon(#"doa_game_is_over");
	self endon(#"player_respawned");
	self thread function_285fe1ad();
	foreach(var_804c02f2, player in getplayers())
	{
		if(player == self)
		{
			continue;
		}
		level thread function_2b1d321f(player, self);
	}
	self.doa.var_97c2af1a = 0;
	self.doa.var_70b102c6 = 0;
	self thread namespace_eaa992c::turnofffx("reviveAdvertise");
	self thread namespace_eaa992c::turnofffx("reviveActive");
	while(self.var_9ea856f6 > 0)
	{
		util::wait_network_frame();
		self.doa.var_22d93250 = 0;
		self.doa.var_6ccec7c0 = self.doa.var_b08ad9f8.size;
		curtime = gettime();
		foreach(var_7dcd64e1, savior in self.doa.var_b08ad9f8)
		{
			if(curtime - savior.timestamp > getdvarint("scr_doa_playrevive_delay", 250))
			{
				self.doa.var_22d93250++;
			}
		}
		if(self.doa.var_97c2af1a == 0 && self.doa.var_6ccec7c0 > 0)
		{
			self thread namespace_eaa992c::function_285a2999("reviveAdvertise");
			self thread namespace_eaa992c::turnofffx("reviveActive");
		}
		if(self.doa.var_97c2af1a > 0 && self.doa.var_6ccec7c0 == 0)
		{
			self thread namespace_eaa992c::turnofffx("reviveAdvertise");
			self thread namespace_eaa992c::turnofffx("reviveActive");
		}
		if(self.doa.var_22d93250 > 0 && self.doa.var_70b102c6 == 0)
		{
			self thread namespace_eaa992c::turnofffx("reviveAdvertise");
			self thread namespace_eaa992c::function_285a2999("reviveActive");
		}
		self.doa.var_97c2af1a = self.doa.var_6ccec7c0;
		self.doa.var_70b102c6 = self.doa.var_22d93250;
	}
}

/*
	Name: function_285fe1ad
	Namespace: namespace_831a4a7c
	Checksum: 0xF03A41E1
	Offset: 0x8200
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_285fe1ad()
{
	self endon(#"disconnect");
	level endon(#"doa_game_is_over");
	self waittill(#"player_respawned");
	if(mayspawnentity())
	{
		self playsound("evt_revived_respawn");
	}
}

/*
	Name: function_27202201
	Namespace: namespace_831a4a7c
	Checksum: 0x9148932
	Offset: 0x8268
	Size: 0x44C
	Parameters: 0
	Flags: Linked
*/
function function_27202201()
{
	self endon(#"disconnect");
	level endon(#"doa_game_is_over");
	self endon(#"player_respawned");
	self.doa.respawning = 1;
	self.var_9ea856f6 = level.doa.rules.var_575e919f;
	if(self.doa.fate == 2 || self.doa.fate == 11)
	{
		self.var_9ea856f6 = self.var_9ea856f6 - 10;
	}
	self thread function_b1958e58();
	self function_7f33210a();
	self thread namespace_eaa992c::function_285a2999("down_marker_" + function_ee495f41(self.entnum));
	while(self.var_9ea856f6 > 0)
	{
		wait(1);
		self.var_9ea856f6 = self.var_9ea856f6 - 1;
		if(self.doa.var_22d93250 > 0)
		{
			amount = int(math::clamp(self.doa.var_22d93250 - 1 + 3, 3, 5));
			if(mayspawnentity())
			{
				playsoundatposition("evt_revive", self.origin);
			}
			self thread namespace_eaa992c::function_285a2999("reviveCredit");
			self.var_9ea856f6 = self.var_9ea856f6 - amount;
			foreach(var_8927104f, savior in self.doa.var_b08ad9f8)
			{
				if(isdefined(savior.player))
				{
					savior.player.doa.var_faf30682 = savior.player.doa.var_faf30682 + 1;
				}
			}
		}
		self freezecontrols(1);
		players = function_5eb6e4d1();
		count = 0;
		for(i = 0; i < players.size; i++)
		{
			if(!isalive(players[i]) || (isdefined(players[i].doa.respawning) && players[i].doa.respawning) && players[i].doa.lives == 0)
			{
				count++;
			}
		}
		if(count == players.size)
		{
			level flag::set("doa_game_is_over");
			level notify(#"hash_d1f5acf7");
			self.doa.respawning = 0;
			self.var_9ea856f6 = 0;
			return;
		}
	}
	self.doa.respawning = 0;
	self.var_9ea856f6 = 0;
	self function_ad1d5fcb();
}

/*
	Name: function_c7471371
	Namespace: namespace_831a4a7c
	Checksum: 0xAA1DC807
	Offset: 0x86C0
	Size: 0x230
	Parameters: 0
	Flags: Linked
*/
function function_c7471371()
{
	self endon(#"disconnect");
	level endon(#"doa_game_is_over");
	self thread function_bbdc9bc0();
	self thread function_27202201();
	while(self.lives == 0 && !level flag::get("doa_game_is_over"))
	{
		players = function_5eb6e4d1();
		richestplayer = undefined;
		biggestlives = 1;
		foreach(var_a6707c05, player in players)
		{
			if(player == self)
			{
				continue;
			}
			if(isdefined(player.var_744a3931))
			{
				continue;
			}
			if(isdefined(player.doa.var_c5fe2763) && player.doa.var_c5fe2763)
			{
				continue;
			}
			if(player.doa.lives > biggestlives)
			{
				biggestlives = player.doa.lives;
				richestplayer = player;
			}
		}
		if(isdefined(richestplayer) && level flag::get("doa_round_active") && (isdefined(self.dead) && self.dead))
		{
			level thread function_2f150493(richestplayer, self);
			return;
		}
		wait(1);
	}
}

/*
	Name: function_79489c4c
	Namespace: namespace_831a4a7c
	Checksum: 0xAC6D5BDA
	Offset: 0x88F8
	Size: 0x66
	Parameters: 1
	Flags: Linked, Private
*/
private function function_79489c4c(time)
{
	self endon(#"disconnect");
	level endon(#"doa_game_is_over");
	self notify(#"hash_79489c4c");
	self endon(#"hash_79489c4c");
	self.doa.var_c5fe2763 = 1;
	wait(time);
	self.doa.var_c5fe2763 = undefined;
}

/*
	Name: function_c240f40e
	Namespace: namespace_831a4a7c
	Checksum: 0x8FA9E227
	Offset: 0x8968
	Size: 0x210
	Parameters: 3
	Flags: Linked, Private
*/
private function function_c240f40e(source, dest, orb)
{
	self endon(#"disconnect");
	dest endon(#"disconnect");
	level endon(#"doa_game_is_over");
	if(!isdefined(orb))
	{
		orb = spawn("script_model", self.origin + vectorscale((0, 0, 1), 50));
		orb.targetname = "_lifeLink";
		orb setmodel("tag_origin");
	}
	orb thread namespace_eaa992c::function_285a2999("trail_fast");
	orb thread doa_utility::function_a625b5d3(source);
	orb thread doa_utility::function_a625b5d3(dest);
	orb thread doa_utility::function_75e76155(source, "end_life_link");
	orb thread doa_utility::function_75e76155(dest, "playerLifeRespawn");
	orb thread doa_utility::function_783519c1("doa_game_is_over", 1);
	orb thread doa_utility::function_1bd67aef(4);
	end = dest.origin + vectorscale((0, 0, 1), 50);
	while(isdefined(orb))
	{
		orb moveto(end, 0.2, 0, 0);
		wait(0.5);
		if(isdefined(orb))
		{
			orb.origin = self.origin + vectorscale((0, 0, 1), 50);
		}
	}
}

/*
	Name: function_2f150493
	Namespace: namespace_831a4a7c
	Checksum: 0x9668880E
	Offset: 0x8B80
	Size: 0xA9C
	Parameters: 2
	Flags: Linked, Private
*/
private function function_2f150493(source, dest)
{
	self endon(#"disconnect");
	level endon(#"doa_game_is_over");
	if(dest.doa.lives > 0)
	{
		return;
	}
	if(!isdefined(source) || source.doa.lives < 1)
	{
		return;
	}
	if(isdefined(source.doa.var_c5fe2763) && source.doa.var_c5fe2763)
	{
		return;
	}
	if(isdefined(dest.doa.var_c5fe2763) && dest.doa.var_c5fe2763)
	{
		return;
	}
	source thread function_79489c4c(60);
	source thread function_c240f40e(source, dest);
	dest thread function_79489c4c(level.doa.rules.var_378eec79 + 5);
	wait(1);
	origin = source.origin;
	pickup = spawn("script_model", origin);
	pickup.targetname = "_stealLifeFrom";
	pickup.angles = source.angles;
	pickup setmodel(level.doa.extra_life_model);
	pickup thread namespace_eaa992c::function_285a2999("glow_white");
	source thread turnplayershieldon(1);
	pickup thread doa_utility::function_a625b5d3(source);
	pickup thread doa_utility::function_a625b5d3(dest);
	pickup thread doa_utility::function_75e76155(level, "doa_game_is_over");
	pickup moveto(dest.origin, 1, 0, 0);
	pickup thread namespace_1a381543::function_90118d8c("zmb_pickup_life_shimmer");
	pickup thread doa_utility::function_1bd67aef(3);
	pickup util::waittill_any_timeout(2, "movedone");
	source notify(#"end_life_link");
	pickup delete();
	if(!(isdefined(dest.doa.respawning) && dest.doa.respawning) || dest.doa.lives > 0)
	{
		return;
	}
	dest.doa.lives++;
	dest.doa.var_ec2548a9 = 1;
	dest.doa.var_67cd9d65++;
	source.doa.var_bfe4f859++;
	source.doa.lives--;
	if(source.doa.lives < 0)
	{
		source.doa.lives = 0;
	}
	if(isdefined(source.doa.vehicle))
	{
		if(math::cointoss())
		{
			/#
				doa_utility::debugmsg("" + source.name);
			#/
			level thread doa_pickups::directeditemawardto(source, level.doa.booster_model, 4);
		}
		else
		{
			/#
				doa_utility::debugmsg("" + source.name);
			#/
			level thread doa_pickups::directeditemawardto(source, level.doa.var_501f85b4, 3);
		}
		return;
	}
	roll = randomint(100);
	if(roll < 30 && gettime() > level.doa.var_d2b5415f)
	{
		level.doa.var_d2b5415f = gettime() + 60000;
		if(math::cointoss())
		{
			/#
				doa_utility::debugmsg("" + source.name);
			#/
			source thread namespace_1a381543::function_90118d8c("zmb_army_skeleton");
			for(i = 0; i < 10; i++)
			{
				spot = doa_utility::function_14a10231(source.origin);
				level thread doa_pickups::function_411355c0(30, source, spot);
				wait(0.5);
			}
		}
		else
		{
			/#
				doa_utility::debugmsg("" + source.name);
			#/
			source thread namespace_1a381543::function_90118d8c("zmb_army_robot");
			for(i = 0; i < 4; i++)
			{
				spot = doa_utility::function_14a10231(source.origin);
				level thread doa_pickups::function_411355c0(31, source, spot);
				wait(0.5);
			}
		}
	}
	else if(roll < 30)
	{
		wait(0.4);
		level thread doa_pickups::directeditemawardto(source, level.doa.var_97bbae9c);
		wait(0.4);
		level thread doa_pickups::directeditemawardto(source, level.doa.var_97bbae9c);
		wait(0.4);
		level thread doa_pickups::directeditemawardto(source, level.doa.var_97bbae9c);
		wait(0.4);
		level thread doa_pickups::directeditemawardto(source, level.doa.var_97bbae9c);
		level thread doa_pickups::directeditemawardto(source, level.doa.gloves);
	}
	else if(roll < 40)
	{
		/#
			doa_utility::debugmsg("" + source.name);
		#/
		level thread doa_pickups::directeditemawardto(source, level.doa.var_501f85b4, 2);
	}
	else if(roll < 50)
	{
		/#
			doa_utility::debugmsg("" + source.name);
		#/
		level thread doa_pickups::directeditemawardto(source, level.doa.booster_model, 3);
	}
	else if(roll < 60)
	{
		/#
			doa_utility::debugmsg("" + source.name);
		#/
		level thread doa_pickups::directeditemawardto(source, level.doa.var_3b704a85);
	}
	else if(roll < 70)
	{
		/#
			doa_utility::debugmsg("" + source.name);
		#/
		level thread doa_pickups::directeditemawardto(source, level.doa.var_f21ae3af);
	}
	else if(roll < 80)
	{
		/#
			doa_utility::debugmsg("" + source.name);
		#/
		level thread doa_pickups::directeditemawardto(source, level.doa.var_d6256e83);
	}
	else
	{
		/#
			doa_utility::debugmsg("" + source.name);
		#/
		level thread doa_pickups::directeditemawardto(source, level.doa.var_8d63e734, 2);
	}
}

/*
	Name: function_60123d1c
	Namespace: namespace_831a4a7c
	Checksum: 0x74C826D1
	Offset: 0x9628
	Size: 0x1B6
	Parameters: 0
	Flags: Linked
*/
function function_60123d1c()
{
	self notify(#"hash_cca1b1b9");
	self notify(#"kill_watch_player_in_combat");
	self notify(#"removehealthregen");
	self notify(#"nohealthoverlay");
	self notify(#"killspawnmonitor");
	self notify(#"killmonitorreloads");
	self notify(#"killrank");
	self notify(#"killspawnmonitor");
	self notify(#"killgrenademonitor");
	self notify(#"killhurtcheck");
	self notify(#"killteamchangemonitor");
	self notify(#"killhackermonitor");
	self notify(#"killreplaygunmonitor");
	self notify(#"track_riot_shield");
	self notify(#"killdtpmonitor");
	self notify(#"killgameendmonitor");
	self notify(#"killflashmonitor");
	self notify(#"killplayedtimemonitor");
	self notify(#"killplayersprintmonitor");
	self notify(#"killempmonitor");
	self notify(#"riotshieldtrackingstart");
	self notify(#"watch_remove_influencer");
	self notify(#"killoedmonitor");
	self notify(#"killmantlemonitor");
	self notify(#"new_cover_on_death_thread");
	self notify(#"bolttrackingstart");
	self notify(#"smoketrackingstart");
	self notify(#"emptrackingstart");
	self notify(#"proximitytrackingstart");
	self notify(#"insertiontrackingstart");
	self notify(#"grenadetrackingstart");
	self notify(#"hash_5c6cd2a");
	self notify(#"killonpainmonitor");
	self notify(#"killondeathmonitor");
	self notify(#"end_healthregen");
	level notify(#"stop_spawn_weight_debug");
}

/*
	Name: function_fea7ed75
	Namespace: namespace_831a4a7c
	Checksum: 0xD1EAD2AC
	Offset: 0x97E8
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function function_fea7ed75(num)
{
	if(!isdefined(num))
	{
		return (1, 1, 1);
	}
	switch(num)
	{
		case 0:
		{
			return (0, 1, 0);
		}
		case 1:
		{
			return (0, 0, 1);
		}
		case 2:
		{
			return (1, 0, 0);
		}
		case 3:
		{
			return (1, 1, 0);
		}
		default:
		{
			/#
				assert(0);
			#/
		}
	}
}

/*
	Name: function_e7e0aa7f
	Namespace: namespace_831a4a7c
	Checksum: 0x94FA2217
	Offset: 0x9878
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_e7e0aa7f(num)
{
	return "glow_" + function_ee495f41(num);
}

/*
	Name: function_ee495f41
	Namespace: namespace_831a4a7c
	Checksum: 0x81255FD2
	Offset: 0x98B0
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function function_ee495f41(num)
{
	switch(num)
	{
		case 0:
		{
			return "green";
		}
		case 1:
		{
			return "blue";
		}
		case 2:
		{
			return "red";
		}
		case 3:
		{
			return "yellow";
		}
		default:
		{
			/#
				assert(0);
			#/
		}
	}
}

/*
	Name: function_5eb6e4d1
	Namespace: namespace_831a4a7c
	Checksum: 0x7F81A97A
	Offset: 0x9940
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_5eb6e4d1()
{
	players = [];
	foreach(var_ae11f852, player in getplayers())
	{
		if(!isdefined(player))
		{
			continue;
		}
		if(isdefined(player.doa))
		{
			players[players.size] = player;
		}
	}
	return players;
}

/*
	Name: function_35f36dec
	Namespace: namespace_831a4a7c
	Checksum: 0x4D239E81
	Offset: 0x9A10
	Size: 0x19C
	Parameters: 1
	Flags: Linked
*/
function function_35f36dec(origin)
{
	players = function_5eb6e4d1();
	if(players.size == 0)
	{
		return undefined;
	}
	if(players.size == 1)
	{
		return players[0];
	}
	bestent = players[0];
	bestsq = 8192 * 8192;
	foreach(var_d38f1fba, player in players)
	{
		if(!isdefined(player) || !isalive(player))
		{
			continue;
		}
		if(isdefined(player.ignoreme) && player.ignoreme)
		{
			continue;
		}
		distsq = distancesquared(player.origin, origin);
		if(distsq < bestsq)
		{
			bestent = player;
			bestsq = distsq;
		}
	}
	return bestent;
}

/*
	Name: function_f300c612
	Namespace: namespace_831a4a7c
	Checksum: 0x21B585B3
	Offset: 0x9BB8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_f300c612()
{
	self endon(#"disconnect");
	self notify(#"hash_f300c612");
	self endon(#"hash_f300c612");
	while(true)
	{
		wait(0.05);
		if(isdefined(self.doa.var_f4a883ed) && self.doa.var_f4a883ed)
		{
			namespace_2f63e553::drawcylinder(self.origin, 50, 50, 1, (1, 0, 0));
		}
	}
}

/*
	Name: function_4519b17
	Namespace: namespace_831a4a7c
	Checksum: 0xDA029DD7
	Offset: 0x9C48
	Size: 0x1C8
	Parameters: 2
	Flags: Linked
*/
function function_4519b17(on, clear = 0)
{
	if(!isdefined(self) || !isdefined(self.doa))
	{
		return;
	}
	if(clear)
	{
		self.doa.var_f4a883ed = undefined;
		self disableinvulnerability();
		self.takedamage = 1;
	}
	if(isdefined(level.doa.var_e5a69065) && level.doa.var_e5a69065)
	{
		self thread function_f300c612();
	}
	if(on)
	{
		if(!isdefined(self.doa.var_f4a883ed))
		{
			self.doa.var_f4a883ed = 1;
			self enableinvulnerability();
			self.takedamage = 0;
		}
		else
		{
			/#
				assert(self.doa.var_f4a883ed > 0);
			#/
			self.doa.var_f4a883ed++;
		}
	}
	else if(isdefined(self.doa.var_f4a883ed))
	{
		self.doa.var_f4a883ed--;
	}
	if(!isdefined(self.doa.var_f4a883ed) || self.doa.var_f4a883ed == 0)
	{
		self.doa.var_f4a883ed = undefined;
		self disableinvulnerability();
		self.takedamage = 1;
	}
}

/*
	Name: function_139199e1
	Namespace: namespace_831a4a7c
	Checksum: 0x8B35897F
	Offset: 0x9E18
	Size: 0x452
	Parameters: 1
	Flags: Linked
*/
function function_139199e1(type)
{
	while(!level flag::get("doa_round_active"))
	{
		wait(0.05);
	}
	if(!isdefined(type))
	{
		if(randomint(100) > 50)
		{
			type = "fury";
		}
		else
		{
			type = "force";
		}
	}
	if(self.doa.fate == 10 && type == "fury")
	{
		type = "force";
	}
	if(self.doa.fate == 13 && type == "force")
	{
		type = "fury";
	}
	level thread doa_utility::function_c5f3ece8(&"DOA_CHALLENGE_VICTOR");
	wait(3);
	level.doa.var_9b77ca48 = 1;
	switch(type)
	{
		case "fury":
		{
			level thread doa_utility::function_37fb5c23(&"DOA_REWARD_FURY");
			var_213a57a7 = self.doa.default_weap;
			wait(2);
			level thread doa_fate::function_17fb777b(self, "zombietron_statue_fury", 0.5, &donothing);
			self.doa.default_weap = level.doa.var_69899304;
			self function_d5f89a15(self.doa.default_weap.name);
			while(level flag::get("doa_round_active"))
			{
				wait(0.05);
			}
			self.doa.default_weap = var_213a57a7;
			self function_d5f89a15(self.doa.default_weap.name);
			break;
		}
		case "force":
		{
			level thread doa_utility::function_37fb5c23(&"DOA_REWARD_FORCE");
			wait(1);
			level thread doa_pickups::directeditemawardto(self, level.doa.booster_model, 6);
			wait(1);
			level thread doa_fate::function_17fb777b(self, "zombietron_statue_force", 0.5, &donothing);
			self.doa.var_480b6280 = 1;
			var_2b4d4c09 = self.doa.default_movespeed;
			self.doa.default_movespeed = level.doa.rules.var_b92b82b;
			self setmovespeedscale(self.doa.default_movespeed);
			while(level flag::get("doa_round_active"))
			{
				wait(0.05);
			}
			self.doa.var_480b6280 = undefined;
			self.doa.default_movespeed = var_2b4d4c09;
			self setmovespeedscale(self.doa.default_movespeed);
			break;
		}
	}
	level thread doa_utility::function_c5f3ece8(&"DOA_REWARD_EXPIRE");
	wait(2);
	level thread doa_utility::function_37fb5c23(&"DOA_REWARD_EXPIRE2");
	wait(7);
	level.doa.var_9b77ca48 = undefined;
	level.doa.var_c03fe5f1 = undefined;
}

/*
	Name: donothing
	Namespace: namespace_831a4a7c
	Checksum: 0x99EC1590
	Offset: 0xA278
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function donothing()
{
}

