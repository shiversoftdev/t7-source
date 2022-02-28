// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_explode;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace gravity_spikes;

/*
	Name: __init__sytem__
	Namespace: gravity_spikes
	Checksum: 0xA96DA39A
	Offset: 0x218
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gravity_spikes", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: gravity_spikes
	Checksum: 0x32F41FA7
	Offset: 0x258
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["gravity_spike_dust"] = "weapon/fx_hero_grvity_spk_grnd_hit_dust";
	level.gravity_spike_table = "surface_explosion_gravityspikes";
	level thread watchforgravityspikeexplosion();
	level.dirt_enable_gravity_spikes = getdvarint("scr_dirt_enable_gravity_spikes", 0);
	/#
		level thread updatedvars();
	#/
}

/*
	Name: updatedvars
	Namespace: gravity_spikes
	Checksum: 0xE49C692F
	Offset: 0x2E0
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function updatedvars()
{
	/#
		while(true)
		{
			level.dirt_enable_gravity_spikes = getdvarint("", level.dirt_enable_gravity_spikes);
			wait(1);
		}
	#/
}

/*
	Name: watchforgravityspikeexplosion
	Namespace: gravity_spikes
	Checksum: 0x15CE607B
	Offset: 0x330
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function watchforgravityspikeexplosion()
{
	if(getactivelocalclients() > 1)
	{
		return;
	}
	weapon_proximity = getweapon("hero_gravityspikes");
	while(true)
	{
		level waittill(#"explode", localclientnum, position, mod, weapon, owner_cent);
		if(weapon.rootweapon != weapon_proximity)
		{
			continue;
		}
		if(isdefined(owner_cent) && getlocalplayer(localclientnum) == owner_cent && level.dirt_enable_gravity_spikes)
		{
			owner_cent thread explode::dothedirty(localclientnum, 0, 1, 0, 1000, 500);
		}
		thread do_gravity_spike_fx(localclientnum, owner_cent, weapon, position);
		thread audio::dorattle(position, 200, 700);
	}
}

/*
	Name: do_gravity_spike_fx
	Namespace: gravity_spikes
	Checksum: 0xAD2DA60E
	Offset: 0x488
	Size: 0x136
	Parameters: 4
	Flags: Linked
*/
function do_gravity_spike_fx(localclientnum, owner, weapon, position)
{
	radius_of_effect = 40;
	number_of_circles = 3;
	base_number_of_effects = 3;
	additional_number_of_effects_per_circle = 7;
	explosion_radius = weapon.explosionradius;
	radius_per_circle = (explosion_radius - radius_of_effect) / number_of_circles;
	for(circle = 0; circle < number_of_circles; circle++)
	{
		wait(0.1);
		radius_for_this_circle = radius_per_circle * (circle + 1);
		number_for_this_circle = base_number_of_effects + (additional_number_of_effects_per_circle * circle);
		thread do_gravity_spike_fx_circle(localclientnum, owner, position, radius_for_this_circle, number_for_this_circle);
	}
}

/*
	Name: getideallocationforfx
	Namespace: gravity_spikes
	Checksum: 0xA44848DA
	Offset: 0x5C8
	Size: 0xB6
	Parameters: 5
	Flags: Linked
*/
function getideallocationforfx(startpos, fxindex, fxcount, defaultdistance, rotation)
{
	currentangle = (360 / fxcount) * fxindex;
	coscurrent = cos(currentangle + rotation);
	sincurrent = sin(currentangle + rotation);
	return startpos + (defaultdistance * coscurrent, defaultdistance * sincurrent, 0);
}

/*
	Name: randomizelocation
	Namespace: gravity_spikes
	Checksum: 0x8D1F62E
	Offset: 0x688
	Size: 0xE2
	Parameters: 3
	Flags: Linked
*/
function randomizelocation(startpos, max_x_offset, max_y_offset)
{
	half_x = int(max_x_offset / 2);
	half_y = int(max_y_offset / 2);
	rand_x = randomintrange(half_x * -1, half_x);
	rand_y = randomintrange(half_y * -1, half_y);
	return startpos + (rand_x, rand_y, 0);
}

/*
	Name: ground_trace
	Namespace: gravity_spikes
	Checksum: 0xD67A59CC
	Offset: 0x778
	Size: 0x72
	Parameters: 2
	Flags: Linked
*/
function ground_trace(startpos, owner)
{
	trace_height = 50;
	trace_depth = 100;
	return bullettrace(startpos + (0, 0, trace_height), startpos - (0, 0, trace_depth), 0, owner);
}

/*
	Name: do_gravity_spike_fx_circle
	Namespace: gravity_spikes
	Checksum: 0x3A90E4E5
	Offset: 0x7F8
	Size: 0x24E
	Parameters: 5
	Flags: Linked
*/
function do_gravity_spike_fx_circle(localclientnum, owner, center, radius, count)
{
	segment = 360 / count;
	up = (0, 0, 1);
	randomization = 40;
	sphere_size = 5;
	for(i = 0; i < count; i++)
	{
		fx_position = getideallocationforfx(center, i, count, radius, 0);
		/#
		#/
		fx_position = randomizelocation(fx_position, randomization, randomization);
		trace = ground_trace(fx_position, owner);
		if(trace["fraction"] < 1)
		{
			/#
			#/
			fx = getfxfromsurfacetable(level.gravity_spike_table, trace["surfacetype"]);
			if(isdefined(fx))
			{
				angles = (0, randomintrange(0, 359), 0);
				forward = anglestoforward(angles);
				normal = trace["normal"];
				if(lengthsquared(normal) == 0)
				{
					normal = (1, 0, 0);
				}
				playfx(localclientnum, fx, trace["position"], normal, forward);
			}
		}
		else
		{
			/#
			#/
		}
		wait(0.016);
	}
}

