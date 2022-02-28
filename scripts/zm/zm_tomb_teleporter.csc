// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using_animtree("generic");

#namespace zm_tomb_teleporter;

/*
	Name: init
	Namespace: zm_tomb_teleporter
	Checksum: 0xACA97E60
	Offset: 0x260
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("allplayers", "teleport_arrival_departure_fx", 21000, 1, "counter", &function_dadd24b7, 0, 0);
	clientfield::register("vehicle", "teleport_arrival_departure_fx", 21000, 1, "counter", &function_dadd24b7, 0, 0);
}

/*
	Name: main
	Namespace: zm_tomb_teleporter
	Checksum: 0x7784DED7
	Offset: 0x300
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_factory_teleport", 21000, 1, "pstfx_zm_tomb_teleport");
}

/*
	Name: function_a8255fab
	Namespace: zm_tomb_teleporter
	Checksum: 0xD3E25CE2
	Offset: 0x338
	Size: 0x106
	Parameters: 7
	Flags: Linked
*/
function function_a8255fab(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"disconnect");
	if(newval == 1)
	{
		if(!isdefined(self.var_1e8e073f))
		{
			self.var_1e8e073f = playfxontag(localclientnum, level._effect["teleport_1p"], self, "tag_origin");
			setfxignorepause(localclientnum, self.var_1e8e073f, 1);
		}
	}
	else if(isdefined(self.var_1e8e073f))
	{
		stopfx(localclientnum, self.var_1e8e073f);
		self.var_1e8e073f = undefined;
	}
}

/*
	Name: function_ffedfe48
	Namespace: zm_tomb_teleporter
	Checksum: 0xB8CCA17
	Offset: 0x448
	Size: 0xE4
	Parameters: 7
	Flags: None
*/
function function_ffedfe48(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_b162502d = !(isdefined(self.var_76534568) && self.var_76534568);
	if(!(isdefined(self.var_76534568) && self.var_76534568))
	{
		self useanimtree($generic);
		self.var_76534568 = 1;
	}
	if(newval)
	{
		self thread scene::play("p7_fxanim_zm_ori_portal_open_bundle", self);
	}
	else
	{
		self thread scene::play("p7_fxanim_zm_ori_portal_collapse_bundle", self);
	}
}

/*
	Name: function_dadd24b7
	Namespace: zm_tomb_teleporter
	Checksum: 0xE7FFB710
	Offset: 0x538
	Size: 0x172
	Parameters: 7
	Flags: Linked
*/
function function_dadd24b7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	str_tag_name = "";
	if(self isplayer())
	{
		str_tag_name = "j_spinelower";
	}
	else
	{
		str_tag_name = "tag_brain";
	}
	a_e_players = getlocalplayers();
	foreach(e_player in a_e_players)
	{
		self.var_16ab725 = playfxontag(e_player.localclientnum, level._effect["teleport_arrive_player"], self, str_tag_name);
		setfxignorepause(e_player.localclientnum, self.var_16ab725, 1);
	}
}

