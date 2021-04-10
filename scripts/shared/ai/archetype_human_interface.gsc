// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_human;
#using scripts\shared\ai\systems\ai_interface;

#namespace humaninterface;

/*
	Name: registerhumaninterfaceattributes
	Namespace: humaninterface
	Checksum: 0x5707D523
	Offset: 0x1B8
	Size: 0x3C4
	Parameters: 0
	Flags: Linked
*/
function registerhumaninterfaceattributes()
{
	ai::registermatchedinterface("human", "can_be_meleed", 1, array(1, 0));
	ai::registermatchedinterface("human", "can_melee", 1, array(1, 0));
	ai::registermatchedinterface("human", "can_initiateaivsaimelee", 1, array(1, 0));
	ai::registermatchedinterface("human", "coverIdleOnly", 0, array(1, 0));
	ai::registermatchedinterface("human", "cqb", 0, array(1, 0), &humansoldierserverutils::cqbattributecallback);
	ai::registermatchedinterface("human", "forceTacticalWalk", 0, array(1, 0), &humansoldierserverutils::forcetacticalwalkcallback);
	ai::registermatchedinterface("human", "move_mode", "normal", array("normal", "rambo"), &humansoldierserverutils::movemodeattributecallback);
	ai::registermatchedinterface("human", "useAnimationOverride", 0, array(1, 0), &humansoldierserverutils::useanimationoverridecallback);
	ai::registermatchedinterface("human", "sprint", 0, array(1, 0));
	ai::registermatchedinterface("human", "patrol", 0, array(1, 0));
	ai::registermatchedinterface("human", "disablearrivals", 0, array(1, 0));
	ai::registermatchedinterface("human", "disablesprint", 0, array(1, 0));
	ai::registermatchedinterface("human", "stealth", 0, array(1, 0));
	ai::registermatchedinterface("human", "vignette_mode", "off", array("off", "slow", "fast"), &humansoldierserverutils::vignettemodecallback);
	ai::registermatchedinterface("human", "useGrenades", 1, array(1, 0));
}

