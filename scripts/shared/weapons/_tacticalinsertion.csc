// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace tacticalinsertion;

/*
	Name: init_shared
	Namespace: tacticalinsertion
	Checksum: 0x89FF87CC
	Offset: 0x1F8
	Size: 0x1F4
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["tacticalInsertionFriendly"] = "_t6/misc/fx_equip_tac_insert_light_grn";
	level._effect["tacticalInsertionEnemy"] = "_t6/misc/fx_equip_tac_insert_light_red";
	clientfield::register("scriptmover", "tacticalinsertion", 1, 1, "int", &spawned, 0, 0);
	latlongstruct = struct::get("lat_long", "targetname");
	if(isdefined(latlongstruct))
	{
		mapx = latlongstruct.origin[0];
		mapy = latlongstruct.origin[1];
		lat = latlongstruct.script_vector[0];
		long = latlongstruct.script_vector[1];
	}
	else
	{
		if(isdefined(level.worldmapx) && isdefined(level.worldmapy))
		{
			mapx = level.worldmapx;
			mapy = level.worldmapy;
		}
		else
		{
			mapx = 0;
			mapy = 0;
		}
		if(isdefined(level.worldlat) && isdefined(level.worldlong))
		{
			lat = level.worldlat;
			long = level.worldlong;
		}
		else
		{
			lat = 34.02156;
			long = -118.4487;
		}
	}
	setmaplatlong(mapx, mapy, long, lat);
}

/*
	Name: spawned
	Namespace: tacticalinsertion
	Checksum: 0xD1B26E43
	Offset: 0x3F8
	Size: 0x5C
	Parameters: 7
	Flags: None
*/
function spawned(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	self thread checkforplayerswitch(localclientnum);
}

/*
	Name: playflarefx
	Namespace: tacticalinsertion
	Checksum: 0x6C028CAD
	Offset: 0x460
	Size: 0x11C
	Parameters: 1
	Flags: None
*/
function playflarefx(localclientnum)
{
	self endon(#"entityshutdown");
	level endon(#"player_switch");
	if(util::friend_not_foe(localclientnum))
	{
		self.tacticalinsertionfx = playfxontag(localclientnum, level._effect["tacticalInsertionFriendly"], self, "tag_flash");
	}
	else
	{
		self.tacticalinsertionfx = playfxontag(localclientnum, level._effect["tacticalInsertionEnemy"], self, "tag_flash");
	}
	self thread watchtacinsertshutdown(localclientnum, self.tacticalinsertionfx);
	looporigin = self.origin;
	audio::playloopat("fly_tinsert_beep", looporigin);
	self thread stopflareloopwatcher(looporigin);
}

/*
	Name: watchtacinsertshutdown
	Namespace: tacticalinsertion
	Checksum: 0x346141D1
	Offset: 0x588
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function watchtacinsertshutdown(localclientnum, fxhandle)
{
	self waittill(#"entityshutdown");
	stopfx(localclientnum, fxhandle);
}

/*
	Name: stopflareloopwatcher
	Namespace: tacticalinsertion
	Checksum: 0x63CEF46E
	Offset: 0x5D0
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function stopflareloopwatcher(looporigin)
{
	while(true)
	{
		if(!isdefined(self) || !isdefined(self.tacticalinsertionfx))
		{
			audio::stoploopat("fly_tinsert_beep", looporigin);
			break;
		}
		wait(0.5);
	}
}

/*
	Name: checkforplayerswitch
	Namespace: tacticalinsertion
	Checksum: 0x2CF0F956
	Offset: 0x638
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function checkforplayerswitch(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		level waittill(#"player_switch");
		if(isdefined(self.tacticalinsertionfx))
		{
			stopfx(localclientnum, self.tacticalinsertionfx);
			self.tacticalinsertionfx = undefined;
		}
		waittillframeend();
	}
}

