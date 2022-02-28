// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\bgbs\_zm_bgb_extra_credit;

#namespace zm_bgb_reign_drops;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_reign_drops
	Checksum: 0xDED1DE76
	Offset: 0x1E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_reign_drops", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_reign_drops
	Checksum: 0xEFAB241D
	Offset: 0x220
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_reign_drops", "activated", 2, undefined, undefined, &validation, &activation);
}

/*
	Name: validation
	Namespace: zm_bgb_reign_drops
	Checksum: 0x7F3D91FE
	Offset: 0x290
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function validation()
{
	if(isdefined(self.var_b90dda44) && self.var_b90dda44)
	{
		return false;
	}
	return true;
}

/*
	Name: activation
	Namespace: zm_bgb_reign_drops
	Checksum: 0x1CC28CDD
	Offset: 0x2C0
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	level thread bgb::function_dea74fb0("minigun", self function_ed573cc2(1));
	self thread zm_bgb_extra_credit::function_b18c3b2d(self function_ed573cc2(2));
	level thread bgb::function_dea74fb0("nuke", self function_ed573cc2(3));
	level thread bgb::function_dea74fb0("carpenter", self function_ed573cc2(4));
	level thread bgb::function_dea74fb0("free_perk", self function_ed573cc2(5));
	level thread bgb::function_dea74fb0("fire_sale", self function_ed573cc2(6));
	level thread bgb::function_dea74fb0("insta_kill", self function_ed573cc2(7));
	level thread bgb::function_dea74fb0("full_ammo", self function_ed573cc2(8));
	level thread bgb::function_dea74fb0("double_points", self function_ed573cc2(9));
	self.var_b90dda44 = 1;
	self thread function_7892610e();
}

/*
	Name: function_7892610e
	Namespace: zm_bgb_reign_drops
	Checksum: 0x495E79A9
	Offset: 0x4B0
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_7892610e()
{
	wait(0.05);
	n_start_time = gettime();
	n_total_time = 0;
	while(isdefined(level.active_powerups) && level.active_powerups.size)
	{
		wait(0.5);
		n_current_time = gettime();
		n_total_time = (n_current_time - n_start_time) / 1000;
		if(n_total_time >= 28)
		{
			break;
		}
	}
	self.var_b90dda44 = undefined;
}

/*
	Name: function_ed573cc2
	Namespace: zm_bgb_reign_drops
	Checksum: 0xAB8C78BA
	Offset: 0x550
	Size: 0x282
	Parameters: 1
	Flags: Linked
*/
function function_ed573cc2(n_position)
{
	v_powerup = self bgb::get_player_dropped_powerup_origin();
	v_up = vectorscale((0, 0, 1), 5);
	var_8e2dcc47 = (v_powerup + (anglestoforward(self.angles) * 60)) + v_up;
	var_682b51de = (var_8e2dcc47 + (anglestoforward(self.angles) * 60)) + v_up;
	switch(n_position)
	{
		case 1:
		{
			v_origin = (v_powerup + (anglestoright(self.angles) * -60)) + v_up;
			break;
		}
		case 2:
		{
			v_origin = v_powerup;
			break;
		}
		case 3:
		{
			v_origin = (v_powerup + (anglestoright(self.angles) * 60)) + v_up;
			break;
		}
		case 4:
		{
			v_origin = (var_8e2dcc47 + (anglestoright(self.angles) * -60)) + v_up;
			break;
		}
		case 5:
		{
			v_origin = var_8e2dcc47;
			break;
		}
		case 6:
		{
			v_origin = (var_8e2dcc47 + (anglestoright(self.angles) * 60)) + v_up;
			break;
		}
		case 7:
		{
			v_origin = (var_682b51de + (anglestoright(self.angles) * -60)) + v_up;
			break;
		}
		case 8:
		{
			v_origin = var_682b51de;
			break;
		}
		case 9:
		{
			v_origin = (var_682b51de + (anglestoright(self.angles) * 60)) + v_up;
			break;
		}
		default:
		{
			v_origin = v_powerup;
			break;
		}
	}
	return v_origin;
}

