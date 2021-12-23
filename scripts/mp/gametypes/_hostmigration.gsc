// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;

#namespace hostmigration;

/*
	Name: callback_hostmigrationsave
	Namespace: hostmigration
	Checksum: 0x99EC1590
	Offset: 0x100
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function callback_hostmigrationsave()
{
}

/*
	Name: callback_prehostmigrationsave
	Namespace: hostmigration
	Checksum: 0x99EC1590
	Offset: 0x110
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function callback_prehostmigrationsave()
{
}

/*
	Name: callback_hostmigration
	Namespace: hostmigration
	Checksum: 0x348F972E
	Offset: 0x120
	Size: 0x1B2
	Parameters: 0
	Flags: Linked
*/
function callback_hostmigration()
{
	setslowmotion(1, 1, 0);
	level.hostmigrationreturnedplayercount = 0;
	if(level.inprematchperiod)
	{
		level waittill(#"prematch_over");
	}
	if(level.gameended)
	{
		/#
			println(("" + gettime()) + "");
		#/
		return;
	}
	/#
		println("" + gettime());
	#/
	level.hostmigrationtimer = 1;
	sethostmigrationstatus(1);
	level notify(#"host_migration_begin");
	thread locktimer();
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player thread hostmigrationtimerthink();
	}
	level endon(#"host_migration_begin");
	hostmigrationwait();
	level.hostmigrationtimer = undefined;
	sethostmigrationstatus(0);
	/#
		println("" + gettime());
	#/
	level notify(#"host_migration_end");
}

