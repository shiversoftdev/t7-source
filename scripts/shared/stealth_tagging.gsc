// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_oed;
#using scripts\shared\clientfield_shared;
#using scripts\shared\stealth;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace stealth_tagging;

/*
	Name: init
	Namespace: stealth_tagging
	Checksum: 0x99EC1590
	Offset: 0x148
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: enabled
	Namespace: stealth_tagging
	Checksum: 0xCE06E423
	Offset: 0x158
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function enabled()
{
	return isdefined(self.stealth) && isdefined(self.stealth.tagging);
}

/*
	Name: get_tagged
	Namespace: stealth_tagging
	Checksum: 0xE5F3D06A
	Offset: 0x180
	Size: 0x56
	Parameters: 0
	Flags: None
*/
function get_tagged()
{
	return isdefined(self.stealth) && isdefined(self.stealth.tagging) && (isdefined(self.stealth.tagging.tagged) && self.stealth.tagging.tagged);
}

/*
	Name: tagging_thread
	Namespace: stealth_tagging
	Checksum: 0x93D85160
	Offset: 0x1E0
	Size: 0x580
	Parameters: 0
	Flags: None
*/
function tagging_thread()
{
	/#
		assert(isplayer(self));
	#/
	/#
		assert(self enabled());
	#/
	self endon(#"disconnect");
	timeinc = 0.25;
	wait(randomfloatrange(0.05, 1));
	while(true)
	{
		if(self playerads() > 0.3)
		{
			vec_eye_dir = anglestoforward(self getplayerangles());
			vec_eye_pos = self getplayercamerapos();
			rangesq = self.stealth.tagging.range * self.stealth.tagging.range;
			trace = bullettrace(vec_eye_pos, vec_eye_pos + (vec_eye_dir * 32000), 1, self);
			foreach(enemy in level.stealth.enemies[self.team])
			{
				if(!isdefined(enemy) || !isalive(enemy))
				{
					continue;
				}
				if(!enemy enabled() || (isdefined(enemy.stealth.tagging.tagged) && enemy.stealth.tagging.tagged))
				{
					continue;
				}
				if(!isactor(enemy))
				{
					continue;
				}
				enemyentnum = enemy getentitynumber();
				bdirectaiming = isdefined(trace["entity"]) && trace["entity"] == enemy;
				bbroadaiming = 0;
				if(!bdirectaiming)
				{
					distsq = distancesquared(enemy.origin, vec_eye_pos);
					vec_enemy_dir = vectornormalize((enemy.origin + vectorscale((0, 0, 1), 30)) - vec_eye_pos);
					if(distsq < rangesq && vectordot(vec_enemy_dir, vec_eye_dir) > self.stealth.tagging.tag_fovcos)
					{
						bbroadaiming = self tagging_sight_trace(vec_eye_pos, enemy);
					}
				}
				if(bdirectaiming || bbroadaiming)
				{
					if(!isdefined(self.stealth.tagging.tag_times[enemyentnum]))
					{
						self.stealth.tagging.tag_times[enemyentnum] = 0;
					}
					self.stealth.tagging.tag_times[enemyentnum] = self.stealth.tagging.tag_times[enemyentnum] + ((1 / self.stealth.tagging.tag_time) * timeinc);
					if(self.stealth.tagging.tag_times[enemyentnum] >= 1)
					{
						if(isplayer(self))
						{
							self playsoundtoplayer("uin_gadget_fully_charged", self);
						}
						enemy thread tagging_set_tagged(1);
					}
					continue;
				}
				if(isdefined(self.stealth.tagging.tag_times[enemyentnum]))
				{
					self.stealth.tagging.tag_times[enemyentnum] = undefined;
				}
			}
		}
		wait(timeinc);
	}
}

/*
	Name: tagging_set_tagged
	Namespace: stealth_tagging
	Checksum: 0xDF939E08
	Offset: 0x768
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function tagging_set_tagged(tagged)
{
	if(isalive(self))
	{
		self oed::set_force_tmode(tagged);
		if(isdefined(self.stealth) && isdefined(self.stealth.tagging))
		{
			if(!tagged)
			{
				self.stealth.tagging.tagged = undefined;
			}
			else
			{
				self.stealth.tagging.tagged = tagged;
			}
		}
		self clientfield::set("tagged", tagged);
	}
}

/*
	Name: tagging_sight_trace
	Namespace: stealth_tagging
	Checksum: 0xD87D8997
	Offset: 0x830
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function tagging_sight_trace(vec_eye_pos, enemy)
{
	result = 0;
	if(isactor(enemy))
	{
		if(!result && sighttracepassed(vec_eye_pos, enemy gettagorigin("j_head"), 0, self))
		{
			result = 1;
		}
		if(!result && sighttracepassed(vec_eye_pos, enemy gettagorigin("j_spinelower"), 0, self))
		{
			result = 1;
		}
	}
	if(!result && sighttracepassed(vec_eye_pos, enemy.origin, 0, self))
	{
		result = 1;
	}
	return result;
}

