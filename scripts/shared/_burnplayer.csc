// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace burnplayer;

/*
	Name: __init__sytem__
	Namespace: burnplayer
	Checksum: 0x2C5A3FB8
	Offset: 0x5C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("burnplayer", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: burnplayer
	Checksum: 0x2AACD918
	Offset: 0x608
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "burn", 1, 1, "int", &burning_callback, 0, 0);
	clientfield::register("playercorpse", "burned_effect", 1, 1, "int", &burning_corpse_callback, 0, 1);
	loadeffects();
	callback::on_localplayer_spawned(&on_localplayer_spawned);
	callback::on_localclient_connect(&on_local_client_connect);
}

/*
	Name: loadeffects
	Namespace: burnplayer
	Checksum: 0x823E30CC
	Offset: 0x6F8
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function loadeffects()
{
	level._effect["burn_j_elbow_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["burn_j_elbow_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["burn_j_shoulder_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["burn_j_shoulder_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["burn_j_spine4_loop"] = "fire/fx_fire_ai_human_torso_loop";
	level._effect["burn_j_hip_le_loop"] = "fire/fx_fire_ai_human_hip_left_loop";
	level._effect["burn_j_hip_ri_loop"] = "fire/fx_fire_ai_human_hip_right_loop";
	level._effect["burn_j_knee_le_loop"] = "fire/fx_fire_ai_human_leg_left_loop";
	level._effect["burn_j_knee_ri_loop"] = "fire/fx_fire_ai_human_leg_right_loop";
	level._effect["burn_j_head_loop"] = "fire/fx_fire_ai_human_head_loop";
	level._effect["burn_j_elbow_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["burn_j_elbow_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["burn_j_shoulder_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["burn_j_shoulder_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["burn_j_spine4_os"] = "fire/fx_fire_ai_human_torso_os";
	level._effect["burn_j_hip_le_os"] = "fire/fx_fire_ai_human_hip_left_os";
	level._effect["burn_j_hip_ri_os"] = "fire/fx_fire_ai_human_hip_right_os";
	level._effect["burn_j_knee_le_os"] = "fire/fx_fire_ai_human_leg_left_os";
	level._effect["burn_j_knee_ri_os"] = "fire/fx_fire_ai_human_leg_right_os";
	level._effect["burn_j_head_os"] = "fire/fx_fire_ai_human_head_os";
	level.burntags = array("j_elbow_le", "j_elbow_ri", "j_shoulder_le", "j_shoulder_ri", "j_spine4", "j_spinelower", "j_hip_le", "j_hip_ri", "j_head", "j_knee_le", "j_knee_ri");
}

/*
	Name: on_local_client_connect
	Namespace: burnplayer
	Checksum: 0x86C9B965
	Offset: 0x9A8
	Size: 0x19C
	Parameters: 1
	Flags: Linked
*/
function on_local_client_connect(localclientnum)
{
	registerrewindfx(localclientnum, level._effect["burn_j_elbow_le_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_elbow_ri_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_shoulder_le_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_shoulder_ri_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_spine4_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_hip_le_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_hip_ri_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_knee_le_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_knee_ri_loop"]);
	registerrewindfx(localclientnum, level._effect["burn_j_head_loop"]);
}

/*
	Name: on_localplayer_spawned
	Namespace: burnplayer
	Checksum: 0x176A723C
	Offset: 0xB50
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_spawned(localclientnum)
{
}

/*
	Name: burning_callback
	Namespace: burnplayer
	Checksum: 0x116D6DD1
	Offset: 0xB68
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function burning_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self burn_on(localclientnum);
	}
	else
	{
		self burn_off(localclientnum);
	}
}

/*
	Name: burning_corpse_callback
	Namespace: burnplayer
	Checksum: 0xD842ABAD
	Offset: 0xBF0
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function burning_corpse_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self set_corpse_burning(localclientnum);
	}
	else
	{
		self burn_off(localclientnum);
	}
}

/*
	Name: set_corpse_burning
	Namespace: burnplayer
	Checksum: 0x7DD0ECEA
	Offset: 0xC78
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function set_corpse_burning(localclientnum)
{
	self thread _burnbody(localclientnum);
}

/*
	Name: burn_off
	Namespace: burnplayer
	Checksum: 0x7139D5A5
	Offset: 0xCA8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function burn_off(localclientnum)
{
	self notify(#"burn_off");
	if(getlocalplayer(localclientnum) == self)
	{
		self postfx::exitpostfxbundle();
	}
}

/*
	Name: burn_on
	Namespace: burnplayer
	Checksum: 0xF0906393
	Offset: 0xD00
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function burn_on(localclientnum)
{
	if(getlocalplayer(localclientnum) != self || isthirdperson(localclientnum))
	{
		self thread _burnbody(localclientnum);
	}
	if(getlocalplayer(localclientnum) == self && !isthirdperson(localclientnum))
	{
		self thread burn_on_postfx();
	}
}

/*
	Name: burn_on_postfx
	Namespace: burnplayer
	Checksum: 0xEF32489E
	Offset: 0xDB8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function burn_on_postfx()
{
	self endon(#"entityshutdown");
	self endon(#"burn_off");
	self endon(#"death");
	self notify(#"burn_on_postfx");
	self endon(#"burn_on_postfx");
	self thread postfx::playpostfxbundle("pstfx_burn_loop");
}

/*
	Name: _burntag
	Namespace: burnplayer
	Checksum: 0x4CA29FA9
	Offset: 0xE20
	Size: 0x9C
	Parameters: 3
	Flags: Linked, Private
*/
function private _burntag(localclientnum, tag, postfix)
{
	if(isdefined(self) && self hasdobj(localclientnum))
	{
		fxname = ("burn_" + tag) + postfix;
		if(isdefined(level._effect[fxname]))
		{
			return playfxontag(localclientnum, level._effect[fxname], self, tag);
		}
	}
}

/*
	Name: _burntagson
	Namespace: burnplayer
	Checksum: 0x4D43A99B
	Offset: 0xEC8
	Size: 0x12C
	Parameters: 2
	Flags: Linked, Private
*/
function private _burntagson(localclientnum, tags)
{
	if(!isdefined(self))
	{
		return;
	}
	self endon(#"entityshutdown");
	self endon(#"burn_off");
	self notify(#"burn_tags_on");
	self endon(#"burn_tags_on");
	activefx = [];
	for(i = 0; i < tags.size; i++)
	{
		activefx[activefx.size] = self _burntag(localclientnum, tags[i], "_loop");
	}
	burnsound = self playloopsound("chr_burn_loop_overlay", 0.5);
	self thread _burntagswatchend(localclientnum, activefx, burnsound);
	self thread _burntagswatchclear(localclientnum, activefx, burnsound);
}

/*
	Name: _burnbody
	Namespace: burnplayer
	Checksum: 0xDDE1AF08
	Offset: 0x1000
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private _burnbody(localclientnum)
{
	self endon(#"entityshutdown");
	self thread _burntagson(localclientnum, level.burntags);
}

/*
	Name: _burntagswatchend
	Namespace: burnplayer
	Checksum: 0xF6F2BF4C
	Offset: 0x1040
	Size: 0xF2
	Parameters: 3
	Flags: Linked, Private
*/
function private _burntagswatchend(localclientnum, fxarray, burnsound)
{
	self endon(#"entityshutdown");
	self waittill(#"burn_off");
	if(isdefined(burnsound))
	{
		self stoploopsound(burnsound, 1);
	}
	if(isdefined(fxarray))
	{
		foreach(fx in fxarray)
		{
			stopfx(localclientnum, fx);
		}
	}
}

/*
	Name: _burntagswatchclear
	Namespace: burnplayer
	Checksum: 0xAC4DE82A
	Offset: 0x1140
	Size: 0xEA
	Parameters: 3
	Flags: Linked, Private
*/
function private _burntagswatchclear(localclientnum, fxarray, burnsound)
{
	self endon(#"burn_off");
	self waittill(#"entityshutdown");
	if(isdefined(burnsound))
	{
		stopsound(burnsound);
	}
	if(isdefined(fxarray))
	{
		foreach(fx in fxarray)
		{
			stopfx(localclientnum, fx);
		}
	}
}

