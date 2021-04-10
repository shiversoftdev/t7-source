// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace fr;

/*
	Name: main
	Namespace: fr
	Checksum: 0xBB534E6E
	Offset: 0x300
	Size: 0x33C
	Parameters: 0
	Flags: None
*/
function main()
{
	callback::on_localclient_connect(&on_player_connect);
	clientfield::register("world", "freerun_state", 1, 3, "int", &freerunstatechanged, 0, 0);
	clientfield::register("world", "freerun_retries", 1, 16, "int", &freerunretriesupdated, 0, 0);
	clientfield::register("world", "freerun_faults", 1, 16, "int", &freerunfaultsupdated, 0, 0);
	clientfield::register("world", "freerun_startTime", 1, 31, "int", &freerunstarttimeupdated, 0, 0);
	clientfield::register("world", "freerun_finishTime", 1, 31, "int", &freerunfinishtimeupdated, 0, 0);
	clientfield::register("world", "freerun_bestTime", 1, 31, "int", &freerunbesttimeupdated, 0, 0);
	clientfield::register("world", "freerun_timeAdjustment", 1, 31, "int", &freeruntimeadjustmentupdated, 0, 0);
	clientfield::register("world", "freerun_timeAdjustmentNegative", 1, 1, "int", &freeruntimeadjustmentsignupdated, 0, 0);
	clientfield::register("world", "freerun_bulletPenalty", 1, 16, "int", &freerunbulletpenaltyupdated, 0, 0);
	clientfield::register("world", "freerun_pausedTime", 1, 31, "int", &freerunpausedtimeupdated, 0, 0);
	clientfield::register("world", "freerun_checkpointIndex", 1, 7, "int", &freeruncheckpointupdated, 0, 0);
}

/*
	Name: on_player_connect
	Namespace: fr
	Checksum: 0x55FEC4EE
	Offset: 0x648
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function on_player_connect(localclientnum)
{
	allowactionslotinput(localclientnum);
	allowscoreboard(localclientnum, 0);
}

/*
	Name: freerunstatechanged
	Namespace: fr
	Checksum: 0xEBA1747B
	Offset: 0x690
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freerunstatechanged(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	statemodel = createuimodel(controllermodel, "FreeRun.runState");
	setuimodelvalue(statemodel, newval);
}

/*
	Name: freerunretriesupdated
	Namespace: fr
	Checksum: 0x3CFA0699
	Offset: 0x740
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freerunretriesupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	retriesmodel = createuimodel(controllermodel, "FreeRun.freeRunInfo.retries");
	setuimodelvalue(retriesmodel, newval);
}

/*
	Name: freerunfaultsupdated
	Namespace: fr
	Checksum: 0x33BF8E3E
	Offset: 0x7F0
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freerunfaultsupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	faultsmodel = createuimodel(controllermodel, "FreeRun.freeRunInfo.faults");
	setuimodelvalue(faultsmodel, newval);
}

/*
	Name: freerunstarttimeupdated
	Namespace: fr
	Checksum: 0x6F52FA34
	Offset: 0x8A0
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freerunstarttimeupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	model = createuimodel(controllermodel, "FreeRun.startTime");
	setuimodelvalue(model, newval);
}

/*
	Name: freerunfinishtimeupdated
	Namespace: fr
	Checksum: 0xE9C3C603
	Offset: 0x950
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freerunfinishtimeupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	model = createuimodel(controllermodel, "FreeRun.finishTime");
	setuimodelvalue(model, newval);
}

/*
	Name: freerunbesttimeupdated
	Namespace: fr
	Checksum: 0x57C0600C
	Offset: 0xA00
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freerunbesttimeupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	model = createuimodel(controllermodel, "FreeRun.freeRunInfo.bestTime");
	setuimodelvalue(model, newval);
}

/*
	Name: freeruntimeadjustmentupdated
	Namespace: fr
	Checksum: 0x7B79FE2B
	Offset: 0xAB0
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freeruntimeadjustmentupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	model = createuimodel(controllermodel, "FreeRun.timer.timeAdjustment");
	setuimodelvalue(model, newval);
}

/*
	Name: freeruntimeadjustmentsignupdated
	Namespace: fr
	Checksum: 0x73DB482
	Offset: 0xB60
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freeruntimeadjustmentsignupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	model = createuimodel(controllermodel, "FreeRun.timer.timeAdjustmentNegative");
	setuimodelvalue(model, newval);
}

/*
	Name: freerunbulletpenaltyupdated
	Namespace: fr
	Checksum: 0xA1DA69C4
	Offset: 0xC10
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freerunbulletpenaltyupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	bulletpenaltymodel = createuimodel(controllermodel, "FreeRun.freeRunInfo.bulletPenalty");
	setuimodelvalue(bulletpenaltymodel, newval);
}

/*
	Name: freerunpausedtimeupdated
	Namespace: fr
	Checksum: 0xE5DCC027
	Offset: 0xCC0
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freerunpausedtimeupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	model = createuimodel(controllermodel, "FreeRun.pausedTime");
	setuimodelvalue(model, newval);
}

/*
	Name: freeruncheckpointupdated
	Namespace: fr
	Checksum: 0x59A4B026
	Offset: 0xD70
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function freeruncheckpointupdated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	model = createuimodel(controllermodel, "FreeRun.freeRunInfo.activeCheckpoint");
	setuimodelvalue(model, newval);
}

/*
	Name: onprecachegametype
	Namespace: fr
	Checksum: 0x99EC1590
	Offset: 0xE20
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
}

/*
	Name: onstartgametype
	Namespace: fr
	Checksum: 0x99EC1590
	Offset: 0xE30
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
}

