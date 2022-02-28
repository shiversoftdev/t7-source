// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_weapons;

#namespace zm_utility;

/*
	Name: ignore_triggers
	Namespace: zm_utility
	Checksum: 0xB6AE7601
	Offset: 0x120
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function ignore_triggers(timer)
{
	self endon(#"death");
	self.ignoretriggers = 1;
	if(isdefined(timer))
	{
		wait(timer);
	}
	else
	{
		wait(0.5);
	}
	self.ignoretriggers = 0;
}

/*
	Name: is_encounter
	Namespace: zm_utility
	Checksum: 0x11D2E351
	Offset: 0x178
	Size: 0x6
	Parameters: 0
	Flags: None
*/
function is_encounter()
{
	return false;
}

/*
	Name: round_up_to_ten
	Namespace: zm_utility
	Checksum: 0xB233F14B
	Offset: 0x188
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function round_up_to_ten(score)
{
	new_score = score - (score % 10);
	if(new_score < score)
	{
		new_score = new_score + 10;
	}
	return new_score;
}

/*
	Name: round_up_score
	Namespace: zm_utility
	Checksum: 0x2EEA486C
	Offset: 0x1E0
	Size: 0x70
	Parameters: 2
	Flags: Linked
*/
function round_up_score(score, value)
{
	score = int(score);
	new_score = score - (score % value);
	if(new_score < score)
	{
		new_score = new_score + value;
	}
	return new_score;
}

/*
	Name: halve_score
	Namespace: zm_utility
	Checksum: 0xDD0D5FAF
	Offset: 0x258
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function halve_score(n_score)
{
	n_score = n_score / 2;
	n_score = round_up_score(n_score, 10);
	return n_score;
}

/*
	Name: spawn_weapon_model
	Namespace: zm_utility
	Checksum: 0x12F62812
	Offset: 0x2A0
	Size: 0xF0
	Parameters: 6
	Flags: None
*/
function spawn_weapon_model(localclientnum, weapon, model = weapon.worldmodel, origin, angles, options)
{
	weapon_model = spawn(localclientnum, origin, "script_model");
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	if(isdefined(options))
	{
		weapon_model useweaponmodel(weapon, model, options);
	}
	else
	{
		weapon_model useweaponmodel(weapon, model);
	}
	return weapon_model;
}

/*
	Name: spawn_buildkit_weapon_model
	Namespace: zm_utility
	Checksum: 0x8B1BDCA1
	Offset: 0x398
	Size: 0xB0
	Parameters: 5
	Flags: Linked
*/
function spawn_buildkit_weapon_model(localclientnum, weapon, camo, origin, angles)
{
	weapon_model = spawn(localclientnum, origin, "script_model");
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	weapon_model usebuildkitweaponmodel(localclientnum, weapon, camo, zm_weapons::is_weapon_upgraded(weapon));
	return weapon_model;
}

/*
	Name: is_classic
	Namespace: zm_utility
	Checksum: 0xEE3FAA58
	Offset: 0x450
	Size: 0x8
	Parameters: 0
	Flags: None
*/
function is_classic()
{
	return true;
}

/*
	Name: is_gametype_active
	Namespace: zm_utility
	Checksum: 0x24C4905C
	Offset: 0x460
	Size: 0xB2
	Parameters: 1
	Flags: None
*/
function is_gametype_active(a_gametypes)
{
	b_is_gametype_active = 0;
	if(!isarray(a_gametypes))
	{
		a_gametypes = array(a_gametypes);
	}
	for(i = 0; i < a_gametypes.size; i++)
	{
		if(getdvarstring("g_gametype") == a_gametypes[i])
		{
			b_is_gametype_active = 1;
		}
	}
	return b_is_gametype_active;
}

/*
	Name: setinventoryuimodels
	Namespace: zm_utility
	Checksum: 0x363E5E7B
	Offset: 0x520
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function setinventoryuimodels(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "zmInventory." + fieldname), newval);
}

/*
	Name: setsharedinventoryuimodels
	Namespace: zm_utility
	Checksum: 0x3437D677
	Offset: 0x5D0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function setsharedinventoryuimodels(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "zmInventory." + fieldname), newval);
}

/*
	Name: zm_ui_infotext
	Namespace: zm_utility
	Checksum: 0xA49F2BB2
	Offset: 0x660
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function zm_ui_infotext(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "zmInventory.infoText"), fieldname);
	}
	else
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "zmInventory.infoText"), "");
	}
}

/*
	Name: drawcylinder
	Namespace: zm_utility
	Checksum: 0x195D843
	Offset: 0x748
	Size: 0x2B6
	Parameters: 4
	Flags: Linked
*/
function drawcylinder(pos, rad, height, color)
{
	/#
		currad = rad;
		curheight = height;
		debugstar(pos, 1, color);
		for(r = 0; r < 20; r++)
		{
			theta = (r / 20) * 360;
			theta2 = ((r + 1) / 20) * 360;
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0), color, 1, 1, 100);
			line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight), color, 1, 1, 100);
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight), color, 1, 1, 100);
		}
	#/
}

/*
	Name: umbra_fix_logic
	Namespace: zm_utility
	Checksum: 0xBF9F9B53
	Offset: 0xA08
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function umbra_fix_logic(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	umbra_settometrigger(localclientnum, "");
	while(true)
	{
		in_fix_area = 0;
		if(isdefined(level.custom_umbra_hotfix))
		{
			in_fix_area = self thread [[level.custom_umbra_hotfix]](localclientnum);
		}
		if(in_fix_area == 0)
		{
			umbra_settometrigger(localclientnum, "");
		}
		wait(0.05);
	}
}

/*
	Name: umbra_fix_trigger
	Namespace: zm_utility
	Checksum: 0xCBF2EDAC
	Offset: 0xAC0
	Size: 0x12E
	Parameters: 5
	Flags: None
*/
function umbra_fix_trigger(localclientnum, pos, height, radius, umbra_name)
{
	bottomy = pos[2];
	topy = pos[2] + height;
	if(self.origin[2] > bottomy && self.origin[2] < topy)
	{
		if(distance2dsquared(self.origin, pos) < (radius * radius))
		{
			umbra_settometrigger(localclientnum, umbra_name);
			/#
				drawcylinder(pos, radius, height, (0, 1, 0));
			#/
			return true;
		}
	}
	/#
		drawcylinder(pos, radius, height, (1, 0, 0));
	#/
	return false;
}

