// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_microwavegun;

/*
	Name: __init__sytem__
	Namespace: zm_weap_microwavegun
	Checksum: 0xE4DC6790
	Offset: 0x2E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_microwavegun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_microwavegun
	Checksum: 0xB583057F
	Offset: 0x328
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("actor", "toggle_microwavegun_hit_response", 21000, 1, "int", &microwavegun_zombie_initial_hit_response, 0, 0);
	clientfield::register("actor", "toggle_microwavegun_expand_response", 21000, 1, "int", &microwavegun_zombie_expand_response, 0, 0);
	clientfield::register("clientuimodel", "hudItems.showDpadLeft_WaveGun", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "hudItems.dpadLeftAmmo", 21000, 5, "int", undefined, 0, 0);
	level._effect["microwavegun_sizzle_blood_eyes"] = "dlc5/zmb_weapon/fx_sizzle_blood_eyes";
	level._effect["microwavegun_sizzle_death_mist"] = "dlc5/zmb_weapon/fx_sizzle_mist";
	level._effect["microwavegun_sizzle_death_mist_low_g"] = "dlc5/zmb_weapon/fx_sizzle_mist_low_g";
	level thread player_init();
}

/*
	Name: player_init
	Namespace: zm_weap_microwavegun
	Checksum: 0x852BA97
	Offset: 0x4A0
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function player_init()
{
	util::waitforclient(0);
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
	}
}

/*
	Name: microwavegun_create_hit_response_fx
	Namespace: zm_weap_microwavegun
	Checksum: 0xDCAF4BA2
	Offset: 0x528
	Size: 0x68
	Parameters: 3
	Flags: Linked
*/
function microwavegun_create_hit_response_fx(localclientnum, tag, effect)
{
	if(!isdefined(self._microwavegun_hit_response_fx[localclientnum][tag]))
	{
		self._microwavegun_hit_response_fx[localclientnum][tag] = playfxontag(localclientnum, effect, self, tag);
	}
}

/*
	Name: microwavegun_delete_hit_response_fx
	Namespace: zm_weap_microwavegun
	Checksum: 0x30D3C6F4
	Offset: 0x598
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function microwavegun_delete_hit_response_fx(localclientnum, tag)
{
	if(isdefined(self._microwavegun_hit_response_fx[localclientnum][tag]))
	{
		deletefx(localclientnum, self._microwavegun_hit_response_fx[localclientnum][tag], 0);
		self._microwavegun_hit_response_fx[localclientnum][tag] = undefined;
	}
}

/*
	Name: microwavegun_bloat
	Namespace: zm_weap_microwavegun
	Checksum: 0xBF90A093
	Offset: 0x608
	Size: 0x17C
	Parameters: 1
	Flags: Linked
*/
function microwavegun_bloat(localclientnum)
{
	self endon(#"entityshutdown");
	durationmsec = 2500;
	tag_pos = self gettagorigin("J_SpineLower");
	bloat_max_fraction = 1;
	if(!isdefined(tag_pos))
	{
		durationmsec = 1000;
	}
	self mapshaderconstant(localclientnum, 0, "scriptVector6", 0, 0, 0, 0);
	begin_time = getrealtime();
	while(true)
	{
		age = getrealtime() - begin_time;
		bloat_fraction = age / durationmsec;
		if(bloat_fraction > bloat_max_fraction)
		{
			bloat_fraction = bloat_max_fraction;
		}
		if(!isdefined(self))
		{
			return;
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector6", 4 * bloat_fraction, 0, 0, 0);
		if(bloat_fraction >= bloat_max_fraction)
		{
			break;
		}
		waitrealtime(0.05);
	}
}

/*
	Name: microwavegun_zombie_initial_hit_response
	Namespace: zm_weap_microwavegun
	Checksum: 0x1EFA0C2
	Offset: 0x790
	Size: 0x166
	Parameters: 7
	Flags: Linked
*/
function microwavegun_zombie_initial_hit_response(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(isdefined(self.microwavegun_zombie_hit_response))
	{
		self [[self.microwavegun_zombie_hit_response]](localclientnum, newval, bnewent);
		return;
	}
	if(localclientnum != 0)
	{
		return;
	}
	if(!isdefined(self._microwavegun_hit_response_fx))
	{
		self._microwavegun_hit_response_fx = [];
	}
	self.microwavegun_initial_hit_response = 1;
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(self._microwavegun_hit_response_fx[i]))
		{
			self._microwavegun_hit_response_fx[i] = [];
		}
		if(newval)
		{
			self microwavegun_create_hit_response_fx(i, "J_Eyeball_LE", level._effect["microwavegun_sizzle_blood_eyes"]);
			playsound(0, "wpn_mgun_impact_zombie", self.origin);
		}
	}
}

/*
	Name: microwavegun_zombie_expand_response
	Namespace: zm_weap_microwavegun
	Checksum: 0xFC4397FE
	Offset: 0x900
	Size: 0x30E
	Parameters: 7
	Flags: Linked
*/
function microwavegun_zombie_expand_response(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(isdefined(self.microwavegun_zombie_hit_response))
	{
		self [[self.microwavegun_zombie_hit_response]](localclientnum, newval, bnewent);
		return;
	}
	if(localclientnum != 0)
	{
		return;
	}
	if(!isdefined(self._microwavegun_hit_response_fx))
	{
		self._microwavegun_hit_response_fx = [];
	}
	initial_hit_occurred = isdefined(self.microwavegun_initial_hit_response) && self.microwavegun_initial_hit_response;
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(self._microwavegun_hit_response_fx[i]))
		{
			self._microwavegun_hit_response_fx[i] = [];
		}
		if(newval && initial_hit_occurred)
		{
			playsound(0, "wpn_mgun_impact_zombie", self.origin);
			self thread microwavegun_bloat(i);
			continue;
		}
		self thread microwavegun_bloat(i);
		if(initial_hit_occurred)
		{
			self microwavegun_delete_hit_response_fx(i, "J_Eyeball_LE");
		}
		tag_pos = self gettagorigin("J_SpineLower");
		tag_angles = self gettagangles("J_SpineLower");
		if(!isdefined(tag_pos))
		{
			tag_pos = self gettagorigin("J_Spine1");
			tag_angles = self gettagangles("J_Spine1");
		}
		fx = level._effect["microwavegun_sizzle_death_mist"];
		if(isdefined(self.in_low_g) && self.in_low_g)
		{
			fx = level._effect["microwavegun_sizzle_death_mist_low_g"];
		}
		if(isdefined(tag_pos))
		{
			playfx(i, fx, tag_pos, anglestoforward(tag_angles), anglestoup(tag_angles));
		}
		playsound(0, "wpn_mgun_explode_zombie", self.origin);
	}
}

