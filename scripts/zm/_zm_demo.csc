// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _zm_demo;

/*
	Name: __init__sytem__
	Namespace: _zm_demo
	Checksum: 0xA96465A8
	Offset: 0x168
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_demo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_demo
	Checksum: 0xD9C3BDFB
	Offset: 0x1A8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(isdemoplaying())
	{
		if(!isdefined(level.demolocalclients))
		{
			level.demolocalclients = [];
		}
		callback::on_localclient_connect(&player_on_connect);
	}
}

/*
	Name: player_on_connect
	Namespace: _zm_demo
	Checksum: 0x838493F1
	Offset: 0x208
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function player_on_connect(localclientnum)
{
	level thread watch_predicted_player_changes(localclientnum);
}

/*
	Name: watch_predicted_player_changes
	Namespace: _zm_demo
	Checksum: 0x3AF5D63D
	Offset: 0x238
	Size: 0x214
	Parameters: 1
	Flags: Linked
*/
function watch_predicted_player_changes(localclientnum)
{
	level.demolocalclients[localclientnum] = spawnstruct();
	level.demolocalclients[localclientnum].nonpredicted_local_player = getnonpredictedlocalplayer(localclientnum);
	level.demolocalclients[localclientnum].predicted_local_player = getlocalplayer(localclientnum);
	while(true)
	{
		nonpredicted_local_player = getnonpredictedlocalplayer(localclientnum);
		predicted_local_player = getlocalplayer(localclientnum);
		if(nonpredicted_local_player !== level.demolocalclients[localclientnum].nonpredicted_local_player)
		{
			level notify(#"demo_nplplayer_change", localclientnum, level.demolocalclients[localclientnum].nonpredicted_local_player, nonpredicted_local_player);
			level notify("demo_nplplayer_change" + localclientnum, level.demolocalclients[localclientnum].nonpredicted_local_player, nonpredicted_local_player);
			level.demolocalclients[localclientnum].nonpredicted_local_player = nonpredicted_local_player;
		}
		if(predicted_local_player !== level.demolocalclients[localclientnum].predicted_local_player)
		{
			level notify(#"demo_plplayer_change", localclientnum, level.demolocalclients[localclientnum].predicted_local_player, predicted_local_player);
			level notify("demo_plplayer_change" + localclientnum, level.demolocalclients[localclientnum].predicted_local_player, predicted_local_player);
			level.demolocalclients[localclientnum].predicted_local_player = predicted_local_player;
		}
		wait(0.016);
	}
}

