// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace perplayer;

/*
	Name: init
	Namespace: perplayer
	Checksum: 0xA3A73E6A
	Offset: 0x98
	Size: 0xBC
	Parameters: 3
	Flags: None
*/
function init(id, playerbegincallback, playerendcallback)
{
	handler = spawnstruct();
	handler.id = id;
	handler.playerbegincallback = playerbegincallback;
	handler.playerendcallback = playerendcallback;
	handler.enabled = 0;
	handler.players = [];
	thread onplayerconnect(handler);
	level.handlerglobalflagval = 0;
	return handler;
}

/*
	Name: enable
	Namespace: perplayer
	Checksum: 0x213FD1BF
	Offset: 0x160
	Size: 0x146
	Parameters: 1
	Flags: None
*/
function enable(handler)
{
	if(handler.enabled)
	{
		return;
	}
	handler.enabled = 1;
	level.handlerglobalflagval++;
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i].handlerflagval = level.handlerglobalflagval;
	}
	players = handler.players;
	for(i = 0; i < players.size; i++)
	{
		if(players[i].handlerflagval != level.handlerglobalflagval)
		{
			continue;
		}
		if(players[i].handlers[handler.id].ready)
		{
			players[i] handleplayer(handler);
		}
	}
}

/*
	Name: disable
	Namespace: perplayer
	Checksum: 0x8D1B3AD2
	Offset: 0x2B0
	Size: 0x14E
	Parameters: 1
	Flags: None
*/
function disable(handler)
{
	if(!handler.enabled)
	{
		return;
	}
	handler.enabled = 0;
	level.handlerglobalflagval++;
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i].handlerflagval = level.handlerglobalflagval;
	}
	players = handler.players;
	for(i = 0; i < players.size; i++)
	{
		if(players[i].handlerflagval != level.handlerglobalflagval)
		{
			continue;
		}
		if(players[i].handlers[handler.id].ready)
		{
			players[i] unhandleplayer(handler, 0, 0);
		}
	}
}

/*
	Name: onplayerconnect
	Namespace: perplayer
	Checksum: 0xD68C9EA3
	Offset: 0x408
	Size: 0x180
	Parameters: 1
	Flags: None
*/
function onplayerconnect(handler)
{
	for(;;)
	{
		level waittill(#"connecting", player);
		if(!isdefined(player.handlers))
		{
			player.handlers = [];
		}
		player.handlers[handler.id] = spawnstruct();
		player.handlers[handler.id].ready = 0;
		player.handlers[handler.id].handled = 0;
		player.handlerflagval = -1;
		handler.players[handler.players.size] = player;
		player thread onplayerdisconnect(handler);
		player thread onplayerspawned(handler);
		player thread onjoinedteam(handler);
		player thread onjoinedspectators(handler);
		player thread onplayerkilled(handler);
	}
}

/*
	Name: onplayerdisconnect
	Namespace: perplayer
	Checksum: 0x43E1A715
	Offset: 0x590
	Size: 0xCC
	Parameters: 1
	Flags: None
*/
function onplayerdisconnect(handler)
{
	self waittill(#"disconnect");
	newplayers = [];
	for(i = 0; i < handler.players.size; i++)
	{
		if(handler.players[i] != self)
		{
			newplayers[newplayers.size] = handler.players[i];
		}
	}
	handler.players = newplayers;
	self thread unhandleplayer(handler, 1, 1);
}

/*
	Name: onjoinedteam
	Namespace: perplayer
	Checksum: 0x8F2402C5
	Offset: 0x668
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function onjoinedteam(handler)
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"joined_team");
		self thread unhandleplayer(handler, 1, 0);
	}
}

/*
	Name: onjoinedspectators
	Namespace: perplayer
	Checksum: 0xF3789B58
	Offset: 0x6B8
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function onjoinedspectators(handler)
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"joined_spectators");
		self thread unhandleplayer(handler, 1, 0);
	}
}

/*
	Name: onplayerspawned
	Namespace: perplayer
	Checksum: 0x8999EFD3
	Offset: 0x708
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function onplayerspawned(handler)
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"spawned_player");
		self thread handleplayer(handler);
	}
}

/*
	Name: onplayerkilled
	Namespace: perplayer
	Checksum: 0x98568528
	Offset: 0x750
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function onplayerkilled(handler)
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"killed_player");
		self thread unhandleplayer(handler, 1, 0);
	}
}

/*
	Name: handleplayer
	Namespace: perplayer
	Checksum: 0xD6E31FE0
	Offset: 0x7A0
	Size: 0xB0
	Parameters: 1
	Flags: None
*/
function handleplayer(handler)
{
	self.handlers[handler.id].ready = 1;
	if(!handler.enabled)
	{
		return;
	}
	if(self.handlers[handler.id].handled)
	{
		return;
	}
	self.handlers[handler.id].handled = 1;
	self thread [[handler.playerbegincallback]]();
}

/*
	Name: unhandleplayer
	Namespace: perplayer
	Checksum: 0x2A101852
	Offset: 0x858
	Size: 0xC4
	Parameters: 3
	Flags: None
*/
function unhandleplayer(handler, unsetready, disconnected)
{
	if(!disconnected && unsetready)
	{
		self.handlers[handler.id].ready = 0;
	}
	if(!self.handlers[handler.id].handled)
	{
		return;
	}
	if(!disconnected)
	{
		self.handlers[handler.id].handled = 0;
	}
	self thread [[handler.playerendcallback]](disconnected);
}

