// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_perks;

#namespace zm_playerhealth;

/*
	Name: __init__sytem__
	Namespace: zm_playerhealth
	Checksum: 0x31E42B91
	Offset: 0x2E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_playerhealth", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_playerhealth
	Checksum: 0x1E9DB964
	Offset: 0x328
	Size: 0x33C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "sndZombieHealth", 21000, 1, "int");
	level.global_damage_func_ads = &empty_kill_func;
	level.global_damage_func = &empty_kill_func;
	level.difficultytype[0] = "easy";
	level.difficultytype[1] = "normal";
	level.difficultytype[2] = "hardened";
	level.difficultytype[3] = "veteran";
	level.difficultystring["easy"] = &"GAMESKILL_EASY";
	level.difficultystring["normal"] = &"GAMESKILL_NORMAL";
	level.difficultystring["hardened"] = &"GAMESKILL_HARDENED";
	level.difficultystring["veteran"] = &"GAMESKILL_VETERAN";
	/#
		thread playerhealthdebug();
	#/
	level.gameskill = 1;
	switch(level.gameskill)
	{
		case 0:
		{
			setdvar("currentDifficulty", "easy");
			break;
		}
		case 1:
		{
			setdvar("currentDifficulty", "normal");
			break;
		}
		case 2:
		{
			setdvar("currentDifficulty", "hardened");
			break;
		}
		case 3:
		{
			setdvar("currentDifficulty", "veteran");
			break;
		}
	}
	/#
		print("" + level.gameskill);
	#/
	level.player_deathinvulnerabletime = 1700;
	level.longregentime = 5000;
	level.healthoverlaycutoff = 0.2;
	level.invultime_preshield = 0.35;
	level.invultime_onshield = 0.5;
	level.invultime_postshield = 0.3;
	level.playerhealth_regularregendelay = 2400;
	level.worthydamageratio = 0.1;
	callback::on_spawned(&on_player_spawned);
	if(!isdefined(level.vsmgr_prio_overlay_zm_player_health_blur))
	{
		level.vsmgr_prio_overlay_zm_player_health_blur = 22;
	}
	visionset_mgr::register_info("overlay", "zm_health_blur", 1, level.vsmgr_prio_overlay_zm_player_health_blur, 1, 1, &visionset_mgr::ramp_in_out_thread_per_player, 1);
}

/*
	Name: on_player_spawned
	Namespace: zm_playerhealth
	Checksum: 0xC7762652
	Offset: 0x670
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 0);
	self notify(#"nohealthoverlay");
	self thread playerhealthregen();
}

/*
	Name: player_health_visionset
	Namespace: zm_playerhealth
	Checksum: 0xB14FA474
	Offset: 0x6C0
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function player_health_visionset()
{
	visionset_mgr::deactivate("overlay", "zm_health_blur", self);
	visionset_mgr::activate("overlay", "zm_health_blur", self, 0, 1, 1);
}

/*
	Name: playerhurtcheck
	Namespace: zm_playerhealth
	Checksum: 0x8AF64608
	Offset: 0x720
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function playerhurtcheck()
{
	self endon(#"nohealthoverlay");
	self.hurtagain = 0;
	for(;;)
	{
		self waittill(#"damage", amount, attacker, dir, point, mod);
		if(isdefined(attacker) && isplayer(attacker) && attacker.team == self.team)
		{
			continue;
		}
		self.hurtagain = 1;
		self.damagepoint = point;
		self.damageattacker = attacker;
	}
}

/*
	Name: playerhealthregen
	Namespace: zm_playerhealth
	Checksum: 0x8D589359
	Offset: 0x7F8
	Size: 0x730
	Parameters: 0
	Flags: Linked
*/
function playerhealthregen()
{
	self notify(#"playerhealthregen");
	self endon(#"playerhealthregen");
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(self.flag))
	{
		self.flag = [];
		self.flags_lock = [];
	}
	if(!isdefined(self.flag["player_has_red_flashing_overlay"]))
	{
		self flag::init("player_has_red_flashing_overlay");
		self flag::init("player_is_invulnerable");
	}
	self flag::clear("player_has_red_flashing_overlay");
	self flag::clear("player_is_invulnerable");
	self thread healthoverlay();
	oldratio = 1;
	health_add = 0;
	regenrate = 0.1;
	veryhurt = 0;
	playerjustgotredflashing = 0;
	invultime = 0;
	hurttime = 0;
	newhealth = 0;
	lastinvulratio = 1;
	self thread playerhurtcheck();
	if(!isdefined(self.veryhurt))
	{
		self.veryhurt = 0;
	}
	self.bolthit = 0;
	if(getdvarstring("scr_playerInvulTimeScale") == "")
	{
		setdvar("scr_playerInvulTimeScale", 1);
	}
	playerinvultimescale = getdvarfloat("scr_playerInvulTimeScale");
	for(;;)
	{
		wait(0.05);
		waittillframeend();
		if(self.health == self.maxhealth)
		{
			if(self flag::get("player_has_red_flashing_overlay"))
			{
				self clientfield::set_to_player("sndZombieHealth", 0);
				self flag::clear("player_has_red_flashing_overlay");
			}
			lastinvulratio = 1;
			playerjustgotredflashing = 0;
			veryhurt = 0;
			continue;
		}
		if(self.health <= 0)
		{
			/#
				showhitlog();
			#/
			return;
		}
		wasveryhurt = veryhurt;
		health_ratio = self.health / self.maxhealth;
		if(health_ratio <= level.healthoverlaycutoff)
		{
			veryhurt = 1;
			if(!wasveryhurt)
			{
				hurttime = gettime();
				self startfadingblur(3.6, 2);
				self clientfield::set_to_player("sndZombieHealth", 1);
				self flag::set("player_has_red_flashing_overlay");
				playerjustgotredflashing = 1;
			}
		}
		if(self.hurtagain)
		{
			hurttime = gettime();
			self.hurtagain = 0;
		}
		if(health_ratio >= oldratio)
		{
			if((gettime() - hurttime) < level.playerhealth_regularregendelay)
			{
				continue;
			}
			if(veryhurt)
			{
				self.veryhurt = 1;
				newhealth = health_ratio;
				if(gettime() > (hurttime + level.longregentime))
				{
					newhealth = newhealth + regenrate;
				}
			}
			else
			{
				newhealth = 1;
				self.veryhurt = 0;
			}
			if(newhealth > 1)
			{
				newhealth = 1;
			}
			if(newhealth <= 0)
			{
				return;
			}
			/#
				if(newhealth > health_ratio)
				{
					logregen(newhealth);
				}
			#/
			self setnormalhealth(newhealth);
			oldratio = self.health / self.maxhealth;
			continue;
		}
		invulworthyhealthdrop = (lastinvulratio - health_ratio) > level.worthydamageratio;
		if(self.health <= 1)
		{
			self setnormalhealth(2 / self.maxhealth);
			invulworthyhealthdrop = 1;
			/#
				if(!isdefined(level.player_deathinvulnerabletimeout))
				{
					level.player_deathinvulnerabletimeout = 0;
				}
				if(level.player_deathinvulnerabletimeout < gettime())
				{
					level.player_deathinvulnerabletimeout = gettime() + getdvarint("");
				}
			#/
		}
		oldratio = self.health / self.maxhealth;
		level notify(#"hit_again");
		health_add = 0;
		hurttime = gettime();
		self startfadingblur(3, 0.8);
		if(!invulworthyhealthdrop || playerinvultimescale <= 0)
		{
			/#
				loghit(self.health, 0);
			#/
			continue;
		}
		if(self flag::get("player_is_invulnerable"))
		{
			continue;
		}
		self flag::set("player_is_invulnerable");
		level notify(#"player_becoming_invulnerable");
		if(playerjustgotredflashing)
		{
			invultime = level.invultime_onshield;
			playerjustgotredflashing = 0;
		}
		else
		{
			if(veryhurt)
			{
				invultime = level.invultime_postshield;
			}
			else
			{
				invultime = level.invultime_preshield;
			}
		}
		invultime = invultime * playerinvultimescale;
		/#
			loghit(self.health, invultime);
		#/
		lastinvulratio = self.health / self.maxhealth;
		self thread playerinvul(invultime);
	}
}

/*
	Name: playerinvul
	Namespace: zm_playerhealth
	Checksum: 0x7C3C6426
	Offset: 0xF30
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function playerinvul(timer)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(timer > 0)
	{
		/#
			level.playerinvultimeend = gettime() + (timer * 1000);
		#/
		wait(timer);
	}
	self flag::clear("player_is_invulnerable");
}

/*
	Name: healthoverlay
	Namespace: zm_playerhealth
	Checksum: 0x5BB3085F
	Offset: 0xFA8
	Size: 0x1E0
	Parameters: 0
	Flags: Linked
*/
function healthoverlay()
{
	self endon(#"disconnect");
	self endon(#"nohealthoverlay");
	if(!isdefined(self._health_overlay))
	{
		self._health_overlay = newclienthudelem(self);
		self._health_overlay.x = 0;
		self._health_overlay.y = 0;
		self._health_overlay setshader("overlay_low_health", 640, 480);
		self._health_overlay.alignx = "left";
		self._health_overlay.aligny = "top";
		self._health_overlay.horzalign = "fullscreen";
		self._health_overlay.vertalign = "fullscreen";
		self._health_overlay.alpha = 0;
	}
	overlay = self._health_overlay;
	self thread healthoverlay_remove(overlay);
	self thread watchhideredflashingoverlay(overlay);
	pulsetime = 0.8;
	for(;;)
	{
		if(overlay.alpha > 0)
		{
			overlay fadeovertime(0.5);
		}
		overlay.alpha = 0;
		self flag::wait_till("player_has_red_flashing_overlay");
		self redflashingoverlay(overlay);
	}
}

/*
	Name: fadefunc
	Namespace: zm_playerhealth
	Checksum: 0x7E454E0B
	Offset: 0x1190
	Size: 0x240
	Parameters: 4
	Flags: Linked
*/
function fadefunc(overlay, severity, mult, hud_scaleonly)
{
	pulsetime = 0.8;
	scalemin = 0.5;
	fadeintime = pulsetime * 0.1;
	stayfulltime = pulsetime * (0.1 + (severity * 0.2));
	fadeouthalftime = pulsetime * (0.1 + (severity * 0.1));
	fadeoutfulltime = pulsetime * 0.3;
	remainingtime = (((pulsetime - fadeintime) - stayfulltime) - fadeouthalftime) - fadeoutfulltime;
	/#
		assert(remainingtime >= -0.001);
	#/
	if(remainingtime < 0)
	{
		remainingtime = 0;
	}
	halfalpha = 0.8 + (severity * 0.1);
	leastalpha = 0.5 + (severity * 0.3);
	overlay fadeovertime(fadeintime);
	overlay.alpha = mult * 1;
	wait(fadeintime + stayfulltime);
	overlay fadeovertime(fadeouthalftime);
	overlay.alpha = mult * halfalpha;
	wait(fadeouthalftime);
	overlay fadeovertime(fadeoutfulltime);
	overlay.alpha = mult * leastalpha;
	wait(fadeoutfulltime);
	wait(remainingtime);
}

/*
	Name: watchhideredflashingoverlay
	Namespace: zm_playerhealth
	Checksum: 0x58CBCEC4
	Offset: 0x13D8
	Size: 0xAE
	Parameters: 1
	Flags: Linked
*/
function watchhideredflashingoverlay(overlay)
{
	self endon(#"death_or_disconnect");
	while(isdefined(overlay))
	{
		self waittill(#"clear_red_flashing_overlay");
		self clientfield::set_to_player("sndZombieHealth", 0);
		self flag::clear("player_has_red_flashing_overlay");
		overlay fadeovertime(0.05);
		overlay.alpha = 0;
		self notify(#"hit_again");
	}
}

/*
	Name: redflashingoverlay
	Namespace: zm_playerhealth
	Checksum: 0xAA59A084
	Offset: 0x1490
	Size: 0x24A
	Parameters: 1
	Flags: Linked
*/
function redflashingoverlay(overlay)
{
	self endon(#"hit_again");
	self endon(#"damage");
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"clear_red_flashing_overlay");
	self.stopflashingbadlytime = gettime() + level.longregentime;
	if(!(isdefined(self.is_in_process_of_zombify) && self.is_in_process_of_zombify) && (!(isdefined(self.is_zombie) && self.is_zombie)))
	{
		fadefunc(overlay, 1, 1, 0);
		while(gettime() < self.stopflashingbadlytime && isalive(self) && (!(isdefined(self.is_in_process_of_zombify) && self.is_in_process_of_zombify) && (!(isdefined(self.is_zombie) && self.is_zombie))))
		{
			fadefunc(overlay, 0.9, 1, 0);
		}
		if(!(isdefined(self.is_in_process_of_zombify) && self.is_in_process_of_zombify) && (!(isdefined(self.is_zombie) && self.is_zombie)))
		{
			if(isalive(self))
			{
				fadefunc(overlay, 0.65, 0.8, 0);
			}
			fadefunc(overlay, 0, 0.6, 1);
		}
	}
	overlay fadeovertime(0.5);
	overlay.alpha = 0;
	self flag::clear("player_has_red_flashing_overlay");
	self clientfield::set_to_player("sndZombieHealth", 0);
	wait(0.5);
	self notify(#"hit_again");
}

/*
	Name: healthoverlay_remove
	Namespace: zm_playerhealth
	Checksum: 0x15591E96
	Offset: 0x16E8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function healthoverlay_remove(overlay)
{
	self endon(#"disconnect");
	self util::waittill_any("noHealthOverlay", "death");
	overlay fadeovertime(3.5);
	overlay.alpha = 0;
}

/*
	Name: empty_kill_func
	Namespace: zm_playerhealth
	Checksum: 0xB17F6BCB
	Offset: 0x1760
	Size: 0x2C
	Parameters: 5
	Flags: Linked
*/
function empty_kill_func(type, loc, point, attacker, amount)
{
}

/*
	Name: loghit
	Namespace: zm_playerhealth
	Checksum: 0x59F3E9D
	Offset: 0x1798
	Size: 0x18
	Parameters: 2
	Flags: Linked
*/
function loghit(newhealth, invultime)
{
	/#
	#/
}

/*
	Name: logregen
	Namespace: zm_playerhealth
	Checksum: 0x1ACF3C81
	Offset: 0x17B8
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function logregen(newhealth)
{
	/#
	#/
}

/*
	Name: showhitlog
	Namespace: zm_playerhealth
	Checksum: 0x1C49D3A3
	Offset: 0x17D0
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function showhitlog()
{
	/#
	#/
}

/*
	Name: playerhealthdebug
	Namespace: zm_playerhealth
	Checksum: 0x13442FEB
	Offset: 0x17E0
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function playerhealthdebug()
{
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		waittillframeend();
		while(true)
		{
			while(true)
			{
				if(getdvarstring("") != "")
				{
					break;
				}
				wait(0.5);
			}
			thread printhealthdebug();
			while(true)
			{
				if(getdvarstring("") == "")
				{
					break;
				}
				wait(0.5);
			}
			level notify(#"stop_printing_grenade_timers");
			destroyhealthdebug();
		}
	#/
}

/*
	Name: printhealthdebug
	Namespace: zm_playerhealth
	Checksum: 0x28E276B8
	Offset: 0x18F8
	Size: 0x66E
	Parameters: 0
	Flags: Linked
*/
function printhealthdebug()
{
	/#
		level notify(#"stop_printing_health_bars");
		level endon(#"stop_printing_health_bars");
		x = 40;
		y = 40;
		level.healthbarhudelems = [];
		level.healthbarkeys[0] = "";
		level.healthbarkeys[1] = "";
		level.healthbarkeys[2] = "";
		if(!isdefined(level.playerinvultimeend))
		{
			level.playerinvultimeend = 0;
		}
		if(!isdefined(level.player_deathinvulnerabletimeout))
		{
			level.player_deathinvulnerabletimeout = 0;
		}
		for(i = 0; i < level.healthbarkeys.size; i++)
		{
			key = level.healthbarkeys[i];
			textelem = newhudelem();
			textelem.x = x;
			textelem.y = y;
			textelem.alignx = "";
			textelem.aligny = "";
			textelem.horzalign = "";
			textelem.vertalign = "";
			textelem settext(key);
			bgbar = newhudelem();
			bgbar.x = x + 79;
			bgbar.y = y + 1;
			bgbar.alignx = "";
			bgbar.aligny = "";
			bgbar.horzalign = "";
			bgbar.vertalign = "";
			bgbar.maxwidth = 3;
			bgbar setshader("", bgbar.maxwidth, 10);
			bgbar.color = vectorscale((1, 1, 1), 0.5);
			bar = newhudelem();
			bar.x = x + 80;
			bar.y = y + 2;
			bar.alignx = "";
			bar.aligny = "";
			bar.horzalign = "";
			bar.vertalign = "";
			bar setshader("", 1, 8);
			textelem.bar = bar;
			textelem.bgbar = bgbar;
			textelem.key = key;
			y = y + 10;
			level.healthbarhudelems[key] = textelem;
		}
		level flag::wait_till("");
		while(true)
		{
			wait(0.05);
			players = getplayers();
			for(i = 0; i < level.healthbarkeys.size && players.size > 0; i++)
			{
				key = level.healthbarkeys[i];
				player = players[0];
				width = 0;
				if(i == 0)
				{
					width = (player.health / player.maxhealth) * 300;
				}
				else
				{
					if(i == 1)
					{
						width = ((level.playerinvultimeend - gettime()) / 1000) * 40;
					}
					else if(i == 2)
					{
						width = ((level.player_deathinvulnerabletimeout - gettime()) / 1000) * 40;
					}
				}
				width = int(max(width, 1));
				width = int(min(width, 300));
				bar = level.healthbarhudelems[key].bar;
				bar setshader("", width, 8);
				bgbar = level.healthbarhudelems[key].bgbar;
				if((width + 2) > bgbar.maxwidth)
				{
					bgbar.maxwidth = width + 2;
					bgbar setshader("", bgbar.maxwidth, 10);
					bgbar.color = vectorscale((1, 1, 1), 0.5);
				}
			}
		}
	#/
}

/*
	Name: destroyhealthdebug
	Namespace: zm_playerhealth
	Checksum: 0x96689F7B
	Offset: 0x1F70
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function destroyhealthdebug()
{
	/#
		if(!isdefined(level.healthbarhudelems))
		{
			return;
		}
		for(i = 0; i < level.healthbarkeys.size; i++)
		{
			level.healthbarhudelems[level.healthbarkeys[i]].bgbar destroy();
			level.healthbarhudelems[level.healthbarkeys[i]].bar destroy();
			level.healthbarhudelems[level.healthbarkeys[i]] destroy();
		}
	#/
}

