// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_vortex;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _zm_weap_gravityspikes;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_gravityspikes
	Checksum: 0xE822E63C
	Offset: 0x600
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_gravityspikes", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_gravityspikes
	Checksum: 0xE12EB5A0
	Offset: 0x640
	Size: 0x16A
	Parameters: 1
	Flags: Linked
*/
function __init__(localclientnum)
{
	register_clientfields();
	level._effect["gravityspikes_destroy"] = "electric/fx_elec_burst_lg_z270_os";
	level._effect["gravityspikes_location"] = "dlc1/castle/fx_weapon_gravityspike_location_glow";
	level._effect["gravityspikes_slam"] = "dlc1/zmb_weapon/fx_wpn_spike_grnd_hit";
	level._effect["gravityspikes_slam_1p"] = "dlc1/zmb_weapon/fx_wpn_spike_grnd_hit_1p";
	level._effect["gravityspikes_trap_start"] = "dlc1/zmb_weapon/fx_wpn_spike_trap_start";
	level._effect["gravityspikes_trap_loop"] = "dlc1/zmb_weapon/fx_wpn_spike_trap_loop";
	level._effect["gravityspikes_trap_end"] = "dlc1/zmb_weapon/fx_wpn_spike_trap_end";
	level._effect["gravity_trap_spike_spark"] = "dlc1/zmb_weapon/fx_wpn_spike_trap_handle_sparks";
	level._effect["zombie_sparky"] = "electric/fx_ability_elec_surge_short_robot_optim";
	level._effect["zombie_spark_light"] = "light/fx_light_spark_chest_zombie_optim";
	level._effect["zombie_spark_trail"] = "dlc1/zmb_weapon/fx_wpn_spike_torso_trail";
	level._effect["gravity_spike_zombie_explode"] = "dlc1/castle/fx_tesla_trap_body_exp";
}

/*
	Name: register_clientfields
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x6346DC69
	Offset: 0x7B8
	Size: 0x3AC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("actor", "gravity_slam_down", 1, 1, "int", &gravity_slam_down, 0, 0);
	clientfield::register("scriptmover", "gravity_trap_fx", 1, 1, "int", &gravity_trap_fx, 0, 0);
	clientfield::register("scriptmover", "gravity_trap_spike_spark", 1, 1, "int", &gravity_trap_spike_spark, 0, 0);
	clientfield::register("scriptmover", "gravity_trap_destroy", 1, 1, "counter", &gravity_trap_destroy, 0, 0);
	clientfield::register("scriptmover", "gravity_trap_location", 1, 1, "int", &gravity_trap_location, 0, 0);
	clientfield::register("scriptmover", "gravity_slam_fx", 1, 1, "int", &gravity_slam_fx, 0, 0);
	clientfield::register("toplayer", "gravity_slam_player_fx", 1, 1, "counter", &gravity_slam_player_fx, 0, 0);
	clientfield::register("actor", "sparky_beam_fx", 1, 1, "int", &play_sparky_beam_fx, 0, 0);
	clientfield::register("actor", "sparky_zombie_fx", 1, 1, "int", &sparky_zombie_fx_cb, 0, 0);
	clientfield::register("actor", "sparky_zombie_trail_fx", 1, 1, "int", &sparky_zombie_trail_fx_cb, 0, 0);
	clientfield::register("toplayer", "gravity_trap_rumble", 1, 1, "int", &gravity_trap_rumble_callback, 0, 0);
	clientfield::register("actor", "ragdoll_impact_watch", 1, 1, "int", &ragdoll_impact_watch_start, 0, 0);
	clientfield::register("actor", "gravity_spike_zombie_explode_fx", 12000, 1, "counter", &gravity_spike_zombie_explode, 1, 0);
}

/*
	Name: gravity_slam_down
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x591A9428
	Offset: 0xB70
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function gravity_slam_down(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self launchragdoll(vectorscale((0, 0, -1), 200));
	}
}

/*
	Name: gravity_slam_fx
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x6218FF3E
	Offset: 0xBE0
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function gravity_slam_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(isdefined(self.slam_fx))
		{
			deletefx(localclientnum, self.slam_fx, 1);
		}
		playfxontag(localclientnum, level._effect["gravityspikes_slam"], self, "tag_origin");
	}
}

/*
	Name: gravity_slam_player_fx
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x7DB97C2D
	Offset: 0xC90
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function gravity_slam_player_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxoncamera(localclientnum, level._effect["gravityspikes_slam_1p"]);
}

/*
	Name: gravity_trap_fx
	Namespace: _zm_weap_gravityspikes
	Checksum: 0xCA8DD46C
	Offset: 0xD00
	Size: 0x21C
	Parameters: 7
	Flags: Linked
*/
function gravity_trap_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.b_gravity_trap_fx = 1;
		if(!isdefined(level.a_mdl_gravity_traps))
		{
			level.a_mdl_gravity_traps = [];
		}
		if(!isinarray(level.a_mdl_gravity_traps, self))
		{
			if(!isdefined(level.a_mdl_gravity_traps))
			{
				level.a_mdl_gravity_traps = [];
			}
			else if(!isarray(level.a_mdl_gravity_traps))
			{
				level.a_mdl_gravity_traps = array(level.a_mdl_gravity_traps);
			}
			level.a_mdl_gravity_traps[level.a_mdl_gravity_traps.size] = self;
		}
		playfxontag(localclientnum, level._effect["gravityspikes_trap_start"], self, "tag_origin");
		wait(0.5);
		if(isdefined(self.b_gravity_trap_fx) && self.b_gravity_trap_fx)
		{
			self.n_gravity_trap_fx = playfxontag(localclientnum, level._effect["gravityspikes_trap_loop"], self, "tag_origin");
		}
	}
	else
	{
		self.b_gravity_trap_fx = undefined;
		if(isdefined(self.n_gravity_trap_fx))
		{
			deletefx(localclientnum, self.n_gravity_trap_fx, 1);
			self.n_gravity_trap_fx = undefined;
		}
		arrayremovevalue(level.a_mdl_gravity_traps, self);
		playfxontag(localclientnum, level._effect["gravityspikes_trap_end"], self, "tag_origin");
	}
}

/*
	Name: gravity_trap_spike_spark
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x48C09B13
	Offset: 0xF28
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function gravity_trap_spike_spark(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.spark_fx_id = playfxontag(localclientnum, level._effect["gravity_trap_spike_spark"], self, "tag_origin");
	}
	else if(isdefined(self.spark_fx_id))
	{
		deletefx(localclientnum, self.spark_fx_id, 1);
	}
}

/*
	Name: gravity_trap_location
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x2CCD10B
	Offset: 0xFE0
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function gravity_trap_location(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.fx_id_location = playfxontag(localclientnum, level._effect["gravityspikes_location"], self, "tag_origin");
	}
	else if(isdefined(self.fx_id_location))
	{
		deletefx(localclientnum, self.fx_id_location, 1);
		self.fx_id_location = undefined;
	}
}

/*
	Name: gravity_trap_destroy
	Namespace: _zm_weap_gravityspikes
	Checksum: 0xEA3B047A
	Offset: 0x10A8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function gravity_trap_destroy(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfx(localclientnum, level._effect["gravityspikes_destroy"], self.origin);
}

/*
	Name: ragdoll_impact_watch_start
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x934A3215
	Offset: 0x1120
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function ragdoll_impact_watch_start(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self thread ragdoll_impact_watch(localclientnum);
	}
}

/*
	Name: ragdoll_impact_watch
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x5BC9D5E4
	Offset: 0x1190
	Size: 0x220
	Parameters: 1
	Flags: Linked
*/
function ragdoll_impact_watch(localclientnum)
{
	self endon(#"entityshutdown");
	self.v_start_pos = self.origin;
	n_wait_time = 0.05;
	n_gib_speed = 20;
	v_prev_origin = self.origin;
	waitrealtime(n_wait_time);
	v_prev_vel = self.origin - v_prev_origin;
	n_prev_speed = length(v_prev_vel);
	v_prev_origin = self.origin;
	waitrealtime(n_wait_time);
	b_first_loop = 1;
	while(true)
	{
		v_vel = self.origin - v_prev_origin;
		n_speed = length(v_vel);
		if(n_speed < (n_prev_speed * 0.5) && n_speed <= n_gib_speed && !b_first_loop)
		{
			if(self.origin[2] > (self.v_start_pos[2] + 128))
			{
				if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
				{
					playfx(localclientnum, level._effect["zombie_guts_explosion"], self.origin, anglestoforward(self.angles));
				}
				self hide();
			}
			break;
		}
		v_prev_origin = self.origin;
		n_prev_speed = n_speed;
		b_first_loop = 0;
		waitrealtime(n_wait_time);
	}
}

/*
	Name: gravity_trap_rumble_callback
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x315BE581
	Offset: 0x13B8
	Size: 0x76
	Parameters: 7
	Flags: Linked
*/
function gravity_trap_rumble_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread gravity_trap_rumble(localclientnum);
	}
	else
	{
		self notify(#"vortex_stop");
	}
}

/*
	Name: gravity_trap_rumble
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x4D44DF4A
	Offset: 0x1438
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function gravity_trap_rumble(localclientnum)
{
	level endon(#"demo_jump");
	self endon(#"vortex_stop");
	self endon(#"death");
	while(isdefined(self))
	{
		self playrumbleonentity(localclientnum, "zod_idgun_vortex_interior");
		wait(0.075);
	}
}

/*
	Name: play_sparky_beam_fx
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x8AC5C11C
	Offset: 0x14A0
	Size: 0x15C
	Parameters: 7
	Flags: Linked
*/
function play_sparky_beam_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		ai_zombie = self;
		a_sparky_tags = array("J_Spine4", "J_SpineUpper", "J_Spine1");
		str_tag = array::random(a_sparky_tags);
		if(isdefined(level.a_mdl_gravity_traps))
		{
			mdl_gravity_trap = arraygetclosest(self.origin, level.a_mdl_gravity_traps);
		}
		if(isdefined(mdl_gravity_trap))
		{
			self.e_sparky_beam = beamlaunch(localclientnum, mdl_gravity_trap, "tag_origin", ai_zombie, str_tag, "electric_arc_sm_tesla_beam_pap");
		}
	}
	else if(isdefined(self.e_sparky_beam))
	{
		beamkill(localclientnum, self.e_sparky_beam);
	}
}

/*
	Name: sparky_zombie_fx_cb
	Namespace: _zm_weap_gravityspikes
	Checksum: 0x7E4983FC
	Offset: 0x1608
	Size: 0x16E
	Parameters: 7
	Flags: Linked
*/
function sparky_zombie_fx_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(!isdefined(self.sparky_loop_snd))
		{
			self.sparky_loop_snd = self playloopsound("zmb_electrozomb_lp", 0.2);
		}
		self.n_sparky_fx = playfxontag(localclientnum, level._effect["zombie_sparky"], self, "J_SpineUpper");
		setfxignorepause(localclientnum, self.n_sparky_fx, 1);
		self.n_sparky_fx = playfxontag(localclientnum, level._effect["zombie_spark_light"], self, "J_SpineUpper");
		setfxignorepause(localclientnum, self.n_sparky_fx, 1);
	}
	else
	{
		if(isdefined(self.n_sparky_fx))
		{
			deletefx(localclientnum, self.n_sparky_fx, 1);
		}
		self.n_sparky_fx = undefined;
	}
}

/*
	Name: sparky_zombie_trail_fx_cb
	Namespace: _zm_weap_gravityspikes
	Checksum: 0xCF7CB4AF
	Offset: 0x1780
	Size: 0xDE
	Parameters: 7
	Flags: Linked
*/
function sparky_zombie_trail_fx_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.n_trail_fx = playfxontag(localclientnum, level._effect["zombie_spark_trail"], self, "J_SpineUpper");
		setfxignorepause(localclientnum, self.n_trail_fx, 1);
	}
	else
	{
		if(isdefined(self.n_trail_fx))
		{
			deletefx(localclientnum, self.n_trail_fx, 1);
		}
		self.n_trail_fx = undefined;
	}
}

/*
	Name: gravity_spike_zombie_explode
	Namespace: _zm_weap_gravityspikes
	Checksum: 0xCBEFB715
	Offset: 0x1868
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function gravity_spike_zombie_explode(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	playfxontag(localclientnum, level._effect["gravity_spike_zombie_explode"], self, "j_spine4");
}

