// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace mpdialog;

/*
	Name: __init__sytem__
	Namespace: mpdialog
	Checksum: 0xC1AD19B3
	Offset: 0x2E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("mpdialog", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: mpdialog
	Checksum: 0x2D1F01B2
	Offset: 0x328
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.mpboostresponse = [];
	level.mpboostresponse["assassin"] = "Spectre";
	level.mpboostresponse["grenadier"] = "Grenadier";
	level.mpboostresponse["outrider"] = "Outrider";
	level.mpboostresponse["prophet"] = "Technomancer";
	level.mpboostresponse["pyro"] = "Firebreak";
	level.mpboostresponse["reaper"] = "Reaper";
	level.mpboostresponse["ruin"] = "Mercenary";
	level.mpboostresponse["seraph"] = "Enforcer";
	level.mpboostresponse["trapper"] = "Trapper";
	level.mpboostresponse["blackjack"] = "Blackjack";
	level.clientvoicesetup = &client_voice_setup;
	clientfield::register("world", "boost_number", 1, 2, "int", &set_boost_number, 1, 1);
	clientfield::register("allplayers", "play_boost", 1, 2, "int", &play_boost_vox, 1, 0);
}

/*
	Name: client_voice_setup
	Namespace: mpdialog
	Checksum: 0x74848AE9
	Offset: 0x500
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function client_voice_setup(localclientnum)
{
	self thread snipervonotify(localclientnum, "playerbreathinsound", "exertSniperHold");
	self thread snipervonotify(localclientnum, "playerbreathoutsound", "exertSniperExhale");
	self thread snipervonotify(localclientnum, "playerbreathgaspsound", "exertSniperGasp");
}

/*
	Name: snipervonotify
	Namespace: mpdialog
	Checksum: 0x548A283A
	Offset: 0x590
	Size: 0x98
	Parameters: 3
	Flags: Linked
*/
function snipervonotify(localclientnum, notifystring, dialogkey)
{
	self endon(#"entityshutdown");
	for(;;)
	{
		self waittill(notifystring);
		if(isunderwater(localclientnum))
		{
			return;
		}
		dialogalias = self get_player_dialog_alias(dialogkey);
		if(isdefined(dialogalias))
		{
			self playsound(0, dialogalias);
		}
	}
}

/*
	Name: set_boost_number
	Namespace: mpdialog
	Checksum: 0x582F1F46
	Offset: 0x630
	Size: 0x48
	Parameters: 7
	Flags: Linked
*/
function set_boost_number(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.boostnumber = newval;
}

/*
	Name: play_boost_vox
	Namespace: mpdialog
	Checksum: 0x1AA080FC
	Offset: 0x680
	Size: 0x13C
	Parameters: 7
	Flags: Linked
*/
function play_boost_vox(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	localplayerteam = getlocalplayerteam(localclientnum);
	entitynumber = self getentitynumber();
	if(newval == 0 || self.team != localplayerteam || level._sndnextsnapshot != "mpl_prematch" || level.booststartentnum === entitynumber || level.boostresponseentnum === entitynumber)
	{
		return;
	}
	if(newval == 1)
	{
		level.booststartentnum = entitynumber;
		self thread play_boost_start_vox(localclientnum);
	}
	else if(newval == 2)
	{
		level.boostresponseentnum = entitynumber;
		self thread play_boost_start_response_vox(localclientnum);
	}
}

/*
	Name: play_boost_start_vox
	Namespace: mpdialog
	Checksum: 0xA19F1A19
	Offset: 0x7C8
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function play_boost_start_vox(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	wait(2);
	playbackid = self play_dialog("boostStart" + level.boostnumber, localclientnum);
	if(isdefined(playbackid) && playbackid >= 0)
	{
		while(soundplaying(playbackid))
		{
			wait(0.05);
		}
	}
	wait(0.5);
	level.booststartresponse = ("boostStartResp" + level.mpboostresponse[self getmpdialogname()]) + level.boostnumber;
	if(isdefined(level.boostresponseentnum))
	{
		responder = getentbynum(localclientnum, level.boostresponseentnum);
		if(isdefined(responder))
		{
			responder thread play_boost_start_response_vox(localclientnum);
		}
	}
}

/*
	Name: play_boost_start_response_vox
	Namespace: mpdialog
	Checksum: 0x70C160F3
	Offset: 0x908
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function play_boost_start_response_vox(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	if(!isdefined(level.booststartresponse) || self.team != getlocalplayerteam(localclientnum))
	{
		return;
	}
	self play_dialog(level.booststartresponse, localclientnum);
}

/*
	Name: get_commander_dialog_alias
	Namespace: mpdialog
	Checksum: 0x1DC713F
	Offset: 0x990
	Size: 0x62
	Parameters: 2
	Flags: None
*/
function get_commander_dialog_alias(commandername, dialogkey)
{
	if(!isdefined(commandername))
	{
		return;
	}
	commanderbundle = struct::get_script_bundle("mpdialog_commander", commandername);
	return get_dialog_bundle_alias(commanderbundle, dialogkey);
}

/*
	Name: get_player_dialog_alias
	Namespace: mpdialog
	Checksum: 0x643779E4
	Offset: 0xA00
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function get_player_dialog_alias(dialogkey)
{
	bundlename = self getmpdialogname();
	if(!isdefined(bundlename))
	{
		return undefined;
	}
	playerbundle = struct::get_script_bundle("mpdialog_player", bundlename);
	return get_dialog_bundle_alias(playerbundle, dialogkey);
}

/*
	Name: get_dialog_bundle_alias
	Namespace: mpdialog
	Checksum: 0xAB17A4EB
	Offset: 0xA90
	Size: 0xAE
	Parameters: 2
	Flags: Linked
*/
function get_dialog_bundle_alias(dialogbundle, dialogkey)
{
	if(!isdefined(dialogbundle) || !isdefined(dialogkey))
	{
		return undefined;
	}
	dialogalias = getstructfield(dialogbundle, dialogkey);
	if(!isdefined(dialogalias))
	{
		return;
	}
	voiceprefix = getstructfield(dialogbundle, "voiceprefix");
	if(isdefined(voiceprefix))
	{
		dialogalias = voiceprefix + dialogalias;
	}
	return dialogalias;
}

/*
	Name: play_dialog
	Namespace: mpdialog
	Checksum: 0xBB5246CF
	Offset: 0xB48
	Size: 0x162
	Parameters: 2
	Flags: Linked
*/
function play_dialog(dialogkey, localclientnum)
{
	if(!isdefined(dialogkey) || !isdefined(localclientnum))
	{
		return -1;
	}
	dialogalias = self get_player_dialog_alias(dialogkey);
	if(!isdefined(dialogalias))
	{
		return -1;
	}
	soundpos = (self.origin[0], self.origin[1], self.origin[2] + 60);
	if(!isspectating(localclientnum))
	{
		return self playsound(undefined, dialogalias, soundpos);
	}
	voicebox = spawn(localclientnum, self.origin, "script_model");
	self thread update_voice_origin(voicebox);
	voicebox thread delete_after(10);
	return voicebox playsound(undefined, dialogalias, soundpos);
}

/*
	Name: update_voice_origin
	Namespace: mpdialog
	Checksum: 0x7A9DC328
	Offset: 0xCB8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function update_voice_origin(voicebox)
{
	while(true)
	{
		wait(0.1);
		if(!isdefined(self) || !isdefined(voicebox))
		{
			return;
		}
		voicebox.origin = self.origin;
	}
}

/*
	Name: delete_after
	Namespace: mpdialog
	Checksum: 0x5FE5D4B8
	Offset: 0xD10
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function delete_after(waittime)
{
	wait(waittime);
	self delete();
}

