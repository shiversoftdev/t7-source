// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;

#using_animtree("mp_vehicles");

#namespace ai_tank;

/*
	Name: __init__sytem__
	Namespace: ai_tank
	Checksum: 0x6B64A4B6
	Offset: 0x3A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ai_tank", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ai_tank
	Checksum: 0x9C33814E
	Offset: 0x3E8
	Size: 0x254
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	bundle = struct::get_script_bundle("killstreak", "killstreak_ai_tank_drop");
	level.aitankkillstreakbundle = bundle;
	level._ai_tank_fx = [];
	level._ai_tank_fx["light_green"] = "killstreaks/fx_agr_vlight_eye_grn";
	level._ai_tank_fx["light_red"] = "killstreaks/fx_agr_vlight_eye_red";
	level._ai_tank_fx["stun"] = "killstreaks/fx_agr_emp_stun";
	clientfield::register("vehicle", "ai_tank_death", 1, 1, "int", &death, 0, 0);
	clientfield::register("vehicle", "ai_tank_missile_fire", 1, 2, "int", &missile_fire, 0, 0);
	clientfield::register("vehicle", "ai_tank_stun", 1, 1, "int", &tank_stun, 0, 0);
	clientfield::register("toplayer", "ai_tank_update_hud", 1, 1, "counter", &update_hud, 0, 0);
	vehicle::add_vehicletype_callback("ai_tank_drone_mp", &spawned);
	vehicle::add_vehicletype_callback("spawner_bo3_ai_tank_mp", &spawned);
	vehicle::add_vehicletype_callback("spawner_bo3_ai_tank_mp_player", &spawned);
	visionset_mgr::register_visionset_info("agr_visionset", 1, 16, undefined, "mp_vehicles_agr");
}

/*
	Name: spawned
	Namespace: ai_tank
	Checksum: 0xBA08E0D0
	Offset: 0x648
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function spawned(localclientnum, killstreak_duration)
{
	self thread play_driving_rumble(localclientnum);
	self.killstreakbundle = level.aitankkillstreakbundle;
}

/*
	Name: missile_fire
	Namespace: ai_tank
	Checksum: 0xE91F8A15
	Offset: 0x690
	Size: 0x1EC
	Parameters: 7
	Flags: Linked
*/
function missile_fire(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(self hasanimtree() == 0)
	{
		self useanimtree($mp_vehicles);
	}
	missiles_loaded = newval;
	if(newval == 2)
	{
		self setanimrestart(%mp_vehicles::o_drone_tank_missile1_fire, 1, 0, 0.5);
	}
	else
	{
		if(newval == 1)
		{
			self setanimrestart(%mp_vehicles::o_drone_tank_missile2_fire, 1, 0, 0.5);
		}
		else
		{
			if(newval == 0)
			{
				self setanimrestart(%mp_vehicles::o_drone_tank_missile3_fire, 1, 0, 0.5);
			}
			else if(newval == 3)
			{
				self setanimrestart(%mp_vehicles::o_drone_tank_missile_full_reload, 1, 0, 1);
			}
		}
	}
	if(missiles_loaded <= 3)
	{
		update_ui_ammo_count(localclientnum, missiles_loaded);
	}
}

/*
	Name: update_hud
	Namespace: ai_tank
	Checksum: 0xA15FA138
	Offset: 0x888
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function update_hud(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"disconnect");
	wait(0.016);
	vehicle = getplayervehicle(self);
	if(isdefined(vehicle))
	{
		self update_ui_model_ammo_count(localclientnum, vehicle clientfield::get("ai_tank_missile_fire"));
	}
}

/*
	Name: update_ui_ammo_count
	Namespace: ai_tank
	Checksum: 0x397AE200
	Offset: 0x948
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function update_ui_ammo_count(localclientnum, missiles_loaded)
{
	if(self islocalclientdriver(localclientnum) || isspectating(localclientnum))
	{
		update_ui_model_ammo_count(localclientnum, missiles_loaded);
	}
}

/*
	Name: update_ui_model_ammo_count
	Namespace: ai_tank
	Checksum: 0x22122786
	Offset: 0x9B8
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function update_ui_model_ammo_count(localclientnum, missiles_loaded)
{
	ammo_ui_data_model = getuimodel(getuimodelforcontroller(localclientnum), "vehicle.ammo");
	if(isdefined(ammo_ui_data_model))
	{
		setuimodelvalue(ammo_ui_data_model, missiles_loaded);
	}
}

/*
	Name: tank_stun
	Namespace: ai_tank
	Checksum: 0xF8D81B4E
	Offset: 0xA38
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function tank_stun(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	if(newval)
	{
		self notify(#"light_disable");
		self stop_stun_fx(localclientnum);
		self start_stun_fx(localclientnum);
	}
	else
	{
		self stop_stun_fx(localclientnum);
	}
}

/*
	Name: death
	Namespace: ai_tank
	Checksum: 0x92CED6C2
	Offset: 0xAF8
	Size: 0xBA
	Parameters: 7
	Flags: Linked
*/
function death(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	if(!isdefined(player))
	{
		return;
	}
	if(player getinkillcam(localclientnum))
	{
		return;
	}
	if(newval)
	{
		self stop_stun_fx(localclientnum);
		self notify(#"light_disable");
	}
}

/*
	Name: start_stun_fx
	Namespace: ai_tank
	Checksum: 0xA6EFB21F
	Offset: 0xBC0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function start_stun_fx(localclientnum)
{
	self.stun_fx = playfxontag(localclientnum, level._ai_tank_fx["stun"], self, "tag_origin");
	playsound(localclientnum, "veh_talon_shutdown", self.origin);
}

/*
	Name: stop_stun_fx
	Namespace: ai_tank
	Checksum: 0x258E9B84
	Offset: 0xC38
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function stop_stun_fx(localclientnum)
{
	if(isdefined(self.stun_fx))
	{
		stopfx(localclientnum, self.stun_fx);
		self.stun_fx = undefined;
	}
}

/*
	Name: play_driving_rumble
	Namespace: ai_tank
	Checksum: 0x4F294358
	Offset: 0xC80
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function play_driving_rumble(localclientnum)
{
	self notify(#"driving_rumble");
	self endon(#"entityshutdown");
	self endon(#"death");
	self endon(#"driving_rumble");
	for(;;)
	{
		if(isinvehicle(localclientnum, self))
		{
			speed = self getspeed();
			if(speed >= 40 || speed <= -40)
			{
				player = getlocalplayer(localclientnum);
				if(isdefined(player))
				{
					player earthquake(0.1, 0.1, self.origin, 200);
				}
			}
		}
		util::server_wait(localclientnum, 0.05);
	}
}

