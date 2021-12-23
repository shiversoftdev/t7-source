// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace zm_island_challenges;

/*
	Name: init
	Namespace: zm_island_challenges
	Checksum: 0x6FF34A8A
	Offset: 0x3C8
	Size: 0x3CC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	var_850da4c5 = getminbitcountfornum(4);
	clientfield::register("world", "pillar_challenge_0_1", 9000, var_850da4c5, "int", &pillar_challenge_0_1, 0, 0);
	clientfield::register("world", "pillar_challenge_0_2", 9000, var_850da4c5, "int", &pillar_challenge_0_2, 0, 0);
	clientfield::register("world", "pillar_challenge_0_3", 9000, var_850da4c5, "int", &pillar_challenge_0_3, 0, 0);
	clientfield::register("world", "pillar_challenge_1_1", 9000, var_850da4c5, "int", &pillar_challenge_1_1, 0, 0);
	clientfield::register("world", "pillar_challenge_1_2", 9000, var_850da4c5, "int", &pillar_challenge_1_2, 0, 0);
	clientfield::register("world", "pillar_challenge_1_3", 9000, var_850da4c5, "int", &pillar_challenge_1_3, 0, 0);
	clientfield::register("world", "pillar_challenge_2_1", 9000, var_850da4c5, "int", &pillar_challenge_2_1, 0, 0);
	clientfield::register("world", "pillar_challenge_2_2", 9000, var_850da4c5, "int", &pillar_challenge_2_2, 0, 0);
	clientfield::register("world", "pillar_challenge_2_3", 9000, var_850da4c5, "int", &pillar_challenge_2_3, 0, 0);
	clientfield::register("world", "pillar_challenge_3_1", 9000, var_850da4c5, "int", &pillar_challenge_3_1, 0, 0);
	clientfield::register("world", "pillar_challenge_3_2", 9000, var_850da4c5, "int", &pillar_challenge_3_2, 0, 0);
	clientfield::register("world", "pillar_challenge_3_3", 9000, var_850da4c5, "int", &pillar_challenge_3_3, 0, 0);
	clientfield::register("scriptmover", "challenge_glow_fx", 9000, 2, "int", &challenge_glow_fx, 0, 0);
}

/*
	Name: pillar_challenge_0_1
	Namespace: zm_island_challenges
	Checksum: 0x4E5F7FDC
	Offset: 0x7A0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_0_1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_0", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 0)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 1, var_2ca030e2);
}

/*
	Name: pillar_challenge_0_2
	Namespace: zm_island_challenges
	Checksum: 0xC016F565
	Offset: 0x8A8
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_0_2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_0", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 0)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 2, var_2ca030e2);
}

/*
	Name: pillar_challenge_0_3
	Namespace: zm_island_challenges
	Checksum: 0xF1448737
	Offset: 0x9B0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_0_3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_0", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 0)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 3, var_2ca030e2);
}

/*
	Name: pillar_challenge_1_1
	Namespace: zm_island_challenges
	Checksum: 0x8D043E1B
	Offset: 0xAB8
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_1_1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_1", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 1)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 1, var_2ca030e2);
}

/*
	Name: pillar_challenge_1_2
	Namespace: zm_island_challenges
	Checksum: 0x67B770FF
	Offset: 0xBC0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_1_2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_1", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 1)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 2, var_2ca030e2);
}

/*
	Name: pillar_challenge_1_3
	Namespace: zm_island_challenges
	Checksum: 0xE617369C
	Offset: 0xCC8
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_1_3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_1", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 1)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 3, var_2ca030e2);
}

/*
	Name: pillar_challenge_2_1
	Namespace: zm_island_challenges
	Checksum: 0x75AB2C3B
	Offset: 0xDD0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_2_1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_2", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 2)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 1, var_2ca030e2);
}

/*
	Name: pillar_challenge_2_2
	Namespace: zm_island_challenges
	Checksum: 0x6C85C18B
	Offset: 0xED8
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_2_2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_2", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 2)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 2, var_2ca030e2);
}

/*
	Name: pillar_challenge_2_3
	Namespace: zm_island_challenges
	Checksum: 0xC4C01CC8
	Offset: 0xFE0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_2_3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_2", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 2)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 3, var_2ca030e2);
}

/*
	Name: pillar_challenge_3_1
	Namespace: zm_island_challenges
	Checksum: 0x7277989B
	Offset: 0x10E8
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_3_1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_3", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 3)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 1, var_2ca030e2);
}

/*
	Name: pillar_challenge_3_2
	Namespace: zm_island_challenges
	Checksum: 0x513ED6BC
	Offset: 0x11F0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_3_2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_3", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 3)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 2, var_2ca030e2);
}

/*
	Name: pillar_challenge_3_3
	Namespace: zm_island_challenges
	Checksum: 0x5622176D
	Offset: 0x12F8
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function pillar_challenge_3_3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_4c6172ff = getent(localclientnum, "challenge_pillar_3", "targetname");
	var_2ca030e2 = 0;
	player = getlocalplayer(localclientnum);
	if(player getentitynumber() == 3)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localclientnum, newval, 3, var_2ca030e2);
}

/*
	Name: function_4aadb052
	Namespace: zm_island_challenges
	Checksum: 0x9DA02333
	Offset: 0x1400
	Size: 0xEE
	Parameters: 4
	Flags: Linked
*/
function function_4aadb052(localclientnum, newval, n_challenge, var_2ca030e2)
{
	switch(newval)
	{
		case 1:
		{
			self thread function_4516da29(localclientnum, n_challenge);
			break;
		}
		case 2:
		{
			self thread function_2fba808e(localclientnum, n_challenge, var_2ca030e2);
			break;
		}
		case 3:
		{
			self thread function_21cf53eb(localclientnum, n_challenge, var_2ca030e2);
			break;
		}
		case 4:
		{
			self thread function_72573d3d(localclientnum, n_challenge, var_2ca030e2);
			break;
		}
	}
}

/*
	Name: function_4516da29
	Namespace: zm_island_challenges
	Checksum: 0x6098F423
	Offset: 0x14F8
	Size: 0x14C
	Parameters: 2
	Flags: Linked
*/
function function_4516da29(localclientnum, n_challenge)
{
	self util::waittill_dobj(localclientnum);
	self hidepart(localclientnum, "j_player_started_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	self hidepart(localclientnum, "j_player_completed_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	self hidepart(localclientnum, "j_player_claimed_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	self hidepart(localclientnum, "j_ally_started_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	self hidepart(localclientnum, "j_ally_completed_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	self hidepart(localclientnum, "j_ally_claimed_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
}

/*
	Name: function_2fba808e
	Namespace: zm_island_challenges
	Checksum: 0xBFAAF255
	Offset: 0x1650
	Size: 0xBC
	Parameters: 3
	Flags: Linked
*/
function function_2fba808e(localclientnum, n_challenge, var_2ca030e2)
{
	self util::waittill_dobj(localclientnum);
	self function_4516da29(localclientnum, n_challenge);
	if(var_2ca030e2)
	{
		self showpart(localclientnum, "j_player_started_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	}
	else
	{
		self showpart(localclientnum, "j_ally_started_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	}
}

/*
	Name: function_21cf53eb
	Namespace: zm_island_challenges
	Checksum: 0xFE92D449
	Offset: 0x1718
	Size: 0xBC
	Parameters: 3
	Flags: Linked
*/
function function_21cf53eb(localclientnum, n_challenge, var_2ca030e2)
{
	self util::waittill_dobj(localclientnum);
	self function_4516da29(localclientnum, n_challenge);
	if(var_2ca030e2)
	{
		self showpart(localclientnum, "j_player_completed_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	}
	else
	{
		self showpart(localclientnum, "j_ally_completed_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	}
}

/*
	Name: function_72573d3d
	Namespace: zm_island_challenges
	Checksum: 0xF5A33374
	Offset: 0x17E0
	Size: 0xBC
	Parameters: 3
	Flags: Linked
*/
function function_72573d3d(localclientnum, n_challenge, var_2ca030e2)
{
	self util::waittill_dobj(localclientnum);
	self function_4516da29(localclientnum, n_challenge);
	if(var_2ca030e2)
	{
		self showpart(localclientnum, "j_player_claimed_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	}
	else
	{
		self showpart(localclientnum, "j_ally_claimed_0" + n_challenge, "p7_zm_isl_ritual_pillar_symbol");
	}
}

/*
	Name: challenge_glow_fx
	Namespace: zm_island_challenges
	Checksum: 0x2FD8ABCA
	Offset: 0x18A8
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function challenge_glow_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfxontag(localclientnum, level._effect["powerup_on"], self, "tag_origin");
	}
	if(newval == 2)
	{
		playfxontag(localclientnum, level._effect["powerup_on_solo"], self, "tag_origin");
	}
}

