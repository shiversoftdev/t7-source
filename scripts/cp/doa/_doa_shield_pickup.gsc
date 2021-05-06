// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_gibs;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace namespace_6df66aa5;

/*
	Name: boxingpickupupdate
	Namespace: namespace_6df66aa5
	Checksum: 0x3CA3ADA0
	Offset: 0x5B0
	Size: 0x514
	Parameters: 0
	Flags: Linked
*/
function boxingpickupupdate()
{
	note = doa_utility::function_2ccf4b82("end_boxing_pickup");
	self endon(note);
	self notify(#"hash_3924e234");
	org = spawn("script_model", self.origin);
	org.targetname = "boxingPickupUpdate";
	org.angles = (0, randomint(180), 0);
	org setmodel("tag_origin");
	self.doa.var_bfb9be95 = org;
	org thread namespace_1a381543::function_90118d8c("zmb_pwup_boxing_start");
	leftglove = spawn("script_model", self.origin + (0, 60, 32));
	leftglove.targetname = "leftglove";
	leftglove setmodel("zombietron_boxing_gloves_lt");
	leftglove setplayercollision(0);
	leftglove linkto(org, "tag_origin", (0, 60, 32), vectorscale((1, 0, 0), 90));
	trigger = spawn("trigger_radius", leftglove.origin, 1, 40, 50);
	trigger.targetname = "leftGlove";
	trigger enablelinkto();
	trigger linkto(leftglove);
	trigger thread function_80bf1f40(self, note, "zmb_pwup_boxing_punch", "boxing_pow", "MOD_IMPACT", &function_fa8666fa);
	org.var_1ab55691 = leftglove;
	org.trigger1 = trigger;
	rightglove = spawn("script_model", self.origin + (0, -60, 32));
	rightglove.targetname = "rightGlove";
	rightglove setmodel("zombietron_boxing_gloves_rt");
	rightglove setplayercollision(0);
	rightglove linkto(org, "tag_origin", (0, -60, 32), vectorscale((1, 0, 0), 90));
	trigger = spawn("trigger_radius", rightglove.origin, 1, 40, 50);
	trigger.targetname = "rightGlove";
	trigger enablelinkto();
	trigger linkto(rightglove);
	trigger thread function_80bf1f40(self, note, "zmb_pwup_boxing_punch", "boxing_pow", "MOD_IMPACT", &function_fa8666fa);
	org.var_40b7d0fa = rightglove;
	org.trigger2 = trigger;
	org linkto(self, "", vectorscale((0, 0, 1), 10), (0, 0, 0));
	self thread function_3c5a0d64(org, note, undefined, "zmb_pwup_boxing_end");
	self thread function_6143f535(org, note);
	org thread function_121caed2(self);
	self waittill(#"hash_eda7663d");
	leftglove setmodel("zombietron_boxing_gloves_expiring_lt");
	rightglove setmodel("zombietron_boxing_gloves_expiring_rt");
}

/*
	Name: function_fa8666fa
	Namespace: namespace_6df66aa5
	Checksum: 0x7E60F24B
	Offset: 0xAD0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_fa8666fa()
{
	self thread namespace_eaa992c::function_285a2999("boxing_stars");
	self waittill(#"actor_corpse", corpse);
	corpse thread namespace_eaa992c::function_285a2999("boxing_stars");
}

/*
	Name: barrelupdate
	Namespace: namespace_6df66aa5
	Checksum: 0x66A9AB17
	Offset: 0xB38
	Size: 0x4E0
	Parameters: 0
	Flags: Linked
*/
function barrelupdate()
{
	note = doa_utility::function_2ccf4b82("end_barrel_pickup");
	self endon(note);
	org = spawn("script_model", self.origin);
	org.targetname = "barrelUpdate";
	org.angles = (0, randomint(180), 0);
	self.doa.var_5a34cdc9 = org;
	org setmodel("tag_origin");
	barrel = spawn("script_model", self.origin + vectorscale((0, 1, 0), 90));
	barrel.targetname = "barrel1";
	barrel setmodel(level.doa.var_f6947407);
	barrel setplayercollision(0);
	barrel linkto(org, "tag_origin", vectorscale((0, 1, 0), 90));
	trigger = spawn("trigger_radius", barrel.origin, 1, 40, 50);
	trigger.targetname = "barrel1";
	trigger enablelinkto();
	trigger linkto(barrel);
	trigger thread function_80bf1f40(self, note, "zmb_pwup_barrel_impact");
	org.barrel1 = barrel;
	org.trigger1 = trigger;
	barrel = spawn("script_model", self.origin + vectorscale((0, -1, 0), 90));
	barrel.targetname = "barrel2";
	barrel setmodel(level.doa.var_f6947407);
	barrel setplayercollision(0);
	barrel linkto(org, "tag_origin", vectorscale((0, -1, 0), 90));
	trigger = spawn("trigger_radius", barrel.origin, 1, 40, 50);
	trigger.targetname = "barrel2";
	trigger enablelinkto();
	trigger linkto(barrel);
	trigger thread function_80bf1f40(self, note, "zmb_pwup_barrel_impact");
	org.barrel2 = barrel;
	org.trigger2 = trigger;
	org linkto(self, "", vectorscale((0, 0, 1), 10), (0, 0, 0));
	self thread function_3c5a0d64(org, note, "zmb_pwup_barrel_loop", "zmb_pwup_barrel_end");
	self thread function_6143f535(org, note);
	org thread function_121caed2(self);
	while(isdefined(org) && isdefined(self))
	{
		org.origin = self.origin;
		org rotateto(org.angles + vectorscale((0, 1, 0), 180), 1.2);
		wait(1.2);
	}
}

/*
	Name: function_80bf1f40
	Namespace: namespace_6df66aa5
	Checksum: 0xE52DF30F
	Offset: 0x1020
	Size: 0x270
	Parameters: 6
	Flags: Linked, Private
*/
private function function_80bf1f40(player, note, sfx, var_5e61e69d, mod = "MOD_CRUSH", var_aa78744e)
{
	player endon(note);
	while(true)
	{
		self waittill(#"trigger", guy);
		if(isplayer(guy))
		{
			continue;
		}
		if(isdefined(guy.boss) && guy.boss)
		{
			continue;
		}
		if(isdefined(guy.knocked_out) && guy.knocked_out)
		{
			continue;
		}
		if(isdefined(sfx))
		{
			guy thread namespace_1a381543::function_90118d8c(sfx);
		}
		if(isdefined(var_5e61e69d))
		{
			guy thread namespace_eaa992c::function_285a2999(var_5e61e69d);
		}
		if(isdefined(var_aa78744e))
		{
			guy thread [[var_aa78744e]]();
		}
		guy.knocked_out = 1;
		if(!isvehicle(guy))
		{
			dir = guy.origin - self.origin;
			guy thread doa_utility::function_e3c30240(dir, getdvarint("scr_doa_fling_force", 200));
			guy thread doa_utility::function_ba30b321(0, player, mod);
		}
		else
		{
			self dodamage(guy.health + 1, guy.origin, player, player, "none", mod, 0, getweapon("none"));
		}
		player playrumbleonentity("damage_light");
	}
}

/*
	Name: function_3c5a0d64
	Namespace: namespace_6df66aa5
	Checksum: 0xAEEE4FBC
	Offset: 0x1298
	Size: 0x11E
	Parameters: 4
	Flags: Linked, Private
*/
private function function_3c5a0d64(org, note, var_3587f608, var_eaac4dd5)
{
	self endon(note);
	self endon(#"disconnect");
	if(isdefined(var_3587f608))
	{
		self playloopsound(var_3587f608);
	}
	level doa_utility::function_c8f4d63a();
	time = self doa_utility::function_1ded48e6(level.doa.rules.var_f53cdb6e);
	wait(time - 3);
	self notify(#"hash_eda7663d");
	wait(3);
	if(isdefined(var_3587f608))
	{
		self stoploopsound(0.5);
	}
	if(isdefined(var_eaac4dd5))
	{
		self thread namespace_1a381543::function_90118d8c(var_eaac4dd5);
	}
	self notify(note);
}

/*
	Name: function_121caed2
	Namespace: namespace_6df66aa5
	Checksum: 0x5DB8301B
	Offset: 0x13C0
	Size: 0x1DC
	Parameters: 1
	Flags: Linked, Private
*/
private function function_121caed2(player)
{
	self endon(#"death");
	player waittill(#"disconnect");
	if(isdefined(self.trigger1))
	{
		self.trigger1 delete();
	}
	if(isdefined(self.trigger2))
	{
		self.trigger2 delete();
	}
	if(isdefined(self.barrel1))
	{
		self.barrel1 unlink();
	}
	if(isdefined(self.barrel2))
	{
		self.barrel2 unlink();
	}
	if(isdefined(self.var_1ab55691))
	{
		self.var_1ab55691 unlink();
	}
	if(isdefined(self.var_40b7d0fa))
	{
		self.var_40b7d0fa unlink();
	}
	wait(5);
	if(isdefined(self.barrel1))
	{
		self.barrel1 delete();
	}
	if(isdefined(self.barrel2))
	{
		self.barrel2 delete();
	}
	if(isdefined(self.var_1ab55691))
	{
		self.var_1ab55691 delete();
	}
	if(isdefined(self.var_40b7d0fa))
	{
		self.var_40b7d0fa delete();
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: function_6143f535
	Namespace: namespace_6df66aa5
	Checksum: 0xB745FF56
	Offset: 0x15A8
	Size: 0x564
	Parameters: 2
	Flags: Linked, Private
*/
private function function_6143f535(org, note)
{
	self util::waittill_any(note, "player_died", "kill_shield", "doa_playerVehiclePickup", "kill_duplicate_shields", "disconnect");
	if(isdefined(self))
	{
		self notify(note);
	}
	util::wait_network_frame();
	if(isdefined(org) && isdefined(org.trigger1))
	{
		org.trigger1 delete();
	}
	if(isdefined(org) && isdefined(org.trigger2))
	{
		org.trigger2 delete();
	}
	if(isdefined(org) && isdefined(org.barrel1))
	{
		org.barrel1 unlink();
	}
	if(isdefined(org) && isdefined(org.barrel2))
	{
		org.barrel2 unlink();
	}
	if(isdefined(org) && isdefined(org.var_1ab55691))
	{
		org.var_1ab55691 unlink();
	}
	if(isdefined(org) && isdefined(org.var_40b7d0fa))
	{
		org.var_40b7d0fa unlink();
	}
	if(isdefined(self))
	{
		if(isdefined(org) && isdefined(org.barrel1))
		{
			vel = org.barrel1.origin - self.origin;
			org.barrel1 physicslaunch(org.barrel1.origin, vel);
		}
		if(isdefined(org) && isdefined(org.barrel2))
		{
			vel = org.barrel2.origin - self.origin;
			org.barrel2 physicslaunch(org.barrel2.origin, vel);
		}
		self.doa.var_5a34cdc9 = undefined;
		if(isdefined(org) && isdefined(org.var_1ab55691))
		{
			vel = org.var_1ab55691.origin - self.origin;
			org.var_1ab55691 physicslaunch(org.var_1ab55691.origin, vel);
		}
		if(isdefined(org) && isdefined(org.var_40b7d0fa))
		{
			vel = org.var_40b7d0fa.origin - self.origin;
			org.var_40b7d0fa physicslaunch(org.var_40b7d0fa.origin, vel);
		}
		self.doa.var_bfb9be95 = undefined;
	}
	if(isdefined(org) && isdefined(org.barrel1))
	{
		org.barrel1 thread namespace_1a381543::function_90118d8c("zmb_pwup_barrel_fall_0");
	}
	if(isdefined(org) && isdefined(org.barrel2))
	{
		org.barrel2 thread namespace_1a381543::function_90118d8c("zmb_pwup_barrel_fall_1");
	}
	wait(5);
	if(isdefined(org) && isdefined(org.barrel1))
	{
		org.barrel1 delete();
	}
	if(isdefined(org) && isdefined(org.barrel2))
	{
		org.barrel2 delete();
	}
	if(isdefined(org) && isdefined(org.var_1ab55691))
	{
		org.var_1ab55691 delete();
	}
	if(isdefined(org) && isdefined(org.var_40b7d0fa))
	{
		org.var_40b7d0fa delete();
	}
	if(isdefined(org))
	{
		org delete();
	}
}

/*
	Name: function_a0a646c2
	Namespace: namespace_6df66aa5
	Checksum: 0x6D81E761
	Offset: 0x1B18
	Size: 0x8C
	Parameters: 0
	Flags: Linked, Private
*/
private function function_a0a646c2()
{
	self endon(#"death");
	self.doa.stunned = 1;
	self thread namespace_eaa992c::function_285a2999("stunbear_affected");
	wait(level.doa.rules.var_83dda8f2);
	self.doa.stunned = 0;
	self thread namespace_eaa992c::turnofffx("stunbear_affected");
}

/*
	Name: function_5f0b5579
	Namespace: namespace_6df66aa5
	Checksum: 0x329A811A
	Offset: 0x1BB0
	Size: 0x138
	Parameters: 1
	Flags: Linked, Private
*/
private function function_5f0b5579(player)
{
	player endon(#"hash_792240f4");
	player endon(#"disconnect");
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", guy);
		if(isdefined(guy.var_d538832c) && guy.var_d538832c)
		{
			continue;
		}
		if(isdefined(guy.boss) && guy.boss)
		{
			continue;
		}
		if(guy.doa.stunned == 0)
		{
			guy thread namespace_1a381543::function_90118d8c("zmb_pwup_bear_stun");
			guy thread namespace_eaa992c::function_285a2999("stunbear_contact");
			player playrumbleonentity("slide_rumble");
			guy thread function_a0a646c2();
		}
	}
}

/*
	Name: function_813e9dbd
	Namespace: namespace_6df66aa5
	Checksum: 0xC083A8AC
	Offset: 0x1CF0
	Size: 0xB2
	Parameters: 0
	Flags: Linked, Private
*/
private function function_813e9dbd()
{
	self endon(#"hash_792240f4");
	self endon(#"disconnect");
	self endon(#"death");
	level doa_utility::function_c8f4d63a();
	self.doa.var_1a9bbba7 = gettime() + self doa_utility::function_1ded48e6(level.doa.rules.var_4f139db6) * 1000;
	while(gettime() < self.doa.var_1a9bbba7)
	{
		wait(1);
	}
	self notify(#"hash_792240f4");
}

/*
	Name: function_e6abac68
	Namespace: namespace_6df66aa5
	Checksum: 0x9FDF37FF
	Offset: 0x1DB0
	Size: 0x144
	Parameters: 1
	Flags: Linked, Private
*/
private function function_e6abac68(trigger)
{
	self util::waittill_any("end_teddybear_stun", "disconnect", "player_died", "kill_shield", "disconnect");
	if(isdefined(self))
	{
		self notify(#"hash_792240f4");
		self.doa.var_908e6b76 = undefined;
		self thread namespace_eaa992c::turnofffx("stunbear");
		self thread namespace_eaa992c::function_285a2999("stunbear_fade");
		self stoploopsound(2);
	}
	wait(0.5);
	util::wait_network_frame();
	if(isdefined(self))
	{
		self thread namespace_1a381543::function_90118d8c("zmb_pwup_bear_end");
		self thread namespace_eaa992c::turnofffx("stunbear_fade");
	}
	if(isdefined(trigger))
	{
		trigger delete();
	}
}

/*
	Name: function_affe0c28
	Namespace: namespace_6df66aa5
	Checksum: 0x1671988F
	Offset: 0x1F00
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_affe0c28()
{
	if(isdefined(self.doa.var_908e6b76) && self.doa.var_908e6b76)
	{
		self.doa.var_1a9bbba7 = gettime() + self doa_utility::function_1ded48e6(level.doa.rules.var_4f139db6) * 1000;
		return;
	}
	self notify(#"hash_792240f4");
	self endon(#"hash_792240f4");
	self.doa.var_908e6b76 = 1;
	self.doa.var_21520b4e = spawn("trigger_radius", self.origin, 9, 130, 50);
	self.doa.var_21520b4e.targetname = "stunBear";
	self.doa.var_21520b4e enablelinkto();
	self.doa.var_21520b4e linkto(self);
	self.doa.var_21520b4e thread function_5f0b5579(self);
	self playloopsound("zmb_pwup_bear_loop");
	self thread namespace_eaa992c::function_285a2999("stunbear");
	self thread function_813e9dbd();
	self thread function_e6abac68(self.doa.var_21520b4e);
}

/*
	Name: function_45123d3c
	Namespace: namespace_6df66aa5
	Checksum: 0x12A727C1
	Offset: 0x20F0
	Size: 0x1EA
	Parameters: 1
	Flags: Linked
*/
function function_45123d3c(player)
{
	def = doa_pickups::function_bac08508(19);
	blade = spawn("script_model", player.origin + vectorscale((0, -1, 0), 70));
	blade.targetname = "blade";
	blade setmodel(level.doa.var_97bbae9c);
	blade setscale(def.scale);
	blade setplayercollision(0);
	blade linkto(self, "tag_origin", vectorscale((0, -1, 0), 70), (90 * self.blades.size, 0, 0));
	trigger = spawn("trigger_radius", blade.origin, 1, 30, 50);
	trigger.targetname = "blade";
	trigger enablelinkto();
	trigger linkto(blade);
	trigger thread function_92374630(player);
	self.blades[self.blades.size] = blade;
	self.triggers[self.triggers.size] = trigger;
}

/*
	Name: sawbladeupdate
	Namespace: namespace_6df66aa5
	Checksum: 0xBDC27F3B
	Offset: 0x22E8
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function sawbladeupdate()
{
	note = doa_utility::function_2ccf4b82("end_sawblad_pickup");
	self endon(note);
	org = spawn("script_model", self.origin);
	org.targetname = "sawbladeUpdate";
	org.angles = (0, randomint(180), 0);
	self.doa.var_39c1b814 = org;
	org setmodel("tag_origin");
	blades = 1;
	org.blades = [];
	org.triggers = [];
	org linkto(self, "tag_origin", vectorscale((0, 0, 1), 32));
	org playloopsound("zmb_pwup_blade_loop", 1);
	self thread function_f797c54(org, note);
	self thread function_595842c5(org, note);
	while(isdefined(org))
	{
		if(blades > 0)
		{
			org function_45123d3c(self);
			blades--;
		}
		if(!isdefined(self))
		{
			break;
		}
		org.origin = self.origin;
		org rotateto(org.angles + vectorscale((0, 1, 0), 180), 0.4);
		wait(0.4);
	}
}

/*
	Name: function_92374630
	Namespace: namespace_6df66aa5
	Checksum: 0xD9BC99F7
	Offset: 0x2518
	Size: 0x198
	Parameters: 1
	Flags: Linked, Private
*/
private function function_92374630(player)
{
	player endon(#"hash_1d724bbf");
	player endon(#"disconnect");
	while(true)
	{
		self waittill(#"trigger", guy);
		if(isplayer(guy))
		{
			continue;
		}
		if(isdefined(guy.boss) && guy.boss)
		{
			continue;
		}
		guy thread namespace_1a381543::function_90118d8c("zmb_pwup_blade_impact");
		if(isactor(guy))
		{
			vel = vectorscale(self.origin - player.origin, 0.2);
			if(!(isdefined(guy.var_ad61c13d) && guy.var_ad61c13d))
			{
				guy namespace_fba031c8::function_ddf685e8(vel, player);
				guy thread doa_utility::function_ba30b321(0.5, player);
			}
			else
			{
				guy thread doa_utility::function_ba30b321(0, player);
			}
		}
		else
		{
			guy thread doa_utility::function_ba30b321(0, player);
		}
	}
}

/*
	Name: function_f797c54
	Namespace: namespace_6df66aa5
	Checksum: 0x6491F1AD
	Offset: 0x26B8
	Size: 0xE6
	Parameters: 2
	Flags: Linked, Private
*/
private function function_f797c54(org, note)
{
	self endon(note);
	self endon(#"disconnect");
	level doa_utility::function_c8f4d63a();
	time_left = gettime() + self doa_utility::function_1ded48e6(level.doa.rules.var_fb13151a) * 1000;
	while(gettime() < time_left)
	{
		wait(0.05);
		/#
		#/
	}
	self stoploopsound(0.5);
	self thread namespace_1a381543::function_90118d8c("zmb_pwup_blade_end");
	self notify(note);
}

/*
	Name: function_595842c5
	Namespace: namespace_6df66aa5
	Checksum: 0x228DFCF4
	Offset: 0x27A8
	Size: 0x22A
	Parameters: 2
	Flags: Linked, Private
*/
private function function_595842c5(org, note)
{
	self util::waittill_any(note, "player_died", "kill_shield", "disconnect");
	if(isdefined(self))
	{
		self notify(note);
	}
	util::wait_network_frame();
	for(i = 0; i < org.triggers.size; i++)
	{
		org.triggers[i] delete();
		org.blades[i] unlink();
		if(isdefined(self))
		{
			vel = org.blades[i].origin - self.origin;
			org.blades[i] physicslaunch(org.blades[i].origin, vel);
		}
		org.blades[i] thread namespace_1a381543::function_90118d8c("zmb_pwup_blade_fall_0");
	}
	wait(5);
	for(i = 0; i < org.blades.size; i++)
	{
		org.blades[i] delete();
	}
	org delete();
	if(isdefined(self))
	{
		self.doa.var_39c1b814 = undefined;
	}
}

/*
	Name: function_64bb8338
	Namespace: namespace_6df66aa5
	Checksum: 0xB1DE8E0
	Offset: 0x29E0
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_64bb8338(orb)
{
	msg = self util::waittill_any_return("player_died", "magnet_update", "magnet_expired", "disconnect", "kill_shield");
	if(isdefined(msg) && msg == "magnet_update")
	{
		orb delete();
		return;
	}
	orb thread namespace_eaa992c::turnofffx("magnet_on");
	orb thread namespace_eaa992c::function_285a2999("magnet_fade");
	wait(1);
	if(isdefined(self))
	{
		self thread namespace_1a381543::function_4f06fb8("zmb_pwup_magnet_loop");
		self thread namespace_1a381543::function_90118d8c("zmb_pwup_magnet_end");
	}
	orb delete();
}

/*
	Name: function_2016b381
	Namespace: namespace_6df66aa5
	Checksum: 0x74D19B07
	Offset: 0x2B18
	Size: 0x1B2
	Parameters: 1
	Flags: Linked
*/
function function_2016b381(time)
{
	self notify(#"hash_2016b381");
	self endon(#"hash_2016b381");
	self endon(#"player_died");
	self endon(#"disconnect");
	orb = spawn("script_model", self.origin);
	orb.targetname = "magnet_update";
	orb setmodel("tag_origin");
	orb linkto(self, "", vectorscale((0, 0, 1), 50));
	self.doa.var_3df27425 = orb;
	self thread function_64bb8338(orb);
	self thread namespace_1a381543::function_90118d8c("zmb_pwup_magnet_loop");
	orb thread namespace_eaa992c::function_285a2999("magnet_on");
	level doa_utility::function_c8f4d63a();
	if(isdefined(time))
	{
		wait(time);
	}
	else
	{
		wait(self doa_utility::function_1ded48e6(level.doa.rules.var_2a59d58f));
	}
	self notify(#"hash_f327cf19");
	self.doa.var_3df27425 = undefined;
}

