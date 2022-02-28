// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_accolades;
#using scripts\cp\_skipto;
#using scripts\cp\gametypes\_save;

#namespace decorations;

/*
	Name: function_25328f50
	Namespace: decorations
	Checksum: 0xBE24EBC8
	Offset: 0x238
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function function_25328f50(var_aeda862b)
{
	a_decorations = self getdecorations(1);
	foreach(decoration in a_decorations)
	{
		if(decoration.name == var_aeda862b)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_59f1fa79
	Namespace: decorations
	Checksum: 0xC88625D6
	Offset: 0x300
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function function_59f1fa79(map_name = getrootmapname())
{
	var_ebb087c2 = self savegame::get_player_data("accolades");
	if(isdefined(var_ebb087c2))
	{
		foreach(accolade in var_ebb087c2)
		{
			if(!(isdefined(accolade.is_completed) && accolade.is_completed))
			{
				return false;
			}
		}
		self setdstat("PlayerStatsByMap", map_name, "allAccoladesComplete", 1);
	}
}

/*
	Name: function_e72fc18
	Namespace: decorations
	Checksum: 0x22B99D7
	Offset: 0x430
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_e72fc18()
{
	var_c02de660 = skipto::function_23eda99c();
	foreach(mission in var_c02de660)
	{
		if(!(isdefined(self getdstat("PlayerStatsByMap", mission, "allAccoladesComplete")) && self getdstat("PlayerStatsByMap", mission, "allAccoladesComplete")))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_45ddfa6
	Namespace: decorations
	Checksum: 0xB2C3D069
	Offset: 0x530
	Size: 0x90
	Parameters: 0
	Flags: None
*/
function function_45ddfa6()
{
	for(itemindex = 100; itemindex < 141; itemindex++)
	{
		var_f62f7b55 = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, itemindex, 17);
		if(var_f62f7b55 == "")
		{
			continue;
		}
		if(!self isitempurchased(itemindex))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_59727018
	Namespace: decorations
	Checksum: 0x50CF07F1
	Offset: 0x5C8
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function function_59727018()
{
	return isdefined(self.var_d1b47d51) && self.var_d1b47d51 >= 35000;
}

/*
	Name: function_13cc355e
	Namespace: decorations
	Checksum: 0xE2A2060B
	Offset: 0x5F0
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function function_13cc355e()
{
	maxrank = tablelookup("gamedata/tables/cp/cp_rankTable.csv", 0, "maxrank", 1);
	var_4223990f = int(tablelookup("gamedata/tables/cp/cp_rankTable.csv", 0, maxrank, 2));
	return self getdstat("PlayerStatsList", "RANKXP", "statValue") >= var_4223990f;
}

/*
	Name: function_7006b9ad
	Namespace: decorations
	Checksum: 0x4AA8D7BD
	Offset: 0x6A0
	Size: 0xC0
	Parameters: 0
	Flags: None
*/
function function_7006b9ad()
{
	for(itemindex = 1; itemindex < 76; itemindex++)
	{
		var_8e9deedf = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, itemindex, 17);
		if(var_8e9deedf == "")
		{
			continue;
		}
		var_1976a117 = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, itemindex, 4);
		if(!self isitempurchased(itemindex))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_931263b1
	Namespace: decorations
	Checksum: 0x758A52D6
	Offset: 0x768
	Size: 0x120
	Parameters: 1
	Flags: Linked
*/
function function_931263b1(difficulty)
{
	foreach(mission in skipto::function_23eda99c())
	{
		var_a4b6fa1f = self getdstat("PlayerStatsByMap", mission, "highestStats", "HIGHEST_DIFFICULTY");
		if(var_a4b6fa1f < difficulty)
		{
			return false;
		}
		var_346332b8 = self getdstat("PlayerStatsByMap", mission, "checkpointUsed");
		if(isdefined(var_346332b8) && var_346332b8)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_2bc66a34
	Namespace: decorations
	Checksum: 0x13458D59
	Offset: 0x890
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_2bc66a34()
{
	kills = self getdstat("PlayerStatsList", "KILLS", "statValue");
	if(kills >= 2000)
	{
		self givedecoration("cp_medal_kill_enemies");
	}
}

/*
	Name: function_7b01cb74
	Namespace: decorations
	Checksum: 0x9417D87E
	Offset: 0x908
	Size: 0x21A
	Parameters: 0
	Flags: Linked
*/
function function_7b01cb74()
{
	for(itemindex = 1; itemindex < 60; itemindex++)
	{
		var_4d26d5ca = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, itemindex, 12);
		if(var_4d26d5ca == ("-1"))
		{
			continue;
		}
		var_1976a117 = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, itemindex, 4);
		var_f41ce74f = tablelookuprownum("gamedata/weapons/cp/cp_gunlevels.csv", 2, var_1976a117);
		if(var_f41ce74f == -1)
		{
			continue;
		}
		rankid = tablelookupcolumnforrow("gamedata/weapons/cp/cp_gunlevels.csv", var_f41ce74f, 0);
		var_f554224b = tablelookupcolumnforrow("gamedata/weapons/cp/cp_gunlevels.csv", var_f41ce74f, 2);
		var_3f3ab3c1 = var_f41ce74f;
		while(var_f554224b == var_1976a117)
		{
			rankid = tablelookupcolumnforrow("gamedata/weapons/cp/cp_gunlevels.csv", var_3f3ab3c1, 0);
			var_3f3ab3c1++;
			var_f554224b = tablelookupcolumnforrow("gamedata/weapons/cp/cp_gunlevels.csv", var_3f3ab3c1, 2);
		}
		var_b0863e9a = int(rankid);
		var_b47d78c4 = self getcurrentgunrank(itemindex);
		if(!isdefined(var_b47d78c4))
		{
			var_b47d78c4 = 0;
		}
		if(var_b47d78c4 < var_b0863e9a)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_6cd12a29
	Namespace: decorations
	Checksum: 0x3716A6F
	Offset: 0xB30
	Size: 0x1DE
	Parameters: 0
	Flags: Linked
*/
function function_6cd12a29()
{
	for(itemindex = 1; itemindex < 60; itemindex++)
	{
		var_4d26d5ca = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, itemindex, 12);
		if(var_4d26d5ca == ("-1"))
		{
			continue;
		}
		weapon_group = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, itemindex, 2);
		if(weapon_group == "")
		{
			continue;
		}
		var_1976a117 = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, itemindex, 4);
		if(var_1976a117 == "hero_annihilator" || var_1976a117 == "hero_pineapplegun")
		{
			continue;
		}
		var_c1b6a586 = tablelookuprownum("gamedata/stats/cp/statsmilestones3.csv", 3, weapon_group);
		if(var_c1b6a586 == -1)
		{
			continue;
		}
		var_ed54f9d7 = tablelookup("gamedata/stats/cp/statsmilestones3.csv", 3, weapon_group, 1, 3, 2);
		var_15879d61 = int(var_ed54f9d7);
		if(self getdstat("ItemStats", itemindex, "stats", "kills", "statValue") < var_15879d61)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_bea4ff57
	Namespace: decorations
	Checksum: 0x9EC2B837
	Offset: 0xD18
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_bea4ff57()
{
	if(!function_13cc355e())
	{
		return false;
	}
	if(!function_7b01cb74())
	{
		return false;
	}
	if(!function_6cd12a29())
	{
		return false;
	}
	return true;
}

