// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace serverfaceanim;

/*
	Name: __init__sytem__
	Namespace: serverfaceanim
	Checksum: 0xE6AB256C
	Offset: 0x180
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("serverfaceanim", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: serverfaceanim
	Checksum: 0x82F7FE
	Offset: 0x1C0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level._use_faceanim) && level._use_faceanim))
	{
		return;
	}
	callback::on_spawned(&init_serverfaceanim);
}

/*
	Name: init_serverfaceanim
	Namespace: serverfaceanim
	Checksum: 0xA6E06F9
	Offset: 0x208
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function init_serverfaceanim()
{
	self.do_face_anims = 1;
	if(!isdefined(level.face_event_handler))
	{
		level.face_event_handler = spawnstruct();
		level.face_event_handler.events = [];
		level.face_event_handler.events["death"] = "face_death";
		level.face_event_handler.events["grenade danger"] = "face_alert";
		level.face_event_handler.events["bulletwhizby"] = "face_alert";
		level.face_event_handler.events["projectile_impact"] = "face_alert";
		level.face_event_handler.events["explode"] = "face_alert";
		level.face_event_handler.events["alert"] = "face_alert";
		level.face_event_handler.events["shoot"] = "face_shoot_single";
		level.face_event_handler.events["melee"] = "face_melee";
		level.face_event_handler.events["damage"] = "face_pain";
		level thread wait_for_face_event();
	}
}

/*
	Name: wait_for_face_event
	Namespace: serverfaceanim
	Checksum: 0x43055E4F
	Offset: 0x3B0
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function wait_for_face_event()
{
	while(true)
	{
		level waittill(#"face", face_notify, ent);
		if(isdefined(ent) && isdefined(ent.do_face_anims) && ent.do_face_anims)
		{
			if(isdefined(level.face_event_handler.events[face_notify]))
			{
				ent sendfaceevent(level.face_event_handler.events[face_notify]);
			}
		}
	}
}

