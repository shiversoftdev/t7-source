// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace callback;

/*
	Name: callback
	Namespace: callback
	Checksum: 0xEAAD0C5C
	Offset: 0x1E0
	Size: 0x14C
	Parameters: 3
	Flags: Linked
*/
function callback(event, localclientnum, params)
{
	if(isdefined(level._callbacks) && isdefined(level._callbacks[event]))
	{
		for(i = 0; i < level._callbacks[event].size; i++)
		{
			callback = level._callbacks[event][i][0];
			obj = level._callbacks[event][i][1];
			if(!isdefined(callback))
			{
				continue;
			}
			if(isdefined(obj))
			{
				if(isdefined(params))
				{
					obj thread [[callback]](localclientnum, self, params);
				}
				else
				{
					obj thread [[callback]](localclientnum, self);
				}
				continue;
			}
			if(isdefined(params))
			{
				self thread [[callback]](localclientnum, params);
				continue;
			}
			self thread [[callback]](localclientnum);
		}
	}
}

/*
	Name: entity_callback
	Namespace: callback
	Checksum: 0x6971A7B4
	Offset: 0x338
	Size: 0x14C
	Parameters: 3
	Flags: Linked
*/
function entity_callback(event, localclientnum, params)
{
	if(isdefined(self._callbacks) && isdefined(self._callbacks[event]))
	{
		for(i = 0; i < self._callbacks[event].size; i++)
		{
			callback = self._callbacks[event][i][0];
			obj = self._callbacks[event][i][1];
			if(!isdefined(callback))
			{
				continue;
			}
			if(isdefined(obj))
			{
				if(isdefined(params))
				{
					obj thread [[callback]](localclientnum, self, params);
				}
				else
				{
					obj thread [[callback]](localclientnum, self);
				}
				continue;
			}
			if(isdefined(params))
			{
				self thread [[callback]](localclientnum, params);
				continue;
			}
			self thread [[callback]](localclientnum);
		}
	}
}

/*
	Name: add_callback
	Namespace: callback
	Checksum: 0x3A916861
	Offset: 0x490
	Size: 0x18C
	Parameters: 3
	Flags: Linked
*/
function add_callback(event, func, obj)
{
	/#
		assert(isdefined(event), "");
	#/
	if(!isdefined(level._callbacks) || !isdefined(level._callbacks[event]))
	{
		level._callbacks[event] = [];
	}
	foreach(callback in level._callbacks[event])
	{
		if(callback[0] == func)
		{
			if(!isdefined(obj) || callback[1] == obj)
			{
				return;
			}
		}
	}
	array::add(level._callbacks[event], array(func, obj), 0);
	if(isdefined(obj))
	{
		obj thread remove_callback_on_death(event, func);
	}
}

/*
	Name: add_entity_callback
	Namespace: callback
	Checksum: 0x47B03572
	Offset: 0x628
	Size: 0x164
	Parameters: 3
	Flags: Linked
*/
function add_entity_callback(event, func, obj)
{
	/#
		assert(isdefined(event), "");
	#/
	if(!isdefined(self._callbacks) || !isdefined(self._callbacks[event]))
	{
		self._callbacks[event] = [];
	}
	foreach(callback in self._callbacks[event])
	{
		if(callback[0] == func)
		{
			if(!isdefined(obj) || callback[1] == obj)
			{
				return;
			}
		}
	}
	array::add(self._callbacks[event], array(func, obj), 0);
}

/*
	Name: remove_callback_on_death
	Namespace: callback
	Checksum: 0x1E0389D7
	Offset: 0x798
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function remove_callback_on_death(event, func)
{
	self waittill(#"death");
	remove_callback(event, func, self);
}

/*
	Name: remove_callback
	Namespace: callback
	Checksum: 0xF6DBDC0B
	Offset: 0x7E0
	Size: 0x13A
	Parameters: 3
	Flags: Linked
*/
function remove_callback(event, func, obj)
{
	/#
		assert(isdefined(event), "");
	#/
	/#
		assert(isdefined(level._callbacks[event]), "");
	#/
	foreach(index, func_group in level._callbacks[event])
	{
		if(func_group[0] == func)
		{
			if(func_group[1] === obj)
			{
				arrayremoveindex(level._callbacks[event], index, 0);
			}
		}
	}
}

/*
	Name: on_localclient_connect
	Namespace: callback
	Checksum: 0x9E9C1FB7
	Offset: 0x928
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_localclient_connect(func, obj)
{
	add_callback(#"hash_da8d7d74", func, obj);
}

/*
	Name: on_localclient_shutdown
	Namespace: callback
	Checksum: 0x5F5EAA03
	Offset: 0x968
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_localclient_shutdown(func, obj)
{
	add_callback(#"hash_e64327a6", func, obj);
}

/*
	Name: on_finalize_initialization
	Namespace: callback
	Checksum: 0x827B66A7
	Offset: 0x9A8
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_finalize_initialization(func, obj)
{
	add_callback(#"hash_36fb1b1a", func, obj);
}

/*
	Name: on_localplayer_spawned
	Namespace: callback
	Checksum: 0x94E186A6
	Offset: 0x9E8
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_localplayer_spawned(func, obj)
{
	add_callback(#"hash_842e788a", func, obj);
}

/*
	Name: remove_on_localplayer_spawned
	Namespace: callback
	Checksum: 0x49CE9DFB
	Offset: 0xA28
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_localplayer_spawned(func, obj)
{
	remove_callback(#"hash_842e788a", func, obj);
}

/*
	Name: on_spawned
	Namespace: callback
	Checksum: 0x4606D377
	Offset: 0xA68
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_spawned(func, obj)
{
	add_callback(#"hash_bc12b61f", func, obj);
}

/*
	Name: remove_on_spawned
	Namespace: callback
	Checksum: 0xD71999B3
	Offset: 0xAA8
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_spawned(func, obj)
{
	remove_callback(#"hash_bc12b61f", func, obj);
}

/*
	Name: on_shutdown
	Namespace: callback
	Checksum: 0xE963B01A
	Offset: 0xAE8
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_shutdown(func, obj)
{
	add_entity_callback(#"hash_390259d9", func, obj);
}

/*
	Name: on_start_gametype
	Namespace: callback
	Checksum: 0x7CBF803B
	Offset: 0xB28
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_start_gametype(func, obj)
{
	add_callback(#"hash_cc62acca", func, obj);
}

/*
	Name: codecallback_preinitialization
	Namespace: callback
	Checksum: 0xBD9EE26C
	Offset: 0xB68
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function codecallback_preinitialization()
{
	callback(#"hash_ecc6aecf");
	system::run_pre_systems();
}

/*
	Name: codecallback_finalizeinitialization
	Namespace: callback
	Checksum: 0xAC821D11
	Offset: 0xBA0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function codecallback_finalizeinitialization()
{
	system::run_post_systems();
	callback(#"hash_36fb1b1a");
}

/*
	Name: codecallback_statechange
	Namespace: callback
	Checksum: 0x6B4192EF
	Offset: 0xBD8
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function codecallback_statechange(clientnum, system, newstate)
{
	if(!isdefined(level._systemstates))
	{
		level._systemstates = [];
	}
	if(!isdefined(level._systemstates[system]))
	{
		level._systemstates[system] = spawnstruct();
	}
	level._systemstates[system].state = newstate;
	if(isdefined(level._systemstates[system].callback))
	{
		[[level._systemstates[system].callback]](clientnum, newstate);
	}
	else
	{
		/#
			println(("" + system) + "");
		#/
	}
}

/*
	Name: codecallback_maprestart
	Namespace: callback
	Checksum: 0xB1A144AF
	Offset: 0xCE0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function codecallback_maprestart()
{
	/#
		println("");
	#/
	util::waitforclient(0);
	level thread util::init_utility();
}

/*
	Name: codecallback_localclientconnect
	Namespace: callback
	Checksum: 0xA3189630
	Offset: 0xD40
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function codecallback_localclientconnect(localclientnum)
{
	/#
		println("" + localclientnum);
	#/
	[[level.callbacklocalclientconnect]](localclientnum);
}

/*
	Name: codecallback_localclientdisconnect
	Namespace: callback
	Checksum: 0xC07545D1
	Offset: 0xD90
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function codecallback_localclientdisconnect(clientnum)
{
	/#
		println("" + clientnum);
	#/
}

/*
	Name: codecallback_glasssmash
	Namespace: callback
	Checksum: 0x2C1D9C42
	Offset: 0xDD0
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function codecallback_glasssmash(org, dir)
{
	level notify(#"glass_smash", org, dir);
}

/*
	Name: codecallback_soundsetambientstate
	Namespace: callback
	Checksum: 0x24FB4F5E
	Offset: 0xE08
	Size: 0x54
	Parameters: 5
	Flags: Linked
*/
function codecallback_soundsetambientstate(ambientroom, ambientpackage, roomcollidercent, packagecollidercent, defaultroom)
{
	audio::setcurrentambientstate(ambientroom, ambientpackage, roomcollidercent, packagecollidercent, defaultroom);
}

/*
	Name: codecallback_soundsetaiambientstate
	Namespace: callback
	Checksum: 0x89379260
	Offset: 0xE68
	Size: 0x1C
	Parameters: 3
	Flags: Linked
*/
function codecallback_soundsetaiambientstate(triggers, actors, numtriggers)
{
}

/*
	Name: codecallback_soundplayuidecodeloop
	Namespace: callback
	Checksum: 0x30140C87
	Offset: 0xE90
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function codecallback_soundplayuidecodeloop(decodestring, playtimems)
{
	self thread audio::soundplayuidecodeloop(decodestring, playtimems);
}

/*
	Name: codecallback_playerspawned
	Namespace: callback
	Checksum: 0xA19A4E89
	Offset: 0xED0
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function codecallback_playerspawned(localclientnum)
{
	/#
		println("");
	#/
	[[level.callbackplayerspawned]](localclientnum);
}

/*
	Name: codecallback_gibevent
	Namespace: callback
	Checksum: 0x6E34919E
	Offset: 0xF18
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function codecallback_gibevent(localclientnum, type, locations)
{
	if(isdefined(level._gibeventcbfunc))
	{
		self thread [[level._gibeventcbfunc]](localclientnum, type, locations);
	}
}

/*
	Name: codecallback_precachegametype
	Namespace: callback
	Checksum: 0x8C9E42C4
	Offset: 0xF68
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function codecallback_precachegametype()
{
	if(isdefined(level.callbackprecachegametype))
	{
		[[level.callbackprecachegametype]]();
	}
}

/*
	Name: codecallback_startgametype
	Namespace: callback
	Checksum: 0x98EA46D7
	Offset: 0xF90
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function codecallback_startgametype()
{
	if(isdefined(level.callbackstartgametype) && (!isdefined(level.gametypestarted) || !level.gametypestarted))
	{
		[[level.callbackstartgametype]]();
		level.gametypestarted = 1;
	}
}

/*
	Name: codecallback_entityspawned
	Namespace: callback
	Checksum: 0x90291AD2
	Offset: 0xFE0
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function codecallback_entityspawned(localclientnum)
{
	[[level.callbackentityspawned]](localclientnum);
}

/*
	Name: codecallback_soundnotify
	Namespace: callback
	Checksum: 0x33D10E9C
	Offset: 0x1008
	Size: 0x76
	Parameters: 3
	Flags: Linked
*/
function codecallback_soundnotify(localclientnum, entity, note)
{
	switch(note)
	{
		case "scr_bomb_beep":
		{
			if(getgametypesetting("silentPlant") == 0)
			{
				entity playsound(localclientnum, "fly_bomb_buttons_npc");
			}
			break;
		}
	}
}

/*
	Name: codecallback_entityshutdown
	Namespace: callback
	Checksum: 0xC75C4AEA
	Offset: 0x1088
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function codecallback_entityshutdown(localclientnum, entity)
{
	if(isdefined(level.callbackentityshutdown))
	{
		[[level.callbackentityshutdown]](localclientnum, entity);
	}
	entity entity_callback(#"hash_390259d9", localclientnum);
}

/*
	Name: codecallback_localclientshutdown
	Namespace: callback
	Checksum: 0x6444FB87
	Offset: 0x10F0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function codecallback_localclientshutdown(localclientnum, entity)
{
	level.localplayers = getlocalplayers();
	entity callback(#"hash_e64327a6", localclientnum);
}

/*
	Name: codecallback_localclientchanged
	Namespace: callback
	Checksum: 0x2B71FF28
	Offset: 0x1148
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function codecallback_localclientchanged(localclientnum, entity)
{
	level.localplayers = getlocalplayers();
}

/*
	Name: codecallback_airsupport
	Namespace: callback
	Checksum: 0xA7A85A58
	Offset: 0x1180
	Size: 0xB0
	Parameters: 12
	Flags: Linked
*/
function codecallback_airsupport(localclientnum, x, y, z, type, yaw, team, teamfaction, owner, exittype, time, height)
{
	if(isdefined(level.callbackairsupport))
	{
		[[level.callbackairsupport]](localclientnum, x, y, z, type, yaw, team, teamfaction, owner, exittype, time, height);
	}
}

/*
	Name: codecallback_demojump
	Namespace: callback
	Checksum: 0x37011C8D
	Offset: 0x1238
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function codecallback_demojump(localclientnum, time)
{
	level notify(#"demo_jump", time);
	level notify("demo_jump" + localclientnum, time);
}

/*
	Name: codecallback_demoplayerswitch
	Namespace: callback
	Checksum: 0xE50F14C4
	Offset: 0x1280
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function codecallback_demoplayerswitch(localclientnum)
{
	level notify(#"demo_player_switch");
	level notify("demo_player_switch" + localclientnum);
}

/*
	Name: codecallback_playerswitch
	Namespace: callback
	Checksum: 0xA27AE773
	Offset: 0x12B8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function codecallback_playerswitch(localclientnum)
{
	level notify(#"player_switch");
	level notify("player_switch" + localclientnum);
}

/*
	Name: codecallback_killcambegin
	Namespace: callback
	Checksum: 0xF3EFFED8
	Offset: 0x12F0
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function codecallback_killcambegin(localclientnum, time)
{
	level notify(#"killcam_begin", time);
	level notify("killcam_begin" + localclientnum, time);
}

/*
	Name: codecallback_killcamend
	Namespace: callback
	Checksum: 0xC28A1AB2
	Offset: 0x1338
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function codecallback_killcamend(localclientnum, time)
{
	level notify(#"killcam_end", time);
	level notify("killcam_end" + localclientnum, time);
}

/*
	Name: codecallback_creatingcorpse
	Namespace: callback
	Checksum: 0x3F32EBFA
	Offset: 0x1380
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function codecallback_creatingcorpse(localclientnum, player)
{
	if(isdefined(level.callbackcreatingcorpse))
	{
		[[level.callbackcreatingcorpse]](localclientnum, player);
	}
}

/*
	Name: codecallback_playerfoliage
	Namespace: callback
	Checksum: 0x5110290A
	Offset: 0x13C0
	Size: 0x44
	Parameters: 4
	Flags: Linked
*/
function codecallback_playerfoliage(client_num, player, firstperson, quiet)
{
	footsteps::playerfoliage(client_num, player, firstperson, quiet);
}

/*
	Name: codecallback_activateexploder
	Namespace: callback
	Checksum: 0xC45A0B4A
	Offset: 0x1410
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function codecallback_activateexploder(exploder_id)
{
	if(!isdefined(level._exploder_ids))
	{
		return;
	}
	keys = getarraykeys(level._exploder_ids);
	exploder = undefined;
	for(i = 0; i < keys.size; i++)
	{
		if(level._exploder_ids[keys[i]] == exploder_id)
		{
			exploder = keys[i];
			break;
		}
	}
	if(!isdefined(exploder))
	{
		return;
	}
	exploder::activate_exploder(exploder);
}

/*
	Name: codecallback_deactivateexploder
	Namespace: callback
	Checksum: 0x77BF9CBD
	Offset: 0x14E8
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function codecallback_deactivateexploder(exploder_id)
{
	if(!isdefined(level._exploder_ids))
	{
		return;
	}
	keys = getarraykeys(level._exploder_ids);
	exploder = undefined;
	for(i = 0; i < keys.size; i++)
	{
		if(level._exploder_ids[keys[i]] == exploder_id)
		{
			exploder = keys[i];
			break;
		}
	}
	if(!isdefined(exploder))
	{
		return;
	}
	exploder::stop_exploder(exploder);
}

/*
	Name: codecallback_chargeshotweaponsoundnotify
	Namespace: callback
	Checksum: 0x1C1D043E
	Offset: 0x15C0
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function codecallback_chargeshotweaponsoundnotify(localclientnum, weapon, chargeshotlevel)
{
	if(isdefined(level.sndchargeshot_func))
	{
		self [[level.sndchargeshot_func]](localclientnum, weapon, chargeshotlevel);
	}
}

/*
	Name: codecallback_hostmigration
	Namespace: callback
	Checksum: 0xF810AE0A
	Offset: 0x1610
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function codecallback_hostmigration(localclientnum)
{
	/#
		println("");
	#/
	if(isdefined(level.callbackhostmigration))
	{
		[[level.callbackhostmigration]](localclientnum);
	}
}

/*
	Name: codecallback_dogsoundnotify
	Namespace: callback
	Checksum: 0xE967BE99
	Offset: 0x1668
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function codecallback_dogsoundnotify(client_num, entity, note)
{
	if(isdefined(level.callbackdogsoundnotify))
	{
		[[level.callbackdogsoundnotify]](client_num, entity, note);
	}
}

/*
	Name: codecallback_playaifootstep
	Namespace: callback
	Checksum: 0xF8F39517
	Offset: 0x16B8
	Size: 0x50
	Parameters: 5
	Flags: Linked
*/
function codecallback_playaifootstep(client_num, pos, surface, notetrack, bone)
{
	[[level.callbackplayaifootstep]](client_num, pos, surface, notetrack, bone);
}

/*
	Name: codecallback_playlightloopexploder
	Namespace: callback
	Checksum: 0xD5261361
	Offset: 0x1710
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function codecallback_playlightloopexploder(exploderindex)
{
	[[level.callbackplaylightloopexploder]](exploderindex);
}

/*
	Name: codecallback_stoplightloopexploder
	Namespace: callback
	Checksum: 0xC9492D6B
	Offset: 0x1738
	Size: 0x1A2
	Parameters: 1
	Flags: Linked
*/
function codecallback_stoplightloopexploder(exploderindex)
{
	num = int(exploderindex);
	if(isdefined(level.createfxexploders[num]))
	{
		for(i = 0; i < level.createfxexploders[num].size; i++)
		{
			ent = level.createfxexploders[num][i];
			if(!isdefined(ent.looperfx))
			{
				ent.looperfx = [];
			}
			for(clientnum = 0; clientnum < level.max_local_clients; clientnum++)
			{
				if(localclientactive(clientnum))
				{
					if(isdefined(ent.looperfx[clientnum]))
					{
						for(looperfxcount = 0; looperfxcount < ent.looperfx[clientnum].size; looperfxcount++)
						{
							deletefx(clientnum, ent.looperfx[clientnum][looperfxcount]);
						}
					}
				}
				ent.looperfx[clientnum] = [];
			}
			ent.looperfx = [];
		}
	}
}

/*
	Name: codecallback_clientflag
	Namespace: callback
	Checksum: 0xB0124B18
	Offset: 0x18E8
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function codecallback_clientflag(localclientnum, flag, set)
{
	if(isdefined(level.callbackclientflag))
	{
		[[level.callbackclientflag]](localclientnum, flag, set);
	}
}

/*
	Name: codecallback_clientflagasval
	Namespace: callback
	Checksum: 0x6EE22F78
	Offset: 0x1938
	Size: 0x5A
	Parameters: 2
	Flags: None
*/
function codecallback_clientflagasval(localclientnum, val)
{
	if(isdefined(level._client_flagasval_callbacks) && isdefined(level._client_flagasval_callbacks[self.type]))
	{
		self thread [[level._client_flagasval_callbacks[self.type]]](localclientnum, val);
	}
}

/*
	Name: codecallback_extracamrenderhero
	Namespace: callback
	Checksum: 0x99E51925
	Offset: 0x19A0
	Size: 0x5C
	Parameters: 5
	Flags: Linked
*/
function codecallback_extracamrenderhero(localclientnum, jobindex, extracamindex, sessionmode, characterindex)
{
	if(isdefined(level.extra_cam_render_hero_func_callback))
	{
		[[level.extra_cam_render_hero_func_callback]](localclientnum, jobindex, extracamindex, sessionmode, characterindex);
	}
}

/*
	Name: codecallback_extracamrenderlobbyclienthero
	Namespace: callback
	Checksum: 0xE5D74533
	Offset: 0x1A08
	Size: 0x50
	Parameters: 4
	Flags: Linked
*/
function codecallback_extracamrenderlobbyclienthero(localclientnum, jobindex, extracamindex, sessionmode)
{
	if(isdefined(level.extra_cam_render_lobby_client_hero_func_callback))
	{
		[[level.extra_cam_render_lobby_client_hero_func_callback]](localclientnum, jobindex, extracamindex, sessionmode);
	}
}

/*
	Name: codecallback_extracamrendercurrentheroheadshot
	Namespace: callback
	Checksum: 0x7E10C680
	Offset: 0x1A60
	Size: 0x68
	Parameters: 6
	Flags: Linked
*/
function codecallback_extracamrendercurrentheroheadshot(localclientnum, jobindex, extracamindex, sessionmode, characterindex, isdefaulthero)
{
	if(isdefined(level.extra_cam_render_current_hero_headshot_func_callback))
	{
		[[level.extra_cam_render_current_hero_headshot_func_callback]](localclientnum, jobindex, extracamindex, sessionmode, characterindex, isdefaulthero);
	}
}

/*
	Name: codecallback_extracamrendercharacterbodyitem
	Namespace: callback
	Checksum: 0xE648D319
	Offset: 0x1AD0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function codecallback_extracamrendercharacterbodyitem(localclientnum, jobindex, extracamindex, sessionmode, characterindex, itemindex, defaultitemrender)
{
	if(isdefined(level.extra_cam_render_character_body_item_func_callback))
	{
		[[level.extra_cam_render_character_body_item_func_callback]](localclientnum, jobindex, extracamindex, sessionmode, characterindex, itemindex, defaultitemrender);
	}
}

/*
	Name: codecallback_extracamrendercharacterhelmetitem
	Namespace: callback
	Checksum: 0x31A14D17
	Offset: 0x1B50
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function codecallback_extracamrendercharacterhelmetitem(localclientnum, jobindex, extracamindex, sessionmode, characterindex, itemindex, defaultitemrender)
{
	if(isdefined(level.extra_cam_render_character_helmet_item_func_callback))
	{
		[[level.extra_cam_render_character_helmet_item_func_callback]](localclientnum, jobindex, extracamindex, sessionmode, characterindex, itemindex, defaultitemrender);
	}
}

/*
	Name: codecallback_extracamrendercharacterheaditem
	Namespace: callback
	Checksum: 0xAA2CDCF9
	Offset: 0x1BD0
	Size: 0x68
	Parameters: 6
	Flags: Linked
*/
function codecallback_extracamrendercharacterheaditem(localclientnum, jobindex, extracamindex, sessionmode, headindex, defaultitemrender)
{
	if(isdefined(level.extra_cam_render_character_head_item_func_callback))
	{
		[[level.extra_cam_render_character_head_item_func_callback]](localclientnum, jobindex, extracamindex, sessionmode, headindex, defaultitemrender);
	}
}

/*
	Name: codecallback_extracamrenderoutfitpreview
	Namespace: callback
	Checksum: 0xE2BA0ABA
	Offset: 0x1C40
	Size: 0x5C
	Parameters: 5
	Flags: Linked
*/
function codecallback_extracamrenderoutfitpreview(localclientnum, jobindex, extracamindex, sessionmode, outfitindex)
{
	if(isdefined(level.extra_cam_render_outfit_preview_func_callback))
	{
		[[level.extra_cam_render_outfit_preview_func_callback]](localclientnum, jobindex, extracamindex, sessionmode, outfitindex);
	}
}

/*
	Name: codecallback_extracamrenderwcpaintjobicon
	Namespace: callback
	Checksum: 0x8A9A6CCF
	Offset: 0x1CA8
	Size: 0x98
	Parameters: 10
	Flags: Linked
*/
function codecallback_extracamrenderwcpaintjobicon(localclientnum, extracamindex, jobindex, attachmentvariantstring, weaponoptions, weaponplusattachments, loadoutslot, paintjobindex, paintjobslot, isfilesharepreview)
{
	if(isdefined(level.extra_cam_render_wc_paintjobicon_func_callback))
	{
		[[level.extra_cam_render_wc_paintjobicon_func_callback]](localclientnum, extracamindex, jobindex, attachmentvariantstring, weaponoptions, weaponplusattachments, loadoutslot, paintjobindex, paintjobslot, isfilesharepreview);
	}
}

/*
	Name: codecallback_extracamrenderwcvarianticon
	Namespace: callback
	Checksum: 0x9F9E78A4
	Offset: 0x1D48
	Size: 0x98
	Parameters: 10
	Flags: Linked
*/
function codecallback_extracamrenderwcvarianticon(localclientnum, extracamindex, jobindex, attachmentvariantstring, weaponoptions, weaponplusattachments, loadoutslot, paintjobindex, paintjobslot, isfilesharepreview)
{
	if(isdefined(level.extra_cam_render_wc_varianticon_func_callback))
	{
		[[level.extra_cam_render_wc_varianticon_func_callback]](localclientnum, extracamindex, jobindex, attachmentvariantstring, weaponoptions, weaponplusattachments, loadoutslot, paintjobindex, paintjobslot, isfilesharepreview);
	}
}

/*
	Name: codecallback_collectibleschanged
	Namespace: callback
	Checksum: 0x687CCC9A
	Offset: 0x1DE8
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function codecallback_collectibleschanged(changedclient, collectiblesarray, localclientnum)
{
	if(isdefined(level.on_collectibles_change))
	{
		[[level.on_collectibles_change]](changedclient, collectiblesarray, localclientnum);
	}
}

/*
	Name: add_weapon_type
	Namespace: callback
	Checksum: 0xBEBA8A1E
	Offset: 0x1E38
	Size: 0x72
	Parameters: 2
	Flags: Linked
*/
function add_weapon_type(weapontype, callback)
{
	if(!isdefined(level.weapon_type_callback_array))
	{
		level.weapon_type_callback_array = [];
	}
	if(isstring(weapontype))
	{
		weapontype = getweapon(weapontype);
	}
	level.weapon_type_callback_array[weapontype] = callback;
}

/*
	Name: spawned_weapon_type
	Namespace: callback
	Checksum: 0xFCE44147
	Offset: 0x1EB8
	Size: 0x62
	Parameters: 1
	Flags: Linked
*/
function spawned_weapon_type(localclientnum)
{
	weapontype = self.weapon.rootweapon;
	if(isdefined(level.weapon_type_callback_array) && isdefined(level.weapon_type_callback_array[weapontype]))
	{
		self thread [[level.weapon_type_callback_array[weapontype]]](localclientnum);
	}
}

/*
	Name: codecallback_callclientscript
	Namespace: callback
	Checksum: 0xE70A8280
	Offset: 0x1F28
	Size: 0x5A
	Parameters: 3
	Flags: Linked
*/
function codecallback_callclientscript(pself, label, param)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		return;
	}
	if(isdefined(level._animnotifyfuncs[label]))
	{
		pself [[level._animnotifyfuncs[label]]](param);
	}
}

/*
	Name: codecallback_callclientscriptonlevel
	Namespace: callback
	Checksum: 0x18C60AD5
	Offset: 0x1F90
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function codecallback_callclientscriptonlevel(label, param)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		return;
	}
	if(isdefined(level._animnotifyfuncs[label]))
	{
		level [[level._animnotifyfuncs[label]]](param);
	}
}

/*
	Name: codecallback_serversceneinit
	Namespace: callback
	Checksum: 0x6C4AAD3A
	Offset: 0x1FF0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function codecallback_serversceneinit(scene_name)
{
	if(isdefined(level.server_scenes[scene_name]))
	{
		level thread scene::init(scene_name);
	}
}

/*
	Name: codecallback_serversceneplay
	Namespace: callback
	Checksum: 0x1EE31FD4
	Offset: 0x2030
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function codecallback_serversceneplay(scene_name)
{
	level thread scene_black_screen();
	if(isdefined(level.server_scenes[scene_name]))
	{
		level thread scene::play(scene_name);
	}
}

/*
	Name: codecallback_serverscenestop
	Namespace: callback
	Checksum: 0x1DC0BB33
	Offset: 0x2088
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function codecallback_serverscenestop(scene_name)
{
	level thread scene_black_screen();
	if(isdefined(level.server_scenes[scene_name]))
	{
		level thread scene::stop(scene_name, undefined, undefined, undefined, 1);
	}
}

/*
	Name: scene_black_screen
	Namespace: callback
	Checksum: 0xA6FB2505
	Offset: 0x20F0
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function scene_black_screen()
{
	foreach(i, player in level.localplayers)
	{
		if(!isdefined(player.lui_black))
		{
			player.lui_black = createluimenu(i, "FullScreenBlack");
			openluimenu(i, player.lui_black);
		}
	}
	wait(0.016);
	foreach(i, player in level.localplayers)
	{
		if(isdefined(player.lui_black))
		{
			closeluimenu(i, player.lui_black);
			player.lui_black = undefined;
		}
	}
}

/*
	Name: codecallback_gadgetvisionpulse_reveal
	Namespace: callback
	Checksum: 0x9EC38FA0
	Offset: 0x2270
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function codecallback_gadgetvisionpulse_reveal(local_client_num, entity, breveal)
{
	if(isdefined(level.gadgetvisionpulse_reveal_func))
	{
		entity [[level.gadgetvisionpulse_reveal_func]](local_client_num, breveal);
	}
}

