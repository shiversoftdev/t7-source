// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_fate;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;

#namespace namespace_2f63e553;

/*
	Name: function_40206fdf
	Namespace: namespace_2f63e553
	Checksum: 0x5D704E08
	Offset: 0x770
	Size: 0x288
	Parameters: 0
	Flags: Linked
*/
function function_40206fdf()
{
	level endon(#"hash_1684cf71");
	while(true)
	{
		player = getplayers()[0];
		wait(0.05);
		if(level.var_cee29ae7 != 1 || !isdefined(player))
		{
			continue;
		}
		var_a67ace85 = randomint(255) << 22;
		if(player stancebuttonpressed())
		{
			var_a67ace85 = var_a67ace85 | 1;
		}
		if(player jumpbuttonpressed())
		{
			var_a67ace85 = var_a67ace85 | 65536;
		}
		lstick = player getnormalizedmovement();
		if(lstick[0] > 0.5)
		{
			var_a67ace85 = var_a67ace85 | 2;
		}
		if(lstick[0] < -0.5)
		{
			var_a67ace85 = var_a67ace85 | 131072;
		}
		if(lstick[1] > 0.5)
		{
			var_a67ace85 = var_a67ace85 | 4;
		}
		if(lstick[1] < -0.5)
		{
			var_a67ace85 = var_a67ace85 | 262144;
		}
		rstick = player getnormalizedcameramovement();
		if(rstick[0] > 0.5)
		{
			var_a67ace85 = var_a67ace85 | 8;
		}
		if(rstick[0] < -0.5)
		{
			var_a67ace85 = var_a67ace85 | 524288;
		}
		if(rstick[1] > 0.5)
		{
			var_a67ace85 = var_a67ace85 | 16;
		}
		if(rstick[1] < -0.5)
		{
			var_a67ace85 = var_a67ace85 | 1048576;
		}
		level clientfield::set("debugCameraPayload", var_a67ace85);
	}
}

/*
	Name: function_35d58a26
	Namespace: namespace_2f63e553
	Checksum: 0xD11245EC
	Offset: 0xA00
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function function_35d58a26()
{
	while(namespace_831a4a7c::function_5eb6e4d1().size == 0)
	{
		wait(0.05);
	}
	doa_utility::debugmsg("Hail to the King baby!");
	foreach(player in namespace_831a4a7c::function_5eb6e4d1())
	{
		player thread function_92c840a6(1);
	}
}

/*
	Name: setupdevgui
	Namespace: namespace_2f63e553
	Checksum: 0xCCB7ECE2
	Offset: 0xAE8
	Size: 0x4A4
	Parameters: 0
	Flags: Linked
*/
function setupdevgui()
{
	/#
		execdevgui("");
		level thread devguithink();
		level thread function_40206fdf();
		level.var_cee29ae7 = 0;
		level.var_bbb7743c = 0;
		level.doa.var_e5a69065 = 0;
		rootmenu = "";
		index = 1;
		var_9ba2319f = index;
		var_9c0bafd1 = level.doa.rules.var_88c0b67b;
		foreach(arena in level.doa.arenas)
		{
			if(isdefined(arena.var_63b4dab3) && arena.var_63b4dab3)
			{
				continue;
			}
			name = (((((arena.name + "") + var_9ba2319f) + "") + var_9c0bafd1) + "") + index;
			index++;
			cmd = (((rootmenu + name) + "") + arena.name) + "";
			adddebugcommand(cmd);
			var_9ba2319f = var_9ba2319f + level.doa.rules.var_88c0b67b;
			var_9c0bafd1 = var_9c0bafd1 + level.doa.rules.var_88c0b67b;
		}
		if(isdefined(world.var_e5cf1b41))
		{
			level.doa.dev_level_skipped = world.var_e5cf1b41 * 4;
			doa_utility::debugmsg((("" + world.var_e5cf1b41) + "") + level.doa.dev_level_skipped);
			flag::clear("");
			setdvar("", "");
			wait(1);
			doa_utility::killallenemy();
			world.var_e5cf1b41 = undefined;
			doa_utility::debugmsg("");
			foreach(player in namespace_831a4a7c::function_5eb6e4d1())
			{
				player thread function_92c840a6(5);
			}
		}
		else
		{
			doa_utility::debugmsg("");
		}
	#/
	if(getdvarint("scr_doa_kingme_soak_think", 0))
	{
		setdvar("scr_doa_kingme_soak_think", 0);
		setdvar("scr_doa_soak_think", 1);
		level thread function_35d58a26();
	}
	if(getdvarint("scr_doa_soak_think", 0) && (!(isdefined(level.var_1575b6db) && level.var_1575b6db)))
	{
		level thread function_a3bba13d();
	}
}

/*
	Name: function_92c840a6
	Namespace: namespace_2f63e553
	Checksum: 0xAE695569
	Offset: 0xF98
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_92c840a6(delay = 0.1)
{
	self notify(#"hash_92c840a6");
	self endon(#"hash_92c840a6");
	level endon(#"hash_a291d1ee");
	self endon(#"disconnect");
	wait(delay);
	while(true)
	{
		if(self.doa.lives <= 3)
		{
			self.doa.lives = 9;
		}
		if(self.doa.bombs <= 1)
		{
			self.doa.bombs = 9;
		}
		if(self.doa.boosters <= 1)
		{
			self.doa.boosters = 9;
		}
		wait(0.05);
	}
}

/*
	Name: function_a4d5519a
	Namespace: namespace_2f63e553
	Checksum: 0x8D98C1B0
	Offset: 0x1098
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function function_a4d5519a(pickup)
{
	self endon(#"disconnect");
	pickup endon(#"death");
	wait(randomfloatrange(0.1, 1));
	if(self isinmovemode("ufo", "noclip"))
	{
		return;
	}
	level thread doa_utility::debug_circle(pickup.origin + vectorscale((0, 0, 1), 20), 30, 3, namespace_831a4a7c::function_fea7ed75(self.entnum));
	level thread doa_utility::debug_line(self.origin + vectorscale((0, 0, 1), 20), pickup.origin + vectorscale((0, 0, 1), 20), 3, namespace_831a4a7c::function_fea7ed75(self.entnum));
	yaw = doa_utility::function_fa8a86e8(self, pickup);
	if(!isdefined(yaw))
	{
		return;
	}
	angles = (0, yaw, 0);
	self setplayerangles(angles);
	wait(2);
	yaw = doa_utility::function_fa8a86e8(self, pickup);
	if(!isdefined(yaw))
	{
		return;
	}
	angles = (0, yaw, 0);
	self setplayerangles(angles);
	self.doa.var_3be905bb = 1;
	doa_utility::debugmsg((("Bot is boosting at pickup:" + pickup.def.gdtname) + ".  Boosts Left:") + self.doa.boosters);
}

/*
	Name: function_733651c
	Namespace: namespace_2f63e553
	Checksum: 0x321D8385
	Offset: 0x12E0
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function function_733651c()
{
	self endon(#"disconnect");
	self notify(#"hash_733651c");
	self endon(#"hash_733651c");
	level endon(#"hash_e20ba07c");
	while(isdefined(self))
	{
		if(isdefined(self.doa.boosters) && self.doa.boosters)
		{
			pickupsitems = getentarray("a_pickup_item", "script_noteworthy");
			if(pickupsitems.size > 0)
			{
				var_a49668c4 = pickupsitems[randomint(pickupsitems.size)];
			}
			if(isdefined(var_a49668c4) && isdefined(var_a49668c4.trigger))
			{
				self thread function_a4d5519a(var_a49668c4);
			}
		}
		wait(randomint(10));
	}
}

/*
	Name: function_7abdb1e8
	Namespace: namespace_2f63e553
	Checksum: 0x9C92CCFE
	Offset: 0x1400
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_7abdb1e8()
{
	level notify(#"hash_7abdb1e8");
	level endon(#"hash_7abdb1e8");
	level waittill(#"hash_e20ba07c");
	level.var_1575b6db = 0;
	doa_utility::debugmsg("DOA Soak Test [OFF]");
}

/*
	Name: function_f71d59c
	Namespace: namespace_2f63e553
	Checksum: 0x9D9D9DAB
	Offset: 0x1460
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_f71d59c()
{
	level notify(#"hash_f71d59c");
	level endon(#"hash_f71d59c");
	level waittill(#"hash_24d3a44");
	adddebugcommand("set devgui_bot remove_all");
}

/*
	Name: function_a3bba13d
	Namespace: namespace_2f63e553
	Checksum: 0x68E748D4
	Offset: 0x14B0
	Size: 0x850
	Parameters: 0
	Flags: Linked
*/
function function_a3bba13d()
{
	level notify(#"hash_a3bba13d");
	level endon(#"hash_a3bba13d");
	level endon(#"hash_e20ba07c");
	level.botcount = 0;
	level thread function_7abdb1e8();
	level.var_1575b6db = 1;
	level thread function_f71d59c();
	doa_utility::debugmsg("DOA Soak Test [ON]");
	adddebugcommand("set bot_AllowMovement 0; set bot_PressAttackBtn 1; set bot_PressMeleeBtn 0; set scr_botsAllowKillstreaks 0; set bot_AllowGrenades 1");
	while(level.var_1575b6db)
	{
		foreach(guy in namespace_831a4a7c::function_5eb6e4d1())
		{
			if(!isdefined(guy))
			{
				continue;
			}
			guy thread function_733651c();
			if(guy isinmovemode("ufo", "noclip"))
			{
				wait(0.4);
				continue;
			}
			roll = randomint(100);
			if(roll > 90)
			{
				guy setplayerangles((0, randomint(360), 0));
				guy.doa.var_3be905bb = 1;
				doa_utility::debugmsg("Bot is boosting.  Boosts Left:" + guy.doa.boosters);
			}
			if(roll < 10)
			{
				guy.doa.var_f2870a9e = 1;
				doa_utility::debugmsg("Bot is dropping nuke.  Bombs Left:" + guy.doa.bombs);
			}
		}
		if(getdvarint("scr_doa_soak_think", 0) > 1)
		{
			wait(randomintrange(2, 6));
		}
		else
		{
			wait(randomintrange(5, 20));
		}
		if(level flag::get("doa_game_is_over"))
		{
			continue;
		}
		if(!level flag::get("doa_game_is_running"))
		{
			continue;
		}
		level thread function_f71d59c();
		if(level.botcount > 0 && randomint(100) > 50)
		{
			adddebugcommand("set devgui_bot remove");
			level.botcount--;
			doa_utility::debugmsg("Bot is being removed.   Count=" + level.botcount);
		}
		else if(level.botcount < 3 && randomint(100) > 70)
		{
			if(getplayers().size < 4)
			{
				adddebugcommand("set devgui_bot add");
				level.botcount++;
				doa_utility::debugmsg("Bot is being added.  Count=" + level.botcount);
			}
		}
		if(level.doa.var_b1698a42.var_cadf4b04.size > 0)
		{
			i = 0;
			foreach(guy in namespace_831a4a7c::function_5eb6e4d1())
			{
				if(guy arecontrolsfrozen() == 0)
				{
					guy setorigin(level.doa.var_b1698a42.var_cadf4b04[i].origin);
					i++;
				}
			}
			wait(30);
		}
		if(isdefined(level.doa.boss) && (isdefined(level.doa.boss.takedamage) && level.doa.boss.takedamage))
		{
			level.doa.boss dodamage(30000, level.doa.boss.origin);
		}
		if(level flag::get("doa_round_active") && getdvarint("scr_doa_soak_think", 0) > 1)
		{
			flag::clear("doa_round_active");
			doa_utility::killallenemy();
		}
		if(!level flag::get("doa_round_active"))
		{
			if(level.doa.exits_open.size > 0)
			{
				if(getdvarint("scr_doa_soak_think", 0) > 1)
				{
					wait(0.2);
					doa_utility::killallenemy();
				}
				else
				{
					wait(5);
				}
				foreach(exit in level.doa.exits_open)
				{
					exit thread doa_utility::function_a4d1f25e("trigger", randomfloatrange(0.5, 1));
				}
			}
			else if(isdefined(level.doa.teleporter) && isdefined(level.doa.teleporter.trigger))
			{
				if(getdvarint("scr_doa_soak_think", 0) > 1)
				{
					wait(0.2);
					doa_utility::killallenemy();
				}
				else
				{
					wait(5);
				}
				if(isdefined(level.doa.teleporter) && isdefined(level.doa.teleporter.trigger))
				{
					level.doa.teleporter.trigger notify(#"trigger");
				}
			}
		}
	}
}

/*
	Name: function_f24eee41
	Namespace: namespace_2f63e553
	Checksum: 0x34C478BD
	Offset: 0x1D08
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_f24eee41()
{
	level endon(#"hash_da8786df");
	lockspot = self.origin;
	while(true)
	{
		self setorigin(lockspot);
		wait(0.05);
	}
}

/*
	Name: devguithink
	Namespace: namespace_2f63e553
	Checksum: 0x3480E02E
	Offset: 0x1D60
	Size: 0x16E8
	Parameters: 0
	Flags: Linked
*/
function devguithink()
{
	setdvar("zombie_devgui", "");
	setdvar("scr_spawn_pickup", "");
	setdvar("scr_spawn_room_name", "");
	setdvar("scr_spawn_room", "");
	while(true)
	{
		if(getdvarint("scr_doa_kingme_soak_think", 0))
		{
			setdvar("scr_doa_kingme_soak_think", 0);
			setdvar("scr_doa_soak_think", 1);
			doa_utility::debugmsg("Hail to the King baby!");
			foreach(player in namespace_831a4a7c::function_5eb6e4d1())
			{
				player thread function_92c840a6();
			}
		}
		if(getdvarint("scr_doa_soak_think", 0))
		{
			if(!(isdefined(level.var_1575b6db) && level.var_1575b6db))
			{
				level thread function_a3bba13d();
			}
		}
		else if(isdefined(level.var_1575b6db) && level.var_1575b6db)
		{
			level notify(#"hash_e20ba07c");
		}
		cmd = getdvarstring("zombie_devgui");
		if(cmd == "")
		{
			wait(0.5);
			continue;
		}
		doa_utility::debugmsg(("Devgui Cmd-->") + cmd);
		switch(cmd)
		{
			case "outro":
			{
				players = namespace_831a4a7c::function_5eb6e4d1();
				for(i = 0; i < players.size; i++)
				{
					players[i].doa.lives = 0;
					players[i] dodamage(players[i].health + 100, players[i].origin);
				}
				break;
			}
			case "joyride":
			{
				level.doa.rules.var_cd899ae7 = 9999;
				level.doa.rules.var_91e6add5 = 9999;
				level.doa.rules.var_7196fe3d = 9999;
				level.doa.rules.var_8b15034d = 9999;
				break;
			}
			case "uploadstat":
			{
				if(getdvarint("scr_doa_min_level_stat_upload", 45) == 45)
				{
					setdvar("scr_doa_min_level_stat_upload", 1);
					doa_utility::debugmsg("UploadStats Min Level set to 1");
				}
				else
				{
					setdvar("scr_doa_min_level_stat_upload", 45);
					doa_utility::debugmsg("UploadStats Min Level set to " + 45);
				}
				break;
			}
			case "infinite":
			{
				setdvar("scr_doa_infinite_round", !getdvarint("scr_doa_infinite_round", 0));
				break;
			}
			case "poleme":
			{
				setdvar("scr_doa_max_poles", !getdvarint("scr_doa_max_poles", 0));
				break;
			}
			case "hazardShow":
			{
				setdvar("scr_doa_show_hazards", !getdvarint("scr_doa_show_hazards", 0));
				break;
			}
			case "bossonly":
			{
				setdvar("scr_doa_onlyboss_during_challenge", !getdvarint("scr_doa_onlyboss_during_challenge", 0));
				break;
			}
			case "doasoak":
			{
				setdvar("scr_doa_soak_think", (getdvarint("scr_doa_soak_think", 0) > 0 ? 0 : 1));
				break;
			}
			case "doafastsoak":
			{
				setdvar("scr_doa_soak_think", 2);
				break;
			}
			case "fixedCamDebug":
			{
				if(level.var_cee29ae7 != 1)
				{
					level.var_cee29ae7 = 1;
				}
				else
				{
					level.var_cee29ae7 = 0;
				}
				doa_utility::debugmsg(("camera debug FIX ARENA CAM LOC [" + (level.var_cee29ae7 == 1 ? "ON" : "OFF")) + "]");
				level clientfield::set("debugCamera", level.var_cee29ae7);
				level notify(#"hash_da8786df");
				if(level.var_cee29ae7 == 1)
				{
					foreach(player in getplayers())
					{
						player thread function_f24eee41();
					}
				}
				break;
			}
			case "fixedCamOn":
			{
				level.var_bbb7743c = !level.var_bbb7743c;
				doa_utility::debugmsg(("camera FIX CAM[" + (level.var_bbb7743c ? "ON" : "OFF")) + "]");
				level clientfield::set("fixCameraOn", (level.var_bbb7743c ? 1 : 0));
				break;
			}
			case "money":
			{
				doa_utility::debugmsg("big money, BIG PRIZES!");
				level thread doa_pickups::spawnmoneyglob();
				level thread doa_pickups::spawnmoneyglob(1);
				break;
			}
			case "gem":
			{
				doa_utility::debugmsg("Gem Launching!");
				players = namespace_831a4a7c::function_5eb6e4d1();
				for(i = 0; i < players.size; i++)
				{
					level thread doa_pickups::spawnubertreasure(players[i].origin, 4, 10, 1, 1);
				}
				break;
			}
			case "gemX":
			{
				doa_utility::debugmsg("Gem Launching!");
				players = namespace_831a4a7c::function_5eb6e4d1();
				scale = int(getdvarstring("scr_spawn_pickup"));
				for(i = 0; i < players.size; i++)
				{
					level thread doa_pickups::spawnubertreasure(players[i].origin, 1, 10, 1, 1, scale);
				}
				break;
			}
			case "king":
			{
				doa_utility::debugmsg("Hail to the King baby!");
				foreach(player in namespace_831a4a7c::function_5eb6e4d1())
				{
					player thread function_92c840a6();
				}
				break;
			}
			case "unking":
			{
				level notify(#"hash_a291d1ee");
				break;
			}
			case "pickup":
			{
				doa_utility::debugmsg("spawning pickup " + getdvarstring("scr_spawn_pickup"));
				level doa_pickups::function_3238133b(getdvarstring("scr_spawn_pickup"));
				break;
			}
			case "magic_room":
			{
				level.doa.forced_magical_room = getdvarint("scr_spawn_room");
				if(level.doa.forced_magical_room == 13)
				{
					level.doa.var_94073ca5 = getdvarstring("scr_spawn_room_name");
				}
				if(level.doa.forced_magical_room == 10)
				{
					players = namespace_831a4a7c::function_5eb6e4d1();
					for(i = 1; i < players.size; i++)
					{
						if(players[i].doa.fate == 0)
						{
							players[i] doa_fate::awardfate(randomintrange(1, 5));
						}
					}
				}
				flag::clear("doa_round_active");
				doa_utility::function_1ced251e();
				setdvar("scr_spawn_room_name", "");
				setdvar("scr_spawn_room", "");
				break;
			}
			case "UnderBossRound":
			{
				level.doa.var_bae65231 = 1;
				flag::clear("doa_round_active");
				doa_utility::function_1ced251e();
				break;
			}
			case "bossRound":
			{
				level.doa.var_602737ab = 1;
				flag::clear("doa_round_active");
				doa_utility::function_1ced251e();
				break;
			}
			case "fate":
			{
				type = getdvarint("scr_spawn_pickup");
				doa_utility::debugmsg(("Fating you ->") + type);
				level.doa.fates_have_been_chosen = 1;
				players = namespace_831a4a7c::function_5eb6e4d1();
				for(i = 0; i < players.size; i++)
				{
					if(type < 10)
					{
						players[i] doa_fate::awardfate(type);
						continue;
					}
					type1 = type - 9;
					players[i] doa_fate::awardfate(type1);
					wait(1);
					players[i] doa_fate::awardfate(type);
				}
				break;
			}
			case "all_pickups":
			{
				doa_utility::debugmsg("Spawning All Pickups");
				for(i = 0; i < level.doa.pickups.items.size; i++)
				{
					level doa_pickups::function_3238133b(level.doa.pickups.items[i].gdtname);
				}
				break;
			}
			case "nurgles":
			{
				doa_utility::debugmsg("Spawning Nurgles");
				level thread doa_pickups::function_eaf49506(32, undefined, 120);
				break;
			}
			case "arena":
			{
				world.var_e5cf1b41 = namespace_3ca3c537::function_5835533a(getdvarstring("scr_spawn_room_name"));
				doa_utility::debugmsg((("Advance To Arena =" + getdvarstring("scr_spawn_room_name")) + " idx=") + world.var_e5cf1b41);
				setdvar("scr_spawn_room_name", "");
				adddebugcommand("map_restart");
				break;
			}
			case "warp":
			{
				flag::clear("doa_round_active");
				level.doa.var_b5c260bb = namespace_3ca3c537::function_5835533a(getdvarstring("scr_spawn_room_name"));
				level.doa.arena_round_number = level.doa.rules.var_88c0b67b - 1;
				round_number = level.doa.var_b5c260bb * level.doa.rules.var_88c0b67b;
				foreach(room in level.doa.var_ec2bff7b)
				{
					if(round_number > room.var_5281efe5)
					{
						room.var_57ce7582[room.var_57ce7582.size] = round_number;
					}
				}
				var_7dce6dce = 1;
				while(var_7dce6dce)
				{
					var_7dce6dce = 0;
					foreach(room in level.doa.var_ec2bff7b)
					{
						if(isdefined(room.var_6f369ab4) && room.var_57ce7582.size >= room.var_6f369ab4)
						{
							arrayremovevalue(level.doa.var_ec2bff7b, room, 0);
							var_7dce6dce = 1;
							break;
						}
					}
				}
				level.doa.zombie_move_speed = level.doa.rules.var_e626be31 + (round_number * level.doa.var_c9e1c854);
				level.doa.zombie_health = level.doa.rules.var_6fa02512 + (round_number * level.doa.zombie_health_inc);
				doa_utility::debugmsg((("Warp To Arena =" + getdvarstring("scr_spawn_room_name")) + " idx=") + level.doa.var_b5c260bb);
				setdvar("scr_spawn_room_name", "");
				doa_utility::function_1ced251e();
				break;
			}
			case "aispawn":
			{
				if(isdefined(level.doa.var_e6fd0e17))
				{
					[[level.doa.var_e6fd0e17]](getdvarstring("scr_spawn_name"));
				}
				break;
			}
			case "round":
			{
				level.doa.dev_level_skipped = getdvarint(#"hash_d81b6e19") - 1;
				flag::clear("doa_round_active");
				setdvar("timescale", "10");
				doa_utility::function_1ced251e();
				break;
			}
			case "lap_next":
			{
				level.doa.var_da96f13c++;
				level.doa.round_number = level.doa.round_number + 64;
				flag::clear("doa_round_active");
				doa_utility::function_1ced251e();
				break;
			}
			case "round_next":
			{
				flag::clear("doa_round_active");
				doa_utility::function_1ced251e();
				break;
			}
			case "open_exits":
			{
				level.doa.var_638a5ffc = "all";
				flag::clear("doa_round_active");
				doa_utility::function_1ced251e();
				break;
			}
			case "kill_all_enemy":
			{
				flag::clear("doa_round_active");
				doa_utility::killallenemy(1);
				doa_utility::function_1ced251e();
				doa_utility::clearallcorpses();
				level clientfield::set("cleanupGiblets", 1);
				break;
			}
			case "kill":
			{
				doa_utility::debugmsg("death has been notified ...");
				players = namespace_831a4a7c::function_5eb6e4d1();
				if(players.size == 1)
				{
					player = players[0];
				}
				else
				{
					player = players[randomint(players.size)];
				}
				player dodamage(player.health + 100, player.origin);
				break;
			}
			case "kill_all":
			{
				doa_utility::debugmsg("death to all...");
				players = namespace_831a4a7c::function_5eb6e4d1();
				for(i = 0; i < players.size; i++)
				{
					players[i] dodamage(players[i].health + 100, players[i].origin);
				}
				break;
			}
			case "debug_invul":
			{
				level.doa.var_e5a69065 = !level.doa.var_e5a69065;
				break;
			}
		}
		setdvar("zombie_devgui", "");
	}
}

/*
	Name: function_5e6b8376
	Namespace: namespace_2f63e553
	Checksum: 0x879EDB88
	Offset: 0x3450
	Size: 0x200
	Parameters: 4
	Flags: Linked
*/
function function_5e6b8376(origin, radius, time, color = (0, 1, 0))
{
	/#
		level endon(#"hash_48b870e4");
		self endon(#"death");
		hangtime = 0.05;
		circleres = 16;
		hemires = circleres / 2;
		circleinc = 360 / circleres;
		circleres++;
		timer = gettime() + (time * 1000);
		while(gettime() < timer)
		{
			plotpoints = [];
			rad = 0;
			wait(hangtime);
			players = getplayers();
			angletoplayer = vectortoangles(origin - players[0].origin);
			for(i = 0; i < circleres; i++)
			{
				plotpoints[plotpoints.size] = (origin + (vectorscale(anglestoforward(angletoplayer + (rad, 90, 0)), radius))) + vectorscale((0, 0, 1), 12);
				rad = rad + circleinc;
			}
			plotpoints(plotpoints, color, hangtime);
		}
	#/
}

/*
	Name: plotpoints
	Namespace: namespace_2f63e553
	Checksum: 0xBAB68229
	Offset: 0x3658
	Size: 0xFA
	Parameters: 3
	Flags: Linked
*/
function plotpoints(plotpoints, var_c75b4e78, server_frames = 1)
{
	/#
		if(plotpoints.size == 0)
		{
			return;
		}
		lastpoint = plotpoints[0];
		for(server_frames = int(server_frames); server_frames; server_frames--)
		{
			for(i = 1; i < plotpoints.size; i++)
			{
				line(lastpoint, plotpoints[i], var_c75b4e78, 1, server_frames);
				lastpoint = plotpoints[i];
			}
			wait(0.05);
		}
	#/
}

/*
	Name: drawcylinder
	Namespace: namespace_2f63e553
	Checksum: 0xC42DB679
	Offset: 0x3760
	Size: 0x2FA
	Parameters: 5
	Flags: Linked
*/
function drawcylinder(pos, rad, height, server_frames = 1, color = (0, 0, 0))
{
	/#
		self endon(#"stop_cylinder");
		self endon(#"death");
		currad = rad;
		curheight = height;
		for(server_frames = int(server_frames); server_frames; server_frames--)
		{
			for(r = 0; r < 20; r++)
			{
				theta = (r / 20) * 360;
				theta2 = ((r + 1) / 20) * 360;
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0), color);
				line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight), color);
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight), color);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: debugorigin
	Namespace: namespace_2f63e553
	Checksum: 0xD8D2482E
	Offset: 0x3A68
	Size: 0x1D0
	Parameters: 0
	Flags: None
*/
function debugorigin()
{
	/#
		self notify(#"hash_707e044");
		self endon(#"hash_707e044");
		self endon(#"death");
		for(;;)
		{
			forward = anglestoforward(self.angles);
			forwardfar = vectorscale(forward, 30);
			forwardclose = vectorscale(forward, 20);
			right = anglestoright(self.angles);
			left = vectorscale(right, -10);
			right = vectorscale(right, 10);
			line(self.origin, self.origin + forwardfar, (0.9, 0.7, 0.6), 0.9);
			line(self.origin + forwardfar, (self.origin + forwardclose) + right, (0.9, 0.7, 0.6), 0.9);
			line(self.origin + forwardfar, (self.origin + forwardclose) + left, (0.9, 0.7, 0.6), 0.9);
			wait(0.05);
		}
	#/
}

/*
	Name: function_a0e51d80
	Namespace: namespace_2f63e553
	Checksum: 0x963F7917
	Offset: 0x3C40
	Size: 0x1C0
	Parameters: 4
	Flags: Linked
*/
function function_a0e51d80(point, timesec, size, color)
{
	end = gettime() + (timesec * 1000);
	halfwidth = int(size / 2);
	l1 = point + (halfwidth * -1, 0, 0);
	l2 = point + (halfwidth, 0, 0);
	var_5e2b69e1 = point + (0, halfwidth * -1, 0);
	var_842de44a = point + (0, halfwidth, 0);
	h1 = point + (0, 0, halfwidth * -1);
	h2 = point + (0, 0, halfwidth);
	while(end > gettime())
	{
		/#
			line(l1, l2, color, 1, 0, 1);
			line(var_5e2b69e1, var_842de44a, color, 1, 0, 1);
			line(h1, h2, color, 1, 0, 1);
		#/
		wait(0.05);
	}
}

/*
	Name: debugline
	Namespace: namespace_2f63e553
	Checksum: 0xBBBDD605
	Offset: 0x3E08
	Size: 0x88
	Parameters: 4
	Flags: Linked
*/
function debugline(p1, p2, timesec, color)
{
	end = gettime() + (timesec * 1000);
	while(end > gettime())
	{
		/#
			line(p1, p2, color, 1, 0, 1);
		#/
		wait(0.05);
	}
}

