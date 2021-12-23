// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;

#namespace blackboard;

/*
	Name: registervehicleblackboardattributes
	Namespace: blackboard
	Checksum: 0x50764AF7
	Offset: 0x108
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function registervehicleblackboardattributes()
{
	/#
		assert(isvehicle(self), "");
	#/
	registerblackboardattribute(self, "_speed", undefined, &bb_getspeed);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	registerblackboardattribute(self, "_enemy_yaw", undefined, &bb_vehgetenemyyaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
}

/*
	Name: bb_getspeed
	Namespace: blackboard
	Checksum: 0xC5014C38
	Offset: 0x208
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function bb_getspeed()
{
	velocity = self getvelocity();
	return length(velocity);
}

/*
	Name: bb_vehgetenemyyaw
	Namespace: blackboard
	Checksum: 0x6ADACB43
	Offset: 0x250
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function bb_vehgetenemyyaw()
{
	enemy = self.enemy;
	if(!isdefined(enemy))
	{
		return 0;
	}
	toenemyyaw = vehgetpredictedyawtoenemy(self, 0.2);
	return toenemyyaw;
}

/*
	Name: vehgetpredictedyawtoenemy
	Namespace: blackboard
	Checksum: 0x935ED51A
	Offset: 0x2B0
	Size: 0x190
	Parameters: 2
	Flags: Linked
*/
function vehgetpredictedyawtoenemy(entity, lookaheadtime)
{
	if(isdefined(entity.predictedyawtoenemy) && isdefined(entity.predictedyawtoenemytime) && entity.predictedyawtoenemytime == gettime())
	{
		return entity.predictedyawtoenemy;
	}
	selfpredictedpos = entity.origin;
	moveangle = entity.angles[1] + entity getmotionangle();
	selfpredictedpos = selfpredictedpos + (((cos(moveangle), sin(moveangle), 0) * 200) * lookaheadtime);
	yaw = (vectortoangles(entity.enemy.origin - selfpredictedpos)[1]) - entity.angles[1];
	yaw = absangleclamp360(yaw);
	entity.predictedyawtoenemy = yaw;
	entity.predictedyawtoenemytime = gettime();
	return yaw;
}

