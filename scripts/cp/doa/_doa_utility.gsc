// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\util_shared;

#namespace doa_utility;

/*
	Name: function_4e9a23a9
	Namespace: doa_utility
	Checksum: 0x140994E2
	Offset: 0x368
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_4e9a23a9(array)
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
	Name: isheadshot
	Namespace: doa_utility
	Checksum: 0xF077F613
	Offset: 0x410
	Size: 0x68
	Parameters: 3
	Flags: None
*/
function isheadshot(sweapon, shitloc, smeansofdeath)
{
	return shitloc == "head" || shitloc == "helmet" && smeansofdeath != "MOD_MELEE" && smeansofdeath != "MOD_BAYONET" && smeansofdeath != "MOD_IMPACT";
}

/*
	Name: isexplosivedamage
	Namespace: doa_utility
	Checksum: 0x83B99469
	Offset: 0x480
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function isexplosivedamage(damage_mod)
{
	if(damage_mod == "MOD_GRENADE" || damage_mod == "MOD_GRENADE_SPLASH" || damage_mod == "MOD_PROJECTILE" || damage_mod == "MOD_PROJECTILE_SPLASH" || damage_mod == "MOD_EXPLOSIVE")
	{
		return true;
	}
	return false;
}

/*
	Name: function_767f35f5
	Namespace: doa_utility
	Checksum: 0x48B3A0A6
	Offset: 0x4F0
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function function_767f35f5(mod)
{
	return isdefined(self.damageweapon) && self.damageweapon == "zombietron_tesla_gun" && (mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH");
}

/*
	Name: stringtofloat
	Namespace: doa_utility
	Checksum: 0xAFF35B26
	Offset: 0x540
	Size: 0x130
	Parameters: 1
	Flags: None
*/
function stringtofloat(string)
{
	floatparts = strtok(string, ".");
	if(floatparts.size == 1)
	{
		return int(floatparts[0]);
	}
	whole = int(floatparts[0]);
	decimal = 0;
	for(i = floatparts[1].size - 1; i >= 0; i--)
	{
		decimal = (decimal / 10) + (int(floatparts[1][i]) / 10);
	}
	if(whole >= 0)
	{
		return whole + decimal;
	}
	return whole - decimal;
}

/*
	Name: function_124b9a08
	Namespace: doa_utility
	Checksum: 0xA60B1B24
	Offset: 0x680
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_124b9a08()
{
	while(true)
	{
		if(level flag::get("doa_round_active"))
		{
			return;
		}
		wait(0.05);
	}
}

/*
	Name: function_c8f4d63a
	Namespace: doa_utility
	Checksum: 0x824F4DA6
	Offset: 0x6C8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_c8f4d63a()
{
	while(level flag::get("doa_bonusroom_active"))
	{
		wait(0.05);
	}
}

/*
	Name: function_d0e32ad0
	Namespace: doa_utility
	Checksum: 0x6A2A90B0
	Offset: 0x708
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_d0e32ad0(state)
{
	if(state == 1)
	{
		while(!level flag::get("doa_screen_faded_out"))
		{
			wait(0.05);
		}
	}
	else if(state == 0)
	{
		while(level flag::get("doa_screen_faded_out"))
		{
			wait(0.05);
		}
	}
}

/*
	Name: function_44eb090b
	Namespace: doa_utility
	Checksum: 0xA7CE7A22
	Offset: 0x798
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_44eb090b(time)
{
	function_a5821e05(time);
}

/*
	Name: function_390adefe
	Namespace: doa_utility
	Checksum: 0xD75152AD
	Offset: 0x7C8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_390adefe(unfreeze = 1)
{
	function_c85960dd(1.2, unfreeze);
}

/*
	Name: function_a5821e05
	Namespace: doa_utility
	Checksum: 0x2FD19A70
	Offset: 0x810
	Size: 0x1BC
	Parameters: 1
	Flags: Linked
*/
function function_a5821e05(time = 1)
{
	if(isdefined(level.var_a7749866))
	{
		/#
			debugmsg("");
		#/
		return;
	}
	level.var_a7749866 = gettime();
	/#
		debugmsg("" + level.var_a7749866);
	#/
	level thread function_1d62c13a();
	foreach(player in getplayers())
	{
		player freezecontrols(1);
		player thread namespace_831a4a7c::function_4519b17(1);
	}
	level lui::screen_fade_out(time, "black");
	wait(time);
	/#
		debugmsg("" + gettime());
	#/
	level notify(#"fade_out_complete");
	level flag::set("doa_screen_faded_out");
}

/*
	Name: function_c85960dd
	Namespace: doa_utility
	Checksum: 0xD48C5AB5
	Offset: 0x9D8
	Size: 0x214
	Parameters: 2
	Flags: Linked
*/
function function_c85960dd(hold_black_time = 1.2, unfreeze = 1)
{
	/#
		debugmsg("");
	#/
	wait(hold_black_time);
	foreach(player in getplayers())
	{
		player notify(#"hash_ff28e404");
	}
	level lui::screen_fade_in(1.5);
	if(unfreeze)
	{
		foreach(player in getplayers())
		{
			player freezecontrols(0);
			player thread namespace_831a4a7c::function_4519b17(0);
		}
	}
	level notify(#"fade_in_complete");
	/#
		debugmsg("");
	#/
	level flag::clear("doa_screen_faded_out");
	level.var_a7749866 = undefined;
	level lui::screen_close_menu();
}

/*
	Name: function_1d62c13a
	Namespace: doa_utility
	Checksum: 0xD0DE82F1
	Offset: 0xBF8
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_1d62c13a()
{
	level endon(#"fade_in_complete");
	while(isdefined(level.var_a7749866))
	{
		if(level flag::get("doa_game_is_over"))
		{
			return;
		}
		if(level flag::get("doa_round_spawning"))
		{
			break;
		}
		wait(0.05);
	}
	/#
		debugmsg("");
	#/
	level thread function_c85960dd();
}

/*
	Name: function_d0c69425
	Namespace: doa_utility
	Checksum: 0x5D0EECFE
	Offset: 0xCA8
	Size: 0xB4
	Parameters: 1
	Flags: None
*/
function function_d0c69425(var_30d383f5)
{
	level endon(#"fade_in_complete");
	while(!(isdefined(level.var_de693c3) && level.var_de693c3))
	{
		wait(0.05);
	}
	timeout = gettime() + (var_30d383f5 * 1000);
	while(isdefined(level.var_a7749866) && gettime() < timeout)
	{
		wait(0.05);
	}
	/#
		debugmsg("");
	#/
	level thread function_c85960dd();
}

/*
	Name: getclosestto
	Namespace: doa_utility
	Checksum: 0x58C024B5
	Offset: 0xD68
	Size: 0x82
	Parameters: 3
	Flags: Linked
*/
function getclosestto(origin, &entarray, maxdist = 2048)
{
	if(!isdefined(entarray))
	{
		return;
	}
	if(entarray.size == 0)
	{
		return;
	}
	if(entarray.size == 1)
	{
		return entarray[0];
	}
	return arraygetclosest(origin, entarray, maxdist);
}

/*
	Name: getarrayitemswithin
	Namespace: doa_utility
	Checksum: 0x94BF13BD
	Offset: 0xDF8
	Size: 0xDC
	Parameters: 3
	Flags: Linked
*/
function getarrayitemswithin(origin, &entarray, minsq)
{
	items = [];
	if(isdefined(entarray) && entarray.size)
	{
		for(i = 0; i < entarray.size; i++)
		{
			if(!isdefined(entarray[i]))
			{
				continue;
			}
			distsq = distancesquared(entarray[i].origin, origin);
			if(distsq < minsq)
			{
				items[items.size] = entarray[i];
			}
		}
	}
	return items;
}

/*
	Name: getclosesttome
	Namespace: doa_utility
	Checksum: 0x31224F8B
	Offset: 0xEE0
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function getclosesttome(&entarray)
{
	return getclosestto(self.origin, entarray);
}

/*
	Name: function_999bba85
	Namespace: doa_utility
	Checksum: 0xD0EF0B58
	Offset: 0xF18
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function function_999bba85(origin, time)
{
	self moveto(origin, time, 0, 0);
	wait(time);
	if(isdefined(self.trigger))
	{
		self.trigger delete();
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: notify_timeout
	Namespace: doa_utility
	Checksum: 0x775443C7
	Offset: 0xFA8
	Size: 0x2E
	Parameters: 2
	Flags: Linked
*/
function notify_timeout(note, timeout)
{
	self endon(#"death");
	wait(timeout);
	self notify(note);
}

/*
	Name: clamp
	Namespace: doa_utility
	Checksum: 0x4E571FB5
	Offset: 0xFE0
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function clamp(val, min, max)
{
	if(isdefined(min))
	{
		if(val < min)
		{
			val = min;
		}
	}
	if(isdefined(max))
	{
		if(val > max)
		{
			val = max;
		}
	}
	return val;
}

/*
	Name: function_75e76155
	Namespace: doa_utility
	Checksum: 0xFAD5ABE3
	Offset: 0x1050
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function function_75e76155(other, note)
{
	if(!isdefined(other))
	{
		return;
	}
	killnote = function_2ccf4b82("DeleteNote");
	self thread function_f5db70f1(other, killnote);
	if(isplayer(other))
	{
		if(note == "disconnect")
		{
			other util::waittill_any(note, killnote);
		}
		else
		{
			other util::waittill_any(note, "disconnect", killnote);
		}
	}
	else
	{
		other util::waittill_any(note, killnote);
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: function_f5db70f1
	Namespace: doa_utility
	Checksum: 0x66E6E345
	Offset: 0x1170
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function function_f5db70f1(other, note)
{
	self endon(note);
	other endon(#"death");
	self waittill(#"death");
	if(isdefined(other))
	{
		other notify(note);
	}
}

/*
	Name: function_24245456
	Namespace: doa_utility
	Checksum: 0xD70422A9
	Offset: 0x11C8
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function function_24245456(other, note)
{
	if(!isdefined(other))
	{
		return;
	}
	self endon(#"death");
	killnote = function_2ccf4b82("killNote");
	self thread function_f5db70f1(other, killnote);
	if(isplayer(other))
	{
		if(note == "disconnect")
		{
			other util::waittill_any(note, killnote);
		}
		else
		{
			other util::waittill_any(note, "disconnect", killnote);
		}
	}
	else
	{
		other util::waittill_any(note, killnote);
	}
	if(isdefined(self))
	{
		self notify(killnote);
		self.aioverridedamage = undefined;
		self.takedamage = 1;
		self.allowdeath = 1;
		self thread function_ba30b321(0);
	}
}

/*
	Name: notifymeinnsec
	Namespace: doa_utility
	Checksum: 0x208B5EC6
	Offset: 0x1318
	Size: 0x56
	Parameters: 5
	Flags: Linked
*/
function notifymeinnsec(note, sec, endnote, param1, param2)
{
	self endon(endnote);
	self endon(#"disconnect");
	wait(sec);
	self notify(note, param1, param2);
}

/*
	Name: function_783519c1
	Namespace: doa_utility
	Checksum: 0xD44DA52
	Offset: 0x1378
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function function_783519c1(note, var_8b804bd9 = 0)
{
	self endon(#"death");
	self endon("abort" + note);
	if(!var_8b804bd9)
	{
		self waittill(note);
	}
	else
	{
		level waittill(note);
	}
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self delete();
}

/*
	Name: function_1bd67aef
	Namespace: doa_utility
	Checksum: 0xC2CF097E
	Offset: 0x1428
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_1bd67aef(time)
{
	self endon(#"death");
	wait(time);
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self delete();
}

/*
	Name: function_981c685d
	Namespace: doa_utility
	Checksum: 0x36476B4A
	Offset: 0x1490
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_981c685d(var_627e7613)
{
	self endon(#"death");
	killnote = function_2ccf4b82("deathNote");
	self thread function_f5db70f1(var_627e7613, killnote);
	if(isplayer(var_627e7613))
	{
		var_627e7613 util::waittill_any("death", "disconnect", killnote);
	}
	else
	{
		var_627e7613 util::waittill_any("death", killnote);
	}
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self delete();
}

/*
	Name: function_a625b5d3
	Namespace: doa_utility
	Checksum: 0xE9945F5E
	Offset: 0x1598
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_a625b5d3(player)
{
	/#
		assert(isplayer(player), "");
	#/
	self endon(#"death");
	player waittill(#"disconnect");
	self delete();
}

/*
	Name: function_c157030a
	Namespace: doa_utility
	Checksum: 0x1B84B512
	Offset: 0x1618
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_c157030a()
{
	while(function_b99d78c7() > 0)
	{
		wait(1);
	}
}

/*
	Name: function_1ced251e
	Namespace: doa_utility
	Checksum: 0x73C364DE
	Offset: 0x1648
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function function_1ced251e(all = 0)
{
	while(function_b99d78c7() > 0)
	{
		killallenemy(all);
		wait(1);
	}
}

/*
	Name: function_2f0d697f
	Namespace: doa_utility
	Checksum: 0x1A870CDD
	Offset: 0x16B0
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_2f0d697f(spawner)
{
	count = 0;
	ai = function_fb2ad2fb();
	foreach(guy in ai)
	{
		if(isdefined(guy.spawner) && guy.spawner == spawner)
		{
			count++;
		}
	}
	return count;
}

/*
	Name: function_b99d78c7
	Namespace: doa_utility
	Checksum: 0x52B9A55
	Offset: 0x1798
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function function_b99d78c7()
{
	prospects = arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
	return prospects.size;
}

/*
	Name: function_fb2ad2fb
	Namespace: doa_utility
	Checksum: 0x386A796
	Offset: 0x1800
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function function_fb2ad2fb()
{
	return arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
}

/*
	Name: function_fe180f6f
	Namespace: doa_utility
	Checksum: 0x9CFAC255
	Offset: 0x1858
	Size: 0x19A
	Parameters: 1
	Flags: Linked
*/
function function_fe180f6f(count = 1)
{
	var_54a85fb0 = 4;
	var_76cfbf10 = 0;
	enemies = function_fb2ad2fb();
	foreach(guy in enemies)
	{
		if(count <= 0)
		{
			return;
		}
		if(!isdefined(guy))
		{
			continue;
		}
		if(isdefined(guy.boss) && guy.boss)
		{
			continue;
		}
		if(!(isdefined(guy.spawner.var_8d1af144) && guy.spawner.var_8d1af144))
		{
			continue;
		}
		guy thread function_ba30b321(0);
		var_76cfbf10++;
		count--;
		if(var_76cfbf10 == var_54a85fb0)
		{
			util::wait_network_frame();
			var_76cfbf10 = 0;
		}
	}
}

/*
	Name: killallenemy
	Namespace: doa_utility
	Checksum: 0x15838382
	Offset: 0x1A00
	Size: 0x18A
	Parameters: 1
	Flags: Linked
*/
function killallenemy(all = 0)
{
	var_54a85fb0 = 4;
	var_76cfbf10 = 0;
	enemies = function_fb2ad2fb();
	foreach(guy in enemies)
	{
		if(!isdefined(guy))
		{
			continue;
		}
		if(!all && (isdefined(guy.boss) && guy.boss))
		{
			continue;
		}
		guy.aioverridedamage = undefined;
		guy.takedamage = 1;
		guy.allowdeath = 1;
		guy thread function_ba30b321(0);
		var_76cfbf10++;
		if(var_76cfbf10 == var_54a85fb0)
		{
			util::wait_network_frame();
			var_76cfbf10 = 0;
		}
	}
}

/*
	Name: function_e3c30240
	Namespace: doa_utility
	Checksum: 0x10A103CB
	Offset: 0x1B98
	Size: 0x104
	Parameters: 4
	Flags: Linked
*/
function function_e3c30240(dir, var_e3e1b987 = 100, var_1f32eac0 = 0.1, attacker)
{
	if(!isdefined(self))
	{
		return;
	}
	self thread function_ba30b321(var_1f32eac0, attacker);
	if(isdefined(self.no_ragdoll) && self.no_ragdoll)
	{
		return;
	}
	self endon(#"death");
	self setplayercollision(0);
	self startragdoll();
	if(isdefined(dir))
	{
		dir = vectornormalize(dir);
		self launchragdoll(dir * var_e3e1b987);
	}
}

/*
	Name: function_ba30b321
	Namespace: doa_utility
	Checksum: 0xE14D6D0C
	Offset: 0x1CA8
	Size: 0x134
	Parameters: 3
	Flags: Linked
*/
function function_ba30b321(time, attacker, mod = "MOD_HIT_BY_OBJECT")
{
	/#
		assert(!isplayer(self));
	#/
	if(isdefined(self.boss) && self.boss)
	{
		return;
	}
	self endon(#"death");
	if(time > 0)
	{
		wait(time);
	}
	self.takedamage = 1;
	self.allowdeath = 1;
	if(isdefined(attacker))
	{
		self dodamage(self.health + 187, self.origin, attacker, attacker, "none", mod, 0, getweapon("none"));
	}
	else
	{
		self dodamage(self.health + 187, self.origin);
	}
}

/*
	Name: function_308fa126
	Namespace: doa_utility
	Checksum: 0x1F763B37
	Offset: 0x1DE8
	Size: 0x2BA
	Parameters: 1
	Flags: Linked
*/
function function_308fa126(num = 5)
{
	locs = [];
	players = getplayers();
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_1d2ed40))
	{
		foreach(spot in level.doa.arenas[level.doa.current_arena].var_1d2ed40)
		{
			locs[locs.size] = spot.origin;
			num--;
			if(num == 0)
			{
				return locs;
			}
		}
	}
	if(isdefined(level.doa.var_3361a074))
	{
		foreach(spot in level.doa.var_3361a074)
		{
			locs[locs.size] = spot.origin;
			num--;
			if(num == 0)
			{
				return locs;
			}
		}
	}
	foreach(player in players)
	{
		if(isdefined(player.vehicle))
		{
			continue;
		}
		locs[locs.size] = player.origin;
		num--;
		if(num == 0)
		{
			return locs;
		}
	}
	return locs;
}

/*
	Name: function_8fc4387a
	Namespace: doa_utility
	Checksum: 0x4424964F
	Offset: 0x20B0
	Size: 0x1D2
	Parameters: 1
	Flags: Linked
*/
function function_8fc4387a(num = 5)
{
	locs = [];
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_1d2ed40))
	{
		foreach(spot in level.doa.arenas[level.doa.current_arena].var_1d2ed40)
		{
			locs[locs.size] = spot;
			num--;
			if(num == 0)
			{
				return locs;
			}
		}
	}
	if(isdefined(level.doa.var_3361a074))
	{
		foreach(spot in level.doa.var_3361a074)
		{
			locs[locs.size] = spot;
			num--;
			if(num == 0)
			{
				return locs;
			}
		}
	}
	return locs;
}

/*
	Name: function_812b4715
	Namespace: doa_utility
	Checksum: 0xAF27915B
	Offset: 0x2290
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function function_812b4715(side)
{
	switch(side)
	{
		case "top":
		{
			return "bottom";
			break;
		}
		case "bottom":
		{
			return "top";
			break;
		}
		case "left":
		{
			return "right";
			break;
		}
		case "right":
		{
			return "left";
			break;
		}
	}
	/#
		assert(0);
	#/
}

/*
	Name: function_5b4fbaef
	Namespace: doa_utility
	Checksum: 0x46514E56
	Offset: 0x2320
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function function_5b4fbaef()
{
	/#
		if(getdvarint("", 0))
		{
			return "";
		}
	#/
	switch(randomint(4))
	{
		case 0:
		{
			return "bottom";
			break;
		}
		case 1:
		{
			return "top";
			break;
		}
		case 2:
		{
			return "right";
			break;
		}
		case 3:
		{
			return "left";
			break;
		}
	}
}

/*
	Name: getyawtoenemy
	Namespace: doa_utility
	Checksum: 0xD715A5B1
	Offset: 0x23D0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function getyawtoenemy()
{
	pos = undefined;
	if(isdefined(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = anglestoforward(self.angles);
		forward = vectorscale(forward, 150);
		pos = self.origin + forward;
	}
	yaw = self.angles[1] - getyaw(pos);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getyaw
	Namespace: doa_utility
	Checksum: 0xEB94EBAF
	Offset: 0x24B0
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function getyaw(org)
{
	angles = vectortoangles(org - self.origin);
	return angles[1];
}

/*
	Name: function_cf5857a3
	Namespace: doa_utility
	Checksum: 0x4796CE05
	Offset: 0x2500
	Size: 0x54
	Parameters: 2
	Flags: None
*/
function function_cf5857a3(ent, note)
{
	if(note != "death")
	{
		ent endon(#"death");
	}
	ent waittill(note);
	ent unlink();
}

/*
	Name: function_a98c85b2
	Namespace: doa_utility
	Checksum: 0xFC8FD807
	Offset: 0x2560
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function function_a98c85b2(location, timesec = 1)
{
	self notify(#"hash_a98c85b2");
	self endon(#"hash_a98c85b2");
	if(timesec <= 0)
	{
		timesec = 1;
	}
	increment = (self.origin - location) / (timesec * 20);
	var_afc5c189 = gettime() + (timesec * 1000);
	while(gettime() < var_afc5c189)
	{
		self.origin = self.origin - increment;
		wait(0.05);
	}
	self notify(#"movedone");
}

/*
	Name: function_89a258a7
	Namespace: doa_utility
	Checksum: 0x353D5C43
	Offset: 0x2640
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_89a258a7()
{
	self endon(#"death");
	self endon(#"hash_3d81b494");
	while(true)
	{
		wait(0.5);
		if(isdefined(self.var_111c7bbb))
		{
			distsq = distancesquared(self.var_111c7bbb, self.origin);
			if(distsq < (32 * 32))
			{
				continue;
			}
		}
		var_111c7bbb = getclosestpointonnavmesh(self.origin, 64, 16);
		if(isdefined(var_111c7bbb))
		{
			self.var_111c7bbb = var_111c7bbb;
		}
	}
}

/*
	Name: function_5fd5c3ea
	Namespace: doa_utility
	Checksum: 0x6E0E7992
	Offset: 0x2718
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function function_5fd5c3ea(entity)
{
	entity thread function_89a258a7();
	level.doa.var_f953d785[level.doa.var_f953d785.size] = entity;
}

/*
	Name: function_3d81b494
	Namespace: doa_utility
	Checksum: 0x721B9527
	Offset: 0x2770
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_3d81b494(entity)
{
	arrayremovevalue(level.doa.var_f953d785, entity);
}

/*
	Name: getclosestpoi
	Namespace: doa_utility
	Checksum: 0x42797DA0
	Offset: 0x27B0
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function getclosestpoi(origin, radiussq)
{
	return getclosestto(origin, level.doa.var_f953d785, radiussq);
}

/*
	Name: clearallcorpses
	Namespace: doa_utility
	Checksum: 0x7C15CFA0
	Offset: 0x27F8
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function clearallcorpses(num = 99)
{
	corpse_array = getcorpsearray();
	if(num == 99)
	{
		total = corpse_array.size;
	}
	else
	{
		total = num;
	}
	for(i = 0; i < total; i++)
	{
		if(isdefined(corpse_array[i]))
		{
			corpse_array[i] delete();
		}
	}
}

/*
	Name: function_5f54cafa
	Namespace: doa_utility
	Checksum: 0x34D5DBFB
	Offset: 0x28C8
	Size: 0x4E
	Parameters: 1
	Flags: None
*/
function function_5f54cafa(waittime)
{
	level notify(#"hash_5f54cafa");
	level endon(#"hash_5f54cafa");
	while(true)
	{
		clearallcorpses();
		wait(waittime);
	}
}

/*
	Name: function_2ccf4b82
	Namespace: doa_utility
	Checksum: 0x8B429B9F
	Offset: 0x2920
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_2ccf4b82(note)
{
	if(!isdefined(level.doa.var_24cbf490))
	{
		level.doa.var_24cbf490 = 0;
	}
	level.doa.var_24cbf490++;
	return note + level.doa.var_24cbf490;
}

/*
	Name: function_c5f3ece8
	Namespace: doa_utility
	Checksum: 0xCD42B0D3
	Offset: 0x2980
	Size: 0x1F6
	Parameters: 5
	Flags: Linked
*/
function function_c5f3ece8(text, param, holdtime = 5, color = vectorscale((1, 1, 0), 0.9), note = "title1Fade")
{
	self notify(#"hash_c5f3ece8");
	self endon(#"hash_c5f3ece8");
	level.doa.title1.color = color;
	level.doa.title1.alpha = 0;
	if(isdefined(param))
	{
		level.doa.title1 settext(text, param);
	}
	else
	{
		level.doa.title1 settext(text);
	}
	level.doa.title1 fadeovertime(1);
	level.doa.title1.alpha = 1;
	if(holdtime == -1)
	{
		level waittill(note);
	}
	else
	{
		level util::waittill_any_timeout(holdtime, note);
	}
	level.doa.title1 fadeovertime(1);
	level.doa.title1.alpha = 0;
	level notify(#"hash_b96c96ac");
}

/*
	Name: function_37fb5c23
	Namespace: doa_utility
	Checksum: 0x2E26646E
	Offset: 0x2B80
	Size: 0x1CE
	Parameters: 5
	Flags: Linked
*/
function function_37fb5c23(text, param, holdtime = 5, color = (1, 1, 0), note = "title2Fade")
{
	self notify(#"hash_37fb5c23");
	self endon(#"hash_37fb5c23");
	level.doa.title2.color = color;
	level.doa.title2.alpha = 0;
	if(isdefined(param))
	{
		level.doa.title2 settext(text, param);
	}
	else
	{
		level.doa.title2 settext(text);
	}
	level.doa.title2 fadeovertime(1);
	level.doa.title2.alpha = 1;
	level util::waittill_any_timeout(holdtime, note);
	level.doa.title2 fadeovertime(1);
	level.doa.title2.alpha = 0;
	level notify(#"hash_97276c43");
}

/*
	Name: function_13fbad22
	Namespace: doa_utility
	Checksum: 0x34D2A491
	Offset: 0x2D58
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_13fbad22()
{
	if(isdefined(world.var_c642e28c))
	{
		for(i = 0; i < world.var_c642e28c; i++)
		{
			function_11f3f381(i, 1);
			util::wait_network_frame();
		}
	}
	world.var_c642e28c = 0;
}

/*
	Name: function_c9fb43e9
	Namespace: doa_utility
	Checksum: 0x708D965B
	Offset: 0x2DE0
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function function_c9fb43e9(text, position)
{
	index = world.var_c642e28c;
	world.var_c642e28c++;
	luinotifyevent(&"doa_bubble", 6, -1, index, text, int(position[0]), int(position[1]), int(position[2]));
	return index;
}

/*
	Name: function_11f3f381
	Namespace: doa_utility
	Checksum: 0x7EBC171E
	Offset: 0x2E98
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_11f3f381(index, fadetime)
{
	luinotifyevent(&"doa_bubble", 2, (isdefined(fadetime) ? fadetime : 0), index);
}

/*
	Name: function_dbcf48a0
	Namespace: doa_utility
	Checksum: 0x444FF08
	Offset: 0x2EF0
	Size: 0x21C
	Parameters: 3
	Flags: Linked
*/
function function_dbcf48a0(delay = 0, width = 40, height = 40)
{
	if(delay)
	{
		wait(delay);
	}
	if(!isdefined(self))
	{
		return;
	}
	trigger = spawn("trigger_radius", self.origin, 1, width, height);
	trigger.targetname = "touchmeTrigger";
	trigger enablelinkto();
	trigger linkto(self);
	trigger thread function_981c685d(self);
	trigger endon(#"death");
	while(isdefined(self))
	{
		trigger waittill(#"trigger", guy);
		if(isdefined(guy))
		{
			if(isdefined(guy.untouchable) && guy.untouchable)
			{
				continue;
			}
			if(isdefined(guy.boss) && guy.boss)
			{
				continue;
			}
			if(isdefined(guy.doa) && isdefined(guy.doa.vehicle))
			{
				continue;
			}
			guy dodamage(guy.health + 1, guy.origin);
		}
	}
	if(isdefined(trigger))
	{
		trigger delete();
	}
}

/*
	Name: function_1ded48e6
	Namespace: doa_utility
	Checksum: 0xE5796A6
	Offset: 0x3118
	Size: 0xB6
	Parameters: 2
	Flags: Linked
*/
function function_1ded48e6(time, var_f88fd757)
{
	if(!isdefined(self))
	{
		return 0;
	}
	if(isdefined(var_f88fd757))
	{
		return time * var_f88fd757;
	}
	if(self.doa.fate == 2)
	{
		time = time * level.doa.rules.var_f2d5f54d;
	}
	else if(self.doa.fate == 11)
	{
		time = time * level.doa.rules.var_b3d39edc;
	}
	return time;
}

/*
	Name: function_a4d1f25e
	Namespace: doa_utility
	Checksum: 0xD6B1F83
	Offset: 0x31D8
	Size: 0x2E
	Parameters: 2
	Flags: Linked
*/
function function_a4d1f25e(note, time)
{
	self endon(#"death");
	wait(time);
	self notify(note);
}

/*
	Name: function_1c0abd70
	Namespace: doa_utility
	Checksum: 0xAA9A5F21
	Offset: 0x3210
	Size: 0x9C
	Parameters: 3
	Flags: Linked
*/
function function_1c0abd70(var_8e25979b, var_5e50267c, ignore)
{
	start = var_8e25979b + (0, 0, var_5e50267c);
	end = var_8e25979b - vectorscale((0, 0, 1), 1024);
	a_trace = groundtrace(start, end, 0, ignore, 1);
	return a_trace["position"];
}

/*
	Name: addoffsetontopoint
	Namespace: doa_utility
	Checksum: 0x67787D55
	Offset: 0x32B8
	Size: 0x4A
	Parameters: 3
	Flags: None
*/
function addoffsetontopoint(point, angles, offset)
{
	offset_world = rotatepoint(offset, angles);
	return point + offset_world;
}

/*
	Name: getyawtospot
	Namespace: doa_utility
	Checksum: 0x3FDD65A
	Offset: 0x3310
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function getyawtospot(spot)
{
	yaw = self.angles[1] - getyaw(spot);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: function_fa8a86e8
	Namespace: doa_utility
	Checksum: 0x5639E5FC
	Offset: 0x3378
	Size: 0xD0
	Parameters: 2
	Flags: Linked
*/
function function_fa8a86e8(ent, target)
{
	v_diff = target.origin - ent.origin;
	x = v_diff[0];
	y = v_diff[1];
	if(x != 0)
	{
		n_slope = y / x;
		yaw = atan(n_slope);
		if(x < 0)
		{
			yaw = yaw + 180;
		}
	}
	return yaw;
}

/*
	Name: debug_circle
	Namespace: doa_utility
	Checksum: 0xECB3DC32
	Offset: 0x3450
	Size: 0xA4
	Parameters: 4
	Flags: Linked
*/
function debug_circle(origin, radius, seconds, color)
{
	/#
		if(!isdefined(seconds))
		{
			seconds = 1;
		}
		if(!isdefined(color))
		{
			color = (1, 0, 0);
		}
		frames = int(20 * seconds);
		circle(origin, radius, color, 0, 1, frames);
	#/
}

/*
	Name: debug_line
	Namespace: doa_utility
	Checksum: 0x8055CF29
	Offset: 0x3500
	Size: 0x64
	Parameters: 4
	Flags: Linked
*/
function debug_line(p1, p2, seconds, color)
{
	/#
		line(p1, p2, color, 1, 0, int(seconds * 20));
	#/
}

/*
	Name: function_a0e51d80
	Namespace: doa_utility
	Checksum: 0x99BA6664
	Offset: 0x3570
	Size: 0x1D0
	Parameters: 4
	Flags: None
*/
function function_a0e51d80(point, timesec, size, color)
{
	/#
		self endon(#"hash_b67acf30");
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
			line(l1, l2, color, 1, 0, 1);
			line(var_5e2b69e1, var_842de44a, color, 1, 0, 1);
			line(h1, h2, color, 1, 0, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: debugorigin
	Namespace: doa_utility
	Checksum: 0xCC098ED1
	Offset: 0x3748
	Size: 0x1D8
	Parameters: 3
	Flags: Linked
*/
function debugorigin(timesec, size, color)
{
	/#
		self endon(#"hash_c32e3b78");
		end = gettime() + (timesec * 1000);
		halfwidth = int(size / 2);
		while(end > gettime())
		{
			point = self.origin;
			l1 = point + (halfwidth * -1, 0, 0);
			l2 = point + (halfwidth, 0, 0);
			var_5e2b69e1 = point + (0, halfwidth * -1, 0);
			var_842de44a = point + (0, halfwidth, 0);
			h1 = point + (0, 0, halfwidth * -1);
			h2 = point + (0, 0, halfwidth);
			line(l1, l2, color, 1, 0, 1);
			line(var_5e2b69e1, var_842de44a, color, 1, 0, 1);
			line(h1, h2, color, 1, 0, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: debugmsg
	Namespace: doa_utility
	Checksum: 0x6255F834
	Offset: 0x3928
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
	Name: set_lighting_state
	Namespace: doa_utility
	Checksum: 0x74E1A408
	Offset: 0x3968
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function set_lighting_state(state)
{
	level.lighting_state = state;
	setlightingstate(state);
}

/*
	Name: function_5233dbc0
	Namespace: doa_utility
	Checksum: 0xBD82AD46
	Offset: 0x39A0
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_5233dbc0()
{
	foreach(player in getplayers())
	{
		if(isdefined(player.doa) && isdefined(player.doa.vehicle))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_5bca1086
	Namespace: doa_utility
	Checksum: 0x7DC42ECC
	Offset: 0x3A60
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_5bca1086()
{
	if(!isdefined(self))
	{
		return namespace_3ca3c537::function_61d60e0b();
	}
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_1d2ed40) && level.doa.arenas[level.doa.current_arena].var_1d2ed40.size)
	{
		spot = getclosestto(self.origin, level.doa.arenas[level.doa.current_arena].var_1d2ed40);
		if(!isdefined(spot))
		{
			spot = self.origin;
		}
		else
		{
			spot = spot.origin;
		}
	}
	else
	{
		spot = self.origin;
	}
	return spot;
}

/*
	Name: function_14a10231
	Namespace: doa_utility
	Checksum: 0x315AB981
	Offset: 0x3B80
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function function_14a10231(origin)
{
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_1d2ed40) && level.doa.arenas[level.doa.current_arena].var_1d2ed40.size)
	{
		spot = level.doa.arenas[level.doa.current_arena].var_1d2ed40[randomint(level.doa.arenas[level.doa.current_arena].var_1d2ed40.size)].origin;
	}
	else
	{
		spot = origin;
	}
	return spot;
}

/*
	Name: function_ada6d90
	Namespace: doa_utility
	Checksum: 0x4DA92468
	Offset: 0x3C90
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_ada6d90()
{
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_1d2ed40) && level.doa.arenas[level.doa.current_arena].var_1d2ed40.size)
	{
		return level.doa.arenas[level.doa.current_arena].var_1d2ed40[randomint(level.doa.arenas[level.doa.current_arena].var_1d2ed40.size)];
	}
}

