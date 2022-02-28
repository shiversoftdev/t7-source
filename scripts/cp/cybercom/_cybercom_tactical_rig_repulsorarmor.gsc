// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom_tacrig_respulsorarmor;

/*
	Name: init
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0x99EC1590
	Offset: 0x3C8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0x1053978
	Offset: 0x3D8
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level._effect["repulsorarmor_fx"] = "player/fx_plyr_ability_repulsor_armor";
	level._effect["repulsorarmorUpgraded_fx"] = "player/fx_plyr_ability_repulsor_armor";
	level._effect["repulsorarmor_contact"] = "electric/fx_elec_sparks_burst_lg_os";
	cybercom_tacrig::register_cybercom_rig_ability("cybercom_repulsorarmor", 1);
	cybercom_tacrig::register_cybercom_rig_possession_callbacks("cybercom_repulsorarmor", &repulsorarmorshieldgive, &repulsorarmorshieldtake);
}

/*
	Name: on_player_connect
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0x99EC1590
	Offset: 0x4D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0x99EC1590
	Offset: 0x4E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: repulsorarmorshieldgive
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0x6BB68ADD
	Offset: 0x4F0
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function repulsorarmorshieldgive(type)
{
	if(!isdefined(self.cybercom.var_c281e3c))
	{
		self.cybercom.var_c281e3c = [];
		self.cybercom.var_c281e3c[0] = spawnstruct();
		self.cybercom.var_c281e3c[1] = spawnstruct();
		self.cybercom.var_c281e3c[2] = spawnstruct();
		self.cybercom.var_c281e3c[3] = spawnstruct();
		self.cybercom.var_c281e3c[0].time = 0;
		self.cybercom.var_c281e3c[1].time = 0;
		self.cybercom.var_c281e3c[2].time = 0;
		self.cybercom.var_c281e3c[3].time = 0;
	}
	self thread function_170e07a2();
	self thread _threatmonitor(type);
}

/*
	Name: repulsorarmorshieldtake
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0xAEB2CF85
	Offset: 0x688
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function repulsorarmorshieldtake(type)
{
	if(isdefined(self.missile_repulsor))
	{
		missile_deleteattractor(self.missile_repulsor);
		self.missile_repulsor = undefined;
	}
	self notify(#"repulsorarmorshieldtake");
	self.cybercom.var_c281e3c = undefined;
}

/*
	Name: _threatmonitor
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0xD565A0E
	Offset: 0x6F0
	Size: 0x208
	Parameters: 1
	Flags: Linked, Private
*/
function private _threatmonitor(weapon)
{
	self notify(#"repulsearmorthreatmonitor");
	self endon(#"repulsearmorthreatmonitor");
	self endon(#"repulsorarmorshieldtake");
	self endon(#"death");
	self endon(#"disconnect");
	isupgraded = self hascybercomrig(weapon) == 2;
	fx = (isupgraded ? level._effect["repulsorarmorUpgraded_fx"] : level._effect["repulsorarmor_fx"]);
	if(!isdefined(self.missile_repulsor))
	{
		self.missile_repulsor = missile_createrepulsorent(self, 4000, getdvarint("scr_repulsorarmor_dist", 200), isupgraded);
	}
	cooldown = 0.5;
	var_6d621232 = gettime();
	while(true)
	{
		self waittill(#"projectile_applyattractor", missile);
		if(gettime() > (var_6d621232 + (cooldown * 1000)))
		{
			if(!isdefined(self.usingvehicle) || (isdefined(self.usingvehicle) && self.usingvehicle != 1))
			{
				playfxontag(fx, self, "tag_origin");
				self playsound("gdt_cybercore_rig_repulse_jawawawa");
				self thread _repulsethreat(missile, self.origin + vectorscale((0, 0, 1), 72));
				var_6d621232 = gettime();
			}
		}
	}
}

/*
	Name: function_170e07a2
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0x8BFE5DA9
	Offset: 0x900
	Size: 0x280
	Parameters: 0
	Flags: Linked, Private
*/
function private function_170e07a2()
{
	self endon(#"repulsorarmorshieldtake");
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		curtime = gettime();
		var_f9459f98 = undefined;
		var_2f0e78d0 = 0;
		for(zone = 0; zone < 4; zone++)
		{
			if(self.cybercom.var_c281e3c[zone].time > curtime)
			{
				threat = self.cybercom.var_c281e3c[zone].threat;
				if(isdefined(threat))
				{
					self.cybercom.var_c281e3c[zone].yaw = self cybercom::getyawtospot(threat.origin);
				}
				if(self.cybercom.var_c281e3c[zone].time > var_2f0e78d0)
				{
					var_2f0e78d0 = self.cybercom.var_c281e3c[zone].time;
					var_f9459f98 = zone;
				}
				continue;
			}
			if(self.cybercom.var_c281e3c[zone].time != 0)
			{
				self.cybercom.var_c281e3c[zone].time = 0;
				self.cybercom.var_c281e3c[zone].threat = undefined;
				self.cybercom.var_c281e3c[zone].yaw = undefined;
			}
		}
		if(isdefined(var_f9459f98))
		{
			self clientfield::set_player_uimodel("playerAbilities.repulsorIndicatorIntensity", 1);
			self clientfield::set_player_uimodel("playerAbilities.repulsorIndicatorDirection", var_f9459f98);
		}
		else
		{
			self clientfield::set_player_uimodel("playerAbilities.repulsorIndicatorIntensity", 0);
		}
		wait(0.05);
	}
}

/*
	Name: function_1542f1f0
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0x6F9CF3BE
	Offset: 0xB88
	Size: 0x19C
	Parameters: 1
	Flags: Linked
*/
function function_1542f1f0(threat)
{
	threat = (isdefined(threat.owner) ? threat.owner : threat);
	yaw = self cybercom::getyawtospot(threat.origin);
	if(yaw > -45 && yaw <= 45)
	{
		zone = 0;
	}
	else
	{
		if(yaw > 45 && yaw <= 135)
		{
			zone = 3;
		}
		else
		{
			if(yaw > 135 && yaw <= 180 || (yaw >= -180 && yaw < -135))
			{
				zone = 2;
			}
			else
			{
				zone = 1;
			}
		}
	}
	self.cybercom.var_c281e3c[zone].time = gettime() + getdvarint("scr_repulsorarmor_indicator_durationMSEC", 1500);
	self.cybercom.var_c281e3c[zone].threat = threat;
	self.cybercom.var_c281e3c[zone].yaw = yaw;
}

/*
	Name: _repulsethreat
	Namespace: cybercom_tacrig_respulsorarmor
	Checksum: 0x7C2E6EFF
	Offset: 0xD30
	Size: 0x84
	Parameters: 2
	Flags: Linked, Private
*/
function private _repulsethreat(grenade, trophyorigin)
{
	if(isdefined(grenade))
	{
		self thread function_1542f1f0(grenade);
		grenade playsound("gdt_cybercore_rig_repulse_jawawawa_missile");
		playfx(level._effect["repulsorarmor_contact"], grenade.origin);
	}
}

