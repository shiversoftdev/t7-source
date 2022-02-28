// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace killstreak_hacking;

/*
	Name: enable_hacking
	Namespace: killstreak_hacking
	Checksum: 0x9A316672
	Offset: 0x218
	Size: 0x1F0
	Parameters: 3
	Flags: Linked
*/
function enable_hacking(killstreakname, prehackfunction, posthackfunction)
{
	killstreak = self;
	level.challenge_scorestreaksenabled = 1;
	killstreak.challenge_isscorestreak = 1;
	killstreak.killstreak_hackedcallback = &_hacked_callback;
	killstreak.killstreakprehackfunction = prehackfunction;
	killstreak.killstreakposthackfunction = posthackfunction;
	killstreak.hackertoolinnertimems = killstreak killstreak_bundles::get_hack_tool_inner_time();
	killstreak.hackertooloutertimems = killstreak killstreak_bundles::get_hack_tool_outer_time();
	killstreak.hackertoolinnerradius = killstreak killstreak_bundles::get_hack_tool_inner_radius();
	killstreak.hackertoolouterradius = killstreak killstreak_bundles::get_hack_tool_outer_radius();
	killstreak.hackertoolradius = killstreak.hackertoolouterradius;
	killstreak.killstreakhackloopfx = killstreak killstreak_bundles::get_hack_loop_fx();
	killstreak.killstreakhackfx = killstreak killstreak_bundles::get_hack_fx();
	killstreak.killstreakhackscoreevent = killstreak killstreak_bundles::get_hack_scoreevent();
	killstreak.killstreakhacklostlineofsightlimitms = killstreak killstreak_bundles::get_lost_line_of_sight_limit_msec();
	killstreak.killstreakhacklostlineofsighttimems = killstreak killstreak_bundles::get_hack_tool_no_line_of_sight_time();
	killstreak.killstreak_hackedprotection = killstreak killstreak_bundles::get_hack_protection();
}

/*
	Name: disable_hacking
	Namespace: killstreak_hacking
	Checksum: 0x80672ED6
	Offset: 0x410
	Size: 0x22
	Parameters: 0
	Flags: None
*/
function disable_hacking()
{
	killstreak = self;
	killstreak.killstreak_hackedcallback = undefined;
}

/*
	Name: hackerfx
	Namespace: killstreak_hacking
	Checksum: 0x9F1CC764
	Offset: 0x440
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function hackerfx()
{
	killstreak = self;
	if(isdefined(killstreak.killstreakhackfx) && killstreak.killstreakhackfx != "")
	{
		playfxontag(killstreak.killstreakhackfx, killstreak, "tag_origin");
	}
}

/*
	Name: hackerloopfx
	Namespace: killstreak_hacking
	Checksum: 0x9EA8BC02
	Offset: 0x4B8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function hackerloopfx()
{
	killstreak = self;
	if(isdefined(killstreak.killstreakloophackfx) && killstreak.killstreakloophackfx != "")
	{
		playfxontag(killstreak.killstreakloophackfx, killstreak, "tag_origin");
	}
}

/*
	Name: _hacked_callback
	Namespace: killstreak_hacking
	Checksum: 0x287BDD31
	Offset: 0x530
	Size: 0x1E4
	Parameters: 1
	Flags: Linked, Private
*/
function private _hacked_callback(hacker)
{
	killstreak = self;
	originalowner = killstreak.owner;
	if(isdefined(killstreak.killstreakhackscoreevent))
	{
		scoreevents::processscoreevent(killstreak.killstreakhackscoreevent, hacker, originalowner, level.weaponhackertool);
	}
	if(isdefined(killstreak.killstreakprehackfunction))
	{
		killstreak thread [[killstreak.killstreakprehackfunction]](hacker);
	}
	killstreak killstreaks::configure_team_internal(hacker, 1);
	killstreak clientfield::set("enemyvehicle", 2);
	if(isdefined(killstreak.killstreakhackfx))
	{
		killstreak thread hackerfx();
	}
	if(isdefined(killstreak.killstreakhackloopfx))
	{
		killstreak thread hackerloopfx();
	}
	if(isdefined(killstreak.killstreakposthackfunction))
	{
		killstreak thread [[killstreak.killstreakposthackfunction]](hacker);
	}
	killstreaktype = killstreak.killstreaktype;
	if(isdefined(killstreak.hackedkillstreakref))
	{
		killstreaktype = killstreak.hackedkillstreakref;
	}
	level thread popups::displaykillstreakhackedteammessagetoall(killstreaktype, hacker);
	killstreak _update_health(hacker);
}

/*
	Name: override_hacked_killstreak_reference
	Namespace: killstreak_hacking
	Checksum: 0x98E3CB3C
	Offset: 0x720
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function override_hacked_killstreak_reference(killstreakref)
{
	killstreak = self;
	killstreak.hackedkillstreakref = killstreakref;
}

/*
	Name: get_hacked_timeout_duration_ms
	Namespace: killstreak_hacking
	Checksum: 0x19ECF789
	Offset: 0x758
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function get_hacked_timeout_duration_ms()
{
	killstreak = self;
	timeout = killstreak killstreak_bundles::get_hack_timeout();
	if(!isdefined(timeout) || timeout <= 0)
	{
		/#
			/#
				assertmsg(("" + killstreak.killstreaktype) + "");
			#/
		#/
		return;
	}
	return timeout * 1000;
}

/*
	Name: set_vehicle_drivable_time_starting_now
	Namespace: killstreak_hacking
	Checksum: 0x74AD9713
	Offset: 0x7F8
	Size: 0x6A
	Parameters: 2
	Flags: Linked
*/
function set_vehicle_drivable_time_starting_now(killstreak, duration_ms = -1)
{
	if(duration_ms == -1)
	{
		duration_ms = killstreak get_hacked_timeout_duration_ms();
	}
	return self vehicle::set_vehicle_drivable_time_starting_now(duration_ms);
}

/*
	Name: _update_health
	Namespace: killstreak_hacking
	Checksum: 0x11725507
	Offset: 0x870
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function _update_health(hacker)
{
	killstreak = self;
	if(isdefined(killstreak.hackedhealthupdatecallback))
	{
		killstreak [[killstreak.hackedhealthupdatecallback]](hacker);
	}
	else
	{
		if(issentient(killstreak))
		{
			hackedhealth = killstreak_bundles::get_hacked_health(killstreak.killstreaktype);
			/#
				assert(isdefined(hackedhealth));
			#/
			if(self.health > hackedhealth)
			{
				self.health = hackedhealth;
			}
		}
		else
		{
			/#
				hacker iprintlnbold("");
			#/
		}
	}
}

/*
	Name: killstreak_switch_team_end
	Namespace: killstreak_hacking
	Checksum: 0x620FB7D2
	Offset: 0x968
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function killstreak_switch_team_end()
{
	/#
		killstreakentity = self;
		killstreakentity notify(#"killstreak_switch_team_end");
	#/
}

/*
	Name: killstreak_switch_team
	Namespace: killstreak_hacking
	Checksum: 0xE90C2A8D
	Offset: 0x998
	Size: 0x202
	Parameters: 1
	Flags: Linked
*/
function killstreak_switch_team(owner)
{
	/#
		killstreakentity = self;
		killstreakentity notify(#"killstreak_switch_team_singleton");
		killstreakentity endon(#"killstreak_switch_team_singleton");
		killstreakentity endon(#"death");
		setdvar("", "");
		while(true)
		{
			wait(0.5);
			devgui_int = getdvarint("");
			if(devgui_int != 0)
			{
				team = "";
				if(isdefined(level.getenemyteam) && isdefined(owner) && isdefined(owner.team))
				{
					team = [[level.getenemyteam]](owner.team);
				}
				if(isdefined(level.devongetormakebot))
				{
					player = [[level.devongetormakebot]](team);
				}
				if(!isdefined(player))
				{
					println("");
					wait(1);
					continue;
				}
				if(!isdefined(killstreakentity.killstreak_hackedcallback))
				{
					/#
						iprintlnbold("");
					#/
					return;
				}
				killstreakentity notify(#"killstreak_hacked", player);
				killstreakentity.previouslyhacked = 1;
				killstreakentity [[killstreakentity.killstreak_hackedcallback]](player);
				wait(0.5);
				setdvar("", "");
				return;
			}
		}
	#/
}

