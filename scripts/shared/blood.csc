// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace blood;

/*
	Name: __init__sytem__
	Namespace: blood
	Checksum: 0x78316BA3
	Offset: 0x1B8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("blood", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: blood
	Checksum: 0xA02BB25C
	Offset: 0x1F8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.bloodstage3 = getdvarfloat("cg_t7HealthOverlay_Threshold3", 0.5);
	level.bloodstage2 = getdvarfloat("cg_t7HealthOverlay_Threshold2", 0.8);
	level.bloodstage1 = getdvarfloat("cg_t7HealthOverlay_Threshold1", 0.99);
	level.use_digital_blood_enabled = getdvarfloat("scr_use_digital_blood_enabled", 1);
	callback::on_localplayer_spawned(&localplayer_spawned);
}

/*
	Name: localplayer_spawned
	Namespace: blood
	Checksum: 0x8B034714
	Offset: 0x2C8
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function localplayer_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	/#
		level.use_digital_blood_enabled = getdvarfloat("", level.use_digital_blood_enabled);
	#/
	self.use_digital_blood = 0;
	bodytype = self getcharacterbodytype();
	if(level.use_digital_blood_enabled && bodytype >= 0)
	{
		bodytypefields = getcharacterfields(bodytype, currentsessionmode());
		self.use_digital_blood = (isdefined(bodytypefields.digitalblood) ? bodytypefields.digitalblood : 0);
	}
	self thread player_watch_blood(localclientnum);
	self thread player_watch_blood_shutdown(localclientnum);
}

/*
	Name: player_watch_blood_shutdown
	Namespace: blood
	Checksum: 0x134C5B6B
	Offset: 0x400
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function player_watch_blood_shutdown(localclientnum)
{
	self util::waittill_any("entityshutdown", "death");
	self disable_blood(localclientnum);
}

/*
	Name: enable_blood
	Namespace: blood
	Checksum: 0x70D371A3
	Offset: 0x458
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function enable_blood(localclientnum)
{
	self.blood_enabled = 1;
	filter::init_filter_feedback_blood(localclientnum, self.use_digital_blood);
	filter::enable_filter_feedback_blood(localclientnum, 2, 2, self.use_digital_blood);
	filter::set_filter_feedback_blood_sundir(localclientnum, 2, 2, 65, 32);
	filter::init_filter_sprite_blood_heavy(localclientnum, self.use_digital_blood);
	filter::enable_filter_sprite_blood_heavy(localclientnum, 2, 1, self.use_digital_blood);
	filter::set_filter_sprite_blood_seed_offset(localclientnum, 2, 1, randomfloat(1));
}

/*
	Name: disable_blood
	Namespace: blood
	Checksum: 0xD70EE0DA
	Offset: 0x560
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function disable_blood(localclientnum)
{
	if(isdefined(self))
	{
		self.blood_enabled = 0;
	}
	filter::disable_filter_feedback_blood(localclientnum, 2, 2);
	filter::disable_filter_sprite_blood(localclientnum, 2, 1);
	if(!(isdefined(self.nobloodlightbarchange) && self.nobloodlightbarchange))
	{
		setcontrollerlightbarcolor(localclientnum);
	}
}

/*
	Name: blood_in
	Namespace: blood
	Checksum: 0xA59D1B
	Offset: 0x5F8
	Size: 0x1DC
	Parameters: 2
	Flags: Linked
*/
function blood_in(localclientnum, playerhealth)
{
	if(playerhealth < level.bloodstage3)
	{
		self.stage3amount = (level.bloodstage3 - playerhealth) / level.bloodstage3;
	}
	else
	{
		self.stage3amount = 0;
	}
	if(playerhealth < level.bloodstage2)
	{
		self.stage2amount = (level.bloodstage2 - playerhealth) / level.bloodstage2;
	}
	else
	{
		self.stage2amount = 0;
	}
	filter::set_filter_feedback_blood_vignette(localclientnum, 2, 2, self.stage3amount);
	filter::set_filter_feedback_blood_opacity(localclientnum, 2, 2, self.stage2amount);
	if(playerhealth < level.bloodstage1)
	{
		minstage1health = 0.55;
		/#
			assert(level.bloodstage1 > minstage1health);
		#/
		stagehealth = playerhealth - minstage1health;
		if(stagehealth < 0)
		{
			stagehealth = 0;
		}
		self.stage1amount = 1 - (stagehealth / (level.bloodstage1 - minstage1health));
	}
	else
	{
		self.stage1amount = 0;
	}
	filter::set_filter_sprite_blood_opacity(localclientnum, 2, 1, self.stage1amount);
	filter::set_filter_sprite_blood_elapsed(localclientnum, 2, 1, getservertime(localclientnum));
}

/*
	Name: blood_out
	Namespace: blood
	Checksum: 0x99281DA8
	Offset: 0x7E0
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function blood_out(localclientnum)
{
	currenttime = getservertime(localclientnum);
	elapsedtime = currenttime - self.lastbloodupdate;
	self.lastbloodupdate = currenttime;
	subtract = elapsedtime / 1000;
	if(self.stage3amount > 0)
	{
		self.stage3amount = self.stage3amount - subtract;
	}
	if(self.stage3amount < 0)
	{
		self.stage3amount = 0;
	}
	if(self.stage2amount > 0)
	{
		self.stage2amount = self.stage2amount - subtract;
	}
	if(self.stage2amount < 0)
	{
		self.stage2amount = 0;
	}
	filter::set_filter_feedback_blood_vignette(localclientnum, 2, 2, self.stage3amount);
	filter::set_filter_feedback_blood_opacity(localclientnum, 2, 2, self.stage2amount);
	if(self.stage1amount > 0)
	{
		self.stage1amount = self.stage1amount - subtract;
	}
	if(self.stage1amount < 0)
	{
		self.stage1amount = 0;
	}
	filter::set_filter_sprite_blood_opacity(localclientnum, 2, 1, self.stage1amount);
	filter::set_filter_sprite_blood_elapsed(localclientnum, 2, 1, getservertime(localclientnum));
}

/*
	Name: player_watch_blood
	Namespace: blood
	Checksum: 0xEA9EC669
	Offset: 0x9B0
	Size: 0x3D0
	Parameters: 1
	Flags: Linked
*/
function player_watch_blood(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	self endon(#"death");
	self endon(#"killbloodoverlay");
	self.stage2amount = 0;
	self.stage3amount = 0;
	self.lastbloodupdate = 0;
	priorplayerhealth = renderhealthoverlayhealth(localclientnum);
	self blood_in(localclientnum, priorplayerhealth);
	while(true)
	{
		if(renderhealthoverlay(localclientnum) && (!(isdefined(self.nobloodoverlay) && self.nobloodoverlay)))
		{
			shouldenabledoverlay = 0;
			playerhealth = renderhealthoverlayhealth(localclientnum);
			if(playerhealth < priorplayerhealth)
			{
				shouldenabledoverlay = 1;
				self blood_in(localclientnum, playerhealth);
			}
			else
			{
				if(playerhealth == priorplayerhealth && playerhealth != 1)
				{
					shouldenabledoverlay = 1;
					self.lastbloodupdate = getservertime(localclientnum);
				}
				else
				{
					if(self.stage2amount > 0 || self.stage3amount > 0)
					{
						shouldenabledoverlay = 1;
						self blood_out(localclientnum);
					}
					else if(isdefined(self.blood_enabled) && self.blood_enabled)
					{
						self disable_blood(localclientnum);
					}
				}
			}
			priorplayerhealth = playerhealth;
			if(!(isdefined(self.blood_enabled) && self.blood_enabled) && shouldenabledoverlay)
			{
				self enable_blood(localclientnum);
			}
			if(!(isdefined(self.nobloodlightbarchange) && self.nobloodlightbarchange))
			{
				if(self.stage3amount > 0)
				{
					setcontrollerlightbarcolorpulsing(localclientnum, (1, 0, 0), 600);
				}
				else
				{
					if(self.stage2amount == 1)
					{
						setcontrollerlightbarcolorpulsing(localclientnum, vectorscale((1, 0, 0), 0.8), 1200);
					}
					else
					{
						if(getgadgetpower(localclientnum) == 1 && (!sessionmodeiscampaigngame() || codegetuimodelclientfield(self, "playerAbilities.inRange")))
						{
							setcontrollerlightbarcolorpulsing(localclientnum, (1, 1, 0), 2000);
						}
						else
						{
							if(isdefined(self.controllercolor))
							{
								setcontrollerlightbarcolor(localclientnum, self.controllercolor);
							}
							else
							{
								setcontrollerlightbarcolor(localclientnum);
							}
						}
					}
				}
			}
		}
		else if(isdefined(self.blood_enabled) && self.blood_enabled)
		{
			self disable_blood(localclientnum);
		}
		wait(0.016);
	}
}

/*
	Name: setcontrollerlightbarcolorpulsing
	Namespace: blood
	Checksum: 0xC2EA4D1F
	Offset: 0xD88
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function setcontrollerlightbarcolorpulsing(localclientnum, color, pulserate)
{
	curcolor = color * 0.2;
	scale = (gettime() % pulserate) / (pulserate * 0.5);
	if(scale > 1)
	{
		scale = (scale - 2) * -1;
	}
	curcolor = curcolor + ((color * 0.8) * scale);
	setcontrollerlightbarcolor(localclientnum, curcolor);
}

