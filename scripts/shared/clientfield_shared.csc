// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace clientfield;

/*
	Name: register
	Namespace: clientfield
	Checksum: 0x5CF03B24
	Offset: 0x78
	Size: 0x74
	Parameters: 8
	Flags: Linked
*/
function register(str_pool_name, str_name, n_version, n_bits, str_type, func_callback, b_host, b_callback_for_zero_when_new)
{
	registerclientfield(str_pool_name, str_name, n_version, n_bits, str_type, func_callback, b_host, b_callback_for_zero_when_new);
}

/*
	Name: get
	Namespace: clientfield
	Checksum: 0x4E79446D
	Offset: 0xF8
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function get(field_name)
{
	if(self == level)
	{
		return codegetworldclientfield(field_name);
	}
	return codegetclientfield(self, field_name);
}

/*
	Name: get_to_player
	Namespace: clientfield
	Checksum: 0xEDA893FF
	Offset: 0x150
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function get_to_player(field_name)
{
	return codegetplayerstateclientfield(self, field_name);
}

/*
	Name: get_player_uimodel
	Namespace: clientfield
	Checksum: 0x62B4F328
	Offset: 0x180
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function get_player_uimodel(field_name)
{
	return codegetuimodelclientfield(self, field_name);
}

