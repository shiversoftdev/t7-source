// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_ai_sentinel_drone;

/*
	Name: __init__sytem__
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x4D561638
	Offset: 0x500
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_sentinel_drone", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xE80B5843
	Offset: 0x548
	Size: 0x69E
	Parameters: 0
	Flags: Linked, AutoExec
*/
function autoexec __init__()
{
	clientfield::register("world", "sentinel_round_fog", 12000, 1, "int", &sentinel_round_fog, 0, 0);
	clientfield::register("toplayer", "sentinel_round_fx", 12000, 1, "int", &sentinel_round_fx, 0, 0);
	clientfield::register("vehicle", "sentinel_spawn_fx", 12000, 1, "int", &sentinel_spawn_fx, 0, 0);
	clientfield::register("vehicle", "necro_sentinel_fx", 12000, 1, "int", &necro_sentinel_fx, 0, 0);
	clientfield::register("actor", "sentinel_zombie_spawn_fx", 12000, 1, "int", &function_bc95cac0, 0, 0);
	level._effect["sentinel_round"] = "zombie/fx_meatball_round_tell_zod_zmb";
	level._effect["sentinel_spawn_in"] = "dlc3/stalingrad/fx_sentinel_drone_spawn_trail";
	level._effect["sentinel_spawn_impact"] = "dlc3/stalingrad/fx_mech_wpn_harpoon_explo";
	level._effect["sentinel_ground_radiation"] = "dlc3/stalingrad/fx_sentinel_drone_ground_elec";
	level._effect["rezzed_skeleton_eye_glow"] = "zombie/fx_glow_eye_blue_stalingrad";
	level._effect["rezzed_skeleton_sparky"] = "dlc3/stalingrad/fx_elec_sparky_chest";
	level._effect["rezzed_skeleton_spark_light"] = "dlc3/stalingrad/fx_light_sparky_chest";
	level.var_4d7b6b0 = [];
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!isarray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_0";
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!isarray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_1";
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!isarray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_2";
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!isarray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_3";
	if(!isdefined(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = [];
	}
	else if(!isarray(level.var_4d7b6b0))
	{
		level.var_4d7b6b0 = array(level.var_4d7b6b0);
	}
	level.var_4d7b6b0[level.var_4d7b6b0.size] = "vox_valk_valkyrie_resurrect_4";
	level.var_266194a = [];
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!isarray(level.var_266194a))
	{
		level.var_266194a = array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_0";
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!isarray(level.var_266194a))
	{
		level.var_266194a = array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_1";
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!isarray(level.var_266194a))
	{
		level.var_266194a = array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_2";
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!isarray(level.var_266194a))
	{
		level.var_266194a = array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_3";
	if(!isdefined(level.var_266194a))
	{
		level.var_266194a = [];
	}
	else if(!isarray(level.var_266194a))
	{
		level.var_266194a = array(level.var_266194a);
	}
	level.var_266194a[level.var_266194a.size] = "vox_valk_valkyrie_scanner_4";
}

/*
	Name: __main__
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x7DEF5F1D
	Offset: 0xBF0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	visionset_mgr::register_visionset_info("zm_sentinel_round_visionset", 12000, 31, undefined, "zm_sentinel_round_visionset");
}

/*
	Name: sentinel_round_fog
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x468BA76D
	Offset: 0xC28
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function sentinel_round_fog(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	if(n_val_new)
	{
		setlitfogbank(n_local_client, -1, 1, -1);
		setworldfogactivebank(n_local_client, 2);
	}
	else
	{
		setlitfogbank(n_local_client, -1, 0, -1);
		setworldfogactivebank(n_local_client, 1);
	}
}

/*
	Name: sentinel_round_fx
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xB624283D
	Offset: 0xCF0
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function sentinel_round_fx(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self endon(#"death");
	if(n_val_new)
	{
		if(isspectating(n_local_client))
		{
			return;
		}
		self thread postfx::playpostfxbundle("pstfx_stalingrad_sentinel");
		self.var_8ffc609a = playfxoncamera(n_local_client, level._effect["sentinel_round"]);
		wait(3.5);
		if(isdefined(self))
		{
			deletefx(n_local_client, self.var_8ffc609a);
		}
	}
}

/*
	Name: sentinel_spawn_fx
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xA970AF4A
	Offset: 0xDE0
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function sentinel_spawn_fx(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	if(n_val_new)
	{
		self.var_e43aab07 = playfxontag(n_local_client, level._effect["sentinel_spawn_in"], self, "tag_origin");
		setfxignorepause(n_local_client, self.var_e43aab07, 1);
	}
	else
	{
		if(isdefined(self.var_e43aab07))
		{
			stopfx(n_local_client, self.var_e43aab07);
		}
		playfxontag(n_local_client, level._effect["sentinel_spawn_impact"], self, "tag_origin");
		wait(1);
		if(isdefined(self))
		{
			sentinel_play_taunt(n_local_client, level.var_266194a);
		}
	}
}

/*
	Name: necro_sentinel_fx
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x477474FD
	Offset: 0xF10
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function necro_sentinel_fx(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	if(n_val_new)
	{
		self.var_5ec69ff1 = playfxontag(n_local_client, level._effect["sentinel_ground_radiation"], self, "tag_origin");
		setfxignorepause(n_local_client, self.var_5ec69ff1, 1);
		sentinel_play_taunt(n_local_client, level.var_4d7b6b0);
	}
	else if(isdefined(self.var_5ec69ff1))
	{
		stopfx(n_local_client, self.var_5ec69ff1);
	}
}

/*
	Name: function_bc95cac0
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xFCBDA34C
	Offset: 0x1008
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function function_bc95cac0(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self._eyeglow_fx_override = level._effect["rezzed_skeleton_eye_glow"];
	self.var_46d9c2ee = "J_Spine4";
	self.var_7abb4217 = level._effect["rezzed_skeleton_sparky"];
	self.var_e22d3880 = level._effect["rezzed_skeleton_spark_light"];
}

/*
	Name: sentinel_play_taunt
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x6F9D589A
	Offset: 0x10A8
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function sentinel_play_taunt(localclientnum, taunt_arr)
{
	if(isdefined(level._lastplayed_drone_taunt) && (gettime() - level._lastplayed_drone_taunt) < 6000)
	{
		return;
	}
	if(isdefined(level.voxaideactivate) && level.voxaideactivate)
	{
		return;
	}
	level._lastplayed_drone_taunt = gettime();
	taunt = randomint(taunt_arr.size);
	self playsound(localclientnum, taunt_arr[taunt]);
}

