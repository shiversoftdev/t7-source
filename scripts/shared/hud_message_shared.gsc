// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace hud_message;

/*
	Name: __init__sytem__
	Namespace: hud_message
	Checksum: 0x3506DA05
	Offset: 0x210
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hud_message", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hud_message
	Checksum: 0x1BB5DB15
	Offset: 0x250
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
	Namespace: hud_message
	Checksum: 0x87DBBE5E
	Offset: 0x280
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function init()
{
	callback::on_connect(&on_player_connect);
	callback::on_disconnect(&on_player_disconnect);
}

/*
	Name: on_player_connect
	Namespace: hud_message
	Checksum: 0x7311A22B
	Offset: 0x2D0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread hintmessagedeaththink();
	self thread lowermessagethink();
	self thread initnotifymessage();
	self thread initcustomgametypeheader();
}

/*
	Name: on_player_disconnect
	Namespace: hud_message
	Checksum: 0x49C5D77
	Offset: 0x340
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function on_player_disconnect()
{
	if(isdefined(self.customgametypeheader))
	{
		self.customgametypeheader destroy();
	}
	if(isdefined(self.customgametypesubheader))
	{
		self.customgametypesubheader destroy();
	}
}

/*
	Name: initcustomgametypeheader
	Namespace: hud_message
	Checksum: 0xE5E223EC
	Offset: 0x3A0
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function initcustomgametypeheader()
{
	font = "default";
	titlesize = 2.5;
	self.customgametypeheader = hud::createfontstring(font, titlesize);
	self.customgametypeheader hud::setpoint("TOP", undefined, 0, 30);
	self.customgametypeheader.glowalpha = 1;
	self.customgametypeheader.hidewheninmenu = 1;
	self.customgametypeheader.archived = 0;
	self.customgametypeheader.color = (1, 1, 0.6);
	self.customgametypeheader.alpha = 1;
	titlesize = 2;
	self.customgametypesubheader = hud::createfontstring(font, titlesize);
	self.customgametypesubheader hud::setparent(self.customgametypeheader);
	self.customgametypesubheader hud::setpoint("TOP", "BOTTOM", 0, 0);
	self.customgametypesubheader.glowalpha = 1;
	self.customgametypesubheader.hidewheninmenu = 1;
	self.customgametypesubheader.archived = 0;
	self.customgametypesubheader.color = (1, 1, 0.6);
	self.customgametypesubheader.alpha = 1;
}

/*
	Name: hintmessage
	Namespace: hud_message
	Checksum: 0x7D1C6755
	Offset: 0x580
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function hintmessage(hinttext, duration)
{
	notifydata = spawnstruct();
	notifydata.notifytext = hinttext;
	notifydata.duration = duration;
	notifymessage(notifydata);
}

/*
	Name: hintmessageplayers
	Namespace: hud_message
	Checksum: 0x325610D
	Offset: 0x5F8
	Size: 0xAE
	Parameters: 3
	Flags: None
*/
function hintmessageplayers(players, hinttext, duration)
{
	notifydata = spawnstruct();
	notifydata.notifytext = hinttext;
	notifydata.duration = duration;
	for(i = 0; i < players.size; i++)
	{
		players[i] notifymessage(notifydata);
	}
}

/*
	Name: showinitialfactionpopup
	Namespace: hud_message
	Checksum: 0x4286D2D8
	Offset: 0x6B0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function showinitialfactionpopup(team)
{
	self luinotifyevent(&"faction_popup", 1, game["strings"][team + "_name"]);
	oldnotifymessage(undefined, undefined, undefined, undefined);
}

/*
	Name: initnotifymessage
	Namespace: hud_message
	Checksum: 0xC8ABAD1D
	Offset: 0x718
	Size: 0x4D0
	Parameters: 0
	Flags: Linked
*/
function initnotifymessage()
{
	if(!sessionmodeiszombiesgame())
	{
		if(self issplitscreen())
		{
			titlesize = 2;
			textsize = 1.4;
			iconsize = 24;
			font = "big";
			point = "TOP";
			relativepoint = "BOTTOM";
			yoffset = 30;
			xoffset = 30;
		}
		else
		{
			titlesize = 2.5;
			textsize = 1.75;
			iconsize = 30;
			font = "big";
			point = "TOP";
			relativepoint = "BOTTOM";
			yoffset = 0;
			xoffset = 0;
		}
	}
	else
	{
		if(self issplitscreen())
		{
			titlesize = 2;
			textsize = 1.4;
			iconsize = 24;
			font = "big";
			point = "TOP";
			relativepoint = "BOTTOM";
			yoffset = 30;
			xoffset = 30;
		}
		else
		{
			titlesize = 2.5;
			textsize = 1.75;
			iconsize = 30;
			font = "big";
			point = "BOTTOM LEFT";
			relativepoint = "TOP";
			yoffset = 0;
			xoffset = 0;
		}
	}
	self.notifytitle = hud::createfontstring(font, titlesize);
	self.notifytitle hud::setpoint(point, undefined, xoffset, yoffset);
	self.notifytitle.glowalpha = 1;
	self.notifytitle.hidewheninmenu = 1;
	self.notifytitle.archived = 0;
	self.notifytitle.alpha = 0;
	self.notifytext = hud::createfontstring(font, textsize);
	self.notifytext hud::setparent(self.notifytitle);
	self.notifytext hud::setpoint(point, relativepoint, 0, 0);
	self.notifytext.glowalpha = 1;
	self.notifytext.hidewheninmenu = 1;
	self.notifytext.archived = 0;
	self.notifytext.alpha = 0;
	self.notifytext2 = hud::createfontstring(font, textsize);
	self.notifytext2 hud::setparent(self.notifytitle);
	self.notifytext2 hud::setpoint(point, relativepoint, 0, 0);
	self.notifytext2.glowalpha = 1;
	self.notifytext2.hidewheninmenu = 1;
	self.notifytext2.archived = 0;
	self.notifytext2.alpha = 0;
	self.notifyicon = hud::createicon("white", iconsize, iconsize);
	self.notifyicon hud::setparent(self.notifytext2);
	self.notifyicon hud::setpoint(point, relativepoint, 0, 0);
	self.notifyicon.hidewheninmenu = 1;
	self.notifyicon.archived = 0;
	self.notifyicon.alpha = 0;
	self.doingnotify = 0;
	self.notifyqueue = [];
}

/*
	Name: oldnotifymessage
	Namespace: hud_message
	Checksum: 0xB6EB90C5
	Offset: 0xBF0
	Size: 0xF6
	Parameters: 6
	Flags: Linked
*/
function oldnotifymessage(titletext, notifytext, iconname, glowcolor, sound, duration)
{
	if(level.wagermatch && !level.teambased)
	{
		return;
	}
	notifydata = spawnstruct();
	notifydata.titletext = titletext;
	notifydata.notifytext = notifytext;
	notifydata.iconname = iconname;
	notifydata.sound = sound;
	notifydata.duration = duration;
	self.startmessagenotifyqueue[self.startmessagenotifyqueue.size] = notifydata;
	self notify(#"hash_2528173");
}

/*
	Name: notifymessage
	Namespace: hud_message
	Checksum: 0xABA1D943
	Offset: 0xCF0
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function notifymessage(notifydata)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(self.messagenotifyqueue))
	{
		self.messagenotifyqueue = [];
	}
	self.messagenotifyqueue[self.messagenotifyqueue.size] = notifydata;
	self notify(#"hash_2528173");
}

/*
	Name: playnotifyloop
	Namespace: hud_message
	Checksum: 0xE940172F
	Offset: 0xD58
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function playnotifyloop(duration)
{
	playnotifyloop = spawn("script_origin", (0, 0, 0));
	playnotifyloop playloopsound("uin_notify_data_loop");
	duration = duration - 4;
	if(duration < 1)
	{
		duration = 1;
	}
	wait(duration);
	playnotifyloop delete();
}

/*
	Name: shownotifymessage
	Namespace: hud_message
	Checksum: 0x859CACCE
	Offset: 0xE00
	Size: 0x79C
	Parameters: 2
	Flags: Linked
*/
function shownotifymessage(notifydata, duration)
{
	self endon(#"disconnect");
	self.doingnotify = 1;
	waitrequirevisibility(0);
	self notify(#"notifymessagebegin", duration);
	self thread resetoncancel();
	if(isdefined(notifydata.sound))
	{
		self playlocalsound(notifydata.sound);
	}
	if(isdefined(notifydata.musicstate))
	{
		self music::setmusicstate(notifydata.music);
	}
	if(isdefined(notifydata.leadersound))
	{
		if(isdefined(level.globallogic_audio_dialog_on_player_override))
		{
			self [[level.globallogic_audio_dialog_on_player_override]](notifydata.leadersound);
		}
	}
	if(isdefined(notifydata.glowcolor))
	{
		glowcolor = notifydata.glowcolor;
	}
	else
	{
		glowcolor = (0, 0, 0);
	}
	if(isdefined(notifydata.color))
	{
		color = notifydata.color;
	}
	else
	{
		color = (1, 1, 1);
	}
	anchorelem = self.notifytitle;
	if(isdefined(notifydata.titletext))
	{
		if(isdefined(notifydata.titlelabel))
		{
			self.notifytitle.label = notifydata.titlelabel;
		}
		else
		{
			self.notifytitle.label = &"";
		}
		if(isdefined(notifydata.titlelabel) && !isdefined(notifydata.titleisstring))
		{
			self.notifytitle setvalue(notifydata.titletext);
		}
		else
		{
			self.notifytitle settext(notifydata.titletext);
		}
		self.notifytitle setcod7decodefx(200, int(duration * 1000), 600);
		self.notifytitle.glowcolor = glowcolor;
		self.notifytitle.color = color;
		self.notifytitle.alpha = 1;
	}
	if(isdefined(notifydata.notifytext))
	{
		if(isdefined(notifydata.textlabel))
		{
			self.notifytext.label = notifydata.textlabel;
		}
		else
		{
			self.notifytext.label = &"";
		}
		if(isdefined(notifydata.textlabel) && !isdefined(notifydata.textisstring))
		{
			self.notifytext setvalue(notifydata.notifytext);
		}
		else
		{
			self.notifytext settext(notifydata.notifytext);
		}
		self.notifytext setcod7decodefx(100, int(duration * 1000), 600);
		self.notifytext.glowcolor = glowcolor;
		self.notifytext.color = color;
		self.notifytext.alpha = 1;
		anchorelem = self.notifytext;
	}
	if(isdefined(notifydata.notifytext2))
	{
		if(self issplitscreen())
		{
			if(isdefined(notifydata.text2label))
			{
				self iprintlnbold(notifydata.text2label, notifydata.notifytext2);
			}
			else
			{
				self iprintlnbold(notifydata.notifytext2);
			}
		}
		else
		{
			self.notifytext2 hud::setparent(anchorelem);
			if(isdefined(notifydata.text2label))
			{
				self.notifytext2.label = notifydata.text2label;
			}
			else
			{
				self.notifytext2.label = &"";
			}
			self.notifytext2 settext(notifydata.notifytext2);
			self.notifytext2 setpulsefx(100, int(duration * 1000), 1000);
			self.notifytext2.glowcolor = glowcolor;
			self.notifytext2.color = color;
			self.notifytext2.alpha = 1;
			anchorelem = self.notifytext2;
		}
	}
	if(isdefined(notifydata.iconname))
	{
		iconwidth = 60;
		iconheight = 60;
		if(isdefined(notifydata.iconwidth))
		{
			iconwidth = notifydata.iconwidth;
		}
		if(isdefined(notifydata.iconheight))
		{
			iconheight = notifydata.iconheight;
		}
		self.notifyicon hud::setparent(anchorelem);
		self.notifyicon setshader(notifydata.iconname, iconwidth, iconheight);
		self.notifyicon.alpha = 0;
		self.notifyicon fadeovertime(1);
		self.notifyicon.alpha = 1;
		waitrequirevisibility(duration);
		self.notifyicon fadeovertime(0.75);
		self.notifyicon.alpha = 0;
	}
	else
	{
		waitrequirevisibility(duration);
	}
	self notify(#"notifymessagedone");
	self.doingnotify = 0;
}

/*
	Name: waitrequirevisibility
	Namespace: hud_message
	Checksum: 0xFFDC977D
	Offset: 0x15A8
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function waitrequirevisibility(waittime)
{
	interval = 0.05;
	while(!self canreadtext())
	{
		wait(interval);
	}
	while(waittime > 0)
	{
		wait(interval);
		if(self canreadtext())
		{
			waittime = waittime - interval;
		}
	}
}

/*
	Name: canreadtext
	Namespace: hud_message
	Checksum: 0xC8D94473
	Offset: 0x1630
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function canreadtext()
{
	if(self util::is_flashbanged())
	{
		return false;
	}
	return true;
}

/*
	Name: resetondeath
	Namespace: hud_message
	Checksum: 0x93939159
	Offset: 0x1660
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function resetondeath()
{
	self endon(#"notifymessagedone");
	self endon(#"disconnect");
	level endon(#"game_ended");
	self waittill(#"death");
	resetnotify();
}

/*
	Name: resetoncancel
	Namespace: hud_message
	Checksum: 0xF8EBD61F
	Offset: 0x16B0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function resetoncancel()
{
	self notify(#"resetoncancel");
	self endon(#"resetoncancel");
	self endon(#"notifymessagedone");
	self endon(#"disconnect");
	level waittill(#"cancel_notify");
	resetnotify();
}

/*
	Name: resetnotify
	Namespace: hud_message
	Checksum: 0x43825907
	Offset: 0x1710
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function resetnotify()
{
	self.notifytitle.alpha = 0;
	self.notifytext.alpha = 0;
	self.notifytext2.alpha = 0;
	self.notifyicon.alpha = 0;
	self.doingnotify = 0;
}

/*
	Name: hintmessagedeaththink
	Namespace: hud_message
	Checksum: 0x8978C336
	Offset: 0x1778
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function hintmessagedeaththink()
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"death");
		if(isdefined(self.hintmessage))
		{
			self.hintmessage hud::destroyelem();
		}
	}
}

/*
	Name: lowermessagethink
	Namespace: hud_message
	Checksum: 0x2CD85EB0
	Offset: 0x17C8
	Size: 0x1C8
	Parameters: 0
	Flags: Linked
*/
function lowermessagethink()
{
	self endon(#"disconnect");
	messagetexty = level.lowertexty;
	if(self issplitscreen())
	{
		messagetexty = level.lowertexty - 50;
	}
	self.lowermessage = hud::createfontstring("default", level.lowertextfontsize);
	self.lowermessage hud::setpoint("CENTER", level.lowertextyalign, 0, messagetexty);
	self.lowermessage settext("");
	self.lowermessage.archived = 0;
	timerfontsize = 1.5;
	if(self issplitscreen())
	{
		timerfontsize = 1.4;
	}
	self.lowertimer = hud::createfontstring("default", timerfontsize);
	self.lowertimer hud::setparent(self.lowermessage);
	self.lowertimer hud::setpoint("TOP", "BOTTOM", 0, 0);
	self.lowertimer settext("");
	self.lowertimer.archived = 0;
}

/*
	Name: setmatchscorehudelemforteam
	Namespace: hud_message
	Checksum: 0x4D0387A1
	Offset: 0x1998
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function setmatchscorehudelemforteam(team)
{
	if(level.cumulativeroundscores)
	{
		self setvalue(getteamscore(team));
	}
	else
	{
		self setvalue(util::get_rounds_won(team));
	}
}

/*
	Name: isintop
	Namespace: hud_message
	Checksum: 0x4C8461C3
	Offset: 0x1A10
	Size: 0x66
	Parameters: 2
	Flags: None
*/
function isintop(players, topn)
{
	for(i = 0; i < topn; i++)
	{
		if(isdefined(players[i]) && self == players[i])
		{
			return true;
		}
	}
	return false;
}

/*
	Name: destroyhudelem
	Namespace: hud_message
	Checksum: 0x3D8C1855
	Offset: 0x1A80
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function destroyhudelem(hudelem)
{
	if(isdefined(hudelem))
	{
		hudelem hud::destroyelem();
	}
}

/*
	Name: setshoutcasterwaitingmessage
	Namespace: hud_message
	Checksum: 0xEF39D67C
	Offset: 0x1AB8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function setshoutcasterwaitingmessage()
{
	if(!isdefined(self.waitingforplayerstext))
	{
		self.waitingforplayerstext = hud::createfontstring("objective", 2.5);
		self.waitingforplayerstext hud::setpoint("CENTER", "CENTER", 0, -80);
		self.waitingforplayerstext.sort = 1001;
		self.waitingforplayerstext settext(&"MP_WAITING_FOR_PLAYERS_SHOUTCASTER");
		self.waitingforplayerstext.foreground = 0;
		self.waitingforplayerstext.hidewheninmenu = 1;
	}
}

/*
	Name: clearshoutcasterwaitingmessage
	Namespace: hud_message
	Checksum: 0xFC203B0E
	Offset: 0x1B90
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function clearshoutcasterwaitingmessage()
{
	if(isdefined(self.waitingforplayerstext))
	{
		destroyhudelem(self.waitingforplayerstext);
		self.waitingforplayerstext = undefined;
	}
}

/*
	Name: waittillnotifiesdone
	Namespace: hud_message
	Checksum: 0x997D5D4F
	Offset: 0x1BD0
	Size: 0xEE
	Parameters: 0
	Flags: None
*/
function waittillnotifiesdone()
{
	pendingnotifies = 1;
	timewaited = 0;
	while(pendingnotifies && timewaited < 12)
	{
		pendingnotifies = 0;
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(players[i].notifyqueue) && players[i].notifyqueue.size > 0)
			{
				pendingnotifies = 1;
			}
		}
		if(pendingnotifies)
		{
			wait(0.2);
		}
		timewaited = timewaited + 0.2;
	}
}

