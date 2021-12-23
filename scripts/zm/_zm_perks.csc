// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace zm_perks;

/*
	Name: init
	Namespace: zm_perks
	Checksum: 0x75EDA150
	Offset: 0x1B8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init()
{
	callback::on_start_gametype(&init_perk_machines_fx);
	init_custom_perks();
	perks_register_clientfield();
	init_perk_custom_threads();
}

/*
	Name: perks_register_clientfield
	Namespace: zm_perks
	Checksum: 0x44BE60E2
	Offset: 0x218
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function perks_register_clientfield()
{
	if(isdefined(level.zombiemode_using_perk_intro_fx) && level.zombiemode_using_perk_intro_fx)
	{
		clientfield::register("scriptmover", "clientfield_perk_intro_fx", 1, 1, "int", &perk_meteor_fx, 0, 0);
	}
	if(level._custom_perks.size > 0)
	{
		a_keys = getarraykeys(level._custom_perks);
		for(i = 0; i < a_keys.size; i++)
		{
			if(isdefined(level._custom_perks[a_keys[i]].clientfield_register))
			{
				level [[level._custom_perks[a_keys[i]].clientfield_register]]();
			}
		}
	}
	level thread perk_init_code_callbacks();
}

/*
	Name: perk_init_code_callbacks
	Namespace: zm_perks
	Checksum: 0x8BEC9B24
	Offset: 0x340
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function perk_init_code_callbacks()
{
	wait(0.1);
	if(level._custom_perks.size > 0)
	{
		a_keys = getarraykeys(level._custom_perks);
		for(i = 0; i < a_keys.size; i++)
		{
			if(isdefined(level._custom_perks[a_keys[i]].clientfield_code_callback))
			{
				level [[level._custom_perks[a_keys[i]].clientfield_code_callback]]();
			}
		}
	}
}

/*
	Name: init_custom_perks
	Namespace: zm_perks
	Checksum: 0x6E4514FA
	Offset: 0x400
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function init_custom_perks()
{
	if(!isdefined(level._custom_perks))
	{
		level._custom_perks = [];
	}
}

/*
	Name: register_perk_clientfields
	Namespace: zm_perks
	Checksum: 0x21F6A8D4
	Offset: 0x428
	Size: 0xA4
	Parameters: 3
	Flags: Linked
*/
function register_perk_clientfields(str_perk, func_clientfield_register, func_code_callback)
{
	_register_undefined_perk(str_perk);
	if(!isdefined(level._custom_perks[str_perk].clientfield_register))
	{
		level._custom_perks[str_perk].clientfield_register = func_clientfield_register;
	}
	if(!isdefined(level._custom_perks[str_perk].clientfield_code_callback))
	{
		level._custom_perks[str_perk].clientfield_code_callback = func_code_callback;
	}
}

/*
	Name: register_perk_effects
	Namespace: zm_perks
	Checksum: 0xF69D5707
	Offset: 0x4D8
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function register_perk_effects(str_perk, str_light_effect)
{
	_register_undefined_perk(str_perk);
	if(!isdefined(level._custom_perks[str_perk].machine_light_effect))
	{
		level._custom_perks[str_perk].machine_light_effect = str_light_effect;
	}
}

/*
	Name: register_perk_init_thread
	Namespace: zm_perks
	Checksum: 0xDAD231DF
	Offset: 0x548
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function register_perk_init_thread(str_perk, func_init_thread)
{
	_register_undefined_perk(str_perk);
	if(!isdefined(level._custom_perks[str_perk].init_thread))
	{
		level._custom_perks[str_perk].init_thread = func_init_thread;
	}
}

/*
	Name: init_perk_custom_threads
	Namespace: zm_perks
	Checksum: 0xB86BB0D3
	Offset: 0x5B8
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function init_perk_custom_threads()
{
	if(level._custom_perks.size > 0)
	{
		a_keys = getarraykeys(level._custom_perks);
		for(i = 0; i < a_keys.size; i++)
		{
			if(isdefined(level._custom_perks[a_keys[i]].init_thread))
			{
				level thread [[level._custom_perks[a_keys[i]].init_thread]]();
			}
		}
	}
}

/*
	Name: _register_undefined_perk
	Namespace: zm_perks
	Checksum: 0x6ACC932B
	Offset: 0x670
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function _register_undefined_perk(str_perk)
{
	if(!isdefined(level._custom_perks))
	{
		level._custom_perks = [];
	}
	if(!isdefined(level._custom_perks[str_perk]))
	{
		level._custom_perks[str_perk] = spawnstruct();
	}
}

/*
	Name: perk_meteor_fx
	Namespace: zm_perks
	Checksum: 0xDCFAB8C5
	Offset: 0x6D8
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function perk_meteor_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.meteor_fx = playfxontag(localclientnum, level._effect["perk_meteor"], self, "tag_origin");
	}
	else if(isdefined(self.meteor_fx))
	{
		stopfx(localclientnum, self.meteor_fx);
	}
}

/*
	Name: init_perk_machines_fx
	Namespace: zm_perks
	Checksum: 0x12EFD45C
	Offset: 0x790
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function init_perk_machines_fx(localclientnum)
{
	if(!level.enable_magic)
	{
		return;
	}
	wait(0.1);
	machines = struct::get_array("zm_perk_machine", "targetname");
	array::thread_all(machines, &perk_start_up);
}

/*
	Name: perk_start_up
	Namespace: zm_perks
	Checksum: 0x15419E0
	Offset: 0x810
	Size: 0x142
	Parameters: 0
	Flags: Linked
*/
function perk_start_up()
{
	if(isdefined(self.script_int))
	{
		power_zone = self.script_int;
		int = undefined;
		while(int != power_zone)
		{
			level waittill(#"power_on", int);
		}
	}
	else
	{
		level waittill(#"power_on");
	}
	timer = 0;
	duration = 0.1;
	while(true)
	{
		if(isdefined(level._custom_perks[self.script_noteworthy]) && isdefined(level._custom_perks[self.script_noteworthy].machine_light_effect))
		{
			self thread vending_machine_flicker_light(level._custom_perks[self.script_noteworthy].machine_light_effect, duration);
		}
		timer = timer + duration;
		duration = duration + 0.2;
		if(timer >= 3)
		{
			break;
		}
		waitrealtime(duration);
	}
}

/*
	Name: vending_machine_flicker_light
	Namespace: zm_perks
	Checksum: 0xC4A0758
	Offset: 0x960
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function vending_machine_flicker_light(fx_light, duration)
{
	players = level.localplayers;
	for(i = 0; i < players.size; i++)
	{
		self thread play_perk_fx_on_client(i, fx_light, duration);
	}
}

/*
	Name: play_perk_fx_on_client
	Namespace: zm_perks
	Checksum: 0xB34FAA2C
	Offset: 0x9E0
	Size: 0xCC
	Parameters: 3
	Flags: Linked
*/
function play_perk_fx_on_client(client_num, fx_light, duration)
{
	fxobj = spawn(client_num, self.origin + (vectorscale((0, 0, -1), 50)), "script_model");
	fxobj setmodel("tag_origin");
	playfxontag(client_num, level._effect[fx_light], fxobj, "tag_origin");
	waitrealtime(duration);
	fxobj delete();
}

