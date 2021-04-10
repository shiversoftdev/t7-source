// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\doa\_doa_arena;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace namespace_ad544aeb;

/*
	Name: function_d22ceb57
	Namespace: namespace_ad544aeb
	Checksum: 0xA988DA5D
	Offset: 0x118
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function function_d22ceb57(angles, min_dist, max_dist = 0)
{
	if(isdefined(angles))
	{
		vectornormalize(angles);
		level.doa.camera_angles = angles;
		level.var_eb70931a = anglestoforward(angles) * -1;
		level.var_7a2e3b7d = anglestoup(angles);
	}
	if(min_dist < 1)
	{
		min_dist = 1;
	}
	level.var_8e0085fe = min_dist;
	level.var_3e96d0bc = max_dist;
	if(!isdefined(level.var_a32fbbc0))
	{
		level.var_a32fbbc0 = level.doa.camera_angles;
	}
}

/*
	Name: function_44a2ae85
	Namespace: namespace_ad544aeb
	Checksum: 0xE78FD80
	Offset: 0x220
	Size: 0xCE
	Parameters: 2
	Flags: Linked
*/
function function_44a2ae85(vec, mins)
{
	if(vec[0] < mins[0])
	{
		mins = (vec[0], mins[1], mins[2]);
	}
	if(vec[1] < mins[1])
	{
		mins = (mins[0], vec[1], mins[2]);
	}
	if(vec[2] < mins[2])
	{
		mins = (mins[0], mins[1], vec[2]);
	}
	return mins;
}

/*
	Name: function_b72ba417
	Namespace: namespace_ad544aeb
	Checksum: 0x86F9A1C4
	Offset: 0x2F8
	Size: 0xCE
	Parameters: 2
	Flags: Linked
*/
function function_b72ba417(vec, maxs)
{
	if(vec[0] > maxs[0])
	{
		maxs = (vec[0], maxs[1], maxs[2]);
	}
	if(vec[1] > maxs[1])
	{
		maxs = (maxs[0], vec[1], maxs[2]);
	}
	if(vec[2] > maxs[2])
	{
		maxs = (maxs[0], maxs[1], vec[2]);
	}
	return maxs;
}

/*
	Name: function_d207ecc1
	Namespace: namespace_ad544aeb
	Checksum: 0x142BCAA0
	Offset: 0x3D0
	Size: 0x12DC
	Parameters: 2
	Flags: Linked
*/
function function_d207ecc1(localclientnum, delta_time)
{
	mins = vectorscale((1, 1, 1), 1000000);
	maxs = vectorscale((-1, -1, -1), 1000000);
	if(level.localplayers.size == 0)
	{
		var_44509e49 = 2;
	}
	else if(isdefined(level.localplayers[0]))
	{
		var_44509e49 = level.localplayers[0].var_44509e49;
	}
	if(level.localplayers.size > 0 && !isdefined(level.localplayers[0]))
	{
		return;
	}
	if(isdefined(level.var_b62087b0))
	{
		return;
	}
	if(level.localplayers.size >= 2)
	{
		if(!isdefined(level.var_3d977189))
		{
			setdvar("r_deadOpsActive", 1);
			setdvar("r_splitScreenExpandFull", 1);
			level.var_3d977189 = 1;
		}
	}
	if(!isdefined(var_44509e49))
	{
		var_44509e49 = 0;
	}
	if(level.localplayers.size > 1 && isdefined(level.var_81528e19))
	{
		var_44509e49 = level.var_81528e19;
	}
	players = [];
	angles = level.doa.camera_angles;
	if(var_44509e49 == 4)
	{
		var_44509e49 = 0;
	}
	if(level.localplayers.size && (isdefined(level.localplayers[0].var_bf81deea) && level.localplayers[0].var_bf81deea))
	{
		var_44509e49 = 0;
	}
	if(vrisactive())
	{
		var_44509e49 = 2;
	}
	if(var_44509e49 == 3)
	{
		players[0] = level.localplayers[0];
		var_d5cac046 = level.localplayers[0];
		parentent = getplayervehicle(var_d5cac046);
		if(!isdefined(parentent) || level.localplayers.size > 1)
		{
			var_44509e49 = 0;
		}
	}
	if(var_44509e49 == 0)
	{
		if(level.localplayers.size > 1)
		{
			players = level.localplayers;
		}
		else
		{
			players[0] = level.localplayers[0];
		}
	}
	if(var_44509e49 == 1)
	{
		players = getplayers(localclientnum);
		if(players.size == 0)
		{
			return;
		}
	}
	if(var_44509e49 == 2)
	{
		var_2fda52e5 = level.doa.arenas[level.doa.current_arena].center + level.doa.arenas[level.doa.current_arena].var_7526f3f5;
		if(vrisactive())
		{
			var_2fda52e5 = var_2fda52e5 - level.var_7a2e3b7d * 450;
			var_2fda52e5 = var_2fda52e5 + vectorscale((0, 0, -1), 500);
		}
		foreach(var_98786fb6, player in level.localplayers)
		{
			if(!isdefined(player))
			{
				continue;
			}
			player camerasetposition(var_2fda52e5);
		}
		if(isdefined(level.doa.arenas[level.doa.current_arena].var_790aac0e))
		{
			/#
				var_cf220b7b = level.doa.arenas[level.doa.current_arena].var_790aac0e[0] + level.var_83a34f19;
				var_a91f9112 = level.doa.arenas[level.doa.current_arena].var_790aac0e[1] + level.var_e9c73e06;
				var_831d16a9 = level.doa.arenas[level.doa.current_arena].var_790aac0e[2];
				level.doa.arenas[level.doa.current_arena].var_790aac0e = (var_cf220b7b, var_a91f9112, var_831d16a9);
			#/
			foreach(var_4adf7bba, player in level.localplayers)
			{
				if(!isdefined(player))
				{
					continue;
				}
				player camerasetlookat(level.doa.arenas[level.doa.current_arena].var_790aac0e);
			}
			level.var_a32fbbc0 = level.doa.arenas[level.doa.current_arena].var_790aac0e;
		}
		else
		{
			foreach(var_32d69962, player in level.localplayers)
			{
				if(!isdefined(player))
				{
					continue;
				}
				player camerasetlookat(level.doa.camera_angles);
			}
		}
		level.var_6383030e = var_2fda52e5;
		/#
			if(getdvarint("", 0))
			{
				println("" + int(level.doa.arenas[level.doa.current_arena].var_7526f3f5[0]) + "" + int(level.doa.arenas[level.doa.current_arena].var_7526f3f5[1]) + "" + int(level.doa.arenas[level.doa.current_arena].var_7526f3f5[2]) + "");
				println("" + level.var_a32fbbc0[0] + "" + level.var_a32fbbc0[1] + "" + level.var_a32fbbc0[2] + "");
			}
			level.var_83a34f19 = 0;
			level.var_e9c73e06 = 0;
		#/
		return;
	}
	var_f51225df = level.var_eb70931a;
	var_aa43a214 = level.var_7a2e3b7d;
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_f4f1abf3))
	{
		angles = level.doa.arenas[level.doa.current_arena].var_f4f1abf3;
		var_f51225df = anglestoforward(angles) * -1;
		var_aa43a214 = anglestoup(angles);
	}
	foreach(var_b545f8e9, player in players)
	{
		origin = player.origin;
		vehicle = getplayervehicle(player);
		if(isdefined(vehicle))
		{
			origin = vehicle.origin;
		}
		mins = function_44a2ae85(origin, mins);
		maxs = function_b72ba417(origin, maxs);
	}
	if(isarray(level.var_172ed9a1))
	{
		foreach(var_9d10a9f0, target in level.var_172ed9a1)
		{
			if(!isdefined(target))
			{
				continue;
			}
			mins = function_44a2ae85(target.origin, mins);
			maxs = function_b72ba417(target.origin, maxs);
		}
	}
	dims = maxs - mins;
	var_733be899 = mins + maxs * 0.5;
	arena_center = namespace_3ca3c537::function_61d60e0b();
	mins = function_44a2ae85(arena_center, mins);
	maxs = function_b72ba417(arena_center, maxs);
	center = mins + maxs;
	center = center * 0.5;
	cam_pos = center;
	if(players.size == 1)
	{
		var_4d44f2a6 = namespace_3ca3c537::function_be152c54();
		if(var_4d44f2a6 == 99)
		{
			cam_pos = (players[0].origin[0], players[0].origin[1], arena_center[2]);
		}
		else
		{
			dir_to_player = center - arena_center;
			cam_pos = arena_center + dir_to_player * var_4d44f2a6;
		}
	}
	if(level.localplayers.size > 1)
	{
		cam_pos = var_733be899;
		arena_center = var_733be899;
	}
	cam_pos = cam_pos + var_f51225df * level.var_8e0085fe;
	cam_pos = cam_pos + var_aa43a214 * -20;
	var_aee49bea = 200;
	var_e147176c = 1800;
	var_ecd4ec49 = 450;
	var_4544d2a1 = abs(dims[1]);
	var_c23fe37b = 0;
	if(var_4544d2a1 > var_aee49bea)
	{
		var_c23fe37b = var_4544d2a1 - var_aee49bea / var_e147176c - var_aee49bea;
	}
	var_de478449 = 50;
	var_967aec83 = 500;
	var_1f425838 = abs(dims[0]);
	var_9c3d6912 = 0;
	if(var_1f425838 > var_de478449)
	{
		var_9c3d6912 = var_1f425838 - var_de478449 / var_967aec83 - var_de478449;
		frac = math::clamp(var_9c3d6912, 0, 1);
		var_5296710e = arena_center[1];
		new_y = cam_pos[1] + var_5296710e - cam_pos[1] * frac;
		cam_pos = (cam_pos[0], new_y, cam_pos[2]);
	}
	t = var_c23fe37b;
	if(var_9c3d6912 > t)
	{
		t = var_9c3d6912;
	}
	var_d5d07072 = var_ecd4ec49;
	if(players.size > 1 && var_44509e49 == 1)
	{
		var_d69e684e = 200;
		if(!isdefined(level.var_bff78e60))
		{
			level.var_bff78e60 = var_d69e684e;
		}
		var_d5d07072 = var_d5d07072 - var_d69e684e;
		if(t > 1)
		{
			var_d69e684e = var_d69e684e * t;
		}
		level.var_bff78e60 = level.var_bff78e60 + var_d69e684e - level.var_bff78e60 * 3 * delta_time;
		cam_pos = cam_pos + var_f51225df * var_d69e684e;
	}
	var_d5d07072 = var_d5d07072 * t;
	var_d5d07072 = math::clamp(var_d5d07072, 0, var_ecd4ec49);
	if(!isdefined(level.var_d5d07072))
	{
		level.var_d5d07072 = var_d5d07072;
	}
	level.var_d5d07072 = level.var_d5d07072 + var_d5d07072 - level.var_d5d07072 * 2 * delta_time;
	cam_pos = cam_pos + var_f51225df * level.var_d5d07072;
	if(level.localplayers.size > 0)
	{
		if(isdefined(level.var_6383030e))
		{
			var_f55f63f3 = 2;
			dir = cam_pos - level.var_6383030e;
			if(lengthsquared(dir) < 1000000)
			{
				cam_pos = level.var_6383030e + dir * var_f55f63f3 * delta_time;
			}
		}
		if(isdefined(level.var_a32fbbc0))
		{
			var_f55f63f3 = 3;
			dir = angles - level.var_a32fbbc0;
			angles = level.var_a32fbbc0 + dir * var_f55f63f3 * delta_time;
		}
		if(cam_pos[2] > 2000)
		{
			cam_pos = (cam_pos[0], cam_pos[1], 2000);
		}
		if(isdefined(level.doa.var_db180da))
		{
			cam_pos = level.doa.var_db180da.origin;
		}
		foreach(var_826deedc, player in level.localplayers)
		{
			if(!isdefined(player))
			{
				continue;
			}
			player camerasetposition(cam_pos);
			player camerasetlookat(angles);
		}
		level.var_6383030e = cam_pos;
		level.var_a32fbbc0 = angles;
	}
}

