// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace electroball_grenade;

/*
	Name: __init__sytem__
	Namespace: electroball_grenade
	Checksum: 0x73C4FF26
	Offset: 0x3E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("electroball_grenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: electroball_grenade
	Checksum: 0xDB44F2AE
	Offset: 0x428
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "tazered", 1, 1, "int", undefined, 0, 0);
	clientfield::register("allplayers", "electroball_shock", 1, 1, "int", &function_1619af16, 0, 0);
	clientfield::register("actor", "electroball_make_sparky", 1, 1, "int", &function_72eeb2e6, 0, 0);
	clientfield::register("missile", "electroball_stop_trail", 1, 1, "int", &function_bd1f6a88, 0, 0);
	clientfield::register("missile", "electroball_play_landed_fx", 1, 1, "int", &electroball_play_landed_fx, 0, 0);
	level._effect["fx_wpn_115_blob"] = "dlc1/castle/fx_wpn_115_blob";
	level._effect["fx_wpn_115_bul_trail"] = "dlc1/castle/fx_wpn_115_bul_trail";
	level._effect["fx_wpn_115_canister"] = "dlc1/castle/fx_wpn_115_canister";
	level._effect["electroball_grenade_player_shock"] = "weapon/fx_prox_grenade_impact_player_spwner";
	level._effect["electroball_grenade_sparky_conversion"] = "weapon/fx_prox_grenade_exp";
	callback::add_weapon_type("electroball_grenade", &proximity_spawned);
	level thread watchforproximityexplosion();
}

/*
	Name: proximity_spawned
	Namespace: electroball_grenade
	Checksum: 0xC332E464
	Offset: 0x658
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function proximity_spawned(localclientnum)
{
	self util::waittill_dobj(localclientnum);
	if(self isgrenadedud())
	{
		return;
	}
	self.var_886cac6a = playfxontag(localclientnum, level._effect["fx_wpn_115_bul_trail"], self, "j_grenade_front");
	self.var_5470a25d = playfxontag(localclientnum, level._effect["fx_wpn_115_canister"], self, "j_grenade_back");
}

/*
	Name: watchforproximityexplosion
	Namespace: electroball_grenade
	Checksum: 0x16981BD8
	Offset: 0x718
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function watchforproximityexplosion()
{
	if(getactivelocalclients() > 1)
	{
		return;
	}
	weapon_proximity = getweapon("electroball_grenade");
	while(true)
	{
		level waittill(#"explode", localclientnum, position, mod, weapon, owner_cent);
		if(weapon.rootweapon != weapon_proximity)
		{
			continue;
		}
		localplayer = getlocalplayer(localclientnum);
		if(!localplayer util::is_player_view_linked_to_entity(localclientnum))
		{
			explosionradius = weapon.explosionradius;
			if(distancesquared(localplayer.origin, position) < (explosionradius * explosionradius))
			{
				if(isdefined(owner_cent))
				{
					if(owner_cent == localplayer || !owner_cent util::friend_not_foe(localclientnum, 1))
					{
						localplayer thread postfx::playpostfxbundle("pstfx_shock_charge");
					}
				}
			}
		}
	}
}

/*
	Name: function_72eeb2e6
	Namespace: electroball_grenade
	Checksum: 0x5EB9E134
	Offset: 0x8B8
	Size: 0x154
	Parameters: 7
	Flags: Linked
*/
function function_72eeb2e6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	ai_zombie = self;
	if(isdefined(level.a_electroball_grenades))
	{
		electroball = arraygetclosest(ai_zombie.origin, level.a_electroball_grenades);
	}
	a_sparky_tags = array("J_Spine4", "J_SpineUpper", "J_Spine1");
	tag = array::random(a_sparky_tags);
	if(isdefined(electroball))
	{
		var_d72ccbc = beamlaunch(localclientnum, electroball, "tag_origin", ai_zombie, tag, "electric_arc_beam_electroball");
		wait(1);
		if(isdefined(var_d72ccbc))
		{
			beamkill(localclientnum, var_d72ccbc);
		}
	}
}

/*
	Name: function_1619af16
	Namespace: electroball_grenade
	Checksum: 0x3C5059AA
	Offset: 0xA18
	Size: 0x78
	Parameters: 7
	Flags: Linked
*/
function function_1619af16(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	fx = playfxontag(localclientnum, level._effect["electroball_grenade_player_shock"], self, "J_SpineUpper");
}

/*
	Name: function_bd1f6a88
	Namespace: electroball_grenade
	Checksum: 0x281DB941
	Offset: 0xA98
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function function_bd1f6a88(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.a_electroball_grenades))
	{
		level.a_electroball_grenades = [];
	}
	array::add(level.a_electroball_grenades, self);
	self thread function_1d823abf();
	if(isdefined(self.var_886cac6a))
	{
		stopfx(localclientnum, self.var_886cac6a);
	}
	if(isdefined(self.var_626a3201))
	{
		stopfx(localclientnum, self.var_626a3201);
	}
	if(isdefined(self.var_7a731cc6))
	{
		stopfx(localclientnum, self.var_7a731cc6);
	}
	if(isdefined(self.var_5470a25d))
	{
		stopfx(localclientnum, self.var_5470a25d);
	}
}

/*
	Name: function_1d823abf
	Namespace: electroball_grenade
	Checksum: 0xBA16B608
	Offset: 0xBC8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_1d823abf()
{
	self waittill(#"entityshutdown");
	level.a_electroball_grenades = array::remove_undefined(level.a_electroball_grenades);
}

/*
	Name: electroball_play_landed_fx
	Namespace: electroball_grenade
	Checksum: 0xDAD8F922
	Offset: 0xC08
	Size: 0xB8
	Parameters: 7
	Flags: Linked
*/
function electroball_play_landed_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self.var_3b22ba3c = playfxontag(localclientnum, level._effect["fx_wpn_115_blob"], self, "tag_origin");
	dynent = createdynentandlaunch(localclientnum, "p7_zm_ctl_115_grenade_broken", self.origin, self.angles, self.origin, (0, 0, 0));
}

