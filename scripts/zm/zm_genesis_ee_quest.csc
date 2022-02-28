// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_teleporter;
#using scripts\zm\zm_genesis_util;

#using_animtree("generic");

#namespace zm_genesis_ee_quest;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_ee_quest
	Checksum: 0x560DFAF5
	Offset: 0x450
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_ee_quest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_ee_quest
	Checksum: 0x669FDCBE
	Offset: 0x490
	Size: 0x2E6
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "ee_quest_state", 15000, getminbitcountfornum(13), "int", &ee_quest_state, 0, 0);
	clientfield::register("scriptmover", "ghost_entity", 15000, 1, "int", &function_2b5ef9a6, 0, 0);
	clientfield::register("scriptmover", "electric_charge", 15000, 1, "int", &function_ede1c539, 0, 0);
	clientfield::register("scriptmover", "grand_tour_found_toy_fx", 15000, 1, "int", &function_52d5d371, 0, 0);
	clientfield::register("scriptmover", "sophia_transition_fx", 15000, 1, "int", &sophia_transition_fx, 0, 0);
	clientfield::register("allplayers", "sophia_follow", 15000, 3, "int", &sophia_follow, 0, 0);
	clientfield::register("scriptmover", "sophia_eye_on", 15000, 1, "int", &sophia_eye_on, 0, 0);
	clientfield::register("allplayers", "sophia_delete_local", 15000, 1, "int", &sophia_delete_local, 0, 0);
	clientfield::register("world", "GenesisEndGameEEScreen", 15000, 1, "int", &genesisendgameee, 0, 0);
	duplicate_render::set_dr_filter_framebuffer("zod_ghost", 90, "zod_ghost", undefined, 0, "mc/hud_zod_ghost", 0);
	level._effect["electric_charge"] = "electric/fx_elec_arc_med_loop_hacktower";
}

/*
	Name: ee_quest_state
	Namespace: zm_genesis_ee_quest
	Checksum: 0x79E851A6
	Offset: 0x780
	Size: 0xA6
	Parameters: 7
	Flags: Linked
*/
function ee_quest_state(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level notify(#"ee_quest_state");
	level endon(#"ee_quest_state");
	switch(newval)
	{
		case 7:
		{
			break;
		}
		case 8:
		{
			break;
		}
		case 9:
		{
			break;
		}
		case 10:
		{
			break;
		}
		case 12:
		{
			break;
		}
	}
}

/*
	Name: function_2b5ef9a6
	Namespace: zm_genesis_ee_quest
	Checksum: 0xB7A52EBA
	Offset: 0x830
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_2b5ef9a6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self duplicate_render::set_dr_flag("zod_ghost", newval);
	self duplicate_render::update_dr_filters(localclientnum);
}

/*
	Name: function_ede1c539
	Namespace: zm_genesis_ee_quest
	Checksum: 0x9D1043A
	Offset: 0x8B0
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_ede1c539(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_ebad8041))
	{
		deletefx(localclientnum, self.var_ebad8041, 0);
		self.var_ebad8041 = undefined;
	}
	if(newval == 1)
	{
		self.var_ebad8041 = playfxontag(localclientnum, level._effect["electric_charge"], self, "tag_origin");
	}
}

/*
	Name: function_52d5d371
	Namespace: zm_genesis_ee_quest
	Checksum: 0x8C699C1F
	Offset: 0x970
	Size: 0xD6
	Parameters: 7
	Flags: Linked
*/
function function_52d5d371(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["ee_toy_found"], self.origin);
		self.var_22c9fb1a = playfxontag(localclientnum, level._effect["shadow_rq_chomper_light"], self, "tag_origin");
	}
	else
	{
		deletefx(localclientnum, self.var_22c9fb1a, 0);
		self.var_22c9fb1a = undefined;
	}
}

/*
	Name: sophia_transition_fx
	Namespace: zm_genesis_ee_quest
	Checksum: 0x137C0FA
	Offset: 0xA50
	Size: 0xB6
	Parameters: 7
	Flags: Linked
*/
function sophia_transition_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.n_fx = playfxontag(localclientnum, level._effect["sophia_transition"], self, "tag_origin");
	}
	else if(isdefined(self.n_fx))
	{
		deletefx(localclientnum, self.n_fx, 0);
		self.n_fx = undefined;
	}
}

/*
	Name: sophia_follow
	Namespace: zm_genesis_ee_quest
	Checksum: 0x5589E835
	Offset: 0xB10
	Size: 0x1A4
	Parameters: 7
	Flags: Linked
*/
function sophia_follow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level endon(#"hash_249c0595");
	var_1c7b6837 = getent(localclientnum, "sophia_eye", "targetname");
	if(!isdefined(var_1c7b6837))
	{
		var_af8a18df = struct::get("ee_beam_sophia", "targetname");
		var_1c7b6837 = util::spawn_model(localclientnum, "p7_zm_gen_dark_arena_sphere", var_af8a18df.origin, var_af8a18df.angles);
		var_1c7b6837.targetname = "sophia_eye";
		var_1c7b6837 mapshaderconstant(localclientnum, 0, "scriptVector2", 1, 0, 0);
	}
	level notify(#"hash_deeb3634");
	wait(0.5);
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	if(newval == 0)
	{
		var_1c7b6837 rotateto((0, 0, 0), 0.5);
	}
	else
	{
		level.var_9a736d20 = 1;
		var_1c7b6837 thread function_36666e11(self);
	}
}

/*
	Name: sophia_eye_on
	Namespace: zm_genesis_ee_quest
	Checksum: 0xD3126C43
	Offset: 0xCC0
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function sophia_eye_on(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector2", 1, 0, 0);
}

/*
	Name: function_36666e11
	Namespace: zm_genesis_ee_quest
	Checksum: 0xE66D3847
	Offset: 0xD30
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function function_36666e11(e_player)
{
	level endon(#"demo_jump");
	level endon(#"hash_deeb3634");
	e_player endon(#"death");
	self endon(#"entityshutdown");
	while(isdefined(e_player))
	{
		var_c746e6bf = e_player gettagorigin("j_head");
		var_933e0d32 = vectortoangles(var_c746e6bf - self.origin);
		var_933e0d32 = (var_933e0d32[0], var_933e0d32[1], var_933e0d32[2]);
		self rotateto(var_933e0d32, 0.1);
		wait(0.1);
	}
}

/*
	Name: sophia_delete_local
	Namespace: zm_genesis_ee_quest
	Checksum: 0x56574BF4
	Offset: 0xE28
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function sophia_delete_local(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_1c7b6837 = getent(localclientnum, "sophia_eye", "targetname");
	if(isdefined(var_1c7b6837))
	{
		var_1c7b6837 rotateto((0, 0, 0), 0.2);
		var_1c7b6837 delete();
	}
}

/*
	Name: genesisendgameee
	Namespace: zm_genesis_ee_quest
	Checksum: 0x85835E3F
	Offset: 0xEE8
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function genesisendgameee(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "GenesisEndGameEE"), 1);
}

