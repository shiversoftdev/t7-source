// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;

#namespace cp_mi_sing_blackstation_sound;

/*
	Name: main
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x57EA5086
	Offset: 0x218
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_8a682a34();
	level thread function_70f35bef();
	level thread function_329c89f();
	clientfield::register("toplayer", "slowmo_duck_active", 1, 2, "int");
}

/*
	Name: function_8a682a34
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x6FD6C53D
	Offset: 0x2A0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_8a682a34()
{
	level waittill(#"hash_d195be99");
	music::setmusicstate("military_action");
}

/*
	Name: function_70f35bef
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x780B2AD0
	Offset: 0x2D8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_70f35bef()
{
	level waittill(#"hash_9074b8ad");
	wait(1.85);
	music::setmusicstate("none");
}

/*
	Name: function_329c89f
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x113976A
	Offset: 0x318
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_329c89f()
{
	level waittill(#"hash_329c89f");
	level clientfield::set("sndDrillWalla", 0);
}

#namespace namespace_4297372;

/*
	Name: function_973b77f9
	Namespace: namespace_4297372
	Checksum: 0x57830479
	Offset: 0x350
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_973b77f9()
{
	music::setmusicstate("none");
}

/*
	Name: function_fcea1d9
	Namespace: namespace_4297372
	Checksum: 0xB8DE633B
	Offset: 0x378
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_fcea1d9()
{
	wait(3);
	music::setmusicstate("none");
}

/*
	Name: function_240ac8fa
	Namespace: namespace_4297372
	Checksum: 0xB3E813D4
	Offset: 0x3A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_240ac8fa()
{
	music::setmusicstate("shanty_town");
}

/*
	Name: function_4f531ae2
	Namespace: namespace_4297372
	Checksum: 0x8B8773A1
	Offset: 0x3D0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_4f531ae2()
{
	music::setmusicstate("54i_theme_igc");
}

/*
	Name: function_fa2e45b8
	Namespace: namespace_4297372
	Checksum: 0xFFC98E45
	Offset: 0x3F8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_fa2e45b8()
{
	music::setmusicstate("battle_1");
}

/*
	Name: function_91146001
	Namespace: namespace_4297372
	Checksum: 0xF3DDA14F
	Offset: 0x420
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_91146001()
{
	music::setmusicstate("battle_1_docks");
}

/*
	Name: function_11139d81
	Namespace: namespace_4297372
	Checksum: 0xA5ACA76F
	Offset: 0x448
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_11139d81()
{
	music::setmusicstate("boat_ride");
}

/*
	Name: function_5b1a53ea
	Namespace: namespace_4297372
	Checksum: 0x4A7C2014
	Offset: 0x470
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_5b1a53ea()
{
	music::setmusicstate("rachael");
}

/*
	Name: function_6c35b4f3
	Namespace: namespace_4297372
	Checksum: 0x6CAAD59C
	Offset: 0x498
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_6c35b4f3()
{
	music::setmusicstate("battle_2");
}

/*
	Name: function_d4c52995
	Namespace: namespace_4297372
	Checksum: 0xFFA4F035
	Offset: 0x4C0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_d4c52995()
{
	music::setmusicstate("tension_loop");
}

/*
	Name: function_cde82250
	Namespace: namespace_4297372
	Checksum: 0x71D83084
	Offset: 0x4E8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_cde82250()
{
	music::setmusicstate("data_relay");
}

/*
	Name: function_f152b1dc
	Namespace: namespace_4297372
	Checksum: 0x1E7C8F83
	Offset: 0x510
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_f152b1dc()
{
	wait(3);
	music::setmusicstate("zip_line");
}

/*
	Name: function_674f7650
	Namespace: namespace_4297372
	Checksum: 0x99A0339A
	Offset: 0x540
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_674f7650()
{
	music::setmusicstate("last_building_underscore");
}

/*
	Name: function_37f7c98d
	Namespace: namespace_4297372
	Checksum: 0x6A5FB495
	Offset: 0x568
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_37f7c98d()
{
	music::setmusicstate("underwater");
}

/*
	Name: function_bed0eaad
	Namespace: namespace_4297372
	Checksum: 0xF75D65F3
	Offset: 0x590
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_bed0eaad()
{
	wait(9);
	music::setmusicstate("police_station");
}

/*
	Name: function_6048af60
	Namespace: namespace_4297372
	Checksum: 0x7350C032
	Offset: 0x5C0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_6048af60()
{
	music::setmusicstate("discovery");
}

/*
	Name: function_a339da70
	Namespace: namespace_4297372
	Checksum: 0x1533E53F
	Offset: 0x5E8
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function function_a339da70()
{
	playerlist = getplayers();
	foreach(player in playerlist)
	{
		player playsoundtoplayer("evt_takedown_slowmo_02", player);
		player playloopsound("evt_time_slow_loop");
		player clientfield::set_to_player("slowmo_duck_active", 1);
	}
}

/*
	Name: function_69fc18eb
	Namespace: namespace_4297372
	Checksum: 0x6F99F35D
	Offset: 0x6E8
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_69fc18eb()
{
	playerlist = getplayers();
	foreach(player in playerlist)
	{
		player playsoundtoplayer("evt_takedown_slowmo_exit", player);
		player stoploopsound();
		player clientfield::set_to_player("slowmo_duck_active", 0);
	}
}

