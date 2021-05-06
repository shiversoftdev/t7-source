// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\util_shared;

#namespace zm_moon_teleporter;

/*
	Name: main
	Namespace: zm_moon_teleporter
	Checksum: 0xA8E36342
	Offset: 0x130
	Size: 0xCE
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread wait_for_teleport_aftereffect();
	util::waitforallclients();
	level.portal_effect = level._effect["zombie_pentagon_teleporter"];
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread teleporter_fx_setup(i);
		players[i] thread teleporter_fx_cool_down(i);
	}
}

/*
	Name: teleporter_fx_setup
	Namespace: zm_moon_teleporter
	Checksum: 0x5C8F200E
	Offset: 0x208
	Size: 0x1A2
	Parameters: 1
	Flags: None
*/
function teleporter_fx_setup(clientnum)
{
	teleporters = getentarray(clientnum, "pentagon_teleport_fx", "targetname");
	level.fxents[clientnum] = [];
	level.packtime[clientnum] = 1;
	for(i = 0; i < teleporters.size; i++)
	{
		fx_ent = spawn(clientnum, teleporters[i].origin, "script_model");
		fx_ent setmodel("tag_origin");
		fx_ent.angles = teleporters[i].angles;
		if(!isdefined(level.fxents[clientnum]))
		{
			level.fxents[clientnum] = [];
		}
		else if(!isarray(level.fxents[clientnum]))
		{
			level.fxents[clientnum] = array(level.fxents[clientnum]);
		}
		level.fxents[clientnum][level.fxents[clientnum].size] = fx_ent;
	}
}

/*
	Name: teleporter_fx_init
	Namespace: zm_moon_teleporter
	Checksum: 0x98C2A46E
	Offset: 0x3B8
	Size: 0x1A6
	Parameters: 3
	Flags: None
*/
function teleporter_fx_init(clientnum, set, newent)
{
	fx_array = level.fxents[clientnum];
	if(set && level.packtime[clientnum] == 1)
	{
		/#
			println("", clientnum);
		#/
		level.packtime[clientnum] = 0;
		for(i = 0; i < fx_array.size; i++)
		{
			if(isdefined(fx_array[i].portalfx))
			{
				deletefx(clientnum, fx_array[i].portalfx);
			}
			wait(0.01);
			fx_array[i].portalfx = playfxontag(clientnum, level.portal_effect, fx_array[i], "tag_origin");
			playsound(clientnum, "evt_teleporter_start", fx_array[i].origin);
			fx_array[i] playloopsound("evt_teleporter_loop", 1.75);
		}
	}
}

/*
	Name: teleporter_fx_cool_down
	Namespace: zm_moon_teleporter
	Checksum: 0xDD8FD674
	Offset: 0x568
	Size: 0x218
	Parameters: 1
	Flags: None
*/
function teleporter_fx_cool_down(clientnum)
{
	while(true)
	{
		level waittill(#"cool_fx", clientnum);
		players = getlocalplayers();
		if(level.packtime[clientnum] == 0)
		{
			fx_pos = undefined;
			closest = 512;
			for(i = 0; i < level.fxents[clientnum].size; i++)
			{
				if(isdefined(level.fxents[clientnum][i]))
				{
					if(closest > distance(level.fxents[clientnum][i].origin, players[clientnum].origin))
					{
						closest = distance(level.fxents[clientnum][i].origin, players[clientnum].origin);
						fx_pos = level.fxents[clientnum][i];
					}
				}
			}
			if(isdefined(fx_pos) && isdefined(fx_pos.portalfx))
			{
				deletefx(clientnum, fx_pos.portalfx);
				fx_pos.portalfx = playfxontag(clientnum, level._effect["zombie_pent_portal_cool"], fx_pos, "tag_origin");
				self thread turn_off_cool_down_fx(fx_pos, clientnum);
			}
		}
		wait(0.1);
	}
}

/*
	Name: turn_off_cool_down_fx
	Namespace: zm_moon_teleporter
	Checksum: 0x17359D1F
	Offset: 0x788
	Size: 0xC8
	Parameters: 2
	Flags: None
*/
function turn_off_cool_down_fx(fx_pos, clientnum)
{
	fx_pos thread cool_down_timer();
	fx_pos waittill(#"cool_down_over");
	if(isdefined(fx_pos) && isdefined(fx_pos.portalfx))
	{
		deletefx(clientnum, fx_pos.portalfx);
		if(level.packtime[clientnum] == 0)
		{
			fx_pos.portalfx = playfxontag(clientnum, level.portal_effect, fx_pos, "tag_origin");
		}
	}
}

/*
	Name: cool_down_timer
	Namespace: zm_moon_teleporter
	Checksum: 0x28AB658F
	Offset: 0x858
	Size: 0x6A
	Parameters: 0
	Flags: None
*/
function cool_down_timer()
{
	time = 0;
	self.defcon_active = 0;
	self thread pack_cooldown_listener();
	while(!self.defcon_active && time < 20)
	{
		wait(1);
		time++;
	}
	self notify(#"cool_down_over");
}

/*
	Name: pack_cooldown_listener
	Namespace: zm_moon_teleporter
	Checksum: 0xC2021E56
	Offset: 0x8D0
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function pack_cooldown_listener()
{
	self endon(#"cool_down_over");
	level waittill(#"end_cool_downs");
	self.defcon_active = 1;
}

/*
	Name: wait_for_teleport_aftereffect
	Namespace: zm_moon_teleporter
	Checksum: 0x28B03046
	Offset: 0x900
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function wait_for_teleport_aftereffect()
{
	while(true)
	{
		level waittill(#"ae1", clientnum);
		visionsetnaked(clientnum, "flare", 0.4);
	}
}

