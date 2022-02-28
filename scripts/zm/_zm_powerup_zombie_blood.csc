// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_zombie_blood;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_zombie_blood
	Checksum: 0x10A3FFA2
	Offset: 0x2F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_zombie_blood", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_zombie_blood
	Checksum: 0xBC45CE0B
	Offset: 0x330
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localclient_connect(&function_a0b86d2c);
	registerclientfield("allplayers", "player_zombie_blood_fx", 21000, 1, "int", &toggle_player_zombie_blood_fx, 0, 1);
	level._effect["zombie_blood"] = "dlc5/tomb/fx_pwr_up_blood";
	level._effect["zombie_blood_1st"] = "dlc5/tomb/fx_pwr_up_blood_overlay";
	zm_powerups::include_zombie_powerup("zombie_blood");
	zm_powerups::add_zombie_powerup("zombie_blood", "powerup_zombie_blood");
	visionset_mgr::register_visionset_info("zm_tomb_in_plain_sight", 1, 31, undefined, "zm_tomb_in_plain_sight");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_tomb_in_plain_sight", 1, 1, "pstfx_zm_tomb_in_plain_sight");
}

/*
	Name: function_a0b86d2c
	Namespace: zm_powerup_zombie_blood
	Checksum: 0x5958323F
	Offset: 0x468
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_a0b86d2c(localclientnum)
{
	player = getlocalplayer(localclientnum);
	filter::init_filter_indices();
	filter::map_material_helper(player, "generic_filter_zombie_blood_tomb");
}

/*
	Name: toggle_player_zombie_blood_fx
	Namespace: zm_powerup_zombie_blood
	Checksum: 0x78770197
	Offset: 0x4D8
	Size: 0x1B6
	Parameters: 7
	Flags: Linked
*/
function toggle_player_zombie_blood_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(isspectating(localclientnum, 0) || isdemoplaying())
	{
		return;
	}
	if(newval == 1)
	{
		if(self islocalplayer() && self getlocalclientnumber() == localclientnum)
		{
			if(!isdefined(self.var_c5eb485f))
			{
				self.var_c5eb485f = playviewmodelfx(localclientnum, level._effect["zombie_blood_1st"], "tag_camera");
				playsound(localclientnum, "zmb_zombieblood_start", (0, 0, 0));
				audio::playloopat("zmb_zombieblood_loop", (0, 0, 0));
			}
		}
	}
	else if(isdefined(self.var_c5eb485f))
	{
		stopfx(localclientnum, self.var_c5eb485f);
		playsound(localclientnum, "zmb_zombieblood_stop", (0, 0, 0));
		audio::stoploopat("zmb_zombieblood_loop", (0, 0, 0));
		self.var_c5eb485f = undefined;
	}
}

