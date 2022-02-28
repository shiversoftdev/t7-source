// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_weaponobjects;

#namespace tacticalinsertion;

/*
	Name: init_shared
	Namespace: tacticalinsertion
	Checksum: 0x4BF2B742
	Offset: 0x448
	Size: 0xCC
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	if(level.gametype == "infect")
	{
		level.weapontacticalinsertion = getweapon("trophy_system");
	}
	else
	{
		level.weapontacticalinsertion = getweapon("tactical_insertion");
	}
	level._effect["tacticalInsertionFizzle"] = "_t6/misc/fx_equip_tac_insert_exp";
	clientfield::register("scriptmover", "tacticalinsertion", 1, 1, "int");
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: tacticalinsertion
	Checksum: 0x5FBB91D4
	Offset: 0x520
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread begin_other_grenade_tracking();
}

/*
	Name: istacspawntouchingcrates
	Namespace: tacticalinsertion
	Checksum: 0xDDB00F46
	Offset: 0x548
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function istacspawntouchingcrates(origin, angles)
{
	crate_ents = getentarray("care_package", "script_noteworthy");
	mins = (-17, -17, -40);
	maxs = (17, 17, 40);
	for(i = 0; i < crate_ents.size; i++)
	{
		if(crate_ents[i] istouchingvolume(origin + vectorscale((0, 0, 1), 40), mins, maxs))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: overridespawn
	Namespace: tacticalinsertion
	Checksum: 0xC01EBAB1
	Offset: 0x638
	Size: 0x148
	Parameters: 1
	Flags: None
*/
function overridespawn(ispredictedspawn)
{
	if(!isdefined(self.tacticalinsertion))
	{
		return false;
	}
	origin = self.tacticalinsertion.origin;
	angles = self.tacticalinsertion.angles;
	team = self.tacticalinsertion.team;
	if(!ispredictedspawn)
	{
		self.tacticalinsertion destroy_tactical_insertion();
	}
	if(team != self.team)
	{
		return false;
	}
	if(istacspawntouchingcrates(origin))
	{
		return false;
	}
	if(!ispredictedspawn)
	{
		self.tacticalinsertiontime = gettime();
		self spawn(origin, angles, "tactical insertion");
		self setspawnclientflag("SCDFL_DISABLE_LOGGING");
		self addweaponstat(level.weapontacticalinsertion, "used", 1);
	}
	return true;
}

/*
	Name: waitanddelete
	Namespace: tacticalinsertion
	Checksum: 0xCA239D62
	Offset: 0x788
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function waitanddelete(time)
{
	self endon(#"death");
	wait(0.05);
	self delete();
}

/*
	Name: watch
	Namespace: tacticalinsertion
	Checksum: 0xFA400B03
	Offset: 0x7C8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function watch(player)
{
	if(isdefined(player.tacticalinsertion))
	{
		player.tacticalinsertion destroy_tactical_insertion();
	}
	player thread spawntacticalinsertion();
	self waitanddelete(0.05);
}

/*
	Name: watchusetrigger
	Namespace: tacticalinsertion
	Checksum: 0xBEB5C2A8
	Offset: 0x848
	Size: 0x1D2
	Parameters: 4
	Flags: Linked
*/
function watchusetrigger(trigger, callback, playersoundonuse, npcsoundonuse)
{
	self endon(#"delete");
	while(true)
	{
		trigger waittill(#"trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(!player isonground())
		{
			continue;
		}
		if(isdefined(trigger.triggerteam) && player.team != trigger.triggerteam)
		{
			continue;
		}
		if(isdefined(trigger.triggerteamignore) && player.team == trigger.triggerteamignore)
		{
			continue;
		}
		if(isdefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}
		if(player usebuttonpressed() && !player.throwinggrenade && !player meleebuttonpressed())
		{
			if(isdefined(playersoundonuse))
			{
				player playlocalsound(playersoundonuse);
			}
			if(isdefined(npcsoundonuse))
			{
				player playsound(npcsoundonuse);
			}
			self thread [[callback]](player);
		}
	}
}

/*
	Name: watchdisconnect
	Namespace: tacticalinsertion
	Checksum: 0xCF66D2B6
	Offset: 0xA28
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function watchdisconnect()
{
	self.tacticalinsertion endon(#"delete");
	self waittill(#"disconnect");
	self.tacticalinsertion thread destroy_tactical_insertion();
}

/*
	Name: destroy_tactical_insertion
	Namespace: tacticalinsertion
	Checksum: 0xDF66AEF9
	Offset: 0xA70
	Size: 0x1E4
	Parameters: 1
	Flags: Linked
*/
function destroy_tactical_insertion(attacker)
{
	self.owner.tacticalinsertion = undefined;
	self notify(#"delete");
	self.owner notify(#"tactical_insertion_destroyed");
	self.friendlytrigger delete();
	self.enemytrigger delete();
	if(isdefined(attacker) && isdefined(attacker.pers["team"]) && isdefined(self.owner) && isdefined(self.owner.pers["team"]))
	{
		if(level.teambased)
		{
			if(attacker.pers["team"] != self.owner.pers["team"])
			{
				attacker notify(#"destroyed_explosive");
				attacker challenges::destroyedequipment();
				attacker challenges::destroyedtacticalinsert();
				scoreevents::processscoreevent("destroyed_tac_insert", attacker);
			}
		}
		else if(attacker != self.owner)
		{
			attacker notify(#"destroyed_explosive");
			attacker challenges::destroyedequipment();
			attacker challenges::destroyedtacticalinsert();
			scoreevents::processscoreevent("destroyed_tac_insert", attacker);
		}
	}
	self delete();
}

/*
	Name: fizzle
	Namespace: tacticalinsertion
	Checksum: 0xF1A555FD
	Offset: 0xC60
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function fizzle(attacker)
{
	if(isdefined(self.fizzle) && self.fizzle)
	{
		return;
	}
	self.fizzle = 1;
	playfx(level._effect["tacticalInsertionFizzle"], self.origin);
	self playsound("dst_tac_insert_break");
	if(isdefined(attacker) && attacker != self.owner)
	{
		if(isdefined(level.globallogic_audio_dialog_on_player_override))
		{
			self.owner [[level.globallogic_audio_dialog_on_player_override]]("tact_destroyed", "item_destroyed");
		}
	}
	self destroy_tactical_insertion(attacker);
}

/*
	Name: pickup
	Namespace: tacticalinsertion
	Checksum: 0x4E58DF5B
	Offset: 0xD50
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function pickup(attacker)
{
	player = self.owner;
	self destroy_tactical_insertion();
	player giveweapon(level.weapontacticalinsertion);
	player setweaponammoclip(level.weapontacticalinsertion, 1);
}

/*
	Name: spawntacticalinsertion
	Namespace: tacticalinsertion
	Checksum: 0x27334525
	Offset: 0xDD0
	Size: 0x8D0
	Parameters: 0
	Flags: Linked
*/
function spawntacticalinsertion()
{
	self endon(#"disconnect");
	trace = bullettrace(self.origin, self.origin + (vectorscale((0, 0, -1), 30)), 0, self);
	trace["position"] = trace["position"] + (0, 0, 1);
	if(!self isonground() && bullettracepassed(self.origin, self.origin + (vectorscale((0, 0, -1), 30)), 0, self))
	{
		self giveweapon(level.weapontacticalinsertion);
		self setweaponammoclip(level.weapontacticalinsertion, 1);
		return;
	}
	self.tacticalinsertion = spawn("script_model", trace["position"]);
	self.tacticalinsertion setmodel("wpn_t7_trophy_system");
	self.tacticalinsertion.origin = self.origin + (0, 0, 1);
	self.tacticalinsertion.angles = self.angles;
	self.tacticalinsertion.team = self.team;
	self.tacticalinsertion setteam(self.team);
	self.tacticalinsertion.owner = self;
	self.tacticalinsertion setowner(self);
	self.tacticalinsertion setweapon(level.weapontacticalinsertion);
	self.tacticalinsertion endon(#"delete");
	self.tacticalinsertion hacker_tool::registerwithhackertool(level.equipmenthackertoolradius, level.equipmenthackertooltimems);
	triggerheight = 64;
	triggerradius = 128;
	self.tacticalinsertion.friendlytrigger = spawn("trigger_radius_use", self.tacticalinsertion.origin + vectorscale((0, 0, 1), 3));
	self.tacticalinsertion.friendlytrigger setcursorhint("HINT_NOICON", self.tacticalinsertion);
	self.tacticalinsertion.friendlytrigger sethintstring(&"MP_TACTICAL_INSERTION_PICKUP");
	if(level.teambased)
	{
		self.tacticalinsertion.friendlytrigger setteamfortrigger(self.team);
		self.tacticalinsertion.friendlytrigger.triggerteam = self.team;
	}
	self clientclaimtrigger(self.tacticalinsertion.friendlytrigger);
	self.tacticalinsertion.friendlytrigger.claimedby = self;
	self.tacticalinsertion.enemytrigger = spawn("trigger_radius_use", self.tacticalinsertion.origin + vectorscale((0, 0, 1), 3));
	self.tacticalinsertion.enemytrigger setcursorhint("HINT_NOICON", self.tacticalinsertion);
	self.tacticalinsertion.enemytrigger sethintstring(&"MP_TACTICAL_INSERTION_DESTROY");
	self.tacticalinsertion.enemytrigger setinvisibletoplayer(self);
	if(level.teambased)
	{
		self.tacticalinsertion.enemytrigger setexcludeteamfortrigger(self.team);
		self.tacticalinsertion.enemytrigger.triggerteamignore = self.team;
	}
	self.tacticalinsertion clientfield::set("tacticalinsertion", 1);
	self thread watchdisconnect();
	watcher = weaponobjects::getweaponobjectwatcherbyweapon(level.weapontacticalinsertion);
	self.tacticalinsertion thread watchusetrigger(self.tacticalinsertion.friendlytrigger, &pickup, watcher.pickupsoundplayer, watcher.pickupsound);
	self.tacticalinsertion thread watchusetrigger(self.tacticalinsertion.enemytrigger, &fizzle);
	if(isdefined(self.tacticalinsertioncount))
	{
		self.tacticalinsertioncount++;
	}
	else
	{
		self.tacticalinsertioncount = 1;
	}
	self.tacticalinsertion setcandamage(1);
	self.tacticalinsertion.health = 1;
	while(true)
	{
		self.tacticalinsertion waittill(#"damage", damage, attacker, direction, point, type, tagname, modelname, partname, weapon, idflags);
		if(level.teambased && (!isdefined(attacker) || !isplayer(attacker) || attacker.team == self.team) && attacker != self)
		{
			continue;
		}
		if(attacker != self)
		{
			attacker challenges::destroyedequipment(weapon);
			attacker challenges::destroyedtacticalinsert();
			scoreevents::processscoreevent("destroyed_tac_insert", attacker);
		}
		if(watcher.stuntime > 0 && weapon.dostun)
		{
			self thread weaponobjects::stunstart(watcher, watcher.stuntime);
		}
		if(weapon.dodamagefeedback)
		{
			if(level.teambased && self.tacticalinsertion.owner.team != attacker.team)
			{
				if(damagefeedback::dodamagefeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
			else if(!level.teambased && self.tacticalinsertion.owner != attacker)
			{
				if(damagefeedback::dodamagefeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
		}
		if(isdefined(attacker) && attacker != self)
		{
			if(isdefined(level.globallogic_audio_dialog_on_player_override))
			{
				self [[level.globallogic_audio_dialog_on_player_override]]("tact_destroyed", "item_destroyed");
			}
		}
		self.tacticalinsertion thread fizzle();
	}
}

/*
	Name: cancel_button_think
	Namespace: tacticalinsertion
	Checksum: 0x6BA4F317
	Offset: 0x16A8
	Size: 0xE4
	Parameters: 0
	Flags: None
*/
function cancel_button_think()
{
	if(!isdefined(self.tacticalinsertion))
	{
		return;
	}
	text = cancel_text_create();
	self thread cancel_button_press();
	event = self util::waittill_any_return("tactical_insertion_destroyed", "disconnect", "end_killcam", "abort_killcam", "tactical_insertion_canceled", "spawned");
	if(event == "tactical_insertion_canceled")
	{
		self.tacticalinsertion destroy_tactical_insertion();
	}
	if(isdefined(text))
	{
		text destroy();
	}
}

/*
	Name: canceltackinsertionbutton
	Namespace: tacticalinsertion
	Checksum: 0x27F4F62B
	Offset: 0x1798
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function canceltackinsertionbutton()
{
	if(level.console)
	{
		return self changeseatbuttonpressed();
	}
	return self jumpbuttonpressed();
}

/*
	Name: cancel_button_press
	Namespace: tacticalinsertion
	Checksum: 0x60C973E8
	Offset: 0x17E0
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function cancel_button_press()
{
	self endon(#"disconnect");
	self endon(#"end_killcam");
	self endon(#"abort_killcam");
	while(true)
	{
		wait(0.05);
		if(self canceltackinsertionbutton())
		{
			break;
		}
	}
	self notify(#"tactical_insertion_canceled");
}

/*
	Name: cancel_text_create
	Namespace: tacticalinsertion
	Checksum: 0x672BAC1A
	Offset: 0x1850
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function cancel_text_create()
{
	text = newclienthudelem(self);
	text.archived = 0;
	text.y = -100;
	text.alignx = "center";
	text.aligny = "middle";
	text.horzalign = "center";
	text.vertalign = "bottom";
	text.sort = 10;
	text.font = "small";
	text.foreground = 1;
	text.hidewheninmenu = 1;
	if(self issplitscreen())
	{
		text.y = -80;
		text.fontscale = 1.2;
	}
	else
	{
		text.fontscale = 1.6;
	}
	text settext(&"PLATFORM_PRESS_TO_CANCEL_TACTICAL_INSERTION");
	text.alpha = 1;
	return text;
}

/*
	Name: gettacticalinsertions
	Namespace: tacticalinsertion
	Checksum: 0x8FAAE533
	Offset: 0x19D8
	Size: 0xB6
	Parameters: 0
	Flags: None
*/
function gettacticalinsertions()
{
	tac_inserts = [];
	foreach(player in level.players)
	{
		if(isdefined(player.tacticalinsertion))
		{
			tac_inserts[tac_inserts.size] = player.tacticalinsertion;
		}
	}
	return tac_inserts;
}

/*
	Name: tacticalinsertiondestroyedbytrophysystem
	Namespace: tacticalinsertion
	Checksum: 0x21FBC319
	Offset: 0x1A98
	Size: 0xE0
	Parameters: 2
	Flags: Linked
*/
function tacticalinsertiondestroyedbytrophysystem(attacker, trophysystem)
{
	owner = self.owner;
	if(isdefined(attacker))
	{
		attacker challenges::destroyedequipment(trophysystem.name);
		attacker challenges::destroyedtacticalinsert();
	}
	self thread fizzle();
	if(isdefined(owner))
	{
		owner endon(#"death");
		owner endon(#"disconnect");
		wait(0.05);
		if(isdefined(level.globallogic_audio_dialog_on_player_override))
		{
			owner [[level.globallogic_audio_dialog_on_player_override]]("tact_destroyed", "item_destroyed");
		}
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: tacticalinsertion
	Checksum: 0xB6D0258C
	Offset: 0x1B80
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function begin_other_grenade_tracking()
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify(#"insertiontrackingstart");
	self endon(#"insertiontrackingstart");
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon, cooktime);
		if(grenade util::ishacked())
		{
			continue;
		}
		if(weapon == level.weapontacticalinsertion)
		{
			if(level.gametype == "infect" && self.team == game["defenders"])
			{
				return;
			}
			grenade thread watch(self);
		}
	}
}

