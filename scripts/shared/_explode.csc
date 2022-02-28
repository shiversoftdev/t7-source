// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace explode;

/*
	Name: __init__sytem__
	Namespace: explode
	Checksum: 0x8D9235A8
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("explode", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: explode
	Checksum: 0x5B05BE23
	Offset: 0x1D8
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.dirt_enable_explosion = getdvarint("scr_dirt_enable_explosion", 1);
	level.dirt_enable_slide = getdvarint("scr_dirt_enable_slide", 1);
	level.dirt_enable_fall_damage = getdvarint("scr_dirt_enable_fall_damage", 1);
	callback::on_localplayer_spawned(&localplayer_spawned);
	/#
		level thread updatedvars();
	#/
}

/*
	Name: updatedvars
	Namespace: explode
	Checksum: 0xE604F422
	Offset: 0x298
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function updatedvars()
{
	/#
		while(true)
		{
			level.dirt_enable_explosion = getdvarint("", level.dirt_enable_explosion);
			level.dirt_enable_slide = getdvarint("", level.dirt_enable_slide);
			level.dirt_enable_fall_damage = getdvarint("", level.dirt_enable_fall_damage);
			wait(1);
		}
	#/
}

/*
	Name: localplayer_spawned
	Namespace: explode
	Checksum: 0x9E3309C9
	Offset: 0x338
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function localplayer_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	if(level.dirt_enable_explosion || level.dirt_enable_slide || level.dirt_enable_fall_damage)
	{
		filter::init_filter_sprite_dirt(self);
		filter::disable_filter_sprite_dirt(self, 5);
		if(level.dirt_enable_explosion)
		{
			self thread watchforexplosion(localclientnum);
		}
		if(level.dirt_enable_slide)
		{
			self thread watchforplayerslide(localclientnum);
		}
		if(level.dirt_enable_fall_damage)
		{
			self thread watchforplayerfalldamage(localclientnum);
		}
	}
}

/*
	Name: watchforplayerfalldamage
	Namespace: explode
	Checksum: 0xF7871B3F
	Offset: 0x420
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function watchforplayerfalldamage(localclientnum)
{
	self endon(#"entityshutdown");
	seed = 0;
	xdir = 0;
	ydir = 270;
	while(true)
	{
		self waittill(#"fall_damage");
		self thread dothedirty(localclientnum, xdir, ydir, 1, 1000, 500);
	}
}

/*
	Name: watchforplayerslide
	Namespace: explode
	Checksum: 0xF408B1CD
	Offset: 0x4C0
	Size: 0x1D0
	Parameters: 1
	Flags: Linked
*/
function watchforplayerslide(localclientnum)
{
	self endon(#"entityshutdown");
	seed = 0;
	self.wasplayersliding = 0;
	xdir = 0;
	ydir = 6000;
	while(true)
	{
		self.isplayersliding = self isplayersliding();
		if(self.isplayersliding)
		{
			if(!self.wasplayersliding)
			{
				self notify(#"endthedirty");
				seed = randomfloatrange(0, 1);
			}
			filter::set_filter_sprite_dirt_opacity(self, 5, 1);
			filter::set_filter_sprite_dirt_seed_offset(self, 5, seed);
			filter::enable_filter_sprite_dirt(self, 5);
			filter::set_filter_sprite_dirt_source_position(self, 5, xdir, ydir, 1);
			filter::set_filter_sprite_dirt_elapsed(self, 5, getservertime(localclientnum));
		}
		else if(self.wasplayersliding)
		{
			self thread dothedirty(localclientnum, xdir, ydir, 1, 300, 300);
		}
		self.wasplayersliding = self.isplayersliding;
		wait(0.016);
	}
}

/*
	Name: dothedirty
	Namespace: explode
	Checksum: 0xF110AAE7
	Offset: 0x698
	Size: 0x204
	Parameters: 6
	Flags: Linked
*/
function dothedirty(localclientnum, right, up, distance, dirtduration, dirtfadetime)
{
	self endon(#"entityshutdown");
	self notify(#"dothedirty");
	self endon(#"dothedirty");
	self endon(#"endthedirty");
	filter::enable_filter_sprite_dirt(self, 5);
	filter::set_filter_sprite_dirt_seed_offset(self, 5, randomfloatrange(0, 1));
	starttime = getservertime(localclientnum);
	currenttime = starttime;
	elapsedtime = 0;
	while(elapsedtime < dirtduration)
	{
		if(elapsedtime > (dirtduration - dirtfadetime))
		{
			filter::set_filter_sprite_dirt_opacity(self, 5, (dirtduration - elapsedtime) / dirtfadetime);
		}
		else
		{
			filter::set_filter_sprite_dirt_opacity(self, 5, 1);
		}
		filter::set_filter_sprite_dirt_source_position(self, 5, right, up, distance);
		filter::set_filter_sprite_dirt_elapsed(self, 5, currenttime);
		wait(0.016);
		currenttime = getservertime(localclientnum);
		elapsedtime = currenttime - starttime;
	}
	filter::disable_filter_sprite_dirt(self, 5);
}

/*
	Name: watchforexplosion
	Namespace: explode
	Checksum: 0xB6F42E6E
	Offset: 0x8A8
	Size: 0x3A8
	Parameters: 1
	Flags: Linked
*/
function watchforexplosion(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		level waittill(#"explode", localclientnum, position, mod, weapon, owner_cent);
		explosiondistance = distance(self.origin, position);
		if(mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE_SPLASH" && explosiondistance < 600 && !getinkillcam(localclientnum) && !isthirdperson(localclientnum))
		{
			cameraangles = self getcamangles();
			if(!isdefined(cameraangles))
			{
				continue;
			}
			forwardvec = vectornormalize(anglestoforward(cameraangles));
			upvec = vectornormalize(anglestoup(cameraangles));
			rightvec = vectornormalize(anglestoright(cameraangles));
			explosionvec = vectornormalize(position - self getcampos());
			if(vectordot(forwardvec, explosionvec) > 0)
			{
				trace = bullettrace(getlocalclienteyepos(localclientnum), position, 0, self);
				if(trace["fraction"] >= 0.9)
				{
					udot = -1 * vectordot(explosionvec, upvec);
					rdot = vectordot(explosionvec, rightvec);
					udotabs = abs(udot);
					rdotabs = abs(rdot);
					if(udotabs > rdotabs)
					{
						if(udot > 0)
						{
							udot = 1;
						}
						else
						{
							udot = -1;
						}
					}
					else
					{
						if(rdot > 0)
						{
							rdot = 1;
						}
						else
						{
							rdot = -1;
						}
					}
					self thread dothedirty(localclientnum, rdot, udot, 1 - (explosiondistance / 600), 2000, 500);
				}
			}
		}
	}
}

