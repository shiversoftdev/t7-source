// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_stalingrad_audio;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_audio
	Checksum: 0x717361B0
	Offset: 0x2A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_audio
	Checksum: 0x2FCD0A30
	Offset: 0x2E8
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "ee_anthem_pa", 12000, 1, "int", &function_a50e0efb, 0, 0);
	clientfield::register("scriptmover", "ee_ballerina", 12000, 2, "int", &function_41eaf8b8, 0, 0);
	level._effect["ee_anthem_pa_appear"] = "dlc3/stalingrad/fx_main_anomoly_emp_pulse";
	level._effect["ee_anthem_pa_explode"] = "dlc3/stalingrad/fx_main_impact_success";
	level._effect["ee_ballerina_appear"] = "dlc3/stalingrad/fx_main_impact_success";
	level._effect["ee_ballerina_disappear"] = "dlc3/stalingrad/fx_main_impact_success";
}

/*
	Name: function_a50e0efb
	Namespace: zm_stalingrad_audio
	Checksum: 0x95348088
	Offset: 0x3F8
	Size: 0x134
	Parameters: 7
	Flags: Linked
*/
function function_a50e0efb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["ee_anthem_pa_appear"], self.origin);
		audio::playloopat("zmb_nikolai_mus_pa_anthem_lp", self.origin);
		wait(randomfloatrange(0.05, 0.35));
		playsound(0, "zmb_nikolai_mus_pa_anthem_start", self.origin);
	}
	else
	{
		playfx(localclientnum, level._effect["ee_anthem_pa_explode"], self.origin);
		audio::stoploopat("zmb_nikolai_mus_pa_anthem_lp", self.origin);
	}
}

/*
	Name: function_41eaf8b8
	Namespace: zm_stalingrad_audio
	Checksum: 0x6C8710D3
	Offset: 0x538
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function function_41eaf8b8(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(newval == 1)
		{
			playfx(localclientnum, level._effect["ee_ballerina_appear"], self.origin);
			playsound(0, "zmb_sam_egg_appear", self.origin);
		}
	}
	else
	{
		playfx(localclientnum, level._effect["ee_ballerina_disappear"], self.origin);
		playsound(0, "zmb_sam_egg_disappear", self.origin);
	}
}

