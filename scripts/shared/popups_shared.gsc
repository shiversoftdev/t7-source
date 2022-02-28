// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace popups;

/*
	Name: __init__sytem__
	Namespace: popups
	Checksum: 0xD9CEE6CE
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("popups", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: popups
	Checksum: 0x867E07C8
	Offset: 0x288
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: popups
	Checksum: 0x1D47A933
	Offset: 0x2B8
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.contractsettings = spawnstruct();
	level.contractsettings.waittime = 4.2;
	level.killstreaksettings = spawnstruct();
	level.killstreaksettings.waittime = 3;
	level.ranksettings = spawnstruct();
	level.ranksettings.waittime = 3;
	level.startmessage = spawnstruct();
	level.startmessagedefaultduration = 2;
	level.endmessagedefaultduration = 2;
	level.challengesettings = spawnstruct();
	level.challengesettings.waittime = 3;
	level.teammessage = spawnstruct();
	level.teammessage.waittime = 3;
	level.regulargamemessages = spawnstruct();
	level.regulargamemessages.waittime = 6;
	level.wagersettings = spawnstruct();
	level.wagersettings.waittime = 3;
	level.momentumnotifywaittime = 0;
	level.momentumnotifywaitlasttime = 0;
	level.teammessagequeuemax = 8;
	/#
		level thread popupsfromconsole();
		level thread function_9a14a686();
	#/
	callback::on_connecting(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: popups
	Checksum: 0x545A4F4D
	Offset: 0x4C0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self.resetgameoverhudrequired = 0;
	self thread displaypopupswaiter();
	if(!level.hardcoremode)
	{
		self thread displayteammessagewaiter();
	}
}

/*
	Name: devgui_notif_getgunleveltablename
	Namespace: popups
	Checksum: 0xB34EB0A6
	Offset: 0x510
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function devgui_notif_getgunleveltablename()
{
	/#
		if(sessionmodeiscampaigngame())
		{
			return "";
		}
		if(sessionmodeiszombiesgame())
		{
			return "";
		}
		return "";
	#/
}

/*
	Name: devgui_notif_getchallengestablecount
	Namespace: popups
	Checksum: 0xA0AAB2C2
	Offset: 0x570
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function devgui_notif_getchallengestablecount()
{
	/#
		if(sessionmodeiscampaigngame())
		{
			return 4;
		}
		if(sessionmodeiszombiesgame())
		{
			return 4;
		}
		return 6;
	#/
}

/*
	Name: devgui_notif_getchallengestablename
	Namespace: popups
	Checksum: 0x6CFDA47E
	Offset: 0x5C8
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function devgui_notif_getchallengestablename(tableid)
{
	/#
		if(sessionmodeiscampaigngame())
		{
			return ("" + tableid) + "";
		}
		if(sessionmodeiszombiesgame())
		{
			return ("" + tableid) + "";
		}
		return ("" + tableid) + "";
	#/
}

/*
	Name: set_statstable_id
	Namespace: popups
	Checksum: 0xEB7D1C2F
	Offset: 0x660
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function set_statstable_id()
{
	/#
		if(!isdefined(level.statstableid))
		{
			level.statstableid = tablelookupfindcoreasset(util::getstatstablename());
		}
	#/
}

/*
	Name: devgui_create_weapon_levels_table
	Namespace: popups
	Checksum: 0xBED6750F
	Offset: 0x6B0
	Size: 0x206
	Parameters: 0
	Flags: Linked
*/
function devgui_create_weapon_levels_table()
{
	/#
		level.tbl_weaponids = [];
		set_statstable_id();
		if(!isdefined(level.statstableid))
		{
			return;
		}
		for(i = 0; i < 256; i++)
		{
			itemrow = tablelookuprownum(level.statstableid, 0, i);
			if(itemrow > -1)
			{
				group_s = tablelookupcolumnforrow(level.statstableid, itemrow, 2);
				if(issubstr(group_s, "") || group_s == "")
				{
					reference_s = tablelookupcolumnforrow(level.statstableid, itemrow, 4);
					if(reference_s != "")
					{
						weapon = getweapon(reference_s);
						level.tbl_weaponids[i][""] = reference_s;
						level.tbl_weaponids[i][""] = group_s;
						level.tbl_weaponids[i][""] = int(tablelookupcolumnforrow(level.statstableid, itemrow, 5));
						level.tbl_weaponids[i][""] = tablelookupcolumnforrow(level.statstableid, itemrow, 8);
					}
				}
			}
		}
	#/
}

/*
	Name: function_9a14a686
	Namespace: popups
	Checksum: 0xEB16DA80
	Offset: 0x8C0
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_9a14a686()
{
	/#
		if(isdedicated())
		{
			return;
		}
		if((getdvarint("", -999)) == -999)
		{
			setdvar("", 0);
		}
		var_deda26ca = "";
		util::function_e2ac06bb(var_deda26ca + "", ("" + "") + "");
		while(true)
		{
			if(getdvarint("", 0) > 0)
			{
				util::function_181cbd1a(var_deda26ca);
				level thread devgui_notif_init();
				break;
			}
			wait(1);
		}
	#/
}

/*
	Name: devgui_notif_init
	Namespace: popups
	Checksum: 0x6C6630A3
	Offset: 0x9E0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function devgui_notif_init()
{
	/#
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		if(isdedicated())
		{
			return;
		}
		level thread notif_devgui_rank();
		level thread notif_devgui_gun_rank();
		if(!sessionmodeiscampaigngame())
		{
			level thread notif_devgui_challenges();
		}
	#/
}

/*
	Name: notif_devgui_rank
	Namespace: popups
	Checksum: 0xA431CF3
	Offset: 0xAD8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function notif_devgui_rank()
{
	/#
		if(!isdefined(level.ranktable))
		{
			return;
		}
		notif_rank_devgui_base = "";
		for(i = 1; i < level.ranktable.size; i++)
		{
			display_level = i + 1;
			if(display_level < 10)
			{
				display_level = "" + display_level;
			}
			adddebugcommand(((((((notif_rank_devgui_base + display_level) + "") + "") + "") + "") + i) + "");
			if((i % 10) == 0)
			{
				wait(0.05);
			}
		}
		wait(0.05);
		level thread notif_devgui_rank_up_think();
	#/
}

/*
	Name: notif_devgui_rank_up_think
	Namespace: popups
	Checksum: 0x71C447B5
	Offset: 0xC08
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function notif_devgui_rank_up_think()
{
	/#
		for(;;)
		{
			rank_number = getdvarint("");
			if(rank_number == 0)
			{
				wait(0.05);
				continue;
			}
			level.players[0] rank::codecallback_rankup(rank_number, 0, 1);
			setdvar("", 0);
			wait(1);
		}
	#/
}

/*
	Name: notif_devgui_gun_rank
	Namespace: popups
	Checksum: 0x3982CB3B
	Offset: 0xCA8
	Size: 0x7FC
	Parameters: 0
	Flags: Linked
*/
function notif_devgui_gun_rank()
{
	/#
		notif_gun_rank_devgui_base = "";
		gunlevel_rankid_col = 0;
		gunlevel_gunref_col = 2;
		gunlevel_attachment_unlock_col = 3;
		gunlevel_xpgained_col = 4;
		level flag::wait_till("");
		if(!isdefined(level.tbl_weaponids))
		{
			devgui_create_weapon_levels_table();
		}
		if(!isdefined(level.tbl_weaponids))
		{
			return;
		}
		a_weapons = [];
		a_weapons[""] = [];
		a_weapons[""] = [];
		a_weapons[""] = [];
		a_weapons[""] = [];
		a_weapons[""] = [];
		a_weapons[""] = [];
		a_weapons[""] = [];
		a_weapons[""] = [];
		gun_levels_table = devgui_notif_getgunleveltablename();
		foreach(weapon in level.tbl_weaponids)
		{
			gun = [];
			gun[""] = weapon[""];
			gun[""] = getitemindexfromref(weapon[""]);
			gun[""] = [];
			gun_weapon_attachments = strtok(weapon[""], "");
			foreach(attachment in gun_weapon_attachments)
			{
				gun[""][attachment] = [];
				gun[""][attachment][""] = getattachmenttableindex(attachment);
				gun[""][attachment][""] = tablelookup(gun_levels_table, gunlevel_gunref_col, gun[""], gunlevel_attachment_unlock_col, attachment, gunlevel_rankid_col);
				gun[""][attachment][""] = tablelookup(gun_levels_table, gunlevel_gunref_col, gun[""], gunlevel_attachment_unlock_col, attachment, gunlevel_xpgained_col);
			}
			switch(weapon[""])
			{
				case "":
				{
					if(weapon[""] != "")
					{
						arrayinsert(a_weapons[""], gun, 0);
					}
					break;
				}
				case "":
				{
					arrayinsert(a_weapons[""], gun, 0);
					break;
				}
				case "":
				{
					arrayinsert(a_weapons[""], gun, 0);
					break;
				}
				case "":
				{
					arrayinsert(a_weapons[""], gun, 0);
					break;
				}
				case "":
				{
					arrayinsert(a_weapons[""], gun, 0);
					break;
				}
				case "":
				{
					arrayinsert(a_weapons[""], gun, 0);
					break;
				}
				case "":
				{
					arrayinsert(a_weapons[""], gun, 0);
					break;
				}
				case "":
				{
					arrayinsert(a_weapons[""], gun, 0);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		foreach(group_name, gun_group in a_weapons)
		{
			foreach(gun, attachment_group in gun_group)
			{
				foreach(attachment, attachment_data in attachment_group[""])
				{
					devgui_cmd_gun_path = ((((notif_gun_rank_devgui_base + group_name) + "") + gun_group[gun][""]) + "") + attachment;
					adddebugcommand(((((((((((((((((((devgui_cmd_gun_path + "") + "") + "") + "") + "") + attachment_data[""]) + "") + "") + "") + attachment_data[""]) + "") + "") + "") + gun_group[gun][""]) + "") + "") + "") + attachment_data[""]) + "");
				}
			}
			wait(0.05);
		}
		level thread notif_devgui_gun_level_think();
	#/
}

/*
	Name: notif_devgui_gun_level_think
	Namespace: popups
	Checksum: 0x7DF47C8F
	Offset: 0x14B0
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function notif_devgui_gun_level_think()
{
	/#
		for(;;)
		{
			weapon_item_index = getdvarint("");
			if(weapon_item_index == 0)
			{
				wait(0.05);
				continue;
			}
			xp_reward = getdvarint("");
			attachment_index = getdvarint("");
			rank_id = getdvarint("");
			level.players[0] persistence::codecallback_gunchallengecomplete(xp_reward, attachment_index, weapon_item_index, rank_id);
			setdvar("", 0);
			setdvar("", 0);
			setdvar("", 0);
			setdvar("", 0);
			wait(1);
		}
	#/
}

/*
	Name: notif_devgui_challenges
	Namespace: popups
	Checksum: 0xE91159F8
	Offset: 0x1610
	Size: 0x32C
	Parameters: 0
	Flags: Linked
*/
function notif_devgui_challenges()
{
	/#
		notif_challenges_devgui_base = "";
		for(i = 1; i <= devgui_notif_getchallengestablecount(); i++)
		{
			tablename = devgui_notif_getchallengestablename(i);
			rows = tablelookuprowcount(tablename);
			for(j = 1; j < rows; j++)
			{
				challengeid = tablelookupcolumnforrow(tablename, j, 0);
				if(challengeid != "" && strisint(tablelookupcolumnforrow(tablename, j, 0)))
				{
					challengestring = tablelookupcolumnforrow(tablename, j, 5);
					type = tablelookupcolumnforrow(tablename, j, 3);
					challengetier = int(tablelookupcolumnforrow(tablename, j, 1));
					challengetierstring = "" + challengetier;
					if(challengetier < 10)
					{
						challengetierstring = "" + challengetier;
					}
					name = tablelookupcolumnforrow(tablename, j, 5);
					devgui_cmd_challenge_path = (((((notif_challenges_devgui_base + type) + "") + makelocalizedstring(name) + "") + challengetierstring) + "") + challengeid;
					adddebugcommand(((((((((((devgui_cmd_challenge_path + "") + "") + "") + "") + "") + j) + "") + "") + "") + i) + "");
					if((int(challengeid) % 10) == 0)
					{
						wait(0.05);
					}
				}
			}
		}
		level thread notif_devgui_challenges_think();
	#/
}

/*
	Name: notif_devgui_challenges_think
	Namespace: popups
	Checksum: 0xB79669BD
	Offset: 0x1948
	Size: 0x346
	Parameters: 0
	Flags: Linked
*/
function notif_devgui_challenges_think()
{
	/#
		setdvar("", 0);
		setdvar("", 0);
		for(;;)
		{
			row = getdvarint("");
			table = getdvarint("");
			if(table < 1 || table > devgui_notif_getchallengestablecount())
			{
				wait(0.05);
				continue;
			}
			tablename = devgui_notif_getchallengestablename(table);
			if(row < 1 || row > tablelookuprowcount(tablename))
			{
				wait(0.05);
				continue;
			}
			type = tablelookupcolumnforrow(tablename, row, 3);
			itemindex = 0;
			if(type == "")
			{
				type = 0;
			}
			else
			{
				if(type == "")
				{
					itemindex = 4;
					type = 3;
				}
				else
				{
					if(type == "")
					{
						itemindex = 1;
						type = 4;
					}
					else
					{
						if(type == "")
						{
							type = 2;
						}
						else
						{
							if(type == "")
							{
								type = 5;
							}
							else
							{
								itemindex = 23;
								type = 1;
							}
						}
					}
				}
			}
			xpreward = int(tablelookupcolumnforrow(tablename, row, 6));
			challengeid = int(tablelookupcolumnforrow(tablename, row, 0));
			maxvalue = int(tablelookupcolumnforrow(tablename, row, 2));
			level.players[0] persistence::codecallback_challengecomplete(xpreward, maxvalue, row, table - 1, type, itemindex, challengeid);
			setdvar("", 0);
			setdvar("", 0);
			wait(1);
		}
	#/
}

/*
	Name: popupsfromconsole
	Namespace: popups
	Checksum: 0x7829FCCA
	Offset: 0x1C98
	Size: 0x6A8
	Parameters: 0
	Flags: Linked
*/
function popupsfromconsole()
{
	/#
		while(true)
		{
			timeout = getdvarfloat("", 1);
			if(timeout == 0)
			{
				timeout = 1;
			}
			wait(timeout);
			medal = getdvarint("", 0);
			challenge = getdvarint("", 0);
			rank = getdvarint("", 0);
			gun = getdvarint("", 0);
			contractpass = getdvarint("", 0);
			contractfail = getdvarint("", 0);
			gamemodemsg = getdvarint("", 0);
			teammsg = getdvarint("", 0);
			challengeindex = getdvarint("", 1);
			for(i = 0; i < medal; i++)
			{
				level.players[0] medals::codecallback_medal(86);
			}
			for(i = 0; i < challenge; i++)
			{
				level.players[0] persistence::codecallback_challengecomplete(1000, 10, 19, 0, 0, 0, 18);
				level.players[0] persistence::codecallback_challengecomplete(1000, 1, 21, 0, 0, 0, 20);
				rewardxp = 500;
				maxval = 1;
				row = 1;
				tablenumber = 0;
				challengetype = 1;
				itemindex = 111;
				challengeindex = 0;
				maxval = 50;
				row = 1;
				tablenumber = 2;
				challengetype = 1;
				itemindex = 20;
				challengeindex = 512;
				maxval = 150;
				row = 100;
				tablenumber = 2;
				challengetype = 4;
				itemindex = 1;
				challengeindex = 611;
				level.players[0] persistence::codecallback_challengecomplete(rewardxp, maxval, row, tablenumber, challengetype, itemindex, challengeindex);
			}
			for(i = 0; i < rank; i++)
			{
				level.players[0] rank::codecallback_rankup(4, 0, 1);
			}
			for(i = 0; i < gun; i++)
			{
				level.players[0] persistence::codecallback_gunchallengecomplete(0, 20, 25, 0);
			}
			for(i = 0; i < contractpass; i++)
			{
				level.players[0] persistence::add_contract_to_queue(12, 1);
			}
			for(i = 0; i < contractfail; i++)
			{
				level.players[0] persistence::add_contract_to_queue(12, 0);
			}
			for(i = 0; i < teammsg; i++)
			{
				player = level.players[0];
				if(isdefined(level.players[1]))
				{
					player = level.players[1];
				}
				level.players[0] displayteammessagetoall(&"", player);
			}
			reset = getdvarint("", 1);
			if(reset)
			{
				if(medal)
				{
					setdvar("", 0);
				}
				if(challenge)
				{
					setdvar("", 0);
				}
				if(gun)
				{
					setdvar("", 0);
				}
				if(rank)
				{
					setdvar("", 0);
				}
				if(contractpass)
				{
					setdvar("", 0);
				}
				if(contractfail)
				{
					setdvar("", 0);
				}
				if(gamemodemsg)
				{
					setdvar("", 0);
				}
				if(teammsg)
				{
					setdvar("", 0);
				}
			}
		}
	#/
}

/*
	Name: displaykillstreakteammessagetoall
	Namespace: popups
	Checksum: 0x2092EBE5
	Offset: 0x2348
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function displaykillstreakteammessagetoall(killstreak, player)
{
	if(!isdefined(level.killstreaks[killstreak]))
	{
		return;
	}
	if(!isdefined(level.killstreaks[killstreak].inboundtext))
	{
		return;
	}
	message = level.killstreaks[killstreak].inboundtext;
	self displayteammessagetoall(message, player);
}

/*
	Name: displaykillstreakhackedteammessagetoall
	Namespace: popups
	Checksum: 0x88CD6A5F
	Offset: 0x23E0
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function displaykillstreakhackedteammessagetoall(killstreak, player)
{
	if(!isdefined(level.killstreaks[killstreak]))
	{
		return;
	}
	if(!isdefined(level.killstreaks[killstreak].hackedtext))
	{
		return;
	}
	message = level.killstreaks[killstreak].hackedtext;
	self displayteammessagetoall(message, player);
}

/*
	Name: shoulddisplayteammessages
	Namespace: popups
	Checksum: 0xB7681166
	Offset: 0x2478
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function shoulddisplayteammessages()
{
	if(level.hardcoremode == 1 || level.splitscreen == 1)
	{
		return false;
	}
	return true;
}

/*
	Name: displayteammessagetoall
	Namespace: popups
	Checksum: 0x2D8E08C5
	Offset: 0x24B0
	Size: 0x136
	Parameters: 2
	Flags: Linked
*/
function displayteammessagetoall(message, player)
{
	if(!shoulddisplayteammessages())
	{
		return;
	}
	for(i = 0; i < level.players.size; i++)
	{
		cur_player = level.players[i];
		if(cur_player isempjammed())
		{
			continue;
		}
		size = cur_player.teammessagequeue.size;
		if(size >= level.teammessagequeuemax)
		{
			continue;
		}
		cur_player.teammessagequeue[size] = spawnstruct();
		cur_player.teammessagequeue[size].message = message;
		cur_player.teammessagequeue[size].player = player;
		cur_player notify(#"hash_f0fa2450");
	}
}

/*
	Name: displayteammessagetoteam
	Namespace: popups
	Checksum: 0xA1846B22
	Offset: 0x25F0
	Size: 0x156
	Parameters: 3
	Flags: None
*/
function displayteammessagetoteam(message, player, team)
{
	if(!shoulddisplayteammessages())
	{
		return;
	}
	for(i = 0; i < level.players.size; i++)
	{
		cur_player = level.players[i];
		if(cur_player.team != team)
		{
			continue;
		}
		if(cur_player isempjammed())
		{
			continue;
		}
		size = cur_player.teammessagequeue.size;
		if(size >= level.teammessagequeuemax)
		{
			continue;
		}
		cur_player.teammessagequeue[size] = spawnstruct();
		cur_player.teammessagequeue[size].message = message;
		cur_player.teammessagequeue[size].player = player;
		cur_player notify(#"hash_f0fa2450");
	}
}

/*
	Name: displayteammessagewaiter
	Namespace: popups
	Checksum: 0xACF6B28A
	Offset: 0x2750
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function displayteammessagewaiter()
{
	if(!shoulddisplayteammessages())
	{
		return;
	}
	self endon(#"disconnect");
	level endon(#"game_ended");
	self.teammessagequeue = [];
	for(;;)
	{
		if(self.teammessagequeue.size == 0)
		{
			self waittill(#"hash_f0fa2450");
		}
		if(self.teammessagequeue.size > 0)
		{
			nextnotifydata = self.teammessagequeue[0];
			arrayremoveindex(self.teammessagequeue, 0, 0);
			if(!isdefined(nextnotifydata.player) || !isplayer(nextnotifydata.player))
			{
				continue;
			}
			if(self isempjammed())
			{
				continue;
			}
			self luinotifyevent(&"player_callout", 2, nextnotifydata.message, nextnotifydata.player.entnum);
		}
		wait(level.teammessage.waittime);
	}
}

/*
	Name: displaypopupswaiter
	Namespace: popups
	Checksum: 0x928D1EB1
	Offset: 0x28A8
	Size: 0x29A
	Parameters: 0
	Flags: Linked
*/
function displaypopupswaiter()
{
	self endon(#"disconnect");
	self.ranknotifyqueue = [];
	if(!isdefined(self.pers["challengeNotifyQueue"]))
	{
		self.pers["challengeNotifyQueue"] = [];
	}
	if(!isdefined(self.pers["contractNotifyQueue"]))
	{
		self.pers["contractNotifyQueue"] = [];
	}
	self.messagenotifyqueue = [];
	self.startmessagenotifyqueue = [];
	self.wagernotifyqueue = [];
	while(isdefined(level) && isdefined(level.gameended) && !level.gameended)
	{
		if(!isdefined(self) || !isdefined(self.startmessagenotifyqueue) || !isdefined(self.messagenotifyqueue))
		{
			break;
		}
		if(self.startmessagenotifyqueue.size == 0 && self.messagenotifyqueue.size == 0)
		{
			self waittill(#"hash_2528173");
		}
		waittillframeend();
		if(!isdefined(level))
		{
			break;
		}
		if(!isdefined(level.gameended))
		{
			break;
		}
		if(level.gameended)
		{
			break;
		}
		if(self.startmessagenotifyqueue.size > 0)
		{
			nextnotifydata = self.startmessagenotifyqueue[0];
			arrayremoveindex(self.startmessagenotifyqueue, 0, 0);
			if(isdefined(nextnotifydata.duration))
			{
				duration = nextnotifydata.duration;
			}
			else
			{
				duration = level.startmessagedefaultduration;
			}
			self hud_message::shownotifymessage(nextnotifydata, duration);
			wait(duration);
		}
		else
		{
			if(self.messagenotifyqueue.size > 0)
			{
				nextnotifydata = self.messagenotifyqueue[0];
				arrayremoveindex(self.messagenotifyqueue, 0, 0);
				if(isdefined(nextnotifydata.duration))
				{
					duration = nextnotifydata.duration;
				}
				else
				{
					duration = level.regulargamemessages.waittime;
				}
				self hud_message::shownotifymessage(nextnotifydata, duration);
			}
			else
			{
				wait(1);
			}
		}
	}
}

/*
	Name: milestonenotify
	Namespace: popups
	Checksum: 0x7F32B7F5
	Offset: 0x2B50
	Size: 0x12A
	Parameters: 4
	Flags: None
*/
function milestonenotify(index, itemindex, type, tier)
{
	level.globalchallenges++;
	if(!isdefined(type))
	{
		type = "global";
	}
	size = self.pers["challengeNotifyQueue"].size;
	self.pers["challengeNotifyQueue"][size] = [];
	self.pers["challengeNotifyQueue"][size]["tier"] = tier;
	self.pers["challengeNotifyQueue"][size]["index"] = index;
	self.pers["challengeNotifyQueue"][size]["itemIndex"] = itemindex;
	self.pers["challengeNotifyQueue"][size]["type"] = type;
	self notify(#"hash_2528173");
}

