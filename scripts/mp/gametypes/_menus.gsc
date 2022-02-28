// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\shared\callbacks_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;

#namespace menus;

/*
	Name: __init__sytem__
	Namespace: menus
	Checksum: 0xFF147CA8
	Offset: 0x2A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("menus", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: menus
	Checksum: 0xDC954A3
	Offset: 0x2E8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
}

/*
	Name: init
	Namespace: menus
	Checksum: 0x7ACF8462
	Offset: 0x338
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function init()
{
	game["menu_start_menu"] = "StartMenu_Main";
	game["menu_team"] = "ChangeTeam";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "ChooseClass_InGame";
	game["menu_changeclass_offline"] = "ChooseClass_InGame";
	foreach(team in level.teams)
	{
		game["menu_changeclass_" + team] = "ChooseClass_InGame";
	}
	game["menu_controls"] = "ingame_controls";
	game["menu_options"] = "ingame_options";
	game["menu_leavegame"] = "popup_leavegame";
}

/*
	Name: on_player_connect
	Namespace: menus
	Checksum: 0xA44618E0
	Offset: 0x470
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread on_menu_response();
}

/*
	Name: on_menu_response
	Namespace: menus
	Checksum: 0xEB0582B3
	Offset: 0x498
	Size: 0x448
	Parameters: 0
	Flags: Linked
*/
function on_menu_response()
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"menuresponse", menu, response);
		if(response == "back")
		{
			self closeingamemenu();
			if(level.console)
			{
				if(menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"])
				{
					if(isdefined(level.teams[self.pers["team"]]))
					{
						self openmenu(game["menu_start_menu"]);
					}
				}
			}
			continue;
		}
		if(response == "changeteam" && level.allow_teamchange == "1")
		{
			self closeingamemenu();
			self openmenu(game["menu_team"]);
		}
		if(response == "endgame")
		{
			if(level.splitscreen)
			{
				level.skipvote = 1;
				if(!level.gameended)
				{
					level thread globallogic::forceend();
				}
			}
			continue;
		}
		if(response == "killserverpc")
		{
			level thread globallogic::killserverpc();
			continue;
		}
		if(response == "endround")
		{
			if(!level.gameended)
			{
				self globallogic::gamehistoryplayerquit();
				level thread globallogic::forceend();
			}
			else
			{
				self closeingamemenu();
				self iprintln(&"MP_HOST_ENDGAME_RESPONSE");
			}
			continue;
		}
		if(menu == game["menu_team"] && level.allow_teamchange == "1")
		{
			switch(response)
			{
				case "autoassign":
				{
					self [[level.autoassign]](1);
					break;
				}
				case "spectator":
				{
					self [[level.spectator]]();
					break;
				}
				default:
				{
					self [[level.teammenu]](response);
					break;
				}
			}
			continue;
		}
		if(menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"])
		{
			if(response != "cancel")
			{
				self closeingamemenu();
				if(level.rankedmatch && issubstr(response, "custom"))
				{
					if(self isitemlocked(rank::getitemindex("feature_cac")))
					{
						kick(self getentitynumber());
					}
				}
				self.selectedclass = 1;
				self [[level.curclass]](response);
			}
			continue;
		}
		if(menu == "spectate")
		{
			player = util::getplayerfromclientnum(int(response));
			if(isdefined(player))
			{
				self setcurrentspectatorclient(player);
			}
		}
	}
}

