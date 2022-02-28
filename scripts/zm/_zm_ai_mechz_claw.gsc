// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\mechz;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\_zm_zonemgr;

#using_animtree("mechz_claw");

#namespace zm_ai_mechz_claw;

/*
	Name: __init__sytem__
	Namespace: zm_ai_mechz_claw
	Checksum: 0x9EC616A5
	Offset: 0x8A0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_mechz_claw", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_mechz_claw
	Checksum: 0x31EF4976
	Offset: 0x8E8
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	function_f20c04a4();
	spawner::add_archetype_spawn_function("mechz", &function_1aacf7d4);
	level.mechz_claw_cooldown_time = 7000;
	level.mechz_left_arm_damage_callback = &function_671deda5;
	level.mechz_explosive_damage_reaction_callback = &function_6028875a;
	level.mechz_powercap_destroyed_callback = &function_d6f31ed2;
	level flag::init("mechz_launching_claw");
	level flag::init("mechz_claw_move_complete");
	clientfield::register("actor", "mechz_fx", 21000, 12, "int");
	clientfield::register("scriptmover", "mechz_claw", 21000, 1, "int");
	clientfield::register("actor", "mechz_wpn_source", 21000, 1, "int");
	clientfield::register("toplayer", "mechz_grab", 21000, 1, "int");
}

/*
	Name: __main__
	Namespace: zm_ai_mechz_claw
	Checksum: 0x99EC1590
	Offset: 0xA80
	Size: 0x4
	Parameters: 0
	Flags: Linked, Private
*/
function private __main__()
{
}

/*
	Name: function_f20c04a4
	Namespace: zm_ai_mechz_claw
	Checksum: 0xFBFB3FD1
	Offset: 0xA90
	Size: 0x164
	Parameters: 0
	Flags: Linked, Private
*/
function private function_f20c04a4()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMechzShouldShootClaw", &function_bdc90f38);
	behaviortreenetworkutility::registerbehaviortreeaction("zmMechzShootClawAction", &function_86ac6346, &function_a94df749, &function_1b118e5);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMechzShootClaw", &function_456e76fa);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMechzUpdateClaw", &function_a844c266);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMechzStopClaw", &function_75278fab);
	animationstatenetwork::registernotetrackhandlerfunction("muzzleflash", &function_de3abdba);
	animationstatenetwork::registernotetrackhandlerfunction("start_ft", &function_48c03479);
	animationstatenetwork::registernotetrackhandlerfunction("stop_ft", &function_235008e3);
}

/*
	Name: function_bdc90f38
	Namespace: zm_ai_mechz_claw
	Checksum: 0x907B18C3
	Offset: 0xC00
	Size: 0x2B2
	Parameters: 1
	Flags: Linked, Private
*/
function private function_bdc90f38(entity)
{
	if(!isdefined(entity.favoriteenemy))
	{
		return false;
	}
	if(!(isdefined(entity.has_powercap) && entity.has_powercap))
	{
		return false;
	}
	if(isdefined(entity.last_claw_time) && (gettime() - self.last_claw_time) < level.mechz_claw_cooldown_time)
	{
		return false;
	}
	if(isdefined(entity.berserk) && entity.berserk)
	{
		return false;
	}
	if(!entity mechzserverutils::mechzcheckinarc())
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 40000 || dist_sq > 1000000)
	{
		return false;
	}
	if(!entity.favoriteenemy player_can_be_grabbed())
	{
		return false;
	}
	curr_zone = zm_zonemgr::get_zone_from_position(self.origin + vectorscale((0, 0, 1), 36));
	if(isdefined(curr_zone) && "ug_bottom_zone" == curr_zone)
	{
		return false;
	}
	clip_mask = 1 | 8;
	claw_origin = entity.origin + vectorscale((0, 0, 1), 65);
	trace = physicstrace(claw_origin, entity.favoriteenemy.origin + vectorscale((0, 0, 1), 30), (-15, -15, -20), (15, 15, 40), entity, clip_mask);
	b_cansee = trace["fraction"] == 1 || (isdefined(trace["entity"]) && trace["entity"] == entity.favoriteenemy);
	if(!b_cansee)
	{
		return false;
	}
}

/*
	Name: player_can_be_grabbed
	Namespace: zm_ai_mechz_claw
	Checksum: 0xB0E1850E
	Offset: 0xEC0
	Size: 0x4E
	Parameters: 0
	Flags: Linked, Private
*/
function private player_can_be_grabbed()
{
	if(self getstance() == "prone")
	{
		return false;
	}
	if(!zm_utility::is_player_valid(self))
	{
		return false;
	}
	return true;
}

/*
	Name: function_86ac6346
	Namespace: zm_ai_mechz_claw
	Checksum: 0x352735E5
	Offset: 0xF18
	Size: 0x48
	Parameters: 2
	Flags: Linked, Private
*/
function private function_86ac6346(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	function_456e76fa(entity);
	return 5;
}

/*
	Name: function_a94df749
	Namespace: zm_ai_mechz_claw
	Checksum: 0xFFB16407
	Offset: 0xF68
	Size: 0x44
	Parameters: 2
	Flags: Linked, Private
*/
function private function_a94df749(entity, asmstatename)
{
	if(!(isdefined(entity.var_7bee990f) && entity.var_7bee990f))
	{
		return 4;
	}
	return 5;
}

/*
	Name: function_1b118e5
	Namespace: zm_ai_mechz_claw
	Checksum: 0x9CF512EF
	Offset: 0xFB8
	Size: 0x18
	Parameters: 2
	Flags: Linked, Private
*/
function private function_1b118e5(entity, asmstatename)
{
	return 4;
}

/*
	Name: function_456e76fa
	Namespace: zm_ai_mechz_claw
	Checksum: 0xA327E930
	Offset: 0xFD8
	Size: 0x44
	Parameters: 1
	Flags: Linked, Private
*/
function private function_456e76fa(entity)
{
	self thread function_31c4b972();
	level flag::set("mechz_launching_claw");
}

/*
	Name: function_a844c266
	Namespace: zm_ai_mechz_claw
	Checksum: 0x2FFBD5C6
	Offset: 0x1028
	Size: 0xC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_a844c266(entity)
{
}

/*
	Name: function_75278fab
	Namespace: zm_ai_mechz_claw
	Checksum: 0x5B9513E3
	Offset: 0x1040
	Size: 0xC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_75278fab(entity)
{
}

/*
	Name: function_de3abdba
	Namespace: zm_ai_mechz_claw
	Checksum: 0x8D09ACA8
	Offset: 0x1058
	Size: 0x60
	Parameters: 1
	Flags: Linked, Private
*/
function private function_de3abdba(entity)
{
	self.var_7bee990f = 1;
	self.last_claw_time = gettime();
	entity function_672f9804();
	entity function_90832db7();
	self.last_claw_time = gettime();
}

/*
	Name: function_48c03479
	Namespace: zm_ai_mechz_claw
	Checksum: 0x4E70C510
	Offset: 0x10C0
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private function_48c03479(entity)
{
	entity notify(#"hash_8225d137");
	entity clientfield::set("mechz_ft", 1);
	entity.isshootingflame = 1;
	entity thread function_fa513ca0();
}

/*
	Name: function_fa513ca0
	Namespace: zm_ai_mechz_claw
	Checksum: 0xC2AC5BEF
	Offset: 0x1130
	Size: 0x118
	Parameters: 0
	Flags: Linked, Private
*/
function private function_fa513ca0()
{
	self endon(#"death");
	self endon(#"hash_8225d137");
	while(true)
	{
		players = getplayers();
		foreach(player in players)
		{
			if(!(isdefined(player.is_burning) && player.is_burning))
			{
				if(player istouching(self.flametrigger))
				{
					player thread mechzbehavior::playerflamedamage(self);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_235008e3
	Namespace: zm_ai_mechz_claw
	Checksum: 0xFF08A825
	Offset: 0x1250
	Size: 0x72
	Parameters: 1
	Flags: Linked, Private
*/
function private function_235008e3(entity)
{
	entity notify(#"hash_8225d137");
	entity clientfield::set("mechz_ft", 0);
	entity.isshootingflame = 0;
	entity.nextflametime = gettime() + 7500;
	entity.stopshootingflametime = undefined;
}

/*
	Name: function_1aacf7d4
	Namespace: zm_ai_mechz_claw
	Checksum: 0xD1A9ED74
	Offset: 0x12D0
	Size: 0x2EC
	Parameters: 0
	Flags: Linked, Private
*/
function private function_1aacf7d4()
{
	if(isdefined(self.m_claw))
	{
		self.m_claw delete();
		self.m_claw = undefined;
	}
	self.fx_field = 0;
	org = self gettagorigin("tag_claw");
	ang = self gettagangles("tag_claw");
	self.m_claw = spawn("script_model", org);
	self.m_claw setmodel("c_t7_zm_dlchd_origins_mech_claw");
	self.m_claw.angles = ang;
	self.m_claw linkto(self, "tag_claw");
	self.m_claw useanimtree($mechz_claw);
	if(isdefined(self.m_claw_damage_trigger))
	{
		self.m_claw_damage_trigger unlink();
		self.m_claw_damage_trigger delete();
		self.m_claw_damage_trigger = undefined;
	}
	trigger_spawnflags = 0;
	trigger_radius = 3;
	trigger_height = 15;
	self.m_claw_damage_trigger = spawn("script_model", org);
	self.m_claw_damage_trigger setmodel("p7_chemistry_kit_large_bottle");
	ang = combineangles(vectorscale((-1, 0, 0), 90), ang);
	self.m_claw_damage_trigger.angles = ang;
	self.m_claw_damage_trigger hide();
	self.m_claw_damage_trigger setcandamage(1);
	self.m_claw_damage_trigger.health = 10000;
	self.m_claw_damage_trigger enablelinkto();
	self.m_claw_damage_trigger linkto(self, "tag_claw");
	self thread function_5dfc412a();
	self hidepart("tag_claw");
}

/*
	Name: function_5dfc412a
	Namespace: zm_ai_mechz_claw
	Checksum: 0x34E549BA
	Offset: 0x15C8
	Size: 0x166
	Parameters: 0
	Flags: Linked, Private
*/
function private function_5dfc412a()
{
	self endon(#"death");
	self.m_claw_damage_trigger endon(#"death");
	while(true)
	{
		self.m_claw_damage_trigger waittill(#"damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weaponname, idflags);
		self.m_claw_damage_trigger.health = 10000;
		if(self.m_claw islinkedto(self))
		{
			continue;
		}
		if(zm_utility::is_player_valid(inflictor))
		{
			self dodamage(1, inflictor.origin, inflictor, inflictor, "left_hand", type);
			self.m_claw setcandamage(0);
			self notify(#"claw_damaged");
		}
	}
}

/*
	Name: function_31c4b972
	Namespace: zm_ai_mechz_claw
	Checksum: 0x4AB73000
	Offset: 0x1738
	Size: 0x4C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_31c4b972()
{
	self endon(#"claw_complete");
	self util::waittill_either("death", "kill_claw");
	self function_90832db7();
}

/*
	Name: function_90832db7
	Namespace: zm_ai_mechz_claw
	Checksum: 0x3488FB5D
	Offset: 0x1790
	Size: 0x3C4
	Parameters: 0
	Flags: Linked, Private
*/
function private function_90832db7()
{
	self.fx_field = self.fx_field & (~256);
	self.fx_field = self.fx_field & (~64);
	self clientfield::set("mechz_fx", self.fx_field);
	self function_9bfd96c8();
	if(isdefined(self.m_claw))
	{
		self.m_claw clearanim(%mechz_claw::root, 0.2);
		if(isdefined(self.m_claw.fx_ent))
		{
			self.m_claw.fx_ent delete();
			self.m_claw.fx_ent = undefined;
		}
		if(!(isdefined(self.has_powercap) && self.has_powercap))
		{
			self function_4208b4ec();
			level flag::clear("mechz_launching_claw");
		}
		else
		{
			if(!self.m_claw islinkedto(self))
			{
				v_claw_origin = self gettagorigin("tag_claw");
				v_claw_angles = self gettagangles("tag_claw");
				n_dist = distance(self.m_claw.origin, v_claw_origin);
				n_time = n_dist / 1000;
				self.m_claw moveto(v_claw_origin, max(0.05, n_time));
				self.m_claw playloopsound("zmb_ai_mechz_claw_loop_in", 0.1);
				self.m_claw waittill(#"movedone");
				v_claw_origin = self gettagorigin("tag_claw");
				v_claw_angles = self gettagangles("tag_claw");
				self.m_claw playsound("zmb_ai_mechz_claw_back");
				self.m_claw stoploopsound(1);
				self.m_claw.origin = v_claw_origin;
				self.m_claw.angles = v_claw_angles;
				self.m_claw clearanim(%mechz_claw::root, 0.2);
				self.m_claw linkto(self, "tag_claw", (0, 0, 0));
			}
			self.m_claw setanim(%mechz_claw::ai_zombie_mech_grapple_arm_closed_idle, 1, 0.2, 1);
		}
	}
	self notify(#"claw_complete");
	self.var_7bee990f = 0;
}

/*
	Name: function_4208b4ec
	Namespace: zm_ai_mechz_claw
	Checksum: 0xC95B0CC8
	Offset: 0x1B60
	Size: 0x136
	Parameters: 0
	Flags: Linked, Private
*/
function private function_4208b4ec()
{
	if(isdefined(self.m_claw))
	{
		self.m_claw setanim(%mechz_claw::ai_zombie_mech_grapple_arm_open_idle, 1, 0.2, 1);
		if(isdefined(self.m_claw.fx_ent))
		{
			self.m_claw.fx_ent delete();
		}
		self.m_claw unlink();
		self.m_claw physicslaunch(self.m_claw.origin, (0, 0, -1));
		self.m_claw thread function_36db86b();
		self.m_claw = undefined;
	}
	if(isdefined(self.m_claw_damage_trigger))
	{
		self.m_claw_damage_trigger unlink();
		self.m_claw_damage_trigger delete();
		self.m_claw_damage_trigger = undefined;
	}
}

/*
	Name: function_36db86b
	Namespace: zm_ai_mechz_claw
	Checksum: 0x170A4A0C
	Offset: 0x1CA0
	Size: 0x1C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_36db86b()
{
	wait(30);
	self delete();
}

/*
	Name: function_9bfd96c8
	Namespace: zm_ai_mechz_claw
	Checksum: 0x3726CB94
	Offset: 0x1CC8
	Size: 0x1DC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_9bfd96c8(bopenclaw)
{
	self.explosive_dmg_taken_on_grab_start = undefined;
	if(isdefined(self.e_grabbed))
	{
		if(isplayer(self.e_grabbed))
		{
			self.e_grabbed clientfield::set_to_player("mechz_grab", 0);
			self.e_grabbed allowcrouch(1);
			self.e_grabbed allowprone(1);
		}
		if(!isdefined(self.e_grabbed._fall_down_anchor))
		{
			trace_start = self.e_grabbed.origin + vectorscale((0, 0, 1), 70);
			trace_end = self.e_grabbed.origin + (vectorscale((0, 0, -1), 500));
			drop_trace = playerphysicstrace(trace_start, trace_end) + vectorscale((0, 0, 1), 24);
			self.e_grabbed unlink();
			self.e_grabbed setorigin(drop_trace);
		}
		self.e_grabbed = undefined;
		if(isdefined(bopenclaw) && bopenclaw)
		{
			self.m_claw setanim(%mechz_claw::ai_zombie_mech_grapple_arm_open_idle, 1, 0.2, 1);
		}
	}
}

/*
	Name: function_7c33f4fb
	Namespace: zm_ai_mechz_claw
	Checksum: 0x821DF5F5
	Offset: 0x1EB0
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_7c33f4fb()
{
	if(!isdefined(self.explosive_dmg_taken))
	{
		self.explosive_dmg_taken = 0;
	}
	self.explosive_dmg_taken_on_grab_start = self.explosive_dmg_taken;
}

/*
	Name: function_d6f31ed2
	Namespace: zm_ai_mechz_claw
	Checksum: 0x941D14BB
	Offset: 0x1EE8
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_d6f31ed2()
{
	self mechzserverutils::hide_part("tag_claw");
	self.m_claw hide();
}

/*
	Name: function_5f5eaf3a
	Namespace: zm_ai_mechz_claw
	Checksum: 0xA7799255
	Offset: 0x1F30
	Size: 0xAC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_5f5eaf3a(ai_mechz)
{
	self endon(#"disconnect");
	self zm_audio::create_and_play_dialog("general", "mech_grab");
	while(isdefined(self) && (isdefined(self.isspeaking) && self.isspeaking))
	{
		wait(0.1);
	}
	wait(1);
	if(isalive(ai_mechz) && isdefined(ai_mechz.e_grabbed))
	{
		ai_mechz thread play_shoot_arm_hint_vo();
	}
}

/*
	Name: play_shoot_arm_hint_vo
	Namespace: zm_ai_mechz_claw
	Checksum: 0xBA759057
	Offset: 0x1FE8
	Size: 0x188
	Parameters: 0
	Flags: Linked, Private
*/
function private play_shoot_arm_hint_vo()
{
	self endon(#"death");
	while(true)
	{
		if(!isdefined(self.e_grabbed))
		{
			return;
		}
		a_players = getplayers();
		foreach(player in a_players)
		{
			if(player == self.e_grabbed)
			{
				continue;
			}
			if(distancesquared(self.origin, player.origin) < 1000000)
			{
				if(player util::is_player_looking_at(self.origin + vectorscale((0, 0, 1), 60), 0.75))
				{
					if(!(isdefined(player.dontspeak) && player.dontspeak))
					{
						player zm_audio::create_and_play_dialog("general", "shoot_mech_arm");
						return;
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_671deda5
	Namespace: zm_ai_mechz_claw
	Checksum: 0x75701F2F
	Offset: 0x2178
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_671deda5()
{
	if(isdefined(self.e_grabbed))
	{
		self thread function_9bfd96c8(1);
	}
}

/*
	Name: function_6028875a
	Namespace: zm_ai_mechz_claw
	Checksum: 0x34B66BA7
	Offset: 0x21B0
	Size: 0x5C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_6028875a()
{
	if(isdefined(self.explosive_dmg_taken_on_grab_start))
	{
		if(isdefined(self.e_grabbed) && (self.explosive_dmg_taken - self.explosive_dmg_taken_on_grab_start) > self.mechz_explosive_dmg_to_cancel_claw)
		{
			self.show_pain_from_explosive_dmg = 1;
			self thread function_9bfd96c8();
		}
	}
}

/*
	Name: function_8b0a73b5
	Namespace: zm_ai_mechz_claw
	Checksum: 0x169F6E1E
	Offset: 0x2218
	Size: 0x94
	Parameters: 1
	Flags: Linked, Private
*/
function private function_8b0a73b5(mechz)
{
	self endon(#"death");
	self endon(#"disconnect");
	mechz endon(#"death");
	mechz endon(#"claw_complete");
	mechz endon(#"kill_claw");
	while(true)
	{
		if(isdefined(self) && self laststand::player_is_in_laststand())
		{
			mechz thread function_9bfd96c8();
			return;
		}
		wait(0.05);
	}
}

/*
	Name: function_bed84b4
	Namespace: zm_ai_mechz_claw
	Checksum: 0xE32C1EFF
	Offset: 0x22B8
	Size: 0x92
	Parameters: 1
	Flags: Linked, Private
*/
function private function_bed84b4(mechz)
{
	self endon(#"death");
	self endon(#"disconnect");
	mechz endon(#"death");
	mechz endon(#"claw_complete");
	mechz endon(#"kill_claw");
	while(true)
	{
		self waittill(#"bgb_activation_request");
		if(isdefined(self) && self.bgb === "zm_bgb_anywhere_but_here")
		{
			mechz thread function_9bfd96c8();
			return;
		}
	}
}

/*
	Name: function_38d105a4
	Namespace: zm_ai_mechz_claw
	Checksum: 0xF69E84FF
	Offset: 0x2358
	Size: 0x7A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_38d105a4(mechz)
{
	self endon(#"death");
	self endon(#"disconnect");
	mechz endon(#"death");
	mechz endon(#"claw_complete");
	mechz endon(#"kill_claw");
	if(1)
	{
		self waittill(#"hash_e2be4752");
		mechz thread function_9bfd96c8();
		return;
	}
}

/*
	Name: function_672f9804
	Namespace: zm_ai_mechz_claw
	Checksum: 0xF302A04C
	Offset: 0x23E0
	Size: 0xE4C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_672f9804()
{
	self endon(#"death");
	self endon(#"kill_claw");
	if(!isdefined(self.favoriteenemy))
	{
		return;
	}
	v_claw_origin = self gettagorigin("tag_claw");
	v_claw_angles = vectortoangles(self.origin - self.favoriteenemy.origin);
	self.fx_field = self.fx_field | 256;
	self clientfield::set("mechz_fx", self.fx_field);
	self.m_claw setanim(%mechz_claw::ai_zombie_mech_grapple_arm_open_idle, 1, 0, 1);
	self.m_claw unlink();
	self.m_claw.fx_ent = spawn("script_model", self.m_claw gettagorigin("tag_claw"));
	self.m_claw.fx_ent.angles = self.m_claw gettagangles("tag_claw");
	self.m_claw.fx_ent setmodel("tag_origin");
	self.m_claw.fx_ent linkto(self.m_claw, "tag_claw");
	self.m_claw.fx_ent clientfield::set("mechz_claw", 1);
	self clientfield::set("mechz_wpn_source", 1);
	v_enemy_origin = self.favoriteenemy.origin + vectorscale((0, 0, 1), 36);
	n_dist = distance(v_claw_origin, v_enemy_origin);
	n_time = n_dist / 1200;
	self playsound("zmb_ai_mechz_claw_fire");
	self.m_claw moveto(v_enemy_origin, n_time);
	self.m_claw thread function_2998f2a1();
	self.m_claw playloopsound("zmb_ai_mechz_claw_loop_out", 0.1);
	self.e_grabbed = undefined;
	do
	{
		a_players = getplayers();
		foreach(player in a_players)
		{
			if(!zm_utility::is_player_valid(player, 1, 1) || !player player_can_be_grabbed())
			{
				continue;
			}
			n_dist_sq = distancesquared(player.origin + vectorscale((0, 0, 1), 36), self.m_claw.origin);
			if(n_dist_sq < 2304)
			{
				clip_mask = 1 | 8;
				var_7d76644b = self.origin + vectorscale((0, 0, 1), 65);
				trace = physicstrace(var_7d76644b, player.origin + vectorscale((0, 0, 1), 30), (-15, -15, -20), (15, 15, 40), self, clip_mask);
				b_cansee = trace["fraction"] == 1 || (isdefined(trace["entity"]) && trace["entity"] == player);
				if(!b_cansee)
				{
					continue;
				}
				if(isdefined(player.hasriotshield) && player.hasriotshield && (isdefined(player.hasriotshieldequipped) && player.hasriotshieldequipped))
				{
					shield_dmg = level.zombie_vars["riotshield_hit_points"];
					player riotshield::player_damage_shield(shield_dmg - 1, 1);
					wait(1);
					player riotshield::player_damage_shield(1, 1);
				}
				else
				{
					self.e_grabbed = player;
					self.e_grabbed clientfield::set_to_player("mechz_grab", 1);
					self.e_grabbed playerlinktodelta(self.m_claw, "tag_attach_player");
					self.e_grabbed setplayerangles(vectortoangles(self.origin - self.e_grabbed.origin));
					self.e_grabbed playsound("zmb_ai_mechz_claw_grab");
					self.e_grabbed setstance("stand");
					self.e_grabbed allowcrouch(0);
					self.e_grabbed allowprone(0);
					self.e_grabbed thread function_5f5eaf3a(self);
					self.e_grabbed thread function_bed84b4(self);
					self.e_grabbed thread function_38d105a4(self);
					if(!level flag::get("mechz_claw_move_complete"))
					{
						self.m_claw moveto(self.m_claw.origin, 0.05);
					}
				}
				break;
			}
		}
		wait(0.05);
	}
	while(!level flag::get("mechz_claw_move_complete") && !isdefined(self.e_grabbed));
	if(!isdefined(self.e_grabbed))
	{
		a_ai_zombies = zombie_utility::get_round_enemy_array();
		foreach(ai_zombie in a_ai_zombies)
		{
			if(!isalive(ai_zombie) || (isdefined(ai_zombie.is_giant_robot) && ai_zombie.is_giant_robot) || (isdefined(ai_zombie.is_mechz) && ai_zombie.is_mechz))
			{
				continue;
			}
			n_dist_sq = distancesquared(ai_zombie.origin + vectorscale((0, 0, 1), 36), self.m_claw.origin);
			if(n_dist_sq < 2304)
			{
				self.e_grabbed = ai_zombie;
				self.e_grabbed linkto(self.m_claw, "tag_attach_player", (0, 0, 0));
				self.e_grabbed.mechz_grabbed_by = self;
				break;
			}
		}
	}
	self.m_claw clearanim(%mechz_claw::root, 0.2);
	self.m_claw setanim(%mechz_claw::ai_zombie_mech_grapple_arm_closed_idle, 1, 0.2, 1);
	wait(0.5);
	if(isdefined(self.e_grabbed))
	{
		n_time = n_dist / 200;
	}
	else
	{
		n_time = n_dist / 1000;
	}
	self function_7c33f4fb();
	v_claw_origin = self gettagorigin("tag_claw");
	v_claw_angles = self gettagangles("tag_claw");
	self.m_claw moveto(v_claw_origin, max(0.05, n_time));
	self.m_claw playloopsound("zmb_ai_mechz_claw_loop_in", 0.1);
	self.m_claw waittill(#"movedone");
	v_claw_origin = self gettagorigin("tag_claw");
	v_claw_angles = self gettagangles("tag_claw");
	self.m_claw playsound("zmb_ai_mechz_claw_back");
	self.m_claw stoploopsound(1);
	if(zm_audio::sndisnetworksafe())
	{
		self playsound("zmb_ai_mechz_vox_angry");
	}
	self.m_claw.origin = v_claw_origin;
	self.m_claw.angles = v_claw_angles;
	self.m_claw clearanim(%mechz_claw::root, 0.2);
	self.m_claw linkto(self, "tag_claw", (0, 0, 0));
	self.m_claw setanim(%mechz_claw::ai_zombie_mech_grapple_arm_closed_idle, 1, 0.2, 1);
	self.m_claw.fx_ent delete();
	self.m_claw.fx_ent = undefined;
	self.fx_field = self.fx_field & (~256);
	self clientfield::set("mechz_fx", self.fx_field);
	self clientfield::set("mechz_wpn_source", 0);
	level flag::clear("mechz_launching_claw");
	if(isdefined(self.e_grabbed))
	{
		if(isplayer(self.e_grabbed) && zm_utility::is_player_valid(self.e_grabbed))
		{
			self.e_grabbed thread function_8b0a73b5(self);
		}
		else if(isai(self.e_grabbed))
		{
			self.e_grabbed thread function_860f0461(self);
		}
		self thread function_eb9df173(self.e_grabbed);
		self animscripted("flamethrower_anim", self.origin, self.angles, "ai_zombie_mech_ft_burn_player");
		self zombie_shared::donotetracks("flamethrower_anim");
	}
	level flag::clear("mechz_claw_move_complete");
}

/*
	Name: function_eb9df173
	Namespace: zm_ai_mechz_claw
	Checksum: 0x96078390
	Offset: 0x3238
	Size: 0x1AA
	Parameters: 1
	Flags: Linked, Private
*/
function private function_eb9df173(player)
{
	player endon(#"death");
	player endon(#"disconnect");
	self endon(#"death");
	self endon(#"claw_complete");
	self endon(#"kill_claw");
	self thread function_7792d05e(player);
	player thread function_d0e280a0(self);
	self.m_claw setcandamage(1);
	while(isdefined(self.e_grabbed))
	{
		self.m_claw waittill(#"damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weaponname, idflags);
		if(zm_utility::is_player_valid(inflictor))
		{
			self dodamage(1, inflictor.origin, inflictor, inflictor, "left_hand", type);
			self.m_claw setcandamage(0);
			self notify(#"claw_damaged");
			break;
		}
	}
}

/*
	Name: function_7792d05e
	Namespace: zm_ai_mechz_claw
	Checksum: 0xD27C5750
	Offset: 0x33F0
	Size: 0x8C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_7792d05e(player)
{
	self endon(#"claw_damaged");
	player endon(#"death");
	player endon(#"disconnect");
	self util::waittill_any("death", "claw_complete", "kill_claw");
	if(isdefined(self) && isdefined(self.m_claw))
	{
		self.m_claw setcandamage(0);
	}
}

/*
	Name: function_d0e280a0
	Namespace: zm_ai_mechz_claw
	Checksum: 0xBB4AC903
	Offset: 0x3488
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_d0e280a0(mechz)
{
	mechz endon(#"claw_damaged");
	mechz endon(#"death");
	mechz endon(#"claw_complete");
	mechz endon(#"kill_claw");
	self util::waittill_any("death", "disconnect");
	if(isdefined(mechz) && isdefined(mechz.m_claw))
	{
		mechz.m_claw setcandamage(0);
	}
}

/*
	Name: function_2998f2a1
	Namespace: zm_ai_mechz_claw
	Checksum: 0x7FDF7C4B
	Offset: 0x3538
	Size: 0x34
	Parameters: 0
	Flags: Linked, Private
*/
function private function_2998f2a1()
{
	self waittill(#"movedone");
	wait(0.05);
	level flag::set("mechz_claw_move_complete");
}

/*
	Name: function_860f0461
	Namespace: zm_ai_mechz_claw
	Checksum: 0xB7441423
	Offset: 0x3578
	Size: 0x94
	Parameters: 1
	Flags: Linked, Private
*/
function private function_860f0461(mechz)
{
	mechz waittillmatch(#"flamethrower_anim");
	if(isalive(self))
	{
		self dodamage(self.health, self.origin, self);
		self zombie_utility::gib_random_parts();
		gibserverutils::annihilate(self);
	}
}

