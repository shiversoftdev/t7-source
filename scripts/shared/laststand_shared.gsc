// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;

#namespace laststand;

/*
	Name: player_is_in_laststand
	Namespace: laststand
	Checksum: 0xF997EFC
	Offset: 0x190
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function player_is_in_laststand()
{
	if(!(isdefined(self.no_revive_trigger) && self.no_revive_trigger))
	{
		return isdefined(self.revivetrigger);
	}
	return isdefined(self.laststand) && self.laststand;
}

/*
	Name: player_num_in_laststand
	Namespace: laststand
	Checksum: 0x310E3175
	Offset: 0x1D8
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function player_num_in_laststand()
{
	num = 0;
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] player_is_in_laststand())
		{
			num++;
		}
	}
	return num;
}

/*
	Name: player_all_players_in_laststand
	Namespace: laststand
	Checksum: 0x4FDDB829
	Offset: 0x268
	Size: 0x26
	Parameters: 0
	Flags: None
*/
function player_all_players_in_laststand()
{
	return player_num_in_laststand() == getplayers().size;
}

/*
	Name: player_any_player_in_laststand
	Namespace: laststand
	Checksum: 0xDA614525
	Offset: 0x298
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function player_any_player_in_laststand()
{
	return player_num_in_laststand() > 0;
}

/*
	Name: laststand_allowed
	Namespace: laststand
	Checksum: 0x196606
	Offset: 0x2B8
	Size: 0x38
	Parameters: 3
	Flags: None
*/
function laststand_allowed(sweapon, smeansofdeath, shitloc)
{
	if(level.laststandpistol == "none")
	{
		return false;
	}
	return true;
}

/*
	Name: cleanup_suicide_hud
	Namespace: laststand
	Checksum: 0xF977FFA6
	Offset: 0x2F8
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function cleanup_suicide_hud()
{
	if(isdefined(self.suicideprompt))
	{
		self.suicideprompt destroy();
	}
	self.suicideprompt = undefined;
}

/*
	Name: clean_up_suicide_hud_on_end_game
	Namespace: laststand
	Checksum: 0x9C90E015
	Offset: 0x338
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function clean_up_suicide_hud_on_end_game()
{
	self endon(#"disconnect");
	self endon(#"stop_revive_trigger");
	self endon(#"player_revived");
	self endon(#"bled_out");
	level util::waittill_any("game_ended", "stop_suicide_trigger");
	self cleanup_suicide_hud();
	if(isdefined(self.suicidetexthud))
	{
		self.suicidetexthud destroy();
	}
	if(isdefined(self.suicideprogressbar))
	{
		self.suicideprogressbar hud::destroyelem();
	}
}

/*
	Name: clean_up_suicide_hud_on_bled_out
	Namespace: laststand
	Checksum: 0xBE6ACC14
	Offset: 0x400
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function clean_up_suicide_hud_on_bled_out()
{
	self endon(#"disconnect");
	self endon(#"stop_revive_trigger");
	self util::waittill_any("bled_out", "player_revived", "fake_death");
	self cleanup_suicide_hud();
	if(isdefined(self.suicideprogressbar))
	{
		self.suicideprogressbar hud::destroyelem();
	}
	if(isdefined(self.suicidetexthud))
	{
		self.suicidetexthud destroy();
	}
}

/*
	Name: is_facing
	Namespace: laststand
	Checksum: 0xDBF1BB69
	Offset: 0x4B8
	Size: 0x15A
	Parameters: 2
	Flags: Linked
*/
function is_facing(facee, requireddot = 0.9)
{
	orientation = self getplayerangles();
	forwardvec = anglestoforward(orientation);
	forwardvec2d = (forwardvec[0], forwardvec[1], 0);
	unitforwardvec2d = vectornormalize(forwardvec2d);
	tofaceevec = facee.origin - self.origin;
	tofaceevec2d = (tofaceevec[0], tofaceevec[1], 0);
	unittofaceevec2d = vectornormalize(tofaceevec2d);
	dotproduct = vectordot(unitforwardvec2d, unittofaceevec2d);
	return dotproduct > requireddot;
}

/*
	Name: revive_hud_create
	Namespace: laststand
	Checksum: 0x5CFC7D19
	Offset: 0x620
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function revive_hud_create()
{
	self.revive_hud = newclienthudelem(self);
	self.revive_hud.alignx = "center";
	self.revive_hud.aligny = "middle";
	self.revive_hud.horzalign = "center";
	self.revive_hud.vertalign = "bottom";
	self.revive_hud.foreground = 1;
	self.revive_hud.font = "default";
	self.revive_hud.fontscale = 1.5;
	self.revive_hud.alpha = 0;
	self.revive_hud.color = (1, 1, 1);
	self.revive_hud.hidewheninmenu = 1;
	self.revive_hud settext("");
	self.revive_hud.y = -148;
}

/*
	Name: revive_hud_show
	Namespace: laststand
	Checksum: 0xCCE6BB0D
	Offset: 0x760
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function revive_hud_show()
{
	/#
		assert(isdefined(self));
	#/
	/#
		assert(isdefined(self.revive_hud));
	#/
	self.revive_hud.alpha = 1;
}

/*
	Name: revive_hud_show_n_fade
	Namespace: laststand
	Checksum: 0xFCD44F36
	Offset: 0x7B8
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function revive_hud_show_n_fade(time)
{
	revive_hud_show();
	self.revive_hud fadeovertime(time);
	self.revive_hud.alpha = 0;
}

/*
	Name: drawcylinder
	Namespace: laststand
	Checksum: 0xD86F4EFD
	Offset: 0x810
	Size: 0x25E
	Parameters: 3
	Flags: None
*/
function drawcylinder(pos, rad, height)
{
	/#
		currad = rad;
		curheight = height;
		for(r = 0; r < 20; r++)
		{
			theta = (r / 20) * 360;
			theta2 = ((r + 1) / 20) * 360;
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0));
			line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight));
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight));
		}
	#/
}

/*
	Name: get_lives_remaining
	Namespace: laststand
	Checksum: 0xA29137BA
	Offset: 0xA78
	Size: 0x7E
	Parameters: 0
	Flags: None
*/
function get_lives_remaining()
{
	/#
		assert(level.laststandgetupallowed, "");
	#/
	if(level.laststandgetupallowed && isdefined(self.laststand_info) && isdefined(self.laststand_info.type_getup_lives))
	{
		return max(0, self.laststand_info.type_getup_lives);
	}
	return 0;
}

/*
	Name: update_lives_remaining
	Namespace: laststand
	Checksum: 0x8EAB02C1
	Offset: 0xB00
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function update_lives_remaining(increment)
{
	/#
		assert(level.laststandgetupallowed, "");
	#/
	/#
		assert(isdefined(increment), "");
	#/
	increment = (isdefined(increment) ? increment : 0);
	self.laststand_info.type_getup_lives = max(0, (increment ? self.laststand_info.type_getup_lives + 1 : self.laststand_info.type_getup_lives - 1));
	self notify(#"laststand_lives_updated");
}

/*
	Name: player_getup_setup
	Namespace: laststand
	Checksum: 0xB0221D88
	Offset: 0xBE8
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function player_getup_setup()
{
	/#
		println("");
	#/
	self.laststand_info = spawnstruct();
	self.laststand_info.type_getup_lives = 0;
}

/*
	Name: laststand_getup_damage_watcher
	Namespace: laststand
	Checksum: 0x7A430A53
	Offset: 0xC40
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function laststand_getup_damage_watcher()
{
	self endon(#"player_revived");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"damage");
		self.laststand_info.getup_bar_value = self.laststand_info.getup_bar_value - 0.1;
		if(self.laststand_info.getup_bar_value < 0)
		{
			self.laststand_info.getup_bar_value = 0;
		}
	}
}

/*
	Name: laststand_getup_hud
	Namespace: laststand
	Checksum: 0x7210C0C0
	Offset: 0xCD0
	Size: 0x190
	Parameters: 0
	Flags: Linked
*/
function laststand_getup_hud()
{
	self endon(#"player_revived");
	self endon(#"disconnect");
	hudelem = newclienthudelem(self);
	hudelem.alignx = "left";
	hudelem.aligny = "middle";
	hudelem.horzalign = "left";
	hudelem.vertalign = "middle";
	hudelem.x = 5;
	hudelem.y = 170;
	hudelem.font = "big";
	hudelem.fontscale = 1.5;
	hudelem.foreground = 1;
	hudelem.hidewheninmenu = 1;
	hudelem.hidewhendead = 1;
	hudelem.sort = 2;
	hudelem.label = &"SO_WAR_LASTSTAND_GETUP_BAR";
	self thread laststand_getup_hud_destroy(hudelem);
	while(true)
	{
		hudelem setvalue(self.laststand_info.getup_bar_value);
		wait(0.05);
	}
}

/*
	Name: laststand_getup_hud_destroy
	Namespace: laststand
	Checksum: 0xD86B10F0
	Offset: 0xE68
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function laststand_getup_hud_destroy(hudelem)
{
	self util::waittill_either("player_revived", "disconnect");
	hudelem destroy();
}

/*
	Name: cleanup_laststand_on_disconnect
	Namespace: laststand
	Checksum: 0xA6344D42
	Offset: 0xEC0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function cleanup_laststand_on_disconnect()
{
	self endon(#"player_revived");
	self endon(#"player_suicide");
	self endon(#"bled_out");
	trig = self.revivetrigger;
	self waittill(#"disconnect");
	if(isdefined(trig))
	{
		trig delete();
	}
}

