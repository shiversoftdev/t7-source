// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;

#namespace zm_castle_characters;

/*
	Name: precachecustomcharacters
	Namespace: zm_castle_characters
	Checksum: 0x99EC1590
	Offset: 0x748
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precachecustomcharacters()
{
}

/*
	Name: initcharacterstartindex
	Namespace: zm_castle_characters
	Checksum: 0x5A5DD539
	Offset: 0x758
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function initcharacterstartindex()
{
	level.characterstartindex = randomint(4);
}

/*
	Name: selectcharacterindextouse
	Namespace: zm_castle_characters
	Checksum: 0x114A29D7
	Offset: 0x788
	Size: 0x3E
	Parameters: 0
	Flags: None
*/
function selectcharacterindextouse()
{
	if(level.characterstartindex >= 4)
	{
		level.characterstartindex = 0;
	}
	self.characterindex = level.characterstartindex;
	level.characterstartindex++;
	return self.characterindex;
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: zm_castle_characters
	Checksum: 0x6EBAF324
	Offset: 0x7D0
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	players = getplayers();
	if(players.size == 1)
	{
		charindexarray = array::randomize(charindexarray);
		if(charindexarray[0] == 2)
		{
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	n_characters_defined = 0;
	foreach(player in players)
	{
		if(isdefined(player.characterindex))
		{
			arrayremovevalue(charindexarray, player.characterindex, 0);
			n_characters_defined++;
		}
	}
	if(charindexarray.size > 0)
	{
		if(n_characters_defined == (players.size - 1))
		{
			if(!(isdefined(level.has_richtofen) && level.has_richtofen))
			{
				level.has_richtofen = 1;
				return 2;
			}
		}
		charindexarray = array::randomize(charindexarray);
		if(charindexarray[0] == 2)
		{
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	return 0;
}

/*
	Name: givecustomcharacters
	Namespace: zm_castle_characters
	Checksum: 0x535AD2A0
	Offset: 0x9F0
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function givecustomcharacters()
{
	self detachall();
	if(!isdefined(self.characterindex))
	{
		self.characterindex = assign_lowest_unused_character_index();
	}
	self.favorite_wall_weapons_list = [];
	self.talks_in_danger = 0;
	/#
		if(getdvarstring("") != "")
		{
			self.characterindex = getdvarint("");
		}
	#/
	self setcharacterbodytype(self.characterindex);
	self setcharacterbodystyle(0);
	self setcharacterhelmetstyle(0);
	switch(self.characterindex)
	{
		case 1:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("870mcs");
			break;
		}
		case 0:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("frag_grenade");
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("bouncingbetty");
			break;
		}
		case 3:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("hk416");
			break;
		}
		case 2:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			level.sndradioa = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("pistol_standard");
			break;
		}
	}
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
	self thread set_exert_id();
}

/*
	Name: set_exert_id
	Namespace: zm_castle_characters
	Checksum: 0xD002341D
	Offset: 0xCA0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function set_exert_id()
{
	self endon(#"disconnect");
	util::wait_network_frame();
	util::wait_network_frame();
	self zm_audio::setexertvoice(self.characterindex + 1);
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_castle_characters
	Checksum: 0xBBF2F9FB
	Offset: 0xD00
	Size: 0x8BA
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["burp"][0] = "vox_plr_0_exert_burp_0";
	level.exert_sounds[1]["burp"][1] = "vox_plr_0_exert_burp_1";
	level.exert_sounds[1]["burp"][2] = "vox_plr_0_exert_burp_2";
	level.exert_sounds[1]["burp"][3] = "vox_plr_0_exert_burp_3";
	level.exert_sounds[1]["burp"][4] = "vox_plr_0_exert_burp_4";
	level.exert_sounds[1]["burp"][5] = "vox_plr_0_exert_burp_5";
	level.exert_sounds[1]["burp"][6] = "vox_plr_0_exert_burp_6";
	level.exert_sounds[2]["burp"][0] = "vox_plr_1_exert_burp_0";
	level.exert_sounds[2]["burp"][1] = "vox_plr_1_exert_burp_1";
	level.exert_sounds[2]["burp"][2] = "vox_plr_1_exert_burp_2";
	level.exert_sounds[2]["burp"][3] = "vox_plr_1_exert_burp_3";
	level.exert_sounds[3]["burp"][0] = "vox_plr_2_exert_burp_0";
	level.exert_sounds[3]["burp"][1] = "vox_plr_2_exert_burp_1";
	level.exert_sounds[3]["burp"][2] = "vox_plr_2_exert_burp_2";
	level.exert_sounds[3]["burp"][3] = "vox_plr_2_exert_burp_3";
	level.exert_sounds[3]["burp"][4] = "vox_plr_2_exert_burp_4";
	level.exert_sounds[3]["burp"][5] = "vox_plr_2_exert_burp_5";
	level.exert_sounds[3]["burp"][6] = "vox_plr_2_exert_burp_6";
	level.exert_sounds[4]["burp"][0] = "vox_plr_3_exert_burp_0";
	level.exert_sounds[4]["burp"][1] = "vox_plr_3_exert_burp_1";
	level.exert_sounds[4]["burp"][2] = "vox_plr_3_exert_burp_2";
	level.exert_sounds[4]["burp"][3] = "vox_plr_3_exert_burp_3";
	level.exert_sounds[4]["burp"][4] = "vox_plr_3_exert_burp_4";
	level.exert_sounds[4]["burp"][5] = "vox_plr_3_exert_burp_5";
	level.exert_sounds[4]["burp"][6] = "vox_plr_3_exert_burp_6";
	level.exert_sounds[1]["hitmed"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["hitmed"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["hitmed"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["hitmed"][3] = "vox_plr_0_exert_pain_medium_3";
	level.exert_sounds[2]["hitmed"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["hitmed"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["hitmed"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["hitmed"][3] = "vox_plr_1_exert_pain_medium_3";
	level.exert_sounds[3]["hitmed"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["hitmed"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["hitmed"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["hitmed"][3] = "vox_plr_2_exert_pain_medium_3";
	level.exert_sounds[4]["hitmed"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["hitmed"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["hitmed"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_medium_3";
	level.exert_sounds[1]["hitlrg"][0] = "vox_plr_0_exert_pain_high_0";
	level.exert_sounds[1]["hitlrg"][1] = "vox_plr_0_exert_pain_high_1";
	level.exert_sounds[1]["hitlrg"][2] = "vox_plr_0_exert_pain_high_2";
	level.exert_sounds[1]["hitlrg"][3] = "vox_plr_0_exert_pain_high_3";
	level.exert_sounds[2]["hitlrg"][0] = "vox_plr_1_exert_pain_high_0";
	level.exert_sounds[2]["hitlrg"][1] = "vox_plr_1_exert_pain_high_1";
	level.exert_sounds[2]["hitlrg"][2] = "vox_plr_1_exert_pain_high_2";
	level.exert_sounds[2]["hitlrg"][3] = "vox_plr_1_exert_pain_high_3";
	level.exert_sounds[3]["hitlrg"][0] = "vox_plr_2_exert_pain_high_0";
	level.exert_sounds[3]["hitlrg"][1] = "vox_plr_2_exert_pain_high_1";
	level.exert_sounds[3]["hitlrg"][2] = "vox_plr_2_exert_pain_high_2";
	level.exert_sounds[3]["hitlrg"][3] = "vox_plr_2_exert_pain_high_3";
	level.exert_sounds[4]["hitlrg"][0] = "vox_plr_3_exert_pain_high_0";
	level.exert_sounds[4]["hitlrg"][1] = "vox_plr_3_exert_pain_high_1";
	level.exert_sounds[4]["hitlrg"][2] = "vox_plr_3_exert_pain_high_2";
	level.exert_sounds[4]["hitlrg"][3] = "vox_plr_3_exert_pain_high_3";
}

