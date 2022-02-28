// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_5f11fb0b;

/*
	Name: main
	Namespace: namespace_5f11fb0b
	Checksum: 0xAE0096D6
	Offset: 0x200
	Size: 0xDC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("toplayer", "player_cam_blur", 1, 1, "int", &player_cam_blur, 0, 1);
	clientfield::register("toplayer", "player_cam_bubbles", 1, 1, "int", &player_cam_bubbles, 0, 1);
	clientfield::register("toplayer", "player_cam_fire", 1, 1, "int", &player_cam_fire, 0, 1);
}

/*
	Name: player_cam_blur
	Namespace: namespace_5f11fb0b
	Checksum: 0xE8A8EB94
	Offset: 0x2E8
	Size: 0xD2
	Parameters: 7
	Flags: Linked
*/
function player_cam_blur(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1 && !getinkillcam(localclientnum))
	{
		blurandtint_fx(localclientnum, 1, 0.5);
		self thread function_db5afebe(localclientnum);
	}
	else
	{
		blurandtint_fx(localclientnum, 0);
		self notify(#"hash_64e72e9d");
	}
}

/*
	Name: function_db5afebe
	Namespace: namespace_5f11fb0b
	Checksum: 0x9E51875
	Offset: 0x3C8
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function function_db5afebe(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"hash_64e72e9d");
	blur_level = 0.5;
	while(blur_level <= 1)
	{
		blur_level = blur_level + 0.04;
		blurandtint_fx(localclientnum, 1, blur_level);
		wait(0.05);
	}
}

/*
	Name: player_cam_bubbles
	Namespace: namespace_5f11fb0b
	Checksum: 0x1EFE3C96
	Offset: 0x458
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function player_cam_bubbles(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1 && !getinkillcam(localclientnum))
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
		self.n_fx_id = playfxoncamera(localclientnum, "player/fx_plyr_swim_bubbles_body", (0, 0, 0), (1, 0, 0), (0, 0, 1));
		self playrumbleonentity(localclientnum, "damage_heavy");
	}
	else if(isdefined(self.n_fx_id))
	{
		deletefx(localclientnum, self.n_fx_id, 1);
	}
}

/*
	Name: player_cam_fire
	Namespace: namespace_5f11fb0b
	Checksum: 0xB7CBDF4B
	Offset: 0x578
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function player_cam_fire(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1 && !getinkillcam(localclientnum))
	{
		burn_on_postfx();
	}
	else
	{
		function_7a5c3cf3();
	}
}

/*
	Name: burn_on_postfx
	Namespace: namespace_5f11fb0b
	Checksum: 0x55732AD6
	Offset: 0x618
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function burn_on_postfx()
{
	self endon(#"disconnect");
	self endon(#"hash_bdb63a72");
	self thread postfx::playpostfxbundle("pstfx_burn_loop");
}

/*
	Name: function_7a5c3cf3
	Namespace: namespace_5f11fb0b
	Checksum: 0x536F65D4
	Offset: 0x658
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_7a5c3cf3()
{
	self notify(#"hash_bdb63a72");
	self postfx::stoppostfxbundle();
}

