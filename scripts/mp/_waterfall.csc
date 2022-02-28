// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\water_surface;

#namespace waterfall;

/*
	Name: waterfalloverlay
	Namespace: waterfall
	Checksum: 0x1A70C90F
	Offset: 0x210
	Size: 0xCA
	Parameters: 1
	Flags: None
*/
function waterfalloverlay(localclientnum)
{
	triggers = getentarray(localclientnum, "waterfall", "targetname");
	foreach(trigger in triggers)
	{
		trigger thread setupwaterfall(localclientnum);
	}
}

/*
	Name: waterfallmistoverlay
	Namespace: waterfall
	Checksum: 0xFD5D4B84
	Offset: 0x2E8
	Size: 0xCA
	Parameters: 1
	Flags: None
*/
function waterfallmistoverlay(localclientnum)
{
	triggers = getentarray(localclientnum, "waterfall_mist", "targetname");
	foreach(trigger in triggers)
	{
		trigger thread setupwaterfallmist(localclientnum);
	}
}

/*
	Name: waterfallmistoverlayreset
	Namespace: waterfall
	Checksum: 0x63426D8C
	Offset: 0x3C0
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function waterfallmistoverlayreset(localclientnum)
{
	localplayer = getlocalplayer(localclientnum);
	localplayer.rainopacity = 0;
}

/*
	Name: setupwaterfallmist
	Namespace: waterfall
	Checksum: 0x3AFB91A9
	Offset: 0x410
	Size: 0x128
	Parameters: 1
	Flags: None
*/
function setupwaterfallmist(localclientnum)
{
	level notify("setupWaterfallmist_waterfall_csc" + localclientnum);
	level endon("setupWaterfallmist_waterfall_csc" + localclientnum);
	trigger = self;
	for(;;)
	{
		trigger waittill(#"trigger", trigplayer);
		if(!trigplayer islocalplayer())
		{
			continue;
		}
		localclientnum = trigplayer getlocalclientnumber();
		if(isdefined(localclientnum))
		{
			localplayer = getlocalplayer(localclientnum);
		}
		else
		{
			localplayer = trigplayer;
		}
		filter::init_filter_sprite_rain(localplayer);
		trigger thread trigger::function_d1278be0(localplayer, &trig_enter_waterfall_mist, &trig_leave_waterfall_mist);
	}
}

/*
	Name: setupwaterfall
	Namespace: waterfall
	Checksum: 0x181D276E
	Offset: 0x540
	Size: 0x118
	Parameters: 2
	Flags: None
*/
function setupwaterfall(localclientnum, localowner)
{
	level notify("setupWaterfall_waterfall_csc" + localclientnum);
	level endon("setupWaterfall_waterfall_csc" + localclientnum);
	trigger = self;
	for(;;)
	{
		trigger waittill(#"trigger", trigplayer);
		if(!trigplayer islocalplayer())
		{
			continue;
		}
		localclientnum = trigplayer getlocalclientnumber();
		if(isdefined(localclientnum))
		{
			localplayer = getlocalplayer(localclientnum);
		}
		else
		{
			localplayer = trigplayer;
		}
		trigger thread trigger::function_d1278be0(localplayer, &trig_enter_waterfall, &trig_leave_waterfall);
	}
}

/*
	Name: trig_enter_waterfall
	Namespace: waterfall
	Checksum: 0xF395F41
	Offset: 0x660
	Size: 0xB8
	Parameters: 1
	Flags: None
*/
function trig_enter_waterfall(localplayer)
{
	trigger = self;
	localclientnum = localplayer.localclientnum;
	localplayer thread postfx::playpostfxbundle("pstfx_waterfall");
	playsound(0, "amb_waterfall_hit", (0, 0, 0));
	while(trigger istouching(localplayer))
	{
		localplayer playrumbleonentity(localclientnum, "waterfall_rumble");
		wait(0.1);
	}
}

/*
	Name: trig_leave_waterfall
	Namespace: waterfall
	Checksum: 0x235A7961
	Offset: 0x720
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function trig_leave_waterfall(localplayer)
{
	trigger = self;
	localclientnum = localplayer.localclientnum;
	localplayer postfx::stoppostfxbundle();
	if(isunderwater(localclientnum) == 0)
	{
		localplayer thread water_surface::startwatersheeting();
	}
}

/*
	Name: trig_enter_waterfall_mist
	Namespace: waterfall
	Checksum: 0xD9836BD
	Offset: 0x7B0
	Size: 0x1F0
	Parameters: 1
	Flags: None
*/
function trig_enter_waterfall_mist(localplayer)
{
	localplayer endon(#"entityshutdown");
	trigger = self;
	if(!isdefined(localplayer.rainopacity))
	{
		localplayer.rainopacity = 0;
	}
	if(localplayer.rainopacity == 0)
	{
		filter::set_filter_sprite_rain_seed_offset(localplayer, 0, randomfloat(1));
	}
	filter::enable_filter_sprite_rain(localplayer, 0);
	while(trigger istouching(localplayer))
	{
		localclientnum = trigger.localclientnum;
		if(!isdefined(localclientnum))
		{
			localclientnum = localplayer getlocalclientnumber();
		}
		if(isunderwater(localclientnum))
		{
			filter::disable_filter_sprite_rain(localplayer, 0);
			break;
		}
		localplayer.rainopacity = localplayer.rainopacity + 0.003;
		if(localplayer.rainopacity > 1)
		{
			localplayer.rainopacity = 1;
		}
		filter::set_filter_sprite_rain_opacity(localplayer, 0, localplayer.rainopacity);
		filter::set_filter_sprite_rain_elapsed(localplayer, 0, localplayer getclienttime());
		wait(0.016);
	}
}

/*
	Name: trig_leave_waterfall_mist
	Namespace: waterfall
	Checksum: 0x8382A05C
	Offset: 0x9A8
	Size: 0x174
	Parameters: 1
	Flags: None
*/
function trig_leave_waterfall_mist(localplayer)
{
	localplayer endon(#"entityshutdown");
	trigger = self;
	if(isdefined(localplayer.rainopacity))
	{
		while(!trigger istouching(localplayer) && localplayer.rainopacity > 0)
		{
			localclientnum = trigger.localclientnum;
			if(isunderwater(localclientnum))
			{
				filter::disable_filter_sprite_rain(localplayer, 0);
				break;
			}
			localplayer.rainopacity = localplayer.rainopacity - 0.005;
			filter::set_filter_sprite_rain_opacity(localplayer, 0, localplayer.rainopacity);
			filter::set_filter_sprite_rain_elapsed(localplayer, 0, localplayer getclienttime());
			wait(0.016);
		}
	}
	localplayer.rainopacity = 0;
	filter::disable_filter_sprite_rain(localplayer, 0);
}

