// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_quad;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_moon_ai_quad;

/*
	Name: init
	Namespace: zm_moon_ai_quad
	Checksum: 0xA925BFFA
	Offset: 0x620
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_e9b3dfb0();
	spawner::add_archetype_spawn_function("zombie_quad", &function_5076473f);
}

/*
	Name: function_e9b3dfb0
	Namespace: zm_moon_ai_quad
	Checksum: 0xA4112EB7
	Offset: 0x668
	Size: 0x174
	Parameters: 0
	Flags: Linked, Private
*/
function private function_e9b3dfb0()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("quadPhasingService", &quadphasingservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldPhase", &shouldphase);
	behaviortreenetworkutility::registerbehaviortreescriptapi("phaseActionStart", &phaseactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("phaseActionTerminate", &phaseactionterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("moonQuadKilledByMicrowaveGunDw", &killedbymicrowavegundw);
	behaviortreenetworkutility::registerbehaviortreescriptapi("moonQuadKilledByMicrowaveGun", &killedbymicrowavegun);
	animationstatenetwork::registernotetrackhandlerfunction("phase_start", &function_51ab54f7);
	animationstatenetwork::registernotetrackhandlerfunction("phase_end", &function_428f351c);
	animationstatenetwork::registeranimationmocomp("quad_phase", &function_4e0a671e, undefined, undefined);
}

/*
	Name: quadphasingservice
	Namespace: zm_moon_ai_quad
	Checksum: 0x500B30F7
	Offset: 0x7E8
	Size: 0x39C
	Parameters: 1
	Flags: Linked, Private
*/
function private quadphasingservice(entity)
{
	if(isdefined(entity.is_phasing) && entity.is_phasing)
	{
		return false;
	}
	entity.var_662afd11 = 0;
	if(entity.var_20535e44 == 0)
	{
		if(math::cointoss())
		{
			entity.var_3b07930a = "quad_phase_right";
		}
		else
		{
			entity.var_3b07930a = "quad_phase_left";
		}
	}
	else
	{
		if(entity.var_20535e44 == -1)
		{
			entity.var_3b07930a = "quad_phase_right";
		}
		else
		{
			entity.var_3b07930a = "quad_phase_left";
		}
	}
	if(entity.var_3b07930a == "quad_phase_left")
	{
		if(isplayer(entity.enemy) && entity.enemy islookingat(entity))
		{
			if(entity maymovefrompointtopoint(entity.origin, zombie_utility::getanimendpos(level.var_9fcbbc83["phase_left_long"])))
			{
				entity.var_662afd11 = 1;
			}
		}
	}
	else if(isplayer(entity.enemy) && entity.enemy islookingat(entity))
	{
		if(entity maymovefrompointtopoint(entity.origin, zombie_utility::getanimendpos(level.var_9fcbbc83["phase_right_long"])))
		{
			entity.var_662afd11 = 1;
		}
	}
	if(!(isdefined(entity.var_662afd11) && entity.var_662afd11))
	{
		if(entity maymovefrompointtopoint(entity.origin, zombie_utility::getanimendpos(level.var_9fcbbc83["phase_forward"])))
		{
			entity.var_662afd11 = 1;
			entity.var_3b07930a = "quad_phase_forward";
		}
	}
	if(isdefined(entity.var_662afd11) && entity.var_662afd11)
	{
		blackboard::setblackboardattribute(entity, "_quad_phase_direction", entity.var_3b07930a);
		if(math::cointoss())
		{
			blackboard::setblackboardattribute(entity, "_quad_phase_distance", "quad_phase_short");
		}
		else
		{
			blackboard::setblackboardattribute(entity, "_quad_phase_distance", "quad_phase_long");
		}
		return true;
	}
	return false;
}

/*
	Name: shouldphase
	Namespace: zm_moon_ai_quad
	Checksum: 0xB53C5092
	Offset: 0xB90
	Size: 0x22C
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldphase(entity)
{
	if(!(isdefined(entity.var_662afd11) && entity.var_662afd11))
	{
		return false;
	}
	if(isdefined(entity.is_phasing) && entity.is_phasing)
	{
		return false;
	}
	if((gettime() - entity.var_b7d765b3) < 2000)
	{
		return false;
	}
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.enemy.origin);
	min_dist_sq = 4096;
	max_dist_sq = 1000000;
	if(entity.var_3b07930a == "quad_phase_forward")
	{
		min_dist_sq = 14400;
		max_dist_sq = 5760000;
	}
	if(dist_sq < min_dist_sq)
	{
		return false;
	}
	if(dist_sq > max_dist_sq)
	{
		return false;
	}
	if(!isdefined(entity.pathgoalpos) || distancesquared(entity.origin, entity.pathgoalpos) < min_dist_sq)
	{
		return false;
	}
	if(abs(entity getmotionangle()) > 15)
	{
		return false;
	}
	yaw = zombie_utility::getyawtoorigin(entity.enemy.origin);
	if(abs(yaw) > 45)
	{
		return false;
	}
	return true;
}

/*
	Name: phaseactionstart
	Namespace: zm_moon_ai_quad
	Checksum: 0x7BC2833C
	Offset: 0xDC8
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private phaseactionstart(entity)
{
	entity.is_phasing = 1;
	if(entity.var_3b07930a == "quad_phase_left")
	{
		entity.var_20535e44--;
	}
	else if(entity.var_3b07930a == "quad_phase_right")
	{
		entity.var_20535e44++;
	}
}

/*
	Name: phaseactionterminate
	Namespace: zm_moon_ai_quad
	Checksum: 0x682F8065
	Offset: 0xE50
	Size: 0x2C
	Parameters: 1
	Flags: Linked, Private
*/
function private phaseactionterminate(entity)
{
	entity.var_b7d765b3 = gettime();
	entity.is_phasing = 0;
}

/*
	Name: killedbymicrowavegundw
	Namespace: zm_moon_ai_quad
	Checksum: 0xB4D12F1D
	Offset: 0xE88
	Size: 0x2E
	Parameters: 1
	Flags: Linked, Private
*/
function private killedbymicrowavegundw(entity)
{
	return isdefined(entity.microwavegun_dw_death) && entity.microwavegun_dw_death;
}

/*
	Name: killedbymicrowavegun
	Namespace: zm_moon_ai_quad
	Checksum: 0x4F24DC7B
	Offset: 0xEC0
	Size: 0x2E
	Parameters: 1
	Flags: Linked, Private
*/
function private killedbymicrowavegun(entity)
{
	return isdefined(entity.microwavegun_death) && entity.microwavegun_death;
}

/*
	Name: function_51ab54f7
	Namespace: zm_moon_ai_quad
	Checksum: 0x53349F2E
	Offset: 0xEF8
	Size: 0x44
	Parameters: 1
	Flags: Linked, Private
*/
function private function_51ab54f7(entity)
{
	entity thread moon_quad_phase_fx("quad_phasing_out");
	entity ghost();
}

/*
	Name: function_428f351c
	Namespace: zm_moon_ai_quad
	Checksum: 0xA29B838F
	Offset: 0xF48
	Size: 0x44
	Parameters: 1
	Flags: Linked, Private
*/
function private function_428f351c(entity)
{
	entity thread moon_quad_phase_fx("quad_phasing_in");
	entity show();
}

/*
	Name: function_4e0a671e
	Namespace: zm_moon_ai_quad
	Checksum: 0xE29D6AD6
	Offset: 0xF98
	Size: 0x4C
	Parameters: 5
	Flags: Linked, Private
*/
function private function_4e0a671e(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity animmode("gravity", 0);
}

/*
	Name: function_5076473f
	Namespace: zm_moon_ai_quad
	Checksum: 0x3C6524ED
	Offset: 0xFF0
	Size: 0x17E
	Parameters: 0
	Flags: Linked
*/
function function_5076473f()
{
	self.var_662afd11 = 0;
	self.var_b7d765b3 = gettime();
	self.var_20535e44 = 0;
	if(!isdefined(level.var_9fcbbc83))
	{
		level.var_9fcbbc83 = [];
		level.var_9fcbbc83["phase_forward"] = self animmappingsearch(istring("anim_zombie_phase_f_long_b"));
		level.var_9fcbbc83["phase_left_long"] = self animmappingsearch(istring("anim_zombie_phase_l_long_b"));
		level.var_9fcbbc83["phase_left_short"] = self animmappingsearch(istring("anim_zombie_phase_l_short_b"));
		level.var_9fcbbc83["phase_right_long"] = self animmappingsearch(istring("anim_zombie_phase_r_long_b"));
		level.var_9fcbbc83["phase_right_short"] = self animmappingsearch(istring("anim_zombie_phase_r_short_a"));
	}
}

/*
	Name: moon_quad_prespawn
	Namespace: zm_moon_ai_quad
	Checksum: 0x82F11BF4
	Offset: 0x1178
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function moon_quad_prespawn()
{
	self.no_gib = 1;
	self.zombie_can_sidestep = 1;
	self.zombie_can_forwardstep = 1;
	self.sidestepfunc = &moon_quad_sidestep;
	self.fastsprintfunc = &moon_quad_fastsprint;
}

/*
	Name: moon_quad_sidestep
	Namespace: zm_moon_ai_quad
	Checksum: 0x498F4AD1
	Offset: 0x11D8
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function moon_quad_sidestep(animname, stepanim)
{
	self endon(#"death");
	self endon(#"stop_sidestep");
	self thread moon_quad_wait_phase_end(stepanim);
	self thread moon_quad_exit_align(stepanim);
	while(true)
	{
		self waittill(animname, note);
		if(note == "phase_start")
		{
			self thread moon_quad_phase_fx("quad_phasing_out");
			self playsound("zmb_quad_phase_out");
			self ghost();
		}
		else if(note == "phase_end")
		{
			self notify(#"stop_wait_phase_end");
			self thread moon_quad_phase_fx("quad_phasing_in");
			self show();
			self playsound("zmb_quad_phase_in");
			break;
		}
	}
}

/*
	Name: moon_quad_fastsprint
	Namespace: zm_moon_ai_quad
	Checksum: 0x256543AD
	Offset: 0x1348
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function moon_quad_fastsprint()
{
	if(isdefined(self.in_low_gravity) && self.in_low_gravity)
	{
		return "low_g_super_sprint";
	}
	return "super_sprint";
}

/*
	Name: moon_quad_wait_phase_end
	Namespace: zm_moon_ai_quad
	Checksum: 0x45746C11
	Offset: 0x1380
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function moon_quad_wait_phase_end(stepanim)
{
	self endon(#"death");
	self endon(#"stop_wait_phase_end");
	anim_length = getanimlength(stepanim);
	wait(anim_length);
	self thread moon_quad_phase_fx("quad_phasing_in");
	self show();
	self notify(#"stop_sidestep");
}

/*
	Name: moon_quad_exit_align
	Namespace: zm_moon_ai_quad
	Checksum: 0x4A91A0B
	Offset: 0x1420
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function moon_quad_exit_align(stepanim)
{
	self endon(#"death");
	anim_length = getanimlength(stepanim);
	wait(anim_length);
	if(!(isdefined(self.exit_align) && self.exit_align))
	{
		self notify(#"stepanim", "exit_align");
	}
}

/*
	Name: moon_quad_phase_fx
	Namespace: zm_moon_ai_quad
	Checksum: 0x8BB9DB1
	Offset: 0x1498
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function moon_quad_phase_fx(var_99a8589b)
{
	self endon(#"death");
	if(isdefined(level._effect[var_99a8589b]))
	{
		playfxontag(level._effect[var_99a8589b], self, "j_spine4");
	}
}

/*
	Name: moon_quad_gas_immune
	Namespace: zm_moon_ai_quad
	Checksum: 0xA44A2E4A
	Offset: 0x14F8
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function moon_quad_gas_immune()
{
	self endon(#"disconnect");
	self endon(#"death");
}

