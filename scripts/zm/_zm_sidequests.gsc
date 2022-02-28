// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_sidequests;

/*
	Name: init_sidequests
	Namespace: zm_sidequests
	Checksum: 0xE82D6BE4
	Offset: 0x228
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function init_sidequests()
{
	level._zombie_sidequests = [];
	/#
		level thread sidequest_debug();
	#/
}

/*
	Name: is_sidequest_allowed
	Namespace: zm_sidequests
	Checksum: 0x422CA32E
	Offset: 0x260
	Size: 0xD2
	Parameters: 1
	Flags: None
*/
function is_sidequest_allowed(a_gametypes)
{
	if(isdefined(level.gamedifficulty) && level.gamedifficulty == 0)
	{
		return 0;
	}
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
	Name: sidequest_debug
	Namespace: zm_sidequests
	Checksum: 0x76616890
	Offset: 0x340
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function sidequest_debug()
{
	/#
		if(getdvarstring("") != "")
		{
			return;
		}
		while(true)
		{
			wait(1);
		}
	#/
}

/*
	Name: damager_trigger_thread
	Namespace: zm_sidequests
	Checksum: 0x1F517EEA
	Offset: 0x390
	Size: 0x10A
	Parameters: 2
	Flags: None
*/
function damager_trigger_thread(dam_types, trigger_func)
{
	while(true)
	{
		self waittill(#"damage", amount, attacker, dir, point, type);
		self.dam_amount = amount;
		self.attacker = attacker;
		self.dam_dir = dir;
		self.dam_point = point;
		self.dam_type = type;
		for(i = 0; i < dam_types.size; i++)
		{
			if(type == dam_types[i])
			{
				break;
			}
		}
	}
	if(isdefined(trigger_func))
	{
		self [[trigger_func]]();
	}
	self notify(#"triggered");
}

/*
	Name: damage_trigger_thread
	Namespace: zm_sidequests
	Checksum: 0xF715094F
	Offset: 0x4A8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function damage_trigger_thread()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage");
		self.owner_ent notify(#"triggered");
	}
}

/*
	Name: entity_damage_thread
	Namespace: zm_sidequests
	Checksum: 0xF6762281
	Offset: 0x4F0
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function entity_damage_thread()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage");
		self.owner_ent notify(#"triggered");
	}
}

/*
	Name: sidequest_uses_teleportation
	Namespace: zm_sidequests
	Checksum: 0xE6B43D0F
	Offset: 0x538
	Size: 0x28
	Parameters: 1
	Flags: None
*/
function sidequest_uses_teleportation(name)
{
	level._zombie_sidequests[name].uses_teleportation = 1;
}

/*
	Name: register_sidequest_icon
	Namespace: zm_sidequests
	Checksum: 0xB276C266
	Offset: 0x568
	Size: 0xA4
	Parameters: 2
	Flags: None
*/
function register_sidequest_icon(icon_name, version_number)
{
	clientfieldprefix = ("sidequestIcons." + icon_name) + ".";
	clientfield::register("clientuimodel", clientfieldprefix + "icon", version_number, 1, "int");
	clientfield::register("clientuimodel", clientfieldprefix + "notification", version_number, 1, "int");
}

/*
	Name: add_sidequest_icon
	Namespace: zm_sidequests
	Checksum: 0x91BCD30E
	Offset: 0x618
	Size: 0x9C
	Parameters: 3
	Flags: None
*/
function add_sidequest_icon(sidequest_name, icon_name, var_275b4f28 = 1)
{
	clientfield::set_player_uimodel(("sidequestIcons." + icon_name) + ".icon", 1);
	if(isdefined(var_275b4f28) && var_275b4f28)
	{
		clientfield::set_player_uimodel(("sidequestIcons." + icon_name) + ".notification", 1);
	}
}

/*
	Name: remove_sidequest_icon
	Namespace: zm_sidequests
	Checksum: 0xA476429A
	Offset: 0x6C0
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function remove_sidequest_icon(sidequest_name, icon_name)
{
	clientfield::set_player_uimodel(("sidequestIcons." + icon_name) + ".icon", 0);
	clientfield::set_player_uimodel(("sidequestIcons." + icon_name) + ".notification", 0);
}

/*
	Name: declare_sidequest
	Namespace: zm_sidequests
	Checksum: 0x4743D63A
	Offset: 0x730
	Size: 0x1D2
	Parameters: 6
	Flags: None
*/
function declare_sidequest(name, init_func, logic_func, complete_func, generic_stage_start_func, generic_stage_end_func)
{
	if(!isdefined(level._zombie_sidequests))
	{
		init_sidequests();
	}
	/#
		if(isdefined(level._zombie_sidequests[name]))
		{
			println("" + name);
			return;
		}
	#/
	sq = spawnstruct();
	sq.name = name;
	sq.stages = [];
	sq.last_completed_stage = -1;
	sq.active_stage = -1;
	sq.sidequest_complete = 0;
	sq.init_func = init_func;
	sq.logic_func = logic_func;
	sq.complete_func = complete_func;
	sq.generic_stage_start_func = generic_stage_start_func;
	sq.generic_stage_end_func = generic_stage_end_func;
	sq.assets = [];
	sq.uses_teleportation = 0;
	sq.active_assets = [];
	sq.icons = [];
	sq.num_reps = 0;
	level._zombie_sidequests[name] = sq;
}

/*
	Name: declare_sidequest_stage
	Namespace: zm_sidequests
	Checksum: 0x7DB614D6
	Offset: 0x910
	Size: 0x1F2
	Parameters: 5
	Flags: None
*/
function declare_sidequest_stage(sidequest_name, stage_name, init_func, logic_func, exit_func)
{
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println("");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(((("" + stage_name) + "") + sidequest_name) + "");
			return;
		}
		if(isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
		{
			println((("" + sidequest_name) + "") + stage_name);
			return;
		}
	#/
	stage = spawnstruct();
	stage.name = stage_name;
	stage.stage_number = level._zombie_sidequests[sidequest_name].stages.size;
	stage.assets = [];
	stage.active_assets = [];
	stage.logic_func = logic_func;
	stage.init_func = init_func;
	stage.exit_func = exit_func;
	stage.completed = 0;
	stage.time_limit = 0;
	level._zombie_sidequests[sidequest_name].stages[stage_name] = stage;
}

/*
	Name: set_stage_time_limit
	Namespace: zm_sidequests
	Checksum: 0xE745E5B2
	Offset: 0xB10
	Size: 0x158
	Parameters: 4
	Flags: None
*/
function set_stage_time_limit(sidequest_name, stage_name, time_limit, timer_func)
{
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println("");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(((("" + stage_name) + "") + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
		{
			println(((("" + stage_name) + "") + sidequest_name) + "");
			return;
		}
	#/
	level._zombie_sidequests[sidequest_name].stages[stage_name].time_limit = time_limit;
	level._zombie_sidequests[sidequest_name].stages[stage_name].time_limit_func = timer_func;
}

/*
	Name: declare_stage_asset_from_struct
	Namespace: zm_sidequests
	Checksum: 0x20A25844
	Offset: 0xC70
	Size: 0x284
	Parameters: 5
	Flags: None
*/
function declare_stage_asset_from_struct(sidequest_name, stage_name, target_name, thread_func, trigger_thread_func)
{
	structs = struct::get_array(target_name, "targetname");
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + target_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(((("" + target_name) + "") + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
		{
			println(((((("" + target_name) + "") + sidequest_name) + "") + stage_name) + "");
			return;
		}
		if(!structs.size)
		{
			println(("" + target_name) + "");
			return;
		}
	#/
	for(i = 0; i < structs.size; i++)
	{
		asset = spawnstruct();
		asset.type = "struct";
		asset.struct = structs[i];
		asset.thread_func = thread_func;
		asset.trigger_thread_func = trigger_thread_func;
		level._zombie_sidequests[sidequest_name].stages[stage_name].assets[level._zombie_sidequests[sidequest_name].stages[stage_name].assets.size] = asset;
	}
}

/*
	Name: declare_stage_title
	Namespace: zm_sidequests
	Checksum: 0x2C3F7AB6
	Offset: 0xF00
	Size: 0x144
	Parameters: 3
	Flags: None
*/
function declare_stage_title(sidequest_name, stage_name, title)
{
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + title) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(((("" + title) + "") + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
		{
			println(((((("" + title) + "") + sidequest_name) + "") + stage_name) + "");
			return;
		}
	#/
	level._zombie_sidequests[sidequest_name].stages[stage_name].title = title;
}

/*
	Name: declare_stage_asset
	Namespace: zm_sidequests
	Checksum: 0xECB7FFD2
	Offset: 0x1050
	Size: 0x284
	Parameters: 5
	Flags: None
*/
function declare_stage_asset(sidequest_name, stage_name, target_name, thread_func, trigger_thread_func)
{
	ents = getentarray(target_name, "targetname");
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + target_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(((("" + target_name) + "") + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
		{
			println(((((("" + target_name) + "") + sidequest_name) + "") + stage_name) + "");
			return;
		}
		if(!ents.size)
		{
			println(("" + target_name) + "");
			return;
		}
	#/
	for(i = 0; i < ents.size; i++)
	{
		asset = spawnstruct();
		asset.type = "entity";
		asset.ent = ents[i];
		asset.thread_func = thread_func;
		asset.trigger_thread_func = trigger_thread_func;
		level._zombie_sidequests[sidequest_name].stages[stage_name].assets[level._zombie_sidequests[sidequest_name].stages[stage_name].assets.size] = asset;
	}
}

/*
	Name: declare_sidequest_asset
	Namespace: zm_sidequests
	Checksum: 0xD680E68F
	Offset: 0x12E0
	Size: 0x224
	Parameters: 4
	Flags: None
*/
function declare_sidequest_asset(sidequest_name, target_name, thread_func, trigger_thread_func)
{
	ents = getentarray(target_name, "targetname");
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + target_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(((("" + target_name) + "") + sidequest_name) + "");
			return;
		}
		if(!ents.size)
		{
			println(("" + target_name) + "");
			return;
		}
	#/
	for(i = 0; i < ents.size; i++)
	{
		asset = spawnstruct();
		asset.type = "entity";
		asset.ent = ents[i];
		asset.thread_func = thread_func;
		asset.trigger_thread_func = trigger_thread_func;
		asset.ent.thread_func = thread_func;
		asset.ent.trigger_thread_func = trigger_thread_func;
		level._zombie_sidequests[sidequest_name].assets[level._zombie_sidequests[sidequest_name].assets.size] = asset;
	}
}

/*
	Name: declare_sidequest_asset_from_struct
	Namespace: zm_sidequests
	Checksum: 0x85696CF
	Offset: 0x1510
	Size: 0x1EC
	Parameters: 4
	Flags: None
*/
function declare_sidequest_asset_from_struct(sidequest_name, target_name, thread_func, trigger_thread_func)
{
	structs = struct::get_array(target_name, "targetname");
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + target_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(((("" + target_name) + "") + sidequest_name) + "");
			return;
		}
		if(!structs.size)
		{
			println(("" + target_name) + "");
			return;
		}
	#/
	for(i = 0; i < structs.size; i++)
	{
		asset = spawnstruct();
		asset.type = "struct";
		asset.struct = structs[i];
		asset.thread_func = thread_func;
		asset.trigger_thread_func = trigger_thread_func;
		level._zombie_sidequests[sidequest_name].assets[level._zombie_sidequests[sidequest_name].assets.size] = asset;
	}
}

/*
	Name: build_asset_from_struct
	Namespace: zm_sidequests
	Checksum: 0xB075FC6
	Offset: 0x1708
	Size: 0x228
	Parameters: 2
	Flags: Linked
*/
function build_asset_from_struct(asset, parent_struct)
{
	ent = spawn("script_model", asset.origin);
	if(isdefined(asset.model))
	{
		ent setmodel(asset.model);
		asset.var_d0dd151f = ent;
	}
	if(isdefined(asset.angles))
	{
		ent.angles = asset.angles;
	}
	ent.script_noteworthy = asset.script_noteworthy;
	ent.type = "struct";
	ent.radius = asset.radius;
	ent.thread_func = parent_struct.thread_func;
	ent.trigger_thread_func = parent_struct.trigger_thread_func;
	ent.script_vector = parent_struct.script_vector;
	asset.trigger_thread_func = parent_struct.trigger_thread_func;
	asset.script_vector = parent_struct.script_vector;
	ent.target = asset.target;
	ent.script_float = asset.script_float;
	ent.script_int = asset.script_int;
	ent.script_trigger_spawnflags = asset.script_trigger_spawnflags;
	ent.targetname = asset.targetname;
	return ent;
}

/*
	Name: delete_stage_assets
	Namespace: zm_sidequests
	Checksum: 0xF6DD6427
	Offset: 0x1938
	Size: 0x200
	Parameters: 0
	Flags: Linked
*/
function delete_stage_assets()
{
	for(i = 0; i < self.active_assets.size; i++)
	{
		asset = self.active_assets[i];
		switch(asset.type)
		{
			case "struct":
			{
				if(isdefined(asset.trigger))
				{
					/#
						println("");
					#/
					if(!(isdefined(asset.trigger.var_b82c7478) && asset.trigger.var_b82c7478))
					{
						asset.trigger delete();
					}
					asset.trigger = undefined;
				}
				asset delete();
				break;
			}
			case "entity":
			{
				if(isdefined(asset.trigger))
				{
					/#
						println("");
					#/
					asset.trigger delete();
					asset.trigger = undefined;
				}
				break;
			}
		}
	}
	remaining_assets = [];
	for(i = 0; i < self.active_assets.size; i++)
	{
		if(isdefined(self.active_assets[i]))
		{
			remaining_assets[remaining_assets.size] = self.active_assets[i];
		}
	}
	self.active_assets = remaining_assets;
}

/*
	Name: build_assets
	Namespace: zm_sidequests
	Checksum: 0x5C4B1E5E
	Offset: 0x1B40
	Size: 0x7D6
	Parameters: 0
	Flags: Linked
*/
function build_assets()
{
	for(i = 0; i < self.assets.size; i++)
	{
		asset = undefined;
		switch(self.assets[i].type)
		{
			case "struct":
			{
				asset = self.assets[i].struct;
				self.active_assets[self.active_assets.size] = build_asset_from_struct(asset, self.assets[i]);
				break;
			}
			case "entity":
			{
				for(j = 0; j < self.active_assets.size; j++)
				{
					if(self.active_assets[j] == self.assets[i].ent)
					{
						asset = self.active_assets[j];
						break;
					}
				}
				asset = self.assets[i].ent;
				asset.type = "entity";
				self.active_assets[self.active_assets.size] = asset;
				break;
			}
			default:
			{
				/#
					println("" + self.assets.type);
				#/
				break;
			}
		}
		if(isdefined(asset.script_noteworthy) && (self.assets[i].type == "entity" && !isdefined(asset.trigger)) || isdefined(asset.script_noteworthy))
		{
			trigger_radius = 15;
			trigger_height = 72;
			if(isdefined(asset.radius))
			{
				trigger_radius = asset.radius;
			}
			if(isdefined(asset.height))
			{
				trigger_height = asset.height;
			}
			trigger_spawnflags = 0;
			if(isdefined(asset.script_trigger_spawnflags))
			{
				trigger_spawnflags = asset.script_trigger_spawnflags;
			}
			trigger_offset = (0, 0, 0);
			if(isdefined(asset.script_vector))
			{
				trigger_offset = asset.script_vector;
			}
			switch(asset.script_noteworthy)
			{
				case "trigger_radius_use":
				{
					use_trigger = spawn("trigger_radius_use", asset.origin + trigger_offset, trigger_spawnflags, trigger_radius, trigger_height);
					use_trigger setcursorhint("HINT_NOICON");
					use_trigger triggerignoreteam();
					if(isdefined(asset.radius))
					{
						use_trigger.radius = asset.radius;
					}
					use_trigger.owner_ent = self.active_assets[self.active_assets.size - 1];
					if(isdefined(asset.trigger_thread_func))
					{
						use_trigger thread [[asset.trigger_thread_func]]();
					}
					else
					{
						use_trigger thread use_trigger_thread();
					}
					self.active_assets[self.active_assets.size - 1].trigger = use_trigger;
					break;
				}
				case "trigger_radius_damage":
				{
					damage_trigger = spawn("trigger_damage", asset.origin + trigger_offset, trigger_spawnflags, trigger_radius, trigger_height);
					damage_trigger.angles = asset.angles;
					damage_trigger.owner_ent = self.active_assets[self.active_assets.size - 1];
					if(isdefined(asset.trigger_thread_func))
					{
						damage_trigger thread [[asset.trigger_thread_func]]();
					}
					else
					{
						damage_trigger thread damage_trigger_thread();
					}
					self.active_assets[self.active_assets.size - 1].trigger = damage_trigger;
					break;
				}
				case "trigger_radius":
				{
					radius_trigger = spawn("trigger_radius", asset.origin + trigger_offset, trigger_spawnflags, trigger_radius, trigger_height);
					if(isdefined(asset.radius))
					{
						radius_trigger.radius = asset.radius;
					}
					radius_trigger.owner_ent = self.active_assets[self.active_assets.size - 1];
					if(isdefined(asset.trigger_thread_func))
					{
						radius_trigger thread [[asset.trigger_thread_func]]();
					}
					else
					{
						radius_trigger thread radius_trigger_thread();
					}
					self.active_assets[self.active_assets.size - 1].trigger = radius_trigger;
					break;
				}
				case "entity_damage":
				{
					asset.var_d0dd151f setcandamage(1);
					asset.owner_ent = self.active_assets[self.active_assets.size - 1];
					if(isdefined(asset.trigger_thread_func))
					{
						asset.var_d0dd151f thread [[asset.trigger_thread_func]]();
					}
					else
					{
						asset.var_d0dd151f thread damage_trigger_thread();
					}
					break;
				}
			}
		}
		if(isdefined(self.assets[i].thread_func) && !isdefined(self.active_assets[self.active_assets.size - 1].dont_rethread))
		{
			self.active_assets[self.active_assets.size - 1] thread [[self.assets[i].thread_func]]();
		}
		if((i % 2) == 0)
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: radius_trigger_thread
	Namespace: zm_sidequests
	Checksum: 0x40CEACE8
	Offset: 0x2320
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function radius_trigger_thread()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", player);
		if(!isplayer(player))
		{
			continue;
		}
		self.owner_ent notify(#"triggered");
		while(player istouching(self))
		{
			wait(0.05);
		}
		self.owner_ent notify(#"untriggered");
	}
}

/*
	Name: thread_on_assets
	Namespace: zm_sidequests
	Checksum: 0x47B8A987
	Offset: 0x23C8
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function thread_on_assets(target_name, thread_func)
{
	for(i = 0; i < self.active_assets.size; i++)
	{
		if(self.active_assets[i].targetname == target_name)
		{
			self.active_assets[i] thread [[thread_func]]();
		}
	}
}

/*
	Name: stage_logic_func_wrapper
	Namespace: zm_sidequests
	Checksum: 0xDF2E493B
	Offset: 0x2450
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function stage_logic_func_wrapper(sidequest, stage)
{
	if(isdefined(stage.logic_func))
	{
		level endon(((sidequest.name + "_") + stage.name) + "_over");
		stage [[stage.logic_func]]();
	}
}

/*
	Name: sidequest_start
	Namespace: zm_sidequests
	Checksum: 0xC0087F1C
	Offset: 0x24D0
	Size: 0x114
	Parameters: 1
	Flags: None
*/
function sidequest_start(sidequest_name)
{
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(("" + sidequest_name) + "");
			return;
		}
	#/
	sidequest = level._zombie_sidequests[sidequest_name];
	sidequest build_assets();
	if(isdefined(sidequest.init_func))
	{
		sidequest [[sidequest.init_func]]();
	}
	if(isdefined(sidequest.logic_func))
	{
		sidequest thread [[sidequest.logic_func]]();
	}
}

/*
	Name: stage_start
	Namespace: zm_sidequests
	Checksum: 0xA55CC497
	Offset: 0x25F0
	Size: 0x1E4
	Parameters: 2
	Flags: Linked
*/
function stage_start(sidequest, stage)
{
	if(isstring(sidequest))
	{
		sidequest = level._zombie_sidequests[sidequest];
	}
	if(isstring(stage))
	{
		stage = sidequest.stages[stage];
	}
	stage build_assets();
	sidequest.active_stage = stage.stage_number;
	level notify(((sidequest.name + "_") + stage.name) + "_started");
	stage.completed = 0;
	if(isdefined(sidequest.generic_stage_start_func))
	{
		stage [[sidequest.generic_stage_start_func]]();
	}
	if(isdefined(stage.init_func))
	{
		stage [[stage.init_func]]();
	}
	level._last_stage_started = stage.name;
	level thread stage_logic_func_wrapper(sidequest, stage);
	if(stage.time_limit > 0)
	{
		stage thread time_limited_stage(sidequest);
	}
	if(isdefined(stage.title))
	{
		stage thread display_stage_title(sidequest.uses_teleportation);
	}
}

/*
	Name: display_stage_title
	Namespace: zm_sidequests
	Checksum: 0x3B5C4D8E
	Offset: 0x27E0
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function display_stage_title(wait_for_teleport_done_notify)
{
	if(wait_for_teleport_done_notify)
	{
		level waittill(#"teleport_done");
		wait(2);
	}
	stage_text = newhudelem();
	stage_text.location = 0;
	stage_text.alignx = "center";
	stage_text.aligny = "middle";
	stage_text.foreground = 1;
	stage_text.fontscale = 1.6;
	stage_text.sort = 20;
	stage_text.x = 320;
	stage_text.y = 300;
	stage_text.og_scale = 1;
	stage_text.color = vectorscale((1, 0, 0), 128);
	stage_text.alpha = 0;
	stage_text.fontstyle3d = "shadowedmore";
	stage_text settext(self.title);
	stage_text fadeovertime(0.5);
	stage_text.alpha = 1;
	wait(5);
	stage_text fadeovertime(1);
	stage_text.alpha = 0;
	wait(1);
	stage_text destroy();
}

/*
	Name: time_limited_stage
	Namespace: zm_sidequests
	Checksum: 0x72DE4E23
	Offset: 0x29C8
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function time_limited_stage(sidequest)
{
	/#
		println(((((("" + sidequest.name) + "") + self.name) + "") + self.time_limit) + "");
	#/
	level endon(((sidequest.name + "_") + self.name) + "_over");
	level endon(#"suspend_timer");
	level endon(#"end_game");
	time_limit = undefined;
	if(isdefined(self.time_limit_func))
	{
		time_limit = [[self.time_limit_func]]() * 0.25;
	}
	else
	{
		time_limit = self.time_limit * 0.25;
	}
	wait(time_limit);
	level notify(#"timed_stage_75_percent");
	wait(time_limit);
	level notify(#"timed_stage_50_percent");
	wait(time_limit);
	level notify(#"timed_stage_25_percent");
	wait(time_limit - 10);
	level notify(#"timed_stage_10_seconds_to_go");
	wait(10);
	stage_failed(sidequest, self);
}

/*
	Name: sidequest_println
	Namespace: zm_sidequests
	Checksum: 0x22F0BCA
	Offset: 0x2B48
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function sidequest_println(str)
{
	/#
		if(getdvarstring("") != "")
		{
			return;
		}
		println(str);
	#/
}

/*
	Name: precache_sidequest_assets
	Namespace: zm_sidequests
	Checksum: 0x99EC1590
	Offset: 0x2BA8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function precache_sidequest_assets()
{
}

/*
	Name: sidequest_complete
	Namespace: zm_sidequests
	Checksum: 0x74B1B447
	Offset: 0x2BB8
	Size: 0x9E
	Parameters: 1
	Flags: None
*/
function sidequest_complete(sidequest_name)
{
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(("" + sidequest_name) + "");
			return;
		}
	#/
	return level._zombie_sidequests[sidequest_name].sidequest_complete;
}

/*
	Name: stage_completed
	Namespace: zm_sidequests
	Checksum: 0xD206FE7D
	Offset: 0x2C60
	Size: 0x15C
	Parameters: 2
	Flags: None
*/
function stage_completed(sidequest_name, stage_name)
{
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(("" + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name].stages[stage_name]))
		{
			println(((("" + sidequest_name) + "") + stage_name) + "");
			return;
		}
		println("");
	#/
	sidequest = level._zombie_sidequests[sidequest_name];
	stage = sidequest.stages[stage_name];
	level thread stage_completed_internal(sidequest, stage);
}

/*
	Name: stage_completed_internal
	Namespace: zm_sidequests
	Checksum: 0x4BF3CAB2
	Offset: 0x2DC8
	Size: 0x278
	Parameters: 2
	Flags: Linked
*/
function stage_completed_internal(sidequest, stage)
{
	level notify(((sidequest.name + "_") + stage.name) + "_over");
	level notify(((sidequest.name + "_") + stage.name) + "_completed");
	if(isdefined(sidequest.generic_stage_end_func))
	{
		/#
			println("");
		#/
		stage [[sidequest.generic_stage_end_func]]();
	}
	if(isdefined(stage.exit_func))
	{
		/#
			println("");
		#/
		stage [[stage.exit_func]](1);
	}
	stage.completed = 1;
	sidequest.last_completed_stage = sidequest.active_stage;
	sidequest.active_stage = -1;
	stage delete_stage_assets();
	all_complete = 1;
	stage_names = getarraykeys(sidequest.stages);
	for(i = 0; i < stage_names.size; i++)
	{
		if(sidequest.stages[stage_names[i]].completed == 0)
		{
			all_complete = 0;
			break;
		}
	}
	if(all_complete == 1)
	{
		if(isdefined(sidequest.complete_func))
		{
			sidequest thread [[sidequest.complete_func]]();
		}
		level notify(("sidequest_" + sidequest.name) + "_complete");
		sidequest.sidequest_completed = 1;
	}
}

/*
	Name: stage_failed_internal
	Namespace: zm_sidequests
	Checksum: 0xF1CCE015
	Offset: 0x3048
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function stage_failed_internal(sidequest, stage)
{
	level notify(((sidequest.name + "_") + stage.name) + "_over");
	level notify(((sidequest.name + "_") + stage.name) + "_failed");
	if(isdefined(sidequest.generic_stage_end_func))
	{
		stage [[sidequest.generic_stage_end_func]]();
	}
	if(isdefined(stage.exit_func))
	{
		stage [[stage.exit_func]](0);
	}
	sidequest.active_stage = -1;
	stage delete_stage_assets();
}

/*
	Name: stage_failed
	Namespace: zm_sidequests
	Checksum: 0x3A3503F
	Offset: 0x3158
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function stage_failed(sidequest, stage)
{
	/#
		println("");
	#/
	if(isstring(sidequest))
	{
		sidequest = level._zombie_sidequests[sidequest];
	}
	if(isstring(stage))
	{
		stage = sidequest.stages[stage];
	}
	level thread stage_failed_internal(sidequest, stage);
}

/*
	Name: get_sidequest_stage
	Namespace: zm_sidequests
	Checksum: 0x98936EC6
	Offset: 0x3218
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function get_sidequest_stage(sidequest, stage_number)
{
	stage = undefined;
	stage_names = getarraykeys(sidequest.stages);
	for(i = 0; i < stage_names.size; i++)
	{
		if(sidequest.stages[stage_names[i]].stage_number == stage_number)
		{
			stage = sidequest.stages[stage_names[i]];
			break;
		}
	}
	return stage;
}

/*
	Name: get_damage_trigger
	Namespace: zm_sidequests
	Checksum: 0x8DF06D02
	Offset: 0x32F0
	Size: 0x70
	Parameters: 3
	Flags: None
*/
function get_damage_trigger(radius, origin, damage_types)
{
	trig = spawn("trigger_damage", origin, 0, radius, 72);
	trig thread dam_trigger_thread(damage_types);
	return trig;
}

/*
	Name: dam_trigger_thread
	Namespace: zm_sidequests
	Checksum: 0x7B7980EF
	Offset: 0x3368
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function dam_trigger_thread(damage_types)
{
	self endon(#"death");
	damage_type = "NONE";
	while(true)
	{
		self waittill(#"damage", amount, attacker, dir, point, mod);
		for(i = 0; i < damage_types.size; i++)
		{
			if(mod == damage_types[i])
			{
				self notify(#"triggered");
			}
		}
	}
}

/*
	Name: use_trigger_thread
	Namespace: zm_sidequests
	Checksum: 0x7946712F
	Offset: 0x3440
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function use_trigger_thread()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", player);
		self.owner_ent notify(#"triggered", player);
		wait(0.1);
	}
}

/*
	Name: sidequest_stage_active
	Namespace: zm_sidequests
	Checksum: 0xA642A7C9
	Offset: 0x34A0
	Size: 0x78
	Parameters: 2
	Flags: None
*/
function sidequest_stage_active(sidequest_name, stage_name)
{
	sidequest = level._zombie_sidequests[sidequest_name];
	stage = sidequest.stages[stage_name];
	if(sidequest.active_stage == stage.stage_number)
	{
		return true;
	}
	return false;
}

/*
	Name: sidequest_start_next_stage
	Namespace: zm_sidequests
	Checksum: 0xD5F51995
	Offset: 0x3528
	Size: 0x178
	Parameters: 1
	Flags: None
*/
function sidequest_start_next_stage(sidequest_name)
{
	/#
		if(!isdefined(level._zombie_sidequests))
		{
			println(("" + sidequest_name) + "");
			return;
		}
		if(!isdefined(level._zombie_sidequests[sidequest_name]))
		{
			println(("" + sidequest_name) + "");
			return;
		}
	#/
	sidequest = level._zombie_sidequests[sidequest_name];
	if(sidequest.sidequest_complete == 1)
	{
		return;
	}
	last_completed = sidequest.last_completed_stage;
	if(last_completed == -1)
	{
		last_completed = 0;
	}
	else
	{
		last_completed++;
	}
	stage = get_sidequest_stage(sidequest, last_completed);
	if(!isdefined(stage))
	{
		/#
			println((("" + sidequest_name) + "") + last_completed);
		#/
		return;
	}
	stage_start(sidequest, stage);
	return stage;
}

/*
	Name: main
	Namespace: zm_sidequests
	Checksum: 0x99EC1590
	Offset: 0x36A8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function main()
{
}

/*
	Name: is_facing
	Namespace: zm_sidequests
	Checksum: 0x86C31BE0
	Offset: 0x36B8
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function is_facing(facee)
{
	orientation = self getplayerangles();
	forwardvec = anglestoforward(orientation);
	forwardvec2d = (forwardvec[0], forwardvec[1], 0);
	unitforwardvec2d = vectornormalize(forwardvec2d);
	tofaceevec = facee.origin - self.origin;
	tofaceevec2d = (tofaceevec[0], tofaceevec[1], 0);
	unittofaceevec2d = vectornormalize(tofaceevec2d);
	dotproduct = vectordot(unitforwardvec2d, unittofaceevec2d);
	return dotproduct > 0.9;
}

/*
	Name: fake_use
	Namespace: zm_sidequests
	Checksum: 0x8AD29FEA
	Offset: 0x3800
	Size: 0x18C
	Parameters: 2
	Flags: None
*/
function fake_use(notify_string, qualifier_func)
{
	waittillframeend();
	while(!(isdefined(level.disable_print3d_ent) && level.disable_print3d_ent))
	{
		if(!isdefined(self))
		{
			return;
		}
		/#
			print3d(self.origin, "", vectorscale((0, 1, 0), 255), 1);
		#/
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			qualifier_passed = 1;
			if(isdefined(qualifier_func))
			{
				qualifier_passed = players[i] [[qualifier_func]]();
			}
			if(qualifier_passed && distancesquared(self.origin, players[i].origin) < 4096)
			{
				if(players[i] is_facing(self))
				{
					if(players[i] usebuttonpressed())
					{
						self notify(notify_string, players[i]);
						return;
					}
				}
			}
		}
		wait(0.1);
	}
}

