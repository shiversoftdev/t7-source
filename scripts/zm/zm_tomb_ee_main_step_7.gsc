// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_tomb_chamber;
#using scripts\zm\zm_tomb_ee_main;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_ee_main_step_7;

/*
	Name: init
	Namespace: zm_tomb_ee_main_step_7
	Checksum: 0x3560A554
	Offset: 0x2A0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("little_girl_lost", "step_7", &init_stage, &stage_logic, &exit_stage);
}

/*
	Name: init_stage
	Namespace: zm_tomb_ee_main_step_7
	Checksum: 0x9DB3FBA0
	Offset: 0x300
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function init_stage()
{
	level._cur_stage_name = "step_7";
	level.n_ee_portal_souls = 0;
}

/*
	Name: stage_logic
	Namespace: zm_tomb_ee_main_step_7
	Checksum: 0xAAA60187
	Offset: 0x328
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	/#
		iprintln(level._cur_stage_name + "");
	#/
	level thread monitor_puzzle_portal();
	level flag::wait_till("ee_souls_absorbed");
	util::wait_network_frame();
	zm_sidequests::stage_completed("little_girl_lost", level._cur_stage_name);
}

/*
	Name: exit_stage
	Namespace: zm_tomb_ee_main_step_7
	Checksum: 0xBD8C55D0
	Offset: 0x3C8
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function exit_stage(success)
{
	level notify(#"hash_7f00c03c");
}

/*
	Name: ee_zombie_killed_override
	Namespace: zm_tomb_ee_main_step_7
	Checksum: 0xDC7252BC
	Offset: 0x3F0
	Size: 0x1A4
	Parameters: 8
	Flags: Linked
*/
function ee_zombie_killed_override(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime)
{
	if(isdefined(attacker) && isplayer(attacker) && zm_tomb_chamber::is_point_in_chamber(self.origin))
	{
		level.n_ee_portal_souls++;
		if(level.n_ee_portal_souls == 1)
		{
			level thread zm_tomb_ee_main::ee_samantha_say("vox_sam_generic_encourage_3");
		}
		else
		{
			if(level.n_ee_portal_souls == floor(33.33333))
			{
				level thread zm_tomb_ee_main::ee_samantha_say("vox_sam_generic_encourage_4");
			}
			else
			{
				if(level.n_ee_portal_souls == floor(66.66666))
				{
					level thread zm_tomb_ee_main::ee_samantha_say("vox_sam_generic_encourage_5");
				}
				else if(level.n_ee_portal_souls == 100)
				{
					level thread zm_tomb_ee_main::ee_samantha_say("vox_sam_generic_encourage_0");
					level flag::set("ee_souls_absorbed");
				}
			}
		}
		self clientfield::set("ee_zombie_soul_portal", 1);
	}
}

/*
	Name: monitor_puzzle_portal
	Namespace: zm_tomb_ee_main_step_7
	Checksum: 0x29A31F6
	Offset: 0x5A0
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function monitor_puzzle_portal()
{
	/#
		if(isdefined(level.ee_debug) && level.ee_debug)
		{
			level flag::set("");
			level clientfield::set("", 1);
			return;
		}
	#/
	while(!level flag::get("ee_souls_absorbed"))
	{
		if(zm_tomb_ee_main::all_staffs_inserted_in_puzzle_room() && !level flag::get("ee_sam_portal_active"))
		{
			level flag::set("ee_sam_portal_active");
			level clientfield::set("ee_sam_portal", 1);
		}
		else if(!zm_tomb_ee_main::all_staffs_inserted_in_puzzle_room() && level flag::get("ee_sam_portal_active"))
		{
			level flag::clear("ee_sam_portal_active");
			level clientfield::set("ee_sam_portal", 0);
		}
		wait(0.5);
	}
}

