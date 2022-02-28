// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace remotemissile;

/*
	Name: __init__sytem__
	Namespace: remotemissile
	Checksum: 0xEB9702C9
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("remotemissile", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: remotemissile
	Checksum: 0xD3DE3808
	Offset: 0x238
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("missile", "remote_missile_bomblet_fired", 1, 1, "int", &bomblets_deployed, 0, 0);
	clientfield::register("missile", "remote_missile_fired", 1, 2, "int", &missile_fired, 0, 0);
}

/*
	Name: missile_fired
	Namespace: remotemissile
	Checksum: 0x64FBBDF3
	Offset: 0x2D8
	Size: 0x2CC
	Parameters: 7
	Flags: Linked
*/
function missile_fired(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		player = getlocalplayer(localclientnum);
		owner = self getowner(localclientnum);
		clientobjid = util::getnextobjid(localclientnum);
		objective_add(localclientnum, clientobjid, "invisible", self.origin, self.team, owner);
		objective_onentity(localclientnum, clientobjid, self, 1, 0, 1);
		self.hellfireobjid = clientobjid;
		self thread destruction_watcher(localclientnum, clientobjid);
		objective_state(localclientnum, clientobjid, "active");
		if(player hasperk(localclientnum, "specialty_showenemyequipment") || self.team == player.team)
		{
			objective_seticon(localclientnum, clientobjid, "remotemissile_target");
			objective_seticonsize(localclientnum, clientobjid, 50);
		}
		self thread hud_update(localclientnum);
	}
	else
	{
		if(newval == 2)
		{
			if(isdefined(self.hellfireobjid))
			{
				self notify(#"hellfire_detonated");
				objective_delete(localclientnum, self.hellfireobjid);
				util::releaseobjid(localclientnum, self.hellfireobjid);
			}
		}
		else
		{
			self notify(#"cleanup_objectives");
		}
	}
	ammo_ui_data_model = getuimodel(getuimodelforcontroller(localclientnum), "vehicle.ammo");
	if(isdefined(ammo_ui_data_model))
	{
		setuimodelvalue(ammo_ui_data_model, 1);
	}
}

/*
	Name: bomblets_deployed
	Namespace: remotemissile
	Checksum: 0x7D3DAD90
	Offset: 0x5B0
	Size: 0x23C
	Parameters: 7
	Flags: Linked
*/
function bomblets_deployed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(bnewent && oldval == newval)
	{
		return;
	}
	if(newval == 1)
	{
		player = getlocalplayer(localclientnum);
		owner = self getowner(localclientnum);
		clientobjid = util::getnextobjid(localclientnum);
		objective_add(localclientnum, clientobjid, "invisible", self.origin, self.team, owner);
		objective_onentity(localclientnum, clientobjid, self, 1, 0, 1);
		self thread destruction_watcher(localclientnum, clientobjid);
		objective_state(localclientnum, clientobjid, "active");
		if(player hasperk(localclientnum, "specialty_showenemyequipment") || player.team == self.team)
		{
			objective_seticon(localclientnum, clientobjid, "remotemissile_target");
		}
	}
	else
	{
		self notify(#"cleanup_objectives");
	}
	ammo_ui_data_model = getuimodel(getuimodelforcontroller(localclientnum), "vehicle.ammo");
	if(isdefined(ammo_ui_data_model))
	{
		setuimodelvalue(ammo_ui_data_model, 0);
	}
}

/*
	Name: destruction_watcher
	Namespace: remotemissile
	Checksum: 0x53FC81A
	Offset: 0x7F8
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function destruction_watcher(localclientnum, clientobjid)
{
	self util::waittill_any("death", "entityshutdown", "cleanup_objectives");
	wait(0.1);
	if(isdefined(clientobjid))
	{
		objective_delete(localclientnum, clientobjid);
		util::releaseobjid(localclientnum, clientobjid);
	}
}

/*
	Name: hud_update
	Namespace: remotemissile
	Checksum: 0x418B2CD5
	Offset: 0x890
	Size: 0x1D0
	Parameters: 1
	Flags: Linked
*/
function hud_update(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"remote_missile_singeton");
	self endon(#"remote_missile_singeton");
	missile = self;
	altitude_ui_data_model = getuimodel(getuimodelforcontroller(localclientnum), "vehicle.altitude");
	speed_ui_data_model = getuimodel(getuimodelforcontroller(localclientnum), "vehicle.speed");
	if(!isdefined(altitude_ui_data_model) || !isdefined(speed_ui_data_model))
	{
		return;
	}
	prev_z = missile.origin[2];
	fps = 20;
	delay = 1 / fps;
	while(true)
	{
		cur_z = missile.origin[2];
		setuimodelvalue(altitude_ui_data_model, cur_z);
		dist = (prev_z - cur_z) * fps;
		val = dist / 17.6;
		setuimodelvalue(speed_ui_data_model, val);
		prev_z = cur_z;
		wait(delay);
	}
}

