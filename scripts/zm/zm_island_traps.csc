// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_island_traps;

/*
	Name: init
	Namespace: zm_island_traps
	Checksum: 0xDF5D7F41
	Offset: 0x218
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "proptrap_downdraft_rumble", 9000, 1, "int", &proptrap_downdraft_rumble, 0, 0);
	clientfield::register("toplayer", "proptrap_downdraft_blur", 9000, 1, "int", &proptrap_downdraft_blur, 0, 0);
	clientfield::register("world", "walltrap_draft_rumble", 9000, 1, "int", &walltrap_draft_rumble, 0, 0);
	clientfield::register("toplayer", "walltrap_draft_blur", 9000, 1, "int", &walltrap_draft_blur, 0, 0);
}

/*
	Name: proptrap_downdraft_rumble
	Namespace: zm_island_traps
	Checksum: 0xC9D4DB6D
	Offset: 0x348
	Size: 0x2EE
	Parameters: 7
	Flags: Linked
*/
function proptrap_downdraft_rumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	if(isdefined(newval) && newval)
	{
		if(!isdefined(player.var_69abefde))
		{
			player.var_69abefde = [];
			var_719bbcb8 = struct::get_array("s_proptrap_downdraft_rumble", "targetname");
			foreach(var_dd3351d8 in var_719bbcb8)
			{
				e_pos = util::spawn_model(localclientnum, "tag_origin", var_dd3351d8.origin, var_dd3351d8.angles);
				array::add(player.var_69abefde, e_pos);
			}
		}
		foreach(e_pos in player.var_69abefde)
		{
			e_pos playrumbleonentity(localclientnum, "zm_island_rumble_proptrap_downdraft");
		}
	}
	else
	{
		if(isdefined(player.var_69abefde))
		{
			foreach(e_pos in player.var_69abefde)
			{
				e_pos stoprumble(localclientnum, "zm_island_rumble_proptrap_downdraft");
				e_pos delete();
			}
		}
		player.var_69abefde = undefined;
	}
}

/*
	Name: proptrap_downdraft_blur
	Namespace: zm_island_traps
	Checksum: 0xA8BEFD82
	Offset: 0x640
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function proptrap_downdraft_blur(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread function_24f1be38(localclientnum, "s_proptrap_downdraft_rumble");
	}
	else
	{
		self notify(#"hash_602aae2b");
		disablespeedblur(localclientnum);
	}
}

/*
	Name: walltrap_draft_rumble
	Namespace: zm_island_traps
	Checksum: 0x27DAF088
	Offset: 0x6D8
	Size: 0x2EE
	Parameters: 7
	Flags: Linked
*/
function walltrap_draft_rumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	if(isdefined(newval) && newval)
	{
		if(!isdefined(player.var_d33c558c))
		{
			player.var_d33c558c = [];
			var_52928b68 = struct::get_array("s_walltrap_draft_rumble", "targetname");
			foreach(var_7f2e4e88 in var_52928b68)
			{
				e_pos = util::spawn_model(localclientnum, "tag_origin", var_7f2e4e88.origin, var_7f2e4e88.angles);
				array::add(player.var_d33c558c, e_pos);
			}
		}
		foreach(e_pos in player.var_d33c558c)
		{
			e_pos playrumbleonentity(localclientnum, "zm_island_rumble_proptrap_downdraft");
		}
	}
	else
	{
		if(isdefined(player.var_d33c558c))
		{
			foreach(e_pos in player.var_d33c558c)
			{
				e_pos stoprumble(localclientnum, "zm_island_rumble_proptrap_downdraft");
				e_pos delete();
			}
		}
		player.var_d33c558c = undefined;
	}
}

/*
	Name: walltrap_draft_blur
	Namespace: zm_island_traps
	Checksum: 0x82EAEB21
	Offset: 0x9D0
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function walltrap_draft_blur(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread function_24f1be38(localclientnum, "s_walltrap_draft_rumble");
	}
	else
	{
		self notify(#"hash_602aae2b");
		disablespeedblur(localclientnum);
	}
}

/*
	Name: function_24f1be38
	Namespace: zm_island_traps
	Checksum: 0x81875FD7
	Offset: 0xA68
	Size: 0x150
	Parameters: 2
	Flags: Linked
*/
function function_24f1be38(localclientnum, str_structname)
{
	self endon(#"hash_602aae2b");
	self endon(#"death");
	var_719bbcb8 = struct::get_array(str_structname, "targetname");
	while(true)
	{
		foreach(var_dd3351d8 in var_719bbcb8)
		{
			if(isdefined(self) && distancesquared(self.origin, var_dd3351d8.origin) < 3600)
			{
				enablespeedblur(localclientnum, 0.1, 0.5, 0.75);
				continue;
			}
			disablespeedblur(localclientnum);
		}
		wait(0.5);
	}
}

