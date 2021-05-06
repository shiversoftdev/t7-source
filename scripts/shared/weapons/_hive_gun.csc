// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace hive_gun;

/*
	Name: init_shared
	Namespace: hive_gun
	Checksum: 0xA687986D
	Offset: 0x3A0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level thread register();
}

/*
	Name: register
	Namespace: hive_gun
	Checksum: 0x72891D0A
	Offset: 0x3C8
	Size: 0xDC
	Parameters: 0
	Flags: None
*/
function register()
{
	clientfield::register("scriptmover", "firefly_state", 1, 3, "int", &firefly_state_change, 0, 0);
	clientfield::register("toplayer", "fireflies_attacking", 1, 1, "int", &fireflies_attacking, 0, 1);
	clientfield::register("toplayer", "fireflies_chasing", 1, 1, "int", &fireflies_chasing, 0, 1);
}

/*
	Name: getotherteam
	Namespace: hive_gun
	Checksum: 0x2A432276
	Offset: 0x4B0
	Size: 0x4A
	Parameters: 1
	Flags: None
*/
function getotherteam(team)
{
	if(team == "allies")
	{
		return "axis";
	}
	if(team == "axis")
	{
		return "allies";
	}
	return "free";
}

/*
	Name: fireflies_attacking
	Namespace: hive_gun
	Checksum: 0xF387E8A9
	Offset: 0x508
	Size: 0x10E
	Parameters: 7
	Flags: None
*/
function fireflies_attacking(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		self notify(#"stop_player_fx");
		if(self islocalplayer() && !self getinkillcam(localclientnum))
		{
			fx = playfxoncamera(localclientnum, "weapon/fx_ability_firefly_attack_1p", (0, 0, 0), (1, 0, 0), (0, 0, 1));
			self thread watch_player_fx_finished(localclientnum, fx);
		}
	}
	else
	{
		self notify(#"stop_player_fx");
	}
}

/*
	Name: fireflies_chasing
	Namespace: hive_gun
	Checksum: 0xA5D1AC2A
	Offset: 0x620
	Size: 0x15E
	Parameters: 7
	Flags: None
*/
function fireflies_chasing(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		self notify(#"stop_player_fx");
		if(self islocalplayer() && !self getinkillcam(localclientnum))
		{
			fx = playfxoncamera(localclientnum, "weapon/fx_ability_firefly_chase_1p", (0, 0, 0), (1, 0, 0), (0, 0, 1));
			sound = self playloopsound("wpn_gelgun_hive_hunt_lp");
			self playrumblelooponentity(localclientnum, "firefly_chase_rumble_loop");
			self thread watch_player_fx_finished(localclientnum, fx, sound);
		}
	}
	else
	{
		self notify(#"stop_player_fx");
	}
}

/*
	Name: watch_player_fx_finished
	Namespace: hive_gun
	Checksum: 0x67FC62A1
	Offset: 0x788
	Size: 0xBC
	Parameters: 3
	Flags: None
*/
function watch_player_fx_finished(localclientnum, fx, sound)
{
	self util::waittill_any("entityshutdown", "stop_player_fx");
	if(isdefined(self))
	{
		self stoprumble(localclientnum, "firefly_chase_rumble_loop");
	}
	if(isdefined(fx))
	{
		stopfx(localclientnum, fx);
	}
	if(isdefined(sound) && isdefined(self))
	{
		self stoploopsound(sound);
	}
}

/*
	Name: firefly_state_change
	Namespace: hive_gun
	Checksum: 0x184CFD32
	Offset: 0x850
	Size: 0x14E
	Parameters: 7
	Flags: None
*/
function firefly_state_change(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(self.initied))
	{
		self thread firefly_init(localclientnum);
		self.initied = 1;
	}
	switch(newval)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			self firefly_deploying(localclientnum);
			break;
		}
		case 2:
		{
			self firefly_hunting(localclientnum);
			break;
		}
		case 3:
		{
			self firefly_attacking(localclientnum);
			break;
		}
		case 4:
		{
			self firefly_link_attacking(localclientnum);
			break;
		}
	}
}

/*
	Name: on_shutdown
	Namespace: hive_gun
	Checksum: 0x93F98983
	Offset: 0x9A8
	Size: 0xB4
	Parameters: 2
	Flags: None
*/
function on_shutdown(localclientnum, ent)
{
	if(isdefined(ent) && isdefined(ent.origin) && self === ent && (!(isdefined(self.no_death_fx) && self.no_death_fx)))
	{
		fx = playfx(localclientnum, "weapon/fx_hero_firefly_death", ent.origin, (0, 0, 1));
		setfxteam(localclientnum, fx, ent.team);
	}
}

/*
	Name: firefly_init
	Namespace: hive_gun
	Checksum: 0x51AAEE7F
	Offset: 0xA68
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function firefly_init(localclientnum)
{
	self callback::on_shutdown(&on_shutdown, self);
}

/*
	Name: firefly_deploying
	Namespace: hive_gun
	Checksum: 0x4F834A09
	Offset: 0xAA0
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function firefly_deploying(localclientnum)
{
	fx = playfx(localclientnum, "weapon/fx_hero_firefly_start", self.origin, anglestoup(self.angles));
	setfxteam(localclientnum, fx, self.team);
}

/*
	Name: firefly_hunting
	Namespace: hive_gun
	Checksum: 0x7BFF501F
	Offset: 0xB20
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function firefly_hunting(localclientnum)
{
	fx = playfxontag(localclientnum, "weapon/fx_hero_firefly_hunting", self, "tag_origin");
	setfxteam(localclientnum, fx, self.team);
	self thread firefly_watch_fx_finished(localclientnum, fx);
}

/*
	Name: firefly_watch_fx_finished
	Namespace: hive_gun
	Checksum: 0xC31B21CB
	Offset: 0xBB0
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function firefly_watch_fx_finished(localclientnum, fx)
{
	self util::waittill_any("entityshutdown", "stop_effects");
	if(isdefined(fx))
	{
		stopfx(localclientnum, fx);
	}
}

/*
	Name: firefly_attacking
	Namespace: hive_gun
	Checksum: 0x2E3A5C2B
	Offset: 0xC20
	Size: 0x28
	Parameters: 1
	Flags: None
*/
function firefly_attacking(localclientnum)
{
	self notify(#"stop_effects");
	self.no_death_fx = 1;
}

/*
	Name: firefly_link_attacking
	Namespace: hive_gun
	Checksum: 0xDBACAAA3
	Offset: 0xC50
	Size: 0x90
	Parameters: 1
	Flags: None
*/
function firefly_link_attacking(localclientnum)
{
	fx = playfx(localclientnum, "weapon/fx_hero_firefly_start_entity", self.origin, anglestoup(self.angles));
	setfxteam(localclientnum, fx, self.team);
	self notify(#"stop_effects");
	self.no_death_fx = 1;
}

/*
	Name: gib_fx
	Namespace: hive_gun
	Checksum: 0xB1549DB5
	Offset: 0xCE8
	Size: 0xAC
	Parameters: 3
	Flags: None
*/
function gib_fx(localclientnum, fxfilename, gibflag)
{
	fxtag = gibclientutils::playergibtag(localclientnum, gibflag);
	if(isdefined(fxtag))
	{
		fx = playfxontag(localclientnum, fxfilename, self, fxtag);
		setfxteam(localclientnum, fx, getotherteam(self.team));
	}
}

/*
	Name: gib_corpse
	Namespace: hive_gun
	Checksum: 0xD2504F7C
	Offset: 0xDA0
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function gib_corpse(localclientnum, value)
{
	self endon(#"entityshutdown");
	self thread watch_for_gib_notetracks(localclientnum);
}

/*
	Name: watch_for_gib_notetracks
	Namespace: hive_gun
	Checksum: 0xF782D03
	Offset: 0xDE0
	Size: 0x34E
	Parameters: 1
	Flags: None
*/
function watch_for_gib_notetracks(localclientnum)
{
	self endon(#"entityshutdown");
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	fxfilename = "weapon/fx_hero_firefly_attack_limb";
	bodytype = self getcharacterbodytype();
	if(bodytype >= 0)
	{
		bodytypefields = getcharacterfields(bodytype, currentsessionmode());
		if((isdefined(bodytypefields.digitalblood) ? bodytypefields.digitalblood : 0))
		{
			fxfilename = "weapon/fx_hero_firefly_attack_limb_reaper";
		}
	}
	arm_gib = 0;
	leg_gib = 0;
	while(true)
	{
		notetrack = self util::waittill_any_return("gib_leftarm", "gib_leftleg", "gib_rightarm", "gib_rightleg", "entityshutdown");
		switch(notetrack)
		{
			case "gib_rightarm":
			{
				arm_gib = arm_gib | 1;
				gib_fx(localclientnum, fxfilename, 16);
				self gibclientutils::playergibleftarm(localclientnum);
				self setcorpsegibstate(leg_gib, arm_gib);
				break;
			}
			case "gib_leftarm":
			{
				arm_gib = arm_gib | 2;
				gib_fx(localclientnum, fxfilename, 32);
				self gibclientutils::playergibleftarm(localclientnum);
				self setcorpsegibstate(leg_gib, arm_gib);
				break;
			}
			case "gib_rightleg":
			{
				leg_gib = leg_gib | 1;
				gib_fx(localclientnum, fxfilename, 128);
				self gibclientutils::playergibleftleg(localclientnum);
				self setcorpsegibstate(leg_gib, arm_gib);
				break;
			}
			case "gib_leftleg":
			{
				leg_gib = leg_gib | 2;
				gib_fx(localclientnum, fxfilename, 256);
				self gibclientutils::playergibleftleg(localclientnum);
				self setcorpsegibstate(leg_gib, arm_gib);
				break;
			}
			default:
			{
				break;
			}
		}
	}
}

