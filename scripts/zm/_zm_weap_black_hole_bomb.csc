// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_vortex;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_black_hole_bomb;

/*
	Name: __init__sytem__
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xD9F187AC
	Offset: 0x390
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_black_hole_bomb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x99639D8E
	Offset: 0x3D0
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["black_hole_bomb_portal"] = "dlc5/cosmo/fx_zmb_blackhole_looping";
	level._effect["black_hole_bomb_event_horizon"] = "dlc5/cosmo/fx_zmb_blackhole_implode";
	level._effect["black_hole_bomb_marker_flare"] = "dlc5/cosmo/fx_zmb_blackhole_flare_marker";
	level._effect["black_hole_bomb_zombie_pull"] = "dlc5/cosmo/fx_blackhole_zombie_breakup";
	level._current_black_hole_bombs = [];
	level._visionset_black_hole_bomb = "zombie_cosmodrome_blackhole";
	level._visionset_black_hole_bomb_transition_time_in = 2;
	level._visionset_black_hole_bomb_transition_time_out = 1;
	level._visionset_black_hole_bomb_priority = 10;
	visionset_mgr::register_visionset_info("zombie_cosmodrome_blackhole", 21000, 30, undefined, "zombie_cosmodrome_blackhole");
	clientfield::register("toplayer", "bhb_viewlights", 21000, 2, "int", &bhb_viewlights, 0, 0);
	clientfield::register("scriptmover", "toggle_black_hole_deployed", 21000, 1, "int", &black_hole_deployed, 0, 0);
	clientfield::register("actor", "toggle_black_hole_being_pulled", 21000, 1, "int", &black_hole_zombie_being_pulled, 0, 1);
}

/*
	Name: bhb_viewlights
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x9279E2E
	Offset: 0x598
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function bhb_viewlights(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 100, newval, 0);
	}
	else
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

/*
	Name: black_hole_deployed
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xB700AC6D
	Offset: 0x648
	Size: 0xAE
	Parameters: 7
	Flags: Linked
*/
function black_hole_deployed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		level thread black_hole_fx_start(i, self);
	}
}

/*
	Name: black_hole_fx_start
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x676C55A0
	Offset: 0x700
	Size: 0x224
	Parameters: 2
	Flags: Linked
*/
function black_hole_fx_start(local_client_num, ent_bomb)
{
	bomb_fx_spot = spawn(local_client_num, ent_bomb.origin, "script_model");
	bomb_fx_spot setmodel("tag_origin");
	playsound(0, "wpn_bhbomb_portal_start", bomb_fx_spot.origin);
	bomb_fx_spot.sndlooper = bomb_fx_spot playloopsound("wpn_bhbomb_portal_loop");
	playfxontag(local_client_num, level._effect["black_hole_bomb_portal"], bomb_fx_spot, "tag_origin");
	playfxontag(local_client_num, level._effect["black_hole_bomb_marker_flare"], bomb_fx_spot, "tag_origin");
	ent_bomb waittill(#"entityshutdown");
	if(isdefined(bomb_fx_spot.sndlooper))
	{
		bomb_fx_spot stoploopsound(bomb_fx_spot.sndlooper);
	}
	event_horizon_spot = spawn(local_client_num, bomb_fx_spot.origin, "script_model");
	event_horizon_spot setmodel("tag_origin");
	bomb_fx_spot delete();
	playfxontag(local_client_num, level._effect["black_hole_bomb_event_horizon"], event_horizon_spot, "tag_origin");
	wait(0.2);
	event_horizon_spot delete();
}

/*
	Name: black_hole_activated
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x736C08E2
	Offset: 0x930
	Size: 0xA4
	Parameters: 2
	Flags: None
*/
function black_hole_activated(ent_model, int_local_client_num)
{
	new_black_hole_struct = spawnstruct();
	new_black_hole_struct.origin = ent_model.origin;
	new_black_hole_struct._black_hole_active = 1;
	array::add(level._current_black_hole_bombs, new_black_hole_struct);
	ent_model waittill(#"entityshutdown");
	new_black_hole_struct._black_hole_active = 0;
	wait(0.2);
}

/*
	Name: black_hole_zombie_being_pulled
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x932D1D94
	Offset: 0x9E0
	Size: 0x1E4
	Parameters: 7
	Flags: Linked
*/
function black_hole_zombie_being_pulled(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	if(localclientnum != 0)
	{
		return;
	}
	if(newval)
	{
		self._bhb_pulled_in_fx = spawn(localclientnum, self.origin, "script_model");
		self._bhb_pulled_in_fx.angles = self.angles;
		self._bhb_pulled_in_fx linkto(self, "tag_origin");
		self._bhb_pulled_in_fx setmodel("tag_origin");
		level thread black_hole_bomb_pulled_in_fx_clean(self, self._bhb_pulled_in_fx);
		players = getlocalplayers();
		for(i = 0; i < players.size; i++)
		{
			playfxontag(i, level._effect["black_hole_bomb_zombie_pull"], self._bhb_pulled_in_fx, "tag_origin");
		}
	}
	else if(isdefined(self._bhb_pulled_in_fx))
	{
		self._bhb_pulled_in_fx notify(#"no_clean_up_needed");
		self._bhb_pulled_in_fx unlink();
		self._bhb_pulled_in_fx delete();
	}
}

/*
	Name: black_hole_bomb_pulled_in_fx_clean
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x748EE14D
	Offset: 0xBD0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function black_hole_bomb_pulled_in_fx_clean(ent_zombie, ent_fx_origin)
{
	ent_fx_origin endon(#"no_clean_up_needed");
	if(!isdefined(ent_zombie))
	{
		return;
	}
	ent_zombie waittill(#"entityshutdown");
	if(isdefined(ent_fx_origin))
	{
		ent_fx_origin delete();
	}
}

