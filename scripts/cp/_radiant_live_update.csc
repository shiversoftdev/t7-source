// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\system_shared;

#namespace radiant_live_update;

/*
	Name: __init__sytem__
	Namespace: radiant_live_update
	Checksum: 0x6FEDD873
	Offset: 0x98
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: radiant_live_update
	Checksum: 0x85AD79B0
	Offset: 0xD8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		thread scriptstruct_debug_render();
	#/
}

/*
	Name: scriptstruct_debug_render
	Namespace: radiant_live_update
	Checksum: 0x82E7522D
	Offset: 0x100
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function scriptstruct_debug_render()
{
	/#
		while(true)
		{
			level waittill(#"liveupdate", selected_struct);
			if(isdefined(selected_struct))
			{
				level thread render_struct(selected_struct);
			}
			else
			{
				level notify(#"stop_struct_render");
			}
		}
	#/
}

/*
	Name: render_struct
	Namespace: radiant_live_update
	Checksum: 0x2FFFCD7E
	Offset: 0x170
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function render_struct(selected_struct)
{
	/#
		self endon(#"stop_struct_render");
		while(isdefined(selected_struct) && isdefined(selected_struct.origin))
		{
			box(selected_struct.origin, vectorscale((-1, -1, -1), 16), vectorscale((1, 1, 1), 16), 0, (1, 0.4, 0.4));
			wait(0.01);
		}
	#/
}

