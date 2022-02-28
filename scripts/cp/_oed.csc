// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace oed;

/*
	Name: __init__sytem__
	Namespace: oed
	Checksum: 0x9E85F2E
	Offset: 0x4E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("oed", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: oed
	Checksum: 0x9CB242EB
	Offset: 0x520
	Size: 0x59C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "ev_toggle", 1, 1, "int", &ev_player_toggle, 0, 0);
	clientfield::register("toplayer", "sitrep_toggle", 1, 1, "int", &sitrep_player_toggle, 0, 0);
	clientfield::register("toplayer", "tmode_toggle", 1, 3, "int", &tmode_player_toggle, 0, 0);
	clientfield::register("toplayer", "active_dni_fx", 1, 1, "counter", &function_6b87ceb0, 0, 0);
	clientfield::register("toplayer", "hack_dni_fx", 1, 1, "counter", &hack_dni_fx, 0, 0);
	clientfield::register("actor", "thermal_active", 1, 1, "int", &ent_thermal_callback, 0, 0);
	clientfield::register("actor", "sitrep_material", 1, 1, "int", &ent_material_callback, 0, 0);
	clientfield::register("actor", "force_tmode", 1, 1, "int", &tmode_force_toggle, 0, 0);
	clientfield::register("actor", "tagged", 1, 1, "int", &tagged_toggle, 0, 0);
	clientfield::register("vehicle", "thermal_active", 1, 1, "int", &ent_thermal_callback, 0, 0);
	clientfield::register("vehicle", "sitrep_material", 1, 1, "int", &ent_material_callback, 0, 0);
	clientfield::register("scriptmover", "thermal_active", 1, 1, "int", &ent_thermal_callback, 0, 0);
	clientfield::register("scriptmover", "sitrep_material", 1, 1, "int", &ent_material_callback, 0, 0);
	clientfield::register("item", "sitrep_material", 1, 1, "int", &ent_material_callback, 0, 0);
	duplicate_render::set_dr_filter_offscreen("sitrep_keyline", 25, "keyline_active", "keyfill_active", 2, "mc/hud_outline_model_z_white", 0);
	duplicate_render::set_dr_filter_offscreen("sitrep_fill", 25, "keyfill_active", "keyline_active", 2, "mc/hud_outline_model_orange_alpha", 0);
	duplicate_render::set_dr_filter_offscreen("sitrep_keyfill", 30, "keyline_active,keyfill_active", undefined, 2, "mc/hud_outline_model_orange_calpha", 0);
	duplicate_render::set_dr_filter_offscreen("enemy_thermal", 24, "thermal_enemy_active", undefined, 2, "mc/hud_outline_model_z_red", 0);
	duplicate_render::set_dr_filter_offscreen("friendly_thermal", 24, "thermal_friendly_active", undefined, 2, "mc/hud_outline_model_z_green", 0);
	visionset_mgr::register_visionset_info("tac_mode", 1, 15, undefined, "tac_mode_blue");
	callback::on_spawned(&on_player_spawned);
	level flag::init("activate_tmode");
	level flag::init("activate_thermal");
	callback::on_localclient_shutdown(&on_localplayer_shutdown);
}

/*
	Name: on_player_spawned
	Namespace: oed
	Checksum: 0x38F833BB
	Offset: 0xAC8
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(localclientnum)
{
	self.b_ev_active = 0;
	var_7fd179a9 = 10500;
	var_3b6a005d = 3000;
	if(isdefined(level.var_6411bf7a))
	{
		var_7fd179a9 = level.var_6411bf7a;
	}
	if(isdefined(level.var_80d69208))
	{
		var_3b6a005d = level.var_80d69208;
	}
	evsetranges(localclientnum, var_7fd179a9, var_3b6a005d);
	self oed_sitrepscan_setoutline(1);
	self oed_sitrepscan_setlinewidth(1);
	self oed_sitrepscan_setradius(1800);
	self oed_sitrepscan_setfalloff(0.01);
	self tmode_init_ent_shader_materials();
	function_357cbbf0(localclientnum);
	function_22ee3552(localclientnum);
}

/*
	Name: on_localplayer_shutdown
	Namespace: oed
	Checksum: 0xA4633418
	Offset: 0xC10
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_shutdown(localclientnum)
{
	function_357cbbf0(localclientnum);
	function_22ee3552(localclientnum);
}

/*
	Name: tmode_init_ent_shader_materials
	Namespace: oed
	Checksum: 0x99EC1590
	Offset: 0xC58
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function tmode_init_ent_shader_materials()
{
}

/*
	Name: tmode_remove_all_ents
	Namespace: oed
	Checksum: 0xD0AC6A6E
	Offset: 0xC68
	Size: 0x10A
	Parameters: 1
	Flags: Linked
*/
function tmode_remove_all_ents(localclientnum)
{
	if(!self islocalplayer())
	{
		return;
	}
	a_all_entities = getentarray(localclientnum);
	foreach(entity in a_all_entities)
	{
		if(isdefined(entity.tmode_set) && entity.tmode_set)
		{
			entity.tmode_set = 0;
			entity tmodeclearflag(4);
		}
	}
}

/*
	Name: ev_player_toggle
	Namespace: oed
	Checksum: 0x576291E5
	Offset: 0xD80
	Size: 0xCC
	Parameters: 7
	Flags: Linked
*/
function ev_player_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!self islocalplayer())
	{
		return;
	}
	if(!isdefined(self getlocalclientnumber()))
	{
		return;
	}
	if(self getlocalclientnumber() != localclientnum)
	{
		return;
	}
	if(level flagsys::get("menu_open"))
	{
		return;
	}
	self player_toggle_ev(localclientnum, newval);
}

/*
	Name: function_e8b1e8b2
	Namespace: oed
	Checksum: 0xE305AAF5
	Offset: 0xE58
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function function_e8b1e8b2(localclientnum, newval)
{
	if(isdefined(self))
	{
		self evenable(newval);
	}
	else
	{
		/#
			println("");
		#/
		gadgetsetinfrared(localclientnum, newval);
	}
}

/*
	Name: function_22ee3552
	Namespace: oed
	Checksum: 0x214B8EF7
	Offset: 0xED0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_22ee3552(localclientnum)
{
	audio::stoploopat("gdt_oed_loop", (1, 2, 3));
	deactivate_thermal_ents(localclientnum);
	wait(0.016);
	self function_e8b1e8b2(localclientnum, 0);
	level flag::clear("activate_thermal");
}

/*
	Name: function_357cbbf0
	Namespace: oed
	Checksum: 0x172B43BC
	Offset: 0xF68
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_357cbbf0(localclientnum)
{
	self tmodeenable(0);
	self thread tmode_remove_all_ents(localclientnum);
	wait(0.016);
	level flag::clear("activate_tmode");
}

/*
	Name: player_toggle_ev
	Namespace: oed
	Checksum: 0x766E1517
	Offset: 0xFD8
	Size: 0x1AC
	Parameters: 2
	Flags: Linked
*/
function player_toggle_ev(lcn, newval)
{
	self.b_ev_active = newval;
	if(newval)
	{
		function_357cbbf0(lcn);
		self function_e8b1e8b2(lcn, newval);
		level flag::set("activate_thermal");
		if(isdefined(level.ev_override))
		{
			[[level.ev_override]]();
		}
		playsound(lcn, "gdt_oed_on", (0, 0, 0));
		audio::playloopat("gdt_oed_loop", (1, 2, 3));
		activate_thermal_ents(lcn);
	}
	else
	{
		playsound(lcn, "gdt_oed_off", (0, 0, 0));
		audio::stoploopat("gdt_oed_loop", (1, 2, 3));
		deactivate_thermal_ents(lcn);
		wait(0.016);
		self function_e8b1e8b2(lcn, newval);
		level flag::clear("activate_thermal");
	}
}

/*
	Name: ent_thermal_callback
	Namespace: oed
	Checksum: 0x2EFF89D1
	Offset: 0x1190
	Size: 0x14C
	Parameters: 7
	Flags: Linked
*/
function ent_thermal_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	level flagsys::wait_till("duplicaterender_registry_ready");
	/#
		assert(isdefined(self), "");
	#/
	if(newval == 0)
	{
		self.b_show_thermal = 0;
		self set_entity_thermal(localclientnum, 0);
	}
	else
	{
		self.b_show_thermal = newval;
		player = getlocalplayer(localclientnum);
		if(isdefined(player.b_ev_active) && player.b_ev_active)
		{
			self set_entity_thermal(localclientnum, 1);
		}
		else
		{
			self set_entity_thermal(localclientnum, 0);
		}
	}
}

/*
	Name: set_entity_thermal
	Namespace: oed
	Checksum: 0xD700ABB5
	Offset: 0x12E8
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function set_entity_thermal(localclientnum, b_enabled)
{
	if(self.team == "allies")
	{
		self duplicate_render::set_dr_flag("thermal_friendly_active", b_enabled);
		n_index = 6;
	}
	else
	{
		self duplicate_render::set_dr_flag("thermal_enemy_active", b_enabled);
		n_index = 5;
	}
	if(b_enabled)
	{
		self tmodesetflag(n_index);
	}
	else
	{
		self tmodeclearflag(n_index);
	}
}

/*
	Name: activate_thermal_ents
	Namespace: oed
	Checksum: 0x6BDD7A07
	Offset: 0x13C0
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function activate_thermal_ents(localclientnum)
{
	a_e_thermals = getentarray(localclientnum);
	foreach(entity in a_e_thermals)
	{
		if(isdefined(entity.b_show_thermal) && entity.b_show_thermal)
		{
			entity set_entity_thermal(localclientnum, 1);
		}
	}
}

/*
	Name: deactivate_thermal_ents
	Namespace: oed
	Checksum: 0x34E2355B
	Offset: 0x14B0
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function deactivate_thermal_ents(localclientnum)
{
	a_e_thermals = getentarray(localclientnum);
	foreach(entity in a_e_thermals)
	{
		if(isdefined(entity.b_show_thermal) && entity.b_show_thermal)
		{
			entity set_entity_thermal(localclientnum, 0);
		}
	}
}

/*
	Name: structural_weakness_callback
	Namespace: oed
	Checksum: 0x8B34FE18
	Offset: 0x15A0
	Size: 0xAC
	Parameters: 7
	Flags: None
*/
function structural_weakness_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	level flagsys::wait_till("duplicaterender_registry_ready");
	/#
		assert(isdefined(self), "");
	#/
	if(newval)
	{
		self duplicate_render::set_item_enemy_equipment(localclientnum, newval);
	}
}

/*
	Name: tmode_force_toggle
	Namespace: oed
	Checksum: 0x7C2C5A3A
	Offset: 0x1658
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function tmode_force_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.b_force_tmode = 1;
		self tmodesetflag(1);
	}
	else
	{
		self.b_force_tmode = 0;
		self tmodeclearflag(1);
	}
}

/*
	Name: tagged_toggle
	Namespace: oed
	Checksum: 0x8BC85B39
	Offset: 0x1700
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function tagged_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	forcetmodevisible(self, newval);
}

/*
	Name: function_6b87ceb0
	Namespace: oed
	Checksum: 0xB23A7F52
	Offset: 0x1760
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_6b87ceb0(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread postfx::playpostfxbundle("pstfx_tactical_bootup");
}

/*
	Name: hack_dni_fx
	Namespace: oed
	Checksum: 0x2279FF1E
	Offset: 0x17C8
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function hack_dni_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread postfx::playpostfxbundle("pstfx_hacking_bootup");
	self playsound(0, "uin_hack_mode_activate");
}

/*
	Name: function_3b4d6db0
	Namespace: oed
	Checksum: 0xBF8D3CDB
	Offset: 0x1850
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function function_3b4d6db0(localclientnum, b_playsound = 1)
{
	self tmodeenable(0);
	if(!isdefined(level.var_e46224ba) && !isigcactive(localclientnum) && b_playsound)
	{
		self thread postfx::playpostfxbundle("pstfx_tactical_bootup");
	}
	self thread tmode_remove_all_ents(localclientnum);
	if(!isigcactive(localclientnum) && b_playsound)
	{
		self playsound(0, "uin_tac_mode_off");
	}
	level flag::clear("activate_tmode");
}

/*
	Name: function_165838aa
	Namespace: oed
	Checksum: 0xD69F07C4
	Offset: 0x1960
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function function_165838aa(localclientnum, b_playsound = 1)
{
	function_22ee3552(localclientnum);
	level flag::set("activate_tmode");
	self tmodeenable(1);
	if(isdefined(level.tmode_override))
	{
		[[level.tmode_override]]();
	}
	if(!isdefined(level.var_e46224ba) && b_playsound)
	{
		self thread postfx::playpostfxbundle("pstfx_tactical_bootup");
	}
	if(b_playsound)
	{
		self playsound(0, "uin_tac_mode_on");
	}
}

/*
	Name: tmode_player_toggle
	Namespace: oed
	Checksum: 0x868F52F
	Offset: 0x1A58
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function tmode_player_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!self islocalplayer())
	{
		return;
	}
	if(!isdefined(self.localclientnum))
	{
		return;
	}
	if(self.localclientnum != localclientnum)
	{
		return;
	}
	if(level flagsys::get("menu_open"))
	{
		return;
	}
	self notify(#"tmode_cancel");
	self.var_8b70667f = newval;
	b_playsound = 0;
	if(newval & 2)
	{
		b_playsound = 1;
	}
	if(newval & 4)
	{
		self function_165838aa(localclientnum, b_playsound);
	}
	else
	{
		self function_3b4d6db0(localclientnum, b_playsound);
	}
}

/*
	Name: sitrep_player_toggle
	Namespace: oed
	Checksum: 0x74B8B325
	Offset: 0x1B88
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function sitrep_player_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!self islocalplayer())
	{
		return;
	}
	if(!isdefined(self.localclientnum))
	{
		return;
	}
	if(self.localclientnum != localclientnum)
	{
		return;
	}
	self thread player_toggle_sitrep(localclientnum, newval);
}

/*
	Name: player_toggle_sitrep
	Namespace: oed
	Checksum: 0x551127AC
	Offset: 0x1C28
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function player_toggle_sitrep(lcn, newval)
{
	self.sitrep_active = newval;
	self oed_sitrepscan_enable(newval);
}

/*
	Name: ent_material_callback
	Namespace: oed
	Checksum: 0xA39F2ACA
	Offset: 0x1C70
	Size: 0x184
	Parameters: 7
	Flags: Linked
*/
function ent_material_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	/#
		assert(isdefined(self), "");
	#/
	level flagsys::wait_till("duplicaterender_registry_ready");
	/#
		assert(isdefined(self), "");
	#/
	if(newval == 0)
	{
		self notify(#"hash_1b32b83b");
		self.var_6c4eaf38 = undefined;
		self duplicate_render::change_dr_flags(localclientnum, undefined, "keyline_active,keyfill_active");
		self tmodesetflag(2);
	}
	else
	{
		self duplicate_render::change_dr_flags(localclientnum, "keyline_active", "keyfill_active");
		self.var_ac0e7241 = 1;
		self tmodeclearflag(2);
		if(!isdefined(self.var_6c4eaf38))
		{
			self.var_6c4eaf38 = 1;
			self thread function_537efcea(localclientnum);
		}
	}
}

/*
	Name: function_537efcea
	Namespace: oed
	Checksum: 0x67D6593E
	Offset: 0x1E00
	Size: 0x27A
	Parameters: 1
	Flags: Linked
*/
function function_537efcea(localclientnum)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	self endon(#"hash_1b32b83b");
	player = getlocalplayer(localclientnum);
	player endon(#"disconnect");
	player endon(#"entityshutdown");
	var_56f99f06 = 0;
	var_56f99f06 = getdvarfloat("interactivePromptNearToDist", 8.4);
	var_56f99f06 = var_56f99f06 * 39.37;
	while(true)
	{
		n_dist = distance(self.origin, player.origin);
		var_98b6ad82 = level flag::get("activate_thermal");
		var_d2ca8de = 0;
		if(n_dist <= 90 || n_dist > var_56f99f06 && self.var_ac0e7241 && !var_98b6ad82 && !var_d2ca8de || (var_98b6ad82 || var_d2ca8de && self.var_ac0e7241))
		{
			self duplicate_render::change_dr_flags(localclientnum, undefined, "keyline_active,keyfill_active");
			self tmodeclearflag(2);
			self.var_ac0e7241 = 0;
		}
		else if(n_dist > 90 && n_dist <= var_56f99f06 && !self.var_ac0e7241 && !var_98b6ad82 && !var_d2ca8de)
		{
			self duplicate_render::change_dr_flags(localclientnum, "keyline_active", "keyfill_active");
			self tmodesetflag(2);
			self.var_ac0e7241 = 1;
		}
		wait(0.016 * randomintrange(1, 10));
	}
}

