// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\postfx_shared;

#using_animtree("generic");

#namespace _zm_ai_thrasher;

/*
	Name: main
	Namespace: _zm_ai_thrasher
	Checksum: 0x26529667
	Offset: 0x210
	Size: 0x4C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "thrasher_mouth_cf", 9000, 8, "int", &thrasherclientutils::function_dc24e0f3, 0, 0);
}

#namespace thrasherclientutils;

/*
	Name: function_43bf0af5
	Namespace: thrasherclientutils
	Checksum: 0x2D446B35
	Offset: 0x268
	Size: 0x74
	Parameters: 3
	Flags: Linked
*/
function function_43bf0af5(entity, player, state)
{
	entitynumber = player getentitynumber();
	var_a2619f0 = 3 << (entitynumber * 2);
	return (state & var_a2619f0) >> (entitynumber * 2);
}

/*
	Name: function_dc24e0f3
	Namespace: thrasherclientutils
	Checksum: 0x8D88A21E
	Offset: 0x2E8
	Size: 0x28E
	Parameters: 7
	Flags: Linked, Private
*/
function private function_dc24e0f3(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	localplayer = getlocalplayer(localclientnum);
	var_a1af5dd8 = localplayer getlocalclientnumber();
	oldstate = function_43bf0af5(entity, localplayer, oldvalue);
	state = function_43bf0af5(entity, localplayer, newvalue);
	if(oldstate == state && localclientnum === var_a1af5dd8)
	{
		return;
	}
	if(localclientnum !== var_a1af5dd8)
	{
		entity thread function_93c1c40c(localclientnum, entity, localplayer);
		return;
	}
	if(isdefined(entity.var_9ed023df) && entity.var_9ed023df)
	{
		return;
	}
	if(!isdefined(entity.var_18fd72ff) && state != 0)
	{
		entity thread function_4cf5760d(localclientnum, entity, localplayer);
		entity thread function_785afcbe(localclientnum, entity, localplayer);
	}
	switch(state)
	{
		case 0:
		{
			entity thread function_93c1c40c(localclientnum, entity, localplayer);
			break;
		}
		case 1:
		{
			entity thread function_51fb721f(localclientnum, entity, localplayer);
			break;
		}
		case 2:
		{
			entity thread function_98817801(localclientnum, entity, localplayer);
			break;
		}
		case 3:
		{
			entity thread function_48032157(localclientnum, entity, localplayer);
			break;
		}
	}
}

/*
	Name: function_51fb721f
	Namespace: thrasherclientutils
	Checksum: 0xB3DB556E
	Offset: 0x580
	Size: 0xBC
	Parameters: 3
	Flags: Linked, Private
*/
function private function_51fb721f(localclientnum, thrasher, player)
{
	if(isdefined(thrasher) && isdefined(thrasher.var_18fd72ff))
	{
		thrasher.var_18fd72ff clearanim("p7_fxanim_zm_island_thrasher_stomach_close_anim", 0.2);
		thrasher.var_18fd72ff clearanim("p7_fxanim_zm_island_thrasher_stomach_open_anim", 0.2);
		thrasher.var_18fd72ff setanimrestart("p7_fxanim_zm_island_thrasher_stomach_idle_anim");
	}
}

/*
	Name: function_48032157
	Namespace: thrasherclientutils
	Checksum: 0xEC0791A0
	Offset: 0x648
	Size: 0x104
	Parameters: 3
	Flags: Linked, Private
*/
function private function_48032157(localclientnum, thrasher, player)
{
	if(isdefined(thrasher) && isdefined(thrasher.var_18fd72ff))
	{
		thrasher.var_18fd72ff clearanim("p7_fxanim_zm_island_thrasher_stomach_idle_anim", 0.2);
		thrasher.var_18fd72ff clearanim("p7_fxanim_zm_island_thrasher_stomach_open_anim", 0.2);
		thrasher.var_18fd72ff setanimrestart("p7_fxanim_zm_island_thrasher_stomach_close_anim");
		player thread lui::screen_fade(1.5, 0.3, 0);
		player thread postfx::playpostfxbundle("pstfx_thrasher_stomach");
	}
}

/*
	Name: function_98817801
	Namespace: thrasherclientutils
	Checksum: 0x1E38FBD1
	Offset: 0x758
	Size: 0x13C
	Parameters: 3
	Flags: Linked, Private
*/
function private function_98817801(localclientnum, thrasher, player)
{
	if(isdefined(thrasher) && isdefined(thrasher.var_18fd72ff))
	{
		thrasher.var_18fd72ff clearanim("p7_fxanim_zm_island_thrasher_stomach_idle_anim", 0.2);
		thrasher.var_18fd72ff clearanim("p7_fxanim_zm_island_thrasher_stomach_close_anim", 0.2);
		thrasher.var_18fd72ff setanimrestart("p7_fxanim_zm_island_thrasher_stomach_open_anim");
		player thread lui::screen_fade_in(2);
		player thread postfx::playpostfxbundle("pstfx_thrasher_stomach");
		animtime = getanimlength("p7_fxanim_zm_island_thrasher_stomach_open_anim");
		wait(animtime);
		function_51fb721f(localclientnum, thrasher, player);
	}
}

/*
	Name: function_4cf5760d
	Namespace: thrasherclientutils
	Checksum: 0x13642A57
	Offset: 0x8A0
	Size: 0x41C
	Parameters: 3
	Flags: Linked, Private
*/
function private function_4cf5760d(localclientnum, thrasher, player)
{
	thrasher endon(#"entityshutdown");
	player endon(#"entityshutdown");
	player endon(#"hash_d53b1d6d");
	thrasher endon(#"hash_d53b1d6d");
	eyeposition = player gettagorigin("tag_eye");
	eyeoffset = (0, 0, (abs((abs(eyeposition[2] - player.origin[2])) - 40)) - 10);
	thrasher.var_18fd72ff = spawn(localclientnum, thrasher.origin, "script_model");
	thrasher.var_18fd72ff setmodel("p7_fxanim_zm_island_thrasher_stomach_mod");
	thrasher.var_18fd72ff useanimtree($generic);
	var_8cfe2065 = 5;
	forwardoffset = anglestoforward(thrasher.var_18fd72ff.angles) * var_8cfe2065;
	thrasher.var_18fd72ff.origin = getcamposbylocalclientnum(player.localclientnum) - forwardoffset;
	lastposition = thrasher.var_18fd72ff.origin;
	var_2f57a8ba = (0, 0, 0);
	interpolate = 0.01;
	var_7b5d5a9 = 2;
	var_11a41486 = 0.1;
	var_3c524399 = var_7b5d5a9 * var_7b5d5a9;
	var_dadc8424 = var_11a41486 * var_11a41486;
	while(true)
	{
		forwardoffset = anglestoforward(thrasher.var_18fd72ff.angles) * var_8cfe2065;
		desiredposition = (thrasher gettagorigin("tag_camera_thrasher") + eyeoffset) - forwardoffset;
		var_bef3bf12 = getcamposbylocalclientnum(player.localclientnum) - forwardoffset;
		var_622b2c1a = desiredposition - var_bef3bf12;
		if(lengthsquared(var_622b2c1a) > var_3c524399)
		{
			var_622b2c1a = vectornormalize(var_622b2c1a) * var_7b5d5a9;
		}
		desiredposition = var_bef3bf12 + var_622b2c1a;
		var_e8cd6d4 = var_622b2c1a - var_2f57a8ba;
		if(lengthsquared(var_e8cd6d4) > var_dadc8424)
		{
			var_622b2c1a = var_2f57a8ba + (vectornormalize(var_e8cd6d4) * var_11a41486);
		}
		thrasher.var_18fd72ff.origin = var_bef3bf12 + var_622b2c1a;
		var_2f57a8ba = var_622b2c1a;
		wait(interpolate);
	}
}

/*
	Name: function_785afcbe
	Namespace: thrasherclientutils
	Checksum: 0x58804144
	Offset: 0xCC8
	Size: 0x25E
	Parameters: 3
	Flags: Linked, Private
*/
function private function_785afcbe(localclientnum, thrasher, player)
{
	thrasher endon(#"entityshutdown");
	player endon(#"entityshutdown");
	player endon(#"hash_d53b1d6d");
	thrasher endon(#"hash_d53b1d6d");
	interpolate = 0.016;
	var_e494fe3c = angleclamp180(getcamanglesbylocalclientnum(player.localclientnum)[1]);
	thrasher.var_18fd72ff.angles = (0, var_e494fe3c, 0);
	maxyawdelta = 0.01;
	var_c0756dfb = 2;
	lasttime = player getclienttime() / 1000;
	wait(interpolate);
	while(isdefined(thrasher.var_18fd72ff))
	{
		currenttime = player getclienttime() / 1000;
		timedelta = currenttime - lasttime;
		var_50a8bb46 = thrasher.var_18fd72ff.angles[1];
		newyaw = getcamanglesbylocalclientnum(player.localclientnum)[1];
		while(timedelta > interpolate)
		{
			var_50a8bb46 = angleclamp180(anglelerp(var_50a8bb46, newyaw, 0.15));
			timedelta = timedelta - interpolate;
		}
		thrasher.var_18fd72ff.angles = (0, var_50a8bb46, 0);
		lasttime = currenttime - timedelta;
		wait(interpolate);
	}
}

/*
	Name: function_93c1c40c
	Namespace: thrasherclientutils
	Checksum: 0x277F2777
	Offset: 0xF30
	Size: 0xCA
	Parameters: 3
	Flags: Linked, Private
*/
function private function_93c1c40c(localclientnum, thrasher, player)
{
	if(isdefined(thrasher))
	{
		thrasher notify(#"hash_d53b1d6d");
		thrasher.var_9ed023df = 1;
	}
	if(isdefined(player))
	{
		player notify(#"hash_d53b1d6d");
	}
	if(isdefined(player))
	{
		player thread lui::screen_fade_in(2);
	}
	if(isdefined(thrasher) && isdefined(thrasher.var_18fd72ff))
	{
		thrasher.var_18fd72ff delete();
		thrasher.var_18fd72ff = undefined;
	}
}

