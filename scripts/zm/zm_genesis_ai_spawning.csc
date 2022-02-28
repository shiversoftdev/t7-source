// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#using_animtree("generic");

#namespace zm_genesis_ai_spawning;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_ai_spawning
	Checksum: 0x87B0EB1D
	Offset: 0x4A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_ai_spawning", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_ai_spawning
	Checksum: 0xC08FB0DE
	Offset: 0x4E0
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "chaos_postfx_set", 15000, 1, "int", &chaos_postfx_set, 0, 0);
	clientfield::register("world", "chaos_fog_bank_switch", 15000, 1, "int", &chaos_fog_bank_switch, 0, 0);
	visionset_mgr::register_visionset_info("zm_chaos_organge", 15000, 1, undefined, "zm_chaos_organge");
	ai::add_archetype_spawn_function("keeper", &function_5ea6033e);
	level._effect["chaos_1p_light"] = "zombie/fx_bmode_tent_light_zod_zmb";
	level._effect["keeper_glow"] = "zombie/fx_keeper_ambient_torso_zod_zmb";
	level._effect["keeper_mouth"] = "zombie/fx_keeper_glow_mouth_zod_zmb";
	level._effect["keeper_trail"] = "zombie/fx_keeper_mist_trail_zod_zmb";
	level._effect["keeper_death"] = "zombie/fx_keeper_death_zod_zmb";
	level.var_b7572a82 = 0;
}

/*
	Name: chaos_postfx_set
	Namespace: zm_genesis_ai_spawning
	Checksum: 0xB6629F7D
	Offset: 0x660
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function chaos_postfx_set(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_d8f5e78d = playfxoncamera(localclientnum, level._effect["chaos_1p_light"]);
		function_3c75e14b(localclientnum, 1);
	}
	else
	{
		if(isdefined(self.var_d8f5e78d))
		{
			stopfx(localclientnum, self.var_d8f5e78d);
			self.var_d8f5e78d = undefined;
		}
		function_3c75e14b(localclientnum, 0);
		self thread postfx::exitpostfxbundle();
	}
}

/*
	Name: function_3c75e14b
	Namespace: zm_genesis_ai_spawning
	Checksum: 0x9D968C9C
	Offset: 0x768
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_3c75e14b(localclientnum, onoff)
{
	if(getdvarint("splitscreen_playerCount") == 2)
	{
		var_b401f607 = getdvarint("scr_num_in_beast");
		if(onoff)
		{
			var_b401f607++;
			setdvar("cg_focalLength", 21);
		}
		else
		{
			var_b401f607--;
			if(var_b401f607 == 0)
			{
				setdvar("cg_focalLength", 14.64);
			}
		}
		setdvar("scr_num_in_beast", var_b401f607);
	}
}

/*
	Name: chaos_fog_bank_switch
	Namespace: zm_genesis_ai_spawning
	Checksum: 0xFC6157A9
	Offset: 0x850
	Size: 0x140
	Parameters: 7
	Flags: Linked
*/
function chaos_fog_bank_switch(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		level.var_b7572a82 = 1;
		for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
		{
			if(level.var_e8af7a2f)
			{
				setworldfogactivebank(localclientnum, 8);
				continue;
			}
			setworldfogactivebank(localclientnum, 2);
		}
	}
	else
	{
		for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
		{
			if(level.var_e8af7a2f)
			{
				setworldfogactivebank(localclientnum, 4);
				continue;
			}
			setworldfogactivebank(localclientnum, 1);
		}
		level.var_b7572a82 = 0;
	}
}

/*
	Name: function_5ea6033e
	Namespace: zm_genesis_ai_spawning
	Checksum: 0x45C16DE3
	Offset: 0x998
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_5ea6033e(localclientnum)
{
	self.var_341f7209 = playfxontag(localclientnum, level._effect["keeper_glow"], self, "j_spineupper");
	self.var_c5e3cf4b = playfxontag(localclientnum, level._effect["keeper_mouth"], self, "j_head");
	self.var_2d3cc156 = playfxontag(localclientnum, level._effect["keeper_trail"], self, "j_robe_front_03");
	if(!isdefined(self.sndlooper))
	{
		self.sndlooper = self playloopsound("zmb_keeper_looper");
	}
	self callback::on_shutdown(&function_4dc56cc7);
}

/*
	Name: function_4dc56cc7
	Namespace: zm_genesis_ai_spawning
	Checksum: 0x3F7795DF
	Offset: 0xAA8
	Size: 0x17C
	Parameters: 1
	Flags: Linked
*/
function function_4dc56cc7(localclientnum)
{
	if(isdefined(self.var_341f7209))
	{
		stopfx(localclientnum, self.var_341f7209);
		self.var_341f7209 = undefined;
	}
	if(isdefined(self.var_c5e3cf4b))
	{
		stopfx(localclientnum, self.var_c5e3cf4b);
		self.var_c5e3cf4b = undefined;
	}
	if(isdefined(self.var_2d3cc156))
	{
		stopfx(localclientnum, self.var_2d3cc156);
		self.var_2d3cc156 = undefined;
	}
	v_origin = self gettagorigin("j_spineupper");
	v_angles = self gettagangles("j_spineupper");
	if(isdefined(v_origin) && isdefined(v_angles))
	{
		playfx(localclientnum, level._effect["keeper_death"], v_origin, v_angles);
	}
	self stopallloopsounds();
	self playsound(0, "zmb_keeper_death_explo");
}

