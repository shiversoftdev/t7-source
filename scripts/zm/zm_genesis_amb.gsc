// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_weaponobjects;

#namespace zm_genesis_amb;

/*
	Name: main
	Namespace: zm_genesis_amb
	Checksum: 0x25FAD8DD
	Offset: 0x1D0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level flag::init("ambient_solar_flares_on");
	level thread function_25b0085d();
}

/*
	Name: function_25b0085d
	Namespace: zm_genesis_amb
	Checksum: 0xDBA4D479
	Offset: 0x218
	Size: 0x238
	Parameters: 0
	Flags: Linked
*/
function function_25b0085d()
{
	level waittill(#"start_zombie_round_logic");
	if(getdvarint("splitscreen_playerCount") >= 2)
	{
		return;
	}
	level flag::set("ambient_solar_flares_on");
	while(true)
	{
		wait(randomfloatrange(40, 60));
		var_9a813858 = 0;
		if(!level flag::get("ambient_solar_flares_on"))
		{
			level flag::wait_till("ambient_solar_flares_on");
		}
		do
		{
			var_34b4e10b = undefined;
			var_717fac8 = array::random(level.activeplayers);
			if(!isdefined(var_717fac8.var_a3d40b8))
			{
				wait(0.5);
			}
			else
			{
				str_zone = var_717fac8.var_a3d40b8;
				var_32db8f92 = strtok(str_zone, "_");
				var_34b4e10b = var_32db8f92[0];
				if(var_34b4e10b === "apothicon")
				{
					var_34b4e10b = undefined;
					wait(0.5);
				}
				else
				{
					wait(0.05);
				}
			}
		}
		while(!isdefined(var_34b4e10b));
		if(var_34b4e10b == "start")
		{
			var_34b4e10b = "sheffield";
		}
		var_9949c988 = randomintrange(1, 4);
		var_3f75b0e3 = (("lgtexp_solarflare_" + var_34b4e10b) + "_0") + var_9949c988;
		exploder::exploder_duration(var_3f75b0e3, 4);
	}
}

