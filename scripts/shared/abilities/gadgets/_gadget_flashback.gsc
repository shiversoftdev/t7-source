// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace flashback;

/*
	Name: __init__sytem__
	Namespace: flashback
	Checksum: 0xEB9AB937
	Offset: 0x350
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_flashback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: flashback
	Checksum: 0x334CA8D3
	Offset: 0x390
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "flashback_trail_fx", 1, 1, "int");
	clientfield::register("playercorpse", "flashback_clone", 1, 1, "int");
	clientfield::register("allplayers", "flashback_activated", 1, 1, "int");
	ability_player::register_gadget_activation_callbacks(16, &gadget_flashback_on, &gadget_flashback_off);
	ability_player::register_gadget_possession_callbacks(16, &gadget_flashback_on_give, &gadget_flashback_on_take);
	ability_player::register_gadget_flicker_callbacks(16, &gadget_flashback_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(16, &gadget_flashback_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(16, &gadget_flashback_is_flickering);
	ability_player::register_gadget_primed_callbacks(16, &gadget_flashback_is_primed);
	callback::on_connect(&gadget_flashback_on_connect);
	callback::on_spawned(&gadget_flashback_spawned);
	if(!isdefined(level.vsmgr_prio_overlay_flashback_warp))
	{
		level.vsmgr_prio_overlay_flashback_warp = 27;
	}
	visionset_mgr::register_info("overlay", "flashback_warp", 1, level.vsmgr_prio_overlay_flashback_warp, 1, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
}

/*
	Name: gadget_flashback_spawned
	Namespace: flashback
	Checksum: 0x37403A6E
	Offset: 0x5A8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function gadget_flashback_spawned()
{
	self clientfield::set("flashback_activated", 0);
}

/*
	Name: gadget_flashback_is_inuse
	Namespace: flashback
	Checksum: 0xE9BDCBE4
	Offset: 0x5D8
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_flashback_is_inuse(slot)
{
	return self flagsys::get("gadget_flashback_on");
}

/*
	Name: gadget_flashback_is_flickering
	Namespace: flashback
	Checksum: 0x9925899B
	Offset: 0x610
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_flashback_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_flashback_on_flicker
	Namespace: flashback
	Checksum: 0x4693D28E
	Offset: 0x640
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_flashback_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_flashback_on_give
	Namespace: flashback
	Checksum: 0x3065EF30
	Offset: 0x660
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_flashback_on_give(slot, weapon)
{
}

/*
	Name: gadget_flashback_on_take
	Namespace: flashback
	Checksum: 0x8C62A649
	Offset: 0x680
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_flashback_on_take(slot, weapon)
{
}

/*
	Name: gadget_flashback_on_connect
	Namespace: flashback
	Checksum: 0x99EC1590
	Offset: 0x6A0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function gadget_flashback_on_connect()
{
}

/*
	Name: clone_watch_death
	Namespace: flashback
	Checksum: 0xA4337A8B
	Offset: 0x6B0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function clone_watch_death()
{
	self endon(#"death");
	wait(1);
	self clientfield::set("flashback_clone", 0);
	self ghost();
}

/*
	Name: debug_star
	Namespace: flashback
	Checksum: 0xFB4C2FD1
	Offset: 0x708
	Size: 0x8C
	Parameters: 3
	Flags: None
*/
function debug_star(origin, seconds, color)
{
	/#
		if(!isdefined(seconds))
		{
			seconds = 1;
		}
		if(!isdefined(color))
		{
			color = (1, 0, 0);
		}
		frames = int(20 * seconds);
		debugstar(origin, frames, color);
	#/
}

/*
	Name: drop_unlinked_grenades
	Namespace: flashback
	Checksum: 0x98C08DCC
	Offset: 0x7A0
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function drop_unlinked_grenades(linkedgrenades)
{
	waittillframeend();
	foreach(grenade in linkedgrenades)
	{
		grenade launch((randomfloatrange(-5, 5), randomfloatrange(-5, 5), 5));
	}
}

/*
	Name: unlink_grenades
	Namespace: flashback
	Checksum: 0xFDA47A9C
	Offset: 0x878
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function unlink_grenades(oldpos)
{
	radius = 32;
	origin = oldpos;
	grenades = getentarray("grenade", "classname");
	radiussq = radius * radius;
	linkedgrenades = [];
	foreach(grenade in grenades)
	{
		if(distancesquared(origin, grenade.origin) < radiussq)
		{
			if(isdefined(grenade.stucktoplayer) && grenade.stucktoplayer == self)
			{
				grenade unlink();
				linkedgrenades[linkedgrenades.size] = grenade;
			}
		}
	}
	thread drop_unlinked_grenades(linkedgrenades);
}

/*
	Name: gadget_flashback_on
	Namespace: flashback
	Checksum: 0x3EF755F4
	Offset: 0xA10
	Size: 0x264
	Parameters: 2
	Flags: Linked
*/
function gadget_flashback_on(slot, weapon)
{
	self flagsys::set("gadget_flashback_on");
	self gadgetsetactivatetime(slot, gettime());
	visionset_mgr::activate("overlay", "flashback_warp", self, 0.8, 0.8);
	self.flashbacktime = gettime();
	self notify(#"flashback");
	clone = self createflashbackclone();
	clone thread clone_watch_death();
	clone clientfield::set("flashback_clone", 1);
	self thread watchclientfields();
	oldpos = self gettagorigin("j_spineupper");
	offset = oldpos - self.origin;
	self unlink_grenades(oldpos);
	newpos = self flashbackstart(weapon) + offset;
	self notsolid();
	if(isdefined(newpos) && isdefined(oldpos))
	{
		self thread flashbacktrailfx(slot, weapon, oldpos, newpos);
		flashbacktrailimpact(newpos, oldpos, 8);
		flashbacktrailimpact(oldpos, newpos, 8);
		if(isdefined(level.playgadgetsuccess))
		{
			self [[level.playgadgetsuccess]](weapon, "flashbackSuccessDelay");
		}
	}
	self thread deactivateflashbackwarpaftertime(0.8);
}

/*
	Name: watchclientfields
	Namespace: flashback
	Checksum: 0xF40A13F
	Offset: 0xC80
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function watchclientfields()
{
	self endon(#"death");
	self endon(#"disconnect");
	util::wait_network_frame();
	self clientfield::set("flashback_activated", 1);
	util::wait_network_frame();
	self clientfield::set("flashback_activated", 0);
}

/*
	Name: flashbacktrailimpact
	Namespace: flashback
	Checksum: 0xA25BB3A9
	Offset: 0xD08
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function flashbacktrailimpact(startpos, endpos, recursiondepth)
{
	recursiondepth--;
	if(recursiondepth <= 0)
	{
		return;
	}
	trace = bullettrace(startpos, endpos, 0, self);
	if(trace["fraction"] < 1 && trace["normal"] != (0, 0, 0))
	{
		playfx("player/fx_plyr_flashback_trail_impact", trace["position"], trace["normal"]);
		newstartpos = trace["position"] - trace["normal"];
		/#
		#/
		flashbacktrailimpact(newstartpos, endpos, recursiondepth);
	}
}

/*
	Name: deactivateflashbackwarpaftertime
	Namespace: flashback
	Checksum: 0xA85B71E7
	Offset: 0xE10
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function deactivateflashbackwarpaftertime(time)
{
	self endon(#"disconnect");
	self util::waittill_any_timeout(time, "death");
	visionset_mgr::deactivate("overlay", "flashback_warp", self);
}

/*
	Name: flashbacktrailfx
	Namespace: flashback
	Checksum: 0xA43000FC
	Offset: 0xE70
	Size: 0x1E4
	Parameters: 4
	Flags: Linked
*/
function flashbacktrailfx(slot, weapon, oldpos, newpos)
{
	dirvec = newpos - oldpos;
	if(dirvec == (0, 0, 0))
	{
		dirvec = (0, 0, 1);
	}
	dirvec = vectornormalize(dirvec);
	angles = vectortoangles(dirvec);
	fxorg = spawn("script_model", oldpos, 0, angles);
	fxorg.angles = angles;
	fxorg setowner(self);
	fxorg setmodel("tag_origin");
	fxorg clientfield::set("flashback_trail_fx", 1);
	util::wait_network_frame();
	tagpos = self gettagorigin("j_spineupper");
	fxorg moveto(tagpos, 0.1);
	fxorg waittill(#"movedone");
	wait(1);
	fxorg clientfield::set("flashback_trail_fx", 0);
	util::wait_network_frame();
	fxorg delete();
}

/*
	Name: gadget_flashback_is_primed
	Namespace: flashback
	Checksum: 0xA715D4C6
	Offset: 0x1060
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_flashback_is_primed(slot, weapon)
{
}

/*
	Name: gadget_flashback_off
	Namespace: flashback
	Checksum: 0xC39375B2
	Offset: 0x1080
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function gadget_flashback_off(slot, weapon)
{
	self flagsys::clear("gadget_flashback_on");
	self solid();
	self flashbackfinish();
	if(level.gameended)
	{
		self freezecontrols(1);
	}
}

