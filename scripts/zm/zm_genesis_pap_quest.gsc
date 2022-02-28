// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_grappler;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_flingers;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_vo;

#namespace namespace_3ddd867f;

/*
	Name: __init__sytem__
	Namespace: namespace_3ddd867f
	Checksum: 0x37FBBDD6
	Offset: 0x5F8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_pap_quest", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_3ddd867f
	Checksum: 0x761E948E
	Offset: 0x640
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_e1ee8457 = 0;
	level.pack_a_punch.custom_power_think = &function_23a5b653;
	level.zombiemode_reusing_pack_a_punch = 1;
	scene::add_scene_func("p7_fxanim_zm_gen_apoth_pap_sac_arm_lft_bundle", &function_d2b266ee, "init");
	scene::add_scene_func("p7_fxanim_zm_gen_apoth_pap_sac_arm_cnt_bundle", &function_d2b266ee, "init");
	scene::add_scene_func("p7_fxanim_zm_gen_apoth_pap_sac_arm_rt_bundle", &function_d2b266ee, "init");
	scene::add_scene_func("p7_fxanim_zm_gen_apoth_pap_sac_bundle", &function_dc681bed, "init");
	level thread scene::init("p7_fxanim_zm_gen_apoth_pap_sac_arm_lft_bundle");
	level thread scene::init("p7_fxanim_zm_gen_apoth_pap_sac_arm_cnt_bundle");
	level thread scene::init("p7_fxanim_zm_gen_apoth_pap_sac_arm_rt_bundle");
	level thread scene::init("p7_fxanim_zm_gen_apoth_pap_sac_bundle");
}

/*
	Name: __main__
	Namespace: namespace_3ddd867f
	Checksum: 0xD1F43254
	Offset: 0x7C8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level flag::init("pap_power_on");
	level flag::init("apotho_pack_freed");
}

/*
	Name: function_23a5b653
	Namespace: namespace_3ddd867f
	Checksum: 0x27896673
	Offset: 0x818
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_23a5b653(powered_on)
{
	if(!powered_on)
	{
		self.zbarrier set_pap_zbarrier_state("initial");
		level flag::wait_till_all(array("power_on1", "power_on2", "power_on3", "power_on4"));
		self thread function_e488a6a8();
	}
	for(;;)
	{
		self.zbarrier set_pap_zbarrier_state("power_on");
		level waittill(#"pack_a_punch_off");
		self.zbarrier set_pap_zbarrier_state("power_off");
		level waittill(#"pack_a_punch_on");
	}
}

/*
	Name: set_pap_zbarrier_state
	Namespace: namespace_3ddd867f
	Checksum: 0xC8327104
	Offset: 0x910
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function set_pap_zbarrier_state(state)
{
	for(i = 0; i < self getnumzbarrierpieces(); i++)
	{
		self hidezbarrierpiece(i);
	}
	self notify(#"zbarrier_state_change");
	self [[level.pap_zbarrier_state_func]](state);
}

/*
	Name: function_8d5c3682
	Namespace: namespace_3ddd867f
	Checksum: 0x9B9675D9
	Offset: 0x998
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_8d5c3682()
{
	var_d1f5ed14 = getvehiclenodearray("pap_travel_spline", "targetname");
	array::thread_all(var_d1f5ed14, &function_21d887cd);
}

/*
	Name: function_21d887cd
	Namespace: namespace_3ddd867f
	Checksum: 0xF2DC44AA
	Offset: 0x9F8
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_21d887cd()
{
	/#
		assert(ispointonnavmesh(self.origin), ("" + self.origin) + "");
	#/
	s_stub = level zm_genesis_util::spawn_trigger_radius(self.origin, 256, undefined, &function_f8c1234b);
	while(true)
	{
		s_stub waittill(#"trigger", e_player);
		e_player thread function_4ab898f4(self);
		level.var_6fe80781 = gettime();
	}
}

/*
	Name: function_f8c1234b
	Namespace: namespace_3ddd867f
	Checksum: 0x4C310D41
	Offset: 0xAD8
	Size: 0x12
	Parameters: 1
	Flags: Linked
*/
function function_f8c1234b(e_player)
{
	return "";
}

/*
	Name: function_e8ef758e
	Namespace: namespace_3ddd867f
	Checksum: 0x853238E0
	Offset: 0xAF8
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_e8ef758e()
{
	if(!isdefined(level.apothicon_grapple_source))
	{
		level.apothicon_grapple_source = struct::get("apothicon_grapple_source");
	}
	if(!isdefined(level.apothicon_grapple_source))
	{
		level.apothicon_grapple_source = spawnstruct();
		level.apothicon_grapple_source.origin = (1894, -438, -127);
		level.apothicon_grapple_source.angles = vectorscale((0, 1, 0), 180);
		level.apothicon_grapple_source.targetname = "apothicon_grapple_source";
	}
	if(isdefined(level.apothicon_grapple_source))
	{
		e_player = self;
		e_player.var_c932472f = "j_spine4";
		if(!(isdefined(e_player.var_1533bb11) && e_player.var_1533bb11))
		{
			e_player.var_1533bb11 = 1;
			zm_grappler::start_grapple(level.apothicon_grapple_source, e_player, 2, 3300);
			e_player.var_1533bb11 = 0;
		}
	}
}

/*
	Name: function_4ab898f4
	Namespace: namespace_3ddd867f
	Checksum: 0x6288F18E
	Offset: 0xC50
	Size: 0x5FC
	Parameters: 1
	Flags: Linked
*/
function function_4ab898f4(nd_start)
{
	self endon(#"death");
	if(isdefined(self.is_flung) && self.is_flung)
	{
		return;
	}
	self.is_flung = 1;
	self.var_a393601c = 1;
	self function_e8ef758e();
	self.b_invulnerable = self enableinvulnerability();
	self allowcrouch(0);
	self allowprone(0);
	self freezecontrols(1);
	self notsolid();
	if(self getstance() != "stand")
	{
		self setstance("stand");
		wait(1);
	}
	var_413ea50f = vehicle::spawn(undefined, "player_vehicle", "flinger_vehicle", nd_start.origin, nd_start.angles);
	var_116e109f = struct::get(nd_start.target);
	var_f28a4a19 = var_116e109f function_fc804fdd();
	self playerlinktodelta(var_413ea50f);
	self playrumbleonentity("zm_castle_flinger_launch");
	self clientfield::set_to_player("apothicon_entry_postfx", 1);
	self thread zm_genesis_flingers::function_c1f1756a();
	var_6a7beeb2 = zm_genesis_flingers::function_cbac68fe(self);
	var_6a7beeb2 linkto(var_413ea50f);
	w_current = self.currentweapon;
	var_f5434f17 = zm_utility::spawn_buildkit_weapon_model(self, w_current, undefined, var_6a7beeb2 gettagorigin("tag_weapon_right"), var_6a7beeb2 gettagangles("tag_weapon_right"));
	var_f5434f17 linkto(var_6a7beeb2, "tag_weapon_right");
	var_f5434f17 setowner(self);
	var_6a7beeb2 thread scene::play("cin_zm_dlc1_jump_pad_air_loop", var_6a7beeb2);
	var_6a7beeb2 clientfield::set("player_visibility", 1);
	var_f5434f17 clientfield::set("player_visibility", 1);
	self ghost();
	var_413ea50f setignorepauseworld(1);
	var_413ea50f vehicle::get_on_and_go_path(nd_start);
	while(positionwouldtelefrag(var_f28a4a19.origin))
	{
		wait(0.05);
	}
	var_413ea50f vehicle::get_on_and_go_path(var_f28a4a19);
	self thread function_3298b25f();
	self thread zm_genesis_flingers::function_29c06608();
	self playrumbleonentity("zm_castle_flinger_land");
	self clientfield::set_to_player("apothicon_entry_postfx", 0);
	var_6a7beeb2 clientfield::set("player_visibility", 0);
	var_f5434f17 clientfield::set("player_visibility", 0);
	var_6a7beeb2 thread scene::stop("cin_zm_dlc1_jump_pad_air_loop");
	var_f5434f17 delete();
	self show();
	self solid();
	self thread zm_genesis_flingers::function_9f131b98();
	var_6a7beeb2 hide();
	util::wait_network_frame();
	var_6a7beeb2 delete();
	self thread function_10171438();
	self.is_flung = undefined;
	self thread cleanup_vehicle(var_413ea50f);
	wait(2);
	self allowcrouch(1);
	self allowprone(1);
	self freezecontrols(0);
}

/*
	Name: cleanup_vehicle
	Namespace: namespace_3ddd867f
	Checksum: 0xFB0D69CA
	Offset: 0x1258
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function cleanup_vehicle(var_413ea50f)
{
	while(true)
	{
		if(!isdefined(self) || (isdefined(self.var_3298b25f) && self.var_3298b25f))
		{
			break;
		}
		util::wait_network_frame();
	}
	var_413ea50f delete();
}

/*
	Name: function_10171438
	Namespace: namespace_3ddd867f
	Checksum: 0x84510305
	Offset: 0x12C8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_10171438()
{
	self endon(#"death");
	self endon(#"disconnect");
	wait(3);
	self.var_a393601c = 0;
}

/*
	Name: function_fc804fdd
	Namespace: namespace_3ddd867f
	Checksum: 0x9A878F7E
	Offset: 0x1300
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_fc804fdd(var_16caea3d)
{
	var_62a30970 = getvehiclenodearray(self.target, "targetname");
	foreach(nd_spline in var_62a30970)
	{
		if(nd_spline.script_noteworthy === var_16caea3d)
		{
			return nd_spline;
		}
	}
	/#
		assert(isdefined(nd_spline), ((("" + var_16caea3d) + "") + self.origin) + "");
	#/
}

/*
	Name: function_3298b25f
	Namespace: namespace_3ddd867f
	Checksum: 0x2C909673
	Offset: 0x1410
	Size: 0x168
	Parameters: 0
	Flags: Linked
*/
function function_3298b25f()
{
	self.var_3298b25f = 0;
	var_6b138e28 = groundtrace(self.origin, self.origin + (vectorscale((0, 0, -1), 10000)), 0, undefined)["position"];
	var_16f5c370 = var_6b138e28;
	while(positionwouldtelefrag(var_16f5c370) || !ispointonnavmesh(var_16f5c370))
	{
		util::wait_network_frame();
		var_16f5c370 = var_6b138e28 + (randomfloatrange(-96, 96), randomfloatrange(-96, 96), 0);
	}
	self unlink();
	self setorigin(var_16f5c370);
	self clientfield::increment_to_player("flinger_land_smash");
	self thread zm_genesis_vo::function_e1bf753b();
	self.var_3298b25f = 1;
}

/*
	Name: function_e488a6a8
	Namespace: namespace_3ddd867f
	Checksum: 0x983122DC
	Offset: 0x1580
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_e488a6a8()
{
	level flag::set("pap_power_on");
	level notify(#"pack_a_punch_on");
	self.origin = self.origin + vectorscale((0, 0, 1), 500);
	self.clip.origin = self.clip.origin + vectorscale((0, 0, 1), 500);
	self.pap_machine.origin = self.pap_machine.origin - vectorscale((0, 0, 1), 500);
	for(var_9748d143 = 0; var_9748d143 < 3; var_9748d143++)
	{
		level waittill(#"hash_80f97945");
	}
	level scene::play("p7_fxanim_zm_gen_apoth_pap_sac_bundle");
	playsoundatposition("evt_pap_freed", (873, 110, -3239));
	self.pap_machine.origin = self.pap_machine.origin + vectorscale((0, 0, 1), 500);
	level flag::set("apotho_pack_freed");
	self.origin = self.origin - vectorscale((0, 0, 1), 500);
	self.clip.origin = self.clip.origin - vectorscale((0, 0, 1), 500);
}

/*
	Name: function_9278bc8a
	Namespace: namespace_3ddd867f
	Checksum: 0xB9810E04
	Offset: 0x1758
	Size: 0x1F4
	Parameters: 1
	Flags: Linked
*/
function function_9278bc8a(var_181e2689)
{
	self setcandamage(1);
	self.health = 6000;
	self.n_damage = 0;
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction_vec, point, type, modelname, tagname, partname, weapon, idflags);
		playfx(level._effect["pap_cord_impact"], point, (0, 0, -1));
		self.n_damage = self.n_damage - damage;
		self.health = self.health + damage;
		if(self.n_damage <= 1000)
		{
			playsoundatposition("evt_pap_cord_burst", self.origin);
			self setcandamage(0);
			break;
		}
	}
	level notify(#"hash_80f97945");
	if(isplayer(attacker))
	{
		attacker thread zm_genesis_vo::function_57f3d77();
	}
	exploder::exploder("fxexp_" + (106 + var_181e2689));
	level thread scene::play(self.current_scene);
}

/*
	Name: function_d2b266ee
	Namespace: namespace_3ddd867f
	Checksum: 0x5352FBBB
	Offset: 0x1958
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function function_d2b266ee(a_ents)
{
	a_str_keys = getarraykeys(a_ents);
	str_key = a_str_keys[0];
	var_9f585353 = a_ents[str_key];
	switch(str_key)
	{
		case "pap_sac_lft_arm":
		{
			var_9f585353 thread function_9278bc8a(1);
			break;
		}
		case "pap_sac_cnt_arm":
		{
			var_9f585353 thread function_9278bc8a(2);
			break;
		}
		case "pap_sac_rt_arm":
		{
			var_9f585353 thread function_9278bc8a(3);
			break;
		}
	}
}

/*
	Name: function_dc681bed
	Namespace: namespace_3ddd867f
	Checksum: 0xB8151441
	Offset: 0x1A48
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_dc681bed(a_ents)
{
	var_de243c38 = a_ents["pap_sac_vending"];
	level waittill(#"apotho_pack_freed");
	wait(0.2);
	var_de243c38 delete();
}

