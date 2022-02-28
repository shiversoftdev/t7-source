// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_prop_dev;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\prop;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;

#namespace namespace_4c773ed3;

/*
	Name: notifyonplayercommand
	Namespace: namespace_4c773ed3
	Checksum: 0xFB4D26B8
	Offset: 0x838
	Size: 0x5C
	Parameters: 2
	Flags: None
*/
function notifyonplayercommand(command, key)
{
	/#
		assert(isplayer(self));
	#/
	self thread function_e17a8f06(command, key);
}

/*
	Name: notifyonplayercommandremove
	Namespace: namespace_4c773ed3
	Checksum: 0xBE563177
	Offset: 0x8A0
	Size: 0x2E
	Parameters: 2
	Flags: None
*/
function notifyonplayercommandremove(command, key)
{
	self notify((command + "_") + key);
}

/*
	Name: function_e17a8f06
	Namespace: namespace_4c773ed3
	Checksum: 0x320CBF53
	Offset: 0x8D8
	Size: 0x39E
	Parameters: 2
	Flags: None
*/
function function_e17a8f06(command, key)
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self notify((command + "_") + key);
	self endon((command + "_") + key);
	switch(key)
	{
		case "+attack":
		{
			function_c6639fc9(&attackbuttonpressed, command);
			break;
		}
		case "+toggleads_throw":
		{
			function_c6639fc9(&adsbuttonpressed, command);
			break;
		}
		case "weapnext":
		{
			function_c6639fc9(&weaponswitchbuttonpressed, command);
			break;
		}
		case "+usereload":
		{
			function_c6639fc9(&usebuttonpressed, command);
			break;
		}
		case "+smoke":
		{
			function_c6639fc9(&secondaryoffhandbuttonpressed, command);
			break;
		}
		case "+frag":
		{
			function_c6639fc9(&fragbuttonpressed, command);
			break;
		}
		case "+actionslot 1":
		{
			function_c6639fc9(&actionslotonebuttonpressed, command);
			break;
		}
		case "+actionslot 2":
		{
			function_c6639fc9(&actionslottwobuttonpressed, command);
			break;
		}
		case "+actionslot 3":
		{
			function_c6639fc9(&actionslotthreebuttonpressed, command);
			break;
		}
		case "+actionslot 4":
		{
			function_c6639fc9(&actionslotfourbuttonpressed, command);
			break;
		}
		case "-actionslot 1":
		{
			function_b01c4bcb(&actionslotonebuttonpressed, command);
			break;
		}
		case "-actionslot 2":
		{
			function_b01c4bcb(&actionslottwobuttonpressed, command);
			break;
		}
		case "-actionslot 3":
		{
			function_b01c4bcb(&actionslotthreebuttonpressed, command);
			break;
		}
		case "-actionslot 4":
		{
			function_b01c4bcb(&actionslotfourbuttonpressed, command);
			break;
		}
		case "+stance":
		{
			function_b01c4bcb(&stancebuttonpressed, command);
			break;
		}
		case "+breath_sprint":
		{
			function_b01c4bcb(&sprintbuttonpressed, command);
			break;
		}
		case "+melee":
		{
			function_b01c4bcb(&meleebuttonpressed, command);
			break;
		}
	}
}

/*
	Name: function_c6639fc9
	Namespace: namespace_4c773ed3
	Checksum: 0x91E19DF8
	Offset: 0xC80
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function function_c6639fc9(var_33b64687, command)
{
	while(true)
	{
		while(!self [[var_33b64687]]())
		{
			wait(0.05);
		}
		self notify(command);
		while(self [[var_33b64687]]())
		{
			wait(0.05);
		}
	}
}

/*
	Name: function_b01c4bcb
	Namespace: namespace_4c773ed3
	Checksum: 0xFB703A77
	Offset: 0xCF0
	Size: 0x62
	Parameters: 2
	Flags: None
*/
function function_b01c4bcb(var_33b64687, command)
{
	while(true)
	{
		while(!self [[var_33b64687]]())
		{
			wait(0.05);
		}
		while(self [[var_33b64687]]())
		{
			wait(0.05);
		}
		self notify(command);
	}
}

/*
	Name: setupkeybindings
	Namespace: namespace_4c773ed3
	Checksum: 0x1025E606
	Offset: 0xD60
	Size: 0x184
	Parameters: 0
	Flags: None
*/
function setupkeybindings()
{
	if(isai(self))
	{
		return;
	}
	self notifyonplayercommand("lock", "+attack");
	self notifyonplayercommand("spin", "+toggleads_throw");
	self notifyonplayercommand("changeProp", "weapnext");
	self notifyonplayercommand("setToSlope", "+usereload");
	self notifyonplayercommand("propAbility", "+smoke");
	self notifyonplayercommand("cloneProp", "+actionslot 2");
	self notifyonplayercommand("zoomin", "+actionslot 3");
	self notifyonplayercommand("zoomout", "+actionslot 4");
	self notifyonplayercommand("hide", "+melee");
}

/*
	Name: function_3122ae57
	Namespace: namespace_4c773ed3
	Checksum: 0xDF004209
	Offset: 0xEF0
	Size: 0x184
	Parameters: 0
	Flags: None
*/
function function_3122ae57()
{
	if(isai(self))
	{
		return;
	}
	self notifyonplayercommandremove("lock", "+attack");
	self notifyonplayercommandremove("spin", "+toggleads_throw");
	self notifyonplayercommandremove("changeProp", "+weapnext");
	self notifyonplayercommandremove("setToSlope", "+usereload");
	self notifyonplayercommandremove("propAbility", "+smoke");
	self notifyonplayercommandremove("cloneProp", "+actionslot 2");
	self notifyonplayercommandremove("zoomin", "+actionslot 3");
	self notifyonplayercommandremove("zoomout", "+actionslot 4");
	self notifyonplayercommandremove("hide", "+melee");
}

/*
	Name: is_player_gamepad_enabled
	Namespace: namespace_4c773ed3
	Checksum: 0x249680DE
	Offset: 0x1080
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function is_player_gamepad_enabled()
{
	return self gamepadusedlast();
}

/*
	Name: addupperrighthudelem
	Namespace: namespace_4c773ed3
	Checksum: 0x3678A526
	Offset: 0x10A8
	Size: 0x224
	Parameters: 4
	Flags: None
*/
function addupperrighthudelem(label, value, text, labelpc)
{
	hudelem = hud::createfontstring("default", 1.2);
	hudelem.x = -15;
	hudelem.y = self.currenthudy;
	hudelem.alignx = "right";
	hudelem.aligny = "bottom";
	hudelem.horzalign = "right";
	hudelem.vertalign = "bottom";
	hudelem.archived = 1;
	hudelem.alpha = 1;
	hudelem.glowalpha = 0;
	hudelem.hidewheninmenu = 1;
	hudelem.hidewheninkillcam = 1;
	hudelem.startfontscale = hudelem.fontscale;
	if(isdefined(label) && isdefined(labelpc))
	{
		if(self is_player_gamepad_enabled())
		{
			hudelem.label = label;
		}
		else
		{
			hudelem.label = labelpc;
		}
	}
	else
	{
		if(isdefined(label))
		{
			hudelem.label = label;
		}
		else if(isdefined(text))
		{
			hudelem settext(text);
		}
	}
	if(isdefined(value))
	{
		hudelem setvalue(value);
	}
	self.currenthudy = self.currenthudy - 20;
	return hudelem;
}

/*
	Name: propcontrolshud
	Namespace: namespace_4c773ed3
	Checksum: 0xC6AFB0C3
	Offset: 0x12D8
	Size: 0x1BC
	Parameters: 0
	Flags: None
*/
function propcontrolshud()
{
	/#
		assert(!isdefined(self.changepropkey));
	#/
	if(self issplitscreen())
	{
		self.currenthudy = -10;
	}
	else
	{
		self.currenthudy = -80;
	}
	self.abilitykey = addupperrighthudelem();
	self.clonekey = addupperrighthudelem(&"MP_PH_CLONE");
	self.changepropkey = addupperrighthudelem(&"MP_PH_CHANGE", 0);
	self.currenthudy = self.currenthudy - 20;
	self.var_6f16621b = addupperrighthudelem(&"MP_PH_HIDEPROP");
	self.matchslopekey = addupperrighthudelem(&"MP_PH_SLOPE", undefined, undefined, &"MP_PH_SLOPE_PC");
	self.lockpropkey = addupperrighthudelem(&"MP_PH_LOCK");
	self.spinpropkey = addupperrighthudelem(&"MP_PH_SPIN", undefined, undefined, &"MP_PH_SPIN_PC");
	self setnewabilityhud();
	self.zoomkey = addupperrighthudelem(&"MP_PH_ZOOM");
	self thread updatetextongamepadchange();
}

/*
	Name: cleanuppropcontrolshudondeath
	Namespace: namespace_4c773ed3
	Checksum: 0x8C6846C5
	Offset: 0x14A0
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function cleanuppropcontrolshudondeath()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self waittill(#"death");
	self thread function_3122ae57();
	self thread cleanuppropcontrolshud();
}

/*
	Name: safedestroy
	Namespace: namespace_4c773ed3
	Checksum: 0xAE94B016
	Offset: 0x1500
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function safedestroy(hudelem)
{
	if(isdefined(hudelem))
	{
		hudelem destroy();
	}
}

/*
	Name: cleanuppropcontrolshud
	Namespace: namespace_4c773ed3
	Checksum: 0x98FEB889
	Offset: 0x1538
	Size: 0xDC
	Parameters: 0
	Flags: None
*/
function cleanuppropcontrolshud()
{
	safedestroy(self.changepropkey);
	safedestroy(self.spinpropkey);
	safedestroy(self.lockpropkey);
	safedestroy(self.matchslopekey);
	safedestroy(self.abilitykey);
	safedestroy(self.zoomkey);
	safedestroy(self.spectatekey);
	safedestroy(self.clonekey);
	safedestroy(self.var_6f16621b);
}

/*
	Name: updatetextongamepadchange
	Namespace: namespace_4c773ed3
	Checksum: 0x80F56F06
	Offset: 0x1620
	Size: 0x178
	Parameters: 0
	Flags: None
*/
function updatetextongamepadchange()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"death");
	if(level.console)
	{
		return;
	}
	waittillframeend();
	var_85e0f0fe = self is_player_gamepad_enabled();
	while(true)
	{
		var_521408c = self is_player_gamepad_enabled();
		if(var_521408c != var_85e0f0fe)
		{
			var_85e0f0fe = var_521408c;
			if(var_521408c)
			{
				if(!(isdefined(self.slopelocked) && self.slopelocked))
				{
					self.matchslopekey.label = &"MP_PH_SLOPE";
				}
				else
				{
					self.matchslopekey.label = &"MP_PH_SLOPED";
				}
				self.spinpropkey.label = &"MP_PH_SPIN";
			}
			else
			{
				if(!(isdefined(self.slopelocked) && self.slopelocked))
				{
					self.matchslopekey.label = &"MP_PH_SLOPE_PC";
				}
				else
				{
					self.matchslopekey.label = &"MP_PH_SLOPED_PC";
				}
				self.spinpropkey.label = &"MP_PH_SPIN_PC";
			}
		}
		wait(0.05);
	}
}

/*
	Name: propinputwatch
	Namespace: namespace_4c773ed3
	Checksum: 0xEE6AF523
	Offset: 0x17A0
	Size: 0x230
	Parameters: 0
	Flags: None
*/
function propinputwatch()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	if(isai(self))
	{
		return;
	}
	self.lock = 0;
	self.slopelocked = 0;
	prop::function_45c842e9();
	self thread propmoveunlock();
	self thread propcamerazoom();
	self.debugnextpropindex = 1;
	while(true)
	{
		msg = self util::waittill_any_return("lock", "spin", "changeProp", "setToSlope", "propAbility", "cloneProp", "hide");
		if(!isdefined(msg))
		{
			continue;
		}
		waittillframeend();
		if(msg == "lock")
		{
			self proplockunlock();
		}
		else
		{
			if(msg == "spin")
			{
				self function_90ce903e();
			}
			else
			{
				if(msg == "changeProp")
				{
					self propchange();
				}
				else
				{
					if(msg == "setToSlope")
					{
						self propmatchslope();
					}
					else
					{
						if(msg == "propAbility")
						{
							self propability();
						}
						else
						{
							if(msg == "cloneProp")
							{
								self propclonepower();
							}
							else if(msg == "hide")
							{
								self function_8b7be7e3();
							}
						}
					}
				}
			}
		}
	}
}

/*
	Name: proplockunlock
	Namespace: namespace_4c773ed3
	Checksum: 0x5D846836
	Offset: 0x19D8
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function proplockunlock()
{
	if(self ismantling())
	{
		return;
	}
	if(self.lock)
	{
		self unlockprop();
	}
	else
	{
		self lockprop();
	}
}

/*
	Name: function_90ce903e
	Namespace: namespace_4c773ed3
	Checksum: 0xF2CF965E
	Offset: 0x1A38
	Size: 0xCC
	Parameters: 0
	Flags: None
*/
function function_90ce903e()
{
	self.propent unlink();
	self.propent.angles = self.propent.angles + vectorscale((0, 1, 0), 45);
	self.propent.origin = self.propanchor.origin;
	if(self.slopelocked && (isdefined(self.lock) && self.lock))
	{
		self.propent set_pitch_roll_for_ground_normal(self.prop);
	}
	self.propent linkto(self.propanchor);
}

/*
	Name: registerpreviousprop
	Namespace: namespace_4c773ed3
	Checksum: 0x1D7F12AD
	Offset: 0x1B10
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function registerpreviousprop(var_bc9de76b)
{
	var_771596a5 = 3;
	if(!isdefined(var_bc9de76b.usedpropsindex))
	{
		var_bc9de76b.usedpropsindex = 0;
	}
	var_bc9de76b.usedprops[var_bc9de76b.usedpropsindex] = var_bc9de76b.prop.info;
	var_bc9de76b.usedpropsindex++;
	if(var_bc9de76b.usedpropsindex >= var_771596a5)
	{
		var_bc9de76b.usedpropsindex = 0;
	}
}

/*
	Name: propchange
	Namespace: namespace_4c773ed3
	Checksum: 0x9E4F481D
	Offset: 0x1BC0
	Size: 0x294
	Parameters: 0
	Flags: None
*/
function propchange()
{
	if(!self prophaschangesleft())
	{
		return;
	}
	if(!level.console)
	{
		var_6f5743e8 = 300;
		if(isdefined(self.lastpropchangetime) && (gettime() - self.lastpropchangetime) < var_6f5743e8)
		{
			return;
		}
		self.lastpropchangetime = gettime();
	}
	self notify(#"hash_a603bd25");
	registerpreviousprop(self);
	self.prop.info = prop::getnextprop(self);
	/#
		if(getdvarint("", 0) != 0)
		{
			self.prop.info = level.proplist[self.debugnextpropindex];
			self.debugnextpropindex++;
			if(self.debugnextpropindex >= level.proplist.size)
			{
				self.debugnextpropindex = 0;
			}
		}
	#/
	self propchangeto(self.prop.info);
	if(level.phsettings.var_e332c699)
	{
		playfxontag("player/fx_plyr_clone_reaper_appear", self.prop, "tag_origin");
	}
	self.maxhealth = int(prop::getprophealth(self.prop.info));
	self setnormalhealth(1);
	self setnewabilitycount(self.currentability);
	self setnewabilitycount("CLONE");
	if(prop::useprophudserver())
	{
		self.abilitykey.alpha = 1;
		self.clonekey.alpha = 1;
	}
	/#
		if(getdvarint("", 0) != 0)
		{
			return;
		}
	#/
	self propdeductchange();
}

/*
	Name: prophaschangesleft
	Namespace: namespace_4c773ed3
	Checksum: 0x738EF7AD
	Offset: 0x1E60
	Size: 0x2E
	Parameters: 0
	Flags: None
*/
function prophaschangesleft()
{
	/#
		if(isdefined(self.var_c4494f8d) && self.var_c4494f8d)
		{
			return 1;
		}
	#/
	return self.changesleft > 0;
}

/*
	Name: propdeductchange
	Namespace: namespace_4c773ed3
	Checksum: 0x663C8F47
	Offset: 0x1E98
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function propdeductchange()
{
	/#
		if(isdefined(self.var_c4494f8d) && self.var_c4494f8d)
		{
			return;
		}
	#/
	propsetchangesleft(self.changesleft - 1);
}

/*
	Name: propsetchangesleft
	Namespace: namespace_4c773ed3
	Checksum: 0x31A18AB3
	Offset: 0x1EE8
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function propsetchangesleft(newvalue)
{
	self.changesleft = newvalue;
	if(prop::useprophudserver())
	{
		self.changepropkey setvalue(self.changesleft);
		if(self.changesleft <= 0)
		{
			self.changepropkey.alpha = 0.5;
		}
	}
}

/*
	Name: propchangeto
	Namespace: namespace_4c773ed3
	Checksum: 0xEF4A0DB8
	Offset: 0x1F68
	Size: 0x374
	Parameters: 1
	Flags: None
*/
function propchangeto(info)
{
	self.prop.info = info;
	self.propinfo = info;
	if(level.phsettings.var_e332c699)
	{
		var_5e63b8b5 = self.propent.angles;
		var_345eaa38 = self.prop.angles;
		var_9b6a4a66 = self.angles;
	}
	self.prop setmodel(info.modelname);
	self.prop.xyzoffset = info.xyzoffset;
	self.prop.anglesoffset = info.anglesoffset;
	self.prop setscale(info.var_bbac36c8, 1);
	self.prop unlink();
	self.propent unlink();
	self.propent.origin = self.propanchor.origin;
	self.prop.origin = self.propent.origin;
	self.propent.angles = (self.angles[0], self.propent.angles[1], self.angles[2]);
	self.prop.angles = self.propent.angles;
	if(isdefined(self.isangleoffset) && self.isangleoffset)
	{
		self.prop.angles = self.angles;
		self.isangleoffset = 0;
	}
	self prop::applyxyzoffset();
	self prop::applyanglesoffset();
	if(level.phsettings.var_e332c699)
	{
		self.propent.angles = var_5e63b8b5;
		self.prop.angles = var_345eaa38;
		self.angles = var_9b6a4a66;
	}
	self.prop linkto(self.propent);
	if(self.slopelocked && (isdefined(self.lock) && self.lock))
	{
		self.propent set_pitch_roll_for_ground_normal(self.prop);
	}
	self.propent linkto(self.propanchor);
	self.thirdpersonrange = info.proprange;
	self.thirdpersonheightoffset = info.propheight;
	self setclientthirdperson(1, self.thirdpersonrange, self.thirdpersonheightoffset);
}

/*
	Name: propmatchslope
	Namespace: namespace_4c773ed3
	Checksum: 0x75289AB7
	Offset: 0x22E8
	Size: 0x214
	Parameters: 0
	Flags: None
*/
function propmatchslope()
{
	if(!(isdefined(self.slopelocked) && self.slopelocked))
	{
		self.slopelocked = 1;
		if(isdefined(self.lock) && self.lock)
		{
			self.propent unlink();
			self.propent set_pitch_roll_for_ground_normal(self.prop);
			self.propent linkto(self.propanchor);
		}
		if(prop::useprophudserver())
		{
			if(self is_player_gamepad_enabled())
			{
				self.matchslopekey.label = &"MP_PH_SLOPED";
			}
			else
			{
				self.matchslopekey.label = &"MP_PH_SLOPED_PC";
			}
		}
	}
	else
	{
		self.slopelocked = 0;
		if(isdefined(self.lock) && self.lock)
		{
			self.propent unlink();
			self.propent.angles = (self.angles[0], self.propent.angles[1], self.angles[2]);
			self.propent.origin = self.propanchor.origin;
			self.propent linkto(self.propanchor);
		}
		if(prop::useprophudserver())
		{
			if(self is_player_gamepad_enabled())
			{
				self.matchslopekey.label = &"MP_PH_SLOPE";
			}
			else
			{
				self.matchslopekey.label = &"MP_PH_SLOPE_PC";
			}
		}
	}
}

/*
	Name: propability
	Namespace: namespace_4c773ed3
	Checksum: 0xB929FB78
	Offset: 0x2508
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function propability()
{
	if(!level flag::get("props_hide_over"))
	{
		return;
	}
	if(self prophasflashesleft())
	{
		self thread flashenemies();
		self propdeductflash();
	}
}

/*
	Name: propclonepower
	Namespace: namespace_4c773ed3
	Checksum: 0xF12C4CD6
	Offset: 0x2580
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function propclonepower()
{
	if(prophasclonesleft())
	{
		self thread cloneprop();
		self thread propdeductclonechange();
	}
}

/*
	Name: prophasclonesleft
	Namespace: namespace_4c773ed3
	Checksum: 0x26838613
	Offset: 0x25D0
	Size: 0x2E
	Parameters: 0
	Flags: None
*/
function prophasclonesleft()
{
	/#
		if(isdefined(self.var_b53602f4) && self.var_b53602f4)
		{
			return 1;
		}
	#/
	return self.clonesleft > 0;
}

/*
	Name: propdeductclonechange
	Namespace: namespace_4c773ed3
	Checksum: 0x8D286D0F
	Offset: 0x2608
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function propdeductclonechange()
{
	/#
		if(isdefined(self.var_b53602f4) && self.var_b53602f4)
		{
			return;
		}
	#/
	propsetclonesleft(self.clonesleft - 1);
}

/*
	Name: propsetclonesleft
	Namespace: namespace_4c773ed3
	Checksum: 0x1E11CF07
	Offset: 0x2658
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function propsetclonesleft(newvalue)
{
	self.clonesleft = newvalue;
	if(prop::useprophudserver() && isdefined(self) && isalive(self) && isdefined(self.clonekey))
	{
		self.clonekey setvalue(self.clonesleft);
		if(self.clonesleft <= 0)
		{
			self.clonekey.alpha = 0.5;
		}
		else
		{
			self.clonekey.alpha = 1;
		}
	}
}

/*
	Name: prophasflashesleft
	Namespace: namespace_4c773ed3
	Checksum: 0x52BC6043
	Offset: 0x2720
	Size: 0x2E
	Parameters: 0
	Flags: None
*/
function prophasflashesleft()
{
	/#
		if(isdefined(self.var_2f1101f4) && self.var_2f1101f4)
		{
			return 1;
		}
	#/
	return self.abilityleft > 0;
}

/*
	Name: propdeductflash
	Namespace: namespace_4c773ed3
	Checksum: 0xFE63C964
	Offset: 0x2758
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function propdeductflash()
{
	/#
		if(isdefined(self.var_2f1101f4) && self.var_2f1101f4)
		{
			return;
		}
	#/
	propsetflashesleft(self.abilityleft - 1);
}

/*
	Name: propsetflashesleft
	Namespace: namespace_4c773ed3
	Checksum: 0x46EE740A
	Offset: 0x27A8
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function propsetflashesleft(newvalue)
{
	self.abilityleft = newvalue;
	if(prop::useprophudserver())
	{
		self.abilitykey setvalue(self.abilityleft);
		if(self.abilityleft <= 0)
		{
			self.abilitykey.alpha = 0.5;
		}
	}
}

/*
	Name: set_pitch_roll_for_ground_normal
	Namespace: namespace_4c773ed3
	Checksum: 0x480275B7
	Offset: 0x2828
	Size: 0x1F0
	Parameters: 1
	Flags: None
*/
function set_pitch_roll_for_ground_normal(var_a84e1ffa)
{
	groundnormal = get_ground_normal(var_a84e1ffa, 0);
	if(!isdefined(groundnormal))
	{
		return;
	}
	var_a8f94d84 = anglestoforward(self.angles);
	ovr = anglestoright(self.angles);
	new_angles = vectortoangles(groundnormal);
	pitch = angleclamp180(new_angles[0] + 90);
	new_angles = (0, new_angles[1], 0);
	var_7001e881 = anglestoforward(new_angles);
	mod = vectordot(var_7001e881, ovr);
	if(mod < 0)
	{
		mod = -1;
	}
	else
	{
		mod = 1;
	}
	dot = vectordot(var_7001e881, var_a8f94d84);
	var_4ef8701 = dot * pitch;
	var_676ea8f0 = ((1 - abs(dot)) * pitch) * mod;
	self.angles = (var_4ef8701, self.angles[1], var_676ea8f0);
}

/*
	Name: function_b811663a
	Namespace: namespace_4c773ed3
	Checksum: 0x2E4EE664
	Offset: 0x2A20
	Size: 0xD2
	Parameters: 1
	Flags: None
*/
function function_b811663a(var_32d4bb6a)
{
	foreach(player in level.players)
	{
		if(isdefined(player.prop))
		{
			if(var_32d4bb6a)
			{
				player.prop notsolid();
				continue;
			}
			player.prop solid();
		}
	}
}

/*
	Name: function_af3207f6
	Namespace: namespace_4c773ed3
	Checksum: 0x37D45F6D
	Offset: 0x2B00
	Size: 0x148
	Parameters: 1
	Flags: None
*/
function function_af3207f6(var_32d4bb6a)
{
	foreach(player in level.players)
	{
		if(isdefined(player.propclones))
		{
			foreach(clone in player.propclones)
			{
				if(isdefined(clone))
				{
					if(var_32d4bb6a)
					{
						clone notsolid();
						continue;
					}
					clone solid();
				}
			}
		}
	}
}

/*
	Name: get_ground_normal
	Namespace: namespace_4c773ed3
	Checksum: 0x6C49E6EB
	Offset: 0x2C50
	Size: 0x3BE
	Parameters: 2
	Flags: None
*/
function get_ground_normal(var_a84e1ffa, debug)
{
	if(!isdefined(var_a84e1ffa))
	{
		ignore = self;
	}
	else
	{
		ignore = var_a84e1ffa;
	}
	var_4f9e9c19 = array(self.origin);
	if(getdvarint("scr_ph_useBoundsForGroundNormal", 1))
	{
		i = -1;
		while(i <= 1)
		{
			j = -1;
			while(j <= 1)
			{
				corner = ignore getpointinbounds(i, j, 0);
				corner = (corner[0], corner[1], self.origin[2]);
				var_4f9e9c19[var_4f9e9c19.size] = corner;
				j = j + 2;
			}
			i = i + 2;
		}
	}
	function_b811663a(1);
	var_d54ec402 = (0, 0, 0);
	var_6146aef8 = 0;
	foreach(point in var_4f9e9c19)
	{
		trace = bullettrace(point + vectorscale((0, 0, 1), 4), point + (vectorscale((0, 0, -1), 16)), 0, ignore);
		tracehit = trace["fraction"] > 0 && trace["fraction"] < 1;
		if(tracehit)
		{
			var_d54ec402 = var_d54ec402 + trace["normal"];
			var_6146aef8++;
		}
		/#
			if(debug)
			{
				if(tracehit)
				{
					line(point, point + (trace[""] * 30), (0, 1, 0));
					continue;
				}
				sphere(point, 3, (1, 0, 0));
			}
		#/
	}
	function_b811663a(0);
	if(var_6146aef8 > 0)
	{
		var_d54ec402 = var_d54ec402 / var_6146aef8;
		/#
			if(debug)
			{
				line(self.origin, self.origin + (var_d54ec402 * 20), (1, 1, 1));
			}
		#/
		return var_d54ec402;
	}
	/#
		if(debug)
		{
			sphere(self.origin, 5, (1, 0, 0));
		}
	#/
	return undefined;
}

/*
	Name: propmoveunlock
	Namespace: namespace_4c773ed3
	Checksum: 0x6C819B5D
	Offset: 0x3018
	Size: 0x18E
	Parameters: 0
	Flags: None
*/
function propmoveunlock()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	var_f98cbcda = 0;
	var_bc31618a = 0;
	var_449744f5 = 0;
	while(true)
	{
		wait(0.05);
		movement = self getnormalizedmovement();
		jumping = self jumpbuttonpressed();
		if(!isdefined(movement))
		{
			continue;
		}
		ismoving = movement[0] != 0 || movement[1] != 0 || jumping;
		if(self.lock && var_449744f5 && !ismoving)
		{
			var_449744f5 = 0;
		}
		else
		{
			if(self.lock && !var_f98cbcda && ismoving)
			{
				var_449744f5 = 1;
			}
			else if(self.lock && ismoving && !var_449744f5)
			{
				self unlockprop();
			}
		}
		var_f98cbcda = self.lock;
		var_bc31618a = ismoving;
	}
}

/*
	Name: unlockprop
	Namespace: namespace_4c773ed3
	Checksum: 0xAB53B618
	Offset: 0x31B0
	Size: 0x13C
	Parameters: 0
	Flags: None
*/
function unlockprop()
{
	self unlink();
	self resetdoublejumprechargetime();
	if(self.slopelocked)
	{
		self.propent unlink();
		self.propent.angles = (self.angles[0], self.propent.angles[1], self.angles[2]);
		self.propent.origin = self.propanchor.origin;
		self.propent linkto(self.propanchor);
	}
	self.propanchor linkto(self);
	self.lock = 0;
	if(prop::useprophudserver())
	{
		self.lockpropkey.label = &"MP_PH_LOCK";
		self thread flashlockpropkey();
	}
}

/*
	Name: lockprop
	Namespace: namespace_4c773ed3
	Checksum: 0x6C4ADE18
	Offset: 0x32F8
	Size: 0x144
	Parameters: 0
	Flags: None
*/
function lockprop()
{
	if(!canlock())
	{
		return;
	}
	self.propanchor unlink();
	self.propanchor.origin = self.origin;
	self playerlinkto(self.propanchor);
	if(self.slopelocked)
	{
		self.propent unlink();
		self.propent set_pitch_roll_for_ground_normal(self.prop);
		self.propent.origin = self.origin;
		self.propent linkto(self.propanchor);
	}
	self.lock = 1;
	self notify(#"locked");
	if(prop::useprophudserver())
	{
		self.lockpropkey.label = &"MP_PH_LOCKED";
		self thread flashlockpropkey();
	}
}

/*
	Name: flashlockpropkey
	Namespace: namespace_4c773ed3
	Checksum: 0xA93CFCF3
	Offset: 0x3448
	Size: 0xEC
	Parameters: 0
	Flags: None
*/
function flashlockpropkey()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	self notify(#"flashlockpropkey");
	self endon(#"flashlockpropkey");
	var_ec404e3d = self.lockpropkey.startfontscale + 0.75;
	self.lockpropkey changefontscaleovertime(0.1);
	self.lockpropkey.fontscale = var_ec404e3d;
	wait(0.1);
	if(isdefined(self.lockpropkey))
	{
		self.lockpropkey changefontscaleovertime(0.1);
		self.lockpropkey.fontscale = self.lockpropkey.startfontscale;
	}
}

/*
	Name: function_fd824ee5
	Namespace: namespace_4c773ed3
	Checksum: 0xEEDEB620
	Offset: 0x3540
	Size: 0x7A
	Parameters: 0
	Flags: None
*/
function function_fd824ee5()
{
	/#
		assert(isplayer(self));
	#/
	start = self.origin;
	end = start + (vectorscale((0, 0, -1), 2000));
	return playerphysicstrace(start, end);
}

/*
	Name: function_b9733d59
	Namespace: namespace_4c773ed3
	Checksum: 0xA7C9C622
	Offset: 0x35C8
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function function_b9733d59()
{
	/#
		assert(isplayer(self));
	#/
	start = self.origin;
	end = start + (vectorscale((0, 0, -1), 2000));
	trace = bullettrace(start, end, 0, self.prop);
	return trace;
}

/*
	Name: function_2dff88ca
	Namespace: namespace_4c773ed3
	Checksum: 0x2D6A8CDD
	Offset: 0x3668
	Size: 0x1A4
	Parameters: 9
	Flags: None
*/
function function_2dff88ca(success, type, player, origin1, text1, origin2, text2, origin3, text3)
{
	/#
		if(!isdefined(level.var_ec1690fd))
		{
			level.var_ec1690fd = spawnstruct();
		}
		level.var_ec1690fd.success = success;
		level.var_ec1690fd.type = type;
		level.var_ec1690fd.playerorg = player.origin;
		level.var_ec1690fd.playerangles = player.angles;
		level.var_ec1690fd.playermins = player getmins();
		level.var_ec1690fd.playermaxs = player getmaxs();
		level.var_ec1690fd.origin1 = origin1;
		level.var_ec1690fd.text1 = text1;
		level.var_ec1690fd.origin2 = origin2;
		level.var_ec1690fd.text2 = text2;
		level.var_ec1690fd.origin3 = origin3;
		level.var_ec1690fd.text3 = text3;
	#/
}

/*
	Name: canlock
	Namespace: namespace_4c773ed3
	Checksum: 0x870959C3
	Offset: 0x3818
	Size: 0x6D8
	Parameters: 0
	Flags: None
*/
function canlock()
{
	killtriggers = getentarray("trigger_hurt", "classname");
	oobtriggers = getentarray("trigger_out_of_bounds", "classname");
	triggers = arraycombine(killtriggers, oobtriggers, 0, 0);
	var_40aa9cbd = getentarray("prop_no_lock", "targetname");
	if(var_40aa9cbd.size > 0)
	{
		triggers = arraycombine(triggers, var_40aa9cbd, 0, 0);
	}
	foreach(trigger in triggers)
	{
		if(trigger istouchingvolume(self.origin, self getmins(), self getmaxs()))
		{
			/#
				function_2dff88ca(0, "", self, trigger.origin, trigger.classname);
			#/
			return false;
		}
	}
	if(self isplayerswimming())
	{
		/#
			function_2dff88ca(1, "", self);
		#/
		return true;
	}
	if(!self isonground() || self iswallrunning())
	{
		trace1 = self function_b9733d59();
		frac = trace1["fraction"];
		org1 = trace1["position"];
		if(frac == 1)
		{
			/#
				function_2dff88ca(0, "", self, org1, "");
			#/
			return false;
		}
		foreach(trigger in triggers)
		{
			if(trigger istouchingvolume(org1, self getmins(), self getmaxs()))
			{
				/#
					function_2dff88ca(0, "", self, trigger.origin, trigger.classname);
				#/
				return false;
			}
		}
		point = getnearestpathpoint(org1, 256);
		if(!isdefined(point))
		{
			/#
				function_2dff88ca(0, "", self, org1);
			#/
			return false;
		}
		distz = point[2] - org1[2];
		if(distz > 50)
		{
			point2 = getnearestpathpoint(org1, 50);
			if(!isdefined(point2))
			{
				/#
					function_2dff88ca(0, "", self, org1, "", point, "");
				#/
				return false;
			}
		}
		dist2d = distance2d(point, org1);
		if(dist2d > 100)
		{
			/#
				function_2dff88ca(0, "", self, org1, "", point, "");
			#/
			return false;
		}
		org2 = self function_fd824ee5();
		foreach(trigger in triggers)
		{
			if(trigger istouchingvolume(org2, self getmins(), self getmaxs()))
			{
				/#
					function_2dff88ca(0, "", self, trigger.origin, trigger.classname);
				#/
				return false;
			}
		}
		/#
			function_2dff88ca(1, "", self, org1, "", org2, "", point, "" + distance(org1, point));
		#/
		return true;
	}
	/#
		function_2dff88ca(1, "", self);
	#/
	return true;
}

/*
	Name: propcamerazoom
	Namespace: namespace_4c773ed3
	Checksum: 0xE48D10B9
	Offset: 0x3F00
	Size: 0x1C8
	Parameters: 0
	Flags: None
*/
function propcamerazoom()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	var_8ea3acea = 10;
	self.thirdpersonrange = self.prop.info.proprange;
	while(true)
	{
		zoom = self util::waittill_any_return("zoomin", "zoomout");
		if(!isdefined(zoom))
		{
			continue;
		}
		if(zoom == "zoomin")
		{
			if((self.thirdpersonrange - var_8ea3acea) < 50)
			{
				continue;
			}
			self.thirdpersonrange = self.thirdpersonrange - var_8ea3acea;
			self setclientthirdperson(1, self.thirdpersonrange, self.thirdpersonheightoffset);
		}
		else if(zoom == "zoomout")
		{
			var_b751fa63 = math::clamp(self.prop.info.proprange + 50, 50, 360);
			if((self.thirdpersonrange + var_8ea3acea) > var_b751fa63)
			{
				continue;
			}
			self.thirdpersonrange = self.thirdpersonrange + var_8ea3acea;
			self setclientthirdperson(1, self.thirdpersonrange, self.thirdpersonheightoffset);
		}
	}
}

/*
	Name: setnewabilityhud
	Namespace: namespace_4c773ed3
	Checksum: 0x83D231CB
	Offset: 0x40D0
	Size: 0x66
	Parameters: 0
	Flags: None
*/
function setnewabilityhud()
{
	switch(self.currentability)
	{
		case "FLASH":
		{
			self.abilitykey.label = &"MP_PH_FLASH";
			break;
		}
		default:
		{
			/#
				assertmsg("");
			#/
			break;
		}
	}
}

/*
	Name: setnewabilitycount
	Namespace: namespace_4c773ed3
	Checksum: 0xE9446F13
	Offset: 0x4140
	Size: 0xD6
	Parameters: 2
	Flags: None
*/
function setnewabilitycount(var_9c968389, count)
{
	switch(var_9c968389)
	{
		case "FLASH":
		{
			if(!isdefined(count))
			{
				count = level.phsettings.propnumflashes;
			}
			propsetflashesleft(count);
			break;
		}
		case "CLONE":
		{
			if(!isdefined(count))
			{
				count = level.phsettings.propnumclones;
			}
			propsetclonesleft(count);
			break;
		}
		default:
		{
			/#
				assertmsg("" + var_9c968389);
			#/
			break;
		}
	}
}

/*
	Name: endondeath
	Namespace: namespace_4c773ed3
	Checksum: 0x34B087B9
	Offset: 0x4220
	Size: 0x1E
	Parameters: 0
	Flags: None
*/
function endondeath()
{
	self waittill(#"death");
	waittillframeend();
	self notify(#"end_explode");
}

/*
	Name: flashtheprops
	Namespace: namespace_4c773ed3
	Checksum: 0xABFE86D4
	Offset: 0x4248
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function flashtheprops(var_e967d644)
{
	level endon(#"game_ended");
	var_e967d644 endon(#"disconnect");
	self thread endondeath();
	self endon(#"end_explode");
	self waittill(#"explode", position);
	if(!isdefined(var_e967d644))
	{
		return;
	}
	flashenemies(var_e967d644, position);
}

/*
	Name: flashenemies
	Namespace: namespace_4c773ed3
	Checksum: 0xADBF8D03
	Offset: 0x42D8
	Size: 0x33A
	Parameters: 2
	Flags: None
*/
function flashenemies(var_e967d644 = self, position = self.origin)
{
	playfx(fx::get("propFlash"), position + vectorscale((0, 0, 1), 4));
	playsoundatposition("mpl_emp_equip_stun", position);
	foreach(otherplayer in level.players)
	{
		if(otherplayer == var_e967d644)
		{
			continue;
		}
		if(isdefined(otherplayer.flashimmune) && otherplayer.flashimmune)
		{
			continue;
		}
		if(!isdefined(otherplayer) || !isalive(otherplayer) || !isdefined(otherplayer.team) || otherplayer.team != game["attackers"])
		{
			continue;
		}
		vec = (position + vectorscale((0, 0, 1), 4)) - otherplayer geteye();
		dist = length(vec);
		var_6df9e8b8 = 500;
		var_88ef1466 = 150;
		if(dist <= var_6df9e8b8)
		{
			if(dist <= var_88ef1466)
			{
				var_bdf6b2ee = 1;
			}
			else
			{
				var_bdf6b2ee = 1 - (dist - var_88ef1466) / (var_6df9e8b8 - var_88ef1466);
			}
			dir = vectornormalize(vec);
			fwd = anglestoforward(otherplayer getplayerangles());
			var_b02fb38d = vectordot(fwd, dir);
			otherplayer notify(#"flashbang", var_bdf6b2ee, var_b02fb38d, var_e967d644);
			var_e967d644 thread damagefeedback::update();
		}
	}
}

/*
	Name: deletepropsifatmax
	Namespace: namespace_4c773ed3
	Checksum: 0x9EC5F38
	Offset: 0x4620
	Size: 0x1E0
	Parameters: 0
	Flags: None
*/
function deletepropsifatmax()
{
	var_b793211e = 9;
	if(level.phsettings.var_78280ce0)
	{
		var_b793211e = 27;
	}
	if((self.propclones.size + 1) <= var_b793211e)
	{
		return;
	}
	var_b76d0af5 = 0;
	foreach(clone in self.propclones)
	{
		if(isdefined(clone))
		{
			var_b76d0af5++;
		}
	}
	if((var_b76d0af5 + 1) <= var_b793211e)
	{
		return;
	}
	clones = [];
	var_1292f83e = undefined;
	for(i = 0; i < self.propclones.size; i++)
	{
		clone = self.propclones[i];
		if(!isdefined(clone))
		{
			continue;
		}
		if(!isdefined(var_1292f83e))
		{
			var_1292f83e = clone;
			continue;
		}
		clones[clones.size] = clone;
	}
	/#
		assert(isdefined(var_1292f83e));
	#/
	var_1292f83e notify(#"hash_63ce821c");
	var_1292f83e delete();
	self.propclones = clones;
}

/*
	Name: cloneprop
	Namespace: namespace_4c773ed3
	Checksum: 0x6DA9C3B
	Offset: 0x4808
	Size: 0x286
	Parameters: 0
	Flags: None
*/
function cloneprop()
{
	if(!isdefined(self.propclones))
	{
		self.propclones = [];
	}
	else
	{
		deletepropsifatmax();
	}
	var_a20cbf64 = spawn("script_model", self.prop.origin);
	var_a20cbf64.targetname = "propClone";
	var_a20cbf64 setmodel(self.prop.model);
	var_a20cbf64 setscale(self.prop.info.var_bbac36c8, 1);
	var_a20cbf64.angles = self.prop.angles;
	var_a20cbf64 setcandamage(1);
	var_a20cbf64.fakehealth = 50;
	var_a20cbf64.health = 99999;
	var_a20cbf64.maxhealth = 99999;
	var_a20cbf64.playerowner = self;
	var_a20cbf64 thread prop::function_500dc7d9(&damageclonewatch);
	var_a20cbf64 setplayercollision(0);
	var_a20cbf64 makesentient();
	var_a20cbf64 notsolidcapsule();
	var_a20cbf64 setteam(self.team);
	var_a20cbf64 clientfield::set("enemyequip", 2);
	if(prop::function_503c9413())
	{
		var_a20cbf64 hidefromteam(game["attackers"]);
		var_a20cbf64 notsolid();
	}
	if(level.phsettings.var_78280ce0)
	{
		var_a20cbf64.fakehealth = 100;
	}
	self.propclones[self.propclones.size] = var_a20cbf64;
}

/*
	Name: damageclonewatch
	Namespace: namespace_4c773ed3
	Checksum: 0xBF1929A5
	Offset: 0x4A98
	Size: 0x174
	Parameters: 10
	Flags: None
*/
function damageclonewatch(damage, attacker, direction_vec, point, meansofdeath, modelname, tagname, partname, weapon, idflags)
{
	if(!isdefined(attacker))
	{
		return;
	}
	if(isplayer(attacker))
	{
		if(isdefined(self.isdying) && self.isdying)
		{
			return;
		}
		if(isdefined(weapon) && weapon.rootweapon.name == "concussion_grenade" && isdefined(meansofdeath) && meansofdeath != "MOD_IMPACT")
		{
			function_770b4cfa(attacker, undefined, meansofdeath, damage, point, weapon);
		}
		attacker thread damagefeedback::update();
		self.lastattacker = attacker;
		self.fakehealth = self.fakehealth - damage;
		if(self.fakehealth <= 0)
		{
			self function_a40d8853();
			return;
		}
	}
	self.health = self.health + damage;
}

/*
	Name: function_8e6b5244
	Namespace: namespace_4c773ed3
	Checksum: 0x7CBA58A
	Offset: 0x4C18
	Size: 0x48
	Parameters: 0
	Flags: None
*/
function function_8e6b5244()
{
	self.var_86fdc107.alpha = 1;
	self.var_86fdc107 fadeovertime(3);
	self.var_86fdc107.alpha = 0;
}

/*
	Name: function_de01cce2
	Namespace: namespace_4c773ed3
	Checksum: 0x4CC87F24
	Offset: 0x4C68
	Size: 0x134
	Parameters: 0
	Flags: None
*/
function function_de01cce2()
{
	self.var_86fdc107 = hud::createfontstring("objective", 1);
	self.var_86fdc107.label = &"SCORE_DECOY_KILLED";
	self.var_86fdc107.x = 0;
	self.var_86fdc107.y = 20;
	self.var_86fdc107.alignx = "center";
	self.var_86fdc107.aligny = "middle";
	self.var_86fdc107.horzalign = "user_center";
	self.var_86fdc107.vertalign = "middle";
	self.var_86fdc107.archived = 1;
	self.var_86fdc107.fontscale = 1;
	self.var_86fdc107.alpha = 0;
	self.var_86fdc107.glowalpha = 0.5;
	self.var_86fdc107.hidewheninmenu = 0;
}

/*
	Name: function_7a923efa
	Namespace: namespace_4c773ed3
	Checksum: 0xF9C86014
	Offset: 0x4DA8
	Size: 0xA4
	Parameters: 2
	Flags: None
*/
function function_7a923efa(var_8847a584, attacker)
{
	if(isdefined(var_8847a584))
	{
		if(!isdefined(var_8847a584.var_86fdc107))
		{
			var_8847a584 function_de01cce2();
		}
		var_8847a584 function_8e6b5244();
	}
	if(isdefined(attacker))
	{
		if(!isdefined(attacker.var_86fdc107))
		{
			attacker function_de01cce2();
		}
		attacker function_8e6b5244();
	}
}

/*
	Name: function_a40d8853
	Namespace: namespace_4c773ed3
	Checksum: 0xF30A778
	Offset: 0x4E58
	Size: 0x174
	Parameters: 0
	Flags: None
*/
function function_a40d8853()
{
	if(level.phsettings.var_78280ce0)
	{
		thread function_7a923efa(self.playerowner, self.lastattacker);
		if(isdefined(self.playerowner))
		{
			self.playerowner propsetclonesleft(self.playerowner.clonesleft + 1);
		}
	}
	else if(isdefined(self.lastattacker))
	{
		scoreevents::processscoreevent("clone_destroyed", self.lastattacker);
		if(isdefined(self.playerowner))
		{
			scoreevents::processscoreevent("clone_was_destroyed", self.playerowner);
		}
	}
	if(!isdefined(self.isdying))
	{
		self.isdying = 1;
	}
	playsoundatposition("wpn_flash_grenade_explode", self.origin + vectorscale((0, 0, 1), 4));
	playfx(fx::get("propDeathFX"), self.origin + vectorscale((0, 0, 1), 4));
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: function_7244ebc6
	Namespace: namespace_4c773ed3
	Checksum: 0x14F6CE7E
	Offset: 0x4FD8
	Size: 0x30C
	Parameters: 3
	Flags: None
*/
function function_7244ebc6(var_ad5f9a75, fade_in_time, fade_out_time)
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	if(!isdefined(var_ad5f9a75))
	{
		var_ad5f9a75 = 5;
	}
	if(!isdefined(fade_in_time))
	{
		fade_in_time = 1;
	}
	if(!isdefined(fade_out_time))
	{
		fade_out_time = 1;
	}
	/#
		assert((fade_out_time + fade_in_time) < var_ad5f9a75);
	#/
	overlay = newclienthudelem(self);
	overlay.foreground = 0;
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader("black", 640, 480);
	overlay.alignx = "left";
	overlay.aligny = "top";
	overlay.horzalign = "fullscreen";
	overlay.vertalign = "fullscreen";
	overlay.alpha = 0;
	wait(0.05);
	if(fade_in_time > 0)
	{
		overlay fadeovertime(fade_in_time);
	}
	overlay.alpha = 1;
	self setclientuivisibilityflag("hud_visible", 0);
	self prop::function_da184fd(fade_in_time);
	self useservervisionset(1);
	self setvisionsetforplayer("blackout_ph", fade_in_time);
	self prop::function_da184fd((var_ad5f9a75 - fade_out_time) - fade_in_time);
	if(fade_out_time > 0)
	{
		overlay fadeovertime(fade_out_time);
	}
	overlay.alpha = 0;
	self useservervisionset(0);
	self setvisionsetforplayer("blackout_ph", fade_out_time);
	self prop::function_da184fd(fade_out_time);
	self setclientuivisibilityflag("hud_visible", 1);
	wait(0.05);
	safedestroy(overlay);
}

/*
	Name: watchspecialgrenadethrow
	Namespace: namespace_4c773ed3
	Checksum: 0xCCAB25F7
	Offset: 0x52F0
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function watchspecialgrenadethrow()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	self notify(#"watchspecialgrenadethrow");
	self endon(#"watchspecialgrenadethrow");
	while(true)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		self thread function_899a39ec(grenade);
		self.thrownspecialcount = self.thrownspecialcount + 1;
	}
}

/*
	Name: function_899a39ec
	Namespace: namespace_4c773ed3
	Checksum: 0x96E1A1A
	Offset: 0x5398
	Size: 0x108
	Parameters: 1
	Flags: None
*/
function function_899a39ec(grenade)
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	weapon = grenade.weapon;
	grenade waittill(#"explode", damageorigin);
	if(!isdefined(level.var_56d3e86e))
	{
		level.var_56d3e86e = [];
	}
	index = function_913d23(damageorigin);
	if(!isdefined(index))
	{
		index = function_141daf3d(self, damageorigin, weapon, 1, "MOD_GRENADE_SPLASH");
	}
	wait(0.05);
	wait(0.05);
	self function_af4e8351(index);
	wait(0.05);
	level.var_56d3e86e[index] = undefined;
}

/*
	Name: function_141daf3d
	Namespace: namespace_4c773ed3
	Checksum: 0x3DA62B3E
	Offset: 0x54A8
	Size: 0x10C
	Parameters: 5
	Flags: None
*/
function function_141daf3d(attacker, damageorigin, weapon, damage, meansofdeath)
{
	index = level.var_56d3e86e.size;
	level.var_56d3e86e[index] = spawnstruct();
	level.var_56d3e86e[index].players = [];
	level.var_56d3e86e[index].attacker = self;
	level.var_56d3e86e[index].damageorigin = damageorigin;
	level.var_56d3e86e[index].damage = damage;
	level.var_56d3e86e[index].meansofdeath = meansofdeath;
	level.var_56d3e86e[index].weapon = weapon;
	return index;
}

/*
	Name: function_770b4cfa
	Namespace: namespace_4c773ed3
	Checksum: 0x5C5988A6
	Offset: 0x55C0
	Size: 0xFE
	Parameters: 6
	Flags: None
*/
function function_770b4cfa(attacker, var_bf500123, meansofdeath, damage, damageorigin, weapon)
{
	if(!isdefined(level.var_56d3e86e))
	{
		level.var_56d3e86e = [];
	}
	index = function_913d23(damageorigin);
	if(!isdefined(index))
	{
		index = function_141daf3d(attacker, damageorigin, weapon, damage, meansofdeath);
	}
	if(isdefined(var_bf500123))
	{
		playerindex = level.var_56d3e86e[index].players.size;
		level.var_56d3e86e[index].players[playerindex] = var_bf500123;
	}
}

/*
	Name: function_913d23
	Namespace: namespace_4c773ed3
	Checksum: 0x7823D6F3
	Offset: 0x56C8
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function function_913d23(damageorigin)
{
	if(!isdefined(level.var_56d3e86e))
	{
		return;
	}
	foreach(index, event in level.var_56d3e86e)
	{
		if(event.damageorigin == damageorigin)
		{
			return index;
		}
	}
}

/*
	Name: function_af4e8351
	Namespace: namespace_4c773ed3
	Checksum: 0xC47AF14A
	Offset: 0x5778
	Size: 0x31E
	Parameters: 1
	Flags: None
*/
function function_af4e8351(index)
{
	if(!isdefined(level.var_56d3e86e) || !isdefined(level.var_56d3e86e[index].attacker))
	{
		return;
	}
	weapon = level.var_56d3e86e[index].weapon;
	damageorigin = level.var_56d3e86e[index].damageorigin;
	var_cb673c8c = weapon.explosionradius;
	var_6a573904 = var_cb673c8c * var_cb673c8c;
	foreach(player in level.players)
	{
		if(!player util::isprop() || !isalive(player) || player function_fde936b5(index))
		{
			continue;
		}
		distsq = distancesquared(damageorigin, player.origin);
		if(distsq <= var_6a573904)
		{
			function_73052bdb(0);
			function_564fbbef(0);
			function_b7d2b256(1);
			function_56938929(0);
			damage = level.var_56d3e86e[index].damage;
			attacker = level.var_56d3e86e[index].attacker;
			meansofdeath = level.var_56d3e86e[index].meansofdeath;
			attacker radiusdamage(damageorigin, var_cb673c8c, damage, damage, attacker, meansofdeath, weapon);
			function_73052bdb(1);
			function_564fbbef(1);
			function_b7d2b256(0);
			function_56938929(1);
			break;
		}
	}
}

/*
	Name: function_73052bdb
	Namespace: namespace_4c773ed3
	Checksum: 0x1A5663D3
	Offset: 0x5AA0
	Size: 0x19A
	Parameters: 1
	Flags: None
*/
function function_73052bdb(var_d18ea86a)
{
	foreach(player in level.players)
	{
		if(isdefined(player.prop))
		{
			if(var_d18ea86a)
			{
				if(isdefined(player.prop.var_42c57e68))
				{
					player.prop setcontents(player.prop.var_42c57e68);
				}
				player.prop solid();
				continue;
			}
			if(!isdefined(player.prop.var_42c57e68))
			{
				player.prop.var_42c57e68 = player.prop setcontents(0);
			}
			else
			{
				player.prop setcontents(0);
			}
			player.prop notsolid();
		}
	}
}

/*
	Name: function_564fbbef
	Namespace: namespace_4c773ed3
	Checksum: 0x931210E6
	Offset: 0x5C48
	Size: 0x1D8
	Parameters: 1
	Flags: None
*/
function function_564fbbef(var_d18ea86a)
{
	foreach(player in level.players)
	{
		if(isdefined(player.propclones))
		{
			foreach(clone in player.propclones)
			{
				if(isdefined(clone))
				{
					if(var_d18ea86a)
					{
						if(isdefined(clone.var_edad31da))
						{
							clone setcontents(clone.var_edad31da);
						}
						clone solid();
						continue;
					}
					if(!isdefined(clone.var_edad31da))
					{
						clone.var_edad31da = clone setcontents(0);
					}
					else
					{
						clone setcontents(0);
					}
					clone notsolid();
				}
			}
		}
	}
}

/*
	Name: function_b7d2b256
	Namespace: namespace_4c773ed3
	Checksum: 0x69F510
	Offset: 0x5E28
	Size: 0x132
	Parameters: 1
	Flags: None
*/
function function_b7d2b256(var_d18ea86a)
{
	foreach(player in level.players)
	{
		if(!player util::isprop() || !isalive(player))
		{
			continue;
		}
		if(var_d18ea86a)
		{
			player setcontents(level.phsettings.var_8f9d0c7c);
			player solid();
			continue;
		}
		player setcontents(0);
		player notsolid();
	}
}

/*
	Name: function_56938929
	Namespace: namespace_4c773ed3
	Checksum: 0x6AB0BC25
	Offset: 0x5F68
	Size: 0x132
	Parameters: 1
	Flags: None
*/
function function_56938929(var_d18ea86a)
{
	foreach(player in level.players)
	{
		if(!player prop::function_e4b2f23() || !isalive(player))
		{
			continue;
		}
		if(var_d18ea86a)
		{
			player setcontents(level.phsettings.var_8f9d0c7c);
			player solid();
			continue;
		}
		player setcontents(0);
		player notsolid();
	}
}

/*
	Name: function_94e1618c
	Namespace: namespace_4c773ed3
	Checksum: 0x21210D8F
	Offset: 0x60A8
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function function_94e1618c(damageorigin)
{
	index = function_913d23(damageorigin);
	if(isdefined(index))
	{
		return self function_fde936b5(index);
	}
	return 0;
}

/*
	Name: function_fde936b5
	Namespace: namespace_4c773ed3
	Checksum: 0xCD6CF48B
	Offset: 0x6108
	Size: 0xAA
	Parameters: 1
	Flags: None
*/
function function_fde936b5(index)
{
	foreach(var_f07e80d9 in level.var_56d3e86e[index].players)
	{
		if(isdefined(var_f07e80d9) && var_f07e80d9 == self)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: safesetalpha
	Namespace: namespace_4c773ed3
	Checksum: 0x7408BDE4
	Offset: 0x61C0
	Size: 0x30
	Parameters: 2
	Flags: None
*/
function safesetalpha(hudelem, var_9a1ea53a)
{
	if(isdefined(hudelem))
	{
		hudelem.alpha = var_9a1ea53a;
	}
}

/*
	Name: propabilitykeysvisible
	Namespace: namespace_4c773ed3
	Checksum: 0x5BCB9CBA
	Offset: 0x61F8
	Size: 0x194
	Parameters: 2
	Flags: None
*/
function propabilitykeysvisible(visible, override)
{
	if(isdefined(visible) && visible)
	{
		var_4d23023a = 1;
	}
	else
	{
		var_4d23023a = 0;
	}
	if(prop::useprophudserver() || (isdefined(override) && override))
	{
		safesetalpha(self.changepropkey, var_4d23023a);
		safesetalpha(self.spinpropkey, var_4d23023a);
		safesetalpha(self.lockpropkey, var_4d23023a);
		safesetalpha(self.matchslopekey, var_4d23023a);
		safesetalpha(self.abilitykey, var_4d23023a);
		safesetalpha(self.clonekey, var_4d23023a);
		safesetalpha(self.zoomkey, var_4d23023a);
		safesetalpha(self.var_6f16621b, var_4d23023a);
		if(!(isdefined(level.nopropsspectate) && level.nopropsspectate))
		{
			safesetalpha(self.spectatekey, var_4d23023a);
		}
	}
}

/*
	Name: function_8b7be7e3
	Namespace: namespace_4c773ed3
	Checksum: 0x253A6D32
	Offset: 0x6398
	Size: 0xD8
	Parameters: 0
	Flags: None
*/
function function_8b7be7e3()
{
	if(!isdefined(self.var_4a35819e))
	{
		self.var_4a35819e = 1;
	}
	else
	{
		self.var_4a35819e = !self.var_4a35819e;
	}
	if(self.var_4a35819e)
	{
		self.prop clientfield::set("retrievable", 1);
		if(prop::useprophudserver())
		{
			self.var_6f16621b.label = &"MP_PH_SHOWPROP";
		}
	}
	else
	{
		self.prop clientfield::set("retrievable", 0);
		if(prop::useprophudserver())
		{
			self.var_6f16621b.label = &"MP_PH_HIDEPROP";
		}
	}
}

/*
	Name: function_bf45ce54
	Namespace: namespace_4c773ed3
	Checksum: 0x6D93B601
	Offset: 0x6478
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function function_bf45ce54()
{
	/#
		assert(!isdefined(self.var_b47d9b7e));
	#/
	if(self issplitscreen())
	{
		self.currenthudy = -50;
	}
	else
	{
		self.currenthudy = -100;
	}
	self.var_b47d9b7e = addupperrighthudelem(&"MP_PH_PING");
}

/*
	Name: function_227409a5
	Namespace: namespace_4c773ed3
	Checksum: 0xE71C7110
	Offset: 0x6500
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function function_227409a5()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self waittill(#"death");
	self thread function_b4c19c50();
	self thread function_7fd4f3ae();
}

/*
	Name: function_7fd4f3ae
	Namespace: namespace_4c773ed3
	Checksum: 0x52AECDFA
	Offset: 0x6560
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function function_7fd4f3ae()
{
	safedestroy(self.var_b47d9b7e);
}

/*
	Name: function_b6740059
	Namespace: namespace_4c773ed3
	Checksum: 0x8F8510F9
	Offset: 0x6588
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_b6740059()
{
	if(isai(self))
	{
		return;
	}
	self notifyonplayercommand("ping", "+smoke");
}

/*
	Name: function_b4c19c50
	Namespace: namespace_4c773ed3
	Checksum: 0xD435B370
	Offset: 0x65D8
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_b4c19c50()
{
	if(isai(self))
	{
		return;
	}
	self notifyonplayercommandremove("ping", "+smoke");
}

/*
	Name: function_5951cacf
	Namespace: namespace_4c773ed3
	Checksum: 0xE2DAD99B
	Offset: 0x6628
	Size: 0x2E
	Parameters: 0
	Flags: None
*/
function function_5951cacf()
{
	/#
		if(isdefined(self.var_74ca9cd1) && self.var_74ca9cd1)
		{
			return 1;
		}
	#/
	return self.var_292246d3 > 0;
}

/*
	Name: function_2c53f5e6
	Namespace: namespace_4c773ed3
	Checksum: 0x3FDFAC9
	Offset: 0x6660
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_2c53f5e6()
{
	/#
		if(isdefined(self.var_74ca9cd1) && self.var_74ca9cd1)
		{
			return;
		}
	#/
	function_afeda2bf(self.var_292246d3 - 1);
}

/*
	Name: function_afeda2bf
	Namespace: namespace_4c773ed3
	Checksum: 0xFE48798A
	Offset: 0x66B0
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function function_afeda2bf(newvalue)
{
	self.var_292246d3 = newvalue;
	if(prop::useprophudserver())
	{
		self.var_b47d9b7e setvalue(self.var_292246d3);
		if(self.var_292246d3 <= 0)
		{
			self.var_b47d9b7e.alpha = 0.5;
		}
	}
}

/*
	Name: function_1abcc66
	Namespace: namespace_4c773ed3
	Checksum: 0x44BC984
	Offset: 0x6730
	Size: 0xC0
	Parameters: 0
	Flags: None
*/
function function_1abcc66()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	if(isai(self))
	{
		return;
	}
	prop::function_45c842e9();
	while(true)
	{
		msg = self util::waittill_any_return("ping");
		if(!isdefined(msg))
		{
			continue;
		}
		if(msg == "ping")
		{
			self function_38543493();
		}
	}
}

/*
	Name: function_38543493
	Namespace: namespace_4c773ed3
	Checksum: 0xF20F30F2
	Offset: 0x67F8
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function function_38543493()
{
	if(!level flag::get("props_hide_over"))
	{
		return;
	}
	if(isdefined(self.var_ad7b9a66) && self.var_ad7b9a66)
	{
		return;
	}
	if(self function_5951cacf())
	{
		self thread function_aac4667c();
		self function_2c53f5e6();
	}
}

/*
	Name: function_aac4667c
	Namespace: namespace_4c773ed3
	Checksum: 0xBEE6A8E1
	Offset: 0x6888
	Size: 0x2CA
	Parameters: 0
	Flags: None
*/
function function_aac4667c()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"death");
	self.var_ad7b9a66 = 1;
	if(prop::useprophudserver())
	{
		self.var_b47d9b7e.alpha = 0.5;
	}
	var_6f71e4e9 = gameobjects::get_next_obj_id();
	objective_add(var_6f71e4e9, "active");
	objective_team(var_6f71e4e9, game["attackers"]);
	objective_position(var_6f71e4e9, self.origin);
	objective_icon(var_6f71e4e9, "t7_hud_waypoints_safeguard_location");
	objective_setcolor(var_6f71e4e9, &"FriendlyBlue");
	objective_onentity(var_6f71e4e9, self);
	self thread function_41584b4b(var_6f71e4e9);
	self clientfield::set("pingHighlight", 1);
	foreach(player in level.players)
	{
		if(isalive(player) && player.team == self.team)
		{
			player playlocalsound("evt_hacker_raise");
		}
	}
	hostmigration::waitlongdurationwithhostmigrationpause(4);
	self clientfield::set("pingHighlight", 0);
	gameobjects::release_obj_id(var_6f71e4e9);
	if(prop::useprophudserver() && isdefined(self.var_b47d9b7e))
	{
		self.var_b47d9b7e.alpha = 1;
	}
	self.var_ad7b9a66 = 0;
	self notify(#"hash_9c5a8370");
}

/*
	Name: function_41584b4b
	Namespace: namespace_4c773ed3
	Checksum: 0x87991EE3
	Offset: 0x6B60
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function function_41584b4b(var_6f71e4e9)
{
	level endon(#"game_ended");
	self endon(#"hash_9c5a8370");
	self util::waittill_either("disconnect", "death");
	gameobjects::release_obj_id(var_6f71e4e9);
}

