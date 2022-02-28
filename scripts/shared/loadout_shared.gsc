// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace loadout;

/*
	Name: is_warlord_perk
	Namespace: loadout
	Checksum: 0xA8DCE69B
	Offset: 0x78
	Size: 0xE
	Parameters: 1
	Flags: Linked
*/
function is_warlord_perk(itemindex)
{
	return false;
}

/*
	Name: is_item_excluded
	Namespace: loadout
	Checksum: 0x2C4D7A5F
	Offset: 0x90
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function is_item_excluded(itemindex)
{
	if(!level.onlinegame)
	{
		return false;
	}
	numexclusions = level.itemexclusions.size;
	for(exclusionindex = 0; exclusionindex < numexclusions; exclusionindex++)
	{
		if(itemindex == level.itemexclusions[exclusionindex])
		{
			return true;
		}
	}
	return false;
}

/*
	Name: getloadoutitemfromddlstats
	Namespace: loadout
	Checksum: 0xCF017F4F
	Offset: 0x110
	Size: 0x78
	Parameters: 2
	Flags: Linked
*/
function getloadoutitemfromddlstats(customclassnum, loadoutslot)
{
	itemindex = self getloadoutitem(customclassnum, loadoutslot);
	if(is_item_excluded(itemindex) && !is_warlord_perk(itemindex))
	{
		return 0;
	}
	return itemindex;
}

/*
	Name: initweaponattachments
	Namespace: loadout
	Checksum: 0x46E5E5EF
	Offset: 0x190
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function initweaponattachments(weapon)
{
	self.currentweaponstarttime = gettime();
	self.currentweapon = weapon;
}

