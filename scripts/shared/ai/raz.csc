// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;

#using_animtree("generic");

#namespace raz;

/*
	Name: main
	Namespace: raz
	Checksum: 0xB023007A
	Offset: 0x828
	Size: 0x2FC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("scriptmover", "raz_detonate_ground_torpedo", 12000, 1, "int", &razclientutils::razdetonategroundtorpedo, 0, 0);
	clientfield::register("scriptmover", "raz_torpedo_play_fx_on_self", 12000, 1, "int", &razclientutils::razplayselffx, 0, 0);
	clientfield::register("scriptmover", "raz_torpedo_play_trail", 12000, 1, "counter", &razclientutils::raztorpedoplaytrailfx, 0, 0);
	clientfield::register("actor", "raz_detach_gun", 12000, 1, "int", &razclientutils::razdetachgunfx, 0, 0);
	clientfield::register("actor", "raz_gun_weakpoint_hit", 12000, 1, "counter", &razclientutils::razgunweakpointhitfx, 0, 0);
	clientfield::register("actor", "raz_detach_helmet", 12000, 1, "int", &razclientutils::razhelmetdetach, 0, 0);
	clientfield::register("actor", "raz_detach_chest_armor", 12000, 1, "int", &razclientutils::razchestarmordetach, 0, 0);
	clientfield::register("actor", "raz_detach_l_shoulder_armor", 12000, 1, "int", &razclientutils::razleftshoulderarmordetach, 0, 0);
	clientfield::register("actor", "raz_detach_r_thigh_armor", 12000, 1, "int", &razclientutils::razrightthigharmordetach, 0, 0);
	clientfield::register("actor", "raz_detach_l_thigh_armor", 12000, 1, "int", &razclientutils::razleftthigharmordetach, 0, 0);
	ai::add_archetype_spawn_function("raz", &razclientutils::razspawn);
}

/*
	Name: precache
	Namespace: raz
	Checksum: 0xBF086AB2
	Offset: 0xB30
	Size: 0x70E
	Parameters: 0
	Flags: AutoExec
*/
function autoexec precache()
{
	level._effect["fx_mech_foot_step"] = "dlc1/castle/fx_mech_foot_step";
	level._effect["fx_raz_mc_shockwave_projectile_impact"] = "dlc3/stalingrad/fx_raz_mc_shockwave_projectile_impact";
	level._effect["fx_bul_impact_concrete_xtreme"] = "impacts/fx_bul_impact_concrete_xtreme";
	level._effect["fx_raz_mc_shockwave_projectile"] = "dlc3/stalingrad/fx_raz_mc_shockwave_projectile";
	level._effect["fx_raz_dest_weak_point_exp"] = "dlc3/stalingrad/fx_raz_dest_weak_point_exp";
	level._effect["fx_raz_dest_weak_point_sparking_loop"] = "dlc3/stalingrad/fx_raz_dest_weak_point_sparking_loop";
	level._effect["fx_raz_dmg_weak_point"] = "dlc3/stalingrad/fx_raz_dmg_weak_point";
	level._effect["fx_raz_dest_weak_point_exp_generic"] = "dlc3/stalingrad/fx_raz_dest_weak_point_exp_generic";
	level._raz_taunts = [];
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_0";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_1";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_2";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_3";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_4";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_5";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_6";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_7";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_8";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_9";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_10";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_11";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_12";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!isarray(level._raz_taunts))
	{
		level._raz_taunts = array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_13";
}

#namespace razclientutils;

/*
	Name: razspawn
	Namespace: razclientutils
	Checksum: 0xEC8806FA
	Offset: 0x1248
	Size: 0x74
	Parameters: 1
	Flags: Linked, Private
*/
function private razspawn(localclientnum)
{
	level._footstepcbfuncs[self.archetype] = &razprocessfootstep;
	self thread razplayfireemissiveshader(localclientnum);
	self thread razplayroarsound(localclientnum);
	self thread razplaytaunts(localclientnum);
}

/*
	Name: razplayfireemissiveshader
	Namespace: razclientutils
	Checksum: 0xE6F629E5
	Offset: 0x12C8
	Size: 0x88
	Parameters: 1
	Flags: Linked, Private
*/
function private razplayfireemissiveshader(localclientnum)
{
	self endon(#"death");
	while(isdefined(self))
	{
		self waittill(#"lights_on");
		self mapshaderconstant(localclientnum, 0, "scriptVector3", 0, 1, 1);
		self waittill(#"lights_off");
		self mapshaderconstant(localclientnum, 0, "scriptVector3", 0, 0, 0);
	}
}

/*
	Name: razplayroarsound
	Namespace: razclientutils
	Checksum: 0x51F41F28
	Offset: 0x1358
	Size: 0x70
	Parameters: 1
	Flags: Linked, Private
*/
function private razplayroarsound(localclientnum)
{
	self endon(#"death");
	while(isdefined(self))
	{
		self waittill(#"roar");
		self playsound(localclientnum, "vox_raz_exert_enrage", self gettagorigin("tag_eye"));
	}
}

/*
	Name: razplaytaunts
	Namespace: razclientutils
	Checksum: 0x3D2059A8
	Offset: 0x13D0
	Size: 0x100
	Parameters: 1
	Flags: Linked, Private
*/
function private razplaytaunts(localclientnum)
{
	self endon(#"death_start");
	self thread razstoptauntsondeath(localclientnum);
	while(isdefined(self))
	{
		taunt_wait = randomintrange(5, 12);
		wait(taunt_wait);
		if(isdefined(level.voxaideactivate) && level.voxaideactivate)
		{
			continue;
		}
		else if(isdefined(self))
		{
			taunt_alias = level._raz_taunts[randomint(level._raz_taunts.size)];
			self.taunt_id = self playsound(localclientnum, taunt_alias, self gettagorigin("tag_eye"));
		}
	}
}

/*
	Name: razstoptauntsondeath
	Namespace: razclientutils
	Checksum: 0x48BC00B8
	Offset: 0x14D8
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private razstoptauntsondeath(localclientnum)
{
	self waittill(#"death_start");
	if(isdefined(self.taunt_id))
	{
		stopsound(self.taunt_id);
	}
}

/*
	Name: razprocessfootstep
	Namespace: razclientutils
	Checksum: 0xCCDE52C4
	Offset: 0x1520
	Size: 0x238
	Parameters: 5
	Flags: Linked
*/
function razprocessfootstep(localclientnum, pos, surface, notetrack, bone)
{
	e_player = getlocalplayer(localclientnum);
	n_dist = distancesquared(pos, e_player.origin);
	n_raz_dist = 160000;
	if(n_raz_dist > 0)
	{
		n_scale = (n_raz_dist - n_dist) / n_raz_dist;
	}
	else
	{
		return;
	}
	if(n_scale > 1 || n_scale < 0)
	{
		return;
	}
	if(n_scale <= 0.01)
	{
		return;
	}
	earthquake_scale = n_scale * 0.1;
	if(earthquake_scale > 0.01)
	{
		e_player earthquake(earthquake_scale, 0.1, pos, n_dist);
	}
	if(n_scale <= 1 && n_scale > 0.8)
	{
		e_player playrumbleonentity(localclientnum, "damage_heavy");
	}
	else
	{
		if(n_scale <= 0.8 && n_scale > 0.4)
		{
			e_player playrumbleonentity(localclientnum, "damage_light");
		}
		else
		{
			e_player playrumbleonentity(localclientnum, "reload_small");
		}
	}
	fx = playfxontag(localclientnum, level._effect["fx_mech_foot_step"], self, bone);
}

/*
	Name: razdetonategroundtorpedo
	Namespace: razclientutils
	Checksum: 0xD1B3CBBA
	Offset: 0x1760
	Size: 0x78
	Parameters: 7
	Flags: Linked, Private
*/
function private razdetonategroundtorpedo(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	fx = playfx(localclientnum, level._effect["fx_raz_mc_shockwave_projectile_impact"], self.origin);
}

/*
	Name: raztorpedoplaytrailfx
	Namespace: razclientutils
	Checksum: 0xD9DC20DE
	Offset: 0x17E0
	Size: 0x78
	Parameters: 7
	Flags: Linked, Private
*/
function private raztorpedoplaytrailfx(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	fx = playfx(localclientnum, level._effect["fx_bul_impact_concrete_xtreme"], self.origin);
}

/*
	Name: razplayselffx
	Namespace: razclientutils
	Checksum: 0xC04015EA
	Offset: 0x1860
	Size: 0xD4
	Parameters: 7
	Flags: Linked, Private
*/
function private razplayselffx(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue == 0 && isdefined(self.raz_torpedo_self_fx))
	{
		stopfx(localclientnum, self.raz_torpedo_self_fx);
		self.raz_torpedo_self_fx = undefined;
	}
	if(newvalue == 1 && !isdefined(self.raz_torpedo_self_fx))
	{
		self.raz_torpedo_self_fx = playfxontag(localclientnum, level._effect["fx_raz_mc_shockwave_projectile"], self, "tag_origin");
	}
}

/*
	Name: razcreatedynentandlaunch
	Namespace: razclientutils
	Checksum: 0x830464FB
	Offset: 0x1940
	Size: 0x1BC
	Parameters: 7
	Flags: Linked, Private
*/
function private razcreatedynentandlaunch(localclientnum, model, pos, angles, hitpos, vel_factor = 1, direction)
{
	if(!isdefined(pos) || !isdefined(angles))
	{
		return;
	}
	velocity = self getvelocity();
	velocity_normal = vectornormalize(velocity);
	velocity_length = length(velocity);
	if(isdefined(direction) && direction == "back")
	{
		launch_dir = anglestoforward(self.angles) * -1;
	}
	else
	{
		launch_dir = anglestoforward(self.angles);
	}
	velocity_length = velocity_length * 0.1;
	if(velocity_length < 10)
	{
		velocity_length = 10;
	}
	launch_dir = (launch_dir * 0.5) + (velocity_normal * 0.5);
	launch_dir = launch_dir * velocity_length;
	createdynentandlaunch(localclientnum, model, pos, angles, self.origin, launch_dir * vel_factor);
}

/*
	Name: razdetachgunfx
	Namespace: razclientutils
	Checksum: 0x443BE85E
	Offset: 0x1B08
	Size: 0x1DC
	Parameters: 7
	Flags: Linked, Private
*/
function private razdetachgunfx(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	fx = playfxontag(localclientnum, level._effect["fx_raz_dest_weak_point_exp"], self, "TAG_FX_Shoulder_RI_GIB");
	gun_pos = self gettagorigin("j_elbow_ri");
	gun_ang = self gettagangles("j_elbow_ri");
	gun_core_pos = self gettagorigin("j_shouldertwist_ri_attach");
	gun_core_ang = self gettagangles("j_shouldertwist_ri_attach");
	dynent = razcreatedynentandlaunch(localclientnum, "c_zom_dlc3_raz_s_armcannon", gun_pos, gun_ang, self.origin, 1.3, "back");
	dynent = razcreatedynentandlaunch(localclientnum, "c_zom_dlc3_raz_s_cannonpowercore", gun_core_pos, gun_core_ang, self.origin, 1, "back");
	self playsound(localclientnum, "zmb_raz_gun_explo", self gettagorigin("tag_eye"));
}

/*
	Name: razgunweakpointhitfx
	Namespace: razclientutils
	Checksum: 0xD6BCC010
	Offset: 0x1CF0
	Size: 0x78
	Parameters: 7
	Flags: Linked, Private
*/
function private razgunweakpointhitfx(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	fx = playfxontag(localclientnum, level._effect["fx_raz_dmg_weak_point"], self, "j_shoulder_ri");
}

/*
	Name: razhelmetdetach
	Namespace: razclientutils
	Checksum: 0xEEEFB1B4
	Offset: 0x1D70
	Size: 0x174
	Parameters: 7
	Flags: Linked
*/
function razhelmetdetach(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	pos = self gettagorigin("j_elbow_ri");
	ang = self gettagangles("j_elbow_ri");
	fx = playfxontag(localclientnum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_Helmet");
	dynent = razcreatedynentandlaunch(localclientnum, "c_zom_dlc3_raz_s_helmet", pos, ang, self.origin, 1, "back");
	thread applynewfaceanim(localclientnum, "ai_zm_dlc3_face_armored_zombie_generic_idle_1");
	self playsound(localclientnum, "zmb_raz_armor_explo", self gettagorigin("tag_eye"));
}

/*
	Name: razchestarmordetach
	Namespace: razclientutils
	Checksum: 0x10A865A
	Offset: 0x1EF0
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function razchestarmordetach(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	pos = self gettagorigin("j_spine4_attach");
	ang = self gettagangles("j_spine4_attach");
	fx = playfxontag(localclientnum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_ChestPlate");
	dynent = razcreatedynentandlaunch(localclientnum, "c_zom_dlc3_raz_s_chestplate", pos, ang, self.origin);
	self playsound(localclientnum, "zmb_raz_armor_explo", self gettagorigin("tag_eye"));
}

/*
	Name: razleftshoulderarmordetach
	Namespace: razclientutils
	Checksum: 0xC652729E
	Offset: 0x2040
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function razleftshoulderarmordetach(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	pos = self gettagorigin("j_shouldertwist_le_attach");
	ang = self gettagangles("j_shouldertwist_le_attach");
	fx = playfxontag(localclientnum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_Shoulder_LE");
	dynent = razcreatedynentandlaunch(localclientnum, "c_zom_dlc3_raz_s_leftshoulderpad", pos, ang, self.origin);
	self playsound(localclientnum, "zmb_raz_armor_explo", self gettagorigin("tag_eye"));
}

/*
	Name: razleftthigharmordetach
	Namespace: razclientutils
	Checksum: 0x178E3010
	Offset: 0x2190
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function razleftthigharmordetach(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	pos = self gettagorigin("j_hiptwist_le_attach");
	ang = self gettagangles("j_hiptwist_le_attach");
	fx = playfxontag(localclientnum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_Thigh_LE");
	dynent = razcreatedynentandlaunch(localclientnum, "c_zom_dlc3_raz_s_leftthighpad", pos, ang, self.origin);
	self playsound(localclientnum, "zmb_raz_armor_explo", self gettagorigin("tag_eye"));
}

/*
	Name: razrightthigharmordetach
	Namespace: razclientutils
	Checksum: 0xBC4D8806
	Offset: 0x22E0
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function razrightthigharmordetach(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	pos = self gettagorigin("j_hiptwist_ri_attach");
	ang = self gettagangles("j_hiptwist_ri_attach");
	fx = playfxontag(localclientnum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_Thigh_RI");
	dynent = razcreatedynentandlaunch(localclientnum, "c_zom_dlc3_raz_s_rightthighpad", pos, ang, self.origin);
	self playsound(localclientnum, "zmb_raz_armor_explo", self gettagorigin("tag_eye"));
}

/*
	Name: applynewfaceanim
	Namespace: razclientutils
	Checksum: 0x7B9DBEF9
	Offset: 0x2430
	Size: 0xD4
	Parameters: 2
	Flags: Linked, Private
*/
function private applynewfaceanim(localclientnum, animation)
{
	self endon(#"disconnect");
	clearcurrentfacialanim(localclientnum);
	if(isdefined(animation))
	{
		self._currentfaceanim = animation;
		if(self hasdobj(localclientnum) && self hasanimtree())
		{
			self setflaggedanimknob("ai_secondary_facial_anim", animation, 1, 0.1, 1);
			self waittill(#"death_start");
			clearcurrentfacialanim(localclientnum);
		}
	}
}

/*
	Name: clearcurrentfacialanim
	Namespace: razclientutils
	Checksum: 0x6E1F871B
	Offset: 0x2510
	Size: 0x7E
	Parameters: 1
	Flags: Linked, Private
*/
function private clearcurrentfacialanim(localclientnum)
{
	if(isdefined(self._currentfaceanim) && self hasdobj(localclientnum) && self hasanimtree())
	{
		self clearanim(self._currentfaceanim, 0.2);
	}
	self._currentfaceanim = undefined;
}

