// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace zm_temple_geyser;

/*
	Name: main
	Namespace: zm_temple_geyser
	Checksum: 0xDBF776BC
	Offset: 0x190
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("allplayers", "geyserfakestand", 21000, 1, "int", &geyser_player_setup_stand, 0, 0);
	clientfield::register("allplayers", "geyserfakeprone", 21000, 1, "int", &geyser_player_setup_prone, 0, 0);
}

/*
	Name: geyser_player_setup_prone
	Namespace: zm_temple_geyser
	Checksum: 0xAAB74AA8
	Offset: 0x230
	Size: 0x420
	Parameters: 7
	Flags: Linked
*/
function geyser_player_setup_prone(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(isspectating(localclientnum, 0))
	{
		return;
	}
	player = getlocalplayers()[localclientnum];
	if(player getentitynumber() == self getentitynumber())
	{
		if(newval)
		{
			self playrumbleonentity(localclientnum, "slide_rumble");
		}
		else
		{
			self stoprumble(localclientnum, "slide_rumble");
		}
		return;
	}
	if(newval)
	{
		if(localclientnum == 0)
		{
			self thread player_disconnect_tracker();
		}
		fake_player = spawn(localclientnum, self.origin + (vectorscale((0, 0, -1), 800)), "script_model");
		fake_player.angles = self.angles;
		fake_player setmodel(self.model);
		if(self.model == "c_ger_richtofen_body")
		{
			fake_player attach("c_ger_richtofen_head", "J_Spine4");
			fake_player attach("c_ger_richtofen_offcap", "J_Head");
		}
		fake_player.fake_weapon = spawn(localclientnum, self.origin, "script_model");
		if(self.weapon != "none" && self.weapon != "syrette")
		{
			fake_player.fake_weapon useweaponhidetags(self.weapon);
		}
		else
		{
			self thread geyser_weapon_monitor(fake_player.fake_weapon);
		}
		fake_player.fake_weapon linkto(fake_player, "tag_weapon_right");
		waitrealtime(0.016);
		fake_player linkto(self, "tag_origin");
		if(!isdefined(self.fake_player))
		{
			self.fake_player = [];
		}
		self.fake_player[localclientnum] = fake_player;
		self thread wait_for_geyser_player_to_disconnect(localclientnum);
	}
	else
	{
		if(!isdefined(self.fake_player) && !isdefined(self.fake_player[localclientnum]))
		{
			return;
		}
		str_notify = "player_geyser" + localclientnum;
		self notify(str_notify);
		self notify(#"end_geyser");
		if(isdefined(self.fake_player[localclientnum].fake_weapon))
		{
			self.fake_player[localclientnum].fake_weapon delete();
			self.fake_player[localclientnum].fake_weapon = undefined;
		}
		self.fake_player[localclientnum] delete();
		self.fake_player[localclientnum] = undefined;
	}
}

/*
	Name: geyser_player_setup_stand
	Namespace: zm_temple_geyser
	Checksum: 0xB8739EAE
	Offset: 0x658
	Size: 0x448
	Parameters: 7
	Flags: Linked
*/
function geyser_player_setup_stand(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(isspectating(localclientnum, 0))
	{
		return;
	}
	player = getlocalplayers()[localclientnum];
	if(player getentitynumber() == self getentitynumber())
	{
		if(newval)
		{
			self playrumbleonentity(localclientnum, "slide_rumble");
		}
		else
		{
			self stoprumble(localclientnum, "slide_rumble");
		}
		return;
	}
	if(newval)
	{
		if(localclientnum == 0)
		{
			self thread player_disconnect_tracker();
		}
		fake_player = spawn(localclientnum, self.origin + (vectorscale((0, 0, -1), 800)), "script_model");
		fake_player.angles = self.angles;
		fake_player setmodel(self.model);
		if(self.model == "c_ger_richtofen_body")
		{
			fake_player attach("c_ger_richtofen_head", "J_Spine4");
			fake_player attach("c_ger_richtofen_offcap", "J_Head");
		}
		fake_player.fake_weapon = spawn(localclientnum, self.origin, "script_model");
		if(self.weapon.name != "none" && self.weapon.name != "syrette")
		{
			fake_player.fake_weapon useweaponhidetags(self.weapon);
		}
		else
		{
			self thread geyser_weapon_monitor(fake_player.fake_weapon);
		}
		fake_player.fake_weapon linkto(fake_player, "tag_weapon_right");
		waitrealtime(0.016);
		fake_player.origin = self.origin;
		fake_player linkto(self, "tag_origin");
		if(!isdefined(self.fake_player))
		{
			self.fake_player = [];
		}
		self.fake_player[localclientnum] = fake_player;
		self thread wait_for_geyser_player_to_disconnect(localclientnum);
	}
	else
	{
		if(!isdefined(self.fake_player) || !isdefined(self.fake_player[localclientnum]))
		{
			return;
		}
		str_notify = "player_geyser" + localclientnum;
		self notify(str_notify);
		self notify(#"end_geyser");
		if(isdefined(self.fake_player[localclientnum].fake_weapon))
		{
			self.fake_player[localclientnum].fake_weapon delete();
			self.fake_player[localclientnum].fake_weapon = undefined;
		}
		self.fake_player[localclientnum] delete();
		self.fake_player[localclientnum] = undefined;
	}
}

/*
	Name: geyser_weapon_monitor
	Namespace: zm_temple_geyser
	Checksum: 0x8EAF6A1F
	Offset: 0xAA8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function geyser_weapon_monitor(fake_weapon)
{
	self endon(#"end_geyser");
	self endon(#"disconnect");
	while(self.weapon == "none")
	{
		wait(0.05);
	}
	if(self.weapon != "syrette")
	{
		fake_weapon useweaponhidetags(self.weapon);
	}
}

/*
	Name: player_disconnect_tracker
	Namespace: zm_temple_geyser
	Checksum: 0x612AEAE1
	Offset: 0xB28
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function player_disconnect_tracker()
{
	self notify(#"stop_tracking");
	self endon(#"stop_tracking");
	ent_num = self getentitynumber();
	while(isdefined(self))
	{
		wait(0.05);
	}
	level notify(#"player_disconnected", ent_num);
}

/*
	Name: geyser_model_remover
	Namespace: zm_temple_geyser
	Checksum: 0xA15C22C1
	Offset: 0xB98
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function geyser_model_remover(str_endon, player)
{
	player endon(str_endon);
	level waittill(#"player_disconnected", client);
	if(isdefined(self.fake_weapon))
	{
		self.fake_weapon delete();
	}
	self delete();
}

/*
	Name: wait_for_geyser_player_to_disconnect
	Namespace: zm_temple_geyser
	Checksum: 0xA452BF0B
	Offset: 0xC18
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function wait_for_geyser_player_to_disconnect(localclientnum)
{
	str_endon = "player_geyser" + localclientnum;
	self.fake_player[localclientnum] thread geyser_model_remover(str_endon, self);
}

