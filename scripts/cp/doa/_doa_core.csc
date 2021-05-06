// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\cp_doa_bo3_fx;
#using scripts\cp\cp_doa_bo3_sound;
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_camera;
#using scripts\cp\doa\_doa_core;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_vortex;
#using scripts\shared\blood;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\math_shared;
#using scripts\shared\player_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_693feb87;

/*
	Name: main
	Namespace: namespace_693feb87
	Checksum: 0x2A62E304
	Offset: 0xA28
	Size: 0x144C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.doa = spawnstruct();
	callback::on_spawned(&on_player_spawned);
	namespace_3ca3c537::init();
	namespace_eaa992c::init();
	namespace_1a381543::init();
	namespace_64c6b720::init();
	namespace_ad544aeb::function_d22ceb57(vectorscale((1, 0, 0), 75), 600);
	doa_pickups::init();
	level.doa.var_160ae6c6 = 1;
	level.doa.roundnumber = 1;
	level.doa.flipped = 0;
	level.doa.hazards = [];
	level.disablewatersurfacefx = 1;
	level.gibresettime = 0.5;
	level.gibmaxcount = 3;
	level.gibtimer = 0;
	level.gibcount = 0;
	level.var_ff8aba3b = vectorscale((0, 0, 1), 4);
	level.var_96344b03 = 3;
	level.var_46418da4 = 2;
	level.var_bd436f37 = 0.5;
	level.var_e3119165 = array("zombietron_gib_chunk_fat", "zombietron_gib_chunk_bone_01", "zombietron_gib_chunk_bone_02", "zombietron_gib_chunk_bone_03", "zombietron_gib_chunk_flesh_01", "zombietron_gib_chunk_flesh_02", "zombietron_gib_chunk_flesh_03", "zombietron_gib_chunk_meat_01", "zombietron_gib_chunk_meat_02", "zombietron_gib_chunk_meat_03");
	clientfield::register("world", "podiumEvent", 1, 1, "int", &function_10093dd7, 0, 0);
	clientfield::register("world", "overworld", 1, 1, "int", &function_a6c926fc, 0, 0);
	clientfield::register("world", "scoreMenu", 1, 1, "int", &function_d3b4c89d, 0, 0);
	clientfield::register("world", "overworldlevel", 1, 5, "int", &function_22de3f7, 0, 0);
	clientfield::register("world", "roundnumber", 1, 10, "int", &function_e3bb35e, 0, 0);
	clientfield::register("world", "roundMenu", 1, 1, "int", &function_2eaf8a3f, 0, 0);
	clientfield::register("world", "teleportMenu", 1, 1, "int", &function_c97b97ae, 0, 0);
	clientfield::register("world", "numexits", 1, 3, "int", &function_c86d63f6, 0, 0);
	clientfield::register("world", "gameover", 1, 1, "int", &function_91976e37, 0, 0);
	clientfield::register("world", "doafps", 1, 1, "int", &function_e63081e8, 0, 0);
	clientfield::register("scriptmover", "play_fx", 1, 7, "int", &function_351aa01c, 0, 0);
	clientfield::register("allplayers", "play_fx", 1, 7, "int", &function_351aa01c, 0, 0);
	clientfield::register("actor", "play_fx", 1, 7, "int", &function_351aa01c, 0, 0);
	clientfield::register("vehicle", "play_fx", 1, 7, "int", &function_351aa01c, 0, 0);
	clientfield::register("scriptmover", "off_fx", 1, 7, "int", &function_33760903, 0, 0);
	clientfield::register("allplayers", "off_fx", 1, 7, "int", &function_33760903, 0, 0);
	clientfield::register("actor", "off_fx", 1, 7, "int", &function_33760903, 0, 0);
	clientfield::register("vehicle", "off_fx", 1, 7, "int", &function_33760903, 0, 0);
	clientfield::register("scriptmover", "play_sfx", 1, 7, "int", &function_68503cb7, 0, 0);
	clientfield::register("allplayers", "play_sfx", 1, 7, "int", &function_68503cb7, 0, 0);
	clientfield::register("actor", "play_sfx", 1, 7, "int", &function_68503cb7, 0, 0);
	clientfield::register("vehicle", "play_sfx", 1, 7, "int", &function_68503cb7, 0, 0);
	clientfield::register("scriptmover", "off_sfx", 1, 7, "int", &function_9bf26aa6, 0, 0);
	clientfield::register("allplayers", "off_sfx", 1, 7, "int", &function_9bf26aa6, 0, 0);
	clientfield::register("actor", "off_sfx", 1, 7, "int", &function_9bf26aa6, 0, 0);
	clientfield::register("vehicle", "off_sfx", 1, 7, "int", &function_9bf26aa6, 0, 0);
	clientfield::register("allplayers", "fated_boost", 1, 1, "int", &function_409fa9ce, 0, 0);
	clientfield::register("allplayers", "bombDrop", 1, 1, "int", &function_f87ff72d, 0, 0);
	clientfield::register("toplayer", "controlBinding", 1, 1, "counter", &function_f8c69ca4, 0, 0);
	clientfield::register("toplayer", "goFPS", 1, 1, "counter", &function_ca593121, 0, 0);
	clientfield::register("toplayer", "exitFPS", 1, 1, "counter", &function_9e1eca0b, 0, 0);
	clientfield::register("world", "cleanUpGibs", 1, 1, "counter", &function_efeeaa92, 0, 0);
	clientfield::register("world", "killweather", 1, 1, "counter", &namespace_3ca3c537::function_22f2039b, 0, 0);
	clientfield::register("world", "killfog", 1, 1, "counter", &namespace_3ca3c537::function_9977953, 0, 0);
	clientfield::register("world", "flipCamera", 1, 2, "int", &namespace_3ca3c537::flipcamera, 0, 0);
	clientfield::register("world", "arenaUpdate", 1, 8, "int", &namespace_3ca3c537::setarena, 0, 0);
	clientfield::register("world", "arenaRound", 1, 3, "int", &namespace_3ca3c537::function_836d1e22, 0, 0);
	clientfield::register("actor", "enemy_ragdoll_explode", 1, 1, "int", &zombie_ragdoll_explode_cb, 0, 0);
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int", &zombie_gut_explosion_cb, 0, 0);
	clientfield::register("actor", "zombie_chunk", 1, 1, "counter", &function_3a1ccea7, 0, 0);
	clientfield::register("actor", "zombie_saw_explosion", 1, 1, "int", &function_15b503eb, 0, 0);
	clientfield::register("actor", "zombie_rhino_explosion", 1, 1, "int", &function_8b8f5cb4, 0, 0);
	clientfield::register("world", "restart_doa", 1, 1, "counter", &function_4ac9a8ba, 0, 0);
	clientfield::register("scriptmover", "hazard_type", 1, 4, "int", &function_20671f0, 0, 0);
	clientfield::register("scriptmover", "hazard_activated", 1, 4, "int", &function_ec2caec3, 0, 0);
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int", &handle_zombie_risers, 0, 0);
	clientfield::register("actor", "zombie_bloodriser_fx", 1, 1, "int", &function_cb806a9b, 0, 0);
	clientfield::register("scriptmover", "heartbeat", 1, 3, "int", &function_d277a961, 0, 0);
	clientfield::register("actor", "burnType", 1, 2, "int", &namespace_eaa992c::function_7aac5112, 0, 0);
	clientfield::register("actor", "burnZombie", 1, 1, "counter", &namespace_eaa992c::function_f6008bb4, 0, 0);
	clientfield::register("actor", "burnCorpse", 1, 1, "counter", &namespace_eaa992c::burncorpse, 0, 0);
	clientfield::register("toplayer", "changeCamera", 1, 1, "counter", &changecamera, 0, 0);
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int", &namespace_eaa992c::zombie_eyes_clientfield_cb, 0, 0);
	clientfield::register("world", "cameraHeight", 1, 3, "int", &function_b868b40f, 0, 0);
	clientfield::register("world", "cleanupGiblets", 1, 1, "int", &function_23f655ed, 0, 0);
	clientfield::register("scriptmover", "camera_focus_item", 1, 1, "int", &function_354ec425, 0, 0);
	clientfield::register("actor", "camera_focus_item", 1, 1, "int", &function_354ec425, 0, 0);
	clientfield::register("vehicle", "camera_focus_item", 1, 1, "int", &function_354ec425, 0, 0);
	callback::on_spawned(&on_player_spawn);
	callback::on_shutdown(&on_player_shutdown);
	callback::on_localclient_connect(&player_on_connect);
	/#
		clientfield::register("", "", 1, 1, "", &function_bbb7743c, 0, 0);
		clientfield::register("", "", 1, 2, "", &function_cee29ae7, 0, 0);
		clientfield::register("", "", 1, 30, "", &function_cd844947, 0, 0);
		level.var_83a34f19 = 0;
		level.var_e9c73e06 = 0;
		level.var_7a6087fd = 0;
	#/
	setdvar("dynEnt_spawnedLimit", 400);
	setdvar("cg_disableearthquake", 1);
	setdvar("scr_use_digital_blood_enabled", 0);
	setdvar("ik_enable_ai_terrain", 0);
	setdvar("r_newLensFlares", 0);
	level thread function_ae0a4fc5();
	level thread function_d5eb029a();
}

/*
	Name: on_player_spawned
	Namespace: namespace_693feb87
	Checksum: 0x7DE001F4
	Offset: 0x1E80
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(localclientnum)
{
	recacheleaderboards(localclientnum);
	if(self islocalplayer() && localclientnum > 0)
	{
		allowscoreboard(localclientnum, 0);
	}
	level notify(#"hash_a2a24535");
	level thread function_5c2a88d5();
}

/*
	Name: function_d5eb029a
	Namespace: namespace_693feb87
	Checksum: 0x6BE79366
	Offset: 0x1F10
	Size: 0x3A4
	Parameters: 0
	Flags: Linked
*/
function function_d5eb029a()
{
	level notify(#"hash_d5eb029a");
	level endon(#"hash_d5eb029a");
	while(true)
	{
		level waittill(#"hash_aae01d5a", playernum, newstate);
		players = getplayers(0);
		foreach(var_e6d1a490, player in players)
		{
			if(!isdefined(player.entnum))
			{
				player.entnum = player getentitynumber();
			}
			if(playernum != player.entnum)
			{
				continue;
			}
			if(!isdefined(player.var_4abf708a))
			{
				player.var_4abf708a = [];
				for(localclientnum = 0; localclientnum < 2; localclientnum++)
				{
					player.var_4abf708a[localclientnum] = 0;
				}
			}
			var_36ffb352 = "player_trail_" + function_ee495f41(player.entnum);
			for(localclientnum = 0; localclientnum < 2; localclientnum++)
			{
				if(localclientnum >= getlocalplayers().size)
				{
					continue;
				}
				if(isdefined(player.var_4abf708a[localclientnum]) && player.var_4abf708a[localclientnum] != 0)
				{
					killfx(localclientnum, player.var_4abf708a[localclientnum]);
					player.var_4abf708a[localclientnum] = 0;
				}
			}
			player.var_8064cb04 = newstate;
			switch(player.var_8064cb04)
			{
				case 0:
				{
					break;
				}
				case 1:
				case 2:
				{
					for(localclientnum = 0; localclientnum < 2; localclientnum++)
					{
						if(localclientnum >= getlocalplayers().size)
						{
							continue;
						}
						if(!player hasdobj(localclientnum))
						{
							player.var_8064cb04 = 0;
							continue;
						}
						player.var_4abf708a[localclientnum] = playfxontag(localclientnum, level._effect[var_36ffb352], player, "tag_origin");
					}
					break;
				}
				default:
				{
					/#
						assert(0);
					#/
				}
			}
		}
	}
}

/*
	Name: function_ae0a4fc5
	Namespace: namespace_693feb87
	Checksum: 0xB479B90E
	Offset: 0x22C0
	Size: 0x260
	Parameters: 0
	Flags: Linked
*/
function function_ae0a4fc5()
{
	self notify(#"hash_ae0a4fc5");
	self endon(#"hash_ae0a4fc5");
	while(true)
	{
		players = getplayers(0);
		foreach(var_5474f216, player in players)
		{
			if(isdefined(player.doa))
			{
				continue;
			}
			if(!player isplayer())
			{
				continue;
			}
			if(player islocalplayer() && isspectating(player getlocalclientnumber()))
			{
				continue;
			}
			if(!isdefined(player.name))
			{
				continue;
			}
			doa = level.var_29e6f519[player getentitynumber()];
			if(!isdefined(doa))
			{
				continue;
			}
			if(isdefined(doa.player) && doa.player != player)
			{
				/#
					debugmsg("" + player.name + "" + doa.player.name + "" + player getentitynumber() + "" + doa.player getentitynumber());
				#/
				continue;
			}
			player function_12c2fbcb();
		}
		wait(0.016);
	}
}

/*
	Name: player_on_connect
	Namespace: namespace_693feb87
	Checksum: 0x1058E50D
	Offset: 0x2528
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function player_on_connect(localclientnum)
{
	disablespeedblur(localclientnum);
	self blood::disable_blood(localclientnum);
}

/*
	Name: on_player_spawn
	Namespace: namespace_693feb87
	Checksum: 0x80CD2BE9
	Offset: 0x2570
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function on_player_spawn(localclientnum)
{
	self.entnum = self getentitynumber();
	self.nobloodlightbarchange = 1;
}

/*
	Name: on_player_shutdown
	Namespace: namespace_693feb87
	Checksum: 0xAB473D9F
	Offset: 0x25B0
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function on_player_shutdown(localclientnum)
{
	for(localclientnum = 0; localclientnum < 2; localclientnum++)
	{
		if(localclientnum >= getlocalplayers().size)
		{
			continue;
		}
		if(isdefined(self.var_4abf708a[localclientnum]) && self.var_4abf708a[localclientnum] != 0)
		{
			killfx(localclientnum, self.var_4abf708a[localclientnum]);
			self.var_4abf708a[localclientnum] = 0;
		}
	}
	if(self islocalplayer())
	{
		self setcontrollerlightbarcolor(localclientnum);
	}
}

/*
	Name: function_fc05827f
	Namespace: namespace_693feb87
	Checksum: 0x69337CF5
	Offset: 0x2698
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function function_fc05827f(localclientnum)
{
	self endon(#"disconnect");
	wait(0.5);
	disablespeedblur(localclientnum);
	self blood::disable_blood(localclientnum);
}

/*
	Name: function_2eaf8a3f
	Namespace: namespace_693feb87
	Checksum: 0x70AAF276
	Offset: 0x26F0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function function_2eaf8a3f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	/#
		debugmsg("" + newval + "" + level.doa.roundnumber);
	#/
	if(newval)
	{
		setuimodelvalue(getuimodel(level.var_7e2a814c, "round"), level.doa.roundnumber);
	}
	else
	{
		setuimodelvalue(getuimodel(level.var_7e2a814c, "round"), 0);
	}
}

/*
	Name: function_c97b97ae
	Namespace: namespace_693feb87
	Checksum: 0x20F3127
	Offset: 0x27F8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_c97b97ae(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(getuimodel(level.var_7e2a814c, "teleporter"), newval);
}

/*
	Name: function_e3bb35e
	Namespace: namespace_693feb87
	Checksum: 0x7762234
	Offset: 0x2878
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_e3bb35e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.doa.roundnumber = newval;
	/#
		debugmsg("" + level.doa.roundnumber);
	#/
}

/*
	Name: function_c86d63f6
	Namespace: namespace_693feb87
	Checksum: 0x4BBD897D
	Offset: 0x2908
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_c86d63f6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(getuimodel(level.var_7e2a814c, "numexits"), newval);
	/#
		debugmsg("" + newval);
	#/
}

/*
	Name: function_91976e37
	Namespace: namespace_693feb87
	Checksum: 0x35373392
	Offset: 0x29B0
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function function_91976e37(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(getuimodel(level.var_7e2a814c, "gameover"), (newval > 0 ? level.doa.roundnumber : 0));
	/#
		debugmsg("" + level.doa.roundnumber);
	#/
}

/*
	Name: function_e63081e8
	Namespace: namespace_693feb87
	Checksum: 0x5E03639E
	Offset: 0x2A80
	Size: 0x258
	Parameters: 7
	Flags: Linked
*/
function function_e63081e8(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(getuimodel(level.var_7e2a814c, "doafps"), newval);
	/#
		debugmsg("" + newval);
	#/
	if(newval)
	{
		if(newval && getlocalplayers().size > 1)
		{
			setdvar("r_splitScreenExpandFull", 0);
		}
		if(isdefined(level.doa.var_6e0195ea))
		{
			stopradiantexploder(localclientnum, level.doa.var_6e0195ea);
			level.doa.var_6e0195ea = undefined;
		}
		level.doa.var_6e0195ea = "fx_exploder_" + level.doa.arenas[level.doa.current_arena].name + "_FPS";
		/#
			debugmsg("" + level.doa.var_6e0195ea + "" + localclientnum);
		#/
		playradiantexploder(localclientnum, level.doa.var_6e0195ea);
	}
	else
	{
		setdvar("r_splitScreenExpandFull", 1);
		if(isdefined(level.doa.var_6e0195ea))
		{
			stopradiantexploder(localclientnum, level.doa.var_6e0195ea);
			level.doa.var_6e0195ea = undefined;
		}
	}
	level.doa.var_2836c8ee = newval;
}

/*
	Name: function_9e1eca0b
	Namespace: namespace_693feb87
	Checksum: 0xF1E317C5
	Offset: 0x2CE0
	Size: 0xFE
	Parameters: 7
	Flags: Linked
*/
function function_9e1eca0b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_4f118af8))
	{
		self.var_44509e49 = self.var_4f118af8;
		self.var_4f118af8 = undefined;
	}
	if(isdefined(self.var_bf81deea) && self.var_bf81deea && self islocalplayer())
	{
		self.var_bf81deea = undefined;
		level.var_6383030e = self.origin + vectorscale((0, 0, 1), 72);
		self cameraforcedisablescriptcam(0);
	}
	if(isdefined(self.laserfx))
	{
		killfx(localclientnum, self.laserfx);
		self.laserfx = undefined;
	}
}

/*
	Name: function_ca593121
	Namespace: namespace_693feb87
	Checksum: 0xE7681C29
	Offset: 0x2DE8
	Size: 0x2EC
	Parameters: 7
	Flags: Linked
*/
function function_ca593121(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!(isdefined(self.var_bf81deea) && self.var_bf81deea) && !isdefined(level.doa.var_db180da))
	{
		if(!isdefined(level.var_6383030e))
		{
			level.var_6383030e = self.origin;
		}
		level.doa.var_db180da = spawn(localclientnum, level.var_6383030e, "script_model");
		level.doa.var_db180da setmodel("tag_origin");
		level.doa.var_db180da moveto(self.origin + vectorscale((0, 0, 1), 72), 0.15);
		wait(0.1);
		playfx(localclientnum, level._effect["bomb"], self.origin);
		level.doa.var_db180da util::waittill_any_timeout(0.1, "movedone");
		playfx(localclientnum, level._effect["turret_impact"], self.origin);
		self earthquake(1, 0.8, self.origin, 1000);
		playrumbleonposition(localclientnum, "damage_heavy", self.origin);
		wait(0.1);
		if(isdefined(level.doa.var_db180da))
		{
			level.doa.var_db180da delete();
			level.doa.var_db180da = undefined;
		}
	}
	if(!isdefined(self.var_4f118af8))
	{
		self.var_4f118af8 = self.var_44509e49;
	}
	if(!(isdefined(self.var_bf81deea) && self.var_bf81deea) && self islocalplayer())
	{
		self cameraforcedisablescriptcam(1);
		self.var_bf81deea = 1;
	}
	self thread function_f7c0d598("zombietron_fps");
}

/*
	Name: function_22de3f7
	Namespace: namespace_693feb87
	Checksum: 0xF8B32BC9
	Offset: 0x30E0
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function function_22de3f7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.doa.var_160ae6c6 = newval;
	setuimodelvalue(getuimodel(level.var_7e2a814c, "level"), level.doa.var_160ae6c6);
}

/*
	Name: function_d3b4c89d
	Namespace: namespace_693feb87
	Checksum: 0xA8EE6E15
	Offset: 0x3180
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function function_d3b4c89d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(localclientnum != 0)
	{
		return;
	}
	player = getlocalplayer(localclientnum);
	if(!isdefined(player))
	{
		return;
	}
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "forceScoreboard"), newval);
}

/*
	Name: function_a6c926fc
	Namespace: namespace_693feb87
	Checksum: 0x119072E1
	Offset: 0x3250
	Size: 0x1DA
	Parameters: 7
	Flags: Linked
*/
function function_a6c926fc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(localclientnum != 0)
	{
		return;
	}
	player = getlocalplayer(localclientnum);
	if(!isdefined(player))
	{
		return;
	}
	if(newval)
	{
		setuimodelvalue(getuimodel(level.var_7e2a814c, "level"), level.doa.var_160ae6c6);
		setuimodelvalue(createuimodel(level.var_7e2a814c, "changingLevel"), 1);
		if(!isdefined(player.var_336bed9c))
		{
			player.var_336bed9c = createluimenu(localclientnum, "DOA_overworld");
		}
		openluimenu(localclientnum, player.var_336bed9c);
	}
	else if(isdefined(player.var_336bed9c))
	{
		setuimodelvalue(createuimodel(level.var_7e2a814c, "changingLevel"), 0);
		closeluimenu(localclientnum, player.var_336bed9c);
		player.var_336bed9c = undefined;
	}
}

/*
	Name: function_10093dd7
	Namespace: namespace_693feb87
	Checksum: 0xDA31140A
	Offset: 0x3438
	Size: 0x1FE
	Parameters: 7
	Flags: Linked
*/
function function_10093dd7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(level.weatherfx) && isdefined(level.weatherfx[localclientnum]))
	{
		stopfx(localclientnum, level.weatherfx[localclientnum]);
		level.weatherfx[localclientnum] = 0;
	}
	if(localclientnum != 0)
	{
		return;
	}
	players = getlocalplayers();
	if(newval)
	{
		if(!isdefined(level.var_45fd31cd))
		{
			level.var_45fd31cd = createluimenu(localclientnum, "DOA_outro_frame");
		}
		openluimenu(localclientnum, level.var_45fd31cd);
		if(isdefined(level.var_ba533099))
		{
			exploder::kill_exploder(level.var_ba533099);
			level.var_ba533099 = undefined;
		}
		level.var_b62087b0 = struct::get("podium_camera", "targetname");
		players[0] camerasetposition(level.var_b62087b0.origin);
		players[0] camerasetlookat(level.var_b62087b0.angles);
	}
	else if(isdefined(level.var_45fd31cd))
	{
		closeluimenu(localclientnum, level.var_45fd31cd);
		level.var_45fd31cd = undefined;
	}
	level.var_b62087b0 = undefined;
}

/*
	Name: function_354ec425
	Namespace: namespace_693feb87
	Checksum: 0x7604C9E1
	Offset: 0x3640
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function function_354ec425(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(!(isdefined(self.var_354ec425) && self.var_354ec425))
		{
			self.var_354ec425 = 1;
			if(!isdefined(level.var_172ed9a1))
			{
				level.var_172ed9a1 = [];
			}
			else if(!isarray(level.var_172ed9a1))
			{
				level.var_172ed9a1 = array(level.var_172ed9a1);
			}
			level.var_172ed9a1[level.var_172ed9a1.size] = self;
		}
	}
	else if(isdefined(self.var_354ec425) && self.var_354ec425)
	{
		self.var_354ec425 = undefined;
		arrayremovevalue(level.var_172ed9a1, self);
	}
}

/*
	Name: function_23f655ed
	Namespace: namespace_693feb87
	Checksum: 0x2F02471D
	Offset: 0x3760
	Size: 0x4C
	Parameters: 7
	Flags: Linked
*/
function function_23f655ed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	cleanupspawneddynents();
}

/*
	Name: function_ee495f41
	Namespace: namespace_693feb87
	Checksum: 0x83ECB617
	Offset: 0x37B8
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
	Name: function_351aa01c
	Namespace: namespace_693feb87
	Checksum: 0xDB931C25
	Offset: 0x3848
	Size: 0xF4
	Parameters: 7
	Flags: Linked
*/
function function_351aa01c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval != 0)
	{
		name = namespace_eaa992c::function_9e6fe7c3(newval);
		if(isdefined(self.var_ec1cda64) && namespace_eaa992c::function_7664cc94(newval) && isdefined(self.var_ec1cda64[name]))
		{
			self thread namespace_eaa992c::function_e68e3c0d(localclientnum, name, 1);
		}
		self thread namespace_eaa992c::function_e68e3c0d(localclientnum, name, 0, namespace_eaa992c::function_28a90644(newval));
	}
}

/*
	Name: function_33760903
	Namespace: namespace_693feb87
	Checksum: 0x3911602B
	Offset: 0x3948
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_33760903(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval != 0)
	{
		self thread namespace_eaa992c::function_e68e3c0d(localclientnum, namespace_eaa992c::function_9e6fe7c3(newval), 1);
	}
}

/*
	Name: function_68503cb7
	Namespace: namespace_693feb87
	Checksum: 0xD357C448
	Offset: 0x39D0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_68503cb7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(newval != 0)
	{
		self namespace_1a381543::function_1f085aea(localclientnum, newval, 0);
	}
}

/*
	Name: function_9bf26aa6
	Namespace: namespace_693feb87
	Checksum: 0x566CC620
	Offset: 0x3A50
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_9bf26aa6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(newval != 0)
	{
		self namespace_1a381543::function_1f085aea(localclientnum, newval, 1);
	}
}

/*
	Name: onground
	Namespace: namespace_693feb87
	Checksum: 0xC9D87E0E
	Offset: 0x3AD0
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function onground()
{
	a_trace = bullettrace(self.origin, self.origin + vectorscale((0, 0, -1), 5000), 0, self, 1);
	v_ground = a_trace["position"];
	distance_squared = distancesquared(self.origin, v_ground);
	if(distance_squared > 576)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_10477d98
	Namespace: namespace_693feb87
	Checksum: 0xADF4C6C5
	Offset: 0x3B78
	Size: 0x29C
	Parameters: 1
	Flags: Linked
*/
function function_10477d98(localclientnum)
{
	self notify(#"hash_f33fde4b");
	self endon(#"disconnect");
	self endon(#"hash_7f60c43e");
	self endon(#"entityshutdown");
	endtime = gettime() + 600;
	self playsound(0, "zmb_fated_boost_activate");
	lastposition = self.origin;
	stepsize = 20;
	while(gettime() < endtime)
	{
		if(self onground())
		{
			wait(0.2);
			if(!(isdefined(level.doa.var_2836c8ee) && level.doa.var_2836c8ee) && localclientnum != 0)
			{
				continue;
			}
			normal = vectornormalize(self.origin - lastposition);
			step = normal * stepsize;
			dist = distance(self.origin, lastposition);
			if(dist < 10)
			{
				continue;
			}
			steps = int(dist / stepsize + 0.5);
			for(i = 0; i < steps; i++)
			{
				playfx(localclientnum, level._effect["fury_boost"], lastposition, anglestoforward(self.angles), (0, 0, 1));
				playfx(localclientnum, level._effect["fury_patch"], lastposition, anglestoforward(self.angles), (0, 0, 1));
				lastposition = lastposition + step;
			}
			lastposition = self.origin;
		}
		else
		{
			wait(0.5);
		}
	}
}

/*
	Name: function_b868b40f
	Namespace: namespace_693feb87
	Checksum: 0x56D308F3
	Offset: 0x3E20
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_b868b40f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		level.doa.var_708cc739 = undefined;
	}
	else
	{
		level.doa.var_708cc739 = newval;
	}
	namespace_3ca3c537::function_986ae2b3(localclientnum);
}

/*
	Name: function_409fa9ce
	Namespace: namespace_693feb87
	Checksum: 0xFB65DA9E
	Offset: 0x3EB0
	Size: 0xCE
	Parameters: 7
	Flags: Linked
*/
function function_409fa9ce(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	/#
		debugmsg("" + (isdefined(self.name) ? self.name : "") + "" + newval + "" + localclientnum);
	#/
	if(newval)
	{
		self thread function_10477d98(localclientnum);
	}
	else
	{
		self notify(#"hash_f33fde4b");
	}
}

/*
	Name: function_cb806a9b
	Namespace: namespace_693feb87
	Checksum: 0x9CA31BB8
	Offset: 0x3F88
	Size: 0x166
	Parameters: 7
	Flags: Linked
*/
function function_cb806a9b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(!oldval && newval)
	{
		localplayers = level.localplayers;
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_blood_burst"];
		billow_fx = level._effect["rise_blood_billow"];
		var_cf929ddb = level._effect["rise_blood_dust"];
		type = "dirt";
		playsound(0, sound, self.origin);
		for(i = 0; i < localplayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx, var_cf929ddb);
		}
	}
}

/*
	Name: handle_zombie_risers
	Namespace: namespace_693feb87
	Checksum: 0xE96738FF
	Offset: 0x40F8
	Size: 0x166
	Parameters: 7
	Flags: Linked
*/
function handle_zombie_risers(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(!oldval && newval)
	{
		localplayers = level.localplayers;
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst"];
		billow_fx = level._effect["rise_billow"];
		var_cf929ddb = level._effect["rise_dust"];
		type = "dirt";
		playsound(0, sound, self.origin);
		for(i = 0; i < localplayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx, var_cf929ddb);
		}
	}
}

/*
	Name: rise_dust_fx
	Namespace: namespace_693feb87
	Checksum: 0x2C9C2D23
	Offset: 0x4268
	Size: 0x1D6
	Parameters: 5
	Flags: Linked
*/
function rise_dust_fx(localclientnum, type, billow_fx, burst_fx, var_cf929ddb)
{
	dust_tag = "J_SpineUpper";
	self endon(#"entityshutdown");
	if(isdefined(burst_fx))
	{
		playfx(localclientnum, burst_fx, self.origin + (0, 0, randomintrange(5, 10)));
	}
	wait(0.25);
	if(isdefined(billow_fx))
	{
		playfx(localclientnum, billow_fx, self.origin + (randomintrange(-10, 10), randomintrange(-10, 10), randomintrange(5, 10)));
	}
	wait(2);
	dust_time = 5.5;
	dust_interval = 0.3;
	self util::waittill_dobj(localclientnum);
	t = 0;
	while(t < dust_time)
	{
		if(self hasdobj(localclientnum))
		{
			playfxontag(localclientnum, var_cf929ddb, self, dust_tag);
		}
		wait(dust_interval);
		t = t + dust_interval;
	}
}

/*
	Name: function_20671f0
	Namespace: namespace_693feb87
	Checksum: 0x25787F13
	Offset: 0x4448
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function function_20671f0(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.doa.hazards[level.doa.hazards.size] = self;
	arrayremovevalue(level.doa.hazards, undefined);
	self.var_d05d7e08 = newval;
	self thread function_38452435(localclientnum);
}

/*
	Name: function_ec2caec3
	Namespace: namespace_693feb87
	Checksum: 0xC1EFDA95
	Offset: 0x4500
	Size: 0xDE
	Parameters: 7
	Flags: Linked
*/
function function_ec2caec3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.var_d05d7e08))
	{
		self.var_d05d7e08 = 0;
	}
	switch(self.var_d05d7e08)
	{
		case 3:
		{
			self.activefx = level._effect["electric_trap2"];
		}
		case 1:
		{
			self function_e41e6611(localclientnum, newval);
			break;
		}
		case 2:
		{
			self function_d8d20160(localclientnum, newval);
			break;
		}
	}
}

/*
	Name: function_38452435
	Namespace: namespace_693feb87
	Checksum: 0x129CF718
	Offset: 0x45E8
	Size: 0x9E
	Parameters: 1
	Flags: Linked, Private
*/
private function function_38452435(localclientnum)
{
	self notify(#"hash_38452435");
	self endon(#"hash_38452435");
	self waittill(#"entityshutdown");
	if(isdefined(self.fx))
	{
		deletefx(localclientnum, self.fx);
		self.fx = undefined;
	}
	if(isdefined(self.fx2))
	{
		deletefx(localclientnum, self.fx2);
		self.fx2 = undefined;
	}
}

/*
	Name: function_b54615b2
	Namespace: namespace_693feb87
	Checksum: 0x2559169C
	Offset: 0x4690
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_b54615b2()
{
	arrayremovevalue(level.doa.hazards, undefined);
	foreach(var_146c2ac8, hazard in level.doa.hazards)
	{
		if(!isdefined(hazard))
		{
			continue;
		}
		if(hazard == self)
		{
			continue;
		}
		if(hazard.var_d05d7e08 != self.var_d05d7e08)
		{
			continue;
		}
		distsq = distancesquared(hazard.origin, self.origin);
		if(distsq < 72 * 72)
		{
			if(isdefined(hazard.activefx) && hazard.activefx == level._effect["electric_trap"])
			{
				return level._effect["electric_trap2"];
			}
		}
	}
	self.var_5ad223cf = 1;
	return level._effect["electric_trap"];
}

/*
	Name: function_e41e6611
	Namespace: namespace_693feb87
	Checksum: 0x593BC8A
	Offset: 0x4828
	Size: 0x386
	Parameters: 2
	Flags: Linked
*/
function function_e41e6611(localclientnum, value)
{
	switch(value)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			if(isdefined(self.fx))
			{
				deletefx(localclientnum, self.fx);
				self.fx = undefined;
			}
			if(isdefined(self.fx2))
			{
				deletefx(localclientnum, self.fx2);
				self.fx2 = undefined;
			}
			self.fx2 = playfx(localclientnum, level._effect["trap_green"], self.origin + vectorscale((0, 0, 1), 124));
			break;
		}
		case 2:
		{
			if(isdefined(self.fx))
			{
				deletefx(localclientnum, self.fx);
				self.fx = undefined;
			}
			if(isdefined(self.fx2))
			{
				deletefx(localclientnum, self.fx2);
				self.fx2 = undefined;
			}
			self.fx2 = playfx(localclientnum, level._effect["trap_red"], self.origin + vectorscale((0, 0, 1), 124));
			break;
		}
		case 3:
		{
			if(isdefined(self.fx))
			{
				deletefx(localclientnum, self.fx);
				self.fx = undefined;
			}
			if(isdefined(self.fx2))
			{
				deletefx(localclientnum, self.fx2);
				self.fx2 = undefined;
			}
			if(!isdefined(self.activefx))
			{
				self.activefx = self function_b54615b2();
			}
			/#
				if(isdefined(self.var_5ad223cf) && self.var_5ad223cf)
				{
					level thread drawcylinder(self.origin, 40, 20, 180, (0, 0, 1));
				}
			#/
			self.fx = playfx(localclientnum, self.activefx, self.origin + vectorscale((0, 0, 1), 100));
			self.fx2 = playfx(localclientnum, level._effect["hazard_electric"], self.origin + vectorscale((0, 0, 1), 124));
			break;
		}
		case 9:
		{
			if(isdefined(self.fx))
			{
				deletefx(localclientnum, self.fx);
			}
			if(isdefined(self.fx2))
			{
				deletefx(localclientnum, self.fx2);
			}
			break;
		}
	}
}

/*
	Name: function_d8d20160
	Namespace: namespace_693feb87
	Checksum: 0x249C1FD5
	Offset: 0x4BB8
	Size: 0x156
	Parameters: 2
	Flags: Linked
*/
function function_d8d20160(localclientnum, value)
{
	self util::waittill_dobj(localclientnum);
	switch(value)
	{
		case 3:
		{
			self.fx = playfxontag(localclientnum, level._effect["trashcan_active"], self, "tag_origin");
			break;
		}
		case 4:
		case 5:
		case 6:
		{
			playfx(localclientnum, level._effect["trashcan_damaged"], self.origin + vectorscale((0, 0, 1), 32));
			break;
		}
		case 9:
		{
			playfx(localclientnum, level._effect["trashcan_destroyed"], self.origin + vectorscale((0, 0, 1), 32));
			if(isdefined(self.fx))
			{
				deletefx(localclientnum, self.fx);
			}
			break;
		}
	}
}

/*
	Name: function_4ac9a8ba
	Namespace: namespace_693feb87
	Checksum: 0xAA61F8F5
	Offset: 0x4D18
	Size: 0x1FC
	Parameters: 7
	Flags: Linked
*/
function function_4ac9a8ba(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	namespace_3ca3c537::restart();
	namespace_64c6b720::function_6fa6dee2();
	namespace_ad544aeb::function_d22ceb57(vectorscale((1, 0, 0), 75), 600);
	cleanupspawneddynents();
	level.doa.hazards = [];
	level.doa.roundnumber = 1;
	level.doa.var_160ae6c6 = 1;
	setuimodelvalue(getuimodel(level.var_7e2a814c, "level"), level.doa.var_160ae6c6);
	foreach(var_209d81f0, player in getplayers(0))
	{
		player.doa = undefined;
		player thread function_12c2fbcb();
	}
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "forceScoreboard"), 0);
}

/*
	Name: function_f7c0d598
	Namespace: namespace_693feb87
	Checksum: 0xBECB4713
	Offset: 0x4F20
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function function_f7c0d598(mapping = "zombietron")
{
	self notify(#"hash_f7c0d598");
	self endon(#"hash_f7c0d598");
	self endon(#"entityshutdown");
	self endon(#"disconnect");
	/#
		loc_00004FA8:
		debugmsg("" + (isdefined(self.name) ? self.name : "") + "" + mapping + "" + (self islocalplayer() ? "" : ""));
	#/
	if(self islocalplayer())
	{
		clientnum = self getlocalclientnumber();
		/#
			debugmsg("" + clientnum);
		#/
		forcegamemodemappings(clientnum, mapping);
	}
	debugmsg("");
}

/*
	Name: function_f8c69ca4
	Namespace: namespace_693feb87
	Checksum: 0xB1004401
	Offset: 0x50A0
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function function_f8c69ca4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread function_f7c0d598();
}

/*
	Name: function_f87ff72d
	Namespace: namespace_693feb87
	Checksum: 0xFD8B0B9E
	Offset: 0x5100
	Size: 0x2F4
	Parameters: 7
	Flags: Linked
*/
function function_f87ff72d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		return;
	}
	if(isdefined(level.doa.var_2836c8ee) && level.doa.var_2836c8ee)
	{
		forward = anglestoforward(self.angles);
		var_ec8a4984 = self.origin + forward * 100;
	}
	else
	{
		var_ec8a4984 = self.origin;
	}
	origin = var_ec8a4984 + (20, 0, 2000);
	bomb = spawn(localclientnum, origin, "script_model");
	bomb setmodel("zombietron_nuke");
	bomb.angles = vectorscale((1, 0, 0), 90);
	bomb moveto(var_ec8a4984, 0.3, 0, 0);
	playsound(0, "zmb_nuke_incoming", self.origin);
	bomb waittill(#"movedone");
	playsound(localclientnum, "zmb_nuke_impact", var_ec8a4984);
	playfx(localclientnum, level._effect["bomb"], var_ec8a4984);
	foreach(var_c68d4c29, player in getlocalplayers())
	{
		player earthquake(1, 0.8, var_ec8a4984, 1000);
	}
	bomb delete();
	wait(0.2);
	playfx(localclientnum, level._effect["nuke_dust"], var_ec8a4984);
}

/*
	Name: randomize_array
	Namespace: namespace_693feb87
	Checksum: 0x46FB018
	Offset: 0x5400
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function randomize_array(array)
{
	for(i = 0; i < array.size; i++)
	{
		j = randomint(array.size);
		temp = array[i];
		array[i] = array[j];
		array[j] = temp;
	}
	return array;
}

/*
	Name: function_ef1ad359
	Namespace: namespace_693feb87
	Checksum: 0xD360E022
	Offset: 0x54A8
	Size: 0x1CE
	Parameters: 3
	Flags: Linked
*/
function function_ef1ad359(origin, count = 3, dir)
{
	while(count)
	{
		if(!isdefined(dir))
		{
			dir = level.var_ff8aba3b + (randomfloatrange(level.var_46418da4 * -1 - count, level.var_46418da4 + count), randomfloatrange(level.var_46418da4 * -1 - count, level.var_46418da4 + count), randomintrange(level.var_96344b03 * -1 - count, level.var_96344b03 + count)) * level.var_bd436f37;
		}
		model = level.var_e3119165[randomint(level.var_e3119165.size)];
		launchorigin = origin + (randomintrange(-12, 12), randomintrange(-12, 12), randomintrange(-40, 12));
		createdynentandlaunch(0, model, launchorigin, (0, 0, 0), launchorigin, dir, level._effect["gibtrail_fx"], 1);
		count--;
	}
}

/*
	Name: function_3a1ccea7
	Namespace: namespace_693feb87
	Checksum: 0xBB14733C
	Offset: 0x5680
	Size: 0xF4
	Parameters: 7
	Flags: Linked
*/
function function_3a1ccea7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
	{
		where = self gettagorigin("J_SpineLower");
		if(!isdefined(where))
		{
			where = self.origin;
		}
		playfx(localclientnum, level._effect["zombie_guts_explosion"], where);
		level thread function_ef1ad359(where, 1);
	}
}

/*
	Name: zombie_gut_explosion_cb
	Namespace: namespace_693feb87
	Checksum: 0x59D91203
	Offset: 0x5780
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function zombie_gut_explosion_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
		{
			where = self gettagorigin("J_SpineLower");
			if(!isdefined(where))
			{
				where = self.origin;
			}
			playfx(localclientnum, level._effect["zombie_guts_explosion"], where);
			level thread function_ef1ad359(where, 6);
		}
	}
}

/*
	Name: function_15b503eb
	Namespace: namespace_693feb87
	Checksum: 0xD72082AA
	Offset: 0x5888
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function function_15b503eb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
	{
		where = self gettagorigin("J_SpineLower");
		if(!isdefined(where))
		{
			where = self.origin;
		}
		playfx(localclientnum, level._effect["zombie_guts_explosion"], where);
		level thread function_ef1ad359(where);
	}
}

/*
	Name: function_8b8f5cb4
	Namespace: namespace_693feb87
	Checksum: 0x86D49E12
	Offset: 0x5990
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function function_8b8f5cb4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
	{
		where = self gettagorigin("J_SpineLower");
		if(!isdefined(where))
		{
			where = self.origin;
		}
		playfx(localclientnum, level._effect["zombie_guts_explosion"], where);
		level thread function_ef1ad359(where, 5);
	}
}

/*
	Name: zombie_ragdoll_explode_cb
	Namespace: namespace_693feb87
	Checksum: 0xC077EE8F
	Offset: 0x5AA0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function zombie_ragdoll_explode_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self zombie_wait_explode(localclientnum);
	}
}

/*
	Name: zombie_wait_explode
	Namespace: namespace_693feb87
	Checksum: 0xA607AE7A
	Offset: 0x5B08
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function zombie_wait_explode(localclientnum)
{
	where = self gettagorigin("J_SpineLower");
	if(!isdefined(where))
	{
		where = self.origin;
	}
	start = gettime();
	while(gettime() - start < 2000)
	{
		if(isdefined(self))
		{
			where = self gettagorigin("J_SpineLower");
			if(!isdefined(where))
			{
				where = self.origin;
			}
		}
		wait(0.05);
	}
	if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
	{
		playfx(localclientnum, level._effect["zombie_guts_explosion"], where);
	}
}

/*
	Name: function_36c61ba6
	Namespace: namespace_693feb87
	Checksum: 0x4197386
	Offset: 0x5C28
	Size: 0x288
	Parameters: 3
	Flags: Linked
*/
function function_36c61ba6(localclientnum, var_4faf5231 = 1, var_ad5de66e = 1)
{
	self endon(#"entityshutdown");
	currentscale = var_ad5de66e;
	var_c316c8b8 = var_ad5de66e * 1.25;
	var_711842d8 = 0.002;
	var_fa7c415 = 0.002;
	var_ba7af42 = var_711842d8;
	baseangles = self.angles;
	self.rate = 1;
	while(isdefined(self))
	{
		var_ba7af42 = var_711842d8;
		while(currentscale < var_c316c8b8)
		{
			currentscale = currentscale + var_ba7af42;
			var_ba7af42 = var_ba7af42 + var_fa7c415 * self.rate;
			if(currentscale > var_c316c8b8)
			{
				currentscale = var_c316c8b8;
			}
			self setscale(currentscale);
			if(var_4faf5231)
			{
				self.angles = self.angles + (0, 1, 1);
			}
			wait(0.016);
		}
		while(currentscale > var_ad5de66e)
		{
			currentscale = currentscale - var_ba7af42;
			var_ba7af42 = var_ba7af42 - var_fa7c415 * self.rate;
			if(var_ba7af42 < 0.0125)
			{
				var_ba7af42 = 0.0125;
			}
			if(currentscale < var_ad5de66e)
			{
				currentscale = var_ad5de66e;
			}
			self setscale(currentscale);
			if(var_4faf5231)
			{
				self.angles = self.angles - (0, 1, 1);
			}
			wait(0.016);
		}
		self rotateto(baseangles, 0.6 - self.rate / 10);
		wait(0.6 - self.rate / 10);
	}
}

/*
	Name: function_455fa2fe
	Namespace: namespace_693feb87
	Checksum: 0x2D8F58C6
	Offset: 0x5EB8
	Size: 0x6C
	Parameters: 3
	Flags: Linked
*/
function function_455fa2fe(localclientnum, owner, fx)
{
	owner waittill(#"entityshutdown");
	playfx(localclientnum, level._effect[fx], self.origin);
	self delete();
}

/*
	Name: function_d277a961
	Namespace: namespace_693feb87
	Checksum: 0xA9DE01DF
	Offset: 0x5F30
	Size: 0x246
	Parameters: 7
	Flags: Linked
*/
function function_d277a961(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 1:
		{
			self.fakemodel = spawn(localclientnum, self.origin, "script_model");
			self.fakemodel setmodel("zombietron_heart");
			self.fakemodel thread function_455fa2fe(localclientnum, self, "heart_explode");
			self.fakemodel thread function_36c61ba6(localclientnum);
			self.fakemodel.rate = newval;
			self hide();
		}
		case 2:
		case 3:
		case 4:
		case 5:
		{
			if(isdefined(self.fakemodel))
			{
				self.fakemodel.rate = newval;
			}
			break;
		}
		case 6:
		{
			self.fakemodel = spawn(localclientnum, self.origin, "script_model");
			if(isdefined(self.fakemodel))
			{
				self.fakemodel setmodel("zombietron_spider_egg");
				self.fakemodel setscale(0.5);
				self.fakemodel thread function_455fa2fe(localclientnum, self, "egg_explode");
			}
			break;
		}
		case 7:
		{
			if(isdefined(self.fakemodel))
			{
				self.fakemodel thread function_36c61ba6(localclientnum, 0, 0.5);
			}
			break;
		}
	}
}

/*
	Name: delay_for_clients_then_execute
	Namespace: namespace_693feb87
	Checksum: 0xA71F10D3
	Offset: 0x6180
	Size: 0x52
	Parameters: 1
	Flags: None
*/
function delay_for_clients_then_execute(func)
{
	wait(0.1);
	while(!clienthassnapshot(self.localclientnum))
	{
		wait(0.016);
	}
	wait(0.1);
	self thread [[func]]();
}

/*
	Name: function_ddbc17b4
	Namespace: namespace_693feb87
	Checksum: 0xF6D85C9D
	Offset: 0x61E0
	Size: 0x152
	Parameters: 3
	Flags: Linked
*/
function function_ddbc17b4(localclientnum, var_bac17ccf, var_2ca34dda)
{
	if(var_bac17ccf == 1 && getplayers(localclientnum).size == level.localplayers.size)
	{
		var_bac17ccf++;
	}
	if(var_bac17ccf == 4 && isdefined(level.doa.var_708cc739) && level.doa.var_708cc739 != 1)
	{
		var_bac17ccf++;
	}
	if(var_bac17ccf == 3 && level.localplayers.size > 1)
	{
		var_bac17ccf++;
	}
	if(var_bac17ccf > 4)
	{
		var_bac17ccf = 0;
	}
	if(var_bac17ccf == var_2ca34dda)
	{
		return var_2ca34dda;
	}
	if(level.doa.arenas[level.doa.current_arena].var_dd94482c & 1 << var_bac17ccf)
	{
		return var_bac17ccf;
	}
	return function_ddbc17b4(localclientnum, var_bac17ccf + 1, var_2ca34dda);
}

/*
	Name: changecamera
	Namespace: namespace_693feb87
	Checksum: 0x58366A3D
	Offset: 0x6340
	Size: 0x294
	Parameters: 7
	Flags: Linked
*/
function changecamera(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(localclientnum != 0)
	{
		return;
	}
	enablevr();
	setdvar("g_vrGameMode", 2);
	setdvar("cg_disableearthquake", 1);
	setdvar("vr_eyeScale", 0.3);
	if(!isdefined(self.var_44509e49))
	{
		self.var_44509e49 = 0;
	}
	var_f855b918 = self.var_44509e49;
	self.var_44509e49 = function_ddbc17b4(localclientnum, self.var_44509e49 + 1, self.var_44509e49);
	if(isdefined(self.var_4f118af8))
	{
		self.var_44509e49 = self.var_4f118af8;
	}
	self cameraforcedisablescriptcam(0);
	if(isdefined(level.doa.var_20e9a021) && level.doa.var_20e9a021)
	{
		self.var_44509e49 = 2;
	}
	if(self.var_44509e49 == 4)
	{
		level.doa.var_708cc739 = 1;
		namespace_3ca3c537::function_986ae2b3(localclientnum);
	}
	if(self.var_44509e49 == 3)
	{
		self cameraforcedisablescriptcam(1);
	}
	if(var_f855b918 == 4 && self.var_44509e49 != var_f855b918)
	{
		if(isdefined(level.doa.var_708cc739) && level.doa.var_708cc739 == 1)
		{
			level.doa.var_708cc739 = undefined;
			namespace_3ca3c537::function_986ae2b3(localclientnum);
		}
	}
	/#
		debugmsg("" + self getentitynumber() + "" + self.var_44509e49);
	#/
}

/*
	Name: function_bbb7743c
	Namespace: namespace_693feb87
	Checksum: 0xBEFB77A3
	Offset: 0x65E0
	Size: 0xB8
	Parameters: 7
	Flags: Linked
*/
function function_bbb7743c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayers()[0];
	if(newval)
	{
		level.doa.var_20e9a021 = 1;
		player.var_44509e49 = 2;
	}
	else
	{
		level.doa.var_20e9a021 = undefined;
		player.var_44509e49 = 0;
	}
}

/*
	Name: function_cee29ae7
	Namespace: namespace_693feb87
	Checksum: 0xBE0E84AE
	Offset: 0x66A0
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_cee29ae7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.var_7a6087fd = newval;
	player = getlocalplayers()[0];
	if(level.var_7a6087fd == 1)
	{
		player function_f7c0d598("default");
	}
	else
	{
		player function_f7c0d598();
	}
}

/*
	Name: function_cd844947
	Namespace: namespace_693feb87
	Checksum: 0x5B01A10E
	Offset: 0x6760
	Size: 0x414
	Parameters: 7
	Flags: Linked
*/
function function_cd844947(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	low = newval & 65535;
	high = newval >> 16;
	forward = anglestoforward(level.var_a32fbbc0);
	right = anglestoright(level.var_a32fbbc0);
	level.var_191c8154 = (0, 0, 0);
	if(low & 1)
	{
		level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_7526f3f5 + vectorscale((0, 0, 1), 10);
	}
	if(high & 1)
	{
		level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_7526f3f5 - vectorscale((0, 0, 1), 10);
	}
	if(low & 2)
	{
		level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_7526f3f5 + vectorscale(forward, 10);
	}
	if(high & 2)
	{
		level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_7526f3f5 - vectorscale(forward, 10);
	}
	if(low & 4)
	{
		level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_7526f3f5 + vectorscale(right, 10);
	}
	if(high & 4)
	{
		level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_7526f3f5 - vectorscale(right, 10);
	}
	if(low & 8)
	{
		level.var_83a34f19 = level.var_83a34f19 - 1;
	}
	if(high & 8)
	{
		level.var_83a34f19 = level.var_83a34f19 + 1;
	}
	if(low & 16)
	{
		level.var_e9c73e06 = level.var_e9c73e06 - 1;
	}
	if(high & 16)
	{
		level.var_e9c73e06 = level.var_e9c73e06 + 1;
	}
}

/*
	Name: function_efeeaa92
	Namespace: namespace_693feb87
	Checksum: 0xC530B83A
	Offset: 0x6B80
	Size: 0x4C
	Parameters: 7
	Flags: Linked
*/
function function_efeeaa92(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	cleanupspawneddynents();
}

/*
	Name: debugmsg
	Namespace: namespace_693feb87
	Checksum: 0x9913422E
	Offset: 0x6BD8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function debugmsg(txt)
{
	/#
		println("" + txt);
	#/
}

/*
	Name: function_12c2fbcb
	Namespace: namespace_693feb87
	Checksum: 0xF7124A0C
	Offset: 0x6C18
	Size: 0x41C
	Parameters: 0
	Flags: Linked
*/
function function_12c2fbcb()
{
	if(!isdefined(self.var_ec1cda64))
	{
		self.var_ec1cda64 = [];
	}
	if(!isdefined(self.doa))
	{
		self.entnum = self getentitynumber();
		self.doa = level.var_29e6f519[self.entnum];
		if(isdefined(self.doa.player))
		{
			/#
				loc_00006CBC:
				loc_00006CFC:
				debugmsg("" + (isdefined(self.name) ? self.name : "") + "" + (isdefined(self.doa.player) ? self.doa.player.name : "") + "" + self getentitynumber() + "" + (isdefined(self.doa.player) ? self.doa.player getentitynumber() : -1));
			#/
			/#
				assert(self.doa.player == self);
			#/
		}
		namespace_64c6b720::function_e06716c7(self.doa);
		self.doa.player = self;
		/#
			loc_00006DF4:
			debugmsg("" + (isdefined(self.name) ? self.name : "") + "" + self.entnum + "" + (isdefined(self.doa.player) ? self.doa.player getentitynumber() : -1));
		#/
		self cameraforcedisablescriptcam(0);
		self camerasetupdatecallback(&namespace_ad544aeb::function_d207ecc1);
		setdvar("vr_playerScale", 30);
		setfriendlynamedraw(0);
		if(self islocalplayer())
		{
			self.var_44509e49 = namespace_3ca3c537::function_9f1a0b26(0);
		}
		level notify(#"hash_aae01d5a", self.doa.player.entnum, self.doa.var_c88a6593);
		if(self islocalplayer())
		{
			localclientnum = self getlocalclientnumber();
			switch(self.entnum)
			{
				case 0:
				{
					self setcontrollerlightbarcolor(localclientnum, (0, 1, 0));
					break;
				}
				case 1:
				{
					self setcontrollerlightbarcolor(localclientnum, (0, 0, 1));
					break;
				}
				case 2:
				{
					self setcontrollerlightbarcolor(localclientnum, (1, 0, 0));
					break;
				}
				case 3:
				{
					self setcontrollerlightbarcolor(localclientnum, (1, 1, 0));
					break;
				}
			}
		}
	}
	self thread function_f7c0d598();
}

/*
	Name: function_c33d3992
	Namespace: namespace_693feb87
	Checksum: 0xC0A82063
	Offset: 0x7040
	Size: 0x42C
	Parameters: 1
	Flags: None
*/
function function_c33d3992(localclientnum)
{
	if(!clienthassnapshot(localclientnum))
	{
		/#
			debugmsg("" + (isdefined(self.name) ? self.name : "") + "");
		#/
		return 0;
	}
	if(!self isplayer())
	{
		/#
			debugmsg("" + (isdefined(self.name) ? self.name : "") + "");
		#/
		return 0;
	}
	if(!self hasdobj(localclientnum))
	{
		/#
			debugmsg("" + (isdefined(self.name) ? self.name : "") + "");
		#/
		return 0;
	}
	if(self islocalplayer() && !isdefined(self getlocalclientnumber()))
	{
		/#
			debugmsg("" + (isdefined(self.name) ? self.name : "") + "");
		#/
		return 0;
	}
	if(isspectating(localclientnum))
	{
		/#
			debugmsg("" + (isdefined(self.name) ? self.name : "") + "");
		#/
		return 0;
	}
	if(isdemoplaying())
	{
		/#
			debugmsg("" + (isdefined(self.name) ? self.name : "") + "");
		#/
		return 0;
	}
	if(self islocalplayer() && isdefined(self getlocalclientnumber()))
	{
		spectated = playerbeingspectated(self getlocalclientnumber());
		if(self != spectated)
		{
			/#
				debugmsg("" + (isdefined(self.name) ? self.name : "") + "");
			#/
			return 0;
		}
	}
	doa = level.var_29e6f519[self getentitynumber()];
	if(isdefined(doa.player) && doa.player != self)
	{
		/#
			debugmsg("" + (isdefined(self.name) ? self.name : "") + "" + doa.player.name + "" + self getentitynumber() + "" + doa.player getentitynumber());
		#/
		return 0;
	}
	return 1;
}

/*
	Name: function_5c2a88d5
	Namespace: namespace_693feb87
	Checksum: 0x9D648174
	Offset: 0x7478
	Size: 0x1E0
	Parameters: 0
	Flags: Linked
*/
function function_5c2a88d5()
{
	level endon(#"hash_a2a24535");
	while(true)
	{
		setsoundcontext("water", "over");
		foreach(var_e06199f2, player in getlocalplayers())
		{
			player setsoundentcontext("water", "over");
		}
		level waittill(#"hash_c4c783f9");
		forceambientroom("cp_doa_fps_mode");
		setsoundcontext("water", "under");
		foreach(var_eb5d91b8, player in getlocalplayers())
		{
			player setsoundentcontext("water", "under");
		}
		level waittill(#"hash_fca9c70d");
		forceambientroom("");
	}
}

/*
	Name: drawcylinder
	Namespace: namespace_693feb87
	Checksum: 0xB8CBF264
	Offset: 0x7660
	Size: 0x2FA
	Parameters: 5
	Flags: Linked
*/
function drawcylinder(pos, rad, height, frames = 60, color = (0, 0, 0))
{
	/#
		self endon(#"stop_cylinder");
		self endon(#"entityshutdown");
		currad = rad;
		curheight = height;
		for(frames = int(frames); frames; frames--)
		{
			for(r = 0; r < 20; r++)
			{
				theta = r / 20 * 360;
				theta2 = r + 1 / 20 * 360;
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0), color);
				line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight), color);
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight), color);
			}
			wait(0.016);
		}
	#/
}

