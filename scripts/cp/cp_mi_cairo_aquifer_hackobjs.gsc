// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_hacking;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\shared\flag_shared;

#namespace cp_mi_cairo_aquifer_hackobjs;

/*
	Name: main
	Namespace: cp_mi_cairo_aquifer_hackobjs
	Checksum: 0x30C5E008
	Offset: 0x210
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function main()
{
	init_skiptos();
}

/*
	Name: init_skiptos
	Namespace: cp_mi_cairo_aquifer_hackobjs
	Checksum: 0x99EC1590
	Offset: 0x230
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function init_skiptos()
{
}

/*
	Name: skipto_attack_tanks
	Namespace: cp_mi_cairo_aquifer_hackobjs
	Checksum: 0x1CE65449
	Offset: 0x240
	Size: 0xF4
	Parameters: 2
	Flags: None
*/
function skipto_attack_tanks(a, b)
{
	tank_obj = getent("tank_obj_target", "targetname");
	level.tank_targ = spawnstruct();
	level.tank_targ.origin = tank_obj.origin;
	objectives::set("obj_attack_tanks", level.tank_targ);
	iprintln("waiting placeholder for attack tanks");
	wait(5);
	objectives::complete("obj_attack_tanks", level.tank_targ);
	skipto::objective_completed(a);
}

/*
	Name: skipto_hack_1
	Namespace: cp_mi_cairo_aquifer_hackobjs
	Checksum: 0x4A49A2DB
	Offset: 0x340
	Size: 0xF4
	Parameters: 2
	Flags: None
*/
function skipto_hack_1(a, b)
{
	hack_trig_1 = getent("exterior_hack_trig_1", "targetname");
	level.hack_trig1 = struct::get(hack_trig_1.target, "targetname");
	objectives::set("cp_mi_cairo_aquifer_hack_obj1", level.hack_trig1);
	hack_trig_1 hacking::init_hack_trigger(1);
	hack_trig_1 hacking::trigger_wait();
	objectives::complete("cp_mi_cairo_aquifer_hack_obj1", level.hack_trig1);
	skipto::objective_completed(a);
}

/*
	Name: skipto_hack_2
	Namespace: cp_mi_cairo_aquifer_hackobjs
	Checksum: 0x8CE95AD1
	Offset: 0x440
	Size: 0xF4
	Parameters: 2
	Flags: None
*/
function skipto_hack_2(a, b)
{
	hack_trig_2 = getent("exterior_hack_trig_2", "targetname");
	level.hack_trig2 = struct::get(hack_trig_2.target, "targetname");
	objectives::set("cp_mi_cairo_aquifer_hack_obj2", level.hack_trig2);
	hack_trig_2 hacking::init_hack_trigger(1);
	hack_trig_2 hacking::trigger_wait();
	objectives::complete("cp_mi_cairo_aquifer_hack_obj2", level.hack_trig2);
	skipto::objective_completed(a);
}

/*
	Name: skipto_hack_3
	Namespace: cp_mi_cairo_aquifer_hackobjs
	Checksum: 0xADC1679A
	Offset: 0x540
	Size: 0x104
	Parameters: 2
	Flags: None
*/
function skipto_hack_3(a, b)
{
	hack_trig_3 = getent("exterior_hack_trig_3", "targetname");
	level.hack_trig3 = spawnstruct();
	level.hack_trig3.origin = hack_trig_3.origin;
	objectives::set("cp_mi_cairo_aquifer_hack_obj3", level.hack_trig3);
	hack_trig_3 hacking::init_hack_trigger(5);
	hack_trig_3 hacking::trigger_wait();
	objectives::complete("cp_mi_cairo_aquifer_hack_obj3", level.hack_trig3);
	skipto::objective_completed(a);
}

/*
	Name: done
	Namespace: cp_mi_cairo_aquifer_hackobjs
	Checksum: 0xA23E278A
	Offset: 0x650
	Size: 0x4C
	Parameters: 4
	Flags: None
*/
function done(a, b, c, d)
{
	iprintln(("######## " + a) + " is completed ########");
}

