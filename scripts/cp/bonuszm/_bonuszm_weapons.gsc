// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\weapons\_weapons;

class class_a17e6f03 
{

	/*
		Name: constructor
		Namespace: namespace_a17e6f03
		Checksum: 0x99EC1590
		Offset: 0x198
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_a17e6f03
		Checksum: 0x99EC1590
		Offset: 0x1A8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

}

#namespace namespace_fdfaa57d;

/*
	Name: function_58d5283a
	Namespace: namespace_fdfaa57d
	Checksum: 0x30387A33
	Offset: 0x248
	Size: 0x154
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_58d5283a()
{
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	mapname = getdvarstring("mapname");
	level.var_acba406b = [];
	level.var_ed11f8b7 = [];
	level.var_5e3f3853 = 0;
	level.var_24893e7 = spawn("script_model", (0, 0, 0));
	level.var_24893e7 sethighdetail(1);
	level.var_24893e7 ghost();
	level.var_a432d965 = struct::get_script_bundle("bonuszmdata", mapname);
	var_6a173bd1 = getstructfield(level.var_a432d965, "weaponsTable");
	/#
		assert(isdefined(var_6a173bd1));
	#/
	function_549c28ac(("gamedata/tables/cpzm/") + var_6a173bd1);
}

/*
	Name: function_549c28ac
	Namespace: namespace_fdfaa57d
	Checksum: 0x9597F221
	Offset: 0x3A8
	Size: 0x24E
	Parameters: 1
	Flags: Linked
*/
function function_549c28ac(var_6a173bd1)
{
	noneweapon = getweapon("none");
	var_adeb478a = tablelookuprowcount(var_6a173bd1);
	for(i = 0; i < var_adeb478a; i++)
	{
		var_279890e8 = new class_a17e6f03();
		var_279890e8.weaponname = tablelookupcolumnforrow(var_6a173bd1, i, 0);
		var_279890e8.var_bc6ce097 = int(tablelookupcolumnforrow(var_6a173bd1, i, 1));
		var_279890e8.var_2b758e89 = int(tablelookupcolumnforrow(var_6a173bd1, i, 2));
		var_279890e8.var_83fbee4b = tablelookupcolumnforrow(var_6a173bd1, i, 3);
		if(!isdefined(var_279890e8.weaponname) || getweapon(var_279890e8.weaponname) == noneweapon)
		{
			continue;
		}
		if(var_279890e8.var_83fbee4b == "")
		{
			var_279890e8.var_83fbee4b = 0;
		}
		else
		{
			var_279890e8.var_83fbee4b = int(var_279890e8.var_83fbee4b);
		}
		if(var_279890e8.var_83fbee4b)
		{
			array::add(level.var_ed11f8b7, var_279890e8);
			continue;
		}
		array::add(level.var_acba406b, var_279890e8);
	}
}

/*
	Name: function_1e2e0936
	Namespace: namespace_fdfaa57d
	Checksum: 0x97A564D
	Offset: 0x600
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function function_1e2e0936(var_1010f96a = 0)
{
	if(isdefined(level.var_fd21e404))
	{
		weaponinfo = level.var_fd21e404;
	}
	level.var_fd21e404 = function_53200e4d(var_1010f96a);
	level.var_24893e7 useweaponmodel(level.var_fd21e404[0], level.var_fd21e404[0].worldmodel);
	level.var_24893e7 setweaponrenderoptions(level.var_fd21e404[2], 0, 0, 0, 0);
	if(isdefined(weaponinfo))
	{
		return weaponinfo;
	}
	return function_53200e4d(var_1010f96a);
}

/*
	Name: function_53200e4d
	Namespace: namespace_fdfaa57d
	Checksum: 0x93E48692
	Offset: 0x6F8
	Size: 0x890
	Parameters: 1
	Flags: Linked
*/
function function_53200e4d(var_1010f96a)
{
	/#
		assert(isdefined(level.var_acba406b));
	#/
	/#
		assert(isdefined(level.var_ed11f8b7));
	#/
	/#
		assert(isdefined(level.var_a9e78bf7[""]));
	#/
	var_82d771df = undefined;
	var_d9cb0358 = [];
	if(var_1010f96a && level.var_5e3f3853 < level.var_a9e78bf7["maxmagicboxonlyweapons"] && randomint(100) < level.var_a9e78bf7["magicboxonlyweaponchance"] && level.var_ed11f8b7.size)
	{
		level.var_5e3f3853++;
		var_279890e8 = array::random(level.var_ed11f8b7);
	}
	else
	{
		var_279890e8 = array::random(level.var_acba406b);
	}
	numattachments = 0;
	if(var_279890e8.var_bc6ce097 >= 0 && var_279890e8.var_2b758e89 > 0)
	{
		numattachments = randomintrange(var_279890e8.var_bc6ce097, var_279890e8.var_2b758e89);
	}
	if(numattachments > 0)
	{
		weapon = getweapon(var_279890e8.weaponname);
		var_d9cb0358 = getrandomcompatibleattachmentsforweapon(weapon, numattachments);
	}
	acvi = undefined;
	var_2106259a = 0;
	if(isdefined(var_d9cb0358) && isarray(var_d9cb0358) && var_d9cb0358.size)
	{
		var_82d771df = getweapon(var_279890e8.weaponname, var_d9cb0358);
		if(isdefined(var_82d771df))
		{
			var_2106259a = 1;
			switch(var_d9cb0358.size)
			{
				case 8:
				{
					acvi = getattachmentcosmeticvariantindexes(var_82d771df, var_d9cb0358[0], math::cointoss(), var_d9cb0358[1], math::cointoss(), var_d9cb0358[2], math::cointoss(), var_d9cb0358[3], math::cointoss(), var_d9cb0358[4], math::cointoss(), var_d9cb0358[5], math::cointoss(), var_d9cb0358[6], math::cointoss(), var_d9cb0358[7], math::cointoss());
					break;
				}
				case 7:
				{
					acvi = getattachmentcosmeticvariantindexes(var_82d771df, var_d9cb0358[0], math::cointoss(), var_d9cb0358[1], math::cointoss(), var_d9cb0358[2], math::cointoss(), var_d9cb0358[3], math::cointoss(), var_d9cb0358[4], math::cointoss(), var_d9cb0358[5], math::cointoss(), var_d9cb0358[6], math::cointoss());
					break;
				}
				case 6:
				{
					acvi = getattachmentcosmeticvariantindexes(var_82d771df, var_d9cb0358[0], math::cointoss(), var_d9cb0358[1], math::cointoss(), var_d9cb0358[2], math::cointoss(), var_d9cb0358[3], math::cointoss(), var_d9cb0358[4], math::cointoss(), var_d9cb0358[5], math::cointoss());
					break;
				}
				case 5:
				{
					acvi = getattachmentcosmeticvariantindexes(var_82d771df, var_d9cb0358[0], math::cointoss(), var_d9cb0358[1], math::cointoss(), var_d9cb0358[2], math::cointoss(), var_d9cb0358[3], math::cointoss(), var_d9cb0358[4], math::cointoss());
					break;
				}
				case 4:
				{
					acvi = getattachmentcosmeticvariantindexes(var_82d771df, var_d9cb0358[0], math::cointoss(), var_d9cb0358[1], math::cointoss(), var_d9cb0358[2], math::cointoss(), var_d9cb0358[3], math::cointoss());
					break;
				}
				case 3:
				{
					acvi = getattachmentcosmeticvariantindexes(var_82d771df, var_d9cb0358[0], math::cointoss(), var_d9cb0358[1], math::cointoss(), var_d9cb0358[2], math::cointoss());
					break;
				}
				case 2:
				{
					acvi = getattachmentcosmeticvariantindexes(var_82d771df, var_d9cb0358[0], math::cointoss(), var_d9cb0358[1], math::cointoss());
					break;
				}
				case 1:
				{
					acvi = getattachmentcosmeticvariantindexes(var_82d771df, var_d9cb0358[0], math::cointoss());
					break;
				}
			}
		}
	}
	if(!var_2106259a)
	{
		var_82d771df = getweapon(var_279890e8.weaponname);
	}
	weaponinfo = [];
	weaponinfo[0] = var_82d771df;
	weaponinfo[1] = acvi;
	if(randomint(100) < level.var_a9e78bf7["camochance"])
	{
		weaponinfo[2] = array::random(array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 18, 19, 20, 21, 22, 23, 24, 25));
	}
	else
	{
		weaponinfo[2] = 0;
	}
	/#
		assert(weaponinfo[0] != level.weaponnone);
	#/
	return weaponinfo;
}

/*
	Name: function_43128d49
	Namespace: namespace_fdfaa57d
	Checksum: 0xE01C7CC
	Offset: 0xF90
	Size: 0x48C
	Parameters: 2
	Flags: Linked
*/
function function_43128d49(weaponinfo, var_fe7b5ca3 = 1)
{
	/#
		assert(isdefined(weaponinfo));
	#/
	randomweapon = weaponinfo[0];
	var_d6c5d457 = weaponinfo[1];
	var_54a70e6e = weaponinfo[2];
	if(!isdefined(randomweapon))
	{
		return;
	}
	if(randomweapon == level.weaponnone)
	{
		return;
	}
	a_weaponlist = self getweaponslist();
	a_heroweapons = [];
	foreach(weapon in a_weaponlist)
	{
		if(isdefined(weapon.isheroweapon) && weapon.isheroweapon)
		{
			if(!isdefined(a_heroweapons))
			{
				a_heroweapons = [];
			}
			else if(!isarray(a_heroweapons))
			{
				a_heroweapons = array(a_heroweapons);
			}
			a_heroweapons[a_heroweapons.size] = weapon;
		}
	}
	var_4044e31f = self getweaponslistprimaries();
	foreach(weapon in var_4044e31f)
	{
		if(weapon.isheroweapon || !var_fe7b5ca3)
		{
			self takeweapon(weapon);
			continue;
		}
		self function_132d9eee(weapon);
	}
	var_a817a92d = self calcweaponoptions(var_54a70e6e, 0, 0, 0);
	if(isdefined(var_d6c5d457))
	{
		self giveweapon(randomweapon, var_a817a92d, var_d6c5d457);
	}
	else
	{
		self giveweapon(randomweapon, var_a817a92d);
	}
	if(self hasweapon(randomweapon))
	{
		self setweaponammoclip(randomweapon, randomweapon.clipsize);
		self givemaxammo(randomweapon);
	}
	foreach(weapon in a_heroweapons)
	{
		self giveweapon(weapon);
		self setweaponammoclip(weapon, weapon.clipsize);
		self givemaxammo(weapon);
	}
	if(self hasweapon(randomweapon))
	{
		self switchtoweapon(randomweapon);
	}
	else if(var_4044e31f.size)
	{
		self switchtoweapon(var_4044e31f[0]);
	}
}

/*
	Name: function_7e774306
	Namespace: namespace_fdfaa57d
	Checksum: 0xA9502087
	Offset: 0x1428
	Size: 0x156
	Parameters: 0
	Flags: None
*/
function function_7e774306()
{
	level.var_3d2f81f1 = getweapon("ar_standard");
	while(true)
	{
		level waittill(#"scene_sequence_started");
		foreach(player in level.activeplayers)
		{
			player function_be94c003();
		}
		level waittill(#"scene_sequence_ended");
		foreach(player in level.activeplayers)
		{
			player function_d5efb07f();
		}
	}
}

/*
	Name: function_be94c003
	Namespace: namespace_fdfaa57d
	Checksum: 0x639C1FBF
	Offset: 0x1588
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_be94c003()
{
	self.var_c74b20c1 = self getcurrentweapon();
	if(self hasweapon(level.var_3d2f81f1))
	{
		self.var_7a5a5490 = 1;
	}
	else
	{
		self giveweapon(level.var_3d2f81f1);
	}
	self switchtoweapon(level.var_3d2f81f1);
}

/*
	Name: function_d5efb07f
	Namespace: namespace_fdfaa57d
	Checksum: 0x5600CDC8
	Offset: 0x1628
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_d5efb07f()
{
	if(!(isdefined(self.var_7a5a5490) && self.var_7a5a5490))
	{
		self takeweapon(level.var_3d2f81f1);
	}
	if(isdefined(self.var_c74b20c1) && self hasweapon(self.var_c74b20c1))
	{
		self switchtoweapon(self.var_c74b20c1);
	}
}

/*
	Name: function_132d9eee
	Namespace: namespace_fdfaa57d
	Checksum: 0xEC9D94B6
	Offset: 0x16B0
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function function_132d9eee(weapon)
{
	clipammo = self getweaponammoclip(weapon);
	stockammo = self getweaponammostock(weapon);
	stockmax = weapon.maxammo;
	if(stockammo > stockmax)
	{
		stockammo = stockmax;
	}
	item = self dropitem(weapon, "tag_origin");
	if(!isdefined(item))
	{
		/#
			iprintlnbold(("" + weapon.name) + "");
		#/
		return;
	}
	level weapons::drop_limited_weapon(weapon, self, item);
	item itemweaponsetammo(clipammo, stockammo);
	item.owner = self;
	item thread weapons::watch_pickup();
	item thread weapons::delete_pickup_after_awhile();
}

