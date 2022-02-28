// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_grappler;

/*
	Name: __init__sytem__
	Namespace: zm_grappler
	Checksum: 0xC67EF4F
	Offset: 0x220
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_grappler", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_grappler
	Checksum: 0x3225733
	Offset: 0x268
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "grappler_beam_source", 15000, 1, "int");
	clientfield::register("scriptmover", "grappler_beam_target", 15000, 1, "int");
}

/*
	Name: __main__
	Namespace: zm_grappler
	Checksum: 0x99EC1590
	Offset: 0x2D8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
}

/*
	Name: start_grapple
	Namespace: zm_grappler
	Checksum: 0xE69FE55D
	Offset: 0x2E8
	Size: 0x3BC
	Parameters: 4
	Flags: Linked
*/
function start_grapple(var_683c052c, var_a2613153, n_type, n_speed = 1800)
{
	/#
		assert(n_type == 2);
	#/
	e_source = function_7027852f(var_683c052c function_1e702195(), var_683c052c.angles);
	var_b7c15e33 = function_7027852f(var_683c052c function_1e702195(), var_683c052c.angles * -1);
	thread function_28ac2916(e_source, var_b7c15e33);
	if(isdefined(var_b7c15e33))
	{
		var_a2613153 function_63b4b8a5(1);
		util::wait_network_frame();
		n_time = function_3e1b1cea(var_683c052c, var_a2613153, n_speed);
		var_b7c15e33.origin = var_683c052c function_1e702195();
		var_c35f0f99 = var_a2613153 function_1e702195();
		var_b7c15e33 playsound("zmb_grapple_start");
		var_b7c15e33 moveto(var_c35f0f99, n_time);
		var_b7c15e33 waittill(#"movedone");
		var_8986f6e8 = var_c35f0f99 - var_a2613153.origin;
		var_b7c15e33.origin = var_a2613153.origin;
		if(isplayer(var_a2613153))
		{
			var_a2613153 playerlinkto(var_b7c15e33, "tag_origin");
		}
		else
		{
			var_a2613153 linkto(var_b7c15e33);
		}
		var_a2613153 playsound("zmb_grapple_grab");
		var_de84fe14 = var_683c052c function_1e702195() - var_8986f6e8;
		var_b7c15e33 moveto(var_de84fe14, n_time);
		var_b7c15e33 playsound("zmb_grapple_pull");
		var_b7c15e33 waittill(#"movedone");
		function_b7c692b0();
		var_b7c15e33 clientfield::set("grappler_beam_target", 0);
		var_a2613153 unlink();
		var_a2613153 function_63b4b8a5(0);
		util::wait_network_frame();
		function_58192f77(var_b7c15e33);
		function_58192f77(e_source);
	}
}

/*
	Name: function_b7c692b0
	Namespace: zm_grappler
	Checksum: 0x140F8570
	Offset: 0x6B0
	Size: 0x28
	Parameters: 0
	Flags: Linked, Private
*/
function private function_b7c692b0()
{
	while(isdefined(level.var_5b94112c) && level.var_5b94112c)
	{
		wait(0.05);
	}
}

/*
	Name: function_28ac2916
	Namespace: zm_grappler
	Checksum: 0xD04D742B
	Offset: 0x6E0
	Size: 0xB0
	Parameters: 2
	Flags: Linked, Private
*/
function private function_28ac2916(e_source, e_target)
{
	function_b7c692b0();
	level.var_5b94112c = 1;
	if(isdefined(e_source))
	{
		e_source clientfield::set("grappler_beam_source", 1);
	}
	util::wait_network_frame();
	if(isdefined(e_target))
	{
		e_target clientfield::set("grappler_beam_target", 1);
	}
	util::wait_network_frame();
	level.var_5b94112c = 0;
}

/*
	Name: function_3e1b1cea
	Namespace: zm_grappler
	Checksum: 0x6D5DC9A2
	Offset: 0x798
	Size: 0x72
	Parameters: 3
	Flags: Linked, Private
*/
function private function_3e1b1cea(var_cef3781d, var_a9fb66fa, n_speed)
{
	n_distance = distance(var_cef3781d function_1e702195(), var_a9fb66fa function_1e702195());
	return n_distance / n_speed;
}

/*
	Name: function_63b4b8a5
	Namespace: zm_grappler
	Checksum: 0xE8143A3E
	Offset: 0x818
	Size: 0x104
	Parameters: 1
	Flags: Linked, Private
*/
function private function_63b4b8a5(var_365c612)
{
	if(!isdefined(self))
	{
		return;
	}
	if(var_365c612 != (isdefined(self.var_14f171d3) && self.var_14f171d3))
	{
		self.var_14f171d3 = var_365c612;
		if(isplayer(self))
		{
			self util::freeze_player_controls(var_365c612);
			self setplayercollision(!var_365c612);
			if(var_365c612)
			{
				self zm_utility::increment_ignoreme();
				self.var_61f01d73 = self enableinvulnerability();
			}
			else
			{
				self zm_utility::decrement_ignoreme();
				if(!(isdefined(self.var_61f01d73) && self.var_61f01d73))
				{
					self disableinvulnerability();
				}
			}
		}
	}
}

/*
	Name: function_1e702195
	Namespace: zm_grappler
	Checksum: 0x48E5527D
	Offset: 0x928
	Size: 0x46
	Parameters: 0
	Flags: Linked, Private
*/
function private function_1e702195()
{
	if(isdefined(self.var_c932472f))
	{
		v_origin = self gettagorigin(self.var_c932472f);
		return v_origin;
	}
	return self.origin;
}

/*
	Name: function_7027852f
	Namespace: zm_grappler
	Checksum: 0x805558DF
	Offset: 0x978
	Size: 0x54
	Parameters: 2
	Flags: Linked, Private
*/
function private function_7027852f(v_origin, v_angles)
{
	model = "tag_origin";
	e_ent = util::spawn_model(model, v_origin, v_angles);
	return e_ent;
}

/*
	Name: function_58192f77
	Namespace: zm_grappler
	Checksum: 0x41501F2B
	Offset: 0x9D8
	Size: 0x2C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_58192f77(var_b7c15e33)
{
	if(isdefined(var_b7c15e33))
	{
		var_b7c15e33 delete();
	}
}

