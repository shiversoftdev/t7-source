// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace quadtank;

/*
	Name: __init__sytem__
	Namespace: quadtank
	Checksum: 0x11649A0F
	Offset: 0x230
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("quadtank", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: quadtank
	Checksum: 0x2119266F
	Offset: 0x270
	Size: 0xBC
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_vehicletype_callback("quadtank", &_setup_);
	clientfield::register("toplayer", "player_shock_fx", 1, 1, "int", &player_shock_fx_handler, 0, 0);
	clientfield::register("vehicle", "quadtank_trophy_state", 1, 1, "int", &update_trophy_system_state, 0, 0);
}

/*
	Name: _setup_
	Namespace: quadtank
	Checksum: 0xACFA3892
	Offset: 0x338
	Size: 0x88
	Parameters: 1
	Flags: None
*/
function _setup_(localclientnum)
{
	player = getlocalplayer(localclientnum);
	if(isdefined(player))
	{
		filter::init_filter_ev_interference(player);
	}
	self.notifyonbulletimpact = 1;
	self thread wait_for_bullet_impact(localclientnum);
	self.trophy_on = 0;
}

/*
	Name: player_shock_fx_handler
	Namespace: quadtank
	Checksum: 0x23D8A926
	Offset: 0x3C8
	Size: 0x6C
	Parameters: 7
	Flags: None
*/
function player_shock_fx_handler(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self))
	{
		self thread player_shock_fx_fade_off(localclientnum, 1, 1);
	}
}

/*
	Name: player_shock_fx_fade_off
	Namespace: quadtank
	Checksum: 0x28397F6F
	Offset: 0x440
	Size: 0x164
	Parameters: 3
	Flags: None
*/
function player_shock_fx_fade_off(localclientnum, amount, fadeouttime)
{
	self endon(#"disconnect");
	self notify(#"player_shock_fx_fade_off_end");
	self endon(#"player_shock_fx_fade_off_end");
	if(!isalive(self))
	{
		return;
	}
	starttime = gettime();
	filter::set_filter_ev_interference_amount(self, 4, amount);
	filter::enable_filter_ev_interference(self, 4);
	while(gettime() <= (starttime + (fadeouttime * 1000)) && isalive(self))
	{
		ratio = (gettime() - starttime) / (fadeouttime * 1000);
		currentvalue = lerpfloat(amount, 0, ratio);
		setfilterpassconstant(localclientnum, 4, 0, 0, currentvalue);
		wait(0.016);
	}
	setfilterpassenabled(localclientnum, 4, 0, 0);
}

/*
	Name: update_trophy_system_state
	Namespace: quadtank
	Checksum: 0xB278D423
	Offset: 0x5B0
	Size: 0x5C
	Parameters: 7
	Flags: None
*/
function update_trophy_system_state(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread set_trophy_state(localclientnum, newval === 1);
}

/*
	Name: set_trophy_state
	Namespace: quadtank
	Checksum: 0x309740BA
	Offset: 0x618
	Size: 0x44C
	Parameters: 2
	Flags: None
*/
function set_trophy_state(localclientnum, ison)
{
	self endon(#"entityshutdown");
	self notify(#"stop_set_trophy_state");
	self endon(#"stop_set_trophy_state");
	if(isdefined(self.trophydestroy_fx_handle))
	{
		stopfx(localclientnum, self.trophydestroy_fx_handle);
	}
	if(isdefined(self.trophylight_fx_handle))
	{
		stopfx(localclientnum, self.trophylight_fx_handle);
	}
	vehicle::wait_for_dobj(localclientnum);
	if(isdefined(self.scriptbundlesettings))
	{
		settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	if(!isdefined(settings))
	{
		return;
	}
	if(ison === 1)
	{
		warmuptime = (isdefined(settings.trophywarmup) ? settings.trophywarmup : 0.1);
		start = gettime();
		interval = 0.3;
		while(gettime() <= (start + (warmuptime * 1000)))
		{
			if(isdefined(settings.trophylight_fx_1) && isdefined(settings.trophylight_tag_1))
			{
				self.trophylight_fx_handle = playfxontag(localclientnum, settings.trophylight_fx_1, self, settings.trophylight_tag_1);
			}
			wait(0.05);
			if(isdefined(self.trophylight_fx_handle))
			{
				stopfx(localclientnum, self.trophylight_fx_handle);
			}
			wait(max(interval, 0.05));
			interval = interval * 0.8;
		}
		if(isdefined(settings.trophylight_fx_1) && isdefined(settings.trophylight_tag_1))
		{
			self.trophylight_fx_handle = playfxontag(localclientnum, settings.trophylight_fx_1, self, settings.trophylight_tag_1);
		}
		self.trophy_on = 1;
		self playloopsound("wpn_trophy_spin_loop");
		rate = 0;
		while(isdefined(settings.trophyanim) && rate < 1)
		{
			rate = rate + 0.02;
			self setanim(settings.trophyanim, 1, 0.1, rate);
			wait(0.016);
		}
		self setanim(settings.trophyanim, 1, 0.1, 1);
	}
	else
	{
		self.trophy_on = 0;
		self stopallloopsounds();
		if(isdefined(settings.trophyanim))
		{
			self setanim(settings.trophyanim, 0, 0.2, 1);
		}
		if(isdefined(settings.trophydestroyfx))
		{
			self.trophydestroy_fx_handle = playfxontag(localclientnum, settings.trophydestroyfx, self, "tag_target_lower");
		}
	}
}

/*
	Name: wait_for_bullet_impact
	Namespace: quadtank
	Checksum: 0xA8819A65
	Offset: 0xA70
	Size: 0x170
	Parameters: 1
	Flags: None
*/
function wait_for_bullet_impact(localclientnum)
{
	self endon(#"entityshutdown");
	if(isdefined(self.scriptbundlesettings))
	{
		settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	else
	{
		return;
	}
	while(true)
	{
		self waittill(#"damage", attacker, impactpos, effectdir, partname);
		if(partname == "tag_target_lower" || partname == "tag_target_upper" || partname == "tag_defense_active" || partname == "tag_body_animate")
		{
			if(self.trophy_on)
			{
				if(isdefined(attacker) && attacker isplayer() && attacker.team != self.team)
				{
					playfx(localclientnum, settings.weakspotfx, impactpos, effectdir);
					self playsound(0, "veh_quadtank_panel_hit");
				}
			}
		}
	}
}

