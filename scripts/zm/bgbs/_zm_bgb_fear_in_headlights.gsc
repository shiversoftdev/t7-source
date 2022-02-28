// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_fear_in_headlights;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0xFE62B444
	Offset: 0x1F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_fear_in_headlights", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0x5EB6920C
	Offset: 0x230
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
	bgb::register("zm_bgb_fear_in_headlights", "activated", 1, undefined, undefined, &validation, &activation);
}

/*
	Name: function_b13c2f15
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0x45567D84
	Offset: 0x2A0
	Size: 0x84
	Parameters: 0
	Flags: Linked, Private
*/
function private function_b13c2f15()
{
	self endon(#"hash_4e7f43fc");
	self waittill(#"death");
	if(isdefined(self) && self ispaused())
	{
		self setentitypaused(0);
		if(!self isragdoll())
		{
			self startragdoll();
		}
	}
}

/*
	Name: function_b8eb33c5
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0x12DC37BE
	Offset: 0x330
	Size: 0xAC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_b8eb33c5(ai)
{
	ai notify(#"hash_4e7f43fc");
	ai thread function_b13c2f15();
	ai setentitypaused(1);
	ai.var_70a58794 = ai.b_ignore_cleanup;
	ai.b_ignore_cleanup = 1;
	ai.var_7f7a0b19 = ai.is_inert;
	ai.is_inert = 1;
}

/*
	Name: function_31a2964e
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0x4053149D
	Offset: 0x3E8
	Size: 0xA8
	Parameters: 1
	Flags: Linked, Private
*/
function private function_31a2964e(ai)
{
	ai notify(#"hash_4e7f43fc");
	ai setentitypaused(0);
	if(isdefined(ai.var_7f7a0b19))
	{
		ai.is_inert = ai.var_7f7a0b19;
	}
	if(isdefined(ai.var_70a58794))
	{
		ai.b_ignore_cleanup = ai.var_70a58794;
	}
	else
	{
		ai.b_ignore_cleanup = 0;
	}
}

/*
	Name: function_723d94f5
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0xAA2BEEBD
	Offset: 0x498
	Size: 0x1B2
	Parameters: 3
	Flags: Linked, Private
*/
function private function_723d94f5(allai, trace, degree = 45)
{
	var_f1649153 = allai;
	players = getplayers();
	var_445b9352 = cos(degree);
	foreach(player in players)
	{
		var_f1649153 = player cantseeentities(var_f1649153, var_445b9352, trace);
	}
	foreach(ai in var_f1649153)
	{
		if(isalive(ai))
		{
			function_31a2964e(ai);
		}
	}
}

/*
	Name: validation
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0x528443D1
	Offset: 0x658
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function validation()
{
	if(bgb::is_team_active("zm_bgb_fear_in_headlights"))
	{
		return false;
	}
	return true;
}

/*
	Name: activation
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0xE94CB83F
	Offset: 0x688
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self endon(#"disconnect");
	self thread function_deeb696f();
	self playsound("zmb_bgb_fearinheadlights_start");
	self playloopsound("zmb_bgb_fearinheadlights_loop");
	self thread kill_fear_in_headlights();
	self bgb::run_timer(120);
	self notify(#"kill_fear_in_headlights");
}

/*
	Name: function_deeb696f
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0xB4D3AC8
	Offset: 0x738
	Size: 0x318
	Parameters: 0
	Flags: Linked
*/
function function_deeb696f()
{
	self endon(#"disconnect");
	self endon(#"kill_fear_in_headlights");
	var_bd6badee = 1200 * 1200;
	while(true)
	{
		allai = getaiarray();
		foreach(ai in allai)
		{
			if(isdefined(ai.var_48cabef5) && ai [[ai.var_48cabef5]]())
			{
				continue;
			}
			if(isalive(ai) && !ai ispaused() && ai.team == level.zombie_team && !ai ishidden() && (!(isdefined(ai.bgbignorefearinheadlights) && ai.bgbignorefearinheadlights)))
			{
				function_b8eb33c5(ai);
			}
		}
		var_e4760c66 = [];
		var_e37fbbbd = [];
		foreach(ai in allai)
		{
			if(isdefined(ai.aat_turned) && ai.aat_turned && ai ispaused())
			{
				function_31a2964e(ai);
				continue;
			}
			if(distance2dsquared(ai.origin, self.origin) >= var_bd6badee)
			{
				var_e4760c66[var_e4760c66.size] = ai;
				continue;
			}
			var_e37fbbbd[var_e37fbbbd.size] = ai;
		}
		function_723d94f5(var_e4760c66, 1);
		function_723d94f5(var_e37fbbbd, 0, 75);
		wait(0.05);
	}
}

/*
	Name: kill_fear_in_headlights
	Namespace: zm_bgb_fear_in_headlights
	Checksum: 0x95068479
	Offset: 0xA58
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function kill_fear_in_headlights()
{
	str_notify = self util::waittill_any_return("death", "kill_fear_in_headlights");
	if(str_notify == "kill_fear_in_headlights")
	{
		self stoploopsound();
		self playsound("zmb_bgb_fearinheadlights_end");
	}
	allai = getaiarray();
	foreach(ai in allai)
	{
		function_31a2964e(ai);
	}
}

