// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_qrdrone;
#using scripts\mp\killstreaks\_turret;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\util_shared;

#namespace remote_weapons;

/*
	Name: init
	Namespace: remote_weapons
	Checksum: 0xB0BFA67F
	Offset: 0x318
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.remoteweapons = [];
	level.remoteexithint = &"MP_REMOTE_EXIT";
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: remote_weapons
	Checksum: 0xEBD83E5E
	Offset: 0x368
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self assignremotecontroltrigger();
}

/*
	Name: removeandassignnewremotecontroltrigger
	Namespace: remote_weapons
	Checksum: 0x9264CE6F
	Offset: 0x398
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function removeandassignnewremotecontroltrigger(remotecontroltrigger)
{
	arrayremovevalue(self.activeremotecontroltriggers, remotecontroltrigger);
	self assignremotecontroltrigger(1);
}

/*
	Name: assignremotecontroltrigger
	Namespace: remote_weapons
	Checksum: 0x6D99665C
	Offset: 0x3E8
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function assignremotecontroltrigger(force_new_assignment = 0)
{
	if(!isdefined(self.activeremotecontroltriggers))
	{
		self.activeremotecontroltriggers = [];
	}
	arrayremovevalue(self.activeremotecontroltriggers, undefined);
	if(!isdefined(self.remotecontroltrigger) || force_new_assignment && self.activeremotecontroltriggers.size > 0)
	{
		self.remotecontroltrigger = self.activeremotecontroltriggers[self.activeremotecontroltriggers.size - 1];
	}
	if(isdefined(self.remotecontroltrigger))
	{
		self.remotecontroltrigger.origin = self.origin;
		self.remotecontroltrigger linkto(self);
	}
}

/*
	Name: registerremoteweapon
	Namespace: remote_weapons
	Checksum: 0x7250C605
	Offset: 0x4D0
	Size: 0xF4
	Parameters: 5
	Flags: Linked
*/
function registerremoteweapon(weaponname, hintstring, usecallback, endusecallback, hidecompassonuse = 1)
{
	/#
		assert(isdefined(level.remoteweapons));
	#/
	level.remoteweapons[weaponname] = spawnstruct();
	level.remoteweapons[weaponname].hintstring = hintstring;
	level.remoteweapons[weaponname].usecallback = usecallback;
	level.remoteweapons[weaponname].endusecallback = endusecallback;
	level.remoteweapons[weaponname].hidecompassonuse = hidecompassonuse;
}

/*
	Name: useremoteweapon
	Namespace: remote_weapons
	Checksum: 0x962F1B83
	Offset: 0x5D0
	Size: 0x144
	Parameters: 5
	Flags: Linked
*/
function useremoteweapon(weapon, weaponname, immediate, allowmanualdeactivation = 1, always_allow_ride = 0)
{
	player = self;
	/#
		assert(isplayer(player));
	#/
	weapon.remoteowner = player;
	weapon.inittime = gettime();
	weapon.remotename = weaponname;
	weapon.remoteweaponallowmanualdeactivation = allowmanualdeactivation;
	weapon thread watchremoveremotecontrolledweapon();
	if(!immediate)
	{
		weapon createremoteweapontrigger();
	}
	else
	{
		weapon thread watchownerdisconnect();
		weapon useremotecontrolweapon(allowmanualdeactivation, always_allow_ride);
	}
}

/*
	Name: watchforhack
	Namespace: remote_weapons
	Checksum: 0xA76DB73
	Offset: 0x720
	Size: 0x90
	Parameters: 0
	Flags: None
*/
function watchforhack()
{
	weapon = self;
	weapon endon(#"death");
	weapon waittill(#"killstreak_hacked", hacker);
	if(isdefined(weapon.remoteweaponallowmanualdeactivation) && weapon.remoteweaponallowmanualdeactivation == 1)
	{
		weapon thread watchremotecontroldeactivate();
	}
	weapon.remoteowner = hacker;
}

/*
	Name: watchremoveremotecontrolledweapon
	Namespace: remote_weapons
	Checksum: 0x7F50A7B1
	Offset: 0x7B8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function watchremoveremotecontrolledweapon()
{
	weapon = self;
	weapon endon(#"remote_weapon_end");
	weapon util::waittill_any("death", "remote_weapon_shutdown");
	weapon endremotecontrolweaponuse(0);
	while(isdefined(weapon))
	{
		wait(0.05);
	}
}

/*
	Name: createremoteweapontrigger
	Namespace: remote_weapons
	Checksum: 0x7B67BE61
	Offset: 0x838
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function createremoteweapontrigger()
{
	weapon = self;
	player = weapon.remoteowner;
	if(isdefined(weapon.usetrigger))
	{
		weapon.usetrigger delete();
	}
	weapon.usetrigger = spawn("trigger_radius_use", player.origin, 32, 32);
	weapon.usetrigger enablelinkto();
	weapon.usetrigger linkto(player);
	weapon.usetrigger sethintlowpriority(1);
	weapon.usetrigger setcursorhint("HINT_NOICON");
	weapon.usetrigger sethintstring(level.remoteweapons[weapon.remotename].hintstring);
	weapon.usetrigger setteamfortrigger(player.team);
	weapon.usetrigger.team = player.team;
	player clientclaimtrigger(weapon.usetrigger);
	player.remotecontroltrigger = weapon.usetrigger;
	player.activeremotecontroltriggers[player.activeremotecontroltriggers.size] = weapon.usetrigger;
	weapon.usetrigger.claimedby = player;
	weapon thread watchweapondeath();
	weapon thread watchownerdisconnect();
	weapon thread watchremotetriggeruse();
	weapon thread watchremotetriggerdisable();
}

/*
	Name: watchweapondeath
	Namespace: remote_weapons
	Checksum: 0x924CAF56
	Offset: 0xAD8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function watchweapondeath()
{
	weapon = self;
	weapon.usetrigger endon(#"death");
	weapon util::waittill_any("death", "remote_weapon_end");
	if(isdefined(weapon.remoteowner))
	{
		weapon.remoteowner removeandassignnewremotecontroltrigger(weapon.usetrigger);
	}
	weapon.usetrigger delete();
}

/*
	Name: watchownerdisconnect
	Namespace: remote_weapons
	Checksum: 0x17A8FA7D
	Offset: 0xB90
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function watchownerdisconnect()
{
	weapon = self;
	weapon endon(#"remote_weapon_end");
	weapon endon(#"remote_weapon_shutdown");
	if(isdefined(weapon.usetrigger))
	{
		weapon.usetrigger endon(#"death");
	}
	weapon.remoteowner util::waittill_any("joined_team", "disconnect", "joined_spectators");
	endremotecontrolweaponuse(0);
	if(isdefined(weapon) && isdefined(weapon.usetrigger))
	{
		weapon.usetrigger delete();
	}
}

/*
	Name: watchremotetriggerdisable
	Namespace: remote_weapons
	Checksum: 0x90D39203
	Offset: 0xC78
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function watchremotetriggerdisable()
{
	weapon = self;
	weapon endon(#"remote_weapon_end");
	weapon endon(#"remote_weapon_shutdown");
	weapon.usetrigger endon(#"death");
	while(true)
	{
		weapon.usetrigger triggerenable(!weapon.remoteowner iswallrunning());
		wait(0.1);
	}
}

/*
	Name: allowremotestart
	Namespace: remote_weapons
	Checksum: 0x69C1EC1B
	Offset: 0xD18
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function allowremotestart()
{
	player = self;
	if(player usebuttonpressed() && !player.throwinggrenade && !player meleebuttonpressed() && !player util::isusingremote() && (!(isdefined(player.carryobject) && (isdefined(player.carryobject.disallowremotecontrol) && player.carryobject.disallowremotecontrol))))
	{
		return 1;
	}
	return 0;
}

/*
	Name: watchremotetriggeruse
	Namespace: remote_weapons
	Checksum: 0x58085E4F
	Offset: 0xDF0
	Size: 0x170
	Parameters: 0
	Flags: Linked
*/
function watchremotetriggeruse()
{
	weapon = self;
	weapon endon(#"death");
	weapon endon(#"remote_weapon_end");
	if(weapon.remoteowner util::is_bot())
	{
		return;
	}
	while(true)
	{
		weapon.usetrigger waittill(#"trigger", player);
		if(weapon.remoteowner isusingoffhand() || weapon.remoteowner iswallrunning())
		{
			continue;
		}
		if(isdefined(weapon.hackertrigger) && isdefined(weapon.hackertrigger.progressbar))
		{
			if(weapon.remotename == "killstreak_remote_turret")
			{
				weapon.remoteowner iprintlnbold(&"KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE");
			}
			continue;
		}
		if(weapon.remoteowner allowremotestart())
		{
			useremotecontrolweapon();
		}
	}
}

/*
	Name: useremotecontrolweapon
	Namespace: remote_weapons
	Checksum: 0xBC3F0515
	Offset: 0xF68
	Size: 0x42C
	Parameters: 2
	Flags: Linked
*/
function useremotecontrolweapon(allowmanualdeactivation = 1, always_allow_ride = 0)
{
	self endon(#"death");
	weapon = self;
	/#
		assert(isdefined(weapon.remoteowner));
	#/
	weapon.control_initiated = 1;
	weapon.endremotecontrolweapon = 0;
	weapon.remoteowner endon(#"disconnect");
	weapon.remoteowner endon(#"joined_team");
	weapon.remoteowner disableoffhandweapons();
	weapon.remoteowner disableweaponcycling();
	weapon.remoteowner.dofutz = 0;
	if(!isdefined(weapon.disableremoteweaponswitch))
	{
		remoteweapon = getweapon("killstreak_remote");
		weapon.remoteowner giveweapon(remoteweapon);
		weapon.remoteowner switchtoweapon(remoteweapon);
		if(always_allow_ride)
		{
			weapon.remoteowner util::waittill_any("weapon_change", "death");
		}
		else
		{
			weapon.remoteowner waittill(#"weapon_change", newweapon);
		}
	}
	if(isdefined(newweapon))
	{
		if(newweapon != remoteweapon)
		{
			weapon.remoteowner killstreaks::clear_using_remote(1, 1);
			return;
		}
	}
	weapon.remoteowner thread killstreaks::watch_for_remove_remote_weapon();
	weapon.remoteowner util::setusingremote(weapon.remotename);
	weapon.remoteowner util::freeze_player_controls(1);
	result = weapon.remoteowner killstreaks::init_ride_killstreak(weapon.remotename, always_allow_ride);
	if(result != "success")
	{
		if(result != "disconnect")
		{
			weapon.remoteowner killstreaks::clear_using_remote();
			weapon thread resetcontrolinitiateduponownerrespawn();
		}
	}
	else
	{
		weapon.controlled = 1;
		weapon.killcament = self;
		weapon notify(#"remote_start");
		if(allowmanualdeactivation)
		{
			weapon thread watchremotecontroldeactivate();
		}
		weapon.remoteowner thread [[level.remoteweapons[weapon.remotename].usecallback]](weapon);
		if(level.remoteweapons[weapon.remotename].hidecompassonuse)
		{
			weapon.remoteowner killstreaks::hide_compass();
		}
	}
	weapon.remoteowner util::freeze_player_controls(0);
}

/*
	Name: resetcontrolinitiateduponownerrespawn
	Namespace: remote_weapons
	Checksum: 0x5225467C
	Offset: 0x13A0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function resetcontrolinitiateduponownerrespawn()
{
	self endon(#"death");
	self.remoteowner waittill(#"spawned");
	self.control_initiated = 0;
}

/*
	Name: watchremotecontroldeactivate
	Namespace: remote_weapons
	Checksum: 0x1F652251
	Offset: 0x13D8
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function watchremotecontroldeactivate()
{
	self notify(#"watchremotecontroldeactivate_remoteweapons");
	self endon(#"watchremotecontroldeactivate_remoteweapons");
	weapon = self;
	weapon endon(#"remote_weapon_end");
	weapon endon(#"death");
	weapon.remoteowner endon(#"disconnect");
	while(true)
	{
		timeused = 0;
		while(weapon.remoteowner usebuttonpressed())
		{
			timeused = timeused + 0.05;
			if(timeused > 0.25)
			{
				weapon thread endremotecontrolweaponuse(1);
				return;
			}
			wait(0.05);
		}
		wait(0.05);
	}
}

/*
	Name: endremotecontrolweaponuse
	Namespace: remote_weapons
	Checksum: 0xBE4FADA8
	Offset: 0x14D0
	Size: 0x4F0
	Parameters: 1
	Flags: Linked
*/
function endremotecontrolweaponuse()
{
System.InvalidOperationException: Stack empty.
   at System.ThrowHelper.ThrowInvalidOperationException(ExceptionResource resource)
   at System.Collections.Generic.Stack`1.Pop()
   at Cerberus.Logic.Decompiler.BuildExpression(ScriptOp startOp) in D:\Modding\Call of Duty\t89-dec\Cerberus.Logic\Decompiler\Decompiler.cs:line 1185
   at Cerberus.Logic.Decompiler.ProcessInstruction(ScriptOp operation, DecompilerBlock block) in D:\Modding\Call of Duty\t89-dec\Cerberus.Logic\Decompiler\Decompiler.cs:line 2343
   at Cerberus.Logic.Decompiler.DecompileBlock(DecompilerBlock decompilerBlock, Int32 tabs) in D:\Modding\Call of Duty\t89-dec\Cerberus.Logic\Decompiler\Decompiler.cs:line 998
   at Cerberus.Logic.Decompiler..ctor(ScriptExport function, ScriptBase script) in D:\Modding\Call of Duty\t89-dec\Cerberus.Logic\Decompiler\Decompiler.cs:line 222
/*
function endremotecontrolweaponuse(exitrequestedbyowner)
{
	weapon = self;
	if(!isdefined(weapon) || (isdefined(weapon.endremotecontrolweapon) && weapon.endremotecontrolweapon))
	{
		return;
	}
	weapon.endremotecontrolweapon = 1;

*/

	/* ======== */

/* 
	Stack: 
*/
	/* ======== */

/* 
	Blocks: 
	Cerberus.Logic.BasicBlock at 0x14D0, end at 0x19C1
	Cerberus.Logic.IfBlock at 0x1502, end at 0x1536
	Cerberus.Logic.WhileLoop at 0x1596, end at 0x1616
	Cerberus.Logic.IfBlock at 0x161A, end at 0x1626
	Cerberus.Logic.IfBlock at 0x1626, end at 0x17EA
	Cerberus.Logic.IfBlock at 0x1642, end at 0x1666
	Cerberus.Logic.IfBlock at 0x167A, end at 0x16F6
	Cerberus.Logic.IfBlock at 0x16B8, end at 0x16F2
	Cerberus.Logic.ElseIfBlock at 0x16F6, end at 0x175E
	Cerberus.Logic.TernaryBlock at 0x1734, end at 0x175C
	Cerberus.Logic.IfBlock at 0x175E, end at 0x17EA
	Cerberus.Logic.IfBlock at 0x1790, end at 0x17B2
	Cerberus.Logic.IfBlock at 0x17EA, end at 0x183A
	Cerberus.Logic.IfBlock at 0x183A, end at 0x1922
	Cerberus.Logic.IfBlock at 0x1856, end at 0x1922
	Cerberus.Logic.IfBlock at 0x186A, end at 0x18EA
	Cerberus.Logic.IfBlock at 0x1892, end at 0x18C2
	Cerberus.Logic.IfBlock at 0x18EA, end at 0x1922
	Cerberus.Logic.IfBlock at 0x1922, end at 0x19BE
	Cerberus.Logic.IfBlock at 0x194E, end at 0x1982
	Cerberus.Logic.IfBlock at 0x1982, end at 0x19BE
*/
	/* ======== */

}

/*
	Name: fadetoblackandbackin
	Namespace: remote_weapons
	Checksum: 0x6A0FD362
	Offset: 0x19C8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function fadetoblackandbackin()
{
	self endon(#"disconnect");
	lui::screen_fade_out(0.1);
	self qrdrone::destroyhud();
	wait(0.05);
	self notify(#"fade2black");
	lui::screen_fade_in(0.2);
}

/*
	Name: stunstaticfx
	Namespace: remote_weapons
	Checksum: 0x6B5BD34D
	Offset: 0x1A40
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function stunstaticfx(duration)
{
	self endon(#"remove_remote_weapon");
	self.fullscreen_static.alpha = 0.65;
	wait(duration - 0.5);
	time = duration - 0.5;
	while(time < duration)
	{
		wait(0.05);
		time = time + 0.05;
		self.fullscreen_static.alpha = self.fullscreen_static.alpha - 0.05;
	}
	self.fullscreen_static.alpha = 0.15;
}

/*
	Name: destroyremotehud
	Namespace: remote_weapons
	Checksum: 0x90CE73B7
	Offset: 0x1B10
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function destroyremotehud()
{
	self useservervisionset(0);
	self setinfraredvision(0);
	if(isdefined(self.fullscreen_static))
	{
		self.fullscreen_static destroy();
	}
	if(isdefined(self.hud_prompt_exit))
	{
		self.hud_prompt_exit destroy();
	}
}

/*
	Name: set_static
	Namespace: remote_weapons
	Checksum: 0xF83E9E70
	Offset: 0x1BA0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function set_static(val)
{
	owner = self.owner;
	if(isdefined(owner) && owner.usingvehicle && isdefined(owner.viewlockedentity) && owner.viewlockedentity == self)
	{
		owner clientfield::set_to_player("static_postfx", val);
	}
}

/*
	Name: do_static_fx
	Namespace: remote_weapons
	Checksum: 0xB05E264C
	Offset: 0x1C30
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function do_static_fx()
{
	self endon(#"death");
	self set_static(1);
	wait(2);
	self set_static(0);
	self notify(#"static_fx_done");
}

