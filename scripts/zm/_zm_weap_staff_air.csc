// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_staff_common;

#namespace zm_weap_staff_air;

/*
	Name: __init__sytem__
	Namespace: zm_weap_staff_air
	Checksum: 0xEFBEA1
	Offset: 0x228
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_air", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_staff_air
	Checksum: 0x53E9C14D
	Offset: 0x268
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["whirlwind"] = "dlc5/zmb_weapon/fx_staff_air_impact_ug_miss";
	clientfield::register("scriptmover", "whirlwind_play_fx", 21000, 1, "int", &function_c6b66912, 0, 0);
	clientfield::register("actor", "air_staff_launch", 21000, 1, "int", &air_staff_launch, 0, 0);
	clientfield::register("allplayers", "air_staff_source", 21000, 1, "int", &function_869adfb, 0, 0);
	level.var_1e7d95e0 = (0, 0, 0);
	level.var_654c7116 = [];
	zm_weap_staff::function_4be5e665(getweapon("staff_air_upgraded"), "dlc5/zmb_weapon/fx_staff_charge_air_lv1");
}

/*
	Name: function_869adfb
	Namespace: zm_weap_staff_air
	Checksum: 0x2A8C6E2E
	Offset: 0x3B0
	Size: 0x4C
	Parameters: 7
	Flags: Linked
*/
function function_869adfb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level.var_1e7d95e0 = self.origin;
}

/*
	Name: ragdoll_impact_watch
	Namespace: zm_weap_staff_air
	Checksum: 0x472E06EE
	Offset: 0x408
	Size: 0x20E
	Parameters: 1
	Flags: Linked
*/
function ragdoll_impact_watch(localclientnum)
{
	self endon(#"entityshutdown");
	wait(0.1);
	waittime = 0.016;
	gibspeed = 500;
	prevorigin = self.origin;
	waitrealtime(waittime);
	prevvel = self.origin - prevorigin;
	prevspeed = length(prevvel);
	prevorigin = self.origin;
	waitrealtime(waittime);
	firstloop = 1;
	while(true)
	{
		vel = self.origin - prevorigin;
		speed = length(vel);
		if(speed < (prevspeed * 0.5) && prevspeed > (gibspeed * waittime))
		{
			if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
			{
				where = self gettagorigin("J_SpineLower");
				playfx(localclientnum, level._effect["zombie_guts_explosion"], where);
			}
			break;
		}
		if(prevspeed < (gibspeed * waittime) && !firstloop)
		{
			break;
		}
		prevorigin = self.origin;
		prevvel = vel;
		prevspeed = speed;
		firstloop = 0;
		waitrealtime(waittime);
	}
}

/*
	Name: air_staff_launch
	Namespace: zm_weap_staff_air
	Checksum: 0x5DD287AD
	Offset: 0x620
	Size: 0x204
	Parameters: 7
	Flags: Linked
*/
function air_staff_launch(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	v_source = level.var_1e7d95e0;
	var_8178243a = randomfloatrange(0.05, 0.35);
	var_bf0620ca = level.var_654c7116[localclientnum];
	if(isdefined(var_bf0620ca))
	{
		dist_sq = distancesquared(var_bf0620ca, self.origin);
		if(dist_sq < 22500)
		{
			var_5321b51d = (randomfloatrange(-1000, 1000), randomfloatrange(-1000, 1000), 0);
			v_source = var_bf0620ca + var_5321b51d;
		}
	}
	dir = self.origin - v_source;
	dir = vectornormalize(dir);
	v_force = length(dir) * 300;
	launch = (dir[0], dir[1], var_8178243a);
	launch = vectorscale(launch, v_force);
	self launchragdoll(launch);
	self thread ragdoll_impact_watch(localclientnum);
}

/*
	Name: function_c6b66912
	Namespace: zm_weap_staff_air
	Checksum: 0xC2DE390E
	Offset: 0x830
	Size: 0x1EE
	Parameters: 7
	Flags: Linked
*/
function function_c6b66912(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"entityshutdown");
	if(newval)
	{
		self.is_active = 1;
		original_pos = self.origin;
		level.var_654c7116[localclientnum] = self.origin;
		level.var_c6b66912 = playfxontag(localclientnum, level._effect["whirlwind"], self, "tag_origin");
		if(!isdefined(self.sndent))
		{
			self.sndent = spawn(0, self.origin, "script_origin");
			self.sndent.n_id = self.sndent playloopsound("wpn_airstaff_tornado", 1);
			self.sndent thread function_3a4d4e97();
		}
	}
	else
	{
		if(isdefined(level.var_c6b66912))
		{
			self.is_active = 0;
			level.var_654c7116[localclientnum] = undefined;
			stopfx(localclientnum, level.var_c6b66912);
		}
		if(isdefined(self.sndent))
		{
			self.sndent stoploopsound(self.sndent.n_id, 1.5);
			self.sndent delete();
			self.sndent = undefined;
		}
	}
}

/*
	Name: function_3a4d4e97
	Namespace: zm_weap_staff_air
	Checksum: 0x76CA7CFE
	Offset: 0xA28
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_3a4d4e97()
{
	self endon(#"entityshutdown");
	level waittill(#"demo_jump");
	self delete();
}

