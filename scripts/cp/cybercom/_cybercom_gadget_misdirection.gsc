// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace cybercom_gadget_misdirection;

/*
	Name: init
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x7F7E2015
	Offset: 0x5B0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("toplayer", "misdirection_enable", 1, 1, "int");
	clientfield::register("scriptmover", "makedecoy", 1, 1, "int");
}

/*
	Name: main
	Namespace: cybercom_gadget_misdirection
	Checksum: 0xB587B2A
	Offset: 0x620
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(2, 32, 1);
	level.cybercom.misdirection = spawnstruct();
	level.cybercom.misdirection._is_flickering = &_is_flickering;
	level.cybercom.misdirection._on_flicker = &_on_flicker;
	level.cybercom.misdirection._on_give = &_on_give;
	level.cybercom.misdirection._on_take = &_on_take;
	level.cybercom.misdirection._on_connect = &_on_connect;
	level.cybercom.misdirection._on = &_on;
	level.cybercom.misdirection._off = &_off;
	level.cybercom.misdirection._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x6324FF93
	Offset: 0x7B0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x93687036
	Offset: 0x7C8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x3DA85D42
	Offset: 0x7E8
	Size: 0x194
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.misdirection_lifetime = getdvarfloat("scr_misdirection_lifetime", 4);
	self.cybercom.var_c0a69197 = getdvarint("scr_misdirection_target_count", 3);
	self.cybercom.var_e5260c29 = getdvarfloat("scr_misdirection_fov", 0.968);
	if(self hascybercomability("cybercom_misdirection") == 2)
	{
		self.cybercom.misdirection_lifetime = getdvarfloat("scr_misdirection_upgraded_lifetime", 5.5);
		self.cybercom.var_c0a69197 = getdvarint("scr_misdirection_target_count_upgraded", 5);
		self.cybercom.var_e5260c29 = getdvarfloat("scr_misdirection_upgraded_fov", 0.94);
	}
	clientfield::set_to_player("misdirection_enable", 1);
	self thread cybercom::function_b5f4e597(weapon);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x3AE22221
	Offset: 0x988
	Size: 0x40
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
	clientfield::set_to_player("misdirection_enable", 0);
	self.cybercom.is_primed = 0;
}

/*
	Name: _on_connect
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x99EC1590
	Offset: 0x9D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_misdirection
	Checksum: 0xD4E032BC
	Offset: 0x9E0
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	result = self _activate_misdirection(slot, weapon);
	if(!result)
	{
		self gadgetdeactivate(slot, weapon, 2);
	}
	cybercom::function_adc40f11(weapon, result);
	self.cybercom.is_primed = 0;
	if(isplayer(self))
	{
		itemindex = getitemindexfromref("cybercom_misdirection");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: _off
	Namespace: cybercom_gadget_misdirection
	Checksum: 0xB67E7E71
	Offset: 0xB00
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
	self.cybercom.is_primed = 0;
}

/*
	Name: _is_primed
	Namespace: cybercom_gadget_misdirection
	Checksum: 0xA456AF9A
	Offset: 0xB30
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function _is_primed(slot, weapon)
{
	if(!(isdefined(self.cybercom.is_primed) && self.cybercom.is_primed))
	{
		self.cybercom.is_primed = 1;
	}
}

/*
	Name: _get_valid_targets
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x3EF02424
	Offset: 0xB88
	Size: 0x33E
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	playerforward = anglestoforward(self getplayerangles());
	enemies = arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
	enemies = arraysort(enemies, self.origin, 1);
	valid = [];
	foreach(guy in enemies)
	{
		if(isvehicle(guy))
		{
			continue;
		}
		if(!isactor(guy))
		{
			continue;
		}
		if(!isdefined(guy.archetype) || guy.archetype == "direwolf" || guy.archetype == "zombie")
		{
			continue;
		}
		distsq = distancesquared(self.origin, guy.origin);
		if(distsq < (getdvarint("scr_misdirection_min_distanceSQR", getdvarint("scr_misdirection_min_distance", 200) * getdvarint("scr_misdirection_min_distance", 200))))
		{
			continue;
		}
		if(distsq > (getdvarint("scr_misdirection_max_distanceSQR", getdvarint("scr_misdirection_max_distance", 1750) * getdvarint("scr_misdirection_max_distance", 1750))))
		{
			continue;
		}
		dot = vectordot(playerforward, vectornormalize(guy.origin - self.origin));
		if(dot < self.cybercom.var_e5260c29)
		{
			continue;
		}
		valid[valid.size] = guy;
		self thread challenges::function_96ed590f("cybercom_uses_chaos");
	}
	return valid;
}

/*
	Name: _activate_misdirection
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x9F743A02
	Offset: 0xED0
	Size: 0x186
	Parameters: 2
	Flags: Linked, Private
*/
function private _activate_misdirection(slot, weapon)
{
	targets = _get_valid_targets(weapon);
	self.cybercom.var_1beb8e5f = [];
	for(i = 0; i < self.cybercom.var_c0a69197; i++)
	{
		decoy = self function_4adc7dc8(targets);
		if(isdefined(decoy))
		{
			self.cybercom.var_1beb8e5f[self.cybercom.var_1beb8e5f.size] = decoy;
			util::wait_network_frame();
		}
	}
	foreach(decoy in self.cybercom.var_1beb8e5f)
	{
		decoy thread function_7ca046a9(self.cybercom.misdirection_lifetime, self);
	}
	return true;
}

/*
	Name: function_7074260
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x81231AD7
	Offset: 0x1060
	Size: 0x116
	Parameters: 1
	Flags: Linked
*/
function function_7074260(point)
{
	foreach(var_d3c532e6 in self.cybercom.var_1beb8e5f)
	{
		distsq = distance2dsquared(point, var_d3c532e6.origin);
		if(distsq < (getdvarint("scr_misdirection_decoy_spacingSQR", getdvarint("scr_misdirection_decoy_spacing", 90) * getdvarint("scr_misdirection_decoy_spacing", 90))))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_10cd71b
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x4A6A2932
	Offset: 0x1180
	Size: 0x6B8
	Parameters: 2
	Flags: Linked
*/
function function_10cd71b(decoy, &potentialtargets)
{
	mins = vectorscale((1, 1, 1), 1000000);
	maxs = vectorscale((-1, -1, -1), 1000000);
	playerforward = anglestoforward(self getplayerangles());
	playerforward = (playerforward[0], playerforward[1], 0);
	var_81ca05ac = anglestoright(self getplayerangles());
	var_81ca05ac = (var_81ca05ac[0], var_81ca05ac[1], 0);
	foreach(target in potentialtargets)
	{
		origin = target.origin;
		mins = function_44a2ae85(origin, mins);
		maxs = function_b72ba417(origin, maxs);
	}
	rangemax = self.origin + (playerforward * getdvarint("scr_misdirection_no_target_max_distance", 675));
	maxs = function_b72ba417(rangemax, maxs);
	rangemin = self.origin + (playerforward * getdvarint("scr_misdirection_min_distance", 200));
	mins = function_44a2ae85(rangemin, mins);
	center = (maxs + mins) * 0.5;
	var_412aa3ee = distance(center, self.origin);
	var_eec44088 = vectornormalize(center - self.origin);
	var_b333c85b = self.origin + (var_eec44088 * var_412aa3ee);
	var_6a0945f2 = var_b333c85b;
	maxtries = 6;
	var_539aaa1a = 0;
	step = var_81ca05ac * getdvarint("scr_misdirection_decoy_spacing", 90);
	while(maxtries > 0)
	{
		left = var_6a0945f2 + ((6 - maxtries) * step);
		v_ground = bullettrace(left + vectorscale((0, 0, 1), 72), left + (vectorscale((0, 0, -1), 2048)), 0, undefined, 1)["position"];
		left = (left[0], left[1], v_ground[2]);
		v_trace = bullettrace(self.origin + vectorscale((0, 0, 1), 24), left + vectorscale((0, 0, 1), 24), 1, self)["position"];
		dir = vectornormalize(v_trace - self.origin);
		v_trace = v_trace + -48 * dir;
		v_ground = bullettrace(v_trace, v_trace + (vectorscale((0, 0, -1), 2048)), 0, undefined, 1)["position"];
		if(self function_7074260(v_ground))
		{
			var_b333c85b = v_ground;
			break;
		}
		right = var_6a0945f2 - ((6 - maxtries) * step);
		v_ground = bullettrace(right + vectorscale((0, 0, 1), 72), right + (vectorscale((0, 0, -1), 2048)), 0, undefined, 1)["position"];
		right = (right[0], right[1], v_ground[2]);
		v_trace = bullettrace(self.origin + vectorscale((0, 0, 1), 24), right + vectorscale((0, 0, 1), 24), 1, self)["position"];
		dir = vectornormalize(v_trace - self.origin);
		v_trace = v_trace + -48 * dir;
		v_ground = bullettrace(v_trace, v_trace + (vectorscale((0, 0, -1), 2048)), 0, undefined, 1)["position"];
		if(self function_7074260(v_ground))
		{
			var_b333c85b = v_ground;
			break;
		}
		maxtries--;
	}
	decoy.origin = var_b333c85b + vectorscale((0, 0, 1), 64);
}

/*
	Name: initthreatbias
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x1E70FAEF
	Offset: 0x1840
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function initthreatbias()
{
	aiarray = getaiarray();
	foreach(ai in aiarray)
	{
		if(ai === self)
		{
			continue;
		}
		if(ai.ignoredecoy === 1)
		{
			ai setpersonalignore(self);
		}
	}
}

/*
	Name: function_4adc7dc8
	Namespace: cybercom_gadget_misdirection
	Checksum: 0xCA2770FF
	Offset: 0x1920
	Size: 0x388
	Parameters: 1
	Flags: Linked
*/
function function_4adc7dc8(&potentialtargets)
{
	decoy = spawn("script_model", self.origin);
	if(!isdefined(decoy))
	{
		return undefined;
	}
	decoy.angles = self.angles;
	decoy setmodel("tag_origin");
	decoy makesentient();
	decoy.team = self.team;
	decoy.var_e42818a3 = 1;
	decoy ghost();
	decoy initthreatbias();
	foreach(target in potentialtargets)
	{
		v_trace = bullettrace(self.origin + vectorscale((0, 0, 1), 24), target.origin + vectorscale((0, 0, 1), 24), 1, self)["position"];
		dir = vectornormalize(v_trace - self.origin);
		v_trace = v_trace + -48 * dir;
		v_ground = bullettrace(v_trace, v_trace + (vectorscale((0, 0, -1), 2048)), 0, target, 1)["position"];
		if(self function_7074260(v_ground) == 0)
		{
			continue;
		}
		decoy.origin = v_ground + vectorscale((0, 0, 1), 64);
		decoy.var_faa77c1d = target;
		break;
	}
	if(!isdefined(decoy.var_faa77c1d))
	{
		self function_10cd71b(decoy, potentialtargets);
	}
	decoy notsolid();
	decoy.notsolid = 1;
	decoy notify(#"end_nudge_collision");
	decoy.ignoreall = 1;
	decoy.takedamage = 0;
	decoy.health = 10000;
	decoy.goalradius = 36;
	decoy.goalheight = 36;
	decoy.good_melee_target = 1;
	return decoy;
}

/*
	Name: function_7ca046a9
	Namespace: cybercom_gadget_misdirection
	Checksum: 0xCCE458D8
	Offset: 0x1CB0
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function function_7ca046a9(lifetime, player)
{
	self notify(#"hash_7ca046a9");
	self endon(#"hash_7ca046a9");
	self show();
	self clientfield::set("makedecoy", 1);
	waittime = lifetime + randomfloatrange(1, 3);
	if(getdvarint("scr_misdirection_debug", 0))
	{
		level thread cybercom_dev::function_a0e51d80(self.origin, waittime, 20, (1, 0, 0));
	}
	wait(waittime);
	self clientfield::set("makedecoy", 0);
	util::wait_network_frame();
	self delete();
}

/*
	Name: function_44a2ae85
	Namespace: cybercom_gadget_misdirection
	Checksum: 0xCB981DFC
	Offset: 0x1DE0
	Size: 0xCE
	Parameters: 2
	Flags: Linked
*/
function function_44a2ae85(vec, mins)
{
	if(vec[0] < mins[0])
	{
		mins = (vec[0], mins[1], mins[2]);
	}
	if(vec[1] < mins[1])
	{
		mins = (mins[0], vec[1], mins[2]);
	}
	if(vec[2] < mins[2])
	{
		mins = (mins[0], mins[1], vec[2]);
	}
	return mins;
}

/*
	Name: function_b72ba417
	Namespace: cybercom_gadget_misdirection
	Checksum: 0x49ACDF7B
	Offset: 0x1EB8
	Size: 0xCE
	Parameters: 2
	Flags: Linked
*/
function function_b72ba417(vec, maxs)
{
	if(vec[0] > maxs[0])
	{
		maxs = (vec[0], maxs[1], maxs[2]);
	}
	if(vec[1] > maxs[1])
	{
		maxs = (maxs[0], vec[1], maxs[2]);
	}
	if(vec[2] > maxs[2])
	{
		maxs = (maxs[0], maxs[1], vec[2]);
	}
	return maxs;
}

