// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm_bgb_machine;

#namespace bgb;

/*
	Name: __init__sytem__
	Namespace: bgb
	Checksum: 0x8E44099B
	Offset: 0x278
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bgb", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: bgb
	Checksum: 0x9F12A9D8
	Offset: 0x2C0
	Size: 0x236
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level.weaponbgbgrab = getweapon("zombie_bgb_grab");
	callback::on_localclient_connect(&on_player_connect);
	level.bgb = [];
	level.bgb_pack = [];
	clientfield::register("clientuimodel", "bgb_current", 1, 8, "int", &function_cec2dbda, 0, 0);
	clientfield::register("clientuimodel", "bgb_display", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "bgb_timer", 1, 8, "float", undefined, 0, 0);
	clientfield::register("clientuimodel", "bgb_activations_remaining", 1, 3, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "bgb_invalid_use", 1, 1, "counter", undefined, 0, 0);
	clientfield::register("clientuimodel", "bgb_one_shot_use", 1, 1, "counter", undefined, 0, 0);
	clientfield::register("toplayer", "bgb_blow_bubble", 1, 1, "counter", &bgb_blow_bubble, 0, 0);
	level._effect["bgb_blow_bubble"] = "zombie/fx_bgb_bubble_blow_zmb";
}

/*
	Name: __main__
	Namespace: bgb
	Checksum: 0xE5DF4326
	Offset: 0x500
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private __main__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb_finalize();
}

/*
	Name: on_player_connect
	Namespace: bgb
	Checksum: 0xF80D05EB
	Offset: 0x538
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private on_player_connect(localclientnum)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	self thread bgb_player_init(localclientnum);
}

/*
	Name: bgb_player_init
	Namespace: bgb
	Checksum: 0x7253B4EB
	Offset: 0x580
	Size: 0x42
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_player_init(localclientnum)
{
	if(isdefined(level.bgb_pack[localclientnum]))
	{
		return;
	}
	level.bgb_pack[localclientnum] = getbubblegumpack(localclientnum);
}

/*
	Name: bgb_finalize
	Namespace: bgb
	Checksum: 0x92D48920
	Offset: 0x5D0
	Size: 0x384
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_finalize()
{
	level.var_f3c83828 = [];
	level.var_f3c83828[0] = "base";
	level.var_f3c83828[1] = "speckled";
	level.var_f3c83828[2] = "shiny";
	level.var_f3c83828[3] = "swirl";
	level.var_f3c83828[4] = "pinwheel";
	statstablename = util::getstatstablename();
	level.bgb_item_index_to_name = [];
	keys = getarraykeys(level.bgb);
	for(i = 0; i < keys.size; i++)
	{
		level.bgb[keys[i]].item_index = getitemindexfromref(keys[i]);
		level.bgb[keys[i]].rarity = int(tablelookup(statstablename, 0, level.bgb[keys[i]].item_index, 16));
		if(0 == level.bgb[keys[i]].rarity || 4 == level.bgb[keys[i]].rarity)
		{
			level.bgb[keys[i]].consumable = 0;
		}
		else
		{
			level.bgb[keys[i]].consumable = 1;
		}
		level.bgb[keys[i]].camo_index = int(tablelookup(statstablename, 0, level.bgb[keys[i]].item_index, 5));
		level.bgb[keys[i]].flying_gumball_tag = "tag_gumball_" + level.bgb[keys[i]].limit_type;
		level.bgb[keys[i]].var_ece14434 = (("tag_gumball_" + level.bgb[keys[i]].limit_type) + "_") + level.var_f3c83828[level.bgb[keys[i]].rarity];
		level.bgb_item_index_to_name[level.bgb[keys[i]].item_index] = keys[i];
	}
}

/*
	Name: register
	Namespace: bgb
	Checksum: 0x8C8068F6
	Offset: 0x960
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function register(name, limit_type)
{
	/#
		assert(isdefined(name), "");
	#/
	/#
		assert("" != name, ("" + "") + "");
	#/
	/#
		assert(!isdefined(level.bgb[name]), ("" + name) + "");
	#/
	/#
		assert(isdefined(limit_type), ("" + name) + "");
	#/
	level.bgb[name] = spawnstruct();
	level.bgb[name].name = name;
	level.bgb[name].limit_type = limit_type;
}

/*
	Name: function_78c4bfa
	Namespace: bgb
	Checksum: 0x199C3CA9
	Offset: 0xAB0
	Size: 0x17C
	Parameters: 2
	Flags: Linked, Private
*/
function private function_78c4bfa(localclientnum, time)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	if(isdemoplaying())
	{
		return;
	}
	if(!isdefined(self.bgb) || !isdefined(level.bgb[self.bgb]))
	{
		return;
	}
	switch(level.bgb[self.bgb].limit_type)
	{
		case "activated":
		{
			color = (25, 0, 50) / 255;
			break;
		}
		case "event":
		{
			color = (100, 50, 0) / 255;
			break;
		}
		case "rounds":
		{
			color = (1, 149, 244) / 255;
			break;
		}
		case "time":
		{
			color = (19, 244, 20) / 255;
			break;
		}
		default:
		{
			return;
		}
	}
	self setcontrollerlightbarcolor(localclientnum, color);
	wait(time);
	if(isdefined(self))
	{
		self setcontrollerlightbarcolor(localclientnum);
	}
}

/*
	Name: function_cec2dbda
	Namespace: bgb
	Checksum: 0xD8DC07CD
	Offset: 0xC38
	Size: 0x6C
	Parameters: 7
	Flags: Linked, Private
*/
function private function_cec2dbda(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self.bgb = level.bgb_item_index_to_name[newval];
	self thread function_78c4bfa(localclientnum, 3);
}

/*
	Name: function_c8a1c86
	Namespace: bgb
	Checksum: 0x8B49EA30
	Offset: 0xCB0
	Size: 0x94
	Parameters: 2
	Flags: Linked, Private
*/
function private function_c8a1c86(localclientnum, fx)
{
	if(isdefined(self.var_d7197e33))
	{
		deletefx(localclientnum, self.var_d7197e33, 1);
	}
	if(isdefined(fx))
	{
		self.var_d7197e33 = playfxoncamera(localclientnum, fx);
		self playsound(0, "zmb_bgb_blow_bubble_plr");
	}
}

/*
	Name: bgb_blow_bubble
	Namespace: bgb
	Checksum: 0x66C74291
	Offset: 0xD50
	Size: 0x84
	Parameters: 7
	Flags: Linked, Private
*/
function private bgb_blow_bubble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_c8a1c86(localclientnum, level._effect["bgb_blow_bubble"]);
	self thread function_78c4bfa(localclientnum, 0.5);
}

