// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace gadget_vision_pulse;

/*
	Name: __init__sytem__
	Namespace: gadget_vision_pulse
	Checksum: 0xDE1BB0C0
	Offset: 0x308
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_vision_pulse", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: gadget_vision_pulse
	Checksum: 0x8E431CF7
	Offset: 0x348
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!sessionmodeiscampaigngame())
	{
		callback::on_localplayer_spawned(&on_localplayer_spawned);
		duplicate_render::set_dr_filter_offscreen("reveal_en", 50, "reveal_enemy", undefined, 2, "mc/hud_outline_model_z_red", 1);
		duplicate_render::set_dr_filter_offscreen("reveal_self", 50, "reveal_self", undefined, 2, "mc/hud_outline_model_z_red_alpha", 1);
	}
	clientfield::register("toplayer", "vision_pulse_active", 1, 1, "int", &vision_pulse_changed, 0, 1);
	visionset_mgr::register_visionset_info("vision_pulse", 1, 12, undefined, "vision_puls_bw");
}

/*
	Name: on_localplayer_spawned
	Namespace: gadget_vision_pulse
	Checksum: 0x1F280E98
	Offset: 0x468
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_spawned(localclientnum)
{
	if(self == getlocalplayer(localclientnum))
	{
		self.vision_pulse_owner = undefined;
		filter::init_filter_vision_pulse(localclientnum);
		self gadgetpulseresetreveal();
		self set_reveal_self(localclientnum, 0);
		self set_reveal_enemy(localclientnum, 0);
		self thread watch_emped(localclientnum);
	}
}

/*
	Name: watch_emped
	Namespace: gadget_vision_pulse
	Checksum: 0x8B95A0EB
	Offset: 0x520
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function watch_emped(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		if(self isempjammed())
		{
			self thread disableshader(localclientnum, 0);
			self notify(#"emp_jammed_vp");
			break;
		}
		wait(0.016);
	}
}

/*
	Name: disableshader
	Namespace: gadget_vision_pulse
	Checksum: 0xC3EDC67E
	Offset: 0x5A0
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function disableshader(localclientnum, duration)
{
	self endon(#"startvpshader");
	self endon(#"death");
	self endon(#"entityshutdown");
	self notify(#"disablevpshader");
	self endon(#"disablevpshader");
	wait(duration);
	filter::disable_filter_vision_pulse(localclientnum, 3);
}

/*
	Name: watch_world_pulse_end
	Namespace: gadget_vision_pulse
	Checksum: 0x89838CCB
	Offset: 0x618
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function watch_world_pulse_end(localclientnum)
{
	self notify(#"watchworldpulseend");
	self endon(#"watchworldpulseend");
	self util::waittill_any("entityshutdown", "death", "emp_jammed_vp");
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 0, getvisionpulsemaxradius(localclientnum) + 1);
}

/*
	Name: do_vision_world_pulse
	Namespace: gadget_vision_pulse
	Checksum: 0x396E281D
	Offset: 0x6B0
	Size: 0x32C
	Parameters: 1
	Flags: Linked
*/
function do_vision_world_pulse(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	self notify(#"startvpshader");
	self thread watch_world_pulse_end(localclientnum);
	filter::enable_filter_vision_pulse(localclientnum, 3);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 1, 1);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 2, 0.08);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 3, 0);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 4, 1);
	starttime = getservertime(localclientnum);
	wait(0.016);
	amount = 1;
	irisamount = 0;
	pulsemaxradius = 0;
	while((getservertime(localclientnum) - starttime) < 2000)
	{
		elapsedtime = (getservertime(localclientnum) - starttime) * 1;
		if(elapsedtime < 200)
		{
			irisamount = elapsedtime / 200;
		}
		else
		{
			if(elapsedtime < (2000 * 0.6))
			{
				irisamount = 1 - (elapsedtime / 1000);
			}
			else
			{
				irisamount = 0;
			}
		}
		amount = 1 - (elapsedtime / 2000);
		pulseradius = getvisionpulseradius(localclientnum);
		pulsemaxradius = getvisionpulsemaxradius(localclientnum);
		filter::set_filter_vision_pulse_constant(localclientnum, 3, 0, pulseradius);
		filter::set_filter_vision_pulse_constant(localclientnum, 3, 3, irisamount);
		filter::set_filter_vision_pulse_constant(localclientnum, 3, 11, pulsemaxradius);
		wait(0.016);
	}
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 0, pulsemaxradius + 1);
	self thread disableshader(localclientnum, 4);
}

/*
	Name: vision_pulse_owner_valid
	Namespace: gadget_vision_pulse
	Checksum: 0x448F12A2
	Offset: 0x9E8
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function vision_pulse_owner_valid(owner)
{
	if(isdefined(owner) && owner isplayer() && isalive(owner))
	{
		return true;
	}
	return false;
}

/*
	Name: watch_vision_pulse_owner_death
	Namespace: gadget_vision_pulse
	Checksum: 0x8A0FB79F
	Offset: 0xA40
	Size: 0xF6
	Parameters: 1
	Flags: Linked
*/
function watch_vision_pulse_owner_death(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	self endon(#"finished_local_pulse");
	self notify(#"watch_vision_pulse_owner_death");
	self endon(#"watch_vision_pulse_owner_death");
	owner = self.vision_pulse_owner;
	if(vision_pulse_owner_valid(owner))
	{
		owner util::waittill_any("entityshutdown", "death");
	}
	self notify(#"vision_pulse_owner_death");
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 7, 0);
	self thread disableshader(localclientnum, 4);
	self.vision_pulse_owner = undefined;
}

/*
	Name: do_vision_local_pulse
	Namespace: gadget_vision_pulse
	Checksum: 0x7FD14468
	Offset: 0xB40
	Size: 0x29A
	Parameters: 1
	Flags: Linked
*/
function do_vision_local_pulse(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	self endon(#"vision_pulse_owner_death");
	self notify(#"startvpshader");
	self notify(#"startlocalpulse");
	self endon(#"startlocalpulse");
	self thread watch_vision_pulse_owner_death(localclientnum);
	origin = getrevealpulseorigin(localclientnum);
	filter::enable_filter_vision_pulse(localclientnum, 3);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 5, 0.4);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 6, 0.0001);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 8, origin[0]);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 9, origin[1]);
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 7, 1);
	starttime = getservertime(localclientnum);
	while((getservertime(localclientnum) - starttime) < 4000)
	{
		if((getservertime(localclientnum) - starttime) < 2000)
		{
			pulseradius = ((getservertime(localclientnum) - starttime) / 2000) * 2000;
		}
		filter::set_filter_vision_pulse_constant(localclientnum, 3, 10, pulseradius);
		wait(0.016);
	}
	filter::set_filter_vision_pulse_constant(localclientnum, 3, 7, 0);
	self thread disableshader(localclientnum, 4);
	self notify(#"finished_local_pulse");
	self.vision_pulse_owner = undefined;
}

/*
	Name: vision_pulse_changed
	Namespace: gadget_vision_pulse
	Checksum: 0x5966EA40
	Offset: 0xDE8
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function vision_pulse_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(self == getlocalplayer(localclientnum))
		{
			if(isdemoplaying() && (bnewent || oldval == newval))
			{
				return;
			}
			self thread do_vision_world_pulse(localclientnum);
		}
	}
}

/*
	Name: do_reveal_enemy_pulse
	Namespace: gadget_vision_pulse
	Checksum: 0x5D4B6B41
	Offset: 0xE98
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function do_reveal_enemy_pulse(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	self notify(#"startenemypulse");
	self endon(#"startenemypulse");
	starttime = getservertime(localclientnum);
	currtime = starttime;
	self mapshaderconstant(localclientnum, 0, "scriptVector7", 0, 0, 0, 0);
	while((currtime - starttime) < 4000)
	{
		if((currtime - starttime) > 3500)
		{
			value = float(((currtime - starttime) - 3500) / 500);
			self mapshaderconstant(localclientnum, 0, "scriptVector7", value, 0, 0, 0);
		}
		wait(0.016);
		currtime = getservertime(localclientnum);
	}
}

/*
	Name: set_reveal_enemy
	Namespace: gadget_vision_pulse
	Checksum: 0xF31AB4C3
	Offset: 0xFF8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function set_reveal_enemy(localclientnum, on_off)
{
	if(on_off)
	{
		self thread do_reveal_enemy_pulse(localclientnum);
	}
	self duplicate_render::update_dr_flag(localclientnum, "reveal_enemy", on_off);
}

/*
	Name: set_reveal_self
	Namespace: gadget_vision_pulse
	Checksum: 0xA14C93CD
	Offset: 0x1060
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function set_reveal_self(localclientnum, on_off)
{
	if(on_off && self == getlocalplayer(localclientnum))
	{
		self thread do_vision_local_pulse(localclientnum);
	}
	else if(!on_off)
	{
		filter::set_filter_vision_pulse_constant(localclientnum, 3, 7, 0);
	}
}

/*
	Name: gadget_visionpulse_reveal
	Namespace: gadget_vision_pulse
	Checksum: 0x82DDD9A2
	Offset: 0x10F0
	Size: 0x164
	Parameters: 2
	Flags: None
*/
function gadget_visionpulse_reveal(localclientnum, breveal)
{
	self notify(#"gadget_visionpulse_changed");
	player = getlocalplayer(localclientnum);
	if(!isdefined(self.visionpulserevealself) && player == self)
	{
		self.visionpulserevealself = 0;
	}
	if(!isdefined(self.visionpulsereveal))
	{
		self.visionpulsereveal = 0;
	}
	if(player == self)
	{
		owner = self gadgetpulsegetowner(localclientnum);
		if(self.visionpulserevealself != breveal || (isdefined(self.vision_pulse_owner) && isdefined(owner) && self.vision_pulse_owner != owner))
		{
			self.vision_pulse_owner = owner;
			self.visionpulserevealself = breveal;
			self set_reveal_self(localclientnum, breveal);
		}
	}
	else if(self.visionpulsereveal != breveal)
	{
		self.visionpulsereveal = breveal;
		self set_reveal_enemy(localclientnum, breveal);
	}
}

