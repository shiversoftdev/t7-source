// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\end_game_taunts;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("all_player");

#namespace end_game_flow;

/*
	Name: __init__sytem__
	Namespace: end_game_flow
	Checksum: 0xD6E23E2A
	Offset: 0x2C0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("end_game_flow", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: end_game_flow
	Checksum: 0xC8F1A7C0
	Offset: 0x300
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "displayTop3Players", 1, 1, "int", &handletopthreeplayers, 0, 0);
	clientfield::register("world", "triggerScoreboardCamera", 1, 1, "int", &showscoreboard, 0, 0);
	clientfield::register("world", "playTop0Gesture", 1000, 3, "int", &handleplaytop0gesture, 0, 0);
	clientfield::register("world", "playTop1Gesture", 1000, 3, "int", &handleplaytop1gesture, 0, 0);
	clientfield::register("world", "playTop2Gesture", 1000, 3, "int", &handleplaytop2gesture, 0, 0);
	level thread streamerwatcher();
}

/*
	Name: setanimationonmodel
	Namespace: end_game_flow
	Checksum: 0x6F52165
	Offset: 0x490
	Size: 0xBC
	Parameters: 3
	Flags: Linked
*/
function setanimationonmodel(localclientnum, charactermodel, topplayerindex)
{
	anim_name = end_game_taunts::getidleanimname(localclientnum, charactermodel, topplayerindex);
	if(isdefined(anim_name))
	{
		charactermodel util::waittill_dobj(localclientnum);
		if(!charactermodel hasanimtree())
		{
			charactermodel useanimtree($all_player);
		}
		charactermodel setanim(anim_name);
	}
}

/*
	Name: loadcharacteronmodel
	Namespace: end_game_flow
	Checksum: 0x19F8A4AF
	Offset: 0x558
	Size: 0x454
	Parameters: 3
	Flags: Linked
*/
function loadcharacteronmodel(localclientnum, charactermodel, topplayerindex)
{
	/#
		assert(isdefined(charactermodel));
	#/
	bodymodel = gettopplayersbodymodel(localclientnum, topplayerindex);
	displaytopplayermodel = createuimodel(getuimodelforcontroller(localclientnum), "displayTopPlayer" + (topplayerindex + 1));
	setuimodelvalue(displaytopplayermodel, 1);
	if(!isdefined(bodymodel) || bodymodel == "")
	{
		setuimodelvalue(displaytopplayermodel, 0);
		return;
	}
	charactermodel setmodel(bodymodel);
	helmetmodel = gettopplayershelmetmodel(localclientnum, topplayerindex);
	if(!charactermodel isattached(helmetmodel, ""))
	{
		charactermodel.helmetmodel = helmetmodel;
		charactermodel attach(helmetmodel, "");
	}
	moderenderoptions = getcharactermoderenderoptions(currentsessionmode());
	bodyrenderoptions = gettopplayersbodyrenderoptions(localclientnum, topplayerindex);
	helmetrenderoptions = gettopplayershelmetrenderoptions(localclientnum, topplayerindex);
	weaponrenderoptions = gettopplayersweaponrenderoptions(localclientnum, topplayerindex);
	charactermodel.bodymodel = bodymodel;
	charactermodel.moderenderoptions = moderenderoptions;
	charactermodel.bodyrenderoptions = bodyrenderoptions;
	charactermodel.helmetrenderoptions = helmetrenderoptions;
	charactermodel.headrenderoptions = helmetrenderoptions;
	weapon_right = gettopplayersweaponinfo(localclientnum, topplayerindex);
	if(!isdefined(level.weaponnone))
	{
		level.weaponnone = getweapon("none");
	}
	charactermodel setbodyrenderoptions(moderenderoptions, bodyrenderoptions, helmetrenderoptions, helmetrenderoptions);
	if(weapon_right["weapon"] == level.weaponnone)
	{
		weapon_right["weapon"] = getweapon("ar_standard");
		charactermodel.showcaseweapon = weapon_right["weapon"];
		charactermodel attachweapon(weapon_right["weapon"]);
	}
	else
	{
		charactermodel.showcaseweapon = weapon_right["weapon"];
		charactermodel.showcaseweaponrenderoptions = weaponrenderoptions;
		charactermodel.showcaseweaponacvi = weapon_right["acvi"];
		charactermodel attachweapon(weapon_right["weapon"], weaponrenderoptions, weapon_right["acvi"]);
		charactermodel useweaponhidetags(weapon_right["weapon"]);
	}
}

/*
	Name: setupmodelandanimation
	Namespace: end_game_flow
	Checksum: 0xD06557C8
	Offset: 0x9B8
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function setupmodelandanimation(localclientnum, charactermodel, topplayerindex)
{
	charactermodel endon(#"entityshutdown");
	loadcharacteronmodel(localclientnum, charactermodel, topplayerindex);
	setanimationonmodel(localclientnum, charactermodel, topplayerindex);
}

/*
	Name: preparetopthreeplayers
	Namespace: end_game_flow
	Checksum: 0x6259DAA
	Offset: 0xA28
	Size: 0x126
	Parameters: 1
	Flags: Linked
*/
function preparetopthreeplayers(localclientnum)
{
	numclients = gettopscorercount(localclientnum);
	position = struct::get("endgame_top_players_struct", "targetname");
	if(!isdefined(position))
	{
		return;
	}
	for(index = 0; index < 3; index++)
	{
		if(index < numclients)
		{
			model = spawn(localclientnum, position.origin, "script_model");
			loadcharacteronmodel(localclientnum, model, index);
			model hide();
			model sethighdetail(1);
		}
	}
}

/*
	Name: showtopthreeplayers
	Namespace: end_game_flow
	Checksum: 0x13AAE18A
	Offset: 0xB58
	Size: 0x394
	Parameters: 1
	Flags: Linked
*/
function showtopthreeplayers(localclientnum)
{
	level.topplayercharacters = [];
	topplayerscriptstructs = [];
	topplayerscriptstructs[0] = struct::get("TopPlayer1", "targetname");
	topplayerscriptstructs[1] = struct::get("TopPlayer2", "targetname");
	topplayerscriptstructs[2] = struct::get("TopPlayer3", "targetname");
	foreach(index, scriptstruct in topplayerscriptstructs)
	{
		level.topplayercharacters[index] = spawn(localclientnum, scriptstruct.origin, "script_model");
		level.topplayercharacters[index].angles = scriptstruct.angles;
	}
	numclients = gettopscorercount(localclientnum);
	foreach(index, charactermodel in level.topplayercharacters)
	{
		if(index < numclients)
		{
			thread setupmodelandanimation(localclientnum, charactermodel, index);
			if(index == 0)
			{
				thread end_game_taunts::playcurrenttaunt(localclientnum, charactermodel, index);
			}
		}
	}
	/#
		level thread end_game_taunts::check_force_taunt();
		level thread end_game_taunts::check_force_gesture();
		level thread end_game_taunts::draw_runner_up_bounds();
	#/
	position = struct::get("endgame_top_players_struct", "targetname");
	playmaincamxcam(localclientnum, level.endgamexcamname, 0, "cam_topscorers", "topscorers", position.origin, position.angles);
	playradiantexploder(localclientnum, "exploder_mp_endgame_lights");
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "displayTop3Players"), 1);
	thread spamuimodelvalue(localclientnum);
	thread checkforgestures(localclientnum);
}

/*
	Name: spamuimodelvalue
	Namespace: end_game_flow
	Checksum: 0xAC5D42B1
	Offset: 0xEF8
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function spamuimodelvalue(localclientnum)
{
	while(true)
	{
		wait(0.25);
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "displayTop3Players"), 1);
	}
}

/*
	Name: checkforgestures
	Namespace: end_game_flow
	Checksum: 0x9F8E9CF7
	Offset: 0xF68
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function checkforgestures(localclientnum)
{
	localplayers = getlocalplayers();
	for(i = 0; i < localplayers.size; i++)
	{
		thread checkforplayergestures(localclientnum, localplayers[i], i);
	}
}

/*
	Name: checkforplayergestures
	Namespace: end_game_flow
	Checksum: 0xC8AC1D3C
	Offset: 0xFE8
	Size: 0xDC
	Parameters: 3
	Flags: Linked
*/
function checkforplayergestures(localclientnum, localplayer, playerindex)
{
	localtopplayerindex = localplayer gettopplayersindex(localclientnum);
	if(!isdefined(localtopplayerindex) || !isdefined(level.topplayercharacters) || localtopplayerindex >= level.topplayercharacters.size)
	{
		return;
	}
	charactermodel = level.topplayercharacters[localtopplayerindex];
	if(localtopplayerindex > 0)
	{
		wait(3);
	}
	else if(isdefined(charactermodel.playingtaunt))
	{
		charactermodel waittill(#"tauntfinished");
	}
	showgestures(localclientnum, playerindex);
}

/*
	Name: showgestures
	Namespace: end_game_flow
	Checksum: 0x70CEC1E7
	Offset: 0x10D0
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function showgestures(localclientnum, playerindex)
{
	gesturesmodel = getuimodel(getuimodelforcontroller(localclientnum), "topPlayerInfo.showGestures");
	if(isdefined(gesturesmodel))
	{
		setuimodelvalue(gesturesmodel, 1);
		allowactionslotinput(playerindex);
	}
}

/*
	Name: handleplaytop0gesture
	Namespace: end_game_flow
	Checksum: 0x648B58E6
	Offset: 0x1168
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function handleplaytop0gesture(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	handleplaygesture(localclientnum, 0, newval);
}

/*
	Name: handleplaytop1gesture
	Namespace: end_game_flow
	Checksum: 0x258D76A6
	Offset: 0x11D0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function handleplaytop1gesture(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	handleplaygesture(localclientnum, 1, newval);
}

/*
	Name: handleplaytop2gesture
	Namespace: end_game_flow
	Checksum: 0x154A28EE
	Offset: 0x1238
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function handleplaytop2gesture(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	handleplaygesture(localclientnum, 2, newval);
}

/*
	Name: handleplaygesture
	Namespace: end_game_flow
	Checksum: 0x916BCE76
	Offset: 0x12A0
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function handleplaygesture(localclientnum, topplayerindex, gesturetype)
{
	if(gesturetype > 2 || !isdefined(level.topplayercharacters) || topplayerindex >= level.topplayercharacters.size)
	{
		return;
	}
	charactermodel = level.topplayercharacters[topplayerindex];
	if(isdefined(charactermodel.playingtaunt) || (isdefined(charactermodel.playinggesture) && charactermodel.playinggesture))
	{
		return;
	}
	thread end_game_taunts::playgesturetype(localclientnum, charactermodel, topplayerindex, gesturetype);
}

/*
	Name: streamerwatcher
	Namespace: end_game_flow
	Checksum: 0x2D21BD00
	Offset: 0x1370
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function streamerwatcher()
{
	while(true)
	{
		level waittill(#"streamfksl", localclientnum);
		preparetopthreeplayers(localclientnum);
		end_game_taunts::stream_epic_models();
	}
}

/*
	Name: handletopthreeplayers
	Namespace: end_game_flow
	Checksum: 0x38E15084
	Offset: 0x13C8
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function handletopthreeplayers(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(newval) && newval > 0 && isdefined(level.endgamexcamname))
	{
		level.showedtopthreeplayers = 1;
		showtopthreeplayers(localclientnum);
	}
}

/*
	Name: showscoreboard
	Namespace: end_game_flow
	Checksum: 0x7D9A714A
	Offset: 0x1458
	Size: 0x150
	Parameters: 7
	Flags: Linked
*/
function showscoreboard(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(newval) && newval > 0 && isdefined(level.endgamexcamname))
	{
		end_game_taunts::stop_stream_epic_models();
		end_game_taunts::deletecameraglass(undefined);
		position = struct::get("endgame_top_players_struct", "targetname");
		playmaincamxcam(localclientnum, level.endgamexcamname, 0, "cam_topscorers", "", position.origin, position.angles);
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "forceScoreboard"), 1);
		level.inendgameflow = 1;
	}
}

